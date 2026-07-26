import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

enum FnosBrowseMode { files, mediaLibrary }

typedef FnosFileLoader =
    Future<FnosFileListPage> Function(
      FnosBindInfo bind,
      String path,
      int page,
      int pageSize,
      String search,
    );
typedef FnosLibraryLoader =
    Future<List<FnosMediaLibraryInfo>> Function(FnosBindInfo bind);
typedef FnosMediaItemLoader =
    Future<FnosMediaListPage> Function(
      FnosBindInfo bind,
      FnosMediaCollection collection,
      String ancestorGuid,
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
    this.fileLoader,
    this.libraryLoader,
    this.mediaItemLoader,
  });

  final String roomId;
  final String playlistId;
  final List<FnosBindInfo> binds;
  final ValueChanged<bool>? onDraftChanged;
  final FnosFileLoader? fileLoader;
  final FnosLibraryLoader? libraryLoader;
  final FnosMediaItemLoader? mediaItemLoader;

  @override
  State<FnosAddMediaForm> createState() => _FnosAddMediaFormState();
}

class _FnosAddMediaFormState extends State<FnosAddMediaForm> {
  static const _pageSize = 50;

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
  final List<(String, String)> _mediaPath = [];
  List<FnosMediaItemInfo> _mediaItems = const [];
  final Set<String> _mutatingItems = {};

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
    if (_bind == null && widget.binds.isNotEmpty) {
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
        child: AppEmptyState(
          icon: Icons.storage_rounded,
          title: 'FNOS',
          subtitle: context.l10n.bindAccountToAccessResources,
        ),
      );
    }
    final mediaEnabled = _bind?.mediaAvailable == true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: _buildBindSelector()),
            const SizedBox(width: 12),
            Expanded(
              child: AppSegmentedControl<FnosBrowseMode>(
                segments: [
                  const ButtonSegment(
                    value: FnosBrowseMode.files,
                    icon: Icon(Icons.folder_outlined),
                    label: Text('Files'),
                  ),
                  ButtonSegment(
                    value: FnosBrowseMode.mediaLibrary,
                    enabled: mediaEnabled,
                    icon: const Icon(Icons.video_library_outlined),
                    label: const Text('Media'),
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
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _searchController,
                label: 'Search',
                prefixIcon: Icons.search_rounded,
                suffix: AppIconButton(
                  tooltip: 'Search',
                  onPressed: _loading ? null : _search,
                  icon: Icons.arrow_forward_rounded,
                ),
                onSubmitted: (_) => _search(),
              ),
            ),
            const SizedBox(width: 8),
            AppIconButton(
              tooltip: context.l10n.dynamicPlaylist,
              onPressed: _loading ? null : _addCurrentPlaylist,
              icon: Icons.playlist_add_rounded,
              style: AppIconButtonStyle.tonal,
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildLocationBar(),
        const SizedBox(height: 8),
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
  }

  Widget _buildBindSelector() {
    return DropdownButtonFormField<String>(
      initialValue: _bind?.serverId,
      decoration: const InputDecoration(
        labelText: 'FNOS',
        prefixIcon: Icon(Icons.dns_outlined),
      ),
      items: widget.binds
          .map(
            (bind) => DropdownMenuItem(
              value: bind.serverId,
              child: Text(
                bind.endpoint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(),
      onChanged: (serverId) {
        final bind = widget.binds.firstWhere(
          (candidate) => candidate.serverId == serverId,
        );
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
              FnosMediaCollection.library => 'Libraries',
              FnosMediaCollection.favorites => 'Favorites',
              FnosMediaCollection.history => 'Continue watching',
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
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
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
    if (_files.isEmpty) return _empty();
    return AppListView.separated(
      itemCount: _files.length,
      separatorBuilder: (_, _) => const AppDivider(height: 1),
      itemBuilder: (context, index) {
        final item = _files[index];
        return ListTile(
          leading: Icon(
            item.isDir ? Icons.folder_rounded : Icons.movie_outlined,
          ),
          title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: item.size == null ? null : Text(_formatBytes(item.size!)),
          onTap: item.isDir ? () => _openFileFolder(item) : null,
          trailing: AppIconButton(
            tooltip: item.isDir
                ? context.l10n.dynamicPlaylist
                : context.l10n.add,
            onPressed: () =>
                item.isDir ? _addFilePlaylist(item) : _addFileMedia(item),
            icon: item.isDir
                ? Icons.playlist_add_rounded
                : Icons.add_circle_outline_rounded,
          ),
        );
      },
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
              title: const Text('Favorites'),
              onTap: () => _openCollection(FnosMediaCollection.favorites),
              trailing: AppIconButton(
                tooltip: context.l10n.dynamicPlaylist,
                onPressed: () =>
                    _addNativePlaylist('favorites', 'FNOS Favorites'),
                icon: Icons.playlist_add_rounded,
              ),
            );
          }
          if (index == 1) {
            return ListTile(
              leading: const Icon(Icons.history_rounded),
              title: const Text('Continue watching'),
              onTap: () => _openCollection(FnosMediaCollection.history),
              trailing: AppIconButton(
                tooltip: context.l10n.dynamicPlaylist,
                onPressed: () =>
                    _addNativePlaylist('history', 'FNOS Continue watching'),
                icon: Icons.playlist_add_rounded,
              ),
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
            trailing: AppIconButton(
              tooltip: context.l10n.dynamicPlaylist,
              onPressed: () => _addMediaPlaylist(
                ancestorGuid: library.guid,
                name: library.title,
              ),
              icon: Icons.playlist_add_rounded,
            ),
          );
        },
      );
    }
    if (_mediaItems.isEmpty) return _empty();
    return AppListView.separated(
      itemCount: _mediaItems.length,
      separatorBuilder: (_, _) => const AppDivider(height: 1),
      itemBuilder: (context, index) {
        final item = _mediaItems[index];
        return ListTile(
          leading: _thumbnail(
            item.poster,
            fallback: item.isFolder
                ? Icons.folder_rounded
                : Icons.movie_outlined,
          ),
          title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: item.overview.isEmpty
              ? null
              : Text(
                  item.overview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
          onTap: item.isFolder ? () => _openMediaFolder(item) : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIconButton(
                tooltip: item.favorite ? 'Remove favorite' : 'Favorite',
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
                  tooltip: item.watched ? 'Mark unwatched' : 'Mark watched',
                  onPressed: _mutatingItems.contains(item.guid)
                      ? null
                      : () => _setWatched(item, !item.watched),
                  icon: item.watched
                      ? Icons.check_circle_rounded
                      : Icons.check_circle_outline_rounded,
                  iconSize: 20,
                ),
              if (item.isFolder || item.isPlayable)
                AppIconButton(
                  tooltip: item.isFolder
                      ? context.l10n.dynamicPlaylist
                      : context.l10n.add,
                  onPressed: () => item.isFolder
                      ? _addMediaPlaylist(
                          ancestorGuid: item.guid,
                          name: item.title,
                        )
                      : _addMediaItem(item),
                  icon: item.isFolder
                      ? Icons.playlist_add_rounded
                      : Icons.add_circle_outline_rounded,
                ),
            ],
          ),
        );
      },
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

  Widget _empty() => Center(
    child: AppEmptyState(icon: Icons.video_file_outlined, title: 'No items'),
  );

  void _resetLocation() {
    _filePath = '';
    _page = 1;
    _files = const [];
    _libraries = const [];
    _library = null;
    _collection = FnosMediaCollection.library;
    _mediaPath.clear();
    _mediaItems = const [];
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
    setState(() => _loading = true);
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
            });
          } else {
            final ancestorGuid =
                _mediaPath.lastOrNull?.$1 ?? _library?.guid ?? '';
            final result =
                await (widget.mediaItemLoader?.call(
                      bind,
                      _collection,
                      ancestorGuid,
                      _page,
                      _pageSize,
                      _searchController.text,
                    ) ??
                    providerGateway.listFnosMediaItems(
                      bind.serverId,
                      collection: _collection,
                      ancestorGuid: ancestorGuid,
                      page: _page,
                      pageSize: _pageSize,
                      search: _searchController.text,
                      instanceName: bind.providerInstanceName,
                    ));
            if (!mounted) return;
            setState(() {
              _mediaItems = result.items;
              _hasMore = result.hasMore;
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
      _mediaPath.add((item.guid, item.title));
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

  Future<void> _addCurrentPlaylist() async {
    if (_mode == FnosBrowseMode.files) {
      await _addFilePlaylist(
        FnosFileItemInfo(
          name: _filePath.split('/').lastOrNull ?? 'FNOS Files',
          path: _filePath,
          size: null,
          modifiedAt: null,
          createdAt: null,
          isDir: true,
          storageId: null,
        ),
      );
      return;
    }
    switch (_collection) {
      case FnosMediaCollection.library:
        final library = _library;
        if (library == null) return;
        await _addMediaPlaylist(
          ancestorGuid: _mediaPath.lastOrNull?.$1 ?? library.guid,
          name: _mediaPath.lastOrNull?.$2 ?? library.title,
        );
        return;
      case FnosMediaCollection.favorites:
        await _addNativePlaylist('favorites', 'FNOS Favorites');
        return;
      case FnosMediaCollection.history:
        await _addNativePlaylist('history', 'FNOS Continue watching');
        return;
    }
  }

  Future<void> _addFileMedia(FnosFileItemInfo item) => _runAdd(() async {
    final bind = _bind!;
    await providerGateway.addFnosFileMedia(
      widget.roomId,
      playlistId: widget.playlistId,
      serverId: bind.serverId,
      path: item.path,
      name: item.name,
      providerInstanceName: bind.providerInstanceName,
    );
  });

  Future<void> _addMediaItem(FnosMediaItemInfo item) => _runAdd(() async {
    final bind = _bind!;
    await providerGateway.addFnosMediaLibraryItem(
      widget.roomId,
      playlistId: widget.playlistId,
      serverId: bind.serverId,
      itemGuid: item.guid,
      mediaGuid: item.mediaGuid,
      name: item.title,
      providerInstanceName: bind.providerInstanceName,
    );
  });

  Future<void> _addFilePlaylist(FnosFileItemInfo item) => _runAdd(() async {
    final bind = _bind!;
    await providerGateway.createPlaylist(
      widget.roomId,
      parentId: widget.playlistId,
      sourceProvider: 'fnos',
      providerInstanceName: bind.providerInstanceName,
      sourceConfig: {
        'serverId': bind.serverId,
        'type': 'files',
        'path': item.path,
      },
      name: item.name.isEmpty ? 'FNOS Files' : item.name,
    );
  });

  Future<void> _addMediaPlaylist({
    required String ancestorGuid,
    required String name,
  }) => _runAdd(() async {
    final bind = _bind!;
    await providerGateway.createPlaylist(
      widget.roomId,
      parentId: widget.playlistId,
      sourceProvider: 'fnos',
      providerInstanceName: bind.providerInstanceName,
      sourceConfig: {
        'serverId': bind.serverId,
        'type': 'mediaLibrary',
        'ancestorGuid': ancestorGuid,
        'mediaTypes': ['Movie', 'TV', 'Directory', 'Video'],
      },
      name: name,
    );
  });

  Future<void> _addNativePlaylist(String type, String name) =>
      _runAdd(() async {
        final bind = _bind!;
        await providerGateway.createPlaylist(
          widget.roomId,
          parentId: widget.playlistId,
          sourceProvider: 'fnos',
          providerInstanceName: bind.providerInstanceName,
          sourceConfig: {
            'serverId': bind.serverId,
            'type': type,
            if (type == 'favorites')
              'mediaTypes': ['Movie', 'TV', 'Directory', 'Video'],
          },
          name: name,
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

  String _formatBytes(int value) {
    if (value < 1024) return '$value B';
    if (value < 1024 * 1024) return '${(value / 1024).toStringAsFixed(1)} KB';
    if (value < 1024 * 1024 * 1024) {
      return '${(value / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(value / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
