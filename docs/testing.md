# Testing and screenshots

## Default suite

`flutter test` is self-contained. UI tests construct immutable presentation
state, inject callbacks, and render production views at phone, tablet, and
desktop breakpoints. Network behavior is covered with in-process mock clients.
Test paths mirror production ownership: shared API contracts use
`test/contracts/`, shared API adapters use `test/data/synctv_api/`, and feature
tests live below `test/features/<feature>/`.

```bash
fvm flutter analyze --fatal-infos
fvm flutter test
```

## Store screenshots

The showcase entrypoint uses fixed English fixtures, the light theme, and the
same `HomeView` used by `HomeScreen`. It starts no server and performs no
network requests.

```bash
tool/generate_showcase_screenshots.sh
```

The generator first renders into `build/showcase/` at each device's native
pixel ratio. It copies all successful outputs into `fastlane/screenshots/`
after the render pass completes.

For interactive layout work, run the same offline showcase directly:

```bash
fvm flutter run -t tool/home_showcase.dart -d macos
```

## Real backend contracts

HTTP, protobuf, authentication, WebSocket, playback, upload, and destructive
business-flow checks remain explicit. Their commands and environment contract
are documented in [`integration_test/backend/README.md`](../integration_test/backend/README.md).
Run them against a disposable local SyncTV database.
