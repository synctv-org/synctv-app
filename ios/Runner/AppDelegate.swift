import fl_pip
import Flutter
import UIKit

@main
@objc class AppDelegate: FlFlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let channel = FlutterMethodChannel(
      name: "org.synctv.app/passkey_identity",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "getAppleIdentity" else {
        result(FlutterMethodNotImplemented)
        return
      }
      result(Self.appleIdentity())
    }
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
