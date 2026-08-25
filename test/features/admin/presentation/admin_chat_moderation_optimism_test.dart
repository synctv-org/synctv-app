import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/features/admin/presentation/admin_chat_moderation_optimism.dart';

void main() {
  group('AdminChatModerationOptimisticState', () {
    test('applies bulk deletion to messages loaded after submission', () {
      final state = AdminChatModerationOptimisticState();
      state.begin(
        messageId: '10',
        userId: 'usr_target',
        deleteAllMessages: true,
      );

      expect(state.recordServerMessage(_message('10')).isDeleted, isTrue);
      expect(state.recordServerMessage(_message('9')).isDeleted, isTrue);
      expect(
        state.recordServerMessage(_message('8', userId: 'usr_other')).isDeleted,
        isFalse,
      );
    });

    test('restores server messages when submission is discarded', () {
      final state = AdminChatModerationOptimisticState();
      final intentId = state.begin(
        messageId: '10',
        userId: 'usr_target',
        deleteAllMessages: true,
      );
      final original = _message('10');

      expect(state.recordServerMessage(original).isDeleted, isTrue);
      state.discard(intentId);

      final restored = state.messageForDisplay(original.id);
      expect(restored, same(original));
      expect(restored!.isDeleted, isFalse);
      expect(restored.content, 'message 10');
      expect(restored.version, 4);
    });
  });
}

RoomChatMessageInfo _message(String id, {String userId = 'usr_target'}) {
  return RoomChatMessageInfo(
    id: id,
    roomId: 'room_test',
    userId: userId,
    username: userId,
    content: 'message $id',
    timestamp: 1,
    version: 4,
  );
}
