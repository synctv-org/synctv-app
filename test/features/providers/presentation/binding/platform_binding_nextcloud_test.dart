import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/features/providers/presentation/binding/platform_binding_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

const _flow = NextcloudLoginFlowInfo(
  loginUrl: 'https://cloud.example.test/login',
  pollEndpoint: 'https://cloud.example.test/poll',
  pollToken: 'preview-token',
);
const _binding = NextcloudBindInfo(
  id: 'binding',
  serverId: 'server',
  endpoint: 'https://cloud.example.test',
  username: 'preview',
  userId: 'preview',
  displayName: 'Preview',
  version: '',
  edition: '',
  createdAt: 0,
  providerInstanceName: '',
);

Future<VoidCallback> _open(
  WidgetTester tester,
  _Gateway gateway, {
  bool password = false,
  String locale = 'en',
  double scale = 1,
  Size size = const Size(1000, 1000),
  VoidCallback? beforeBind,
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
        body: PlatformBindingDialog(initialProviderType: 'nextcloud'),
      ),
    ),
  );
  await tester.pumpAndSettle();
  beforeBind?.call();
  final bindButton = find.byWidgetPredicate(
    (widget) => widget is AppActionButton && widget.label.contains('Nextcloud'),
  );
  final bindLabel = find.descendant(
    of: bindButton,
    matching: find.text(tester.widget<AppActionButton>(bindButton).label),
  );
  expect(
    tester.renderObject<RenderParagraph>(bindLabel).didExceedMaxLines,
    isFalse,
  );
  await tester.tap(
    find.byWidgetPredicate(
      (widget) =>
          widget is AppActionButton && widget.label.contains('Nextcloud'),
    ),
  );
  await tester.pumpAndSettle();
  final l10n = tester.element(find.byType(PlatformBindingDialog)).l10n;
  if (password) {
    await tester.ensureVisible(find.text(l10n.appPassword));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10n.appPassword));
    await tester.pumpAndSettle();
  }
  final fields = find.byType(TextField);
  await tester.enterText(fields.at(0), 'https://cloud.example.test');
  if (password) {
    await tester.enterText(fields.at(1), 'preview');
    await tester.enterText(fields.at(2), 'preview-only');
  }
  return tester
      .widget<AppActionButton>(
        find.byWidgetPredicate(
          (widget) =>
              widget is AppActionButton &&
              widget.label ==
                  (password
                      ? tester
                            .element(find.byType(PlatformBindingDialog))
                            .l10n
                            .login
                      : l10n.openBrowser),
        ),
      )
      .onPressed!;
}

void _replaceDialog(WidgetTester tester) {
  final context = tester.element(find.byType(PlatformBindingDialog));
  Navigator.of(context).pop();
  unawaited(
    showDialog<void>(
      context: context,
      builder: (_) => const AlertDialog(content: Text('Replacement')),
    ),
  );
}

void main() {
  const channel = MethodChannel('plugins.flutter.io/url_launcher');
  late List<String> launched;
  Completer<bool>? pendingLaunch;
  setUp(() {
    launched = [];
    pendingLaunch = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method != 'launch') return true;
          launched.add((call.arguments as Map)['url'] as String);
          return pendingLaunch?.future ?? true;
        });
  });
  tearDown(() {
    AppNotifications.dismissAll();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  for (final initiallyBound in [false, true]) {
    for (final outcome in ['success', 'failure', 'disposed']) {
      testWidgets(
        'Nextcloud pending refresh guards actions $initiallyBound/$outcome',
        (tester) async {
          final gateway = _Gateway()
            ..initiallyBound = initiallyBound
            ..refresh = Completer<List<NextcloudBindInfo>>();
          final oldActions = <VoidCallback>[];
          final submit = await _open(
            tester,
            gateway,
            password: true,
            beforeBind: () {
              oldActions.addAll(
                tester
                    .widgetList<AppActionButton>(find.byType(AppActionButton))
                    .map((button) => button.onPressed)
                    .whereType<VoidCallback>(),
              );
            },
          );
          submit();
          gateway.login.complete(_binding);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 350));
          AppNotifications.dismissAll();
          await tester.pump();
          expect(gateway.loads, 2);
          expect(find.byType(AppLinearProgress), findsOneWidget);
          final commands = tester.widgetList<AppActionButton>(
            find.byType(AppActionButton),
          );
          expect(commands, isNotEmpty);
          expect(commands.every((button) => button.onPressed == null), isTrue);
          if (initiallyBound) {
            expect(find.text(_binding.endpoint), findsOneWidget);
          }
          for (final action in oldActions) {
            action();
          }
          await tester.pump();
          expect(find.byType(TextField), findsNothing);
          expect(find.text('Confirm unbinding'), findsNothing);
          if (outcome == 'disposed') {
            await tester.pumpWidget(const SizedBox.shrink());
            gateway.refresh!.completeError(StateError('Late refresh failure'));
            await tester.pump();
          } else if (outcome == 'failure') {
            gateway.refresh!.completeError(StateError('Refresh rejected'));
            await tester.pumpAndSettle();
            expect(find.textContaining('Refresh rejected'), findsOneWidget);
            expect(find.text('Retry'), findsOneWidget);
          } else {
            gateway.refresh!.complete([_binding]);
            await tester.pumpAndSettle();
            expect(find.byType(AppLinearProgress), findsNothing);
            expect(find.text(_binding.endpoint), findsOneWidget);
            expect(
              tester
                  .widgetList<AppActionButton>(find.byType(AppActionButton))
                  .every((button) => button.onPressed != null),
              isTrue,
            );
          }
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  for (final replacement in ['removed', 'replaced', 'same']) {
    for (final action in ['Details', 'Unbind']) {
      testWidgets(
        'Nextcloud rejects old account $action after $replacement refresh',
        (tester) async {
          final gateway = _Gateway()
            ..initiallyBound = true
            ..refresh = Completer<List<NextcloudBindInfo>>();
          late VoidCallback oldAction;
          final submit = await _open(
            tester,
            gateway,
            password: true,
            beforeBind: () {
              oldAction = tester
                  .widget<AppIconButton>(
                    find.byWidgetPredicate(
                      (widget) =>
                          widget is AppIconButton && widget.tooltip == action,
                    ),
                  )
                  .onPressed!;
            },
          );
          submit();
          gateway.login.complete(_binding);
          await tester.pump();
          gateway.refresh!.complete([
            if (replacement == 'same') _binding,
            if (replacement == 'replaced')
              const NextcloudBindInfo(
                id: 'replacement',
                serverId: 'server',
                endpoint: 'https://cloud.example.test',
                username: 'replacement',
                userId: 'replacement',
                displayName: 'Replacement',
                version: '',
                edition: '',
                createdAt: 0,
                providerInstanceName: '',
              ),
          ]);
          await tester.pumpAndSettle();
          AppNotifications.dismissAll();
          await tester.pumpAndSettle();
          oldAction();
          await tester.pumpAndSettle();
          expect(gateway.loads, 2);
          expect(find.byType(AppDialog), findsNothing);
          expect(gateway.logouts, 0);
          if (replacement != 'removed') {
            final current = find.byWidgetPredicate(
              (widget) => widget is AppIconButton && widget.tooltip == action,
            );
            await tester.tap(current);
            await tester.pumpAndSettle();
            if (action == 'Unbind') {
              expect(find.text('Confirm unbinding'), findsOneWidget);
            } else {
              expect(gateway.loads, 3);
              expect(find.byType(AppDialog), findsOneWidget);
              expect(find.text('Retry'), findsNothing);
            }
            await tester.tap(
              find.widgetWithText(
                AppActionButton,
                action == 'Unbind' ? 'Cancel' : 'Close',
              ),
            );
            await tester.pumpAndSettle();
          }
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  for (final locale in ['en', 'zh']) {
    for (final size in [const Size(320, 568), const Size(1200, 900)]) {
      testWidgets('Nextcloud labels $locale/$size at 3x', (tester) async {
        await _open(
          tester,
          _Gateway(),
          password: true,
          locale: locale,
          size: size,
          scale: 3,
        );
        expect(tester.takeException(), isNull);
        for (final field
            in tester
                .widgetList<AppTextField>(find.byType(AppTextField))
                .toList()) {
          final label = find.descendant(
            of: find.byWidget(field),
            matching: find.text(field.label),
          );
          await tester.ensureVisible(label);
          await tester.pumpAndSettle();
          expect(
            tester.renderObject<RenderParagraph>(label).didExceedMaxLines,
            isFalse,
          );
          expect(tester.getRect(label).width, lessThan(size.width));
          expect(tester.takeException(), isNull);
        }
      });
    }
  }

  for (final locale in ['en', 'zh']) {
    testWidgets('instance label collisions preserve targets $locale', (
      tester,
    ) async {
      final l10n = await AppLocalizations.delegate.load(Locale(locale));
      final local = l10n.localInstance;
      final fallback = '$local (${l10n.defaultProviderInstance})';
      final names = [local, fallback, '$fallback 2', 'remote'];
      final gateway = _Gateway()..instances = names;
      await _open(tester, gateway, password: true, locale: locale);
      final selector = find.byType(AppSelect<String>);
      var control = tester.widget<AppSelect<String>>(selector);
      expect(control.options.values, ['', ...names]);
      expect(control.options.keys.toSet().length, names.length + 1);
      expect(control.value, '');
      for (final target in [...names, '']) {
        control = tester.widget<AppSelect<String>>(selector);
        final label = control.options.entries
            .singleWhere((entry) => entry.value == target)
            .key;
        await tester.ensureVisible(selector);
        await tester.pumpAndSettle();
        await tester.tap(find.byType(DropdownButton<String>));
        await tester.pumpAndSettle();
        await tester.tap(find.text(label).last);
        await tester.pumpAndSettle();
        expect(tester.widget<AppSelect<String>>(selector).value, target);
        final submit = tester
            .widget<AppActionButton>(
              find.byWidgetPredicate(
                (widget) =>
                    widget is AppActionButton && widget.label == l10n.login,
              ),
            )
            .onPressed!;
        submit();
        await tester.pump();
        expect(gateway.loginInstances.last, target);
        gateway.login.completeError(StateError('Retry'));
        await tester.pumpAndSettle();
        AppNotifications.dismissAll();
        await tester.pumpAndSettle();
        gateway.login = Completer<NextcloudBindInfo>();
        expect(tester.takeException(), isNull);
      }
    });
  }

  for (final password in [false, true]) {
    testWidgets('Nextcloud active success password=$password', (tester) async {
      final gateway = _Gateway();
      final submit = await _open(tester, gateway, password: password);
      submit();
      if (password) {
        gateway.login.complete(_binding);
      } else {
        gateway.start.complete(_flow);
        await tester.pump();
        gateway.poll.complete(_binding);
      }
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsNothing);
      expect(find.text('Account bound'), findsOneWidget);
      expect(tester.takeException(), isNull);
      AppNotifications.dismissAll();
      await tester.pumpAndSettle();
    });
  }

  testWidgets('Nextcloud password failure permits retry', (tester) async {
    final gateway = _Gateway();
    final submit = await _open(tester, gateway, password: true);
    submit();
    gateway.login.completeError(StateError('Preview failure'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widgetList<TextField>(find.byType(TextField))
          .every((field) => field.enabled == true),
      isTrue,
    );
    gateway.login = Completer<NextcloudBindInfo>();
    submit();
    expect(gateway.logins, 2);
    gateway.login.complete(_binding);
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);
    expect(tester.takeException(), isNull);
    AppNotifications.dismissAll();
    await tester.pumpAndSettle();
  });

  testWidgets('Nextcloud cancel stops retry after pending poll failure', (
    tester,
  ) async {
    final gateway = _Gateway();
    final submit = await _open(tester, gateway);
    submit();
    gateway.start.complete(_flow);
    await tester.pump();
    gateway.poll.completeError(StateError('Authorization pending'));
    await tester.pump();
    _replaceDialog(tester);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(gateway.polledInstances, ['']);
    expect(find.text('Replacement'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final password in [false, true]) {
    testWidgets('Nextcloud ignores repeated submit password=$password', (
      tester,
    ) async {
      final gateway = _Gateway();
      final submit = await _open(tester, gateway, password: password);
      submit();
      submit();
      await tester.pump();
      expect(password ? gateway.logins : gateway.starts, 1);
      await tester.pumpWidget(const SizedBox());
      if (password) {
        gateway.login.complete(_binding);
      } else {
        gateway.start.complete(_flow);
      }
      await tester.pumpAndSettle();
      expect(launched, isEmpty);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Nextcloud freezes request inputs password=$password', (
      tester,
    ) async {
      final gateway = _Gateway();
      final submit = await _open(tester, gateway, password: password);
      final changeInstance = tester
          .widget<AppSelect<String>>(find.byType(AppSelect<String>))
          .onChanged!;
      submit();
      changeInstance('remote');
      await tester.pump();
      expect(
        tester
            .widget<AppSelect<String>>(find.byType(AppSelect<String>))
            .enabled,
        isFalse,
      );
      expect(
        tester
            .widgetList<TextField>(find.byType(TextField))
            .every((field) => field.enabled == false),
        isTrue,
      );
      if (!password) {
        gateway.start.complete(_flow);
        await tester.pump();
        await tester.pump();
        expect(gateway.polledInstances, ['']);
      }
      await tester.pumpWidget(const SizedBox());
      if (password) {
        gateway.login.complete(_binding);
      } else {
        gateway.poll.complete(_binding);
      }
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  for (final stage in ['start', 'launch', 'poll', 'password']) {
    testWidgets('Nextcloud cancellation suppresses late $stage result', (
      tester,
    ) async {
      final gateway = _Gateway();
      if (stage == 'launch') pendingLaunch = Completer<bool>();
      final submit = await _open(
        tester,
        gateway,
        password: stage == 'password',
      );
      submit();
      await tester.pump();
      if (stage == 'launch' || stage == 'poll') {
        gateway.start.complete(_flow);
        await tester.pump();
        await tester.pump();
        expect(launched, [_flow.loginUrl]);
      }
      _replaceDialog(tester);
      switch (stage) {
        case 'start':
          gateway.start.complete(_flow);
        case 'launch':
          pendingLaunch!.complete(true);
        case 'poll':
          gateway.poll.complete(_binding);
        case 'password':
          gateway.login.complete(_binding);
      }
      await tester.pumpAndSettle();
      expect(find.text('Replacement'), findsOneWidget);
      if (stage == 'start') expect(launched, isEmpty);
      if (stage == 'start' || stage == 'launch') {
        expect(gateway.polledInstances, isEmpty);
      }
      expect(find.text('Account bound'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}

class _Gateway implements ProviderGateway {
  int logouts = 0;
  bool initiallyBound = false;
  int loads = 0;
  Completer<List<NextcloudBindInfo>>? refresh;

  @override
  Future<List<NextcloudBindInfo>> getAllNextcloudBindInfos() {
    loads++;
    if (loads > 1 && refresh != null) return refresh!.future;
    return Future.value(initiallyBound ? [_binding] : []);
  }

  final start = Completer<NextcloudLoginFlowInfo>();
  final poll = Completer<NextcloudBindInfo>();
  var login = Completer<NextcloudBindInfo>();
  int starts = 0;
  int logins = 0;
  final polledInstances = <String>[];
  final loginInstances = <String>[];
  List<String> instances = ['remote'];

  @override
  Future<List<String>> listAvailableProviderInstances({
    String providerType = '',
  }) async => instances;

  @override
  Future<NextcloudLoginFlowInfo> startNextcloudLoginFlow(String endpoint) {
    starts++;
    return start.future;
  }

  @override
  Future<NextcloudBindInfo> pollNextcloudLoginFlow({
    required String endpoint,
    required NextcloudLoginFlowInfo flow,
    String instanceName = '',
  }) {
    polledInstances.add(instanceName);
    return poll.future;
  }

  @override
  Future<NextcloudBindInfo> loginNextcloud({
    required String endpoint,
    required String username,
    required String appPassword,
    String instanceName = '',
  }) {
    logins++;
    loginInstances.add(instanceName);
    return login.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName.toString().contains('logoutNextcloud')) {
      logouts++;
      return Future<void>.value();
    }
    if (invocation.memberName.toString().contains('getAll')) {
      return Future.value(const <Never>[]);
    }
    return super.noSuchMethod(invocation);
  }
}
