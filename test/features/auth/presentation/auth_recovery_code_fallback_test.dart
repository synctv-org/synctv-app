import 'package:flutter/material.dart';
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
