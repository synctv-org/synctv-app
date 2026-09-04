import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:xml/xml.dart';

enum P2pManifestKind { progressive, hls, dash }

final class P2pMediaResourceRegistration {
  const P2pMediaResourceRegistration({
    required this.upstream,
    required this.logicalKey,
    required this.shareable,
    required this.manifestKind,
    required this.isDirectory,
  });

  final Uri upstream;
  final String logicalKey;
  final bool shareable;
  final P2pManifestKind manifestKind;
  final bool isDirectory;
}

typedef P2pMediaResourceRegistrar = Uri Function(
  P2pMediaResourceRegistration registration,
);

P2pManifestKind p2pManifestKind(String format, Uri upstream) {
  final normalizedFormat = format.trim().toLowerCase();
  final path = upstream.path.toLowerCase();
  if (normalizedFormat.contains('hls') ||
      normalizedFormat.contains('m3u8') ||
      path.endsWith('.m3u8')) {
    return P2pManifestKind.hls;
  }
  if (normalizedFormat.contains('dash') ||
      normalizedFormat.contains('mpd') ||
      path.endsWith('.mpd')) {
    return P2pManifestKind.dash;
  }
  return P2pManifestKind.progressive;
}

String rewriteP2pHlsManifest({
  required String manifest,
  required Uri upstream,
  required String logicalKey,
  required P2pMediaResourceRegistrar register,
}) {
  final lines = const LineSplitter().convert(manifest);
  var mediaSequence = 0;
  var discontinuitySequence = 0;
  var segmentIndex = 0;
  var resourceIndex = 0;
  for (final line in lines) {
    if (line.startsWith('#EXT-X-MEDIA-SEQUENCE:')) {
      mediaSequence = int.tryParse(line.split(':').last.trim()) ?? 0;
    } else if (line.startsWith('#EXT-X-DISCONTINUITY-SEQUENCE:')) {
      discontinuitySequence = int.tryParse(line.split(':').last.trim()) ?? 0;
    }
  }

  final rewritten = <String>[];
  var nextUriIsPlaylist = false;
  for (final line in lines) {
    if (line.isEmpty) {
      rewritten.add(line);
      continue;
    }
    if (line.startsWith('#')) {
      if (line.startsWith('#EXT-X-STREAM-INF:')) {
        nextUriIsPlaylist = true;
      }
      final attributeUriIsPlaylist =
          line.startsWith('#EXT-X-MEDIA:') ||
          line.startsWith('#EXT-X-I-FRAME-STREAM-INF:') ||
          line.startsWith('#EXT-X-IMAGE-STREAM-INF:') ||
          line.startsWith('#EXT-X-RENDITION-REPORT:');
      rewritten.add(
        line.replaceAllMapped(RegExp(r'URI="([^"]+)"'), (match) {
          final raw = match.group(1)!;
          final isKey =
              line.startsWith('#EXT-X-KEY:') ||
              line.startsWith('#EXT-X-SESSION-KEY:');
          final childUpstream = upstream.resolve(raw);
          final isManifest =
              !isKey &&
              (attributeUriIsPlaylist ||
                  looksLikeP2pHlsManifest(childUpstream));
          final childLogicalKey = isKey
              ? '$logicalKey:key:${resourceIndex++}'
              : '$logicalKey:resource:$discontinuitySequence:'
                    '$mediaSequence:${line.split(':').first}:${resourceIndex++}';
          final child = register(
            P2pMediaResourceRegistration(
              upstream: childUpstream,
              logicalKey: childLogicalKey,
              shareable: !isKey && !isManifest,
              manifestKind: isManifest
                  ? P2pManifestKind.hls
                  : P2pManifestKind.progressive,
              isDirectory: false,
            ),
          );
          return 'URI="$child"';
        }),
      );
      continue;
    }

    final childUpstream = upstream.resolve(line);
    final isManifest =
        nextUriIsPlaylist || looksLikeP2pHlsManifest(childUpstream);
    nextUriIsPlaylist = false;
    final child = register(
      P2pMediaResourceRegistration(
        upstream: childUpstream,
        logicalKey: isManifest
            ? '$logicalKey:manifest:${resourceIndex++}'
            : '$logicalKey:segment:$discontinuitySequence:'
                  '${mediaSequence + segmentIndex++}',
        shareable: !isManifest,
        manifestKind: isManifest
            ? P2pManifestKind.hls
            : P2pManifestKind.progressive,
        isDirectory: false,
      ),
    );
    rewritten.add(child.toString());
  }
  return '${rewritten.join('\n')}\n';
}

String rewriteP2pDashManifest({
  required String manifest,
  required Uri upstream,
  required String logicalKey,
  required P2pMediaResourceRegistrar register,
}) {
  final document = XmlDocument.parse(manifest);
  final root = document.rootElement;
  final rootBaseUrls = root.childElements
      .where((element) => element.name.local == 'BaseURL')
      .toList(growable: false);

  String registerReference({
    required Uri reference,
    required String childLogicalKey,
    required _DashReferenceKind kind,
  }) {
    if (kind == _DashReferenceKind.media &&
        reference.toString().contains(r'$')) {
      final path = reference.path;
      var suffixStart = path.lastIndexOf('/') + 1;
      var offset = 0;
      for (final segment in path.split('/')) {
        if (segment.contains(r'$')) {
          suffixStart = offset;
          break;
        }
        offset += segment.length + 1;
      }
      final scope = reference.replace(
        path: path.substring(0, suffixStart),
        query: null,
        fragment: null,
      );
      final directory = register(
        P2pMediaResourceRegistration(
          upstream: _directoryUri(scope),
          logicalKey: childLogicalKey,
          shareable: true,
          manifestKind: P2pManifestKind.progressive,
          isDirectory: true,
        ),
      );
      final suffix = StringBuffer(path.substring(suffixStart));
      if (reference.hasQuery) suffix.write('?${reference.query}');
      if (reference.hasFragment) suffix.write('#${reference.fragment}');
      return '$directory$suffix';
    }

    if (reference.path.endsWith('/')) {
      return register(
        P2pMediaResourceRegistration(
          upstream: _directoryUri(reference),
          logicalKey: childLogicalKey,
          shareable: true,
          manifestKind: P2pManifestKind.progressive,
          isDirectory: true,
        ),
      ).toString();
    }
    final local = register(
      P2pMediaResourceRegistration(
        upstream: reference,
        logicalKey: childLogicalKey,
        shareable: kind == _DashReferenceKind.media,
        manifestKind: kind == _DashReferenceKind.manifest
            ? P2pManifestKind.dash
            : P2pManifestKind.progressive,
        isDirectory: false,
      ),
    );
    return reference.hasFragment
        ? local.replace(fragment: reference.fragment).toString()
        : local.toString();
  }

  void rewriteElement(
    XmlElement element,
    Uri inheritedBase,
    String inheritedScope,
  ) {
    final scope = _dashElementScope(element, inheritedScope);
    for (final attribute in element.attributes) {
      final kind = _dashAttributeKind(element, attribute);
      if (kind == null) continue;
      final raw = attribute.value.trim();
      if (raw.isEmpty ||
          (kind == _DashReferenceKind.media &&
              _isSafeRelativeDashReference(raw))) {
        continue;
      }
      attribute.value = registerReference(
        reference: inheritedBase.resolve(raw),
        childLogicalKey: _dashReferenceLogicalKey(
          logicalKey: logicalKey,
          scope: scope,
          element: element,
          attribute: attribute,
          reference: inheritedBase.resolve(raw),
          kind: kind,
        ),
        kind: kind,
      );
    }

    if (element.name.local == 'Location') {
      final raw = element.innerText.trim();
      if (raw.isNotEmpty) {
        final local = registerReference(
          reference: inheritedBase.resolve(raw),
          childLogicalKey: '$logicalKey:$scope:manifest-location',
          kind: _DashReferenceKind.manifest,
        );
        element.children
          ..clear()
          ..add(XmlText(local));
      }
    }

    var descendantBase = inheritedBase;
    final baseUrls = element.childElements
        .where((child) => child.name.local == 'BaseURL')
        .toList(growable: false);
    for (final baseUrl in baseUrls) {
      final raw = baseUrl.innerText.trim();
      if (raw.isEmpty) continue;
      final reference = inheritedBase.resolve(raw);
      if (identical(baseUrl, baseUrls.first)) descendantBase = reference;
      if (!identical(element, root) && _isSafeRelativeDashReference(raw)) {
        continue;
      }
      final local = register(
        P2pMediaResourceRegistration(
          upstream: reference.path.endsWith('/')
              ? _directoryUri(reference)
              : reference,
          logicalKey: '$logicalKey:$scope:base',
          shareable: true,
          manifestKind: P2pManifestKind.progressive,
          isDirectory: raw.endsWith('/') || reference.path.endsWith('/'),
        ),
      );
      baseUrl.children
        ..clear()
        ..add(XmlText(local.toString()));
    }
    for (final child in element.childElements) {
      if (child.name.local != 'BaseURL') {
        rewriteElement(child, descendantBase, scope);
      }
    }
  }

  rewriteElement(root, upstream, 'mpd');
  if (rootBaseUrls.isEmpty) {
    final local = register(
      P2pMediaResourceRegistration(
        upstream: _directoryUri(upstream.resolve('.')),
        logicalKey: '$logicalKey:mpd:root-base',
        shareable: true,
        manifestKind: P2pManifestKind.progressive,
        isDirectory: true,
      ),
    );
    root.children.insert(
      0,
      XmlElement(XmlName.parts('BaseURL'), const [], [
        XmlText(local.toString()),
      ]),
    );
  }
  return document.toXmlString();
}

String _dashElementScope(XmlElement element, String inheritedScope) {
  final name = element.name.local;
  return switch (name) {
    'Period' => '$inheritedScope:period:${_dashElementIdentity(element)}',
    'AdaptationSet' =>
      '$inheritedScope:adaptation:${_dashElementIdentity(element)}',
    'Representation' =>
      '$inheritedScope:representation:${_dashElementIdentity(element)}',
    _ => inheritedScope,
  };
}

String _dashElementIdentity(XmlElement element) {
  final id = element.getAttribute('id')?.trim() ?? '';
  if (id.isNotEmpty) return Uri.encodeComponent(id);
  final attributes = switch (element.name.local) {
    'Period' => const ['start', 'duration'],
    'AdaptationSet' => const [
      'contentType',
      'mimeType',
      'codecs',
      'lang',
      'group',
    ],
    'Representation' => const [
      'codecs',
      'mimeType',
      'width',
      'height',
      'frameRate',
      'audioSamplingRate',
      'bandwidth',
    ],
    _ => const <String>[],
  };
  final identity = attributes
      .map((name) => '$name=${element.getAttribute(name)?.trim() ?? ''}')
      .join(',');
  final referenceIdentity = _dashLocalReferenceIdentity(element);
  final attributeIdentity = identity.isEmpty ? element.name.local : identity;
  if (referenceIdentity.isEmpty) return Uri.encodeComponent(attributeIdentity);
  final referenceDigest = sha256
      .convert(utf8.encode(referenceIdentity))
      .toString()
      .substring(0, 16);
  return '${Uri.encodeComponent(attributeIdentity)}@$referenceDigest';
}

String _dashLocalReferenceIdentity(XmlElement element) {
  final references = <String>{};

  void visit(XmlElement current) {
    if (!identical(current, element) &&
        const {
          'Period',
          'AdaptationSet',
          'Representation',
        }.contains(current.name.local)) {
      return;
    }
    if (current.name.local == 'BaseURL') {
      final raw = current.innerText.trim();
      if (raw.isNotEmpty) references.add(_stableDashReferenceIdentity(raw));
    }
    for (final attribute in current.attributes) {
      if (_dashAttributeKind(current, attribute) != _DashReferenceKind.media) {
        continue;
      }
      final raw = attribute.value.trim();
      if (raw.isEmpty) continue;
      var reference = _stableDashReferenceIdentity(raw);
      final rangeName = switch ((current.name.local, attribute.name.local)) {
        ('SegmentURL', 'media') => 'mediaRange',
        ('SegmentURL', 'index') => 'indexRange',
        ('Initialization', 'sourceURL') ||
        ('RepresentationIndex', 'sourceURL') ||
        ('BitstreamSwitching', 'sourceURL') => 'range',
        _ => null,
      };
      final byteRange = rangeName == null
          ? null
          : current.getAttribute(rangeName)?.trim();
      if (byteRange != null && byteRange.isNotEmpty) {
        reference = '$reference#range=$byteRange';
      }
      references.add(
        '${current.name.local}:${attribute.name.local}:$reference',
      );
    }
    for (final child in current.childElements) {
      visit(child);
    }
  }

  visit(element);
  final sorted = references.toList()..sort();
  return sorted.join('|');
}

String _stableDashReferenceIdentity(String raw) {
  final reference = Uri.tryParse(raw);
  if (reference == null) return raw;
  final stableQuery = _stableMediaQuery(reference);
  return stableQuery.isEmpty
      ? reference.path
      : '${reference.path}?$stableQuery';
}

String _dashReferenceLogicalKey({
  required String logicalKey,
  required String scope,
  required XmlElement element,
  required XmlAttribute attribute,
  required Uri reference,
  required _DashReferenceKind kind,
}) {
  final elementName = element.name.local;
  final attributeName = attribute.name.local;
  final role = switch ((elementName, attributeName, kind)) {
    ('SegmentTemplate', 'initialization', _) => 'initialization-template',
    ('SegmentTemplate', 'media', _) => 'media-template',
    ('SegmentTemplate', 'bitstreamSwitching', _) =>
      'bitstream-switching-template',
    ('Initialization', 'sourceURL', _) => 'initialization',
    ('RepresentationIndex', 'sourceURL', _) => 'representation-index',
    ('BitstreamSwitching', 'sourceURL', _) => 'bitstream-switching',
    ('SegmentURL', 'media', _) =>
      'media:${_dashReferenceResourceIdentity(reference, element, attribute)}',
    ('SegmentURL', 'index', _) =>
      'index:${_dashReferenceResourceIdentity(reference, element, attribute)}',
    (_, _, _DashReferenceKind.manifest) => 'manifest-xlink',
    (_, _, _DashReferenceKind.utcTiming) => 'utc-timing',
    _ => '$elementName-$attributeName',
  };
  return '$logicalKey:$scope:$role';
}

String _dashReferenceResourceIdentity(
  Uri reference,
  XmlElement element,
  XmlAttribute attribute,
) {
  final path = Uri.encodeComponent(reference.path);
  final stableQuery = _stableMediaQuery(reference);
  final rangeAttribute = switch (attribute.name.local) {
    'media' => 'mediaRange',
    'index' => 'indexRange',
    _ => null,
  };
  final byteRange = rangeAttribute == null
      ? null
      : element.getAttribute(rangeAttribute)?.trim();
  final query = stableQuery.isEmpty ? '' : '?$stableQuery';
  final range = byteRange == null || byteRange.isEmpty
      ? ''
      : '${stableQuery.isEmpty ? '?' : '&'}range=${Uri.encodeComponent(byteRange)}';
  return '$path$query$range';
}

bool looksLikeP2pHlsManifest(Uri uri) => p2pMediaPath(uri).endsWith('.m3u8');

String p2pDirectoryChildLogicalKey(String directoryLogicalKey, Uri relative) {
  final stableQuery = _stableMediaQuery(relative);
  final resourceIdentity = stableQuery.isEmpty
      ? relative.path
      : '${relative.path}?$stableQuery';
  return '$directoryLogicalKey:$resourceIdentity';
}

String _stableMediaQuery(Uri uri) {
  final query =
      <MapEntry<String, String>>[
        for (final entry in uri.queryParametersAll.entries)
          if (!_isVolatileMediaQueryParameter(entry.key))
            for (final value in entry.value) MapEntry(entry.key, value),
      ]..sort((left, right) {
        final keyOrder = left.key.compareTo(right.key);
        return keyOrder != 0 ? keyOrder : left.value.compareTo(right.value);
      });
  return query
      .map(
        (entry) =>
            '${Uri.encodeQueryComponent(entry.key)}='
            '${Uri.encodeQueryComponent(entry.value)}',
      )
      .join('&');
}

String p2pMediaPath(Uri uri) {
  final path = uri.path.toLowerCase();
  for (final value in uri.queryParameters.values) {
    final nested = Uri.tryParse(value);
    final nestedPath = nested?.path.toLowerCase();
    if (nestedPath != null && _isKnownMediaPath(nestedPath)) {
      return nestedPath;
    }
  }
  return path;
}

Uri _directoryUri(Uri value) =>
    value.path.endsWith('/') ? value : value.resolve('.');

bool _isVolatileMediaQueryParameter(String name) {
  final normalized = name.trim().toLowerCase();
  return normalized == 'token' ||
      normalized == 'sign' ||
      normalized == 'signature' ||
      normalized == 'deadline' ||
      normalized == 'expires' ||
      normalized == 'expire' ||
      normalized == 'expiry' ||
      normalized == 'auth_key' ||
      normalized == 'authkey' ||
      normalized == 'upsig' ||
      normalized == 'policy' ||
      normalized == 'key-pair-id' ||
      normalized == 'wssecret' ||
      normalized == 'wstime' ||
      normalized == 'hdnea' ||
      normalized.startsWith('x-amz-') ||
      normalized.startsWith('x-goog-');
}

enum _DashReferenceKind { media, manifest, utcTiming }

_DashReferenceKind? _dashAttributeKind(
  XmlElement element,
  XmlAttribute attribute,
) {
  final elementName = element.name.local;
  final attributeName = attribute.name.local;
  if (elementName == 'SegmentTemplate' &&
      const {
        'media',
        'initialization',
        'bitstreamSwitching',
      }.contains(attributeName)) {
    return _DashReferenceKind.media;
  }
  if (elementName == 'SegmentURL' &&
      const {'media', 'index'}.contains(attributeName)) {
    return _DashReferenceKind.media;
  }
  if (const {
        'Initialization',
        'RepresentationIndex',
        'BitstreamSwitching',
      }.contains(elementName) &&
      attributeName == 'sourceURL') {
    return _DashReferenceKind.media;
  }
  if (attributeName == 'href' &&
      (attribute.name.prefix == 'xlink' ||
          attribute.name.namespaceUri == 'http://www.w3.org/1999/xlink')) {
    return _DashReferenceKind.manifest;
  }
  if (elementName == 'UTCTiming' &&
      attributeName == 'value' &&
      (element.getAttribute('schemeIdUri') ?? '').contains(':http-')) {
    return _DashReferenceKind.utcTiming;
  }
  return null;
}

bool _isSafeRelativeDashReference(String raw) {
  final parsed = Uri.tryParse(raw);
  if (parsed == null ||
      parsed.hasScheme ||
      parsed.hasAuthority ||
      raw.startsWith('/') ||
      raw.startsWith(r'\') ||
      raw.contains(r'\')) {
    return false;
  }
  return parsed.path.isNotEmpty &&
      parsed.pathSegments.every(
        (segment) => segment.isEmpty || (segment != '.' && segment != '..'),
      );
}

bool _isKnownMediaPath(String path) =>
    path.endsWith('.m3u8') ||
    path.endsWith('.ts') ||
    path.endsWith('.m4s') ||
    path.endsWith('.mp4') ||
    path.endsWith('.flv') ||
    path.endsWith('.webm') ||
    path.endsWith('.mpd') ||
    path.endsWith('.vtt') ||
    path.endsWith('.srt') ||
    path.endsWith('.ass') ||
    path.endsWith('.ssa') ||
    path.endsWith('.aac') ||
    path.endsWith('.mp3');
