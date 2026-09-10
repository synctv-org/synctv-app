@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/voice/infrastructure/voice_chat_manager.dart';

void main() {
  testWidgets('leaving an idle browser room never initializes native WebRTC', (
    tester,
  ) async {
    final manager = VoiceChatManager(
      onSignalingMessage: (_, _) {},
      onStateChange: () {},
      loadIceServers: () async => [],
    );
    await manager.leave();
    await manager.dispose();
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
