import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synctv_app/models/danmaku_model.dart';
import 'package:synctv_app/models/synctv_models.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/utils/chat_reactions.dart';

class PlaybackDanmakuWindow {
  const PlaybackDanmakuWindow({
    required this.sourceKey,
    required this.startSeconds,
    required this.endSeconds,
  });

  final String sourceKey;
  final double startSeconds;
  final double endSeconds;

  bool covers(String sourceKey, double positionSeconds, double marginSeconds) {
    return this.sourceKey == sourceKey &&
        positionSeconds >= startSeconds &&
        positionSeconds <= endSeconds - marginSeconds;
  }
}

class PlaybackDanmakuFetchResult {
  const PlaybackDanmakuFetchResult({
    required this.window,
    required this.items,
  });

  final PlaybackDanmakuWindow window;
  final List<DanmakuItem> items;
}

String playbackDanmakuSourceKey(SyncTvMovie? movie) {
  if (movie == null) return '';
  final target = movie.playbackTarget ?? '';
  final mediaId = movie.playbackMediaId;
  final playlistId = movie.playbackPlaylistId;
  if (mediaId.isEmpty && playlistId.isEmpty && target.isEmpty) return '';
  return [
    mediaId,
    playlistId,
    target,
  ].join('|');
}

Future<PlaybackDanmakuFetchResult?> fetchPlaybackDanmakuWindow({
  required String roomId,
  required SyncTvMovie? movie,
  required double positionSeconds,
  double beforeSeconds = 5,
  double afterSeconds = 90,
  int limit = 300,
}) async {
  if (movie == null) return null;
  final sourceKey = playbackDanmakuSourceKey(movie);
  if (sourceKey.isEmpty) return null;

  final target = movie.playbackTarget;
  final playbackTarget =
      target == null ? const <int>[] : base64Url.decode(target);
  final messages = await SyncTvService.getChatPlaybackMessages(
    roomId,
    playbackMediaId: movie.playbackMediaId,
    playbackPlaylistId: movie.playbackPlaylistId,
    playbackTarget: playbackTarget,
    positionSeconds: positionSeconds < 0 ? 0 : positionSeconds,
    beforeSeconds: beforeSeconds,
    afterSeconds: afterSeconds,
    limit: limit,
  );

  final start = (positionSeconds - beforeSeconds).clamp(0, double.infinity);
  return PlaybackDanmakuFetchResult(
    window: PlaybackDanmakuWindow(
      sourceKey: sourceKey,
      startSeconds: start.toDouble(),
      endSeconds: positionSeconds + afterSeconds,
    ),
    items: messages
        .where((message) =>
            !message.isDeleted && message.content.trim().isNotEmpty)
        .map(chatMessageToDanmaku)
        .toList(growable: false),
  );
}

DanmakuItem chatMessageToDanmaku(RoomChatMessageInfo message) {
  final position = message.position ?? 0;
  final startTime = Duration(milliseconds: (position * 1000).round());
  return DanmakuItem(
    text: chatTextWithReactionSummary(
      username: message.username,
      content: message.content,
      reactions: message.reactions,
    ),
    startTime: startTime,
    endTime: startTime + const Duration(seconds: 8),
    color: _parseDanmakuColor(message.color),
    type: DanmakuType.floating,
    fontSize: 24,
  );
}

Color _parseDanmakuColor(String? value) {
  if (value == null || value.isEmpty) return Colors.white;
  final hex = value.startsWith('#') ? value.substring(1) : value;
  final parsed = int.tryParse(hex.length == 6 ? 'FF$hex' : hex, radix: 16);
  return parsed == null ? Colors.white : Color(parsed);
}
