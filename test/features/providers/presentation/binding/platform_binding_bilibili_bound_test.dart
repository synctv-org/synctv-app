import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/features/providers/presentation/binding/platform_binding_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

const _instance = 'Shared media source for the family';
const _server = 'bilibili-server-01234567890123456789';

void main() {
  for (final locale in ['en', 'zh']) {
    for (final scale in [1.0, 3.0]) {
      for (final size in [const Size(320, 568), const Size(1200, 360)]) {
        testWidgets('bound Bilibili $locale/$size at ${scale}x', (
          tester,
        ) async {
          final gateway = _Gateway();
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
          expect(tester.takeException(), isNull);
          final l10n = tester.element(find.byType(PlatformBindingDialog)).l10n;
          for (final label in [
            _instance,
            _server,
            l10n.viewStatus,
            l10n.rebind,
            l10n.unbind,
          ]) {
            final text = find.text(label);
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
          await tester.tap(find.text(l10n.unbind));
          await tester.pumpAndSettle();
          expect(find.text(l10n.confirmUnbind), findsOneWidget);
          expect(
            tester
                .renderObject<RenderParagraph>(find.text(l10n.confirmUnbind))
                .didExceedMaxLines,
            isFalse,
          );
          await tester.ensureVisible(find.text(l10n.cancel));
          await tester.pumpAndSettle();
          await tester.tap(find.text(l10n.cancel));
          await tester.pumpAndSettle();
          expect(gateway.logoutCalls, 0);
          expect(find.text(l10n.bilibiliBound), findsOneWidget);
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}

class _Gateway implements ProviderGateway {
  int logoutCalls = 0;

  @override
  Future<List<BilibiliBindInfo>> getAllBilibiliBindInfos() async => const [
    BilibiliBindInfo(
      id: 'bound',
      serverId: _server,
      createdAt: 0,
      providerInstanceName: _instance,
    ),
  ];

  @override
  Future<void> logoutBilibili() async {
    logoutCalls++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName.toString().contains('getAll')) {
      return Future.value(const <Never>[]);
    }
    return super.noSuchMethod(invocation);
  }
}
