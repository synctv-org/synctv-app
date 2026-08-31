import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_provider_service.dart';
import 'package:synctv_app/src/generated/proto/providers/bilibili.pb.dart'
    as bilibili;
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart' as source;

void main() {
  test(
    'Bilibili parse preserves typed media and playlist source configs',
    () async {
      late http.Request capturedRequest;
      final response = bilibili.ParseResponse(
        normalizedUrl: 'https://www.bilibili.com/video/BV1typed?p=2',
        candidates: [
          bilibili.ParseCandidate(
            title: 'Part 2',
            cover: 'https://i.example/part-2.jpg',
            durationSeconds: Int64(120),
            partNumber: 2,
            width: Int64(1920),
            height: Int64(1080),
            source: provider_common.DiscoveredSource(
              media: source.MediaSourceConfig(
                bilibili: source.BilibiliMediaSourceConfig(
                  video: source.BilibiliVideoSourceConfig(
                    bvid: 'BV1typed',
                    aid: Int64(100),
                    cid: Int64(200),
                  ),
                ),
              ),
            ),
          ),
          bilibili.ParseCandidate(
            title: 'All parts',
            source: provider_common.DiscoveredSource(
              playlist: source.PlaylistSourceConfig(
                bilibili: source.BilibiliPlaylistSourceConfig(
                  videoParts: source.BilibiliVideoPartsPlaylistSource(
                    bvid: 'BV1typed',
                    aid: Int64(100),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
      final api = SyncTvApiClient(
        baseUrl: 'https://synctv.example',
        session: SyncTvSession()
          ..updateAccountTokens(accessToken: 'access-token'),
        httpClient: MockClient((request) async {
          capturedRequest = request;
          return http.Response(
            jsonEncode(response.toProto3Json()),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final result = await SyncTvProviderDomainService(api)
          .parseBilibiliInfo('https://b23.tv/typed', instanceName: 'remote');

      expect(result.normalizedUrl, response.normalizedUrl);
      expect(result.candidates, hasLength(2));
      expect(result.candidates.first.isMedia, isTrue);
      expect(
        result.candidates.first.source.media.bilibili.video.bvid,
        'BV1typed',
      );
      expect(
        result.candidates.first.source.media.bilibili.video.cid,
        Int64(200),
      );
      expect(result.candidates.first.partNumber, 2);
      expect(result.candidates.last.isPlaylist, isTrue);
      expect(
        result.candidates.last.source.playlist.bilibili.videoParts.bvid,
        'BV1typed',
      );
      expect(result.candidates.last.source.playlist.bilibili.shared, isFalse);

      expect(capturedRequest.url.path, '/api/providers/bilibili/parse');
      expect(capturedRequest.headers['authorization'], 'Bearer access-token');
      final requestBody =
          jsonDecode(capturedRequest.body) as Map<String, dynamic>;
      expect(requestBody['url'], 'https://b23.tv/typed');
      expect(requestBody['instanceName'], 'remote');
      expect(requestBody.containsKey('shared'), isFalse);
    },
  );
}
