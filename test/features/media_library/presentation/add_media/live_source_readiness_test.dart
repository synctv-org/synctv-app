import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as common;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart' as source;
import 'package:synctv_app/features/media_library/presentation/add_media/acfun_add_media_form.dart';
import 'package:synctv_app/src/generated/proto/providers/acfun.pb.dart'
    as acfun;
import 'package:synctv_app/features/media_library/presentation/add_media/cctv_add_media_form.dart';
import 'package:synctv_app/src/generated/proto/providers/cctv.pb.dart' as cctv;
import 'package:synctv_app/features/media_library/presentation/add_media/douyu_add_media_form.dart';
import 'package:synctv_app/src/generated/proto/providers/douyu.pb.dart'
    as douyu;
import 'package:synctv_app/features/media_library/presentation/add_media/huya_add_media_form.dart';
import 'package:synctv_app/src/generated/proto/providers/huya.pb.dart' as huya;

import '../../../../test_app.dart';

void main() {
  for (final provider in ['acfun', 'cctv', 'douyu', 'huya']) {
    for (final variant in [
      'absent',
      'empty',
      'empty-media',
      'empty-playlist',
      'playlist',
      'media',
    ]) {
      testWidgets('$provider submit readiness for $variant', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        var submissions = 0;
        final responseSource = switch (variant) {
          'absent' => null,
          'empty' => common.DiscoveredSource(),
          'empty-media' => common.DiscoveredSource(
            media: source.MediaSourceConfig(),
          ),
          'empty-playlist' => common.DiscoveredSource(
            playlist: source.PlaylistSourceConfig(),
          ),
          'playlist' => testDiscoveredPlaylistSource(),
          _ => testDiscoveredMediaSource(),
        };
        final form = switch (provider) {
          'acfun' => AcFunAddMediaForm(
            roomId: 'room',
            playlistId: '',
            instances: const [],
            onDraftChanged: (_) {},
            onResolve: (_) async =>
                acfun.ResolveResponse(source: responseSource),
            onSubmit: (_) async => submissions++,
          ),
          'cctv' => CctvAddMediaForm(
            roomId: 'room',
            playlistId: '',
            instances: const [],
            onDraftChanged: (_) {},
            onResolve: (_) async =>
                cctv.ResolveResponse(source: responseSource),
            onSubmit: (_) async => submissions++,
          ),
          'douyu' => DouyuAddMediaForm(
            roomId: 'room',
            playlistId: '',
            instances: const [],
            onDraftChanged: (_) {},
            onResolve: (_) async =>
                douyu.ResolveResponse(source: responseSource),
            onSubmit: (_) async => submissions++,
          ),
          'huya' => HuyaAddMediaForm(
            roomId: 'room',
            playlistId: '',
            instances: const [],
            onDraftChanged: (_) {},
            onResolve: (_) async =>
                huya.ResolveResponse(source: responseSource),
            onSubmit: (_) async => submissions++,
          ),
          _ => throw StateError(provider),
        };
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: form),
          ),
        );
        await tester.enterText(
          find.byKey(Key('$provider-resource')),
          'resource',
        );
        await tester.pump();
        await tester.tap(find.byKey(Key('$provider-preview')));
        await tester.pumpAndSettle();
        final submit = find.byKey(Key('$provider-submit'));
        expect(
          tester.widget<FilledButton>(submit).onPressed,
          variant == 'media' ? isNotNull : isNull,
        );
        if (variant == 'media') {
          await tester.tap(submit);
          await tester.pumpAndSettle();
          expect(submissions, 1);
          await tester.pump(const Duration(seconds: 4));
        } else {
          expect(submissions, 0);
          expect(find.text('resource'), findsNWidgets(2));
        }
        expect(tester.takeException(), isNull);
      });
    }
  }
}
