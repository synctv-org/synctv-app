import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/core/media/local_image_upload.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_file_upload_service.dart';

Map<String, Object> _part(int number, Object offset, Object size) => {
  'partNumber': number,
  'offsetBytes': offset,
  'sizeBytes': size,
};

class _Fixture {
  final requests = <String>[];
  Map<String, dynamic>? completion;

  Future<Object> run({
    String algorithm = 'sha256',
    Object partSize = 3,
    List<Map<String, Object>>? parts,
    Object proofOffset = 1,
    int proofLength = 3,
  }) {
    final api = SyncTvApiClient(
      baseUrl: 'https://example.test',
      session: SyncTvSession()..updateAccountTokens(accessToken: 'token'),
      httpClient: MockClient((request) async {
        requests.add('${request.method} ${request.url.path}');
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        Object response;
        if (request.url.path.endsWith('/upload-session')) {
          response = (body['parts'] as List<dynamic>? ?? []).isEmpty
              ? {
                  'plan': {
                    'checksumAlgorithm': algorithm,
                    'partSizeBytes': partSize,
                    'parts': parts ?? [_part(1, 0, 3), _part(2, 3, 3)],
                  },
                }
              : {
                  'session': {
                    'avatarReference': {'id': 'avatar_1'},
                    'uploadRequired': false,
                    'ownershipProofRequired': true,
                    'ownershipProofNonce': 'nonce_1',
                    'ownershipProofRanges': [
                      {'offset': proofOffset, 'length': proofLength},
                    ],
                    'uploadToken': 'upload-token',
                    'encodedObjectKey': 'object-key',
                  },
                };
        } else if (request.url.path.endsWith('/complete')) {
          completion = body;
          response = {'complete': true};
        } else if (request.url.path == '/api/user/avatar') {
          response = {'id': 'user_1'};
        } else {
          fail('Unexpected request: ${request.method} ${request.url.path}');
        }
        return http.Response(
          jsonEncode(response),
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
    );
    addTearDown(api.close);
    return SyncTvFileUploadDomainService(api).updateUserAvatar(
      LocalImageUpload(
        bytes: Uint8List.fromList([10, 20, 30, 40, 50, 60]),
        fileName: 'image.png',
        mimeType: 'image/png',
        width: 2,
        height: 3,
      ),
    );
  }
}

void main() {
  final invalidPlans = <String, List<Map<String, Object>>>{
    'empty': [],
    'missing tail': [_part(1, 0, 3)],
    'missing head': [_part(2, 3, 3)],
    'duplicate number': [_part(1, 0, 3), _part(1, 3, 3)],
    'zero number': [_part(0, 0, 3), _part(2, 3, 3)],
    'skipped number': [_part(1, 0, 3), _part(3, 3, 3)],
    'overlap': [_part(1, 0, 3), _part(2, 2, 3)],
    'gap': [_part(1, 0, 2), _part(2, 3, 3)],
    'negative offset': [_part(1, -1, 3), _part(2, 3, 3)],
    'negative size': [_part(1, 0, -3), _part(2, 3, 3)],
    'empty part': [_part(1, 0, 0), _part(2, 3, 3)],
    'oversized part': [_part(1, 0, 4), _part(2, 4, 2)],
    'extra part': [_part(1, 0, 3), _part(2, 3, 3), _part(3, 6, 1)],
    'reordered': [_part(2, 3, 3), _part(1, 0, 3)],
    'int64 addition overflow': [_part(1, '9223372036854775807', 3)],
    'int64 size overflow': [_part(1, 0, '9223372036854775807')],
  };
  for (final entry in invalidPlans.entries) {
    test('rejects ${entry.key} before creating upload session', () async {
      final fixture = _Fixture();
      await expectLater(
        fixture.run(parts: entry.value),
        throwsA(isA<SyncTvFileUploadException>()),
      );
      expect(fixture.requests, ['POST /api/user/avatar/upload-session']);
    });
  }

  for (final algorithm in ['', 'sha512']) {
    test('rejects unsupported checksum algorithm $algorithm', () async {
      final fixture = _Fixture();
      await expectLater(
        fixture.run(algorithm: algorithm),
        throwsA(isA<SyncTvFileUploadException>()),
      );
      expect(fixture.requests.length, 1);
    });
  }
  for (final size in [0, -1]) {
    test('rejects invalid part size $size', () async {
      final fixture = _Fixture();
      await expectLater(
        fixture.run(partSize: size),
        throwsA(isA<SyncTvFileUploadException>()),
      );
      expect(fixture.requests.length, 1);
    });
  }
  for (final range in <(Object, int)>[
    (-1, 3),
    (0, 0),
    (0, -1),
    (4, 3),
    (7, 1),
    ('9007199254740993', 1),
    ('9223372036854775807', 3),
  ]) {
    test('rejects invalid ownership range $range before completing', () async {
      final fixture = _Fixture();
      await expectLater(
        fixture.run(proofOffset: range.$1, proofLength: range.$2),
        throwsA(isA<SyncTvFileUploadException>()),
      );
      expect(
        fixture.requests,
        List.filled(2, 'POST /api/user/avatar/upload-session'),
      );
      expect(fixture.completion, isNull);
    });
  }

  test('accepts full plan and preserves ownership proof vector', () async {
    final fixture = _Fixture();
    await fixture.run();
    expect(fixture.requests.length, 4);
    expect(
      fixture.completion?['ownershipProof'],
      '40b499f0fad2cc65d40fabbe343d7727d77cc7467d7eeeff50a33f3992782dee',
    );
  });

  test('accepts a shorter final part', () async {
    final fixture = _Fixture();
    await fixture.run(partSize: 4, parts: [_part(1, 0, 4), _part(2, 4, 2)]);
    expect(fixture.requests.length, 4);
  });

  test('preserves exact large part-size metadata in manifest digest', () async {
    final fixture = _Fixture();
    await fixture.run(partSize: '9007199254740993', parts: [_part(1, 0, 6)]);
    // Independent protocol vector with one part and a large i64 part size.
    expect(
      fixture.completion?['ownershipProof'],
      '314f38e948ae505226356da39e22b7fb619a53f32a5d8df0c02a4c782786f0a9',
    );
  });
}
