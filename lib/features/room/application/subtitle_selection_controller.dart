import 'package:flutter/foundation.dart';

/// Keeps an explicit subtitle choice for the current playback resource.
class SubtitleSelectionController extends ChangeNotifier {
  String? _resourceIdentity;
  String? _selectedKey;

  ({String? key, bool disabled})? selectionFor(String resourceIdentity) {
    if (_resourceIdentity != resourceIdentity) return null;
    return (key: _selectedKey, disabled: _selectedKey == null);
  }

  void select(String resourceIdentity, String? key) {
    _resourceIdentity = resourceIdentity;
    _selectedKey = key;
    notifyListeners();
  }
}
