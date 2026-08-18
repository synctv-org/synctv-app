import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synctv_app/features/room/presentation/models/danmaku_model.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/room/domain/chat_reactions.dart';

typedef PlaybackDanmakuMessageLoader =
    Future<List<RoomChatMessageInfo>> Function(PlaybackDanmakuQuery query);

class PlaybackDanmakuQuery {
  const PlaybackDanmakuQuery({
    required this.roomId,
    required this.playbackMediaId,
    required this.playbackPlaylistId,
    required this.playbackTarget,
    required this.positionSeconds,
    required this.beforeSeconds,
    required this.afterSeconds,
    required this.limit,
  });

  final String roomId;
  final String playbackMediaId;
  final String playbackPlaylistId;
  final List<int> playbackTarget;
  final double positionSeconds;
  final double beforeSeconds;
  final double afterSeconds;
  final int limit;
}

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
  const PlaybackDanmakuFetchResult({required this.window, required this.items});

  final PlaybackDanmakuWindow window;
  final List<DanmakuItem> items;
}

String playbackDanmakuSourceKey(RoomMediaEntry? entry) {
  if (entry == null) return '';
  final target = entry.playbackTarget ?? '';
  final mediaId = entry.playbackMediaId;
  final playlistId = entry.playbackPlaylistId;
  if (mediaId.isEmpty && playlistId.isEmpty && target.isEmpty) return '';
  return [mediaId, playlistId, target].join('|');
}

Future<PlaybackDanmakuFetchResult?> fetchPlaybackDanmakuWindow({
  required PlaybackDanmakuMessageLoader loadMessages,
  required String roomId,
  required RoomMediaEntry? entry,
  required double positionSeconds,
  double beforeSeconds = 5,
  double afterSeconds = 90,
  int limit = 300,
}) async {
  if (entry == null || entry.live) return null;
  final sourceKey = playbackDanmakuSourceKey(entry);
  if (sourceKey.isEmpty) return null;

  final target = entry.playbackTarget;
  final playbackTarget = target == null
      ? const <int>[]
      : base64Url.decode(target);
  final messages = await loadMessages(
    PlaybackDanmakuQuery(
      roomId: roomId,
      playbackMediaId: entry.playbackMediaId,
      playbackPlaylistId: entry.playbackPlaylistId,
      playbackTarget: playbackTarget,
      positionSeconds: positionSeconds < 0 ? 0 : positionSeconds,
      beforeSeconds: beforeSeconds,
      afterSeconds: afterSeconds,
      limit: limit,
    ),
  );

  final start = (positionSeconds - beforeSeconds).clamp(0, double.infinity);
  return PlaybackDanmakuFetchResult(
    window: PlaybackDanmakuWindow(
      sourceKey: sourceKey,
      startSeconds: start.toDouble(),
      endSeconds: positionSeconds + afterSeconds,
    ),
    items: messages
        .where(
          (message) =>
              message.isUserMessage &&
              !message.isDeleted &&
              message.content.trim().isNotEmpty,
        )
        .map(chatMessageToDanmaku)
        .toList(growable: false),
  );
}

DanmakuItem chatMessageToDanmaku(RoomChatMessageInfo message) {
  final position = message.position ?? 0;
  final startTime = Duration(milliseconds: (position * 1000).round());
  return DanmakuItem(
    text: chatTextWithReactionSummary(
      username: message.username ?? '',
      content: message.content,
      reactions: message.reactions,
    ),
    startTime: startTime,
    endTime: startTime + const Duration(seconds: 8),
    color: _parseDanmakuColor(message.color),
    type: DanmakuType.floating,
    fontSize: 24,
    origin: DanmakuOrigin.chat,
  );
}

Color _parseDanmakuColor(String? value) {
  if (value == null || value.isEmpty) return Colors.white;
  final hex = value.startsWith('#') ? value.substring(1) : value;
  final parsed = int.tryParse(hex.length == 6 ? 'FF$hex' : hex, radix: 16);
  return parsed == null ? Colors.white : Color(parsed);
}
