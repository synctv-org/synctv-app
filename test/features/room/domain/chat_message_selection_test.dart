import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/chat_message_selection.dart';
import 'package:synctv_app/features/room/data/room_realtime_codec.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

void main() {
  test('chat timeline includes persisted playback change messages', () {
    expect(chatTimelineMessageTypes, [
      client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_USER,
      client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_SYSTEM_MEMBER_JOINED,
      client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_SYSTEM_PLAYBACK_CHANGED,
    ]);
  });

  test('danmaku selection remains limited to user messages', () {
    expect(chatDanmakuMessageTypes, [
      client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_USER,
    ]);
  });

  test('chat realtime observation requests the timeline selection', () {
    final message = client.ClientMessage.fromBuffer(
      RoomRealtimeCodec.encodeChatEventsObservation(),
    );

    expect(
      message.observeResource.chatEvents.includeMessageTypes,
      chatTimelineMessageTypes,
    );
  });
}
