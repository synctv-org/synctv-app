import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_provider_service.dart';
import 'package:synctv_app/src/generated/proto/providers/youtube.pb.dart'
    as youtube;
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/source_config.pb.dart' as source;

void main() {
  test(
    'YouTube resolve sends a neutral query and preserves native details',
    () async {
      late http.Request capturedRequest;
      final response = youtube.ResolveResponse(
        metadata: youtube.Metadata(
          videoId: 'abcdefghijk',
          title: 'Video',
          channelName: 'Creator',
        ),
        formats: [youtube.Format(itag: 22, name: '720p')],
        subtitleCount: 1,
        source: provider_common.DiscoveredSource(
          providerInstanceName: 'edge',
          media: source.MediaSourceConfig(
            youtube: source.YoutubeMediaSourceConfig(videoId: 'abcdefghijk'),
          ),
        ),
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
          .resolveYoutube('https://youtu.be/abcdefghijk', instanceName: 'edge');

      expect(result.metadata.title, 'Video');
      expect(result.formats.single.itag, 22);
      expect(result.subtitleCount, 1);
      expect(result.source.media.youtube.videoId, 'abcdefghijk');
      expect(result.source.media.youtube.shared, isFalse);
      expect(capturedRequest.url.path, '/api/providers/youtube/resolve');
      final body = jsonDecode(capturedRequest.body) as Map<String, dynamic>;
      expect(body['resource'], 'https://youtu.be/abcdefghijk');
      expect(body['instanceName'], 'edge');
      expect(body.containsKey('shared'), isFalse);
    },
  );
}
