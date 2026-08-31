import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/discovered_source.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/discovery_browser.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_account_action.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/playback_proxy_mode_control.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_workspace.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

enum FnosBrowseMode { files, mediaLibrary }

typedef FnosFileLoader = Future<FnosFileListPage> Function(
  FnosBindInfo bind,
  String path,
  int page,
  int pageSize,
  String search,
);
typedef FnosLibraryLoader = Future<List<FnosMediaLibraryInfo>> Function(
  FnosBindInfo bind,
);
typedef FnosMediaItemLoader = Future<FnosMediaListPage> Function(
  FnosBindInfo bind,
  FnosMediaCollection collection,
  String libraryGuid,
  String parentGuid,
  int page,
  int pageSize,
  String search,
);

class FnosAddMediaForm extends StatefulWidget {
  const FnosAddMediaForm({
    super.key,
    required this.roomId,
    required this.playlistId,
    required this.binds,
    this.onDraftChanged,
    this.onOpenBinding,
    this.fileLoader,
    this.libraryLoader,
    this.mediaItemLoader,
  });

  final String roomId;
  final String playlistId;
  final List<FnosBindInfo> binds;
  final ValueChanged<bool>? onDraftChanged;
  final Future<void> Function()? onOpenBinding;
  final FnosFileLoader? fileLoader;
  final FnosLibraryLoader? libraryLoader;
  final FnosMediaItemLoader? mediaItemLoader;

  @override
  State<FnosAddMediaForm> createState() => _FnosAddMediaFormState();
}

class _FnosAddMediaFormState extends State<FnosAddMediaForm> {
  static const _pageSize = 50;

  final _selection = DiscoverySelectionController();
  final _searchController = TextEditingController();
  FnosBrowseMode _mode = FnosBrowseMode.files;
  FnosBindInfo? _bind;
  String _filePath = '';
  int _page = 1;
  bool _hasMore = false;
  bool _loading = false;
  List<FnosFileItemInfo> _files = const [];
  List<FnosMediaLibraryInfo> _libraries = const [];
  FnosMediaLibraryInfo? _library;
  FnosMediaCollection _collection = FnosMediaCollection.library;
  final List<(String, String, String)> _mediaPath = [];
  List<FnosMediaItemInfo> _mediaItems = const [];
  final Set<String> _mutatingItems = {};
  provider_common.DiscoveredSource? _listSource;
  source_enum.PlaybackProxyMode _proxyMode =
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;

  provider_common.DiscoveredSource? get _playbackPolicySource =>
      _selection.entries.firstOrNull?.source ?? _listSource;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_notifyDraftChanged);
    _bind = widget.binds.firstOrNull;
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void didUpdateWidget(covariant FnosAddMediaForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((_bind == null || !widget.binds.any((bind) => bind.id == _bind!.id)) &&
        widget.binds.isNotEmpty) {
      _bind = widget.binds.first;
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_notifyDraftChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _notifyDraftChanged() {
    widget.onDraftChanged?.call(_searchController.text.trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.binds.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppEmptyState(
              icon: Icons.storage_rounded,
              title: 'FNOS',
              subtitle: context.l10n.bindAccountToAccessResources,
            ),
            const SizedBox(height: 16),
            ProviderAccountAction(
              providerType: 'fnos',
              onPressed: widget.onOpenBinding == null
                  ? null
                  : () => widget.onOpenBinding!(),
            ),
          ],
        ),
      );
    }
    final mediaEnabled = _bind?.mediaAvailable == true;
    final controls = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: _buildBindSelector()),
            const SizedBox(width: 12),
            Expanded(
              child: AppSegmentedControl<FnosBrowseMode>(
                segments: [
                  ButtonSegment(
                    value: FnosBrowseMode.files,
                    icon: const Icon(Icons.folder_outlined),
                    label: Text(context.l10n.files),
                  ),
                  ButtonSegment(
                    value: FnosBrowseMode.mediaLibrary,
                    enabled: mediaEnabled,
                    icon: const Icon(Icons.video_library_outlined),
                    label: Text(context.l10n.media),
                  ),
                ],
                value: _mode,
                onChanged: (mode) {
                  setState(() {
                    _mode = mode;
                    _page = 1;
                    _searchController.clear();
                  });
                  _load();
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        PlaybackProxyModeControl(
          value: _proxyMode,
          source: _playbackPolicySource,
          onChanged: (value) => setState(() => _proxyMode = value),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _searchController,
                label: context.l10n.search,
                prefixIcon: Icons.search_rounded,
                suffix: AppIconButton(
                  tooltip: context.l10n.search,
                  onPressed: _loading ? null : _search,
                  icon: Icons.arrow_forward_rounded,
                ),
                onSubmitted: (_) => _search(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildLocationBar(),
      ],
    );
    final results = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _loading
              ? const AppLoadingIndicator()
              : _mode == FnosBrowseMode.files
              ? _buildFileList()
              : _buildMediaList(),
        ),
        const SizedBox(height: 8),
        _buildPagination(),
      ],
    );
    return ProviderWorkspace(controls: controls, results: results);
  }

  Widget _buildBindSelector() {
    return ProviderAccountSelector<FnosBindInfo>(
      accounts: widget.binds,
      selectedId: _bind?.id,
      idOf: (bind) => bind.id,
      labelOf: (bind) => bind.providerInstanceName.isEmpty
          ? bind.endpoint
          : '${bind.endpoint} · ${bind.providerInstanceName}',
      enabled: !_loading,
      onChanged: (bind) {
        if (bind == null) return;
        setState(() {
          _bind = bind;
          if (!bind.mediaAvailable) _mode = FnosBrowseMode.files;
          _resetLocation();
        });
        _load();
      },
    );
  }

  Widget _buildLocationBar() {
    final title = switch (_mode) {
      FnosBrowseMode.files => _filePath.isEmpty ? '/' : _filePath,
      FnosBrowseMode.mediaLibrary =>
        _mediaPath.lastOrNull?.$2 ??
            _library?.title ??
            switch (_collection) {
              FnosMediaCollection.library => context.l10n.libraries,
              FnosMediaCollection.favorites => context.l10n.favorites,
              FnosMediaCollection.history => context.l10n.continueWatching,
            },
    };
    final canGoUp = switch (_mode) {
      FnosBrowseMode.files => _filePath.isNotEmpty,
      FnosBrowseMode.mediaLibrary =>
        _library != null || _collection != FnosMediaCollection.library,
    };
    return Row(
      children: [
        AppIconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: canGoUp && !_loading ? _goUp : null,
          icon: Icons.arrow_upward_rounded,
        ),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        AppIconButton(
          tooltip: context.l10n.refresh,
          onPressed: _loading ? null : _load,
          icon: Icons.refresh_rounded,
        ),
      ],
    );
  }

  Widget _buildFileList() {
    final itemsByKey = {for (final item in _files) item.path: item};
    return DiscoveryBrowser(
      selectionController: _selection,
      selectionScope: _bind?.id,
      onSelectionChanged: () => setState(() {}),
      items: [
        for (final item in _files)
          DiscoveryBrowserEntry(
            key: item.path,
            title: item.name,
            subtitle: item.size == null ? '' : _formatBytes(item.size!),
            source: item.source,
            isContainer: item.isDir,
          ),
      ],
      loading: _loading,
      onOpen: (entry) => _openFileFolder(itemsByKey[entry.key]!),
      onAddSelected: _addSelected,
      onAddCurrentList: _listSource == null ? null : _addCurrentPlaylist,
    );
  }

  Widget _buildMediaList() {
    if (_collection == FnosMediaCollection.library && _library == null) {
      return AppListView.separated(
        itemCount: _libraries.length + 2,
        separatorBuilder: (_, _) => const AppDivider(height: 1),
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(
              leading: const Icon(Icons.star_rounded),
              title: Text(context.l10n.favorites),
              onTap: () => _openCollection(FnosMediaCollection.favorites),
            );
          }
          if (index == 1) {
            return ListTile(
              leading: const Icon(Icons.history_rounded),
              title: Text(context.l10n.continueWatching),
              onTap: () => _openCollection(FnosMediaCollection.history),
            );
          }
          final library = _libraries[index - 2];
          return ListTile(
            leading: _thumbnail(
              library.poster,
              fallback: Icons.video_library_rounded,
            ),
            title: Text(library.title),
            subtitle: library.category.isEmpty ? null : Text(library.category),
            onTap: () => _openLibrary(library),
          );
        },
      );
    }
    final itemsByKey = {for (final item in _mediaItems) item.guid: item};
    return DiscoveryBrowser(
      selectionController: _selection,
      selectionScope: _bind?.id,
      onSelectionChanged: () => setState(() {}),
      items: [
        for (final item in _mediaItems)
          DiscoveryBrowserEntry(
            key: item.guid,
            title: item.title,
            subtitle: item.overview,
            source: item.source,
            isContainer: item.isFolder,
            selectable: item.isFolder || item.isPlayable,
            leading: _thumbnail(
              item.poster,
              fallback: item.isFolder
                  ? Icons.folder_rounded
                  : Icons.movie_outlined,
            ),
            actions: [
              AppIconButton(
                tooltip: item.favorite
                    ? context.l10n.removeFavorite
                    : context.l10n.favorite,
                onPressed: _mutatingItems.contains(item.guid)
                    ? null
                    : () => _setFavorite(item, !item.favorite),
                icon: item.favorite
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                iconSize: 20,
              ),
              if (item.isPlayable)
                AppIconButton(
                  tooltip: item.watched
                      ? context.l10n.markUnwatched
                      : context.l10n.markWatched,
                  onPressed: _mutatingItems.contains(item.guid)
                      ? null
                      : () => _setWatched(item, !item.watched),
                  icon: item.watched
                      ? Icons.check_circle_rounded
                      : Icons.check_circle_outline_rounded,
                  iconSize: 20,
                ),
            ],
          ),
      ],
      loading: _loading,
      onOpen: (entry) => _openMediaFolder(itemsByKey[entry.key]!),
      onAddSelected: _addSelected,
      onAddCurrentList: _listSource == null ? null : _addCurrentPlaylist,
    );
  }

  Widget _buildPagination() {
    if (_mode == FnosBrowseMode.mediaLibrary &&
        _collection == FnosMediaCollection.library &&
        _library == null) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppIconButton(
          tooltip: MaterialLocalizations.of(context).previousPageTooltip,
          onPressed: _page > 1 && !_loading
              ? () {
                  setState(() => _page--);
                  _load();
                }
              : null,
          icon: Icons.chevron_left_rounded,
        ),
        SizedBox(width: 48, child: Text('$_page', textAlign: TextAlign.center)),
        AppIconButton(
          tooltip: MaterialLocalizations.of(context).nextPageTooltip,
          onPressed: _hasMore && !_loading
              ? () {
                  setState(() => _page++);
                  _load();
                }
              : null,
          icon: Icons.chevron_right_rounded,
        ),
      ],
    );
  }

  Widget _thumbnail(String url, {required IconData fallback}) {
    if (url.isEmpty) return Icon(fallback);
    return AppImageThumbnail(
      url: url,
      width: 42,
      height: 48,
      borderRadius: BorderRadius.circular(4),
      errorIcon: fallback,
    );
  }

  void _resetLocation() {
    _filePath = '';
    _page = 1;
    _files = const [];
    _libraries = const [];
    _library = null;
    _collection = FnosMediaCollection.library;
    _mediaPath.clear();
    _mediaItems = const [];
    _listSource = null;
  }

  void _search() {
    setState(() => _page = 1);
    _load();
  }

  Future<void> _setFavorite(FnosMediaItemInfo item, bool favorite) async {
    final bind = _bind;
    if (bind == null || _mutatingItems.contains(item.guid)) return;
    setState(() => _mutatingItems.add(item.guid));
    try {
      final success = await providerGateway.setFnosFavorite(
        bind.serverId,
        item.guid,
        favorite,
        instanceName: bind.providerInstanceName,
      );
      if (!success) throw StateError('FNOS rejected the favorite update');
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _mutatingItems.remove(item.guid));
    }
    if (mounted) await _load();
  }

  Future<void> _setWatched(FnosMediaItemInfo item, bool watched) async {
    final bind = _bind;
    if (bind == null || _mutatingItems.contains(item.guid)) return;
    setState(() => _mutatingItems.add(item.guid));
    try {
      final success = await providerGateway.setFnosWatched(
        bind.serverId,
        item.guid,
        watched,
        instanceName: bind.providerInstanceName,
      );
      if (!success) throw StateError('FNOS rejected the watched update');
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _mutatingItems.remove(item.guid));
    }
    if (mounted) await _load();
  }

  Future<void> _load() async {
    final bind = _bind;
    if (bind == null || _loading) return;
    setState(() {
      _loading = true;
      _listSource = null;
      _selection.clear();
    });
    try {
      switch (_mode) {
        case FnosBrowseMode.files:
          final result =
              await (widget.fileLoader?.call(
                    bind,
                    _filePath,
                    _page,
                    _pageSize,
                    _searchController.text,
                  ) ??
                  providerGateway.listFnosFiles(
                    bind.serverId,
                    _filePath,
                    page: _page,
                    pageSize: _pageSize,
                    search: _searchController.text,
                    instanceName: bind.providerInstanceName,
                  ));
          if (!mounted) return;
          setState(() {
            _files = result.items;
            _hasMore = result.hasMore;
            _listSource = result.source;
          });
        case FnosBrowseMode.mediaLibrary:
          if (_collection == FnosMediaCollection.library && _library == null) {
            final libraries =
                await (widget.libraryLoader?.call(bind) ??
                    providerGateway.listFnosMediaLibraries(
                      bind.serverId,
                      instanceName: bind.providerInstanceName,
                    ));
            if (!mounted) return;
            setState(() {
              _libraries = libraries;
              _hasMore = false;
              _listSource = null;
            });
          } else {
            final libraryGuid =
                _mediaPath.lastOrNull?.$3 ?? _library?.guid ?? '';
            final parentGuid = _mediaPath.lastOrNull?.$1 ?? '';
            final result =
                await (widget.mediaItemLoader?.call(
                      bind,
                      _collection,
                      libraryGuid,
                      parentGuid,
                      _page,
                      _pageSize,
                      _searchController.text,
                    ) ??
                    providerGateway.listFnosMediaItems(
                      bind.serverId,
                      collection: _collection,
                      libraryGuid: libraryGuid,
                      parentGuid: parentGuid,
                      page: _page,
                      pageSize: _pageSize,
                      search: _searchController.text,
                      instanceName: bind.providerInstanceName,
                    ));
            if (!mounted) return;
            setState(() {
              _mediaItems = result.items;
              _hasMore = result.hasMore;
              _listSource = result.source;
            });
          }
      }
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(context, '$error');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openFileFolder(FnosFileItemInfo item) {
    setState(() {
      _filePath = item.path;
      _page = 1;
    });
    _load();
  }

  void _openLibrary(FnosMediaLibraryInfo library) {
    setState(() {
      _collection = FnosMediaCollection.library;
      _library = library;
      _mediaPath.clear();
      _page = 1;
    });
    _load();
  }

  void _openCollection(FnosMediaCollection collection) {
    setState(() {
      _collection = collection;
      _library = null;
      _mediaPath.clear();
      _mediaItems = const [];
      _page = 1;
    });
    _load();
  }

  void _openMediaFolder(FnosMediaItemInfo item) {
    setState(() {
      _mediaPath.add((item.guid, item.title, item.libraryGuid));
      _page = 1;
    });
    _load();
  }

  void _goUp() {
    setState(() {
      _page = 1;
      if (_mode == FnosBrowseMode.files) {
        final normalized = _filePath.trimRight();
        final separator = normalized.lastIndexOf('/');
        _filePath = separator <= 0 ? '' : normalized.substring(0, separator);
      } else if (_mediaPath.isNotEmpty) {
        _mediaPath.removeLast();
      } else if (_collection != FnosMediaCollection.library) {
        _collection = FnosMediaCollection.library;
        _mediaItems = const [];
      } else {
        _library = null;
        _mediaItems = const [];
      }
    });
    _load();
  }

  Future<void> _addCurrentPlaylist() => _runAdd(() async {
    await providerGateway.addDiscoveredSource(
      widget.roomId,
      playlistId: widget.playlistId,
      source: _listSource!.withPlaybackProxyMode(_proxyMode),
    );
  });

  Future<void> _addSelected(List<DiscoveryBrowserEntry> entries) =>
      _runAdd(() async {
        for (final entry in entries) {
          await providerGateway.addDiscoveredSource(
            widget.roomId,
            playlistId: widget.playlistId,
            source: entry.source.withPlaybackProxyMode(_proxyMode),
            name: entry.title,
          );
        }
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

  String _formatBytes(int value) {
    if (value < 1024) return '$value B';
    if (value < 1024 * 1024) return '${(value / 1024).toStringAsFixed(1)} KB';
    if (value < 1024 * 1024 * 1024) {
      return '${(value / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(value / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
