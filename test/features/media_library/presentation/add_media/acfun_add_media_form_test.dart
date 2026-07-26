import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/src/generated/proto/providers/acfun.pb.dart'
    as acfun;
import 'package:synctv_app/src/generated/proto/providers/acfun.pbenum.dart'
    as acfun_enum;
import 'package:synctv_app/features/media_library/presentation/add_media/acfun_add_media_form.dart';

void main() {
  testWidgets('AcFun preview exposes formats, tags, and danmaku capabilities', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AcFunAddMediaForm(
            roomId: 'room',
            playlistId: '',
            instances: const [],
            onDraftChanged: (_) {},
            onResolve: (_) async => acfun.ResolveResponse(
              kind: acfun_enum.ResourceKind.RESOURCE_KIND_VIDEO,
              metadata: acfun.Metadata(
                id: 'ac123',
                title: 'AcFun Video',
                author: 'UP',
                thumbnailUrl: 'https://img.example/cover.jpg',
                tags: const ['Animation', 'Music'],
                hasDanmaku: true,
              ),
              qualities: [
                acfun.Quality(
                  name: '1080p',
                  format: acfun_enum.StreamFormat.STREAM_FORMAT_HLS,
                ),
                acfun.Quality(
                  name: '720p',
                  format: acfun_enum.StreamFormat.STREAM_FORMAT_FLV,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.enterText(find.byKey(const Key('acfun-resource')), 'ac123');
    await tester.pump();
    await tester.tap(find.byKey(const Key('acfun-preview')));
    await tester.pumpAndSettle();

    expect(find.text('AcFun Video'), findsOneWidget);
    expect(find.textContaining('2 qualities'), findsOneWidget);
    expect(find.textContaining('HLS/FLV'), findsOneWidget);
    expect(find.textContaining('Danmaku'), findsOneWidget);
    expect(find.textContaining('Animation/Music'), findsOneWidget);
  });

  testWidgets('AcFun form submits provider instance and bangumi resource', (
    tester,
  ) async {
    AcFunAddRequest? submitted;
    await tester.binding.setSurfaceSize(const Size(900, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AcFunAddMediaForm(
            roomId: 'room',
            playlistId: '',
            instances: const ['acfun-edge'],
            onDraftChanged: (_) {},
            onSubmit: (request) async => submitted = request,
          ),
        ),
      ),
    );
    await tester.enterText(
      find.byKey(const Key('acfun-resource')),
      'https://www.acfun.cn/bangumi/aa123?ac=456',
    );
    await tester.tap(find.text('Local instance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('acfun-edge').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('acfun-submit')));
    await tester.pumpAndSettle();

    expect(submitted?.resource, contains('aa123'));
    expect(submitted?.instanceName, 'acfun-edge');
    await tester.pump(const Duration(seconds: 4));
  });
}
