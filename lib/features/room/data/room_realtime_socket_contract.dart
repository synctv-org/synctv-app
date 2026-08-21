/// WebSocket connection abstraction shared by native and web runtimes.
///
/// [messages] is a single-subscription stream. The socket returned by
/// [connectRoomRealtimeSocket] is ready before the connection future
/// completes. [close] is idempotent: calling it more than once is safe and
/// should not throw due to an already-closed connection. [close] must release
/// the underlying connection and complete even if [messages] was never
/// listened to.
abstract interface class RoomRealtimeSocket {
  Stream<String> get messages;

  void send(String message);

  Future<void> close();
}
