import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/contracts/youtube_source_config.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/src/generated/proto/providers/youtube.pb.dart'
    as youtube;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/youtube_playlist_preview.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

enum YoutubeAddMode {
  video,
  playlist,
  channel,
  search,
  subscriptions,
  likedVideos,
  watchLater,
}

enum YoutubeChannelMode { videos, shorts, live }

class YoutubeAddRequest {
  const YoutubeAddRequest({
    required this.mode,
    required this.channelMode,
    required this.value,
    required this.name,
    required this.shared,
    required this.instanceName,
  });

  final YoutubeAddMode mode;
  final YoutubeChannelMode channelMode;
  final String value;
  final String name;
  final bool shared;
  final String instanceName;
}

class YoutubeAddMediaForm extends StatefulWidget {
  const YoutubeAddMediaForm({
    super.key,
    required this.roomId,
    required this.playlistId,
    required this.binds,
    required this.onDraftChanged,
    this.onSubmit,
    this.onResolve,
  });

  final String roomId;
  final String playlistId;
  final List<YoutubeBindInfo> binds;
  final ValueChanged<bool> onDraftChanged;
  final Future<void> Function(YoutubeAddRequest request)? onSubmit;
  final Future<youtube.ResolveResponse> Function(YoutubeAddRequest request)?
  onResolve;

  @override
  State<YoutubeAddMediaForm> createState() => _YoutubeAddMediaFormState();
}

class _YoutubeAddMediaFormState extends State<YoutubeAddMediaForm> {
  final _valueController = TextEditingController();
  final _nameController = TextEditingController();
  YoutubeAddMode _mode = YoutubeAddMode.video;
  YoutubeChannelMode _channelMode = YoutubeChannelMode.videos;
  bool _shared = false;
  bool _loading = false;
  String _instanceName = '';
  youtube.ResolveResponse? _resolved;
  RoomMediaLibraryPage? _playlistPreview;

  @override
  void dispose() {
    _valueController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _changed() {
    _resolved = null;
    _playlistPreview = null;
    widget.onDraftChanged(
      _valueController.text.trim().isNotEmpty ||
          _nameController.text.trim().isNotEmpty,
    );
    setState(() {});
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
          DropdownButtonFormField<YoutubeAddMode>(
            key: const Key('youtube-mode'),
            initialValue: _mode,
            decoration: const InputDecoration(
              labelText: 'Source',
              prefixIcon: Icon(Icons.video_library_outlined),
            ),
            items: YoutubeAddMode.values
                .map(
                  (mode) => DropdownMenuItem(
                    value: mode,
                    child: Text(_modeLabel(mode)),
                  ),
                )
                .toList(),
            onChanged: _loading
                ? null
                : (mode) {
                    if (mode == null) return;
                    if (mode == _mode) return;
                    _mode = mode;
                    _valueController.clear();
                    _changed();
                  },
          ),
          if (_requiresValue) ...[
            const SizedBox(height: 16),
            AppTextField(
              key: const Key('youtube-value'),
              controller: _valueController,
              enabled: !_loading,
              label: switch (_mode) {
                YoutubeAddMode.video => 'Video URL or ID',
                YoutubeAddMode.playlist => 'Playlist URL or ID',
                YoutubeAddMode.channel => 'Channel URL or ID',
                YoutubeAddMode.search => 'Search query',
                _ => '',
              },
              prefixIcon: switch (_mode) {
                YoutubeAddMode.video => Icons.smart_display_outlined,
                YoutubeAddMode.playlist => Icons.playlist_play,
                YoutubeAddMode.channel => Icons.video_library_outlined,
                YoutubeAddMode.search => Icons.search,
                _ => Icons.video_library_outlined,
              },
              keyboardType: _mode == YoutubeAddMode.search
                  ? TextInputType.text
                  : TextInputType.url,
              onChanged: (_) => _changed(),
            ),
          ],
          if (_mode == YoutubeAddMode.channel) ...[
            const SizedBox(height: 12),
            SegmentedButton<YoutubeChannelMode>(
              segments: const [
                ButtonSegment(
                  value: YoutubeChannelMode.videos,
                  icon: Icon(Icons.ondemand_video_outlined),
                  label: Text('Videos'),
                ),
                ButtonSegment(
                  value: YoutubeChannelMode.shorts,
                  icon: Icon(Icons.smartphone_outlined),
                  label: Text('Shorts'),
                ),
                ButtonSegment(
                  value: YoutubeChannelMode.live,
                  icon: Icon(Icons.live_tv_outlined),
                  label: Text('Live'),
                ),
              ],
              selected: {_channelMode},
              onSelectionChanged: _loading
                  ? null
                  : (values) {
                      _channelMode = values.first;
                      _changed();
                    },
            ),
          ],
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('youtube-name'),
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
                : (value) => setState(() {
                    _instanceName = value ?? '';
                    _resolved = null;
                    _playlistPreview = null;
                  }),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Use room owner credential'),
            value: _shared,
            onChanged: _loading
                ? null
                : (value) => setState(() {
                    _shared = value;
                    if (_mode != YoutubeAddMode.video) {
                      _playlistPreview = null;
                    }
                  }),
          ),
          if (_resolved case final resolved?) ...[
            const SizedBox(height: 8),
            _preview(resolved),
          ],
          if (_playlistPreview case final preview?) ...[
            const SizedBox(height: 8),
            YoutubePlaylistPreview(
              items: preview.dynamicItems,
              loading: _loading,
              hasMore: _playlistPreviewHasMore,
              onLoadMore: () => _loadPreview(loadMore: true),
              onAddSelected: _addSelectedPreviewItems,
            ),
          ],
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                key: const Key('youtube-preview'),
                onPressed: _loading || !_valid ? null : _loadPreview,
                icon: const Icon(Icons.preview_outlined),
                label: const Text('Preview'),
              ),
              FilledButton.icon(
                key: const Key('youtube-submit'),
                onPressed: _loading || !_valid ? null : _submit,
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
                  _mode == YoutubeAddMode.video
                      ? 'Add video'
                      : 'Create playlist',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _preview(youtube.ResolveResponse resolved) {
    final metadata = resolved.metadata;
    final details = <String>[
      if (metadata.channelName.isNotEmpty) metadata.channelName,
      '${resolved.formats.length} formats',
      '${resolved.subtitles.length} subtitles',
      if (metadata.isLive) 'Live',
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (metadata.hasThumbnailUrl())
            AppImageThumbnail(
              url: metadata.thumbnailUrl,
              width: 112,
              height: 72,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(7),
              ),
              fit: BoxFit.cover,
              errorChild: const SizedBox(width: 112, height: 72),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metadata.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    details.join(' · '),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool get _playlistPreviewHasMore {
    final preview = _playlistPreview;
    if (preview == null) return false;
    if (preview.usesCursor) return preview.nextCursor.isNotEmpty;
    if (preview.total case final total?) {
      return preview.dynamicItems.length < total;
    }
    return false;
  }

  Future<void> _loadPreview({bool loadMore = false}) async {
    final normalized = _normalizeValue(_mode, _valueController.text);
    if (normalized == null) {
      AppNotifications.showError(context, 'Invalid YouTube source');
      return;
    }
    final request = YoutubeAddRequest(
      mode: _mode,
      channelMode: _channelMode,
      value: normalized,
      name: _nameController.text.trim(),
      shared: _shared,
      instanceName: _instanceName,
    );
    final current = _playlistPreview;
    if (loadMore && (current == null || !_playlistPreviewHasMore)) return;
    setState(() => _loading = true);
    try {
      if (_mode == YoutubeAddMode.video) {
        final resolve = widget.onResolve;
        _resolved = resolve != null
            ? await resolve(request)
            : await providerGateway.resolveYoutube(
                normalized,
                instanceName: _instanceName,
              );
      } else {
        final page = await providerGateway.listMediaLibrary(
          widget.roomId,
          sourceProvider: 'youtube',
          typedPreviewSourceConfig: YoutubeSourceConfig.playlist(
            _playlistSource(normalized),
            _shared,
          ),
          providerInstanceName: _instanceName,
          pageSize: 24,
          page: loadMore && current?.usesCursor == false
              ? current!.page + 1
              : 1,
          cursor: loadMore && current?.usesCursor == true
              ? current!.nextCursor
              : null,
        );
        _playlistPreview = loadMore && current != null
            ? RoomMediaLibraryPage(
                playlists: page.playlists,
                media: page.media,
                dynamicItems: [...current.dynamicItems, ...page.dynamicItems],
                currentPath: page.currentPath,
                total: page.total,
                playlistCount: page.playlistCount,
                fileCount: page.fileCount,
                version: page.version,
                usesCursor: page.usesCursor,
                nextCursor: page.nextCursor,
                page: page.page,
              )
            : page;
      }
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  source_config.YoutubePlaylistSourceConfig _playlistSource(
    String normalized,
  ) => switch (_mode) {
    YoutubeAddMode.playlist => source_config.YoutubePlaylistSourceConfig(
      playlist: source_config.YoutubePlaylistSourceConfig_Playlist(
        playlistId: normalized,
      ),
    ),
    YoutubeAddMode.channel => source_config.YoutubePlaylistSourceConfig(
      channel: source_config.YoutubePlaylistSourceConfig_Channel(
        channelId: normalized,
        content: switch (_channelMode) {
          YoutubeChannelMode.videos =>
            source_enum.YoutubeChannelContent.YOUTUBE_CHANNEL_CONTENT_VIDEOS,
          YoutubeChannelMode.shorts =>
            source_enum.YoutubeChannelContent.YOUTUBE_CHANNEL_CONTENT_SHORTS,
          YoutubeChannelMode.live =>
            source_enum.YoutubeChannelContent.YOUTUBE_CHANNEL_CONTENT_LIVE,
        },
      ),
    ),
    YoutubeAddMode.search => source_config.YoutubePlaylistSourceConfig(
      search: source_config.YoutubePlaylistSourceConfig_Search(
        query: normalized,
      ),
    ),
    YoutubeAddMode.subscriptions => source_config.YoutubePlaylistSourceConfig(
      subscriptions: source_config.YoutubePlaylistSourceConfig_Subscriptions(),
    ),
    YoutubeAddMode.likedVideos => source_config.YoutubePlaylistSourceConfig(
      likedVideos: source_config.YoutubePlaylistSourceConfig_LikedVideos(),
    ),
    YoutubeAddMode.watchLater => source_config.YoutubePlaylistSourceConfig(
      watchLater: source_config.YoutubePlaylistSourceConfig_WatchLater(),
    ),
    YoutubeAddMode.video => throw StateError('Expected YouTube playlist'),
  };

  Future<void> _submit() async {
    final normalized = _normalizeValue(_mode, _valueController.text);
    if (normalized == null) {
      AppNotifications.showError(context, 'Invalid YouTube source');
      return;
    }
    final request = YoutubeAddRequest(
      mode: _mode,
      channelMode: _channelMode,
      value: normalized,
      name: _nameController.text.trim(),
      shared: _shared,
      instanceName: _instanceName,
    );
    setState(() => _loading = true);
    try {
      if (widget.onSubmit case final submit?) {
        await submit(request);
      } else if (_mode == YoutubeAddMode.video) {
        final resolved =
            _resolved ??
            await providerGateway.resolveYoutube(
              normalized,
              instanceName: _instanceName,
            );
        await providerGateway.addMediaFromSourceConfig(
          widget.roomId,
          playlistId: widget.playlistId,
          sourceConfig: YoutubeSourceConfig.media(
            resolved.sourceConfig,
            _shared,
          ),
          name: request.name.isEmpty ? resolved.metadata.title : request.name,
          providerInstanceName: _instanceName,
        );
      } else {
        await providerGateway.createPlaylistFromSourceConfig(
          widget.roomId,
          sourceConfig: YoutubeSourceConfig.playlist(
            _playlistSource(normalized),
            _shared,
          ),
          name: request.name.isEmpty ? _defaultName(request) : request.name,
          parentId: widget.playlistId,
          providerInstanceName: _instanceName,
        );
      }
      if (!mounted) return;
      _valueController.clear();
      _nameController.clear();
      _resolved = null;
      _playlistPreview = null;
      widget.onDraftChanged(false);
      AppNotifications.showSuccess(context, 'YouTube source added');
      setState(() {});
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _addSelectedPreviewItems(
    List<RoomDynamicMediaEntry> items,
  ) async {
    if (items.isEmpty) return;
    setState(() => _loading = true);
    try {
      for (final item in items) {
        final config = item.mediaSourceConfig;
        if (config?.hasYoutube() != true) continue;
        await providerGateway.addMediaFromSourceConfig(
          widget.roomId,
          playlistId: widget.playlistId,
          providerInstanceName: _instanceName,
          sourceConfig: YoutubeSourceConfig.media(config!.youtube, _shared),
          name: item.name,
        );
      }
      if (!mounted) return;
      _valueController.clear();
      _nameController.clear();
      _playlistPreview = null;
      widget.onDraftChanged(false);
      AppNotifications.showSuccess(context, 'YouTube media added');
      setState(() {});
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _defaultName(YoutubeAddRequest request) => switch (request.mode) {
    YoutubeAddMode.playlist => 'YouTube Playlist',
    YoutubeAddMode.channel => 'YouTube Channel',
    YoutubeAddMode.search => 'YouTube: ${request.value}',
    YoutubeAddMode.subscriptions => 'YouTube Subscriptions',
    YoutubeAddMode.likedVideos => 'YouTube Liked Videos',
    YoutubeAddMode.watchLater => 'YouTube Watch Later',
    YoutubeAddMode.video => 'YouTube Video',
  };

  static String? _normalizeValue(YoutubeAddMode mode, String raw) {
    final value = raw.trim();
    if (mode == YoutubeAddMode.subscriptions) return 'subscriptions';
    if (mode == YoutubeAddMode.likedVideos) return 'likedVideos';
    if (mode == YoutubeAddMode.watchLater) return 'watchLater';
    if (value.isEmpty) return null;
    if (mode == YoutubeAddMode.search) return value;
    if (mode == YoutubeAddMode.channel &&
        RegExp(r'^UC[A-Za-z0-9_-]{20,}$').hasMatch(value)) {
      return value;
    }
    if (mode == YoutubeAddMode.playlist &&
        RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(value)) {
      return value;
    }
    if (mode == YoutubeAddMode.video &&
        RegExp(r'^[A-Za-z0-9_-]{11}$').hasMatch(value)) {
      return value;
    }
    final uri = Uri.tryParse(value);
    if (uri == null) return null;
    if (mode == YoutubeAddMode.channel) {
      final host = uri.host.toLowerCase();
      final segments = uri.pathSegments;
      final candidate =
          (host == 'youtube.com' || host.endsWith('.youtube.com')) &&
              segments.length >= 2 &&
              segments.first == 'channel'
          ? segments[1]
          : null;
      return candidate != null &&
              RegExp(r'^UC[A-Za-z0-9_-]{20,}$').hasMatch(candidate)
          ? candidate
          : null;
    }
    if (mode == YoutubeAddMode.playlist) return uri.queryParameters['list'];
    if (mode == YoutubeAddMode.video) {
      final candidate = uri.host.endsWith('youtu.be')
          ? uri.pathSegments.firstOrNull
          : uri.queryParameters['v'] ??
                (uri.pathSegments.length > 1 &&
                        {
                          'shorts',
                          'live',
                          'embed',
                        }.contains(uri.pathSegments.first)
                    ? uri.pathSegments[1]
                    : null);
      return candidate != null &&
              RegExp(r'^[A-Za-z0-9_-]{11}$').hasMatch(candidate)
          ? candidate
          : null;
    }
    return null;
  }

  bool get _requiresValue => switch (_mode) {
    YoutubeAddMode.video ||
    YoutubeAddMode.playlist ||
    YoutubeAddMode.channel ||
    YoutubeAddMode.search => true,
    _ => false,
  };

  bool get _valid =>
      _normalizeValue(_mode, _valueController.text) != null &&
      (!_requiresCookie || _shared || _selectedInstanceHasCookie);

  bool get _selectedInstanceHasCookie => widget.binds.any(
    (bind) => bind.providerInstanceName == _instanceName && bind.hasCookie,
  );

  bool get _requiresCookie => switch (_mode) {
    YoutubeAddMode.subscriptions ||
    YoutubeAddMode.likedVideos ||
    YoutubeAddMode.watchLater => true,
    _ => false,
  };

  static String _modeLabel(YoutubeAddMode mode) => switch (mode) {
    YoutubeAddMode.video => 'Video',
    YoutubeAddMode.playlist => 'Playlist',
    YoutubeAddMode.channel => 'Channel',
    YoutubeAddMode.search => 'Search',
    YoutubeAddMode.subscriptions => 'Subscriptions',
    YoutubeAddMode.likedVideos => 'Liked Videos',
    YoutubeAddMode.watchLater => 'Watch Later',
  };
}
