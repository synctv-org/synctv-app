import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/services/xml_parser.dart';

void main() {
  test('MuteParser reads DLNA CurrentMute state', () {
    const mutedResponse = '''
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body>
    <u:GetMuteResponse xmlns:u="urn:schemas-upnp-org:service:RenderingControl:1">
      <CurrentMute>1</CurrentMute>
    </u:GetMuteResponse>
  </s:Body>
</s:Envelope>
''';
    const audibleResponse = '''
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
  <s:Body>
    <u:GetMuteResponse xmlns:u="urn:schemas-upnp-org:service:RenderingControl:1">
      <CurrentMute>0</CurrentMute>
    </u:GetMuteResponse>
  </s:Body>
</s:Envelope>
''';

    expect(MuteParser(mutedResponse).muted, isTrue);
    expect(MuteParser(audibleResponse).muted, isFalse);
  });
}
