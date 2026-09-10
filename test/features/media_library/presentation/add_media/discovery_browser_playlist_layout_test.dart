import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/discovery_browser.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_add_target.dart';
import 'package:synctv_app/l10n/app_localizations.dart';

import '../../../../test_app.dart';

void main() {
  for (final locale in ['en', 'zh']) {
    for (final size in [const Size(320, 568), const Size(1200, 400)]) {
      for (final leading in [false, true]) {
        testWidgets('$locale $size playlist toolbar leading=$leading at 3x', (
          tester,
        ) async {
          await tester.binding.setSurfaceSize(size);
          addTearDown(() => tester.binding.setSurfaceSize(null));
          var submitted = 0;
          final controller = TextEditingController(text: 'Cinema');
          addTearDown(controller.dispose);
          await tester.pumpWidget(
            MaterialApp(
              locale: Locale(locale),
              builder: (context, child) => buildThemedTestApp(
                context,
                MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: const TextScaler.linear(3)),
                  child: child!,
                ),
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: Builder(
                  builder: (context) => DiscoveryBrowser(
                    items: [
                      DiscoveryBrowserEntry(
                        key: 'folder',
                        title: 'Folder',
                        source: testDiscoveredPlaylistSource(),
                        isContainer: true,
                      ),
                    ],
                    loading: false,
                    target: ProviderAddTarget.playlist,
                    onAddCurrentList: () async => submitted++,
                    playlistActionLeading: leading
                        ? AppTextField(
                            key: const Key('playlist-name'),
                            controller: controller,
                            label: AppLocalizations.of(context).playlistName,
                          )
                        : null,
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          final button = find.byKey(const Key('discovery-add-current-list'));
          final rect = tester.getRect(button);
          expect(rect.left, greaterThanOrEqualTo(0));
          expect(rect.right, lessThanOrEqualTo(size.width));
          expect(rect.bottom, lessThanOrEqualTo(size.height));
          if (leading) {
            final field = find.byKey(const Key('playlist-name'));
            expect(
              tester.getSize(field).width,
              greaterThanOrEqualTo(size.width * .8),
            );
            expect(tester.getRect(field).bottom, lessThanOrEqualTo(rect.top));
            await tester.enterText(find.byType(TextField), 'Evening cinema');
            expect(controller.text, 'Evening cinema');
          }
          await tester.tap(button);
          await tester.pumpAndSettle();
          expect(submitted, 1);
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
