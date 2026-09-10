import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

final class AdminChatModerationOptimisticState {
  final Map<String, RoomChatMessageInfo> _serverMessages = {};
  final Map<int, _ModerationIntent> _intents = {};
  int _nextIntentId = 1;

  void clearServerMessages() {
    _serverMessages.clear();
    // Accepted jobs are asynchronous; an explicit refresh trusts the server.
    _intents.removeWhere((_, intent) => intent.accepted);
  }

  int begin({
    required String messageId,
    required String userId,
    required bool deleteAllMessages,
  }) {
    final intentId = _nextIntentId++;
    _intents[intentId] = _ModerationIntent(
      messageId: messageId,
      userId: userId,
      deleteAllMessages: deleteAllMessages,
    );
    return intentId;
  }

  void discard(int intentId) => _intents.remove(intentId);

  void accept(int intentId) {
    _intents[intentId]?.accepted = true;
  }

  RoomChatMessageInfo recordServerMessage(RoomChatMessageInfo message) {
    final current = _serverMessages[message.id];
    if (current != null && current.version > message.version) {
      return _displayMessage(current);
    }
    _serverMessages[message.id] = message;
    return _displayMessage(message);
  }

  RoomChatMessageInfo? messageForDisplay(String messageId) {
    final message = _serverMessages[messageId];
    return message == null ? null : _displayMessage(message);
  }

  RoomChatMessageInfo _displayMessage(RoomChatMessageInfo message) {
    if (message.isDeleted ||
        !_intents.values.any((intent) => intent.matches(message))) {
      return message;
    }
    return message.copyWith(
      status: client_enum.ChatMessageStatus.CHAT_MESSAGE_STATUS_DELETED,
      version: message.version + 1,
      images: const [],
      reactions: const [],
      reactionCount: 0,
      clearPin: true,
    );
  }
}

final class _ModerationIntent {
  _ModerationIntent({
    required this.messageId,
    required this.userId,
    required this.deleteAllMessages,
  });

  final String messageId;
  final String userId;
  final bool deleteAllMessages;
  bool accepted = false;

  bool matches(RoomChatMessageInfo message) =>
      message.id == messageId ||
      (deleteAllMessages && message.userId == userId);
}
