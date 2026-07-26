import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/auth/infrastructure/passkey_native_association_service_io.dart';

void main() {
  test('matches Android package and signing certificate in asset links', () {
    final document = [
      {
        'relation': ['delegate_permission/common.get_login_creds'],
        'target': {
          'namespace': 'android_app',
          'package_name': 'org.synctv.app',
          'sha256_cert_fingerprints': ['AA:BB:CC'],
        },
      },
    ];

    expect(
      PasskeyNativeAssociationService.androidDocumentMatches(
        document: document,
        packageName: 'org.synctv.app',
        certificateSha256: {'AABBCC'},
      ),
      isTrue,
    );
    expect(
      PasskeyNativeAssociationService.androidDocumentMatches(
        document: document,
        packageName: 'org.synctv.app.debug',
        certificateSha256: {'AABBCC'},
      ),
      isFalse,
    );
  });

  test('requires the WebAuthn relation for Android asset links', () {
    final document = [
      {
        'relation': ['delegate_permission/common.handle_all_urls'],
        'target': {
          'namespace': 'android_app',
          'package_name': 'org.synctv.app',
          'sha256_cert_fingerprints': ['AA:BB:CC'],
        },
      },
    ];

    expect(
      PasskeyNativeAssociationService.androidDocumentMatches(
        document: document,
        packageName: 'org.synctv.app',
        certificateSha256: {'AABBCC'},
      ),
      isFalse,
    );
  });

  test('matches the signed Apple application identifier in AASA', () {
    final document = {
      'webcredentials': {
        'apps': ['85KBWFQ6F6.org.synctv.app'],
      },
    };

    expect(
      PasskeyNativeAssociationService.appleDocumentMatches(
        document: document,
        applicationIdentifier: '85KBWFQ6F6.org.synctv.app',
      ),
      isTrue,
    );
    expect(
      PasskeyNativeAssociationService.appleDocumentMatches(
        document: document,
        applicationIdentifier: 'OTHERTEAM.org.synctv.app',
      ),
      isFalse,
    );
  });
}
