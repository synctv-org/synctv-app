import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_media_preferences.dart';
import 'package:synctv_app/contracts/room_management_models.dart';

typedef P2pMediaSignalingCallback =
    void Function(String type, Map<String, dynamic> data);
typedef P2pCachedPieceLoader =
    Future<Uint8List?> Function(String swarmId, String pieceKey);
typedef P2pIceServersLoader = Future<List<IceServerInfo>> Function();

final class P2pPieceRequestCancellation {
  final Completer<void> _cancelled = Completer<void>();

  bool get isCancelled => _cancelled.isCompleted;
  Future<void> get whenCancelled => _cancelled.future;

  void cancel() {
    if (!_cancelled.isCompleted) _cancelled.complete();
  }
}

@immutable
final class P2pPeerSource {
  const P2pPeerSource({required this.peerId, required this.swarmId});

  final String peerId;
  final String swarmId;
}

@immutable
final class P2pPeerPiece {
  const P2pPeerPiece({required this.bytes, required this.source});

  final Uint8List bytes;
  final P2pPeerSource source;
}

@immutable
final class P2pMediaStats {
  const P2pMediaStats({
    this.httpBytes = 0,
    this.p2pBytes = 0,
    this.cacheBytes = 0,
    this.cacheHits = 0,
    this.cacheMisses = 0,
    this.integrityChecks = 0,
    this.integrityMismatches = 0,
    this.integrityUnavailable = 0,
  });

  final int httpBytes;
  final int p2pBytes;
  final int cacheBytes;
  final int cacheHits;
  final int cacheMisses;
  final int integrityChecks;
  final int integrityMismatches;
  final int integrityUnavailable;

  P2pMediaStats copyWith({
    int? httpBytes,
    int? p2pBytes,
    int? cacheBytes,
    int? cacheHits,
    int? cacheMisses,
    int? integrityChecks,
    int? integrityMismatches,
    int? integrityUnavailable,
  }) {
    return P2pMediaStats(
      httpBytes: httpBytes ?? this.httpBytes,
      p2pBytes: p2pBytes ?? this.p2pBytes,
      cacheBytes: cacheBytes ?? this.cacheBytes,
      cacheHits: cacheHits ?? this.cacheHits,
      cacheMisses: cacheMisses ?? this.cacheMisses,
      integrityChecks: integrityChecks ?? this.integrityChecks,
      integrityMismatches: integrityMismatches ?? this.integrityMismatches,
      integrityUnavailable: integrityUnavailable ?? this.integrityUnavailable,
    );
  }
}

abstract interface class P2pMediaSession {
  Set<String> get activeSwarms;
  int get connectedPeerCount;
  int get uploadedBytes;

  bool hasConnectedPeer(String swarmId);
  bool canRequestPeer(String swarmId);
  Future<void> setActiveSwarms(Map<String, String> swarms);
  Future<void> resetSignalingSession();
  void handleSignalingMessage(String type, Map<String, dynamic> data);
  Future<P2pPeerPiece?> requestPiece(
    String swarmId,
    String pieceKey,
    P2pPieceRequestCancellation cancellation,
  );
  Future<void> reportPeerIntegrity(P2pPeerSource source, bool valid);
  Future<void> dispose();
}

abstract interface class P2pMediaPlaybackEngine {
  int get maxCacheBytes;
  P2pMediaSecurityMode get securityMode;
  ValueListenable<P2pMediaStats> get stats;

  Future<Uri> localize({
    required Uri upstream,
    required Map<String, String> headers,
    required String swarmId,
    required String format,
  });
  Future<Uri> localizeStatic({
    required Uri upstream,
    required Map<String, String> headers,
    required String swarmId,
    required String logicalKey,
  });
  Future<Uint8List?> cachedPiece(String swarmId, String pieceKey);
  Future<void> dispose();
}

abstract interface class P2pMediaRuntimeFactory {
  P2pMediaSession createSession({
    required P2pMediaSignalingCallback onSignalingMessage,
    required P2pIceServersLoader loadIceServers,
    required P2pCachedPieceLoader loadCachedPiece,
    required void Function() onStateChange,
  });

  Future<P2pMediaPlaybackEngine> createPlaybackEngine({
    required P2pMediaSession session,
    required String serverBaseUrl,
    required int maxCacheBytes,
    required P2pMediaSecurityMode securityMode,
  });
}
