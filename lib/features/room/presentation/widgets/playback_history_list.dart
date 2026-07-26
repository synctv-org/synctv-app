import 'package:flutter/material.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class PlaybackHistoryList extends StatelessWidget {
  const PlaybackHistoryList({
    super.key,
    required this.entries,
    required this.historyCursorId,
    required this.unknownSourceLabel,
    required this.playTooltip,
    required this.onPlay,
    this.sourceDetailsBuilder,
    this.playingEntryId = '',
    this.canPlay = true,
  });

  final List<client.PlaybackHistoryEntry> entries;
  final String historyCursorId;
  final String unknownSourceLabel;
  final String playTooltip;
  final String playingEntryId;
  final bool canPlay;
  final ValueChanged<String> onPlay;
  final String Function(client.PlaybackHistoryEntry entry)?
  sourceDetailsBuilder;

  @override
  Widget build(BuildContext context) {
    return AppListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      separatorBuilder: (_, _) => const AppDivider(height: 1),
      itemBuilder: (context, index) {
        final entry = entries[index];
        final isCurrent = entry.id == historyCursorId;
        final mediaName = entry.mediaName.trim();
        final playlistName = entry.playlistName.trim();
        final source = mediaName.isEmpty ? unknownSourceLabel : mediaName;
        final sourceDetails = sourceDetailsBuilder?.call(entry).trim() ?? '';
        final createdAt = DateTime.fromMillisecondsSinceEpoch(
          entry.createdAt.toInt() * 1000,
        ).toLocal();
        return ListTile(
          key: Key('playback_history_${entry.id}'),
          leading: Icon(
            isCurrent ? Icons.play_circle_fill_rounded : Icons.history,
          ),
          title: Text(source, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            [
              if (playlistName.isNotEmpty) playlistName,
              if (sourceDetails.isNotEmpty) sourceDetails,
              createdAt.toString(),
            ].join(' · '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: playingEntryId == entry.id
              ? const SizedBox.square(
                  dimension: 20,
                  child: AppLoadingIndicator(
                    size: AppLoadingSize.sm,
                    centered: false,
                  ),
                )
              : AppIconButton(
                  key: Key('play_history_entry_${entry.id}'),
                  icon: Icons.play_arrow_rounded,
                  tooltip: playTooltip,
                  onPressed: isCurrent || !canPlay
                      ? null
                      : () => onPlay(entry.id),
                ),
        );
      },
    );
  }
}
