abstract interface class RoomRealtimeSocket {
  Stream<String> get messages;

  void send(String message);

  Future<void> close();
}
