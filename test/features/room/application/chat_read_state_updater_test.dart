import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/application/chat_read_state_updater.dart';

void main() {
  test(
    'deduplicates the acknowledged cursor and duplicates queued in flight',
    () async {
      final calls = <String>[];
      final pending = Completer<void>();
      final updater = ChatReadStateUpdater(
        markRead: (id) async {
          calls.add(id);
          await pending.future;
        },
      );
      addTearDown(updater.dispose);
      updater
        ..markVisible('first')
        ..markVisible('first')
        ..markVisible('first');
      pending.complete();
      await Future<void>.delayed(Duration.zero);
      updater.markVisible('first');
      await Future<void>.delayed(Duration.zero);
      expect(calls, ['first']);
    },
  );

  test('failed cursor remains eligible for retry', () async {
    final calls = <String>[];
    final updater = ChatReadStateUpdater(
      markRead: (id) async {
        calls.add(id);
        if (calls.length == 1) throw StateError('temporary failure');
      },
    );
    addTearDown(updater.dispose);
    updater.markVisible('first');
    await Future<void>.delayed(Duration.zero);
    updater.markVisible('first');
    await Future<void>.delayed(Duration.zero);
    updater.markVisible('first');
    await Future<void>.delayed(Duration.zero);
    expect(calls, ['first', 'first']);
  });

  test('deduplication tracks only the last successful cursor', () async {
    final calls = <String>[];
    final updater = ChatReadStateUpdater(markRead: (id) async => calls.add(id));
    addTearDown(updater.dispose);
    for (final id in ['first', 'second', 'first']) {
      updater.markVisible(id);
      await Future<void>.delayed(Duration.zero);
    }
    expect(calls, ['first', 'second', 'first']);
  });

  for (final fail in [false, true]) {
    test('disposal drops queued and later cursors, fail=$fail', () async {
      final calls = <String>[];
      final pending = Completer<void>();
      final updater = ChatReadStateUpdater(
        markRead: (id) async {
          calls.add(id);
          await pending.future;
        },
      );
      updater
        ..markVisible('first')
        ..markVisible('second')
        ..dispose()
        ..markVisible('third');
      if (fail) {
        pending.completeError(StateError('request failed'));
      } else {
        pending.complete();
      }
      await Future<void>.delayed(Duration.zero);
      expect(calls, ['first']);
    });
  }

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
