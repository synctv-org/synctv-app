import 'package:flutter/widgets.dart';

class ChatMessageHoverLayout extends StatelessWidget {
  const ChatMessageHoverLayout({
    super.key,
    required this.message,
    required this.alignEnd,
    this.actions,
    this.spacing = 6,
  });

  final Widget message;
  final Widget? actions;
  final bool alignEnd;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: alignEnd ? WrapAlignment.end : WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.start,
      spacing: spacing,
      runSpacing: spacing,
      children: [message, ?actions],
    );
  }
}
