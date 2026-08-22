import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synctv_app/core/network/server_endpoint_identity.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_runtime.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_media_preferences.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_cache.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_engine.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_manager.dart';

final class NativeP2pMediaRuntimeFactory implements P2pMediaRuntimeFactory {
  const NativeP2pMediaRuntimeFactory();

  @override
  P2pMediaSession createSession({
    required P2pMediaSignalingCallback onSignalingMessage,
    required P2pIceServersLoader loadIceServers,
    required P2pCachedPieceLoader loadCachedPiece,
    required void Function() onStateChange,
  }) {
    return P2pMediaManager(
      onSignalingMessage: onSignalingMessage,
      loadIceServers: loadIceServers,
      loadCachedPiece: loadCachedPiece,
      onStateChange: onStateChange,
    );
  }

  @override
  Future<P2pMediaPlaybackEngine> createPlaybackEngine({
    required P2pMediaSession session,
    required String serverBaseUrl,
    required int maxCacheBytes,
    required P2pMediaSecurityMode securityMode,
  }) async {
    P2pMediaPersistentCache? persistentCache;
    try {
      final root = await getApplicationCacheDirectory();
      final namespace = ServerEndpointIdentity.storageNamespace(serverBaseUrl);
      persistentCache = P2pMediaPersistentCache(
        directory: Directory('${root.path}/p2p_media/$namespace'),
        maxBytes: maxCacheBytes,
      );
    } catch (error) {
      debugPrint('P2P media persistent cache unavailable: $error');
    }
    return P2pMediaEngine(
      requestPeerPiece: session.requestPiece,
      reportPeerIntegrity: session.reportPeerIntegrity,
      canRequestPeer: session.canRequestPeer,
      maxCacheBytes: maxCacheBytes,
      persistentCache: persistentCache,
      securityMode: securityMode,
    );
  }
}
