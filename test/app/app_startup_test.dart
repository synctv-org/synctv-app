import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/app/app_startup.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

void main() {
  testWidgets('disposed failed startup ignores a retained retry callback', (
    tester,
  ) async {
    var calls = 0;
    await tester.pumpWidget(
      AppStartup(
        initialize: () async {
          calls++;
          throw StateError('unavailable');
        },
        child: const SizedBox(),
      ),
    );
    await tester.pumpAndSettle();
    final retry = tester
        .widget<AppActionButton>(find.byType(AppActionButton))
        .onPressed!;
    await tester.pumpWidget(const SizedBox());
    retry();
    await tester.pumpAndSettle();
    expect(calls, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('synchronous initialization failure can recover on retry', (
    tester,
  ) async {
    var calls = 0;
    var readyCalls = 0;
    await tester.pumpWidget(
      AppStartup(
        initialize: () {
          if (++calls == 1) throw StateError('unavailable');
          return Future.value();
        },
        onReady: () => readyCalls++,
        child: const MaterialApp(home: Scaffold(body: Text('Ready'))),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('SyncTV could not start.'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Ready'), findsOneWidget);
    expect(readyCalls, 1);
    expect(calls, 2);
    expect(tester.takeException(), isNull);
  });

  for (final width in [320.0, 1200.0]) {
    testWidgets(
      'startup failure is retryable without duplicate work at $width',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 568));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        tester.platformDispatcher.textScaleFactorTestValue = 1.3;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final requests = <Completer<void>>[];
        var readyCalls = 0;
        await tester.pumpWidget(
          AppStartup(
            initialize: () {
              final request = Completer<void>();
              requests.add(request);
              return request.future;
            },
            onReady: () => readyCalls++,
            child: const MaterialApp(
              home: Scaffold(body: Text('Application ready')),
            ),
          ),
        );
        expect(find.byType(AppLinearProgress), findsOneWidget);
        expect(find.text('Application ready'), findsNothing);
        requests.single.completeError(StateError('storage unavailable'));
        await tester.pumpAndSettle();
        expect(find.text('SyncTV could not start.'), findsOneWidget);
        expect(find.textContaining('storage unavailable'), findsNothing);
        final retry = tester.widget<AppActionButton>(
          find.byType(AppActionButton),
        );
        expect(
          tester.getRect(find.byType(AppActionButton)).bottom,
          lessThanOrEqualTo(568),
        );
        retry.onPressed!();
        retry.onPressed!();
        await tester.pump();
        expect(requests, hasLength(2));
        expect(find.byType(AppLinearProgress), findsOneWidget);
        requests.last.complete();
        await tester.pumpAndSettle();
        expect(find.text('Application ready'), findsOneWidget);
        expect(readyCalls, 1);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final fail in [false, true]) {
    testWidgets('disposed startup ignores delayed result, failure=$fail', (
      tester,
    ) async {
      final pending = Completer<void>();
      var readyCalls = 0;
      await tester.pumpWidget(
        AppStartup(
          initialize: () => pending.future,
          onReady: () => readyCalls++,
          child: const SizedBox(),
        ),
      );
      await tester.pumpWidget(const SizedBox());
      if (fail) {
        pending.completeError(StateError('late initialization failure'));
      } else {
        pending.complete();
      }
      await tester.pumpAndSettle();
      expect(readyCalls, 0);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'startup preserves the initial callback path for the application',
    (tester) async {
      const route = '/oauth2/callback?code=test-code';
      tester.platformDispatcher.defaultRouteNameTestValue = route;
      addTearDown(tester.platformDispatcher.clearDefaultRouteNameTestValue);
      final pending = Completer<void>();
      await tester.pumpWidget(
        AppStartup(
          initialize: () => pending.future,
          child: MaterialApp(
            onGenerateRoute: (settings) => MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => Scaffold(body: Text(settings.name!)),
            ),
          ),
        ),
      );
      expect(find.byType(Navigator), findsNothing);
      pending.complete();
      await tester.pumpAndSettle();
      expect(find.text(route), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
