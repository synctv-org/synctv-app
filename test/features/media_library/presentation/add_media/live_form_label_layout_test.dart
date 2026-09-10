import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/acfun_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/cctv_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/douyu_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/huya_add_media_form.dart';

void main() {
  for (final provider in ['acfun', 'cctv', 'douyu', 'huya']) {
    for (final locale in ['en', 'zh']) {
      for (final width in [320.0, 1200.0]) {
        testWidgets('$provider $locale labels readable at $width and 3x', (
          tester,
        ) async {
          await tester.binding.setSurfaceSize(Size(width, 900));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final semantics = tester.ensureSemantics();
          final form = switch (provider) {
            'acfun' => AcFunAddMediaForm(
              roomId: 'room',
              playlistId: '',
              instances: const [],
              onDraftChanged: (_) {},
            ),
            'cctv' => CctvAddMediaForm(
              roomId: 'room',
              playlistId: '',
              instances: const [],
              onDraftChanged: (_) {},
            ),
            'douyu' => DouyuAddMediaForm(
              roomId: 'room',
              playlistId: '',
              instances: const [],
              onDraftChanged: (_) {},
            ),
            'huya' => HuyaAddMediaForm(
              roomId: 'room',
              playlistId: '',
              instances: const [],
              onDraftChanged: (_) {},
            ),
            _ => throw StateError(provider),
          };
          await tester.pumpWidget(
            MaterialApp(
              locale: Locale(locale),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              builder: (context, child) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(3)),
                child: child!,
              ),
              home: Scaffold(body: form),
            ),
          );
          await tester.pumpAndSettle();
          for (final key in ['$provider-resource', '$provider-name']) {
            final root = find.byKey(Key(key));
            final field = tester.widget<AppTextField>(root);
            final input = tester.widget<TextField>(
              find.descendant(of: root, matching: find.byType(TextField)),
            );
            expect(input.decoration!.labelText, isNull);
            final label = find.descendant(
              of: root,
              matching: find.text(field.label),
            );
            expect(label, findsOneWidget);
            final paragraph = tester.renderObject<RenderParagraph>(label);
            expect(paragraph.didExceedMaxLines, isFalse);
            expect(paragraph.size.width, lessThanOrEqualTo(width));
            expect(find.bySemanticsLabel(field.label), findsOneWidget);
          }
          expect(tester.takeException(), isNull);
          await tester.enterText(
            find.byKey(Key('$provider-resource')),
            '660000',
          );
          await tester.pump();
          expect(
            tester
                .widget<OutlinedButton>(find.byKey(Key('$provider-preview')))
                .onPressed,
            isNotNull,
          );
          expect(tester.takeException(), isNull);
          semantics.dispose();
        });
      }
    }
  }
}
