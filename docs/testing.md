# Testing and screenshots

## Default suite

`flutter test` is self-contained. UI tests construct immutable presentation
state, inject callbacks, and render production views at phone, tablet, and
desktop breakpoints. Network behavior is covered with in-process mock clients.
Test paths mirror production ownership: shared API contracts use
`test/contracts/`, shared API adapters use `test/data/synctv_api/`, and feature
tests live below `test/features/<feature>/`.

Running the root `flutter test` suite builds the `synctv_opaque` native asset
through its build hook, which invokes Cargo and therefore requires the Rust
toolchain. The fork's web path is pure Dart: web builds and the
`packages/passkeys_darwin` tests run without Rust. On a machine without Cargo,
root `flutter test` stops at the hook; per the workspace constraint
(`AGENTS.md`) do not install Rust to work around it — run the package-level
tests and web builds instead and treat root-suite verification as restricted.

```bash
fvm flutter analyze --fatal-infos
fvm flutter test
```

## OPAQUE web checks

The pure-Dart OPAQUE implementation in `packages/synctv_opaque` carries
standalone check tools under `packages/synctv_opaque/tool/` that run on the VM
without Cargo, so the web crypto path stays verifiable on machines without the
Rust toolchain:

```bash
cd packages/synctv_opaque
dart tool/check_ksf_web.dart          # key stretch function output
cd packages/synctv_opaque
dart tool/check_ksf_twice_web.dart    # deterministic output
cd packages/synctv_opaque
dart tool/check_ristretto_web.dart    # hash-to-curve scalar
cd packages/synctv_opaque
dart tool/check_envelope_roundtrip.dart  # tampered envelope is rejected
cd packages/synctv_opaque
dart tool/check_simulated_server.dart    # full simulated login, session match
cd packages/synctv_opaque
dart tool/check_web_login.dart           # web-path login roundtrip
```

The envelope roundtrip is a negative test: it prints `invalid envelope MAC`
and exits 0 when the tampered credential response is rejected, as expected.
`check_simulated_server.dart` prints `simulated server login ok` and
`session match true`; `check_web_login.dart` prints `login ok`.

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
