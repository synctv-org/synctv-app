import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:mime/mime.dart';

class LocalImageUpload {
  const LocalImageUpload({
    required this.bytes,
    required this.fileName,
    required this.mimeType,
    this.width = 0,
    this.height = 0,
  });

  factory LocalImageUpload.fromEncodedBytes({
    required Uint8List bytes,
    required String fileName,
    int width = 0,
    int height = 0,
  }) {
    final mimeType =
        lookupMimeType(fileName, headerBytes: bytes) ?? 'image/png';
    final extension = extensionFromMime(mimeType);
    final dot = fileName.lastIndexOf('.');
    final baseName = dot > 0 ? fileName.substring(0, dot) : fileName;
    return LocalImageUpload(
      bytes: bytes,
      fileName: '$baseName.$extension',
      mimeType: mimeType,
      width: width,
      height: height,
    );
  }

  final Uint8List bytes;
  final String fileName;
  final String mimeType;
  final int width;
  final int height;

  int get sizeBytes => bytes.length;
  String get checksumSha256 => sha256.convert(bytes).toString();
}
