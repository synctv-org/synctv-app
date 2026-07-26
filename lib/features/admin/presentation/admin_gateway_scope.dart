import 'package:flutter/widgets.dart';
import 'package:synctv_app/core/network/resource_url_resolver.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/admin/application/admin_gateway.dart';

extension AdminGatewayContextAccess on BuildContext {
  AdminGateway get adminGateway => DependencyScope.read<AdminGateway>(this);

  ResourceUrlResolver get resourceUrlResolver =>
      DependencyScope.read<ResourceUrlResolver>(this);
}

extension AdminGatewayStateAccess<T extends StatefulWidget> on State<T> {
  AdminGateway get adminGateway => context.adminGateway;
}
