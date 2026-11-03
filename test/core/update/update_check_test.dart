@TestOn('vm')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synctv_app/core/update/github_release.dart';
import 'package:synctv_app/core/update/update_checker.dart';
import 'package:synctv_app/core/update/update_source.dart';
import 'package:synctv_app/core/update/update_version.dart';

void main() {
  group('UpdateVersion.parse', () {
    test('parses v-prefixed and bare tags', () {
      expect(UpdateVersion.parse('v1.2.3')!.toString(), '1.2.3');
      expect(UpdateVersion.parse('1.2.3')!.toString(), '1.2.3');
    });

    test('strips build metadata and lowercases prerelease', () {
      final version = UpdateVersion.parse('v1.2.3-RC.1+27')!;
      expect(version.toString(), '1.2.3-rc.1');
    });

    test('rejects malformed tags', () {
      for (final bad in ['', 'v', 'v1.2', '1.2.3.4', 'v1.a.3', 'vx.y.z']) {
        expect(UpdateVersion.parse(bad), isNull, reason: bad);
      }
    });
  });

  group('isUpdateNewer', () {
    test('newer patch/major/minor is newer', () {
      expect(
        isUpdateNewer(currentVersion: '1.2.3', candidateTag: 'v1.2.4'),
        isTrue,
      );
      expect(
        isUpdateNewer(currentVersion: '1.2.3', candidateTag: 'v1.3.0'),
        isTrue,
      );
      expect(
        isUpdateNewer(currentVersion: '1.2.3', candidateTag: 'v2.0.0'),
        isTrue,
      );
    });

    test('same or older is not newer', () {
      expect(
        isUpdateNewer(currentVersion: '1.2.3', candidateTag: 'v1.2.3'),
        isFalse,
      );
      expect(
        isUpdateNewer(currentVersion: '1.2.3', candidateTag: 'v1.2.2'),
        isFalse,
      );
      expect(
        isUpdateNewer(currentVersion: '1.2.3+27', candidateTag: 'v1.2.3'),
        isFalse,
      );
    });

    test('prerelease ranks below its release', () {
      expect(
        isUpdateNewer(currentVersion: '1.2.3-rc.1', candidateTag: 'v1.2.3'),
        isTrue,
      );
      expect(
        isUpdateNewer(currentVersion: '1.2.3', candidateTag: 'v1.2.3-rc.1'),
        isFalse,
      );
      expect(
        isUpdateNewer(
          currentVersion: '1.2.3-rc.1',
          candidateTag: 'v1.2.3-rc.2',
        ),
        isTrue,
      );
    });

    test('fails closed on malformed input', () {
      expect(
        isUpdateNewer(currentVersion: 'oops', candidateTag: 'v9.9.9'),
        isFalse,
      );
      expect(
        isUpdateNewer(currentVersion: '1.2.3', candidateTag: 'latest'),
        isFalse,
      );
    });
  });

  group('UpdateCheckSource.parse', () {
    test('accepts owner/name', () {
      final source = UpdateCheckSource.parse('synctv-org/synctv-app')!;
      expect(source.slug, 'synctv-org/synctv-app');
      expect(
        source.releasesUrl,
        'https://github.com/synctv-org/synctv-app/releases/latest',
      );
    });

    test('accepts organization dots and rejects path tricks', () {
      expect(UpdateCheckSource.parse('a.b-c/d-e'), isNotNull);
      expect(UpdateCheckSource.parse('..'), isNull);
      expect(UpdateCheckSource.parse('a/b/c'), isNull);
      expect(UpdateCheckSource.parse('a/'), isNull);
      expect(UpdateCheckSource.parse('owner/name?x=1'), isNull);
      expect(UpdateCheckSource.parse('  '), isNull);
      expect(UpdateCheckSource.parse(''), isNull);
    });
  });

  group('GitHubLatestRelease.fromJson', () {
    test('maps the GitHub release payload', () {
      final release = GitHubLatestRelease.fromJson({
        'tag_name': ' v1.2.3 ',
        'html_url': 'https://github.com/o/r/releases/tag/v1.2.3',
        'name': 'Release 1.2.3',
        'body': '# Notes',
      });
      expect(release.tagName, 'v1.2.3');
      expect(release.name, 'Release 1.2.3');
      expect(release.body, '# Notes');
    });

    test('tolerates missing fields', () {
      final release = GitHubLatestRelease.fromJson({});
      expect(release.tagName, '');
      expect(release.body, '');
    });
  });

  group('fetchLatestRelease', () {
    final source = UpdateCheckSource.parse('owner/repo')!;

    test('parses a 200 release', () async {
      final client = MockClient((request) async {
        expect(request.url.path, '/repos/owner/repo/releases/latest');
        expect(request.headers['User-Agent'], isNotEmpty);
        return http.Response(
          '{"tag_name":"v2.0.0","html_url":"https://github.com/owner/repo/releases/latest","name":"v2.0.0","body":"notes"}',
          200,
        );
      });
      final release = await fetchLatestRelease(source, client);
      expect(release.tagName, 'v2.0.0');
    });

    test('marks 403 as rate limited', () async {
      final client = MockClient((request) async => http.Response('{}', 403));
      await expectLater(
        fetchLatestRelease(source, client),
        throwsA(
          isA<GitHubReleaseException>().having(
            (e) => e.rateLimited,
            'rateLimited',
            isTrue,
          ),
        ),
      );
    });

    test('maps 404 to no-release', () async {
      final client = MockClient((request) async => http.Response('{}', 404));
      await expectLater(
        fetchLatestRelease(source, client),
        throwsA(
          isA<GitHubReleaseException>().having(
            (e) => e.message,
            'message',
            contains('no published release'),
          ),
        ),
      );
    });

    test('rejects malformed payloads', () async {
      final client = MockClient((request) async => http.Response('[]', 200));
      await expectLater(
        fetchLatestRelease(source, client),
        throwsA(isA<GitHubReleaseException>()),
      );
    });
  });

  group('UpdateChecker', () {
    late SharedPreferences preferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      preferences = await SharedPreferences.getInstance();
    });

    UpdateChecker build({
      required String currentVersion,
      required Object Function(UpdateCheckSource) fetch,
      int Function()? nowMillis,
      Duration interval = const Duration(hours: 24),
    }) {
      return UpdateChecker(
        source: UpdateCheckSource.parse('owner/repo')!,
        currentVersion: currentVersion,
        fetch: (source) async {
          final result = fetch(source);
          if (result is GitHubLatestRelease) return result;
          throw result as GitHubReleaseException;
        },
        preferences: preferences,
        autoCheckInterval: interval,
        nowMillis: nowMillis,
      );
    }

    GitHubLatestRelease release(String tag) => GitHubLatestRelease(
      tagName: tag,
      htmlUrl: 'https://github.com/owner/repo/releases/latest',
      name: tag,
      body: 'notes',
    );

    test('check reports a newer release', () async {
      final checker = build(
        currentVersion: '1.0.0',
        fetch: (_) => release('v1.1.0'),
      );
      final result = await checker.check();
      expect(
        result,
        isA<UpdateCheckAvailable>().having(
          (r) => r.release.tagName,
          'tag',
          'v1.1.0',
        ),
      );
    });

    test('check reports up to date on same version', () async {
      final checker = build(
        currentVersion: '1.1.0',
        fetch: (_) => release('v1.1.0'),
      );
      expect(await checker.check(), isA<UpdateCheckUpToDate>());
    });

    test('check maps fetch failures quietly', () async {
      final checker = build(
        currentVersion: '1.0.0',
        fetch: (_) => const GitHubReleaseException('boom'),
      );
      expect(await checker.check(), isA<UpdateCheckFailed>());
    });

    test('auto check throttles to once per interval', () async {
      // Far enough past the epoch that a fresh install reads as "never
      // checked" instead of "checked moments ago".
      var now = 10 * 24 * 60 * 60 * 1000;
      final checker = build(
        currentVersion: '1.0.0',
        fetch: (_) => release('v1.1.0'),
        nowMillis: () => now,
      );
      expect(checker.shouldAutoCheck(), isTrue);
      checker.recordAutoCheck();
      now += const Duration(hours: 23).inMilliseconds;
      expect(checker.shouldAutoCheck(), isFalse);
      now += const Duration(hours: 2).inMilliseconds;
      expect(checker.shouldAutoCheck(), isTrue);
    });

    test('dismissed releases stay quiet in auto checks', () async {
      final checker = build(
        currentVersion: '1.0.0',
        fetch: (_) => release('v1.1.0'),
      );
      final first = await checker.maybeAutoCheck();
      expect(first, isNotNull);

      checker.dismiss(first!.release);
      expect(checker.isDismissed(first.release), isTrue);

      // Force the next throttle window; the same release must not resurface.
      checker.recordAutoCheck();
      final again = await checker.maybeAutoCheck();
      expect(again, isNull);
    });

    test('auto check records the attempt even when it fails', () async {
      var calls = 0;
      final checker = build(
        currentVersion: '1.0.0',
        fetch: (_) {
          calls++;
          return const GitHubReleaseException('offline');
        },
      );
      expect(await checker.maybeAutoCheck(), isNull);
      expect(await checker.maybeAutoCheck(), isNull);
      expect(calls, 1, reason: 'throttled after the failed first attempt');
    });
  });
}
