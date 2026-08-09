import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:synctv_app/core/network/server_endpoint_identity.dart';

http.Client createServerHttpClient(
  String endpoint, {
  required bool allowInsecureTls,
}) {
  final uri = Uri.parse(ServerEndpointIdentity.normalize(endpoint));
  return IOClient(
    createServerIoHttpClient(uri, allowInsecureTls: allowInsecureTls),
  );
}

HttpClient createServerIoHttpClient(
  Uri endpoint, {
  required bool allowInsecureTls,
}) {
  final client = HttpClient();
  client.badCertificateCallback = (_, host, port) =>
      serverCertificateExceptionAllowed(
        endpoint: endpoint,
        allowInsecureTls: allowInsecureTls,
        host: host,
        port: port,
      );
  return client;
}

bool serverCertificateExceptionAllowed({
  required Uri endpoint,
  required bool allowInsecureTls,
  required String host,
  required int port,
}) {
  if (!allowInsecureTls || endpoint.scheme.toLowerCase() != 'https') {
    return false;
  }
  final endpointPort = endpoint.hasPort ? endpoint.port : 443;
  return endpoint.host.toLowerCase() == host.toLowerCase() &&
      endpointPort == port;
}
