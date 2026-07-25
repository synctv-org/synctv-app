import fl_pip
import Flutter
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
    let applicationIdentifier = Bundle.main.object(
      forInfoDictionaryKey: "SyncTVApplicationIdentifier"
    ) as? String ?? ""
    return [
      "applicationIdentifier": applicationIdentifier
    ]
  }
}
