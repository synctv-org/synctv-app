import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/presentation/room_shell_view.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

import '../../test_app.dart';

Widget _app({
  required RoomShellState state,
  required RoomShellCallbacks callbacks,
}) => MaterialApp(
  builder: buildThemedTestApp,
  locale: const Locale('en'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: RoomShellView(
    state: state,
    callbacks: callbacks,
    latencyBadge: (compact) => AppBadge(
      label: Text(compact ? '24 ms' : 'Server 24 ms'),
      icon: Icons.network_check_rounded,
    ),
    primary: const ColoredBox(key: Key('video_surface'), color: Colors.black),
    secondary: const ColoredBox(
      key: Key('collaboration_panel'),
      color: Colors.white,
    ),
  ),
);

void main() {
  Future<void> setViewport(WidgetTester tester, Size size) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = size;
    addTearDown(tester.view.reset);
  }

  testWidgets('room shell keeps video and collaboration usable across widths', (
    tester,
  ) async {
    for (final size in const [
      Size(390, 844),
      Size(834, 1194),
      Size(1440, 900),
    ]) {
      await setViewport(tester, size);
      await tester.pumpWidget(
        _app(
          state: const RoomShellState(
            roomName: 'Friday Cinema Club',
            hasCurrentPlayback: true,
            canControlPlayback: true,
            hasCurrentUser: true,
            canManageRoom: true,
          ),
          callbacks: RoomShellCallbacks(
            back: () {},
            stopPlayback: () {},
            openRoomSettings: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('video_surface')), findsOneWidget);
      expect(find.byKey(const Key('collaboration_panel')), findsOneWidget);
      expect(tester.takeException(), isNull, reason: 'viewport: $size');
    }
  });

  testWidgets(
    'room shell exposes only commands allowed by presentation state',
    (tester) async {
      await setViewport(tester, const Size(390, 844));
      var backs = 0;
      var stops = 0;
      var settings = 0;
      await tester.pumpWidget(
        _app(
          state: const RoomShellState(
            roomName: 'Friday Cinema Club',
            hasCurrentPlayback: true,
            canControlPlayback: true,
            hasCurrentUser: true,
            canManageRoom: false,
          ),
          callbacks: RoomShellCallbacks(
            back: () => backs += 1,
            stopPlayback: () => stops += 1,
            openRoomSettings: () => settings += 1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(byAppTooltip('Back'));
      await tester.tap(byAppTooltip('Stop playback'));
      await tester.tap(byAppTooltip('Room settings'));
      await tester.pumpAndSettle();
      expect((backs, stops, settings), (1, 1, 1));

      await tester.pumpWidget(
        _app(
          state: const RoomShellState(
            roomName: 'Friday Cinema Club',
            hasCurrentPlayback: false,
            canControlPlayback: false,
            hasCurrentUser: false,
            canManageRoom: false,
          ),
          callbacks: RoomShellCallbacks(
            back: () {},
            stopPlayback: () {},
            openRoomSettings: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(byAppTooltip('Stop playback'), findsNothing);
      expect(byAppTooltip('Room settings'), findsNothing);
    },
  );

  testWidgets('room shell reacts to live permission state changes', (
    tester,
  ) async {
    await setViewport(tester, const Size(1024, 768));
    final state = ValueNotifier(
      const RoomShellState(
        roomName: 'Permission room',
        hasCurrentPlayback: true,
        canControlPlayback: false,
        hasCurrentUser: true,
        canManageRoom: false,
      ),
    );
    addTearDown(state.dispose);

    await tester.pumpWidget(
      ValueListenableBuilder<RoomShellState>(
        valueListenable: state,
        builder: (context, value, _) => _app(
          state: value,
          callbacks: RoomShellCallbacks(
            back: () {},
            stopPlayback: () {},
            openRoomSettings: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(byAppTooltip('Stop playback'), findsNothing);
    expect(byAppTooltip('Room settings'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);

    state.value = const RoomShellState(
      roomName: 'Permission room',
      hasCurrentPlayback: true,
      canControlPlayback: true,
      hasCurrentUser: true,
      canManageRoom: true,
    );
    await tester.pump();

    expect(byAppTooltip('Stop playback'), findsOneWidget);
    expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsNothing);

    state.value = const RoomShellState(
      roomName: 'Permission room',
      hasCurrentPlayback: true,
      canControlPlayback: false,
      hasCurrentUser: false,
      canManageRoom: false,
    );
    await tester.pump();

    expect(byAppTooltip('Stop playback'), findsNothing);
    expect(byAppTooltip('Room settings'), findsNothing);
  });
}
