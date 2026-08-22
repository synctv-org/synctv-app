enum WebPlaybackEngine { progressive, nativeHls, hlsJs, dashJs, mpegTsJs }

enum WebPlaybackTransport { progressive, hls, dash, flv, mpegTs }

WebPlaybackTransport detectWebPlaybackTransport({
  required String? formatHint,
  required Uri uri,
}) {
  final hint = formatHint?.trim().toLowerCase() ?? '';
  final path = uri.path.toLowerCase();
  if (hint == 'hls' || hint == 'm3u8' || path.endsWith('.m3u8')) {
    return WebPlaybackTransport.hls;
  }
  if (hint == 'dash' || hint == 'mpd' || path.endsWith('.mpd')) {
    return WebPlaybackTransport.dash;
  }
  if (hint == 'flv' ||
      hint == 'httpflv' ||
      hint == 'http-flv' ||
      hint == 'http_flv' ||
      path.endsWith('.flv')) {
    return WebPlaybackTransport.flv;
  }
  if (hint == 'mpegts' ||
      hint == 'mpeg-ts' ||
      hint == 'mpeg_ts' ||
      hint == 'ts' ||
      path.endsWith('.ts')) {
    return WebPlaybackTransport.mpegTs;
  }
  return WebPlaybackTransport.progressive;
}

WebPlaybackEngine selectWebPlaybackEngine({
  required WebPlaybackTransport transport,
  required bool nativeHls,
}) => switch (transport) {
  WebPlaybackTransport.progressive => WebPlaybackEngine.progressive,
  WebPlaybackTransport.hls =>
    nativeHls ? WebPlaybackEngine.nativeHls : WebPlaybackEngine.hlsJs,
  WebPlaybackTransport.dash => WebPlaybackEngine.dashJs,
  WebPlaybackTransport.flv ||
  WebPlaybackTransport.mpegTs => WebPlaybackEngine.mpegTsJs,
};

String hlsSelectedTrackId({int? manualLevel}) {
  final selectedLevel = manualLevel ?? -1;
  return selectedLevel < 0 ? 'auto' : 'hls:$selectedLevel';
}
