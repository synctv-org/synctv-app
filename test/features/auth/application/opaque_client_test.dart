import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_opaque/synctv_opaque.dart';

void main() {
  test('native OPAQUE client creates protocol messages', () async {
    final client = SyncTvOpaqueClient();

    final registration = await client.startRegistration(
      'correct horse battery staple',
    );
    final login = await client.startLogin('correct horse battery staple');

    expect(registration.registrationRequest, isA<Uint8List>());
    expect(registration.registrationRequest, isNotEmpty);
    expect(registration.state, isNotEmpty);
    expect(login.credentialRequest, isA<Uint8List>());
    expect(login.credentialRequest, isNotEmpty);
    expect(login.state, isNotEmpty);
  });
}
