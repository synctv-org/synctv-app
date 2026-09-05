// ignore_for_file: avoid_print, invalid_use_of_visible_for_testing_member

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/features/room/data/room_realtime_codec.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart'
    as source_config;

import 'local_backend_test_auth.dart';

void main() {
  test('seed local P2P media coverage', () async {
    const username = String.fromEnvironment('SYNCTV_P2P_USERNAME');
    const password = String.fromEnvironment('SYNCTV_P2P_PASSWORD');
    const roomId = String.fromEnvironment('SYNCTV_P2P_ROOM_ID');
    const origin = String.fromEnvironment('SYNCTV_P2P_ORIGIN');
    const baseUrl = String.fromEnvironment('SYNCTV_P2P_BASE_URL');
    if (username.isEmpty ||
        password.isEmpty ||
        roomId.isEmpty ||
        origin.isEmpty ||
        baseUrl.isEmpty) {
      throw StateError(
        'SYNCTV_P2P_BASE_URL, SYNCTV_P2P_ORIGIN, credentials, and room ID are required',
      );
    }

    SharedPreferences.setMockInitialValues({});
    await SyncTvService.init();
    await SyncTvService.setBaseUrl(baseUrl);
    await loginLocalPasswordUser(username, password);
    if (const bool.fromEnvironment('SYNCTV_P2P_STOP')) {
      await SyncTvService.switchMedia(roomId, '', subPath: '');
      print('P2P_PLAYBACK_STOPPED=true');
      return;
    }
    const switchMediaId = String.fromEnvironment('SYNCTV_P2P_SWITCH_MEDIA_ID');
    if (switchMediaId.isNotEmpty) {
      await SyncTvService.switchMedia(roomId, switchMediaId);
      if (const bool.fromEnvironment('SYNCTV_P2P_PAUSE_AFTER_SWITCH')) {
        await SyncTvService.updatePlaybackState(
          roomId,
          action: PlaybackControlAction.pause,
          isPlaying: false,
        );
      }
      print('P2P_SWITCHED_MEDIA_ID=$switchMediaId');
      return;
    }
    if (const bool.fromEnvironment('SYNCTV_P2P_INSPECT_ONLY')) {
      final status = (await SyncTvService.watchPlaybackSnapshot(
        roomId,
      ).firstWhere((event) => event.snapshot != null)).snapshot!;
      final entry = status.entry;
      print('P2P_INSPECT_ENTRY=${entry?.name}');
      print('P2P_INSPECT_PLAYING=${status.isPlaying}');
      print('P2P_INSPECT_POSITION=${status.currentTime}');
      print('P2P_INSPECT_MEDIA_ID=${status.playingMediaId}');
      print('P2P_INSPECT_PLAYLIST_ID=${status.playingPlaylistId}');
      print('P2P_INSPECT_TARGET_HASH=${status.targetHash}');
      print(
        'P2P_INSPECT_MODES=${entry?.playbackModes.map((mode) => '${mode.key}:${mode.urls.map((url) => url.format).join(',')}').join('|')}',
      );
      for (final mode in entry?.playbackModes ?? const []) {
        for (var index = 0; index < mode.urls.length; index++) {
          final option = mode.urls[index];
          print(
            'P2P_INSPECT_URL=${mode.key}:$index:${option.format}:'
            '${option.p2pDelivery?.swarmId ?? ''}:${option.url}',
          );
        }
      }
      print(
        'P2P_INSPECT_SWARM=${entry?.selectedPlaybackUrlOption?.p2pDelivery?.swarmId ?? ''}',
      );
      return;
    }

    final playlist = await SyncTvService.createPlaylist(
      roomId,
      name: 'P2P Format Coverage',
      description: 'Local MP4, HLS, DASH, FLV, subtitle, proxy, and live tests',
    );
    final vodId = await SyncTvService.addDiscoveredSource(
      roomId,
      playlistId: playlist.id,
      name: 'P2P Multi-format VOD',
      source: provider_common.DiscoveredSource(
        media: source_config.MediaSourceConfig(
          directUrl: source_config.DirectUrlMediaSourceConfig(
            medias: [
              source_config.DirectUrlMediaResourceConfig(
                name: 'MP4 Faststart',
                url: '$origin/video.mp4',
                format: 'mp4',
              ),
              source_config.DirectUrlMediaResourceConfig(
                name: 'HLS VOD',
                url: '$origin/hls/playlist.m3u8',
                format: 'hls',
              ),
              source_config.DirectUrlMediaResourceConfig(
                name: 'DASH VOD',
                url: '$origin/dash/manifest.mpd',
                format: 'dash',
              ),
              source_config.DirectUrlMediaResourceConfig(
                name: 'FLV Archive',
                url: '$origin/archive.flv',
                format: 'flv',
              ),
            ],
            defaultMediaIndex: 0,
            durationSeconds: 30,
            subtitles: [
              source_config.DirectUrlSubtitleSourceConfig(
                name: 'P2P English',
                language: 'en',
                url: '$origin/subtitle.vtt',
                format: 'vtt',
              ),
            ],
            defaultSubtitleIndex: 0,
          ),
        ),
      ),
    );
    final liveId = await SyncTvService.addDiscoveredSource(
      roomId,
      playlistId: playlist.id,
      name: 'P2P Live Exclusion',
      source: provider_common.DiscoveredSource(
        media: source_config.MediaSourceConfig(
          directUrl: source_config.DirectUrlMediaSourceConfig(
            medias: [
              source_config.DirectUrlMediaResourceConfig(
                name: 'Live HLS',
                url: '$origin/hls/playlist.m3u8',
                format: 'hls',
              ),
            ],
            isLive: true,
          ),
        ),
      ),
    );

    await SyncTvService.switchMedia(roomId, vodId);
    print('P2P_SEED_PLAYLIST_ID=${playlist.id}');
    print('P2P_SEED_VOD_ID=$vodId');
    print('P2P_SEED_LIVE_ID=$liveId');
  }, timeout: const Timeout(Duration(minutes: 2)));
}
