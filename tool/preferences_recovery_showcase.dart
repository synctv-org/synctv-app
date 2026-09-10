import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/app/app_startup.dart';
import 'package:synctv_app/core/localization/app_locale_controller.dart';
import 'package:synctv_app/core/localization/presentation/language_selector_dialog.dart';
import 'package:synctv_app/features/room/application/playback_mode_preferences_controller.dart';
import 'package:synctv_app/features/room/application/playback_overlay_preferences_controller.dart';
import 'package:synctv_app/features/room/application/player_volume_preferences_controller.dart';
import 'package:synctv_app/features/room/application/realtime_event_log_preferences_controller.dart';
import 'package:synctv_app/features/room/data/shared_preferences_playback_mode_store.dart';
import 'package:synctv_app/features/room/data/shared_preferences_playback_overlay_store.dart';
import 'package:synctv_app/features/room/data/shared_preferences_player_volume_store.dart';
import 'package:synctv_app/features/room/data/shared_preferences_realtime_event_log_store.dart';
import 'package:synctv_app/features/room/presentation/widgets/free_mode_settings_fields.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  await preferences.setBool(AppLocaleController.preferenceKey, true);
  await preferences.setString('synctv.playback.free-mode.config', '{broken');
  await preferences.setBool('synctv.playback.overlay.preferences', false);
  await preferences.setString('synctv.player.volume', 'invalid');
  await preferences.setDouble('synctv.player.last_audible_volume', 0.7);
  await preferences.setString('realtime_event_log.max_entries', 'invalid');
  await preferences.setBool('realtime_event_log.grouped', true);
  final mode = PlaybackModePreferencesController(
    store: const SharedPreferencesPlaybackModeStore(),
  );
  final overlay = PlaybackOverlayPreferencesController(
    store: const SharedPreferencesPlaybackOverlayStore(),
  );
  final volume = PlayerVolumePreferencesController(
    store: const SharedPreferencesPlayerVolumeStore(),
  );
  final log = RealtimeEventLogPreferencesController(
    store: const SharedPreferencesRealtimeEventLogStore(),
  );
  runApp(
    AppStartup(
      initialize: () => Future.wait([
        appLocaleController.load(),
        mode.load(),
        overlay.load(),
        volume.load(),
        log.load(),
      ]),
      child: MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          appBar: AppBar(title: const Text('Preference recovery')),
          body: ListenableBuilder(
            listenable: mode,
            builder: (context, _) => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Startup ready · volume ${volume.value.volume} · '
                  'last audible ${volume.value.lastAudibleVolume}',
                ),
                Text(
                  'Log limit ${log.maxEntries.value} · grouped ${log.grouped.value}',
                ),
                Text('Subtitle font ${overlay.value.subtitleFontSize}'),
                ListenableBuilder(
                  listenable: appLocaleController,
                  builder: (context, _) =>
                      Text('Locale: ${appLocaleController.preference.name}'),
                ),
                OutlinedButton(
                  onPressed: () => showLanguageSelectorDialog(context),
                  child: const Text('Display language'),
                ),
                const SizedBox(height: 16),
                FreeModeSettingsFields(
                  config: mode.value,
                  onChanged: mode.update,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
