import 'package:synctv_app/contracts/synctv_models.dart';

enum PlaylistSourceFactKind {
  instance,
  type,
  path,
  query,
  identifier,
  host,
  shared,
}

class PlaylistSourceFact {
  const PlaylistSourceFact(this.kind, this.value);

  final PlaylistSourceFactKind kind;
  final String value;
}

List<PlaylistSourceFact> playlistSourceFacts(RoomMediaEntry entry) {
  final facts = <PlaylistSourceFact>[];
  final seen = <String>{};

  void add(PlaylistSourceFactKind kind, Object? rawValue) {
    final value = rawValue?.toString().trim() ?? '';
    if (value.isEmpty) return;
    if (seen.add('${kind.name}:$value')) {
      facts.add(PlaylistSourceFact(kind, value));
    }
  }

  add(PlaylistSourceFactKind.instance, entry.providerInstanceName);

  final config = entry.sourceConfig;
  final nestedSource = config['source'];
  final source = nestedSource is Map
      ? Map<String, dynamic>.from(nestedSource)
      : const <String, dynamic>{};
  final kind = _firstValue([
    source['type'],
    source['kind'],
    config['type'],
    config['kind'],
  ]);
  if (kind.isNotEmpty) {
    add(PlaylistSourceFactKind.type, _humanize(kind));
  }

  add(
    PlaylistSourceFactKind.path,
    _firstValue([source['path'], config['path']]),
  );
  add(
    PlaylistSourceFactKind.query,
    _firstValue([source['query'], config['query'], config['keyword']]),
  );

  for (final key in const [
    'playlistId',
    'channelId',
    'bvid',
    'itemId',
    'personId',
    'repositoryId',
    'objectId',
    'secUid',
    'uniqueId',
    'webRid',
    'serverId',
  ]) {
    add(
      PlaylistSourceFactKind.identifier,
      _firstValue([source[key], config[key]]),
    );
    if (facts.length >= 5) break;
  }

  var rawUrl = config['url']?.toString().trim() ?? '';
  final medias = config['medias'];
  if (rawUrl.isEmpty && medias is Iterable) {
    for (final media in medias.whereType<Map>()) {
      rawUrl = media['url']?.toString().trim() ?? '';
      if (rawUrl.isNotEmpty) break;
    }
  }
  final uri = Uri.tryParse(rawUrl);
  if (uri != null && uri.host.isNotEmpty) {
    add(PlaylistSourceFactKind.host, uri.host);
  }
  if (config['shared'] == true || source['shared'] == true) {
    add(PlaylistSourceFactKind.shared, 'shared');
  }
  return facts.take(5).toList(growable: false);
}

String _firstValue(Iterable<Object?> values) {
  for (final value in values) {
    final text = value?.toString().trim() ?? '';
    if (text.isNotEmpty && text != 'null') return text;
  }
  return '';
}

String _humanize(String value) {
  final spaced = value
      .replaceAll(RegExp(r'[_-]+'), ' ')
      .replaceAllMapped(RegExp(r'(?<=[a-z0-9])(?=[A-Z])'), (_) => ' ')
      .trim();
  if (spaced.isEmpty) return value;
  return spaced
      .split(RegExp(r'\s+'))
      .map(
        (part) => part.isEmpty
            ? part
            : '${part[0].toUpperCase()}${part.substring(1)}',
      )
      .join(' ');
}
