import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

enum _SynologyBrowseMode { files, videoStation }

typedef SynologyFileLoader =
    Future<SynologyFileListPage> Function(
      SynologyBindInfo bind,
      String path,
      int page,
      int pageSize,
      String search,
    );
typedef SynologyLibraryLoader =
    Future<List<SynologyVideoLibraryInfo>> Function(SynologyBindInfo bind);
typedef SynologyVideoLoader =
    Future<SynologyVideoListPage> Function(
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
    this.fileLoader,
    this.libraryLoader,
    this.videoLoader,
  });

  final String roomId;
  final String playlistId;
  final List<SynologyBindInfo> binds;
  final ValueChanged<bool>? onDraftChanged;
  final SynologyFileLoader? fileLoader;
  final SynologyLibraryLoader? libraryLoader;
  final SynologyVideoLoader? videoLoader;

  @override
  State<SynologyAddMediaForm> createState() => _SynologyAddMediaFormState();
}

class _SynologyAddMediaFormState extends State<SynologyAddMediaForm> {
  static const _pageSize = 50;

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
          title: 'Synology DSM',
          subtitle: context.l10n.bindAccountToAccessResources,
        ),
      );
    }
    final canUseVideo = _bind?.videoStationAvailable ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildBindSelector(),
        const SizedBox(height: 10),
        SegmentedButton<_SynologyBrowseMode>(
          segments: [
            const ButtonSegment(
              value: _SynologyBrowseMode.files,
              icon: Icon(Icons.folder_outlined),
              label: Text('File Station'),
            ),
            ButtonSegment(
              value: _SynologyBrowseMode.videoStation,
              enabled: canUseVideo,
              icon: const Icon(Icons.video_library_outlined),
              label: const Text('Video Station'),
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
                label: 'Search',
                prefixIcon: Icons.search_rounded,
                onSubmitted: (_) => _search(),
              ),
            ),
            const SizedBox(width: 8),
            AppIconButton(
              tooltip: 'Search',
              onPressed: _loading ? null : _search,
              icon: Icons.arrow_forward_rounded,
            ),
            AppIconButton(
              tooltip: context.l10n.dynamicPlaylist,
              onPressed: _loading ? null : _addCurrentPlaylist,
              icon: Icons.playlist_add_rounded,
              style: AppIconButtonStyle.tonal,
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_mode == _SynologyBrowseMode.files)
          _buildFileLocationBar()
        else
          _buildVideoFilters(),
        const SizedBox(height: 8),
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
  }

  Widget _buildBindSelector() {
    return DropdownButtonFormField<String>(
      initialValue: _bind?.serverId,
      decoration: const InputDecoration(
        labelText: 'Synology DSM',
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
          if (!bind.videoStationAvailable) _mode = _SynologyBrowseMode.files;
          _path = '';
          _page = 1;
          _library = null;
          _libraries = const [];
          _tvShow = null;
          _files = const [];
          _videos = const [];
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

  Widget _buildVideoFilters() {
    if (_libraries.isEmpty) {
      return Row(
        children: [
          const Expanded(child: Text('Video Station')),
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
                decoration: const InputDecoration(
                  labelText: 'Library',
                  prefixIcon: Icon(Icons.video_library_outlined),
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
    if (_files.isEmpty) {
      return const Center(
        child: AppEmptyState(
          icon: Icons.folder_off_outlined,
          title: 'No files',
        ),
      );
    }
    return AppListView.separated(
      itemCount: _files.length,
      separatorBuilder: (_, _) => const AppDivider(height: 1),
      itemBuilder: (context, index) {
        final item = _files[index];
        return ListTile(
          leading: item.isDir || item.thumbnailUrl.isEmpty
              ? Icon(item.isDir ? Icons.folder_rounded : Icons.movie_outlined)
              : AppImageThumbnail(
                  url: item.thumbnailUrl,
                  headers: resourceUrlResolver.authenticatedHeaders,
                  width: 72,
                  height: 44,
                  borderRadius: BorderRadius.circular(4),
                  errorIcon: Icons.movie_outlined,
                ),
          title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            item.isDir ? 'Folder' : _formatBytes(item.size),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: item.isDir ? () => _openFolder(item) : null,
          trailing: AppIconButton(
            tooltip: item.isDir
                ? context.l10n.dynamicPlaylist
                : context.l10n.add,
            onPressed: () => item.isDir
                ? _createFilePlaylist(item.path, item.name)
                : _addFile(item),
            icon: item.isDir
                ? Icons.playlist_add_rounded
                : Icons.add_circle_outline_rounded,
          ),
        );
      },
    );
  }

  Widget _buildVideoList() {
    if (_videos.isEmpty) {
      return const Center(
        child: AppEmptyState(
          icon: Icons.video_library_outlined,
          title: 'No videos',
        ),
      );
    }
    return AppListView.separated(
      itemCount: _videos.length,
      separatorBuilder: (_, _) => const AppDivider(height: 1),
      itemBuilder: (context, index) {
        final item = _videos[index];
        final file = item.files.firstOrNull;
        return ListTile(
          leading: AppImageThumbnail(
            url: item.posterUrl,
            headers: resourceUrlResolver.authenticatedHeaders,
            width: 52,
            height: 72,
            borderRadius: BorderRadius.circular(4),
            errorIcon: item.type == SynologyVideoEntryType.tvShow
                ? Icons.tv_rounded
                : Icons.movie_outlined,
          ),
          title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            _videoDetails(item, file),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: item.type == SynologyVideoEntryType.tvShow
              ? () => _openTvShow(item)
              : null,
          trailing: AppIconButton(
            tooltip: item.type == SynologyVideoEntryType.tvShow
                ? context.l10n.dynamicPlaylist
                : context.l10n.add,
            onPressed: item.type == SynologyVideoEntryType.tvShow
                ? () => _createTvShowPlaylist(item)
                : item.isPlayable
                ? () => _addVideo(item)
                : null,
            icon: item.type == SynologyVideoEntryType.tvShow
                ? Icons.playlist_add_rounded
                : Icons.add_circle_outline_rounded,
          ),
        );
      },
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
    setState(() => _loading = true);
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
      setState(() => _loading = true);
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
    setState(() => _loading = true);
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

  Future<void> _addCurrentPlaylist() {
    if (_mode == _SynologyBrowseMode.files) {
      final name = _path.split('/').where((part) => part.isNotEmpty).lastOrNull;
      return _createFilePlaylist(_path, name ?? 'Synology Shares');
    }
    final tvShow = _tvShow;
    if (tvShow != null) return _createTvShowPlaylist(tvShow);
    final library = _library;
    if (library == null) return Future.value();
    return _createVideoPlaylist(
      _collectionType(_collection),
      '${library.title} · ${_collectionLabel(_collection)}',
      library.id,
    );
  }

  Future<void> _addFile(SynologyFileItemInfo item) => _runAdd(() async {
    final bind = _bind!;
    await providerGateway.addSynologyFileMedia(
      widget.roomId,
      playlistId: widget.playlistId,
      serverId: bind.serverId,
      path: item.path,
      name: item.name,
      providerInstanceName: bind.providerInstanceName,
    );
  });

  Future<void> _addVideo(SynologyVideoItemInfo item) => _runAdd(() async {
    final bind = _bind!;
    final file = item.files.first;
    await providerGateway.addSynologyLibraryMedia(
      widget.roomId,
      playlistId: widget.playlistId,
      serverId: bind.serverId,
      kind: _entryType(item.type),
      itemId: item.id,
      fileId: file.id,
      name: item.title,
      providerInstanceName: bind.providerInstanceName,
    );
  });

  Future<void> _createFilePlaylist(String path, String name) =>
      _runAdd(() async {
        final bind = _bind!;
        await providerGateway.createPlaylist(
          widget.roomId,
          parentId: widget.playlistId,
          sourceProvider: 'synology',
          providerInstanceName: bind.providerInstanceName,
          sourceConfig: {
            'serverId': bind.serverId,
            'type': 'files',
            'path': path,
          },
          name: name,
        );
      });

  Future<void> _createTvShowPlaylist(SynologyVideoItemInfo item) =>
      _createVideoPlaylist(
        'episodes',
        item.title,
        item.libraryId,
        tvShowId: item.id,
      );

  Future<void> _createVideoPlaylist(
    String type,
    String name,
    int libraryId, {
    int? tvShowId,
  }) => _runAdd(() async {
    final bind = _bind!;
    await providerGateway.createPlaylist(
      widget.roomId,
      parentId: widget.playlistId,
      sourceProvider: 'synology',
      providerInstanceName: bind.providerInstanceName,
      sourceConfig: {
        'serverId': bind.serverId,
        'type': type,
        'libraryId': libraryId,
        'tvShowId': ?tvShowId,
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

  String _collectionLabel(SynologyVideoCollection value) => switch (value) {
    SynologyVideoCollection.movies => 'Movies',
    SynologyVideoCollection.tvShows => 'TV Shows',
    SynologyVideoCollection.episodes => 'Episodes',
    SynologyVideoCollection.homeVideos => 'Home Videos',
    SynologyVideoCollection.tvRecordings => 'TV Recordings',
  };

  String _collectionType(SynologyVideoCollection value) => switch (value) {
    SynologyVideoCollection.movies => 'movies',
    SynologyVideoCollection.tvShows => 'tvShows',
    SynologyVideoCollection.episodes => 'episodes',
    SynologyVideoCollection.homeVideos => 'homeVideos',
    SynologyVideoCollection.tvRecordings => 'tvRecordings',
  };

  String _entryType(SynologyVideoEntryType value) => switch (value) {
    SynologyVideoEntryType.movie => 'movie',
    SynologyVideoEntryType.episode => 'episode',
    SynologyVideoEntryType.homeVideo => 'homeVideo',
    SynologyVideoEntryType.tvRecording => 'tvRecording',
    SynologyVideoEntryType.tvShow => 'movie',
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
