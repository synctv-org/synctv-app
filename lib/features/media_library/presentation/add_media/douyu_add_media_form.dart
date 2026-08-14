import 'package:flutter/material.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/src/generated/proto/providers/douyu.pb.dart'
    as douyu;
import 'package:synctv_app/src/generated/proto/providers/douyu.pbenum.dart'
    as douyu_enum;
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_workspace.dart';
import 'package:synctv_app/l10n/l10n.dart';

class DouyuAddRequest {
  const DouyuAddRequest({
    required this.resource,
    required this.name,
    required this.instanceName,
  });

  final String resource;
  final String name;
  final String instanceName;
}

class DouyuAddMediaForm extends StatefulWidget {
  const DouyuAddMediaForm({
    super.key,
    required this.roomId,
    required this.playlistId,
    required this.instances,
    required this.onDraftChanged,
    this.onResolve,
    this.onSubmit,
  });

  final String roomId;
  final String playlistId;
  final List<String> instances;
  final ValueChanged<bool> onDraftChanged;
  final Future<douyu.ResolveResponse> Function(String resource)? onResolve;
  final Future<void> Function(DouyuAddRequest request)? onSubmit;

  @override
  State<DouyuAddMediaForm> createState() => _DouyuAddMediaFormState();
}

class _DouyuAddMediaFormState extends State<DouyuAddMediaForm> {
  final _resourceController = TextEditingController();
  final _nameController = TextEditingController();
  String _instanceName = '';
  bool _loading = false;
  douyu.ResolveResponse? _resolved;

  @override
  void dispose() {
    _resourceController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _changed() {
    _resolved = null;
    widget.onDraftChanged(
      _resourceController.text.trim().isNotEmpty ||
          _nameController.text.trim().isNotEmpty,
    );
    setState(() {});
  }

  void _nameChanged() {
    widget.onDraftChanged(
      _resourceController.text.trim().isNotEmpty ||
          _nameController.text.trim().isNotEmpty,
    );
    setState(() {});
  }

  DouyuAddRequest get _request => DouyuAddRequest(
    resource: _resourceController.text.trim(),
    name: _nameController.text.trim(),
    instanceName: _instanceName,
  );

  @override
  Widget build(BuildContext context) {
    final instances = {'', ...widget.instances}.toList();
    if (!instances.contains(_instanceName)) _instanceName = '';
    final controls = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          key: const Key('douyu-resource'),
          controller: _resourceController,
          enabled: !_loading,
          label: context.l10n.roomIdAliasOrUrl,
          prefixIcon: Icons.live_tv_outlined,
          onChanged: (_) => _changed(),
        ),
        const SizedBox(height: 12),
        AppTextField(
          key: const Key('douyu-name'),
          controller: _nameController,
          enabled: !_loading,
          label: context.l10n.name,
          prefixIcon: Icons.title,
          onChanged: (_) => _nameChanged(),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _instanceName,
          decoration: InputDecoration(
            labelText: context.l10n.providerInstance,
            prefixIcon: const Icon(Icons.dns_outlined),
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
                }),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              key: const Key('douyu-preview'),
              onPressed: _loading || _resourceController.text.trim().isEmpty
                  ? null
                  : _loadPreview,
              icon: const Icon(Icons.preview_outlined),
              label: Text(context.l10n.preview),
            ),
            const SizedBox(width: 10),
            FilledButton.icon(
              key: const Key('douyu-submit'),
              onPressed: _loading || _resolved?.hasSource() != true
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
              label: Text(context.l10n.addMedia),
            ),
          ],
        ),
      ],
    );
    return ProviderWorkspace(controls: controls, results: _buildResults());
  }

  Widget _buildResults() {
    final preview = _preview();
    return preview == null
        ? const SizedBox()
        : AppSingleChildScrollView(padding: EdgeInsets.zero, child: preview);
  }

  Widget? _preview() {
    final response = _resolved;
    if (response == null || !response.hasMetadata()) return null;
    final metadata = response.metadata;
    final formats = response.qualities
        .map((quality) => _formatName(quality.format))
        .where((value) => value.isNotEmpty)
        .toSet()
        .join('/');
    final codecs = response.qualities
        .map((quality) => _codecName(quality.codec))
        .where((value) => value.isNotEmpty)
        .toSet()
        .join('/');
    final cdns = response.qualities
        .map((quality) => quality.cdn)
        .where((value) => value.isNotEmpty)
        .toSet()
        .length;
    final details = <String>[
      if (metadata.author.isNotEmpty) metadata.author,
      if (metadata.hasCategory()) metadata.category,
      metadata.isReplay ? 'Replay' : (metadata.isLive ? 'Live' : 'Offline'),
      if (metadata.isVip) 'VIP',
      '${response.qualities.length} qualities',
      if (codecs.isNotEmpty) codecs,
      if (formats.isNotEmpty) formats,
      if (cdns > 0) '$cdns CDNs',
      if (metadata.hasViewerCount()) '${metadata.viewerCount} viewers',
    ];
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (metadata.hasThumbnailUrl() && metadata.thumbnailUrl.isNotEmpty)
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
                    maxLines: 3,
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

  String _formatName(douyu_enum.StreamFormat value) => switch (value) {
    douyu_enum.StreamFormat.STREAM_FORMAT_FLV => 'FLV',
    douyu_enum.StreamFormat.STREAM_FORMAT_HLS => 'HLS',
    _ => '',
  };

  String _codecName(douyu_enum.Codec value) => switch (value) {
    douyu_enum.Codec.CODEC_AVC => 'AVC',
    douyu_enum.Codec.CODEC_HEVC => 'HEVC',
    douyu_enum.Codec.CODEC_AAC => 'AAC',
    _ => '',
  };

  Future<void> _loadPreview() async {
    setState(() => _loading = true);
    try {
      _resolved =
          await (widget.onResolve?.call(_request.resource) ??
              providerGateway.resolveDouyu(
                _request.resource,
                instanceName: _instanceName,
              ));
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    final resolved = _resolved;
    if (resolved == null) {
      AppNotifications.showError(context, context.l10n.previewSourceFirst);
      return;
    }
    setState(() => _loading = true);
    try {
      final request = _request;
      if (widget.onSubmit case final submit?) {
        await submit(request);
      } else {
        await providerGateway.addDiscoveredSource(
          widget.roomId,
          playlistId: widget.playlistId,
          source: resolved.source,
          name: request.name.isEmpty ? resolved.metadata.title : request.name,
        );
      }
      if (!mounted) return;
      _resourceController.clear();
      _nameController.clear();
      _resolved = null;
      widget.onDraftChanged(false);
      AppNotifications.showSuccess(context, context.l10n.addedSuccessfully);
      setState(() {});
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
