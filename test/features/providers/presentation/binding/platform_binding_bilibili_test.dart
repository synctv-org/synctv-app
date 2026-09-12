import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/features/providers/presentation/binding/platform_binding_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/providers/bilibili.pbenum.dart'
    as bilibili;

import '../../../../test_app.dart';

void main() {
  tearDown(AppNotifications.dismissAll);
  for (final action in ['Copy link', 'Open login']) {
    for (final scenario in [
      'success',
      'failure',
      if (action == 'Open login') 'rejected',
      'canceled success',
      'canceled failure',
      'mode replaced',
      'instance replaced',
    ]) {
      testWidgets('QR $action handles $scenario and duplicate taps', (
        tester,
      ) async {
        final completion = Completer<Object?>();
        final channel = action == 'Copy link'
            ? SystemChannels.platform
            : const MethodChannel('plugins.flutter.io/url_launcher');
        final calls = <String>[];
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          (call) async {
            if (call.method != 'Clipboard.setData' && call.method != 'launch') {
              return action == 'Copy link' ? null : true;
            }
            final args = call.arguments as Map;
            calls.add(args[action == 'Copy link' ? 'text' : 'url'] as String);
            return completion.future;
          },
        );
        addTearDown(
          () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            channel,
            null,
          ),
        );
        final gateway = _Gateway();
        await _pump(tester, gateway);
        gateway.starts.single.complete(
          const BilibiliQrLoginInfo(url: 'https://example.test/qr', key: 'qr'),
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text(action));
        await tester.pumpAndSettle();
        await tester.tap(find.text(action));
        await tester.tap(find.text(action));
        await tester.pump();
        expect(calls, ['https://example.test/qr']);
        if (scenario.startsWith('canceled')) {
          final context = tester.element(find.byType(PlatformBindingDialog));
          Navigator.of(context).pop();
          unawaited(
            showDialog<void>(
              context: context,
              builder: (_) => const AlertDialog(content: Text('Replacement')),
            ),
          );
        } else if (scenario == 'mode replaced') {
          final change = tester
              .widget<AppSegmentedControl<int>>(
                find.byType(AppSegmentedControl<int>),
              )
              .onChanged;
          change(1);
          change(0);
        } else if (scenario == 'instance replaced') {
          _changeInstance(tester);
          gateway.starts.last.complete(
            const BilibiliQrLoginInfo(
              url: 'https://example.test/replaced',
              key: 'replaced',
            ),
          );
        }
        if (scenario.endsWith('success')) {
          completion.complete(true);
        } else if (scenario == 'rejected') {
          completion.complete(false);
        } else {
          completion.completeError(
            PlatformException(code: 'unavailable', message: 'Preview failure'),
          );
        }
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final l10n = tester.element(find.byType(PlatformBindingDialog)).l10n;
        expect(
          find.text(l10n.loginLinkCopied),
          action == 'Copy link' && scenario == 'success'
              ? findsOneWidget
              : findsNothing,
        );
        expect(
          find.text(l10n.openLoginLinkFailed),
          action == 'Open login' &&
                  (scenario == 'failure' || scenario == 'rejected')
              ? findsOneWidget
              : findsNothing,
        );
        expect(
          find.textContaining('Preview failure'),
          action == 'Copy link' && scenario == 'failure'
              ? findsOneWidget
              : findsNothing,
        );
        if (scenario.startsWith('canceled')) {
          expect(find.text('Replacement'), findsOneWidget);
        }
        AppNotifications.dismissAll();
        await tester.pumpAndSettle();
        await tester.pumpWidget(const SizedBox());
      });
    }
  }

  for (final stage in ['instances', 'create', 'poll']) {
    testWidgets('canceled QR $stage cannot continue or dismiss replacement', (
      tester,
    ) async {
      final gateway = _Gateway();
      if (stage == 'instances') gateway.instances = Completer<List<String>>();
      await _pump(tester, gateway, pendingInstances: stage == 'instances');
      final initialBindLoads = gateway.bindLoads;
      if (stage == 'poll') {
        gateway.starts.single.complete(
          const BilibiliQrLoginInfo(url: 'https://example.test/qr', key: 'qr'),
        );
        await tester.pump();
        expect(gateway.polls, hasLength(1));
      }
      final context = tester.element(find.byType(PlatformBindingDialog));
      Navigator.of(context).pop();
      unawaited(
        showDialog<void>(
          context: context,
          builder: (_) => const AlertDialog(content: Text('Replacement')),
        ),
      );
      switch (stage) {
        case 'instances':
          gateway.instances!.complete(['alternate']);
        case 'create':
          gateway.starts.single.complete(
            const BilibiliQrLoginInfo(
              url: 'https://example.test/qr',
              key: 'qr',
            ),
          );
        case 'poll':
          gateway.polls.single.complete(
            bilibili.QRLoginStatus.QR_LOGIN_STATUS_SUCCESS,
          );
      }
      await tester.pumpAndSettle();
      expect(find.text('Replacement'), findsOneWidget);
      expect(gateway.starts, hasLength(stage == 'instances' ? 0 : 1));
      expect(gateway.polls, hasLength(stage == 'poll' ? 1 : 0));
      expect(gateway.bindLoads, initialBindLoads);
      await tester.pump(const Duration(seconds: 6));
      expect(gateway.polls, hasLength(stage == 'poll' ? 1 : 0));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('current QR success refreshes bindings once and closes', (
    tester,
  ) async {
    final gateway = _Gateway();
    await _pump(tester, gateway);
    final initialBindLoads = gateway.bindLoads;
    gateway.starts.single.complete(
      const BilibiliQrLoginInfo(url: 'https://example.test/qr', key: 'qr'),
    );
    await tester.pump();
    gateway.polls.single.complete(
      bilibili.QRLoginStatus.QR_LOGIN_STATUS_SUCCESS,
    );
    await tester.pumpAndSettle();
    expect(gateway.bindLoads, initialBindLoads + 1);
    expect(find.byType(QrImageView), findsNothing);
    AppNotifications.dismissAll();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 6));
    expect(gateway.polls, hasLength(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('failed QR creation can retry without duplicate requests', (
    tester,
  ) async {
    final gateway = _Gateway();
    await _pump(tester, gateway);
    gateway.starts.single.completeError(StateError('Temporary failure'));
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);
    await tester.ensureVisible(find.text('Retry'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Retry'));
    await tester.tap(find.text('Retry'));
    await tester.pump();
    expect(gateway.starts, hasLength(2));
    gateway.starts.last.complete(
      const BilibiliQrLoginInfo(
        url: 'https://example.test/retry',
        key: 'retry',
      ),
    );
    await tester.pump();
    expect(gateway.pollKeys.single, ('retry', ''));
    expect(find.textContaining('Temporary failure'), findsNothing);
    await tester.pumpWidget(const SizedBox());
    expect(tester.takeException(), isNull);
  });

  for (final failOld in [false, true]) {
    testWidgets('QR creation ignores replaced instances, failure=$failOld', (
      tester,
    ) async {
      final gateway = _Gateway();
      await _pump(tester, gateway);
      _changeInstance(tester);
      await tester.pump();
      gateway.starts[1].complete(
        const BilibiliQrLoginInfo(
          url: 'https://example.com/current',
          key: 'current',
        ),
      );
      await tester.pump();
      if (failOld) {
        gateway.starts[0].completeError(StateError('stale creation'));
      } else {
        gateway.starts[0].complete(
          const BilibiliQrLoginInfo(url: 'https://example.com/old', key: 'old'),
        );
      }
      await tester.pump();
      expect(find.text('https://example.com/current'), findsOneWidget);
      expect(find.text('https://example.com/old'), findsNothing);
      expect(gateway.polls, hasLength(1));
      expect(gateway.pollKeys.single, ('current', 'alternate'));
      expect(find.textContaining('stale creation'), findsNothing);
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    });
  }

  for (final oldOutcome in ['success', 'expired', 'error']) {
    testWidgets('old QR poll $oldOutcome cannot affect the current login', (
      tester,
    ) async {
      final gateway = _Gateway();
      await _pump(tester, gateway);
      gateway.starts[0].complete(
        const BilibiliQrLoginInfo(url: 'https://example.com/old', key: 'old'),
      );
      await tester.pump();
      _changeInstance(tester);
      await tester.pump();
      gateway.starts[1].complete(
        const BilibiliQrLoginInfo(
          url: 'https://example.com/current',
          key: 'current',
        ),
      );
      await tester.pump();
      expect(gateway.polls, hasLength(2));
      if (oldOutcome == 'error') {
        gateway.polls[0].completeError(StateError('429 stale poll'));
      } else {
        gateway.polls[0].complete(
          oldOutcome == 'success'
              ? bilibili.QRLoginStatus.QR_LOGIN_STATUS_SUCCESS
              : bilibili.QRLoginStatus.QR_LOGIN_STATUS_EXPIRED,
        );
      }
      await tester.pump(const Duration(seconds: 6));
      expect(find.byType(QrImageView), findsOneWidget);
      expect(gateway.polls, hasLength(2));
      expect(find.textContaining('429 stale poll'), findsNothing);
      gateway.polls[1].complete(
        bilibili.QRLoginStatus.QR_LOGIN_STATUS_NOT_SCANNED,
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 5));
      expect(gateway.polls, hasLength(3));
      expect(gateway.pollKeys.last, ('current', 'alternate'));
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    });
  }
}

void _changeInstance(WidgetTester tester) {
  tester.widget<AppSelect<String>>(find.byType(AppSelect<String>)).onChanged!(
    'alternate',
  );
}

Future<void> _pump(
  WidgetTester tester,
  _Gateway gateway, {
  bool pendingInstances = false,
}) async {
  await tester.binding.setSurfaceSize(const Size(900, 950));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => DependencyScope<ProviderGateway>(
        value: gateway,
        child: buildThemedTestApp(context, child),
      ),
      home: const Scaffold(
        body: PlatformBindingDialog(initialProviderType: 'bilibili'),
      ),
    ),
  );
  await tester.pumpAndSettle();
  final button = find.byWidgetPredicate(
    (widget) => widget is AppActionButton && widget.label.contains('Bilibili'),
  );
  await tester.tap(button);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
  expect(gateway.starts, hasLength(pendingInstances ? 0 : 1));
}

class _Gateway implements ProviderGateway {
  final starts = <Completer<BilibiliQrLoginInfo>>[];
  final polls = <Completer<bilibili.QRLoginStatus>>[];
  final pollKeys = <(String, String)>[];
  Completer<List<String>>? instances;
  int bindLoads = 0;

  @override
  Future<List<String>> listAvailableProviderInstances({
    String providerType = '',
  }) async => instances == null ? ['alternate'] : await instances!.future;

  @override
  Future<BilibiliQrLoginInfo> startBilibiliQrLogin({String instanceName = ''}) {
    final result = Completer<BilibiliQrLoginInfo>();
    starts.add(result);
    return result.future;
  }

  @override
  Future<bilibili.QRLoginStatus> checkBilibiliQrLogin(
    String key, {
    String instanceName = '',
  }) {
    pollKeys.add((key, instanceName));
    final result = Completer<bilibili.QRLoginStatus>();
    polls.add(result);
    return result.future;
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
