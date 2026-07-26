import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/network/server_endpoint_identity.dart';

void main() {
  group('ServerEndpointIdentity', () {
    test('normalizes equivalent addresses to one identity', () {
      expect(
        ServerEndpointIdentity.normalize(' HTTPS://Example.COM:443/api/ '),
        'https://example.com',
      );
      expect(
        ServerEndpointIdentity.normalize('http://Example.COM:80/base/'),
        'http://example.com/base',
      );
    });

    test('keeps meaningful scheme port and path boundaries', () {
      expect(
        ServerEndpointIdentity.normalize('http://example.com:8080/one'),
        'http://example.com:8080/one',
      );
      expect(
        ServerEndpointIdentity.normalize('https://example.com/two'),
        'https://example.com/two',
      );
    });

    test('rejects address parts that cannot define a server identity', () {
      expect(
        () =>
            ServerEndpointIdentity.normalize('https://user:secret@example.com'),
        throwsFormatException,
      );
      expect(
        () => ServerEndpointIdentity.normalize('https://example.com?tenant=a'),
        throwsFormatException,
      );
      expect(
        () => ServerEndpointIdentity.normalize('ftp://example.com'),
        throwsFormatException,
      );
    });

    test('storage namespace is stable and address-specific', () {
      final first = ServerEndpointIdentity.storageNamespace(
        'https://example.com/',
      );
      expect(
        first,
        ServerEndpointIdentity.storageNamespace('HTTPS://EXAMPLE.COM:443'),
      );
      expect(
        first,
        isNot(
          ServerEndpointIdentity.storageNamespace('https://example.com/v2'),
        ),
      );
    });
  });
}
