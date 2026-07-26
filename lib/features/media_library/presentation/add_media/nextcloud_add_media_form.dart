import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

enum NextcloudBrowseMode { folder, favorites, search }

typedef NextcloudFileLoader =
    Future<NextcloudFileListPage> Function(
      NextcloudBindInfo bind,
      NextcloudBrowseMode mode,
      String path,
      String query,
      int page,
      int pageSize,
    );

class NextcloudAddMediaForm extends StatefulWidget {
  const NextcloudAddMediaForm({
    super.key,
    required this.roomId,
    required this.playlistId,
    required this.binds,
    this.onDraftChanged,
    this.fileLoader,
    this.resourceHeaders,
  });

  final String roomId;
  final String playlistId;
  final List<NextcloudBindInfo> binds;
  final ValueChanged<bool>? onDraftChanged;
  final NextcloudFileLoader? fileLoader;
  final Map<String, String> Function()? resourceHeaders;

  @override
  State<NextcloudAddMediaForm> createState() => _NextcloudAddMediaFormState();
}

class _NextcloudAddMediaFormState extends State<NextcloudAddMediaForm> {
  static const _pageSize = 50;

  final _searchController = TextEditingController();
  NextcloudBindInfo? _bind;
  NextcloudBrowseMode _mode = NextcloudBrowseMode.folder;
  String _path = '';
  int _page = 1;
  bool _hasMore = false;
  bool _loading = false;
  List<NextcloudFileItemInfo> _items = const [];

  @override
  void initState() {
    super.initState();
    _bind = widget.binds.firstOrNull;
    _searchController.addListener(_notifyDraftChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void didUpdateWidget(covariant NextcloudAddMediaForm oldWidget) {
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
          icon: Icons.cloud_off_outlined,
          title: 'Nextcloud',
          subtitle: context.l10n.bindAccountToAccessResources,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildBindSelector(),
        const SizedBox(height: 10),
        SegmentedButton<NextcloudBrowseMode>(
          segments: const [
            ButtonSegment(
              value: NextcloudBrowseMode.folder,
              icon: Icon(Icons.folder_outlined),
              label: Text('Files'),
            ),
            ButtonSegment(
              value: NextcloudBrowseMode.favorites,
              icon: Icon(Icons.star_outline_rounded),
              label: Text('Favorites'),
            ),
            ButtonSegment(
              value: NextcloudBrowseMode.search,
              icon: Icon(Icons.search_rounded),
              label: Text('Search'),
            ),
          ],
          selected: {_mode},
          onSelectionChanged: _loading
              ? null
              : (selection) {
                  setState(() {
                    _mode = selection.single;
                    _page = 1;
                    _items = const [];
                    if (_mode != NextcloudBrowseMode.search) {
                      _searchController.clear();
                    }
                  });
                  if (_mode != NextcloudBrowseMode.search) _load();
                },
        ),
        const SizedBox(height: 10),
        if (_mode == NextcloudBrowseMode.search) ...[
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
            ],
          ),
          const SizedBox(height: 10),
        ],
        _buildLocationBar(),
        const SizedBox(height: 8),
        Expanded(child: _loading ? const AppLoadingIndicator() : _buildList()),
        const SizedBox(height: 8),
        _buildPagination(),
      ],
    );
  }

  Widget _buildBindSelector() {
    return DropdownButtonFormField<String>(
      initialValue: _bind?.serverId,
      decoration: const InputDecoration(
        labelText: 'Nextcloud',
        prefixIcon: Icon(Icons.cloud_outlined),
      ),
      items: widget.binds
          .map(
            (bind) => DropdownMenuItem(
              value: bind.serverId,
              child: Text(
                bind.displayName.isNotEmpty
                    ? '${bind.displayName} · ${bind.endpoint}'
                    : bind.endpoint,
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
          _path = '';
          _page = 1;
          _items = const [];
        });
        if (_mode != NextcloudBrowseMode.search ||
            _searchController.text.trim().length >= 3) {
          _load();
        }
      },
    );
  }

  Widget _buildLocationBar() {
    final title = switch (_mode) {
      NextcloudBrowseMode.folder => _path.isEmpty ? 'Files' : _path,
      NextcloudBrowseMode.favorites => 'Favorites',
      NextcloudBrowseMode.search => _path.isEmpty ? 'All files' : _path,
    };
    return Row(
      children: [
        if (_mode != NextcloudBrowseMode.favorites)
          AppIconButton(
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: _path.isNotEmpty && !_loading ? _goUp : null,
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
          tooltip: context.l10n.dynamicPlaylist,
          onPressed: _canAddPlaylist && !_loading ? _addCurrentPlaylist : null,
          icon: Icons.playlist_add_rounded,
          style: AppIconButtonStyle.tonal,
        ),
        AppIconButton(
          tooltip: context.l10n.refresh,
          onPressed: _canLoad && !_loading ? _load : null,
          icon: Icons.refresh_rounded,
        ),
      ],
    );
  }

  Widget _buildList() {
    if (_items.isEmpty) {
      return Center(
        child: AppEmptyState(
          icon: _mode == NextcloudBrowseMode.favorites
              ? Icons.star_outline_rounded
              : Icons.video_file_outlined,
          title: 'No items',
        ),
      );
    }
    return AppListView.separated(
      itemCount: _items.length,
      separatorBuilder: (_, _) => const AppDivider(height: 1),
      itemBuilder: (context, index) {
        final item = _items[index];
        return ListTile(
          leading: _preview(item),
          title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            _itemDetails(item),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: item.isDir ? () => _openFolder(item) : null,
          trailing: AppIconButton(
            tooltip: item.isDir
                ? context.l10n.dynamicPlaylist
                : context.l10n.add,
            onPressed: () =>
                item.isDir ? _addFolderPlaylist(item) : _addMedia(item),
            icon: item.isDir
                ? Icons.playlist_add_rounded
                : Icons.add_circle_outline_rounded,
          ),
        );
      },
    );
  }

  Widget _preview(NextcloudFileItemInfo item) {
    if (item.isDir || item.previewUrl.isEmpty) {
      return Icon(
        item.isDir ? Icons.folder_rounded : Icons.movie_outlined,
        color: item.favorite ? Colors.amber.shade700 : null,
      );
    }
    return AppImageThumbnail(
      url: item.previewUrl,
      headers:
          widget.resourceHeaders?.call() ??
          resourceUrlResolver.authenticatedHeaders,
      width: 72,
      height: 44,
      borderRadius: BorderRadius.circular(4),
      errorIcon: Icons.movie_outlined,
    );
  }

  String _itemDetails(NextcloudFileItemInfo item) {
    if (item.isDir) return item.favorite ? 'Folder · Favorite' : 'Folder';
    final details = <String>[];
    if (item.durationMillis case final duration?) {
      details.add(_formatDuration(duration));
    }
    details.add(_formatBytes(item.size));
    if (item.width case final width?) {
      final height = item.height;
      if (height != null) details.add('$width×$height');
    }
    if (item.favorite) details.add('Favorite');
    return details.join(' · ');
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

  bool get _canLoad =>
      _mode != NextcloudBrowseMode.search ||
      _searchController.text.trim().length >= 3;

  bool get _canAddPlaylist =>
      _mode != NextcloudBrowseMode.search ||
      _searchController.text.trim().length >= 3;

  void _search() {
    if (_searchController.text.trim().length < 3) {
      AppNotifications.showError(context, 'Enter at least 3 characters');
      return;
    }
    setState(() => _page = 1);
    _load();
  }

  void _openFolder(NextcloudFileItemInfo item) {
    setState(() {
      _path = item.path;
      _page = 1;
      if (_mode == NextcloudBrowseMode.favorites) {
        _mode = NextcloudBrowseMode.folder;
      }
    });
    _load();
  }

  void _goUp() {
    final parts = _path.split('/').where((part) => part.isNotEmpty).toList();
    setState(() {
      _path = parts.length <= 1
          ? ''
          : '/${parts.take(parts.length - 1).join('/')}';
      _page = 1;
    });
    _load();
  }

  Future<void> _load() async {
    final bind = _bind;
    if (bind == null || _loading || !_canLoad) return;
    setState(() => _loading = true);
    try {
      final loader = widget.fileLoader ?? _defaultLoader;
      final result = await loader(
        bind,
        _mode,
        _path,
        _searchController.text.trim(),
        _page,
        _pageSize,
      );
      if (!mounted) return;
      setState(() {
        _items = result.items;
        _page = result.page;
        _hasMore = result.hasMore;
      });
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<NextcloudFileListPage> _defaultLoader(
    NextcloudBindInfo bind,
    NextcloudBrowseMode mode,
    String path,
    String query,
    int page,
    int pageSize,
  ) {
    return switch (mode) {
      NextcloudBrowseMode.folder => providerGateway.listNextcloudFiles(
        bind.serverId,
        path,
        page: page,
        pageSize: pageSize,
        instanceName: bind.providerInstanceName,
      ),
      NextcloudBrowseMode.favorites => providerGateway.listNextcloudFavorites(
        bind.serverId,
        page: page,
        pageSize: pageSize,
        instanceName: bind.providerInstanceName,
      ),
      NextcloudBrowseMode.search => providerGateway.listNextcloudFiles(
        bind.serverId,
        path,
        page: page,
        pageSize: pageSize,
        search: query,
        instanceName: bind.providerInstanceName,
      ),
    };
  }

  Future<void> _addMedia(NextcloudFileItemInfo item) => _runAdd(() async {
    final bind = _bind!;
    await providerGateway.addNextcloudMedia(
      widget.roomId,
      playlistId: widget.playlistId,
      serverId: bind.serverId,
      path: item.path,
      fileId: item.fileId,
      name: item.name,
      providerInstanceName: bind.providerInstanceName,
    );
  });

  Future<void> _addFolderPlaylist(NextcloudFileItemInfo item) =>
      _createPlaylist(
        name: item.name,
        source: {'type': 'folder', 'path': item.path},
      );

  Future<void> _addCurrentPlaylist() {
    final name = _path.split('/').where((part) => part.isNotEmpty).lastOrNull;
    return switch (_mode) {
      NextcloudBrowseMode.folder => _createPlaylist(
        name: name ?? 'Nextcloud Files',
        source: {'type': 'folder', 'path': _path},
      ),
      NextcloudBrowseMode.favorites => _createPlaylist(
        name: 'Nextcloud Favorites',
        source: {'type': 'favorites'},
      ),
      NextcloudBrowseMode.search => _createPlaylist(
        name: 'Nextcloud: ${_searchController.text.trim()}',
        source: {
          'type': 'search',
          'path': _path,
          'query': _searchController.text.trim(),
        },
      ),
    };
  }

  Future<void> _createPlaylist({
    required String name,
    required Map<String, dynamic> source,
  }) => _runAdd(() async {
    final bind = _bind!;
    await providerGateway.createPlaylist(
      widget.roomId,
      parentId: widget.playlistId,
      sourceProvider: 'nextcloud',
      providerInstanceName: bind.providerInstanceName,
      sourceConfig: {'serverId': bind.serverId, 'source': source},
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

  String _formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return hours > 0
        ? '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}'
        : '$minutes:${seconds.toString().padLeft(2, '0')}';
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
