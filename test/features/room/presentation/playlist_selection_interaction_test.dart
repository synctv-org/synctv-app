import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room/presentation/models/playlist_selection_policy.dart';

void main() {
  testWidgets('selection works without exposing delete permission', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: _SelectionHarness(canDeleteMedia: false, canClearMedia: true),
      ),
    );

    await tester.longPress(find.byKey(const Key('entry-opaque-media-a')));
    await tester.pump();

    expect(find.text('Selected 1'), findsOneWidget);
    await tester.tap(find.byKey(const Key('entry-dynamic-child')));
    await tester.pump();
    expect(find.text('Selected 2'), findsOneWidget);
    expect(find.byKey(const Key('delete-selection')), findsNothing);
    expect(find.byKey(const Key('clear-playlist')), findsOneWidget);
  });

  testWidgets('long press and taps update a multi-item selection', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: _SelectionHarness(canDeleteMedia: true, canClearMedia: false),
      ),
    );

    final first = find.byKey(const Key('entry-opaque-media-a'));
    final second = find.byKey(const Key('entry-dynamic-child'));

    await tester.longPress(first);
    await tester.pump();
    expect(find.text('Selected 1'), findsOneWidget);
    expect(find.byKey(const Key('delete-selection')), findsOneWidget);

    await tester.tap(second);
    await tester.pump();
    expect(find.text('Selected 2'), findsOneWidget);

    final dynamicPlaylist = find.byKey(
      const Key('entry-opaque-dynamic-playlist'),
    );
    await tester.longPress(dynamicPlaylist);
    await tester.pump();
    expect(find.text('Selected 3'), findsOneWidget);

    await tester.tap(dynamicPlaylist);
    await tester.pump();
    expect(find.text('Selected 3'), findsOneWidget);

    await tester.tap(first);
    await tester.pump();
    expect(find.text('Selected 2'), findsOneWidget);

    await tester.tap(second);
    await tester.pump();
    expect(find.text('Selected 1'), findsOneWidget);

    await tester.longPress(dynamicPlaylist);
    await tester.pump();
    expect(find.text('Selected 0'), findsOneWidget);
    expect(find.byKey(const Key('delete-selection')), findsNothing);
  });

  testWidgets('provider-generated entries support read-only selection', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: _SelectionHarness(
          canDeleteMedia: true,
          canClearMedia: false,
          readOnlyScope: true,
        ),
      ),
    );

    await tester.longPress(find.byKey(const Key('entry-dynamic-child')));
    await tester.pump();

    expect(find.text('Selected 1'), findsOneWidget);
    expect(find.byKey(const Key('delete-selection')), findsNothing);
  });
}

class _SelectionHarness extends StatefulWidget {
  const _SelectionHarness({
    required this.canDeleteMedia,
    required this.canClearMedia,
    this.readOnlyScope = false,
  });

  final bool canDeleteMedia;
  final bool canClearMedia;
  final bool readOnlyScope;

  @override
  State<_SelectionHarness> createState() => _SelectionHarnessState();
}

class _SelectionHarnessState extends State<_SelectionHarness> {
  static final entries = <RoomMediaEntry>[
    RoomMediaItem(
      id: 'opaque-media-a',
      name: 'Media A',
      url: 'https://example.test/a.mp4',
    ),
    RoomPlaylistItem(id: 'opaque-playlist-b', name: 'Playlist B'),
    RoomPlaylistItem(
      id: 'opaque-dynamic-playlist',
      name: 'Dynamic playlist',
      metadata: const {'isDynamic': true},
    ),
    RoomDynamicMediaEntry(
      id: 'dynamic-child',
      name: 'Dynamic child',
      parentId: 'provider-playlist',
      subPath: '/child',
      isPlaylist: false,
    ),
  ];

  final selectedIds = <String>{};
  bool selectionMode = false;

  void _apply(RoomMediaEntry entry, PlaylistEntryGestureIntent intent) {
    setState(() {
      switch (intent) {
        case PlaylistEntryGestureIntent.activate:
          return;
        case PlaylistEntryGestureIntent.enterSelection:
          selectionMode = true;
          selectedIds
            ..clear()
            ..add(entry.id);
          return;
        case PlaylistEntryGestureIntent.toggleSelection:
          if (!selectedIds.remove(entry.id)) selectedIds.add(entry.id);
          if (selectedIds.isEmpty) selectionMode = false;
          return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Selected ${selectedIds.length}'),
          if (selectionMode && widget.canDeleteMedia && !widget.readOnlyScope)
            const Icon(Icons.delete_outline, key: Key('delete-selection')),
          if (widget.canClearMedia)
            const Icon(Icons.delete_sweep_outlined, key: Key('clear-playlist')),
          for (final entry in entries) _buildEntry(entry),
        ],
      ),
    );
  }

  Widget _buildEntry(RoomMediaEntry entry) {
    final tapIntent = PlaylistSelectionPolicy.tapIntent(
      entry: entry,
      selectionMode: selectionMode,
      canActivate: true,
    );
    final longPressIntent = PlaylistSelectionPolicy.longPressIntent(
      entry: entry,
      selectionMode: selectionMode,
      canSelectEntries: true,
    );
    return GestureDetector(
      key: Key('entry-${entry.id}'),
      behavior: HitTestBehavior.opaque,
      onTap: tapIntent == null ? null : () => _apply(entry, tapIntent),
      onLongPress: longPressIntent == null
          ? null
          : () => _apply(entry, longPressIntent),
      child: SizedBox(width: 240, height: 48, child: Text(entry.name)),
    );
  }
}
