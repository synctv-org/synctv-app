import 'dart:io';

final _projectRoot = Directory.current;

final _excludedPathSegments = <String>{
  '${Platform.pathSeparator}.dart_tool${Platform.pathSeparator}',
  '${Platform.pathSeparator}build${Platform.pathSeparator}',
  '${Platform.pathSeparator}lib${Platform.pathSeparator}src${Platform.pathSeparator}generated${Platform.pathSeparator}',
  '${Platform.pathSeparator}packages${Platform.pathSeparator}',
};

final _excludedFiles = <String>{
  _normalize('lib/core/presentation/widgets/app_form_controls.dart'),
  _normalize('lib/features/room/presentation/widgets/custom_video_player.dart'),
};

final _guardedPatterns = <_GuardedPattern>[
  _GuardedPattern('TextField', RegExp(r'\bTextField\s*\(')),
  _GuardedPattern('TextFormField', RegExp(r'\bTextFormField\s*\(')),
  _GuardedPattern('SelectableText', RegExp(r'\bSelectableText\s*\(')),
  _GuardedPattern('ClipRRect', RegExp(r'\bClipRRect\s*\(')),
  _GuardedPattern('Image.asset', RegExp(r'\bImage\.asset\s*\(')),
  _GuardedPattern('Image.memory', RegExp(r'\bImage\.memory\s*\(')),
  _GuardedPattern('Image.file', RegExp(r'\bImage\.file\s*\(')),
  _GuardedPattern('Image.network', RegExp(r'\bImage\.network\s*\(')),
  _GuardedPattern('ElevatedButton', RegExp(r'\bElevatedButton\s*\(')),
  _GuardedPattern('TextButton', RegExp(r'\bTextButton\s*\(')),
  _GuardedPattern('OutlinedButton', RegExp(r'\bOutlinedButton\s*\(')),
  _GuardedPattern('IconButton', RegExp(r'\bIconButton\s*\(')),
  _GuardedPattern(
    'FloatingActionButton',
    RegExp(r'\bFloatingActionButton\s*\('),
  ),
  _GuardedPattern(
    'DropdownButton',
    RegExp(r'\bDropdownButton(?:HideUnderline)?\s*\('),
  ),
  _GuardedPattern('PopupMenuButton', RegExp(r'\bPopupMenuButton\s*\(')),
  _GuardedPattern('Checkbox', RegExp(r'\bCheckbox\s*\(')),
  _GuardedPattern('Switch', RegExp(r'\bSwitch\s*\(')),
  _GuardedPattern('Slider', RegExp(r'\bSlider\s*\(')),
  _GuardedPattern('AlertDialog', RegExp(r'\bAlertDialog\s*\(')),
  _GuardedPattern('SimpleDialog', RegExp(r'\bSimpleDialog\s*\(')),
  _GuardedPattern('showDialog', RegExp(r'\bshowDialog\s*<')),
  _GuardedPattern('showDialog', RegExp(r'\bshowDialog\s*\(')),
  _GuardedPattern(
    'showModalBottomSheet',
    RegExp(r'\bshowModalBottomSheet\s*<'),
  ),
  _GuardedPattern(
    'showModalBottomSheet',
    RegExp(r'\bshowModalBottomSheet\s*\('),
  ),
  _GuardedPattern(
    'ListView',
    RegExp(r'\bListView(?:\.(?:builder|separated|custom))?\s*\('),
  ),
  _GuardedPattern(
    'GridView',
    RegExp(r'\bGridView(?:\.(?:builder|count|custom|extent))?\s*\('),
  ),
  _GuardedPattern(
    'SingleChildScrollView',
    RegExp(r'\bSingleChildScrollView\s*\('),
  ),
  _GuardedPattern(
    'CircularProgressIndicator',
    RegExp(r'\bCircularProgressIndicator\s*\('),
  ),
  _GuardedPattern(
    'LinearProgressIndicator',
    RegExp(r'\bLinearProgressIndicator\s*\('),
  ),
  _GuardedPattern('Divider', RegExp(r'\bDivider\s*\(')),
  _GuardedPattern('VerticalDivider', RegExp(r'\bVerticalDivider\s*\(')),
];

int checkUiGuard([List<String> args = const <String>[]]) {
  final roots = args.isEmpty ? ['lib'] : args;
  final violations = <_Violation>[];

  for (final root in roots) {
    final entity = Directory(root);
    if (!entity.existsSync()) {
      stderr.writeln('UI guard: 路径不存在: $root');
      return 2;
    }
    for (final file
        in entity
            .listSync(recursive: true, followLinks: false)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))
            .where(_shouldScan)) {
      violations.addAll(_scanFile(file));
    }
  }

  if (violations.isEmpty) {
    stdout.writeln('UI guard passed.');
    return 0;
  }

  stderr.writeln(
    'UI guard found ${violations.length} direct UI primitive use(s):',
  );
  for (final violation in violations) {
    stderr.writeln(
      '${violation.path}:${violation.line}: ${violation.patternName}: ${violation.source.trim()}',
    );
  }
  stderr.writeln(
    'Use core presentation controls or add a narrowly scoped exclusion for a domain-specific widget.',
  );
  return 1;
}

void main(List<String> args) {
  exitCode = checkUiGuard(args);
}

List<_Violation> _scanFile(File file) {
  final path = _normalize(file.path);
  final violations = <_Violation>[];
  final lines = file.readAsLinesSync();
  var inBlockComment = false;

  for (var index = 0; index < lines.length; index++) {
    final stripped = _stripCommentsAndStrings(lines[index], inBlockComment);
    inBlockComment = stripped.inBlockComment;
    if (stripped.source.trim().isEmpty) continue;

    for (final pattern in _guardedPatterns) {
      if (pattern.regex.hasMatch(stripped.source)) {
        violations.add(
          _Violation(
            path: path,
            line: index + 1,
            patternName: pattern.name,
            source: lines[index],
          ),
        );
      }
    }
  }
  return violations;
}

_StrippedLine _stripCommentsAndStrings(String line, bool inBlockComment) {
  final buffer = StringBuffer();
  var index = 0;
  var inSingle = false;
  var inDouble = false;

  while (index < line.length) {
    final char = line[index];
    final next = index + 1 < line.length ? line[index + 1] : '';

    if (inBlockComment) {
      if (char == '*' && next == '/') {
        inBlockComment = false;
        index += 2;
      } else {
        index++;
      }
      continue;
    }

    if (inSingle) {
      if (char == r'\') {
        index += 2;
      } else if (char == "'") {
        inSingle = false;
        index++;
      } else {
        index++;
      }
      buffer.write(' ');
      continue;
    }

    if (inDouble) {
      if (char == r'\') {
        index += 2;
      } else if (char == '"') {
        inDouble = false;
        index++;
      } else {
        index++;
      }
      buffer.write(' ');
      continue;
    }

    if (char == '/' && next == '/') break;
    if (char == '/' && next == '*') {
      inBlockComment = true;
      index += 2;
      continue;
    }
    if (char == "'") {
      inSingle = true;
      buffer.write(' ');
      index++;
      continue;
    }
    if (char == '"') {
      inDouble = true;
      buffer.write(' ');
      index++;
      continue;
    }

    buffer.write(char);
    index++;
  }

  return _StrippedLine(buffer.toString(), inBlockComment);
}

bool _shouldScan(File file) {
  final path = _normalize(file.path);
  if (_excludedFiles.contains(path)) return false;
  return !_excludedPathSegments.any(path.contains);
}

String _normalize(String path) {
  final absolute = File(path).absolute.path;
  final root = _projectRoot.absolute.path;
  if (absolute.startsWith(root)) {
    return absolute.substring(root.length + 1);
  }
  return path;
}

class _GuardedPattern {
  final String name;
  final RegExp regex;

  const _GuardedPattern(this.name, this.regex);
}

class _Violation {
  final String path;
  final int line;
  final String patternName;
  final String source;

  const _Violation({
    required this.path,
    required this.line,
    required this.patternName,
    required this.source,
  });
}

class _StrippedLine {
  final String source;
  final bool inBlockComment;

  const _StrippedLine(this.source, this.inBlockComment);
}
