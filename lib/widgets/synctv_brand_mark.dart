import 'package:flutter/material.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';

class SyncTvBrandMark extends StatelessWidget {
  const SyncTvBrandMark({
    super.key,
    required this.semanticLabel,
    this.size = 36,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  static const assetName = 'assets/icon/robot_3.png';

  final String semanticLabel;
  final double size;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return AppImageThumbnail.asset(
      assetName: assetName,
      width: size,
      height: size,
      borderRadius: borderRadius,
      semanticLabel: semanticLabel,
    );
  }
}
