import 'package:synctv_app/contracts/synctv_models.dart';

enum PlaylistEntryGestureIntent { activate, enterSelection, toggleSelection }

final class PlaylistSelectionPolicy {
  const PlaylistSelectionPolicy._();

  static bool isSelectable(RoomMediaEntry entry) => entry.id.trim().isNotEmpty;

  static bool canActivate({
    required RoomMediaEntry entry,
    required String viewerId,
    required bool canControlPlayback,
  }) {
    if (!entry.isAvailable) return false;
    return entry.isPlaylist
        ? entry.canBrowsePlaylistFor(viewerId)
        : canControlPlayback;
  }

  static PlaylistEntryGestureIntent? tapIntent({
    required RoomMediaEntry entry,
    required bool selectionMode,
    required bool canActivate,
  }) {
    if (selectionMode) {
      if (entry.isPlaylist && canActivate) {
        return PlaylistEntryGestureIntent.activate;
      }
      return isSelectable(entry)
          ? PlaylistEntryGestureIntent.toggleSelection
          : null;
    }
    return canActivate ? PlaylistEntryGestureIntent.activate : null;
  }

  static PlaylistEntryGestureIntent? longPressIntent({
    required RoomMediaEntry entry,
    required bool selectionMode,
    required bool canSelectEntries,
  }) {
    if (!canSelectEntries || !isSelectable(entry)) return null;
    return selectionMode
        ? PlaylistEntryGestureIntent.toggleSelection
        : PlaylistEntryGestureIntent.enterSelection;
  }
}
