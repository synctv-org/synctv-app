import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/room/domain/playback_mode_config.dart';
import 'package:synctv_app/features/room/presentation/widgets/free_mode_settings_fields.dart';

import '../../../../test_app.dart';

void main() {
  testWidgets('threshold panels fit a narrow viewport with enlarged text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) => buildThemedTestApp(
          context,
          MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(3)),
            child: child!,
          ),
        ),
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: FreeModeSettingsFields(
              config: const PlaybackModeConfig(
                autoSeekDriftThresholdSeconds: 30,
                manualSeekDriftThresholdSeconds: 5,
              ),
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  for (final config in [
    const PlaybackModeConfig(
      autoSeekDriftThresholdSeconds: 0.05,
      manualSeekDriftThresholdSeconds: 0.15,
    ),
    const PlaybackModeConfig(
      autoSeekDriftThresholdSeconds: 20,
      manualSeekDriftThresholdSeconds: 4,
    ),
  ]) {
    testWidgets('sliders represent saved thresholds ${config.toJson()}', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: buildThemedTestApp,
          home: Scaffold(
            body: FreeModeSettingsFields(config: config, onChanged: (_) {}),
          ),
        ),
      );
      final sliders = tester.widgetList<Slider>(find.byType(Slider)).toList();
      expect(sliders.first.value, config.autoSeekDriftThresholdSeconds);
      expect(sliders.last.value, config.manualSeekDriftThresholdSeconds);
      expect(
        sliders.first.label,
        config.autoSeekDriftThresholdSeconds < 1
            ? '0.05 seconds'
            : '20.0 seconds',
      );
      expect(
        sliders.last.label,
        config.manualSeekDriftThresholdSeconds < 1
            ? '0.15 seconds'
            : '4.0 seconds',
      );
      expect(tester.takeException(), isNull);
    });
  }

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
