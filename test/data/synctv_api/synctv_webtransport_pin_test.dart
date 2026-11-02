@TestOn('vm')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/data/synctv_api/synctv_api_client.dart';
import 'package:synctv_app/data/synctv_api/synctv_session_store.dart';

SyncTvServerProfile _profile({
  required String endpoint,
  bool allowInsecureTls = false,
  String? pin,
}) {
  return SyncTvServerProfile(
    endpoint: endpoint,
    declaredServerId: endpoint,
    name: endpoint,
    allowInsecureTls: allowInsecureTls,
    webTransportCertificateHash: pin,
  );
}

Future<SyncTvSessionStore> _store() async {
  SharedPreferences.setMockInitialValues({});
  return SyncTvSessionStore(SyncTvSession());
}

void main() {
  group('SyncTvServerProfile.effectiveWebTransportPin', () {
    test('profile pin wins over any advertisement', () {
      final profile = _profile(
        endpoint: 'http://plain.example.test',
        pin: 'operator-pin',
      );
      expect(profile.effectiveWebTransportPin('attacker-pin'), 'operator-pin');
    });

    test('advertised pin honored over a validated https channel', () {
      final validated = _profile(endpoint: 'https://secure.example.test');
      expect(validated.effectiveWebTransportPin('advertised'), 'advertised');
    });

    test('advertised pin ignored on plain http', () {
      final plain = _profile(endpoint: 'http://plain.example.test');
      expect(plain.effectiveWebTransportPin('attacker-pin'), isNull);
    });

    test('advertised pin ignored when certificate validation is disabled', () {
      final insecure = _profile(
        endpoint: 'https://selfsigned.example.test',
        allowInsecureTls: true,
      );
      expect(insecure.effectiveWebTransportPin('attacker-pin'), isNull);
    });
  });

  group('SyncTvSessionStore.addOrUpdateServer pin carry-through', () {
    test('persists the operator pin into the active profile', () async {
      final store = await _store();
      await store.addOrUpdateServer(
        declaredServerId: 'srv',
        name: 'Pinned',
        endpoint: 'https://pinned.example.test',
        webTransportCertificateHash: 'operator-pin',
      );
      expect(store.activeServer?.webTransportCertificateHash, 'operator-pin');
    });

    test('preserves an existing pin when a later update omits it', () async {
      final store = await _store();
      await store.addOrUpdateServer(
        declaredServerId: 'srv',
        name: 'Pinned',
        endpoint: 'https://pinned.example.test',
        webTransportCertificateHash: 'operator-pin',
      );
      await store.addOrUpdateServer(
        declaredServerId: 'srv',
        name: 'Renamed',
        endpoint: 'https://pinned.example.test',
      );
      expect(
        store.activeServer?.webTransportCertificateHash,
        'operator-pin',
        reason: 'an update that omits the pin must carry it forward',
      );
    });

    test(
      'an empty pin update keeps the current pin (empty-keeps-current)',
      () async {
        final store = await _store();
        await store.addOrUpdateServer(
          declaredServerId: 'srv',
          name: 'Pinned',
          endpoint: 'https://pinned.example.test',
          webTransportCertificateHash: 'operator-pin',
        );
        await store.addOrUpdateServer(
          declaredServerId: 'srv',
          name: 'Pinned',
          endpoint: 'https://pinned.example.test',
          webTransportCertificateHash: '',
        );
        expect(
          store.activeServer?.webTransportCertificateHash,
          'operator-pin',
          reason: 'an empty field means "keep the current pin" per the app convention',
        );
      },
    );
  });
}
