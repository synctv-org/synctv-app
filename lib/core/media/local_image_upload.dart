import 'dart:typed_data';

import 'package:crypto/crypto.dart';

class LocalImageUpload {
  const LocalImageUpload({
    required this.bytes,
    required this.fileName,
    required this.mimeType,
    this.width = 0,
    this.height = 0,
  });

  final Uint8List bytes;
  final String fileName;
  final String mimeType;
  final int width;
  final int height;

  int get sizeBytes => bytes.length;
  String get checksumSha256 => sha256.convert(bytes).toString();
}
