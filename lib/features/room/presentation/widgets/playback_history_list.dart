import 'package:fixnum/fixnum.dart';
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
    this.deleteTooltip = '',
    this.onDelete,
    this.sourceDetailsBuilder,
    this.playingEntryId = '',
    this.deletingEntryIds = const <String>{},
    this.canPlay = true,
    this.canDelete = false,
  });

  final List<client.PlaybackHistoryEntry> entries;
  final String historyCursorId;
  final String unknownSourceLabel;
  final String playTooltip;
  final String deleteTooltip;
  final String playingEntryId;
  final Set<String> deletingEntryIds;
  final bool canPlay;
  final bool canDelete;
  final ValueChanged<String> onPlay;
  final void Function(String entryId, bool isCurrent)? onDelete;
  final String Function(client.PlaybackHistoryEntry entry)?
  sourceDetailsBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked =
            constraints.maxWidth < 480 ||
            MediaQuery.textScalerOf(context).scale(14) > 21;
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
            final sourceDetails =
                sourceDetailsBuilder?.call(entry).trim() ?? '';
            // Validate before converting or multiplying: Int64 values can overflow.
            final validTime =
                entry.createdAt > Int64.ZERO &&
                entry.createdAt <= Int64(8640000000000);
            final createdAt = validTime
                ? DateTime.fromMillisecondsSinceEpoch(
                    entry.createdAt.toInt() * 1000,
                  )
                : null;
            final localizations = MaterialLocalizations.of(context);
            final details = [
              if (playlistName.isNotEmpty) playlistName,
              if (sourceDetails.isNotEmpty) sourceDetails,
              if (createdAt != null)
                '${localizations.formatShortDate(createdAt)} ${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(createdAt), alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context))}',
            ].join(' · ');
            return AppTile(
              key: Key('playback_history_${entry.id}'),
              selected: isCurrent,
              stackedSuffix: stacked,
              prefix: stacked
                  ? null
                  : Icon(
                      isCurrent
                          ? Icons.play_circle_fill_rounded
                          : Icons.history,
                    ),
              title: Text(
                source,
                maxLines: stacked ? 3 : 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: details.isEmpty
                  ? null
                  : Text(
                      details,
                      maxLines: stacked ? 8 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
              suffix: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (playingEntryId == entry.id)
                    const SizedBox.square(
                      dimension: 40,
                      child: AppLoadingIndicator(
                        size: AppLoadingSize.sm,
                        centered: true,
                      ),
                    )
                  else
                    AppIconButton(
                      key: Key('play_history_entry_${entry.id}'),
                      icon: Icons.play_arrow_rounded,
                      tooltip: playTooltip,
                      onPressed: canPlay ? () => onPlay(entry.id) : null,
                    ),
                  if (canDelete)
                    if (deletingEntryIds.contains(entry.id))
                      const SizedBox.square(
                        dimension: 40,
                        child: AppLoadingIndicator(
                          size: AppLoadingSize.sm,
                          centered: true,
                        ),
                      )
                    else
                      AppIconButton(
                        key: Key('delete_history_entry_${entry.id}'),
                        icon: Icons.delete_outline_rounded,
                        tooltip: deleteTooltip,
                        onPressed: onDelete == null
                            ? null
                            : () => onDelete!(entry.id, isCurrent),
                      ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
