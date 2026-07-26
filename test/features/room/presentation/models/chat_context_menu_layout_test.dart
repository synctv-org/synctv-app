import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/presentation/models/chat_context_menu_layout.dart';

void main() {
  test('uses the content width on a wide viewport', () {
    final layout = calculateChatContextMenuLayout(
      viewportWidth: 1000,
      viewportHeight: 800,
      anchorX: 200,
      anchorY: 200,
      reactionCount: 6,
      actionCount: 5,
    );

    expect(layout.width, 199);
    expect(layout.height, 83);
  });

  test('fits the menu inside a narrow viewport and accounts for wrapping', () {
    final layout = calculateChatContextMenuLayout(
      viewportWidth: 150,
      viewportHeight: 800,
      anchorX: 20,
      anchorY: 200,
      reactionCount: 6,
      actionCount: 5,
    );

    expect(layout.width, 126);
    expect(layout.height, 145);
    expect(layout.left, 12);
  });

  test('moves the menu left and up near viewport edges', () {
    final layout = calculateChatContextMenuLayout(
      viewportWidth: 320,
      viewportHeight: 180,
      anchorX: 315,
      anchorY: 175,
      reactionCount: 6,
      actionCount: 5,
    );

    expect(layout.left + layout.width, 308);
    expect(layout.top + layout.height, 168);
  });

  test('includes additional rows required by more actions', () {
    final regular = calculateChatContextMenuLayout(
      viewportWidth: 110,
      viewportHeight: 800,
      anchorX: 20,
      anchorY: 200,
      reactionCount: 6,
      actionCount: 4,
    );
    final managed = calculateChatContextMenuLayout(
      viewportWidth: 110,
      viewportHeight: 800,
      anchorX: 20,
      anchorY: 200,
      reactionCount: 6,
      actionCount: 5,
    );

    expect(managed.height, regular.height + 31);
  });
}
