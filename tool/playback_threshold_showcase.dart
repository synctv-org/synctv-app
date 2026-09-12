import 'package:flutter/material.dart';
import 'package:synctv_app/features/room/domain/playback_mode_config.dart';
import 'package:synctv_app/features/room/presentation/widgets/free_mode_settings_fields.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() => runApp(
  MaterialApp(
    theme: AppTheme.light,
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: const _Preview(),
  ),
);

class _Preview extends StatefulWidget {
  const _Preview();
  @override
  State<_Preview> createState() => _PreviewState();
}

class _PreviewState extends State<_Preview> {
  PlaybackModeConfig config = const PlaybackModeConfig(
    autoSeekDriftThresholdSeconds: 20,
    manualSeekDriftThresholdSeconds: 4,
  );
  bool large = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Playback thresholds')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilledButton(
              onPressed: () => setState(
                () => config = const PlaybackModeConfig(
                  autoSeekDriftThresholdSeconds: 0.05,
                  manualSeekDriftThresholdSeconds: 0.15,
                ),
              ),
              child: const Text('Load precise values'),
            ),
            FilledButton(
              onPressed: () => setState(() => large = !large),
              child: Text(large ? 'Text 1x' : 'Text 3x'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(large ? 3 : 1)),
              child: FreeModeSettingsFields(
                config: config,
                onChanged: (value) => setState(() => config = value),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
