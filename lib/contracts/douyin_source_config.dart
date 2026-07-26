import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;

class DouyinSourceConfig {
  const DouyinSourceConfig._();

  static source_config.MediaSourceConfig media(
    source_config.DouyinMediaSourceConfig source,
    bool shared,
  ) {
    final provider = source.deepCopy();
    switch (provider.whichSource()) {
      case source_config.DouyinMediaSourceConfig_Source.video:
        provider.video.shared = shared;
      case source_config.DouyinMediaSourceConfig_Source.live:
        provider.live.shared = shared;
      case source_config.DouyinMediaSourceConfig_Source.notSet:
        throw StateError('Douyin media source is missing');
    }
    return source_config.MediaSourceConfig(douyin: provider);
  }

  static source_config.PlaylistSourceConfig playlist(
    source_config.DouyinPlaylistSourceConfig source,
    bool shared,
  ) {
    final provider = source.deepCopy()..shared = shared;
    return source_config.PlaylistSourceConfig(douyin: provider);
  }
}
