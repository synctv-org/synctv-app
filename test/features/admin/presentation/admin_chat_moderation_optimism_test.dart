import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/features/admin/presentation/admin_chat_moderation_optimism.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart' as client;

void main() {
  group('AdminChatModerationOptimisticState', () {
    test(
      'refresh retires accepted intents and retains unresolved submissions',
      () {
        final state = AdminChatModerationOptimisticState();
        final accepted = state.begin(
          messageId: '10',
          userId: 'usr_target',
          deleteAllMessages: true,
        );
        final pending = state.begin(
          messageId: '11',
          userId: 'usr_other',
          deleteAllMessages: false,
        );
        state.accept(accepted);
        expect(state.recordServerMessage(_message('10')).isDeleted, isTrue);
        state.clearServerMessages();
        final refreshed = _message('10');
        expect(state.recordServerMessage(refreshed), same(refreshed));
        expect(
          state
              .recordServerMessage(_message('11', userId: 'usr_other'))
              .isDeleted,
          isTrue,
        );
        state.discard(pending);
        expect(state.messageForDisplay('11')!.isDeleted, isFalse);
      },
    );

    test('late acceptance of a discarded intent cannot recreate it', () {
      final state = AdminChatModerationOptimisticState();
      final intent = state.begin(
        messageId: '10',
        userId: 'usr_target',
        deleteAllMessages: true,
      );
      state.discard(intent);
      state.accept(intent);
      expect(state.recordServerMessage(_message('10')).isDeleted, isFalse);
    });

    test('older history cannot replace a confirmed deletion', () {
      final state = AdminChatModerationOptimisticState();
      final original = _message('10');
      final deleted = original.copyWith(
        status: client.ChatMessageStatus.CHAT_MESSAGE_STATUS_DELETED,
        version: 5,
      );
      state.recordServerMessage(deleted);
      expect(state.recordServerMessage(original), same(deleted));
      expect(state.messageForDisplay('10'), same(deleted));
    });

    test('discarding one overlapping intent preserves the other', () {
      final state = AdminChatModerationOptimisticState();
      final first = state.begin(
        messageId: '10',
        userId: 'usr_target',
        deleteAllMessages: false,
      );
      final second = state.begin(
        messageId: '9',
        userId: 'usr_target',
        deleteAllMessages: true,
      );
      final original = _message('10');
      state.recordServerMessage(original);
      state.discard(first);
      expect(state.messageForDisplay('10')!.isDeleted, isTrue);
      state.discard(second);
      expect(state.messageForDisplay('10'), same(original));
    });

    test(
      'rollback restores latest server state despite late older history',
      () {
        final state = AdminChatModerationOptimisticState();
        final intent = state.begin(
          messageId: '10',
          userId: 'usr_target',
          deleteAllMessages: false,
        );
        final original = _message('10');
        final updated = original.copyWith(content: 'edited', version: 5);
        state.recordServerMessage(updated);
        state.recordServerMessage(original);
        state.discard(intent);
        expect(state.messageForDisplay('10'), same(updated));
      },
    );

    test('refresh clears cached versions but retains pending intentions', () {
      final state = AdminChatModerationOptimisticState();
      final intent = state.begin(
        messageId: '10',
        userId: 'usr_target',
        deleteAllMessages: true,
      );
      state.recordServerMessage(_message('10').copyWith(version: 5));
      state.clearServerMessages();
      expect(state.messageForDisplay('10'), isNull);
      final refreshed = _message('10');
      expect(state.recordServerMessage(refreshed).isDeleted, isTrue);
      state.discard(intent);
      expect(state.messageForDisplay('10'), same(refreshed));
    });

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
