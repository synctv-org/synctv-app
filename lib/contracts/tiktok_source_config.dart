import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;

class TikTokSourceConfig {
  const TikTokSourceConfig._();

  static source_config.MediaSourceConfig media(
    source_config.TikTokMediaSourceConfig source,
    bool shared,
  ) {
    final provider = source.deepCopy();
    switch (provider.whichSource()) {
      case source_config.TikTokMediaSourceConfig_Source.video:
        provider.video.shared = shared;
      case source_config.TikTokMediaSourceConfig_Source.live:
        provider.live.shared = shared;
      case source_config.TikTokMediaSourceConfig_Source.notSet:
        throw StateError('TikTok media source is missing');
    }
    return source_config.MediaSourceConfig(tiktok: provider);
  }

  static source_config.PlaylistSourceConfig playlist(
    source_config.TikTokPlaylistSourceConfig source,
    bool shared,
  ) {
    final provider = source.deepCopy()..shared = shared;
    return source_config.PlaylistSourceConfig(tiktok: provider);
  }
}
