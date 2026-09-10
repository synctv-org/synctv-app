import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/media/local_image_upload.dart';

void main() {
  test('cropped PNG bytes override the original WebP or GIF extension', () {
    final bytes = Uint8List.fromList([137, 80, 78, 71, 13, 10, 26, 10]);
    for (final name in ['cover.webp', 'cover.gif', 'cover']) {
      final upload = LocalImageUpload.fromEncodedBytes(
        bytes: bytes,
        fileName: name,
        width: 400,
        height: 225,
      );
      expect(upload.fileName, 'cover.png');
      expect(upload.mimeType, 'image/png');
      expect(upload.bytes, same(bytes));
      expect(upload.width, 400);
      expect(upload.height, 225);
    }
  });

  test('JPEG upload retains its encoded format after cropping', () {
    final upload = LocalImageUpload.fromEncodedBytes(
      bytes: Uint8List.fromList([255, 216, 255, 224]),
      fileName: 'frame.png',
    );
    expect(upload.fileName, 'frame.jpg');
    expect(upload.mimeType, 'image/jpeg');
  });
}
