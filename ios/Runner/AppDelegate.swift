import AuthenticationServices
import CryptoKit
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var oauth2SessionController: DarwinOAuth2SessionController?
  private var appleAuthorizationController: NativeAppleAuthorizationController?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(
      forPlugin: "SyncTVAuthenticationPlugin"
    ) {
      registrar.register(
        AppleSignInButtonFactory(messenger: registrar.messenger()),
        withId: "org.synctv.app/apple_sign_in_button"
      )
      oauth2SessionController = DarwinOAuth2SessionController(
        messenger: registrar.messenger()
      )
      appleAuthorizationController = NativeAppleAuthorizationController(
        messenger: registrar.messenger()
      )
    }
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

  private static func appleIdentity() -> [String: Any] {
    let applicationIdentifier =
      Bundle.main.object(
        forInfoDictionaryKey: "SyncTVApplicationIdentifier"
      ) as? String ?? ""
    return [
      "applicationIdentifier": applicationIdentifier
    ]
  }
}

private final class NativeAppleAuthorizationController: NSObject,
  ASAuthorizationControllerDelegate,
  ASAuthorizationControllerPresentationContextProviding
{
  private let channel: FlutterMethodChannel
  private var controller: ASAuthorizationController?
  private var pendingResult: FlutterResult?

  init(messenger: FlutterBinaryMessenger) {
    channel = FlutterMethodChannel(
      name: "org.synctv.app/apple_sign_in",
      binaryMessenger: messenger
    )
    super.init()
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "authorize" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self?.authorize(call.arguments, result: result)
    }
  }

  private func authorize(_ rawArguments: Any?, result: @escaping FlutterResult) {
    guard controller == nil else {
      result(FlutterError(code: "IN_PROGRESS", message: "Apple authorization is already active", details: nil))
      return
    }
    guard
      let arguments = rawArguments as? [String: Any],
      let state = arguments["state"] as? String, !state.isEmpty,
      let nonce = arguments["nonce"] as? String, !nonce.isEmpty
    else {
      result(FlutterError(code: "INVALID_ARGUMENTS", message: "Apple authorization arguments are invalid", details: nil))
      return
    }

    let request = ASAuthorizationAppleIDProvider().createRequest()
    request.requestedScopes = [.fullName, .email]
    request.state = state
    request.nonce = Self.sha256Hex(nonce)
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    pendingResult = result
    controller = authorizationController
    authorizationController.performRequests()
  }

  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    guard
      let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
      let authorizationCode = credential.authorizationCode,
      let code = String(data: authorizationCode, encoding: .utf8),
      let state = credential.state
    else {
      finish(FlutterError(code: "INVALID_RESPONSE", message: "Apple authorization did not return a valid code", details: nil))
      return
    }
    finish(["code": code, "state": state])
  }

  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithError error: Error
  ) {
    let code = (error as? ASAuthorizationError)?.code == .canceled
      ? "CANCELED"
      : "AUTHENTICATION_FAILED"
    finish(FlutterError(code: code, message: error.localizedDescription, details: nil))
  }

  private func finish(_ value: Any?) {
    let result = pendingResult
    pendingResult = nil
    controller = nil
    result?(value)
  }

  private static func sha256Hex(_ value: String) -> String {
    SHA256.hash(data: Data(value.utf8))
      .map { String(format: "%02x", $0) }
      .joined()
  }

  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    let windows = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap(\.windows)
    return windows.first(where: \.isKeyWindow) ?? windows.first ?? UIWindow()
  }
}

private final class AppleSignInButtonFactory: NSObject, FlutterPlatformViewFactory {
  private let messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    AppleSignInPlatformView(
      frame: frame,
      viewId: viewId,
      arguments: args as? [String: Any],
      messenger: messenger
    )
  }

  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    FlutterStandardMessageCodec.sharedInstance()
  }
}

private final class AppleSignInPlatformView: NSObject, FlutterPlatformView {
  private let button: ASAuthorizationAppleIDButton
  private let channel: FlutterMethodChannel

  init(
    frame: CGRect,
    viewId: Int64,
    arguments: [String: Any]?,
    messenger: FlutterBinaryMessenger
  ) {
    let style: ASAuthorizationAppleIDButton.Style =
      arguments?["style"] as? String == "white" ? .white : .black
    button = ASAuthorizationAppleIDButton(type: .continue, style: style)
    channel = FlutterMethodChannel(
      name: "org.synctv.app/apple_sign_in_button/\(viewId)",
      binaryMessenger: messenger
    )
    super.init()
    button.frame = frame
    button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
  }

  func view() -> UIView {
    button
  }

  @objc private func pressed() {
    channel.invokeMethod("pressed", arguments: nil)
  }
}

private final class DarwinOAuth2SessionController: NSObject,
  ASWebAuthenticationPresentationContextProviding
{
  private let channel: FlutterMethodChannel
  private var session: ASWebAuthenticationSession?
  private var pendingResult: FlutterResult?
  private var timeoutWorkItem: DispatchWorkItem?

  init(messenger: FlutterBinaryMessenger) {
    channel = FlutterMethodChannel(
      name: "org.synctv.app/darwin_oauth2",
      binaryMessenger: messenger
    )
    super.init()
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "authorize":
      authorize(call.arguments, result: result)
    case "cancel":
      finish(
        FlutterError(
          code: "CANCELED",
          message: "OAuth2 authorization was canceled",
          details: nil
        ),
        cancelSession: true
      )
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func authorize(_ rawArguments: Any?, result: @escaping FlutterResult) {
    guard session == nil else {
      result(
        FlutterError(
          code: "IN_PROGRESS",
          message: "An OAuth2 authorization session is already active",
          details: nil
        )
      )
      return
    }
    guard
      let arguments = rawArguments as? [String: Any],
      let urlString = arguments["url"] as? String,
      let url = URL(string: urlString),
      let callbackHost = arguments["callbackHost"] as? String,
      let callbackPath = arguments["callbackPath"] as? String,
      let timeoutSeconds = arguments["timeoutSeconds"] as? Int,
      timeoutSeconds > 0
    else {
      result(
        FlutterError(
          code: "INVALID_ARGUMENTS",
          message: "OAuth2 authorization arguments are invalid",
          details: nil
        )
      )
      return
    }

    pendingResult = result
    let authenticationSession = ASWebAuthenticationSession(
      url: url,
      callback: .https(host: callbackHost, path: callbackPath)
    ) { [weak self] callbackURL, error in
      self?.complete(callbackURL: callbackURL, error: error)
    }
    authenticationSession.presentationContextProvider = self
    authenticationSession.prefersEphemeralWebBrowserSession = false
    session = authenticationSession

    let timeout = DispatchWorkItem { [weak self] in
      self?.finish(
        FlutterError(
          code: "TIMED_OUT",
          message: "OAuth2 authorization timed out",
          details: nil
        ),
        cancelSession: true
      )
    }
    timeoutWorkItem = timeout
    DispatchQueue.main.asyncAfter(
      deadline: .now() + .seconds(timeoutSeconds),
      execute: timeout
    )

    if !authenticationSession.start() {
      finish(
        FlutterError(
          code: "START_FAILED",
          message: "Could not start OAuth2 authorization",
          details: nil
        ),
        cancelSession: true
      )
    }
  }

  private func complete(callbackURL: URL?, error: Error?) {
    if let error {
      if case ASWebAuthenticationSessionError.canceledLogin = error {
        finish(
          FlutterError(
            code: "CANCELED",
            message: "OAuth2 authorization was canceled",
            details: nil
          )
        )
      } else {
        finish(
          FlutterError(
            code: "AUTHENTICATION_FAILED",
            message: error.localizedDescription,
            details: nil
          )
        )
      }
      return
    }
    guard let callbackURL else {
      finish(
        FlutterError(
          code: "EMPTY_CALLBACK",
          message: "OAuth2 authorization returned an empty callback",
          details: nil
        )
      )
      return
    }
    finish(callbackURL.absoluteString)
  }

  private func finish(_ value: Any?, cancelSession: Bool = false) {
    guard let result = pendingResult else { return }
    let activeSession = session
    pendingResult = nil
    session = nil
    timeoutWorkItem?.cancel()
    timeoutWorkItem = nil
    if cancelSession {
      activeSession?.cancel()
    }
    result(value)
  }

  func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
    let windows = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap(\.windows)
    return windows.first(where: \.isKeyWindow) ?? windows.first ?? UIWindow()
  }
}
