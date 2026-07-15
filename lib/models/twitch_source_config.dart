import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;

class TwitchSourceConfig {
  const TwitchSourceConfig._();

  static source_config.MediaSourceConfig media(
    source_config.TwitchMediaSourceConfig source,
    bool shared,
  ) {
    final provider = source.deepCopy();
    switch (provider.whichSource()) {
      case source_config.TwitchMediaSourceConfig_Source.live:
        provider.live.shared = shared;
      case source_config.TwitchMediaSourceConfig_Source.video:
        provider.video.shared = shared;
      case source_config.TwitchMediaSourceConfig_Source.clip:
        provider.clip.shared = shared;
      case source_config.TwitchMediaSourceConfig_Source.notSet:
        throw StateError('Twitch media source is missing');
    }
    return source_config.MediaSourceConfig(twitch: provider);
  }

  static source_config.PlaylistSourceConfig playlist(
    source_config.TwitchPlaylistSourceConfig source,
    bool shared,
  ) {
    final provider = source.deepCopy()..shared = shared;
    return source_config.PlaylistSourceConfig(twitch: provider);
  }
}
