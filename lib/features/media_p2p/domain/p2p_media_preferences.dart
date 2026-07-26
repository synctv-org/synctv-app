enum P2pMediaSecurityMode { standard, sampledOrigin }

class P2pMediaPreferenceValues {
  const P2pMediaPreferenceValues({
    this.enabled = false,
    this.securityMode = P2pMediaSecurityMode.standard,
    this.cacheSizeMiB = defaultCacheSizeMiB,
  });

  static const int defaultCacheSizeMiB = 128;
  static const List<int> cacheSizeOptionsMiB = [64, 128, 256, 512, 1024];

  final bool enabled;
  final P2pMediaSecurityMode securityMode;
  final int cacheSizeMiB;

  P2pMediaPreferenceValues copyWith({
    bool? enabled,
    P2pMediaSecurityMode? securityMode,
    int? cacheSizeMiB,
  }) {
    return P2pMediaPreferenceValues(
      enabled: enabled ?? this.enabled,
      securityMode: securityMode ?? this.securityMode,
      cacheSizeMiB: cacheSizeMiB ?? this.cacheSizeMiB,
    );
  }
}
