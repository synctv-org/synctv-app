# passkeys_darwin

SyncTV vendors this iOS and macOS implementation while required fixes are
pending upstream in [corbado/flutter-passkeys][upstream].

## Fork rationale

The fork is based on the published `passkeys_darwin 0.4.3+3` package. The
upstream `main` branch was last checked on 2026-08-18 at
[`a1fdabef92a8bd6d4c59f0c9bbf41df295a75f10`][checked-commit]. It still had the
following defects:

1. Registration and authentication preserve WebAuthn `userVerification` in
   `passkeys_platform_interface`, then drop it at the Darwin Pigeon boundary.
   AuthenticationServices consequently uses Apple's `preferred` default even
   when the relying party requested `required`. This fork forwards the value
   and applies it to platform and security-key registration and assertion
   requests.
2. Overlapping operations share an unsafe controller lifecycle. The published
   implementation contains an unmatched `NSLock.unlock()` and allows an older
   completion callback to clear a newer controller. This fork assigns each
   operation an ID, cancels displaced operations outside the lock, and only
   clears the matching operation.
3. A successful registration can contain a nil `rawAttestationObject`. This
   fork handles that value without force-unwrapping it.

The root `pubspec.yaml` selects this package through `dependency_overrides`.

## Returning to upstream

For every newer `passkeys_darwin` release, compare its Dart, Pigeon, and Swift
paths with this fork. Restore the hosted package after upstream satisfies all
of these checks:

- `userVerification` reaches all four native request variants: platform and
  security-key registration and assertion.
- Replacing an in-flight request is race-safe, and a late callback only clears
  its own operation.
- Registration handles a nil `rawAttestationObject` safely.
- `flutter test packages/passkeys_darwin` passes after the dependency override
  is removed and the tests are adapted to the upstream API.
- The root `dart analyze` and Flutter test suite pass with the hosted package.

Delete `packages/passkeys_darwin` and the root dependency override together
once those conditions are met.

[upstream]: https://github.com/corbado/flutter-passkeys/tree/main/packages/passkeys/passkeys_darwin
[checked-commit]: https://github.com/corbado/flutter-passkeys/commit/a1fdabef92a8bd6d4c59f0c9bbf41df295a75f10

## Usage

This package is [endorsed][endorsed_link], which means you can simply use `passkeys`
normally. This package will be automatically included in your app when you do.

[endorsed_link]: https://flutter.dev/docs/development/packages-and-plugins/developing-packages#endorsed-federated-plugin
