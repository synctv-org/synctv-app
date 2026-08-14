import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/src/generated/proto/providers/acfun.pb.dart'
    as acfun;
import 'package:synctv_app/src/generated/proto/providers/acfun.pbenum.dart'
    as acfun_enum;
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/media_variant_label.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_workspace.dart';

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
    _urlController.addListener(_resourceChanged);
    _nameController.addListener(_nameChanged);
  }

  @override
  void dispose() {
    _urlController.removeListener(_resourceChanged);
    _nameController.removeListener(_nameChanged);
    _urlController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _resourceChanged() {
    _resolved = null;
    _notifyDraftChanged();
  }

  void _nameChanged() => _notifyDraftChanged();

  void _notifyDraftChanged() {
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
    final controls = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          key: const Key('acfun-resource'),
          label: context.l10n.acfunUrl,
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
                  child: Text(name.isEmpty ? context.l10n.localInstance : name),
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
              key: const Key('acfun-preview'),
              onPressed: _loading || _urlController.text.trim().isEmpty
                  ? null
                  : _loadPreview,
              icon: const Icon(Icons.preview_outlined),
              label: Text(context.l10n.preview),
            ),
            const SizedBox(width: 10),
            FilledButton.icon(
              key: const Key('acfun-submit'),
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
    acfun_enum.ResourceKind.RESOURCE_KIND_VIDEO => context.l10n.video,
    acfun_enum.ResourceKind.RESOURCE_KIND_BANGUMI => context.l10n.bangumi,
    acfun_enum.ResourceKind.RESOURCE_KIND_LIVE => context.l10n.live,
    _ => localizedMediaVariant(context, kind.name),
  };

  Future<void> _loadPreview() async {
    setState(() => _loading = true);
    try {
      final resource = _urlController.text.trim();
      _resolved =
          await (widget.onResolve?.call(resource) ??
              providerGateway.resolveAcFun(
                resource,
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
      final request = AcFunAddRequest(
        resource: _urlController.text.trim(),
        name: _nameController.text.trim(),
        instanceName: _instanceName,
      );
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
      _urlController.clear();
      _nameController.clear();
      _resolved = null;
      widget.onDraftChanged?.call(false);
      AppNotifications.showSuccess(context, context.l10n.addedSuccessfully);
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
