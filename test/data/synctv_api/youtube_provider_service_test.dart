import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_provider_service.dart';
import 'package:synctv_app/src/generated/proto/providers/youtube.pb.dart'
    as youtube;
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
        subtitles: [youtube.Subtitle(language: 'en')],
        sourceConfig: source.YoutubeMediaSourceConfig(videoId: 'abcdefghijk'),
      );
      final api = SyncTvApiClient(
        baseUrl: 'https://synctv.example',
        session: SyncTvSession()..accessToken = 'access-token',
        httpClient: MockClient((request) async {
          capturedRequest = request;
          return http.Response(
            jsonEncode(response.toProto3Json()),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );

      final result = await SyncTvProviderDomainService(
        api,
      ).resolveYoutube('https://youtu.be/abcdefghijk', instanceName: 'edge');

      expect(result.metadata.title, 'Video');
      expect(result.formats.single.itag, 22);
      expect(result.subtitles.single.language, 'en');
      expect(result.sourceConfig.videoId, 'abcdefghijk');
      expect(result.sourceConfig.shared, isFalse);
      expect(capturedRequest.url.path, '/api/providers/youtube/resolve');
      final body = jsonDecode(capturedRequest.body) as Map<String, dynamic>;
      expect(body['resource'], 'https://youtu.be/abcdefghijk');
      expect(body['instanceName'], 'edge');
      expect(body.containsKey('shared'), isFalse);
    },
  );
}
