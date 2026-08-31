import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/discovered_source.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/media_variant_label.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/discovery_browser.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/playback_proxy_mode_control.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_account_action.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_workspace.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

enum EmbyCollectionMode {
  continueWatching,
  nextUp,
  recentlyAdded,
  favoriteItems,
  favoritePeople,
  playlists,
  collections,
  genres,
}

typedef EmbyDiscoveryLoader = Future<EmbyListPage> Function(
  EmbyBindInfo bind,
  EmbyListMode mode,
  String targetId,
  List<String> itemTypes,
  String search,
  int page,
  int pageSize,
);

class EmbyPlaylistForm extends StatefulWidget {
  const EmbyPlaylistForm({
    super.key,
    required this.roomId,
    required this.parentId,
    required this.binds,
    required this.onDraftChanged,
    this.leadingControls,
    this.proxyMode = source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
    this.onProxyModeChanged,
    this.onOpenBinding,
    this.loader,
  });

  final String roomId;
  final String parentId;
  final List<EmbyBindInfo> binds;
  final ValueChanged<bool> onDraftChanged;
  final Widget? leadingControls;
  final source_enum.PlaybackProxyMode proxyMode;
  final ValueChanged<source_enum.PlaybackProxyMode>? onProxyModeChanged;
  final Future<void> Function()? onOpenBinding;
  final EmbyDiscoveryLoader? loader;

  @override
  State<EmbyPlaylistForm> createState() => _EmbyPlaylistFormState();
}

class _EmbyBrowseLocation {
  const _EmbyBrowseLocation({
    required this.mode,
    required this.targetId,
    required this.title,
  });

  final EmbyListMode mode;
  final String targetId;
  final String title;
}

class _EmbyPlaylistFormState extends State<EmbyPlaylistForm> {
  static const _pageSize = 30;
  static const _twoColumnMinWidth = 400.0;

  final _selection = DiscoverySelectionController();
  final _nameController = TextEditingController();
  final _searchController = TextEditingController();
  final _itemTypes = <String>{'Movie', 'Episode', 'Video'};
  final _locations = <_EmbyBrowseLocation>[];
  EmbyCollectionMode _mode = EmbyCollectionMode.continueWatching;
  EmbyBindInfo? _bind;
  List<EmbyItemInfo> _items = const [];
  provider_common.DiscoveredSource? _listSource;
  String _activeSearch = '';
  int _page = 1;
  int _total = 0;
  bool _hasMore = false;
  bool _loading = false;

  provider_common.DiscoveredSource? get _playbackPolicySource =>
      _selection.entries.firstOrNull?.source ?? _listSource;

  @override
  void initState() {
    super.initState();
    _bind = widget.binds.firstOrNull;
    _nameController.addListener(_notifyDraftChanged);
    _searchController.addListener(_notifyDraftChanged);
  }

  @override
  void didUpdateWidget(covariant EmbyPlaylistForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    final current = _bind;
    if (current == null || !widget.binds.any((bind) => bind.id == current.id)) {
      _bind = widget.binds.firstOrNull;
      _resetDiscovery();
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_notifyDraftChanged);
    _searchController.removeListener(_notifyDraftChanged);
    _nameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _notifyDraftChanged() {
    widget.onDraftChanged(
      _nameController.text.trim().isNotEmpty ||
          _searchController.text.trim().isNotEmpty,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.binds.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppEmptyState(
              icon: Icons.video_library_outlined,
              title: 'Emby',
              subtitle: context.l10n.bindAccountToAccessResources,
            ),
            const SizedBox(height: 16),
            ProviderAccountAction(
              providerType: 'emby',
              onPressed: widget.onOpenBinding == null
                  ? null
                  : () => widget.onOpenBinding!(),
            ),
          ],
        ),
      );
    }
    final controls = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ?widget.leadingControls,
        if (widget.onProxyModeChanged case final onProxyModeChanged?)
          if (_playbackPolicySource case final source?) ...[
            const SizedBox(height: 12),
            PlaybackProxyModeControl(
              key: const Key('emby-playback-proxy-mode'),
              value: widget.proxyMode,
              enabled: !_loading,
              source: source,
              onChanged: onProxyModeChanged,
            ),
          ],
        LayoutBuilder(
          builder: (context, constraints) {
            final mode = _buildModeSelector();
            final account = _buildAccountSelector();
            if (constraints.maxWidth >= _twoColumnMinWidth) {
              return Row(
                children: [
                  Expanded(child: mode),
                  const SizedBox(width: 12),
                  Expanded(child: account),
                ],
              );
            }
            return Column(
              children: [mode, const SizedBox(height: 10), account],
            );
          },
        ),
        if (_supportsItemTypes) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              for (final type in const ['Movie', 'Episode', 'Video'])
                FilterChip(
                  label: Text(localizedMediaVariant(context, type)),
                  selected: _itemTypes.contains(type),
                  onSelected: _loading
                      ? null
                      : (selected) {
                          if (!selected && _itemTypes.length == 1) {
                            return;
                          }
                          setState(() {
                            if (selected) {
                              _itemTypes.add(type);
                            } else {
                              _itemTypes.remove(type);
                            }
                            _resetDiscovery(keepLocation: true);
                          });
                        },
                ),
            ],
          ),
        ],
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final search = AppTextField(
              controller: _searchController,
              enabled: !_loading,
              label: context.l10n.search,
              prefixIcon: Icons.search_rounded,
              onChanged: (_) => setState(() {
                _listSource = null;
                _selection.clear();
              }),
              onSubmitted: (_) => _list(),
            );
            final name = AppTextField(
              controller: _nameController,
              enabled: !_loading,
              label: context.l10n.playlistName,
              prefixIcon: Icons.title_rounded,
            );
            if (constraints.maxWidth >= _twoColumnMinWidth) {
              return Row(
                children: [
                  Expanded(child: search),
                  const SizedBox(width: 12),
                  Expanded(child: name),
                ],
              );
            }
            return Column(children: [search, const SizedBox(height: 10), name]);
          },
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            AppIconButton(
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: _loading || _locations.isEmpty ? null : _goBack,
              icon: Icons.arrow_back_rounded,
            ),
            Expanded(
              child: Text(
                _locations.lastOrNull?.title ?? _modeLabel(_mode),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            FilledButton.tonalIcon(
              key: const Key('emby-preview'),
              onPressed: _loading || _bind == null ? null : _list,
              icon: const Icon(Icons.manage_search_rounded),
              label: Text(context.l10n.list),
            ),
          ],
        ),
        const SizedBox(height: 6),
      ],
    );
    final results = _loading && _items.isEmpty
        ? const AppLoadingIndicator()
        : DiscoveryBrowser(
            key: ValueKey(
              'emby-discovery:${_bind?.serverId}:${_requestMode.name}:'
              '$_targetId:$_activeSearch:${_itemTypes.join(',')}',
            ),
            items: [
              for (final item in _items)
                DiscoveryBrowserEntry(
                  key: item.id,
                  title: item.name,
                  subtitle: item.description.isEmpty
                      ? localizedMediaVariant(context, item.type)
                      : item.description,
                  source: item.source,
                  isContainer: item.source.isPlaylist,
                  leading: item.thumbnail.isEmpty
                      ? Icon(
                          item.source.isPlaylist
                              ? Icons.folder_rounded
                              : Icons.movie_outlined,
                        )
                      : AppImageThumbnail(
                          url: item.thumbnail,
                          width: 48,
                          height: 48,
                          borderRadius: BorderRadius.circular(4),
                          errorIcon: Icons.movie_outlined,
                        ),
                ),
            ],
            selectionController: _selection,
            selectionScope:
                '${_bind?.id}:${_requestMode.name}:$_targetId:$_activeSearch',
            onSelectionChanged: () => setState(() {}),
            loading: _loading,
            paginationMode: DiscoveryPaginationMode.page,
            page: _page,
            pageSize: _pageSize,
            total: _total,
            hasMore: _hasMore,
            onPreviousPage: _loading || _page <= 1
                ? null
                : () => _load(page: _page - 1, preserveSelection: true),
            onNextPage: _loading || !_hasMore
                ? null
                : () => _load(page: _page + 1, preserveSelection: true),
            onOpen: _open,
            onAddSelected: _addSelected,
            onAddCurrentList: _listSource == null ? null : _addCurrentList,
            emptyIcon: Icons.video_library_outlined,
            emptyTitle: context.l10n.listSourceToPreview,
          );
    return ProviderWorkspace(controls: controls, results: results);
  }

  Widget _buildModeSelector() => DropdownButtonFormField<EmbyCollectionMode>(
    key: const Key('emby-collection-mode'),
    isExpanded: true,
    initialValue: _mode,
    decoration: InputDecoration(
      labelText: context.l10n.source,
      prefixIcon: const Icon(Icons.video_library_outlined),
    ),
    items: [
      for (final mode in EmbyCollectionMode.values)
        DropdownMenuItem(value: mode, child: Text(_modeLabel(mode))),
    ],
    onChanged: _loading
        ? null
        : (mode) {
            if (mode == null) return;
            setState(() {
              _mode = mode;
              _locations.clear();
              _resetDiscovery(keepLocation: true);
            });
          },
  );

  Widget _buildAccountSelector() => DropdownButtonFormField<String>(
    isExpanded: true,
    initialValue: _bind?.id,
    decoration: InputDecoration(
      labelText: context.l10n.mediaSourceAccount,
      prefixIcon: const Icon(Icons.account_circle_outlined),
    ),
    items: [
      for (final bind in widget.binds)
        DropdownMenuItem(
          value: bind.id,
          child: Text(
            bind.providerInstanceName.isEmpty
                ? bind.host
                : '${bind.host} · ${bind.providerInstanceName}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
    ],
    onChanged: _loading
        ? null
        : (value) {
            setState(() {
              _bind = widget.binds.firstWhere((bind) => bind.id == value);
              _locations.clear();
              _resetDiscovery(keepLocation: true);
            });
          },
  );

  bool get _supportsItemTypes => switch (_requestMode) {
    EmbyListMode.favoriteItems ||
    EmbyListMode.favoritePeople ||
    EmbyListMode.personItems ||
    EmbyListMode.recentlyAdded ||
    EmbyListMode.genres ||
    EmbyListMode.genreItems => true,
    _ => false,
  };

  EmbyListMode get _requestMode =>
      _locations.lastOrNull?.mode ??
      switch (_mode) {
        EmbyCollectionMode.continueWatching => EmbyListMode.continueWatching,
        EmbyCollectionMode.nextUp => EmbyListMode.nextUp,
        EmbyCollectionMode.recentlyAdded => EmbyListMode.recentlyAdded,
        EmbyCollectionMode.favoriteItems => EmbyListMode.favoriteItems,
        EmbyCollectionMode.favoritePeople => EmbyListMode.favoritePeople,
        EmbyCollectionMode.playlists => EmbyListMode.playlists,
        EmbyCollectionMode.collections => EmbyListMode.collections,
        EmbyCollectionMode.genres => EmbyListMode.genres,
      };

  String get _targetId => _locations.lastOrNull?.targetId ?? '';

  void _resetDiscovery({bool keepLocation = false}) {
    _items = const [];
    _listSource = null;
    _selection.clear();
    _page = 1;
    _total = 0;
    _hasMore = false;
    _activeSearch = '';
    if (!keepLocation) _locations.clear();
  }

  void _list() {
    setState(() {
      _activeSearch = _searchController.text.trim();
      _page = 1;
      _items = const [];
      _listSource = null;
      _selection.clear();
    });
    _load();
  }

  Future<void> _load({int? page, bool preserveSelection = false}) async {
    final bind = _bind;
    if (bind == null || _loading) return;
    final nextPage = page ?? 1;
    setState(() {
      _loading = true;
      if (!preserveSelection) _selection.clear();
    });
    try {
      final page =
          await (widget.loader?.call(
                bind,
                _requestMode,
                _targetId,
                _itemTypes.toList(),
                _activeSearch,
                nextPage,
                _pageSize,
              ) ??
              providerGateway.listEmbyPage(
                _requestMode,
                targetId: _targetId,
                itemTypes: _itemTypes.toList(),
                keyword: _activeSearch,
                page: nextPage,
                max: _pageSize,
                serverId: bind.serverId,
                instanceName: bind.providerInstanceName,
              ));
      if (!mounted) return;
      setState(() {
        _items = page.items;
        _page = nextPage;
        _total = page.total;
        _hasMore = _page * _pageSize < page.total;
        _listSource = page.source;
      });
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _open(DiscoveryBrowserEntry entry) {
    final nextMode = switch (_requestMode) {
      EmbyListMode.favoritePeople => EmbyListMode.personItems,
      EmbyListMode.genres => EmbyListMode.genreItems,
      _ => EmbyListMode.folder,
    };
    setState(() {
      _locations.add(
        _EmbyBrowseLocation(
          mode: nextMode,
          targetId: entry.key,
          title: entry.title,
        ),
      );
      _resetDiscovery(keepLocation: true);
    });
    _load();
  }

  void _goBack() {
    setState(() {
      _locations.removeLast();
      _resetDiscovery(keepLocation: true);
    });
    _load();
  }

  Future<void> _addSelected(List<DiscoveryBrowserEntry> entries) =>
      _runAdd(() async {
        for (final entry in entries) {
          await providerGateway.addDiscoveredSource(
            widget.roomId,
            playlistId: widget.parentId,
            source: entry.source.withPlaybackProxyMode(widget.proxyMode),
            name: entry.title,
          );
        }
      });

  Future<void> _addCurrentList() => _runAdd(() async {
    final defaultName = _locations.lastOrNull?.title ?? _modeLabel(_mode);
    await providerGateway.addDiscoveredSource(
      widget.roomId,
      playlistId: widget.parentId,
      source: _listSource!.withPlaybackProxyMode(widget.proxyMode),
      name: _nameController.text.trim().isEmpty
          ? defaultName
          : _nameController.text.trim(),
    );
  });

  Future<void> _runAdd(Future<void> Function() action) async {
    setState(() => _loading = true);
    try {
      await action();
      if (!mounted) return;
      Navigator.pop(context);
      AppNotifications.showSuccess(context, context.l10n.addedSuccessfully);
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.addFailed('$error'));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _modeLabel(EmbyCollectionMode mode) => switch (mode) {
    EmbyCollectionMode.continueWatching => context.l10n.continueWatching,
    EmbyCollectionMode.nextUp => context.l10n.nextUp,
    EmbyCollectionMode.recentlyAdded => context.l10n.recentlyAdded,
    EmbyCollectionMode.favoriteItems => context.l10n.favoriteVideos,
    EmbyCollectionMode.favoritePeople => context.l10n.favoritePeople,
    EmbyCollectionMode.playlists => context.l10n.serverPlaylists,
    EmbyCollectionMode.collections => context.l10n.collections,
    EmbyCollectionMode.genres => context.l10n.genres,
  };
}
