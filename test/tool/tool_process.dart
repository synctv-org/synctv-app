import 'dart:io';

/// Runs a repo tool script via `dart run` with the same Dart SDK that is
/// running the tests.
///
/// Resolving `dart` from PATH can pick a different SDK than the one that owns
/// `.dart_tool`: a native-assets hook cache compiled by another SDK then fails
/// with "Invalid kernel binary format version", and an older SDK cannot load
/// the resolved dependencies at all ("language version ... too high"). Pin the
/// executable to the running SDK and heal a stale hook cache once — the hooks
/// runner cache is not keyed by SDK version.
Future<ProcessResult> runToolDart(List<String> arguments) async {
  final executable = _sdkDart();
  final result = await Process.run(executable, ['run', ...arguments]);
  if (result.exitCode == 0 || !_isStaleHookCache(result.stderr.toString())) {
    return result;
  }
  final hooksCache = Directory('.dart_tool/hooks_runner');
  if (hooksCache.existsSync()) {
    hooksCache.deleteSync(recursive: true);
  }
  return Process.run(executable, ['run', ...arguments]);
}

String _sdkDart() {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot != null && flutterRoot.isNotEmpty) {
    const executableNames = ['dart', 'dart.exe'];
    for (final name in executableNames) {
      final candidate = File('$flutterRoot/bin/cache/dart-sdk/bin/$name');
      if (candidate.existsSync()) return candidate.path;
    }
  }
  // Plain `dart test` runs already resolve the right SDK from PATH.
  return 'dart';
}

bool _isStaleHookCache(String output) =>
    output.contains('Invalid kernel binary format version') ||
    output.contains('Running build hooks failed');
