import AuthenticationServices
import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  private var oauth2SessionController: DarwinOAuth2SessionController?

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    let authenticationRegistrar = flutterViewController.registrar(
      forPlugin: "SyncTVAuthenticationPlugin"
    )
    authenticationRegistrar.register(
      AppleSignInButtonFactory(messenger: authenticationRegistrar.messenger),
      withId: "org.synctv.app/apple_sign_in_button"
    )
    oauth2SessionController = DarwinOAuth2SessionController(
      messenger: authenticationRegistrar.messenger,
      window: self
    )

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
    let applicationIdentifier =
      Bundle.main.object(
        forInfoDictionaryKey: "SyncTVApplicationIdentifier"
      ) as? String ?? ""
    return [
      "applicationIdentifier": applicationIdentifier
    ]
  }
}

private final class AppleSignInButtonFactory: NSObject, FlutterPlatformViewFactory {
  private let messenger: FlutterBinaryMessenger

  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }

  func create(
    withViewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> NSView {
    AppleSignInButtonView(
      viewId: viewId,
      arguments: args as? [String: Any],
      messenger: messenger
    )
  }

  func createArgsCodec() -> (FlutterMessageCodec & NSObjectProtocol)? {
    FlutterStandardMessageCodec.sharedInstance()
  }
}

private final class AppleSignInButtonView: NSView {
  private let button: ASAuthorizationAppleIDButton
  private let channel: FlutterMethodChannel

  init(
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
    super.init(frame: .zero)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.target = self
    button.action = #selector(pressed)
    addSubview(button)
    NSLayoutConstraint.activate([
      button.leadingAnchor.constraint(equalTo: leadingAnchor),
      button.trailingAnchor.constraint(equalTo: trailingAnchor),
      button.topAnchor.constraint(equalTo: topAnchor),
      button.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) is unavailable")
  }

  @objc private func pressed() {
    channel.invokeMethod("pressed", arguments: nil)
  }
}

private final class DarwinOAuth2SessionController: NSObject,
  ASWebAuthenticationPresentationContextProviding
{
  private let channel: FlutterMethodChannel
  private weak var window: NSWindow?
  private var session: ASWebAuthenticationSession?
  private var pendingResult: FlutterResult?
  private var timeoutWorkItem: DispatchWorkItem?

  init(messenger: FlutterBinaryMessenger, window: NSWindow) {
    channel = FlutterMethodChannel(
      name: "org.synctv.app/darwin_oauth2",
      binaryMessenger: messenger
    )
    self.window = window
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
    window ?? NSWindow()
  }
}
