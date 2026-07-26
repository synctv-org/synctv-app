import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/src/generated/proto/providers/acfun.pb.dart'
    as acfun;
import 'package:synctv_app/src/generated/proto/providers/acfun.pbenum.dart'
    as acfun_enum;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class AcFunResourceInput {
  const AcFunResourceInput({
    required this.kind,
    required this.id,
    this.episodeQuery,
  });

  final String kind;
  final String id;
  final String? episodeQuery;
}

class AcFunAddRequest {
  const AcFunAddRequest({
    required this.resource,
    required this.name,
    required this.instanceName,
  });

  final String resource;
  final String name;
  final String instanceName;
}

AcFunResourceInput? parseAcFunResource(String raw) {
  final value = raw.trim();
  if (RegExp(r'^ac\d+(?:_\d+)*$').hasMatch(value)) {
    return AcFunResourceInput(kind: 'video', id: value);
  }
  if (RegExp(r'^aa\d+(?:_\d+)*$').hasMatch(value)) {
    return AcFunResourceInput(kind: 'bangumi', id: value);
  }
  if (RegExp(r'^\d+$').hasMatch(value)) {
    return AcFunResourceInput(kind: 'live', id: value);
  }

  final parsed = Uri.tryParse(value.contains('://') ? value : 'https://$value');
  if (parsed == null ||
      !{
        'acfun.cn',
        'www.acfun.cn',
        'm.acfun.cn',
        'live.acfun.cn',
      }.contains(parsed.host.toLowerCase())) {
    return null;
  }
  final parts = parsed.pathSegments
      .where((part) => part.isNotEmpty)
      .toList(growable: false);
  if (parts.length == 2 &&
      parts.first == 'v' &&
      RegExp(r'^ac\d+(?:_\d+)*$').hasMatch(parts[1])) {
    return AcFunResourceInput(kind: 'video', id: parts[1]);
  }
  if (parts.length == 2 &&
      parts.first == 'bangumi' &&
      RegExp(r'^aa\d+(?:_\d+)*$').hasMatch(parts[1])) {
    return AcFunResourceInput(
      kind: 'bangumi',
      id: parts[1],
      episodeQuery: parsed.hasQuery ? parsed.query : null,
    );
  }
  final liveId = switch (parts) {
    ['live', final id] => id,
    [final id] when parsed.host.toLowerCase() == 'live.acfun.cn' => id,
    _ => '',
  };
  if (RegExp(r'^\d+$').hasMatch(liveId)) {
    return AcFunResourceInput(kind: 'live', id: liveId);
  }
  return null;
}

class AcFunAddMediaForm extends StatefulWidget {
  const AcFunAddMediaForm({
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
  final Future<acfun.ResolveResponse> Function(String resource)? onResolve;
  final Future<void> Function(AcFunAddRequest request)? onSubmit;

  @override
  State<AcFunAddMediaForm> createState() => _AcFunAddMediaFormState();
}

class _AcFunAddMediaFormState extends State<AcFunAddMediaForm> {
  final _urlController = TextEditingController();
  final _nameController = TextEditingController();
  String _instanceName = '';
  bool _loading = false;
  acfun.ResolveResponse? _resolved;

  @override
  void initState() {
    super.initState();
    _urlController.addListener(_notifyDraftChanged);
    _nameController.addListener(_notifyDraftChanged);
  }

  @override
  void dispose() {
    _urlController.removeListener(_notifyDraftChanged);
    _nameController.removeListener(_notifyDraftChanged);
    _urlController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _notifyDraftChanged() {
    _resolved = null;
    widget.onDraftChanged?.call(
      _urlController.text.trim().isNotEmpty ||
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
            key: const Key('acfun-resource'),
            label: 'AcFun URL',
            controller: _urlController,
            prefixIcon: Icons.link_rounded,
            keyboardType: TextInputType.url,
            enableSuggestions: false,
            autocorrect: false,
            enabled: !_loading,
          ),
          const SizedBox(height: 12),
          AppTextField(
            key: const Key('acfun-name'),
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
                key: const Key('acfun-preview'),
                onPressed: _loading || _urlController.text.trim().isEmpty
                    ? null
                    : _loadPreview,
                icon: const Icon(Icons.preview_outlined),
                label: const Text('Preview'),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                key: const Key('acfun-submit'),
                onPressed: _loading || _urlController.text.trim().isEmpty
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
        .map(
          (quality) => switch (quality.format) {
            acfun_enum.StreamFormat.STREAM_FORMAT_HLS => 'HLS',
            acfun_enum.StreamFormat.STREAM_FORMAT_FLV => 'FLV',
            _ => '',
          },
        )
        .where((value) => value.isNotEmpty)
        .toSet()
        .join('/');
    final details = <String>[
      if (metadata.author.isNotEmpty) metadata.author,
      _kindName(response.kind),
      '${response.qualities.length} qualities',
      if (formats.isNotEmpty) formats,
      if (metadata.hasDanmaku) 'Danmaku',
      if (metadata.hasLiveDanmaku) 'Live danmaku',
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

  String _kindName(acfun_enum.ResourceKind kind) => switch (kind) {
    acfun_enum.ResourceKind.RESOURCE_KIND_VIDEO => 'Video',
    acfun_enum.ResourceKind.RESOURCE_KIND_BANGUMI => 'Bangumi',
    acfun_enum.ResourceKind.RESOURCE_KIND_LIVE => 'Live',
    _ => 'Media',
  };

  Future<void> _loadPreview() async {
    setState(() => _loading = true);
    try {
      final resource = _urlController.text.trim();
      _resolved =
          await (widget.onResolve?.call(resource) ??
              providerGateway.resolveAcFun(resource));
    } catch (error) {
      if (mounted) AppNotifications.showError(context, '$error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      final request = AcFunAddRequest(
        resource: _urlController.text.trim(),
        name: _nameController.text.trim(),
        instanceName: _instanceName,
      );
      if (widget.onSubmit case final submit?) {
        await submit(request);
      } else {
        final resolved =
            _resolved ?? await providerGateway.resolveAcFun(request.resource);
        final config = resolved.sourceConfig;
        final (kind, id, episodeQuery) = switch (config.whichSource()) {
          source_config.AcFunMediaSourceConfig_Source.video => (
            'video',
            config.video.videoId,
            null,
          ),
          source_config.AcFunMediaSourceConfig_Source.bangumi => (
            'bangumi',
            config.bangumi.bangumiId,
            config.bangumi.hasEpisodeQuery()
                ? config.bangumi.episodeQuery
                : null,
          ),
          source_config.AcFunMediaSourceConfig_Source.live => (
            'live',
            config.live.authorId,
            null,
          ),
          source_config.AcFunMediaSourceConfig_Source.notSet =>
            throw StateError('AcFun resolve response has no source config'),
        };
        await providerGateway.addAcFunMedia(
          widget.roomId,
          playlistId: widget.playlistId,
          kind: kind,
          id: id,
          episodeQuery: episodeQuery,
          name: request.name.isEmpty ? resolved.metadata.title : request.name,
          providerInstanceName: request.instanceName,
        );
      }
      if (!mounted) return;
      _urlController.clear();
      _nameController.clear();
      _resolved = null;
      widget.onDraftChanged?.call(false);
      AppNotifications.showSuccess(context, 'AcFun source added');
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
