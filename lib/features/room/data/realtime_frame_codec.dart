import 'dart:typed_data';

/// Length-prefixed protobuf frame codec shared by the WebTransport
/// transports (web JS interop and native FFI): 4-byte big-endian length +
/// payload, mirroring the server's frame writer.
///
/// The reader is incremental: feed it stream chunks; it emits complete
/// frames as they assemble.
class RealtimeFrameReader {
  RealtimeFrameReader({this.maxFrameBytes = maxRealtimeFrameBytes});

  /// Maximum frame payload (must match the server's cap).
  static const maxRealtimeFrameBytes = 64 * 1024;

  final int maxFrameBytes;

  final BytesBuilder _buffer = BytesBuilder(copy: false);
  int? _pendingLength;

  /// Feeds [chunk] and returns every complete frame it completes.
  List<Uint8List> addChunk(Uint8List chunk) {
    _buffer.add(chunk);
    final frames = <Uint8List>[];
    while (true) {
      final available = _buffer.length;
      final length = _pendingLength;
      if (length == null) {
        if (available < 4) break;
        final header = _buffer.takeBytes();
        final frameLength =
            (header[0] << 24) |
            (header[1] << 16) |
            (header[2] << 8) |
            header[3];
        if (frameLength > maxFrameBytes) {
          throw const RealtimeFrameFormatException('frame exceeds size cap');
        }
        _buffer.add(header.sublist(4));
        _pendingLength = frameLength;
        continue;
      }
      if (available < length) break;
      final data = _buffer.takeBytes();
      frames.add(Uint8List.sublistView(data, 0, length));
      _buffer.add(data.sublist(length));
      _pendingLength = null;
    }
    return frames;
  }
}

/// Encodes [payload] as one length-prefixed frame.
Uint8List encodeRealtimeFrame(List<int> payload) {
  if (payload.length > RealtimeFrameReader.maxRealtimeFrameBytes) {
    throw const RealtimeFrameFormatException('frame exceeds size cap');
  }
  final frame = Uint8List(4 + payload.length);
  final length = payload.length;
  frame[0] = (length >> 24) & 0xff;
  frame[1] = (length >> 16) & 0xff;
  frame[2] = (length >> 8) & 0xff;
  frame[3] = length & 0xff;
  frame.setAll(4, payload);
  return frame;
}

class RealtimeFrameFormatException implements Exception {
  const RealtimeFrameFormatException(this.message);

  final String message;

  @override
  String toString() => 'RealtimeFrameFormatException: $message';
}
