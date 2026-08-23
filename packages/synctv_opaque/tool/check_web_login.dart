import 'package:synctv_opaque/src/opaque/opaque_client.dart';
import 'package:synctv_opaque/src/opaque/serialization.dart';

Future<void> main() async {
  final client = OpaqueProtocolClient(ksf: (input) async => input);
  final password = hexToBytes(
    '436f7272656374486f72736542617474657279537461706c65',
  );
  final start = await client.startLogin(
    password,
    blindScalar: hexToBytes(
      '6ecc102d2e7a7cf49617aad7bbe188556792d4acd60a1a8a8d2b65d4b0790308',
    ),
    clientEphemeralSeed: hexToBytes(
      '82850a697b42a505f5b68fcdafce8c31f0af2b581f063cf1091933541936304b',
    ),
    clientNonce: hexToBytes(
      'da7e07376d6d6f034cfa9bb537d11b8c6b4238c334333d1f0aebb380cae6a6cc',
    ),
  );
  final finish = await client.finishLogin(
    password: password,
    state: start.state,
    context: hexToBytes('4f50415155452d504f43'),
    credentialResponse: hexToBytes(
      '7e308140890bcde30cbcea28b01ea1ecfbd077cff62c4def8efa075aabcbb471'
      '38fe59af0df2c79f57b8780278f5ae47355fe1f817119041951c80f612fdfc6d'
      'd6ec60bcdb26dc455ddf3e718f1020490c192d70dfc7e403981179d8073d1146'
      'a4f9aa1ced4e4cd984c657eb3b54ced3848326f70331953d91b02535af44d9fe'
      'dc80188ca46743c52786e0382f95ad85c08f6afcd1ccfbff95e2bdeb015b166c'
      '6b20b92f832cc6df01e0b86a7efd92c1c804ff865781fa93f2f20b446c8371b6'
      '71cd9960ecef2fe0d0f7494986fa3d8b2bb01963537e60efb13981e138e3d4a1'
      'c4f62198a9d6fa9170c42c3c71f1971b29eb1d5d0bd733e40816c91f7912cc4a'
      '660c48dae03e57aaa38f3d0cffcfc21852ebc8b405d15bd6744945ba1a93438a'
      '162b6111699d98a16bb55b7bdddfe0fc5608b23da246e7bd73b47369169c5c90',
    ),
  );
  final expectedFinalization =
      '4455df4f810ac31a6748835888564b536e6da5d9944dfea9e34defb9575fe5e2'
      '661ef61d2ae3929bcf57e53d464113d364365eb7d1a57b629707ca48da18e442';
  final expectedSessionKey =
      '42afde6f5aca0cfa5c163763fbad55e73a41db6b41bc87b8e7b62214a8eedc67'
      '31fa3cb857d657ab9b3764b89a84e91ebcb4785166fbb02cedfcbdfda215b96f';
  print(
    bytesToHex(finish.credentialFinalization) == expectedFinalization &&
            bytesToHex(finish.sessionKey) == expectedSessionKey
        ? 'login ok'
        : 'login mismatch',
  );
}
