import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/src/generated/proto/providers/huya.pb.dart' as huya;
import 'package:synctv_app/src/generated/proto/providers/huya.pbenum.dart'
    as huya_enum;
import 'package:synctv_app/features/media_library/presentation/add_media/huya_add_media_form.dart';

void main() {
  testWidgets('Huya preview exposes native formats, CDNs, and metadata', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: HuyaAddMediaForm(
            roomId: 'room',
            playlistId: '',
            instances: const [],
            onDraftChanged: (_) {},
            onResolve: (_) async => huya.ResolveResponse(
              kind: huya_enum.ResourceKind.RESOURCE_KIND_LIVE,
              metadata: huya.Metadata(
                id: '660000',
                title: 'Huya Live',
                author: 'Streamer',
                category: 'Game',
                thumbnailUrl: 'https://img.example/live.jpg',
                isLive: true,
              ),
              qualities: [
                huya.Quality(
                  name: 'Original',
                  cdn: 'AL',
                  format: huya_enum.StreamFormat.STREAM_FORMAT_HLS,
                ),
                huya.Quality(
                  name: 'Original',
                  cdn: 'TX',
                  format: huya_enum.StreamFormat.STREAM_FORMAT_FLV,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('huya-resource')),
      'https://www.huya.com/660000',
    );
    await tester.pump();
    await tester.tap(find.byKey(const Key('huya-preview')));
    await tester.pumpAndSettle();

    expect(find.text('Huya Live'), findsOneWidget);
    expect(find.textContaining('Streamer'), findsOneWidget);
    expect(find.textContaining('2 qualities'), findsOneWidget);
    expect(find.textContaining('HLS/FLV'), findsOneWidget);
    expect(find.textContaining('2 CDNs'), findsOneWidget);
  });

  testWidgets('Huya form submits provider instance and resource', (
    tester,
  ) async {
    HuyaAddRequest? submitted;
    await tester.binding.setSurfaceSize(const Size(900, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: HuyaAddMediaForm(
            roomId: 'room',
            playlistId: '',
            instances: const ['huya-edge'],
            onDraftChanged: (_) {},
            onSubmit: (request) async => submitted = request,
          ),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('huya-resource')),
      'https://www.huya.com/video/play/1002412640.html',
    );
    await tester.enterText(find.byKey(const Key('huya-name')), 'Replay');
    await tester.tap(find.text('Default'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('huya-edge').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('huya-submit')));
    await tester.pumpAndSettle();

    expect(submitted?.resource, contains('1002412640'));
    expect(submitted?.name, 'Replay');
    expect(submitted?.instanceName, 'huya-edge');
    await tester.pump(const Duration(seconds: 4));
  });
}
