import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/data/realtime_frame_codec.dart';

void main() {
  group('RealtimeFrameCodec', () {
    test('round trips a frame', () {
      final payload = Uint8List.fromList(List.generate(300, (i) => i & 0xff));
      final frame = encodeRealtimeFrame(payload);

      expect(frame.length, payload.length + 4);
      // Big-endian length prefix.
      expect(frame.sublist(0, 4), [0, 0, 1, 44]);

      final reader = RealtimeFrameReader();
      expect(reader.addChunk(frame), [payload]);
    });

    test('reassembles frames split across arbitrary chunk boundaries', () {
      final payloadA = Uint8List.fromList(List.filled(100, 7));
      final payloadB = Uint8List.fromList(List.filled(50, 9));
      final wire = BytesBuilder()
        ..add(encodeRealtimeFrame(payloadA))
        ..add(encodeRealtimeFrame(payloadB));
      final bytes = wire.takeBytes();

      final reader = RealtimeFrameReader();
      final frames = <Uint8List>[];
      // Feed one byte at a time: worst-case fragmentation.
      for (var i = 0; i < bytes.length; i++) {
        frames.addAll(reader.addChunk(Uint8List.sublistView(bytes, i, i + 1)));
      }
      expect(frames, [payloadA, payloadB]);
    });

    test('multiple frames in one chunk', () {
      final reader = RealtimeFrameReader();
      final frames = reader.addChunk(
        Uint8List.fromList([
          ...encodeRealtimeFrame([1, 2]),
          ...encodeRealtimeFrame([3]),
        ]),
      );
      expect(frames, hasLength(2));
      expect(frames[0], [1, 2]);
      expect(frames[1], [3]);
    });

    test('empty payload frame survives', () {
      final reader = RealtimeFrameReader();
      expect(reader.addChunk(encodeRealtimeFrame(const [])), [Uint8List(0)]);
    });

    test('rejects oversize frames', () {
      final reader = RealtimeFrameReader();
      final header = Uint8List(4)..[0] = 0xff; // 0xff000000 far exceeds the cap
      expect(
        () => reader.addChunk(header),
        throwsA(isA<RealtimeFrameFormatException>()),
      );

      expect(
        () => encodeRealtimeFrame(List.filled(64 * 1024 + 1, 0)),
        throwsA(isA<RealtimeFrameFormatException>()),
      );
    });
  });
}
