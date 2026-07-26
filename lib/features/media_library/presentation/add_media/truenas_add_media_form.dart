import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

typedef TrueNasPageLoader =
    Future<TrueNasFileListPage> Function(
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
    this.pageLoader,
  });

  final String roomId;
  final String playlistId;
  final List<TrueNasBindInfo> binds;
  final ValueChanged<bool>? onDraftChanged;
  final TrueNasPageLoader? pageLoader;

  @override
  State<TrueNasAddMediaForm> createState() => _TrueNasAddMediaFormState();
}

class _TrueNasAddMediaFormState extends State<TrueNasAddMediaForm> {
  static const _pageSize = 50;
  final _searchController = TextEditingController();
  TrueNasBindInfo? _bind;
  String _path = '/mnt';
  int _page = 1;
  bool _hasMore = false;
  bool _loading = false;
  List<TrueNasFileItemInfo> _items = const [];

  @override
  void initState() {
    super.initState();
    _bind = widget.binds.firstOrNull;
    _searchController.addListener(_draftChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
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
        child: AppEmptyState(
          icon: Icons.storage_outlined,
          title: 'TrueNAS',
          subtitle: context.l10n.bindAccountToAccessResources,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<TrueNasBindInfo>(
          initialValue: _bind,
          decoration: const InputDecoration(
            labelText: 'TrueNAS',
            prefixIcon: Icon(Icons.dns_outlined),
          ),
          items: widget.binds
              .map(
                (bind) => DropdownMenuItem(
                  value: bind,
                  child: Text(
                    bind.providerInstanceName.isEmpty
                        ? bind.hostname
                        : '${bind.hostname} · ${bind.providerInstanceName}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: _loading
              ? null
              : (value) {
                  setState(() {
                    _bind = value;
                    _path = '/mnt';
                    _page = 1;
                  });
                  _load();
                },
        ),
        const SizedBox(height: 10),
        AppTextField(
          controller: _searchController,
          label: '搜索',
          prefixIcon: Icons.search_rounded,
          suffix: AppIconButton(
            tooltip: '搜索',
            icon: Icons.arrow_forward_rounded,
            onPressed: _loading ? null : () => _load(page: 1),
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _load(page: 1),
        ),
        const SizedBox(height: 10),
        _breadcrumbs(),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: _loading ? null : _addCurrentPlaylist,
                icon: const Icon(Icons.playlist_add_rounded),
                label: Text(
                  _searchController.text.trim().isEmpty
                      ? '添加当前目录动态列表'
                      : '添加搜索动态列表',
                ),
              ),
            ),
            const SizedBox(width: 8),
            AppIconButton(
              tooltip: context.l10n.refresh,
              onPressed: _loading ? null : () => _load(),
              icon: Icons.refresh_rounded,
              style: AppIconButtonStyle.tonal,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_loading) const AppLinearProgress(minHeight: 2),
        Expanded(child: _fileList()),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AppIconButton(
              tooltip: '上一页',
              onPressed: _loading || _page <= 1
                  ? null
                  : () => _load(page: _page - 1),
              icon: Icons.chevron_left_rounded,
            ),
            Text('$_page'),
            AppIconButton(
              tooltip: '下一页',
              onPressed: _loading || !_hasMore
                  ? null
                  : () => _load(page: _page + 1),
              icon: Icons.chevron_right_rounded,
            ),
          ],
        ),
      ],
    );
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
    if (!_loading && _items.isEmpty) {
      return const AppEmptyState(
        icon: Icons.folder_open_outlined,
        title: '当前目录为空',
        subtitle: '/mnt 下的可播放文件与目录会显示在这里',
      );
    }
    return AppListView.separated(
      itemCount: _items.length,
      separatorBuilder: (_, _) => const AppDivider(height: 1),
      itemBuilder: (context, index) {
        final item = _items[index];
        return ListTile(
          leading: Icon(
            item.isDir ? Icons.folder_rounded : Icons.movie_outlined,
          ),
          title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            _itemDetails(item),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: AppIconButton(
            tooltip: item.isDir ? '添加目录动态列表' : context.l10n.add,
            icon: item.isDir ? Icons.playlist_add_rounded : Icons.add_rounded,
            onPressed: _loading
                ? null
                : () => item.isDir
                      ? _createPlaylist(item.name, {
                          'type': 'folder',
                          'path': item.path,
                        })
                      : _addMedia(item),
          ),
          onTap: item.isDir && !_loading
              ? () {
                  setState(() {
                    _path = item.path;
                    _searchController.clear();
                  });
                  _load(page: 1);
                }
              : null,
        );
      },
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
    setState(() => _loading = true);
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

  Future<void> _addMedia(TrueNasFileItemInfo item) => _runAdd(() async {
    final bind = _bind!;
    await providerGateway.addTrueNasMedia(
      widget.roomId,
      playlistId: widget.playlistId,
      serverId: bind.serverId,
      path: item.path,
      name: item.name,
      providerInstanceName: bind.providerInstanceName,
    );
  });

  Future<void> _addCurrentPlaylist() {
    final query = _searchController.text.trim();
    return _createPlaylist(
      query.isEmpty ? _path.split('/').last : 'TrueNAS: $query',
      query.isEmpty
          ? {'type': 'folder', 'path': _path}
          : {'type': 'search', 'path': _path, 'query': query},
    );
  }

  Future<void> _createPlaylist(String name, Map<String, dynamic> source) =>
      _runAdd(() async {
        final bind = _bind!;
        await providerGateway.createPlaylist(
          widget.roomId,
          parentId: widget.playlistId,
          sourceProvider: 'truenas',
          providerInstanceName: bind.providerInstanceName,
          sourceConfig: {'serverId': bind.serverId, 'source': source},
          name: name.isEmpty ? 'TrueNAS' : name,
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
