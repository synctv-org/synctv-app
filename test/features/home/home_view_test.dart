import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/home/showcase/home_showcase.dart';
import 'package:synctv_app/features/home/presentation/home_view.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/home/presentation/widgets/cinema_room_card.dart';

import '../../test_app.dart';

void main() {
  for (final scale in [1.0, 3.0]) {
    testWidgets('long category fits a phone viewport at $scale', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 568);
      addTearDown(tester.view.reset);
      const name = 'International cinema and documentary discussion screenings';
      String? selected;
      await tester.pumpWidget(
        HomeShowcaseApp(
          callbacks: homeShowcaseCallbacks(
            onSelectCategory: (id) => selected = id,
          ),
          textScaler: TextScaler.linear(scale),
          state: homeShowcaseState(
            categories: const [
              RoomCategoryInfo(
                id: 'long',
                key: 'long',
                name: name,
                description: '',
                sortOrder: 0,
                isEnabled: true,
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();
      final chip = find.widgetWithText(AppChip, name);
      await tester.scrollUntilVisible(
        find.widgetWithText(AppChip, 'All categories'),
        250,
        scrollable: find
            .byWidgetPredicate(
              (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
            )
            .first,
      );
      await tester.scrollUntilVisible(
        chip,
        200,
        scrollable: find.ancestor(
          of: find.widgetWithText(AppChip, 'All categories'),
          matching: find.byWidgetPredicate(
            (w) => w is Scrollable && w.axisDirection == AxisDirection.right,
          ),
        ),
      );
      expect(tester.getSize(chip).width, lessThanOrEqualTo(292));
      expect(byAppTooltip(name), findsOneWidget);
      await tester.ensureVisible(chip);
      await tester.pumpAndSettle();
      final gesture = await tester.startGesture(tester.getCenter(chip));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.text(name), findsNWidgets(2));
      await gesture.up();
      await tester.pump(const Duration(seconds: 3));
      await tester.tap(chip);
      expect(selected, 'long');
      expect(tester.takeException(), isNull);
    });
  }

  Future<void> setViewport(WidgetTester tester, Size size) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = size;
    addTearDown(tester.view.reset);
  }

  testWidgets(
    'home view renders without layout errors at product breakpoints',
    (tester) async {
      for (final size in const [
        Size(320, 568),
        Size(390, 844),
        Size(834, 1194),
        Size(1440, 1000),
      ]) {
        await setViewport(tester, size);
        for (final scale in [1.0, 2.0, 3.0]) {
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          await tester.pumpWidget(const HomeShowcaseApp());
          await tester.pumpAndSettle();

          expect(find.text('Featured rooms'), findsOneWidget);
          expect(find.text('Popular rooms'), findsOneWidget);
          expect(find.byType(CinemaRoomCard), findsWidgets);
          expect(
            tester.takeException(),
            isNull,
            reason: 'viewport: $size, scale: $scale',
          );
        }
      }
    },
  );

  testWidgets('room results are built lazily and use one column on phones', (
    tester,
  ) async {
    await setViewport(tester, const Size(390, 844));
    final rooms = List.generate(
      120,
      (index) => homeShowcaseRooms.first.copyWith(
        roomId: 'room-$index',
        roomName: 'Room $index',
      ),
    );
    await tester.pumpWidget(
      HomeShowcaseApp(
        state: homeShowcaseState(
          rooms: rooms,
          featuredRooms: const [],
          joinedRooms: const [],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CinemaRoomCard).evaluate().length, lessThan(10));
    expect(
      tester.getSize(find.byType(CinemaRoomCard).first).width,
      greaterThan(300),
    );
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -650));
    await tester.pumpAndSettle();
    expect(find.text('Room 3'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('failed discovery shows retry instead of an empty room state', (
    tester,
  ) async {
    await setViewport(tester, const Size(390, 844));
    await tester.pumpWidget(
      HomeShowcaseApp(
        state: homeShowcaseState(
          rooms: const [],
          featuredRooms: const [],
          joinedRooms: const [],
          loadError: 'Connection unavailable',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Could not load rooms: Connection unavailable'),
      findsOneWidget,
    );
    expect(byAppTooltip('Retry'), findsOneWidget);
    expect(find.text('No rooms'), findsNothing);
  });

  testWidgets('search debounces typing and submit cancels a pending request', (
    tester,
  ) async {
    final queries = <String>[];
    await tester.pumpWidget(
      HomeShowcaseApp(callbacks: homeShowcaseCallbacks(onSearch: queries.add)),
    );
    final field = find.byType(TextField).first;
    await tester.enterText(field, 'f');
    await tester.pump(const Duration(milliseconds: 200));
    await tester.enterText(field, 'film');
    await tester.pump(const Duration(milliseconds: 350));
    expect(queries, ['film']);
    await tester.enterText(field, 'cinema');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump(const Duration(milliseconds: 400));
    expect(queries, ['film', 'cinema']);
    await tester.enterText(field, '');
    expect(queries.last, '');
  });

  testWidgets(
    'room, favorite, search, and category commands reach controller',
    (tester) async {
      await setViewport(tester, const Size(1440, 1000));
      SyncTvRoom? openedRoom;
      SyncTvRoom? favoriteRoom;
      String? search;
      String? category;
      await tester.pumpWidget(
        HomeShowcaseApp(
          callbacks: homeShowcaseCallbacks(
            onOpenRoom: (room) => openedRoom = room,
            onToggleFavorite: (room) => favoriteRoom = room,
            onSearch: (value) => search = value,
            onSelectCategory: (value) => category = value,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(CinemaRoomCard).first);
      await tester.pumpAndSettle();
      expect(openedRoom?.roomId, 'friday-cinema');

      await tester.tap(byAppTooltip('Remove from favorites').first);
      await tester.pumpAndSettle();
      expect(favoriteRoom?.roomId, 'friday-cinema');

      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, 'documentary');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      expect(search, 'documentary');

      await tester.tap(find.text('Animation').first);
      await tester.pumpAndSettle();
      expect(category, 'animation');
    },
  );

  testWidgets('featured-only discovery omits an empty popular section', (
    tester,
  ) async {
    await setViewport(tester, const Size(1440, 1000));
    await tester.pumpWidget(
      HomeShowcaseApp(state: homeShowcaseState(rooms: const [])),
    );
    await tester.pumpAndSettle();

    expect(find.text('Featured rooms'), findsOneWidget);
    expect(find.text('Popular rooms'), findsNothing);
    expect(find.text('No rooms match the current filters'), findsNothing);
  });

  testWidgets('loading keeps discovery controls and server switching usable', (
    tester,
  ) async {
    await setViewport(tester, const Size(390, 844));
    var openServerCalls = 0;
    await tester.pumpWidget(
      HomeShowcaseApp(
        state: homeShowcaseState(
          rooms: const [],
          featuredRooms: const [],
          isLoading: true,
        ),
        callbacks: homeShowcaseCallbacks(
          onOpenServerSettings: () => openServerCalls++,
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(AppLinearProgress), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    final serverButton = find.widgetWithText(AppActionButton, 'Server');
    expect(serverButton, findsOneWidget);

    await tester.ensureVisible(serverButton);
    await tester.pump();
    await tester.tap(serverButton);
    expect(openServerCalls, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('room created by the current user has an ownership badge', (
    tester,
  ) async {
    await setViewport(tester, const Size(1440, 1000));
    final ownedRoom = homeShowcaseRooms.first.copyWith(
      roomId: 'owned-room',
      creatorId: 'showcase-user',
      joined: true,
    );
    await tester.pumpWidget(
      HomeShowcaseApp(state: homeShowcaseState(rooms: [ownedRoom])),
    );
    await tester.pumpAndSettle();

    expect(find.text('Created by me'), findsOneWidget);
  });

  testWidgets('account menu icons remain visible in the light theme', (
    tester,
  ) async {
    await setViewport(tester, const Size(1440, 1000));
    await tester.pumpWidget(const HomeShowcaseApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Account menu'));
    await tester.pumpAndSettle();

    final accountIcon = tester.widget<Icon>(
      find.byIcon(Icons.account_circle_rounded),
    );
    expect(
      accountIcon.color,
      Theme.of(tester.element(find.byType(HomeView))).colorScheme.onSurface,
    );
    expect(find.text('Account center'), findsOneWidget);
  });
}
