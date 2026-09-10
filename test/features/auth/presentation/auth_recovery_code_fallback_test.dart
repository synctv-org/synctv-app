import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/auth/presentation/auth_recovery_code_fallback.dart';

import '../../../test_app.dart';

Widget _app(Widget child) {
  return MaterialApp(
    locale: const Locale('zh'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    builder: buildThemedTestApp,
    home: Scaffold(
      body: Center(child: SizedBox(width: 420, child: child)),
    ),
  );
}

class _Harness extends StatefulWidget {
  const _Harness();

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return AuthRecoveryCodeFallback(
      active: active,
      recoveryForm: const TextField(key: ValueKey('recovery-code-test-field')),
      onOpen: () => setState(() => active = true),
      onBack: () => setState(() => active = false),
    );
  }
}

void main() {
  for (final locale in ['en', 'zh']) {
    for (final scale in [2.0, 3.0]) {
      testWidgets(
        'recovery navigation labels remain complete: $locale/$scale',
        (tester) async {
          tester.view.physicalSize = const Size(320, 568);
          tester.view.devicePixelRatio = 1;
          tester.platformDispatcher.textScaleFactorTestValue = scale;
          addTearDown(tester.view.reset);
          addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
          await tester.pumpWidget(
            MaterialApp(
              locale: Locale(locale),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              builder: buildThemedTestApp,
              home: const Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: _Harness(),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final l10n = tester
              .element(find.byType(AuthRecoveryCodeFallback))
              .l10n;
          expect(
            tester
                .renderObject<RenderParagraph>(find.text(l10n.useRecoveryCode))
                .didExceedMaxLines,
            isFalse,
          );
          await tester.tap(find.byKey(AuthRecoveryCodeFallback.openButtonKey));
          await tester.pumpAndSettle();
          expect(
            tester
                .renderObject<RenderParagraph>(
                  find.text(l10n.backToVerificationMethods),
                )
                .didExceedMaxLines,
            isFalse,
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets('recovery code form opens only after explicit selection', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const _Harness()));

    expect(find.byKey(AuthRecoveryCodeFallback.openButtonKey), findsOneWidget);
    expect(
      find.byKey(const ValueKey('recovery-code-test-field')),
      findsNothing,
    );

    await tester.tap(find.byKey(AuthRecoveryCodeFallback.openButtonKey));
    await tester.pumpAndSettle();

    expect(
      find.byKey(AuthRecoveryCodeFallback.recoveryPageKey),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('recovery-code-test-field')),
      findsOneWidget,
    );
    expect(find.text('返回验证方式'), findsOneWidget);

    await tester.tap(find.byKey(AuthRecoveryCodeFallback.backButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(AuthRecoveryCodeFallback.openButtonKey), findsOneWidget);
    expect(
      find.byKey(const ValueKey('recovery-code-test-field')),
      findsNothing,
    );
  });
}
