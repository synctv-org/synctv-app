import 'package:synctv_app/contracts/synctv_models.dart';

final class LocalizedPlaybackResource {
  const LocalizedPlaybackResource({required this.uri, this.headers = const {}});

  final Uri uri;
  final Map<String, String> headers;
}

typedef PlaybackResourceLocalizer = Future<LocalizedPlaybackResource> Function(
  String url,
  Map<String, String> headers,
  P2pResourceDelivery delivery,
);
