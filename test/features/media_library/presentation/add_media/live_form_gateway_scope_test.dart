import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
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

class _Gateway implements ProviderGateway {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  for (final provider in ['acfun', 'cctv', 'douyu', 'huya']) {
    for (final registry in [false, true]) {
      for (final scenario in [
        'pending preview',
        'resolved preview',
        'pending submit',
        'same gateway',
      ]) {
        testWidgets(
          '$provider registry=$registry $scenario follows gateway identity',
          (tester) async {
            await tester.binding.setSurfaceSize(const Size(1000, 800));
            addTearDown(() => tester.binding.setSurfaceSize(null));
            var gateway = _Gateway();
            final preview = Completer<dynamic>();
            final submission = Completer<void>();
            final responses = <String, dynamic>{
              'acfun': acfun.ResolveResponse(
                metadata: acfun.Metadata(title: 'Preview'),
                source: testDiscoveredMediaSource(),
              ),
              'cctv': cctv.ResolveResponse(
                metadata: cctv.Metadata(title: 'Preview'),
                source: testDiscoveredMediaSource(),
              ),
              'douyu': douyu.ResolveResponse(
                metadata: douyu.Metadata(title: 'Preview'),
                source: testDiscoveredMediaSource(),
              ),
              'huya': huya.ResolveResponse(
                metadata: huya.Metadata(title: 'Preview'),
                source: testDiscoveredMediaSource(),
              ),
            };
            final form = switch (provider) {
              'acfun' => AcFunAddMediaForm(
                roomId: 'room',
                playlistId: '',
                instances: const [],
                onDraftChanged: (_) {},
                onResolve: (_) async =>
                    await preview.future as acfun.ResolveResponse,
                onSubmit: (_) => submission.future,
              ),
              'cctv' => CctvAddMediaForm(
                roomId: 'room',
                playlistId: '',
                instances: const [],
                onDraftChanged: (_) {},
                onResolve: (_) async =>
                    await preview.future as cctv.ResolveResponse,
                onSubmit: (_) => submission.future,
              ),
              'douyu' => DouyuAddMediaForm(
                roomId: 'room',
                playlistId: '',
                instances: const [],
                onDraftChanged: (_) {},
                onResolve: (_) async =>
                    await preview.future as douyu.ResolveResponse,
                onSubmit: (_) => submission.future,
              ),
              'huya' => HuyaAddMediaForm(
                roomId: 'room',
                playlistId: '',
                instances: const [],
                onDraftChanged: (_) {},
                onResolve: (_) async =>
                    await preview.future as huya.ResolveResponse,
                onSubmit: (_) => submission.future,
              ),
              _ => throw StateError(provider),
            };
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
                              values: {
                                ProviderGateway: gateway,
                                Object: Object(),
                              },
                              child: form,
                            )
                          : DependencyScope<ProviderGateway>(
                              value: gateway,
                              child: form,
                            );
                    },
                  ),
                ),
              ),
            );
            await tester.enterText(
              find.byKey(Key('$provider-resource')),
              'keep-resource',
            );
            await tester.pump();
            await tester.tap(find.byKey(Key('$provider-preview')));
            await tester.pump();
            if (scenario != 'pending preview') {
              preview.complete(responses[provider]);
              await tester.pumpAndSettle();
              if (scenario == 'pending submit') {
                await tester.tap(find.byKey(Key('$provider-submit')));
                await tester.pump();
              }
            }
            update(() {
              if (scenario != 'same gateway') gateway = _Gateway();
            });
            await tester.pump();
            if (scenario == 'pending preview') {
              expect(
                tester
                    .widget<OutlinedButton>(
                      find.byKey(Key('$provider-preview')),
                    )
                    .onPressed,
                isNotNull,
              );
              preview.complete(responses[provider]);
            }
            if (scenario == 'pending submit') submission.complete();
            await tester.pumpAndSettle();
            expect(
              find.text('Preview'),
              scenario == 'same gateway' ? findsNWidgets(2) : findsOneWidget,
            );
            final field = tester.widget<TextField>(
              find.descendant(
                of: find.byKey(Key('$provider-resource')),
                matching: find.byType(TextField),
              ),
            );
            expect(field.controller!.text, 'keep-resource');
            expect(
              tester
                  .widget<FilledButton>(find.byKey(Key('$provider-submit')))
                  .onPressed,
              scenario == 'same gateway' ? isNotNull : isNull,
            );
            await tester.pumpWidget(const SizedBox());
          },
        );
      }
    }
    testWidgets('$provider progress belongs to the active command', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(1000, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final preview = Completer<dynamic>();
      final submission = Completer<void>();
      final responses = <String, dynamic>{
        'acfun': acfun.ResolveResponse(
          metadata: acfun.Metadata(title: 'Resolved'),
          source: testDiscoveredMediaSource(),
        ),
        'cctv': cctv.ResolveResponse(
          metadata: cctv.Metadata(title: 'Resolved'),
          source: testDiscoveredMediaSource(),
        ),
        'douyu': douyu.ResolveResponse(
          metadata: douyu.Metadata(title: 'Resolved'),
          source: testDiscoveredMediaSource(),
        ),
        'huya': huya.ResolveResponse(
          metadata: huya.Metadata(title: 'Resolved'),
          source: testDiscoveredMediaSource(),
        ),
      };
      final form = switch (provider) {
        'acfun' => AcFunAddMediaForm(
          roomId: 'room',
          playlistId: '',
          instances: const [],
          onDraftChanged: (_) {},
          onResolve: (_) async => await preview.future as acfun.ResolveResponse,
          onSubmit: (_) => submission.future,
        ),
        'cctv' => CctvAddMediaForm(
          roomId: 'room',
          playlistId: '',
          instances: const [],
          onDraftChanged: (_) {},
          onResolve: (_) async => await preview.future as cctv.ResolveResponse,
          onSubmit: (_) => submission.future,
        ),
        'douyu' => DouyuAddMediaForm(
          roomId: 'room',
          playlistId: '',
          instances: const [],
          onDraftChanged: (_) {},
          onResolve: (_) async => await preview.future as douyu.ResolveResponse,
          onSubmit: (_) => submission.future,
        ),
        'huya' => HuyaAddMediaForm(
          roomId: 'room',
          playlistId: '',
          instances: const [],
          onDraftChanged: (_) {},
          onResolve: (_) async => await preview.future as huya.ResolveResponse,
          onSubmit: (_) => submission.future,
        ),
        _ => throw StateError(provider),
      };
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: form),
        ),
      );
      await tester.enterText(find.byKey(Key('$provider-resource')), 'resource');
      await tester.pump();
      await tester.tap(find.byKey(Key('$provider-preview')));
      await tester.pump();
      Finder spinner(String action) => find.descendant(
        of: find.byKey(Key('$provider-$action')),
        matching: find.byType(AppLoadingIndicator),
      );
      expect(spinner('preview'), findsOneWidget);
      expect(spinner('submit'), findsNothing);
      preview.complete(responses[provider]);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('$provider-submit')));
      await tester.pump();
      expect(spinner('preview'), findsNothing);
      expect(spinner('submit'), findsOneWidget);
      submission.complete();
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpWidget(const SizedBox());
    });
  }
}
