class HlsVariantInfo {
  const HlsVariantInfo({
    required this.uri,
    required this.bandwidth,
    this.averageBandwidth,
    this.width,
    this.height,
    this.fps,
    this.codecs,
  });

  final Uri uri;
  final int bandwidth;
  final int? averageBandwidth;
  final int? width;
  final int? height;
  final double? fps;
  final String? codecs;
}

List<HlsVariantInfo> parseHlsMasterPlaylist(String content, Uri manifestUri) {
  final lines = content.split(RegExp(r'\r?\n'));
  final variants = <HlsVariantInfo>[];
  for (var index = 0; index < lines.length; index++) {
    final line = lines[index].trim();
    const prefix = '#EXT-X-STREAM-INF:';
    if (!line.startsWith(prefix)) continue;
    final attributes = _parseAttributeList(line.substring(prefix.length));
    final bandwidth = int.tryParse(attributes['BANDWIDTH'] ?? '');
    if (bandwidth == null || bandwidth <= 0) continue;

    String? variantReference;
    while (++index < lines.length) {
      final candidate = lines[index].trim();
      if (candidate.isEmpty) continue;
      if (candidate.startsWith('#')) break;
      variantReference = candidate;
      break;
    }
    if (variantReference == null) continue;

    final resolution = attributes['RESOLUTION']?.split('x');
    variants.add(
      HlsVariantInfo(
        uri: manifestUri.resolve(variantReference),
        bandwidth: bandwidth,
        averageBandwidth: int.tryParse(attributes['AVERAGE-BANDWIDTH'] ?? ''),
        width: resolution?.length == 2 ? int.tryParse(resolution![0]) : null,
        height: resolution?.length == 2 ? int.tryParse(resolution![1]) : null,
        fps: double.tryParse(attributes['FRAME-RATE'] ?? ''),
        codecs: attributes['CODECS'],
      ),
    );
  }
  variants.sort((left, right) => left.bandwidth.compareTo(right.bandwidth));
  return variants;
}

Map<String, String> _parseAttributeList(String input) {
  final result = <String, String>{};
  var start = 0;
  var quoted = false;
  for (var index = 0; index <= input.length; index++) {
    if (index < input.length && input[index] == '"') quoted = !quoted;
    if (index < input.length && (input[index] != ',' || quoted)) continue;
    final field = input.substring(start, index).trim();
    final separator = field.indexOf('=');
    if (separator > 0) {
      final key = field.substring(0, separator).trim();
      var value = field.substring(separator + 1).trim();
      if (value.length >= 2 && value.startsWith('"') && value.endsWith('"')) {
        value = value.substring(1, value.length - 1);
      }
      result[key] = value;
    }
    start = index + 1;
  }
  return result;
}
