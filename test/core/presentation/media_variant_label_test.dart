import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/media_variant_label.dart';
import 'package:synctv_app/l10n/app_localizations.dart';

void main() {
  testWidgets('localizes media enums and provider-backed media types', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Column(
            children: [
              Text(localizedMediaVariant(context, 'RESOURCE_KIND_VIDEO')),
              Text(localizedMediaVariant(context, 'ITEM_TYPE_EPISODE')),
              Text(localizedMediaVariant(context, 'BILIBILI')),
            ],
          ),
        ),
      ),
    );

    expect(find.text('视频'), findsOneWidget);
    expect(find.text('剧集'), findsOneWidget);
    expect(find.text('媒体'), findsOneWidget);
    expect(find.textContaining('RESOURCE_KIND'), findsNothing);
    expect(find.text('BILIBILI'), findsNothing);
  });
}
