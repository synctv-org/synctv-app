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

enum _SynologyBrowseMode { files, videoStation }

typedef SynologyFileLoader = Future<SynologyFileListPage> Function(
  SynologyBindInfo bind,
  String path,
  int page,
  int pageSize,
  String search,
);
typedef SynologyLibraryLoader = Future<List<SynologyVideoLibraryInfo>> Function(
  SynologyBindInfo bind,
);
typedef SynologyVideoLoader = Future<SynologyVideoListPage> Function(
  SynologyBindInfo bind,
  SynologyVideoCollection collection,
  int libraryId,
  int? tvShowId,
  int page,
  int pageSize,
  String search,
);

class SynologyAddMediaForm extends StatefulWidget {
  const SynologyAddMediaForm({
    super.key,
    required this.roomId,
    required this.playlistId,
    required this.binds,
    this.onDraftChanged,
    this.onOpenBinding,
    this.fileLoader,
    this.libraryLoader,
    this.videoLoader,
  });

  final String roomId;
  final String playlistId;
  final List<SynologyBindInfo> binds;
  final ValueChanged<bool>? onDraftChanged;
  final Future<void> Function()? onOpenBinding;
  final SynologyFileLoader? fileLoader;
  final SynologyLibraryLoader? libraryLoader;
  final SynologyVideoLoader? videoLoader;

  @override
  State<SynologyAddMediaForm> createState() => _SynologyAddMediaFormState();
}

class _SynologyAddMediaFormState extends State<SynologyAddMediaForm> {
  static const _pageSize = 50;

  final _selection = DiscoverySelectionController();
  final _searchController = TextEditingController();
  SynologyBindInfo? _bind;
  _SynologyBrowseMode _mode = _SynologyBrowseMode.files;
  String _path = '';
  List<SynologyFileItemInfo> _files = const [];
  List<SynologyVideoLibraryInfo> _libraries = const [];
  SynologyVideoLibraryInfo? _library;
  SynologyVideoCollection _collection = SynologyVideoCollection.movies;
  SynologyVideoItemInfo? _tvShow;
  List<SynologyVideoItemInfo> _videos = const [];
  int _page = 1;
  bool _hasMore = false;
  bool _loading = false;
  provider_common.DiscoveredSource? _listSource;
  source_enum.PlaybackProxyMode _proxyMode =
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;

  provider_common.DiscoveredSource? get _playbackPolicySource =>
      _selection.entries.firstOrNull?.source ?? _listSource;

  @override
  void initState() {
    super.initState();
    _bind = widget.binds.firstOrNull;
    _searchController.addListener(_notifyDraftChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void didUpdateWidget(covariant SynologyAddMediaForm oldWidget) {
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
              title: 'Synology DSM',
              subtitle: context.l10n.bindAccountToAccessResources,
            ),
            const SizedBox(height: 16),
            ProviderAccountAction(
              providerType: 'synology',
              onPressed: widget.onOpenBinding == null
                  ? null
                  : () => widget.onOpenBinding!(),
            ),
          ],
        ),
      );
    }
    final canUseVideo = _bind?.videoStationAvailable ?? false;
    final controls = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildBindSelector(),
        const SizedBox(height: 10),
        PlaybackProxyModeControl(
          value: _proxyMode,
          source: _playbackPolicySource,
          onChanged: (value) => setState(() => _proxyMode = value),
        ),
        const SizedBox(height: 10),
        SegmentedButton<_SynologyBrowseMode>(
          segments: [
            ButtonSegment(
              value: _SynologyBrowseMode.files,
              icon: const Icon(Icons.folder_outlined),
              label: Text(context.l10n.fileStation),
            ),
            ButtonSegment(
              value: _SynologyBrowseMode.videoStation,
              enabled: canUseVideo,
              icon: const Icon(Icons.video_library_outlined),
              label: Text(context.l10n.videoStation),
            ),
          ],
          selected: {_mode},
          onSelectionChanged: _loading
              ? null
              : (selection) {
                  setState(() {
                    _mode = selection.single;
                    _page = 1;
                    _searchController.clear();
                    _tvShow = null;
                    _listSource = null;
                    _selection.clear();
                  });
                  _load();
                },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _searchController,
                label: context.l10n.search,
                prefixIcon: Icons.search_rounded,
                onSubmitted: (_) => _search(),
              ),
            ),
            const SizedBox(width: 8),
            AppIconButton(
              tooltip: context.l10n.search,
              onPressed: _loading ? null : _search,
              icon: Icons.arrow_forward_rounded,
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_mode == _SynologyBrowseMode.files)
          _buildFileLocationBar()
        else
          _buildVideoFilters(),
      ],
    );
    final results = Column(
      children: [
        Expanded(
          child: _loading
              ? const AppLoadingIndicator()
              : _mode == _SynologyBrowseMode.files
              ? _buildFileList()
              : _buildVideoList(),
        ),
        const SizedBox(height: 8),
        _buildPagination(),
      ],
    );
    return ProviderWorkspace(controls: controls, results: results);
  }

  Widget _buildBindSelector() {
    return ProviderAccountSelector<SynologyBindInfo>(
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
          if (!bind.videoStationAvailable) _mode = _SynologyBrowseMode.files;
          _path = '';
          _page = 1;
          _library = null;
          _libraries = const [];
          _tvShow = null;
          _files = const [];
          _videos = const [];
          _listSource = null;
          _selection.clear();
        });
        _load();
      },
    );
  }

  Widget _buildFileLocationBar() {
    return Row(
      children: [
        AppIconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: _path.isNotEmpty && !_loading ? _goUp : null,
          icon: Icons.arrow_upward_rounded,
        ),
        Expanded(
          child: Text(
            _path.isEmpty ? 'Shared folders' : _path,
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

  Widget _buildVideoFilters() {
    if (_libraries.isEmpty) {
      return Row(
        children: [
          Expanded(child: Text(context.l10n.videoStation)),
          AppIconButton(
            tooltip: context.l10n.refresh,
            onPressed: _loading ? null : _load,
            icon: Icons.refresh_rounded,
          ),
        ],
      );
    }
    return Column(
      children: [
        Row(
          children: [
            if (_tvShow != null)
              AppIconButton(
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                onPressed: _loading
                    ? null
                    : () {
                        setState(() {
                          _tvShow = null;
                          _collection = SynologyVideoCollection.tvShows;
                          _page = 1;
                        });
                        _loadVideos();
                      },
                icon: Icons.arrow_back_rounded,
              ),
            Expanded(
              child: DropdownButtonFormField<int>(
                initialValue: _library?.id,
                decoration: InputDecoration(
                  labelText: context.l10n.library,
                  prefixIcon: const Icon(Icons.video_library_outlined),
                ),
                items: _libraries
                    .map(
                      (library) => DropdownMenuItem(
                        value: library.id,
                        child: Text(
                          library.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: _loading
                    ? null
                    : (id) {
                        setState(() {
                          _library = _libraries.firstWhere(
                            (library) => library.id == id,
                          );
                          _tvShow = null;
                          _page = 1;
                        });
                        _loadVideos();
                      },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_tvShow == null)
          SizedBox(
            height: 42,
            child: AppSingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: SynologyVideoCollection.values
                    .where((value) => value != SynologyVideoCollection.episodes)
                    .map(
                      (value) => Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: ChoiceChip(
                          label: Text(_collectionLabel(value)),
                          selected: _collection == value,
                          onSelected: _loading
                              ? null
                              : (_) {
                                  setState(() {
                                    _collection = value;
                                    _page = 1;
                                  });
                                  _loadVideos();
                                },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
        else
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _tvShow!.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall,
            ),
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
            subtitle: item.isDir
                ? context.l10n.folder
                : _formatBytes(item.size),
            source: item.source.withPlaybackProxyMode(_proxyMode),
            isContainer: item.isDir,
            leading: item.isDir || item.thumbnailUrl.isEmpty
                ? Icon(item.isDir ? Icons.folder_rounded : Icons.movie_outlined)
                : AppImageThumbnail(
                    url: item.thumbnailUrl,
                    headers: resourceUrlResolver.authenticatedHeaders,
                    width: 48,
                    height: 44,
                    borderRadius: BorderRadius.circular(4),
                    errorIcon: Icons.movie_outlined,
                  ),
          ),
      ],
      loading: _loading,
      onOpen: (entry) => _openFolder(itemsByKey[entry.key]!),
      onAddSelected: _addSelected,
      onAddCurrentList: _listSource == null ? null : _addCurrentPlaylist,
      emptyIcon: Icons.folder_off_outlined,
      emptyTitle: context.l10n.noFiles,
    );
  }

  Widget _buildVideoList() {
    final itemsByKey = {
      for (final item in _videos) '${item.type}:${item.id}': item,
    };
    return DiscoveryBrowser(
      selectionController: _selection,
      selectionScope: _bind?.id,
      onSelectionChanged: () => setState(() {}),
      items: [
        for (final item in _videos)
          DiscoveryBrowserEntry(
            key: '${item.type}:${item.id}',
            title: item.title,
            subtitle: _videoDetails(item, item.files.firstOrNull),
            source: item.source,
            isContainer: item.type == SynologyVideoEntryType.tvShow,
            selectable:
                item.type == SynologyVideoEntryType.tvShow || item.isPlayable,
            leading: AppImageThumbnail(
              url: item.posterUrl,
              headers: resourceUrlResolver.authenticatedHeaders,
              width: 48,
              height: 48,
              borderRadius: BorderRadius.circular(4),
              errorIcon: item.type == SynologyVideoEntryType.tvShow
                  ? Icons.tv_rounded
                  : Icons.movie_outlined,
            ),
          ),
      ],
      loading: _loading,
      onOpen: (entry) => _openTvShow(itemsByKey[entry.key]!),
      onAddSelected: _addSelected,
      onAddCurrentList: _listSource == null ? null : _addCurrentPlaylist,
      emptyTitle: context.l10n.noMedia,
    );
  }

  Widget _buildPagination() {
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

  void _search() {
    setState(() => _page = 1);
    _load();
  }

  Future<void> _load() {
    return _mode == _SynologyBrowseMode.files ? _loadFiles() : _loadVideoMode();
  }

  Future<void> _loadFiles() async {
    final bind = _bind;
    if (bind == null) return;
    setState(() {
      _loading = true;
      _listSource = null;
      _selection.clear();
    });
    try {
      final page =
          await (widget.fileLoader?.call(
                bind,
                _path,
                _page,
                _pageSize,
                _searchController.text,
              ) ??
              providerGateway.listSynologyFiles(
                bind.serverId,
                _path,
                page: _page,
                pageSize: _pageSize,
                search: _searchController.text,
                instanceName: bind.providerInstanceName,
              ));
      if (!mounted) return;
      setState(() {
        _files = page.items;
        _hasMore = page.hasMore;
        _listSource = page.source;
      });
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadVideoMode() async {
    final bind = _bind;
    if (bind == null || !bind.videoStationAvailable) return;
    if (_libraries.isEmpty) {
      setState(() {
        _loading = true;
        _listSource = null;
        _selection.clear();
      });
      try {
        final libraries =
            await (widget.libraryLoader?.call(bind) ??
                providerGateway.listSynologyLibraries(
                  bind.serverId,
                  instanceName: bind.providerInstanceName,
                ));
        if (!mounted) return;
        setState(() {
          _libraries = libraries.where((library) => library.visible).toList();
          _library = _libraries.firstOrNull;
        });
      } catch (error) {
        if (mounted) AppNotifications.showError(context, '$error');
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    }
    await _loadVideos();
  }

  Future<void> _loadVideos() async {
    final bind = _bind;
    final library = _library;
    if (bind == null || library == null) return;
    setState(() {
      _loading = true;
      _listSource = null;
      _selection.clear();
    });
    try {
      final collection = _tvShow == null
          ? _collection
          : SynologyVideoCollection.episodes;
      final page =
          await (widget.videoLoader?.call(
                bind,
                collection,
                library.id,
                _tvShow?.id,
                _page,
                _pageSize,
                _searchController.text,
              ) ??
              providerGateway.listSynologyVideos(
                bind.serverId,
                collection: collection,
                libraryId: library.id,
                tvShowId: _tvShow?.id,
                page: _page,
                pageSize: _pageSize,
                search: _searchController.text,
                instanceName: bind.providerInstanceName,
              ));
      if (!mounted) return;
      setState(() {
        _videos = page.items;
        _hasMore = page.hasMore;
        _listSource = page.source;
      });
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _openFolder(SynologyFileItemInfo item) {
    setState(() {
      _path = item.path;
      _page = 1;
      _searchController.clear();
    });
    _loadFiles();
  }

  void _goUp() {
    final parts = _path.split('/').where((part) => part.isNotEmpty).toList();
    if (parts.isNotEmpty) parts.removeLast();
    setState(() {
      _path = parts.isEmpty ? '' : '/${parts.join('/')}';
      _page = 1;
      _searchController.clear();
    });
    _loadFiles();
  }

  void _openTvShow(SynologyVideoItemInfo item) {
    setState(() {
      _tvShow = item;
      _collection = SynologyVideoCollection.episodes;
      _page = 1;
      _searchController.clear();
    });
    _loadVideos();
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

  String _collectionLabel(SynologyVideoCollection value) => switch (value) {
    SynologyVideoCollection.movies => 'Movies',
    SynologyVideoCollection.tvShows => 'TV Shows',
    SynologyVideoCollection.episodes => 'Episodes',
    SynologyVideoCollection.homeVideos => 'Home Videos',
    SynologyVideoCollection.tvRecordings => 'TV Recordings',
  };

  String _videoDetails(
    SynologyVideoItemInfo item,
    SynologyVideoFileInfo? file,
  ) {
    final values = <String>[];
    if (item.season != null && item.episode != null) {
      values.add('S${item.season} E${item.episode}');
    }
    if (item.genres.isNotEmpty) values.add(item.genres.take(2).join('/'));
    if (item.rating > 0) values.add('Rating ${item.rating}');
    if (item.watchedRatio > 0) {
      values.add('${(item.watchedRatio.clamp(0, 1) * 100).round()}% watched');
    }
    if (file != null) {
      if (file.width > 0 && file.height > 0) {
        values.add('${file.width}×${file.height}');
      }
      if (file.videoCodec.isNotEmpty) values.add(file.videoCodec.toUpperCase());
      if (file.videoBitrate > 0) {
        values.add('${(file.videoBitrate / 1000000).toStringAsFixed(1)} Mbps');
      }
      if (file.conversionProduced) values.add('Converted');
      if (file.durationSeconds > 0) {
        values.add(_formatDuration(file.durationSeconds));
      }
    }
    if (values.isEmpty && item.summary.isNotEmpty) values.add(item.summary);
    return values.join(' · ');
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final remaining = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return '${duration.inHours}:$minutes:$remaining';
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
