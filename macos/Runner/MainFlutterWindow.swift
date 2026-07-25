import Cocoa
import FlutterMacOS
import Security

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
    guard let task = SecTaskCreateFromSelf(nil) else { return [:] }
    let applicationIdentifier =
      entitlement(task, "application-identifier") as? String ??
      entitlement(task, "com.apple.application-identifier") as? String ?? ""
    let associatedDomains =
      entitlement(task, "com.apple.developer.associated-domains") as? [String] ?? []
    return [
      "applicationIdentifier": applicationIdentifier,
      "associatedDomains": associatedDomains,
    ]
  }

  private static func entitlement(_ task: SecTask, _ name: String) -> CFTypeRef? {
    SecTaskCopyValueForEntitlement(task, name as CFString, nil)
  }
}
