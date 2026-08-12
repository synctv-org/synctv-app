import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart' as client;

void main() {
  group('SensitiveOperationVerificationChallengeInfo', () {
    const passkey = client
        .SensitiveOperationVerificationMethod
        .SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN;
    const password = client
        .SensitiveOperationVerificationMethod
        .SENSITIVE_OPERATION_VERIFICATION_METHOD_PASSWORD;
    const totp = client
        .SensitiveOperationVerificationMethod
        .SENSITIVE_OPERATION_VERIFICATION_METHOD_TOTP;

    SensitiveOperationVerificationChallengeInfo challenge(
      List<client.SensitiveOperationVerificationMethod> methods,
    ) {
      return SensitiveOperationVerificationChallengeInfo(
        sessionId: 'session',
        requiredCount: 1,
        requiredMethods: const [],
        completedMethods: const [],
        availableMethods: methods,
        expiresAt: DateTime.utc(2100),
      );
    }

    test('filters passkey when native authentication is unavailable', () {
      final value = challenge([passkey, password]);

      expect(
        value.supportsMethodOnDevice(passkey, passkeyAvailable: false),
        isFalse,
      );
      expect(value.preferredMethodOnDevice(passkeyAvailable: false), password);
    });

    test('selects TOTP when passkey is unavailable', () {
      final value = challenge([passkey, totp]);

      expect(value.preferredMethodOnDevice(passkeyAvailable: false), totp);
    });

    test('prefers passkey when native authentication is available', () {
      final value = challenge([passkey, password, totp]);

      expect(value.preferredMethodOnDevice(passkeyAvailable: true), passkey);
    });
  });
}
