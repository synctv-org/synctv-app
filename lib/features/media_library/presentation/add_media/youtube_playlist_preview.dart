import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class YoutubePlaylistPreview extends StatefulWidget {
  const YoutubePlaylistPreview({
    super.key,
    required this.items,
    required this.loading,
    required this.hasMore,
    required this.onAddSelected,
    this.onLoadMore,
  });

  final List<RoomDynamicMediaEntry> items;
  final bool loading;
  final bool hasMore;
  final ValueChanged<List<RoomDynamicMediaEntry>> onAddSelected;
  final VoidCallback? onLoadMore;

  @override
  State<YoutubePlaylistPreview> createState() => _YoutubePlaylistPreviewState();
}

class _YoutubePlaylistPreviewState extends State<YoutubePlaylistPreview> {
  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    _selectNew(const []);
  }

  @override
  void didUpdateWidget(covariant YoutubePlaylistPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selectNew(oldWidget.items);
  }

  Map<String, RoomDynamicMediaEntry> _media(
    List<RoomDynamicMediaEntry> items,
  ) => {
    for (final (index, item) in items.indexed)
      if (item.mediaSourceConfig?.hasYoutube() == true)
        item.id.isEmpty ? '$index:${item.name}' : item.id: item,
  };

  void _selectNew(List<RoomDynamicMediaEntry> oldItems) {
    final current = _media(widget.items).keys.toSet();
    final old = _media(oldItems).keys.toSet();
    _selected
      ..retainAll(current)
      ..addAll(current.difference(old));
  }

  @override
  Widget build(BuildContext context) {
    final media = _media(widget.items);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '${_selected.length} / ${media.length} selected',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            TextButton.icon(
              key: const Key('youtube-preview-select-all'),
              onPressed: widget.loading || media.isEmpty
                  ? null
                  : () => setState(() {
                      _selected
                        ..clear()
                        ..addAll(media.keys);
                    }),
              icon: const Icon(Icons.select_all),
              label: const Text('Select all'),
            ),
            TextButton.icon(
              key: const Key('youtube-preview-clear'),
              onPressed: widget.loading || _selected.isEmpty
                  ? null
                  : () => setState(_selected.clear),
              icon: const Icon(Icons.deselect),
              label: const Text('Clear'),
            ),
          ],
        ),
        ...media.entries.map(
          (entry) => CheckboxListTile(
            key: Key('youtube-preview-item-${entry.key}'),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.trailing,
            value: _selected.contains(entry.key),
            onChanged: widget.loading
                ? null
                : (selected) => setState(() {
                    if (selected == true) {
                      _selected.add(entry.key);
                    } else {
                      _selected.remove(entry.key);
                    }
                  }),
            secondary: entry.value.coverUrl.isEmpty
                ? const Icon(Icons.play_circle_outline)
                : AppImageThumbnail(
                    url: entry.value.coverUrl,
                    width: 72,
                    height: 44,
                    borderRadius: BorderRadius.circular(4),
                  ),
            title: Text(
              entry.value.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (widget.hasMore)
          Align(
            child: TextButton.icon(
              key: const Key('youtube-preview-load-more'),
              onPressed: widget.loading ? null : widget.onLoadMore,
              icon: const Icon(Icons.expand_more),
              label: const Text('Load more'),
            ),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton.icon(
            key: const Key('youtube-preview-add-selected'),
            onPressed: widget.loading || _selected.isEmpty
                ? null
                : () => widget.onAddSelected([
                    for (final entry in media.entries)
                      if (_selected.contains(entry.key)) entry.value,
                  ]),
            icon: const Icon(Icons.playlist_add_check),
            label: Text('Add selected (${_selected.length})'),
          ),
        ),
      ],
    );
  }
}
