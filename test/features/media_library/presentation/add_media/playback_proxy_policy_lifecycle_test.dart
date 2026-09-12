import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/playback_proxy_mode_control.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as common;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source;

const _auto = source.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;
const _only = source.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY;
const _direct = source.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY;

class _Gateway implements ProviderGateway {
  final requests = <Completer<common.PlaybackProxyPolicy>>[];

  @override
  Future<common.PlaybackProxyPolicy> resolvePlaybackProxyPolicy(
    common.DiscoveredSource source,
  ) {
    final request = Completer<common.PlaybackProxyPolicy>();
    requests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

common.PlaybackProxyPolicy _policy(source.PlaybackProxyMode mode) =>
    common.PlaybackProxyPolicy(supportedModes: [mode], currentMode: mode);

void main() {
  for (final locale in ['en', 'zh']) {
    for (final platform in [TargetPlatform.android, TargetPlatform.macOS]) {
      testWidgets('policy loading is named in $locale on $platform', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        try {
          final gateway = _Gateway();
          await tester.pumpWidget(
            MaterialApp(
              theme: ThemeData(platform: platform),
              locale: Locale(locale),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: DependencyScope<ProviderGateway>(
                value: gateway,
                child: Scaffold(
                  body: PlaybackProxyModeControl(
                    source: common.DiscoveredSource(),
                    value: _auto,
                    onChanged: (_) {},
                  ),
                ),
              ),
            ),
          );
          final l10n = AppLocalizations.of(
            tester.element(find.byType(PlaybackProxyModeControl)),
          );
          final loading = find.bySemanticsLabel(l10n.loading);
          expect(loading, findsOneWidget);
          expect(
            tester.getSemantics(loading).getSemanticsData().role,
            ui.SemanticsRole.loadingSpinner,
          );
          expect(
            tester.getSize(find.byType(PlaybackProxyModeControl)).height,
            40,
          );
          gateway.requests.single.complete(_policy(_only));
          await tester.pumpAndSettle();
          expect(loading, findsNothing);
          expect(find.text(l10n.playbackProxyOnly), findsOneWidget);
          expect(tester.takeException(), isNull);
        } finally {
          semantics.dispose();
        }
      });
    }
  }

  for (final registry in [false, true]) {
    for (final resolved in [false, true]) {
      testWidgets('gateway replacement registry=$registry resolved=$resolved', (
        tester,
      ) async {
        final oldGateway = _Gateway();
        final newGateway = _Gateway();
        var gateway = oldGateway;
        final changes = <source.PlaybackProxyMode>[];
        final control = PlaybackProxyModeControl(
          source: common.DiscoveredSource(),
          value: _auto,
          onChanged: changes.add,
        );
        late StateSetter update;
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  update = setState;
                  return registry
                      ? DependencyRegistryScope(
                          values: {ProviderGateway: gateway},
                          child: control,
                        )
                      : DependencyScope<ProviderGateway>(
                          value: gateway,
                          child: control,
                        );
                },
              ),
            ),
          ),
        );
        expect(oldGateway.requests, hasLength(1));
        if (resolved) {
          oldGateway.requests.single.complete(_policy(_direct));
          await tester.pumpAndSettle();
          expect(changes, [_direct]);
          changes.clear();
        }
        update(() => gateway = newGateway);
        await tester.pump();
        expect(newGateway.requests, hasLength(1));
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        newGateway.requests.single.complete(_policy(_only));
        await tester.pumpAndSettle();
        expect(changes, [_only]);
        final l10n = AppLocalizations.of(
          tester.element(find.byType(PlaybackProxyModeControl)),
        );
        expect(find.text(l10n.playbackProxyOnly), findsOneWidget);
        if (!resolved) {
          oldGateway.requests.single.complete(_policy(_direct));
          await tester.pumpAndSettle();
          expect(changes, [_only]);
          expect(find.text(l10n.playbackProxyOnly), findsOneWidget);
        }
        update(() {});
        await tester.pump();
        expect(newGateway.requests, hasLength(1));
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final lateError in [false, true]) {
    testWidgets('source replacement ignores old completion error=$lateError', (
      tester,
    ) async {
      final gateway = _Gateway();
      var discovered = common.DiscoveredSource();
      final changes = <source.PlaybackProxyMode>[];
      late StateSetter update;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: DependencyScope<ProviderGateway>(
            value: gateway,
            child: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  update = setState;
                  return PlaybackProxyModeControl(
                    source: discovered,
                    value: _auto,
                    onChanged: changes.add,
                  );
                },
              ),
            ),
          ),
        ),
      );
      // A populated source has different protobuf equality from the old source.
      update(
        () => discovered = common.DiscoveredSource(
          providerInstanceName: 'second',
        ),
      );
      await tester.pump();
      expect(gateway.requests, hasLength(2));
      gateway.requests.last.complete(_policy(_only));
      await tester.pumpAndSettle();
      expect(changes, [_only]);
      if (lateError) {
        gateway.requests.first.completeError(StateError('old request failed'));
      } else {
        gateway.requests.first.complete(_policy(_direct));
      }
      await tester.pumpAndSettle();
      expect(changes, [_only]);
      expect(tester.takeException(), isNull);
    });
  }
}
