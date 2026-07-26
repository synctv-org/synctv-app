import 'package:flutter/widgets.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/network/resource_url_resolver.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';

extension ProviderGatewayStateAccess<T extends StatefulWidget> on State<T> {
  ProviderGateway get providerGateway =>
      DependencyScope.read<ProviderGateway>(context);

  ResourceUrlResolver get resourceUrlResolver =>
      DependencyScope.read<ResourceUrlResolver>(context);
}
