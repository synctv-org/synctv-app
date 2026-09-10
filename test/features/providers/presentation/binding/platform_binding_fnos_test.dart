import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/features/providers/presentation/binding/platform_binding_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() {
  for (final locale in ['en', 'zh']) {
    for (final size in [const Size(320, 568), const Size(1200, 900)]) {
      testWidgets('FNOS field labels $locale/$size at 3x', (tester) async {
        await tester.binding.setSurfaceSize(size);
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.light,
            locale: Locale(locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => DependencyScope<ProviderGateway>(
              value: _Gateway(),
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(3)),
                child: child!,
              ),
            ),
            home: const Scaffold(
              body: PlatformBindingDialog(initialProviderType: 'fnos'),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'binding page');
        await tester.tap(
          find.byWidgetPredicate(
            (widget) =>
                widget is AppActionButton && widget.label.contains('FNOS'),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'opened form');
        final l10n = tester.element(find.byType(PlatformBindingDialog)).l10n;
        for (final label in [
          'FNOS WebSocket / Host',
          'WebDAV URL',
          'Media API URL',
          l10n.username,
          l10n.password,
        ]) {
          final target = find.text(label);
          expect(target, findsOneWidget);
          await tester.ensureVisible(target);
          await tester.pumpAndSettle();
          final paragraph = tester.renderObject<RenderParagraph>(target);
          expect(paragraph.didExceedMaxLines, isFalse, reason: label);
          expect(tester.getRect(target).width, lessThan(size.width));
          expect(tester.takeException(), isNull, reason: label);
        }
        final fields = find.byType(TextField);
        await tester.enterText(fields.at(0), 'https://example.test');
        await tester.enterText(fields.at(3), 'preview');
        await tester.enterText(fields.at(4), 'preview-only');
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text(l10n.login));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.login));
        await tester.pumpAndSettle();
        final trust = find.text('Trust device');
        await tester.ensureVisible(trust);
        await tester.pumpAndSettle();
        final paragraph = tester.renderObject<RenderParagraph>(trust);
        expect(paragraph.didExceedMaxLines, isFalse);
        expect(paragraph.size.width, lessThan(size.width));
        await tester.ensureVisible(find.byType(Switch));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();
        expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(find.text(l10n.cancel));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.cancel));
        await tester.pumpAndSettle();
        expect(find.byType(PlatformBindingDialog), findsOneWidget);
        expect(find.byType(TextField), findsNothing);
      });
    }
  }
  for (final check in [
    'format',
    'duplicate',
    'selection',
    'setup-required',
    'cancel-success',
    'cancel-error',
    'disposed-success',
    'disposed-error',
    for (var field = 0; field < 6; field++) ...[
      'change-$field',
      'setup-change-$field',
    ],
  ]) {
    testWidgets('FNOS two-factor $check', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1000, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final gateway = _Gateway(setupRequired: check.startsWith('setup-'));
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) =>
              DependencyScope<ProviderGateway>(value: gateway, child: child!),
          home: const Scaffold(
            body: PlatformBindingDialog(initialProviderType: 'fnos'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byWidgetPredicate(
          (widget) =>
              widget is AppActionButton && widget.label.contains('FNOS'),
        ),
      );
      await tester.pumpAndSettle();
      final fields = find.byType(TextField);
      await tester.enterText(fields.at(0), 'https://example.test');
      await tester.enterText(fields.at(3), 'preview');
      await tester.enterText(fields.at(4), ' password ');
      final l10n = tester.element(find.byType(PlatformBindingDialog)).l10n;
      VoidCallback submit() => tester
          .widget<AppActionButton>(
            find.ancestor(
              of: find.text(l10n.login),
              matching: find.byType(AppActionButton),
            ),
          )
          .onPressed!;
      submit()();
      await tester.pumpAndSettle();
      expect(gateway.codes, ['']);
      if (check.contains('change-')) {
        if (!check.startsWith('setup-')) {
          await tester.enterText(fields.last, '012345');
        }
        final changedField = int.parse(check.split('-').last);
        if (changedField == 5) {
          tester
              .widget<AppSelect<String>>(find.byType(AppSelect<String>))
              .onChanged!('remote');
        } else {
          await tester.enterText(fields.at(changedField), 'changed');
        }
        await tester.pumpAndSettle();
        expect(fields, findsNWidgets(5));
        expect(find.text(l10n.fnosTwoFactorSetupRequired), findsNothing);
        submit()();
        await tester.pump();
        expect(gateway.codes, ['', '']);
        expect(
          tester
              .widgetList<TextField>(fields)
              .every((field) => field.enabled == false),
          isTrue,
        );
        expect(
          tester
              .widget<AppSelect<String>>(find.byType(AppSelect<String>))
              .enabled,
          isFalse,
        );
        gateway.pending.complete(
          const FnosTwoFactorRequiredInfo(setupRequired: false),
        );
        await tester.pumpAndSettle();
        expect(fields, findsNWidgets(6));
        expect(tester.widget<TextField>(fields.last).controller!.text, isEmpty);
        expect(
          tester
              .widgetList<TextField>(fields)
              .every((field) => field.enabled != false),
          isTrue,
        );
        await tester.ensureVisible(find.text(l10n.cancel));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.cancel));
        await tester.pumpAndSettle();
        expect(find.byType(PlatformBindingDialog), findsOneWidget);
        return;
      }
      if (check == 'setup-required') {
        expect(
          find.text(
            'Set up two-factor authentication in FNOS, then retry login.',
          ),
          findsOneWidget,
        );
        expect(fields, findsNWidgets(5));
        submit()();
        await tester.pump();
        expect(gateway.codes, ['', '']);
        gateway.pending.complete(
          const FnosTwoFactorRequiredInfo(setupRequired: false),
        );
        await tester.pumpAndSettle();
        expect(fields, findsNWidgets(6));
        expect(
          find.text(
            'Set up two-factor authentication in FNOS, then retry login.',
          ),
          findsNothing,
        );
        await tester.ensureVisible(find.text(l10n.cancel));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.cancel));
        await tester.pumpAndSettle();
        expect(find.byType(PlatformBindingDialog), findsOneWidget);
        return;
      }
      if (check == 'format') {
        for (final invalid in [
          'abcdef',
          '0x1234',
          '+12345',
          '12345',
          '1234567',
        ]) {
          await tester.enterText(fields.last, invalid);
          submit()();
          await tester.pumpAndSettle();
          expect(gateway.codes, [''], reason: invalid);
          expect(find.text(l10n.completeAllFields), findsOneWidget);
          await tester.pump(const Duration(seconds: 5));
          await tester.pumpAndSettle();
        }
      }
      await tester.enterText(fields.last, ' 012345 ');
      if (check == 'selection') {
        tester.widget<TextField>(fields.at(3)).controller!.selection =
            const TextSelection.collapsed(offset: 1);
        await tester.pumpAndSettle();
        expect(fields, findsNWidgets(6));
        expect(
          tester.widget<TextField>(fields.last).controller!.text,
          ' 012345 ',
        );
      }
      final callback = submit();
      callback();
      if (check == 'duplicate') callback();
      await tester.pump();
      expect(gateway.codes, ['', '012345']);
      expect(tester.widget<AppSwitch>(find.byType(AppSwitch)).enabled, isFalse);
      expect(gateway.passwords, everyElement(' password '));
      final canceled =
          check.startsWith('cancel-') || check.startsWith('disposed-');
      if (canceled) {
        await tester.ensureVisible(find.text(l10n.cancel));
        await tester.pump();
        await tester.tap(find.text(l10n.cancel));
        if (check.startsWith('disposed-')) await tester.pumpAndSettle();
      }
      if (check.endsWith('-error')) {
        gateway.pending.completeError(StateError('Late FNOS failure'));
      } else if (canceled) {
        gateway.pending.complete(
          const FnosAuthenticatedInfo(
            serverId: 'preview',
            hostName: 'Preview',
            version: 'test',
            mediaAvailable: true,
          ),
        );
      } else {
        gateway.pending.complete(
          const FnosTwoFactorRequiredInfo(setupRequired: false),
        );
      }
      await tester.pumpAndSettle();
      if (canceled) {
        expect(find.byType(PlatformBindingDialog), findsOneWidget);
        expect(find.text(l10n.boundSuccessfully), findsNothing);
        expect(find.textContaining('Late FNOS failure'), findsNothing);
        expect(gateway.bindLoads, 1);
      }
      await tester.pumpWidget(const SizedBox());
      callback();
      expect(tester.takeException(), isNull);
    });
  }
}

class _Gateway implements ProviderGateway {
  _Gateway({this.setupRequired = false});
  final bool setupRequired;
  int bindLoads = 0;
  final codes = <String>[];
  final passwords = <String>[];
  final pending = Completer<FnosLoginInfo>();

  @override
  Future<List<String>> listAvailableProviderInstances({
    String providerType = '',
  }) async => ['remote'];
  @override
  Future<List<FnosBindInfo>> getAllFnosBindInfos() async {
    bindLoads++;
    return [];
  }

  @override
  Future<FnosLoginInfo> loginFnos({
    required String endpoint,
    required String username,
    required String password,
    String webdavEndpoint = '',
    String mediaEndpoint = '',
    String twoFactorCode = '',
    bool trustDevice = true,
    String instanceName = '',
  }) async {
    codes.add(twoFactorCode);
    passwords.add(password);
    if (codes.length == 1) {
      return FnosTwoFactorRequiredInfo(setupRequired: setupRequired);
    }
    return pending.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName.toString().contains('getAll')) {
      return Future.value(const <Never>[]);
    }
    return super.noSuchMethod(invocation);
  }
}
