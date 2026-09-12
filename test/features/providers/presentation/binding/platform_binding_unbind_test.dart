import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/features/providers/presentation/binding/platform_binding_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() {
  tearDown(AppNotifications.dismissAll);

  for (final failedLogout in [false, true]) {
    testWidgets(
      'Bilibili shows pending refresh after logout failure=$failedLogout',
      (tester) async {
        final gateway = _Gateway();
        await _open(tester, gateway);
        await _confirm(tester);
        gateway.refresh = Completer<List<BilibiliBindInfo>>();
        if (failedLogout) {
          gateway.requests.single.completeError(StateError('Rejected'));
        } else {
          gateway.bound = false;
          gateway.requests.single.complete();
        }
        await tester.pump();
        AppNotifications.dismissAll();
        await tester.pump();
        expect(find.byType(AppLinearProgress), findsOneWidget);
        expect(
          tester
              .widgetList<AppActionButton>(find.byType(AppActionButton))
              .every((button) => button.onPressed == null),
          isTrue,
        );
        gateway.refresh!.complete(const []);
        await tester.pumpAndSettle();
        expect(find.byType(AppLinearProgress), findsNothing);
        expect(_button(tester, 'Bind Bilibili').onPressed, isNotNull);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final unbindFails in [false, true]) {
    testWidgets(
      'refresh failure after unbind is recoverable, failure=$unbindFails',
      (tester) async {
        final gateway = _Gateway();
        await _open(tester, gateway);
        final oldUnbind = _action(tester, 'Unbind');
        final oldDetails = _action(tester, 'View status');
        final oldRebind = _action(tester, 'Rebind');
        await _confirm(tester);
        gateway.failRefresh = true;
        if (unbindFails) {
          gateway.requests.single.completeError(StateError('Unbind rejected'));
        } else {
          gateway.bound = false;
          gateway.requests.single.complete();
        }
        await tester.pumpAndSettle();
        AppNotifications.dismissAll();
        await tester.pumpAndSettle();
        expect(find.textContaining('Refresh unavailable'), findsOneWidget);
        expect(find.text('Bilibili bound'), findsNothing);
        oldUnbind();
        oldDetails();
        oldRebind();
        await tester.pumpAndSettle();
        expect(find.text('Confirm unbinding'), findsNothing);
        expect(gateway.details, 0);
        expect(gateway.starts, 0);
        expect(
          find.widgetWithText(AppActionButton, 'Bind Bilibili'),
          findsNothing,
        );
        final retry = _action(tester, 'Retry');
        gateway.failRefresh = false;
        retry();
        retry();
        oldUnbind();
        oldDetails();
        oldRebind();
        await tester.pumpAndSettle();
        expect(gateway.details, 0);
        expect(gateway.starts, 0);
        expect(gateway.loads, 3);
        expect(gateway.requests, hasLength(1));
        expect(find.text('Retry'), findsNothing);
        if (unbindFails) {
          expect(find.text('Bilibili bound'), findsOneWidget);
          expect(_button(tester, 'Unbind').onPressed, isNotNull);
        } else {
          expect(
            find.widgetWithText(AppActionButton, 'Bind Bilibili'),
            findsOneWidget,
          );
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'unbind opens once and canceled callback cannot dismiss replacement',
    (tester) async {
      final gateway = _Gateway();
      await _open(tester, gateway);
      final unbind = _action(tester, 'Unbind');
      unbind();
      unbind();
      await tester.pumpAndSettle();
      expect(find.text('Confirm unbinding'), findsOneWidget);
      final confirm = _action(tester, 'Unbind');
      final cancel = _action(tester, 'Cancel');
      cancel();
      _replacement(tester);
      confirm();
      cancel();
      await tester.pumpAndSettle();
      expect(find.text('Replacement'), findsOneWidget);
      expect(gateway.requests, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'unbind retains account and disables conflicting actions until success',
    (tester) async {
      final gateway = _Gateway();
      await _open(tester, gateway);
      final rebind = _action(tester, 'Rebind');
      final details = _action(tester, 'View status');
      final unbind = _action(tester, 'Unbind');
      unbind();
      await tester.pumpAndSettle();
      final confirm = _action(tester, 'Unbind');
      confirm();
      confirm();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(gateway.requests, hasLength(1));
      expect(find.text('Bilibili bound'), findsOneWidget);
      for (final label in ['View status', 'Rebind', 'Unbind']) {
        expect(_button(tester, label).onPressed, isNull);
      }
      rebind();
      details();
      unbind();
      await tester.pump();
      expect(gateway.starts, 0);
      expect(gateway.details, 0);
      expect(gateway.requests, hasLength(1));
      gateway.bound = false;
      gateway.requests.single.complete();
      await tester.pumpAndSettle();
      expect(find.text('Bilibili bound'), findsNothing);
      expect(find.text('Bind Bilibili'), findsWidgets);
      AppNotifications.dismissAll();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('failed unbind retains account and permits retry', (
    tester,
  ) async {
    final gateway = _Gateway();
    await _open(tester, gateway);
    await _confirm(tester);
    gateway.requests.single.completeError(StateError('Temporary failure'));
    await tester.pumpAndSettle();
    expect(find.text('Bilibili bound'), findsOneWidget);
    expect(find.textContaining('Temporary failure'), findsOneWidget);
    AppNotifications.dismissAll();
    await tester.pumpAndSettle();
    await _confirm(tester);
    expect(gateway.requests, hasLength(2));
    gateway.bound = false;
    gateway.requests.last.complete();
    await tester.pumpAndSettle();
    expect(find.text('Bilibili bound'), findsNothing);
    AppNotifications.dismissAll();
    await tester.pumpAndSettle();
  });

  for (final failure in [false, true]) {
    testWidgets('covered unbind completion is silent, failure=$failure', (
      tester,
    ) async {
      final gateway = _Gateway();
      await _open(tester, gateway);
      await _confirm(tester);
      _replacement(tester);
      if (failure) {
        gateway.requests.single.completeError(StateError('Late failure'));
      } else {
        gateway.bound = false;
        gateway.requests.single.complete();
      }
      await tester.pumpAndSettle();
      expect(find.text('Replacement'), findsOneWidget);
      expect(find.textContaining('Late failure'), findsNothing);
      expect(find.text('Unbound successfully'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('disposed binding page cannot submit confirmed unbind', (
    tester,
  ) async {
    final gateway = _Gateway();
    final visible = ValueNotifier(true);
    addTearDown(visible.dispose);
    await _open(tester, gateway, visible: visible);
    _action(tester, 'Unbind')();
    await tester.pumpAndSettle();
    visible.value = false;
    await tester.pump();
    _action(tester, 'Unbind')();
    await tester.pumpAndSettle();
    expect(gateway.requests, isEmpty);
    expect(tester.takeException(), isNull);
  });
}

AppActionButton _button(WidgetTester tester, String label) =>
    tester.widget<AppActionButton>(
      find
          .byWidgetPredicate((w) => w is AppActionButton && w.label == label)
          .last,
    );

VoidCallback _action(WidgetTester tester, String label) =>
    _button(tester, label).onPressed!;

Future<void> _confirm(WidgetTester tester) async {
  _action(tester, 'Unbind')();
  await tester.pumpAndSettle();
  _action(tester, 'Unbind')();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 350));
}

void _replacement(WidgetTester tester) {
  final context = tester.element(find.byType(PlatformBindingDialog));
  unawaited(
    showDialog<void>(
      context: context,
      builder: (_) => const AlertDialog(content: Text('Replacement')),
    ),
  );
}

Future<void> _open(
  WidgetTester tester,
  _Gateway gateway, {
  ValueNotifier<bool>? visible,
}) async {
  await tester.binding.setSurfaceSize(const Size(1000, 800));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  const page = PlatformBindingDialog(initialProviderType: 'bilibili');
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) =>
          DependencyScope<ProviderGateway>(value: gateway, child: child!),
      home: Scaffold(
        body: visible == null
            ? page
            : ValueListenableBuilder<bool>(
                valueListenable: visible,
                builder: (_, value, _) => value ? page : const Text('Removed'),
              ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _Gateway implements ProviderGateway {
  bool bound = true;
  bool failRefresh = false;
  Completer<List<BilibiliBindInfo>>? refresh;
  int loads = 0;
  int starts = 0;
  int details = 0;
  final requests = <Completer<void>>[];
  @override
  Future<List<BilibiliBindInfo>> getAllBilibiliBindInfos() async {
    loads++;
    if (loads > 1 && refresh != null) return refresh!.future;
    if (failRefresh) throw StateError('Refresh unavailable');
    return [
      if (bound)
        const BilibiliBindInfo(
          id: 'bound',
          serverId: 'server',
          createdAt: 0,
          providerInstanceName: 'family',
        ),
    ];
  }

  @override
  Future<void> logoutBilibili() {
    final request = Completer<void>();
    requests.add(request);
    return request.future;
  }

  @override
  Future<List<String>> listAvailableProviderInstances({
    String providerType = '',
  }) async {
    starts++;
    return [];
  }

  @override
  Future<BilibiliAccountInfo> getBilibiliAccount({
    String instanceName = '',
  }) async {
    details++;
    return const BilibiliAccountInfo(
      isLogin: true,
      userId: 1,
      username: 'User',
      face: '',
      isVip: false,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName.toString().contains('getAll')) {
      return Future.value(const <Never>[]);
    }
    return super.noSuchMethod(invocation);
  }
}
