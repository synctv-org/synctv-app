import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/src/generated/proto/providers/cctv.pb.dart' as cctv;
import 'package:synctv_app/src/generated/proto/providers/cctv.pbenum.dart'
    as cctv_enum;
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class CctvResourceInput {
  const CctvResourceInput({required this.resource, required this.defaultName});

  final String resource;
  final String defaultName;
}

class CctvAddRequest {
  const CctvAddRequest({
    required this.resource,
    required this.name,
    required this.instanceName,
  });

  final String resource;
  final String name;
  final String instanceName;
}

CctvResourceInput? parseCctvResource(String raw) {
  final value = raw.trim();
  if (RegExp(r'^[0-9a-fA-F]{32}$').hasMatch(value)) {
    final videoId = value.toLowerCase();
    return CctvResourceInput(resource: videoId, defaultName: videoId);
  }
  final uri = Uri.tryParse(value.contains('://') ? value : 'https://$value');
  if (uri == null || !{'http', 'https'}.contains(uri.scheme.toLowerCase())) {
    return null;
  }
  final host = uri.host.toLowerCase();
  final supported =
      host == 'ncpa-classic.com' ||
      host == 'www.ncpa-classic.com' ||
      const [
        'cctv.com',
        'cctv.cn',
        'cntv.com',
        'cntv.cn',
      ].any((suffix) => host == suffix || host.endsWith('.$suffix'));
  if (!supported) return null;
  final name = uri.pathSegments
      .where((segment) => segment.isNotEmpty)
      .lastOrNull
      ?.replaceFirst(RegExp(r'\.s?html$'), '');
  return CctvResourceInput(
    resource: uri.toString(),
    defaultName: name == null || name.isEmpty ? 'CCTV' : name,
  );
}

class CctvAddMediaForm extends StatefulWidget {
  const CctvAddMediaForm({
    super.key,
    required this.roomId,
    required this.playlistId,
    required this.instances,
    this.onDraftChanged,
    this.onResolve,
    this.onSubmit,
  });

  final String roomId;
  final String playlistId;
  final List<String> instances;
  final ValueChanged<bool>? onDraftChanged;
  final Future<cctv.ResolveResponse> Function(String resource)? onResolve;
  final Future<void> Function(CctvAddRequest request)? onSubmit;

  @override
  State<CctvAddMediaForm> createState() => _CctvAddMediaFormState();
}

class _CctvAddMediaFormState extends State<CctvAddMediaForm> {
  final _resourceController = TextEditingController();
  final _nameController = TextEditingController();
  String _instanceName = '';
  bool _loading = false;
  cctv.ResolveResponse? _resolved;

  @override
  void initState() {
    super.initState();
    _resourceController.addListener(_notifyDraftChanged);
    _nameController.addListener(_notifyDraftChanged);
  }

  @override
  void dispose() {
    _resourceController.removeListener(_notifyDraftChanged);
    _nameController.removeListener(_notifyDraftChanged);
    _resourceController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _notifyDraftChanged() {
    _resolved = null;
    widget.onDraftChanged?.call(
      _resourceController.text.trim().isNotEmpty ||
          _nameController.text.trim().isNotEmpty,
    );
    if (mounted) setState(() {});
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
            key: const Key('cctv-resource'),
            label: 'CCTV URL / Video ID',
            controller: _resourceController,
            prefixIcon: Icons.link_rounded,
            keyboardType: TextInputType.url,
            enableSuggestions: false,
            autocorrect: false,
            enabled: !_loading,
          ),
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('cctv-name'),
            label: context.l10n.name,
            controller: _nameController,
            prefixIcon: Icons.title_rounded,
            enabled: !_loading,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _instanceName,
            decoration: InputDecoration(
              labelText: context.l10n.instance,
              prefixIcon: const Icon(Icons.account_tree_outlined),
            ),
            items: instances
                .map(
                  (name) => DropdownMenuItem(
                    value: name,
                    child: Text(
                      name.isEmpty ? context.l10n.localInstance : name,
                    ),
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
                key: const Key('cctv-preview'),
                onPressed: _loading || _resourceController.text.trim().isEmpty
                    ? null
                    : _loadPreview,
                icon: const Icon(Icons.preview_outlined),
                label: const Text('Preview'),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                key: const Key('cctv-submit'),
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
    final formats = response.streams
        .map(
          (stream) => switch (stream.kind) {
            cctv_enum.StreamKind.STREAM_KIND_VIDEO_HLS => 'HLS video',
            cctv_enum.StreamKind.STREAM_KIND_AUDIO_HLS => 'HLS audio',
            cctv_enum.StreamKind.STREAM_KIND_HTTP => 'HTTP',
            _ => '',
          },
        )
        .where((value) => value.isNotEmpty)
        .toSet()
        .join('/');
    final details = <String>[
      if (metadata.hasChannel()) metadata.channel,
      if (metadata.hasColumn()) metadata.column,
      '${response.streams.length} streams',
      if (formats.isNotEmpty) formats,
      if (metadata.chapters.isNotEmpty) '${metadata.chapters.length} chapters',
      if (metadata.protected) 'Protected',
      if (metadata.tags.isNotEmpty) metadata.tags.take(2).join('/'),
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

  Future<void> _loadPreview() async {
    setState(() => _loading = true);
    try {
      final resource = _resourceController.text.trim();
      _resolved =
          await (widget.onResolve?.call(resource) ??
              providerGateway.resolveCctv(resource));
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    final parsed = parseCctvResource(_resourceController.text);
    if (parsed == null) {
      AppNotifications.showError(context, 'Invalid CCTV URL or video ID');
      return;
    }
    setState(() => _loading = true);
    try {
      final request = CctvAddRequest(
        resource: parsed.resource,
        name: _nameController.text.trim(),
        instanceName: _instanceName,
      );
      if (widget.onSubmit case final submit?) {
        await submit(request);
      } else {
        final resolved =
            _resolved ?? await providerGateway.resolveCctv(request.resource);
        final source = resolved.sourceConfig;
        await providerGateway.addCctvMedia(
          widget.roomId,
          playlistId: widget.playlistId,
          resource: source.resource,
          name: request.name.isEmpty ? resolved.metadata.title : request.name,
          providerInstanceName: request.instanceName,
        );
      }
      if (!mounted) return;
      _resourceController.clear();
      _nameController.clear();
      _resolved = null;
      widget.onDraftChanged?.call(false);
      AppNotifications.showSuccess(context, 'CCTV source added');
      setState(() {});
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.addFailed('$error'));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
