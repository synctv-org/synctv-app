import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/contracts/douyin_source_config.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/src/generated/proto/providers/douyin.pb.dart'
    as douyin;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

enum DouyinAddMode { video, live, userPosts }

class DouyinAddRequest {
  const DouyinAddRequest({
    required this.mode,
    required this.value,
    required this.name,
    required this.shared,
    required this.instanceName,
  });

  final DouyinAddMode mode;
  final String value;
  final String name;
  final bool shared;
  final String instanceName;
}

class DouyinAddMediaForm extends StatefulWidget {
  const DouyinAddMediaForm({
    super.key,
    required this.roomId,
    required this.playlistId,
    required this.binds,
    required this.onDraftChanged,
    this.onSubmit,
    this.onResolve,
    this.onListUserPosts,
  });

  final String roomId;
  final String playlistId;
  final List<DouyinBindInfo> binds;
  final ValueChanged<bool> onDraftChanged;
  final Future<void> Function(DouyinAddRequest request)? onSubmit;
  final Future<douyin.ResolveResponse> Function(DouyinAddRequest request)?
  onResolve;
  final Future<douyin.ListUserPostsResponse> Function(DouyinAddRequest request)?
  onListUserPosts;

  @override
  State<DouyinAddMediaForm> createState() => _DouyinAddMediaFormState();
}

class _DouyinAddMediaFormState extends State<DouyinAddMediaForm> {
  final _valueController = TextEditingController();
  final _nameController = TextEditingController();
  DouyinAddMode _mode = DouyinAddMode.video;
  bool _shared = false;
  bool _loading = false;
  String _instanceName = '';
  douyin.ResolveResponse? _resolved;
  douyin.ListUserPostsResponse? _posts;

  @override
  void dispose() {
    _valueController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _changed() {
    _resolved = null;
    _posts = null;
    widget.onDraftChanged(
      _valueController.text.trim().isNotEmpty ||
          _nameController.text.trim().isNotEmpty,
    );
    setState(() {});
  }

  DouyinAddRequest get _request => DouyinAddRequest(
    mode: _mode,
    value: _valueController.text.trim(),
    name: _nameController.text.trim(),
    shared: _shared,
    instanceName: _instanceName,
  );

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
          SegmentedButton<DouyinAddMode>(
            segments: const [
              ButtonSegment(
                value: DouyinAddMode.video,
                icon: Icon(Icons.play_circle_outline),
                label: Text('Video'),
              ),
              ButtonSegment(
                value: DouyinAddMode.live,
                icon: Icon(Icons.live_tv_outlined),
                label: Text('Live'),
              ),
              ButtonSegment(
                value: DouyinAddMode.userPosts,
                icon: Icon(Icons.video_library_outlined),
                label: Text('Posts'),
              ),
            ],
            selected: {_mode},
            onSelectionChanged: _loading
                ? null
                : (values) {
                    final mode = values.first;
                    if (mode == _mode) return;
                    _mode = mode;
                    _valueController.clear();
                    _changed();
                  },
          ),
          const SizedBox(height: 16),
          AppTextField(
            key: const Key('douyin-value'),
            controller: _valueController,
            enabled: !_loading,
            label: switch (_mode) {
              DouyinAddMode.video => 'Video URL, short link, or aweme ID',
              DouyinAddMode.live => 'Live URL or web_rid',
              DouyinAddMode.userPosts => 'Author sec_uid',
            },
            prefixIcon: switch (_mode) {
              DouyinAddMode.video => Icons.music_video_outlined,
              DouyinAddMode.live => Icons.live_tv_outlined,
              DouyinAddMode.userPosts => Icons.person_search_outlined,
            },
            keyboardType: _mode == DouyinAddMode.userPosts
                ? TextInputType.text
                : TextInputType.url,
            onChanged: (_) => _changed(),
          ),
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('douyin-name'),
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
                    _posts = null;
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
                  }),
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
                key: const Key('douyin-preview'),
                onPressed: _loading || _valueController.text.trim().isEmpty
                    ? null
                    : _loadPreview,
                icon: const Icon(Icons.preview_outlined),
                label: const Text('Preview'),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                key: const Key('douyin-submit'),
                onPressed: _loading || _valueController.text.trim().isEmpty
                    ? null
                    : _submit,
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
                  _mode == DouyinAddMode.userPosts
                      ? 'Create playlist'
                      : 'Add media',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget? _preview() {
    final metadata = _resolved?.metadata;
    final post = _posts?.items.firstOrNull;
    final imageUrl = metadata?.dynamicCover.url.isNotEmpty == true
        ? metadata!.dynamicCover.url
        : metadata?.cover.url.isNotEmpty == true
        ? metadata!.cover.url
        : post?.cover.url;
    final title = metadata?.title ?? post?.title;
    if (title == null || title.isEmpty) return null;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (imageUrl != null && imageUrl.isNotEmpty)
            AppImageThumbnail(
              url: imageUrl,
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
                  Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  if (metadata != null)
                    Text(
                      '${metadata.author.nickname} · ${_resolved!.variants.length} variants',
                      maxLines: 1,
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

  Future<void> _loadPreview() async {
    setState(() => _loading = true);
    try {
      final request = _request;
      if (_mode == DouyinAddMode.userPosts) {
        final list = widget.onListUserPosts;
        _posts = list != null
            ? await list(request)
            : await providerGateway.listDouyinUserPosts(
                request.value,
                pageSize: 1,
                instanceName: request.instanceName,
              );
      } else {
        final resolve = widget.onResolve;
        _resolved = resolve != null
            ? await resolve(request)
            : await providerGateway.resolveDouyin(
                request.value,
                instanceName: request.instanceName,
              );
      }
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    final request = _request;
    setState(() => _loading = true);
    try {
      if (widget.onSubmit case final submit?) {
        await submit(request);
      } else if (_mode == DouyinAddMode.userPosts) {
        final source = _posts?.hasSourceConfig() == true
            ? _posts!.sourceConfig
            : source_config.DouyinPlaylistSourceConfig(secUid: request.value);
        await providerGateway.createPlaylistFromSourceConfig(
          widget.roomId,
          sourceConfig: DouyinSourceConfig.playlist(source, request.shared),
          name: request.name.isEmpty ? 'Douyin posts' : request.name,
          parentId: widget.playlistId,
          providerInstanceName: request.instanceName,
        );
      } else {
        final resolved =
            _resolved ??
            await providerGateway.resolveDouyin(
              request.value,
              instanceName: request.instanceName,
            );
        await providerGateway.addMediaFromSourceConfig(
          widget.roomId,
          playlistId: widget.playlistId,
          sourceConfig: DouyinSourceConfig.media(
            resolved.sourceConfig,
            request.shared,
          ),
          name: request.name.isEmpty ? resolved.metadata.title : request.name,
          providerInstanceName: request.instanceName,
        );
      }
      if (!mounted) return;
      _valueController.clear();
      _nameController.clear();
      _resolved = null;
      _posts = null;
      widget.onDraftChanged(false);
      AppNotifications.showSuccess(context, 'Douyin source added');
      setState(() {});
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
