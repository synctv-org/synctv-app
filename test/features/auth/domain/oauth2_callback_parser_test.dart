import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/auth/domain/oauth2_callback_parser.dart';

void main() {
  final redirect = Uri.parse('https://example.test/oauth2/callback');
  for (final parameter in ['code', 'state']) {
    for (final repeatedValue in ['same', 'different']) {
      test('rejects duplicate $parameter with $repeatedValue values', () {
        final values = <String, dynamic>{
          'code': 'valid-code',
          'state': 'valid-state',
        };
        final valid = values[parameter] as String;
        values[parameter] = [
          repeatedValue == 'same' ? valid : 'foreign',
          valid,
        ];
        expect(
          () => OAuth2CallbackParser.parse(
            redirect.replace(queryParameters: values),
            expectedState: 'valid-state',
            expectedRedirectUri: redirect,
          ),
          throwsArgumentError,
        );
      });
    }
  }
  test('preserves whitespace trimming and unrelated repeated parameters', () {
    final payload = OAuth2CallbackParser.parse(
      redirect.replace(
        queryParameters: {
          'code': ' valid-code ',
          'state': ' valid-state ',
          'scope': ['profile', 'email'],
        },
      ),
      expectedState: 'valid-state',
      expectedRedirectUri: redirect,
    );
    expect(payload.code, 'valid-code');
    expect(payload.state, 'valid-state');
  });
}
