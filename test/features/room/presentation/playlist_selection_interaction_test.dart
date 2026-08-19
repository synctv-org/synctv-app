import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room/presentation/models/playlist_selection_policy.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

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

  testWidgets('activation respects lifecycle and playlist browse access', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: _SelectionHarness(canDeleteMedia: false, canClearMedia: false),
      ),
    );

    await tester.tap(find.byKey(const Key('entry-shared-dynamic-playlist')));
    await tester.pump();
    expect(find.text('Activated shared-dynamic-playlist'), findsOneWidget);

    await tester.tap(find.byKey(const Key('entry-unavailable-media')));
    await tester.pump();
    expect(find.text('Activated shared-dynamic-playlist'), findsOneWidget);

    await tester.tap(find.byKey(const Key('entry-creator-only-playlist')));
    await tester.pump();
    expect(find.text('Activated shared-dynamic-playlist'), findsOneWidget);

    await tester.tap(find.byKey(const Key('entry-opaque-media-a')));
    await tester.pump();
    expect(find.text('Activated opaque-media-a'), findsOneWidget);
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
      creator: 'usr_viewer',
      metadata: const {'isDynamic': true},
    ),
    RoomDynamicMediaEntry(
      id: 'dynamic-child',
      name: 'Dynamic child',
      parentId: 'provider-playlist',
      subPath: '/child',
      isPlaylist: false,
    ),
    RoomPlaylistItem(
      id: 'shared-dynamic-playlist',
      name: 'Shared dynamic playlist',
      creator: 'usr_creator',
      browseAccessMode: client_enum
          .PlaylistBrowseAccessMode
          .PLAYLIST_BROWSE_ACCESS_MODE_ROOM_MEMBERS,
      metadata: const {'isDynamic': true},
    ),
    RoomPlaylistItem(
      id: 'creator-only-playlist',
      name: 'Creator-only playlist',
      creator: 'usr_creator',
      metadata: const {'isDynamic': true},
    ),
    RoomMediaItem(
      id: 'unavailable-media',
      name: 'Unavailable media',
      url: 'https://example.test/unavailable.mp4',
      availability: client_enum
          .ResourceAvailability
          .RESOURCE_AVAILABILITY_CREATOR_INACTIVE,
    ),
  ];

  final selectedIds = <String>{};
  bool selectionMode = false;
  String activatedId = '';

  void _apply(RoomMediaEntry entry, PlaylistEntryGestureIntent intent) {
    setState(() {
      switch (intent) {
        case PlaylistEntryGestureIntent.activate:
          activatedId = entry.id;
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
          Text('Activated $activatedId'),
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
    final canActivate = PlaylistSelectionPolicy.canActivate(
      entry: entry,
      viewerId: 'usr_viewer',
      canControlPlayback: true,
    );
    final tapIntent = PlaylistSelectionPolicy.tapIntent(
      entry: entry,
      selectionMode: selectionMode,
      canActivate: canActivate,
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
