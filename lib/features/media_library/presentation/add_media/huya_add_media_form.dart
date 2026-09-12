import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/discovered_source.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_source_preview.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/core/async/async_operation_coordinator.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_instance_selector.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/src/generated/proto/providers/huya.pb.dart' as huya;
import 'package:synctv_app/src/generated/proto/providers/huya.pbenum.dart'
    as huya_enum;
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_workspace.dart';
import 'package:synctv_app/l10n/l10n.dart';

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
  bool _previewLoading = false;
  bool _adding = false;
  bool get _loading => _previewLoading || _adding;
  ProviderGateway? _observedGateway;
  final _operationEpoch = AsyncStateEpoch();
  huya.ResolveResponse? _resolved;

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
  void didUpdateWidget(covariant HuyaAddMediaForm oldWidget) {
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
    if (!mounted) return;
    _invalidateOperation();
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

  @override
  Widget build(BuildContext context) {
    final instances = {'', ...widget.instances}.toList();
    final controls = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          key: const Key('huya-resource'),
          labelAbove: true,
          controller: _resourceController,
          enabled: !_loading,
          label: context.l10n.liveRoomOrVideoUrl,
          prefixIcon: Icons.link_outlined,
          keyboardType: TextInputType.url,
          enableSuggestions: false,
          autocorrect: false,
          onChanged: (_) => _changed(),
        ),
        const SizedBox(height: 12),
        AppTextField(
          key: const Key('huya-name'),
          labelAbove: true,
          controller: _nameController,
          enabled: !_loading,
          label: context.l10n.name,
          prefixIcon: Icons.title,
          onChanged: (_) => _nameChanged(),
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
              key: const Key('huya-preview'),
              onPressed: _loading || _resourceController.text.trim().isEmpty
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
              key: const Key('huya-submit'),
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
    return title.isEmpty ? _resourceController.text.trim() : title;
  }

  Widget? _preview() {
    final response = _resolved;
    if (response == null) return null;
    final metadata = response.metadata;
    final formats = response.qualities
        .map((quality) => _formatName(quality.format))
        .where((format) => format.isNotEmpty)
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
      metadata.isLive ? context.l10n.live : context.l10n.video,
      context.l10n.qualitiesCount(response.qualities.length),
      if (formats.isNotEmpty) formats,
      if (cdns > 0) context.l10n.cdnRoutesCount(cdns),
    ];
    return ProviderSourcePreview(
      title: _previewTitle,
      details: response.hasMetadata() ? details : const [],
      thumbnailUrl: metadata.thumbnailUrl,
    );
  }

  String _formatName(huya_enum.StreamFormat format) => switch (format) {
    huya_enum.StreamFormat.STREAM_FORMAT_FLV => 'FLV',
    huya_enum.StreamFormat.STREAM_FORMAT_HLS => 'HLS',
    _ => '',
  };

  Future<void> _loadPreview() async {
    if (!_canInteract || _resourceController.text.trim().isEmpty) return;
    _operationEpoch.advance();
    final epoch = _operationEpoch.capture();
    final resource = _resourceController.text.trim();
    setState(() {
      _previewLoading = true;
      _resolved = null;
    });
    try {
      final resolved =
          await (widget.onResolve?.call(resource) ??
              providerGateway.resolveHuya(
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
    final draftResource = _resourceController.text;
    final draftName = _nameController.text;
    setState(() => _adding = true);
    try {
      final request = _request;
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
          _resourceController.text != draftResource ||
          _nameController.text != draftName) {
        return;
      }
      _resourceController.clear();
      _nameController.clear();
      _resolved = null;
      widget.onDraftChanged(false);
      if (ModalRoute.of(context)?.isCurrent ?? true) {
        AppNotifications.showSuccess(context, context.l10n.addedSuccessfully);
      }
      setState(() {});
    } catch (error) {
      if (mounted &&
          _ownsOperation(epoch) &&
          (ModalRoute.of(context)?.isCurrent ?? true)) {
        AppNotifications.showError(context, '$error');
      }
    } finally {
      if (_ownsOperation(epoch)) setState(() => _adding = false);
    }
  }
}
