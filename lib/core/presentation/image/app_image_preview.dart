import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';

/// A chat attachment thumbnail that opens the complete image.
class AppImagePreview extends StatelessWidget {
  const AppImagePreview({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.errorChild,
  });

  final String url;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Widget? errorChild;

  @override
  Widget build(BuildContext context) => AppInkSurface(
    semanticLabel: context.l10n.viewImage,
    borderRadius: borderRadius,
    onTap: () => showAppDialog<void>(
      context: context,
      builder: (_) => AppImageViewer(image: NetworkImage(url)),
    ),
    child: AppImageThumbnail(
      url: url,
      width: width,
      height: height,
      borderRadius: borderRadius,
      errorChild: errorChild,
    ),
  );
}

class AppImageViewer extends StatefulWidget {
  const AppImageViewer({super.key, required this.image});

  final ImageProvider image;

  @override
  State<AppImageViewer> createState() => _AppImageViewerState();
}

class _AppImageViewerState extends State<AppImageViewer> {
  final _transform = TransformationController();
  Size _viewport = Size.zero;

  @override
  void dispose() {
    _transform.dispose();
    super.dispose();
  }

  void _zoom(double factor) {
    final current = _transform.value;
    final oldScale = current.getMaxScaleOnAxis();
    final scale = (oldScale * factor).clamp(1.0, 6.0);
    final ratio = scale / oldScale;
    final center = _viewport.center(Offset.zero);
    _transform.value = Matrix4.diagonal3Values(scale, scale, 1)
      ..setTranslationRaw(
        center.dx + (current.storage[12] - center.dx) * ratio,
        center.dy + (current.storage[13] - center.dy) * ratio,
        0,
      );
  }

  @override
  Widget build(BuildContext context) => Dialog.fullscreen(
    child: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      context.l10n.image,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                AppIconButton(
                  tooltip: context.l10n.zoomOut,
                  icon: Icons.zoom_out_rounded,
                  onPressed: () => _zoom(1 / 1.5),
                ),
                AppIconButton(
                  tooltip: context.l10n.zoomIn,
                  icon: Icons.zoom_in_rounded,
                  onPressed: () => _zoom(1.5),
                ),
                AppIconButton(
                  tooltip: context.l10n.reset,
                  icon: Icons.fit_screen_rounded,
                  onPressed: () => _transform.value = Matrix4.identity(),
                ),
                AppIconButton(
                  tooltip: context.l10n.close,
                  icon: Icons.close_rounded,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                _viewport = constraints.biggest;
                return InteractiveViewer(
                  transformationController: _transform,
                  minScale: 1,
                  maxScale: 6,
                  trackpadScrollCausesScale: true,
                  child: Image(
                    image: widget.image,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    fit: BoxFit.contain,
                    semanticLabel: context.l10n.image,
                    loadingBuilder: (context, child, progress) =>
                        progress == null
                        ? child
                        : const Center(child: AppLoadingIndicator()),
                    errorBuilder: (context, error, stackTrace) =>
                        Center(child: Text(context.l10n.imageLoadFailed)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
