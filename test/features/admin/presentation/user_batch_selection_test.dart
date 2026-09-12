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

void main() {
  for (final action in ['Ban', 'Delete']) {
    testWidgets('batch $action preserves failed and newly selected users', (
      tester,
    ) async {
      final gateway = _Gateway();
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
      void select(int index, bool value) => tester
          .widget<AppCheckbox>(find.byType(AppCheckbox).at(index))
          .onChanged!(value);
      select(0, true);
      select(1, true);
      await tester.pumpAndSettle();
      final start = find.widgetWithText(AppActionButton, action);
      await tester.ensureVisible(start);
      await tester.tap(start);
      await tester.pumpAndSettle();
      final confirm = find.descendant(
        of: find.byType(Dialog),
        matching: find.widgetWithText(AppActionButton, action),
      );
      await tester.ensureVisible(confirm);
      await tester.tap(confirm);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(gateway.ids, ['user-0', 'user-1']);
      select(2, true);
      await tester.pump();
      gateway.result.complete(
        const AdminBatchOperationResult(
          results: [
            AdminBatchResult(id: 'user-0', success: true, error: ''),
            AdminBatchResult(id: 'user-1', success: false, error: 'Retry'),
            AdminBatchResult(id: 'user-2', success: true, error: ''),
          ],
          succeeded: 1,
          failed: 1,
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<AppCheckbox>(find.byType(AppCheckbox).at(0)).value,
        isFalse,
      );
      expect(
        tester.widget<AppCheckbox>(find.byType(AppCheckbox).at(1)).value,
        isTrue,
      );
      expect(
        tester.widget<AppCheckbox>(find.byType(AppCheckbox).at(2)).value,
        isTrue,
      );
      expect(find.text('2 users selected'), findsOneWidget);
      expect(tester.takeException(), isNull);
      AppNotifications.dismissAll();
      await tester.pump();
    });
  }
}

class _Gateway implements AdminGateway {
  final result = Completer<AdminBatchOperationResult>();
  List<String>? ids;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #adminListUsersPage) {
      return Future.value(
        AdminUsersPage(
          users: List.generate(
            3,
            (index) => SyncTvUser(
              id: 'user-$index',
              username: 'User $index',
              role: const AccountUserRole(common.UserRole.USER_ROLE_USER),
            ),
          ),
          total: 3,
        ),
      );
    }
    if (invocation.memberName == #adminBatchBanUsers ||
        invocation.memberName == #adminBatchDeleteUsers) {
      ids = List<String>.from(invocation.positionalArguments.first as List);
      return result.future;
    }
    return super.noSuchMethod(invocation);
  }
}
