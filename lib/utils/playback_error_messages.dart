import 'package:synctv_app/l10n/l10n.dart';

String playbackLoadErrorMessage(AppLocalizations l10n, Object error) {
  final text = error.toString();
  final lower = text.toLowerCase();

  if (_containsStatus(lower, 401)) {
    return l10n.playbackAuthenticationRequired;
  }
  if (_containsStatus(lower, 403)) {
    return l10n.playbackAccessForbidden;
  }
  if (_containsStatus(lower, 404) || lower.contains('not found')) {
    return l10n.playbackNotFound;
  }
  if (_containsStatus(lower, 429) || lower.contains('rate limit')) {
    return l10n.playbackRateLimited;
  }
  if (lower.contains('unsupported') ||
      lower.contains('format') ||
      lower.contains('codec') ||
      lower.contains('decode')) {
    return l10n.playbackFormatUnsupported;
  }
  if (lower.contains('timed out') ||
      lower.contains('timeout') ||
      lower.contains('network') ||
      lower.contains('connection') ||
      lower.contains('failed host lookup')) {
    return l10n.playbackConnectionFailed;
  }

  return l10n.playbackLoadFailed;
}

bool _containsStatus(String text, int status) {
  final value = status.toString();
  return text.contains('http $value') ||
      text.contains('http status $value') ||
      text.contains('statuscode: $value') ||
      text.contains('status code $value') ||
      text.contains('status=$value') ||
      text.contains('response code: $value') ||
      text.contains('server returned $value');
}
