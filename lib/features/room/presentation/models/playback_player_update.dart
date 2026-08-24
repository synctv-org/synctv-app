import 'package:synctv_app/contracts/synctv_models.dart';

enum PlaybackPlayerUpdateAction { dispose, drain, keep, initialize, reload }

bool playbackSyncCorrectionRequired({
  required bool isLive,
  required bool targetIsPlaying,
  required bool playerIsPlaying,
  required bool positionRequiresCorrection,
}) {
  return targetIsPlaying != playerIsPlaying ||
      (!isLive && positionRequiresCorrection);
}

bool activePlaybackSourceCanContinue({
  required int? expireAt,
  required DateTime now,
}) {
  if (expireAt == null || expireAt <= 0) return false;
  final expiresAt = DateTime.fromMillisecondsSinceEpoch(
    expireAt * 1000,
    isUtc: true,
  );
  return expiresAt.isAfter(now.toUtc());
}

bool liveStreamGenerationChanged(
  RoomMediaEntry? previous,
  RoomMediaEntry? next,
) {
  return next?.live == true &&
      next!.isLiveStreamPlayable &&
      previous?.liveStreamGenerationId != next.liveStreamGenerationId;
}

bool managedLiveStreamEnded(RoomMediaEntry? previous, RoomMediaEntry? next) {
  return previous != null &&
      next != null &&
      previous.hasSamePlaybackIdentity(next) &&
      previous.live &&
      next.live &&
      previous.liveStreamAvailability == SyncTvLiveStreamAvailability.live &&
      previous.liveStreamGenerationId.isNotEmpty &&
      next.liveStreamAvailability == SyncTvLiveStreamAvailability.offline;
}

bool shouldRetainActivePlaybackSource({
  required RoomMediaEntry? previous,
  required RoomMediaEntry? next,
  required bool authoritativeSourceChanged,
  required bool activeSourceCanContinue,
}) {
  return !authoritativeSourceChanged &&
      activeSourceCanContinue &&
      previous != null &&
      next != null &&
      previous.playbackAttachmentIdentity == next.playbackAttachmentIdentity;
}

PlaybackPlayerUpdateAction playbackPlayerUpdateAction({
  required RoomMediaEntry? previous,
  required RoomMediaEntry? next,
  required bool hasController,
  required bool controllerHasPlayed,
  required bool isDrainingEndedLiveStream,
  required bool samePlayerSource,
  bool forceReload = false,
}) {
  if (next == null || next.url.isEmpty || !next.isLiveStreamPlayable) {
    final canContinueDrain =
        hasController &&
        previous != null &&
        next != null &&
        previous.hasSamePlaybackIdentity(next) &&
        (isDrainingEndedLiveStream ||
            (controllerHasPlayed && managedLiveStreamEnded(previous, next)));
    if (canContinueDrain) return PlaybackPlayerUpdateAction.drain;
    return PlaybackPlayerUpdateAction.dispose;
  }
  if (!hasController) return PlaybackPlayerUpdateAction.initialize;
  if (forceReload || liveStreamGenerationChanged(previous, next)) {
    return PlaybackPlayerUpdateAction.reload;
  }
  return samePlayerSource
      ? PlaybackPlayerUpdateAction.keep
      : PlaybackPlayerUpdateAction.initialize;
}
