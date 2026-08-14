import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/presentation/widgets/playlist_search_field.dart';
import 'package:synctv_app/l10n/l10n.dart';

void main() {
  testWidgets('submits an empty search when the clear action is pressed', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final submittedQueries = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: PlaylistSearchField(
            key: const Key('playlist-search-field'),
            controller: controller,
            label: 'Search media or playlists',
            onSearch: () => submittedQueries.add(controller.text),
          ),
        ),
      ),
    );

    final searchField = find.descendant(
      of: find.byKey(const Key('playlist-search-field')),
      matching: find.byType(TextFormField),
    );
    await tester.enterText(searchField, 'movie');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(submittedQueries, ['movie']);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();

    expect(controller.text, isEmpty);
    expect(submittedQueries, ['movie', '']);
  });
}
