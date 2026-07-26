import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';

void main() {
  testWidgets('toast replaces the previous message and dismisses on time', (
    tester,
  ) async {
    late BuildContext testContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            testContext = context;
            return const Scaffold(body: SizedBox.expand());
          },
        ),
      ),
    );

    AppNotifications.showError(
      testContext,
      'old error',
      duration: const Duration(seconds: 3),
    );
    await tester.pump();
    expect(find.text('old error'), findsOneWidget);

    AppNotifications.showSuccess(
      testContext,
      'new success',
      duration: const Duration(seconds: 3),
    );
    await tester.pump();
    expect(find.text('old error'), findsNothing);
    expect(find.text('new success'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('new success'), findsNothing);
  });

  testWidgets('toast replaces an entry before its first frame', (tester) async {
    late BuildContext testContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            testContext = context;
            return const Scaffold(body: SizedBox.expand());
          },
        ),
      ),
    );

    AppNotifications.showError(testContext, 'same-frame error');
    AppNotifications.showSuccess(testContext, 'same-frame success');
    await tester.pump();

    expect(find.text('same-frame error'), findsNothing);
    expect(find.text('same-frame success'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('same-frame success'), findsNothing);
  });

  testWidgets('toast uses the root overlay across route changes', (
    tester,
  ) async {
    late BuildContext rootContext;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            rootContext = context;
            return Scaffold(
              body: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const Scaffold(body: Text('next page')),
                    ),
                  );
                },
                child: const Text('open'),
              ),
            );
          },
        ),
      ),
    );

    AppNotifications.showError(
      rootContext,
      'route error',
      duration: const Duration(seconds: 3),
    );
    await tester.pump();
    expect(find.text('route error'), findsOneWidget);

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('next page'), findsOneWidget);

    AppNotifications.showInfo(
      rootContext,
      'replacement',
      duration: const Duration(seconds: 3),
    );
    await tester.pump();
    expect(find.text('route error'), findsNothing);
    expect(find.text('replacement'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('replacement'), findsNothing);
  });
}
