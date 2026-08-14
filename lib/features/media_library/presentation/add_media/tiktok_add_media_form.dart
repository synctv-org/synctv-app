import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/src/generated/proto/providers/tiktok.pb.dart'
    as tiktok;
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/discovery_browser.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_add_target.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_account_action.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_workspace.dart';
import 'package:synctv_app/l10n/l10n.dart';

enum TikTokAddMode { video, live, userPosts }

class TikTokAddRequest {
  const TikTokAddRequest({
    required this.target,
    required this.mode,
    required this.value,
    required this.name,
    required this.shared,
    required this.instanceName,
  });

  final ProviderAddTarget target;
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
    String? cursor,
  )?
  onListUserPosts;

  @override
  State<TikTokAddMediaForm> createState() => _TikTokAddMediaFormState();
}

class _TikTokAddMediaFormState extends State<TikTokAddMediaForm> {
  final _valueController = TextEditingController();
  final _nameController = TextEditingController();
  TikTokAddMode _mode = TikTokAddMode.video;
  ProviderAddTarget _target = ProviderAddTarget.parse;
  bool _shared = false;
  bool _loading = false;
  String _instanceName = '';
  String _selectedBindId = '';
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
    target: _target,
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

  void _nameChanged() {
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
        if (_target == ProviderAddTarget.parse) ...[
          const SizedBox(height: 12),
          SegmentedButton<TikTokAddMode>(
            segments: [
              ButtonSegment(
                value: TikTokAddMode.video,
                icon: const Icon(Icons.play_circle_outline),
                label: Text(context.l10n.video),
              ),
              ButtonSegment(
                value: TikTokAddMode.live,
                icon: const Icon(Icons.live_tv_outlined),
                label: Text(context.l10n.live),
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
        ],
        const SizedBox(height: 16),
        AppTextField(
          key: const Key('tiktok-value'),
          controller: _valueController,
          enabled: !_loading,
          label: switch (_mode) {
            TikTokAddMode.video => context.l10n.videoUrlShortLinkOrId,
            TikTokAddMode.live => context.l10n.liveUrlOrRoomId,
            TikTokAddMode.userPosts => context.l10n.usernameOrHandle,
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
        if (_target != ProviderAddTarget.media) ...[
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('tiktok-name'),
            controller: _nameController,
            enabled: !_loading,
            label: context.l10n.name,
            prefixIcon: Icons.title,
            onChanged: (_) => _nameChanged(),
          ),
        ],
        const SizedBox(height: 12),
        ProviderAccountSelector<TikTokBindInfo>(
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
            _clearPreview();
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
              key: const Key('tiktok-preview'),
              onPressed: _loading || _valueController.text.trim().isEmpty
                  ? null
                  : _loadPreview,
              icon: const Icon(Icons.preview_outlined),
              label: Text(context.l10n.preview),
            ),
            if (_target == ProviderAddTarget.parse)
              FilledButton.icon(
                key: const Key('tiktok-submit'),
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
    if (_posts != null) return _postsBrowser();
    final preview = _preview();
    return preview == null
        ? const SizedBox()
        : AppSingleChildScrollView(padding: EdgeInsets.zero, child: preview);
  }

  Widget? _preview() {
    final metadata = _resolved?.metadata;
    final imageUrl = metadata?.dynamicCover.url.isNotEmpty == true
        ? metadata!.dynamicCover.url
        : metadata?.cover.url.isNotEmpty == true
        ? metadata!.cover.url
        : null;
    final title = metadata?.title;
    if (title == null || title.isEmpty) return null;

    final details = <String>[];
    if (metadata != null) {
      if (metadata.author.nickname.isNotEmpty) {
        details.add(metadata.author.nickname);
      }
      details.add(context.l10n.variantsCount(_resolved!.variants.length));
      details.add(context.l10n.subtitlesCount(metadata.subtitles.length));
      final cleanVariants = _resolved!.variants
          .where((variant) => !variant.watermarked)
          .length;
      details.add(context.l10n.watermarkFreeCount(cleanVariants));
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

  Widget _postsBrowser() {
    final posts = _posts!;
    return DiscoveryBrowser(
      key: ValueKey('tiktok-posts:${_user?.secUid ?? ''}'),
      items: [
        for (final item in posts.items)
          DiscoveryBrowserEntry(
            key: item.videoId,
            title: item.title,
            subtitle: item.author.nickname,
            source: item.source,
            isContainer: false,
            selectable: item.hasSource(),
            leading: item.hasCover() && item.cover.url.isNotEmpty
                ? AppImageThumbnail(
                    url: item.cover.url,
                    width: 48,
                    height: 48,
                    borderRadius: BorderRadius.circular(4),
                  )
                : const Icon(Icons.play_circle_outline),
          ),
      ],
      loading: _loading,
      hasMore: posts.hasMore,
      onLoadMore: _loadMorePosts,
      onAddSelected: _target == ProviderAddTarget.media ? _addSelected : null,
      onAddCurrentList:
          _target == ProviderAddTarget.playlist && posts.hasSource()
          ? _submit
          : null,
      target: _target,
      emptyIcon: Icons.video_library_outlined,
      emptyTitle: context.l10n.noPosts,
    );
  }

  Future<tiktok.GetUserResponse> _resolveUser(TikTokAddRequest request) {
    final getUser = widget.onGetUser;
    if (getUser != null) return getUser(request);
    return providerGateway.getTikTokUser(
      request.value,
      instanceName: request.instanceName,
      shared: request.shared,
    );
  }

  Future<void> _loadPreview() async {
    setState(() => _loading = true);
    try {
      final request = _request;
      if (_mode == TikTokAddMode.userPosts) {
        _user = await _resolveUser(request);
        await _loadUserPosts();
      } else {
        final resolve = widget.onResolve;
        _resolved = resolve != null
            ? await resolve(request)
            : await providerGateway.resolveTikTok(
                request.value,
                instanceName: request.instanceName,
                shared: request.shared,
              );
      }
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadUserPosts({bool loadMore = false}) async {
    final request = _request;
    final current = _posts;
    if (loadMore && (current == null || !current.hasMore)) return;
    final secUid = _user?.secUid ?? '';
    final cursor = loadMore && current?.hasCursor() == true
        ? current!.cursor
        : null;
    final list = widget.onListUserPosts;
    final page = list != null
        ? await list(request, secUid, cursor)
        : await providerGateway.listTikTokUserPosts(
            secUid,
            cursor: cursor,
            pageSize: 20,
            instanceName: request.instanceName,
            shared: request.shared,
          );
    _posts = loadMore && current != null
        ? tiktok.ListUserPostsResponse(
            items: [...current.items, ...page.items],
            cursor: page.hasCursor() ? page.cursor : null,
            hasMore: page.hasMore,
            source: page.hasSource() ? page.source : current.source,
          )
        : page;
  }

  Future<void> _loadMorePosts() async {
    setState(() => _loading = true);
    try {
      await _loadUserPosts(loadMore: true);
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    final request = _request;
    final discovered = _target == ProviderAddTarget.playlist
        ? (_posts?.hasSource() == true ? _posts!.source : null)
        : (_resolved?.hasSource() == true ? _resolved!.source : null);
    if (discovered == null) {
      AppNotifications.showError(context, context.l10n.previewSourceFirst);
      return;
    }
    setState(() => _loading = true);
    try {
      if (widget.onSubmit case final submit?) {
        await submit(request);
      } else {
        await providerGateway.addDiscoveredSource(
          widget.roomId,
          playlistId: widget.playlistId,
          source: discovered,
          name: request.name.isEmpty
              ? (_target == ProviderAddTarget.playlist
                    ? 'TikTok ${context.l10n.posts}'
                    : _resolved!.metadata.title)
              : request.name,
        );
      }
      if (!mounted) return;
      _valueController.clear();
      _nameController.clear();
      _clearPreview();
      widget.onDraftChanged(false);
      AppNotifications.showSuccess(context, context.l10n.addedSuccessfully);
      setState(() {});
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _addSelected(List<DiscoveryBrowserEntry> entries) async {
    if (entries.isEmpty) return;
    setState(() => _loading = true);
    try {
      for (final entry in entries) {
        await providerGateway.addDiscoveredSource(
          widget.roomId,
          playlistId: widget.playlistId,
          source: entry.source,
          name: entry.title,
        );
      }
      if (!mounted) return;
      _valueController.clear();
      _nameController.clear();
      _clearPreview();
      widget.onDraftChanged(false);
      AppNotifications.showSuccess(context, context.l10n.addedSuccessfully);
      setState(() {});
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool get _previewReady => _resolved?.hasSource() == true;

  void _selectTarget(ProviderAddTarget target) {
    if (target == _target) return;
    _target = target;
    _mode = target == ProviderAddTarget.parse
        ? TikTokAddMode.video
        : TikTokAddMode.userPosts;
    _valueController.clear();
    _nameController.clear();
    _changed();
  }
}
