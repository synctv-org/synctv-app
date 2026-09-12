import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_add_target.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/youtube_add_media_form.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/providers/youtube.pb.dart'
    as youtube;

import '../../../../test_app.dart';

void main() {
  for (final list in [false, true]) {
    for (final scale in [1.0, 3.0]) {
      for (final invalidate in [false, true]) {
        testWidgets(
          'list=$list scale=$scale invalidate=$invalidate returns to controls after preview removal',
          (tester) async {
            await tester.binding.setSurfaceSize(const Size(320, 568));
            addTearDown(() => tester.binding.setSurfaceSize(null));
            var room = 'room';
            late StateSetter update;
            await tester.pumpWidget(
              MaterialApp(
                builder: (context, child) => buildThemedTestApp(
                  context,
                  MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: TextScaler.linear(scale)),
                    child: child!,
                  ),
                ),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                home: StatefulBuilder(
                  builder: (context, setState) {
                    update = setState;
                    return Scaffold(
                      body: YoutubeAddMediaForm(
                        roomId: room,
                        playlistId: '',
                        binds: const [],
                        onDraftChanged: (_) {},
                        onSubmit: (_) async {},
                        onResolve: (_) async => youtube.ResolveResponse(
                          source: testDiscoveredMediaSource(),
                          metadata: youtube.Metadata(title: 'Preview'),
                        ),
                        onList: (_) async => youtube.ListResponse(
                          source: testDiscoveredPlaylistSource(),
                          items: [
                            youtube.ListItem(
                              videoId: 'video',
                              title: 'Preview',
                              source: testDiscoveredMediaSource(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
            if (list) {
              tester
                  .widget<ProviderAddTargetSelector>(
                    find.byType(ProviderAddTargetSelector),
                  )
                  .onChanged(ProviderAddTarget.playlist);
              await tester.pump();
            }
            await tester.enterText(
              find.byKey(const Key('youtube-value')),
              list ? 'PL123' : 'dQw4w9WgXcQ',
            );
            FocusManager.instance.primaryFocus?.unfocus();
            await tester.pump();
            tester
                .widget<OutlinedButton>(
                  find.byKey(const Key('youtube-preview')),
                )
                .onPressed!();
            await tester.pumpAndSettle();
            final submit = tester
                .widget<FilledButton>(find.byKey(const Key('youtube-submit')))
                .onPressed!;
            final nested = tester.state<NestedScrollViewState>(
              find.byType(NestedScrollView),
            );
            nested.outerController.jumpTo(
              nested.outerController.position.maxScrollExtent,
            );
            await tester.pumpAndSettle();
            if (invalidate) {
              update(() => room = 'other');
            } else {
              submit();
            }
            await tester.pumpAndSettle();
            expect(find.byType(NestedScrollView), findsNothing);
            expect(
              tester.getTopLeft(find.byType(ProviderAddTargetSelector)).dy,
              0,
            );
            expect(tester.takeException(), isNull);
            await tester.pump(const Duration(seconds: 4));
          },
        );
      }
    }
  }
}
