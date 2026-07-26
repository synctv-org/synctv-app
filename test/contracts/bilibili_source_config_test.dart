import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/bilibili_source_config.dart';
import 'package:synctv_app/src/generated/proto/source_config.pb.dart' as source;

void main() {
  test('mediaWithShared updates every Bilibili media variant on a copy', () {
    final configs = [
      source.MediaSourceConfig(
        bilibili: source.BilibiliMediaSourceConfig(
          video: source.BilibiliVideoSourceConfig(
            bvid: 'BV1typed',
            cid: Int64(1),
          ),
        ),
      ),
      source.MediaSourceConfig(
        bilibili: source.BilibiliMediaSourceConfig(
          pgc: source.BilibiliPgcSourceConfig(epid: Int64(2), cid: Int64(3)),
        ),
      ),
      source.MediaSourceConfig(
        bilibili: source.BilibiliMediaSourceConfig(
          live: source.BilibiliLiveSourceConfig(roomId: Int64(4)),
        ),
      ),
    ];

    final updated = configs
        .map((config) => BilibiliSourceConfig.mediaWithShared(config, true))
        .toList();

    expect(updated[0].bilibili.video.shared, isTrue);
    expect(updated[1].bilibili.pgc.shared, isTrue);
    expect(updated[2].bilibili.live.shared, isTrue);
    expect(configs[0].bilibili.video.shared, isFalse);
    expect(configs[1].bilibili.pgc.shared, isFalse);
    expect(configs[2].bilibili.live.shared, isFalse);
  });

  test('playlistWithShared updates the Bilibili playlist on a copy', () {
    final config = source.PlaylistSourceConfig(
      bilibili: source.BilibiliPlaylistSourceConfig(
        popular: source.BilibiliPopularPlaylistSource(),
      ),
    );

    final updated = BilibiliSourceConfig.playlistWithShared(config, true);

    expect(updated.bilibili.shared, isTrue);
    expect(config.bilibili.shared, isFalse);
    expect(updated.bilibili.hasPopular(), isTrue);
  });
}
