import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/widgets/add_administrator_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;

void main() {
  for (final promote in [true, false]) {
    testWidgets(
      'administrator validates, retains failure and retries: $promote',
      (tester) async {
        final gateway = _Gateway();
        await _open(tester, gateway, promote);
        final label = promote ? 'Promote' : 'Add';
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        expect(find.byType(AddAdministratorDialog), findsOneWidget);
        expect(gateway.requests, isEmpty);
        await tester.enterText(find.byType(TextField).first, '  test-user  ');
        if (!promote) {
          await tester.enterText(
            find.byType(TextField).last,
            ' exact password ',
          );
        }
        final submit = tester
            .widget<AppActionButton>(
              find.widgetWithText(AppActionButton, label),
            )
            .onPressed!;
        submit();
        submit();
        await tester.pump();
        expect(gateway.requests, hasLength(1));
        expect(gateway.calls.single.positionalArguments.first, 'test-user');
        if (!promote) {
          expect(
            gateway.calls.single.positionalArguments[1],
            ' exact password ',
          );
          expect(
            gateway.calls.single.positionalArguments[2],
            common.UserRole.USER_ROLE_ADMIN,
          );
        }
        gateway.requests.single.completeError(StateError('Retry fixture'));
        await tester.pumpAndSettle();
        AppNotifications.dismissAll();
        expect(
          tester
              .widget<TextField>(find.byType(TextField).first)
              .controller!
              .text,
          '  test-user  ',
        );
        await tester.showKeyboard(find.byType(TextField).last);
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pump();
        expect(gateway.requests, hasLength(2));
        gateway.requests.last.complete();
        await tester.pumpAndSettle();
        expect(find.byType(AddAdministratorDialog), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
    testWidgets(
      'administrator late response does not close replacement: $promote',
      (tester) async {
        final gateway = _Gateway();
        await _open(tester, gateway, promote);
        await tester.enterText(find.byType(TextField).first, 'test-user');
        if (!promote) {
          await tester.enterText(find.byType(TextField).last, 'test-password');
        }
        await tester.tap(find.text(promote ? 'Promote' : 'Add'));
        await tester.pump();
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        gateway.requests.single.complete();
        await tester.pumpAndSettle();
        expect(find.byType(AddAdministratorDialog), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}

Future<void> _open(WidgetTester tester, _Gateway gateway, bool promote) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (_, child) =>
          DependencyScope<AdminGateway>(value: gateway, child: child!),
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => showAppDialog<bool>(
              context: context,
              builder: (_) => AddAdministratorDialog(promoteExisting: promote),
            ),
            child: const Text('Open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}

class _Gateway implements AdminGateway {
  final requests = <Completer<void>>[];
  final calls = <Invocation>[];
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #adminAddAdmin ||
        invocation.memberName == #adminAddUser) {
      calls.add(invocation);
      final request = Completer<void>();
      requests.add(request);
      return request.future;
    }
    return super.noSuchMethod(invocation);
  }
}
