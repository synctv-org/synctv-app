import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;

class YoutubeSourceConfig {
  const YoutubeSourceConfig._();

  static source_config.MediaSourceConfig media(
    source_config.YoutubeMediaSourceConfig source,
    bool shared,
  ) {
    final provider = source.deepCopy()..shared = shared;
    return source_config.MediaSourceConfig(youtube: provider);
  }

  static source_config.PlaylistSourceConfig playlist(
    source_config.YoutubePlaylistSourceConfig source,
    bool shared,
  ) {
    final provider = source.deepCopy()..shared = shared;
    return source_config.PlaylistSourceConfig(youtube: provider);
  }
}
