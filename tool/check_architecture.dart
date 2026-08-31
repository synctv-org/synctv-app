import 'dart:io';

final _projectRoot = Directory.current.absolute;

const _generatedRoot = 'lib/src/generated/';
const _packagePrefix = 'package:synctv_app/';

int checkArchitecture([List<String> args = const <String>[]]) {
  final sourceRoot = Directory(args.isEmpty ? 'lib' : args.single);
  if (!sourceRoot.existsSync()) {
    stderr.writeln(
      'Architecture guard: path does not exist: ${sourceRoot.path}',
    );
    return 2;
  }

  final violations = <_Violation>[];
  for (final file
      in sourceRoot
          .listSync(recursive: true, followLinks: false)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
    final path = _relativePath(file.path);
    if (path.startsWith(_generatedRoot)) continue;
    violations.addAll(_checkFile(path, file.readAsLinesSync()));
  }

  for (final obsoleteRoot in [
    'lib/managers',
    'lib/models',
    'lib/pages',
    'lib/services',
    'lib/utils',
    'lib/widgets',
  ]) {
    if (Directory(obsoleteRoot).existsSync()) {
      violations.add(
        _Violation(
          path: obsoleteRoot,
          line: 1,
          reason: 'feature-owned code must live under lib/features or lib/core',
        ),
      );
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('Architecture guard passed.');
    return 0;
  }

  stderr.writeln(
    'Architecture guard found ${violations.length} dependency violation(s):',
  );
  for (final violation in violations) {
    stderr.writeln('${violation.path}:${violation.line}: ${violation.reason}');
  }
  return 1;
}

void main(List<String> args) {
  exitCode = checkArchitecture(args);
}

Iterable<_Violation> _checkFile(String path, List<String> lines) sync* {
  for (var index = 0; index < lines.length; index++) {
    final line = lines[index];
    if (RegExp(r'^lib/features/[^/]+/presentation/').hasMatch(path) &&
        line.contains('SyncTvService.')) {
      yield _Violation(
        path: path,
        line: index + 1,
        reason: 'presentation must use an application port',
      );
    }
    if (RegExp(r'^lib/features/[^/]+/presentation/').hasMatch(path) &&
        (line.contains("package:http/") ||
            line.contains("package:shared_preferences/") ||
            line.contains("package:path_provider/") ||
            line.contains("package:web_socket_channel/") ||
            line.contains("package:flutter_secure_storage/"))) {
      yield _Violation(
        path: path,
        line: index + 1,
        reason: 'presentation must access network and storage through a port',
      );
    }
    final importedPath = _packageImport(line);
    if (importedPath == null) continue;
    final reason = _invalidDependency(path, importedPath);
    if (reason != null) {
      yield _Violation(path: path, line: index + 1, reason: reason);
    }
  }
}

String? _packageImport(String line) {
  final match = RegExp(r'''^\s*import\s+['"]package:synctv_app/([^'"]+)['"]''')
      .firstMatch(line);
  return match?.group(1);
}

String? _invalidDependency(String source, String imported) {
  final presentation = RegExp(r'^lib/features/[^/]+/presentation/')
      .hasMatch(source);
  if (presentation && imported.startsWith('data/')) {
    return 'presentation cannot depend on the shared data plane: $imported';
  }
  if (presentation &&
      RegExp(r'^features/[^/]+/(data|infrastructure)/').hasMatch(imported)) {
    return 'presentation must use an application port: $imported';
  }
  if (presentation && imported.startsWith('app/')) {
    return 'presentation cannot depend on the composition root: $imported';
  }

  if (source.startsWith('lib/core/')) {
    if (_startsWithAny(imported, const [
      'features/',
      'data/',
      'managers/',
      'contracts/',
    ])) {
      return 'core cannot depend on $imported';
    }
  }

  if (source.startsWith('lib/contracts/')) {
    if (_startsWithAny(imported, const [
      'core/presentation/',
      'features/',
      'data/',
      'app/',
    ])) {
      return 'shared contracts cannot depend on $imported';
    }
  }

  if (source.startsWith('lib/data/synctv_api/')) {
    if (imported.startsWith('core/presentation/') ||
        imported.startsWith('app/') ||
        RegExp(r'^features/[^/]+/presentation/').hasMatch(imported)) {
      return 'the shared data plane cannot depend on $imported';
    }
  }

  final featureLayer = RegExp(
    r'^lib/features/([^/]+)/(domain|application|data|infrastructure)/',
  ).firstMatch(source);
  if (featureLayer != null) {
    final feature = featureLayer.group(1)!;
    final layer = featureLayer.group(2)!;
    final importedFeature = RegExp(r'^features/([^/]+)/(.+)$')
        .firstMatch(imported);
    if (importedFeature != null && importedFeature.group(1) != feature) {
      return '$feature $layer cannot depend on another feature: $imported';
    }
    if (importedFeature != null &&
        importedFeature.group(2)!.startsWith('presentation/')) {
      return '$feature $layer cannot depend on presentation: $imported';
    }
    final importedLayer = importedFeature?.group(2)!.split('/').first;
    if (layer == 'domain' &&
        const {
          'application',
          'data',
          'infrastructure',
        }.contains(importedLayer)) {
      return '$feature domain cannot depend on $importedLayer: $imported';
    }
    if (layer == 'application' &&
        const {'data', 'infrastructure'}.contains(importedLayer)) {
      return '$feature application cannot depend on $importedLayer: $imported';
    }
    if (layer == 'domain' &&
        _startsWithAny(imported, const [
          'core/presentation/',
          'data/',
          'managers/',
        ])) {
      return '$feature domain cannot depend on $imported';
    }
    if (layer == 'application' &&
        _startsWithAny(imported, const [
          'core/presentation/',
          'data/',
          'managers/',
        ])) {
      return '$feature application cannot depend on $imported';
    }
  }

  if (imported == 'features/admin/presentation/admin_settings_page.dart' &&
      source != 'lib/features/app_shell/presentation/app_shell.dart') {
    return 'admin settings may only be composed by the app shell';
  }

  return null;
}

bool _startsWithAny(String value, List<String> prefixes) {
  return prefixes.any(value.startsWith);
}

String _relativePath(String path) {
  final absolute = File(path).absolute.path;
  final root = _projectRoot.path;
  return absolute.startsWith('$root${Platform.pathSeparator}')
      ? absolute.substring(root.length + 1)
      : path;
}

class _Violation {
  const _Violation({
    required this.path,
    required this.line,
    required this.reason,
  });

  final String path;
  final int line;
  final String reason;
}
