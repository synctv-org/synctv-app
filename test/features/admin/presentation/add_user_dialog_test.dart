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
  testWidgets(
    'user creation validates required fields and sends selected values',
    (tester) async {
      final gateway = _Gateway();
      await _open(tester, gateway);
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();
      expect(gateway.requests, isEmpty);
      await _fill(tester);
      final role = find.descendant(
        of: find.byType(Dialog),
        matching: find.byType(AppSelect<common.UserRole>),
      );
      final status = find.descendant(
        of: find.byType(Dialog),
        matching: find.byType(AppSelect<common.UserStatus>),
      );
      tester.widget<AppSelect<common.UserRole>>(role).onChanged!(
        common.UserRole.USER_ROLE_ADMIN,
      );
      tester.widget<AppSelect<common.UserStatus>>(status).onChanged!(
        common.UserStatus.USER_STATUS_BANNED,
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<AppSelect<common.UserRole>>(role).value,
        common.UserRole.USER_ROLE_ADMIN,
      );
      expect(
        tester.widget<AppSelect<common.UserStatus>>(status).value,
        common.UserStatus.USER_STATUS_BANNED,
      );
      await tester.tap(find.text('Create'));
      await tester.pump();
      expect(
        gateway.calls.single.positionalArguments[2],
        common.UserRole.USER_ROLE_ADMIN,
      );
      expect(
        gateway.calls.single.namedArguments[#status],
        common.UserStatus.USER_STATUS_BANNED,
      );
      expect(tester.widget<AppSelect<common.UserRole>>(role).onChanged, isNull);
      expect(
        tester.widget<AppSelect<common.UserStatus>>(status).onChanged,
        isNull,
      );
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      gateway.requests.single.complete();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  for (final locale in ['en', 'zh']) {
    testWidgets(
      'optional email rejects malformed input and permits correction $locale',
      (tester) async {
        final gateway = _Gateway();
        await _open(tester, gateway, locale: locale);
        await _fill(tester);
        final fields = find.descendant(
          of: find.byType(Dialog),
          matching: find.byType(TextField),
        );
        final submit = find.text(locale == 'en' ? 'Create' : '创建');
        for (final value in [
          'invalid',
          'user@@example.test',
          'user @example.test',
        ]) {
          await tester.enterText(fields.at(1), value);
          await tester.tap(submit);
          await tester.pumpAndSettle();
          expect(gateway.requests, isEmpty);
          expect(
            find.text(
              locale == 'en' ? 'Enter a valid email address.' : '请输入有效的邮箱地址。',
            ),
            findsOneWidget,
          );
          expect(find.text('new-user'), findsOneWidget);
        }
        await tester.enterText(fields.at(1), '  sweep+alias@example.test  ');
        await tester.tap(submit);
        await tester.pump();
        expect(
          gateway.calls.single.namedArguments[#email],
          'sweep+alias@example.test',
        );
        gateway.requests.single.complete();
        await tester.pumpAndSettle();
        expect(find.byType(Dialog), findsNothing);
        AppNotifications.dismissAll();
        await tester.pump();
      },
    );
  }

  for (final locale in ['en', 'zh']) {
    testWidgets('add user form remains usable at 3x on mobile $locale', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final gateway = _Gateway();
      await _open(tester, gateway, locale: locale, scale: 3);
      expect(tester.takeException(), isNull);
      final dialog = find.byType(Dialog);
      for (final field
          in find
              .descendant(of: dialog, matching: find.byType(TextField))
              .evaluate()) {
        await tester.ensureVisible(find.byWidget(field.widget));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      final cancel = find.text(locale == 'en' ? 'Cancel' : '取消');
      await tester.ensureVisible(cancel);
      await tester.pumpAndSettle();
      expect(cancel.hitTestable(), findsOneWidget);
      await tester.tap(cancel);
      await tester.pumpAndSettle();
      expect(dialog, findsNothing);
    });
  }

  testWidgets('user creation prevents duplicate requests and permits retry', (
    tester,
  ) async {
    final gateway = _Gateway();
    await _open(tester, gateway);
    await _fill(tester);
    final submit = tester
        .widget<AppActionButton>(find.widgetWithText(AppActionButton, 'Create'))
        .onPressed!;
    submit();
    submit();
    await tester.pump();
    expect(gateway.requests, hasLength(1));
    expect(
      tester
          .widget<AppActionButton>(
            find.widgetWithText(AppActionButton, 'Create'),
          )
          .loading,
      isTrue,
    );
    gateway.requests.single.completeError(StateError('Retry request'));
    await tester.pumpAndSettle();
    AppNotifications.dismissAll();
    await tester.pump();
    await tester.tap(find.text('Create'));
    await tester.pump();
    expect(gateway.requests, hasLength(2));
    gateway.requests.last.complete();
    await tester.pumpAndSettle();
    expect(find.text('Create'), findsNothing);
    expect(gateway.reads, 2);
    AppNotifications.dismissAll();
    await tester.pump();
  });

  for (final failure in [false, true]) {
    testWidgets(
      'late user creation response preserves replacement, failure=$failure',
      (tester) async {
        final gateway = _Gateway();
        await _open(tester, gateway);
        await _fill(tester);
        await tester.tap(find.text('Create'));
        await tester.pump();
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Add'));
        await tester.pumpAndSettle();
        if (failure) {
          gateway.requests.single.completeError(StateError('Old request'));
        } else {
          gateway.requests.single.complete();
        }
        await tester.pumpAndSettle();
        expect(find.text('Create'), findsOneWidget);
        expect(gateway.reads, 1);
        expect(find.textContaining('Old request'), findsNothing);
        expect(tester.takeException(), isNull);
        AppNotifications.dismissAll();
        await tester.pump();
      },
    );
  }
}

Future<void> _open(
  WidgetTester tester,
  _Gateway gateway, {
  String locale = 'en',
  double scale = 1,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: Locale(locale),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) => DependencyScope<AdminGateway>(
        value: gateway,
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: buildThemedTestApp(context, child),
        ),
      ),
      home: const Scaffold(body: UserManagementTab()),
    ),
  );
  await tester.pumpAndSettle();
  await tester.ensureVisible(
    find.widgetWithIcon(AppActionButton, Icons.person_add_rounded),
  );
  await tester.tap(
    find.widgetWithIcon(AppActionButton, Icons.person_add_rounded),
  );
  await tester.pumpAndSettle();
}

Future<void> _fill(WidgetTester tester) async {
  final fields = find.descendant(
    of: find.byType(Dialog),
    matching: find.byType(TextField),
  );
  await tester.enterText(fields.at(0), 'new-user');
  await tester.enterText(fields.at(2), 'test-password');
}

class _Gateway implements AdminGateway {
  final requests = <Completer<void>>[];
  final calls = <Invocation>[];
  var reads = 0;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #adminListUsersPage) {
      reads++;
      return Future.value(AdminUsersPage(users: [], total: 0));
    }
    if (invocation.memberName == #adminAddUser) {
      calls.add(invocation);
      final request = Completer<void>();
      requests.add(request);
      return request.future;
    }
    return super.noSuchMethod(invocation);
  }
}
