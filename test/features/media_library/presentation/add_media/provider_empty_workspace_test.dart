import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_workspace.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/acfun_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/cctv_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/douyu_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/huya_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/douyin_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/tiktok_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/twitch_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/youtube_add_media_form.dart';
import 'package:synctv_app/l10n/l10n.dart';

import '../../../../test_app.dart';

void main() {
  final forms = <String, Widget Function()>{
    'acfun': () => AcFunAddMediaForm(
      roomId: 'room',
      playlistId: '',
      instances: const [],
      onDraftChanged: (_) {},
    ),
    'cctv': () => CctvAddMediaForm(
      roomId: 'room',
      playlistId: '',
      instances: const [],
      onDraftChanged: (_) {},
    ),
    'douyu': () => DouyuAddMediaForm(
      roomId: 'room',
      playlistId: '',
      instances: const [],
      onDraftChanged: (_) {},
    ),
    'huya': () => HuyaAddMediaForm(
      roomId: 'room',
      playlistId: '',
      instances: const [],
      onDraftChanged: (_) {},
    ),
    'douyin': () => DouyinAddMediaForm(
      roomId: 'room',
      playlistId: '',
      binds: const [],
      onDraftChanged: (_) {},
    ),
    'tiktok': () => TikTokAddMediaForm(
      roomId: 'room',
      playlistId: '',
      binds: const [],
      onDraftChanged: (_) {},
    ),
    'twitch': () => TwitchAddMediaForm(
      roomId: 'room',
      playlistId: '',
      binds: const [],
      onDraftChanged: (_) {},
    ),
    'youtube': () => YoutubeAddMediaForm(
      roomId: 'room',
      playlistId: '',
      binds: const [],
      onDraftChanged: (_) {},
    ),
  };
  for (final entry in forms.entries) {
    for (final width in [320.0, 1200.0]) {
      testWidgets('${entry.key} no-preview workspace at width $width', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(Size(width, 700));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          MaterialApp(
            builder: buildThemedTestApp,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: entry.value()),
          ),
        );
        await tester.pumpAndSettle();
        final workspace = tester.widget<ProviderWorkspace>(
          find.byType(ProviderWorkspace),
        );
        expect(workspace.results, isNull);
        expect(find.byType(NestedScrollView), findsNothing);
        final content = find.byWidget(workspace.controls);
        expect(tester.getTopLeft(content).dy, 0);
        expect(tester.getSize(content).width, width == 320 ? 320 : 408);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
