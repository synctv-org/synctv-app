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

typedef TrueNasPageLoader = Future<TrueNasFileListPage> Function(
  TrueNasBindInfo bind,
  String path,
  String search,
  int page,
  int pageSize,
);

class TrueNasAddMediaForm extends StatefulWidget {
  const TrueNasAddMediaForm({
    super.key,
    required this.roomId,
    required this.playlistId,
    required this.binds,
    this.onDraftChanged,
    this.onOpenBinding,
    this.pageLoader,
  });

  final String roomId;
  final String playlistId;
  final List<TrueNasBindInfo> binds;
  final ValueChanged<bool>? onDraftChanged;
  final Future<void> Function()? onOpenBinding;
  final TrueNasPageLoader? pageLoader;

  @override
  State<TrueNasAddMediaForm> createState() => _TrueNasAddMediaFormState();
}

class _TrueNasAddMediaFormState extends State<TrueNasAddMediaForm> {
  static const _pageSize = 50;
  final _selection = DiscoverySelectionController();
  final _searchController = TextEditingController();
  TrueNasBindInfo? _bind;
  String _path = '/mnt';
  int _page = 1;
  bool _hasMore = false;
  bool _loading = false;
  List<TrueNasFileItemInfo> _items = const [];
  provider_common.DiscoveredSource? _listSource;
  source_enum.PlaybackProxyMode _proxyMode =
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;

  provider_common.DiscoveredSource? get _playbackPolicySource =>
      _selection.entries.firstOrNull?.source ?? _listSource;

  @override
  void initState() {
    super.initState();
    _bind = widget.binds.firstOrNull;
    _searchController.addListener(_draftChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void didUpdateWidget(covariant TrueNasAddMediaForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((_bind == null || !widget.binds.any((bind) => bind.id == _bind!.id)) &&
        widget.binds.isNotEmpty) {
      _bind = widget.binds.first;
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_draftChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _draftChanged() =>
      widget.onDraftChanged?.call(_searchController.text.trim().isNotEmpty);

  @override
  Widget build(BuildContext context) {
    if (widget.binds.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppEmptyState(
              icon: Icons.storage_outlined,
              title: 'TrueNAS',
              subtitle: context.l10n.bindAccountToAccessResources,
            ),
            const SizedBox(height: 16),
            ProviderAccountAction(
              providerType: 'truenas',
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
        ProviderAccountSelector<TrueNasBindInfo>(
          accounts: widget.binds,
          selectedId: _bind?.id,
          idOf: (bind) => bind.id,
          labelOf: (bind) => bind.providerInstanceName.isEmpty
              ? bind.hostname
              : '${bind.hostname} · ${bind.providerInstanceName}',
          enabled: !_loading,
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _bind = value;
              _path = '/mnt';
              _page = 1;
            });
            _load();
          },
        ),
        const SizedBox(height: 10),
        PlaybackProxyModeControl(
          value: _proxyMode,
          source: _playbackPolicySource,
          onChanged: (value) => setState(() => _proxyMode = value),
        ),
        const SizedBox(height: 10),
        AppTextField(
          controller: _searchController,
          label: context.l10n.search,
          prefixIcon: Icons.search_rounded,
          suffix: AppIconButton(
            tooltip: context.l10n.search,
            icon: Icons.arrow_forward_rounded,
            onPressed: _loading ? null : () => _load(page: 1),
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _load(page: 1),
        ),
        const SizedBox(height: 10),
        _breadcrumbs(),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: AppIconButton(
            tooltip: context.l10n.refresh,
            onPressed: _loading ? null : () => _load(),
            icon: Icons.refresh_rounded,
            style: AppIconButtonStyle.tonal,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
    final results = Column(
      children: [
        if (_loading) const AppLinearProgress(minHeight: 2),
        Expanded(child: _fileList()),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppIconButton(
              tooltip: MaterialLocalizations.of(context).previousPageTooltip,
              onPressed: _loading || _page <= 1
                  ? null
                  : () => _load(page: _page - 1),
              icon: Icons.chevron_left_rounded,
            ),
            Text('$_page'),
            AppIconButton(
              tooltip: MaterialLocalizations.of(context).nextPageTooltip,
              onPressed: _loading || !_hasMore
                  ? null
                  : () => _load(page: _page + 1),
              icon: Icons.chevron_right_rounded,
            ),
          ],
        ),
      ],
    );
    return ProviderWorkspace(controls: controls, results: results);
  }

  Widget _breadcrumbs() {
    final parts = _path.split('/').where((part) => part.isNotEmpty).toList();
    return AppSingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < parts.length; index++) ...[
            if (index > 0) const Icon(Icons.chevron_right_rounded, size: 18),
            AppActionButton(
              onPressed: _loading
                  ? null
                  : () {
                      setState(() {
                        _path = '/${parts.take(index + 1).join('/')}';
                        _searchController.clear();
                      });
                      _load(page: 1);
                    },
              label: parts[index],
              style: AppActionButtonStyle.text,
            ),
          ],
        ],
      ),
    );
  }

  Widget _fileList() {
    final itemsByKey = {for (final item in _items) item.path: item};
    return DiscoveryBrowser(
      selectionController: _selection,
      selectionScope: '${_bind?.id}:$_path',
      onSelectionChanged: () => setState(() {}),
      items: [
        for (final item in _items)
          DiscoveryBrowserEntry(
            key: item.path,
            title: item.name,
            subtitle: _itemDetails(item),
            source: item.source.withPlaybackProxyMode(_proxyMode),
            isContainer: item.isDir,
          ),
      ],
      loading: _loading,
      emptyIcon: Icons.folder_open_outlined,
      emptyTitle: context.l10n.noFiles,
      onOpen: (entry) {
        final item = itemsByKey[entry.key]!;
        setState(() {
          _path = item.path;
          _searchController.clear();
        });
        _load(page: 1);
      },
      onAddSelected: _addSelected,
      onAddCurrentList: _listSource == null ? null : _addCurrentPlaylist,
    );
  }

  String _itemDetails(TrueNasFileItemInfo item) {
    final flags = <String>[
      if (item.acl) 'ACL',
      if (item.isMountpoint) 'mount',
      ...item.attributes.take(2),
      ...item.zfsAttributes.take(2),
    ];
    if (item.isDir) {
      return [item.path, ...flags].join(' · ');
    }
    return [
      _formatBytes(item.size),
      '${item.uid}:${item.gid}',
      ...flags,
    ].join(' · ');
  }

  Future<void> _load({int? page}) async {
    final bind = _bind;
    if (bind == null || _loading) return;
    setState(() {
      _loading = true;
      _selection.clear();
      _listSource = null;
    });
    try {
      final result = await (widget.pageLoader ?? _defaultLoader)(
        bind,
        _path,
        _searchController.text.trim(),
        page ?? _page,
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
      if (mounted) {
        AppNotifications.showError(context, '$error');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<TrueNasFileListPage> _defaultLoader(
    TrueNasBindInfo bind,
    String path,
    String search,
    int page,
    int pageSize,
  ) => providerGateway.listTrueNasFiles(
    bind.serverId,
    path,
    search: search,
    page: page,
    pageSize: pageSize,
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
    final query = _searchController.text.trim();
    await providerGateway.addDiscoveredSource(
      widget.roomId,
      playlistId: widget.playlistId,
      source: source.withPlaybackProxyMode(_proxyMode),
      name: query.isEmpty ? _path.split('/').last : 'TrueNAS: $query',
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
      if (mounted) {
        setState(() => _loading = false);
      }
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
