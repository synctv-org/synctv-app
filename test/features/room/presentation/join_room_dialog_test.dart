import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room/presentation/join_room_dialog.dart';
import 'package:synctv_app/l10n/app_localizations.dart';

import '../../../test_app.dart';

void main() {
  testWidgets('room password dialog keeps the form open and allows retry', (
    tester,
  ) async {
    var attempts = 0;
    JoinRoomResult? completed;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: buildThemedTestApp,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                completed = await showRoomPasswordDialog(
                  context: context,
                  roomName: 'Friday Film Club',
                  onSubmitted: (password) async {
                    attempts++;
                    if (password == 'wrong') {
                      throw RoomPasswordRejectedException(
                        StateError('credential validation failed'),
                      );
                    }
                    return const JoinRoomResult(requiresApproval: false);
                  },
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'wrong');
    await tester.tap(find.text('Join room').last);
    await tester.pumpAndSettle();

    expect(find.text('Incorrect room password'), findsOneWidget);
    expect(find.text('Enter room password'), findsOneWidget);
    expect(attempts, 1);
    expect(completed, isNull);

    await tester.enterText(find.byType(TextField), 'correct');
    await tester.tap(find.text('Join room').last);
    await tester.pumpAndSettle();

    expect(find.text('Enter room password'), findsNothing);
    expect(attempts, 2);
    expect(completed?.requiresApproval, isFalse);
  });
}
