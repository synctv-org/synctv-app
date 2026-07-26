import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_peer_performance.dart';

void main() {
  test('lower latency wins when peer bandwidth is equal', () {
    final nearby = P2pPeerPerformance()
      ..recordRoundTrip(const Duration(milliseconds: 15))
      ..recordSuccess(1024 * 1024, const Duration(milliseconds: 215));
    final distant = P2pPeerPerformance()
      ..recordRoundTrip(const Duration(milliseconds: 90))
      ..recordSuccess(1024 * 1024, const Duration(milliseconds: 290));

    expect(compareP2pPeerPerformance(nearby, distant), lessThan(0));
  });

  test('higher bandwidth wins when it yields a faster piece', () {
    final slow = P2pPeerPerformance()
      ..recordRoundTrip(const Duration(milliseconds: 20))
      ..recordSuccess(1024 * 1024, const Duration(seconds: 2));
    final fast = P2pPeerPerformance()
      ..recordRoundTrip(const Duration(milliseconds: 35))
      ..recordSuccess(1024 * 1024, const Duration(milliseconds: 180));

    expect(compareP2pPeerPerformance(fast, slow), lessThan(0));
  });

  test('in-flight work sends the next piece to another capable peer', () {
    final busy = P2pPeerPerformance()
      ..recordRoundTrip(const Duration(milliseconds: 10))
      ..recordSuccess(1024 * 1024, const Duration(milliseconds: 150))
      ..beginRequest();
    final idle = P2pPeerPerformance()
      ..recordRoundTrip(const Duration(milliseconds: 15))
      ..recordSuccess(1024 * 1024, const Duration(milliseconds: 180));

    expect(compareP2pPeerPerformance(idle, busy), lessThan(0));
  });

  test('failures reduce priority and a success restores it', () {
    final recovering = P2pPeerPerformance()
      ..recordRoundTrip(const Duration(milliseconds: 10))
      ..recordSuccess(1024 * 1024, const Duration(milliseconds: 150))
      ..recordFailure()
      ..recordFailure();
    final stable = P2pPeerPerformance()
      ..recordRoundTrip(const Duration(milliseconds: 20))
      ..recordSuccess(1024 * 1024, const Duration(milliseconds: 220));

    expect(compareP2pPeerPerformance(stable, recovering), lessThan(0));

    recovering.recordSuccess(1024 * 1024, const Duration(milliseconds: 120));
    expect(recovering.consecutiveFailures, 0);
    expect(compareP2pPeerPerformance(recovering, stable), lessThan(0));
  });
}
