import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/douyin_source_config.dart';
import 'package:synctv_app/contracts/tiktok_source_config.dart';
import 'package:synctv_app/contracts/twitch_source_config.dart';
import 'package:synctv_app/contracts/youtube_source_config.dart';
import 'package:synctv_app/src/generated/proto/source_config.pb.dart' as source;

void main() {
  test('Twitch config applies credential scope on a copy', () {
    final media = source.TwitchMediaSourceConfig(
      clip: source.TwitchClipSourceConfig(slug: 'clip'),
    );
    final playlist = source.TwitchPlaylistSourceConfig(
      channel: source.TwitchPlaylistSourceConfig_Channel(channel: 'channel'),
    );

    final scopedMedia = TwitchSourceConfig.media(media, true);
    final scopedPlaylist = TwitchSourceConfig.playlist(playlist, true);

    expect(scopedMedia.twitch.clip.shared, isTrue);
    expect(scopedPlaylist.twitch.shared, isTrue);
    expect(media.clip.shared, isFalse);
    expect(playlist.shared, isFalse);
  });

  test('Douyin config applies credential scope on a copy', () {
    final media = source.DouyinMediaSourceConfig(
      video: source.DouyinVideoSourceConfig(awemeId: 'video'),
    );
    final playlist = source.DouyinPlaylistSourceConfig(secUid: 'creator');

    final scopedMedia = DouyinSourceConfig.media(media, true);
    final scopedPlaylist = DouyinSourceConfig.playlist(playlist, true);

    expect(scopedMedia.douyin.video.shared, isTrue);
    expect(scopedPlaylist.douyin.shared, isTrue);
    expect(media.video.shared, isFalse);
    expect(playlist.shared, isFalse);
  });

  test('TikTok config applies credential scope on a copy', () {
    final media = source.TikTokMediaSourceConfig(
      live: source.TikTokLiveSourceConfig(uniqueId: 'creator'),
    );
    final playlist = source.TikTokPlaylistSourceConfig(secUid: 'creator-id');

    final scopedMedia = TikTokSourceConfig.media(media, true);
    final scopedPlaylist = TikTokSourceConfig.playlist(playlist, true);

    expect(scopedMedia.tiktok.live.shared, isTrue);
    expect(scopedPlaylist.tiktok.shared, isTrue);
    expect(media.live.shared, isFalse);
    expect(playlist.shared, isFalse);
  });

  test('YouTube config applies credential scope on a copy', () {
    final media = source.YoutubeMediaSourceConfig(videoId: 'abcdefghijk');
    final playlist = source.YoutubePlaylistSourceConfig(
      playlist: source.YoutubePlaylistSourceConfig_Playlist(
        playlistId: 'PL123',
      ),
    );

    final scopedMedia = YoutubeSourceConfig.media(media, true);
    final scopedPlaylist = YoutubeSourceConfig.playlist(playlist, true);

    expect(scopedMedia.youtube.shared, isTrue);
    expect(scopedPlaylist.youtube.shared, isTrue);
    expect(media.shared, isFalse);
    expect(playlist.shared, isFalse);
  });
}
