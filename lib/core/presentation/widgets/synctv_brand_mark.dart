import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class SyncTvBrandMark extends StatelessWidget {
  const SyncTvBrandMark({
    super.key,
    required this.semanticLabel,
    this.size = 36,
    this.borderRadius,
  });

  static const assetName = 'assets/icon/logo-notext.svg';
  static const cornerRadiusRatio = 2 / 9;

  final String semanticLabel;
  final double size;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius =
        borderRadius ?? BorderRadius.circular(size * cornerRadiusRatio);

    return AppPanelSurface(
      width: size,
      height: size,
      borderRadius: effectiveBorderRadius,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: SvgPicture.asset(
        assetName,
        width: size,
        height: size,
        fit: BoxFit.cover,
        semanticsLabel: semanticLabel,
      ),
    );
  }
}
