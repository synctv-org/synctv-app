import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/widgets/playback_history_list.dart';

void main() {
  testWidgets('history list highlights cursor entry and plays another', (
    tester,
  ) async {
    String playedEntryId = '';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlaybackHistoryList(
            entries: [
              client.PlaybackHistoryEntry(
                id: 'ph_current',
                mediaId: 'med_current',
                createdAt: Int64(1),
              ),
              client.PlaybackHistoryEntry(
                id: 'ph_previous',
                mediaId: 'med_previous',
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
          home: Scaffold(
            body: PlaybackHistoryList(
              entries: [
                client.PlaybackHistoryEntry(
                  id: 'ph_previous',
                  mediaId: 'med_previous',
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
}
