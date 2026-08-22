import 'package:synctv_app/features/media_p2p/application/p2p_media_runtime.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_media_preferences.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_engine_web.dart';
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
    final engine = P2pMediaEngine(
      requestPeerPiece: session.requestPiece,
      reportPeerIntegrity: session.reportPeerIntegrity,
      canRequestPeer: session.canRequestPeer,
      maxCacheBytes: maxCacheBytes,
      securityMode: securityMode,
      serverBaseUrl: serverBaseUrl,
    );
    await engine.initialize();
    return engine;
  }
}
