# Frontend Dependency Audit

Checked on 2026-09-08 with Flutter 3.47.2 / Dart 3.13.2.
This records dependency resolution and the stated verification scope.
It is not a complete security, native-device or performance audit.

## Updated Packages

| Package | Previous | Current | Review |
| --- | --- | --- | --- |
| flutter_webrtc | 1.6.1 | 1.6.2 | Published 2026-09-07. Adds opt-in WARP and zero-playout-delay initialization options on native platforms. Both remain disabled by default. Dart Web implementation is unchanged. |
| platform | 3.1.6 | 3.2.0 | Transitive dependency through path_provider_platform_interface. Introduces new platform APIs; legacy APIs remain available through compatibility wrappers. Application code has no direct package imports. |

The WebRTC native change also updates Windows/Linux libwebrtc from
m150.7871.00 to m150.7871.01. Darwin retains the 150.7871.01 binary and changes
field-trial configuration. WARP is experimental and process-wide; enabling it
requires native peer interoperability and connection-time measurements.
Zero playout delay trades jitter smoothing for latency and needs separate
adverse-network testing.

## Constrained Updates

The post-upgrade resolver reports no remaining upgradable packages under the
current constraints. These newer transitive releases cannot currently resolve:

| Package | Resolved | Latest Reported | Constraint Owner |
| --- | --- | --- | --- |
| cli_util | 0.4.2 | 0.6.0 | flutter_launcher_icons 0.14.4 requires ^0.4.1 |
| flex_seed_scheme | 4.0.1 | 5.0.1 | flex_color_scheme 8.4.0 requires ^4.0.0 |
| material_color_utilities | 0.13.0 | 0.13.1 | Flutter SDK pins 0.13.0 |
| qr | 3.0.2 | 4.0.0 | qr_flutter 4.1.0 requires ^3.0.1 |
| test_api | 0.7.12 | 0.7.14 | flutter_test pins 0.7.12 |

No overrides were added to bypass these constraints. The existing
passkeys_darwin fork remains based on the latest published 0.4.3+3; its removal
criteria remain in the package README. Upstream unreleased changes were not
re-audited in this pass.

## Verification and Follow-up

- flutter pub get --enforce-lockfile succeeds.
- Full 2467 Flutter tests, analysis, architecture and UI guards pass.
- Release Web and debug macOS builds pass.
- Edge exercises production startup, room category filtering and the mobile
  login dialog in dark mode at 1200x900 and 320x568.
- Multi-device native voice/P2P and Android/iOS/Windows/Linux builds remain
  unverified for this upgrade. No measured performance improvement is claimed.
- media_kit_libs_macos_video and media_kit_video still fall back to CocoaPods;
  Flutter warns that missing Swift Package Manager support will become an error.
- Vendored JavaScript, Rust dependencies and packaging dependencies require
  their own follow-up audit.

Package release information:
[flutter_webrtc](https://pub.dev/packages/flutter_webrtc/changelog),
[platform](https://pub.dev/packages/platform/changelog).

## Packaging And Rust Recheck (Pass 262)

Rechecked on 2026-09-08. `flutter pub outdated --json` still reports only the
five constrained transitive versions above, with no upgradable or resolvable
newer release in that output. This does not audit every hosted/native binary.

The DMG packaging lockfile now resolves `@xmldom/xmldom` 0.9.12 instead of
0.9.10, within the existing `plist` dependency constraint. Only this package's
version, URL and integrity changed. This removes the locked version affected by
[GHSA-6gmq-8vp8-gcm6](https://github.com/advisories/GHSA-6gmq-8vp8-gcm6).
The application does not directly use this DOM serializer: create-dmg uses
plist parsing, and plist construction uses xmlbuilder. No reachable application
XML injection was demonstrated. The update still removes the affected parser
version from the packaging toolchain.

Verification:

- Clean npm dependency installation and native addon rebuild succeeded.
- Invalid entity-reference creation and strict serialization reject the advisory
  payload; a valid reference still serializes. Plist values including XML-sensitive
  display text round-trip correctly.
- create-dmg generated a real unsigned DMG from an existing debug app bundle;
  `hdiutil verify` confirmed its checksum is valid.
  This checks packaging, not a new native application build or signed release.
- The first local invocation mixed Node runtimes and failed the native-addon ABI
  check. Rebuilding/running in the same environment succeeded. CI uses Node 24;
  this local packaging check used Node 23 and does not replace a CI release run.
- Post-update npm audit reports zero moderate vulnerabilities and three high
  affected package entries: image-size, appdmg and create-dmg. These three entries
  derive from two image-size advisories, not three independent root defects.

### Remaining Packaging Advisories

The registry's latest image-size is still 2.0.2, and all published versions are
affected by [GHSA-w3rx-r6r6-pgpr](https://github.com/advisories/GHSA-w3rx-r6r6-pgpr)
and [GHSA-5p2g-fcmc-qvqq](https://github.com/advisories/GHSA-5p2g-fcmc-qvqq).
The installed appdmg 0.6.6 depends on image-size ^0.7.4 (locked 0.7.5).
An ordinary version upgrade cannot currently remove these advisories.

The reviewed appdmg call reads background dimensions; create-dmg supplies its
own packaged `assets/dmg-background.png`. The release script exposes no custom
background input. Application icon composition uses a separate icns-lib path.
This limits the current reachable input to an integrity-locked tool asset, but
does not repair image-size or prove every build-input/supply-chain scenario.
The audit remains nonzero; no advisory suppression or incompatible override was
added. Reassess a patched upstream release or a supported packaging replacement.

### Rust Advisory Coverage

`cargo audit` on the native OPAQUE lockfile (60 dependencies) and its web Wasm
lockfile (48 dependencies) reports zero vulnerabilities and no informational
warnings. Both used advisory database commit
`8a1eb4f933fb5821add5b4e98601ebd90b8b3538`, updated 2026-09-07.
This is a known-advisory check of these two resolved graphs, not an audit of
cryptographic protocol correctness, Rust version freshness or native binaries.
Evidence is in the `pass262-*` review logs. Vendored media JavaScript, native
platform dependencies and signed distribution remain separate follow-up work.

## Vendored Playback Recheck (Pass 263)

Updated HLS.js 1.7.1 to 1.7.2, published 2026-09-02. The
[release notes](https://github.com/video-dev/hls.js/releases/tag/v1.7.2)
include fixes for duration collapse when seeking into an end-of-stream gap,
blocking low-latency reload for MSN 0, WebVTT parts, IMSC1 timing and variable
substitution after playlist parse errors. These are upstream fixes; this pass
does not independently reproduce every listed defect or claim measured speedups.
Registry latest versions of dashjs (5.2.1) and mpegts.js (1.8.2) match the
vendored versions and remain unchanged.

The HLS asset and license come unchanged from npm `hls.js@1.7.2`.
The downloaded archive matches registry integrity
`sha512-CW/pPvSOFIRsosbwxrYaE9ERmpTo5fbTqL7wCvuCFlqW1Bmb1K5fXsY7yiH95rmlr4rVuA7UXHbM/cIXQ6AXwg==`.
The runtime now references `playback/hls-1.7.2.min.js` with
`sha256-r83gdDfshLBy/oeC53LOtQRurHUbJxn3OuDYPXY7w/U=`.
All three configured playback SRI hashes match their local assets. Versioned
filenames preserve the Service Worker's immutable playback-cache contract.
The fresh production output contains the new HLS asset and no 1.7.1 asset.

Verification: 2698 application tests, 16 local player-package tests, 22 Service
Worker tests, analysis, architecture/UI guards and production/fixture release
Web builds pass. Browser Use in Edge verifies the production VideoPlayer runtime
with a local 640x360, 24-second HLS fixture. Edge supports native HLS, so the
fixture's `?mse` mode overrides only that capability probe to exercise HLS.js;
the visible runtime version is 1.7.2. Desktop and 320x568 screenshots show video,
accessible controls and advancing position after seeking to 12 seconds, with
24-second duration retained at completion. The initial native HLS run also
reached the end. This fixture is separate from authenticated room UI.

The fixture does not cover end gaps, live/low-latency playlists, subtitles,
adaptive renditions, DRM, Safari/native devices or every codec combination.
Loader timeout/retry ownership and other vendored scripts need further review.
Build/test logs use the `pass263-*` prefix.
