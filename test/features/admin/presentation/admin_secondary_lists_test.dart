import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/providers/common.pbenum.dart'
    as provider_enum;

import '../../../test_app.dart';

void main() {
  testWidgets(
    'provider edit submits changed endpoint and releases actions after refresh',
    (tester) async {
      final gateway = _Gateway();
      await tester.pumpWidget(_app(const AdminProviderTab(), gateway));
      await tester.pump();
      gateway.complete.first('Provider');
      await tester.pumpAndSettle();
      final edit = find.byWidgetPredicate(
        (w) => w is AppIconButton && w.icon == Icons.edit_outlined,
      );
      await tester.tap(edit);
      await tester.pumpAndSettle();
      final endpoint = find.byWidgetPredicate(
        (w) => w is AppTextField && w.label == 'Endpoint',
      );
      await tester.enterText(
        find.descendant(of: endpoint, matching: find.byType(TextField)),
        ' https://updated.example.test ',
      );
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(gateway.providerUpdates, hasLength(1));
      expect(gateway.updateArguments.single[#name], 'Provider');
      expect(
        gateway.updateArguments.single[#endpoint],
        'https://updated.example.test',
      );
      expect(gateway.updateArguments.single[#providers], ['emby']);
      expect(tester.widget<AppIconButton>(edit).onPressed, isNull);
      gateway.providerUpdates.single.complete(
        const AdminProviderInstance(
          name: 'Provider',
          endpoint: 'https://updated.example.test',
          comment: '',
          timeoutSeconds: 30,
          tls: true,
          insecureTls: false,
          providers: ['emby'],
          enabled: true,
          status: provider_enum
              .ProviderInstanceStatus
              .PROVIDER_INSTANCE_STATUS_CONNECTED,
          createdAt: 1,
          updatedAt: 2,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.widget<AppIconButton>(edit).onPressed, isNull);
      gateway.complete.last('Updated provider');
      await tester.pumpAndSettle();
      expect(find.text('Updated provider'), findsOneWidget);
      expect(tester.widget<AppIconButton>(edit).onPressed, isNotNull);
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(seconds: 5));
    },
  );

  testWidgets(
    'provider delete confirmation excludes other operations and cancel restores them',
    (tester) async {
      final gateway = _Gateway();
      await tester.pumpWidget(_app(const AdminProviderTab(), gateway));
      await tester.pump();
      gateway.complete.first('Provider');
      await tester.pumpAndSettle();
      AppIconButton button(IconData icon) => tester.widget<AppIconButton>(
        find.byWidgetPredicate((w) => w is AppIconButton && w.icon == icon),
      );
      final remove = button(Icons.delete_outline).onPressed!;
      final reconnect = button(Icons.sync_rounded).onPressed!;
      final edit = button(Icons.edit_outlined).onPressed!;
      final toggle = tester
          .widget<AppSwitch>(find.byType(AppSwitch))
          .onChanged!;
      remove();
      remove();
      reconnect();
      edit();
      toggle(false);
      await tester.pumpAndSettle();
      expect(gateway.providerToggles, isEmpty);
      expect(gateway.providerReconnects, isEmpty);
      expect(find.text('Delete provider', skipOffstage: false), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(button(Icons.edit_outlined).onPressed, isNotNull);
      reconnect();
      reconnect();
      remove();
      await tester.pumpAndSettle();
      expect(gateway.providerReconnects, hasLength(1));
      expect(find.text('Delete provider'), findsNothing);
      gateway.providerReconnects.first.completeError(
        StateError('reconnect failed'),
      );
      await tester.pumpAndSettle();
      expect(button(Icons.delete_outline).onPressed, isNotNull);
      remove();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(gateway.providerDeletes, hasLength(1));
      expect(gateway.deletedNames, ['Provider']);
      expect(button(Icons.delete_outline).onPressed, isNull);
      gateway.providerDeletes.first.completeError(StateError('delete failed'));
      await tester.pumpAndSettle();
      expect(button(Icons.delete_outline).onPressed, isNotNull);
      remove();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(gateway.providerDeletes, hasLength(2));
      gateway.providerDeletes.last.complete();
      await tester.pumpAndSettle();
      expect(button(Icons.edit_outlined).onPressed, isNull);
      gateway.complete.last('Remaining provider');
      await tester.pumpAndSettle();
      expect(find.text('Remaining provider'), findsOneWidget);
      expect(find.text('Provider'), findsNothing);
      expect(button(Icons.edit_outlined).onPressed, isNotNull);
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(seconds: 5));
    },
  );

  testWidgets(
    'provider enable toggle blocks duplicates and recovers on failure',
    (tester) async {
      final gateway = _Gateway();
      await tester.pumpWidget(_app(const AdminProviderTab(), gateway));
      await tester.pump();
      gateway.complete.first('Provider');
      await tester.pumpAndSettle();
      final toggle = find.byType(AppSwitch);
      final action = tester.widget<AppSwitch>(toggle).onChanged!;
      action(false);
      action(false);
      await tester.pump();
      expect(gateway.providerToggles, hasLength(1));
      expect(tester.widget<AppSwitch>(toggle).onChanged, isNull);
      for (final icon in [
        Icons.edit_outlined,
        Icons.sync_rounded,
        Icons.delete_outline,
      ]) {
        expect(
          tester
              .widget<AppIconButton>(
                find.byWidgetPredicate(
                  (w) => w is AppIconButton && w.icon == icon,
                ),
              )
              .onPressed,
          isNull,
        );
      }
      gateway.providerToggles.first.completeError(StateError('toggle failed'));
      await tester.pumpAndSettle();
      expect(tester.widget<AppSwitch>(toggle).onChanged, isNotNull);
      action(false);
      await tester.pump();
      gateway.providerToggles.last.complete();
      await tester.pumpAndSettle();
      expect(tester.widget<AppSwitch>(toggle).onChanged, isNull);
      gateway.complete.last('Provider');
      await tester.pumpAndSettle();
      expect(tester.widget<AppSwitch>(toggle).onChanged, isNotNull);
      expect(tester.takeException(), isNull);
      await tester.pump(const Duration(seconds: 5));
    },
  );

  testWidgets(
    'stale administrator mode action preserves the promotion dialog',
    (tester) async {
      final gateway = _Gateway();
      await tester.pumpWidget(_app(const AdministratorsTab(), gateway));
      await tester.pump();
      gateway.complete.first('Administrator');
      await tester.pumpAndSettle();
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is AppIconButton && w.icon == Icons.add_moderator_outlined,
        ),
      );
      await tester.pumpAndSettle();
      final action = tester
          .widget<AppActionButton>(
            find.byWidgetPredicate(
              (w) =>
                  w is AppActionButton && w.icon == Icons.person_search_rounded,
            ),
          )
          .onPressed!;
      action();
      await tester.pumpAndSettle();
      expect(find.byType(AppTextField), findsWidgets);
      action();
      await tester.pumpAndSettle();
      expect(find.text('Promote existing user'), findsOneWidget);
      expect(find.text('Promote'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'administrator mode result does not reopen after parent disposal',
    (tester) async {
      final visible = ValueNotifier(true);
      addTearDown(visible.dispose);
      final gateway = _Gateway();
      await tester.pumpWidget(
        _app(
          ValueListenableBuilder<bool>(
            valueListenable: visible,
            builder: (_, show, _) =>
                show ? const AdministratorsTab() : const SizedBox(),
          ),
          gateway,
        ),
      );
      await tester.pump();
      gateway.complete.first('Administrator');
      await tester.pumpAndSettle();
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is AppIconButton && w.icon == Icons.add_moderator_outlined,
        ),
      );
      await tester.pumpAndSettle();
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      visible.value = false;
      await tester.pump();
      navigator.pop('existing');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Promote existing user'), findsNothing);
    },
  );

  testWidgets('review decisions exclude conflicting actions and recover', (
    tester,
  ) async {
    final gateway = _Gateway();
    await tester.pumpWidget(_app(const AdminReviewTab(), gateway));
    await tester.pump();
    gateway.complete.first('Review');
    await tester.pumpAndSettle();
    final approve = find.byWidgetPredicate(
      (w) => w is AppIconButton && w.icon == Icons.check_circle_outline,
    );
    final reject = find.byWidgetPredicate(
      (w) => w is AppIconButton && w.icon == Icons.cancel_outlined,
    );
    final approveAction = tester.widget<AppIconButton>(approve).onPressed!;
    final rejectAction = tester.widget<AppIconButton>(reject).onPressed!;
    approveAction();
    approveAction();
    rejectAction();
    await tester.pumpAndSettle();
    expect(gateway.decisions, hasLength(1));
    expect(find.text('Reject review'), findsNothing);
    expect(tester.widget<AppIconButton>(approve).onPressed, isNull);
    expect(tester.widget<AppIconButton>(reject).onPressed, isNull);
    gateway.decisions.first.completeError(StateError('decision failed'));
    await tester.pumpAndSettle();
    rejectAction();
    approveAction();
    await tester.pumpAndSettle();
    expect(gateway.decisions, hasLength(1));
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(tester.widget<AppIconButton>(approve).onPressed, isNotNull);
    rejectAction();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reject'));
    await tester.pumpAndSettle();
    expect(find.text('Enter Reason'), findsOneWidget);
    expect(find.text('Reject review'), findsOneWidget);
    expect(gateway.decisions, hasLength(1));
    final reasonField = find.descendant(
      of: find.byType(Form),
      matching: find.byType(TextField),
    );
    await tester.enterText(reasonField, '   ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('Reject review'), findsOneWidget);
    expect(gateway.decisions, hasLength(1));
    await tester.enterText(reasonField, 'Disposable review rejection');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(gateway.decisions, hasLength(2));
    gateway.decisions.last.complete();
    await tester.pumpAndSettle();
    expect(tester.widget<AppIconButton>(reject).onPressed, isNull);
    gateway.complete.last('Refreshed review');
    await tester.pumpAndSettle();
    expect(tester.widget<AppIconButton>(reject).onPressed, isNotNull);
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(seconds: 5));
  });

  for (final entry in <(String, Widget)>[
    ('bans', const AdminBanRecordsTab()),
    ('streams', const AdminStreamsTab()),
    ('reviews', const AdminReviewTab()),
    ('providers', const AdminProviderTab()),
    ('administrators', const AdministratorsTab()),
  ]) {
    for (final remaining in [0, entry.$1 == 'administrators' ? 20 : 50]) {
      testWidgets(
        '${entry.$1} recovers when the current page disappears: $remaining remain',
        (tester) async {
          final gateway = _ShrinkingPageGateway(remaining);
          await tester.pumpWidget(_app(entry.$2, gateway));
          await tester.pumpAndSettle();
          tester
              .widget<AppPaginationBar>(find.byType(AppPaginationBar))
              .onNext!();
          await tester.pumpAndSettle();
          expect(gateway.pages, [1, 2, 1]);
          expect(
            tester
                .widget<AppPaginationBar>(find.byType(AppPaginationBar))
                .onPrevious,
            isNull,
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets(
    'ban search rejects unsupported text without clearing its filter',
    (tester) async {
      final gateway = _Gateway();
      await tester.pumpWidget(_app(const AdminBanRecordsTab(), gateway));
      await tester.pump();
      gateway.complete.first('Initial');
      await tester.pumpAndSettle();
      final search = tester.widget<AppSearchField>(find.byType(AppSearchField));
      search.onSubmitted(' usr_latest ');
      await tester.pump();
      gateway.complete.last('Filtered');
      await tester.pumpAndSettle();
      expect(gateway.banQueries.last[#userId], 'usr_latest');
      for (final invalid in ['someone', 'usr_', 'room_']) {
        search.onSubmitted(invalid);
        await tester.pump();
        expect(gateway.banQueries, hasLength(2));
        await tester.pumpAndSettle();
        expect(find.text('Filtered (usr_latest)'), findsOneWidget);
        expect(find.text('usr_latest'), findsOneWidget);
      }
      search.onSubmitted(' room_latest ');
      await tester.pump();
      expect(gateway.banQueries.last[#roomId], 'room_latest');
      expect(gateway.banQueries.last[#userId], '');
      gateway.complete.last('Room filter');
      await tester.pumpAndSettle();
      search.onSubmitted('');
      await tester.pump();
      expect(gateway.banQueries.last[#roomId], '');
      expect(gateway.banQueries.last[#userId], '');
      gateway.complete.last('All records');
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 5));
    },
  );

  for (final roomBan in [false, true]) {
    testWidgets(
      'unban guards confirmation and submission and permits retry: room=$roomBan',
      (tester) async {
        final gateway = _Gateway(roomBan: roomBan);
        await tester.pumpWidget(_app(const AdminBanRecordsTab(), gateway));
        await tester.pump();
        gateway.complete.first('Visible user');
        await tester.pumpAndSettle();
        final unban = find.byWidgetPredicate(
          (widget) =>
              widget is AppIconButton && widget.icon == Icons.lock_open_rounded,
        );
        final action = tester.widget<AppIconButton>(unban).onPressed!;
        action();
        action();
        await tester.pumpAndSettle();
        expect(
          find.text(roomBan ? 'Unban room' : 'Unban user', skipOffstage: false),
          findsOneWidget,
        );
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(gateway.unbans, isEmpty);
        expect(tester.widget<AppIconButton>(unban).onPressed, isNotNull);

        await tester.tap(unban);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Unban'));
        await tester.pumpAndSettle();
        expect(gateway.unbans, hasLength(1));
        expect(tester.widget<AppIconButton>(unban).onPressed, isNull);
        action();
        await tester.pumpAndSettle();
        expect(find.text(roomBan ? 'Unban room' : 'Unban user'), findsNothing);
        gateway.unbans.first.completeError(StateError('unban failed'));
        await tester.pumpAndSettle();
        expect(tester.widget<AppIconButton>(unban).onPressed, isNotNull);

        await tester.tap(unban);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Unban'));
        await tester.pumpAndSettle();
        expect(gateway.unbans, hasLength(2));
        gateway.unbans.last.complete();
        await tester.pumpAndSettle();
        expect(tester.widget<AppIconButton>(unban).onPressed, isNull);
        gateway.complete.last('Refreshed user');
        await tester.pumpAndSettle();
        expect(tester.widget<AppIconButton>(unban).onPressed, isNotNull);
        expect(tester.takeException(), isNull);
        await tester.pump(const Duration(seconds: 5));
      },
    );
  }

  testWidgets('stream disconnect ignores duplicate requests and allows retry', (
    tester,
  ) async {
    final gateway = _Gateway();
    await tester.pumpWidget(_app(const AdminStreamsTab(), gateway));
    await tester.pump();
    gateway.complete.first('Visible stream');
    await tester.pumpAndSettle();
    final disconnect = find.byWidgetPredicate(
      (widget) =>
          widget is AppIconButton &&
          widget.icon == Icons.power_settings_new_rounded,
    );
    final action = tester.widget<AppIconButton>(disconnect).onPressed!;
    action();
    action();
    await tester.pump();
    expect(gateway.kicks, hasLength(1));
    expect(tester.widget<AppIconButton>(disconnect).onPressed, isNull);

    tester.widget<AppSearchField>(find.byType(AppSearchField)).onSubmitted('');
    await tester.pump();
    gateway.complete.last('Visible stream');
    await tester.pumpAndSettle();
    expect(tester.widget<AppIconButton>(disconnect).onPressed, isNull);

    gateway.kicks.first.completeError(StateError('disconnect failed'));
    await tester.pumpAndSettle();
    expect(tester.widget<AppIconButton>(disconnect).onPressed, isNotNull);
    await tester.tap(disconnect);
    await tester.pump();
    expect(gateway.kicks, hasLength(2));
    gateway.kicks.last.complete();
    await tester.pumpAndSettle();
    gateway.complete.last('Refreshed stream');
    await tester.pumpAndSettle();
    expect(find.text('Refreshed stream'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pump(const Duration(seconds: 5));
  });

  for (final entry in <(String, Widget)>[
    ('administrators', const AdministratorsTab()),
    ('bans', const AdminBanRecordsTab()),
    ('reviews', const AdminReviewTab()),
    ('streams', const AdminStreamsTab()),
    ('providers', const AdminProviderTab()),
  ]) {
    for (final size in [const Size(320, 480), const Size(740, 320)]) {
      for (final scale in [1.0, 2.0]) {
        testWidgets(
          '${entry.$1} exposes records at $size with ${scale}x text',
          (tester) async {
            await tester.binding.setSurfaceSize(size);
            addTearDown(() => tester.binding.setSurfaceSize(null));
            tester.platformDispatcher.textScaleFactorTestValue = scale;
            addTearDown(
              tester.platformDispatcher.clearTextScaleFactorTestValue,
            );
            final gateway = _Gateway();
            await tester.pumpWidget(_app(entry.$2, gateway));
            await tester.pump();
            gateway.complete.first('Visible record');
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            final record = find.textContaining('Visible record');
            await tester.scrollUntilVisible(
              record,
              120,
              scrollable: find.byType(Scrollable).first,
            );
            await tester.pumpAndSettle();
            expect(record.hitTestable(), findsOneWidget);
            expect(tester.takeException(), isNull);
          },
        );
      }
    }

    for (final staleError in [false, true]) {
      testWidgets(
        '${entry.$1} ignores stale ${staleError ? "failures" : "results"}',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(1400, 1000));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final gateway = _Gateway();
          await tester.pumpWidget(_app(entry.$2, gateway));
          await tester.pump();
          gateway.complete.first('Initial');
          await tester.pumpAndSettle();
          final search = tester.widget<AppSearchField>(
            find.byType(AppSearchField).first,
          );
          search.onSubmitted('usr_old');
          search.onSubmitted('usr_latest');
          await tester.pump();
          expect(gateway.complete, hasLength(3));
          gateway.complete[2]('Latest');
          await tester.pumpAndSettle();
          if (staleError) {
            gateway.fail[1]();
          } else {
            gateway.complete[1]('Stale');
          }
          await tester.pumpAndSettle();
          expect(find.textContaining('Latest'), findsWidgets);
          expect(find.textContaining('Stale'), findsNothing);
          expect(find.textContaining('outdated request failed'), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}

Widget _app(Widget page, AdminGateway gateway) => MaterialApp(
  locale: const Locale('en'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  builder: (context, child) => DependencyScope<AdminGateway>(
    value: gateway,
    child: buildThemedTestApp(context, child),
  ),
  home: Scaffold(body: page),
);

class _ShrinkingPageGateway implements AdminGateway {
  _ShrinkingPageGateway(this.remaining);
  final int remaining;
  final pages = <int>[];

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #getMe) {
      return Future.value(
        SyncTvUser(
          id: 'usr_me',
          username: 'Me',
          role: const AccountUserRole(common_enum.UserRole.USER_ROLE_ADMIN),
        ),
      );
    }
    final page = invocation.namedArguments[#page] as int;
    final pageSize = invocation.namedArguments[#pageSize] as int;
    pages.add(page);
    final total = pages.length == 1 ? pageSize + 1 : remaining;
    switch (invocation.memberName) {
      case #adminListAdminsPage:
        return Future.value(AdminsPage(admins: [], total: total));
      case #adminListProviderInstancesPage:
        return Future.value(
          AdminProviderInstancesPage(instances: [], total: total),
        );
      case #adminListBanRecordsPage:
        return Future.value(
          AdminBanRecordsPage(
            records: [],
            total: total,
            page: page,
            pageSize: 50,
          ),
        );
      case #adminListActiveStreamsPage:
        return Future.value(AdminActiveStreamsPage(streams: [], total: total));
      case #adminListReviewsPage:
        return Future.value(
          AdminReviewsPage(reviews: [], total: total, page: page, pageSize: 50),
        );
    }
    return super.noSuchMethod(invocation);
  }
}

class _Gateway implements AdminGateway {
  final providerUpdates = <Completer<AdminProviderInstance>>[];
  final updateArguments = <Map<Symbol, dynamic>>[];
  final providerDeletes = <Completer<void>>[];
  final deletedNames = <String>[];
  final providerReconnects = <Completer<void>>[];
  final providerToggles = <Completer<void>>[];
  final decisions = <Completer<void>>[];
  final banQueries = <Map<Symbol, dynamic>>[];
  _Gateway({this.roomBan = false});
  final bool roomBan;
  final unbans = <Completer<void>>[];
  final kicks = <Completer<void>>[];
  final complete = <void Function(String)>[];
  final fail = <void Function()>[];

  Future<T> _pending<T>(T Function(String) result) {
    final completer = Completer<T>();
    complete.add((name) => completer.complete(result(name)));
    fail.add(
      () => completer.completeError(StateError('outdated request failed')),
    );
    return completer.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    switch (invocation.memberName) {
      case #adminUpdateProviderInstance:
        updateArguments.add(invocation.namedArguments);
        final completion = Completer<AdminProviderInstance>();
        providerUpdates.add(completion);
        return completion.future;
      case #adminDeleteProviderInstance:
        deletedNames.add(invocation.positionalArguments.single as String);
        final completion = Completer<void>();
        providerDeletes.add(completion);
        return completion.future;
      case #adminReconnectProviderInstance:
        final completion = Completer<void>();
        providerReconnects.add(completion);
        return completion.future;
      case #adminSetProviderInstanceEnabled:
        final completion = Completer<void>();
        providerToggles.add(completion);
        return completion.future;
      case #adminApproveReview:
      case #adminRejectReview:
        final completion = Completer<void>();
        decisions.add(completion);
        return completion.future;
      case #adminBanUser:
      case #adminBanRoom:
        final completion = Completer<void>();
        unbans.add(completion);
        return completion.future;
      case #adminKickStream:
        final completion = Completer<void>();
        kicks.add(completion);
        return completion.future;
      case #adminListAdminsPage:
        return _pending<AdminsPage>(
          (name) => AdminsPage(
            admins: [
              SyncTvUser(
                id: 'usr_latest',
                username: name,
                role: const AccountUserRole(
                  common_enum.UserRole.USER_ROLE_ADMIN,
                ),
              ),
            ],
            total: 1,
          ),
        );
      case #getMe:
        return Future.value(
          SyncTvUser(
            id: 'usr_me',
            username: 'Me',
            role: const AccountUserRole(common_enum.UserRole.USER_ROLE_ADMIN),
          ),
        );
      case #adminListBanRecordsPage:
        banQueries.add(invocation.namedArguments);
        return _pending<AdminBanRecordsPage>(
          (name) => AdminBanRecordsPage(
            records: [
              AdminBanRecord(
                id: 'ban_1',
                targetType: roomBan
                    ? admin_enum.BanTargetType.BAN_TARGET_TYPE_ROOM
                    : admin_enum.BanTargetType.BAN_TARGET_TYPE_USER,
                userId: 'usr_latest',
                username: name,
                roomId: roomBan ? 'room_latest' : '',
                roomName: roomBan ? name : '',
                bannedBy: 'usr_me',
                bannedByUsername: 'Me',
                reason: '',
                startsAt: 1,
                endsAt: 0,
                revokedAt: 0,
                revokedBy: '',
                isActive: true,
              ),
            ],
            total: 1,
            page: 1,
            pageSize: 50,
          ),
        );
      case #adminListActiveStreamsPage:
        return _pending<AdminActiveStreamsPage>(
          (name) => AdminActiveStreamsPage(
            streams: [
              AdminActiveStream(
                roomId: 'room_1',
                mediaId: name,
                userId: 'usr_latest',
                nodeId: 'node_1',
                startedAt: 1,
              ),
            ],
            total: 1,
          ),
        );
      case #adminListReviewsPage:
        return _pending<AdminReviewsPage>(
          (name) => AdminReviewsPage(
            reviews: [
              AdminRoomCreationReview(
                id: 'review_1',
                title: name,
                subtitle: '',
                detail: '',
                status: common_enum.ReviewStatus.REVIEW_STATUS_PENDING,
                requestedAt: 1,
                reviewedAt: null,
                reviewedBy: null,
                rejectionReason: null,
              ),
            ],
            total: 1,
            page: 1,
            pageSize: 50,
          ),
        );
      case #adminListProviderInstancesPage:
        return _pending<AdminProviderInstancesPage>(
          (name) => AdminProviderInstancesPage(
            instances: [
              AdminProviderInstance(
                name: name,
                endpoint: 'https://example.com',
                comment: '',
                timeoutSeconds: 30,
                tls: true,
                insecureTls: false,
                providers: const ['emby'],
                enabled: true,
                status: provider_enum
                    .ProviderInstanceStatus
                    .PROVIDER_INSTANCE_STATUS_CONNECTED,
                createdAt: 1,
                updatedAt: 1,
              ),
            ],
            total: 1,
          ),
        );
    }
    return super.noSuchMethod(invocation);
  }
}
