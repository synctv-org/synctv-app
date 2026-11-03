/// GitHub Releases client for update checks.
library;

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'update_source.dart';

/// The latest published (non-draft, non-prerelease) release.
class GitHubLatestRelease {
  const GitHubLatestRelease({
    required this.tagName,
    required this.htmlUrl,
    required this.name,
    required this.body,
  });

  /// Release tag, e.g. `v1.2.3`.
  final String tagName;

  /// Human-facing release page (browser destination for downloads).
  final String htmlUrl;

  /// Release title; may be empty.
  final String name;

  /// Release notes (markdown source); may be empty.
  final String body;

  factory GitHubLatestRelease.fromJson(Map<String, dynamic> json) =>
      GitHubLatestRelease(
        tagName: (json['tag_name'] as String? ?? '').trim(),
        htmlUrl: (json['html_url'] as String? ?? '').trim(),
        name: (json['name'] as String? ?? '').trim(),
        body: json['body'] as String? ?? '',
      );
}

/// Thrown when GitHub rejects or cannot serve the release lookup.
class GitHubReleaseException implements Exception {
  const GitHubReleaseException(this.message, {this.rateLimited = false});

  final String message;

  /// Set on 403/429: unauthenticated clients get ~60 requests/hour, and a
  /// shared-NAT deployment can exhaust that. Callers use it to keep the
  /// failure silent and report a targeted message.
  final bool rateLimited;

  @override
  String toString() => message;
}

/// Fetches `releases/latest` for [source].
///
/// The endpoint never returns drafts or prereleases, so no filtering is
/// needed client-side. Redirects are not followed: a moved repository is a
/// configuration problem that should surface, not be silently chased.
Future<GitHubLatestRelease> fetchLatestRelease(
  UpdateCheckSource source,
  http.Client client, {
  Duration timeout = const Duration(seconds: 15),
}) async {
  final uri = Uri.https(
    'api.github.com',
    '/repos/${source.owner}/${source.name}/releases/latest',
  );
  final http.Response response;
  try {
    response = await client
        .get(
          uri,
          headers: {
            'Accept': 'application/vnd.github+json',
            // GitHub rejects API requests without a User-Agent.
            'User-Agent': 'synctv-app-update-check',
          },
        )
        .timeout(timeout);
  } on Object catch (error) {
    throw GitHubReleaseException('update check request failed: $error');
  }
  switch (response.statusCode) {
    case 200:
      break;
    case 403:
    case 429:
      throw const GitHubReleaseException(
        'GitHub API rate limit reached',
        rateLimited: true,
      );
    case 404:
      throw const GitHubReleaseException('no published release found');
    default:
      throw GitHubReleaseException(
        'GitHub API returned ${response.statusCode}',
      );
  }
  try {
    final json =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return GitHubLatestRelease.fromJson(json);
  } on Object catch (error) {
    throw GitHubReleaseException('malformed release payload: $error');
  }
}
