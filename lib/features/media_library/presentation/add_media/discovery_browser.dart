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
  bool _loadingMore = false;
  bool _submitting = false;

  bool get _busy => widget.loading || _submitting;

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
          child: !isPageMode && widget.items.isEmpty
              ? _emptyContent(context)
              : isPageMode
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    final origin = widget;
                    final pagination = AppPaginationBar.page(
                      context: context,
                      page: widget.page,
                      pageSize: widget.pageSize,
                      total: widget.total,
                      onPrevious:
                          _busy ||
                              widget.page <= 1 ||
                              widget.onPreviousPage == null
                          ? null
                          : () => _changePage(origin, next: false),
                      onNext:
                          _busy || !widget.hasMore || widget.onNextPage == null
                          ? null
                          : () => _changePage(origin, next: true),
                    );
                    if (constraints.hasBoundedHeight &&
                        constraints.maxHeight < 300) {
                      return AppSingleChildScrollView(
                        child: Column(
                          children: [
                            if (widget.items.isEmpty) _emptyContent(context),
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
                          child: widget.items.isEmpty
                              ? _emptyContent(context)
                              : AppListView.separated(
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
                    if (notification.depth == 0 &&
                        notification.metrics.pixels >=
                            notification.metrics.maxScrollExtent - 200) {
                      _loadMore();
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
                          loading: widget.loading || _loadingMore,
                          onPressed: widget.onLoadMore == null
                              ? null
                              : _loadMore,
                        );
                      }
                      return _item(widget.items[index]);
                    },
                  ),
                ),
        ),
        if ((_selectionEnabled && widget.items.isNotEmpty) ||
            _showsTargetSelector ||
            (target != ProviderAddTarget.media &&
                widget.onAddCurrentList != null)) ...[
          const AppDivider(height: 1),
          _selectionBar(context, target),
        ],
      ],
    );
  }

  Widget _emptyContent(BuildContext context) {
    if (widget.loading) {
      return const Center(child: AppLoadingIndicator(size: AppLoadingSize.md));
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final emptyState = AppEmptyState(
          icon: widget.emptyIcon,
          title: widget.emptyTitle ?? context.l10n.noItems,
          iconSize: 32,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        );
        // Compact provider dialogs can leave only a sliver for the empty state.
        if (constraints.maxHeight < 96) {
          return AppSingleChildScrollView(child: emptyState);
        }
        return Center(child: emptyState);
      },
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

  bool get _selectionEnabled =>
      _effectiveTarget == ProviderAddTarget.media &&
      widget.onAddSelected != null;

  bool get _canInteract =>
      mounted && !_busy && (ModalRoute.of(context)?.isCurrent ?? true);

  void _selectAll() {
    if (!_canInteract || !_selectionEnabled) return;
    setState(() => _selection.selectAll(widget.items));
    widget.onSelectionChanged?.call();
  }

  void _clearSelection() {
    if (!_canInteract || !_selectionEnabled || _selection.isEmpty) return;
    setState(_selection.clear);
    widget.onSelectionChanged?.call();
  }

  void _changeTarget(ProviderAddTarget target) {
    if (!_canInteract || !_showsTargetSelector) return;
    setState(() => _target = target);
  }

  Future<void> _addSelected() async {
    final add = widget.onAddSelected;
    if (!_canInteract ||
        !_selectionEnabled ||
        _selection.isEmpty ||
        add == null) {
      return;
    }
    final entries = _selection.entries;
    await _submit(() => add(entries));
  }

  Future<void> _addCurrentList() async {
    final add = widget.onAddCurrentList;
    if (!_canInteract ||
        _effectiveTarget == ProviderAddTarget.media ||
        add == null) {
      return;
    }
    await _submit(add);
  }

  Future<void> _submit(Future<void> Function() action) async {
    setState(() => _submitting = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  bool _canUseItem(DiscoveryBrowserEntry item) =>
      _canInteract && widget.items.contains(item);

  void _changePage(DiscoveryBrowser origin, {required bool next}) {
    if (!_canInteract ||
        widget.paginationMode != DiscoveryPaginationMode.page ||
        origin.page != widget.page ||
        origin.selectionScope != widget.selectionScope ||
        (next ? !widget.hasMore : widget.page <= 1)) {
      return;
    }
    final change = next ? widget.onNextPage : widget.onPreviousPage;
    change?.call();
  }

  Future<void> _loadMore() async {
    final load = widget.onLoadMore;
    if (!_canInteract ||
        _loadingMore ||
        !widget.hasMore ||
        widget.paginationMode != DiscoveryPaginationMode.cursor ||
        load == null) {
      return;
    }
    setState(() => _loadingMore = true);
    try {
      await load();
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

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
              enabled: !_busy,
              onChanged: _changeTarget,
            ),
            const SizedBox(height: 8),
          ],
          if (_selectionEnabled)
            LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 480;
                if (compact) {
                  return _compactSelectionActions(context);
                }
                return _expandedSelectionActions(context);
              },
            )
          else if (target != ProviderAddTarget.media &&
              widget.onAddCurrentList != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.playlistActionLeading case final leading?) ...[
                  leading,
                  const SizedBox(height: 8),
                ],
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FilledButton.tonalIcon(
                    key: const Key('discovery-add-current-list'),
                    onPressed: _busy ? null : _addCurrentList,
                    icon: _submitting
                        ? const AppLoadingIndicator(
                            size: AppLoadingSize.sm,
                            centered: false,
                          )
                        : const Icon(Icons.playlist_add_rounded),
                    label: Text(
                      widget.currentListLabel ?? context.l10n.addCurrentList,
                    ),
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
          onPressed: _busy ? null : _selectAll,
          icon: const Icon(Icons.select_all_rounded),
          label: Text(context.l10n.selectAll),
        ),
        TextButton.icon(
          key: const Key('discovery-clear-selection'),
          onPressed: _busy || _selection.isEmpty ? null : _clearSelection,
          icon: const Icon(Icons.deselect_rounded),
          label: Text(context.l10n.clear),
        ),
        FilledButton.tonalIcon(
          key: const Key('discovery-add-selected'),
          onPressed: _busy || _selection.isEmpty || widget.onAddSelected == null
              ? null
              : _addSelected,
          icon: _submitting
              ? const AppLoadingIndicator(
                  size: AppLoadingSize.sm,
                  centered: false,
                )
              : const Icon(Icons.playlist_add_check_rounded),
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
          onPressed: _busy ? null : _selectAll,
        ),
        AppIconButton(
          key: const Key('discovery-clear-selection'),
          tooltip: context.l10n.clear,
          icon: Icons.deselect_rounded,
          onPressed: _busy || _selection.isEmpty ? null : _clearSelection,
        ),
        AppIconButton(
          key: const Key('discovery-add-selected'),
          tooltip: context.l10n.addSelectedCount(_selection.length),
          icon: Icons.playlist_add_check_rounded,
          loading: _submitting,
          onPressed: _busy || _selection.isEmpty || widget.onAddSelected == null
              ? null
              : _addSelected,
          style: AppIconButtonStyle.filled,
        ),
      ],
    );
  }

  Widget _item(DiscoveryBrowserEntry item) {
    final selectionEnabled = _selectionEnabled;
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
              enabled: !_busy && item.selectable,
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
      onTap: !selectionEnabled || _busy || !item.selectable
          ? null
          : () => _toggle(item),
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
                    onPressed: _busy || widget.onOpen == null
                        ? null
                        : () => _open(item),
                    icon: item.openIcon,
                  ),
              ],
            ),
    );
  }

  void _toggle(DiscoveryBrowserEntry item) {
    if (!_canUseItem(item) || !_selectionEnabled || !item.selectable) return;
    setState(() {
      _selection.toggle(item);
      widget.onSelectionChanged?.call();
    });
  }

  void _open(DiscoveryBrowserEntry item) {
    if (!_canUseItem(item) || !item.isContainer) return;
    widget.onOpen?.call(item);
  }
}
