import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_video_player_media_kit/src/hls_master_playlist.dart';

void main() {
  test('parses and sorts HLS variants while resolving relative URLs', () {
    const playlist = '''
#EXTM3U
#EXT-X-STREAM-INF:BANDWIDTH=3200000,AVERAGE-BANDWIDTH=2800000,RESOLUTION=1280x720,FRAME-RATE=59.94,CODECS="avc1.64001f,mp4a.40.2"
high/index.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=900000,RESOLUTION=640x360
low.m3u8
''';

    final variants = parseHlsMasterPlaylist(
      playlist,
      Uri.parse('https://media.example/live/master.m3u8?token=secret'),
    );

    expect(variants, hasLength(2));
    expect(variants.first.bandwidth, 900000);
    expect(
      variants.first.uri,
      Uri.parse('https://media.example/live/low.m3u8'),
    );
    expect(variants.last.bandwidth, 3200000);
    expect(variants.last.averageBandwidth, 2800000);
    expect(variants.last.width, 1280);
    expect(variants.last.height, 720);
    expect(variants.last.fps, 59.94);
    expect(variants.last.codecs, 'avc1.64001f,mp4a.40.2');
  });

  test('returns no variants for a media playlist', () {
    const playlist = '''
#EXTM3U
#EXT-X-TARGETDURATION:6
#EXTINF:6,
segment.ts
''';

    expect(
      parseHlsMasterPlaylist(playlist, Uri.parse('https://a/live.m3u8')),
      isEmpty,
    );
  });

  test('keeps variants that share bandwidth and differ by representation', () {
    const playlist = '''
#EXTM3U
#EXT-X-STREAM-INF:BANDWIDTH=2000000,RESOLUTION=1280x720,CODECS="avc1.64001f"
avc.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=2000000,RESOLUTION=1920x1080,CODECS="hvc1.1.6.L120"
hevc.m3u8
''';

    final variants = parseHlsMasterPlaylist(
      playlist,
      Uri.parse('https://media.example/master.m3u8'),
    );

    expect(variants, hasLength(2));
    expect(variants.map((variant) => variant.uri.path), [
      '/avc.m3u8',
      '/hevc.m3u8',
    ]);
  });

  group('untrusted playlists', () {
    test('drops variants without a usable BANDWIDTH', () {
      const playlist = '''
#EXTM3U
#EXT-X-STREAM-INF:RESOLUTION=1280x720
missing.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=0
zero.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=not-a-number
nan.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=800000
kept.m3u8
''';

      final variants = parseHlsMasterPlaylist(
        playlist,
        Uri.parse('https://a/master.m3u8'),
      );

      expect(variants, hasLength(1));
      expect(variants.single.uri.path, '/kept.m3u8');
    });

    test('drops stream-inf tags whose URI line never arrives', () {
      const playlist = '''
#EXTM3U
#EXT-X-STREAM-INF:BANDWIDTH=800000

#EXT-X-STREAM-INF:BANDWIDTH=900000
#EXT-X-INDEPENDENT-SEGMENTS
''';

      expect(
        parseHlsMasterPlaylist(playlist, Uri.parse('https://a/m.m3u8')),
        isEmpty,
        reason: 'blank lines are skipped but comments terminate the search',
      );
    });

    test('keeps variants with malformed RESOLUTION and numeric fields', () {
      const playlist = '''
#EXTM3U
#EXT-X-STREAM-INF:BANDWIDTH=800000,RESOLUTION=hd,FRAME-RATE=high,AVERAGE-BANDWIDTH=auto
broken.m3u8
''';

      final variants = parseHlsMasterPlaylist(
        playlist,
        Uri.parse('https://a/master.m3u8'),
      );

      expect(variants, hasLength(1));
      final variant = variants.single;
      expect(variant.width, isNull);
      expect(variant.height, isNull);
      expect(variant.fps, isNull);
      expect(variant.averageBandwidth, isNull);
    });

    test('accepts CRLF line endings and skips blank lines before the URI', () {
      const playlist =
          '#EXTM3U\r\n'
          '#EXT-X-STREAM-INF:BANDWIDTH=800000\r\n'
          '\r\n'
          'crlf.m3u8\r\n';

      final variants = parseHlsMasterPlaylist(
        playlist,
        Uri.parse('https://a/master.m3u8'),
      );

      expect(variants.single.uri.path, '/crlf.m3u8');
    });

    test('resolves absolute variant URIs against the manifest location', () {
      const playlist = '''
#EXTM3U
#EXT-X-STREAM-INF:BANDWIDTH=800000
https://cdn.example/absolute/hls.m3u8
''';

      final variants = parseHlsMasterPlaylist(
        playlist,
        Uri.parse('https://origin.example/master.m3u8'),
      );

      expect(
        variants.single.uri,
        Uri.parse('https://cdn.example/absolute/hls.m3u8'),
      );
    });

    test('keeps equals signs and commas inside quoted attribute values', () {
      const playlist = '''
#EXTM3U
#EXT-X-STREAM-INF:BANDWIDTH=800000,CODECS=" AVC=1, MP4A=2 ",SUBTITLES="sub, en"
quoted.m3u8
''';

      final variants = parseHlsMasterPlaylist(
        playlist,
        Uri.parse('https://a/master.m3u8'),
      );

      expect(variants.single.codecs, ' AVC=1, MP4A=2 ');
    });
  });
}
