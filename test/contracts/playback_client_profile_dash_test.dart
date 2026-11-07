import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/playback_client_profile_dash.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

void main() {
  group('buildDashCapabilityEntries', () {
    const h264 = client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_H264;
    const hevc = client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_HEVC;
    const aac = client_enum.PlaybackAudioCodec.PLAYBACK_AUDIO_CODEC_AAC;
    const eac3 = client_enum.PlaybackAudioCodec.PLAYBACK_AUDIO_CODEC_EAC3;

    test('collapses the video×audio cross product', () {
      final entries = buildDashCapabilityEntries(
        supportedVideo: [
          ('avc1.42E01E', h264),
          ('avc1.64001F', h264),
          ('hvc1.1.6.L93.B0', hevc),
        ],
        supportedAudio: [('mp4a.40.2', aac), ('ec-3', eac3)],
        pipeline:
            client_enum.PlaybackMediaPipeline.PLAYBACK_MEDIA_PIPELINE_NATIVE,
      );

      // 3 video entries + 1 extra audio entry instead of 3×2 = 6.
      expect(entries, hasLength(4));

      final codecStrings = entries
          .map((entry) => entry.codecString.toLowerCase())
          .toSet();
      // Every distinct video token stays advertised.
      expect(codecStrings, contains('avc1.42e01e,mp4a.40.2'));
      expect(codecStrings, contains('avc1.64001f,mp4a.40.2'));
      expect(codecStrings, contains('hvc1.1.6.l93.b0,mp4a.40.2'));
      // The extra audio token pairs with the first supported video.
      expect(codecStrings, contains('avc1.42e01e,ec-3'));
    });

    test('keeps the worst-case dual-pipeline matrix under the wire limit', () {
      // The full candidate list (20 video × 3 audio) on both MSE pipelines
      // would previously emit 120 DASH entries; the collapse emits one per
      // video token plus one per extra audio token per pipeline.
      const videoTokens = [
        'avc1.42E01E',
        'avc1.64001E',
        'avc1.64001F',
        'avc1.640028',
        'avc1.64002A',
        'avc1.640032',
        'avc1.640033',
        'hvc1.1.6.L93.B0',
        'hvc1.1.6.L120.90',
        'hvc1.1.6.L150.90',
        'hvc1.1.6.L153.90',
        'hev1.1.6.L93.B0',
        'hev1.1.6.L120.90',
        'hev1.1.6.L150.90',
        'hev1.1.6.L153.90',
        'vp09.00.10.08',
        'vp09.00.21.08',
        'av01.0.08M.08',
        'av01.0.08M.08.0.110.01.01.01.0',
        'av01.0.12M.08.0.110.01.01.01.0',
      ];
      const audioTokens = ['mp4a.40.2', 'ec-3', 'fLaC'];

      final dashEntries = [
        for (final pipeline in [
          client_enum
              .PlaybackMediaPipeline
              .PLAYBACK_MEDIA_PIPELINE_MEDIA_SOURCE,
          client_enum
              .PlaybackMediaPipeline
              .PLAYBACK_MEDIA_PIPELINE_MANAGED_MEDIA_SOURCE,
        ])
          ...buildDashCapabilityEntries(
            supportedVideo: [
              for (final token in videoTokens)
                (
                  token,
                  client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_H264,
                ),
            ],
            supportedAudio: [
              for (final token in audioTokens)
                (
                  token,
                  client_enum.PlaybackAudioCodec.PLAYBACK_AUDIO_CODEC_AAC,
                ),
            ],
            pipeline: pipeline,
          ),
      ];
      expect(dashEntries, hasLength(44));
      expect(dashEntries.length, lessThan(64));

      final advertisedTokens = <String>{
        for (final entry in dashEntries)
          ...entry.codecString.split(',').map((token) => token.toLowerCase()),
      };
      for (final token in videoTokens) {
        expect(advertisedTokens, contains(token.toLowerCase()));
      }
      for (final token in audioTokens) {
        expect(advertisedTokens, contains(token.toLowerCase()));
      }
    });

    test('empty inputs advertise nothing', () {
      expect(
        buildDashCapabilityEntries(
          supportedVideo: const [],
          supportedAudio: const [('mp4a.40.2', aac)],
          pipeline:
              client_enum.PlaybackMediaPipeline.PLAYBACK_MEDIA_PIPELINE_NATIVE,
        ),
        isEmpty,
      );
      expect(
        buildDashCapabilityEntries(
          supportedVideo: const [('avc1.42E01E', h264)],
          supportedAudio: const [],
          pipeline:
              client_enum.PlaybackMediaPipeline.PLAYBACK_MEDIA_PIPELINE_NATIVE,
        ),
        isEmpty,
      );
    });

    test('entries carry the pipeline and container they were built for', () {
      final entries = buildDashCapabilityEntries(
        supportedVideo: const [('avc1.42E01E', h264)],
        supportedAudio: const [('mp4a.40.2', aac)],
        pipeline: client_enum
            .PlaybackMediaPipeline
            .PLAYBACK_MEDIA_PIPELINE_MANAGED_MEDIA_SOURCE,
      );
      final client.PlaybackMediaCapability(:pipeline, :container) =
          entries.single;
      expect(
        pipeline,
        client_enum
            .PlaybackMediaPipeline
            .PLAYBACK_MEDIA_PIPELINE_MANAGED_MEDIA_SOURCE,
      );
      expect(container, client_enum.PlaybackContainer.PLAYBACK_CONTAINER_MP4);
    });
  });
}
