import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/src/generated/proto/providers/youtube.pb.dart'
    as youtube;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/youtube_playlist_preview.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_add_target.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_account_action.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_workspace.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';

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
    this.onList,
  });

  final String roomId;
  final String playlistId;
  final List<YoutubeBindInfo> binds;
  final ValueChanged<bool> onDraftChanged;
  final Future<void> Function(YoutubeAddRequest request)? onSubmit;
  final Future<youtube.ResolveResponse> Function(YoutubeAddRequest request)?
  onResolve;
  final Future<youtube.ListResponse> Function(youtube.ListRequest request)?
  onList;

  @override
  State<YoutubeAddMediaForm> createState() => _YoutubeAddMediaFormState();
}

class _YoutubeAddMediaFormState extends State<YoutubeAddMediaForm> {
  final _valueController = TextEditingController();
  final _nameController = TextEditingController();
  YoutubeAddMode _mode = YoutubeAddMode.video;
  ProviderAddTarget _target = ProviderAddTarget.parse;
  YoutubeChannelMode _channelMode = YoutubeChannelMode.videos;
  bool _shared = false;
  bool _loading = false;
  String _instanceName = '';
  String _selectedBindId = '';
  youtube.ResolveResponse? _resolved;
  youtube.ListResponse? _listPreview;

  @override
  void dispose() {
    _valueController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _changed() {
    _resolved = null;
    _listPreview = null;
    widget.onDraftChanged(
      _valueController.text.trim().isNotEmpty ||
          _nameController.text.trim().isNotEmpty,
    );
    setState(() {});
  }

  void _nameChanged() {
    widget.onDraftChanged(
      _valueController.text.trim().isNotEmpty ||
          _nameController.text.trim().isNotEmpty,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedBindId.isNotEmpty &&
        !widget.binds.any((bind) => bind.id == _selectedBindId)) {
      _selectedBindId = '';
      _instanceName = '';
    }
    final controls = <Widget>[
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
        DropdownButtonFormField<YoutubeAddMode>(
          key: const Key('youtube-mode'),
          initialValue: _mode,
          decoration: InputDecoration(
            labelText: context.l10n.source,
            prefixIcon: const Icon(Icons.video_library_outlined),
          ),
          items: _listModes
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
                  if (mode == null || mode == _mode) return;
                  _mode = mode;
                  _valueController.clear();
                  _changed();
                },
        ),
      ],
      if (_requiresValue) ...[
        const SizedBox(height: 16),
        AppTextField(
          key: const Key('youtube-value'),
          controller: _valueController,
          enabled: !_loading,
          label: switch (_mode) {
            YoutubeAddMode.video => context.l10n.videoUrlOrId,
            YoutubeAddMode.playlist => context.l10n.playlistUrlOrId,
            YoutubeAddMode.channel => context.l10n.channelUrlOrId,
            YoutubeAddMode.search => context.l10n.searchQueryLabel,
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
          segments: [
            ButtonSegment(
              value: YoutubeChannelMode.videos,
              icon: const Icon(Icons.ondemand_video_outlined),
              label: Text(context.l10n.videos),
            ),
            ButtonSegment(
              value: YoutubeChannelMode.shorts,
              icon: const Icon(Icons.smartphone_outlined),
              label: Text(context.l10n.shorts),
            ),
            ButtonSegment(
              value: YoutubeChannelMode.live,
              icon: const Icon(Icons.live_tv_outlined),
              label: Text(context.l10n.live),
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
      if (_target != ProviderAddTarget.media) ...[
        const SizedBox(height: 12),
        AppTextField(
          key: const Key('youtube-name'),
          controller: _nameController,
          enabled: !_loading,
          label: context.l10n.name,
          prefixIcon: Icons.title,
          onChanged: (_) => _nameChanged(),
        ),
      ],
      const SizedBox(height: 12),
      ProviderAccountSelector<YoutubeBindInfo>(
        accounts: widget.binds,
        selectedId: _selectedBindId,
        idOf: (bind) => bind.id,
        labelOf: (bind) {
          final label = bind.label.isEmpty
              ? context.l10n.defaultProviderInstance
              : bind.label;
          return bind.providerInstanceName.isEmpty
              ? label
              : '$label · ${bind.providerInstanceName}';
        },
        includeDefault: true,
        enabled: !_loading,
        onChanged: (bind) => setState(() {
          _selectedBindId = bind?.id ?? '';
          _instanceName = bind?.providerInstanceName ?? '';
          _resolved = null;
          _listPreview = null;
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
                _resolved = null;
                _listPreview = null;
              }),
      ),
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
            label: Text(context.l10n.preview),
          ),
          if (_target != ProviderAddTarget.media)
            FilledButton.icon(
              key: const Key('youtube-submit'),
              onPressed: _loading || !_valid || !_previewReady ? null : _submit,
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
                _target == ProviderAddTarget.parse
                    ? context.l10n.addMedia
                    : context.l10n.addCurrentList,
              ),
            ),
        ],
      ),
    ];
    return ProviderWorkspace(
      controls: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: controls,
      ),
      results: _buildResults(context),
    );
  }

  Widget _buildResults(BuildContext context) {
    if (_listPreview case final preview?) {
      return YoutubePlaylistPreview(
        items: preview.items,
        loading: _loading,
        hasMore: _playlistPreviewHasMore,
        onLoadMore: () => _loadPreview(loadMore: true),
        selectionEnabled: _target == ProviderAddTarget.media,
        onAddSelected: _target == ProviderAddTarget.media
            ? _addSelectedPreviewItems
            : null,
      );
    }
    if (_resolved case final resolved?) {
      return AppSingleChildScrollView(child: _preview(resolved));
    }
    return const SizedBox();
  }

  Widget _preview(youtube.ResolveResponse resolved) {
    final metadata = resolved.metadata;
    final details = <String>[
      if (metadata.channelName.isNotEmpty) metadata.channelName,
      context.l10n.formatsCount(resolved.formats.length),
      context.l10n.subtitlesCount(resolved.subtitles.length),
      if (metadata.isLive) context.l10n.live,
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
    return _listPreview?.hasMore == true;
  }

  Future<void> _loadPreview({bool loadMore = false}) async {
    final value = _inputValue;
    if (value == null) {
      AppNotifications.showError(context, context.l10n.completeAllFields);
      return;
    }
    final request = YoutubeAddRequest(
      mode: _mode,
      channelMode: _channelMode,
      value: value,
      name: _nameController.text.trim(),
      shared: _shared,
      instanceName: _instanceName,
    );
    final current = _listPreview;
    if (loadMore && (current == null || !_playlistPreviewHasMore)) return;
    setState(() => _loading = true);
    try {
      if (_mode == YoutubeAddMode.video) {
        final resolve = widget.onResolve;
        _resolved = resolve != null
            ? await resolve(request)
            : await providerGateway.resolveYoutube(
                value,
                instanceName: _instanceName,
                shared: _shared,
              );
      } else {
        final listRequest = _listRequest(
          value,
          cursor: loadMore && current?.hasCursor() == true
              ? current!.cursor
              : null,
        );
        final page =
            await (widget.onList?.call(listRequest) ??
                providerGateway.listYoutube(listRequest));
        _listPreview = loadMore && current != null
            ? youtube.ListResponse(
                items: [...current.items, ...page.items],
                cursor: page.hasCursor() ? page.cursor : null,
                hasMore: page.hasMore,
                source: page.hasSource() ? page.source : current.source,
              )
            : page;
      }
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  youtube.ListRequest _listRequest(
    String value, {
    String? cursor,
  }) => switch (_mode) {
    YoutubeAddMode.playlist => youtube.ListRequest(
      playlist: youtube.ListRequest_Playlist(resource: value),
      cursor: cursor,
      instanceName: _instanceName,
      shared: _shared,
    ),
    YoutubeAddMode.channel => youtube.ListRequest(
      channel: youtube.ListRequest_Channel(
        resource: value,
        content: switch (_channelMode) {
          YoutubeChannelMode.videos =>
            source_enum.YoutubeChannelContent.YOUTUBE_CHANNEL_CONTENT_VIDEOS,
          YoutubeChannelMode.shorts =>
            source_enum.YoutubeChannelContent.YOUTUBE_CHANNEL_CONTENT_SHORTS,
          YoutubeChannelMode.live =>
            source_enum.YoutubeChannelContent.YOUTUBE_CHANNEL_CONTENT_LIVE,
        },
      ),
      cursor: cursor,
      instanceName: _instanceName,
      shared: _shared,
    ),
    YoutubeAddMode.search => youtube.ListRequest(
      search: youtube.ListRequest_Search(query: value),
      cursor: cursor,
      instanceName: _instanceName,
      shared: _shared,
    ),
    YoutubeAddMode.subscriptions => youtube.ListRequest(
      subscriptions: youtube.ListRequest_Subscriptions(),
      cursor: cursor,
      instanceName: _instanceName,
      shared: _shared,
    ),
    YoutubeAddMode.likedVideos => youtube.ListRequest(
      likedVideos: youtube.ListRequest_LikedVideos(),
      cursor: cursor,
      instanceName: _instanceName,
      shared: _shared,
    ),
    YoutubeAddMode.watchLater => youtube.ListRequest(
      watchLater: youtube.ListRequest_WatchLater(),
      cursor: cursor,
      instanceName: _instanceName,
      shared: _shared,
    ),
    YoutubeAddMode.video => throw StateError('Expected YouTube list'),
  };

  Future<void> _submit() async {
    final value = _inputValue;
    if (value == null || !_previewReady) {
      AppNotifications.showError(context, context.l10n.previewSourceFirst);
      return;
    }
    final request = YoutubeAddRequest(
      mode: _mode,
      channelMode: _channelMode,
      value: value,
      name: _nameController.text.trim(),
      shared: _shared,
      instanceName: _instanceName,
    );
    setState(() => _loading = true);
    try {
      if (widget.onSubmit case final submit?) {
        await submit(request);
      } else if (_mode == YoutubeAddMode.video) {
        final resolved = _resolved!;
        await providerGateway.addDiscoveredSource(
          widget.roomId,
          playlistId: widget.playlistId,
          source: resolved.source,
          name: request.name.isEmpty ? resolved.metadata.title : request.name,
        );
      } else {
        await providerGateway.addDiscoveredSource(
          widget.roomId,
          source: _listPreview!.source,
          name: request.name.isEmpty ? _defaultName(request) : request.name,
          playlistId: widget.playlistId,
        );
      }
      if (!mounted) return;
      _valueController.clear();
      _nameController.clear();
      _resolved = null;
      _listPreview = null;
      widget.onDraftChanged(false);
      AppNotifications.showSuccess(context, context.l10n.addedSuccessfully);
      setState(() {});
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _addSelectedPreviewItems(List<youtube.ListItem> items) async {
    if (items.isEmpty) return;
    setState(() => _loading = true);
    try {
      for (final item in items) {
        if (!item.hasSource()) continue;
        await providerGateway.addDiscoveredSource(
          widget.roomId,
          playlistId: widget.playlistId,
          source: item.source,
          name: item.title,
        );
      }
      if (!mounted) return;
      _valueController.clear();
      _nameController.clear();
      _listPreview = null;
      widget.onDraftChanged(false);
      AppNotifications.showSuccess(context, context.l10n.addedSuccessfully);
      setState(() {});
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _defaultName(YoutubeAddRequest request) => switch (request.mode) {
    YoutubeAddMode.playlist => 'YouTube ${context.l10n.playlist}',
    YoutubeAddMode.channel => 'YouTube ${context.l10n.channel}',
    YoutubeAddMode.search => 'YouTube: ${request.value}',
    YoutubeAddMode.subscriptions => 'YouTube ${context.l10n.subscriptions}',
    YoutubeAddMode.likedVideos => 'YouTube ${context.l10n.likedVideos}',
    YoutubeAddMode.watchLater => 'YouTube ${context.l10n.watchLater}',
    YoutubeAddMode.video => 'YouTube ${context.l10n.video}',
  };

  String? get _inputValue {
    if (!_requiresValue) return '';
    final value = _valueController.text.trim();
    return value.isEmpty ? null : value;
  }

  bool get _requiresValue => switch (_mode) {
    YoutubeAddMode.video ||
    YoutubeAddMode.playlist ||
    YoutubeAddMode.channel ||
    YoutubeAddMode.search => true,
    _ => false,
  };

  bool get _valid =>
      _inputValue != null &&
      (!_requiresCookie || _shared || _selectedInstanceHasCookie);

  bool get _previewReady => _mode == YoutubeAddMode.video
      ? _resolved?.hasSource() == true
      : _listPreview?.hasSource() == true;

  bool get _selectedInstanceHasCookie => widget.binds.any(
    (bind) => bind.providerInstanceName == _instanceName && bind.hasCookie,
  );

  bool get _requiresCookie => switch (_mode) {
    YoutubeAddMode.subscriptions ||
    YoutubeAddMode.likedVideos ||
    YoutubeAddMode.watchLater => true,
    _ => false,
  };

  List<YoutubeAddMode> get _listModes => const [
    YoutubeAddMode.playlist,
    YoutubeAddMode.channel,
    YoutubeAddMode.search,
    YoutubeAddMode.subscriptions,
    YoutubeAddMode.likedVideos,
    YoutubeAddMode.watchLater,
  ];

  void _selectTarget(ProviderAddTarget target) {
    if (target == _target) return;
    _target = target;
    _mode = target == ProviderAddTarget.parse
        ? YoutubeAddMode.video
        : YoutubeAddMode.playlist;
    _valueController.clear();
    _nameController.clear();
    _changed();
  }

  String _modeLabel(YoutubeAddMode mode) => switch (mode) {
    YoutubeAddMode.video => context.l10n.video,
    YoutubeAddMode.playlist => context.l10n.playlist,
    YoutubeAddMode.channel => context.l10n.channel,
    YoutubeAddMode.search => context.l10n.search,
    YoutubeAddMode.subscriptions => context.l10n.subscriptions,
    YoutubeAddMode.likedVideos => context.l10n.likedVideos,
    YoutubeAddMode.watchLater => context.l10n.watchLater,
  };
}
