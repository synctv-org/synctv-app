import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/widgets/edit_user_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';

import '../../../test_app.dart';

void main() {
  for (final password in [false, true]) {
    testWidgets('editor validates, retains failed draft, retries $password', (
      tester,
    ) async {
      final gateway = _Gateway();
      await _open(tester, gateway, password);
      final fields = find.byType(TextField);
      await tester.enterText(fields.first, '');
      await tester.tap(find.text(password ? 'Reset' : 'Save'));
      await tester.pumpAndSettle();
      expect(gateway.calls, isEmpty);
      await tester.enterText(fields.first, '  corrected-value  ');
      if (password) await tester.enterText(fields.last, '  test reason  ');
      await tester.tap(find.text(password ? 'Reset' : 'Save'));
      await tester.pump();
      expect(gateway.calls, hasLength(1));
      expect(gateway.calls.single.positionalArguments, [
        'usr_42',
        password ? '  corrected-value  ' : 'corrected-value',
      ]);
      if (password) {
        expect(gateway.calls.single.namedArguments[#reason], 'test reason');
      }
      final submit = tester
          .widget<AppTextField>(find.byType(AppTextField).first)
          .onSubmitted!;
      submit('');
      expect(gateway.calls, hasLength(1));
      gateway.requests.single.completeError(StateError('rejected'));
      await tester.pumpAndSettle();
      expect(find.byType(EditUserDialog), findsOneWidget);
      expect(
        tester.widget<TextField>(fields.first).controller!.text,
        '  corrected-value  ',
      );
      AppNotifications.dismissAll();
      await tester.pumpAndSettle();
      await tester.tap(find.text(password ? 'Reset' : 'Save'));
      await tester.pump();
      expect(gateway.calls, hasLength(2));
      gateway.requests.last.complete();
      await tester.pumpAndSettle();
      expect(find.byType(EditUserDialog), findsNothing);
      expect(tester.takeException(), isNull);
    });
    for (final failure in [false, true]) {
      testWidgets('closed editor ignores late response $password $failure', (
        tester,
      ) async {
        final gateway = _Gateway();
        await _open(tester, gateway, password);
        await tester.enterText(find.byType(TextField).first, 'test-value');
        await tester.tap(find.text(password ? 'Reset' : 'Save'));
        await tester.pump();
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        if (failure) {
          gateway.requests.single.completeError(StateError('obsolete'));
        } else {
          gateway.requests.single.complete();
        }
        await tester.pumpAndSettle();
        expect(find.byType(EditUserDialog), findsOneWidget);
        expect(find.textContaining('obsolete'), findsNothing);
        expect(tester.takeException(), isNull);
      });
    }
  }
}

Future<void> _open(WidgetTester tester, _Gateway gateway, bool password) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => DependencyScope<AdminGateway>(
        value: gateway,
        child: buildThemedTestApp(context, child),
      ),
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => showAppDialog<bool>(
              context: context,
              builder: (_) => password
                  ? const EditUserDialog.password(userId: 'usr_42')
                  : const EditUserDialog.rename(
                      userId: 'usr_42',
                      username: 'original',
                    ),
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
  final calls = <Invocation>[];
  final requests = <Completer<void>>[];
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #adminUpdateUsername ||
        invocation.memberName == #adminUpdatePassword) {
      calls.add(invocation);
      final request = Completer<void>();
      requests.add(request);
      return request.future;
    }
    return super.noSuchMethod(invocation);
  }
}
