abstract interface class DesktopWebVerificationClient {
  bool get supported;

  Future<String> verify({
    required String html,
    required String bridgeName,
    required String title,
    required double windowWidth,
    required double windowHeight,
    required Duration timeout,
    String? browserPath,
    Map<String, String> browserFragmentParameters = const {},
  });
}
