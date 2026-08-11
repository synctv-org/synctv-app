import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/media_provider_brand.dart';
import 'package:synctv_app/l10n/l10n.dart';

String localizedMediaVariant(BuildContext context, String raw) {
  final value = raw.trim();
  if (value.isEmpty) return context.l10n.media;
  if (mediaProviderBrand(value).known) return context.l10n.media;

  var key = value
      .split('.')
      .last
      .toLowerCase()
      .replaceAll(RegExp('[^a-z0-9]'), '');
  for (final prefix in const [
    'resourcekind',
    'mediatype',
    'mediakind',
    'itemtype',
    'sourcekind',
    'playbackkind',
    'streamkind',
  ]) {
    if (key.startsWith(prefix)) key = key.substring(prefix.length);
  }

  if (key == 'movie') return context.l10n.movie;
  if (key.endsWith('movies')) return context.l10n.movies;
  if (key == 'episode') return context.l10n.episode;
  if (key.endsWith('episodes')) return context.l10n.episodes;
  if (key == 'video') return context.l10n.video;
  if (key.endsWith('videos')) return context.l10n.videos;
  if (key.endsWith('audios') || key == 'audio') return context.l10n.audio;
  if (key.endsWith('folders') || key == 'folder' || key == 'directory') {
    return context.l10n.folder;
  }
  if (key.endsWith('playlists') || key == 'playlist') {
    return context.l10n.playlist;
  }
  if (key.endsWith('collections') || key == 'collection') {
    return context.l10n.collections;
  }
  if (key.endsWith('series') || key == 'tvshow' || key == 'tvshows') {
    return context.l10n.series;
  }
  if (key.endsWith('channels') || key == 'channel') return context.l10n.channel;
  if (key.endsWith('bangumi')) return context.l10n.bangumi;
  if (key == 'clip') return context.l10n.clip;
  if (key.endsWith('clips')) return context.l10n.clips;
  if (key.endsWith('posts') || key == 'post') return context.l10n.posts;
  if (key.endsWith('vod')) return context.l10n.vod;
  if (key.endsWith('live')) return context.l10n.live;
  if (key.endsWith('media')) return context.l10n.media;

  return _humanizeVariant(value);
}

String _humanizeVariant(String value) {
  final withoutPrefix = value.replaceFirst(
    RegExp(
      r'^(?:RESOURCE_KIND|MEDIA_TYPE|MEDIA_KIND|ITEM_TYPE|SOURCE_KIND|PLAYBACK_KIND|STREAM_KIND)[_-]+',
      caseSensitive: false,
    ),
    '',
  );
  final spaced = withoutPrefix
      .replaceAll(RegExp(r'[_-]+'), ' ')
      .replaceAllMapped(RegExp(r'(?<=[a-z0-9])(?=[A-Z])'), (_) => ' ')
      .trim();
  if (spaced.isEmpty) return value;
  return spaced
      .split(RegExp(r'\s+'))
      .map(
        (part) => part.isEmpty
            ? part
            : '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
      )
      .join(' ');
}
