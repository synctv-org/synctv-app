import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_source_preview.dart';
import 'package:synctv_app/l10n/app_localizations.dart';

void main() {
  for (final width in [320.0, 900.0]) {
    for (final scale in [1.0, 3.0]) {
      for (final image in [false, true]) {
        testWidgets(
          'preview width=$width scale=$scale image=$image stays readable',
          (tester) async {
            await tester.binding.setSurfaceSize(Size(width, 900));
            addTearDown(() => tester.binding.setSurfaceSize(null));
            const title =
                'A complete preview title that remains readable with a thumbnail';
            await tester.pumpWidget(
              MaterialApp(
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(scale)),
                  child: child!,
                ),
                home: Scaffold(
                  body: SingleChildScrollView(
                    child: ProviderSourcePreview(
                      title: title,
                      details: const ['Full metadata', 'Last detail'],
                      thumbnailUrl: image
                          ? 'https://invalid.example/thumbnail.png'
                          : '',
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            final titleRect = tester.getRect(find.text(title));
            final detailsRect = tester.getRect(
              find.text('Full metadata · Last detail'),
            );
            expect(detailsRect.top, greaterThanOrEqualTo(titleRect.bottom));
            expect(
              tester
                  .renderObject<RenderParagraph>(find.text(title))
                  .didExceedMaxLines,
              isFalse,
            );
            if (image) {
              final imageRect = tester.getRect(find.byType(AppImageThumbnail));
              if (width < 480 || scale > 1.5) {
                expect(titleRect.top, greaterThanOrEqualTo(imageRect.bottom));
                expect(titleRect.width, greaterThan(width - 30));
              } else {
                expect(titleRect.left, greaterThanOrEqualTo(imageRect.right));
              }
              expect(
                tester
                    .widget<AppImageThumbnail>(find.byType(AppImageThumbnail))
                    .fit,
                BoxFit.contain,
              );
              expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
            } else {
              expect(find.byType(AppImageThumbnail), findsNothing);
            }
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  }
}
