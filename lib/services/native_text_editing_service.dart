import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class NativeTextEditingService {
  NativeTextEditingService._();

  static const MethodChannel _channel =
      MethodChannel('synctv_app/text_editing');

  static void initialize() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'paste':
          return _pasteIntoFocusedEditable();
      }
      return false;
    });
  }

  static Future<bool> _pasteIntoFocusedEditable() async {
    final focusContext = FocusManager.instance.primaryFocus?.context;
    final editable = focusContext?.findAncestorStateOfType<EditableTextState>();
    if (editable == null) {
      return false;
    }

    await editable.pasteText(SelectionChangedCause.keyboard);
    return true;
  }
}
