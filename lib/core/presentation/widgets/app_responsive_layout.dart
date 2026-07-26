import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class AppResponsiveWrap extends StatelessWidget {
  final List<Widget> children;
  final double minItemWidth;
  final int maxColumns;
  final double? spacing;
  final double? runSpacing;
  final WrapAlignment alignment;
  final WrapCrossAlignment crossAxisAlignment;

  const AppResponsiveWrap({
    super.key,
    required this.children,
    this.minItemWidth = 280,
    this.maxColumns = 3,
    this.spacing,
    this.runSpacing,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final effectiveSpacing = spacing ?? 10;
        final effectiveRunSpacing = runSpacing ?? 10;
        final possibleColumns =
            ((availableWidth + effectiveSpacing) /
                    (minItemWidth + effectiveSpacing))
                .floor()
                .clamp(1, maxColumns);
        final itemWidth =
            (availableWidth - effectiveSpacing * (possibleColumns - 1)) /
            possibleColumns;

        return Wrap(
          spacing: effectiveSpacing,
          runSpacing: effectiveRunSpacing,
          alignment: alignment,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            for (final child in children)
              SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }
}

class AppAdaptiveSplitView extends StatelessWidget {
  final Widget primary;
  final Widget secondary;
  final double minPrimaryWidth;
  final double minSecondaryWidth;
  final double maxSecondaryWidth;
  final double spacing;
  final double collapsedPrimaryAspectRatio;
  final double collapsedPrimaryMaxHeightFraction;
  final double? collapsedSecondaryMinHeight;
  final CrossAxisAlignment crossAxisAlignment;

  const AppAdaptiveSplitView({
    super.key,
    required this.primary,
    required this.secondary,
    this.minPrimaryWidth = 520,
    this.minSecondaryWidth = 320,
    this.maxSecondaryWidth = 420,
    this.spacing = 12,
    this.collapsedPrimaryAspectRatio = 16 / 9,
    this.collapsedPrimaryMaxHeightFraction = 0.56,
    this.collapsedSecondaryMinHeight,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final canSplit =
            availableWidth >= minPrimaryWidth + minSecondaryWidth + spacing;
        if (!canSplit) {
          final aspectHeight = availableWidth / collapsedPrimaryAspectRatio;
          final primaryHeight = constraints.hasBoundedHeight
              ? aspectHeight
                    .clamp(
                      0,
                      constraints.maxHeight * collapsedPrimaryMaxHeightFraction,
                    )
                    .toDouble()
              : aspectHeight;
          final remainingHeight =
              constraints.maxHeight - primaryHeight - spacing;
          final minSecondaryHeight =
              collapsedSecondaryMinHeight ?? minSecondaryWidth;
          final secondaryHeight = remainingHeight >= minSecondaryHeight
              ? remainingHeight
              : minSecondaryHeight;
          return AppListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: primaryHeight, child: primary),
              SizedBox(height: spacing),
              SizedBox(height: secondaryHeight, child: secondary),
            ],
          );
        }

        final secondaryWidth = (availableWidth * 0.32)
            .clamp(minSecondaryWidth, maxSecondaryWidth)
            .toDouble();
        return Row(
          crossAxisAlignment: crossAxisAlignment,
          children: [
            Expanded(child: primary),
            SizedBox(width: spacing),
            SizedBox(width: secondaryWidth, child: secondary),
          ],
        );
      },
    );
  }
}
