import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/room/application/realtime_event_log_preferences_controller.dart';
import 'package:synctv_app/features/room/presentation/widgets/realtime_event_log_view.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/room/domain/realtime_event_log.dart';

class _Store implements RealtimeEventLogPreferencesStore {
  final writes = <int>[];
  @override
  Future<RealtimeEventLogPreferenceValues> load() async =>
      const RealtimeEventLogPreferenceValues();
  @override
  Future<void> saveGrouped(bool value) async {}
  @override
  Future<void> saveMaxEntries(int value) async => writes.add(value);
}

void main() {
  testWidgets('expanded event group follows its identity after live reorder', (
    tester,
  ) async {
    final preferences = RealtimeEventLogPreferencesController(store: _Store());
    RealtimeEventLogEntry event(String label, int second) =>
        RealtimeEventLogEntry(
          timestamp: DateTime(2026, 1, 1, 0, 0, second),
          direction: 'in',
          label: label,
          payload: '$label payload',
        );
    final events = ValueNotifier([event('heartbeat', 1), event('resource', 2)]);
    addTearDown(events.dispose);
    await tester.pumpWidget(
      DependencyScope(
        value: preferences,
        child: MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: ValueListenableBuilder(
              valueListenable: events,
              builder: (_, value, _) => RealtimeEventLogView(events: value),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await preferences.setGrouped(true);
    await tester.pumpAndSettle();
    await tester.tap(find.text('resource'));
    await tester.pumpAndSettle();
    expect(find.text('"resource payload"'), findsOneWidget);
    events.value = [...events.value, event('heartbeat', 3)];
    await tester.pumpAndSettle();
    expect(find.text('"resource payload"'), findsOneWidget);
    expect(find.text('"heartbeat payload"'), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('cancelling custom retention does not save or notify', (
    tester,
  ) async {
    final store = _Store();
    final preferences = RealtimeEventLogPreferencesController(store: store);
    final changes = <int>[];
    await tester.pumpWidget(
      DependencyScope(
        value: preferences,
        child: MaterialApp(
          locale: const Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: RealtimeEventLogView(
              events: const [],
              onMaxEntriesChanged: changes.add,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.storage_rounded).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Custom...'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText), '');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(tester.element(find.byType(EditableText)));
    expect(find.text(l10n.valueRequired), findsOneWidget);
    expect(store.writes, isEmpty);
    expect(changes, isEmpty);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text(l10n.valueRequired), findsOneWidget);
    expect(store.writes, isEmpty);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(store.writes, isEmpty);
    expect(changes, isEmpty);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byIcon(Icons.storage_rounded).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Custom...'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText), '9999');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(store.writes, [2000]);
    expect(changes, [2000]);
    expect(preferences.maxEntries.value, 2000);
    expect(tester.takeException(), isNull);
  });
}
