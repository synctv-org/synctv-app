import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/features/providers/presentation/binding/platform_binding_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() {
  tearDown(AppNotifications.dismissAll);
  for (final provider in ['emby', 'bilibili']) {
    for (final locale in ['en', 'zh']) {
      for (final size in [const Size(320, 568), const Size(1200, 360)]) {
        testWidgets('$provider load error retries at $locale/$size/3x', (
          tester,
        ) async {
          final gateway = _Gateway(provider);
          await _open(
            tester,
            gateway,
            provider: provider,
            locale: locale,
            size: size,
          );
          final l10n = tester.element(find.byType(PlatformBindingDialog)).l10n;
          final label = provider == 'emby' ? 'Emby' : 'Bilibili';
          gateway.requests.single.completeError(
            StateError('Provider temporarily unavailable'),
          );
          await tester.pumpAndSettle();
          expect(find.text(l10n.noBoundProviderAccounts(label)), findsNothing);
          expect(find.text(l10n.bindProvider(label)), findsNothing);
          final retry = find.byWidgetPredicate(
            (widget) => widget is AppActionButton && widget.label == l10n.retry,
          );
          expect(retry, findsOneWidget);
          final error = find.text(
            l10n.loadProviderBindingsFailed(
              label,
              'Bad state: Provider temporarily unavailable',
            ),
          );
          expect(error, findsOneWidget);
          expect(
            tester.renderObject<RenderParagraph>(error).didExceedMaxLines,
            isFalse,
          );
          expect(tester.getRect(error).right, lessThanOrEqualTo(size.width));
          await tester.ensureVisible(retry);
          await tester.pumpAndSettle();
          final staleRetry = tester.widget<AppActionButton>(retry).onPressed!;
          await tester.tap(retry);
          staleRetry();
          await tester.pump();
          expect(gateway.requests, hasLength(2));
          gateway.requests.last.complete(const []);
          await tester.pumpAndSettle();
          expect(retry, findsNothing);
          expect(
            find.widgetWithText(AppActionButton, l10n.bindProvider(label)),
            findsOneWidget,
          );
          staleRetry();
          await tester.pump();
          expect(gateway.requests, hasLength(2));
          expect(tester.takeException(), isNull);
        });
      }
    }
  }

  testWidgets('background provider failure stays in its tab without a toast', (
    tester,
  ) async {
    final gateway = _Gateway('emby');
    await _open(tester, gateway, provider: 'bilibili', scale: 1);
    gateway.requests.single.completeError(StateError('Background failure'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Background failure'), findsNothing);
    expect(
      find.widgetWithText(AppActionButton, 'Bind Bilibili'),
      findsOneWidget,
    );
    await tester.tap(find.text('Emby'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Background failure'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    final retry = tester
        .widget<AppActionButton>(find.widgetWithText(AppActionButton, 'Retry'))
        .onPressed!;
    await tester.tap(find.text('Bilibili'));
    await tester.pumpAndSettle();
    retry();
    await tester.pump();
    expect(gateway.requests, hasLength(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('disposed retry ignores late failure and captured callback', (
    tester,
  ) async {
    final gateway = _Gateway('emby');
    await _open(tester, gateway, provider: 'emby', scale: 1);
    gateway.requests.single.completeError(StateError('Initial failure'));
    await tester.pumpAndSettle();
    final retry = tester
        .widget<AppActionButton>(find.widgetWithText(AppActionButton, 'Retry'))
        .onPressed!;
    retry();
    await tester.pump();
    expect(gateway.requests, hasLength(2));
    await tester.pumpWidget(const SizedBox.shrink());
    gateway.requests.last.completeError(StateError('Late failure'));
    retry();
    await tester.pumpAndSettle();
    expect(gateway.requests, hasLength(2));
    expect(tester.takeException(), isNull);
  });
}

Future<void> _open(
  WidgetTester tester,
  _Gateway gateway, {
  required String provider,
  String locale = 'en',
  Size size = const Size(1200, 800),
  double scale = 3,
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
      home: Scaffold(
        body: PlatformBindingDialog(initialProviderType: provider),
      ),
    ),
  );
  await tester.pump();
}

class _Gateway implements ProviderGateway {
  _Gateway(this.provider);
  final String provider;
  final requests = <Completer<List<Never>>>[];

  @override
  dynamic noSuchMethod(Invocation invocation) {
    final name = invocation.memberName.toString();
    final target = provider == 'emby'
        ? 'getAllEmbyBindInfos'
        : 'getAllBilibiliBindInfos';
    if (name.contains(target)) {
      final request = Completer<List<Never>>();
      requests.add(request);
      return request.future;
    }
    if (name.contains('getAll')) return Future.value(const <Never>[]);
    return super.noSuchMethod(invocation);
  }
}
