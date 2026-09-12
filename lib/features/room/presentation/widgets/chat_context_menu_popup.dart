import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room/presentation/models/chat_context_menu_layout.dart';

class ChatContextMenuPopup extends StatelessWidget {
  const ChatContextMenuPopup({
    super.key,
    required this.anchor,
    required this.reactionCount,
    required this.actionCount,
    required this.child,
  });

  final Offset anchor;
  final int reactionCount;
  final int actionCount;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final safe = MediaQuery.viewPaddingOf(context);
    final keyboard = MediaQuery.viewInsetsOf(context);
    final insets = EdgeInsets.fromLTRB(
      math.max(safe.left, keyboard.left),
      math.max(safe.top, keyboard.top),
      math.max(safe.right, keyboard.right),
      math.max(safe.bottom, keyboard.bottom),
    );
    return Padding(
      padding: insets,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final layout = calculateChatContextMenuLayout(
            viewportWidth: constraints.maxWidth,
            viewportHeight: constraints.maxHeight,
            anchorX: anchor.dx - insets.left,
            anchorY: anchor.dy - insets.top,
            reactionCount: reactionCount,
            actionCount: actionCount,
          );
          return Stack(
            children: [
              Positioned(
                left: layout.left,
                top: layout.top,
                width: layout.width,
                child: Material(
                  color: Colors.transparent,
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  clipBehavior: Clip.antiAlias,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: layout.height),
                    child: AppSingleChildScrollView(child: child),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
