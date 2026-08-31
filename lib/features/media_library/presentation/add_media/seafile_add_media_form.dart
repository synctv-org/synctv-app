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

enum SeafileBrowseMode { folder, starred, search }

typedef SeafilePageLoader = Future<SeafileFileListPage> Function(
  SeafileBindInfo bind,
  SeafileBrowseMode mode,
  String repositoryId,
  String path,
  String query,
  int page,
  int pageSize,
);

typedef SeafileLibraryUnlocker = Future<void> Function(
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
    this.onOpenBinding,
    this.pageLoader,
    this.libraryUnlocker,
    this.resourceHeaders,
  });

  final String roomId;
  final String playlistId;
  final List<SeafileBindInfo> binds;
  final ValueChanged<bool>? onDraftChanged;
  final Future<void> Function()? onOpenBinding;
  final SeafilePageLoader? pageLoader;
  final SeafileLibraryUnlocker? libraryUnlocker;
  final Map<String, String> Function()? resourceHeaders;

  @override
  State<SeafileAddMediaForm> createState() => _SeafileAddMediaFormState();
}

class _SeafileAddMediaFormState extends State<SeafileAddMediaForm> {
  static const _pageSize = 50;
  final _selection = DiscoverySelectionController();
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
  provider_common.DiscoveredSource? _listSource;
  source_enum.PlaybackProxyMode _proxyMode =
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;

  provider_common.DiscoveredSource? get _playbackPolicySource =>
      _selection.entries.firstOrNull?.source ?? _listSource;

  @override
  void initState() {
    super.initState();
    _bind = widget.binds.firstOrNull;
    _searchController.addListener(_notifyDraft);
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void didUpdateWidget(covariant SeafileAddMediaForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((_bind == null || !widget.binds.any((bind) => bind.id == _bind!.id)) &&
        widget.binds.isNotEmpty) {
      _bind = widget.binds.first;
      WidgetsBinding.instance.addPostFrameCallback((_) => _load());
    }
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppEmptyState(
              icon: Icons.cloud_off_outlined,
              title: 'Seafile',
              subtitle: context.l10n.bindAccountToAccessResources,
            ),
            const SizedBox(height: 16),
            ProviderAccountAction(
              providerType: 'seafile',
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
        _bindSelector(),
        const SizedBox(height: 10),
        PlaybackProxyModeControl(
          value: _proxyMode,
          source: _playbackPolicySource,
          onChanged: (value) => setState(() => _proxyMode = value),
        ),
        const SizedBox(height: 10),
        SegmentedButton<SeafileBrowseMode>(
          segments: [
            ButtonSegment(
              value: SeafileBrowseMode.folder,
              icon: const Icon(Icons.folder_outlined),
              label: Text(context.l10n.files),
            ),
            ButtonSegment(
              value: SeafileBrowseMode.starred,
              icon: const Icon(Icons.star_outline_rounded),
              label: Text(context.l10n.starred),
            ),
            ButtonSegment(
              value: SeafileBrowseMode.search,
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
                  label: context.l10n.searchMediaLibrary,
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
        _locationBar(),
      ],
    );
    final results = Column(
      children: [
        Expanded(child: _loading ? const AppLoadingIndicator() : _list()),
        _pagination(),
      ],
    );
    return ProviderWorkspace(controls: controls, results: results);
  }

  Widget _bindSelector() => ProviderAccountSelector<SeafileBindInfo>(
    accounts: widget.binds,
    selectedId: _bind?.id,
    idOf: (bind) => bind.id,
    labelOf: (bind) {
      final title = '${bind.username} · ${bind.endpoint}';
      return bind.providerInstanceName.isEmpty
          ? title
          : '$title · ${bind.providerInstanceName}';
    },
    enabled: !_loading,
    onChanged: (bind) {
      if (bind == null) return;
      setState(() {
        _bind = bind;
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
          style: Theme.of(context).textTheme.labelLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      AppIconButton(
        tooltip: context.l10n.refresh,
        onPressed: !_loading ? _load : null,
        icon: Icons.refresh_rounded,
      ),
    ],
  );

  String get _locationTitle {
    if (_mode == SeafileBrowseMode.starred) return context.l10n.starred;
    if (_repositoryId.isEmpty) return context.l10n.libraries;
    return _path.isEmpty ? _repositoryName : '$_repositoryName · $_path';
  }

  Widget _list() {
    final itemsByKey = {
      for (final item in _items) '${item.repositoryId}:${item.path}': item,
    };
    return DiscoveryBrowser(
      selectionController: _selection,
      selectionScope:
          '${_bind?.id}:${_mode.name}:$_repositoryId:$_path:${_searchController.text}',
      onSelectionChanged: () => setState(() {}),
      items: [
        for (final item in _items)
          DiscoveryBrowserEntry(
            key: '${item.repositoryId}:${item.path}',
            title: item.name,
            subtitle: _details(item, _repositoryId.isEmpty && item.isDir),
            source: item.source.withPlaybackProxyMode(_proxyMode),
            isContainer: item.isDir,
            leading: _thumbnail(item),
            selectable: !item.passwordRequired,
            openIcon: item.passwordRequired
                ? Icons.lock_open_rounded
                : Icons.chevron_right_rounded,
            openTooltip: item.passwordRequired
                ? context.l10n.unlock
                : context.l10n.openFolder,
          ),
      ],
      loading: _loading,
      emptyIcon: Icons.video_library_outlined,
      onOpen: (entry) {
        final item = itemsByKey[entry.key]!;
        _open(item, _repositoryId.isEmpty && item.isDir);
      },
      onAddSelected: _addSelected,
      onAddCurrentList: _canCreatePlaylist && _listSource != null
          ? _addCurrentPlaylist
          : null,
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
      AppNotifications.showError(context, context.l10n.selectLibraryFirst);
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
    setState(() {
      _loading = true;
      _listSource = null;
      _selection.clear();
    });
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
        _listSource = page.source;
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
    final name = switch (_mode) {
      SeafileBrowseMode.folder =>
        _path.split('/').where((part) => part.isNotEmpty).lastOrNull ??
            _repositoryName,
      SeafileBrowseMode.starred => 'Seafile Starred',
      SeafileBrowseMode.search => 'Seafile: ${_searchController.text.trim()}',
    };
    await providerGateway.addDiscoveredSource(
      widget.roomId,
      playlistId: widget.playlistId,
      source: source.withPlaybackProxyMode(_proxyMode),
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
            title: Text(context.l10n.unlockLibrary(widget.libraryName)),
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
                  label: context.l10n.libraryPassword,
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
                      label: MaterialLocalizations.of(context)
                          .cancelButtonLabel,
                      style: AppActionButtonStyle.text,
                    ),
                    const SizedBox(width: 8),
                    AppActionButton(
                      onPressed: _submit,
                      label: context.l10n.unlock,
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
