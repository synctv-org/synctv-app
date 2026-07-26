import 'dart:typed_data';

abstract interface class RoomRealtimeChannel {
  Stream<Uint8List> get stream;

  Future<void> get ready;

  void send(List<int> bytes);

  Future<void> close();
}

abstract interface class RoomRealtimeChannelFactory {
  RoomRealtimeChannel connect(
    String roomId, {
    Iterable<List<int>> initialMessages = const [],
    void Function(List<int> bytes)? onOutgoing,
    void Function(Uint8List bytes)? onIncoming,
  });
}
