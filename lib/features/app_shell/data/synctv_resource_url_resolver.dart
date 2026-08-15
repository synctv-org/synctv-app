import 'package:synctv_app/core/network/resource_url_resolver.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';

final class SyncTvResourceUrlResolver implements ResourceUrlResolver {
  const SyncTvResourceUrlResolver();

  @override
  String resolve(String resourceUrl) =>
      SyncTvService.resolveResourceUrl(resourceUrl);

  @override
  bool isServerResource(String resourceUrl) {
    final resource = Uri.tryParse(resolve(resourceUrl));
    final server = Uri.tryParse(SyncTvService.baseUrl);
    return resource != null &&
        server != null &&
        resource.scheme == server.scheme &&
        resource.host == server.host &&
        resource.port == server.port;
  }

  @override
  Map<String, String> get authenticatedHeaders =>
      SyncTvService.authenticatedResourceHeaders;
}
