import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/async/async_operation_coordinator.dart';

void main() {
  test(
    'same key shares pending work while other keys remain current',
    () async {
      final coordinator = KeyedAsyncOperationCoordinator();
      final release = Completer<void>();
      final outcomes = <bool>[];
      var duplicateCalls = 0;
      final first = coordinator.run('a', (isCurrent) async {
        await release.future;
        outcomes.add(isCurrent());
      });
      final duplicate = coordinator.run('a', (_) async => duplicateCalls++);
      final second = coordinator.run('b', (isCurrent) async {
        await release.future;
        outcomes.add(isCurrent());
      });
      expect(identical(first, duplicate), isTrue);
      release.complete();
      await Future.wait([first, duplicate, second]);
      expect(outcomes, [true, true]);
      expect(duplicateCalls, 0);
    },
  );

  for (final failure in [false, true]) {
    test(
      'obsolete completion preserves replacement, failure=$failure',
      () async {
        final coordinator = KeyedAsyncOperationCoordinator();
        final oldRelease = Completer<void>();
        final freshRelease = Completer<void>();
        late bool Function() oldCurrent;
        late bool Function() freshCurrent;
        final old = coordinator.run('a', (isCurrent) {
          oldCurrent = isCurrent;
          return oldRelease.future;
        });
        final oldResult = failure ? expectLater(old, throwsStateError) : old;
        coordinator.invalidate(key: 'a');
        final fresh = coordinator.run('a', (isCurrent) {
          freshCurrent = isCurrent;
          return freshRelease.future;
        });
        expect(oldCurrent(), isFalse);
        if (failure) {
          oldRelease.completeError(StateError('obsolete'));
        } else {
          oldRelease.complete();
        }
        await oldResult;
        final duplicate = coordinator.run(
          'a',
          (_) async => fail('duplicate request'),
        );
        expect(identical(fresh, duplicate), isTrue);
        expect(freshCurrent(), isTrue);
        freshRelease.complete();
        await fresh;
        expect(freshCurrent(), isFalse);
      },
    );
  }

  test('invalidating one key preserves unrelated pending work', () async {
    final coordinator = KeyedAsyncOperationCoordinator();
    final release = Completer<void>();
    late bool Function() aCurrent;
    late bool Function() bCurrent;
    final a = coordinator.run('a', (current) {
      aCurrent = current;
      return release.future;
    });
    final b = coordinator.run('b', (current) {
      bCurrent = current;
      return release.future;
    });
    coordinator.invalidate(key: 'a');
    expect(aCurrent(), isFalse);
    expect(bCurrent(), isTrue);
    release.complete();
    await Future.wait([a, b]);
  });

  test(
    'invalidate all expires pending callbacks and permits immediate restart',
    () async {
      final coordinator = KeyedAsyncOperationCoordinator();
      final release = Completer<void>();
      final currents = <bool Function()>[];
      final pending = [
        for (final key in ['a', 'b'])
          coordinator.run(key, (current) {
            currents.add(current);
            return release.future;
          }),
      ];
      coordinator.invalidate();
      expect(currents.map((current) => current()), [false, false]);
      var calls = 0;
      await coordinator.run('a', (_) async => calls++);
      expect(calls, 1);
      release.complete();
      await Future.wait(pending);
    },
  );

  test('synchronous failures propagate and allow retry', () async {
    final coordinator = KeyedAsyncOperationCoordinator();
    await expectLater(
      coordinator.run('a', (_) => throw StateError('failed')),
      throwsStateError,
    );
    var calls = 0;
    await coordinator.run('a', (_) async => calls++);
    expect(calls, 1);
  });

  test('completed operation releases key for the next request', () async {
    final coordinator = KeyedAsyncOperationCoordinator();
    var calls = 0;
    await coordinator.run('a', (_) async => calls++);
    await coordinator.run('a', (_) async => calls++);
    expect(calls, 2);
  });
}
