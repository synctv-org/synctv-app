import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/src/generated/proto/providers/cctv.pb.dart' as cctv;
import 'package:synctv_app/src/generated/proto/providers/cctv.pbenum.dart'
    as cctv_enum;
import 'package:synctv_app/features/media_library/presentation/add_media/cctv_add_media_form.dart';

import '../../../../test_app.dart';

void main() {
  testWidgets('CCTV preview exposes native streams, chapters, and metadata', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: CctvAddMediaForm(
            roomId: 'room',
            playlistId: '',
            instances: const [],
            onResolve: (_) async => cctv.ResolveResponse(
              metadata: cctv.Metadata(
                videoId: '5c846c0518444308ba32c4159df3b3e0',
                title: 'CCTV Programme',
                channel: 'CCTV-1',
                column: 'News',
                thumbnailUrl: 'https://img.example/cover.jpg',
                tags: const ['Current affairs'],
                chapters: [cctv.Chapter(title: 'Opening')],
              ),
              streams: [
                cctv.Stream(
                  name: 'HLS',
                  kind: cctv_enum.StreamKind.STREAM_KIND_VIDEO_HLS,
                ),
                cctv.Stream(
                  name: 'Audio',
                  kind: cctv_enum.StreamKind.STREAM_KIND_AUDIO_HLS,
                ),
                cctv.Stream(
                  name: 'HTTP',
                  kind: cctv_enum.StreamKind.STREAM_KIND_HTTP,
                ),
              ],
              source: testDiscoveredMediaSource(),
            ),
          ),
        ),
      ),
    );
    await tester.enterText(
      find.byKey(const Key('cctv-resource')),
      '5c846c0518444308ba32c4159df3b3e0',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('cctv-preview')));
    await tester.pumpAndSettle();

    expect(find.text('CCTV Programme'), findsOneWidget);
    expect(find.textContaining('3 streams'), findsOneWidget);
    expect(find.textContaining('HLS video/HLS audio/HTTP'), findsOneWidget);
    expect(find.textContaining('1 chapters'), findsOneWidget);
    expect(find.textContaining('CCTV-1'), findsOneWidget);
  });

  testWidgets('CCTV form submits the selected provider instance', (
    tester,
  ) async {
    CctvAddRequest? submitted;
    await tester.binding.setSurfaceSize(const Size(900, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: CctvAddMediaForm(
            roomId: 'room',
            playlistId: '',
            instances: const ['cctv-edge'],
            onResolve: (_) async => cctv.ResolveResponse(
              metadata: cctv.Metadata(title: 'CCTV Programme'),
              source: testDiscoveredMediaSource(),
            ),
            onSubmit: (request) async => submitted = request,
          ),
        ),
      ),
    );
    await tester.enterText(
      find.byKey(const Key('cctv-resource')),
      '5C846C0518444308BA32C4159DF3B3E0',
    );
    await tester.tap(find.text('Local instance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('cctv-edge').last);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('cctv-submit')))
          .onPressed,
      isNull,
    );
    await tester.tap(find.byKey(const Key('cctv-preview')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('cctv-submit')));
    await tester.pumpAndSettle();

    expect(submitted?.resource, '5C846C0518444308BA32C4159DF3B3E0');
    expect(submitted?.instanceName, 'cctv-edge');
    await tester.pump(const Duration(seconds: 4));
  });
}
