import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/playback_proxy_mode_control.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

void main() {
  testWidgets('selects each playback proxy mode and updates its description', (
    tester,
  ) async {
    var mode = source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: StatefulBuilder(
          builder: (context, setState) => Scaffold(
            body: PlaybackProxyModeControl(
              value: mode,
              onChanged: (value) => setState(() => mode = value),
            ),
          ),
        ),
      ),
    );

    expect(
      find.text("Use the media source's default playback route"),
      findsOneWidget,
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

    await tester.tap(find.text('Proxy only'));
    await tester.pump();
    expect(mode, source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY);
    expect(
      find.text('Keep routes that the SyncTV server can proxy'),
      findsOneWidget,
    );
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
