import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/features/room/presentation/widgets/playback_history_list.dart';

import '../../../../test_app.dart';

void main() {
  testWidgets('history list highlights cursor entry and plays another', (
    tester,
  ) async {
    String playedEntryId = '';
    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        home: Scaffold(
          body: PlaybackHistoryList(
            entries: [
              client.PlaybackHistoryEntry(
                id: 'ph_current',
                mediaId: 'med_current',
                mediaName: 'Current film',
                createdAt: Int64(1),
              ),
              client.PlaybackHistoryEntry(
                id: 'ph_previous',
                mediaId: 'med_previous',
                mediaName: 'Previous film',
                createdAt: Int64(2),
              ),
            ],
            historyCursorId: 'ph_current',
            unknownSourceLabel: 'Unknown',
            playTooltip: 'Play this entry',
            onPlay: (id) => playedEntryId = id,
          ),
        ),
      ),
    );

    expect(find.text('Current film'), findsOneWidget);
    expect(find.text('Previous film'), findsOneWidget);
    expect(find.text('med_current'), findsNothing);
    expect(find.byIcon(Icons.play_circle_fill_rounded), findsOneWidget);
    await tester.tap(find.byKey(const Key('play_history_entry_ph_previous')));
    await tester.pump(const Duration(milliseconds: 200));
    expect(playedEntryId, 'ph_previous');
  });

  testWidgets(
    'history play stays disabled without playback navigation permission',
    (tester) async {
      var playCount = 0;
      await tester.pumpWidget(
        MaterialApp(
          builder: buildThemedTestApp,
          home: Scaffold(
            body: PlaybackHistoryList(
              entries: [
                client.PlaybackHistoryEntry(
                  id: 'ph_previous',
                  mediaId: 'med_previous',
                  mediaName: 'Previous film',
                  createdAt: Int64(2),
                ),
              ],
              historyCursorId: '',
              unknownSourceLabel: 'Unknown',
              playTooltip: 'Play this entry',
              canPlay: false,
              onPlay: (_) => playCount++,
            ),
          ),
        ),
      );

      final playButton = find.byKey(
        const Key('play_history_entry_ph_previous'),
      );
      expect(playButton, findsOneWidget);
      await tester.tap(playButton);
      await tester.pump(const Duration(milliseconds: 200));
      expect(playCount, 0);
    },
  );

  testWidgets('history delete reports whether the entry is current', (
    tester,
  ) async {
    final deleted = <(String, bool)>[];
    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        home: Scaffold(
          body: PlaybackHistoryList(
            entries: [
              client.PlaybackHistoryEntry(
                id: 'ph_current',
                mediaName: 'Current film',
                createdAt: Int64(1),
              ),
            ],
            historyCursorId: 'ph_current',
            unknownSourceLabel: 'Unknown',
            playTooltip: 'Play',
            deleteTooltip: 'Delete',
            canDelete: true,
            onPlay: (_) {},
            onDelete: (id, isCurrent) => deleted.add((id, isCurrent)),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('delete_history_entry_ph_current')));
    await tester.pump();

    expect(deleted, [('ph_current', true)]);
  });
}
