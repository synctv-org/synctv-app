# OAuth2 callback configuration

SyncTV does not use custom URL schemes for OAuth2 callbacks.

Desktop builds use a temporary loopback callback URL:

```text
http://127.0.0.1:{port}/oauth2/callback
```

Mobile builds use HTTPS App Links / Universal Links. Plain HTTP is not
accepted for mobile callback origins. Use a normal HTTPS host without an
explicit port because Android App Links and Apple Universal Links are verified
at the domain level:

```text
https://{verified-domain}/oauth2/callback
```

Build mobile apps with a real verified domain:

```sh
flutter build apk --dart-define=SYNCTV_OAUTH2_APP_LINK_ORIGIN=https://app.example.com
flutter build ios --dart-define=SYNCTV_OAUTH2_APP_LINK_ORIGIN=https://app.example.com
```

Android reads the host from `SYNCTV_OAUTH2_APP_LINK_ORIGIN` and places it in
the manifest App Link filter. Values with a scheme, path, or port are rejected.
It can be overridden with:

```sh
./gradlew assembleRelease -PsyncTvOauth2AppLinkHost=app.example.com
```

iOS generates the signed entitlements from
`SYNCTV_OAUTH2_APP_LINK_ORIGIN` during the Xcode build. The resulting
associated-domain value is:

```text
applinks:app.example.com
```

The domain must host the platform association files required by Android App
Links and Apple Universal Links before OAuth2 login or binding will complete on
mobile builds.
