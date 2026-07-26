import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/async/async_operation_coordinator.dart';

void main() {
  test('state epoch invalidates results captured before a session change', () {
    final epoch = AsyncStateEpoch();
    final previousSession = epoch.capture();

    expect(epoch.isCurrent(previousSession), isTrue);
    epoch.advance();

    expect(epoch.isCurrent(previousSession), isFalse);
    expect(epoch.isCurrent(epoch.capture()), isTrue);
  });

  test('coalesces concurrent operations for the same key', () async {
    final coordinator = LatestAsyncOperationCoordinator();
    final release = Completer<void>();
    var calls = 0;

    final first = coordinator.run('video-a', (_) async {
      calls++;
      await release.future;
    });
    await Future<void>.delayed(Duration.zero);
    final duplicate = coordinator.run('video-a', (_) async => calls++);

    release.complete();
    await Future.wait([first, duplicate]);
    expect(calls, 1);
  });

  test(
    'starts the latest key while the previous operation is pending',
    () async {
      final coordinator = LatestAsyncOperationCoordinator();
      final releaseFirst = Completer<void>();
      final events = <String>[];

      final first = coordinator.run('video-a', (isLatest) async {
        events.add('a-start');
        await releaseFirst.future;
        events.add(isLatest() ? 'a-current' : 'a-stale');
      });
      await Future<void>.delayed(Duration.zero);
      final second = coordinator.run('video-b', (_) async {
        events.add('b-start');
      });

      expect(events, ['a-start', 'b-start']);
      releaseFirst.complete();
      await Future.wait([first, second]);
      expect(events, ['a-start', 'b-start', 'a-stale']);
    },
  );

  test('only the latest concurrent operation remains current', () async {
    final coordinator = LatestAsyncOperationCoordinator();
    final releaseFirst = Completer<void>();
    final releaseSecond = Completer<void>();
    final outcomes = <String>[];

    final first = coordinator.run('video-a', (isLatest) async {
      await releaseFirst.future;
      outcomes.add(isLatest() ? 'a-current' : 'a-stale');
    });
    final second = coordinator.run('video-b', (isLatest) async {
      await releaseSecond.future;
      outcomes.add(isLatest() ? 'b-current' : 'b-stale');
    });
    final latest = coordinator.run('video-c', (isLatest) async {
      outcomes.add(isLatest() ? 'c-current' : 'c-stale');
    });

    releaseFirst.complete();
    releaseSecond.complete();
    await Future.wait([first, second, latest]);
    expect(outcomes, ['c-current', 'a-stale', 'b-stale']);
  });

  test('invalidate allows the same key to restart immediately', () async {
    final coordinator = LatestAsyncOperationCoordinator();
    final releaseFirst = Completer<void>();
    final events = <String>[];

    final first = coordinator.run('video-a', (isLatest) async {
      events.add('first-start');
      await releaseFirst.future;
      events.add(isLatest() ? 'first-current' : 'first-stale');
    });
    coordinator.invalidate();
    final second = coordinator.run('video-a', (_) async {
      events.add('second-start');
    });

    expect(events, ['first-start', 'second-start']);
    releaseFirst.complete();
    await Future.wait([first, second]);
    expect(events, ['first-start', 'second-start', 'first-stale']);
  });

  test('serial coordinator preserves operation order across awaits', () async {
    final coordinator = SerialAsyncOperationCoordinator();
    final releaseFirst = Completer<void>();
    final events = <String>[];

    final first = coordinator.run(() async {
      events.add('first:start');
      await releaseFirst.future;
      events.add('first:end');
    });
    final second = coordinator.run(() async {
      events.add('second:start');
      events.add('second:end');
    });

    await Future<void>.delayed(Duration.zero);
    expect(events, ['first:start']);
    releaseFirst.complete();
    await Future.wait([first, second]);
    expect(events, ['first:start', 'first:end', 'second:start', 'second:end']);
  });

  test('failed operation does not poison later operations', () async {
    final coordinator = SerialAsyncOperationCoordinator();
    final first = coordinator.run<void>(() async => throw StateError('failed'));
    final second = coordinator.run(() async => 42);

    await expectLater(first, throwsStateError);
    expect(await second, 42);
  });
}
