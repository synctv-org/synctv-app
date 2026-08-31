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

typedef QnapFileLoader = Future<QnapFileListPage> Function(
  QnapBindInfo bind,
  String path,
  int page,
  int pageSize,
  String search,
);

class QnapAddMediaForm extends StatefulWidget {
  const QnapAddMediaForm({
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
  final List<QnapBindInfo> binds;
  final ValueChanged<bool>? onDraftChanged;
  final Future<void> Function()? onOpenBinding;
  final QnapFileLoader? fileLoader;
  final Map<String, String> Function()? resourceHeaders;

  @override
  State<QnapAddMediaForm> createState() => _QnapAddMediaFormState();
}

class _QnapAddMediaFormState extends State<QnapAddMediaForm> {
  static const _pageSize = 50;

  final _selection = DiscoverySelectionController();
  final _searchController = TextEditingController();
  QnapBindInfo? _bind;
  String _path = '';
  int _page = 1;
  bool _hasMore = false;
  bool _loading = false;
  List<QnapFileItemInfo> _items = const [];
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
  void didUpdateWidget(covariant QnapAddMediaForm oldWidget) {
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
              title: 'QNAP',
              subtitle: context.l10n.bindAccountToAccessResources,
            ),
            const SizedBox(height: 16),
            ProviderAccountAction(
              providerType: 'qnap',
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
      children: [
        Expanded(child: _loading ? const AppLoadingIndicator() : _buildList()),
        const SizedBox(height: 8),
        _buildPagination(),
      ],
    );
    return ProviderWorkspace(controls: controls, results: results);
  }

  Widget _buildBindSelector() {
    return ProviderAccountSelector<QnapBindInfo>(
      accounts: widget.binds,
      selectedId: _bind?.id,
      idOf: (bind) => bind.id,
      labelOf: (bind) {
        final title = bind.serverName.isEmpty ? bind.endpoint : bind.serverName;
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
          _listSource = null;
        });
        _load();
      },
    );
  }

  Widget _buildLocationBar() {
    return Row(
      children: [
        AppIconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: _path.isNotEmpty && !_loading ? _goUp : null,
          icon: Icons.arrow_upward_rounded,
        ),
        Expanded(
          child: Text(
            _path.isEmpty ? context.l10n.shares : _path,
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

  Widget _buildList() {
    final itemsByKey = {for (final item in _items) item.path: item};
    return DiscoveryBrowser(
      selectionController: _selection,
      selectionScope: '${_bind?.id}:$_path:${_searchController.text}',
      onSelectionChanged: () => setState(() {}),
      items: [
        for (final item in _items)
          DiscoveryBrowserEntry(
            key: item.path,
            title: item.name,
            subtitle: _itemDetails(item),
            source: item.source.withPlaybackProxyMode(_proxyMode),
            isContainer: item.isDir,
            leading: _thumbnail(item),
          ),
      ],
      loading: _loading,
      emptyIcon: Icons.video_file_outlined,
      onOpen: (entry) => _openFolder(itemsByKey[entry.key]!),
      onAddSelected: _addSelected,
      onAddCurrentList: _listSource == null ? null : _addCurrentPlaylist,
    );
  }

  Widget _thumbnail(QnapFileItemInfo item) {
    if (item.isDir || item.thumbnailUrl.isEmpty) {
      return Icon(item.isDir ? Icons.folder_rounded : Icons.movie_outlined);
    }
    return AppImageThumbnail(
      url: item.thumbnailUrl,
      headers:
          widget.resourceHeaders?.call() ??
          resourceUrlResolver.authenticatedHeaders,
      width: 72,
      height: 44,
      borderRadius: BorderRadius.circular(4),
      errorIcon: Icons.movie_outlined,
    );
  }

  String _itemDetails(QnapFileItemInfo item) {
    if (item.isDir) return context.l10n.folder;
    final details = <String>[_formatBytes(item.size)];
    if (item.preTranscodedHeights.isNotEmpty) {
      final heights = [...item.preTranscodedHeights]..sort();
      details.add(
        context.l10n.readyQualities(
          heights.map((height) => '${height}p').join(' / '),
        ),
      );
    }
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

  void _search() {
    setState(() => _page = 1);
    _load();
  }

  void _openFolder(QnapFileItemInfo item) {
    setState(() {
      _path = item.path;
      _page = 1;
      _searchController.clear();
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
      _searchController.clear();
    });
    _load();
  }

  Future<void> _load() async {
    final bind = _bind;
    if (bind == null || _loading) return;
    setState(() {
      _loading = true;
      _selection.clear();
      _listSource = null;
    });
    try {
      final loader = widget.fileLoader ?? _defaultLoader;
      final result = await loader(
        bind,
        _path,
        _page,
        _pageSize,
        _searchController.text.trim(),
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

  Future<QnapFileListPage> _defaultLoader(
    QnapBindInfo bind,
    String path,
    int page,
    int pageSize,
    String search,
  ) => providerGateway.listQnapFiles(
    bind.serverId,
    path,
    page: page,
    pageSize: pageSize,
    search: search,
    instanceName: bind.providerInstanceName,
  );

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
    final name = _path.split('/').where((part) => part.isNotEmpty).lastOrNull;
    await providerGateway.addDiscoveredSource(
      widget.roomId,
      playlistId: widget.playlistId,
      source: source.withPlaybackProxyMode(_proxyMode),
      name: name ?? 'QNAP Shares',
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

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
