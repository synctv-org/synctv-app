import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:synctv_opaque/synctv_opaque.dart' as opaque;

Future<void> main(List<String> args) async {
  final baseUrl = args.isNotEmpty ? args[0] : 'http://127.0.0.1:8080';
  final username = args.length > 1 ? args[1] : 'root';
  final password = args.length > 2 ? args[2] : 'LocalDevRootPass2026!';

  final opaqueClient = opaque.SyncTvOpaqueClient();

  final start = opaqueClient.startLogin(password);
  final startResponse = await http.post(
    Uri.parse('$baseUrl/api/auth/opaque/login/start'),
    headers: {'content-type': 'application/json'},
    body: jsonEncode({
      'username': username,
      'credential_request': base64Encode(start.credentialRequest),
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
  final credentialResponse = base64Decode(
    challenge['credential_response'].toString(),
  );
  stdout.writeln(
    'session=$sessionId credentialResponse=${credentialResponse.length}',
  );

  final finish = opaqueClient.finishLogin(
    password: password,
    state: start.state,
    credentialResponse: Uint8List.fromList(credentialResponse),
  );
  stdout.writeln('finalization=${finish.credentialFinalization.length}');

  final finishResponse = await http.post(
    Uri.parse('$baseUrl/api/auth/opaque/login/finish'),
    headers: {'content-type': 'application/json'},
    body: jsonEncode({
      'session_id': sessionId,
      'credential_finalization': base64Encode(finish.credentialFinalization),
    }),
  );
  stdout.writeln(
    'finish status=${finishResponse.statusCode} body=${finishResponse.body}',
  );
}
