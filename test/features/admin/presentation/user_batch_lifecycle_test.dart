import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;

import '../../../test_app.dart';

Future<void> _mount(WidgetTester tester, _Gateway gateway) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => DependencyScope<AdminGateway>(
        value: gateway,
        child: buildThemedTestApp(context, child),
      ),
      home: const Scaffold(body: UserManagementTab()),
    ),
  );
  await tester.pumpAndSettle();
  tester.widget<AppCheckbox>(find.byType(AppCheckbox)).onChanged!(true);
  await tester.pumpAndSettle();
}

VoidCallback _action(WidgetTester tester, String label) => tester
    .widget<AppActionButton>(find.widgetWithText(AppActionButton, label))
    .onPressed!;

Future<void> _confirm(WidgetTester tester, String action) async {
  final button = find.descendant(
    of: find.byType(Dialog),
    matching: find.widgetWithText(AppActionButton, action),
  );
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  for (final action in ['Ban', 'Delete']) {
    testWidgets(
      'batch $action locks both actions and releases after cancel/error',
      (tester) async {
        final gateway = _Gateway();
        await _mount(tester, gateway);
        final start = _action(tester, action);
        final other = _action(tester, action == 'Ban' ? 'Delete' : 'Ban');
        start();
        start();
        other();
        await tester.pumpAndSettle();
        expect(find.byType(Dialog, skipOffstage: false), findsOneWidget);
        await tester.tap(find.widgetWithText(AppActionButton, 'Cancel'));
        await tester.pumpAndSettle();
        expect(gateway.requests, isEmpty);
        start();
        await tester.pumpAndSettle();
        await _confirm(tester, action);
        start();
        other();
        await tester.pump();
        expect(find.byType(Dialog, skipOffstage: false), findsNothing);
        expect(gateway.requests, hasLength(1));
        for (final label in ['Ban', 'Delete']) {
          expect(
            tester
                .widget<AppActionButton>(
                  find.widgetWithText(AppActionButton, label),
                )
                .onPressed,
            isNull,
          );
        }
        gateway.requests.single.completeError(StateError('Retry batch'));
        await tester.pumpAndSettle();
        expect(
          tester.widget<AppCheckbox>(find.byType(AppCheckbox)).value,
          isTrue,
        );
        _action(tester, action)();
        await tester.pumpAndSettle();
        await _confirm(tester, action);
        expect(gateway.requests, hasLength(2));
        gateway.requests.last.complete(
          const AdminBatchOperationResult(
            results: [
              AdminBatchResult(id: 'user', success: false, error: 'Retry'),
            ],
            succeeded: 0,
            failed: 1,
          ),
        );
        await tester.pumpAndSettle();
        expect(_action(tester, action), isNotNull);
        expect(tester.takeException(), isNull);
        AppNotifications.dismissAll();
        await tester.pump();
      },
    );

    testWidgets(
      'batch $action ignores saved callbacks and failure after disposal',
      (tester) async {
        final gateway = _Gateway();
        await _mount(tester, gateway);
        final start = _action(tester, action);
        start();
        await tester.pumpAndSettle();
        await _confirm(tester, action);
        await tester.pumpWidget(const MaterialApp(home: Text('Replacement')));
        start();
        gateway.requests.single.completeError(StateError('Old batch failure'));
        await tester.pumpAndSettle();
        expect(gateway.requests, hasLength(1));
        expect(find.text('Replacement'), findsOneWidget);
        expect(find.textContaining('Old batch failure'), findsNothing);
        expect(tester.takeException(), isNull);
        AppNotifications.dismissAll();
        await tester.pump();
      },
    );
  }
}

class _Gateway implements AdminGateway {
  final requests = <Completer<AdminBatchOperationResult>>[];

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #adminListUsersPage) {
      return Future.value(
        AdminUsersPage(
          users: [
            SyncTvUser(
              id: 'user',
              username: 'User',
              role: const AccountUserRole(common.UserRole.USER_ROLE_USER),
            ),
          ],
          total: 1,
        ),
      );
    }
    if (invocation.memberName == #adminBatchBanUsers ||
        invocation.memberName == #adminBatchDeleteUsers) {
      final request = Completer<AdminBatchOperationResult>();
      requests.add(request);
      return request.future;
    }
    return super.noSuchMethod(invocation);
  }
}
