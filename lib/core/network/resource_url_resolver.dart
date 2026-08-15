abstract interface class ResourceUrlResolver {
  String resolve(String resourceUrl);

  bool isServerResource(String resourceUrl);

  Map<String, String> get authenticatedHeaders;
}

/// Add the current session credentials only to resources served by SyncTV.
Map<String, String> authenticatedServerResourceHeaders(
  ResourceUrlResolver resolver,
  String resourceUrl,
  Map<String, String> headers,
) {
  final result = Map<String, String>.from(headers);
  if (!resolver.isServerResource(resourceUrl)) return result;

  final authenticated = resolver.authenticatedHeaders;
  if (authenticated.isEmpty) return result;

  final authenticatedKeys = authenticated.keys
      .map((key) => key.toLowerCase())
      .toSet();
  result.removeWhere((key, _) => authenticatedKeys.contains(key.toLowerCase()));
  result.addAll(authenticated);
  return result;
}

final class IdentityResourceUrlResolver implements ResourceUrlResolver {
  const IdentityResourceUrlResolver();

  @override
  String resolve(String resourceUrl) => resourceUrl;

  @override
  bool isServerResource(String resourceUrl) => false;

  @override
  Map<String, String> get authenticatedHeaders => const {};
}
