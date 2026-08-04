import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/core/presentation/widgets/synctv_brand_mark.dart';

void main() {
  testWidgets('SyncTvBrandMark loads the bundled SVG artwork', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SyncTvBrandMark(semanticLabel: 'SyncTV', size: 100),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(SvgPicture), findsOneWidget);

    final surface = tester.widget<AppPanelSurface>(
      find.byType(AppPanelSurface),
    );
    expect(
      surface.borderRadius,
      BorderRadius.circular(100 * SyncTvBrandMark.cornerRadiusRatio),
    );
  });

  testWidgets('default corner radius scales with the brand mark', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SyncTvBrandMark(semanticLabel: 'SyncTV', size: 36),
      ),
    );

    final surface = tester.widget<AppPanelSurface>(
      find.byType(AppPanelSurface),
    );
    expect(surface.borderRadius, BorderRadius.circular(8));
  });
}
