import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_instance_selector.dart';
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
    for (final scenario in [
      'duplicate preview',
      'same instance',
      'removed instance',
      'old preview',
      'old failure',
      'old submit',
    ]) {
      testWidgets('$provider $scenario preserves current operation and draft', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(1000, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        var room = 'first';
        var instances = <String>['remote'];
        final pending = <Completer<dynamic>>[];
        final submissions = <Completer<void>>[];
        Future<dynamic> resolve(String resource) {
          final completion = Completer<dynamic>();
          pending.add(completion);
          return completion.future;
        }

        Future<void> submit(dynamic request) {
          final completion = Completer<void>();
          submissions.add(completion);
          return completion.future;
        }

        final responses = <String, dynamic>{
          'acfun': acfun.ResolveResponse(
            metadata: acfun.Metadata(title: 'Current preview'),
            source: testDiscoveredMediaSource(),
          ),
          'cctv': cctv.ResolveResponse(
            metadata: cctv.Metadata(title: 'Current preview'),
            source: testDiscoveredMediaSource(),
          ),
          'douyu': douyu.ResolveResponse(
            metadata: douyu.Metadata(title: 'Current preview'),
            source: testDiscoveredMediaSource(),
          ),
          'huya': huya.ResolveResponse(
            metadata: huya.Metadata(title: 'Current preview'),
            source: testDiscoveredMediaSource(),
          ),
        };
        Future<acfun.ResolveResponse> acfunResolve(String resource) async =>
            await resolve(resource) as acfun.ResolveResponse;
        Future<cctv.ResolveResponse> cctvResolve(String resource) async =>
            await resolve(resource) as cctv.ResolveResponse;
        Future<douyu.ResolveResponse> douyuResolve(String resource) async =>
            await resolve(resource) as douyu.ResolveResponse;
        Future<huya.ResolveResponse> huyaResolve(String resource) async =>
            await resolve(resource) as huya.ResolveResponse;
        late StateSetter update;
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  update = setState;
                  return switch (provider) {
                    'acfun' => AcFunAddMediaForm(
                      roomId: room,
                      playlistId: '',
                      instances: instances,
                      onDraftChanged: (_) {},
                      onResolve: acfunResolve,
                      onSubmit: submit,
                    ),
                    'cctv' => CctvAddMediaForm(
                      roomId: room,
                      playlistId: '',
                      instances: instances,
                      onDraftChanged: (_) {},
                      onResolve: cctvResolve,
                      onSubmit: submit,
                    ),
                    'douyu' => DouyuAddMediaForm(
                      roomId: room,
                      playlistId: '',
                      instances: instances,
                      onDraftChanged: (_) {},
                      onResolve: douyuResolve,
                      onSubmit: submit,
                    ),
                    'huya' => HuyaAddMediaForm(
                      roomId: room,
                      playlistId: '',
                      instances: instances,
                      onDraftChanged: (_) {},
                      onResolve: huyaResolve,
                      onSubmit: submit,
                    ),
                    _ => throw StateError(provider),
                  };
                },
              ),
            ),
          ),
        );
        await tester.enterText(
          find.byKey(Key('$provider-resource')),
          'resource',
        );
        await tester.pump();
        if (scenario == 'removed instance') {
          tester
              .widget<ProviderInstanceSelector>(
                find.byType(ProviderInstanceSelector),
              )
              .onChanged('remote');
          await tester.pump();
        }
        final preview = tester
            .widget<OutlinedButton>(find.byKey(Key('$provider-preview')))
            .onPressed!;
        preview();
        if (scenario == 'duplicate preview') {
          preview();
          expect(pending, hasLength(1));
        }
        await tester.pump();
        if (scenario == 'old preview' || scenario == 'old failure') {
          update(() => room = 'second');
          await tester.pump();
          final next = tester
              .widget<OutlinedButton>(find.byKey(Key('$provider-preview')))
              .onPressed;
          expect(next, isNotNull);
          next!();
          await tester.pump();
          if (scenario == 'old failure') {
            pending.first.completeError(StateError('obsolete failure'));
          } else {
            pending.first.complete(responses[provider]);
          }
          await tester.pump();
          expect(find.text('Current preview'), findsNothing);
          expect(find.textContaining('obsolete failure'), findsNothing);
          expect(
            tester
                .widget<OutlinedButton>(find.byKey(Key('$provider-preview')))
                .onPressed,
            isNull,
          );
          pending.last.complete(responses[provider]);
          await tester.pumpAndSettle();
          expect(find.text('Current preview'), findsOneWidget);
        } else {
          pending.first.complete(responses[provider]);
          await tester.pumpAndSettle();
          if (scenario == 'same instance') {
            tester
                .widget<ProviderInstanceSelector>(
                  find.byType(ProviderInstanceSelector),
                )
                .onChanged('');
            await tester.pump();
            expect(find.text('Current preview'), findsOneWidget);
          }
          if (scenario == 'removed instance') {
            update(() => instances = []);
            await tester.pump();
            expect(find.text('Current preview'), findsNothing);
            expect(
              tester
                  .widget<FilledButton>(find.byKey(Key('$provider-submit')))
                  .onPressed,
              isNull,
            );
          }
          if (scenario == 'old submit') {
            final add = tester
                .widget<FilledButton>(find.byKey(Key('$provider-submit')))
                .onPressed!;
            add();
            add();
            expect(submissions, hasLength(1));
            await tester.pump();
            update(() => room = 'second');
            await tester.pump();
            submissions.first.complete();
            await tester.pumpAndSettle();
            final field = tester.widget<TextField>(
              find.descendant(
                of: find.byKey(Key('$provider-resource')),
                matching: find.byType(TextField),
              ),
            );
            expect(field.controller!.text, 'resource');
            expect(find.text('Current preview'), findsNothing);
          }
        }
        await tester.pumpWidget(const SizedBox());
      });
    }
  }
}
