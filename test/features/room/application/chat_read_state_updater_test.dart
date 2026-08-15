import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/application/chat_read_state_updater.dart';

void main() {
  test(
    'coalesces visible messages received during an in-flight update',
    () async {
      final calls = <String>[];
      final firstCall = Completer<void>();
      final updater = ChatReadStateUpdater(
        markRead: (messageId) async {
          calls.add(messageId);
          if (messageId == 'first') await firstCall.future;
        },
      );

      updater
        ..markVisible('first')
        ..markVisible('second')
        ..markVisible('third');
      await Future<void>.delayed(Duration.zero);
      expect(calls, ['first']);

      firstCall.complete();
      await Future<void>.delayed(Duration.zero);

      expect(calls, ['first', 'third']);
    },
  );

  test('continues with the latest cursor after a failed update', () async {
    final calls = <String>[];
    final updater = ChatReadStateUpdater(
      markRead: (messageId) async {
        calls.add(messageId);
        if (messageId == 'first') throw StateError('temporary failure');
      },
    );

    updater
      ..markVisible('first')
      ..markVisible('second');
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(calls, ['first', 'second']);
  });
}
