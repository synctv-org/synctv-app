import 'dart:async';

import 'package:synctv_app/features/media_p2p/application/p2p_media_engine_owner.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_runtime.dart';

const p2pEngineOwnerChecks = [
  'Closed room never creates an engine',
  'Late engine is disposed after room exit',
  'Concurrent callers share engine creation',
  'Reentrant callers share registered creation',
  'Superseded creation preserves the new engine',
  'Synchronous creation failure permits retry',
  'Asynchronous creation failure permits retry',
  'Current engine transfers for ordered disposal',
  'Late disposal failure is reported without retaining engine',
];

Future<void> runP2pEngineOwnerCheck(String scenario) async {
  final owner = P2pMediaEngineOwner();
  final first = _Engine();
  final second = _Engine();
  final pending = Completer<P2pMediaPlaybackEngine>();
  switch (scenario) {
    case 'Reentrant callers share registered creation':
      Future<P2pMediaPlaybackEngine?>? nested;
      var duplicates = 0;
      final outer = owner.acquire(() {
        nested = owner.acquire(() async {
          duplicates++;
          return second;
        });
        return pending.future;
      });
      pending.complete(first);
      final results = await Future.wait([outer, nested!]);
      _check(
        duplicates == 0 && identical(outer, nested),
        'Reentrant creation was duplicated',
      );
      _check(
        results.every((engine) => identical(engine, first)),
        'Reentrant callers received different engines',
      );
    case 'Closed room never creates an engine':
      owner.close();
      var creates = 0;
      final result = await owner.acquire(() async {
        creates++;
        return first;
      });
      _check(result == null && creates == 0, 'Closed owner created an engine');
    case 'Late engine is disposed after room exit':
      final result = owner.acquire(() => pending.future);
      owner.close();
      _check(owner.takeCurrent() == null, 'Pending engine exposed as current');
      pending.complete(first);
      _check(await result == null, 'Closed owner returned a late engine');
      _check(
        first.disposals == 1 && owner.current == null,
        'Late engine leaked',
      );
    case 'Concurrent callers share engine creation':
      var creates = 0;
      Future<P2pMediaPlaybackEngine> create() {
        creates++;
        return pending.future;
      }
      final one = owner.acquire(create);
      final two = owner.acquire(create);
      _check(identical(one, two), 'Concurrent futures differ');
      pending.complete(first);
      _check(
        identical(await one, first) && identical(await two, first),
        'Engine not shared',
      );
      _check(
        identical(await owner.acquire(create), first) && creates == 1,
        'Existing engine recreated',
      );
    case 'Superseded creation preserves the new engine':
      final stale = owner.acquire(() => pending.future);
      owner.takeCurrent();
      await owner.acquire(() async => second);
      pending.complete(first);
      _check(await stale == null, 'Superseded engine returned');
      _check(
        first.disposals == 1 && identical(owner.current, second),
        'Stale result replaced new engine',
      );
      _check(second.disposals == 0, 'Current engine disposed');
    case 'Synchronous creation failure permits retry':
      final error = StateError('Create failed');
      final failure = await _failure(owner.acquire(() => throw error));
      _check(identical(failure, error), 'Synchronous error lost');
      _check(
        identical(await owner.acquire(() async => second), second),
        'Retry failed',
      );
    case 'Asynchronous creation failure permits retry':
      final error = StateError('Create failed');
      final failure = _failure(owner.acquire(() => pending.future));
      pending.completeError(error);
      _check(identical(await failure, error), 'Asynchronous error lost');
      _check(
        identical(await owner.acquire(() async => second), second),
        'Retry failed',
      );
    case 'Current engine transfers for ordered disposal':
      await owner.acquire(() async => first);
      owner.close();
      final transferred = owner.takeCurrent();
      _check(identical(transferred, first), 'Current engine lost');
      _check(
        owner.current == null && first.disposals == 0,
        'Disposal order bypassed',
      );
      _check(owner.takeCurrent() == null, 'Engine transferred twice');
      await transferred!.dispose();
      _check(first.disposals == 1, 'Transferred engine not disposed');
    case 'Late disposal failure is reported without retaining engine':
      final error = StateError('Disposal failed');
      first.disposalError = error;
      final failure = _failure(owner.acquire(() => pending.future));
      owner.close();
      pending.complete(first);
      _check(identical(await failure, error), 'Disposal error lost');
      _check(
        owner.current == null && first.disposals == 1,
        'Failed disposal retained engine',
      );
    default:
      throw ArgumentError.value(scenario);
  }
  owner.close();
  await owner.takeCurrent()?.dispose();
}

final class _Engine implements P2pMediaPlaybackEngine {
  int disposals = 0;
  Object? disposalError;

  @override
  Future<void> dispose() async {
    disposals++;
    final error = disposalError;
    if (error != null) throw error;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Future<Object?> _failure(Future<Object?> operation) async {
  try {
    await operation;
    return null;
  } catch (error) {
    return error;
  }
}

void _check(bool condition, String message) {
  if (!condition) throw StateError(message);
}
