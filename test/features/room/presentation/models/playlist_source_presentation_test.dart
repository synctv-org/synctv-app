import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/presentation/models/playlist_source_presentation.dart';
import 'package:synctv_app/contracts/synctv_models.dart';

void main() {
  group('playlistSourceFacts', () {
    test('extracts provider instance and public source details', () {
      final entry = RoomPlaylistItem(
        id: 'pl_1',
        name: 'Studio picks',
        sourceProvider: 'youtube',
        providerInstanceName: 'media-lab',
        sourceConfig: const {
          'kind': 'channel',
          'channelId': 'UC_DEMO',
          'shared': true,
        },
      );

      final facts = playlistSourceFacts(entry);

      expect(
        facts.map((fact) => (fact.kind, fact.value)),
        containsAll([
          (PlaylistSourceFactKind.instance, 'media-lab'),
          (PlaylistSourceFactKind.type, 'Channel'),
          (PlaylistSourceFactKind.identifier, 'UC_DEMO'),
          (PlaylistSourceFactKind.shared, 'shared'),
        ]),
      );
    });

    test('keeps credentials and URL query values out of presentation', () {
      final entry = RoomPlaylistItem(
        id: 'pl_2',
        name: 'Archive',
        sourceProvider: 'alist',
        sourceConfig: const {
          'serverId': 'srv_demo',
          'path': '/Films/Archive',
          'password': 'secret-value',
          'token': 'private-token',
          'url': 'https://media.example.test/library?token=query-secret',
        },
      );

      final facts = playlistSourceFacts(entry);
      final visible = facts.map((fact) => fact.value).join(' ');

      expect(visible, contains('/Films/Archive'));
      expect(visible, contains('srv_demo'));
      expect(visible, contains('media.example.test'));
      expect(visible, isNot(contains('secret-value')));
      expect(visible, isNot(contains('private-token')));
      expect(visible, isNot(contains('query-secret')));
    });
  });
}
