import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room_invite/domain/room_invite.dart';

void main() {
  for (final entry in {
    'https://invite.example.test/rooms/room_1': 'https://invite.example.test',
    'https://invite.example.test/sync/rooms/room_1':
        'https://invite.example.test/sync',
    'https://invite.example.test/sync/rooms/room_1/':
        'https://invite.example.test/sync',
    'https://invite.example.test/team%20one/rooms/join?room_id=room_1':
        'https://invite.example.test/team%20one',
    'https://invite.example.test/sync?r=room_1':
        'https://invite.example.test/sync',
  }.entries) {
    test('preserves invite endpoint ${entry.key}', () {
      final invite = RoomInviteService.parse(entry.key);
      expect(invite.roomId, 'room_1');
      expect(invite.serverEndpoint, entry.value);
    });
  }

  for (final value in [
    '/rooms/join',
    '/rooms/join?room_id=one&room_id=two',
    'https://invite.example.test/rooms/join',
    'https://invite.example.test/rooms/join?room_id=',
    'https://invite.example.test/rooms/join?room_id=%20',
    'https://invite.example.test/rooms/',
    'https://invite.example.test',
    'https://invite.example.test/rooms/join?room_id=one&r=two',
    'https://invite.example.test/rooms/join?room_id=one&room_id=two',
    'https://invite.example.test/rooms/one?room_id=two',
    'https://user:password@invite.example.test/rooms/join?room_id=one',
    'ftp://invite.example.test/rooms/join?room_id=one',
  ]) {
    test('rejects invalid or ambiguous invite $value', () {
      expect(() => RoomInviteService.parse(value), throwsFormatException);
    });
  }

  for (final alias in ['room_id', 'roomId', 'r']) {
    test('accepts query alias $alias', () {
      final invite = RoomInviteService.parse(
        'https://invite.example.test/sync/rooms/join?$alias=%20room_1%20',
      );
      expect(invite.roomId, 'room_1');
      expect(invite.serverEndpoint, 'https://invite.example.test/sync');
    });
  }

  test('relative browser invite preserves the room ID', () {
    final invite = RoomInviteService.parse('/rooms/join?room_id=room_1');
    expect(invite.roomId, 'room_1');
    expect(invite.serverEndpoint, isNull);
  });

  test('same ID aliases and canonical link roundtrip remain compatible', () {
    expect(
      RoomInviteService.parse(
        'https://invite.example.test/rooms/join?room_id=room_1&r=room_1&room_id=room_1',
      ).roomId,
      'room_1',
    );
    final room = SyncTvRoom(
      roomId: 'room_1',
      roomName: 'Room',
      creatorId: 'user_1',
    );
    for (final endpoint in [
      'HTTPS://Invite.Example.Test:443/api/',
      'https://invite.example.test/team%20one/api/',
    ]) {
      final link = RoomInviteService.createInviteLink(
        room: room,
        serverEndpoint: endpoint,
      );
      final parsed = RoomInviteService.parse(link);
      expect(parsed.roomId, room.roomId);
      expect(
        RoomInviteService.matchesServerEndpoint(
          inviteEndpoint: parsed.serverEndpoint!,
          serverEndpoint: endpoint,
        ),
        isTrue,
      );
    }
    expect(RoomInviteService.parse(' room_plain ').roomId, 'room_plain');
    expect(RoomInviteService.parse('room_plain').serverEndpoint, isNull);
  });
}
