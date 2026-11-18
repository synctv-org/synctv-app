import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/playback_client_profile_native.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart';

void main() {
  test('native profile advertises the full local pipeline capability set', () {
    final profile = buildPlaybackClientProfile();

    expect(
      profile.environment,
      PlaybackClientEnvironment.PLAYBACK_CLIENT_ENVIRONMENT_NATIVE,
    );
    expect(profile.profileVersion, 2);
    expect(profile.maxAudioChannels, 2);
    expect(
      profile.audioCapability,
      PlaybackAudioCapability.PLAYBACK_AUDIO_CAPABILITY_STEREO,
    );
    expect(
      profile.streamPreference,
      PlaybackStreamPreference.PLAYBACK_STREAM_PREFERENCE_AUTO,
    );
    expect(
      profile.subtitlePreference,
      PlaybackSubtitlePreference.PLAYBACK_SUBTITLE_PREFERENCE_EXTERNAL,
    );
    expect(
      profile.supportedLiveTransports,
      containsAll({
        PlaybackLiveTransport.PLAYBACK_LIVE_TRANSPORT_FLV,
        PlaybackLiveTransport.PLAYBACK_LIVE_TRANSPORT_HLS,
      }),
    );

    // Native players attach arbitrary headers and accept plain-HTTP media.
    expect(profile.supportsCustomHttpHeaders, isTrue);
    expect(profile.supportsProviderProxy, isTrue);
    expect(profile.supportsInsecureHttpMedia, isTrue);
    expect(supportsP2pMediaLoader(), isTrue);
  });

  test('every progressive codec/container pair is declared natively', () {
    final profile = buildPlaybackClientProfile();
    const containers = [
      PlaybackContainer.PLAYBACK_CONTAINER_MP4,
      PlaybackContainer.PLAYBACK_CONTAINER_MKV,
      PlaybackContainer.PLAYBACK_CONTAINER_WEBM,
    ];
    const videoCodecs = [
      PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_H264,
      PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_HEVC,
      PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_VP9,
      PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_AV1,
    ];

    final progressive = <(PlaybackContainer, PlaybackVideoCodec)>{};
    for (final capability in profile.mediaCapabilities) {
      expect(
        capability.pipeline,
        PlaybackMediaPipeline.PLAYBACK_MEDIA_PIPELINE_NATIVE,
      );
      if (capability.transport ==
          PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_PROGRESSIVE) {
        progressive.add((capability.container, capability.videoCodec));
      }
    }

    for (final container in containers) {
      for (final codec in videoCodecs) {
        expect(
          progressive,
          contains((container, codec)),
          reason: 'missing $container x $codec',
        );
      }
    }
  });

  test('adaptive transports are declared and the profile stays under the server ceiling', () {
    final profile = buildPlaybackClientProfile();
    final adaptiveTransports = profile.mediaCapabilities
        .where(
          (capability) =>
              capability.transport !=
              PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_PROGRESSIVE,
        )
        .map((capability) => capability.transport)
        .toSet();

    expect(
      adaptiveTransports,
      containsAll({
        PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_HLS,
        PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_DASH,
        PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_FLV,
        PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_MPEG_TS,
      }),
    );

    // The server rejects the whole observe message when the profile exceeds
    // the 64-item media_capabilities ceiling (synctv#530).
    expect(profile.mediaCapabilities.length, lessThan(64));
  });

  test(
    'supported codec and container declarations match the capability matrix',
    () {
      final profile = buildPlaybackClientProfile();

      final declaredContainers = profile.supportedContainers.toSet();
      final declaredCodecs = profile.supportedVideoCodecs.toSet();

      final usedContainers = profile.mediaCapabilities
          .map((capability) => capability.container)
          .where(
            (container) =>
                container != PlaybackContainer.PLAYBACK_CONTAINER_UNSPECIFIED,
          )
          .toSet();
      final usedCodecs = profile.mediaCapabilities
          .map((capability) => capability.videoCodec)
          .where(
            (codec) =>
                codec != PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_UNSPECIFIED,
          )
          .toSet();

      expect(usedContainers, declaredContainers);
      expect(usedCodecs, declaredCodecs);
    },
  );
}
