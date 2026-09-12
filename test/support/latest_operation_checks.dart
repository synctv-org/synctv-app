import 'dart:async';

import 'package:synctv_app/core/async/async_operation_coordinator.dart';

void _require(bool condition, String message) {
  if (!condition) throw StateError(message);
}

final latestOperationChecks = <String, Future<void> Function()>{
  'Synchronous same-key reentry shares work': () async {
    final coordinator = LatestAsyncOperationCoordinator();
    final release = Completer<void>();
    late Future<void> duplicate;
    var duplicateCalls = 0;
    final first = coordinator.run('a', (_) {
      duplicate = coordinator.run('a', (_) async => duplicateCalls++);
      return release.future;
    });
    release.complete();
    await Future.wait([first, duplicate]);
    _require(duplicateCalls == 0, 'Reentry started a duplicate operation');
  },
  for (final failure in [false, true])
    'Reentrant replacement survives old ${failure ? 'failure' : 'success'}':
        () async {
          final coordinator = LatestAsyncOperationCoordinator();
          final oldRelease = Completer<void>();
          final newRelease = Completer<void>();
          late Future<void> replacement;
          late IsLatestOperation replacementIsLatest;
          var duplicateCalls = 0;
          final first = coordinator.run('a', (_) {
            replacement = coordinator.run('b', (isLatest) {
              replacementIsLatest = isLatest;
              return newRelease.future;
            });
            return oldRelease.future;
          });
          Object? error;
          final settled = first.catchError((Object value) {
            error = value;
          });
          if (failure) {
            oldRelease.completeError(StateError('Old operation failed'));
          } else {
            oldRelease.complete();
          }
          await settled;
          final duplicate = coordinator.run('b', (_) async => duplicateCalls++);
          final stillLatest = replacementIsLatest();
          newRelease.complete();
          await Future.wait([replacement, duplicate]);
          _require(
            (error != null) == failure,
            'Old result propagation changed',
          );
          _require(
            duplicateCalls == 0 && stillLatest,
            'Old operation lost the replacement registration',
          );
        },
  'Synchronous invalidation permits immediate retry': () async {
    final coordinator = LatestAsyncOperationCoordinator();
    final release = Completer<void>();
    late IsLatestOperation originalIsLatest;
    var retried = false;
    final first = coordinator.run('a', (isLatest) {
      originalIsLatest = isLatest;
      coordinator.invalidate();
      return release.future;
    });
    final retry = coordinator.run('a', (_) async {
      retried = true;
    });
    final immediatelyRetried = retried;
    release.complete();
    await Future.wait([first, retry]);
    _require(
      immediatelyRetried && !originalIsLatest(),
      'Invalidated operation blocked the retry',
    );
  },
  'Synchronous errors propagate and permit retry': () async {
    final coordinator = LatestAsyncOperationCoordinator();
    final failure = StateError('Synchronous failure');
    Object? caught;
    try {
      await coordinator.run('a', (_) => throw failure);
    } catch (error) {
      caught = error;
    }
    var calls = 0;
    await coordinator.run('a', (_) async => calls++);
    _require(
      identical(caught, failure) && calls == 1,
      'Error or retry was lost',
    );
  },
};
