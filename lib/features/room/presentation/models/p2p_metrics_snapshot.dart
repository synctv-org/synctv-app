class P2pMetricsSnapshot {
  const P2pMetricsSnapshot({
    this.httpBytes = 0,
    this.p2pDownloadBytes = 0,
    this.p2pUploadBytes = 0,
    this.httpDownloadRate = 0,
    this.p2pDownloadRate = 0,
    this.p2pUploadRate = 0,
    this.cacheBytes = 0,
    this.cacheHits = 0,
    this.cacheMisses = 0,
    this.integrityChecks = 0,
    this.integrityMismatches = 0,
    this.integrityUnavailable = 0,
  });

  final int httpBytes;
  final int p2pDownloadBytes;
  final int p2pUploadBytes;
  final double httpDownloadRate;
  final double p2pDownloadRate;
  final double p2pUploadRate;
  final int cacheBytes;
  final int cacheHits;
  final int cacheMisses;
  final int integrityChecks;
  final int integrityMismatches;
  final int integrityUnavailable;

  int get totalDownloadBytes => httpBytes + p2pDownloadBytes;
  double get totalDownloadRate => httpDownloadRate + p2pDownloadRate;
  double get cacheHitRatio {
    final total = cacheHits + cacheMisses;
    return total == 0 ? 0 : cacheHits / total;
  }
}
