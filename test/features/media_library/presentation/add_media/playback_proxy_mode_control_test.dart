import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/playback_proxy_mode_control.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
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

  testWidgets('hides direct modes when the source cannot provide them', (
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
              supportsDirectPlayback: false,
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
