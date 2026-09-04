import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:web/web.dart' as web;

const _version = 2;

bool supportsP2pMediaLoader() {
  return globalContext.has('RTCPeerConnection') &&
      globalContext.has('indexedDB') &&
      web.window.navigator.has('serviceWorker') &&
      web.window.isSecureContext;
}

client.PlaybackClientProfile buildPlaybackClientProfile() {
  final video = web.HTMLVideoElement();
  final hasMediaSource = globalContext.has('MediaSource');
  final hasManagedMediaSource = globalContext.has('ManagedMediaSource');
  final capabilities = <client.PlaybackMediaCapability>[];

  void addNative(
    String mimeType,
    client_enum.PlaybackMediaTransport transport,
    client_enum.PlaybackContainer container,
    client_enum.PlaybackVideoCodec videoCodec,
    client_enum.PlaybackAudioCodec audioCodec,
    String codecString,
  ) {
    if (video.canPlayType(mimeType).isEmpty) return;
    capabilities.add(
      client.PlaybackMediaCapability(
        transport: transport,
        container: container,
        videoCodec: videoCodec,
        audioCodec: audioCodec,
        pipeline:
            client_enum.PlaybackMediaPipeline.PLAYBACK_MEDIA_PIPELINE_NATIVE,
        codecString: codecString,
      ),
    );
  }

  void addMediaSource(
    String mimeType,
    client_enum.PlaybackMediaTransport transport,
    client_enum.PlaybackContainer container,
    client_enum.PlaybackVideoCodec videoCodec,
    client_enum.PlaybackAudioCodec audioCodec,
    String codecString,
  ) {
    if (hasMediaSource && _isTypeSupported('MediaSource', mimeType)) {
      capabilities.add(
        client.PlaybackMediaCapability(
          transport: transport,
          container: container,
          videoCodec: videoCodec,
          audioCodec: audioCodec,
          pipeline: client_enum
              .PlaybackMediaPipeline
              .PLAYBACK_MEDIA_PIPELINE_MEDIA_SOURCE,
          codecString: codecString,
        ),
      );
    }
    if (hasManagedMediaSource &&
        _isTypeSupported('ManagedMediaSource', mimeType)) {
      capabilities.add(
        client.PlaybackMediaCapability(
          transport: transport,
          container: container,
          videoCodec: videoCodec,
          audioCodec: audioCodec,
          pipeline: client_enum
              .PlaybackMediaPipeline
              .PLAYBACK_MEDIA_PIPELINE_MANAGED_MEDIA_SOURCE,
          codecString: codecString,
        ),
      );
    }
  }

  void addDashCapabilities(
    String constructorName,
    client_enum.PlaybackMediaPipeline pipeline,
  ) {
    final supportedAudio = _dashAudioCandidates
        .where(
          (candidate) => _isTypeSupported(
            constructorName,
            'audio/mp4; codecs="${candidate.codecString}"',
          ),
        )
        .toList();
    if (supportedAudio.isEmpty) return;

    for (final videoCandidate in _dashVideoCandidates) {
      if (!_isTypeSupported(
        constructorName,
        'video/mp4; codecs="${videoCandidate.codecString}"',
      )) {
        continue;
      }
      for (final audioCandidate in supportedAudio) {
        capabilities.add(
          client.PlaybackMediaCapability(
            transport: client_enum
                .PlaybackMediaTransport
                .PLAYBACK_MEDIA_TRANSPORT_DASH,
            container: client_enum.PlaybackContainer.PLAYBACK_CONTAINER_MP4,
            videoCodec: videoCandidate.videoCodec,
            audioCodec: audioCandidate.audioCodec,
            pipeline: pipeline,
            codecString:
                '${videoCandidate.codecString},${audioCandidate.codecString}',
          ),
        );
      }
    }
  }

  const candidates = [
    _WebMediaCandidate(
      mimeType: 'video/mp4; codecs="avc1.42E01E, mp4a.40.2"',
      container: client_enum.PlaybackContainer.PLAYBACK_CONTAINER_MP4,
      videoCodec: client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_H264,
      audioCodec: client_enum.PlaybackAudioCodec.PLAYBACK_AUDIO_CODEC_AAC,
      codecString: 'avc1.42E01E,mp4a.40.2',
    ),
    _WebMediaCandidate(
      mimeType: 'video/mp4; codecs="hvc1.1.6.L93.B0, mp4a.40.2"',
      container: client_enum.PlaybackContainer.PLAYBACK_CONTAINER_MP4,
      videoCodec: client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_HEVC,
      audioCodec: client_enum.PlaybackAudioCodec.PLAYBACK_AUDIO_CODEC_AAC,
      codecString: 'hvc1.1.6.L93.B0,mp4a.40.2',
    ),
    _WebMediaCandidate(
      mimeType: 'video/webm; codecs="vp09.00.10.08, opus"',
      container: client_enum.PlaybackContainer.PLAYBACK_CONTAINER_WEBM,
      videoCodec: client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_VP9,
      audioCodec: client_enum.PlaybackAudioCodec.PLAYBACK_AUDIO_CODEC_OPUS,
      codecString: 'vp09.00.10.08,opus',
    ),
    _WebMediaCandidate(
      mimeType: 'video/webm; codecs="av01.0.04M.08, opus"',
      container: client_enum.PlaybackContainer.PLAYBACK_CONTAINER_WEBM,
      videoCodec: client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_AV1,
      audioCodec: client_enum.PlaybackAudioCodec.PLAYBACK_AUDIO_CODEC_OPUS,
      codecString: 'av01.0.04M.08,opus',
    ),
  ];

  for (final candidate in candidates) {
    addNative(
      candidate.mimeType,
      client_enum.PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_PROGRESSIVE,
      candidate.container,
      candidate.videoCodec,
      candidate.audioCodec,
      candidate.codecString,
    );
    addMediaSource(
      candidate.mimeType,
      client_enum.PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_HLS,
      candidate.container,
      candidate.videoCodec,
      candidate.audioCodec,
      candidate.codecString,
    );
  }

  if (hasMediaSource) {
    addDashCapabilities(
      'MediaSource',
      client_enum.PlaybackMediaPipeline.PLAYBACK_MEDIA_PIPELINE_MEDIA_SOURCE,
    );
  }
  if (hasManagedMediaSource) {
    addDashCapabilities(
      'ManagedMediaSource',
      client_enum
          .PlaybackMediaPipeline
          .PLAYBACK_MEDIA_PIPELINE_MANAGED_MEDIA_SOURCE,
    );
  }

  final h264 = candidates.first;
  for (final transport in [
    client_enum.PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_FLV,
    client_enum.PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_MPEG_TS,
  ]) {
    addMediaSource(
      h264.mimeType,
      transport,
      h264.container,
      h264.videoCodec,
      h264.audioCodec,
      h264.codecString,
    );
  }

  final nativeHls = video.canPlayType('application/vnd.apple.mpegurl');
  if (nativeHls.isNotEmpty) {
    for (final candidate in candidates) {
      if (video.canPlayType(candidate.mimeType).isEmpty) continue;
      capabilities.add(
        client.PlaybackMediaCapability(
          transport:
              client_enum.PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_HLS,
          container: candidate.container,
          videoCodec: candidate.videoCodec,
          audioCodec: candidate.audioCodec,
          pipeline:
              client_enum.PlaybackMediaPipeline.PLAYBACK_MEDIA_PIPELINE_NATIVE,
          codecString: candidate.codecString,
        ),
      );
    }
  }

  final videoCodecs = capabilities
      .where((capability) => capability.hasVideoCodec())
      .map((capability) => capability.videoCodec)
      .toSet()
      .toList();
  final containers = capabilities
      .where((capability) => capability.hasContainer())
      .map((capability) => capability.container)
      .toSet()
      .toList();
  final supportsHls = capabilities.any(
    (capability) =>
        capability.transport ==
        client_enum.PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_HLS,
  );
  final supportsFlv = capabilities.any(
    (capability) =>
        capability.transport ==
        client_enum.PlaybackMediaTransport.PLAYBACK_MEDIA_TRANSPORT_FLV,
  );

  return client.PlaybackClientProfile(
    profileVersion: _version,
    environment:
        client_enum.PlaybackClientEnvironment.PLAYBACK_CLIENT_ENVIRONMENT_WEB,
    streamPreference:
        client_enum.PlaybackStreamPreference.PLAYBACK_STREAM_PREFERENCE_AUTO,
    maxAudioChannels: 2,
    supportedVideoCodecs: videoCodecs,
    supportedContainers: containers,
    supportedLiveTransports: [
      if (supportsHls)
        client_enum.PlaybackLiveTransport.PLAYBACK_LIVE_TRANSPORT_HLS,
      if (supportsFlv)
        client_enum.PlaybackLiveTransport.PLAYBACK_LIVE_TRANSPORT_FLV,
    ],
    audioCapability:
        client_enum.PlaybackAudioCapability.PLAYBACK_AUDIO_CAPABILITY_STEREO,
    subtitlePreference: client_enum
        .PlaybackSubtitlePreference
        .PLAYBACK_SUBTITLE_PREFERENCE_EXTERNAL,
    mediaCapabilities: capabilities,
    supportsProviderProxy: true,
    supportsInsecureHttpMedia: Uri.base.scheme.toLowerCase() == 'http',
  );
}

bool _isTypeSupported(String constructorName, String mimeType) {
  final constructor = globalContext.getProperty<JSObject?>(
    constructorName.toJS,
  );
  if (constructor == null || !constructor.has('isTypeSupported')) return false;
  return (constructor.callMethod<JSBoolean>(
    'isTypeSupported'.toJS,
    mimeType.toJS,
  )).toDart;
}

extension on JSObject {
  bool has(String name) => hasProperty(name.toJS).toDart;
}

class _WebMediaCandidate {
  const _WebMediaCandidate({
    required this.mimeType,
    required this.container,
    required this.videoCodec,
    required this.audioCodec,
    required this.codecString,
  });

  final String mimeType;
  final client_enum.PlaybackContainer container;
  final client_enum.PlaybackVideoCodec videoCodec;
  final client_enum.PlaybackAudioCodec audioCodec;
  final String codecString;
}

const _dashVideoCandidates = [
  _WebDashVideoCandidate(
    'avc1.42E01E',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_H264,
  ),
  _WebDashVideoCandidate(
    'avc1.64001E',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_H264,
  ),
  _WebDashVideoCandidate(
    'avc1.64001F',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_H264,
  ),
  _WebDashVideoCandidate(
    'avc1.640028',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_H264,
  ),
  _WebDashVideoCandidate(
    'avc1.64002A',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_H264,
  ),
  _WebDashVideoCandidate(
    'avc1.640032',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_H264,
  ),
  _WebDashVideoCandidate(
    'avc1.640033',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_H264,
  ),
  _WebDashVideoCandidate(
    'hvc1.1.6.L93.B0',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_HEVC,
  ),
  _WebDashVideoCandidate(
    'hvc1.1.6.L120.90',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_HEVC,
  ),
  _WebDashVideoCandidate(
    'hvc1.1.6.L150.90',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_HEVC,
  ),
  _WebDashVideoCandidate(
    'hvc1.1.6.L153.90',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_HEVC,
  ),
  _WebDashVideoCandidate(
    'hev1.1.6.L93.B0',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_HEVC,
  ),
  _WebDashVideoCandidate(
    'hev1.1.6.L120.90',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_HEVC,
  ),
  _WebDashVideoCandidate(
    'hev1.1.6.L150.90',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_HEVC,
  ),
  _WebDashVideoCandidate(
    'hev1.1.6.L153.90',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_HEVC,
  ),
  _WebDashVideoCandidate(
    'vp09.00.10.08',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_VP9,
  ),
  _WebDashVideoCandidate(
    'vp09.00.21.08',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_VP9,
  ),
  _WebDashVideoCandidate(
    'av01.0.08M.08',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_AV1,
  ),
  _WebDashVideoCandidate(
    'av01.0.08M.08.0.110.01.01.01.0',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_AV1,
  ),
  _WebDashVideoCandidate(
    'av01.0.12M.08.0.110.01.01.01.0',
    client_enum.PlaybackVideoCodec.PLAYBACK_VIDEO_CODEC_AV1,
  ),
];

const _dashAudioCandidates = [
  _WebDashAudioCandidate(
    'mp4a.40.2',
    client_enum.PlaybackAudioCodec.PLAYBACK_AUDIO_CODEC_AAC,
  ),
  _WebDashAudioCandidate(
    'ec-3',
    client_enum.PlaybackAudioCodec.PLAYBACK_AUDIO_CODEC_EAC3,
  ),
  _WebDashAudioCandidate(
    'fLaC',
    client_enum.PlaybackAudioCodec.PLAYBACK_AUDIO_CODEC_FLAC,
  ),
];

class _WebDashVideoCandidate {
  const _WebDashVideoCandidate(this.codecString, this.videoCodec);

  final String codecString;
  final client_enum.PlaybackVideoCodec videoCodec;
}

class _WebDashAudioCandidate {
  const _WebDashAudioCandidate(this.codecString, this.audioCodec);

  final String codecString;
  final client_enum.PlaybackAudioCodec audioCodec;
}
