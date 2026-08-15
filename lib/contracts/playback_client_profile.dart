import 'package:flutter/foundation.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

client.PlaybackClientProfile defaultPlaybackClientProfile() {
  return client.PlaybackClientProfile(
    streamPreference:
        client_enum.PlaybackStreamPreference.PLAYBACK_STREAM_PREFERENCE_AUTO,
    maxAudioChannels: 2,
    supportedVideoCodecs: [
      client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_H264,
      client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_HEVC,
      client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_VP9,
      client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_AV1,
    ],
    supportedContainers: [
      client_enum.PlaybackContainer.PLAYBACK_CONTAINER_MP4,
      client_enum.PlaybackContainer.PLAYBACK_CONTAINER_MKV,
      client_enum.PlaybackContainer.PLAYBACK_CONTAINER_WEBM,
    ],
    supportedLiveTransports: [
      if (kIsWeb)
        client_enum.PlaybackLiveTransport.PLAYBACK_LIVE_TRANSPORT_HLS
      else
        client_enum.PlaybackLiveTransport.PLAYBACK_LIVE_TRANSPORT_FLV,
    ],
    audioCapability:
        client_enum.PlaybackAudioCapability.PLAYBACK_AUDIO_CAPABILITY_STEREO,
    subtitlePreference: client_enum
        .PlaybackSubtitlePreference
        .PLAYBACK_SUBTITLE_PREFERENCE_EXTERNAL,
  );
}
