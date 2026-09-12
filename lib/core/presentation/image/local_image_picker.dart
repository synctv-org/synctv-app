import 'dart:ui' as ui;

import 'package:crop_your_image/crop_your_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:synctv_app/core/media/local_image_upload.dart';
import 'package:synctv_app/core/media/crop_image_preparation.dart';
import 'package:synctv_app/core/media/pixel_aligned_image_cropper.dart';
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
  if (!context.mounted) return null;
  final route = ModalRoute.of(context);
  bool isActive() => context.mounted && route?.isCurrent == true;
  if (!isActive()) return null;
  try {
    final file = await FilePicker.pickFile(type: FileType.image);
    if (file == null || !isActive()) return null;

    final originalBytes = await file.readAsBytes();
    if (originalBytes.isEmpty || !isActive()) return null;

    if (!context.mounted) return null;
    final edited = await showAppDialog<_PreparedLocalImage>(
      context: context,
      builder: (_) => _LocalImageEditDialog(
        fileName: file.name,
        originalBytes: originalBytes,
        aspectRatio: aspectRatio,
      ),
    );
    if (edited == null || !isActive()) return null;

    final bytes = edited.bytes;
    final dimensions = await _decodeImageDimensions(bytes);
    if (!isActive()) return null;
    final upload = LocalImageUpload.fromEncodedBytes(
      bytes: bytes,
      fileName: edited.fileName,
      width: dimensions?.width ?? 0,
      height: dimensions?.height ?? 0,
    );
    return PickedLocalImage(upload: upload, previewBytes: bytes);
  } catch (_) {
    if (!isActive()) return null;
    rethrow;
  }
}

class _PreparedLocalImage {
  const _PreparedLocalImage({required this.bytes, required this.fileName});

  final Uint8List bytes;
  final String fileName;
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
  late final Future<ImageParser> _preparedImage = prepareCropImage(
    widget.originalBytes,
  );
  bool _squareCrop = false;
  bool _cropping = false;
  bool _closing = false;
  bool _ready = false;
  Rect? _imageRect;

  void _selectCropMode({required bool square}) {
    if (!_canEdit) return;
    setState(() => _squareCrop = square);
    final ratio = square ? 1.0 : widget.aspectRatio;
    _controller.aspectRatio = ratio;
    final image = _imageRect;
    if (image == null || ratio == null) return;
    // Changing ratio in the crop library can place handles outside the
    // viewport after zooming. Keep the new selection inside the visible image.
    final visible = image.intersect(const Rect.fromLTWH(0, 0, 500, 320));
    final size = applyBoxFit(
      BoxFit.contain,
      Size(ratio, 1),
      visible.size * 0.8,
    ).destination;
    _controller.cropRect = Rect.fromCenter(
      center: visible.center,
      width: size.width,
      height: size.height,
    );
  }

  bool get _active =>
      mounted && !_closing && ModalRoute.of(context)?.isCurrent == true;

  bool get _canEdit => _active && _ready && !_cropping;

  void _crop() {
    if (!_canEdit) return;
    setState(() => _cropping = true);
    _controller.crop();
  }

  void _onCropStatus(CropStatus status) {
    if (!mounted || _closing) return;
    final ready = status == CropStatus.ready;
    if (_ready == ready) return;
    setState(() => _ready = ready);
  }

  void _finish(Uint8List bytes) {
    if (!_active) return;
    _closing = true;
    Navigator.pop(
      context,
      _PreparedLocalImage(bytes: bytes, fileName: widget.fileName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveRatio = _squareCrop ? 1.0 : widget.aspectRatio;
    return AppDialog(
      title: Text(context.l10n.editImage),
      icon: const Icon(Icons.photo_size_select_large_outlined),
      body: Material(
        type: MaterialType.transparency,
        child: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppPanelSurface(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  // Reserve room for the header, wrapped choices and actions.
                  height: (MediaQuery.sizeOf(context).height - 440).clamp(
                    120.0,
                    320.0,
                  ),
                  child: AppPanelSurface(
                    borderRadius: BorderRadius.circular(8),
                    child: IgnorePointer(
                      ignoring: !_ready || _cropping,
                      child: FutureBuilder<ImageParser>(
                        future: _preparedImage,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  context.l10n.imageCannotBeEdited,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          final parser = snapshot.data;
                          if (parser == null) {
                            return const Center(child: AppLoadingIndicator());
                          }
                          // Keep the editing coordinate system stable while the
                          // dialog scales it to fit. The crop library resets pan
                          // and zoom whenever its MediaQuery viewport changes.
                          return FittedBox(
                            fit: BoxFit.contain,
                            child: SizedBox(
                              width: 500,
                              height: 320,
                              child: MediaQuery(
                                data: const MediaQueryData(
                                  size: Size(500, 320),
                                ),
                                child: Crop(
                                  image: widget.originalBytes,
                                  imageParser: parser,
                                  imageCropper: pixelAlignedImageCropper,
                                  controller: _controller,
                                  onImageMoved: (rect) => _imageRect = rect,
                                  onStatusChanged: _onCropStatus,
                                  aspectRatio: effectiveRatio,
                                  interactive: true,
                                  maskColor: Colors.black.withValues(
                                    alpha: 0.48,
                                  ),
                                  baseColor:
                                      theme.colorScheme.surfaceContainerHighest,
                                  cornerDotBuilder: (size, edgeAlignment) =>
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: SizedBox(
                                          width: size,
                                          height: size,
                                        ),
                                      ),
                                  progressIndicator: const Center(
                                    child: AppLoadingIndicator(),
                                  ),
                                  onCropped: (result) {
                                    if (!mounted) return;
                                    if (!_active) {
                                      setState(() => _cropping = false);
                                      return;
                                    }
                                    switch (result) {
                                      case CropSuccess(:final croppedImage):
                                        _finish(croppedImage);
                                      case CropFailure(:final cause):
                                        setState(() => _cropping = false);
                                        AppNotifications.showError(
                                          context,
                                          context.l10n.imageCropFailed(
                                            '$cause',
                                          ),
                                        );
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
                    onSelected:
                        !_ready || _cropping || widget.aspectRatio == null
                        ? null
                        : (_) => _selectCropMode(square: false),
                  ),
                  FilterChip(
                    label: Text(context.l10n.squareCrop),
                    selected: _squareCrop,
                    onSelected: !_ready || _cropping
                        ? null
                        : (_) => _selectCropMode(square: true),
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
            () => _finish(widget.originalBytes),
            text: context.l10n.uploadOriginalImage,
          ),
        const SizedBox(width: 8),
        _cropping
            ? const AppLoadingIndicator()
            : AppActionButton(
                wrapLabel: true,
                label: context.l10n.useEditedImage,
                onPressed: _ready ? _crop : null,
              ),
      ],
    );
  }
}

Future<({int width, int height})?> _decodeImageDimensions(
  Uint8List bytes,
) async {
  ui.ImmutableBuffer? buffer;
  ui.ImageDescriptor? descriptor;
  ui.Codec? codec;
  ui.Image? image;
  try {
    // Encoded ImageDescriptor dimensions are unsupported by Flutter Web.
    if (kIsWeb) {
      codec = await ui.instantiateImageCodec(bytes);
      image = (await codec.getNextFrame()).image;
      return (width: image.width, height: image.height);
    }
    buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    descriptor = await ui.ImageDescriptor.encoded(buffer);
    return (width: descriptor.width, height: descriptor.height);
  } catch (_) {
    return null;
  } finally {
    image?.dispose();
    codec?.dispose();
    descriptor?.dispose();
    buffer?.dispose();
  }
}
