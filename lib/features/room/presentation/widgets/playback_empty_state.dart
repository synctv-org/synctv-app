import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class PlaybackEmptyState extends StatelessWidget {
  final String? error;
  final bool loading;
  final bool hasPlayback;
  final double iconSize;
  final double textSize;

  const PlaybackEmptyState({
    super.key,
    required this.error,
    required this.loading,
    required this.hasPlayback,
    this.iconSize = 64,
    this.textSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final icon = error != null
        ? Icons.error_outline_rounded
        : hasPlayback
        ? Icons.hourglass_top_rounded
        : Icons.ondemand_video_rounded;
    final message =
        error ??
        (loading || hasPlayback
            ? context.l10n.loadingVideo
            : context.l10n.waitingForPlayback);

    return Center(
      child: AppPanelSurface(
        color: Colors.transparent,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIconBadge(
              icon: icon,
              color: Colors.white70,
              size: iconSize + 24,
              iconSize: iconSize,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: textSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
