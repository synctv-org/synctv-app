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

const _host = 'https://media.example.test/shared-family-library';
const _account = 'family-member-01234567890123456789';
const _instance = 'Shared media source for the family';
const _server = 'emby-server-01234567890123456789';

void main() {
  tearDown(AppNotifications.dismissAll);
  for (final locale in ['en', 'zh']) {
    for (final scale in [1.0, 3.0]) {
      for (final size in [const Size(320, 568), const Size(1200, 360)]) {
        for (final dark in [false, true]) {
          testWidgets('bound list $locale/$size/${scale}x dark=$dark', (
            tester,
          ) async {
            final gateway = _Gateway();
            await tester.binding.setSurfaceSize(size);
            addTearDown(() => tester.binding.setSurfaceSize(null));
            await tester.pumpWidget(
              MaterialApp(
                theme: dark ? AppTheme.dark : AppTheme.light,
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
                  body: PlatformBindingDialog(initialProviderType: 'emby'),
                ),
              ),
            );
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
            final l10n = tester
                .element(find.byType(PlatformBindingDialog))
                .l10n;
            for (final label in [_host, _instance, _server, _account]) {
              final text = find.text(label);
              expect(text, findsOneWidget, reason: label);
              await Scrollable.ensureVisible(
                tester.element(text),
                alignment: 0.5,
              );
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
            final unbind = find.byWidgetPredicate(
              (widget) =>
                  widget is AppIconButton && widget.tooltip == l10n.unbind,
            );
            await tester.ensureVisible(unbind);
            await tester.pumpAndSettle();
            expect(unbind.hitTestable(), findsOneWidget);
            await tester.tap(unbind);
            await tester.pumpAndSettle();
            expect(find.text(l10n.confirmUnbind), findsOneWidget);
            for (final value in ['$_host\n$_account', _server, _instance]) {
              final field = find.descendant(
                of: find.byType(AppDialog),
                matching: find.byWidgetPredicate(
                  (widget) =>
                      widget is AppSelectableText && widget.data == value,
                ),
              );
              expect(field, findsOneWidget, reason: value);
              await tester.ensureVisible(field);
              await tester.pumpAndSettle();
              expect(tester.widget<AppSelectableText>(field).maxLines, isNull);
              final bounds = tester.getRect(field);
              expect(bounds.left, greaterThanOrEqualTo(0));
              expect(bounds.right, lessThanOrEqualTo(size.width));
              expect(tester.takeException(), isNull);
            }
            await tester.ensureVisible(find.text(l10n.cancel));
            await tester.pumpAndSettle();
            await tester.tap(find.text(l10n.cancel));
            await tester.pumpAndSettle();
            expect(gateway.logoutCalls, 0);
            expect(
              find.text(l10n.rebindProvider('Emby')).hitTestable(),
              findsOneWidget,
            );
            expect(tester.takeException(), isNull);
          });
        }
      }
    }
  }

  testWidgets(
    'unbind identifies and submits the selected account among shared hosts',
    (tester) async {
      final gateway = _Gateway(multiple: true);
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: DependencyScope<ProviderGateway>(
            value: gateway,
            child: const Scaffold(
              body: PlatformBindingDialog(initialProviderType: 'emby'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final card = find
          .ancestor(
            of: find.text('$_account-other'),
            matching: find.byType(AppPanelSurface),
          )
          .first;
      final unbind = find.descendant(
        of: card,
        matching: find.byWidgetPredicate(
          (widget) => widget is AppIconButton && widget.tooltip == 'Unbind',
        ),
      );
      await tester.ensureVisible(unbind);
      await tester.pumpAndSettle();
      await tester.tap(unbind);
      await tester.pumpAndSettle();
      final values = tester
          .widgetList<AppSelectableText>(
            find.descendant(
              of: find.byType(AppDialog),
              matching: find.byType(AppSelectableText),
            ),
          )
          .map((field) => field.data)
          .toList();
      expect(
        values,
        containsAll(['$_host\n$_account-other', '$_server-other', _instance]),
      );
      expect(values, isNot(contains(_server)));
      expect(gateway.submittedServers, isEmpty);
      await tester.tap(find.widgetWithText(AppActionButton, 'Unbind'));
      await tester.pumpAndSettle();
      expect(gateway.submittedServers, ['$_server-other']);
      AppNotifications.dismissAll();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}

class _Gateway implements ProviderGateway {
  _Gateway({this.multiple = false});
  final bool multiple;
  int logoutCalls = 0;
  final submittedServers = <String>[];

  @override
  Future<List<EmbyBindInfo>> getAllEmbyBindInfos() async => [
    const EmbyBindInfo(
      id: 'bound',
      serverId: _server,
      host: _host,
      userId: _account,
      createdAt: 0,
      providerInstanceName: _instance,
    ),
    if (multiple)
      const EmbyBindInfo(
        id: 'other',
        serverId: '$_server-other',
        host: _host,
        userId: '$_account-other',
        createdAt: 0,
        providerInstanceName: _instance,
      ),
  ];

  @override
  Future<void> logoutEmby(String serverId) async {
    logoutCalls++;
    submittedServers.add(serverId);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName.toString().contains('getAll')) {
      return Future.value(const <Never>[]);
    }
    return super.noSuchMethod(invocation);
  }
}
