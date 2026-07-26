import 'dart:math' as math;

const double chatContextMenuScreenMargin = 12;
const double chatContextMenuItemExtent = 28;
const double chatContextMenuItemSpacing = 3;
const double chatContextMenuHorizontalPadding = 8;
const double chatContextMenuVerticalPadding = 7;

class ChatContextMenuLayout {
  const ChatContextMenuLayout({
    required this.width,
    required this.height,
    required this.left,
    required this.top,
  });

  final double width;
  final double height;
  final double left;
  final double top;
}

ChatContextMenuLayout calculateChatContextMenuLayout({
  required double viewportWidth,
  required double viewportHeight,
  required double anchorX,
  required double anchorY,
  required int reactionCount,
  required int actionCount,
}) {
  final availableWidth = math.max(
    1.0,
    viewportWidth - chatContextMenuScreenMargin * 2,
  );
  final preferredReactionWidth = _rowWidth(reactionCount);
  final preferredActionWidth = _rowWidth(actionCount);
  final preferredWidth =
      math.max(preferredReactionWidth, preferredActionWidth) +
      chatContextMenuHorizontalPadding * 2;
  final width = math.min(preferredWidth, availableWidth);
  final contentWidth = math.max(
    1.0,
    width - chatContextMenuHorizontalPadding * 2,
  );
  final reactionRows = _rowCount(reactionCount, contentWidth);
  final actionRows = _rowCount(actionCount, contentWidth);
  final height =
      chatContextMenuVerticalPadding * 2 +
      _rowsHeight(reactionRows) +
      7 +
      1 +
      5 +
      _rowsHeight(actionRows);

  final maxLeft = math.max(
    chatContextMenuScreenMargin,
    viewportWidth - width - chatContextMenuScreenMargin,
  );
  final maxTop = math.max(
    chatContextMenuScreenMargin,
    viewportHeight - height - chatContextMenuScreenMargin,
  );

  return ChatContextMenuLayout(
    width: width,
    height: height,
    left: anchorX.clamp(chatContextMenuScreenMargin, maxLeft).toDouble(),
    top: (anchorY - 10).clamp(chatContextMenuScreenMargin, maxTop).toDouble(),
  );
}

double _rowWidth(int itemCount) {
  if (itemCount <= 0) return 0;
  return itemCount * chatContextMenuItemExtent +
      (itemCount - 1) * chatContextMenuItemSpacing;
}

int _rowCount(int itemCount, double availableWidth) {
  if (itemCount <= 0) return 0;
  final itemsPerRow = math.max(
    1,
    ((availableWidth + chatContextMenuItemSpacing) /
            (chatContextMenuItemExtent + chatContextMenuItemSpacing))
        .floor(),
  );
  return (itemCount + itemsPerRow - 1) ~/ itemsPerRow;
}

double _rowsHeight(int rowCount) {
  if (rowCount <= 0) return 0;
  return rowCount * chatContextMenuItemExtent +
      (rowCount - 1) * chatContextMenuItemSpacing;
}
