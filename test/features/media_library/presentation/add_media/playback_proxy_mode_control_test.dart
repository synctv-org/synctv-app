import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/playback_proxy_mode_control.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/providers/common.pbenum.dart'
    as provider_common_enum;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

void main() {
  testWidgets('selects every playback route mode and updates its description', (
    tester,
  ) async {
    var mode = source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: SizedBox(
              width: 800,
              child: PlaybackProxyModeControl(
                value: mode,
                policy: _allModesPolicy(),
                onChanged: (value) => setState(() => mode = value),
              ),
            ),
          ),
        ),
      ),
    );

    expect(
      find.text("Use the media source's default playback route"),
      findsOneWidget,
    );
    expect(
      find.text(
        'Direct playback can expose upstream URLs, signed links, tokens, cookies, or authorization headers to room members. Use it only in a trusted room and network.',
      ),
      findsNothing,
    );
    await tester.tap(find.text('Prefer proxy'));
    await tester.pump();
    expect(mode, source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER);
    expect(
      find.text('Keep direct and proxy routes, selecting the proxy by default'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Direct playback can expose upstream URLs, signed links, tokens, cookies, or authorization headers to room members. Use it only in a trusted room and network.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Prefer direct'));
    await tester.pump();
    expect(
      mode,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_PREFER,
    );
    expect(
      find.text('Keep direct and proxy routes, selecting direct by default'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Direct playback can expose upstream URLs, signed links, tokens, cookies, or authorization headers to room members. Use it only in a trusted room and network.',
      ),
      findsOneWidget,
    );

    await tester.tap(find.text('Direct only'));
    await tester.pump();
    expect(mode, source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY);
    expect(find.text('Keep direct playback routes only'), findsOneWidget);

    await tester.tap(find.text('Proxy only'));
    await tester.pump();
    expect(mode, source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY);
    expect(
      find.text('Keep routes that the SyncTV server can proxy'),
      findsOneWidget,
    );
    expect(
      find.text(
        'Direct playback can expose upstream URLs, signed links, tokens, cookies, or authorization headers to room members. Use it only in a trusted room and network.',
      ),
      findsNothing,
    );
  });

  testWidgets('uses a dropdown on narrow layouts and reports direct-only', (
    tester,
  ) async {
    var mode = source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: SizedBox(
              width: 360,
              child: PlaybackProxyModeControl(
                value: mode,
                policy: _allModesPolicy(),
                onChanged: (value) => setState(() => mode = value),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('playback-proxy-mode')), findsNothing);
    await tester.tap(find.byKey(const Key('playback-proxy-mode-dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Direct only').last);
    await tester.pumpAndSettle();

    expect(mode, source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY);
    expect(find.text('Keep direct playback routes only'), findsOneWidget);
  });

  testWidgets('renders only modes returned by the provider policy', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 800,
            child: PlaybackProxyModeControl(
              value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
              policy: _proxyModesPolicy(),
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Prefer direct'), findsNothing);
    expect(find.text('Direct only'), findsNothing);
    expect(find.text('Prefer proxy'), findsOneWidget);
    expect(find.text('Proxy only'), findsOneWidget);
  });

  testWidgets('uses backend modes and shows the effective automatic policy', (
    tester,
  ) async {
    final policy = provider_common.PlaybackProxyPolicy(
      supportedModes: [
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
      ],
      currentMode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
      autoPolicies: [
        provider_common.PlaybackProxyAutoPolicy(
          variant: 'video',
          mode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
          reason: provider_common_enum
              .PlaybackProxyAutoReason
              .PLAYBACK_PROXY_AUTO_REASON_SIGNED_RESOURCE,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 800,
            child: PlaybackProxyModeControl(
              value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
              policy: policy,
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Automatic'), findsOneWidget);
    expect(find.text('Proxy only'), findsOneWidget);
    expect(find.text('Prefer proxy'), findsNothing);
    expect(find.text('Prefer direct'), findsNothing);
    expect(find.text('Direct only'), findsNothing);
    expect(find.text('video: Proxy only (signed resource)'), findsOneWidget);
  });

  testWidgets('normalizes a mode excluded by the backend policy', (
    tester,
  ) async {
    var mode = source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY;
    final policy = provider_common.PlaybackProxyPolicy(
      supportedModes: [
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
      ],
      currentMode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: SizedBox(
              width: 800,
              child: PlaybackProxyModeControl(
                value: mode,
                policy: policy,
                onChanged: (value) => setState(() => mode = value),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(mode, source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO);
    expect(find.text('Automatic'), findsOneWidget);
    expect(find.text('Direct only'), findsNothing);
    expect(
      find.text("Use the media source's default playback route"),
      findsOneWidget,
    );
  });

  testWidgets('shows a safe state for an empty provider policy', (
    tester,
  ) async {
    final policy = provider_common.PlaybackProxyPolicy(
      supportedModes: const [],
      currentMode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
    );
    var changes = 0;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SizedBox(
            width: 800,
            child: PlaybackProxyModeControl(
              value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
              policy: policy,
              onChanged: (_) => changes++,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(
      find.byKey(const Key('playback-proxy-mode-unavailable')),
      findsOneWidget,
    );
    expect(
      find.text(
        'No compatible playback route is available for this media source.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('playback-proxy-mode')), findsNothing);
    expect(changes, 0);
  });

  testWidgets('ignores taps while disabled', (tester) async {
    var mode = source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: PlaybackProxyModeControl(
            value: mode,
            enabled: false,
            policy: _allModesPolicy(),
            onChanged: (value) => mode = value,
          ),
        ),
      ),
    );

    await tester.tap(find.text('Proxy only'));
    await tester.pump();
    expect(mode, source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO);
  });
}

provider_common.PlaybackProxyPolicy _allModesPolicy() =>
    provider_common.PlaybackProxyPolicy(
      supportedModes: [
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER,
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_PREFER,
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY,
      ],
      currentMode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
    );

provider_common.PlaybackProxyPolicy _proxyModesPolicy() =>
    provider_common.PlaybackProxyPolicy(
      supportedModes: [
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER,
        source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
      ],
      currentMode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
    );
