import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/network/resource_url_resolver.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/account/application/account_gateway.dart';
import 'package:synctv_app/features/account/presentation/account_center_page.dart';
import 'package:synctv_app/features/app_shell/presentation/app_shell.dart';
import 'package:synctv_app/features/app_shell/presentation/app_shell_dependencies.dart';
import 'package:synctv_app/features/auth/application/auth_gateway.dart';
import 'package:synctv_app/features/auth/application/native_apple_sign_in_client.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/application/opaque_authenticator.dart';
import 'package:synctv_app/features/auth/application/passkey_client.dart';
import 'package:synctv_app/features/auth/presentation/auth_panel.dart';
import 'package:synctv_app/features/home/application/home_gateway.dart';
import 'package:synctv_app/features/home/presentation/home_view.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_preferences_controller.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_media_preferences.dart';
import 'package:synctv_app/features/room/application/room_management_gateway.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;

void main() {
  testWidgets('startup invite opens authentication for its room once', (
    tester,
  ) async {
    final harness = await _pumpShell(
      tester,
      initialInvite: '/rooms/join?room_id=room_invited',
    );
    expect(harness.home.roomLookups, ['room_invited']);
    harness.home.room.complete(
      SyncTvRoom(
        roomId: 'room_invited',
        roomName: 'Invited room',
        creatorId: 'creator',
      ),
    );
    await tester.pumpAndSettle();
    final auth = tester.widget<AuthPanel>(find.byType(AuthPanel));
    expect(auth.initialGuestRoomId, 'room_invited');
    harness.navigator.currentState!.pop();
    await tester.pumpAndSettle();
    await tester.widget<HomeView>(find.byType(HomeView)).callbacks.refresh();
    await tester.pumpAndSettle();
    expect(find.byType(AuthPanel), findsNothing);
    expect(harness.home.roomLookups, ['room_invited']);
  });

  testWidgets('ambiguous startup invite never requests a room', (tester) async {
    final harness = await _pumpShell(
      tester,
      initialInvite: '/rooms/join?room_id=one&room_id=two',
    );
    expect(harness.home.roomLookups, isEmpty);
    expect(find.byType(AuthPanel), findsNothing);
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('returning from account reloads discovery and blocked creators', (
    tester,
  ) async {
    final harness = await _pumpShell(tester, authenticated: true);
    final room = SyncTvRoom(
      roomId: 'joined',
      roomName: 'Joined room',
      creatorId: 'another-user',
      joined: true,
      creatorBlocked: true,
    );
    harness.home.joinedRooms = [room];
    HomeView home() => tester.widget<HomeView>(find.byType(HomeView));
    await home().callbacks.refresh();
    await tester.pumpAndSettle();
    expect(home().state.joinedRooms.single.creatorBlocked, isTrue);
    home().callbacks.openAccountCenter();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    final restored = room.copyWith(creatorBlocked: false);
    harness.home.joinedRooms = [restored];
    harness.home.discoveryResponse = (page) async => RoomDiscoveryPage(
      featuredRooms: [restored],
      rooms: [],
      total: 0,
      page: page,
      pageSize: 24,
    );
    harness.navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(home().state.joinedRooms.single.creatorBlocked, isFalse);
    expect(home().state.featuredRooms.single.roomId, 'joined');
    expect(tester.takeException(), isNull);
  });

  for (final fail in [false, true]) {
    for (final duringMutation in [false, true]) {
      for (final finishMutationFirst in [false, true]) {
        testWidgets(
          'refresh preserves favorite mutation, fail=$fail during=$duringMutation mutationFirst=$finishMutationFirst',
          (tester) async {
            final harness = await _pumpShell(tester, authenticated: true);
            final room = SyncTvRoom(
              roomId: 'favorite',
              roomName: 'Favorite room',
              creatorId: 'user-1',
              joined: true,
              isFavorite: fail,
            );
            RoomDiscoveryPage result(bool favorite) => RoomDiscoveryPage(
              rooms: [room.copyWith(isFavorite: favorite)],
              featuredRooms: [room.copyWith(isFavorite: favorite)],
              total: 1,
              page: 1,
              pageSize: 24,
            );
            harness.home.discoveryResponse = (_) async => result(fail);
            harness.home.joinedRooms = [room];
            HomeView home() => tester.widget<HomeView>(find.byType(HomeView));
            await home().callbacks.refresh();
            await tester.pumpAndSettle();
            final response = Completer<RoomDiscoveryPage>();
            final mutation = Completer<SyncTvRoom>();
            harness.home.pendingFavorite = mutation.future;
            harness.home.discoveryResponse = (_) => response.future;
            if (duringMutation) home().callbacks.toggleFavorite(room);
            final refresh = home().callbacks.refresh();
            await tester.pump();
            if (!duringMutation) home().callbacks.toggleFavorite(room);
            await tester.pump();
            if (!finishMutationFirst) {
              response.complete(result(fail));
              await refresh;
              await tester.pump();
              expect(home().state.rooms.single.isFavorite, !fail);
              expect(home().state.featuredRooms.single.isFavorite, !fail);
              expect(home().state.joinedRooms.single.isFavorite, !fail);
              expect(
                home().state.favoriteRoomIdsInFlight,
                contains('favorite'),
              );
            }
            if (fail) {
              mutation.completeError(StateError('favorite failed'));
            } else {
              mutation.complete(room.copyWith(isFavorite: true));
            }
            await tester.pump();
            if (finishMutationFirst) response.complete(result(false));
            await refresh;
            await tester.pumpAndSettle();
            expect(home().state.rooms.single.isFavorite, isTrue);
            expect(home().state.featuredRooms.single.isFavorite, isTrue);
            expect(home().state.joinedRooms.single.isFavorite, isTrue);
            expect(home().state.favoriteRoomIdsInFlight, isEmpty);
            // A later request can observe an authoritative change from another client.
            harness.home.discoveryResponse = (_) async => result(false);
            harness.home.joinedRooms = [room.copyWith(isFavorite: false)];
            await home().callbacks.refresh();
            await tester.pumpAndSettle();
            expect(home().state.rooms.single.isFavorite, isFalse);
            expect(home().state.featuredRooms.single.isFavorite, isFalse);
            expect(home().state.joinedRooms.single.isFavorite, isFalse);
            await tester.pump(const Duration(seconds: 5));
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }

  testWidgets('expired delete confirmation cannot dismiss login or delete', (
    tester,
  ) async {
    final harness = await _pumpShell(tester, authenticated: true);
    tester
        .widget<HomeView>(find.byType(HomeView))
        .callbacks
        .deleteRoom(
          SyncTvRoom(roomId: 'old', roomName: 'Old room', creatorId: 'user-1'),
        );
    await tester.pumpAndSettle();
    final confirm = tester
        .widget<AppActionButton>(
          find.byWidgetPredicate(
            (w) => w is AppActionButton && w.label == 'Delete',
          ),
        )
        .onPressed!;
    harness.home.expire();
    await tester.pumpAndSettle();
    expect(find.byType(AuthPanel), findsOneWidget);
    confirm();
    await tester.pumpAndSettle();
    expect(find.byType(AuthPanel), findsOneWidget);
    expect(harness.home.deletedRooms, isEmpty);
    harness.navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('disposed delete confirmation cannot close replacement dialog', (
    tester,
  ) async {
    final harness = await _pumpShell(tester, authenticated: true);
    final callbacks = tester.widget<HomeView>(find.byType(HomeView)).callbacks;
    callbacks.deleteRoom(
      SyncTvRoom(roomId: 'old', roomName: 'Old room', creatorId: 'user-1'),
    );
    await tester.pumpAndSettle();
    final confirm = tester
        .widget<AppActionButton>(
          find.byWidgetPredicate(
            (w) => w is AppActionButton && w.label == 'Delete',
          ),
        )
        .onPressed!;
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    callbacks.openLabelFilter();
    await tester.pumpAndSettle();
    confirm();
    await tester.pumpAndSettle();
    expect(find.byType(AppDialog), findsOneWidget);
    expect(harness.home.deletedRooms, isEmpty);
    harness.navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'delete confirmation deduplicates requests and releases after failure',
    (tester) async {
      final harness = await _pumpShell(tester, authenticated: true);
      final callbacks = tester
          .widget<HomeView>(find.byType(HomeView))
          .callbacks;
      final room = SyncTvRoom(
        roomId: 'old',
        roomName: 'Old room',
        creatorId: 'user-1',
      );
      callbacks.deleteRoom(room);
      callbacks.deleteRoom(room);
      await tester.pumpAndSettle();
      final confirms = find.byWidgetPredicate(
        (w) => w is AppActionButton && w.label == 'Delete',
        skipOffstage: false,
      );
      expect(confirms, findsOneWidget);
      final pending = Completer<void>();
      harness.home.pendingDelete = pending.future;
      final confirm = tester.widget<AppActionButton>(confirms).onPressed!;
      confirm();
      confirm();
      await tester.pumpAndSettle();
      callbacks.deleteRoom(room);
      await tester.pumpAndSettle();
      expect(harness.home.deletedRooms, ['old']);
      expect(confirms, findsNothing);
      pending.completeError(StateError('delete offline'));
      await tester.pumpAndSettle();
      harness.home.pendingDelete = null;
      callbacks.deleteRoom(room);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(harness.home.deletedRooms, ['old', 'old']);
      await tester.pump(const Duration(seconds: 5));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('filter uses reconciled category after awaited taxonomy', (
    tester,
  ) async {
    final harness = await _pumpShell(tester);
    harness.home.categories = const [
      RoomCategoryInfo(
        id: 'film',
        key: 'film',
        name: 'Film',
        description: '',
        sortOrder: 0,
        isEnabled: true,
      ),
    ];
    HomeView home() => tester.widget<HomeView>(find.byType(HomeView));
    await home().callbacks.refresh();
    await tester.pumpAndSettle();
    home().callbacks.selectCategory('film');
    await tester.pumpAndSettle();
    harness.home.categories = const [];
    final pending = Completer<List<RoomLabelInfo>>();
    harness.home.pendingLabels = pending.future;
    final refresh = home().callbacks.refresh();
    home().callbacks.openLabelFilter();
    await tester.pump();
    pending.complete(const [
      RoomLabelInfo(
        id: 'weekly',
        key: 'weekly',
        name: 'Weekly',
        description: '',
        color: '',
        categoryId: '',
        sortOrder: 0,
        isEnabled: true,
      ),
    ]);
    await refresh;
    await tester.pumpAndSettle();
    expect(home().state.selectedCategoryId, isEmpty);
    final tile = tester.widget<AppCheckboxTile>(find.byType(AppCheckboxTile));
    expect(tile.subtitle, isNotNull);
    tile.onChanged!(true);
    await tester.pump();
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(home().state.selectedLabelCount, 1);
    expect(harness.home.discoveryLabels.last, ['weekly']);
    expect(tester.takeException(), isNull);
  });

  testWidgets('corrected discovery page failure can be retried', (
    tester,
  ) async {
    final harness = await _pumpShell(tester);
    var total = 49;
    var fail = false;
    harness.home.discoveryResponse = (page) async {
      if (fail && page == 1) throw StateError('recovery failed');
      return RoomDiscoveryPage(
        featuredRooms: [],
        rooms: [],
        total: total,
        page: page,
        pageSize: 24,
      );
    };
    HomeView home() => tester.widget<HomeView>(find.byType(HomeView));
    await home().callbacks.refresh();
    await tester.pumpAndSettle();
    home().callbacks.goToPage(3);
    await tester.pumpAndSettle();
    total = 24;
    fail = true;
    await home().callbacks.refresh();
    await tester.pumpAndSettle();
    expect(home().state.page, 1);
    expect(home().state.isLoading, isFalse);
    expect(home().state.loadError, isNotNull);
    fail = false;
    await home().callbacks.refresh();
    await tester.pumpAndSettle();
    expect(home().state.page, 1);
    expect(home().state.totalRooms, 24);
    expect(home().state.isLoading, isFalse);
    expect(home().state.loadError, isNull);
    expect(harness.home.discoveryPages.reversed.take(3).toList(), [1, 1, 3]);
    expect(tester.takeException(), isNull);
  });

  for (final fail in [false, true]) {
    testWidgets('stale discovery cannot clamp newer search, failure=$fail', (
      tester,
    ) async {
      final harness = await _pumpShell(tester);
      RoomDiscoveryPage pageResult(int page, int total) => RoomDiscoveryPage(
        featuredRooms: [],
        rooms: [],
        total: total,
        page: page,
        pageSize: 24,
      );
      harness.home.discoveryResponse = (page) async => pageResult(page, 49);
      HomeView home() => tester.widget<HomeView>(find.byType(HomeView));
      await home().callbacks.refresh();
      await tester.pumpAndSettle();
      home().callbacks.goToPage(3);
      await tester.pumpAndSettle();
      final pending = Completer<RoomDiscoveryPage>();
      harness.home.discoveryResponse = (_) => pending.future;
      final refresh = home().callbacks.refresh();
      await tester.pump();
      harness.home.discoveryResponse = (page) async => pageResult(page, 25);
      home().callbacks.search('');
      await tester.pumpAndSettle();
      final queryCount = harness.home.discoveryPages.length;
      if (fail) {
        pending.completeError(StateError('stale page failure'));
      } else {
        pending.complete(pageResult(3, 0));
      }
      await refresh;
      await tester.pumpAndSettle();
      expect(home().state.page, 1);
      expect(home().state.totalRooms, 25);
      expect(home().state.loadError, isNull);
      expect(harness.home.discoveryPages, hasLength(queryCount));
      expect(tester.takeException(), isNull);
    });
  }

  for (final remaining in [0, 24, 25]) {
    testWidgets('discovery clamps removed last page with total=$remaining', (
      tester,
    ) async {
      final harness = await _pumpShell(tester);
      var total = 49;
      harness.home.discoveryResponse = (page) async => RoomDiscoveryPage(
        featuredRooms: [],
        rooms: [],
        total: total,
        page: page,
        pageSize: 24,
      );
      HomeView home() => tester.widget<HomeView>(find.byType(HomeView));
      await home().callbacks.refresh();
      await tester.pumpAndSettle();
      home().callbacks.goToPage(3);
      await tester.pumpAndSettle();
      expect(home().state.page, 3);
      total = remaining;
      await home().callbacks.refresh();
      await tester.pumpAndSettle();
      final lastPage = remaining <= 24 ? 1 : 2;
      expect(home().state.page, lastPage);
      expect(home().state.pageCount, lastPage);
      expect(harness.home.discoveryPages.last, lastPage);
      expect(home().state.isLoading, isFalse);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'taxonomy removal clears obsolete category and re-queries current filters',
    (tester) async {
      final harness = await _pumpShell(tester);
      harness.home.categories = const [
        RoomCategoryInfo(
          id: 'film',
          key: 'film',
          name: 'Film',
          description: '',
          sortOrder: 0,
          isEnabled: true,
        ),
      ];
      harness.home.labels = const [
        RoomLabelInfo(
          id: 'weekly',
          key: 'weekly',
          name: 'Weekly',
          description: '',
          color: '',
          categoryId: 'film',
          sortOrder: 0,
          isEnabled: true,
        ),
      ];
      HomeView home() => tester.widget<HomeView>(find.byType(HomeView));
      await home().callbacks.refresh();
      await tester.pumpAndSettle();
      home().callbacks.selectCategory('film');
      await tester.pumpAndSettle();
      home().callbacks.openLabelFilter();
      await tester.pumpAndSettle();
      tester.widget<AppCheckboxTile>(find.byType(AppCheckboxTile)).onChanged!(
        true,
      );
      await tester.pump();
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(home().state.selectedLabelCount, 1);
      harness.home.categories = const [];
      harness.home.labels = const [];
      await home().callbacks.refresh();
      await tester.pumpAndSettle();
      expect(home().state.selectedCategoryId, isEmpty);
      expect(home().state.selectedLabelCount, 0);
      expect(harness.home.discoveryCategories.last, isEmpty);
      expect(harness.home.discoveryLabels.last, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'expiration cancels pending filter and ignores old taxonomy failure',
    (tester) async {
      final harness = await _pumpShell(tester);
      final pending = Completer<List<RoomLabelInfo>>();
      harness.home.pendingLabels = pending.future;
      tester
          .widget<HomeView>(find.byType(HomeView))
          .callbacks
          .openLabelFilter();
      await tester.pump();
      harness.home.pendingLabels = null;
      harness.home.expire();
      await tester.pumpAndSettle();
      expect(find.byType(AuthPanel), findsOneWidget);
      pending.completeError(StateError('stale taxonomy'));
      await tester.pumpAndSettle();
      expect(find.byType(AuthPanel), findsOneWidget);
      expect(find.textContaining('stale taxonomy'), findsNothing);
      harness.navigator.currentState!.pop();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('empty taxonomy is cached until explicit refresh', (
    tester,
  ) async {
    final harness = await _pumpShell(tester);
    expect(harness.home.labelLoads, 1);
    final callbacks = tester.widget<HomeView>(find.byType(HomeView)).callbacks;
    callbacks.search('');
    await tester.pumpAndSettle();
    expect(harness.home.labelLoads, 1);
    await callbacks.refresh();
    await tester.pumpAndSettle();
    expect(harness.home.labelLoads, 2);
  });

  testWidgets('filter waits for shared taxonomy refresh', (tester) async {
    final harness = await _pumpShell(tester);
    final pending = Completer<List<RoomLabelInfo>>();
    harness.home.pendingLabels = pending.future;
    final callbacks = tester.widget<HomeView>(find.byType(HomeView)).callbacks;
    final refresh = callbacks.refresh();
    callbacks.openLabelFilter();
    await tester.pump();
    expect(find.byType(AppDialog), findsNothing);
    pending.complete(const []);
    await refresh;
    await tester.pumpAndSettle();
    expect(find.byType(AppDialog), findsOneWidget);
    expect(harness.home.labelLoads, 2);
    harness.navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('failed label refresh shows error and filter retries', (
    tester,
  ) async {
    final harness = await _pumpShell(tester);
    final pending = Completer<List<RoomLabelInfo>>();
    harness.home.pendingLabels = pending.future;
    tester.widget<HomeView>(find.byType(HomeView)).callbacks.openLabelFilter();
    await tester.pump();
    pending.completeError(StateError('taxonomy offline'));
    await tester.pumpAndSettle();
    expect(find.byType(AppDialog), findsNothing);
    expect(find.textContaining('taxonomy offline'), findsOneWidget);
    harness.home.pendingLabels = null;
    tester.widget<HomeView>(find.byType(HomeView)).callbacks.openLabelFilter();
    await tester.pumpAndSettle();
    expect(find.byType(AppDialog), findsOneWidget);
    harness.navigator.currentState!.pop();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'label filter opens once and applies then clears discovery filters',
    (tester) async {
      final harness = await _pumpShell(tester);
      harness.home.labels = const [
        RoomLabelInfo(
          id: 'selected',
          key: 'selected',
          name: 'Weekend',
          description: '',
          color: '',
          categoryId: '',
          sortOrder: 0,
          isEnabled: true,
        ),
      ];
      void open() => tester
          .widget<HomeView>(find.byType(HomeView))
          .callbacks
          .openLabelFilter();
      open();
      open();
      await tester.pumpAndSettle();
      expect(find.byType(AppDialog), findsOneWidget);
      tester.widget<AppCheckboxTile>(find.byType(AppCheckboxTile)).onChanged!(
        true,
      );
      await tester.pump();
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();
      expect(harness.home.discoveryLabels.last, ['selected']);
      expect(
        tester.widget<HomeView>(find.byType(HomeView)).state.selectedLabelCount,
        1,
      );
      open();
      await tester.pumpAndSettle();
      expect(
        tester.widget<AppCheckboxTile>(find.byType(AppCheckboxTile)).value,
        isTrue,
      );
      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();
      expect(harness.home.discoveryLabels.last, isEmpty);
      expect(
        tester.widget<HomeView>(find.byType(HomeView)).state.selectedLabelCount,
        0,
      );
      expect(harness.navigator.currentState!.canPop(), isFalse);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('label filter wraps long names and ignores disposed apply', (
    tester,
  ) async {
    final harness = await _pumpShell(tester);
    harness.home.labels = const [
      RoomLabelInfo(
        id: 'label',
        key: 'label',
        name: 'A very long film category label for international screenings and discussions',
        description: '',
        color: '#227744',
        categoryId: '',
        sortOrder: 0,
        isEnabled: true,
      ),
    ];
    tester.widget<HomeView>(find.byType(HomeView)).callbacks.openLabelFilter();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final apply = tester
        .widget<AppActionButton>(find.widgetWithText(AppActionButton, 'Apply'))
        .onPressed!;
    harness.navigator.currentState!.pop();
    await tester.pumpAndSettle();
    unawaited(
      harness.navigator.currentState!.push<void>(
        MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text('Replacement page')),
        ),
      ),
    );
    await tester.pumpAndSettle();
    apply();
    await tester.pumpAndSettle();
    expect(find.text('Replacement page'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final fail in [false, true]) {
    testWidgets(
      'cancelled join lookup preserves replacement dialog, failure=$fail',
      (tester) async {
        final harness = await _pumpShell(tester);
        final field = find.descendant(
          of: find.byType(AppDialog),
          matching: find.byType(TextField),
        );
        void open() => tester
            .widget<HomeView>(find.byType(HomeView))
            .callbacks
            .openJoinRoom();
        open();
        await tester.pumpAndSettle();
        await tester.enterText(field, 'room-1');
        await tester.pump();
        await tester.tap(find.text('Continue'));
        await tester.pump();
        expect(harness.home.roomLookups, ['room-1']);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        open();
        await tester.pumpAndSettle();
        await tester.enterText(field, 'new-draft');
        if (fail) {
          harness.home.room.completeError(StateError('old lookup failed'));
        } else {
          harness.home.room.complete(
            SyncTvRoom(
              roomId: 'room-1',
              roomName: 'Old room',
              creatorId: 'creator',
            ),
          );
        }
        await tester.pumpAndSettle();
        expect(field, findsOneWidget);
        expect(tester.widget<TextField>(field).controller!.text, 'new-draft');
        expect(find.textContaining('old lookup failed'), findsNothing);
        expect(find.byType(AuthPanel), findsNothing);
        expect(tester.takeException(), isNull);
        harness.navigator.currentState!.pop();
        await tester.pumpAndSettle();
      },
    );
  }

  for (final fail in [false, true]) {
    testWidgets(
      'logout reconciles cleared credentials and removes pages, failure=$fail',
      (tester) async {
        final harness = await _pumpShell(tester, authenticated: true);
        await _confirmLogout(tester);
        final callback = tester
            .widget<HomeView>(find.byType(HomeView))
            .callbacks
            .logout;
        callback();
        await tester.pump();
        expect(harness.home.logouts, hasLength(1));
        unawaited(
          harness.navigator.currentState!.push<void>(
            MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('Old page')),
            ),
          ),
        );
        await tester.pumpAndSettle();
        harness.home.authenticated = false;
        if (fail) {
          harness.home.logouts.single.completeError(
            StateError('persistence failed'),
          );
        } else {
          harness.home.logouts.single.complete();
        }
        await tester.pumpAndSettle();
        expect(find.text('Old page', skipOffstage: false), findsNothing);
        expect(harness.navigator.currentState!.canPop(), isFalse);
        expect(
          tester.widget<HomeView>(find.byType(HomeView)).state.currentUser,
          isNull,
        );
        expect(
          find.textContaining(fail ? 'persistence failed' : 'Logged out'),
          findsWidgets,
        );
        await tester.pump(const Duration(seconds: 4));
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('failed logout retains current account and can be retried', (
    tester,
  ) async {
    final harness = await _pumpShell(tester, authenticated: true);
    await _confirmLogout(tester);
    harness.home.logouts.single.completeError(StateError('logout failed'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<HomeView>(find.byType(HomeView))
          .state
          .currentUser
          ?.username,
      'Old user',
    );
    await tester.pump(const Duration(seconds: 4));
    await _confirmLogout(tester);
    expect(harness.home.logouts, hasLength(2));
    harness.home.authenticated = false;
    harness.home.logouts.last.complete();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));
    expect(
      tester.widget<HomeView>(find.byType(HomeView)).state.currentUser,
      isNull,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('old logout failure cannot affect a reauthenticated account', (
    tester,
  ) async {
    final harness = await _pumpShell(tester, authenticated: true);
    await _confirmLogout(tester);
    harness.home.expire();
    await tester.pumpAndSettle();
    harness.home.authenticated = true;
    harness.home.username = 'New user';
    harness.navigator.currentState!.pop(true);
    await tester.pumpAndSettle();
    harness.home.logouts.single.completeError(StateError('stale logout'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<HomeView>(find.byType(HomeView))
          .state
          .currentUser
          ?.username,
      'New user',
    );
    expect(find.textContaining('stale logout'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final manage in [false, true]) {
    for (final relogin in [false, true]) {
      testWidgets(
        'late account navigation cannot reopen an expired session, manage=$manage, relogin=$relogin',
        (tester) async {
          final harness = await _pumpShell(tester, authenticated: true);
          tester
              .widget<HomeView>(find.byType(HomeView))
              .callbacks
              .openAccountCenter();
          await tester.pump();
          await tester.pump(const Duration(seconds: 1));
          final account = tester.widget<AccountCenterPage>(
            find.byType(AccountCenterPage),
          );
          final room = SyncTvRoom(
            roomId: 'room-1',
            roomName: 'Room',
            creatorId: 'user-1',
          );
          final navigation = manage
              ? account.onManageRoom(room)
              : account.onOpenRoom(room);
          await tester.pump();
          harness.home.expire();
          await tester.pumpAndSettle();
          expect(
            find.byType(AccountCenterPage, skipOffstage: false),
            findsNothing,
          );
          expect(find.byType(AuthPanel), findsOneWidget);
          if (relogin) {
            harness.home.authenticated = true;
            harness.home.username = 'New user';
            harness.navigator.currentState!.pop(true);
            await tester.pumpAndSettle();
          }
          if (manage) {
            harness.management.settings.complete(SyncTvRoomSettings());
          } else {
            harness.home.room.complete(room);
          }
          await tester.pumpAndSettle();
          await navigation;
          if (relogin) {
            expect(
              tester
                  .widget<HomeView>(find.byType(HomeView))
                  .state
                  .currentUser
                  ?.username,
              'New user',
            );
          } else {
            expect(find.byType(AuthPanel), findsOneWidget);
            harness.navigator.currentState!.pop();
            await tester.pumpAndSettle();
          }
          expect(harness.navigator.currentState!.canPop(), isFalse);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('expired session removes nested pages and dialogs before login', (
    tester,
  ) async {
    final harness = await _pumpShell(tester);
    unawaited(
      harness.navigator.currentState!.push<void>(
        MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text('Old account page')),
        ),
      ),
    );
    await tester.pumpAndSettle();
    unawaited(
      showDialog<void>(
        context: tester.element(find.text('Old account page')),
        builder: (_) => const PopScope(
          canPop: false,
          child: AlertDialog(content: Text('Old account dialog')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    harness.home.expire();
    harness.home.expire();
    await tester.pumpAndSettle();
    expect(find.byType(AuthPanel), findsOneWidget);
    expect(find.text('Old account page', skipOffstage: false), findsNothing);
    expect(find.text('Old account dialog', skipOffstage: false), findsNothing);
    harness.navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(harness.navigator.currentState!.canPop(), isFalse);
    expect(find.byType(HomeView), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('expiration closes an existing shell modal and opens login', (
    tester,
  ) async {
    final harness = await _pumpShell(tester);
    tester.widget<HomeView>(find.byType(HomeView)).callbacks.openJoinRoom();
    await tester.pumpAndSettle();
    expect(harness.navigator.currentState!.canPop(), isTrue);
    harness.home.expire();
    await tester.pumpAndSettle();
    expect(find.byType(AuthPanel), findsOneWidget);
    harness.navigator.currentState!.pop();
    await tester.pumpAndSettle();
    expect(harness.navigator.currentState!.canPop(), isFalse);
    expect(tester.takeException(), isNull);
  });

  for (final initiallyOpen in [false, true]) {
    testWidgets(
      'repeated expiration preserves login draft, open=$initiallyOpen',
      (tester) async {
        final harness = await _pumpShell(tester);
        if (initiallyOpen) {
          tester.widget<HomeView>(find.byType(HomeView)).callbacks.openLogin();
        } else {
          harness.home.expire();
        }
        await tester.pumpAndSettle();
        final field = find
            .descendant(
              of: find.byType(AuthPanel),
              matching: find.byType(EditableText),
            )
            .first;
        await tester.enterText(field, 'login-draft');
        final panelState = tester.state(find.byType(AuthPanel));
        harness.home.expire();
        await tester.pumpAndSettle();
        expect(find.byType(AuthPanel), findsOneWidget);
        expect(tester.state(find.byType(AuthPanel)), same(panelState));
        expect(
          tester.widget<EditableText>(field).controller.text,
          'login-draft',
        );
        harness.navigator.currentState!.pop();
        await tester.pumpAndSettle();
        harness.home.expire();
        await tester.pumpAndSettle();
        expect(find.byType(AuthPanel), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}

Future<
  ({
    GlobalKey<NavigatorState> navigator,
    _HomeGateway home,
    _RoomManagementGateway management,
  })
>
_pumpShell(
  WidgetTester tester, {
  bool authenticated = false,
  String? initialInvite,
}) async {
  await tester.binding.setSurfaceSize(const Size(1200, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final home = _HomeGateway()..authenticated = authenticated;
  final management = _RoomManagementGateway();
  final opaque = OpaqueAuthenticatorService(gateway: _OpaqueGateway());
  final navigator = GlobalKey<NavigatorState>();
  final preferences = P2pMediaPreferencesController(store: _PreferencesStore());
  addTearDown(home.errors.close);
  addTearDown(preferences.dispose);
  await tester.pumpWidget(
    MaterialApp(
      navigatorKey: navigator,
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (_, child) => DependencyRegistryScope(
        values: {
          AccountGateway: _AccountGateway(),
          OpaqueAuthenticatorService: opaque,
          OAuth2CallbackClient: _OAuthCallbacks(),
          NativeAppleSignInClient: _AppleSignIn(),
          PasskeyClient: _PasskeyClient(),
          ResourceUrlResolver: const IdentityResourceUrlResolver(),
        },
        child: child!,
      ),
      home: AppShell(
        initialInvite: initialInvite,
        dependencies: AppShellDependencies(
          homeGateway: home,
          authGateway: _AuthGateway(),
          opaqueAuthenticator: opaque,
          oauth2Callbacks: _OAuthCallbacks(),
          nativeAppleSignIn: _AppleSignIn(),
          passkeyClient: _PasskeyClient(),
          p2pMediaPreferences: preferences,
          roomManagementGateway: management,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return (navigator: navigator, home: home, management: management);
}

class _HomeGateway implements HomeGateway {
  Future<SyncTvRoom>? pendingFavorite;
  List<SyncTvRoom> joinedRooms = [];
  @override
  Future<SyncTvRoom> favoriteRoom(String roomId) => pendingFavorite!;
  @override
  Future<SyncTvRoom> unfavoriteRoom(String roomId) => pendingFavorite!;
  final deletedRooms = <String>[];
  Future<void>? pendingDelete;
  @override
  Future<void> deleteRoom(String roomId) async {
    deletedRooms.add(roomId);
    await pendingDelete;
  }

  final logouts = <Completer<void>>[];
  @override
  Future<void> logout() {
    final operation = Completer<void>();
    logouts.add(operation);
    return operation.future;
  }

  bool authenticated = false;
  String username = 'Old user';
  final room = Completer<SyncTvRoom>();
  final roomLookups = <String>[];
  List<RoomLabelInfo> labels = const [];
  List<RoomCategoryInfo> categories = const [];
  Future<List<RoomLabelInfo>>? pendingLabels;
  int labelLoads = 0;
  final discoveryLabels = <List<String>>[];
  final discoveryCategories = <String>[];
  final discoveryPages = <int>[];
  Future<RoomDiscoveryPage> Function(int page)? discoveryResponse;
  final errors = StreamController<void>.broadcast();
  void expire() {
    authenticated = false;
    errors.add(null);
  }

  @override
  Stream<void> get authErrors => errors.stream;
  @override
  bool get hasServer => true;
  @override
  SyncTvSessionIdentity get sessionIdentity => authenticated
      ? const AccountSessionIdentity()
      : const AnonymousSessionIdentity();
  @override
  Future<SyncTvUser> getCurrentUser() async => SyncTvUser(
    id: 'user-1',
    username: username,
    role: const AccountUserRole(common.UserRole.USER_ROLE_USER),
  );
  @override
  Future<RoomsPage> getJoinedRooms({
    required int page,
    required int pageSize,
  }) async => RoomsPage(
    rooms: joinedRooms,
    total: joinedRooms.length,
    page: page,
    pageSize: pageSize,
  );
  @override
  Future<SyncTvRoom> getRoom(String roomId) {
    roomLookups.add(roomId);
    return room.future;
  }

  @override
  Future<List<RoomCategoryInfo>> listRoomCategories({
    bool refresh = false,
  }) async => categories;
  @override
  Future<List<RoomLabelInfo>> listRoomLabels({bool refresh = false}) async {
    labelLoads++;
    return pendingLabels ?? labels;
  }

  @override
  Future<RoomDiscoveryPage> discoverRooms({
    required int page,
    required int pageSize,
    String? search,
    String categoryId = '',
    List<String> labelIds = const [],
  }) async {
    discoveryLabels.add(List.of(labelIds));
    discoveryCategories.add(categoryId);
    discoveryPages.add(page);
    if (discoveryResponse case final respond?) return respond(page);
    return RoomDiscoveryPage(
      featuredRooms: [],
      rooms: [],
      total: 0,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

Future<void> _confirmLogout(WidgetTester tester) async {
  final callback = tester
      .widget<HomeView>(find.byType(HomeView))
      .callbacks
      .logout;
  callback();
  callback();
  await tester.pumpAndSettle();
  final buttons = tester
      .widgetList<AppActionButton>(
        find.byWidgetPredicate(
          (w) => w is AppActionButton && w.label == 'Log out',
        ),
      )
      .toList();
  expect(buttons, hasLength(1));
  buttons.single.onPressed!();
  buttons.single.onPressed!();
  await tester.pumpAndSettle();
}

class _AuthGateway implements AuthGateway {
  @override
  String? get activeServerName => 'Test server';
  @override
  String get serverBaseUrl => 'https://app.example.test';
  @override
  Future<List<OAuth2ProviderOption>> listOAuth2Providers() async => [];
  @override
  Future<PublicSettingsInfo> getPublicSettings() async =>
      const PublicSettingsInfo(
        roomCreationEnabled: true,
        maxRoomsPerUser: 10,
        defaultMaxMembers: 10,
        roomCreationApprovalRequired: false,
        roomPasswordPolicy:
            common.RoomPasswordPolicy.ROOM_PASSWORD_POLICY_UNSPECIFIED,
        enablePasswordSignup: true,
        passwordSignupNeedReview: false,
        enableEmailSignup: false,
        enableEmail: false,
        enableGuest: false,
        emailSignupNeedReview: false,
        enableWebauthn: false,
        webauthnRpId: '',
        enableWebauthnSignup: false,
        webauthnSignupNeedReview: false,
        emailWhitelistEnabled: false,
        emailWhitelistDomains: [],
        tsDisguisedAsPng: false,
        rtmpAdvertiseAddress: null,
      );
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

class _PreferencesStore implements P2pMediaPreferencesStore {
  @override
  Future<P2pMediaPreferenceValues> load() async =>
      const P2pMediaPreferenceValues();
  @override
  Future<void> save(P2pMediaPreferenceValues values) async {}
}

class _OpaqueGateway implements OpaqueAuthGateway {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

class _OAuthCallbacks implements OAuth2CallbackClient {
  @override
  bool get canCreateSession => false;
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

class _AppleSignIn implements NativeAppleSignInClient {
  @override
  bool get isSupported => false;
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

class _PasskeyClient implements PasskeyClient {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

class _RoomManagementGateway implements RoomManagementGateway {
  final settings = Completer<SyncTvRoomSettings>();
  @override
  Future<SyncTvRoomSettings> getRoomSettings(
    String roomId, {
    bool refresh = false,
  }) => settings.future;
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName}');
}

class _AccountGateway implements AccountGateway {
  final pending = Completer<Never>();
  @override
  String? get activeServerName => 'Test server';
  @override
  dynamic noSuchMethod(Invocation invocation) => pending.future;
}
