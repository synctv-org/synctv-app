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
  final calls = <String>[];
  String? failing = 'Two';
  @override
  Future<String> addDiscoveredSource(
    String roomId, {
    required common.DiscoveredSource source,
    String playlistId = '',
    String name = '',
  }) async {
    calls.add(name);
    if (name == failing) throw StateError('Write failed');
    return name;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  late _Gateway gateway;
  late List<youtube.ListItem> items;
  Future<void> prepare(WidgetTester tester, {bool ids = true}) async {
    gateway = _Gateway();
    items = [
      for (final name in ['One', 'Two', 'Three'])
        youtube.ListItem(
          videoId: ids ? name : '',
          title: name,
          source: testDiscoveredMediaSource(),
        ),
    ];
    await tester.binding.setSurfaceSize(const Size(1100, 850));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: DependencyScope<ProviderGateway>(
          value: gateway,
          child: Scaffold(
            body: YoutubeAddMediaForm(
              roomId: 'room',
              playlistId: 'playlist',
              binds: const [],
              onDraftChanged: (_) {},
              onList: (_) async => youtube.ListResponse(
                items: items,
                source: testDiscoveredPlaylistSource(),
              ),
            ),
          ),
        ),
      ),
    );
    tester
        .widget<ProviderAddTargetSelector>(
          find.byType(ProviderAddTargetSelector),
        )
        .onChanged(ProviderAddTarget.media);
    await tester.pump();
    await tester.enterText(find.byKey(const Key('youtube-value')), 'PL123');
    await tester.pump();
    tester
        .widget<OutlinedButton>(find.byKey(const Key('youtube-preview')))
        .onPressed!();
    await tester.pumpAndSettle();
  }

  Future<void> add(WidgetTester tester) async {
    tester
        .widget<OutlinedButton>(
          find.byKey(const Key('youtube-preview-add-selected')),
        )
        .onPressed!();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));
  }

  for (final ids in [false, true]) {
    testWidgets('ids=$ids retry omits confirmed successful items', (
      tester,
    ) async {
      await prepare(tester, ids: ids);
      await add(tester);
      expect(gateway.calls, ['One', 'Two']);
      expect(find.text('One'), findsNothing);
      expect(find.text('Two'), findsOneWidget);
      expect(find.text('Three'), findsOneWidget);
      await add(tester);
      expect(gateway.calls, ['One', 'Two', 'Two']);
      gateway.failing = null;
      await add(tester);
      expect(gateway.calls, ['One', 'Two', 'Two', 'Two', 'Three']);
      expect(find.byType(YoutubePlaylistPreview), findsNothing);
    });

    testWidgets(
      'ids=$ids partial success preserves deselection of later items',
      (tester) async {
        await prepare(tester, ids: ids);
        final third = find.widgetWithText(ListTile, 'Three');
        await tester.tap(third);
        await tester.pump();
        await add(tester);
        final check = find.descendant(
          of: third,
          matching: find.byType(AppCheckbox),
        );
        expect(tester.widget<AppCheckbox>(check).value, isFalse);
        gateway.failing = null;
        await add(tester);
        expect(gateway.calls, ['One', 'Two', 'Two']);
      },
    );
  }

  testWidgets('retained parent callback cannot resubmit successful items', (
    tester,
  ) async {
    await prepare(tester);
    final submit = tester
        .widget<YoutubePlaylistPreview>(find.byType(YoutubePlaylistPreview))
        .onAddSelected!;
    await add(tester);
    submit(items);
    await tester.pumpAndSettle();
    expect(gateway.calls, ['One', 'Two', 'Two']);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('retained parent callback rejects invalidated preview items', (
    tester,
  ) async {
    await prepare(tester);
    final submit = tester
        .widget<YoutubePlaylistPreview>(find.byType(YoutubePlaylistPreview))
        .onAddSelected!;
    await tester.enterText(find.byKey(const Key('youtube-value')), 'PL456');
    await tester.pump();
    submit(items);
    await tester.pumpAndSettle();
    expect(gateway.calls, isEmpty);
    await tester.pump(const Duration(seconds: 4));
  });
}
