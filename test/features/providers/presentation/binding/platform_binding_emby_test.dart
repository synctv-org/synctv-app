import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/providers/presentation/binding/platform_binding_dialog.dart';
import 'package:synctv_app/l10n/app_localizations.dart';

void main() {
  testWidgets('Emby passwordless mode is explicit and submits empty password', (
    tester,
  ) async {
    Map<String, Object?>? submission;
    await _pumpEmbyForm(
      tester,
      onBind:
          ({
            required host,
            required username,
            required password,
            required apiKey,
            required passwordless,
            required instanceName,
          }) async {
            submission = {
              'host': host,
              'username': username,
              'password': password,
              'apiKey': apiKey,
              'passwordless': passwordless,
              'instanceName': instanceName,
            };
          },
    );

    await tester.enterText(
      find.byKey(const Key('emby-bind-host')),
      'https://emby.example',
    );
    await tester.enterText(
      find.byKey(const Key('emby-bind-username')),
      'guest',
    );

    await tester.tap(find.text('Log in'));
    await tester.pump();
    expect(submission, isNull);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    await _selectCredentialMode(tester, 2);
    expect(find.byKey(const Key('emby-bind-password')), findsNothing);
    expect(find.byKey(const Key('emby-bind-api-key')), findsNothing);

    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(submission, {
      'host': 'https://emby.example',
      'username': 'guest',
      'password': '',
      'apiKey': '',
      'passwordless': true,
      'instanceName': '',
    });
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('Emby credential modes show only their matching input', (
    tester,
  ) async {
    await _pumpEmbyForm(tester);

    expect(find.byKey(const Key('emby-bind-password')), findsOneWidget);
    expect(find.byKey(const Key('emby-bind-api-key')), findsNothing);

    await _selectCredentialMode(tester, 1);
    expect(find.byKey(const Key('emby-bind-password')), findsNothing);
    expect(find.byKey(const Key('emby-bind-api-key')), findsOneWidget);

    await _selectCredentialMode(tester, 2);
    expect(find.byKey(const Key('emby-bind-password')), findsNothing);
    expect(find.byKey(const Key('emby-bind-api-key')), findsNothing);

    await _selectCredentialMode(tester, 0);
    expect(find.byKey(const Key('emby-bind-password')), findsOneWidget);
    expect(find.byKey(const Key('emby-bind-api-key')), findsNothing);
  });

  testWidgets('Emby password mode preserves password whitespace', (
    tester,
  ) async {
    String? submittedPassword;
    bool? submittedPasswordless;
    await _pumpEmbyForm(
      tester,
      onBind:
          ({
            required host,
            required username,
            required password,
            required apiKey,
            required passwordless,
            required instanceName,
          }) async {
            submittedPassword = password;
            submittedPasswordless = passwordless;
          },
    );

    await tester.enterText(
      find.byKey(const Key('emby-bind-host')),
      'https://emby.example',
    );
    await tester.enterText(
      find.byKey(const Key('emby-bind-username')),
      'alice',
    );
    await tester.enterText(
      find.byKey(const Key('emby-bind-password')),
      '  secret password\t',
    );
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(submittedPassword, '  secret password\t');
    expect(submittedPasswordless, isFalse);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('Emby credential selector fits compact layouts', (tester) async {
    await _pumpEmbyForm(tester, surfaceSize: const Size(320, 700));

    expect(find.byTooltip('Password'), findsOneWidget);
    expect(find.byTooltip('API Key'), findsOneWidget);
    expect(find.byTooltip('No password'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpEmbyForm(
  WidgetTester tester, {
  Future<void> Function({
    required String host,
    required String username,
    required String password,
    required String apiKey,
    required bool passwordless,
    required String instanceName,
  })?
  onBind,
  Size surfaceSize = const Size(900, 760),
}) async {
  await tester.binding.setSurfaceSize(surfaceSize);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: EmbyAccountBindingForm(
          instanceNamesLoader: () async => const [],
          onSuccess: () {},
          onBind: onBind,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  expect(find.byKey(const Key('emby-bind-credential-mode')), findsOneWidget);
}

Future<void> _selectCredentialMode(WidgetTester tester, int index) async {
  final control = find.byKey(const Key('emby-bind-credential-mode'));
  final segment = find
      .descendant(of: control, matching: find.byType(TextButton))
      .at(index);
  tester.widget<TextButton>(segment).onPressed!();
  await tester.pump();
}
