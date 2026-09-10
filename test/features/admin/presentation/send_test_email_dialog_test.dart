import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';
import 'package:synctv_app/features/admin/presentation/widgets/send_test_email_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';

void main() {
  for (final outcome in [
    'retry',
    'cancel success',
    'back failure',
    'unmount',
  ]) {
    testWidgets('test email validates, coalesces sends and handles $outcome', (
      tester,
    ) async {
      final gateway = _Gateway();
      String? result;
      await _open(tester, gateway, (value) => result = value);
      final field = tester.widget<AppTextField>(find.byType(AppTextField));
      final controller = field.controller;
      await tester.tap(find.text('Send'));
      await tester.pumpAndSettle();
      expect(find.text('Enter your email address'), findsOneWidget);
      expect(gateway.recipients, isEmpty);
      await tester.enterText(
        find.byType(TextField),
        '  recipient@example.com  ',
      );
      final submit = tester
          .widget<AppActionButton>(find.widgetWithText(AppActionButton, 'Send'))
          .onPressed!;
      submit();
      submit();
      field.onSubmitted!('ignored');
      await tester.pump();
      expect(gateway.recipients, ['recipient@example.com']);
      expect(
        tester.widget<AppTextField>(find.byType(AppTextField)).enabled,
        isFalse,
      );
      if (outcome == 'retry') {
        gateway.requests.single.completeError(StateError('SMTP unavailable'));
        await tester.pumpAndSettle();
        expect(find.textContaining('SMTP unavailable'), findsWidgets);
        expect(controller.text, '  recipient@example.com  ');
        await tester.pump(const Duration(seconds: 4));
        await tester.tap(find.text('Send'));
        await tester.pump();
        expect(gateway.requests, hasLength(2));
        gateway.requests.last.complete('Accepted');
      } else if (outcome == 'cancel success') {
        await tester.tap(find.text('Cancel'));
        await tester.pump();
        submit();
        gateway.requests.single.complete('Late success');
      } else if (outcome == 'back failure') {
        tester.state<NavigatorState>(find.byType(Navigator)).pop();
        await tester.pump();
        submit();
        gateway.requests.single.completeError(StateError('Late failure'));
      } else {
        await tester.pumpWidget(const SizedBox());
        submit();
        gateway.requests.single.completeError(StateError('Late failure'));
      }
      await tester.pumpAndSettle();
      expect(result, outcome == 'retry' ? 'Accepted' : null);
      expect(find.textContaining('Late'), findsNothing);
      expect(gateway.requests, hasLength(outcome == 'retry' ? 2 : 1));
      expect(() => controller.addListener(() {}), throwsFlutterError);
      expect(tester.takeException(), isNull);
    });
  }

  for (final size in [const Size(320, 568), const Size(740, 320)]) {
    testWidgets('test email can cancel with large text at $size', (
      tester,
    ) async {
      final gateway = _Gateway();
      await _open(tester, gateway, (_) {}, size: size, scale: 2);
      expect(find.text('Send').hitTestable(), findsOneWidget);
      expect(find.text('Cancel').hitTestable(), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Open'), findsOneWidget);
      expect(gateway.requests, isEmpty);
      expect(tester.takeException(), isNull);
    });
  }
}

Future<void> _open(
  WidgetTester tester,
  _Gateway gateway,
  ValueChanged<String?> onResult, {
  Size size = const Size(320, 568),
  double scale = 1.3,
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => DependencyScope<AdminGateway>(
        value: gateway,
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
      ),
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async => onResult(
              await showAppDialog<String>(
                context: context,
                builder: (_) => const SendTestEmailDialog(),
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
  final recipients = <String>[];
  final requests = <Completer<String>>[];

  @override
  Future<String> adminSendTestEmail(String recipient) {
    recipients.add(recipient);
    final request = Completer<String>();
    requests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
