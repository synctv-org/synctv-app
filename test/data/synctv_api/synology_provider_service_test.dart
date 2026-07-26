import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_provider_service.dart';

void main() {
  test(
    'Synology service maps File Station and Video Station responses',
    () async {
      final requests = <http.Request>[];
      final api = SyncTvApiClient(
        baseUrl: 'https://synctv.example',
        session: SyncTvSession()..accessToken = 'access-token',
        httpClient: MockClient((request) async {
          requests.add(request);
          final response = switch (request.url.path) {
            '/api/providers/synology/binds' => {
              'binds': [
                {
                  'id': '1',
                  'serverId': 'dsm-home',
                  'endpoint': 'https://nas.example:5001',
                  'username': 'alice',
                  'videoStationAvailable': true,
                  'createdAt': '100',
                  'providerInstanceName': 'remote',
                },
              ],
            },
            '/api/providers/synology/files' => {
              'items': [
                {
                  'name': 'Movie.mkv',
                  'path': '/video/Movie.mkv',
                  'isDir': false,
                  'size': '1073741824',
                  'modifiedAt': '1700000000',
                  'createdAt': '1600000000',
                  'fileType': 'video',
                },
              ],
              'total': '1',
              'page': '1',
              'hasMore': false,
            },
            '/api/providers/synology/libraries' => {
              'libraries': [
                {
                  'id': '7',
                  'title': 'Movies',
                  'libraryType': 'movie',
                  'isPublic': false,
                  'visible': true,
                },
              ],
            },
            '/api/providers/synology/movies' => {
              'items': [
                {
                  'id': '42',
                  'libraryId': '7',
                  'kind': 'SYNOLOGY_VIDEO_ENTRY_KIND_MOVIE',
                  'title': 'Movie',
                  'sortTitle': 'Movie, The',
                  'tagline': 'A native Video Station item',
                  'summary': 'Summary',
                  'certificate': 'PG-13',
                  'rating': 8,
                  'actors': ['Actor'],
                  'directors': ['Director'],
                  'writers': ['Writer'],
                  'genres': ['Science Fiction'],
                  'createTime': '1690000000',
                  'lastWatched': '1700000000',
                  'watchedRatio': 0.5,
                  'parentalControlled': true,
                  'posterMtime': '123',
                  'files': [
                    {
                      'id': '84',
                      'path': '/video/Movie.mkv',
                      'size': '1073741824',
                      'durationSeconds': '7200',
                      'width': 1920,
                      'height': 1080,
                      'videoCodec': 'h264',
                      'audioCodec': 'aac',
                      'container': 'mkv',
                      'videoBitrate': '8000000',
                      'audioBitrate': '320000',
                      'frameRateNumerator': '24000',
                      'frameRateDenominator': '1001',
                      'audioChannels': 6,
                      'audioFrequencyHz': 48000,
                      'conversionProduced': true,
                    },
                  ],
                },
              ],
              'total': '1',
              'page': '1',
              'hasMore': false,
            },
            _ => null,
          };
          return response == null
              ? http.Response('not found', 404)
              : http.Response(
                  jsonEncode(response),
                  200,
                  headers: {'content-type': 'application/json'},
                );
        }),
      );
      final service = SyncTvProviderDomainService(api);

      final binds = await service.getSynologyBindInfos(instanceName: 'remote');
      final files = await service.listSynologyFiles(
        'dsm-home',
        '/video',
        instanceName: 'remote',
      );
      final libraries = await service.listSynologyLibraries(
        'dsm-home',
        instanceName: 'remote',
      );
      final videos = await service.listSynologyVideos(
        'dsm-home',
        collection: SynologyVideoCollection.movies,
        libraryId: 7,
        instanceName: 'remote',
      );

      expect(binds.single.videoStationAvailable, isTrue);
      expect(files.items.single.fileType, 'video');
      expect(
        Uri.parse(files.items.single.thumbnailUrl).queryParameters,
        containsPair('kind', 'file'),
      );
      expect(libraries.single.id, 7);
      expect(videos.items.single.type, SynologyVideoEntryType.movie);
      expect(videos.items.single.files.single.durationSeconds, 7200);
      expect(videos.items.single.genres, ['Science Fiction']);
      expect(videos.items.single.actors, ['Actor']);
      expect(videos.items.single.watchedRatio, 0.5);
      expect(videos.items.single.parentalControlled, isTrue);
      expect(videos.items.single.files.single.videoBitrate, 8000000);
      expect(videos.items.single.files.single.audioChannels, 6);
      expect(
        Uri.parse(videos.items.single.posterUrl).queryParameters,
        containsPair('kind', 'poster'),
      );
      expect(
        requests.every(
          (request) =>
              request.headers['authorization'] == 'Bearer access-token',
        ),
        isTrue,
      );
    },
  );
}
