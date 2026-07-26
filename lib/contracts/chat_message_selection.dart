import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

const List<client_enum.ChatMessageType> chatTimelineMessageTypes = [
  client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_USER,
  client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_SYSTEM_MEMBER_JOINED,
  client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_SYSTEM_PLAYBACK_CHANGED,
];

const List<client_enum.ChatMessageType> chatDanmakuMessageTypes = [
  client_enum.ChatMessageType.CHAT_MESSAGE_TYPE_USER,
];
