import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/models/playback_sync_config.dart';
import 'package:synctv_app/widgets/playback_sync_settings_fields.dart';

void main() {
  testWidgets('updates the playback sync draft from room settings', (
    tester,
  ) async {
    var config = const PlaybackSyncConfig(
      autoSeekDriftThresholdSeconds: 1.5,
      manualSeekDriftThresholdSeconds: 0.4,
    );

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: FTheme(
          data: FThemes.blue.light.desktop,
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return PlaybackSyncSettingsFields(
                  config: config,
                  onChanged: (value) {
                    setState(() => config = value);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Automatic progress correction'), findsOneWidget);
    expect(find.text('1.5 seconds'), findsOneWidget);
    expect(find.text('0.4 seconds'), findsOneWidget);

    await tester.tap(find.text('Automatic progress correction'));
    await tester.pump();

    expect(config.autoSyncEnabled, isFalse);
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
