import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/home/presentation/widgets/cinema_room_card.dart';

import '../../../../test_app.dart';

Widget _app(Widget child, {double height = 318}) {
  return MaterialApp(
    builder: buildThemedTestApp,
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
    ),
    home: Scaffold(
      body: SizedBox(width: 340, height: height, child: child),
    ),
  );
}

CinemaRoomCard _card({
  client_enum.RoomDiscoveryAccess access =
      client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_UNSPECIFIED,
  int onlineMemberCount = 4,
  int onlineGuestCount = 3,
  bool isOwner = false,
  bool joined = false,
  bool canJoin = false,
  bool favoriteLoading = false,
  VoidCallback? onTap,
  VoidCallback? onFavoritePressed,
  String description = '',
}) {
  return CinemaRoomCard(
    roomName: 'Open cinema',
    description: description,
    onlineMemberCount: onlineMemberCount,
    onlineGuestCount: onlineGuestCount,
    discoveryAccess: access,
    isOwner: isOwner,
    joined: joined,
    canJoin: canJoin,
    favoriteLoading: favoriteLoading,
    onTap: onTap,
    onFavoritePressed: onFavoritePressed,
  );
}

void main() {
  testWidgets('total presence is shown with a detailed tooltip', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_card()));

    expect(find.text('Online: 7'), findsOneWidget);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(find.text('Online: 7')));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Online: 4 members · 3 guests'), findsOneWidget);
    await mouse.removePointer();
  });

  testWidgets('zero guests do not change the total presence presentation', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_card(onlineGuestCount: 0)));

    expect(find.text('Online: 4'), findsOneWidget);

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(find.text('Online: 4')));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Online: 4 members · 0 guests'), findsOneWidget);
    await mouse.removePointer();
  });

  testWidgets('guest room has a distinct direct-entry badge', (tester) async {
    await tester.pumpWidget(
      _app(
        _card(
          access: client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_GUEST,
          canJoin: true,
          onTap: () {},
        ),
      ),
    );

    expect(find.text('Enter as guest'), findsOneWidget);
    final badge = tester.widget<AppBadge>(
      find.widgetWithText(AppBadge, 'Enter as guest'),
    );
    final context = tester.element(find.byType(CinemaRoomCard));
    expect(badge.color, Theme.of(context).colorScheme.tertiary);
  });

  testWidgets('unavailable access overrides joined presentation', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        _card(
          access:
              client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_UNAVAILABLE,
          joined: true,
        ),
      ),
    );

    expect(find.text('Unavailable'), findsOneWidget);
    expect(find.text('Joined'), findsNothing);
  });

  testWidgets('owned room is identified as created by the current user', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_card(isOwner: true, joined: true)));

    expect(find.text('Created by me'), findsOneWidget);
    expect(find.text('Joined'), findsNothing);
  });

  testWidgets('favorite action is disabled while its request is running', (
    tester,
  ) async {
    var presses = 0;
    await tester.pumpWidget(
      _app(
        _card(
          joined: true,
          favoriteLoading: true,
          onFavoritePressed: () => presses += 1,
        ),
      ),
    );

    final button = tester.widget<AppIconButton>(find.byType(AppIconButton));
    expect(button.loading, isTrue);
    await tester.tap(find.byType(AppIconButton));
    await tester.pump(const Duration(milliseconds: 250));
    expect(presses, 0);
  });

  testWidgets('full card content fits the fixed discovery card height', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        _card(
          description: 'A complete room description',
          canJoin: true,
          onTap: () {},
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('compact card shows total presence', (tester) async {
    await tester.pumpWidget(_app(_card(), height: 240));

    expect(find.text('Online: 7'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
