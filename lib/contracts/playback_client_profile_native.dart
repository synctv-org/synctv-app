import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

const _version = 2;

bool supportsP2pMediaLoader() => true;

client.PlaybackClientProfile buildPlaybackClientProfile() {
  final videoCodecs = [
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_H264,
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_HEVC,
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_VP9,
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_AV1,
  ];
  final containers = [
    client_enum.PlaybackContainer.PLAYBACK_CONTAINER_MP4,
    client_enum.PlaybackContainer.PLAYBACK_CONTAINER_MKV,
    client_enum.PlaybackContainer.PLAYBACK_CONTAINER_WEBM,
  ];

  return client.PlaybackClientProfile(
    profileVersion: _version,
    environment: client_enum
        .PlaybackClientEnvironment
        .PLAYBACK_CLIENT_ENVIRONMENT_NATIVE,
    streamPreference:
        client_enum.PlaybackStreamPreference.PLAYBACK_STREAM_PREFERENCE_AUTO,
    maxAudioChannels: 2,
    supportedVideoCodecs: videoCodecs,
    supportedContainers: containers,
    supportedLiveTransports: [
      client_enum.PlaybackLiveTransport.PLAYBACK_LIVE_TRANSPORT_FLV,
      client_enum.PlaybackLiveTransport.PLAYBACK_LIVE_TRANSPORT_HLS,
    ],
    audioCapability:
        client_enum.PlaybackAudioCapability.PLAYBACK_AUDIO_CAPABILITY_STEREO,
    subtitlePreference: client_enum
        .PlaybackSubtitlePreference
        .PLAYBACK_SUBTITLE_PREFERENCE_EXTERNAL,
    mediaCapabilities: [
      for (final container in containers)
        for (final videoCodec in videoCodecs)
          client.PlaybackMediaCapability(
            transport: client_enum
                .PlaybackMediaTransport
                .PLAYBACK_MEDIA_TRANSPORT_PROGRESSIVE,
            container: container,
            videoCodec: videoCodec,
            pipeline: client_enum
                .PlaybackMediaPipeline
                .PLAYBACK_MEDIA_PIPELINE_NATIVE,
          ),
      for (final transport in [
        client_enum.PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_HLS,
        client_enum.PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_DASH,
        client_enum.PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_FLV,
        client_enum.PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_MPEG_TS,
      ])
        client.PlaybackMediaCapability(
          transport: transport,
          pipeline:
              client_enum.PlaybackMediaPipeline.PLAYBACK_MEDIA_PIPELINE_NATIVE,
        ),
    ],
    supportsCustomHttpHeaders: true,
    supportsProviderProxy: true,
    supportsInsecureHttpMedia: true,
  );
}
