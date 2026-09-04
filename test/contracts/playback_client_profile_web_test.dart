@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/playback_client_profile.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart';

void main() {
  test('advertises only implemented browser delivery features', () {
    final profile = defaultPlaybackClientProfile();
    final transports = profile.mediaCapabilities
        .map((capability) => capability.transport)
        .toSet();

    expect(
      profile.environment,
      PlaybackClientEnvironment.PLAYBACK_CLIENT_ENVIRONMENT_WEB,
    );
    expect(profile.supportsCustomHttpHeaders, isFalse);
    expect(profile.supportsProviderProxy, isTrue);
    expect(supportsP2pMediaLoader(), isTrue);
    expect(
      profile.supportsInsecureHttpMedia,
      Uri.base.scheme.toLowerCase() == 'http',
    );
    expect(
      transports,
      contains(PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_PROGRESSIVE),
    );
    if (transports.any(
      (transport) =>
          transport !=
          PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_PROGRESSIVE,
    )) {
      expect(
        transports,
        containsAll({
          PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_HLS,
          PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_DASH,
          PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_FLV,
          PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_MPEG_TS,
        }),
      );
    }

    final dashCapabilities = profile.mediaCapabilities.where(
      (capability) =>
          capability.transport ==
          PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_DASH,
    );
    final h264DashCodecs = dashCapabilities
        .where(
          (capability) =>
              capability.videoCodec ==
              PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_H264,
        )
        .map((capability) => capability.codecString.toLowerCase())
        .toSet();
    if (h264DashCodecs.isNotEmpty) {
      expect(h264DashCodecs, contains('avc1.64001f,mp4a.40.2'));
      expect(
        dashCapabilities.every(
          (capability) =>
              capability.container == PlaybackContainer.PLAYBACK_CONTAINER_MP4,
        ),
        isTrue,
      );
    }
  });
}
