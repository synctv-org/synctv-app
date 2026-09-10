import 'package:flutter/material.dart';

class ChatDetailDialogController {
  final _dialogs =
      <({String messageId, String userId, DialogRoute<void> route})>{};
  bool _disposed = false;

  Future<void> show({
    required BuildContext context,
    required String messageId,
    required String userId,
    required WidgetBuilder builder,
  }) async {
    if (_disposed || !context.mounted) return;
    final navigator = Navigator.of(context, rootNavigator: true);
    final route = DialogRoute<void>(
      context: context,
      builder: builder,
      themes: InheritedTheme.capture(from: context, to: navigator.context),
      barrierColor: Colors.black.withValues(alpha: 0.55),
    );
    final dialog = (messageId: messageId, userId: userId, route: route);
    _dialogs.add(dialog);
    try {
      await navigator.push<void>(route);
    } finally {
      _dialogs.remove(dialog);
    }
  }

  void dismissWhere(bool Function(String messageId, String userId) matches) {
    final removed = _dialogs
        .where((dialog) => matches(dialog.messageId, dialog.userId))
        .toList();
    _dialogs.removeAll(removed);
    if (removed.isEmpty) return;
    // Parent disposal can occur while Navigator is locked during a transition.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final dialog in removed) {
        final navigator = dialog.route.navigator;
        if (navigator != null && navigator.mounted && dialog.route.isActive) {
          navigator.removeRoute(dialog.route);
        }
      }
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  void dismissAll() => dismissWhere((_, _) => true);

  void dispose() {
    _disposed = true;
    dismissAll();
  }
}
