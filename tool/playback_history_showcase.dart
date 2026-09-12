import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:synctv_app/features/room/presentation/widgets/playback_history_list.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/theme/app_theme.dart';

void main() =>
    runApp(MaterialApp(theme: AppTheme.light, home: const _History()));

class _History extends StatefulWidget {
  const _History();
  @override
  State<_History> createState() => _HistoryState();
}

class _HistoryState extends State<_History> {
  bool large = false;
  String current = 'current';
  final entries = [
    client.PlaybackHistoryEntry(
      id: 'current',
      mediaName: 'A memorable evening',
      playlistName: 'Shared playlist',
      createdAt: Int64(1700000000),
    ),
    client.PlaybackHistoryEntry(
      id: 'previous',
      mediaName: 'Another film from our collection',
      playlistName: 'Weekend cinema',
      createdAt: Int64(1700000600),
    ),
    client.PlaybackHistoryEntry(
      id: 'invalid',
      mediaName: 'Film with invalid timestamp',
      createdAt: Int64.MAX_VALUE,
    ),
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Playback history'),
      actions: [
        IconButton(
          tooltip: 'Large text',
          icon: const Icon(Icons.text_increase),
          onPressed: () => setState(() => large = !large),
        ),
      ],
    ),
    body: MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(large ? 3 : 1)),
      child: PlaybackHistoryList(
        entries: entries,
        historyCursorId: current,
        unknownSourceLabel: 'Unknown',
        playTooltip: 'Play',
        deleteTooltip: 'Delete',
        canDelete: true,
        onPlay: (id) => setState(() => current = id),
        onDelete: (id, _) =>
            setState(() => entries.removeWhere((entry) => entry.id == id)),
      ),
    ),
  );
}
