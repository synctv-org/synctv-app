import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_add_target.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/youtube_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/youtube_playlist_preview.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as common;
import 'package:synctv_app/src/generated/proto/providers/youtube.pb.dart'
    as youtube;

import '../../../../test_app.dart';

class _Gateway implements ProviderGateway {
  final pending = Completer<String>();
  final calls = <({String room, String playlist, String name})>[];

  @override
  Future<String> addDiscoveredSource(
    String roomId, {
    required common.DiscoveredSource source,
    String playlistId = '',
    String name = '',
  }) async {
    calls.add((room: roomId, playlist: playlistId, name: name));
    return pending.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  late _Gateway gateway;
  late List<bool> drafts;
  late List<youtube.ListItem> items;

  Future<void> render(
    WidgetTester tester, {
    String room = 'room',
    String playlist = 'playlist',
    _Gateway? replacement,
  }) => tester.pumpWidget(
    MaterialApp(
      builder: buildThemedTestApp,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: DependencyScope<ProviderGateway>(
        value: replacement ?? gateway,
        child: Scaffold(
          body: YoutubeAddMediaForm(
            roomId: room,
            playlistId: playlist,
            binds: const [],
            onDraftChanged: drafts.add,
            onResolve: (_) async => youtube.ResolveResponse(
              source: testDiscoveredMediaSource(),
              metadata: youtube.Metadata(title: 'Video'),
            ),
            onList: (_) async => youtube.ListResponse(
              source: testDiscoveredPlaylistSource(),
              items: items,
            ),
          ),
        ),
      ),
    ),
  );

  AppTextField field(WidgetTester tester, String id) =>
      tester.widget<AppTextField>(find.byKey(Key('youtube-$id')));

  Future<void> prepare(WidgetTester tester, String mode) async {
    gateway = _Gateway();
    await tester.binding.setSurfaceSize(const Size(1100, 850));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    addTearDown(() async {
      if (!gateway.pending.isCompleted) gateway.pending.complete('cleanup');
      await tester.pump();
    });
    await render(tester);
    if (mode != 'video') {
      tester
          .widget<ProviderAddTargetSelector>(
            find.byType(ProviderAddTargetSelector),
          )
          .onChanged(
            mode == 'bulk'
                ? ProviderAddTarget.media
                : ProviderAddTarget.playlist,
          );
      await tester.pump();
    }
    await tester.enterText(
      find.byKey(const Key('youtube-value')),
      mode == 'video' ? 'dQw4w9WgXcQ' : 'PL123',
    );
    if (mode != 'bulk') {
      await tester.enterText(find.byKey(const Key('youtube-name')), 'Original');
    }
    await tester.pump();
    tester
        .widget<OutlinedButton>(find.byKey(const Key('youtube-preview')))
        .onPressed!();
    await tester.pumpAndSettle();
    if (mode == 'bulk') {
      tester
          .widget<YoutubePlaylistPreview>(find.byType(YoutubePlaylistPreview))
          .onAddSelected!(items);
    } else {
      tester
          .widget<FilledButton>(find.byKey(const Key('youtube-submit')))
          .onPressed!();
    }
    await tester.pump();
    expect(gateway.calls, hasLength(1));
    drafts.clear();
  }

  setUp(() {
    drafts = [];
    items = [
      for (final name in ['One', 'Two'])
        youtube.ListItem(
          videoId: name,
          title: name,
          source: testDiscoveredMediaSource(),
        ),
    ];
  });

  for (final mode in ['video', 'playlist', 'bulk']) {
    for (final change in ['room', 'playlist', 'round-trip', 'name']) {
      if (mode == 'bulk' && change == 'name') continue;
      testWidgets('$mode completion preserves draft after $change change', (
        tester,
      ) async {
        await prepare(tester, mode);
        if (change == 'name') {
          field(tester, 'name').controller.text = 'New name';
        } else {
          await render(
            tester,
            room: change == 'playlist' ? 'room' : 'next',
            playlist: change == 'playlist' ? 'next' : 'playlist',
          );
          if (change == 'round-trip') await render(tester);
        }
        gateway.pending.complete('added');
        await tester.pumpAndSettle();
        expect(
          field(tester, 'value').controller.text,
          mode == 'video' ? 'dQw4w9WgXcQ' : 'PL123',
        );
        if (mode != 'bulk') {
          expect(
            field(tester, 'name').controller.text,
            change == 'name' ? 'New name' : 'Original',
          );
        }
        expect(drafts, isEmpty);
        expect(field(tester, 'value').enabled, isTrue);
        expect(
          gateway.calls.every(
            (call) => call.room == 'room' && call.playlist == 'playlist',
          ),
          isTrue,
        );
      });
    }
    testWidgets('$mode current success clears its draft', (tester) async {
      await prepare(tester, mode);
      gateway.pending.complete('added');
      await tester.pumpAndSettle();
      expect(field(tester, 'value').controller.text, isEmpty);
      if (mode != 'bulk') {
        expect(field(tester, 'name').controller.text, isEmpty);
      }
      expect(drafts, [false]);
      await tester.pump(const Duration(seconds: 4));
    });
    testWidgets('$mode obsolete failure does not notify the new destination', (
      tester,
    ) async {
      await prepare(tester, mode);
      await render(tester, room: 'next');
      gateway.pending.completeError(StateError('Old write failed'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Old write failed'), findsNothing);
      if (mode != 'bulk') {
        expect(field(tester, 'name').controller.text, 'Original');
      }
      expect(field(tester, 'value').enabled, isTrue);
    });
  }

  testWidgets('bulk keeps its gateway and snapshots remaining item names', (
    tester,
  ) async {
    await prepare(tester, 'bulk');
    final replacement = _Gateway();
    replacement.pending.complete('unexpected');
    await render(tester, room: 'next', replacement: replacement);
    items[1].title = 'Changed';
    gateway.pending.complete('added');
    await tester.pumpAndSettle();
    expect(gateway.calls.map((call) => call.name), ['One', 'Two']);
    expect(replacement.calls, isEmpty);
  });

  testWidgets('bulk completion after disposal finishes original batch', (
    tester,
  ) async {
    await prepare(tester, 'bulk');
    await tester.pumpWidget(const SizedBox());
    gateway.pending.complete('added');
    await tester.pumpAndSettle();
    expect(gateway.calls.map((call) => call.name), ['One', 'Two']);
    expect(drafts, isEmpty);
    expect(tester.takeException(), isNull);
  });
}
