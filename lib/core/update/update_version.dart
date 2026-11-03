/// Release-tag comparison for update checks.
///
/// Tags follow the release workflow's `vMAJOR.MINOR.PATCH` scheme with an
/// optional prerelease suffix. Comparison is semantic-version aware in the
/// plain ways that matter here: numeric component comparison, and a
/// prerelease ranks below its own release (`1.2.3-rc.1 < 1.2.3`).
library;

/// A parsed `v`-prefixed semantic version.
class UpdateVersion implements Comparable<UpdateVersion> {
  const UpdateVersion({
    required this.major,
    required this.minor,
    required this.patch,
    this.prerelease = '',
  });

  final int major;
  final int minor;
  final int patch;

  /// Lowercase prerelease suffix without the leading `-` (may be empty).
  final String prerelease;

  /// Parses `v1.2.3`, `1.2.3`, `v1.2.3-rc.1`; `null` for anything else.
  static UpdateVersion? parse(String raw) {
    var text = raw.trim();
    if (text.startsWith('v') || text.startsWith('V')) {
      text = text.substring(1);
    }
    if (text.isEmpty) return null;

    // Strip build metadata (`+27`); it never affects ordering.
    final withoutBuild = text.split('+').first;
    var core = withoutBuild;
    var prerelease = '';
    final dash = withoutBuild.indexOf('-');
    if (dash >= 0) {
      core = withoutBuild.substring(0, dash);
      prerelease = withoutBuild.substring(dash + 1).toLowerCase();
    }

    final parts = core.split('.');
    if (parts.length != 3) return null;
    final numbers = <int>[];
    for (final part in parts) {
      if (part.isEmpty) return null;
      final value = int.tryParse(part);
      if (value == null) return null;
      numbers.add(value);
    }
    return UpdateVersion(
      major: numbers[0],
      minor: numbers[1],
      patch: numbers[2],
      prerelease: prerelease,
    );
  }

  @override
  int compareTo(UpdateVersion other) {
    for (final (a, b) in [
      (major, other.major),
      (minor, other.minor),
      (patch, other.patch),
    ]) {
      if (a != b) return a.compareTo(b);
    }
    // Semver: a prerelease sorts before the release itself.
    if (prerelease.isEmpty && other.prerelease.isEmpty) return 0;
    if (prerelease.isEmpty) return 1;
    if (other.prerelease.isEmpty) return -1;
    return prerelease.compareTo(other.prerelease);
  }

  @override
  bool operator ==(Object other) =>
      other is UpdateVersion && compareTo(other) == 0;

  @override
  int get hashCode => Object.hash(major, minor, patch, prerelease);

  @override
  String toString() => prerelease.isEmpty
      ? '$major.$minor.$patch'
      : '$major.$minor.$patch-$prerelease';
}

/// Whether [candidateTag] from a release is newer than the running
/// [currentVersion]. Unparseable input is never newer: a malformed tag or
/// version fails closed into "up to date" instead of nagging.
bool isUpdateNewer({
  required String currentVersion,
  required String candidateTag,
}) {
  final current = UpdateVersion.parse(currentVersion);
  final candidate = UpdateVersion.parse(candidateTag);
  if (current == null || candidate == null) return false;
  return candidate.compareTo(current) > 0;
}
