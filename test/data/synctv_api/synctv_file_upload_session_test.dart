import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/core/media/local_image_upload.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_file_upload_service.dart';

enum _Upload {
  chat('attachmentReference'),
  avatar('avatarReference'),
  room('coverReference'),
  playlist('coverReference'),
  cover('coverReference'),
  thumbnail('thumbnailReference');

  const _Upload(this.referenceField);
  final String referenceField;

  Future<Object> run(SyncTvFileUploadDomainService service) {
    final image = LocalImageUpload(
      bytes: Uint8List.fromList([10, 20, 30, 40, 50, 60]),
      fileName: 'image.png',
      mimeType: 'image/png',
      width: 2,
      height: 3,
    );
    return switch (this) {
      chat => service.uploadChatImage('room_1', image),
      avatar => service.updateUserAvatar(image),
      room => service.updateRoomCover('room_1', image),
      playlist => service.updatePlaylistCover('room_1', 'list_1', image),
      cover => service.updateVideoCover('room_1', 'media_1', image),
      thumbnail => service.updateVideoThumbnail('room_1', 'media_1', image),
    };
  }
}

enum _Change { account, server, refresh }

void main() {
  for (final upload in _Upload.values) {
    for (final change in _Change.values) {
      for (final boundary in [
        'plan',
        'session',
        'part',
        'complete',
        if (upload != _Upload.chat) 'attach',
      ]) {
        test('${upload.name}: ${change.name} during $boundary', () async {
          final session = SyncTvSession()
            ..updateAccountTokens(accessToken: 'original-token');
          final stages = <String>[];
          final authorization = <String?>[];
          late SyncTvApiClient api;
          void changeIdentity(String stage) {
            if (stage != boundary) return;
            switch (change) {
              case _Change.account:
                session.updateAccountTokens(accessToken: 'another-account');
              case _Change.server:
                api.baseUrl = 'https://other.test';
              case _Change.refresh:
                session.updateAccountTokens(
                  accessToken: 'refreshed-token',
                  isRefresh: true,
                );
            }
          }

          http.Response respond(String stage, Object body) {
            stages.add(stage);
            changeIdentity(stage);
            return http.Response(
              jsonEncode(body),
              200,
              headers: {'content-type': 'application/json'},
            );
          }

          api = SyncTvApiClient(
            baseUrl: 'https://example.test',
            session: session,
            httpClient: MockClient((request) async {
              authorization.add(request.headers['authorization']);
              if (request.url.path.endsWith('/upload-session')) {
                final body = jsonDecode(request.body) as Map<String, dynamic>;
                if ((body['parts'] as List<dynamic>? ?? []).isEmpty) {
                  return respond('plan', {
                    'plan': {
                      'checksumAlgorithm': 'sha256',
                      'partSizeBytes': 3,
                      'parts': [
                        {'partNumber': 1, 'offsetBytes': 0, 'sizeBytes': 3},
                        {'partNumber': 2, 'offsetBytes': 3, 'sizeBytes': 3},
                      ],
                    },
                  });
                }
                return respond('session', {
                  'session': {
                    upload.referenceField: {'id': 'file_1'},
                    'uploadRequired': true,
                    'ownershipProofRequired': true,
                    'ownershipProofNonce': 'nonce_1',
                    'ownershipProofRanges': [
                      {'offset': 1, 'length': 3},
                    ],
                    'uploadUrl': '/signed-upload',
                    'uploadHeaders': {
                      'x-synctv-file-upload-token': 'upload-token',
                    },
                    'uploadToken': 'upload-token',
                    'encodedObjectKey': 'object-key',
                  },
                });
              }
              if (request.url.path == '/signed-upload') {
                stages.add('part');
                changeIdentity('part');
                return http.Response('', 204, headers: {'etag': 'part-etag'});
              }
              if (request.url.path.endsWith('/complete')) {
                final body = jsonDecode(request.body) as Map<String, dynamic>;
                // Fixed vector from the protocol's big-endian integer layout.
                expect(
                  body['ownershipProof'],
                  '40b499f0fad2cc65d40fabbe343d7727d77cc7467d7eeeff50a33f3992782dee',
                );
                return respond('complete', {
                  'complete': true,
                  'uploadedSizeBytes': 6,
                  'uploadedParts': [1, 2],
                });
              }
              if (request.method == 'PUT') {
                return respond('attach', {
                  if (upload == _Upload.room) 'room': {'id': 'room_1'},
                  if (upload != _Upload.room) 'id': 'updated_1',
                });
              }
              fail('Unexpected request: ${request.method} ${request.url.path}');
            }),
          );
          addTearDown(api.close);

          final result = upload.run(SyncTvFileUploadDomainService(api));
          final fullStages = [
            'plan',
            'session',
            'part',
            'part',
            'complete',
            if (upload != _Upload.chat) 'attach',
          ];
          if (change == _Change.refresh) {
            await result;
            expect(stages, fullStages);
            expect(session.accessToken, 'refreshed-token');
            if (upload != _Upload.chat && boundary != 'attach') {
              expect(authorization.last, 'Bearer refreshed-token');
            }
          } else {
            await expectLater(
              result,
              throwsA(
                change == _Change.server
                    ? isA<SyncTvStaleEndpointException>()
                    : isA<SyncTvStaleSessionException>(),
              ),
            );
            expect(stages, fullStages.take(fullStages.indexOf(boundary) + 1));
            expect(authorization, isNot(contains('Bearer another-account')));
          }
        });
      }
    }
  }
}
