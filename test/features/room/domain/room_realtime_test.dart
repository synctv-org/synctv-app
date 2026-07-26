import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';

void main() {
  test('realtime chat entries preserve the server message version', () {
    const message = RoomRealtimeMessage(
      kind: RoomRealtimeMessageKind.chat,
      chatId: 'msg_42',
      chatContent: 'updated content',
      senderUserId: 'usr_7',
      senderUsername: 'olivia',
      timestampMillis: 1234,
      chatEventKind: RoomRealtimeChatEventKind.edited,
      chatVersion: 9,
    );

    final entry = RoomRealtimeChatEntry.fromMessage(
      message,
      receivedAtMillis: 5678,
    );

    expect(entry.version, 9);
    expect(entry.isEdited, isTrue);
    expect(entry.content, 'updated content');
  });

  test('reaction events preserve an earlier edited state', () {
    const message = RoomRealtimeMessage(
      kind: RoomRealtimeMessageKind.chat,
      chatId: 'msg_42',
      chatContent: 'updated content',
      senderUserId: 'usr_7',
      chatEventKind: RoomRealtimeChatEventKind.reactionsChanged,
      chatEdited: true,
      chatVersion: 9,
    );

    final entry = RoomRealtimeChatEntry.fromMessage(
      message,
      receivedAtMillis: 5678,
    );

    expect(entry.isEdited, isTrue);
  });
}
