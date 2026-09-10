import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/acfun_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/cctv_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/douyu_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/huya_add_media_form.dart';
import 'package:synctv_app/l10n/l10n.dart';

import '../../../../test_app.dart';

void main() {
  final forms = <String, Widget Function()>{
    'acfun': () => AcFunAddMediaForm(
      roomId: 'room',
      playlistId: '',
      instances: const [
        'International live broadcast and shared family streaming instance',
      ],
      onDraftChanged: (_) {},
    ),
    'cctv': () => CctvAddMediaForm(
      roomId: 'room',
      playlistId: '',
      instances: const [
        'International live broadcast and shared family streaming instance',
      ],
      onDraftChanged: (_) {},
    ),
    'douyu': () => DouyuAddMediaForm(
      roomId: 'room',
      playlistId: '',
      instances: const [
        'International live broadcast and shared family streaming instance',
      ],
      onDraftChanged: (_) {},
    ),
    'huya': () => HuyaAddMediaForm(
      roomId: 'room',
      playlistId: '',
      instances: const [
        'International live broadcast and shared family streaming instance',
      ],
      onDraftChanged: (_) {},
    ),
  };
  for (final entry in forms.entries) {
    for (final locale in ['en', 'zh']) {
      for (final width in [320.0, 1200.0]) {
        testWidgets('${entry.key} long instance $locale width $width at 3x', (
          tester,
        ) async {
          await tester.binding.setSurfaceSize(Size(width, 700));
          addTearDown(() => tester.binding.setSurfaceSize(null));
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
              home: Scaffold(body: entry.value()),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
