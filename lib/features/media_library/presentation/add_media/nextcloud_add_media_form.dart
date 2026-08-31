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

enum NextcloudBrowseMode { folder, favorites, search }

typedef NextcloudFileLoader = Future<NextcloudFileListPage> Function(
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
    this.onOpenBinding,
    this.fileLoader,
    this.resourceHeaders,
  });

  final String roomId;
  final String playlistId;
  final List<NextcloudBindInfo> binds;
  final ValueChanged<bool>? onDraftChanged;
  final Future<void> Function()? onOpenBinding;
  final NextcloudFileLoader? fileLoader;
  final Map<String, String> Function()? resourceHeaders;

  @override
  State<NextcloudAddMediaForm> createState() => _NextcloudAddMediaFormState();
}

class _NextcloudAddMediaFormState extends State<NextcloudAddMediaForm> {
  static const _pageSize = 50;

  final _selection = DiscoverySelectionController();
  final _searchController = TextEditingController();
  NextcloudBindInfo? _bind;
  NextcloudBrowseMode _mode = NextcloudBrowseMode.folder;
  String _path = '';
  int _page = 1;
  bool _hasMore = false;
  bool _loading = false;
  List<NextcloudFileItemInfo> _items = const [];
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
  void didUpdateWidget(covariant NextcloudAddMediaForm oldWidget) {
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
              icon: Icons.cloud_off_outlined,
              title: 'Nextcloud',
              subtitle: context.l10n.bindAccountToAccessResources,
            ),
            const SizedBox(height: 16),
            ProviderAccountAction(
              providerType: 'nextcloud',
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
        _buildBindSelector(),
        const SizedBox(height: 10),
        PlaybackProxyModeControl(
          value: _proxyMode,
          source: _playbackPolicySource,
          onChanged: (value) => setState(() => _proxyMode = value),
        ),
        const SizedBox(height: 10),
        SegmentedButton<NextcloudBrowseMode>(
          segments: [
            ButtonSegment(
              value: NextcloudBrowseMode.folder,
              icon: const Icon(Icons.folder_outlined),
              label: Text(context.l10n.files),
            ),
            ButtonSegment(
              value: NextcloudBrowseMode.favorites,
              icon: const Icon(Icons.star_outline_rounded),
              label: Text(context.l10n.favorites),
            ),
            ButtonSegment(
              value: NextcloudBrowseMode.search,
              icon: const Icon(Icons.search_rounded),
              label: Text(context.l10n.search),
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
                    _listSource = null;
                    _selection.clear();
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
        ],
        _buildLocationBar(),
      ],
    );
    final results = Column(
      children: [
        Expanded(child: _loading ? const AppLoadingIndicator() : _buildList()),
        const SizedBox(height: 8),
        _buildPagination(),
      ],
    );
    return ProviderWorkspace(controls: controls, results: results);
  }

  Widget _buildBindSelector() {
    return ProviderAccountSelector<NextcloudBindInfo>(
      accounts: widget.binds,
      selectedId: _bind?.id,
      idOf: (bind) => bind.id,
      labelOf: (bind) {
        final title = bind.displayName.isNotEmpty
            ? '${bind.displayName} · ${bind.endpoint}'
            : bind.endpoint;
        return bind.providerInstanceName.isEmpty
            ? title
            : '$title · ${bind.providerInstanceName}';
      },
      enabled: !_loading,
      onChanged: (bind) {
        if (bind == null) return;
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
      NextcloudBrowseMode.folder => _path.isEmpty ? context.l10n.files : _path,
      NextcloudBrowseMode.favorites => context.l10n.favorites,
      NextcloudBrowseMode.search =>
        _path.isEmpty ? context.l10n.allFiles : _path,
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
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
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
    final itemsByKey = {for (final item in _items) item.path: item};
    return DiscoveryBrowser(
      selectionController: _selection,
      selectionScope:
          '${_bind?.id}:${_mode.name}:$_path:${_searchController.text}',
      onSelectionChanged: () => setState(() {}),
      items: [
        for (final item in _items)
          DiscoveryBrowserEntry(
            key: item.path,
            title: item.name,
            subtitle: _itemDetails(item),
            source: item.source.withPlaybackProxyMode(_proxyMode),
            isContainer: item.isDir,
            leading: _preview(item),
          ),
      ],
      loading: _loading,
      emptyIcon: _mode == NextcloudBrowseMode.favorites
          ? Icons.star_outline_rounded
          : Icons.video_file_outlined,
      onOpen: (entry) => _openFolder(itemsByKey[entry.key]!),
      onAddSelected: _addSelected,
      onAddCurrentList: _canAddPlaylist && _listSource != null
          ? _addCurrentPlaylist
          : null,
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
    if (item.isDir) {
      return item.favorite
          ? '${context.l10n.folder} · ${context.l10n.favorite}'
          : context.l10n.folder;
    }
    final details = <String>[];
    if (item.durationMillis case final duration?) {
      details.add(_formatDuration(duration));
    }
    details.add(_formatBytes(item.size));
    if (item.width case final width?) {
      final height = item.height;
      if (height != null) details.add('$width×$height');
    }
    if (item.favorite) details.add(context.l10n.favorite);
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
      AppNotifications.showError(
        context,
        context.l10n.enterAtLeastThreeCharacters,
      );
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
    setState(() {
      _loading = true;
      _listSource = null;
      _selection.clear();
    });
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
        _listSource = result.source;
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

  Future<void> _addSelected(List<DiscoveryBrowserEntry> items) =>
      _runAdd(() async {
        for (final item in items) {
          await providerGateway.addDiscoveredSource(
            widget.roomId,
            playlistId: widget.playlistId,
            source: item.source.withPlaybackProxyMode(_proxyMode),
            name: item.title,
          );
        }
      });

  Future<void> _addCurrentPlaylist() => _runAdd(() async {
    final source = _listSource;
    if (source == null) return;
    final pathName = _path
        .split('/')
        .where((part) => part.isNotEmpty)
        .lastOrNull;
    final name = switch (_mode) {
      NextcloudBrowseMode.folder => pathName ?? 'Nextcloud Files',
      NextcloudBrowseMode.favorites => 'Nextcloud Favorites',
      NextcloudBrowseMode.search =>
        'Nextcloud: ${_searchController.text.trim()}',
    };
    await providerGateway.addDiscoveredSource(
      widget.roomId,
      playlistId: widget.playlistId,
      source: source.withPlaybackProxyMode(_proxyMode),
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
