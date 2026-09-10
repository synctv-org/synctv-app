import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/room/application/realtime_event_log_preferences_controller.dart';
import 'package:synctv_app/features/room/presentation/widgets/realtime_event_log_view.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() {
  final store = _Store();
  runApp(
    DependencyScope(
      value: RealtimeEventLogPreferencesController(store: store),
      child: MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          appBar: AppBar(title: const Text('Log retention')),
          body: Column(
            children: [
              ValueListenableBuilder<int>(
                valueListenable: store.writes,
                builder: (_, count, _) => Text('Preference writes: $count'),
              ),
              const Expanded(child: RealtimeEventLogView(events: [])),
            ],
          ),
        ),
      ),
    ),
  );
}

class _Store implements RealtimeEventLogPreferencesStore {
  final writes = ValueNotifier(0);
  @override
  Future<RealtimeEventLogPreferenceValues> load() async =>
      const RealtimeEventLogPreferenceValues();
  @override
  Future<void> saveGrouped(bool value) async {}
  @override
  Future<void> saveMaxEntries(int value) async => writes.value++;
}
