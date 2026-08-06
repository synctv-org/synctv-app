const playbackResourceRefreshLeadTime = Duration(seconds: 60);
const playbackResourceRefreshMinimumDelay = Duration(seconds: 1);
const playbackResourceRefreshMaximumRetryDelay = Duration(seconds: 30);

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

int? earliestPlaybackResourceExpiration({
  required int? selectedMediaExpireAt,
  required int? playbackExpireAt,
}) {
  final expirations = [
    selectedMediaExpireAt,
    playbackExpireAt,
  ].whereType<int>().where((value) => value > 0);
  if (expirations.isEmpty) return null;
  return expirations.reduce((left, right) => left < right ? left : right);
}

Duration? playbackResourceRefreshDelay({
  required int? expireAt,
  required DateTime now,
  Duration leadTime = playbackResourceRefreshLeadTime,
  Duration minimumDelay = playbackResourceRefreshMinimumDelay,
}) {
  if (expireAt == null || expireAt <= 0) return null;
  final refreshAt = DateTime.fromMillisecondsSinceEpoch(
    expireAt * 1000,
    isUtc: true,
  ).subtract(leadTime);
  final delay = refreshAt.difference(now.toUtc());
  return delay > minimumDelay ? delay : minimumDelay;
}

Duration playbackResourceRefreshRetryDelay({
  required int attempt,
  required int expireAt,
  required DateTime now,
}) {
  if (attempt <= 1) return const Duration(seconds: 5);
  if (attempt == 2) return const Duration(seconds: 15);

  final hardExpiryDelay = DateTime.fromMillisecondsSinceEpoch(
    expireAt * 1000,
    isUtc: true,
  ).difference(now.toUtc());
  final beforeHardExpiry =
      hardExpiryDelay - playbackResourceRefreshMinimumDelay;
  if (beforeHardExpiry > playbackResourceRefreshMinimumDelay &&
      beforeHardExpiry < playbackResourceRefreshMaximumRetryDelay) {
    return beforeHardExpiry;
  }
  if (hardExpiryDelay > Duration.zero &&
      hardExpiryDelay <= playbackResourceRefreshMinimumDelay * 2) {
    return playbackResourceRefreshMinimumDelay;
  }
  return playbackResourceRefreshMaximumRetryDelay;
}
