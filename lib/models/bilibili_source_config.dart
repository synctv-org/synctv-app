import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;

class BilibiliSourceConfig {
  const BilibiliSourceConfig._();

  static source_config.MediaSourceConfig mediaWithShared(
    source_config.MediaSourceConfig source,
    bool shared,
  ) {
    if (!source.hasBilibili()) {
      throw ArgumentError.value(source, 'source', 'Expected Bilibili media');
    }

    final result = source.deepCopy();
    switch (result.bilibili.whichSource()) {
      case source_config.BilibiliMediaSourceConfig_Source.video:
        result.bilibili.video.shared = shared;
      case source_config.BilibiliMediaSourceConfig_Source.pgc:
        result.bilibili.pgc.shared = shared;
      case source_config.BilibiliMediaSourceConfig_Source.live:
        result.bilibili.live.shared = shared;
      case source_config.BilibiliMediaSourceConfig_Source.notSet:
        throw StateError('Bilibili media source is missing');
    }
    return result;
  }

  static source_config.PlaylistSourceConfig playlistWithShared(
    source_config.PlaylistSourceConfig source,
    bool shared,
  ) {
    if (!source.hasBilibili()) {
      throw ArgumentError.value(source, 'source', 'Expected Bilibili playlist');
    }

    final result = source.deepCopy();
    result.bilibili.shared = shared;
    return result;
  }
}
