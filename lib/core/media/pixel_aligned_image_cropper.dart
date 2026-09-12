import 'dart:math' as math;
import 'dart:ui';

import 'package:crop_your_image/crop_your_image.dart';

final pixelAlignedImageCropper = _PixelAlignedImageCropper(defaultImageCropper);

class _PixelAlignedImageCropper<T> extends ImageCropper<T> {
  const _PixelAlignedImageCropper(this.delegate);

  final ImageCropper<T> delegate;

  @override
  RectValidator<T> get rectValidator => delegate.rectValidator;

  @override
  RectCropper<T> get rectCropper =>
      (original, {required topLeft, required size, required outputFormat}) {
        // Round dimensions independently of position so square crops stay square
        // and floating-point drift cannot truncate a one-pixel crop to zero.
        return delegate.rectCropper(
          original,
          topLeft: topLeft,
          size: Size(
            math.max(1, size.width.round()).toDouble(),
            math.max(1, size.height.round()).toDouble(),
          ),
          outputFormat: outputFormat,
        );
      };

  @override
  CircleCropper<T> get circleCropper => delegate.circleCropper;
}
