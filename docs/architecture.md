# Application Architecture

SyncTV uses feature ownership with explicit dependency layers. UI state and
commands stay separate from API, persistence, platform, and transport code.

## Dependency Direction

```text
main / AppDependencies
        |
        v
app shell -> presentation -> application -> domain
                              ^
                              |
                    data / infrastructure
        |
        v
shared API services and generated protobuf
```

- `lib/core/` owns reusable primitives with no product-feature dependency.
- `lib/contracts/` owns typed SyncTV API contracts shared by multiple
  features. Contracts depend only on generated protocol types and reusable
  core primitives.
- `lib/features/<feature>/domain/` owns immutable rules and value types.
- `lib/features/<feature>/application/` owns commands, controllers, and ports.
- `lib/features/<feature>/data/` implements application ports using storage or
  the SyncTV API facade.
- `lib/features/<feature>/infrastructure/` owns platform plugins and runtime
  transports such as WebRTC, media P2P, Passkey, and picture-in-picture.
- `lib/features/<feature>/presentation/` maps immutable state to Flutter UI and
  forwards user actions to controllers or injected commands.
- `lib/features/app_shell/` is the cross-feature composition and navigation
  root. Feature internals do not own global navigation.
- `lib/features/providers/` owns third-party provider accounts, browsing,
  source resolution, and ingestion contracts. Media library and account UI
  consume this feature without owning provider infrastructure.

The shared `lib/data/synctv_api/` directory is the typed SyncTV API data plane. It
contains HTTP/protobuf clients, session storage, caching, uploads, and API
facades. Feature gateways adapt that plane to focused application contracts.

Auxiliary room media transport follows the same direction: subtitle downloads
and danmaku document/SSE access implement application ports under `room/data/`.
Player widgets own decoding and visual state while the composition root selects
the HTTP adapters.

## State And Commands

Long-lived mutable state uses an injected controller. The media P2P preference
flow is the reference implementation:

```text
SharedPreferences store
        -> P2pMediaPreferencesController
        -> app shell / room / settings views
```

Views receive the controller or an immutable state snapshot. Persistence stays
inside the data adapter. An optimistic controller update rolls back when the
store reports an error.

Pure views such as `HomeView` and `RoomShellView` accept immutable state and
callbacks. The same production views power widget tests and deterministic
showcase screenshots.

Room realtime is split into three boundaries. Typed messages and chat
projections live in `room/domain/`; protocol and channel ports live in
`room/application/`; protobuf encoding, WebSocket framing, and heartbeat
ownership live in `room/data/`.

Generated protobuf enums and request/response DTOs may appear in application
ports when they are the public SyncTV API contract. Presentation code consumes
those typed DTOs through a feature port. Binary encoding, JSON framing,
transport clients, session state, and caches stay in the data plane.

## Composition Rules

- Construct application-wide dependencies in `main.dart`.
- Pass feature dependencies through constructors.
- Register dependencies above `MaterialApp`'s Navigator through
  `DependencyRegistryScope`, so pages, dialogs, bottom sheets, and overlays
  share the same composition root.
- Use `DependencyScope<T>` for a focused test override. A local typed scope
  takes precedence over the root registry.
- Keep static platform and API facades behind feature data adapters when a
  workflow needs isolated tests or long-lived state.
- Inject clocks, transport codecs, identifiers, and loaders into domain or
  application logic.
- Keep generated protobuf under `lib/src/generated/`; expose it through a
  feature application port when the protobuf type is the API contract.
- Place shared visual primitives under `lib/core/presentation/` and
  feature-owned widgets under their feature.

Run the dependency guard directly with:

```bash
dart run tool/check_architecture.dart
dart tool/generate_feature_gateways.dart --check
```

The same checks run through `test/architecture_test.dart`. They reject reverse
dependencies, presentation access to data or infrastructure, feature access
to the composition root, obsolete root `pages/` or `widgets/` buckets, and
stale generated gateway contracts.

## Tests And Screenshots

Unit and widget tests mirror production feature ownership under `test/`.
Deterministic screenshots use production views plus local fixture state, so
they run without a SyncTV server. End-to-end backend scenarios live under
`integration_test/backend/` and run only when explicitly requested.

See [Testing and Showcase Screenshots](testing.md) for commands and fixture
rules.
