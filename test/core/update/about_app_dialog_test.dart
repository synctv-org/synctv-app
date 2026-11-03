@TestOn('vm')
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/core/update/github_release.dart';
import 'package:synctv_app/core/update/update_check_ui.dart';
import 'package:synctv_app/core/update/update_checker.dart';
import 'package:synctv_app/core/update/update_source.dart';
import 'package:synctv_app/l10n/l10n.dart';

Future<void> _pumpDialog(
  WidgetTester tester, {
  UpdateCheckSource? source,
}) async {
  PackageInfo.setMockInitialValues(
    appName: 'SyncTV',
    packageName: 'org.synctv.app',
    version: '1.0.0',
    buildNumber: '42',
    buildSignature: '',
  );
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Builder(
        builder: (context) => Center(
          child: AppActionButton(
            label: 'open',
            onPressed: () =>
                showAboutAppDialog(context, sourceOverride: source),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the app version', (tester) async {
    await _pumpDialog(tester);
    expect(find.text('Version 1.0.0 (build 42)'), findsOneWidget);
    expect(find.text('About SyncTV'), findsOneWidget);
  });

  testWidgets('hides the update section without a release source', (
    tester,
  ) async {
    await _pumpDialog(tester);
    expect(find.text('Check for updates'), findsNothing);
  });

  testWidgets('shows the update action with a release source', (tester) async {
    await _pumpDialog(
      tester,
      source: UpdateCheckSource.parse('synctv-org/synctv-app'),
    );
    expect(find.text('Check for updates'), findsOneWidget);
    expect(find.text('Releases: synctv-org/synctv-app'), findsOneWidget);
  });

  testWidgets('update dialog renders release notes and dismisses quietly', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final checker = UpdateChecker(
      source: UpdateCheckSource.parse('owner/repo')!,
      currentVersion: '1.0.0',
      fetch: (_) => throw UnimplementedError(),
      preferences: preferences,
    );
    final release = GitHubLatestRelease(
      tagName: 'v1.1.0',
      htmlUrl: 'https://github.com/owner/repo/releases/latest',
      name: 'v1.1.0',
      body: '## Changes\n- fixed things',
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) => Center(
            child: AppActionButton(
              label: 'open',
              onPressed: () => showUpdateAvailableDialog(
                context,
                release: release,
                checker: checker,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Update available: v1.1.0'), findsOneWidget);
    // MarkdownBody renders the notes; assert on rendered output.
    expect(find.text('Changes'), findsOneWidget);
    expect(find.text('fixed things'), findsOneWidget);

    await tester.tap(find.text('Later'));
    await tester.pumpAndSettle();
    expect(find.text('Update available: v1.1.0'), findsNothing);
    expect(preferences.getString('update.dismissedTag'), 'v1.1.0');
  });
}
