import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/playback_proxy_mode_control.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;
import 'package:synctv_app/theme/app_theme.dart';

void main() => runApp(const _Showcase());

class _Showcase extends StatefulWidget {
  const _Showcase();

  @override
  State<_Showcase> createState() => _ShowcaseState();
}

class _ShowcaseState extends State<_Showcase> {
  final _async = Uri.base.queryParameters.containsKey('async');
  final _firstGateway = _Gateway();
  final _secondGateway = _Gateway();
  final _source = provider_common.DiscoveredSource();
  bool _second = false;
  bool _dark = true;
  bool _enabled = true;
  var _mode = source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY;
  final _policy = provider_common.PlaybackProxyPolicy(
    supportedModes: [
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_PREFER,
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY,
    ],
    currentMode: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY,
  );

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: _dark ? AppTheme.dark : AppTheme.light,
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(_async ? 1 : 3)),
      child: child!,
    ),
    home: Scaffold(
      body: SafeArea(
        child: AppSingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.topLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSwitchTile(
                    value: _dark,
                    onChanged: (value) => setState(() => _dark = value),
                    title: const Text('Dark theme'),
                  ),
                  const SizedBox(height: 16),
                  AppSwitchTile(
                    value: _enabled,
                    onChanged: (value) => setState(() => _enabled = value),
                    title: const Text('Editing enabled'),
                  ),
                  if (_async) ...[
                    AppSwitchTile(
                      value: _second,
                      onChanged: (value) => setState(() => _second = value),
                      title: const Text('Second provider'),
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final entry in [
                          (
                            _firstGateway,
                            'Resolve first',
                            source_enum
                                .PlaybackProxyMode
                                .PLAYBACK_PROXY_MODE_DIRECT_ONLY,
                          ),
                          (
                            _secondGateway,
                            'Resolve second',
                            source_enum
                                .PlaybackProxyMode
                                .PLAYBACK_PROXY_MODE_ONLY,
                          ),
                        ])
                          AppActionButton(
                            label: entry.$2,
                            icon: Icons.check_rounded,
                            onPressed: entry.$1.result.isCompleted
                                ? null
                                : () {
                                    setState(
                                      () => entry.$1.result.complete(
                                        provider_common.PlaybackProxyPolicy(
                                          supportedModes: [entry.$3],
                                          currentMode: entry.$3,
                                        ),
                                      ),
                                    );
                                  },
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  DependencyScope<ProviderGateway>(
                    value: _second ? _secondGateway : _firstGateway,
                    child: PlaybackProxyModeControl(
                      enabled: _enabled,
                      value: _mode,
                      onChanged: (value) => setState(() => _mode = value),
                      policy: _async ? null : _policy,
                      source: _async ? _source : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _Gateway implements ProviderGateway {
  final result = Completer<provider_common.PlaybackProxyPolicy>();

  @override
  Future<provider_common.PlaybackProxyPolicy> resolvePlaybackProxyPolicy(
    provider_common.DiscoveredSource source,
  ) => result.future;

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
