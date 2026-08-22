@TestOn('browser')
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_runtime.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_media_preferences.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_engine_web.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_length_metadata.dart';

const _runE2e = bool.fromEnvironment('SYNCTV_WEB_P2P_E2E');
const _cacheBytes = 8 * 1024 * 1024;
final _unreachableOrigin = Uri.parse('http://127.0.0.1:9/unreachable.mp4');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'serves ranges, metadata, and cached pieces through the Service Worker',
    (_) async {
      final bytes = Uint8List.fromList(
        List<int>.generate(32, (index) => index),
      );
      final swarmId = 'web-e2e-${DateTime.now().microsecondsSinceEpoch}';
      final requestedKeys = <String>[];
      final availabilityChecks = <String>[];
      final first = await _createEngine(
        swarmId: swarmId,
        bytes: bytes,
        hasPeer: true,
        requestedKeys: requestedKeys,
        availabilityChecks: availabilityChecks,
      );
      expect(first.canRequestPeer(swarmId), isTrue);
      addTearDown(first.dispose);
      final localized = await first.localizeStatic(
        upstream: _unreachableOrigin,
        headers: const {},
        swarmId: swarmId,
        logicalKey: 'progressive',
      );

      final exact = await http.get(localized, headers: {'range': 'bytes=3-9'});
      expect(availabilityChecks.length, greaterThan(1));
      expect(availabilityChecks, everyElement(swarmId));
      expect(requestedKeys, contains('$swarmId|progressive:length'));
      expect(exact.statusCode, 206);
      expect(exact.headers['content-range'], 'bytes 3-9/32');
      expect(exact.bodyBytes, bytes.sublist(3, 10));

      final suffix = await http.get(localized, headers: {'range': 'bytes=-5'});
      expect(suffix.statusCode, 206);
      expect(suffix.headers['content-range'], 'bytes 27-31/32');
      expect(suffix.bodyBytes, bytes.sublist(27));

      final head = await http.head(localized, headers: {'range': 'bytes=4-7'});
      expect(head.statusCode, 206);
      expect(head.headers['content-range'], 'bytes 4-7/32');
      expect(head.headers['content-length'], '4');
      expect(head.bodyBytes, isEmpty);

      final unsatisfiable = await http.get(
        localized,
        headers: {'range': 'bytes=32-40'},
      );
      expect(unsatisfiable.statusCode, 416);
      expect(unsatisfiable.headers['content-range'], 'bytes */32');

      await first.dispose();
      final restored = await _createEngine(
        swarmId: swarmId,
        bytes: bytes,
        hasPeer: false,
      );
      addTearDown(restored.dispose);
      final restoredUri = await restored.localizeStatic(
        upstream: _unreachableOrigin,
        headers: const {},
        swarmId: swarmId,
        logicalKey: 'progressive',
      );
      final cached = await http.get(
        restoredUri,
        headers: {'range': 'bytes=10-15'},
      );
      expect(cached.statusCode, 206);
      expect(cached.bodyBytes, bytes.sublist(10, 16));
      expect(restored.stats.value.httpBytes, 0);
    },
    skip: !_runE2e,
  );

  testWidgets(
    'returns 502 before committing range metadata when the first piece fails',
    (_) async {
      final swarmId =
          'web-e2e-failure-${DateTime.now().microsecondsSinceEpoch}';
      final engine = await _createEngine(
        swarmId: swarmId,
        bytes: Uint8List.fromList(const [1, 2, 3, 4]),
        hasPeer: true,
        servePieces: false,
      );
      addTearDown(engine.dispose);
      final localized = await engine.localizeStatic(
        upstream: _unreachableOrigin,
        headers: const {},
        swarmId: swarmId,
        logicalKey: 'missing-piece',
      );

      final response = await http.get(
        localized,
        headers: {'range': 'bytes=0-3'},
      );
      expect(response.statusCode, 502);
      expect(response.headers['content-range'], isNull);
    },
    skip: !_runE2e,
  );

  testWidgets(
    'propagates response stream cancellation to an active peer request',
    (_) async {
      final firstPiece = Uint8List(1024 * 1024);
      final cancelled = Completer<void>();
      final swarmId = 'web-e2e-cancel-${DateTime.now().microsecondsSinceEpoch}';
      final requestedSwarms = <String>[];
      final engine = P2pMediaEngine(
        requestPeerPiece: (requestedSwarm, key, cancellation) async {
          requestedSwarms.add(requestedSwarm);
          if (key.endsWith(':length')) {
            return _peer(encodeP2pResourceLength(firstPiece.length * 2));
          }
          if (key.endsWith(':piece:0')) return _peer(firstPiece);
          if (key.endsWith(':piece:1')) {
            await cancellation.whenCancelled;
            if (!cancelled.isCompleted) cancelled.complete();
          }
          return null;
        },
        canRequestPeer: (requestedSwarm) => requestedSwarm == swarmId,
        maxCacheBytes: _cacheBytes,
        securityMode: P2pMediaSecurityMode.standard,
        serverBaseUrl: Uri.base.origin,
      );
      await engine.initialize();
      addTearDown(engine.dispose);
      final localized = await engine.localizeStatic(
        upstream: _unreachableOrigin,
        headers: const {},
        swarmId: swarmId,
        logicalKey: 'cancel',
      );
      final client = http.Client();
      addTearDown(client.close);
      final request = http.Request('GET', localized)
        ..headers['range'] = 'bytes=0-${firstPiece.length * 2 - 1}';
      final response = await client.send(request);
      expect(requestedSwarms, everyElement(swarmId));
      expect(response.statusCode, 206);
      late StreamSubscription<List<int>> subscription;
      subscription = response.stream.listen((_) {
        unawaited(subscription.cancel());
      });

      await cancelled.future.timeout(const Duration(seconds: 5));
    },
    skip: !_runE2e,
  );
}

Future<P2pMediaEngine> _createEngine({
  required String swarmId,
  required Uint8List bytes,
  required bool hasPeer,
  bool servePieces = true,
  List<String>? requestedKeys,
  List<String>? availabilityChecks,
}) async {
  final engine = P2pMediaEngine(
    requestPeerPiece: (requestedSwarm, key, _) async {
      requestedKeys?.add('$requestedSwarm|$key');
      if (!hasPeer) return null;
      if (key.endsWith(':length')) {
        return _peer(encodeP2pResourceLength(bytes.length));
      }
      if (servePieces && key.endsWith(':piece:0')) return _peer(bytes);
      return null;
    },
    canRequestPeer: (requestedSwarm) {
      availabilityChecks?.add(requestedSwarm);
      return hasPeer && requestedSwarm == swarmId;
    },
    maxCacheBytes: _cacheBytes,
    securityMode: P2pMediaSecurityMode.standard,
    serverBaseUrl: Uri.base.origin,
  );
  await engine.initialize();
  return engine;
}

P2pPeerPiece _peer(Uint8List bytes) => P2pPeerPiece(
  bytes: bytes,
  source: const P2pPeerSource(peerId: 'fixture-peer', swarmId: 'fixture'),
);
