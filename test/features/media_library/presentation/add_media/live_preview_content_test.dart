import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fixnum/fixnum.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
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
    for (final locale in ['en', 'zh']) {
      for (final width in [320.0, 1200.0]) {
        testWidgets('$provider $locale complete preview at $width and 3x', (
          tester,
        ) async {
          await tester.binding.setSurfaceSize(Size(width, 900));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          const title =
              'A complete broadcast title with enough detail to identify this specific recording';
          const author =
              'A detailed creator and programme description that should remain visible';
          final form = switch (provider) {
            'acfun' => AcFunAddMediaForm(
              roomId: 'room',
              playlistId: '',
              instances: const [],
              onResolve: (_) async => acfun.ResolveResponse(
                metadata: acfun.Metadata(
                  title: title,
                  author: author,
                  hasDanmaku: true,
                  hasLiveDanmaku: true,
                ),
                qualities: [acfun.Quality()],
                source: testDiscoveredMediaSource(),
              ),
            ),
            'cctv' => CctvAddMediaForm(
              roomId: 'room',
              playlistId: '',
              instances: const [],
              onResolve: (_) async => cctv.ResolveResponse(
                metadata: cctv.Metadata(
                  title: title,
                  channel: author,
                  protected: true,
                  chapters: [cctv.Chapter()],
                ),
                streams: [
                  cctv.Stream(kind: cctv.StreamKind.STREAM_KIND_VIDEO_HLS),
                  cctv.Stream(kind: cctv.StreamKind.STREAM_KIND_AUDIO_HLS),
                ],
                source: testDiscoveredMediaSource(),
              ),
            ),
            'douyu' => DouyuAddMediaForm(
              roomId: 'room',
              playlistId: '',
              instances: const [],
              onDraftChanged: (_) {},
              onResolve: (_) async => douyu.ResolveResponse(
                metadata: douyu.Metadata(
                  title: title,
                  author: author,
                  isReplay: true,
                  viewerCount: Int64(123),
                ),
                qualities: [douyu.Quality(cdn: 'one')],
                source: testDiscoveredMediaSource(),
              ),
            ),
            'huya' => HuyaAddMediaForm(
              roomId: 'room',
              playlistId: '',
              instances: const [],
              onDraftChanged: (_) {},
              onResolve: (_) async => huya.ResolveResponse(
                metadata: huya.Metadata(
                  title: title,
                  author: author,
                  isLive: true,
                ),
                qualities: [huya.Quality(cdn: 'one')],
                source: testDiscoveredMediaSource(),
              ),
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
          await tester.enterText(
            find.byKey(Key('$provider-resource')),
            'resource',
          );
          await tester.pump();
          tester
              .widget<OutlinedButton>(find.byKey(Key('$provider-preview')))
              .onPressed!();
          await tester.pumpAndSettle();
          if (width < 860) {
            final nested = tester.state<NestedScrollViewState>(
              find.byType(NestedScrollView),
            );
            nested.outerController.jumpTo(
              nested.outerController.position.maxScrollExtent,
            );
            await tester.pumpAndSettle();
          }
          final details = find.textContaining(author);
          for (final finder in [find.text(title), details]) {
            expect(finder, findsOneWidget);
            final paragraph = tester.renderObject<RenderParagraph>(finder);
            expect(paragraph.didExceedMaxLines, isFalse);
          }
          final text = tester.widget<Text>(details).data!;
          if (locale == 'zh') {
            final expected = switch (provider) {
              'acfun' => ['1 种清晰度', '弹幕', '直播弹幕'],
              'cctv' => ['2 路媒体流', 'HLS 视频', 'HLS 音频', '1 个章节', '受保护'],
              'douyu' => ['回放', '1 种清晰度', '1 条 CDN 线路', '123 人观看'],
              'huya' => ['直播', '1 种清晰度', '1 条 CDN 线路'],
              _ => <String>[],
            };
            for (final value in expected) {
              expect(text, contains(value));
            }
          }
          expect(text, isNot(contains(' · /')));
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
