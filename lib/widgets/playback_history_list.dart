import 'package:flutter/material.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/widgets/app_form_controls.dart';

class PlaybackHistoryList extends StatelessWidget {
  const PlaybackHistoryList({
    super.key,
    required this.entries,
    required this.historyCursorId,
    required this.unknownSourceLabel,
    required this.playTooltip,
    required this.onPlay,
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

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final entry = entries[index];
        final isCurrent = entry.id == historyCursorId;
        final source = entry.mediaId.isNotEmpty
            ? entry.mediaId
            : entry.playlistId.isNotEmpty
            ? entry.playlistId
            : unknownSourceLabel;
        return ListTile(
          key: Key('playback_history_${entry.id}'),
          leading: Icon(
            isCurrent ? Icons.play_circle_fill_rounded : Icons.history,
          ),
          title: Text(source, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            DateTime.fromMillisecondsSinceEpoch(
              entry.createdAt.toInt() * 1000,
            ).toLocal().toString(),
          ),
          trailing: playingEntryId == entry.id
              ? const SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
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
