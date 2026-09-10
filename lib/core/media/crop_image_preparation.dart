import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/foundation.dart';

Future<ImageParser> prepareCropImage(Uint8List bytes) async {
  final detail = await compute(_parseImage, bytes);
  return _reuseParsedImage(detail);
}

ImageDetail _parseImage(Uint8List bytes) => defaultImageParser(bytes);

// Capture only the parsed image so the crop plugin can send this parser through
// compute on native platforms without retaining widget state or decoding twice.
ImageParser _reuseParsedImage(ImageDetail detail) =>
    (_, {inputFormat}) => detail;
