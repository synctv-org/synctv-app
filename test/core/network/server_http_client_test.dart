import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/network/server_http_client.dart';

void main() {
  test('insecure TLS exception is limited to the configured origin', () {
    final endpoint = Uri.parse('https://sync.example.test:8443/base');

    expect(
      serverCertificateExceptionAllowed(
        endpoint: endpoint,
        allowInsecureTls: true,
        host: 'sync.example.test',
        port: 8443,
      ),
      isTrue,
    );
    expect(
      serverCertificateExceptionAllowed(
        endpoint: endpoint,
        allowInsecureTls: true,
        host: 'media.example.test',
        port: 8443,
      ),
      isFalse,
    );
    expect(
      serverCertificateExceptionAllowed(
        endpoint: endpoint,
        allowInsecureTls: true,
        host: 'sync.example.test',
        port: 443,
      ),
      isFalse,
    );
  });

  test('strict TLS rejects every certificate exception', () {
    expect(
      serverCertificateExceptionAllowed(
        endpoint: Uri.parse('https://sync.example.test'),
        allowInsecureTls: false,
        host: 'sync.example.test',
        port: 443,
      ),
      isFalse,
    );
  });
}
