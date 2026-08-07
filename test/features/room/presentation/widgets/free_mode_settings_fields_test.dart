import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/room/domain/playback_mode_config.dart';
import 'package:synctv_app/features/room/presentation/widgets/free_mode_settings_fields.dart';

import '../../../../test_app.dart';

void main() {
  testWidgets('free mode disables room correction and keeps manual sync', (
    tester,
  ) async {
    var config = const PlaybackModeConfig(
      autoSeekDriftThresholdSeconds: 1.5,
      manualSeekDriftThresholdSeconds: 0.4,
    );

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: buildThemedTestApp,
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return FreeModeSettingsFields(
                config: config,
                onChanged: (value) {
                  setState(() => config = value);
                },
              );
            },
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Free mode'), findsOneWidget);
    expect(find.text('1.5 seconds'), findsOneWidget);
    expect(find.text('0.4 seconds'), findsOneWidget);
    var sliders = tester.widgetList<Slider>(find.byType(Slider)).toList();
    expect(sliders.first.onChanged, isNotNull);
    expect(sliders.last.onChanged, isNotNull);

    await tester.tap(find.text('Free mode'));
    await tester.pump();

    expect(config.freeModeEnabled, isTrue);
    sliders = tester.widgetList<Slider>(find.byType(Slider)).toList();
    expect(sliders.first.onChanged, isNull);
    expect(sliders.last.onChanged, isNotNull);
    expect(tester.takeException(), isNull);

    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
