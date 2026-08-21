import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_add_target.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;

class DiscoveryBrowserEntry {
  const DiscoveryBrowserEntry({
    required this.key,
    required this.title,
    required this.source,
    required this.isContainer,
    this.subtitle = '',
    this.leading,
    this.selectable = true,
    this.openIcon = Icons.chevron_right_rounded,
    this.openTooltip = 'Open folder',
    this.actions = const [],
  });

  final String key;
  final String title;
  final String subtitle;
  final provider_common.DiscoveredSource source;
  final bool isContainer;
  final Widget? leading;
  final bool selectable;
  final IconData openIcon;
  final String openTooltip;
  final List<Widget> actions;
}

class DiscoverySelectionController {
  static final Object _unsetScope = Object();

  final Map<String, DiscoveryBrowserEntry> _selected = {};
  Object? _scope = _unsetScope;

  int get length => _selected.length;
  bool get isEmpty => _selected.isEmpty;
  List<DiscoveryBrowserEntry> get entries => _selected.values.toList();

  bool contains(String key) => _selected.containsKey(key);

  void useScope(Object? scope) {
    if (_scope != _unsetScope && _scope != scope) _selected.clear();
    _scope = scope;
  }

  void refresh(
    Iterable<DiscoveryBrowserEntry> items, {
    bool selectAll = false,
    Set<String> previousKeys = const {},
  }) {
    for (final item in items) {
      if (!item.selectable) {
        _selected.remove(item.key);
      } else if (_selected.containsKey(item.key) ||
          (selectAll && !previousKeys.contains(item.key))) {
        _selected[item.key] = item;
      }
    }
  }

  void selectAll(Iterable<DiscoveryBrowserEntry> items) {
    for (final item in items.where((item) => item.selectable)) {
      _selected[item.key] = item;
    }
  }

  void toggle(DiscoveryBrowserEntry item) {
    if (_selected.remove(item.key) == null) _selected[item.key] = item;
  }

  void clear() => _selected.clear();
}

enum DiscoveryPaginationMode { cursor, page }

class DiscoveryBrowser extends StatefulWidget {
  const DiscoveryBrowser({
    super.key,
    required this.items,
    required this.loading,
    this.onAddSelected,
    this.onOpen,
    this.onAddCurrentList,
    this.onLoadMore,
    this.hasMore = false,
    this.paginationMode = DiscoveryPaginationMode.cursor,
    this.page = 1,
    this.pageSize,
    this.total,
    this.onPreviousPage,
    this.onNextPage,
    this.initiallySelectAll = false,
    this.currentListLabel,
    this.emptyIcon = Icons.video_library_outlined,
    this.emptyTitle,
    this.target,
    this.selectionController,
    this.selectionScope,
    this.onSelectionChanged,
    this.playlistActionLeading,
  });

  final List<DiscoveryBrowserEntry> items;
  final bool loading;
  final Future<void> Function(List<DiscoveryBrowserEntry> items)? onAddSelected;
  final ValueChanged<DiscoveryBrowserEntry>? onOpen;
  final Future<void> Function()? onAddCurrentList;
  final Future<void> Function()? onLoadMore;
  final bool hasMore;
  final DiscoveryPaginationMode paginationMode;
  final int page;
  final int? pageSize;
  final int? total;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final bool initiallySelectAll;
  final String? currentListLabel;
  final IconData emptyIcon;
  final String? emptyTitle;
  final ProviderAddTarget? target;
  final DiscoverySelectionController? selectionController;
  final Object? selectionScope;
  final VoidCallback? onSelectionChanged;
  final Widget? playlistActionLeading;

  @override
  State<DiscoveryBrowser> createState() => _DiscoveryBrowserState();
}

class _DiscoveryBrowserState extends State<DiscoveryBrowser> {
  late DiscoverySelectionController _selection;
  ProviderAddTarget _target = ProviderAddTarget.media;

  @override
  void initState() {
    super.initState();
    _selection = widget.selectionController ?? DiscoverySelectionController();
    _selection.useScope(widget.selectionScope);
    _selection.refresh(widget.items, selectAll: widget.initiallySelectAll);
  }

  @override
  void didUpdateWidget(covariant DiscoveryBrowser oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectionController != widget.selectionController) {
      _selection = widget.selectionController ?? DiscoverySelectionController();
    }
    _selection.useScope(widget.selectionScope);
    _selection.refresh(
      widget.items,
      selectAll: widget.initiallySelectAll,
      previousKeys: oldWidget.items.map((item) => item.key).toSet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final target = _effectiveTarget;
    final isPageMode = widget.paginationMode == DiscoveryPaginationMode.page;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: widget.items.isEmpty
              ? widget.loading
                    ? const Center(
                        child: AppLoadingIndicator(size: AppLoadingSize.md),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final emptyState = AppEmptyState(
                            icon: widget.emptyIcon,
                            title: widget.emptyTitle ?? context.l10n.noItems,
                            iconSize: 32,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          );
                          // A compact dialog can leave only a sliver of the
                          // preview viewport after its controls and warning banner.
                          // Let the empty state scroll in that case instead of
                          // forcing its intrinsic column into a tight height.
                          if (constraints.maxHeight < 96) {
                            return AppSingleChildScrollView(child: emptyState);
                          }
                          return Center(child: emptyState);
                        },
                      )
              : isPageMode
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    final pagination = AppPaginationBar.page(
                      context: context,
                      page: widget.page,
                      pageSize: widget.pageSize,
                      total: widget.total,
                      onPrevious: widget.onPreviousPage,
                      onNext: widget.onNextPage,
                    );
                    if (constraints.hasBoundedHeight &&
                        constraints.maxHeight < 300) {
                      return AppSingleChildScrollView(
                        child: Column(
                          children: [
                            for (
                              var index = 0;
                              index < widget.items.length;
                              index++
                            ) ...[
                              if (index > 0) const AppDivider(height: 1),
                              _item(widget.items[index]),
                            ],
                            pagination,
                          ],
                        ),
                      );
                    }
                    return Column(
                      children: [
                        Flexible(
                          child: AppListView.separated(
                            primary: true,
                            itemCount: widget.items.length,
                            separatorBuilder: (_, _) =>
                                const AppDivider(height: 1),
                            itemBuilder: (context, index) =>
                                _item(widget.items[index]),
                          ),
                        ),
                        pagination,
                      ],
                    );
                  },
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (!widget.loading &&
                        widget.hasMore &&
                        widget.onLoadMore != null &&
                        notification.metrics.pixels >=
                            notification.metrics.maxScrollExtent - 200) {
                      widget.onLoadMore!();
                    }
                    return false;
                  },
                  child: AppListView.separated(
                    primary: true,
                    itemCount: widget.items.length + (widget.hasMore ? 1 : 0),
                    separatorBuilder: (_, _) => const AppDivider(height: 1),
                    itemBuilder: (context, index) {
                      if (index == widget.items.length) {
                        return AppLoadMoreFooter(
                          loading: widget.loading,
                          onPressed: widget.onLoadMore,
                        );
                      }
                      return _item(widget.items[index]);
                    },
                  ),
                ),
        ),
        if (widget.items.isNotEmpty || widget.onAddCurrentList != null) ...[
          const AppDivider(height: 1),
          _selectionBar(context, target),
        ],
      ],
    );
  }

  ProviderAddTarget get _effectiveTarget {
    if (widget.target case final target?) return target;
    if (widget.onAddSelected == null && widget.onAddCurrentList != null) {
      return ProviderAddTarget.playlist;
    }
    return _target;
  }

  bool get _showsTargetSelector =>
      widget.target == null &&
      widget.onAddSelected != null &&
      widget.onAddCurrentList != null;

  Widget _selectionBar(BuildContext context, ProviderAddTarget target) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_showsTargetSelector) ...[
            ProviderAddTargetSelector(
              value: target,
              targets: const [
                ProviderAddTarget.media,
                ProviderAddTarget.playlist,
              ],
              enabled: !widget.loading,
              onChanged: (value) => setState(() => _target = value),
            ),
            const SizedBox(height: 8),
          ],
          if (target == ProviderAddTarget.media)
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 480;
                if (compact) {
                  return _compactSelectionActions(context);
                }
                return _expandedSelectionActions(context);
              },
            )
          else if (widget.onAddCurrentList != null)
            Row(
              children: [
                if (widget.playlistActionLeading case final leading?) ...[
                  Expanded(child: leading),
                  const SizedBox(width: 8),
                ],
                FilledButton.tonalIcon(
                  key: const Key('discovery-add-current-list'),
                  onPressed: widget.loading ? null : widget.onAddCurrentList,
                  icon: const Icon(Icons.playlist_add_rounded),
                  label: Text(
                    widget.currentListLabel ?? context.l10n.addCurrentList,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _expandedSelectionActions(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          context.l10n.selectedCount(_selection.length),
          style: Theme.of(context).textTheme.labelLarge,
        ),
        TextButton.icon(
          key: const Key('discovery-select-all'),
          onPressed: widget.loading
              ? null
              : () => setState(() {
                  _selection.selectAll(widget.items);
                  widget.onSelectionChanged?.call();
                }),
          icon: const Icon(Icons.select_all_rounded),
          label: Text(context.l10n.selectAll),
        ),
        TextButton.icon(
          key: const Key('discovery-clear-selection'),
          onPressed: widget.loading || _selection.isEmpty
              ? null
              : () => setState(() {
                  _selection.clear();
                  widget.onSelectionChanged?.call();
                }),
          icon: const Icon(Icons.deselect_rounded),
          label: Text(context.l10n.clear),
        ),
        FilledButton.tonalIcon(
          key: const Key('discovery-add-selected'),
          onPressed:
              widget.loading ||
                  _selection.isEmpty ||
                  widget.onAddSelected == null
              ? null
              : () => widget.onAddSelected!(_selection.entries),
          icon: const Icon(Icons.playlist_add_check_rounded),
          label: Text(context.l10n.addSelectedCount(_selection.length)),
        ),
      ],
    );
  }

  Widget _compactSelectionActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            context.l10n.selectedCount(_selection.length),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        AppIconButton(
          key: const Key('discovery-select-all'),
          tooltip: context.l10n.selectAll,
          icon: Icons.select_all_rounded,
          onPressed: widget.loading
              ? null
              : () => setState(() {
                  _selection.selectAll(widget.items);
                  widget.onSelectionChanged?.call();
                }),
        ),
        AppIconButton(
          key: const Key('discovery-clear-selection'),
          tooltip: context.l10n.clear,
          icon: Icons.deselect_rounded,
          onPressed: widget.loading || _selection.isEmpty
              ? null
              : () => setState(() {
                  _selection.clear();
                  widget.onSelectionChanged?.call();
                }),
        ),
        AppIconButton(
          key: const Key('discovery-add-selected'),
          tooltip: context.l10n.addSelectedCount(_selection.length),
          icon: Icons.playlist_add_check_rounded,
          onPressed:
              widget.loading ||
                  _selection.isEmpty ||
                  widget.onAddSelected == null
              ? null
              : () => widget.onAddSelected!(_selection.entries),
          style: AppIconButtonStyle.filled,
        ),
      ],
    );
  }

  Widget _item(DiscoveryBrowserEntry item) {
    final selectionEnabled =
        _effectiveTarget == ProviderAddTarget.media &&
        widget.onAddSelected != null;
    final selected = _selection.contains(item.key);
    return ListTile(
      key: ValueKey('discovery-item-${item.key}'),
      contentPadding: EdgeInsets.zero,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectionEnabled)
            AppCheckbox(
              value: selected,
              enabled: !widget.loading && item.selectable,
              semanticsLabel: context.l10n.selectItem(item.title),
              onChanged: (_) => _toggle(item),
            ),
          SizedBox.square(
            dimension: 48,
            child:
                item.leading ??
                Icon(
                  item.isContainer
                      ? Icons.folder_rounded
                      : Icons.movie_outlined,
                ),
          ),
        ],
      ),
      title: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: item.subtitle.isEmpty
          ? null
          : Text(item.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
      onTap: widget.loading || !item.selectable ? null : () => _toggle(item),
      trailing: item.actions.isEmpty && !item.isContainer
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...item.actions,
                if (item.isContainer)
                  AppIconButton(
                    key: ValueKey('discovery-open-${item.key}'),
                    tooltip: item.openTooltip,
                    onPressed: widget.loading || widget.onOpen == null
                        ? null
                        : () => widget.onOpen!(item),
                    icon: item.openIcon,
                  ),
              ],
            ),
    );
  }

  void _toggle(DiscoveryBrowserEntry item) {
    setState(() {
      _selection.toggle(item);
      widget.onSelectionChanged?.call();
    });
  }
}
