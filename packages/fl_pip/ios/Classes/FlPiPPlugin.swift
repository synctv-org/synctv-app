import Flutter

public class FlPiPPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        PiPHelper.shared.setRegistrar(registrar)
        PiPHelper.shared.newFlutterMethodChannel(registrar.messenger())
    }
}
