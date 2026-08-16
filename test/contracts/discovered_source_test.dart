import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/discovered_source.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart' as source;

void main() {
  const only = source.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY;

  test('applies proxy mode to every supported media provider', () {
    final cases =
        <
          (
            provider_common.DiscoveredSource,
            source.PlaybackProxyMode Function(provider_common.DiscoveredSource),
          )
        >[
          (
            provider_common.DiscoveredSource(
              media: source.MediaSourceConfig(
                directUrl: source.DirectUrlMediaSourceConfig(),
              ),
            ),
            (value) => value.media.directUrl.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              media: source.MediaSourceConfig(
                alist: source.AlistMediaSourceConfig(),
              ),
            ),
            (value) => value.media.alist.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              media: source.MediaSourceConfig(
                bilibili: source.BilibiliMediaSourceConfig(),
              ),
            ),
            (value) => value.media.bilibili.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              media: source.MediaSourceConfig(
                emby: source.EmbyMediaSourceConfig(),
              ),
            ),
            (value) => value.media.emby.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              media: source.MediaSourceConfig(
                cloudreve: source.CloudreveMediaSourceConfig(),
              ),
            ),
            (value) => value.media.cloudreve.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              media: source.MediaSourceConfig(
                fnos: source.FnosMediaSourceConfig(),
              ),
            ),
            (value) => value.media.fnos.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              media: source.MediaSourceConfig(
                qnap: source.QnapMediaSourceConfig(),
              ),
            ),
            (value) => value.media.qnap.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              media: source.MediaSourceConfig(
                synology: source.SynologyMediaSourceConfig(),
              ),
            ),
            (value) => value.media.synology.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              media: source.MediaSourceConfig(
                nextcloud: source.NextcloudMediaSourceConfig(),
              ),
            ),
            (value) => value.media.nextcloud.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              media: source.MediaSourceConfig(
                seafile: source.SeafileMediaSourceConfig(),
              ),
            ),
            (value) => value.media.seafile.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              media: source.MediaSourceConfig(
                truenas: source.TrueNasMediaSourceConfig(),
              ),
            ),
            (value) => value.media.truenas.proxyMode,
          ),
        ];

    for (final (original, readMode) in cases) {
      final updated = original.withPlaybackProxyMode(only);
      expect(readMode(updated), only);
      expect(
        readMode(original),
        source.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
      );
    }
  });

  test('applies proxy mode to every supported dynamic playlist', () {
    final cases =
        <
          (
            provider_common.DiscoveredSource,
            source.PlaybackProxyMode Function(provider_common.DiscoveredSource),
          )
        >[
          (
            provider_common.DiscoveredSource(
              playlist: source.PlaylistSourceConfig(
                alist: source.AlistPlaylistSourceConfig(),
              ),
            ),
            (value) => value.playlist.alist.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              playlist: source.PlaylistSourceConfig(
                bilibili: source.BilibiliPlaylistSourceConfig(),
              ),
            ),
            (value) => value.playlist.bilibili.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              playlist: source.PlaylistSourceConfig(
                emby: source.EmbyPlaylistSourceConfig(),
              ),
            ),
            (value) => value.playlist.emby.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              playlist: source.PlaylistSourceConfig(
                cloudreve: source.CloudrevePlaylistSourceConfig(),
              ),
            ),
            (value) => value.playlist.cloudreve.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              playlist: source.PlaylistSourceConfig(
                fnos: source.FnosPlaylistSourceConfig(),
              ),
            ),
            (value) => value.playlist.fnos.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              playlist: source.PlaylistSourceConfig(
                qnap: source.QnapPlaylistSourceConfig(),
              ),
            ),
            (value) => value.playlist.qnap.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              playlist: source.PlaylistSourceConfig(
                synology: source.SynologyPlaylistSourceConfig(),
              ),
            ),
            (value) => value.playlist.synology.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              playlist: source.PlaylistSourceConfig(
                nextcloud: source.NextcloudPlaylistSourceConfig(),
              ),
            ),
            (value) => value.playlist.nextcloud.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              playlist: source.PlaylistSourceConfig(
                seafile: source.SeafilePlaylistSourceConfig(),
              ),
            ),
            (value) => value.playlist.seafile.proxyMode,
          ),
          (
            provider_common.DiscoveredSource(
              playlist: source.PlaylistSourceConfig(
                truenas: source.TrueNasPlaylistSourceConfig(),
              ),
            ),
            (value) => value.playlist.truenas.proxyMode,
          ),
        ];

    for (final (original, readMode) in cases) {
      final updated = original.withPlaybackProxyMode(only);
      expect(readMode(updated), only);
      expect(
        readMode(original),
        source.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
      );
    }
  });

  test(
    'preserves complete dynamic playlist source config when switching mode',
    () {
      final original = provider_common.DiscoveredSource(
        playlist: source.PlaylistSourceConfig(
          alist: source.AlistPlaylistSourceConfig(
            serverId: 'alist-main',
            path: '/library/series',
            password: 'playlist-password',
          ),
        ),
        providerInstanceName: 'personal-alist',
      );

      final updated = original.withPlaybackProxyMode(only).requirePlaylist();

      expect(updated.alist.serverId, 'alist-main');
      expect(updated.alist.path, '/library/series');
      expect(updated.alist.password, 'playlist-password');
      expect(updated.alist.proxyMode, only);
      expect(
        original.playlist.alist.proxyMode,
        source.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
      );
    },
  );

  test('keeps fixed-route providers unchanged', () {
    final original = provider_common.DiscoveredSource(
      media: source.MediaSourceConfig(
        twitch: source.TwitchMediaSourceConfig(
          live: source.TwitchLiveSourceConfig(channel: 'synctv'),
        ),
      ),
    );

    final updated = original.withPlaybackProxyMode(only);

    expect(updated, original);
  });
}
