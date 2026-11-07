import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

/// DASH capability entries for one MSE pipeline.
///
/// MSE decodes each track through its own SourceBuffer and the server
/// matches codec strings token-wise, so advertising the full video×audio
/// cross product is redundant: one entry per video token (paired with the
/// first supported audio) plus one per remaining audio token (paired with
/// the first supported video) covers every codec string exactly as well.
/// Without this collapse, WebKit browsers that expose both MediaSource and
/// ManagedMediaSource with broad codec reach (iPad, iOS 17+) build 100+
/// entries and exceed the protocol's 64-item ceiling — the server then
/// rejects the whole observe message and playback never starts
/// (synctv#530).
List<client.PlaybackMediaCapability> buildDashCapabilityEntries({
  required List<(String, client_enum.PlaybackVideoCodec)> supportedVideo,
  required List<(String, client_enum.PlaybackAudioCodec)> supportedAudio,
  required client_enum.PlaybackMediaPipeline pipeline,
}) {
  if (supportedVideo.isEmpty || supportedAudio.isEmpty) return const [];
  final primaryAudio = supportedAudio.first;
  final primaryVideo = supportedVideo.first;
  return [
    for (final (videoCodecString, videoCodec) in supportedVideo)
      client.PlaybackMediaCapability(
        transport: client_enum
            .PlaybackMediaTransport
            .PLAYBACK_MEDIA_TRANSPORT_DASH,
        container: client_enum.PlaybackContainer.PLAYBACK_CONTAINER_MP4,
        videoCodec: videoCodec,
        audioCodec: primaryAudio.$2,
        pipeline: pipeline,
        codecString: '$videoCodecString,${primaryAudio.$1}',
      ),
    for (final (audioCodecString, audioCodec) in supportedAudio.skip(1))
      client.PlaybackMediaCapability(
        transport: client_enum
            .PlaybackMediaTransport
            .PLAYBACK_MEDIA_TRANSPORT_DASH,
        container: client_enum.PlaybackContainer.PLAYBACK_CONTAINER_MP4,
        videoCodec: primaryVideo.$2,
        audioCodec: audioCodec,
        pipeline: pipeline,
        codecString: '${primaryVideo.$1},$audioCodecString',
      ),
  ];
}
