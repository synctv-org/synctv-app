import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_transfer_protocol.dart';

void main() {
  test('incoming transfer accepts matching length', () async {
    final bytes = Uint8List.fromList([1, 2, 3, 4]);
    final transfer = P2pIncomingTransfer()
      ..begin(bytes.length)
      ..add(Uint8List.sublistView(bytes, 0, 2), 16)
      ..add(Uint8List.sublistView(bytes, 2), 16)
      ..complete();

    expect(
      await transfer.wait(
        idleTimeout: const Duration(milliseconds: 20),
        completionBudget: const Duration(seconds: 1),
      ),
      bytes,
    );
  });

  test('incoming transfer rejects length mismatch', () async {
    final transfer = P2pIncomingTransfer()
      ..begin(4)
      ..add(Uint8List.fromList([1, 2, 3]), 16)
      ..complete();

    expect(
      transfer.wait(
        idleTimeout: const Duration(milliseconds: 20),
        completionBudget: const Duration(seconds: 1),
      ),
      throwsFormatException,
    );
  });

  test('incoming activity extends the idle deadline', () async {
    final bytes = Uint8List.fromList([1, 2]);
    final transfer = P2pIncomingTransfer()..begin(bytes.length);
    final result = transfer.wait(
      idleTimeout: const Duration(milliseconds: 200),
      completionBudget: const Duration(seconds: 1),
    );
    await Future<void>.delayed(const Duration(milliseconds: 125));
    transfer.add(Uint8List.fromList([1]), 16);
    await Future<void>.delayed(const Duration(milliseconds: 125));
    transfer.add(Uint8List.fromList([2]), 16);
    transfer.complete();

    expect(await result, bytes);
  });

  test('incoming transfer expires after an idle interval', () async {
    final transfer = P2pIncomingTransfer();

    expect(
      transfer.wait(
        idleTimeout: const Duration(milliseconds: 10),
        completionBudget: const Duration(seconds: 1),
      ),
      throwsA(isA<TimeoutException>()),
    );
  });

  test('permit pool transfers capacity in FIFO order', () async {
    final pool = P2pPermitPool(1);
    await pool.acquire();
    var secondAcquired = false;
    final second = pool.acquire().then((_) => secondAcquired = true);
    await Future<void>.delayed(Duration.zero);
    expect(secondAcquired, isFalse);
    expect(pool.active, 1);
    expect(pool.queued, 1);

    pool.release();
    await second;
    expect(secondAcquired, isTrue);
    expect(pool.active, 1);
    pool.release();
    expect(pool.active, 0);
  });

  test('permit pool removes a cancelled queued caller', () async {
    final pool = P2pPermitPool(1);
    await pool.acquire();
    final cancelled = Completer<void>();
    final queued = pool.acquire(cancelled: cancelled.future);
    await Future<void>.delayed(Duration.zero);
    expect(pool.queued, 1);

    cancelled.complete();

    expect(await queued, isFalse);
    expect(pool.queued, 0);
    expect(pool.active, 1);
    pool.release();
    expect(pool.active, 0);
  });

  test('closing a permit pool releases queued callers with an error', () async {
    final pool = P2pPermitPool(1);
    await pool.acquire();
    final queued = pool.acquire();

    pool.close();

    await expectLater(queued, throwsStateError);
    pool.release();
    expect(pool.active, 0);
  });
}
