abstract interface class ResourceUrlResolver {
  String resolve(String resourceUrl);

  Map<String, String> get authenticatedHeaders;
}

final class IdentityResourceUrlResolver implements ResourceUrlResolver {
  const IdentityResourceUrlResolver();

  @override
  String resolve(String resourceUrl) => resourceUrl;

  @override
  Map<String, String> get authenticatedHeaders => const {};
}
