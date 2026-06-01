import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:synctv_opaque/synctv_opaque.dart' as opaque;

Future<void> main(List<String> args) async {
  final baseUrl = args.isNotEmpty ? args[0] : 'http://127.0.0.1:8080';
  final username = args.length > 1 ? args[1] : 'codexroot';
  final password = args.length > 2 ? args[2] : 'CodexRootPass2026!';

  final opaqueClient = opaque.SyncTvOpaqueClient();
  final start = opaqueClient.startRegistration(password);
  final startResponse = await http.post(
    Uri.parse('$baseUrl/api/auth/opaque/registration/start'),
    headers: {'content-type': 'application/json'},
    body: jsonEncode({
      'username': username,
      'email': '',
      'registration_request': base64Encode(start.registrationRequest),
    }),
  );
  stdout.writeln(
    'start status=${startResponse.statusCode} body=${startResponse.body}',
  );
  if (startResponse.statusCode < 200 || startResponse.statusCode >= 300) {
    return;
  }

  final challenge = jsonDecode(startResponse.body) as Map<String, dynamic>;
  final sessionId = challenge['session_id'].toString();
  final registrationResponse =
      base64Decode(challenge['registration_response'].toString());
  final finish = opaqueClient.finishRegistration(
    password: password,
    state: start.state,
    registrationResponse: Uint8List.fromList(registrationResponse),
  );

  final finishResponse = await http.post(
    Uri.parse('$baseUrl/api/auth/opaque/registration/finish'),
    headers: {'content-type': 'application/json'},
    body: jsonEncode({
      'session_id': sessionId,
      'registration_upload': base64Encode(finish.registrationUpload),
    }),
  );
  stdout.writeln(
    'finish status=${finishResponse.statusCode} body=${finishResponse.body}',
  );
}
