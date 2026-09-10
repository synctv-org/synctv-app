import 'package:flutter/widgets.dart';

/// Preserves tail alignment across responsive reparenting and attachment layout.
class ChatScrollController extends ScrollController {
  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) => _ChatScrollPosition(
    physics: physics,
    context: context,
    oldPosition: oldPosition,
    initialPixels: initialScrollOffset,
    keepScrollOffset: keepScrollOffset,
    restoreTail: oldPosition != null && _atTail(oldPosition),
  );
}

bool _atTail(ScrollPosition position) =>
    position.hasPixels &&
    position.hasContentDimensions &&
    !position.isScrollingNotifier.value &&
    position.maxScrollExtent > position.minScrollExtent &&
    (position.maxScrollExtent - position.pixels).abs() < 1;

class _ChatScrollPosition extends ScrollPositionWithSingleContext {
  _ChatScrollPosition({
    required super.physics,
    required super.context,
    required super.oldPosition,
    required super.initialPixels,
    required super.keepScrollOffset,
    required this.restoreTail,
  });

  bool restoreTail;

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    final followTail = restoreTail || _atTail(this);
    restoreTail = false;
    if (followTail && hasPixels && pixels != maxScrollExtent) {
      correctPixels(maxScrollExtent);
    }
    return super.applyContentDimensions(minScrollExtent, maxScrollExtent);
  }
}
