import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/contracts/tiktok_source_config.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/src/generated/proto/providers/tiktok.pb.dart'
    as tiktok;
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

enum TikTokAddMode { video, live, userPosts }

class TikTokAddRequest {
  const TikTokAddRequest({
    required this.mode,
    required this.value,
    required this.name,
    required this.shared,
    required this.instanceName,
  });

  final TikTokAddMode mode;
  final String value;
  final String name;
  final bool shared;
  final String instanceName;
}

class TikTokAddMediaForm extends StatefulWidget {
  const TikTokAddMediaForm({
    super.key,
    required this.roomId,
    required this.playlistId,
    required this.binds,
    required this.onDraftChanged,
    this.onSubmit,
    this.onResolve,
    this.onGetUser,
    this.onListUserPosts,
  });

  final String roomId;
  final String playlistId;
  final List<TikTokBindInfo> binds;
  final ValueChanged<bool> onDraftChanged;
  final Future<void> Function(TikTokAddRequest request)? onSubmit;
  final Future<tiktok.ResolveResponse> Function(TikTokAddRequest request)?
  onResolve;
  final Future<tiktok.GetUserResponse> Function(TikTokAddRequest request)?
  onGetUser;
  final Future<tiktok.ListUserPostsResponse> Function(
    TikTokAddRequest request,
    String secUid,
  )?
  onListUserPosts;

  @override
  State<TikTokAddMediaForm> createState() => _TikTokAddMediaFormState();
}

class _TikTokAddMediaFormState extends State<TikTokAddMediaForm> {
  final _valueController = TextEditingController();
  final _nameController = TextEditingController();
  TikTokAddMode _mode = TikTokAddMode.video;
  bool _shared = false;
  bool _loading = false;
  String _instanceName = '';
  tiktok.ResolveResponse? _resolved;
  tiktok.GetUserResponse? _user;
  tiktok.ListUserPostsResponse? _posts;

  @override
  void dispose() {
    _valueController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  TikTokAddRequest get _request => TikTokAddRequest(
    mode: _mode,
    value: _valueController.text.trim(),
    name: _nameController.text.trim(),
    shared: _shared,
    instanceName: _instanceName,
  );

  void _changed() {
    _clearPreview();
    widget.onDraftChanged(
      _valueController.text.trim().isNotEmpty ||
          _nameController.text.trim().isNotEmpty,
    );
    setState(() {});
  }

  void _clearPreview() {
    _resolved = null;
    _user = null;
    _posts = null;
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
          SegmentedButton<TikTokAddMode>(
            segments: const [
              ButtonSegment(
                value: TikTokAddMode.video,
                icon: Icon(Icons.play_circle_outline),
                label: Text('Video'),
              ),
              ButtonSegment(
                value: TikTokAddMode.live,
                icon: Icon(Icons.live_tv_outlined),
                label: Text('Live'),
              ),
              ButtonSegment(
                value: TikTokAddMode.userPosts,
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
            key: const Key('tiktok-value'),
            controller: _valueController,
            enabled: !_loading,
            label: switch (_mode) {
              TikTokAddMode.video => 'Video URL, short link, or video ID',
              TikTokAddMode.live => 'Live URL or @username',
              TikTokAddMode.userPosts => '@username or username',
            },
            prefixIcon: switch (_mode) {
              TikTokAddMode.video => Icons.music_video_outlined,
              TikTokAddMode.live => Icons.live_tv_outlined,
              TikTokAddMode.userPosts => Icons.person_search_outlined,
            },
            keyboardType: _mode == TikTokAddMode.userPosts
                ? TextInputType.text
                : TextInputType.url,
            onChanged: (_) => _changed(),
          ),
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('tiktok-name'),
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
                    _clearPreview();
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
                key: const Key('tiktok-preview'),
                onPressed: _loading || _valueController.text.trim().isEmpty
                    ? null
                    : _loadPreview,
                icon: const Icon(Icons.preview_outlined),
                label: const Text('Preview'),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                key: const Key('tiktok-submit'),
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
                  _mode == TikTokAddMode.userPosts
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

    final details = <String>[];
    if (metadata != null) {
      if (metadata.author.nickname.isNotEmpty) {
        details.add(metadata.author.nickname);
      }
      details.add('${_resolved!.variants.length} variants');
      details.add('${metadata.subtitles.length} subtitles');
      final cleanVariants = _resolved!.variants
          .where((variant) => !variant.watermarked)
          .length;
      details.add('$cleanVariants watermark-free');
    } else if (_user?.secUid.isNotEmpty == true) {
      details.add('@${_request.value.replaceFirst(RegExp(r'^@'), '')}');
    }

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
                  if (details.isNotEmpty)
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

  Future<tiktok.GetUserResponse> _resolveUser(TikTokAddRequest request) {
    final getUser = widget.onGetUser;
    if (getUser != null) return getUser(request);
    return providerGateway.getTikTokUser(
      request.value.replaceFirst(RegExp(r'^@'), ''),
      instanceName: request.instanceName,
    );
  }

  Future<void> _loadPreview() async {
    setState(() => _loading = true);
    try {
      final request = _request;
      if (_mode == TikTokAddMode.userPosts) {
        _user = await _resolveUser(request);
        final list = widget.onListUserPosts;
        _posts = list != null
            ? await list(request, _user!.secUid)
            : await providerGateway.listTikTokUserPosts(
                _user!.secUid,
                pageSize: 1,
                instanceName: request.instanceName,
              );
      } else {
        final resolve = widget.onResolve;
        _resolved = resolve != null
            ? await resolve(request)
            : await providerGateway.resolveTikTok(
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
      } else if (_mode == TikTokAddMode.userPosts) {
        final user = _user ?? await _resolveUser(request);
        await providerGateway.createPlaylistFromSourceConfig(
          widget.roomId,
          sourceConfig: TikTokSourceConfig.playlist(
            user.sourceConfig,
            request.shared,
          ),
          name: request.name.isEmpty ? 'TikTok posts' : request.name,
          parentId: widget.playlistId,
          providerInstanceName: request.instanceName,
        );
      } else {
        final resolved =
            _resolved ??
            await providerGateway.resolveTikTok(
              request.value,
              instanceName: request.instanceName,
            );
        await providerGateway.addMediaFromSourceConfig(
          widget.roomId,
          playlistId: widget.playlistId,
          sourceConfig: TikTokSourceConfig.media(
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
      _clearPreview();
      widget.onDraftChanged(false);
      AppNotifications.showSuccess(context, 'TikTok source added');
      setState(() {});
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
