import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/contracts/twitch_source_config.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/src/generated/proto/providers/twitch.pb.dart'
    as twitch;
import 'package:synctv_app/src/generated/proto/providers/twitch.pbenum.dart'
    as twitch_enum;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

enum TwitchAddMode { media, channel, followedLive, categoryLive, searchLive }

class TwitchAddRequest {
  const TwitchAddRequest({
    required this.mode,
    required this.resource,
    required this.name,
    required this.content,
    required this.categoryId,
    required this.categoryName,
    required this.shared,
    required this.instanceName,
  });

  final TwitchAddMode mode;
  final String resource;
  final String name;
  final source_enum.TwitchPlaylistContent content;
  final String categoryId;
  final String categoryName;
  final bool shared;
  final String instanceName;

  bool get playlist => mode != TwitchAddMode.media;
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
  )?
  onListChannelItems;
  final Future<twitch.ListFollowedLiveResponse> Function(
    TwitchAddRequest request,
  )?
  onListFollowedLive;
  final Future<twitch.ListCategoryStreamsResponse> Function(
    TwitchAddRequest request,
  )?
  onListCategoryStreams;
  final Future<twitch.ListTopCategoriesResponse> Function(
    TwitchAddRequest request,
  )?
  onListTopCategories;
  final Future<twitch.SearchLiveChannelsResponse> Function(
    TwitchAddRequest request,
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
  bool _shared = false;
  bool _loading = false;
  String _instanceName = '';
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

  Iterable<TwitchBindInfo> get _selectedBinds =>
      widget.binds.where((bind) => bind.providerInstanceName == _instanceName);

  bool get _hasHelixCredential =>
      _selectedBinds.isNotEmpty ||
      widget.onListTopCategories != null ||
      widget.onSearchLiveChannels != null ||
      widget.onListFollowedLive != null;

  bool get _hasFollowedScope =>
      _selectedBinds.any((bind) => bind.scopes.contains('user:read:follows')) ||
      widget.onListFollowedLive != null;

  void _changed() {
    _clearPreview();
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
    final instances = {
      '',
      ...widget.binds.map((bind) => bind.providerInstanceName),
    }.toList();
    if (!instances.contains(_instanceName)) _instanceName = '';

    return AppSingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<TwitchAddMode>(
            key: const Key('twitch-source'),
            initialValue: _mode,
            decoration: const InputDecoration(
              labelText: 'Source',
              prefixIcon: Icon(Icons.live_tv_outlined),
            ),
            items: [
              const DropdownMenuItem(
                value: TwitchAddMode.media,
                child: Text('Media URL'),
              ),
              const DropdownMenuItem(
                value: TwitchAddMode.channel,
                child: Text('Channel archive'),
              ),
              DropdownMenuItem(
                value: TwitchAddMode.followedLive,
                enabled: _hasFollowedScope,
                child: const Text('Followed live'),
              ),
              DropdownMenuItem(
                value: TwitchAddMode.categoryLive,
                enabled: _hasHelixCredential,
                child: const Text('Category live'),
              ),
              DropdownMenuItem(
                value: TwitchAddMode.searchLive,
                enabled: _hasHelixCredential,
                child: const Text('Search live'),
              ),
            ],
            onChanged: _loading
                ? null
                : (value) {
                    _mode = value ?? TwitchAddMode.media;
                    _resourceController.clear();
                    _categoryId = '';
                    _categoryName = '';
                    _changed();
                  },
          ),
          if (_requiresResource) ...[
            const SizedBox(height: 12),
            AppTextField(
              key: const Key('twitch-resource'),
              controller: _resourceController,
              enabled: !_loading,
              label: switch (_mode) {
                TwitchAddMode.media => 'Live, VOD, or clip URL',
                TwitchAddMode.channel => 'Channel name or URL',
                TwitchAddMode.searchLive => 'Channel search',
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
              decoration: const InputDecoration(
                labelText: 'Content',
                prefixIcon: Icon(Icons.video_collection_outlined),
              ),
              items: const [
                DropdownMenuItem(
                  value: source_enum
                      .TwitchPlaylistContent
                      .TWITCH_PLAYLIST_CONTENT_VIDEOS,
                  child: Text('Videos'),
                ),
                DropdownMenuItem(
                  value: source_enum
                      .TwitchPlaylistContent
                      .TWITCH_PLAYLIST_CONTENT_HIGHLIGHTS,
                  child: Text('Highlights'),
                ),
                DropdownMenuItem(
                  value: source_enum
                      .TwitchPlaylistContent
                      .TWITCH_PLAYLIST_CONTENT_UPLOADS,
                  child: Text('Uploads'),
                ),
                DropdownMenuItem(
                  value: source_enum
                      .TwitchPlaylistContent
                      .TWITCH_PLAYLIST_CONTENT_CLIPS,
                  child: Text('Clips'),
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
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('twitch-name'),
            controller: _nameController,
            enabled: !_loading,
            label: 'Name',
            prefixIcon: Icons.title,
            onChanged: (_) => _changed(),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _instanceName,
            decoration: const InputDecoration(
              labelText: 'Provider instance',
              prefixIcon: Icon(Icons.dns_outlined),
            ),
            items: instances
                .map(
                  (value) => DropdownMenuItem(
                    value: value,
                    child: Text(value.isEmpty ? 'Default' : value),
                  ),
                )
                .toList(),
            onChanged: _loading
                ? null
                : (value) {
                    _instanceName = value ?? '';
                    if ((_mode == TwitchAddMode.followedLive &&
                            !_hasFollowedScope) ||
                        ((_mode == TwitchAddMode.categoryLive ||
                                _mode == TwitchAddMode.searchLive) &&
                            !_hasHelixCredential)) {
                      _mode = TwitchAddMode.media;
                    }
                    _clearPreview(keepCategories: false);
                    setState(() {});
                  },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Use room owner credential'),
            value: _shared,
            onChanged: _loading
                ? null
                : (value) => setState(() => _shared = value),
          ),
          if (_preview() case final preview?) ...[
            const SizedBox(height: 8),
            preview,
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                key: const Key('twitch-preview'),
                onPressed: _loading || !_canAct ? null : _loadPreview,
                icon: const Icon(Icons.preview_outlined),
                label: const Text('Preview'),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                key: const Key('twitch-submit'),
                onPressed: _loading || !_canAct ? null : _submit,
                icon: _loading
                    ? const SizedBox.square(
                        dimension: 18,
                        child: AppLoadingIndicator(
                          size: AppLoadingSize.sm,
                          centered: false,
                        ),
                      )
                    : const Icon(Icons.add),
                label: Text(
                  _mode == TwitchAddMode.media
                      ? 'Add media'
                      : 'Create playlist',
                ),
              ),
            ],
          ),
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
        label: const Text('Load categories'),
      );
    }
    return DropdownButtonFormField<String>(
      key: const Key('twitch-category'),
      initialValue: _categoryId.isEmpty ? null : _categoryId,
      decoration: const InputDecoration(
        labelText: 'Category',
        prefixIcon: Icon(Icons.category_outlined),
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
          resolved.metadata.isLive ? 'Live' : _resourceKind(resolved.kind),
          '${resolved.qualities.length} qualities',
          if (resolved.metadata.chapters.isNotEmpty)
            '${resolved.metadata.chapters.length} chapters',
          if (resolved.metadata.hasStoryboardUrl()) 'Storyboard',
        ].where((value) => value.isNotEmpty).join(' · '),
        imageUrl: resolved.metadata.thumbnailUrl,
      );
    }
    final tiles = <Widget>[];
    for (final item in _channelItems?.items ?? const <twitch.ListItem>[]) {
      tiles.add(
        _previewTile(
          title: item.title,
          subtitle: [
            _resourceKind(item.kind),
            if (item.hasViewCount()) '${item.viewCount} views',
          ].join(' · '),
          imageUrl: item.thumbnailUrl,
        ),
      );
    }
    for (final item in [
      ...?_followedLive?.items,
      ...?_categoryStreams?.items,
    ]) {
      tiles.add(
        _previewTile(
          title: item.title,
          subtitle:
              '${item.displayName} · ${item.categoryName} · ${item.viewerCount} viewers',
          imageUrl: item.thumbnailUrl,
        ),
      );
    }
    for (final item
        in _searchResults?.items ?? const <twitch.SearchChannelItem>[]) {
      tiles.add(
        _previewTile(
          title: item.title.isEmpty ? item.displayName : item.title,
          subtitle: '${item.displayName} · ${item.categoryName}',
          imageUrl: item.thumbnailUrl,
          trailing: AppIconButton(
            tooltip: 'Schedule',
            onPressed: _loading ? null : () => _loadSchedule(item.userId),
            icon: Icons.event_outlined,
          ),
        ),
      );
    }
    if (_schedule case final schedule?) {
      tiles.addAll(
        schedule.segments.map(
          (segment) => _previewTile(
            title: segment.title,
            subtitle: [
              segment.startTime,
              if (segment.hasCategoryName()) segment.categoryName,
              if (segment.isRecurring) 'Recurring',
            ].join(' · '),
          ),
        ),
      );
    }
    if (tiles.isEmpty) return null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: tiles.take(8).toList(),
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
    twitch_enum.ResourceKind.RESOURCE_KIND_CHANNEL => 'Channel',
    twitch_enum.ResourceKind.RESOURCE_KIND_VIDEO => 'VOD',
    twitch_enum.ResourceKind.RESOURCE_KIND_CLIP => 'Clip',
    _ => 'Media',
  };

  String? _channel(String raw) {
    final value = raw.trim().replaceFirst(RegExp(r'^@'), '');
    if (RegExp(r'^[A-Za-z0-9_]{3,25}$').hasMatch(value)) {
      return value.toLowerCase();
    }
    final uri = Uri.tryParse(value.contains('://') ? value : 'https://$value');
    if (uri == null ||
        !{'twitch.tv', 'www.twitch.tv', 'm.twitch.tv'}.contains(uri.host)) {
      return null;
    }
    final parts = uri.pathSegments.where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty ||
        !RegExp(r'^[A-Za-z0-9_]{3,25}$').hasMatch(parts.first)) {
      return null;
    }
    return parts.first.toLowerCase();
  }

  Future<void> _loadCategories() async {
    await _run(() async {
      final load = widget.onListTopCategories;
      _categories = load != null
          ? await load(_request)
          : await providerGateway.listTwitchTopCategories(
              pageSize: 50,
              instanceName: _instanceName,
            );
    });
  }

  Future<void> _loadPreview() async {
    await _run(() async {
      final request = _request;
      switch (_mode) {
        case TwitchAddMode.media:
          final resolve = widget.onResolve;
          _resolved = resolve != null
              ? await resolve(request)
              : await providerGateway.resolveTwitch(
                  request.resource,
                  instanceName: request.instanceName,
                );
        case TwitchAddMode.channel:
          final channel = _channel(request.resource);
          if (channel == null) throw StateError('Invalid Twitch channel');
          final list = widget.onListChannelItems;
          _channelItems = list != null
              ? await list(request, channel)
              : await providerGateway.listTwitchChannelItems(
                  channel,
                  content: request.content,
                  pageSize: 8,
                  instanceName: request.instanceName,
                );
        case TwitchAddMode.followedLive:
          final list = widget.onListFollowedLive;
          _followedLive = list != null
              ? await list(request)
              : await providerGateway.listTwitchFollowedLive(
                  pageSize: 8,
                  instanceName: request.instanceName,
                );
        case TwitchAddMode.categoryLive:
          final list = widget.onListCategoryStreams;
          _categoryStreams = list != null
              ? await list(request)
              : await providerGateway.listTwitchCategoryStreams(
                  categoryId: request.categoryId,
                  categoryName: request.categoryName,
                  pageSize: 8,
                  instanceName: request.instanceName,
                );
        case TwitchAddMode.searchLive:
          final search = widget.onSearchLiveChannels;
          _searchResults = search != null
              ? await search(request)
              : await providerGateway.searchTwitchLiveChannels(
                  request.resource,
                  pageSize: 8,
                  instanceName: request.instanceName,
                );
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
    await _run(() async {
      if (widget.onSubmit case final submit?) {
        await submit(request);
      } else if (_mode == TwitchAddMode.media) {
        final resolved =
            _resolved ??
            await providerGateway.resolveTwitch(
              request.resource,
              instanceName: request.instanceName,
            );
        await providerGateway.addMediaFromSourceConfig(
          widget.roomId,
          playlistId: widget.playlistId,
          sourceConfig: TwitchSourceConfig.media(
            resolved.sourceConfig,
            request.shared,
          ),
          name: request.name.isEmpty ? resolved.metadata.title : request.name,
          providerInstanceName: request.instanceName,
        );
      } else {
        final source = _playlistSource(request);
        await providerGateway.createPlaylistFromSourceConfig(
          widget.roomId,
          sourceConfig: TwitchSourceConfig.playlist(source, request.shared),
          parentId: widget.playlistId,
          providerInstanceName: request.instanceName,
          name: request.name.isEmpty ? _defaultName(request) : request.name,
        );
      }
      if (!mounted) return;
      _resourceController.clear();
      _nameController.clear();
      _clearPreview();
      widget.onDraftChanged(false);
      AppNotifications.showSuccess(context, 'Twitch source added');
    });
  }

  source_config.TwitchPlaylistSourceConfig _playlistSource(
    TwitchAddRequest request,
  ) {
    switch (request.mode) {
      case TwitchAddMode.channel:
        if (_channelItems?.hasSourceConfig() == true) {
          return _channelItems!.sourceConfig;
        }
        final channel = _channel(request.resource);
        if (channel == null) throw StateError('Invalid Twitch channel');
        return source_config.TwitchPlaylistSourceConfig(
          channel: source_config.TwitchPlaylistSourceConfig_Channel(
            channel: channel,
            content: request.content,
          ),
        );
      case TwitchAddMode.followedLive:
        return _followedLive?.sourceConfig ??
            source_config.TwitchPlaylistSourceConfig(
              followedLive:
                  source_config.TwitchPlaylistSourceConfig_FollowedLive(),
            );
      case TwitchAddMode.categoryLive:
        return _categoryStreams?.sourceConfig ??
            source_config.TwitchPlaylistSourceConfig(
              categoryLive:
                  source_config.TwitchPlaylistSourceConfig_CategoryLive(
                    categoryId: request.categoryId,
                    categoryName: request.categoryName,
                  ),
            );
      case TwitchAddMode.searchLive:
        return _searchResults?.sourceConfig ??
            source_config.TwitchPlaylistSourceConfig(
              searchLive: source_config.TwitchPlaylistSourceConfig_SearchLive(
                query: request.resource,
              ),
            );
      case TwitchAddMode.media:
        throw StateError('Twitch media is not a playlist source');
    }
  }

  String _defaultName(TwitchAddRequest request) => switch (request.mode) {
    TwitchAddMode.channel => _channel(request.resource) ?? 'Twitch channel',
    TwitchAddMode.followedLive => 'Followed live',
    TwitchAddMode.categoryLive => request.categoryName,
    TwitchAddMode.searchLive => request.resource,
    TwitchAddMode.media => 'Twitch media',
  };
}
