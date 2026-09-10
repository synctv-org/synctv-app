import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/youtube_add_media_form.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as common;
import 'package:synctv_app/src/generated/proto/providers/youtube.pb.dart'
    as youtube;
import 'package:synctv_app/theme/app_theme.dart';

void main() => runApp(
  MaterialApp(
    theme: AppTheme.light,
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(3)),
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
  static const _account = YoutubeBindInfo(
    id: 'account',
    serverId: 'server',
    label: 'Account',
    hasVisitorData: true,
    hasPoToken: true,
    hasCookie: true,
    createdAt: 1,
    providerInstanceName: 'instance',
  );
  bool _accountAvailable = true;
  bool _otherRoom = false;
  final _bulk = Uri.base.queryParameters['bulk'] == 'true';
  bool _failedOnce = false;
  int _added = 0;
  late final _gateway = _PreviewGateway((name) async {
    await _request();
    if (!mounted) return 'disposed';
    if (name == 'Second' && !_failedOnce) {
      _failedOnce = true;
      throw StateError('Second item failed');
    }
    setState(() => _added++);
    return 'added';
  });
  final _requests = <Completer<void>>[];

  Future<int> _request() async {
    final completion = Completer<void>();
    setState(() => _requests.add(completion));
    final id = _requests.length;
    await completion.future;
    return id;
  }

  @override
  void dispose() {
    for (final request in _requests) {
      if (!request.isCompleted) request.complete();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_bulk)
              AppSwitchTile(
                title: const Text('Account'),
                value: _accountAvailable,
                onChanged: (value) => setState(() => _accountAvailable = value),
              ),
            if (!_bulk)
              AppSwitchTile(
                title: const Text('Other room'),
                value: _otherRoom,
                onChanged: (value) => setState(() => _otherRoom = value),
              ),
            if (_bulk) Text('Added: $_added'),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final (index, request) in _requests.indexed)
                  if (!_bulk || !request.isCompleted)
                    TextButton(
                      onPressed: request.isCompleted
                          ? null
                          : () {
                              request.complete();
                              setState(() {});
                            },
                      child: Text('Finish ${index + 1}'),
                    ),
              ],
            ),
            Expanded(
              child: DependencyScope<ProviderGateway>(
                value: _gateway,
                child: YoutubeAddMediaForm(
                  roomId: _otherRoom ? 'other' : 'preview',
                  playlistId: '',
                  binds: _accountAvailable ? const [_account] : const [],
                  onDraftChanged: (_) {},
                  onSubmit: (_) async {
                    await _request();
                  },
                  onResolve: (request) async => youtube.ResolveResponse(
                    metadata: youtube.Metadata(
                      title:
                          'Preview ${await _request()} (${request.instanceName.isEmpty ? 'default' : request.instanceName})',
                    ),
                    source: common.DiscoveredSource(),
                  ),
                  onList: (_) async {
                    await _request();
                    return youtube.ListResponse(
                      source: common.DiscoveredSource(),
                      items: _bulk
                          ? [
                              for (final title in ['First', 'Second'])
                                youtube.ListItem(
                                  videoId: title,
                                  title: title,
                                  source: common.DiscoveredSource(),
                                ),
                            ]
                          : const [],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _PreviewGateway implements ProviderGateway {
  _PreviewGateway(this.add);
  final Future<String> Function(String) add;

  @override
  Future<String> addDiscoveredSource(
    String roomId, {
    required common.DiscoveredSource source,
    String playlistId = '',
    String name = '',
  }) => add(name);

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
