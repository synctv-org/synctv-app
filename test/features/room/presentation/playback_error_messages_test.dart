import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/features/room/presentation/playback_error_messages.dart';
import 'package:synctv_app/l10n/app_localizations_zh.dart';

void main() {
  final l10n = AppLocalizationsZh();

  test('classifies DASH manifest download failures as connection errors', () {
    expect(
      playbackLoadErrorMessage(
        l10n,
        'manifestError: failed to download media format due to network error',
      ),
      l10n.playbackConnectionFailed,
    );
  });

  test('requires an explicit unsupported format or decode signal', () {
    expect(
      playbackLoadErrorMessage(l10n, 'invalid manifest format response'),
      l10n.playbackLoadFailed,
    );
    expect(
      playbackLoadErrorMessage(l10n, 'MEDIA_ERR_DECODE: unsupported codec'),
      l10n.playbackFormatUnsupported,
    );
    expect(
      playbackLoadErrorMessage(l10n, 'failed to load: unsupported codec'),
      l10n.playbackFormatUnsupported,
    );
  });
}
