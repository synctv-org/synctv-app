import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:synctv_app/services/synctv_file_upload_service.dart';

class PickedLocalImage {
  const PickedLocalImage({
    required this.upload,
    required this.previewBytes,
    this.previewFile,
  });

  final LocalImageUpload upload;
  final Uint8List previewBytes;
  final File? previewFile;
}

Future<PickedLocalImage?> pickLocalImageUpload() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    allowMultiple: false,
    withData: true,
  );
  final file = result?.files.single;
  if (file == null) return null;

  final bytes = file.bytes ??
      (file.path == null ? null : await File(file.path!).readAsBytes());
  if (bytes == null || bytes.isEmpty) return null;

  final dimensions = await _decodeImageDimensions(bytes);
  final upload = LocalImageUpload(
    bytes: bytes,
    fileName: file.name,
    mimeType: _mimeTypeForName(file.name),
    width: dimensions?.width ?? 0,
    height: dimensions?.height ?? 0,
  );
  return PickedLocalImage(
    upload: upload,
    previewBytes: bytes,
    previewFile: !kIsWeb && file.path != null && file.path!.isNotEmpty
        ? File(file.path!)
        : null,
  );
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
