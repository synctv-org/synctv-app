import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/huya_add_media_form.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as common;
import 'package:synctv_app/src/generated/proto/providers/huya.pb.dart' as huya;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart' as source;
import 'package:synctv_app/theme/app_theme.dart';

void main() => runApp(
  MaterialApp(
    theme: AppTheme.light,
    locale: Locale(Uri.base.queryParameters['locale'] ?? 'en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(
          double.tryParse(Uri.base.queryParameters['scale'] ?? '') ?? 1,
        ),
      ),
      child: child!,
    ),
    home: const _Preview(),
  ),
);

class _Preview extends StatefulWidget {
  const _Preview();
  @override
  State<_Preview> createState() => _PreviewState();
}

class _PreviewState extends State<_Preview> {
  bool _otherRoom = false;
  bool _remote = true;
  final _gatewayMode = Uri.base.queryParameters['gateway'] == 'true';
  late final _firstGateway = _PreviewGateway(_resolve, _request);
  late final _secondGateway = _PreviewGateway(_resolve, _request);
  final _pending = <Completer<void>>[];

  Future<int> _request() async {
    final completion = Completer<void>();
    setState(() => _pending.add(completion));
    final id = _pending.length;
    await completion.future;
    return id;
  }

  Future<huya.ResolveResponse> _resolve(String resource) async {
    final id = await _request();
    final response = huya.ResolveResponse(
      metadata: huya.Metadata(
        title: Uri.base.queryParameters['details'] == 'true'
            ? 'A complete broadcast title with enough detail to identify this specific recording'
            : 'Preview $id',
        author: resource,
        isLive: true,
        thumbnailUrl: Uri.base.queryParameters['thumbnail'] == 'true'
            ? Uri.base.resolve('icons/Icon-192.png').toString()
            : null,
      ),
      qualities: [huya.Quality(cdn: 'primary')],
      source: Uri.base.queryParameters['invalid'] == 'true'
          ? common.DiscoveredSource(media: source.MediaSourceConfig())
          : common.DiscoveredSource(
              media: source.MediaSourceConfig(
                huya: source.HuyaMediaSourceConfig(
                  live: source.HuyaLiveSourceConfig(roomId: resource),
                ),
              ),
            ),
    );
    if (Uri.base.queryParameters['missing'] == 'true') response.clearMetadata();
    return response;
  }

  Future<void> _submit(HuyaAddRequest request) async => await _request();

  @override
  void dispose() {
    for (final request in _pending) {
      if (!request.isCompleted) request.complete();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          AppSwitchTile(
            title: Text(_gatewayMode ? 'Other service' : 'Other room'),
            value: _otherRoom,
            onChanged: (value) => setState(() => _otherRoom = value),
          ),
          AppSwitchTile(
            title: const Text('Remote instance'),
            value: _remote,
            onChanged: (value) => setState(() => _remote = value),
          ),
          Wrap(
            children: [
              for (var i = 0; i < _pending.length; i++)
                if (!_pending[i].isCompleted)
                  TextButton(
                    onPressed: () => setState(() => _pending[i].complete()),
                    child: Text('Finish ${i + 1}'),
                  ),
            ],
          ),
          Expanded(
            child: DependencyScope<ProviderGateway>(
              value: _otherRoom ? _secondGateway : _firstGateway,
              child: HuyaAddMediaForm(
                roomId: !_gatewayMode && _otherRoom ? 'second' : 'first',
                playlistId: '',
                instances: _remote ? const ['remote'] : const [],
                onDraftChanged: (_) {},
                onResolve: _gatewayMode ? null : _resolve,
                onSubmit: _gatewayMode ? null : _submit,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _PreviewGateway implements ProviderGateway {
  _PreviewGateway(this.resolve, this.add);
  final Future<huya.ResolveResponse> Function(String) resolve;
  final Future<int> Function() add;

  @override
  Future<huya.ResolveResponse> resolveHuya(
    String resource, {
    String instanceName = '',
  }) => resolve(resource);

  @override
  Future<String> addDiscoveredSource(
    String roomId, {
    required common.DiscoveredSource source,
    String playlistId = '',
    String name = '',
  }) async => 'added-${await add()}';

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
