abstract interface class PasskeyClient {
  Future<bool> isSupported({
    required String serverBaseUrl,
    required String rpId,
  });

  Future<Map<String, dynamic>> createCredential(
    List<int> options, {
    required String serverBaseUrl,
  });

  Future<Map<String, dynamic>> getCredential(
    List<int> options, {
    required String serverBaseUrl,
  });
}
