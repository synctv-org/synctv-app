import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:crop_your_image/crop_your_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:synctv_app/core/media/local_image_upload.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class PickedLocalImage {
  const PickedLocalImage({required this.upload, required this.previewBytes});

  final LocalImageUpload upload;
  final Uint8List previewBytes;
}

Future<PickedLocalImage?> pickLocalImageUpload(
  BuildContext context, {
  double? aspectRatio,
}) async {
  final file = await FilePicker.pickFile(type: FileType.image);
  if (file == null) return null;

  final originalBytes = await file.readAsBytes();
  if (originalBytes.isEmpty) return null;

  if (!context.mounted) return null;
  final edited = await showAppDialog<_PreparedLocalImage>(
    context: context,
    builder: (_) => _LocalImageEditDialog(
      fileName: file.name,
      originalBytes: originalBytes,
      aspectRatio: aspectRatio,
    ),
  );
  if (edited == null) return null;

  final bytes = edited.bytes;

  final dimensions = await _decodeImageDimensions(bytes);
  final upload = LocalImageUpload(
    bytes: bytes,
    fileName: file.name,
    mimeType: edited.mimeType,
    width: dimensions?.width ?? 0,
    height: dimensions?.height ?? 0,
  );
  return PickedLocalImage(upload: upload, previewBytes: bytes);
}

class _PreparedLocalImage {
  const _PreparedLocalImage({required this.bytes, required this.mimeType});

  final Uint8List bytes;
  final String mimeType;
}

class _LocalImageEditDialog extends StatefulWidget {
  const _LocalImageEditDialog({
    required this.fileName,
    required this.originalBytes,
    required this.aspectRatio,
  });

  final String fileName;
  final Uint8List originalBytes;
  final double? aspectRatio;

  @override
  State<_LocalImageEditDialog> createState() => _LocalImageEditDialogState();
}

class _LocalImageEditDialogState extends State<_LocalImageEditDialog> {
  final CropController _controller = CropController();
  bool _squareCrop = false;
  bool _cropping = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveRatio = _squareCrop ? 1.0 : widget.aspectRatio;
    return AppDialog(
      title: Text(context.l10n.editImage),
      icon: const Icon(Icons.photo_size_select_large_outlined),
      body: Material(
        type: MaterialType.transparency,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppPanelSurface(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 320,
                  child: AppPanelSurface(
                    borderRadius: BorderRadius.circular(8),
                    child: Crop(
                      image: widget.originalBytes,
                      controller: _controller,
                      aspectRatio: effectiveRatio,
                      interactive: true,
                      maskColor: Colors.black.withValues(alpha: 0.48),
                      baseColor: theme.colorScheme.surfaceContainerHighest,
                      cornerDotBuilder: (size, edgeAlignment) => DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(width: size, height: size),
                      ),
                      progressIndicator: const Center(
                        child: AppLoadingIndicator(),
                      ),
                      onCropped: (result) {
                        switch (result) {
                          case CropSuccess(:final croppedImage):
                            Navigator.pop(
                              context,
                              _PreparedLocalImage(
                                bytes: croppedImage,
                                mimeType: _mimeTypeForName(widget.fileName),
                              ),
                            );
                          case CropFailure(:final cause):
                            setState(() => _cropping = false);
                            AppNotifications.showError(
                              context,
                              context.l10n.imageCropFailed('$cause'),
                            );
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilterChip(
                    label: Text(context.l10n.cropForPurpose),
                    selected: effectiveRatio != null && !_squareCrop,
                    onSelected: widget.aspectRatio == null
                        ? null
                        : (_) {
                            setState(() => _squareCrop = false);
                            _controller.aspectRatio = widget.aspectRatio;
                          },
                  ),
                  FilterChip(
                    label: Text(context.l10n.squareCrop),
                    selected: _squareCrop,
                    onSelected: (_) {
                      setState(() => _squareCrop = true);
                      _controller.aspectRatio = 1;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (!_cropping) AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        if (!_cropping)
          AppDialogs.createConfirmButton(
            context,
            () => Navigator.pop(
              context,
              _PreparedLocalImage(
                bytes: widget.originalBytes,
                mimeType: _mimeTypeForName(widget.fileName),
              ),
            ),
            text: context.l10n.uploadOriginalImage,
          ),
        const SizedBox(width: 8),
        _cropping
            ? const AppLoadingIndicator()
            : AppDialogs.createConfirmButton(context, () {
                setState(() => _cropping = true);
                _controller.crop();
              }, text: context.l10n.useEditedImage),
      ],
    );
  }
}

String _mimeTypeForName(String name) {
  final lower = name.toLowerCase();
  if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) return 'image/jpeg';
  if (lower.endsWith('.webp')) return 'image/webp';
  if (lower.endsWith('.gif')) return 'image/gif';
  if (lower.endsWith('.bmp')) return 'image/bmp';
  if (lower.endsWith('.avif')) return 'image/avif';
  return 'image/png';
}

Future<({int width, int height})?> _decodeImageDimensions(
  Uint8List bytes,
) async {
  try {
    final descriptor = await ui.ImmutableBuffer.fromUint8List(bytes)
        .then(ui.ImageDescriptor.encoded);
    final width = descriptor.width;
    final height = descriptor.height;
    descriptor.dispose();
    return (width: width, height: height);
  } catch (_) {
    return null;
  }
}
