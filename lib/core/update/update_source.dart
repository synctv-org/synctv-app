/// Where update checks look for releases.
///
/// Non-store builds inject the building repository at CI time via
/// `--dart-define=SYNCTV_UPDATE_CHECK_SOURCE=owner/name` (GitHub Releases
/// host the direct-download artifacts). Store builds (Google Play, App
/// Store) and web builds leave it unset, which disables the feature
/// entirely: stores own update delivery, and the browser cannot install
/// downloads.
library;

import 'package:flutter/foundation.dart';

/// `owner/name` of the GitHub repository whose releases distribute this
/// build; empty when update checks are unavailable.
class UpdateCheckSource {
  const UpdateCheckSource._(this.owner, this.name);

  /// Injected at CI build time; empty disables update checks.
  static const String configuredValue = String.fromEnvironment(
    'SYNCTV_UPDATE_CHECK_SOURCE',
  );

  static final UpdateCheckSource? _configured = parse(configuredValue);

  /// The source injected at build time, or `null` when unset/invalid.
  ///
  /// Web builds never check for updates: the browser owns delivery and
  /// cannot install downloads anyway.
  static UpdateCheckSource? get configured => kIsWeb ? null : _configured;

  final String owner;
  final String name;

  /// `owner/name`, the form used in GitHub API paths.
  String get slug => '$owner/$name';

  /// The release page users are sent to, also the API endpoint base.
  String get releasesUrl => 'https://github.com/$slug/releases/latest';

  @override
  bool operator ==(Object other) =>
      other is UpdateCheckSource && other.slug == slug;

  @override
  int get hashCode => slug.hashCode;

  @override
  String toString() => slug;

  /// Accepts `owner/name` with GitHub-allowed characters; rejects anything
  /// else so a malformed injection cannot produce broken API URLs.
  static UpdateCheckSource? parse(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    final parts = trimmed.split('/');
    if (parts.length != 2) return null;
    final owner = parts[0];
    final name = parts[1];
    if (!_validSegment(owner) || !_validSegment(name)) return null;
    return UpdateCheckSource._(owner, name);
  }

  // GitHub names allow alphanumerics and hyphens; owners additionally allow
  // a single dot for organizations. Kept permissive-but-bounded to avoid
  // path tricks (`..`, slashes) reaching the API URL.
  static bool _validSegment(String segment) {
    if (segment.isEmpty || segment.length > 100) return false;
    var sawDot = false;
    for (final code in segment.codeUnits) {
      final isAlnum =
          (code >= 0x30 && code <= 0x39) ||
          (code >= 0x41 && code <= 0x5a) ||
          (code >= 0x61 && code <= 0x7a);
      final isHyphen = code == 0x2d;
      final isDot = code == 0x2e;
      if (!isAlnum && !isHyphen && !isDot) return false;
      if (isDot) sawDot = true;
    }
    if (sawDot && segment.contains('..')) return false;
    return true;
  }
}
