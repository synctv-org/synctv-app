import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as common;
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/acfun_add_media_form.dart';
import 'package:synctv_app/src/generated/proto/providers/acfun.pb.dart'
    as acfun;
import 'package:synctv_app/features/media_library/presentation/add_media/cctv_add_media_form.dart';
import 'package:synctv_app/src/generated/proto/providers/cctv.pb.dart' as cctv;
import 'package:synctv_app/features/media_library/presentation/add_media/douyu_add_media_form.dart';
import 'package:synctv_app/src/generated/proto/providers/douyu.pb.dart'
    as douyu;
import 'package:synctv_app/features/media_library/presentation/add_media/huya_add_media_form.dart';
import 'package:synctv_app/src/generated/proto/providers/huya.pb.dart' as huya;

import '../../../../test_app.dart';

void main() {
  for (final provider in ['acfun', 'cctv', 'douyu', 'huya']) {
    for (final missingMetadata in [true, false]) {
      testWidgets(
        '$provider preserves source preview without title metadata=$missingMetadata',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(1200, 900));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final gateway = _Gateway();
          final form = switch (provider) {
            'acfun' => AcFunAddMediaForm(
              roomId: 'room',
              playlistId: '',
              instances: const [],
              onDraftChanged: (_) {},
              onResolve: (_) async => acfun.ResolveResponse(
                metadata: missingMetadata ? null : acfun.Metadata(title: '   '),
                source: testDiscoveredMediaSource(),
              ),
            ),
            'cctv' => CctvAddMediaForm(
              roomId: 'room',
              playlistId: '',
              instances: const [],
              onDraftChanged: (_) {},
              onResolve: (_) async => cctv.ResolveResponse(
                metadata: missingMetadata ? null : cctv.Metadata(title: '   '),
                source: testDiscoveredMediaSource(),
              ),
            ),
            'douyu' => DouyuAddMediaForm(
              roomId: 'room',
              playlistId: '',
              instances: const [],
              onDraftChanged: (_) {},
              onResolve: (_) async => douyu.ResolveResponse(
                metadata: missingMetadata ? null : douyu.Metadata(title: '   '),
                source: testDiscoveredMediaSource(),
              ),
            ),
            'huya' => HuyaAddMediaForm(
              roomId: 'room',
              playlistId: '',
              instances: const [],
              onDraftChanged: (_) {},
              onResolve: (_) async => huya.ResolveResponse(
                metadata: missingMetadata ? null : huya.Metadata(title: '   '),
                source: testDiscoveredMediaSource(),
              ),
            ),
            _ => throw StateError(provider),
          };
          await tester.pumpWidget(
            MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: DependencyScope<ProviderGateway>(
                  value: gateway,
                  child: form,
                ),
              ),
            ),
          );
          await tester.enterText(
            find.byKey(Key('$provider-resource')),
            'resource-identifier',
          );
          await tester.pump();
          await tester.tap(find.byKey(Key('$provider-preview')));
          await tester.pumpAndSettle();
          expect(find.text('resource-identifier'), findsNWidgets(2));
          expect(
            tester
                .widget<FilledButton>(find.byKey(Key('$provider-submit')))
                .onPressed,
            isNotNull,
          );
          expect(tester.takeException(), isNull);
          await tester.tap(find.byKey(Key('$provider-submit')));
          await tester.pumpAndSettle();
          expect(gateway.name, 'resource-identifier');
          await tester.pump(const Duration(seconds: 4));
        },
      );
    }
  }
}

class _Gateway implements ProviderGateway {
  String? name;
  @override
  Future<String> addDiscoveredSource(
    String roomId, {
    required common.DiscoveredSource source,
    String playlistId = '',
    String name = '',
  }) async {
    this.name = name;
    return 'added';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}
