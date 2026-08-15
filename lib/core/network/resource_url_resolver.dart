abstract interface class ResourceUrlResolver {
  String resolve(String resourceUrl);

  bool isServerResource(String resourceUrl);

  Map<String, String> get authenticatedHeaders;
}

/// Returns whether [resourceUrl] belongs to the configured SyncTV API.
bool isServerApiResourceUrl(String resourceUrl, String serverBaseUrl) {
  final resource = Uri.tryParse(resourceUrl);
  final server = Uri.tryParse(serverBaseUrl);
  if (resource == null || server == null) return false;
  if (resource.scheme != server.scheme ||
      resource.host != server.host ||
      resource.port != server.port) {
    return false;
  }

  final basePath = server.path.endsWith('/')
      ? server.path.substring(0, server.path.length - 1)
      : server.path;
  final apiPath = '$basePath/api';
  return resource.path == apiPath || resource.path.startsWith('$apiPath/');
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
