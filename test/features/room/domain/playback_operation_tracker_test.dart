import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/domain/playback_operation_tracker.dart';

void main() {
  test('latest rejected operation restores its previous state', () {
    final tracker = PlaybackOperationTracker<String>();
    tracker.remember('a', 'server');

    final result = tracker.reject('a');

    expect(result.handled, isTrue);
    expect(result.stateToApply, 'server');
  });

  test('earlier rejection updates latest operation rollback baseline', () {
    final tracker = PlaybackOperationTracker<String>();
    tracker.remember('a', 'server');
    tracker.remember('b', 'optimistic-a');

    expect(tracker.reject('a').stateToApply, isNull);
    expect(tracker.reject('b').stateToApply, 'server');
  });

  test('earlier acknowledgement becomes latest rollback baseline', () {
    final tracker = PlaybackOperationTracker<String>();
    tracker.remember('a', 'server');
    tracker.remember('b', 'optimistic-a');

    expect(tracker.acknowledge('a', 'authoritative-a').stateToApply, isNull);
    expect(tracker.reject('b').stateToApply, 'authoritative-a');
  });

  test('duplicate acknowledgement is handled without reapplying old state', () {
    final tracker = PlaybackOperationTracker<String>();
    tracker.remember('a', 'server');

    expect(
      tracker.acknowledge('a', 'authoritative-a').stateToApply,
      'authoritative-a',
    );
    final duplicate = tracker.acknowledge('a', 'stale-a');
    expect(duplicate.handled, isTrue);
    expect(duplicate.stateToApply, isNull);
  });
}
