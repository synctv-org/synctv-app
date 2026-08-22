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
    expect(registrations[0].logicalKey, 'root:key:0');
    expect(registrations[0].shareable, isFalse);
    expect(registrations[1].logicalKey, 'root:segment:3:41');
    expect(registrations[1].shareable, isTrue);
    expect(registrations[2].manifestKind, P2pManifestKind.hls);
    expect(registrations[2].shareable, isFalse);
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
    expect(registrations[4].logicalKey, 'root:dash-root');
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
