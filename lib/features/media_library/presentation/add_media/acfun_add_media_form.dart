import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/discovered_source.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_source_preview.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/core/async/async_operation_coordinator.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_instance_selector.dart';
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
  bool _previewLoading = false;
  bool _adding = false;
  bool get _loading => _previewLoading || _adding;
  ProviderGateway? _observedGateway;
  final _operationEpoch = AsyncStateEpoch();
  acfun.ResolveResponse? _resolved;

  @override
  void initState() {
    super.initState();
    _urlController.addListener(_resourceChanged);
    _nameController.addListener(_nameChanged);
  }

  bool get _canInteract =>
      mounted && !_loading && (ModalRoute.of(context)?.isCurrent ?? true);

  bool _ownsOperation(Object epoch) =>
      mounted && _operationEpoch.isCurrent(epoch);

  void _invalidateOperation() {
    _operationEpoch.advance();
    _previewLoading = false;
    _adding = false;
    _resolved = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final gateway = DependencyScope.maybeOf<ProviderGateway>(context);
    if (!identical(gateway, _observedGateway)) {
      _observedGateway = gateway;
      _invalidateOperation();
    }
  }

  @override
  void didUpdateWidget(covariant AcFunAddMediaForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    final instanceRemoved =
        _instanceName.isNotEmpty && !widget.instances.contains(_instanceName);
    if (oldWidget.roomId != widget.roomId ||
        oldWidget.playlistId != widget.playlistId ||
        instanceRemoved) {
      _invalidateOperation();
    }
    if (instanceRemoved) _instanceName = '';
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
    if (!mounted) return;
    _invalidateOperation();
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
    final controls = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          key: const Key('acfun-resource'),
          labelAbove: true,
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
          labelAbove: true,
          label: context.l10n.name,
          controller: _nameController,
          prefixIcon: Icons.title_rounded,
          enabled: !_loading,
        ),
        const SizedBox(height: 12),
        ProviderInstanceSelector(
          instances: instances,
          value: _instanceName,
          enabled: !_loading,
          onChanged: (value) {
            if (!mounted ||
                _loading ||
                value == _instanceName ||
                !(ModalRoute.of(context)?.isCurrent ?? true)) {
              return;
            }
            setState(() {
              _instanceName = value;
              _invalidateOperation();
            });
          },
        ),
        const SizedBox(height: 12),
        Wrap(
          alignment: WrapAlignment.end,
          spacing: 10,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              key: const Key('acfun-preview'),
              onPressed: _loading || _urlController.text.trim().isEmpty
                  ? null
                  : _loadPreview,
              icon: _previewLoading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: AppLoadingIndicator(
                        size: AppLoadingSize.sm,
                        centered: false,
                      ),
                    )
                  : const Icon(Icons.preview_outlined),
              label: Text(context.l10n.preview),
            ),
            FilledButton.icon(
              key: const Key('acfun-submit'),
              onPressed: _loading || _resolved?.source.hasMediaSource != true
                  ? null
                  : _submit,
              icon: _adding
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

  Widget? _buildResults() {
    final preview = _preview();
    return preview == null
        ? null
        : AppSingleChildScrollView(padding: EdgeInsets.zero, child: preview);
  }

  String get _previewTitle {
    final title = _resolved?.metadata.title.trim() ?? '';
    return title.isEmpty ? _urlController.text.trim() : title;
  }

  Widget? _preview() {
    final response = _resolved;
    if (response == null) return null;
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
      context.l10n.qualitiesCount(response.qualities.length),
      if (formats.isNotEmpty) formats,
      if (metadata.hasDanmaku) context.l10n.danmaku,
      if (metadata.hasLiveDanmaku) context.l10n.liveDanmaku,
      if (metadata.tags.isNotEmpty) metadata.tags.take(2).join('/'),
    ];
    return ProviderSourcePreview(
      title: _previewTitle,
      details: response.hasMetadata() ? details : const [],
      thumbnailUrl: metadata.thumbnailUrl,
    );
  }

  String _kindName(acfun_enum.ResourceKind kind) => switch (kind) {
    acfun_enum.ResourceKind.RESOURCE_KIND_VIDEO => context.l10n.video,
    acfun_enum.ResourceKind.RESOURCE_KIND_BANGUMI => context.l10n.bangumi,
    acfun_enum.ResourceKind.RESOURCE_KIND_LIVE => context.l10n.live,
    _ => localizedMediaVariant(context, kind.name),
  };

  Future<void> _loadPreview() async {
    if (!_canInteract || _urlController.text.trim().isEmpty) return;
    _operationEpoch.advance();
    final epoch = _operationEpoch.capture();
    final resource = _urlController.text.trim();
    setState(() {
      _previewLoading = true;
      _resolved = null;
    });
    try {
      final resolved =
          await (widget.onResolve?.call(resource) ??
              providerGateway.resolveAcFun(
                resource,
                instanceName: _instanceName,
              ));
      if (_ownsOperation(epoch)) _resolved = resolved;
    } catch (error) {
      if (mounted &&
          _ownsOperation(epoch) &&
          (ModalRoute.of(context)?.isCurrent ?? true)) {
        AppNotifications.showError(context, '$error');
      }
    } finally {
      if (_ownsOperation(epoch)) setState(() => _previewLoading = false);
    }
  }

  Future<void> _submit() async {
    if (!_canInteract) return;
    final resolved = _resolved;
    if (resolved == null || !resolved.source.hasMediaSource) {
      AppNotifications.showError(context, context.l10n.previewSourceFirst);
      return;
    }
    _operationEpoch.advance();
    final epoch = _operationEpoch.capture();
    final draftResource = _urlController.text;
    final draftName = _nameController.text;
    setState(() => _adding = true);
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
          name: request.name.isEmpty ? _previewTitle : request.name,
        );
      }
      if (!mounted ||
          !_ownsOperation(epoch) ||
          _urlController.text != draftResource ||
          _nameController.text != draftName) {
        return;
      }
      _urlController.clear();
      _nameController.clear();
      _resolved = null;
      widget.onDraftChanged?.call(false);
      if (ModalRoute.of(context)?.isCurrent ?? true) {
        AppNotifications.showSuccess(context, context.l10n.addedSuccessfully);
      }
      setState(() {});
    } catch (error) {
      if (mounted &&
          _ownsOperation(epoch) &&
          (ModalRoute.of(context)?.isCurrent ?? true)) {
        AppNotifications.showError(context, context.l10n.addFailed('$error'));
      }
    } finally {
      if (_ownsOperation(epoch)) setState(() => _adding = false);
    }
  }
}
