import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/src/generated/proto/providers/douyu.pb.dart'
    as douyu;
import 'package:synctv_app/src/generated/proto/providers/douyu.pbenum.dart'
    as douyu_enum;
import 'package:synctv_app/features/media_library/presentation/add_media/douyu_add_media_form.dart';

void main() {
  testWidgets('Douyu preview exposes codecs, formats, CDNs, and metadata', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: DouyuAddMediaForm(
            roomId: 'room',
            playlistId: '',
            instances: const [],
            onDraftChanged: (_) {},
            onResolve: (_) async => douyu.ResolveResponse(
              metadata: douyu.Metadata(
                roomId: '9999',
                title: 'Douyu Live',
                author: 'Streamer',
                category: 'Game',
                thumbnailUrl: 'https://img.example/live.jpg',
                isLive: true,
                viewerCount: Int64(42),
              ),
              qualities: [
                douyu.Quality(
                  name: 'Original',
                  cdn: 'ws-h5',
                  codec: douyu_enum.Codec.CODEC_HEVC,
                  format: douyu_enum.StreamFormat.STREAM_FORMAT_HLS,
                ),
                douyu.Quality(
                  name: 'High',
                  cdn: 'tct-h5',
                  codec: douyu_enum.Codec.CODEC_AVC,
                  format: douyu_enum.StreamFormat.STREAM_FORMAT_FLV,
                ),
                douyu.Quality(
                  name: 'Audio',
                  cdn: 'ws-h5',
                  codec: douyu_enum.Codec.CODEC_AAC,
                  format: douyu_enum.StreamFormat.STREAM_FORMAT_FLV,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.enterText(find.byKey(const Key('douyu-resource')), '9999');
    await tester.pump();
    await tester.tap(find.byKey(const Key('douyu-preview')));
    await tester.pumpAndSettle();

    expect(find.text('Douyu Live'), findsOneWidget);
    expect(find.textContaining('3 qualities'), findsOneWidget);
    expect(find.textContaining('HEVC/AVC/AAC'), findsOneWidget);
    expect(find.textContaining('HLS/FLV'), findsOneWidget);
    expect(find.textContaining('2 CDNs'), findsOneWidget);
    expect(find.textContaining('42 viewers'), findsOneWidget);
  });

  testWidgets('Douyu form submits room alias and provider instance', (
    tester,
  ) async {
    DouyuAddRequest? submitted;
    await tester.binding.setSurfaceSize(const Size(900, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: DouyuAddMediaForm(
            roomId: 'room',
            playlistId: '',
            instances: const ['douyu-edge'],
            onDraftChanged: (_) {},
            onSubmit: (request) async => submitted = request,
          ),
        ),
      ),
    );
    await tester.enterText(
      find.byKey(const Key('douyu-resource')),
      'https://www.douyu.com/room-alias',
    );
    await tester.tap(find.text('Default'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('douyu-edge').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('douyu-submit')));
    await tester.pumpAndSettle();

    expect(submitted?.resource, contains('room-alias'));
    expect(submitted?.instanceName, 'douyu-edge');
    await tester.pump(const Duration(seconds: 4));
  });
}
