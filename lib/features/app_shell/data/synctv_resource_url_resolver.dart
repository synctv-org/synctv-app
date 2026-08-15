import 'package:synctv_app/core/network/resource_url_resolver.dart';
import 'package:synctv_app/data/synctv_api/synctv_service.dart';

final class SyncTvResourceUrlResolver implements ResourceUrlResolver {
  const SyncTvResourceUrlResolver();

  @override
  String resolve(String resourceUrl) =>
      SyncTvService.resolveResourceUrl(resourceUrl);

  @override
  bool isServerResource(String resourceUrl) =>
      isServerApiResourceUrl(resolve(resourceUrl), SyncTvService.baseUrl);

  @override
  Map<String, String> get authenticatedHeaders =>
      SyncTvService.authenticatedResourceHeaders;
}
