import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

enum SeafileBrowseMode { folder, starred, search }

typedef SeafilePageLoader =
    Future<SeafileFileListPage> Function(
      SeafileBindInfo bind,
      SeafileBrowseMode mode,
      String repositoryId,
      String path,
      String query,
      int page,
      int pageSize,
    );

typedef SeafileLibraryUnlocker =
    Future<void> Function(
      SeafileBindInfo bind,
      String repositoryId,
      String password,
    );

class SeafileAddMediaForm extends StatefulWidget {
  const SeafileAddMediaForm({
    super.key,
    required this.roomId,
    required this.playlistId,
    required this.binds,
    this.onDraftChanged,
    this.pageLoader,
    this.libraryUnlocker,
    this.resourceHeaders,
  });

  final String roomId;
  final String playlistId;
  final List<SeafileBindInfo> binds;
  final ValueChanged<bool>? onDraftChanged;
  final SeafilePageLoader? pageLoader;
  final SeafileLibraryUnlocker? libraryUnlocker;
  final Map<String, String> Function()? resourceHeaders;

  @override
  State<SeafileAddMediaForm> createState() => _SeafileAddMediaFormState();
}

class _SeafileAddMediaFormState extends State<SeafileAddMediaForm> {
  static const _pageSize = 50;
  final _searchController = TextEditingController();
  SeafileBindInfo? _bind;
  SeafileBrowseMode _mode = SeafileBrowseMode.folder;
  String _repositoryId = '';
  String _repositoryName = '';
  String _path = '';
  int _page = 1;
  bool _hasMore = false;
  bool _loading = false;
  List<SeafileFileItemInfo> _items = const [];

  @override
  void initState() {
    super.initState();
    _bind = widget.binds.firstOrNull;
    _searchController.addListener(_notifyDraft);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _searchController.removeListener(_notifyDraft);
    _searchController.dispose();
    super.dispose();
  }

  void _notifyDraft() =>
      widget.onDraftChanged?.call(_searchController.text.trim().isNotEmpty);

  @override
  Widget build(BuildContext context) {
    if (widget.binds.isEmpty) {
      return Center(
        child: AppEmptyState(
          icon: Icons.cloud_off_outlined,
          title: 'Seafile',
          subtitle: context.l10n.bindAccountToAccessResources,
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _bindSelector(),
        const SizedBox(height: 10),
        SegmentedButton<SeafileBrowseMode>(
          segments: const [
            ButtonSegment(
              value: SeafileBrowseMode.folder,
              icon: Icon(Icons.folder_outlined),
              label: Text('Files'),
            ),
            ButtonSegment(
              value: SeafileBrowseMode.starred,
              icon: Icon(Icons.star_outline_rounded),
              label: Text('Starred'),
            ),
            ButtonSegment(
              value: SeafileBrowseMode.search,
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
                    if (_mode != SeafileBrowseMode.search) {
                      _searchController.clear();
                    }
                  });
                  if (_mode != SeafileBrowseMode.search) _load();
                },
        ),
        const SizedBox(height: 10),
        if (_mode == SeafileBrowseMode.search) ...[
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: _searchController,
                  label: 'Search current library',
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
        _locationBar(),
        const SizedBox(height: 8),
        Expanded(child: _loading ? const AppLoadingIndicator() : _list()),
        _pagination(),
      ],
    );
  }

  Widget _bindSelector() => DropdownButtonFormField<String>(
    initialValue: _bind?.serverId,
    decoration: const InputDecoration(
      labelText: 'Seafile',
      prefixIcon: Icon(Icons.cloud_outlined),
    ),
    items: widget.binds
        .map(
          (bind) => DropdownMenuItem(
            value: bind.serverId,
            child: Text(
              '${bind.username} · ${bind.endpoint}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
        .toList(),
    onChanged: (serverId) {
      setState(() {
        _bind = widget.binds.firstWhere((bind) => bind.serverId == serverId);
        _repositoryId = '';
        _repositoryName = '';
        _path = '';
        _page = 1;
      });
      _load();
    },
  );

  Widget _locationBar() => Row(
    children: [
      AppIconButton(
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: (_repositoryId.isNotEmpty || _path.isNotEmpty) && !_loading
            ? _goUp
            : null,
        icon: Icons.arrow_upward_rounded,
      ),
      Expanded(
        child: Text(
          _locationTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      AppIconButton(
        tooltip: context.l10n.dynamicPlaylist,
        onPressed: _canCreatePlaylist && !_loading ? _addCurrentPlaylist : null,
        icon: Icons.playlist_add_rounded,
        style: AppIconButtonStyle.tonal,
      ),
      AppIconButton(
        tooltip: context.l10n.refresh,
        onPressed: !_loading ? _load : null,
        icon: Icons.refresh_rounded,
      ),
    ],
  );

  String get _locationTitle {
    if (_mode == SeafileBrowseMode.starred) return 'Starred';
    if (_repositoryId.isEmpty) return 'Libraries';
    return _path.isEmpty ? _repositoryName : '$_repositoryName · $_path';
  }

  Widget _list() {
    if (_items.isEmpty) {
      return const Center(
        child: AppEmptyState(
          icon: Icons.video_library_outlined,
          title: 'No items',
        ),
      );
    }
    return AppListView.separated(
      itemCount: _items.length,
      separatorBuilder: (_, _) => const AppDivider(height: 1),
      itemBuilder: (context, index) {
        final item = _items[index];
        final isLibrary = _repositoryId.isEmpty && item.isDir;
        return ListTile(
          leading: _thumbnail(item),
          title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(
            _details(item, isLibrary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: item.isDir ? () => _open(item, isLibrary) : null,
          trailing: item.passwordRequired
              ? AppIconButton(
                  tooltip: 'Unlock library',
                  onPressed: () => _unlock(item),
                  icon: Icons.lock_open_rounded,
                )
              : AppIconButton(
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

  Widget _thumbnail(SeafileFileItemInfo item) {
    if (item.isDir || item.thumbnailUrl.isEmpty) {
      return Icon(
        item.passwordRequired
            ? Icons.folder_off_outlined
            : item.isDir
            ? Icons.folder_rounded
            : Icons.movie_outlined,
        color: item.starred ? Colors.amber.shade700 : null,
      );
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

  String _details(SeafileFileItemInfo item, bool isLibrary) {
    if (isLibrary) {
      return [
        if (item.repositoryEncrypted) 'Encrypted',
        if (item.passwordRequired) 'Password required',
        _formatBytes(item.size),
      ].join(' · ');
    }
    if (item.isDir) return item.starred ? 'Folder · Starred' : 'Folder';
    return [
      _formatBytes(item.size),
      if (item.modifierName.isNotEmpty) item.modifierName,
      if (item.starred) 'Starred',
    ].join(' · ');
  }

  Widget _pagination() => Row(
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

  bool get _canCreatePlaylist => switch (_mode) {
    SeafileBrowseMode.folder => _repositoryId.isNotEmpty,
    SeafileBrowseMode.starred => true,
    SeafileBrowseMode.search =>
      _repositoryId.isNotEmpty && _searchController.text.trim().isNotEmpty,
  };

  void _search() {
    if (_repositoryId.isEmpty) {
      AppNotifications.showError(context, 'Select a library first');
      return;
    }
    if (_searchController.text.trim().isEmpty) return;
    setState(() => _page = 1);
    _load();
  }

  void _open(SeafileFileItemInfo item, bool isLibrary) {
    if (item.passwordRequired) {
      _unlock(item);
      return;
    }
    setState(() {
      _repositoryId = item.repositoryId;
      if (isLibrary) _repositoryName = item.name;
      _path = isLibrary ? '' : item.path;
      _mode = SeafileBrowseMode.folder;
      _page = 1;
    });
    _load();
  }

  void _goUp() {
    if (_path.isEmpty) {
      setState(() {
        _repositoryId = '';
        _repositoryName = '';
        _page = 1;
      });
    } else {
      final parts = _path.split('/').where((part) => part.isNotEmpty).toList();
      setState(() {
        _path = parts.length <= 1
            ? ''
            : '/${parts.take(parts.length - 1).join('/')}';
        _page = 1;
      });
    }
    _load();
  }

  Future<void> _load() async {
    final bind = _bind;
    if (bind == null || _loading) return;
    if (_mode == SeafileBrowseMode.search &&
        (_repositoryId.isEmpty || _searchController.text.trim().isEmpty)) {
      return;
    }
    setState(() => _loading = true);
    try {
      final page = await (widget.pageLoader ?? _defaultLoader)(
        bind,
        _mode,
        _repositoryId,
        _path,
        _searchController.text.trim(),
        _page,
        _pageSize,
      );
      if (!mounted) return;
      setState(() {
        _items = page.items;
        _page = page.page;
        _hasMore = page.hasMore;
      });
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<SeafileFileListPage> _defaultLoader(
    SeafileBindInfo bind,
    SeafileBrowseMode mode,
    String repositoryId,
    String path,
    String query,
    int page,
    int pageSize,
  ) {
    if (mode == SeafileBrowseMode.starred) {
      return providerGateway.listSeafileStarred(
        bind.serverId,
        page: page,
        pageSize: pageSize,
        instanceName: bind.providerInstanceName,
      );
    }
    if (repositoryId.isEmpty) {
      return providerGateway.listSeafileRepositories(
        bind.serverId,
        page: page,
        pageSize: pageSize,
        instanceName: bind.providerInstanceName,
      );
    }
    return providerGateway.listSeafileFiles(
      bind.serverId,
      repositoryId,
      path,
      page: page,
      pageSize: pageSize,
      search: mode == SeafileBrowseMode.search ? query : '',
      instanceName: bind.providerInstanceName,
    );
  }

  Future<void> _unlock(SeafileFileItemInfo item) async {
    final password = await showAppDialog<String>(
      context: context,
      builder: (context) => _SeafileUnlockDialog(libraryName: item.name),
    );
    if (password == null || password.isEmpty || _bind == null) return;
    setState(() => _loading = true);
    try {
      await (widget.libraryUnlocker ?? _defaultUnlocker)(
        _bind!,
        item.repositoryId,
        password,
      );
      await _loadAfterUnlock();
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _defaultUnlocker(
    SeafileBindInfo bind,
    String repositoryId,
    String password,
  ) => providerGateway.unlockSeafileLibrary(
    bind.serverId,
    repositoryId,
    password,
    instanceName: bind.providerInstanceName,
  );

  Future<void> _loadAfterUnlock() async {
    if (mounted) setState(() => _loading = false);
    await _load();
  }

  Future<void> _addMedia(SeafileFileItemInfo item) => _runAdd(() async {
    final bind = _bind!;
    await providerGateway.addSeafileMedia(
      widget.roomId,
      playlistId: widget.playlistId,
      serverId: bind.serverId,
      repositoryId: item.repositoryId,
      path: item.path,
      objectId: item.objectId,
      hasThumbnail: item.hasThumbnail,
      name: item.name,
      providerInstanceName: bind.providerInstanceName,
    );
  });

  Future<void> _addFolderPlaylist(SeafileFileItemInfo item) => _createPlaylist(
    item.name,
    {'type': 'folder', 'repositoryId': item.repositoryId, 'path': item.path},
  );

  Future<void> _addCurrentPlaylist() => switch (_mode) {
    SeafileBrowseMode.folder => _createPlaylist(
      _path.split('/').where((part) => part.isNotEmpty).lastOrNull ??
          _repositoryName,
      {'type': 'folder', 'repositoryId': _repositoryId, 'path': _path},
    ),
    SeafileBrowseMode.starred => _createPlaylist('Seafile Starred', {
      'type': 'starred',
    }),
    SeafileBrowseMode.search =>
      _createPlaylist('Seafile: ${_searchController.text.trim()}', {
        'type': 'search',
        'repositoryId': _repositoryId,
        'query': _searchController.text.trim(),
      }),
  };

  Future<void> _createPlaylist(String name, Map<String, dynamic> source) =>
      _runAdd(() async {
        final bind = _bind!;
        await providerGateway.createPlaylist(
          widget.roomId,
          parentId: widget.playlistId,
          sourceProvider: 'seafile',
          providerInstanceName: bind.providerInstanceName,
          sourceConfig: {'serverId': bind.serverId, 'source': source},
          name: name.isEmpty ? 'Seafile' : name,
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

class _SeafileUnlockDialog extends StatefulWidget {
  const _SeafileUnlockDialog({required this.libraryName});

  final String libraryName;

  @override
  State<_SeafileUnlockDialog> createState() => _SeafileUnlockDialogState();
}

class _SeafileUnlockDialogState extends State<_SeafileUnlockDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final password = _controller.text;
    if (password.isNotEmpty) Navigator.pop(context, password);
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogFrame(
      maxWidth: 440,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppDialogHeader(
            title: Text('Unlock ${widget.libraryName}'),
            icon: Icons.lock_open_rounded,
            onClose: () => Navigator.pop(context),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _controller,
                  label: 'Library password',
                  prefixIcon: Icons.password_rounded,
                  autofocus: true,
                  obscureText: true,
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppActionButton(
                      onPressed: () => Navigator.pop(context),
                      label: MaterialLocalizations.of(
                        context,
                      ).cancelButtonLabel,
                      style: AppActionButtonStyle.text,
                    ),
                    const SizedBox(width: 8),
                    AppActionButton(
                      onPressed: _submit,
                      label: 'Unlock',
                      icon: Icons.lock_open_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
