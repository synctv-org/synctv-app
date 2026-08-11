import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/src/generated/proto/providers/douyin.pb.dart'
    as douyin;
import 'package:synctv_app/features/media_library/presentation/add_media/douyin_add_media_form.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

import '../../../../test_app.dart';

void main() {
  testWidgets('Douyin form submits live source with shared credential scope', (
    tester,
  ) async {
    DouyinAddRequest? submitted;
    await tester.binding.setSurfaceSize(const Size(900, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: DouyinAddMediaForm(
            roomId: 'room',
            playlistId: '',
            binds: const [
              DouyinBindInfo(
                id: '1',
                serverId: 'douyin-default',
                label: 'Browser',
                hasCookie: true,
                createdAt: 1,
                providerInstanceName: '',
              ),
            ],
            onDraftChanged: (_) {},
            onResolve: (_) async => douyin.ResolveResponse(
              metadata: douyin.Metadata(title: 'Live room'),
              source: testDiscoveredMediaSource(),
            ),
            onSubmit: (request) async => submitted = request,
          ),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('douyin-value')),
      '7123456789012345678',
    );
    await tester.tap(find.text('Live'));
    await tester.pump();
    expect(
      tester
          .widget<AppTextField>(find.byKey(const Key('douyin-value')))
          .controller
          .text,
      isEmpty,
    );
    await tester.enterText(
      find.byKey(const Key('douyin-value')),
      'https://live.douyin.com/123456',
    );
    await tester.enterText(find.byKey(const Key('douyin-name')), 'Live room');
    await tester.tap(find.text('Share my credentials'));
    await tester.pump();
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('douyin-submit')))
          .onPressed,
      isNull,
    );
    await tester.tap(find.byKey(const Key('douyin-preview')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('douyin-submit')));
    await tester.pumpAndSettle();

    expect(submitted, isNotNull);
    expect(submitted!.mode, DouyinAddMode.live);
    expect(submitted!.value, 'https://live.douyin.com/123456');
    expect(submitted!.name, 'Live room');
    expect(submitted!.shared, isTrue);
    await tester.pump(const Duration(seconds: 4));
  });
}
