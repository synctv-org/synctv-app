import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

Future<String> prepareDirectUrlAndAdd(
  String roomId, {
  String playlistId = '',
  required String url,
  required source_enum.PlaybackKind playbackKind,
  Map<String, String> headers = const {},
  String name = '',
  source_enum.PlaybackProxyMode proxyMode =
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
}) async {
  final preview = await SyncTvService.prepareDirectUrl(
    provider_common.PrepareDirectUrlRequest(
      url: url,
      headers: headers.entries,
      playbackKind: playbackKind,
      proxyMode: proxyMode,
    ),
  );
  if (!preview.hasSource()) {
    throw StateError('Direct URL prepare response is missing a source');
  }
  return SyncTvService.addDiscoveredSource(
    roomId,
    playlistId: playlistId,
    source: preview.source,
    name: name.isEmpty ? preview.suggestedName : name,
  );
}

Future<String> prepareRtmpAndAdd(
  String roomId, {
  String playlistId = '',
  String name = '',
  source_enum.RtmpStreamMode mode =
      source_enum.RtmpStreamMode.RTMP_STREAM_MODE_DEFAULT,
}) async {
  final preview = await SyncTvService.prepareRtmp(mode);
  if (!preview.hasSource()) {
    throw StateError('RTMP prepare response is missing a source');
  }
  return SyncTvService.addDiscoveredSource(
    roomId,
    playlistId: playlistId,
    source: preview.source,
    name: name.isEmpty ? preview.suggestedName : name,
  );
}

Future<String> prepareHttpFlvAndAdd(
  String roomId, {
  String playlistId = '',
  required String url,
  String name = '',
}) async {
  final preview = await SyncTvService.prepareLiveProxy(
    provider_common.PrepareLiveProxyRequest(
      httpFlv: provider_common.PrepareHttpFlvPullIntent(url: url),
    ),
  );
  if (!preview.hasSource()) {
    throw StateError('Live proxy prepare response is missing a source');
  }
  return SyncTvService.addDiscoveredSource(
    roomId,
    playlistId: playlistId,
    source: preview.source,
    name: name.isEmpty ? preview.suggestedName : name,
  );
}
