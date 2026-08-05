# OAuth2 callback configuration

Android, Windows, and Linux run OAuth2 sessions through `flutter_web_auth_2`.
iOS and macOS use a small app-owned bridge to AuthenticationServices so the
app can cancel an `ASWebAuthenticationSession` when its three-minute deadline
expires.

Windows and Linux open the system browser and use a temporary loopback
callback URL:

```text
http://127.0.0.1:{port}/oauth2/callback
```

The package owns the loopback HTTP listener. SyncTV probes an available port,
passes the resulting redirect URL to the backend, and retries the complete
authorization start when another process claims that port before the listener
starts.

Android, iOS, and macOS builds use an HTTPS callback. Android opens an AndroidX
Auth Tab. iOS and macOS open `ASWebAuthenticationSession`. Use an HTTPS host
without an explicit port:

```text
https://{verified-domain}/oauth2/callback
```

Build Android and Apple apps with a real callback domain:

```sh
flutter build apk --dart-define=SYNCTV_OAUTH2_APP_LINK_ORIGIN=https://app.example.com
flutter build ios --dart-define=SYNCTV_OAUTH2_APP_LINK_ORIGIN=https://app.example.com
flutter build macos --dart-define=SYNCTV_OAUTH2_APP_LINK_ORIGIN=https://app.example.com
```

The Android integration and the app-owned Apple integration pass the HTTPS host
and `/oauth2/callback` path directly to their system authentication sessions.
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
