import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/features/providers/presentation/binding/platform_binding_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

const _account = BilibiliAccountInfo(
  isLogin: true,
  userId: 1,
  username: 'Shared family account with a long display name',
  face: '',
  isVip: true,
);

void main() {
  tearDown(AppNotifications.dismissAll);

  for (final fail in [false, true]) {
    testWidgets('closed details ignore late result, failure=$fail', (
      tester,
    ) async {
      final gateway = _Gateway();
      await _open(tester, gateway);
      final context = tester.element(find.byType(PlatformBindingDialog));
      expect(find.text(context.l10n.close), findsOneWidget);
      await tester.tap(find.text(context.l10n.close));
      await tester.pumpAndSettle();
      unawaited(
        showDialog<void>(
          context: context,
          builder: (_) => const AlertDialog(content: Text('Replacement')),
        ),
      );
      if (fail) {
        gateway.requests.single.completeError(StateError('Late failure'));
      } else {
        gateway.requests.single.complete(_account);
      }
      await tester.pumpAndSettle();
      expect(find.text('Replacement'), findsOneWidget);
      expect(find.text(_account.username), findsNothing);
      expect(find.textContaining('Late failure'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('details open once and retry once after failure', (tester) async {
    final gateway = _Gateway();
    await _open(tester, gateway, duplicate: true);
    expect(gateway.requests, hasLength(1));
    expect(gateway.instances, ['family']);
    gateway.requests.single.completeError(StateError('Unavailable'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Unavailable'), findsOneWidget);
    final retry = tester
        .widget<AppActionButton>(
          find.byWidgetPredicate(
            (w) => w is AppActionButton && w.label == 'Retry',
          ),
        )
        .onPressed!;
    retry();
    retry();
    await tester.pump();
    expect(gateway.requests, hasLength(2));
    gateway.requests.last.complete(_account);
    await tester.pumpAndSettle();
    expect(find.text(_account.username), findsOneWidget);
    expect(find.textContaining('Unavailable'), findsNothing);
    expect(find.text('Retry'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final locale in ['en', 'zh']) {
    for (final size in [const Size(320, 568), const Size(1200, 360)]) {
      testWidgets('details labels $locale/$size at 3x', (tester) async {
        final gateway = _Gateway();
        await _open(tester, gateway, locale: locale, size: size, scale: 3);
        gateway.requests.single.complete(_account);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final l10n = tester.element(find.byType(PlatformBindingDialog)).l10n;
        for (final label in [
          l10n.providerDetails('Bilibili'),
          l10n.loginStatus,
          l10n.username,
          l10n.bilibiliVip,
          l10n.server,
          l10n.instance,
        ]) {
          final text = find.text(label);
          await Scrollable.ensureVisible(tester.element(text), alignment: 0.5);
          await tester.pumpAndSettle();
          final paragraph = tester.renderObject<RenderParagraph>(text);
          expect(paragraph.didExceedMaxLines, isFalse, reason: label);
          expect(tester.getSize(text).width, greaterThan(100), reason: label);
          expect(tester.getRect(text).right, lessThanOrEqualTo(size.width));
        }
        final username = find.text(_account.username);
        await Scrollable.ensureVisible(
          tester.element(username),
          alignment: 0.5,
        );
        await tester.pumpAndSettle();
        expect(tester.getRect(username).right, lessThanOrEqualTo(size.width));
        await tester.tap(find.text(l10n.close));
        await tester.pumpAndSettle();
        expect(find.text(l10n.providerDetails('Bilibili')), findsNothing);
        expect(tester.takeException(), isNull);
      });
    }
  }
}

Future<void> _open(
  WidgetTester tester,
  _Gateway gateway, {
  String locale = 'en',
  Size size = const Size(1000, 800),
  double scale = 1,
  bool duplicate = false,
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      locale: Locale(locale),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => DependencyScope<ProviderGateway>(
        value: gateway,
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
  final l10n = tester.element(find.byType(PlatformBindingDialog)).l10n;
  final button = find.byWidgetPredicate(
    (w) => w is AppActionButton && w.label == l10n.viewStatus,
  );
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  final callback = tester.widget<AppActionButton>(button).onPressed!;
  callback();
  if (duplicate) callback();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 350));
}

class _Gateway implements ProviderGateway {
  final requests = <Completer<BilibiliAccountInfo>>[];
  final instances = <String>[];
  @override
  Future<List<BilibiliBindInfo>> getAllBilibiliBindInfos() async => const [
    BilibiliBindInfo(
      id: 'bound',
      serverId: 'server',
      createdAt: 0,
      providerInstanceName: 'family',
    ),
  ];
  @override
  Future<BilibiliAccountInfo> getBilibiliAccount({String instanceName = ''}) {
    instances.add(instanceName);
    final request = Completer<BilibiliAccountInfo>();
    requests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName.toString().contains('getAll')) {
      return Future.value(const <Never>[]);
    }
    return super.noSuchMethod(invocation);
  }
}
