import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/src/generated/proto/providers/tiktok.pb.dart'
    as tiktok;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/features/media_library/presentation/add_media/tiktok_add_media_form.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

void main() {
  testWidgets('TikTok form submits live source with shared credential scope', (
    tester,
  ) async {
    TikTokAddRequest? submitted;
    await tester.binding.setSurfaceSize(const Size(900, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TikTokAddMediaForm(
            roomId: 'room',
            playlistId: '',
            binds: const [
              TikTokBindInfo(
                id: '1',
                serverId: 'tiktok-default',
                label: 'Browser',
                hasCookie: true,
                createdAt: 1,
                providerInstanceName: '',
              ),
            ],
            onDraftChanged: (_) {},
            onSubmit: (request) async => submitted = request,
          ),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('tiktok-value')),
      '7123456789012345678',
    );
    await tester.tap(find.text('Live'));
    await tester.pump();
    expect(
      tester
          .widget<AppTextField>(find.byKey(const Key('tiktok-value')))
          .controller
          .text,
      isEmpty,
    );
    await tester.enterText(
      find.byKey(const Key('tiktok-value')),
      'https://www.tiktok.com/@creator/live',
    );
    await tester.enterText(find.byKey(const Key('tiktok-name')), 'Live room');
    await tester.tap(find.byType(Switch));
    await tester.tap(find.byKey(const Key('tiktok-submit')));
    await tester.pumpAndSettle();

    expect(submitted, isNotNull);
    expect(submitted!.mode, TikTokAddMode.live);
    expect(submitted!.value, 'https://www.tiktok.com/@creator/live');
    expect(submitted!.name, 'Live room');
    expect(submitted!.shared, isTrue);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('TikTok posts preview resolves username to stable secUid', (
    tester,
  ) async {
    String? listedSecUid;
    await tester.binding.setSurfaceSize(const Size(900, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TikTokAddMediaForm(
            roomId: 'room',
            playlistId: '',
            binds: const [],
            onDraftChanged: (_) {},
            onGetUser: (request) async => tiktok.GetUserResponse(
              secUid: 'MS4wLjABAAAAstable',
              sourceConfig: source_config.TikTokPlaylistSourceConfig(
                secUid: 'MS4wLjABAAAAstable',
              ),
            ),
            onListUserPosts: (request, secUid) async {
              listedSecUid = secUid;
              return tiktok.ListUserPostsResponse(
                items: [
                  tiktok.ListItem(
                    videoId: '7412345678901234567',
                    title: 'First post',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Posts'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('tiktok-value')), '@creator');
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('tiktok-preview')));
    await tester.tap(find.byKey(const Key('tiktok-preview')));
    await tester.pumpAndSettle();

    expect(listedSecUid, 'MS4wLjABAAAAstable');
    expect(find.text('First post'), findsOneWidget);
  });
}
