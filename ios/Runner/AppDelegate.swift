import fl_pip
import Flutter
import Security
import UIKit

@main
@objc class AppDelegate: FlFlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let controller = window?.rootViewController as? FlutterViewController {
      let channel = FlutterMethodChannel(
        name: "org.synctv.app/passkey_identity",
        binaryMessenger: controller.binaryMessenger
      )
      channel.setMethodCallHandler { call, result in
        guard call.method == "getAppleIdentity" else {
          result(FlutterMethodNotImplemented)
          return
        }
        result(Self.appleIdentity())
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func registerPlugin(_ registry: FlutterPluginRegistry) {
    GeneratedPluginRegistrant.register(with: registry)
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
