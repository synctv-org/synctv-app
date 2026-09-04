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
  if (lower.contains('timed out') ||
      lower.contains('timeout') ||
      lower.contains('network') ||
      lower.contains('connection') ||
      lower.contains('failed host lookup') ||
      lower.contains('manifesterror') ||
      lower.contains('downloaderror') ||
      lower.contains('failed to download') ||
      lower.contains('failed to load manifest') ||
      lower.contains('failed loading manifest')) {
    return l10n.playbackConnectionFailed;
  }
  if (lower.contains('unsupported') ||
      lower.contains('not supported') ||
      lower.contains('format not supported') ||
      lower.contains('codec') ||
      lower.contains('decode') ||
      lower.contains('media_err_src_not_supported')) {
    return l10n.playbackFormatUnsupported;
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
