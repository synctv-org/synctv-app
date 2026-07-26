import 'package:synctv_app/contracts/room_media_models.dart';

const commonChatReactionKeys = ['👍', '❤️', '😂', '🎉', '😮', '😢'];

List<ChatReactionSummaryInfo> topChatReactions(
  Iterable<ChatReactionSummaryInfo> reactions, {
  int limit = 2,
}) {
  final sorted = reactions.where((reaction) => reaction.count > 0).toList()
    ..sort((a, b) {
      final countOrder = b.count.compareTo(a.count);
      if (countOrder != 0) return countOrder;
      return a.key.compareTo(b.key);
    });
  return sorted.take(limit).toList(growable: false);
}

String chatReactionSummarySuffix(
  Iterable<ChatReactionSummaryInfo> reactions, {
  int limit = 2,
}) {
  final summary = topChatReactions(
    reactions,
    limit: limit,
  ).map((reaction) => '${reaction.key}${reaction.count}').join(' ');
  return summary.isEmpty ? '' : '  $summary';
}

String chatTextWithReactionSummary({
  required String username,
  required String content,
  required Iterable<ChatReactionSummaryInfo> reactions,
  int limit = 2,
}) {
  final prefix = username.trim().isEmpty ? content : '$username: $content';
  return '$prefix${chatReactionSummarySuffix(reactions, limit: limit)}';
}
