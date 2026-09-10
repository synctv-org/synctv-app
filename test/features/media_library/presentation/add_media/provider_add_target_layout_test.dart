import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_add_target.dart';
import 'package:synctv_app/l10n/l10n.dart';

void main() {
  for (final locale in ['en', 'zh']) {
    for (final width in [296.0, 1100.0]) {
      for (final scale in [1.0, 3.0]) {
        testWidgets('$locale target selector width $width scale $scale', (
          tester,
        ) async {
          await tester.binding.setSurfaceSize(const Size(1200, 1000));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          var selected = ProviderAddTarget.parse;
          var enabled = true;
          late StateSetter update;
          await tester.pumpWidget(
            MaterialApp(
              locale: Locale(locale),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: StatefulBuilder(
                builder: (context, setState) {
                  update = setState;
                  return Scaffold(
                    body: MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaler: TextScaler.linear(scale)),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SizedBox(
                          width: width,
                          child: ProviderAddTargetSelector(
                            value: selected,
                            targets: ProviderAddTarget.values,
                            enabled: enabled,
                            onChanged: (value) =>
                                setState(() => selected = value),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
          final finder = find.byType(SegmentedButton<ProviderAddTarget>);
          var control = tester.widget<SegmentedButton<ProviderAddTarget>>(
            finder,
          );
          if (width == 296 && scale == 3) {
            expect(control.direction, Axis.vertical);
          }
          if (width == 1100 && scale == 1) {
            expect(control.direction, Axis.horizontal);
          }
          final label =
              ((control.segments[1].label! as ConstrainedBox).child! as Text)
                  .data!;
          await tester.tap(find.text(label));
          await tester.pumpAndSettle();
          expect(selected, ProviderAddTarget.media);
          expect(tester.takeException(), isNull);
          final bounds = tester.getRect(finder);
          expect(bounds.right, lessThanOrEqualTo(width));
          update(() => enabled = false);
          await tester.pump();
          control = tester.widget<SegmentedButton<ProviderAddTarget>>(finder);
          expect(control.onSelectionChanged, isNull);
        });
      }
    }
  }
}
