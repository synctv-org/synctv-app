import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/widgets/add_room_member_dialog.dart';
import 'package:synctv_app/features/admin/presentation/widgets/send_test_email_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';

void main() {
  for (final email in [true, false]) {
    for (final failure in [true, false]) {
      testWidgets('covered admin dialog: email=$email failure=$failure', (
        tester,
      ) async {
        final gateway = _Gateway();
        final navigator = GlobalKey<NavigatorState>();
        Object? result;
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigator,
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (_, child) =>
                DependencyScope<AdminGateway>(value: gateway, child: child!),
            home: Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () async {
                    result = await showAppDialog<Object>(
                      context: context,
                      builder: (_) => email
                          ? const SendTestEmailDialog()
                          : const AddRoomMemberDialog(roomId: 'room'),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byType(TextField),
          email ? 'recipient@example.test' : 'member-id',
        );
        await tester.tap(find.text(email ? 'Send' : 'Add'));
        await tester.pump();
        expect(gateway.requests, hasLength(1));
        unawaited(
          showDialog<void>(
            context: navigator.currentContext!,
            builder: (_) => AlertDialog(
              title: const Text('Independent overlay'),
              actions: [
                TextButton(
                  onPressed: () => navigator.currentState!.pop(),
                  child: const Text('Close overlay'),
                ),
              ],
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 300));
        if (failure) {
          gateway.requests.single.completeError(StateError('request failed'));
        } else {
          gateway.requests.single.complete('Accepted');
        }
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.text('Independent overlay'), findsOneWidget);
        await tester.tap(find.text('Close overlay'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        if (failure) {
          final field = tester.widget<AppTextField>(find.byType(AppTextField));
          expect(field.enabled, isTrue);
          expect(
            field.controller.text,
            email ? 'recipient@example.test' : 'member-id',
          );
          await tester.tap(find.text(email ? 'Send' : 'Add'));
          await tester.pump();
          expect(gateway.requests, hasLength(2));
          gateway.requests.last.complete('Accepted');
          await tester.pumpAndSettle();
        }
        expect(result, email ? 'Accepted' : true);
        expect(find.byType(AppTextField), findsNothing);
        expect(find.text('Open'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}

class _Gateway implements AdminGateway {
  final requests = <Completer<String>>[];

  Future<String> _request() {
    final request = Completer<String>();
    requests.add(request);
    return request.future;
  }

  @override
  Future<String> adminSendTestEmail(String recipient) => _request();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #adminAddRoomMember) {
      return _request().then<void>((_) {});
    }
    return super.noSuchMethod(invocation);
  }
}
