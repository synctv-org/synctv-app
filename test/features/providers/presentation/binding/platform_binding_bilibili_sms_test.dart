import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/providers/application/desktop_web_verification_client.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/features/providers/presentation/binding/platform_binding_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

const _session = BilibiliSmsLoginInfo(
  sessionToken: 'prepared',
  gt: 'test',
  challenge: 'test',
  expiresAt: 0,
);

void main() {
  tearDown(() {
    AppNotifications.dismissAll();
  });

  for (final locale in ['en', 'zh']) {
    for (final size in [const Size(320, 568), const Size(1200, 800)]) {
      testWidgets('Bilibili SMS labels $locale/$size at 3x', (tester) async {
        await _open(
          tester,
          _Gateway(),
          _Verifier(),
          locale: locale,
          size: size,
          scale: 3,
        );
        expect(tester.takeException(), isNull);
        final l10n = tester.element(find.byType(PlatformBindingDialog)).l10n;
        for (final label in [
          l10n.verificationCode,
          l10n.phoneNumber,
          l10n.smsVerificationCode,
          l10n.verifyAgain,
          l10n.sendSms,
          l10n.bind,
          l10n.cancel,
        ]) {
          final text = find.text(label).last;
          await tester.ensureVisible(text);
          await tester.pumpAndSettle();
          expect(
            tester.renderObject<RenderParagraph>(text).didExceedMaxLines,
            isFalse,
            reason: label,
          );
          final rect = tester.getRect(text);
          expect(rect.left, greaterThanOrEqualTo(0), reason: label);
          expect(rect.right, lessThanOrEqualTo(size.width), reason: label);
          expect(tester.takeException(), isNull);
        }
        await tester.tap(find.text(l10n.cancel));
        await tester.pumpAndSettle();
        expect(find.byType(TextField), findsNothing);
      }, variant: TargetPlatformVariant.only(TargetPlatform.linux));
    }
  }

  for (final leave in ['close', 'switch', 'return']) {
    for (final stage in ['captcha', 'send', 'login']) {
      testWidgets('SMS $stage ignores $leave before completion', (
        tester,
      ) async {
        final gateway = _Gateway();
        final verifier = _Verifier();
        await _open(tester, gateway, verifier);
        await _send(tester);
        if (stage != 'captcha') {
          verifier.pending.single.complete('{"validate":"test"}');
          await tester.pump();
        }
        if (stage == 'login') {
          gateway.sent.complete(_session.copyWith(sessionToken: 'sent'));
          await tester.pumpAndSettle();
          await tester.enterText(find.byType(TextField).at(1), '123456');
          _login(tester)();
          await tester.pump();
        }
        final initialLoads = gateway.bindLoads;
        if (leave == 'close') {
          final context = tester.element(find.byType(PlatformBindingDialog));
          Navigator.of(context).pop();
          unawaited(
            showDialog<void>(
              context: context,
              builder: (_) => const AlertDialog(content: Text('Replacement')),
            ),
          );
        } else {
          await tester.tap(find.text('QR code'));
          await tester.pump();
          if (leave == 'return') {
            await tester.pump(const Duration(milliseconds: 350));
            await tester.tap(find.text('Verification code'));
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 350));
          }
        }
        switch (stage) {
          case 'captcha':
            verifier.pending.single.complete('{"validate":"test"}');
          case 'send':
            gateway.sent.complete(_session.copyWith(sessionToken: 'sent'));
          case 'login':
            gateway.loggedIn.complete();
        }
        await tester.pumpAndSettle();
        expect(gateway.sends, stage == 'captcha' ? 0 : 1);
        expect(gateway.bindLoads, initialLoads);
        expect(
          find.text(leave == 'close' ? 'Replacement' : 'QR code'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      }, variant: TargetPlatformVariant.only(TargetPlatform.linux));
    }
  }

  testWidgets('SMS rejects duplicate sends and logins, then succeeds', (
    tester,
  ) async {
    final gateway = _Gateway();
    final verifier = _Verifier();
    await _open(tester, gateway, verifier);
    await tester.enterText(find.byType(TextField).first, '15500000000');
    final send = _action(tester, 'Send SMS');
    send();
    send();
    await tester.pump();
    expect(verifier.pending, hasLength(1));
    for (final field in tester.widgetList<TextField>(find.byType(TextField))) {
      expect(field.enabled, isFalse);
    }
    verifier.pending.single.complete('{"validate":"test"}');
    await tester.pump();
    expect(gateway.sends, 1);
    gateway.sent.complete(_session.copyWith(sessionToken: 'sent'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(1), '123456');
    final login = _login(tester);
    login();
    login();
    await tester.pump();
    expect(gateway.logins, ['sent']);
    final initialLoads = gateway.bindLoads;
    gateway.loggedIn.complete();
    await tester.pumpAndSettle();
    expect(gateway.bindLoads, initialLoads + 1);
    expect(find.byType(TextField), findsNothing);
    AppNotifications.dismissAll();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }, variant: TargetPlatformVariant.only(TargetPlatform.linux));

  testWidgets('SMS prepared session cannot log in before sending', (
    tester,
  ) async {
    final gateway = _Gateway();
    await _open(tester, gateway, _Verifier());
    await tester.enterText(find.byType(TextField).at(1), '123456');
    _login(tester)();
    await tester.pump();
    expect(gateway.logins, isEmpty);
    AppNotifications.dismissAll();
    await tester.pumpAndSettle();
  }, variant: TargetPlatformVariant.only(TargetPlatform.linux));

  testWidgets('SMS phone change invalidates the sent code and session', (
    tester,
  ) async {
    final gateway = _Gateway();
    final verifier = _Verifier();
    await _open(tester, gateway, verifier);
    await _send(tester);
    verifier.pending.single.complete('{"validate":"test"}');
    await tester.pump();
    gateway.sent.complete(_session.copyWith(sessionToken: 'sent'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(1), '123456');
    await tester.enterText(find.byType(TextField).first, '15500000001');
    await tester.pump();
    expect(
      find.text('Switch to the code tab to prepare security verification'),
      findsNothing,
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(1)).controller!.text,
      isEmpty,
    );
    _login(tester)();
    await tester.pump();
    expect(gateway.logins, isEmpty);
    AppNotifications.dismissAll();
    await tester.pumpAndSettle();
  }, variant: TargetPlatformVariant.only(TargetPlatform.linux));

  testWidgets('SMS old session creation cannot replace a reactivated session', (
    tester,
  ) async {
    final gateway = _Gateway();
    final verifier = _Verifier();
    await _open(tester, gateway, verifier);
    gateway.pendingStarts = [];
    _action(tester, 'Verify again')();
    await tester.pump();
    await tester.tap(find.text('QR code'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.tap(find.text('Verification code'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(gateway.pendingStarts, hasLength(2));
    gateway.pendingStarts!.last.complete(
      _session.copyWith(sessionToken: 'new'),
    );
    await tester.pumpAndSettle();
    gateway.pendingStarts!.first.complete(
      _session.copyWith(sessionToken: 'old'),
    );
    await tester.pumpAndSettle();
    await _send(tester);
    verifier.pending.single.complete('{"validate":"test"}');
    await tester.pump();
    expect(gateway.sentTokens, ['new']);
    gateway.sent.complete(_session.copyWith(sessionToken: 'sent'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }, variant: TargetPlatformVariant.only(TargetPlatform.linux));
}

VoidCallback _login(WidgetTester tester) => tester
    .widget<AppActionButton>(
      find.byWidgetPredicate((w) => w is AppActionButton && w.label == 'Bind'),
    )
    .onPressed!;

VoidCallback _action(WidgetTester tester, String label) => tester
    .widget<AppInkSurface>(
      find
          .ancestor(of: find.text(label), matching: find.byType(AppInkSurface))
          .first,
    )
    .onTap!;

Future<void> _send(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).first, '15500000000');
  _action(tester, 'Send SMS')();
  await tester.pump();
}

Future<void> _open(
  WidgetTester tester,
  _Gateway gateway,
  _Verifier verifier, {
  String locale = 'en',
  double scale = 1,
  Size size = const Size(1000, 1000),
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      locale: Locale(locale),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => DependencyRegistryScope(
        values: {
          ProviderGateway: gateway,
          DesktopWebVerificationClient: verifier,
        },
        child: MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        ),
      ),
      home: const Scaffold(
        body: PlatformBindingDialog(initialProviderType: 'bilibili'),
      ),
    ),
  );
  await tester.pumpAndSettle();
  final bind = find.byWidgetPredicate(
    (w) => w is AppActionButton && w.label.contains('Bilibili'),
  );
  await tester.ensureVisible(bind);
  await tester.pumpAndSettle();
  await tester.tap(bind);
  await tester.pumpAndSettle();
  final l10n = tester.element(find.byType(PlatformBindingDialog)).l10n;
  await Scrollable.ensureVisible(
    tester.element(find.text(l10n.verificationCode)),
    alignment: 0.5,
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text(l10n.verificationCode));
  await tester.pumpAndSettle();
}

class _Verifier implements DesktopWebVerificationClient {
  final pending = <Completer<String>>[];
  @override
  bool get supported => true;
  @override
  Future<String> verify({
    required String html,
    required String bridgeName,
    required String title,
    required double windowWidth,
    required double windowHeight,
    required Duration timeout,
    String? browserPath,
    Map<String, String> browserFragmentParameters = const {},
  }) {
    final result = Completer<String>();
    pending.add(result);
    return result.future;
  }
}

class _Gateway implements ProviderGateway {
  final sent = Completer<BilibiliSmsLoginInfo>();
  final loggedIn = Completer<void>();
  int sends = 0;
  int bindLoads = 0;
  final logins = <String>[];
  final sentTokens = <String>[];
  List<Completer<BilibiliSmsLoginInfo>>? pendingStarts;
  @override
  Future<List<String>> listAvailableProviderInstances({
    String providerType = '',
  }) async => ['alternate'];
  @override
  Future<BilibiliQrLoginInfo> startBilibiliQrLogin({
    String instanceName = '',
  }) async => throw StateError('QR unavailable');
  @override
  Future<BilibiliSmsLoginInfo> startBilibiliSmsLogin({
    String instanceName = '',
  }) async {
    if (pendingStarts == null) return _session;
    final result = Completer<BilibiliSmsLoginInfo>();
    pendingStarts!.add(result);
    return result.future;
  }

  @override
  Future<BilibiliSmsLoginInfo> sendBilibiliSms({
    required BilibiliSmsLoginInfo session,
    required String phone,
    required String validate,
  }) {
    sends++;
    sentTokens.add(session.sessionToken);
    return sent.future;
  }

  @override
  Future<void> loginBilibiliSms({
    required String sessionToken,
    required String code,
  }) {
    logins.add(sessionToken);
    return loggedIn.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName.toString().contains('getAll')) {
      bindLoads++;
      return Future.value(const <Never>[]);
    }
    return super.noSuchMethod(invocation);
  }
}
