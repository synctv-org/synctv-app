import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class BilibiliPlaylistPreview extends StatefulWidget {
  const BilibiliPlaylistPreview({
    super.key,
    required this.items,
    required this.loading,
    required this.hasMore,
    required this.onAddSelected,
    required this.onCreatePlaylist,
    this.onLoadMore,
  });

  final List<RoomDynamicMediaEntry> items;
  final bool loading;
  final bool hasMore;
  final ValueChanged<List<RoomDynamicMediaEntry>> onAddSelected;
  final VoidCallback onCreatePlaylist;
  final VoidCallback? onLoadMore;

  @override
  State<BilibiliPlaylistPreview> createState() =>
      _BilibiliPlaylistPreviewState();
}

class _BilibiliPlaylistPreviewState extends State<BilibiliPlaylistPreview> {
  final Set<String> _selectedKeys = {};

  @override
  void initState() {
    super.initState();
    _selectNewItems(const []);
  }

  @override
  void didUpdateWidget(covariant BilibiliPlaylistPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectNewItems(oldWidget.items);
  }

  void _selectNewItems(List<RoomDynamicMediaEntry> oldItems) {
    final currentKeys = _selectableEntries(widget.items).keys.toSet();
    final oldKeys = _selectableEntries(oldItems).keys.toSet();
    _selectedKeys
      ..retainAll(currentKeys)
      ..addAll(currentKeys.difference(oldKeys));
  }

  Map<String, RoomDynamicMediaEntry> _selectableEntries(
    List<RoomDynamicMediaEntry> items,
  ) {
    return {
      for (final (index, item) in items.indexed)
        if (item.mediaSourceConfig != null) _itemKey(item, index): item,
    };
  }

  String _itemKey(RoomDynamicMediaEntry item, int index) {
    return item.id.isEmpty ? '$index:${item.name}' : item.id;
  }

  void _selectAll() {
    setState(() {
      _selectedKeys
        ..clear()
        ..addAll(_selectableEntries(widget.items).keys);
    });
  }

  void _clearSelection() => setState(_selectedKeys.clear);

  void _addSelected() {
    final entries = _selectableEntries(widget.items);
    widget.onAddSelected(
      entries.entries
          .where((entry) => _selectedKeys.contains(entry.key))
          .map((entry) => entry.value)
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectableCount = _selectableEntries(widget.items).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${_selectedKeys.length} / $selectableCount selected',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            TextButton.icon(
              key: const Key('bilibili-preview-select-all'),
              onPressed: widget.loading || selectableCount == 0
                  ? null
                  : _selectAll,
              icon: const Icon(Icons.select_all),
              label: const Text('Select all'),
            ),
            TextButton.icon(
              key: const Key('bilibili-preview-clear'),
              onPressed: widget.loading || _selectedKeys.isEmpty
                  ? null
                  : _clearSelection,
              icon: const Icon(Icons.deselect),
              label: const Text('Clear'),
            ),
          ],
        ),
        ...widget.items.indexed.map((entry) {
          final (index, item) = entry;
          final key = _itemKey(item, index);
          final selectable = item.mediaSourceConfig != null;
          return CheckboxListTile(
            key: Key('bilibili-preview-item-$key'),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.trailing,
            value: selectable && _selectedKeys.contains(key),
            onChanged: widget.loading || !selectable
                ? null
                : (selected) {
                    setState(() {
                      if (selected == true) {
                        _selectedKeys.add(key);
                      } else {
                        _selectedKeys.remove(key);
                      }
                    });
                  },
            secondary: item.coverUrl.isEmpty
                ? Icon(
                    item.isPlaylist
                        ? Icons.video_library_outlined
                        : Icons.play_circle_outline,
                  )
                : AppImageThumbnail(
                    url: item.coverUrl,
                    width: 72,
                    height: 44,
                    borderRadius: BorderRadius.circular(4),
                  ),
            title: Text(
              item.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }),
        if (widget.hasMore)
          Align(
            alignment: Alignment.center,
            child: TextButton.icon(
              key: const Key('bilibili-preview-load-more'),
              onPressed: widget.loading ? null : widget.onLoadMore,
              icon: const Icon(Icons.expand_more),
              label: const Text('Load more'),
            ),
          ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.end,
          spacing: 10,
          runSpacing: 10,
          children: [
            OutlinedButton.icon(
              key: const Key('bilibili-preview-add-selected'),
              onPressed: widget.loading || _selectedKeys.isEmpty
                  ? null
                  : _addSelected,
              icon: const Icon(Icons.playlist_add_check),
              label: Text('Add selected (${_selectedKeys.length})'),
            ),
            FilledButton.icon(
              key: const Key('bilibili-preview-create-playlist'),
              onPressed: widget.loading ? null : widget.onCreatePlaylist,
              icon: const Icon(Icons.playlist_add),
              label: const Text('Create dynamic playlist'),
            ),
          ],
        ),
      ],
    );
  }
}
