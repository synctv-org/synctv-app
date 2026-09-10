@TestOn('vm')
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/core/time/synced_clock.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await SyncTvService.init();
  });

  tearDown(SyncedClock.reset);

  void syncClock() {
    SyncedClock.updateFromServerTime(
      clientSentAtNanos: 1000000,
      clientReceivedAtNanos: 2000000,
      serverReceivedAtNanos: 3000000,
      serverSentAtNanos: 3000000,
    );
  }

  Future<HttpServer> serve(Future<void> Function(HttpRequest) handle) async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen(handle);
    addTearDown(() async {
      await subscription.cancel();
      await server.close(force: true);
    });
    await SyncTvService.setBaseUrl('http://127.0.0.1:${server.port}');
    return server;
  }

  Future<void> reply(HttpRequest request, String name) async {
    request.response.headers.contentType = ContentType.json;
    request.response.write(jsonEncode({'serverId': name, 'serverName': name}));
    await request.response.close();
  }

  test('repeated startup preserves cached server metadata', () async {
    var requests = 0;
    await serve((request) async {
      requests++;
      await reply(request, 'first');
    });
    final original = await SyncTvService.getServerInfo();
    await Future.wait([SyncTvService.init(), SyncTvService.init()]);
    final cached = await SyncTvService.getServerInfo();
    expect(cached, same(original));
    expect(requests, 1);
  });

  for (final delta in [-60000000000, 1]) {
    for (final previous in [false, true]) {
      test(
        'mismatched time reply ($delta) preserves calibration: $previous',
        () async {
          await serve((request) async {
            final sent = int.parse(
              request.uri.queryParameters['clientSentAtNanos']!,
            );
            request.response.headers.contentType = ContentType.json;
            request.response.write(
              jsonEncode({
                'clientSentAtNanos': '${sent + delta}',
                'serverReceivedAtNanos': '$sent',
                'serverSentAtNanos': '$sent',
              }),
            );
            await request.response.close();
          });
          if (previous) syncClock();
          final syncedAt = SyncedClock.syncedAt;
          final latency = SyncedClock.estimatedLatency;
          await SyncTvService.syncServerTime(refresh: true);
          expect(SyncedClock.isSynced, previous);
          expect(SyncedClock.syncedAt, syncedAt);
          expect(SyncedClock.estimatedLatency, latency);
        },
      );
    }
  }

  test('matching time reply still calibrates through real HTTP', () async {
    await serve((request) async {
      final sent = request.uri.queryParameters['clientSentAtNanos']!;
      request.response.headers.contentType = ContentType.json;
      request.response.write(
        jsonEncode({
          'clientSentAtNanos': sent,
          'serverReceivedAtNanos': sent,
          'serverSentAtNanos': sent,
        }),
      );
      await request.response.close();
    });
    await SyncTvService.syncServerTime(refresh: true);
    expect(SyncedClock.isSynced, isTrue);
    expect(SyncedClock.estimatedLatency, isNotNull);
  });

  test('repeated startup preserves an in-flight metadata request', () async {
    final started = Completer<void>();
    final release = Completer<void>();
    var requests = 0;
    await serve((request) async {
      requests++;
      if (!started.isCompleted) started.complete();
      await release.future;
      await reply(request, 'pending');
    });
    final first = SyncTvService.getServerInfo();
    await started.future;
    await SyncTvService.init();
    final second = SyncTvService.getServerInfo();
    release.complete();
    final results = await Future.wait([first, second]);
    expect(results.last, same(results.first));
    expect(requests, 1);
  });

  test('repeated startup preserves synchronized server time', () async {
    syncClock();
    final syncedAt = SyncedClock.syncedAt;
    await Future.wait([SyncTvService.init(), SyncTvService.init()]);
    expect(SyncedClock.isSynced, isTrue);
    expect(SyncedClock.syncedAt, syncedAt);
  });

  test('explicit server selection still replaces metadata and time', () async {
    await serve((request) => reply(request, 'first'));
    expect((await SyncTvService.getServerInfo()).serverName, 'first');
    syncClock();
    await serve((request) => reply(request, 'second'));
    expect(SyncedClock.isSynced, isFalse);
    await SyncTvService.init();
    expect((await SyncTvService.getServerInfo()).serverName, 'second');
  });
}
