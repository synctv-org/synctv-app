import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/presentation/room_screen.dart';
import 'package:synctv_app/l10n/l10n.dart';

import '../../../test_app.dart';

void main() {
  testWidgets('collaboration tabs accept taps across the full tab area', (
    tester,
  ) async {
    final selected = <int>[];

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 360,
            height: 56,
            child: RoomCollaborationTabBar(
              labels: const ['Chat', 'Playlist', 'Members'],
              icons: const [
                Icons.chat_bubble_rounded,
                Icons.playlist_play_rounded,
                Icons.group_rounded,
              ],
              selectedIndex: 0,
              enabled: const [true, true, true],
              onSelected: selected.add,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(byAppTooltip('Chat'), findsOneWidget);
    expect(byAppTooltip('Playlist'), findsOneWidget);
    expect(byAppTooltip('Members'), findsOneWidget);

    await tester.tapAt(const Offset(8, 28));
    await tester.tapAt(const Offset(128, 28));
    await tester.tapAt(const Offset(248, 28));
    await tester.pump();

    expect(selected, [0, 1, 2]);
  });

  testWidgets('disabled collaboration tabs are hidden', (tester) async {
    var selected = 0;

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        home: Scaffold(
          body: SizedBox(
            width: 360,
            height: 56,
            child: RoomCollaborationTabBar(
              labels: const ['Chat', 'Playlist', 'Members'],
              icons: const [
                Icons.chat_bubble_rounded,
                Icons.playlist_play_rounded,
                Icons.group_rounded,
              ],
              selectedIndex: 0,
              enabled: const [true, false, true],
              onSelected: (_) => selected++,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(byAppTooltip('Chat'), findsOneWidget);
    expect(byAppTooltip('Playlist'), findsNothing);
    expect(byAppTooltip('Members'), findsOneWidget);
    expect(selected, 0);
  });
}
