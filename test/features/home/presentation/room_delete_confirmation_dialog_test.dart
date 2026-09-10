import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/home/presentation/room_delete_confirmation_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';

void main() {
  for (final locale in ['en', 'zh']) {
    for (final size in [const Size(320, 568), const Size(800, 320)]) {
      testWidgets('delete confirmation fits $locale $size at 3x', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.reset);
        late BuildContext page;
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(3)),
              child: child!,
            ),
            home: Builder(
              builder: (context) {
                page = context;
                return const Scaffold();
              },
            ),
          ),
        );
        final result = showRoomDeleteConfirmationDialog(
          context: page,
          roomName:
              'International cinema and documentary discussion screenings',
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        final cancel = find.text(page.l10n.cancel);
        await tester.ensureVisible(cancel);
        await tester.pumpAndSettle();
        await tester.tap(cancel);
        await tester.pumpAndSettle();
        expect(await result, isFalse);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
