# passkeys_darwin

SyncTV vendors this iOS and macOS implementation while required fixes are
pending upstream in [corbado/flutter-passkeys][upstream].

## Fork rationale

The fork is based on the published `passkeys_darwin 0.4.5` package. The
upstream `main` branch was last checked on 2026-09-28 at
[`8c9e5b50b386fbb555eded63473a75fdb7fafbd1`][checked-commit]. Upstream 0.4.4
fixed the `userVerification` forwarding defect this fork originally carried
([#309](https://github.com/corbado/flutter-passkeys/pull/309)), so the fork now
uses the upstream implementation for that path. It still had the following
defects:

1. Overlapping operations share an unsafe controller lifecycle. The published
   implementation contains an unmatched `NSLock.unlock()` in the registration
   completion and allows an older completion callback to clear a newer
   controller. This fork assigns each operation an ID, cancels displaced
   operations outside the lock, and only clears the matching operation.
2. A successful registration can contain a nil `rawAttestationObject`. This
   fork handles that value without force-unwrapping it.

The root `pubspec.yaml` selects this package through `dependency_overrides`.

## Returning to upstream

For every newer `passkeys_darwin` release, compare its Dart, Pigeon, and Swift
paths with this fork. Restore the hosted package after upstream satisfies all
of these checks:

- Replacing an in-flight request is race-safe, and a late callback only clears
  its own operation.
- Registration handles a nil `rawAttestationObject` safely.
- `flutter test packages/passkeys_darwin` passes after the dependency override
  is removed.

[upstream]: https://github.com/corbado/flutter-passkeys
[checked-commit]: https://github.com/corbado/flutter-passkeys/commit/8c9e5b50b386fbb555eded63473a75fdb7fafbd1
