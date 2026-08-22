import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/providers/infrastructure/browser_verification_protocol.dart';

void main() {
  group('browser verification protocol', () {
    const bridge = 'SyncTVGeetest';
    const token = 'one-time-token';

    test('accepts a matching envelope and preserves payload', () {
      final result = parseBrowserVerificationMessage(
        jsonDecode(
          encodeBrowserVerificationMessage(
            bridge: bridge,
            token: token,
            payload: const {'validate': 'captcha-value'},
          ),
        ),
        expectedBridge: bridge,
        expectedToken: token,
      );

      expect(result, equals(const {'validate': 'captcha-value'}));
    });

    test('ignores a stale or foreign envelope', () {
      final data = jsonDecode(
        encodeBrowserVerificationMessage(
          bridge: bridge,
          token: 'different-token',
          payload: const {'validate': 'captcha-value'},
        ),
      );

      expect(
        parseBrowserVerificationMessage(
          data,
          expectedBridge: bridge,
          expectedToken: token,
        ),
        isNull,
      );
    });

    test('ignores unrelated messages without throwing', () {
      expect(
        parseBrowserVerificationMessage(
          const {'type': 'other'},
          expectedBridge: bridge,
          expectedToken: token,
        ),
        isNull,
      );
      expect(
        parseBrowserVerificationMessage(
          'not-an-envelope',
          expectedBridge: bridge,
          expectedToken: token,
        ),
        isNull,
      );
    });

    test('rejects a matching envelope with a malformed payload', () {
      expect(
        () => parseBrowserVerificationMessage(
          const {
            'type': 'synctv-provider-verification',
            'bridge': bridge,
            'token': token,
            'payload': 'invalid',
          },
          expectedBridge: bridge,
          expectedToken: token,
        ),
        throwsFormatException,
      );
    });
  });
}
