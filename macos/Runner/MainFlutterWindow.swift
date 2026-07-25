import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    let passkeyIdentityChannel = FlutterMethodChannel(
      name: "org.synctv.app/passkey_identity",
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    passkeyIdentityChannel.setMethodCallHandler { call, result in
      guard call.method == "getAppleIdentity" else {
        result(FlutterMethodNotImplemented)
        return
      }
      result(Self.appleIdentity())
    }

    super.awakeFromNib()
  }

  private static func appleIdentity() -> [String: Any] {
    let applicationIdentifier = Bundle.main.object(
      forInfoDictionaryKey: "SyncTVApplicationIdentifier"
    ) as? String ?? ""
    return [
      "applicationIdentifier": applicationIdentifier
    ]
  }
}
