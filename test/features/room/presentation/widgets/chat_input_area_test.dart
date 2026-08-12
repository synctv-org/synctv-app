import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/presentation/widgets/chat_input_area.dart';
import 'package:synctv_app/l10n/app_localizations.dart';

import '../../../../test_app.dart';

void main() {
  for (final submitMethod in _SubmitMethod.values) {
    testWidgets(
      'keeps the message field focused after ${submitMethod.name} send',
      (tester) async {
        final sendCompleter = Completer<void>();
        var sendCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            builder: buildThemedTestApp,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: _ChatInputHarness(
                onSend: () async {
                  sendCount += 1;
                  await sendCompleter.future;
                },
              ),
            ),
          ),
        );

        final field = find.byType(TextFormField);
        await tester.enterText(field, 'Hello');
        await tester.pump();
        expect(_focusNode(tester, field).hasFocus, isTrue);

        switch (submitMethod) {
          case _SubmitMethod.button:
            await tester.tap(find.byIcon(Icons.send_rounded));
          case _SubmitMethod.keyboard:
            await tester.testTextInput.receiveAction(TextInputAction.send);
        }
        await tester.pump();
        expect(sendCount, 1);

        sendCompleter.complete();
        await tester.pump();
        await tester.pump();

        expect(_focusNode(tester, field).hasFocus, isTrue);
        await tester.pump(const Duration(milliseconds: 150));
      },
    );
  }
}

enum _SubmitMethod { button, keyboard }

FocusNode _focusNode(WidgetTester tester, Finder field) => tester
    .widget<EditableText>(
      find.descendant(of: field, matching: find.byType(EditableText)),
    )
    .focusNode;

class _ChatInputHarness extends StatefulWidget {
  const _ChatInputHarness({required this.onSend});

  final Future<void> Function() onSend;

  @override
  State<_ChatInputHarness> createState() => _ChatInputHarnessState();
}

class _ChatInputHarnessState extends State<_ChatInputHarness> {
  final _controller = TextEditingController();
  var _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() => _isLoading = true);
    await widget.onSend();
    _controller.clear();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return TextInputArea(
      textController: _controller,
      hasText: _controller.text.trim().isNotEmpty,
      isLoading: _isLoading,
      conversationType: 'synctv',
      onSendMessage: _send,
      onShowImagePicker: () {},
    );
  }
}
