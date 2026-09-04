import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/media_p2p/infrastructure/p2p_media_manifest.dart';

void main() {
  test('HLS planning keeps stable live sequence keys and protects keys', () {
    final registrations = <P2pMediaResourceRegistration>[];
    var index = 0;
    final output = rewriteP2pHlsManifest(
      manifest: '''
#EXTM3U
#EXT-X-MEDIA-SEQUENCE:41
#EXT-X-DISCONTINUITY-SEQUENCE:3
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio",URI="audio.m3u8"
#EXT-X-KEY:METHOD=AES-128,URI="secret.key"
#EXTINF:4,
segment.ts
#EXT-X-STREAM-INF:BANDWIDTH=1000
nested.m3u8
''',
      upstream: Uri.parse('https://media.example/live/master.m3u8'),
      logicalKey: 'root',
      register: (registration) {
        registrations.add(registration);
        return Uri.parse('https://local.test/${index++}');
      },
    );

    expect(output, contains('URI="https://local.test/0"'));
    expect(registrations[0].manifestKind, P2pManifestKind.hls);
    expect(registrations[0].shareable, isFalse);
    expect(registrations[1].logicalKey, 'root:key:1');
    expect(registrations[1].shareable, isFalse);
    expect(registrations[2].logicalKey, 'root:segment:3:41');
    expect(registrations[2].shareable, isTrue);
    expect(registrations[3].manifestKind, P2pManifestKind.hls);
    expect(registrations[3].shareable, isFalse);
  });

  test('DASH planning covers template directories and external references', () {
    final registrations = <P2pMediaResourceRegistration>[];
    var index = 0;
    final output = rewriteP2pDashManifest(
      manifest: '''
<MPD xmlns:xlink="http://www.w3.org/1999/xlink">
  <Period xlink:href="https://cdn.example/period.xml">
    <AdaptationSet>
      <Representation>
        <SegmentTemplate initialization="https://cdn.example/v/init.mp4" media="https://cdn.example/v/\$Number\$.m4s" />
      </Representation>
    </AdaptationSet>
  </Period>
  <UTCTiming schemeIdUri="urn:mpeg:dash:utc:http-xsdate:2014" value="https://time.example/utc" />
</MPD>
''',
      upstream: Uri.parse('https://media.example/dash/manifest.mpd'),
      logicalKey: 'root',
      register: (registration) {
        registrations.add(registration);
        return Uri.parse(
          'https://local.test/${index++}${registration.isDirectory ? '/' : ''}',
        );
      },
    );

    expect(output, contains(r'https://local.test/2/$Number$.m4s'));
    expect(registrations, hasLength(5));
    expect(registrations[0].manifestKind, P2pManifestKind.dash);
    expect(registrations[0].shareable, isFalse);
    expect(registrations[1].upstream.path, '/v/init.mp4');
    expect(registrations[1].shareable, isTrue);
    expect(registrations[2].isDirectory, isTrue);
    expect(registrations[2].upstream.path, '/v/');
    expect(registrations[3].shareable, isFalse);
    expect(registrations[4].isDirectory, isTrue);
    expect(registrations[4].logicalKey, 'root:mpd:root-base');
  });

  test('DASH keys survive AdaptationSet reordering and filtering', () {
    const h264 = '''
    <AdaptationSet id="100" contentType="video" codecs="avc1.640028">
      <Representation id="h264-1080" bandwidth="6000000">
        <BaseURL>https://cdn.example/h264-1080.m4s?token=old</BaseURL>
      </Representation>
    </AdaptationSet>
''';
    const hevc = '''
    <AdaptationSet id="110" contentType="video" codecs="hev1.1.6.L120.90">
      <Representation id="hevc-1080" bandwidth="3500000">
        <BaseURL>https://cdn.example/hevc-1080.m4s?token=old</BaseURL>
      </Representation>
    </AdaptationSet>
''';

    Map<String, String> plan(String adaptations) {
      final registrations = <P2pMediaResourceRegistration>[];
      rewriteP2pDashManifest(
        manifest: '<MPD><Period id="0">$adaptations</Period></MPD>',
        upstream: Uri.parse('https://media.example/manifest.mpd'),
        logicalKey: 'root',
        register: (registration) {
          registrations.add(registration);
          return Uri.parse('https://local.test/${registrations.length}');
        },
      );
      return {
        for (final registration in registrations)
          registration.upstream.path: registration.logicalKey,
      };
    }

    final original = plan('$h264$hevc');
    final reordered = plan('$hevc$h264');
    final filtered = plan(hevc);

    expect(reordered['/h264-1080.m4s'], original['/h264-1080.m4s']);
    expect(reordered['/hevc-1080.m4s'], original['/hevc-1080.m4s']);
    expect(filtered['/hevc-1080.m4s'], original['/hevc-1080.m4s']);
    expect(
      original['/hevc-1080.m4s'],
      contains('adaptation:110:representation:hevc-1080:base'),
    );
  });

  test('DASH backup BaseURLs share one representation key', () {
    final registrations = <P2pMediaResourceRegistration>[];
    rewriteP2pDashManifest(
      manifest: '''
<MPD><Period id="0"><AdaptationSet id="100"><Representation id="v1">
  <BaseURL>https://primary.example/video.m4s?token=one</BaseURL>
  <BaseURL>https://backup.example/video.m4s?token=two</BaseURL>
</Representation></AdaptationSet></Period></MPD>
''',
      upstream: Uri.parse('https://media.example/manifest.mpd'),
      logicalKey: 'root',
      register: (registration) {
        registrations.add(registration);
        return Uri.parse('https://local.test/${registrations.length}');
      },
    );

    final baseUrls = registrations
        .where((registration) => registration.upstream.path == '/video.m4s')
        .toList(growable: false);
    expect(baseUrls, hasLength(2));
    expect(baseUrls.map((registration) => registration.logicalKey).toSet(), {
      'root:mpd:period:0:adaptation:100:representation:v1:base',
    });
    expect(baseUrls.every((registration) => registration.shareable), isTrue);
  });

  test('DASH representations without ids use stable resource identities', () {
    Map<String, String> plan(String firstToken, String secondToken) {
      final registrations = <P2pMediaResourceRegistration>[];
      rewriteP2pDashManifest(
        manifest:
            '''
<MPD><Period><AdaptationSet contentType="video">
  <Representation bandwidth="1000">
    <BaseURL>https://cdn.example/first.m4s?token=$firstToken</BaseURL>
  </Representation>
  <Representation bandwidth="1000">
    <BaseURL>https://cdn.example/second.m4s?token=$secondToken</BaseURL>
  </Representation>
</AdaptationSet></Period></MPD>
''',
        upstream: Uri.parse('https://media.example/manifest.mpd'),
        logicalKey: 'root',
        register: (registration) {
          registrations.add(registration);
          return Uri.parse('https://local.test/${registrations.length}');
        },
      );
      return {
        for (final registration in registrations)
          registration.upstream.path: registration.logicalKey,
      };
    }

    final original = plan('old-one', 'old-two');
    final refreshed = plan('new-one', 'new-two');

    expect(original['/first.m4s'], isNot(original['/second.m4s']));
    expect(refreshed['/first.m4s'], original['/first.m4s']);
    expect(refreshed['/second.m4s'], original['/second.m4s']);
  });

  test('DASH SegmentURL keys keep stable query and byte ranges distinct', () {
    final registrations = <P2pMediaResourceRegistration>[];
    rewriteP2pDashManifest(
      manifest: '''
<MPD><Period id="0"><AdaptationSet id="100"><Representation id="v1">
  <SegmentList>
    <SegmentURL media="https://cdn.example/segment.m4s?quality=1&amp;token=one" mediaRange="0-99" />
    <SegmentURL media="https://cdn.example/segment.m4s?token=two&amp;quality=1" mediaRange="0-99" />
    <SegmentURL media="https://cdn.example/segment.m4s?quality=1&amp;token=two" mediaRange="100-199" />
    <SegmentURL media="https://cdn.example/segment.m4s?quality=2&amp;token=two" mediaRange="0-99" />
  </SegmentList>
</Representation></AdaptationSet></Period></MPD>
''',
      upstream: Uri.parse('https://media.example/manifest.mpd'),
      logicalKey: 'root',
      register: (registration) {
        registrations.add(registration);
        return Uri.parse('https://local.test/${registrations.length}');
      },
    );

    final segmentKeys = registrations
        .where((registration) => registration.upstream.path == '/segment.m4s')
        .map((registration) => registration.logicalKey)
        .toList(growable: false);
    expect(segmentKeys, hasLength(4));
    expect(segmentKeys[0], segmentKeys[1]);
    expect(segmentKeys[0], isNot(segmentKeys[2]));
    expect(segmentKeys[0], isNot(segmentKeys[3]));
  });

  test('DASH template child keys ignore signatures and keep segment query', () {
    final first = p2pDirectoryChildLogicalKey(
      'root:media-template',
      Uri.parse('segment.m4s?sq=42&deadline=100&token=old'),
    );
    final refreshed = p2pDirectoryChildLogicalKey(
      'root:media-template',
      Uri.parse('segment.m4s?token=new&deadline=200&sq=42'),
    );
    final next = p2pDirectoryChildLogicalKey(
      'root:media-template',
      Uri.parse('segment.m4s?sq=43&deadline=200&token=new'),
    );

    expect(first, 'root:media-template:segment.m4s?sq=42');
    expect(refreshed, first);
    expect(next, isNot(first));
  });

  test('manifest detection sees media URLs nested in query parameters', () {
    expect(
      p2pManifestKind(
        '',
        Uri.parse(
          'https://proxy.example/resolve?url=https%3A%2F%2Fmedia.example%2Fmaster.m3u8',
        ),
      ),
      P2pManifestKind.progressive,
    );
    expect(
      looksLikeP2pHlsManifest(
        Uri.parse(
          'https://proxy.example/resolve?url=https%3A%2F%2Fmedia.example%2Fmaster.m3u8',
        ),
      ),
      isTrue,
    );
  });
}
