import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/voice/infrastructure/voice_chat_manager.dart';

void main() {
  test('join validates ICE servers before announcing voice presence', () async {
    final signals = <String>[];
    var stateChanges = 0;
    final manager = VoiceChatManager(
      onSignalingMessage: (type, _) => signals.add(type),
      loadIceServers: () async => const [],
      onStateChange: () => stateChanges += 1,
    );

    await expectLater(
      manager.join(clientOperationId: 'voice-join-1'),
      throwsA(isA<StateError>()),
    );

    expect(manager.isConnected, isFalse);
    expect(manager.participantCount, 0);
    expect(signals, isEmpty);
    expect(stateChanges, 0);
  });
}
