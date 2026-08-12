# OAuth2 callback configuration

Android runs OAuth2 sessions through `flutter_web_auth_2`. iOS and macOS use a
small app-owned bridge to AuthenticationServices so the app can cancel an
`ASWebAuthenticationSession` when its three-minute deadline expires.
AuthenticationServices retains the Apple-platform browser session and delivers
the matching HTTPS callback directly to the app.

Windows and Linux open the system browser and use a temporary loopback
callback URL:

```text
http://127.0.0.1:{port}/oauth2/callback
```

SyncTV binds the loopback HTTP listener before requesting the provider's
authorization URL and retains it for the complete authorization flow. This
removes the port race between choosing a callback URL and receiving the browser
redirect. SyncTV closes the listener on completion or failure and brings the
desktop window to the foreground after a valid callback.

Browser-based OAuth authorization on Android, iOS, and macOS uses an HTTPS
callback. Android opens an AndroidX Auth Tab. iOS and macOS open
`ASWebAuthenticationSession`. Use an HTTPS host without an explicit port:

```text
https://{verified-domain}/oauth2/callback
```

Build Android and Apple apps with a real callback domain:

```sh
flutter build apk --dart-define=SYNCTV_OAUTH2_APP_LINK_ORIGIN=https://app.example.com
flutter build ios --dart-define=SYNCTV_OAUTH2_APP_LINK_ORIGIN=https://app.example.com
flutter build macos --dart-define=SYNCTV_OAUTH2_APP_LINK_ORIGIN=https://app.example.com
```

The Android integration and the app-owned Apple browser integration pass the
HTTPS host and `/oauth2/callback` path directly to their system authentication
sessions.
The app's main Android activity has no OAuth callback intent filter.

macOS and iOS generate the signed entitlements from
`SYNCTV_OAUTH2_APP_LINK_ORIGIN` during the Xcode build. The resulting
associated-domain values are:

```text
applinks:app.example.com
webcredentials:app.example.com
```

The domain hosts the platform association files used by native credentials and
Apple Universal Links. Apple requires the `webcredentials` service for HTTPS
callbacks through `ASWebAuthenticationSession`, available on iOS 17.4 and
macOS 14.4 or newer.

## Native Sign in with Apple

iOS and Mac App Store builds use `ASAuthorizationAppleIDProvider` for native
Sign in with Apple. This flow omits `redirectUrl` and does not use
`SYNCTV_OAUTH2_APP_LINK_ORIGIN` or `/.well-known/apple-app-site-association`.
macOS Developer ID builds use the browser flow because Developer ID profiles do
not carry the restricted native Apple entitlement. Native clients send
`native=true` when starting authorization; the server uses the configured
`nativeClientId` and `nativeClientSecret` to exchange Apple's authorization
code.

The server advertises provider capabilities in `GET /api/oauth2/providers`.
When the Apple instance includes both `browser` and `native` in
`supportedModes`, iOS and Mac App Store builds choose native authorization.
macOS Developer ID builds choose browser authorization. When only `browser` is
configured, the same Apple button automatically starts the browser session
through `ASWebAuthenticationSession`. Android, Windows, Linux, and web choose
browser authorization. The client hides a provider when its supported modes
cannot run on the current platform.

The official app Bundle ID is `org.synctv.app`. A self-hosted operator normally
cannot obtain the official Apple Developer Team credentials, so a self-hosted
Apple distribution should use its own Apple Developer Team, Bundle ID, signing
profile, and server-side native client secret. The Bundle ID in the signed app
must equal the server's `nativeClientId`.
