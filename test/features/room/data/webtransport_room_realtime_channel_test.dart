import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/data/webtransport_room_realtime_channel.dart';

void main() {
  test('native provider reports support and builds a factory', () {
    final supported = isWebTransportSupported();
    final factory = webTransportChannelFactory(
      createUri: (roomId) async =>
          Uri.parse('https://wt.example/wt/rooms/$roomId'),
      certificateHashBase64: null,
    );

    // On native builds the bridge is bundled; on web this file never runs.
    expect(supported, isTrue);
    expect(factory, isNotNull);

    // connect() is synchronous: it returns immediately with the connection
    // still pending, satisfying the channel contract.
    final channel = factory!.connect('room-1');
    expect(channel.stream, isA<Stream<Uint8List>>());
    unawaited(channel.close());
  });

  test('factory is created even with a pinned certificate hash', () {
    final factory = webTransportChannelFactory(
      createUri: (roomId) async => Uri.parse('https://wt.example/$roomId'),
      certificateHashBase64: 'Ac6xXcJxS8kOiD9CTJlPeGvMlu1Yl0ZJDVhaRZ4tXwE=',
    );
    expect(factory, isNotNull);
  });
}
