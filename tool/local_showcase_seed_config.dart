import 'dart:io';

void validateLocalShowcaseConfiguration({
  required String baseUrl,
  required String coverDirectory,
  required bool allowReset,
  required Iterable<String> requiredCoverFiles,
}) {
  final uri = Uri.tryParse(baseUrl);
  final address = uri == null ? null : InternetAddress.tryParse(uri.host);
  final isLoopback =
      uri != null &&
      (uri.host == 'localhost' || address?.isLoopback == true) &&
      (uri.scheme == 'http' || uri.scheme == 'https');
  if (!isLoopback) {
    throw ArgumentError.value(
      baseUrl,
      'SYNCTV_SMOKE_BASE_URL',
      'Showcase seeding is restricted to a loopback server',
    );
  }
  if (!allowReset) {
    throw ArgumentError(
      'SYNCTV_SHOWCASE_ALLOW_RESET=true is required to replace showcase data',
    );
  }

  final directory = Directory(coverDirectory);
  if (coverDirectory.trim().isEmpty || !directory.existsSync()) {
    throw ArgumentError.value(
      coverDirectory,
      'SYNCTV_SHOWCASE_COVER_DIR',
      'Showcase cover directory does not exist',
    );
  }

  final missingFiles = requiredCoverFiles
      .where((name) => !File.fromUri(directory.uri.resolve(name)).existsSync())
      .toList(growable: false);
  if (missingFiles.isNotEmpty) {
    throw ArgumentError.value(
      missingFiles.join(', '),
      'SYNCTV_SHOWCASE_COVER_DIR',
      'Showcase cover files are missing',
    );
  }
}
