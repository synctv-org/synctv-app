import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/async/persisted_value_controller.dart';

final class _Preferences extends PersistedValueController<int> {
  _Preferences(_Store store)
    : super(initialValue: 0, read: store.read, write: store.write);

  Future<void> update(int value) => persist(value);
}

final class _Store {
  final reads = <Completer<int>>[];
  final writes = <(int, Completer<void>)>[];
  Future<int> read() {
    final result = Completer<int>();
    reads.add(result);
    return result.future;
  }

  Future<void> write(int value) {
    final result = Completer<void>();
    writes.add((value, result));
    return result.future;
  }
}

Future<void> _flush() => Future<void>.delayed(Duration.zero);

void main() {
  test('a pending read cannot replace an optimistic edit', () async {
    final store = _Store();
    final controller = _Preferences(store);
    final load = controller.load();
    await _flush();
    final save = controller.update(2);
    store.reads.single.complete(1);
    await load;
    await _flush();
    expect(controller.value, 2);
    expect(store.writes.single.$1, 2);
    store.writes.single.$2.complete();
    await save;
    controller.dispose();
  });

  test(
    'writes are ordered and an old failure preserves the latest edit',
    () async {
      final store = _Store();
      final controller = _Preferences(store);
      final first = expectLater(controller.update(1), throwsStateError);
      final second = controller.update(2);
      await _flush();
      expect(store.writes, hasLength(1));
      expect(controller.value, 2);
      store.writes[0].$2.completeError(StateError('first failed'));
      await first;
      await _flush();
      expect(controller.value, 2);
      expect(store.writes[1].$1, 2);
      store.writes[1].$2.complete();
      await second;
      controller.dispose();
    },
  );

  test('multiple failed edits roll back to durable storage', () async {
    final store = _Store();
    final controller = _Preferences(store);
    final load = controller.load();
    await _flush();
    store.reads.single.complete(7);
    await load;
    final first = expectLater(controller.update(1), throwsStateError);
    final second = expectLater(controller.update(2), throwsStateError);
    await _flush();
    store.writes[0].$2.completeError(StateError('first failed'));
    await first;
    await _flush();
    store.writes[1].$2.completeError(StateError('second failed'));
    await second;
    expect(controller.value, 7);
    controller.dispose();
  });

  test('a failed edit rolls back to the previous successful write', () async {
    final store = _Store();
    final controller = _Preferences(store);
    final first = controller.update(1);
    final second = expectLater(controller.update(2), throwsStateError);
    await _flush();
    store.writes[0].$2.complete();
    await first;
    await _flush();
    store.writes[1].$2.completeError(StateError('failed'));
    await second;
    expect(controller.value, 1);
    controller.dispose();
  });

  test('failed loads can be retried and concurrent loads share work', () async {
    final store = _Store();
    final controller = _Preferences(store);
    final first = controller.load();
    expect(identical(controller.load(), first), isTrue);
    final failure = expectLater(first, throwsStateError);
    await _flush();
    store.reads[0].completeError(StateError('read failed'));
    await failure;
    final retry = controller.load();
    await _flush();
    store.reads[1].complete(4);
    await retry;
    await controller.load();
    expect(store.reads, hasLength(2));
    expect(controller.value, 4);
    controller.dispose();
  });

  test('closing a controller permits pending persistence to finish', () async {
    final store = _Store();
    final controller = _Preferences(store);
    final load = controller.load();
    await _flush();
    controller.dispose();
    store.reads.single.complete(1);
    await load;
  });
}
