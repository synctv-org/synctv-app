import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

typedef QnapFileLoader =
    Future<QnapFileListPage> Function(
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
    this.fileLoader,
    this.resourceHeaders,
  });

  final String roomId;
  final String playlistId;
  final List<QnapBindInfo> binds;
  final ValueChanged<bool>? onDraftChanged;
  final QnapFileLoader? fileLoader;
  final Map<String, String> Function()? resourceHeaders;

  @override
  State<QnapAddMediaForm> createState() => _QnapAddMediaFormState();
}

class _QnapAddMediaFormState extends State<QnapAddMediaForm> {
  static const _pageSize = 50;

  final _searchController = TextEditingController();
  QnapBindInfo? _bind;
  String _path = '';
  int _page = 1;
  bool _hasMore = false;
  bool _loading = false;
  List<QnapFileItemInfo> _items = const [];

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
          title: 'QNAP',
          subtitle: context.l10n.bindAccountToAccessResources,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildBindSelector(),
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
        labelText: 'QNAP',
        prefixIcon: Icon(Icons.dns_outlined),
      ),
      items: widget.binds
          .map(
            (bind) => DropdownMenuItem(
              value: bind.serverId,
              child: Text(
                bind.serverName.isEmpty ? bind.endpoint : bind.serverName,
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
            _path.isEmpty ? 'Shares' : _path,
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

  Widget _buildList() {
    if (_items.isEmpty) {
      return Center(
        child: AppEmptyState(
          icon: Icons.video_file_outlined,
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
          leading: _thumbnail(item),
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
            onPressed: () => item.isDir ? _addPlaylist(item) : _addMedia(item),
            icon: item.isDir
                ? Icons.playlist_add_rounded
                : Icons.add_circle_outline_rounded,
          ),
        );
      },
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
    if (item.isDir) return 'Folder';
    final details = <String>[_formatBytes(item.size)];
    if (item.preTranscodedHeights.isNotEmpty) {
      final heights = [...item.preTranscodedHeights]..sort();
      details.add('Ready ${heights.map((height) => '${height}p').join(' / ')}');
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
    setState(() => _loading = true);
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

  Future<void> _addMedia(QnapFileItemInfo item) => _runAdd(() async {
    final bind = _bind!;
    await providerGateway.addQnapMedia(
      widget.roomId,
      playlistId: widget.playlistId,
      serverId: bind.serverId,
      path: item.path,
      name: item.name,
      providerInstanceName: bind.providerInstanceName,
    );
  });

  Future<void> _addPlaylist(QnapFileItemInfo item) =>
      _createPlaylist(item.path, item.name);

  Future<void> _addCurrentPlaylist() {
    final name = _path.split('/').where((part) => part.isNotEmpty).lastOrNull;
    return _createPlaylist(_path, name ?? 'QNAP Shares');
  }

  Future<void> _createPlaylist(String path, String name) => _runAdd(() async {
    final bind = _bind!;
    await providerGateway.createPlaylist(
      widget.roomId,
      parentId: widget.playlistId,
      sourceProvider: 'qnap',
      providerInstanceName: bind.providerInstanceName,
      sourceConfig: {'serverId': bind.serverId, 'path': path},
      name: name.isEmpty ? 'QNAP' : name,
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
