import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_account_action.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_add_target.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/youtube_add_media_form.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/src/generated/proto/providers/youtube.pb.dart'
    as youtube;

import '../../../../test_app.dart';

void main() {
  const account = YoutubeBindInfo(
    id: 'account',
    serverId: 'server',
    label: 'Account',
    hasVisitorData: true,
    hasPoToken: true,
    hasCookie: true,
    createdAt: 1,
    providerInstanceName: 'instance',
  );
  late List<Completer<String>> pending;
  Completer<void>? adding;
  var submissions = 0;
  Future<String> request() {
    final completion = Completer<String>();
    pending.add(completion);
    return completion.future;
  }

  Future<void> render(
    WidgetTester tester, {
    String room = 'room',
    List<YoutubeBindInfo> binds = const [account],
  }) => tester.pumpWidget(
    MaterialApp(
      builder: buildThemedTestApp,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: YoutubeAddMediaForm(
          roomId: room,
          playlistId: '',
          binds: binds,
          onDraftChanged: (_) {},
          onSubmit: (_) async {
            submissions++;
            await adding?.future;
          },
          onResolve: (_) async => youtube.ResolveResponse(
            metadata: youtube.Metadata(title: await request()),
            source: testDiscoveredMediaSource(),
          ),
          onList: (_) async => youtube.ListResponse(
            items: [
              youtube.ListItem(
                videoId: 'video',
                title: await request(),
                source: testDiscoveredMediaSource(),
              ),
            ],
            source: testDiscoveredPlaylistSource(),
          ),
        ),
      ),
    ),
  );
  VoidCallback? preview(WidgetTester tester) => tester
      .widget<OutlinedButton>(find.byKey(const Key('youtube-preview')))
      .onPressed;
  Future<void> prepare(WidgetTester tester, bool list) async {
    await tester.binding.setSurfaceSize(const Size(1100, 850));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    addTearDown(() async {
      if (adding case final request? when !request.isCompleted) {
        request.complete();
      }
      for (final request in pending) {
        if (!request.isCompleted) request.complete('Cleanup');
      }
      await tester.pump();
    });
    await render(tester);
    if (list) {
      tester
          .widget<ProviderAddTargetSelector>(
            find.byType(ProviderAddTargetSelector),
          )
          .onChanged(ProviderAddTarget.playlist);
      await tester.pump();
    }
    tester
        .widget<ProviderAccountSelector<YoutubeBindInfo>>(
          find.byType(ProviderAccountSelector<YoutubeBindInfo>),
        )
        .onChanged(account);
    await tester.pump();
    await tester.enterText(
      find.byKey(const Key('youtube-value')),
      list ? 'PL123' : 'dQw4w9WgXcQ',
    );
    await tester.pump();
  }

  setUp(() {
    pending = [];
    adding = null;
    submissions = 0;
  });

  for (final list in [false, true]) {
    testWidgets(
      'list=$list adding stays exclusive across preview invalidation',
      (tester) async {
        await prepare(tester, list);
        preview(tester)!();
        pending.single.complete('Current preview');
        await tester.pumpAndSettle();
        adding = Completer<void>();
        final submit = tester
            .widget<FilledButton>(find.byKey(const Key('youtube-submit')))
            .onPressed!;
        submit();
        submit();
        expect(submissions, 1);
        await render(tester, room: 'new-room');
        expect(preview(tester), isNull);
        expect(
          tester
              .widget<AppTextField>(find.byKey(const Key('youtube-value')))
              .enabled,
          isFalse,
        );
        adding!.complete();
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<AppTextField>(find.byKey(const Key('youtube-value')))
              .enabled,
          isTrue,
        );
        await tester.pump(const Duration(seconds: 4));
      },
    );

    testWidgets('list=$list current failure permits a retry', (tester) async {
      await prepare(tester, list);
      preview(tester)!();
      pending.single.completeError(StateError('Request failed'));
      await tester.pumpAndSettle();
      expect(preview(tester), isNotNull);
      preview(tester)!();
      pending.last.complete('Retry preview');
      await tester.pumpAndSettle();
      expect(find.text('Retry preview'), findsOneWidget);
      expect(pending, hasLength(2));
      await tester.pump(const Duration(seconds: 4));
    });

    testWidgets('list=$list suppresses duplicate preview before rebuild', (
      tester,
    ) async {
      await prepare(tester, list);
      final invoke = preview(tester)!;
      invoke();
      invoke();
      expect(pending, hasLength(1));
      pending.single.complete('Current preview');
      await tester.pumpAndSettle();
      expect(find.text('Current preview'), findsOneWidget);
    });

    for (final transition in ['room', 'account']) {
      for (final failure in [false, true]) {
        testWidgets(
          'list=$list ignores old response after $transition failure=$failure',
          (tester) async {
            await prepare(tester, list);
            preview(tester)!();
            await tester.pump();
            await render(
              tester,
              room: transition == 'room' ? 'new-room' : 'room',
              binds: transition == 'account' ? [] : [account],
            );
            expect(preview(tester), isNotNull);
            preview(tester)!();
            expect(pending, hasLength(2));
            if (failure) {
              pending.first.completeError(StateError('Obsolete preview'));
            } else {
              pending.first.complete('Obsolete preview');
            }
            await tester.pump();
            expect(find.textContaining('Obsolete preview'), findsNothing);
            expect(preview(tester), isNull);
            pending.last.complete('Current preview');
            await tester.pumpAndSettle();
            expect(find.text('Current preview'), findsOneWidget);
            expect(preview(tester), isNotNull);
            expect(tester.takeException(), isNull);
          },
        );
      }
    }

    testWidgets('list=$list completion after disposal is ignored', (
      tester,
    ) async {
      await prepare(tester, list);
      final request =
          Function.apply(preview(tester)!, const []) as Future<void>;
      await tester.pumpWidget(const SizedBox.shrink());
      pending.single.complete('Disposed preview');
      await request;
      expect(tester.takeException(), isNull);
    });
  }
}
