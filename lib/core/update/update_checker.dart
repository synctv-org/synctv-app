/// Update-check orchestration: compare, throttle, remember dismissals.
library;

import 'package:shared_preferences/shared_preferences.dart';

import 'github_release.dart';
import 'update_source.dart';
import 'update_version.dart';

/// Outcome of one check.
sealed class UpdateCheckResult {
  const UpdateCheckResult();
}

/// No release newer than the running version.
class UpdateCheckUpToDate extends UpdateCheckResult {
  const UpdateCheckUpToDate();
}

/// A newer release exists.
class UpdateCheckAvailable extends UpdateCheckResult {
  const UpdateCheckAvailable(this.release);

  final GitHubLatestRelease release;
}

/// The check itself failed (network, rate limit, malformed payload).
class UpdateCheckFailed extends UpdateCheckResult {
  const UpdateCheckFailed(this.error);

  final GitHubReleaseException error;
}

/// Runs checks against an [UpdateCheckSource] and owns the persistence
/// side of the feature: the auto-check throttle window and the tag the
/// user dismissed (so a declined release does not nag on every launch).
class UpdateChecker {
  UpdateChecker({
    required this.source,
    required this.currentVersion,
    required this.fetch,
    required this.preferences,
    this.autoCheckInterval = const Duration(hours: 24),
    int Function()? nowMillis,
  }) : _nowMillis = nowMillis ?? (() => DateTime.now().millisecondsSinceEpoch);

  /// Where releases are published; null disables every entry point.
  static UpdateCheckSource? get configuredSource =>
      UpdateCheckSource.configured;

  /// Whether update-check UI should be visible at all.
  static bool get enabled => configuredSource != null;

  final UpdateCheckSource source;
  final String currentVersion;
  final Future<GitHubLatestRelease> Function(UpdateCheckSource source) fetch;
  final SharedPreferences preferences;
  final Duration autoCheckInterval;
  final int Function() _nowMillis;

  static const _lastAutoCheckKey = 'update.lastAutoCheckEpochMs';
  static const _dismissedTagKey = 'update.dismissedTag';

  /// One check; never throws.
  Future<UpdateCheckResult> check() async {
    try {
      final release = await fetch(source);
      if (isUpdateNewer(
        currentVersion: currentVersion,
        candidateTag: release.tagName,
      )) {
        return UpdateCheckAvailable(release);
      }
      return const UpdateCheckUpToDate();
    } on GitHubReleaseException catch (error) {
      return UpdateCheckFailed(error);
    }
  }

  /// Auto-check gate: runs at most once per [autoCheckInterval], recording
  /// the attempt even on failure so a broken network or an exhausted rate
  /// limit does not retry on every launch.
  bool shouldAutoCheck() {
    final last = preferences.getInt(_lastAutoCheckKey) ?? 0;
    return _nowMillis() - last >= autoCheckInterval.inMilliseconds;
  }

  void recordAutoCheck() => preferences.setInt(_lastAutoCheckKey, _nowMillis());

  /// Whether the user already declined this release's dialog.
  bool isDismissed(GitHubLatestRelease release) =>
      preferences.getString(_dismissedTagKey) == release.tagName;

  /// Remembers the declined release so auto-checks stay quiet for it.
  void dismiss(GitHubLatestRelease release) =>
      preferences.setString(_dismissedTagKey, release.tagName);

  /// Auto-check flow for app start: silent, throttled, and only surfaces a
  /// release the user has not already declined.
  Future<UpdateCheckAvailable?> maybeAutoCheck() async {
    if (!shouldAutoCheck()) return null;
    recordAutoCheck();
    final result = await check();
    return switch (result) {
      UpdateCheckAvailable(:final release) when !isDismissed(release) =>
        UpdateCheckAvailable(release),
      _ => null,
    };
  }
}
