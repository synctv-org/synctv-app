import 'dart:convert';
import 'dart:io';

import 'package:xml/xml.dart';

const _defaultSourcePath = 'assets/icon/logo-notext.svg';
const _defaultOutputPath = 'assets/icon/AppIcon.icon';
const _screenPathData = 'M218.321 188.894H461.13v120.255H218.321z';

void main(List<String> arguments) {
  if (arguments.length != 0 && arguments.length != 2) {
    stderr.writeln(
      'usage: dart run tool/generate_apple_icon_composer.dart '
      '[<source.svg> <output.icon>]',
    );
    exitCode = 64;
    return;
  }

  final source = File(arguments.isEmpty ? _defaultSourcePath : arguments.first);
  final output = Directory(
    arguments.isEmpty ? _defaultOutputPath : arguments.last,
  );
  final sourceContents = source.readAsStringSync();
  final document = XmlDocument.parse(sourceContents);
  final rootGroup = _rootArtworkGroup(document, source);
  final artwork = rootGroup.childElements.toList(growable: false);
  final foregroundIndex = artwork.indexWhere(
    (element) =>
        element.name.local == 'path' &&
        element.getAttribute('d') == _screenPathData,
  );
  if (foregroundIndex < 0 || foregroundIndex + 1 >= artwork.length) {
    throw StateError('Unable to split the icon artwork in ${source.path}');
  }

  final assets = Directory('${output.path}/Assets')
    ..createSync(recursive: true);
  _writeLayer(
    sourceContents: sourceContents,
    source: source,
    output: File('${assets.path}/background.svg'),
    keepElement: (index) => index < foregroundIndex,
  );
  _writeLayer(
    sourceContents: sourceContents,
    source: source,
    output: File('${assets.path}/foreground.svg'),
    keepElement: (index) => index >= foregroundIndex,
  );
  File('${output.path}/icon.json').writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(_iconDefinition)}\n',
  );
}

XmlElement _rootArtworkGroup(XmlDocument document, File source) {
  final groups = document.rootElement.childElements
      .where((element) => element.name.local == 'g')
      .toList(growable: false);
  if (groups.length != 1) {
    throw StateError('Expected one root artwork group in ${source.path}');
  }
  return groups.single;
}

void _writeLayer({
  required String sourceContents,
  required File source,
  required File output,
  required bool Function(int index) keepElement,
}) {
  final document = XmlDocument.parse(sourceContents);
  final svg = document.rootElement;
  final width = _parseSvgLength(svg.getAttribute('width'), 'width');
  final height = _parseSvgLength(svg.getAttribute('height'), 'height');
  final rootGroup = _rootArtworkGroup(document, source);
  final elements = rootGroup.childElements.toList(growable: false);

  for (var index = 0; index < elements.length; index++) {
    if (!keepElement(index)) elements[index].remove();
  }

  svg.setAttribute('width', '1024');
  svg.setAttribute('height', '1024');
  svg.setAttribute('viewBox', '0 0 ${_format(width)} ${_format(height)}');
  output.writeAsStringSync(document.toXmlString(pretty: false));
}

double _parseSvgLength(String? value, String name) {
  final parsed = double.tryParse(value?.replaceFirst('px', '') ?? '');
  if (parsed == null || parsed <= 0) {
    throw FormatException('Invalid SVG $name: $value');
  }
  return parsed;
}

String _format(double value) => value
    .toStringAsFixed(6)
    .replaceFirst(RegExp(r'0+$'), '')
    .replaceFirst(RegExp(r'\.$'), '');

const _iconDefinition = <String, Object>{
  'fill': 'automatic',
  'groups': [
    {
      'layers': [
        {'glass': false, 'image-name': 'foreground.svg', 'name': 'Foreground'},
        {'glass': false, 'image-name': 'background.svg', 'name': 'Background'},
      ],
      'shadow': {'kind': 'none', 'opacity': 1},
      'translucency': {'enabled': false, 'value': 0.5},
    },
  ],
  'supported-platforms': {
    'circles': ['watchOS'],
    'squares': 'shared',
  },
};
