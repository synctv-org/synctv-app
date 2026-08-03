# OAuth2 callback configuration

SyncTV does not use custom URL schemes for OAuth2 callbacks.

Windows and Linux builds use a temporary loopback callback URL:

```text
http://127.0.0.1:{port}/oauth2/callback
```

Android, iOS, and macOS builds use HTTPS App Links / Universal Links. Apple
platforms open OAuth providers in `ASWebAuthenticationSession`, which keeps
authentication inside the app. Use a normal HTTPS host without an explicit
port because platform association files are verified at the domain level:

```text
https://{verified-domain}/oauth2/callback
```

Build mobile apps with a real verified domain:

```sh
flutter build apk --dart-define=SYNCTV_OAUTH2_APP_LINK_ORIGIN=https://app.example.com
flutter build ios --dart-define=SYNCTV_OAUTH2_APP_LINK_ORIGIN=https://app.example.com
flutter build macos --dart-define=SYNCTV_OAUTH2_APP_LINK_ORIGIN=https://app.example.com
```

Android reads the host from `SYNCTV_OAUTH2_APP_LINK_ORIGIN` and places it in
the manifest App Link filter. Values with a scheme, path, or port are rejected.
It can be overridden with:

```sh
./gradlew assembleRelease -PsyncTvOauth2AppLinkHost=app.example.com
```

macOS and iOS generate the signed entitlements from
`SYNCTV_OAUTH2_APP_LINK_ORIGIN` during the Xcode build. The resulting
associated-domain values are:

```text
applinks:app.example.com
webcredentials:app.example.com
```

The domain must host the platform association files required by Android App
Links and Apple Universal Links. Apple requires the `webcredentials` service
for HTTPS callbacks through `ASWebAuthenticationSession`, which requires iOS
17.4 or macOS 14.4.
