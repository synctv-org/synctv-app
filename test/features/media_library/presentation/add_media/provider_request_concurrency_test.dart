import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/fnos_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/nextcloud_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/qnap_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/seafile_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/synology_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/truenas_add_media_form.dart';
import 'package:synctv_app/l10n/l10n.dart';

import '../../../../test_app.dart';

void main() {
  for (final kind in [
    'nextcloud',
    'truenas',
    'qnap',
    'fnos',
    'seafile',
    'synology',
  ]) {
    for (final staleError in [false, true]) {
      testWidgets(
        '$kind replaces in-flight account requests (error: $staleError)',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(1000, 850));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final requests = _Requests();
          Future<void> pump(String id) => tester.pumpWidget(
            MaterialApp(
              locale: const Locale('en'),
              builder: buildThemedTestApp,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(body: _form(kind, id, requests)),
            ),
          );
          await pump('old');
          await tester.pump();
          expect(requests.ids, ['old']);
          await pump('latest');
          await tester.pump();
          expect(requests.ids, ['old', 'latest']);
          requests.pending[1].complete(true);
          await tester.pumpAndSettle();
          if (staleError) {
            requests.pending[0].completeError(
              StateError('stale provider failure'),
            );
          } else {
            requests.pending[0].complete(false);
          }
          await tester.pumpAndSettle();
          expect(find.textContaining('stale provider failure'), findsNothing);
          final next = tester.widget<AppIconButton>(
            find.byWidgetPredicate(
              (widget) =>
                  widget is AppIconButton && widget.tooltip == 'Next page',
            ),
          );
          expect(next.onPressed, isNotNull);
          await tester.pumpWidget(const SizedBox.shrink());
          expect(tester.takeException(), isNull);
        },
      );
    }
  }

  testWidgets(
    'TrueNAS submits a newer search while the previous query is pending',
    (tester) async {
      final requests = _Requests();
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          builder: buildThemedTestApp,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: _form('truenas', 'account', requests)),
        ),
      );
      await tester.pump();
      requests.pending[0].complete(false);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'first');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'second');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();
      expect(requests.queries, ['', 'first', 'second']);
      requests.pending[2].complete(true);
      await tester.pumpAndSettle();
      requests.pending[1].complete(false);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}

class _Requests {
  final ids = <String>[];
  final queries = <String>[];
  final pending = <Completer<bool>>[];

  Future<bool> load(String id, String query) {
    ids.add(id);
    queries.add(query);
    final completer = Completer<bool>();
    pending.add(completer);
    return completer.future;
  }
}

Widget _form(String kind, String id, _Requests requests) => switch (kind) {
  'nextcloud' => NextcloudAddMediaForm(
    roomId: 'room',
    playlistId: '',
    resourceHeaders: () => {},
    binds: [
      NextcloudBindInfo(
        id: id,
        serverId: id,
        endpoint: 'https://example.com',
        username: 'User',
        userId: id,
        displayName: id,
        version: '',
        edition: '',
        createdAt: 1,
        providerInstanceName: '',
      ),
    ],
    fileLoader: (bind, mode, path, query, page, size) async =>
        NextcloudFileListPage(
          items: [],
          total: 100,
          page: page,
          hasMore: await requests.load(bind.id, query),
          source: null,
        ),
  ),
  'truenas' => TrueNasAddMediaForm(
    roomId: 'room',
    playlistId: '',
    binds: [
      TrueNasBindInfo(
        id: id,
        serverId: id,
        endpoint: 'https://example.com',
        hostname: id,
        version: '',
        systemProduct: '',
        createdAt: 1,
        providerInstanceName: '',
      ),
    ],
    pageLoader: (bind, path, query, page, size) async => TrueNasFileListPage(
      items: [],
      total: 100,
      page: page,
      hasMore: await requests.load(bind.id, query),
      source: null,
    ),
  ),
  'qnap' => QnapAddMediaForm(
    roomId: 'room',
    playlistId: '',
    resourceHeaders: () => {},
    binds: [
      QnapBindInfo(
        id: id,
        serverId: id,
        endpoint: 'https://example.com',
        username: 'User',
        serverName: id,
        version: '',
        supportRtt: false,
        createdAt: 1,
        providerInstanceName: '',
      ),
    ],
    fileLoader: (bind, path, page, size, query) async => QnapFileListPage(
      items: [],
      total: 100,
      page: page,
      hasMore: await requests.load(bind.id, query),
      realtimeTranscode: false,
      source: null,
    ),
  ),
  'fnos' => FnosAddMediaForm(
    roomId: 'room',
    playlistId: '',
    binds: [
      FnosBindInfo(
        id: id,
        serverId: id,
        endpoint: 'https://example.com',
        webdavEndpoint: '',
        mediaEndpoint: '',
        username: id,
        createdAt: 1,
        providerInstanceName: '',
        mediaAvailable: false,
      ),
    ],
    fileLoader: (bind, path, page, size, query) async => FnosFileListPage(
      items: [],
      total: 100,
      page: page,
      hasMore: await requests.load(bind.id, query),
      source: null,
    ),
  ),
  'seafile' => SeafileAddMediaForm(
    roomId: 'room',
    playlistId: '',
    resourceHeaders: () => {},
    binds: [
      SeafileBindInfo(
        id: id,
        serverId: id,
        endpoint: 'https://example.com',
        username: id,
        version: '',
        features: [],
        createdAt: 1,
        providerInstanceName: '',
      ),
    ],
    pageLoader: (bind, mode, repository, path, query, page, size) async =>
        SeafileFileListPage(
          items: [],
          total: 100,
          page: page,
          hasMore: await requests.load(bind.id, query),
          source: null,
        ),
  ),
  'synology' => SynologyAddMediaForm(
    roomId: 'room',
    playlistId: '',
    binds: [
      SynologyBindInfo(
        id: id,
        serverId: id,
        endpoint: 'https://example.com',
        username: id,
        videoStationAvailable: false,
        createdAt: 1,
        providerInstanceName: '',
      ),
    ],
    fileLoader: (bind, path, page, size, query) async => SynologyFileListPage(
      items: [],
      total: 100,
      page: page,
      hasMore: await requests.load(bind.id, query),
      source: null,
    ),
  ),
  _ => throw ArgumentError.value(kind),
};
