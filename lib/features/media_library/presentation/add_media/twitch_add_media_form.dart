import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/src/generated/proto/providers/twitch.pb.dart'
    as twitch;
import 'package:synctv_app/src/generated/proto/providers/twitch.pbenum.dart'
    as twitch_enum;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/discovery_browser.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_add_target.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_account_action.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_workspace.dart';
import 'package:synctv_app/l10n/l10n.dart';

enum TwitchAddMode { media, channel, followedLive, categoryLive, searchLive }

class TwitchAddRequest {
  const TwitchAddRequest({
    required this.target,
    required this.mode,
    required this.resource,
    required this.name,
    required this.content,
    required this.categoryId,
    required this.categoryName,
    required this.shared,
    required this.instanceName,
  });

  final ProviderAddTarget target;
  final TwitchAddMode mode;
  final String resource;
  final String name;
  final source_enum.TwitchPlaylistContent content;
  final String categoryId;
  final String categoryName;
  final bool shared;
  final String instanceName;
}

class TwitchAddMediaForm extends StatefulWidget {
  const TwitchAddMediaForm({
    super.key,
    required this.roomId,
    required this.playlistId,
    required this.binds,
    required this.onDraftChanged,
    this.onSubmit,
    this.onResolve,
    this.onListChannelItems,
    this.onListFollowedLive,
    this.onListCategoryStreams,
    this.onListTopCategories,
    this.onSearchLiveChannels,
    this.onListSchedule,
  });

  final String roomId;
  final String playlistId;
  final List<TwitchBindInfo> binds;
  final ValueChanged<bool> onDraftChanged;
  final Future<void> Function(TwitchAddRequest request)? onSubmit;
  final Future<twitch.ResolveResponse> Function(TwitchAddRequest request)?
  onResolve;
  final Future<twitch.ListChannelItemsResponse> Function(
    TwitchAddRequest request,
    String channel,
    String? cursor,
  )?
  onListChannelItems;
  final Future<twitch.ListFollowedLiveResponse> Function(
    TwitchAddRequest request,
    String? cursor,
  )?
  onListFollowedLive;
  final Future<twitch.ListCategoryStreamsResponse> Function(
    TwitchAddRequest request,
    String? cursor,
  )?
  onListCategoryStreams;
  final Future<twitch.ListTopCategoriesResponse> Function(
    TwitchAddRequest request,
  )?
  onListTopCategories;
  final Future<twitch.SearchLiveChannelsResponse> Function(
    TwitchAddRequest request,
    String? cursor,
  )?
  onSearchLiveChannels;
  final Future<twitch.ListScheduleResponse> Function(
    TwitchAddRequest request,
    String broadcasterId,
  )?
  onListSchedule;

  @override
  State<TwitchAddMediaForm> createState() => _TwitchAddMediaFormState();
}

class _TwitchAddMediaFormState extends State<TwitchAddMediaForm> {
  final _resourceController = TextEditingController();
  final _nameController = TextEditingController();
  TwitchAddMode _mode = TwitchAddMode.media;
  ProviderAddTarget _target = ProviderAddTarget.parse;
  bool _shared = false;
  bool _loading = false;
  String _instanceName = '';
  String _selectedBindId = '';
  String _categoryId = '';
  String _categoryName = '';
  source_enum.TwitchPlaylistContent _content =
      source_enum.TwitchPlaylistContent.TWITCH_PLAYLIST_CONTENT_VIDEOS;
  twitch.ResolveResponse? _resolved;
  twitch.ListChannelItemsResponse? _channelItems;
  twitch.ListFollowedLiveResponse? _followedLive;
  twitch.ListCategoryStreamsResponse? _categoryStreams;
  twitch.ListTopCategoriesResponse? _categories;
  twitch.SearchLiveChannelsResponse? _searchResults;
  twitch.ListScheduleResponse? _schedule;

  @override
  void dispose() {
    _resourceController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  TwitchAddRequest get _request => TwitchAddRequest(
    target: _target,
    mode: _mode,
    resource: _resourceController.text.trim(),
    name: _nameController.text.trim(),
    content: _content,
    categoryId: _categoryId,
    categoryName: _categoryName,
    shared: _shared,
    instanceName: _instanceName,
  );

  bool get _requiresResource => switch (_mode) {
    TwitchAddMode.media ||
    TwitchAddMode.channel ||
    TwitchAddMode.searchLive => true,
    TwitchAddMode.followedLive || TwitchAddMode.categoryLive => false,
  };

  bool get _canAct => switch (_mode) {
    TwitchAddMode.categoryLive => _categoryId.isNotEmpty,
    _ when _requiresResource => _resourceController.text.trim().isNotEmpty,
    _ => true,
  };

  void _changed() {
    _clearPreview();
    widget.onDraftChanged(
      _mode != TwitchAddMode.media ||
          _resourceController.text.trim().isNotEmpty ||
          _nameController.text.trim().isNotEmpty,
    );
    setState(() {});
  }

  void _nameChanged() {
    widget.onDraftChanged(
      _mode != TwitchAddMode.media ||
          _resourceController.text.trim().isNotEmpty ||
          _nameController.text.trim().isNotEmpty,
    );
    setState(() {});
  }

  void _clearPreview({bool keepCategories = true}) {
    _resolved = null;
    _channelItems = null;
    _followedLive = null;
    _categoryStreams = null;
    _searchResults = null;
    _schedule = null;
    if (!keepCategories) _categories = null;
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedBindId.isNotEmpty &&
        !widget.binds.any((bind) => bind.id == _selectedBindId)) {
      _selectedBindId = '';
      _instanceName = '';
    }

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProviderAddTargetSelector(
          value: _target,
          targets: const [
            ProviderAddTarget.parse,
            ProviderAddTarget.media,
            ProviderAddTarget.playlist,
          ],
          enabled: !_loading,
          onChanged: _selectTarget,
        ),
        if (_target != ProviderAddTarget.parse) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<TwitchAddMode>(
            key: const Key('twitch-source'),
            initialValue: _mode,
            decoration: InputDecoration(
              labelText: context.l10n.source,
              prefixIcon: const Icon(Icons.live_tv_outlined),
            ),
            items: [
              DropdownMenuItem(
                value: TwitchAddMode.channel,
                child: Text(context.l10n.channelArchive),
              ),
              DropdownMenuItem(
                value: TwitchAddMode.followedLive,
                child: Text(context.l10n.followedLive),
              ),
              DropdownMenuItem(
                value: TwitchAddMode.categoryLive,
                child: Text(context.l10n.categoryLive),
              ),
              DropdownMenuItem(
                value: TwitchAddMode.searchLive,
                child: Text(context.l10n.searchLive),
              ),
            ],
            onChanged: _loading
                ? null
                : (value) {
                    _mode = value ?? TwitchAddMode.channel;
                    _resourceController.clear();
                    _categoryId = '';
                    _categoryName = '';
                    _changed();
                  },
          ),
        ],
        if (_requiresResource) ...[
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('twitch-resource'),
            controller: _resourceController,
            enabled: !_loading,
            label: switch (_mode) {
              TwitchAddMode.media => context.l10n.liveVodClipUrl,
              TwitchAddMode.channel => context.l10n.channelNameOrUrl,
              TwitchAddMode.searchLive => context.l10n.channelSearch,
              _ => '',
            },
            prefixIcon: _mode == TwitchAddMode.media
                ? Icons.link_outlined
                : Icons.search,
            keyboardType: _mode == TwitchAddMode.media
                ? TextInputType.url
                : TextInputType.text,
            enableSuggestions: _mode != TwitchAddMode.media,
            autocorrect: false,
            onChanged: (_) => _changed(),
          ),
        ],
        if (_mode == TwitchAddMode.channel) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<source_enum.TwitchPlaylistContent>(
            initialValue: _content,
            decoration: InputDecoration(
              labelText: context.l10n.content,
              prefixIcon: const Icon(Icons.video_collection_outlined),
            ),
            items: [
              DropdownMenuItem(
                value: source_enum
                    .TwitchPlaylistContent
                    .TWITCH_PLAYLIST_CONTENT_VIDEOS,
                child: Text(context.l10n.videos),
              ),
              DropdownMenuItem(
                value: source_enum
                    .TwitchPlaylistContent
                    .TWITCH_PLAYLIST_CONTENT_HIGHLIGHTS,
                child: Text(context.l10n.highlights),
              ),
              DropdownMenuItem(
                value: source_enum
                    .TwitchPlaylistContent
                    .TWITCH_PLAYLIST_CONTENT_UPLOADS,
                child: Text(context.l10n.uploads),
              ),
              DropdownMenuItem(
                value: source_enum
                    .TwitchPlaylistContent
                    .TWITCH_PLAYLIST_CONTENT_CLIPS,
                child: Text(context.l10n.clips),
              ),
            ],
            onChanged: _loading
                ? null
                : (value) {
                    _content =
                        value ??
                        source_enum
                            .TwitchPlaylistContent
                            .TWITCH_PLAYLIST_CONTENT_VIDEOS;
                    _changed();
                  },
          ),
        ],
        if (_mode == TwitchAddMode.categoryLive) ...[
          const SizedBox(height: 12),
          _categoryControl(),
        ],
        if (_target != ProviderAddTarget.media) ...[
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('twitch-name'),
            controller: _nameController,
            enabled: !_loading,
            label: context.l10n.name,
            prefixIcon: Icons.title,
            onChanged: (_) => _nameChanged(),
          ),
        ],
        const SizedBox(height: 12),
        ProviderAccountSelector<TwitchBindInfo>(
          accounts: widget.binds,
          selectedId: _selectedBindId,
          idOf: (bind) => bind.id,
          labelOf: (bind) {
            final label = bind.login.isEmpty
                ? context.l10n.defaultProviderInstance
                : bind.login;
            return bind.providerInstanceName.isEmpty
                ? label
                : '$label · ${bind.providerInstanceName}';
          },
          includeDefault: true,
          enabled: !_loading,
          onChanged: (bind) => setState(() {
            _selectedBindId = bind?.id ?? '';
            _instanceName = bind?.providerInstanceName ?? '';
            _clearPreview(keepCategories: false);
          }),
        ),
        AppSwitchTile(
          contentPadding: EdgeInsets.zero,
          title: Text(context.l10n.shareMyCredentials),
          prefix: const Icon(Icons.key_rounded),
          semanticsLabel: context.l10n.shareMyCredentials,
          value: _shared,
          onChanged: _loading
              ? null
              : (value) => setState(() {
                  _shared = value;
                  _clearPreview();
                }),
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.end,
          spacing: 10,
          runSpacing: 10,
          children: [
            OutlinedButton.icon(
              key: const Key('twitch-preview'),
              onPressed: _loading || !_canAct ? null : _loadPreview,
              icon: const Icon(Icons.preview_outlined),
              label: Text(context.l10n.preview),
            ),
            if (_target == ProviderAddTarget.parse)
              FilledButton.icon(
                key: const Key('twitch-submit'),
                onPressed: _loading || !_previewReady ? null : _submit,
                icon: _loading
                    ? const SizedBox.square(
                        dimension: 18,
                        child: AppLoadingIndicator(
                          size: AppLoadingSize.sm,
                          centered: false,
                        ),
                      )
                    : const Icon(Icons.add),
                label: Text(context.l10n.addMedia),
              ),
          ],
        ),
      ],
    );
    return ProviderWorkspace(controls: content, results: _buildResults());
  }

  Widget _buildResults() {
    final schedule = _schedulePreview();
    if (_hasListPreview) {
      if (schedule == null) return _listBrowser();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          schedule,
          const SizedBox(height: 8),
          Expanded(child: _listBrowser()),
        ],
      );
    }
    final preview = _preview();
    if (preview == null && schedule == null) return const SizedBox();
    return AppSingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ?preview,
          if (preview != null && schedule != null) const SizedBox(height: 8),
          ?schedule,
        ],
      ),
    );
  }

  Widget _categoryControl() {
    final categories = _categories?.items ?? const <twitch.CategoryItem>[];
    if (categories.isEmpty) {
      return OutlinedButton.icon(
        key: const Key('twitch-load-categories'),
        onPressed: _loading ? null : _loadCategories,
        icon: const Icon(Icons.grid_view_outlined),
        label: Text(context.l10n.loadCategories),
      );
    }
    return DropdownButtonFormField<String>(
      key: const Key('twitch-category'),
      initialValue: _categoryId.isEmpty ? null : _categoryId,
      decoration: InputDecoration(
        labelText: context.l10n.category,
        prefixIcon: const Icon(Icons.category_outlined),
      ),
      items: categories
          .map(
            (category) => DropdownMenuItem(
              value: category.id,
              child: Text(category.name, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(),
      onChanged: _loading
          ? null
          : (value) {
              final category = categories.firstWhere(
                (item) => item.id == value,
              );
              _categoryId = category.id;
              _categoryName = category.name;
              _changed();
            },
    );
  }

  Widget? _preview() {
    if (_resolved case final resolved?) {
      return _previewTile(
        title: resolved.metadata.title,
        subtitle: [
          resolved.metadata.author,
          resolved.metadata.isLive
              ? context.l10n.live
              : _resourceKind(resolved.kind),
          context.l10n.qualitiesCount(resolved.qualities.length),
          if (resolved.metadata.chapters.isNotEmpty)
            context.l10n.chaptersCount(resolved.metadata.chapters.length),
        ].where((value) => value.isNotEmpty).join(' · '),
        imageUrl: resolved.metadata.thumbnailUrl,
      );
    }
    return null;
  }

  bool get _hasListPreview => switch (_mode) {
    TwitchAddMode.channel => _channelItems != null,
    TwitchAddMode.followedLive => _followedLive != null,
    TwitchAddMode.categoryLive => _categoryStreams != null,
    TwitchAddMode.searchLive => _searchResults != null,
    TwitchAddMode.media => false,
  };

  bool get _listHasMore => switch (_mode) {
    TwitchAddMode.channel => _channelItems?.hasMore ?? false,
    TwitchAddMode.followedLive => _followedLive?.hasMore ?? false,
    TwitchAddMode.categoryLive => _categoryStreams?.hasMore ?? false,
    TwitchAddMode.searchLive => _searchResults?.hasMore ?? false,
    TwitchAddMode.media => false,
  };

  bool get _listSourceReady => switch (_mode) {
    TwitchAddMode.channel => _channelItems?.hasSource() ?? false,
    TwitchAddMode.followedLive => _followedLive?.hasSource() ?? false,
    TwitchAddMode.categoryLive => _categoryStreams?.hasSource() ?? false,
    TwitchAddMode.searchLive => _searchResults?.hasSource() ?? false,
    TwitchAddMode.media => false,
  };

  Widget _listBrowser() {
    return DiscoveryBrowser(
      key: ValueKey(
        'twitch-list:${_mode.name}:$_instanceName:${_shared ? 1 : 0}',
      ),
      items: _listEntries,
      loading: _loading,
      hasMore: _listHasMore,
      onLoadMore: () => _loadPreview(loadMore: true),
      onAddSelected: _target == ProviderAddTarget.media ? _addSelected : null,
      onAddCurrentList:
          _target == ProviderAddTarget.playlist && _listSourceReady
          ? _submit
          : null,
      target: _target,
      emptyIcon: Icons.live_tv_outlined,
      emptyTitle: context.l10n.noTwitchItems,
    );
  }

  List<DiscoveryBrowserEntry> get _listEntries => switch (_mode) {
    TwitchAddMode.channel => [
      for (final item in _channelItems?.items ?? const <twitch.ListItem>[])
        DiscoveryBrowserEntry(
          key: '${item.kind.value}:${item.id}',
          title: item.title,
          subtitle: [
            _resourceKind(item.kind),
            if (item.hasViewCount())
              context.l10n.viewsCount(item.viewCount.toInt()),
          ].join(' · '),
          source: item.source,
          isContainer: false,
          selectable: item.hasSource(),
          leading: _thumbnail(item.thumbnailUrl),
        ),
    ],
    TwitchAddMode.followedLive => _streamEntries(
      _followedLive?.items ?? const <twitch.StreamItem>[],
    ),
    TwitchAddMode.categoryLive => _streamEntries(
      _categoryStreams?.items ?? const <twitch.StreamItem>[],
    ),
    TwitchAddMode.searchLive => [
      for (final item
          in _searchResults?.items ?? const <twitch.SearchChannelItem>[])
        DiscoveryBrowserEntry(
          key: item.userId,
          title: item.title.isEmpty ? item.displayName : item.title,
          subtitle: [
            item.displayName,
            item.categoryName,
            if (item.isLive) context.l10n.live,
          ].where((value) => value.isNotEmpty).join(' · '),
          source: item.source,
          isContainer: false,
          selectable: item.hasSource(),
          leading: _thumbnail(item.thumbnailUrl),
          actions: [
            AppIconButton(
              tooltip: context.l10n.schedule,
              onPressed: _loading ? null : () => _loadSchedule(item.userId),
              icon: Icons.event_outlined,
            ),
          ],
        ),
    ],
    TwitchAddMode.media => const [],
  };

  List<DiscoveryBrowserEntry> _streamEntries(List<twitch.StreamItem> items) => [
    for (final item in items)
      DiscoveryBrowserEntry(
        key: item.streamId.isEmpty ? item.channel : item.streamId,
        title: item.title,
        subtitle: [
          item.displayName,
          item.categoryName,
          context.l10n.viewersCount(item.viewerCount.toInt()),
        ].where((value) => value.isNotEmpty).join(' · '),
        source: item.source,
        isContainer: false,
        selectable: item.hasSource(),
        leading: _thumbnail(item.thumbnailUrl),
      ),
  ];

  Widget _thumbnail(String url) => url.isEmpty
      ? const Icon(Icons.live_tv_outlined)
      : AppImageThumbnail(
          url: url,
          width: 48,
          height: 48,
          borderRadius: BorderRadius.circular(4),
        );

  Widget? _schedulePreview() {
    final schedule = _schedule;
    if (schedule == null) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          schedule.broadcasterName.isEmpty
              ? schedule.broadcasterLogin
              : schedule.broadcasterName,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 6),
        if (schedule.segments.isEmpty)
          Text(context.l10n.noScheduledStreams)
        else
          for (final segment in schedule.segments.take(8))
            _previewTile(
              title: segment.title,
              subtitle: [
                segment.startTime,
                if (segment.hasCategoryName()) segment.categoryName,
                if (segment.isRecurring) context.l10n.recurring,
              ].join(' · '),
            ),
      ],
    );
  }

  Widget _previewTile({
    required String title,
    required String subtitle,
    String imageUrl = '',
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: imageUrl.isEmpty
              ? null
              : AppImageThumbnail(
                  url: imageUrl,
                  width: 96,
                  height: 54,
                  borderRadius: BorderRadius.circular(4),
                  fit: BoxFit.cover,
                  errorChild: const SizedBox(width: 96, height: 54),
                ),
          title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
          subtitle: subtitle.isEmpty
              ? null
              : Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: trailing,
        ),
      ),
    );
  }

  String _resourceKind(twitch_enum.ResourceKind kind) => switch (kind) {
    twitch_enum.ResourceKind.RESOURCE_KIND_CHANNEL => context.l10n.channel,
    twitch_enum.ResourceKind.RESOURCE_KIND_VIDEO => context.l10n.vod,
    twitch_enum.ResourceKind.RESOURCE_KIND_CLIP => context.l10n.clip,
    _ => context.l10n.media,
  };

  Future<void> _loadCategories() async {
    await _run(() async {
      final load = widget.onListTopCategories;
      _categories = load != null
          ? await load(_request)
          : await providerGateway.listTwitchTopCategories(
              pageSize: 50,
              instanceName: _instanceName,
              shared: _shared,
            );
    });
  }

  String? get _listCursor => switch (_mode) {
    TwitchAddMode.channel =>
      _channelItems?.hasCursor() == true ? _channelItems!.cursor : null,
    TwitchAddMode.followedLive =>
      _followedLive?.hasCursor() == true ? _followedLive!.cursor : null,
    TwitchAddMode.categoryLive =>
      _categoryStreams?.hasCursor() == true ? _categoryStreams!.cursor : null,
    TwitchAddMode.searchLive =>
      _searchResults?.hasCursor() == true ? _searchResults!.cursor : null,
    TwitchAddMode.media => null,
  };

  Future<void> _loadPreview({bool loadMore = false}) async {
    if (loadMore && !_listHasMore) return;
    await _run(() async {
      final request = _request;
      final cursor = loadMore ? _listCursor : null;
      switch (_mode) {
        case TwitchAddMode.media:
          final resolve = widget.onResolve;
          _resolved = resolve != null
              ? await resolve(request)
              : await providerGateway.resolveTwitch(
                  request.resource,
                  instanceName: request.instanceName,
                  shared: request.shared,
                );
        case TwitchAddMode.channel:
          final list = widget.onListChannelItems;
          final page = list != null
              ? await list(request, request.resource, cursor)
              : await providerGateway.listTwitchChannelItems(
                  request.resource,
                  content: request.content,
                  cursor: cursor,
                  pageSize: 20,
                  instanceName: request.instanceName,
                  shared: request.shared,
                );
          final current = _channelItems;
          _channelItems = loadMore && current != null
              ? twitch.ListChannelItemsResponse(
                  items: [...current.items, ...page.items],
                  cursor: page.hasCursor() ? page.cursor : null,
                  hasMore: page.hasMore,
                  source: page.hasSource() ? page.source : current.source,
                )
              : page;
        case TwitchAddMode.followedLive:
          final list = widget.onListFollowedLive;
          final page = list != null
              ? await list(request, cursor)
              : await providerGateway.listTwitchFollowedLive(
                  cursor: cursor,
                  pageSize: 20,
                  instanceName: request.instanceName,
                  shared: request.shared,
                );
          final current = _followedLive;
          _followedLive = loadMore && current != null
              ? twitch.ListFollowedLiveResponse(
                  items: [...current.items, ...page.items],
                  cursor: page.hasCursor() ? page.cursor : null,
                  hasMore: page.hasMore,
                  source: page.hasSource() ? page.source : current.source,
                )
              : page;
        case TwitchAddMode.categoryLive:
          final list = widget.onListCategoryStreams;
          final page = list != null
              ? await list(request, cursor)
              : await providerGateway.listTwitchCategoryStreams(
                  categoryId: request.categoryId,
                  categoryName: request.categoryName,
                  cursor: cursor,
                  pageSize: 20,
                  instanceName: request.instanceName,
                  shared: request.shared,
                );
          final current = _categoryStreams;
          _categoryStreams = loadMore && current != null
              ? twitch.ListCategoryStreamsResponse(
                  items: [...current.items, ...page.items],
                  cursor: page.hasCursor() ? page.cursor : null,
                  hasMore: page.hasMore,
                  source: page.hasSource() ? page.source : current.source,
                )
              : page;
        case TwitchAddMode.searchLive:
          final search = widget.onSearchLiveChannels;
          final page = search != null
              ? await search(request, cursor)
              : await providerGateway.searchTwitchLiveChannels(
                  request.resource,
                  cursor: cursor,
                  pageSize: 20,
                  instanceName: request.instanceName,
                  shared: request.shared,
                );
          final current = _searchResults;
          _searchResults = loadMore && current != null
              ? twitch.SearchLiveChannelsResponse(
                  items: [...current.items, ...page.items],
                  cursor: page.hasCursor() ? page.cursor : null,
                  hasMore: page.hasMore,
                  source: page.hasSource() ? page.source : current.source,
                )
              : page;
      }
    });
  }

  Future<void> _loadSchedule(String broadcasterId) async {
    await _run(() async {
      final load = widget.onListSchedule;
      _schedule = load != null
          ? await load(_request, broadcasterId)
          : await providerGateway.listTwitchSchedule(
              broadcasterId,
              pageSize: 8,
              instanceName: _instanceName,
              shared: _shared,
            );
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _loading = true);
    try {
      await action();
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    final request = _request;
    final source = switch (_mode) {
      TwitchAddMode.media =>
        _resolved?.hasSource() == true ? _resolved!.source : null,
      TwitchAddMode.channel =>
        _channelItems?.hasSource() == true ? _channelItems!.source : null,
      TwitchAddMode.followedLive =>
        _followedLive?.hasSource() == true ? _followedLive!.source : null,
      TwitchAddMode.categoryLive =>
        _categoryStreams?.hasSource() == true ? _categoryStreams!.source : null,
      TwitchAddMode.searchLive =>
        _searchResults?.hasSource() == true ? _searchResults!.source : null,
    };
    if (source == null) {
      AppNotifications.showError(context, context.l10n.previewSourceFirst);
      return;
    }
    await _run(() async {
      if (widget.onSubmit case final submit?) {
        await submit(request);
      } else {
        await providerGateway.addDiscoveredSource(
          widget.roomId,
          source: source,
          playlistId: widget.playlistId,
          name: request.name.isEmpty
              ? (_mode == TwitchAddMode.media
                    ? _resolved!.metadata.title
                    : _defaultName(request))
              : request.name,
        );
      }
      if (!mounted) return;
      _resourceController.clear();
      _nameController.clear();
      _clearPreview();
      widget.onDraftChanged(false);
      AppNotifications.showSuccess(context, context.l10n.addedSuccessfully);
    });
  }

  Future<void> _addSelected(List<DiscoveryBrowserEntry> entries) async {
    if (entries.isEmpty) return;
    await _run(() async {
      for (final entry in entries) {
        await providerGateway.addDiscoveredSource(
          widget.roomId,
          source: entry.source,
          playlistId: widget.playlistId,
          name: entry.title,
        );
      }
      if (!mounted) return;
      _resourceController.clear();
      _nameController.clear();
      _clearPreview();
      widget.onDraftChanged(false);
      AppNotifications.showSuccess(context, context.l10n.addedSuccessfully);
    });
  }

  bool get _previewReady => _resolved?.hasSource() == true;

  String _defaultName(TwitchAddRequest request) => switch (request.mode) {
    TwitchAddMode.channel => request.resource.trim(),
    TwitchAddMode.followedLive => context.l10n.followedLive,
    TwitchAddMode.categoryLive => request.categoryName,
    TwitchAddMode.searchLive => request.resource,
    TwitchAddMode.media => 'Twitch ${context.l10n.media}',
  };

  void _selectTarget(ProviderAddTarget target) {
    if (target == _target) return;
    _target = target;
    _mode = target == ProviderAddTarget.parse
        ? TwitchAddMode.media
        : TwitchAddMode.channel;
    _resourceController.clear();
    _nameController.clear();
    _categoryId = '';
    _categoryName = '';
    _clearPreview();
    widget.onDraftChanged(false);
    setState(() {});
  }
}
