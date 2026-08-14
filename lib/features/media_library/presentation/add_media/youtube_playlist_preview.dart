import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/src/generated/proto/providers/youtube.pb.dart'
    as youtube;
import 'package:synctv_app/l10n/l10n.dart';

class YoutubePlaylistPreview extends StatefulWidget {
  const YoutubePlaylistPreview({
    super.key,
    required this.items,
    required this.loading,
    required this.hasMore,
    this.onAddSelected,
    this.onLoadMore,
    this.selectionEnabled = true,
  });

  final List<youtube.ListItem> items;
  final bool loading;
  final bool hasMore;
  final ValueChanged<List<youtube.ListItem>>? onAddSelected;
  final VoidCallback? onLoadMore;
  final bool selectionEnabled;

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

  Map<String, youtube.ListItem> _media(List<youtube.ListItem> items) => {
    for (final (index, item) in items.indexed)
      if (item.hasSource())
        item.videoId.isEmpty ? '$index:${item.title}' : item.videoId: item,
  };

  void _selectNew(List<youtube.ListItem> oldItems) {
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
        if (widget.selectionEnabled)
          Row(
            children: [
              Expanded(
                child: Text(
                  context.l10n.selectionCount(_selected.length, media.length),
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
                label: Text(context.l10n.selectAll),
              ),
              TextButton.icon(
                key: const Key('youtube-preview-clear'),
                onPressed: widget.loading || _selected.isEmpty
                    ? null
                    : () => setState(_selected.clear),
                icon: const Icon(Icons.deselect),
                label: Text(context.l10n.clear),
              ),
            ],
          ),
        Expanded(
          child: AppListView.separated(
            itemCount: media.length + (widget.hasMore ? 1 : 0),
            separatorBuilder: (_, _) => const AppDivider(height: 1),
            itemBuilder: (context, index) {
              if (index == media.length) {
                return Align(
                  child: TextButton.icon(
                    key: const Key('youtube-preview-load-more'),
                    onPressed: widget.loading ? null : widget.onLoadMore,
                    icon: const Icon(Icons.expand_more),
                    label: Text(context.l10n.loadMore),
                  ),
                );
              }
              final entry = media.entries.elementAt(index);
              return ListTile(
                key: Key('youtube-preview-item-${entry.key}'),
                contentPadding: EdgeInsets.zero,
                onTap: !widget.selectionEnabled || widget.loading
                    ? null
                    : () => setState(() {
                        if (_selected.contains(entry.key)) {
                          _selected.remove(entry.key);
                        } else {
                          _selected.add(entry.key);
                        }
                      }),
                leading: !entry.value.hasThumbnailUrl()
                    ? const Icon(Icons.play_circle_outline)
                    : AppImageThumbnail(
                        url: entry.value.thumbnailUrl,
                        width: 72,
                        height: 44,
                        borderRadius: BorderRadius.circular(4),
                      ),
                title: Text(
                  entry.value.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: widget.selectionEnabled
                    ? AppCheckbox(
                        value: _selected.contains(entry.key),
                        enabled: !widget.loading,
                        semanticsLabel: context.l10n.selectItem(
                          entry.value.title,
                        ),
                        onChanged: (_) => setState(() {
                          if (_selected.contains(entry.key)) {
                            _selected.remove(entry.key);
                          } else {
                            _selected.add(entry.key);
                          }
                        }),
                      )
                    : null,
              );
            },
          ),
        ),
        if (widget.selectionEnabled)
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton.icon(
              key: const Key('youtube-preview-add-selected'),
              onPressed:
                  widget.loading ||
                      _selected.isEmpty ||
                      widget.onAddSelected == null
                  ? null
                  : () => widget.onAddSelected!([
                      for (final entry in media.entries)
                        if (_selected.contains(entry.key)) entry.value,
                    ]),
              icon: const Icon(Icons.playlist_add_check),
              label: Text(context.l10n.addSelectedCount(_selected.length)),
            ),
          ),
      ],
    );
  }
}
