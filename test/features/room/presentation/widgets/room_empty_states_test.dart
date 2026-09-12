import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/presentation/widgets/playback_empty_state.dart';
import 'package:synctv_app/features/room/presentation/widgets/playlist_empty_state.dart';
import 'package:synctv_app/l10n/l10n.dart';

Widget _app(Widget child, double scale) => MaterialApp(
  locale: const Locale('en'),
  supportedLocales: AppLocalizations.supportedLocales,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  home: Scaffold(
    body: Center(
      child: SizedBox(
        width: 320,
        height: 180,
        child: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: child,
        ),
      ),
    ),
  ),
);

void main() {
  for (final scale in [1.0, 3.0]) {
    testWidgets('playback error remains readable in a short panel at $scale', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const PlaybackEmptyState(
            error: 'The media could not be loaded. Check the source address and try again. The server returned an unavailable source.',
            loading: false,
            hasPlayback: false,
          ),
          scale,
        ),
      );
      expect(tester.takeException(), isNull);
      final scroll = tester.state<ScrollableState>(find.byType(Scrollable));
      expect(scroll.position.maxScrollExtent, greaterThan(0));
      await tester.drag(find.byType(PlaybackEmptyState), const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(scroll.position.pixels, greaterThan(0));
      expect(tester.takeException(), isNull);
    });

    testWidgets('empty playlist add action stays reachable at $scale', (
      tester,
    ) async {
      var added = false;
      await tester.pumpWidget(
        _app(PlaylistEmptyState(onAdd: () => added = true), scale),
      );
      expect(tester.takeException(), isNull);
      final add = find.text('Add media');
      await tester.ensureVisible(add);
      await tester.pumpAndSettle();
      await tester.tap(add);
      await tester.pump();
      expect(added, isTrue);
      expect(tester.takeException(), isNull);
    });
  }
}
