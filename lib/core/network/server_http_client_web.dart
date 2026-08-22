import 'package:http/http.dart' as http;

http.Client createServerHttpClient(
  String endpoint, {
  required bool allowInsecureTls,
}) => http.Client();

Never createServerIoHttpClient(
  Uri endpoint, {
  required bool allowInsecureTls,
}) => throw UnsupportedError('dart:io HttpClient is unavailable in browsers.');

bool serverCertificateExceptionAllowed({
  required Uri endpoint,
  required bool allowInsecureTls,
  required String host,
  required int port,
}) => false;
