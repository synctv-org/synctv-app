import 'dart:convert';

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

typedef P2pMediaResourceRegistrar =
    Uri Function(P2pMediaResourceRegistration registration);

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
          final childLogicalKey = isKey
              ? '$logicalKey:key:${resourceIndex++}'
              : '$logicalKey:resource:$discontinuitySequence:'
                    '$mediaSequence:${line.split(':').first}:${resourceIndex++}';
          final child = register(
            P2pMediaResourceRegistration(
              upstream: childUpstream,
              logicalKey: childLogicalKey,
              shareable: !isKey,
              manifestKind:
                  !isKey &&
                      (attributeUriIsPlaylist ||
                          looksLikeP2pHlsManifest(childUpstream))
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
  var baseIndex = 0;
  var resourceIndex = 0;

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

  void rewriteElement(XmlElement element, Uri inheritedBase) {
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
        childLogicalKey: '$logicalKey:dash-resource:${resourceIndex++}',
        kind: kind,
      );
    }

    if (element.name.local == 'Location') {
      final raw = element.innerText.trim();
      if (raw.isNotEmpty) {
        final local = registerReference(
          reference: inheritedBase.resolve(raw),
          childLogicalKey: '$logicalKey:dash-resource:${resourceIndex++}',
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
    for (var index = 0; index < baseUrls.length; index++) {
      final baseUrl = baseUrls[index];
      final raw = baseUrl.innerText.trim();
      if (raw.isEmpty) continue;
      final reference = inheritedBase.resolve(raw);
      if (index == 0) descendantBase = reference;
      if (!identical(element, root) && _isSafeRelativeDashReference(raw)) {
        continue;
      }
      final childLogicalKey = '$logicalKey:dash-base:${baseIndex++}';
      final local = register(
        P2pMediaResourceRegistration(
          upstream: reference.path.endsWith('/')
              ? _directoryUri(reference)
              : reference,
          logicalKey: childLogicalKey,
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
        rewriteElement(child, descendantBase);
      }
    }
  }

  rewriteElement(root, upstream);
  if (rootBaseUrls.isEmpty) {
    final local = register(
      P2pMediaResourceRegistration(
        upstream: _directoryUri(upstream.resolve('.')),
        logicalKey: '$logicalKey:dash-root',
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

bool looksLikeP2pHlsManifest(Uri uri) => p2pMediaPath(uri).endsWith('.m3u8');

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
