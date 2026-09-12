import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;

SyncTvApiClient _api(Map<String, String> headers) {
  final api = SyncTvApiClient(
    baseUrl: 'https://example.test',
    session: SyncTvSession(),
    httpClient: MockClient(
      (_) async => http.Response.bytes([1, 2, 3], 200, headers: headers),
    ),
  );
  addTearDown(api.close);
  return api;
}

void main() {
  for (final value in ['0', '9007199254740993', '9223372036854775807']) {
    test('file size preserves exact signed64 decimal $value', () async {
      final api = _api({
        'x-synctv-uploaded-size-bytes': value,
        'content-length': value,
      });
      final uploaded = await api.user.uploadUserAvatarObject(
        client.UploadUserAvatarObjectRequest(encodedObjectKey: 'key'),
      );
      final downloaded = await api.user.getUserAvatarObject(
        client.GetUserAvatarObjectRequest(encodedObjectKey: 'key'),
      );
      expect(uploaded.uploadedSizeBytes.toString(), value);
      expect(downloaded.totalSizeBytes.toString(), value);
    });
  }

  for (final value in [
    '',
    '-1',
    '+1',
    '1e3',
    '0xff',
    '9223372036854775808',
    '18446744073709551616',
  ]) {
    test('invalid file size falls back: $value', () async {
      final api = _api({
        'x-synctv-uploaded-size-bytes': value,
        'content-length': value,
      });
      final uploaded = await api.user.uploadUserAvatarObject(
        client.UploadUserAvatarObjectRequest(encodedObjectKey: 'key'),
      );
      final downloaded = await api.user.getUserAvatarObject(
        client.GetUserAvatarObjectRequest(encodedObjectKey: 'key'),
      );
      expect(uploaded.uploadedSizeBytes.toString(), '0');
      expect(downloaded.totalSizeBytes.toString(), '3');
    });
  }

  test(
    'content range preserves exact offsets above JavaScript integer limit',
    () async {
      final api = _api({
        'content-range':
            'bytes 9007199254740993-9007199254740995/9223372036854775807',
      });
      final result = await api.user.getUserAvatarObject(
        client.GetUserAvatarObjectRequest(encodedObjectKey: 'key'),
      );
      expect(result.contentRange.start.toString(), '9007199254740993');
      expect(result.contentRange.endInclusive.toString(), '9007199254740995');
      expect(result.totalSizeBytes.toString(), '9223372036854775807');
    },
  );

  for (final range in [
    'bytes 4-2/10',
    'bytes 0-3/3',
    'bytes 0-0/0',
    'bytes -1-2/10',
    'bytes 0-2/-1',
    'bytes 0-2/9223372036854775808',
    'bytes 0-9223372036854775808/9223372036854775809',
    'bytes 0-2/*',
  ]) {
    test('invalid content range is discarded: $range', () async {
      final api = _api({'content-range': range});
      final result = await api.user.getUserAvatarObject(
        client.GetUserAvatarObjectRequest(encodedObjectKey: 'key'),
      );
      expect(result.hasContentRange(), isFalse);
      expect(result.totalSizeBytes.toString(), '3');
    });
  }
}
