import 'package:flutter/material.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/src/generated/proto/providers/huya.pb.dart' as huya;
import 'package:synctv_app/src/generated/proto/providers/huya.pbenum.dart'
    as huya_enum;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class HuyaAddRequest {
  const HuyaAddRequest({
    required this.resource,
    required this.name,
    required this.instanceName,
  });

  final String resource;
  final String name;
  final String instanceName;
}

class HuyaAddMediaForm extends StatefulWidget {
  const HuyaAddMediaForm({
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
  final Future<huya.ResolveResponse> Function(String resource)? onResolve;
  final Future<void> Function(HuyaAddRequest request)? onSubmit;

  @override
  State<HuyaAddMediaForm> createState() => _HuyaAddMediaFormState();
}

class _HuyaAddMediaFormState extends State<HuyaAddMediaForm> {
  final _resourceController = TextEditingController();
  final _nameController = TextEditingController();
  String _instanceName = '';
  bool _loading = false;
  huya.ResolveResponse? _resolved;

  @override
  void dispose() {
    _resourceController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  HuyaAddRequest get _request => HuyaAddRequest(
    resource: _resourceController.text.trim(),
    name: _nameController.text.trim(),
    instanceName: _instanceName,
  );

  void _changed() {
    _resolved = null;
    widget.onDraftChanged(
      _resourceController.text.trim().isNotEmpty ||
          _nameController.text.trim().isNotEmpty,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final instances = {'', ...widget.instances}.toList();
    if (!instances.contains(_instanceName)) _instanceName = '';
    return AppSingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            key: const Key('huya-resource'),
            controller: _resourceController,
            enabled: !_loading,
            label: 'Live room or video URL',
            prefixIcon: Icons.link_outlined,
            keyboardType: TextInputType.url,
            enableSuggestions: false,
            autocorrect: false,
            onChanged: (_) => _changed(),
          ),
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('huya-name'),
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
                : (value) => setState(() => _instanceName = value ?? ''),
          ),
          if (_preview() case final preview?) ...[
            const SizedBox(height: 12),
            preview,
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                key: const Key('huya-preview'),
                onPressed: _loading || _resourceController.text.trim().isEmpty
                    ? null
                    : _loadPreview,
                icon: const Icon(Icons.preview_outlined),
                label: const Text('Preview'),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                key: const Key('huya-submit'),
                onPressed: _loading || _resourceController.text.trim().isEmpty
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
                label: const Text('Add media'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget? _preview() {
    final response = _resolved;
    if (response == null || !response.hasMetadata()) return null;
    final metadata = response.metadata;
    final formats = response.qualities
        .map((quality) => _formatName(quality.format))
        .toSet()
        .join('/');
    final cdns = response.qualities
        .map((quality) => quality.cdn)
        .where((cdn) => cdn.isNotEmpty)
        .toSet()
        .length;
    final details = <String>[
      if (metadata.author.isNotEmpty) metadata.author,
      if (metadata.hasCategory()) metadata.category,
      metadata.isLive ? 'Live' : 'Video',
      '${response.qualities.length} qualities',
      if (formats.isNotEmpty) formats,
      if (cdns > 0) '$cdns CDNs',
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

  String _formatName(huya_enum.StreamFormat format) => switch (format) {
    huya_enum.StreamFormat.STREAM_FORMAT_FLV => 'FLV',
    huya_enum.StreamFormat.STREAM_FORMAT_HLS => 'HLS',
    _ => '',
  };

  Future<void> _loadPreview() async {
    setState(() => _loading = true);
    try {
      _resolved =
          await (widget.onResolve?.call(_request.resource) ??
              providerGateway.resolveHuya(_request.resource));
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      final request = _request;
      if (widget.onSubmit case final submit?) {
        await submit(request);
      } else {
        final resolved =
            _resolved ?? await providerGateway.resolveHuya(request.resource);
        final config = resolved.sourceConfig;
        final (kind, id) = switch (config.whichSource()) {
          source_config.HuyaMediaSourceConfig_Source.live => (
            'live',
            config.live.roomId,
          ),
          source_config.HuyaMediaSourceConfig_Source.video => (
            'video',
            config.video.videoId,
          ),
          source_config.HuyaMediaSourceConfig_Source.notSet => throw StateError(
            'Huya resolve response has no source config',
          ),
        };
        await providerGateway.addHuyaMedia(
          widget.roomId,
          playlistId: widget.playlistId,
          kind: kind,
          id: id,
          name: request.name.isEmpty ? resolved.metadata.title : request.name,
          providerInstanceName: request.instanceName,
        );
      }
      if (!mounted) return;
      _resourceController.clear();
      _nameController.clear();
      _resolved = null;
      widget.onDraftChanged(false);
      AppNotifications.showSuccess(context, 'Huya source added');
      setState(() {});
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
