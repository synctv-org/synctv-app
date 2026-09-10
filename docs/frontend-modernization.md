# Frontend Modernization

## Goal

Improve the production experience across discovery, authentication, room
playback, media management, and account administration. Prioritize observable
usability, correctness, accessibility, and performance improvements while
preserving backend contracts and platform capabilities.

## Work Plan

The initial delivery checklist below records the first pass only. The active
follow-up audit remains open; it does not establish that every handwritten
file or every runtime state has been reviewed.

- [x] Inventory application modules, shared controls, tests, and build setup.
- [x] Establish the web release build and dependency baseline.
- [x] Refine discovery hierarchy, search/filter ergonomics, responsive room
  presentation, and lazy rendering.
- [x] Fix confirmed asynchronous state and cache correctness defects.
- [x] Review shared controls and critical room/authentication flows for
  responsive and accessibility regressions.
- [x] Upgrade compatible dependencies after reviewing upstream changes.
- [x] Verify static checks, focused regressions, the complete test suite,
  and the production web build.
- [x] Exercise real browser flows at desktop and mobile sizes against the
  backend; record screenshots, failures, and remaining limitations.

## Baseline

- Flutter 3.47.2 / Dart 3.13.2, using the repository FVM configuration.
- Production web build succeeds before changes.
- Direct updates available: file_picker 12.2.0 and flutter_webrtc 1.6.1.
- Discovery currently nests a shrink-wrapped grid inside a complete page
  scroll view, laying out all result cards in advance.
- Memory cache loaders can write stale data after invalidation or a newer
  request completes.

## Coverage

Reviewed and improved discovery and app shell, theme/responsive metrics,
shared controls, memory cache, image uploads, web startup, room/player
semantics, account pagination, and admin record layouts and request handling.

Inspected authentication, reports, providers, media library, P2P, room invites,
server settings, and voice through existing code, automated coverage, and
reachable browser workflows. External service and device limitations are
listed below.

### Follow-up Audit Status

The [source inventory](frontend-audit-inventory.md) is the file-level coverage
index. Its [evidence ledger](frontend-audit.json) records scoped findings and
source fingerprints; regenerate with `dart run tool/frontend_audit_inventory.dart`
and verify with `dart run tool/frontend_audit_inventory.dart --check`.
Files without registered evidence stay unreviewed even when broad workflow
tests already exist. The initial backfill deliberately records only recent,
directly verified scopes; older passes need evidence reconciliation.

The next audit queue is:

1. Reconcile shared data/session/cache evidence and inspect remaining request
   lifetimes under `lib/data/synctv_api`.
2. Review room settings drafts, chat mutation/refresh ordering, presence
   subscriptions and delayed playlist deletion under `lib/features/room`.
3. Review authentication completion/cancellation and account session changes
   under `lib/features/auth` and `lib/features/account`.
4. Finish shared controls, long labels, actionable notification layout and
   provider forms against desktop, compact and enlarged-text states.
5. Review local media-player, OPAQUE and passkey packages, platform entrypoints,
   and Web startup assets; retain native/external validation gaps explicitly.
6. Reconcile the remaining file inventory, then assess controlled performance
   measurements, dependency state and the complete goal acceptance criteria.

Repository-wide pattern scans cover handwritten modules and exclude generated
protobuf/localization code. A scan is not a line-by-line review. Deep review
and regression work currently concentrate on shared controls, discovery,
cache behavior, admin lists, room management, preferences, and provider
account switching. Browser coverage applies only to the workflows explicitly
recorded, not every component or failure state.

| Area | Evidence level | Follow-up work |
| --- | --- | --- |
| Core, theme, app shell, home | Deep review of changed controls, cache and list rendering; widget and browser coverage | Complete the remaining shared-component inventory |
| Admin | Query races, narrow room/user/member records, shared permission editor integration, member mutations and runtime writes directly tested | Complete per-dialog error/cancellation review and remaining controller lifetimes |
| Room | Management queries, guest permission bits, permission editor, chat refresh/event merging, presence during refresh and preferences directly tested | Review remaining settings draft conflicts, presence subscription changes, pin/delete refresh boundaries and secondary dialogs |
| Media library | Seven provider forms reviewed and directly tested for stale requests/account replacement | Inspect remaining provider-specific states |
| Provider binding | List request lifetime, QR instance-switch races and narrow enlarged-text forms directly tested; complete binding entry mounted in tests | Remaining authentication cancellation paths |
| Authentication | Agreement interaction and shared dialog layouts directly tested; existing auth tests | Complete provider-specific failure/cancellation inventory |
| Account | Pagination, single/all notification repeat-submit/retry, selected-ID snapshots and post-disposal results directly tested; browser sections visited | Remaining mutation and session-change boundaries |
| Reports, server settings, invites | Report disposition cancellation and duplicate-submit regressions; invite activation/clock failures, disposal, missing-server cancellation and successful addition directly tested | External server integration; remaining dialog/state coverage |
| Voice and P2P infrastructure | Pattern scans and existing automated coverage | Device and multi-client behavior; complete infrastructure deep review |

### Follow-up Fixes

- Admin secondary lists, taxonomy, room members/reviews/streams/chat queries,
  provider bindings and media discovery discard superseded request outcomes.
- Runtime setting writes are ordered, and stale refreshes cannot replace
  newer saved values.
- Guest permission flags at bits 32-35 use Web-safe BigInt operations; a
  Chrome regression is included in CI. Ordinary JavaScript bitwise shifts
  previously lost these flags.
- Short user agreements can be accepted without an impossible scroll;
  longer agreements retain the scroll requirement. Checkbox semantics and
  linked agreement actions remain distinct.
- Shared dialogs use one content scroll region and preserve actions with
  narrow viewports, keyboard insets and enlarged text. Member permission
  editing is extracted into a dedicated, directly tested widget.
- Playback mode, volume, overlay and P2P preferences share ordered persistence
  with optimistic updates and rollback to the last successful save. Pending
  reads cannot overwrite newer edits, and disposed controllers do not notify.
- Realtime log preferences retry failed reads and protect each field against
  stale reads and save failures.
- Room chat pagination and refresh retain the submitted query when input text
  has been edited but not submitted. Unrelated live messages do not enter the
  search results, and older message versions cannot overwrite newer ones.
- A realtime media snapshot supersedes an outstanding HTTP response, including
  its error/loading state. Room setting switches expose descriptive labels.
- Bilibili QR creation and polling are scoped to the current login instance.
  Old success, expiry and error responses cannot close or change a replacement
  login, stop its timer or release its active poll lock.
- Binding-list initialization runs after inherited localization dependencies
  become available. A complete binding-entry regression catches the lifecycle
  assertion that isolated account-form tests did not exercise.
- Binding section headings and action groups wrap at 320 pixels with 1.3x and
  2x text scaling; previous heading/action overflows are directly tested.
- Web bootstrap tracks display pixel ratio changes and notifies Flutter's
  viewport dimensions provider on the next frame. This fixes cached physical
  dimensions that made an open dialog double-sized and clipped after resizing.
- Member refresh merges presence events received during its request, preserving
  newer online/offline status and connection counts instead of replacing them
  with stale HTTP data. The request-scoped event buffer is cleared on completion.
- Room settings snapshots merge untouched fields while preserving local edits.
  Password refresh uses the same merge and only clears the submitted password
  draft if it still matches the input. Save responses compare against the
  submitted settings. While a save is pending, realtime echoes update the server
  baseline without replacing edits made after submission.
- Room settings writes invalidate the settings cache instead of caching the
  submitted object as authoritative. Subsequent reads fetch server-normalized
  settings and concurrent changes, rather than echoing the request payload.
- Settings/password readback tracks realtime snapshot revisions. An HTTP result
  cannot replace a newer realtime snapshot received while the read was pending;
  the save merge still preserves edits made after submission.
  A shared read generation also prevents an older password readback from undoing
  a newer settings save. The protobuf settings patch does not write password state.
- Report disposition saves are scoped to the open dialog. Cancelling while a
  request is pending cannot let a late response pop the containing page or show
  an obsolete error. The save action shows progress and rejects repeat submits.
- Admin chat history refresh invalidates outstanding pagination, including
  stale errors and cursor updates. Its summary badges and refresh action wrap
  instead of overflowing when older messages are available. Two direct widget
  regressions cover stale pagination success/failure and reach the refresh action.
- Account notification mutations share an in-flight guard, preventing rapid
  repeated mark/delete actions from racing their refresh responses.
  Notification refresh returns immediately after page disposal.
  Marking selected notifications read removes only submitted IDs from selection,
  preserving choices made while the request is pending.
- Account closure now has a page-level submission guard; repeated taps cannot
  launch concurrent sensitive close-account requests.
- Room batch deletion captures the selection before confirmation and checks
  widget lifetime after the server response. It cannot select different deletion
  targets from later realtime changes or update a disposed room page. Direct
  delayed-deletion regression coverage remains open.
- Invite preparation checks the originating page again after server activation
  and time synchronization, returning no room target after that page is disposed.

## Delivered Changes

- Discovery uses a sliver grid to build visible room cards lazily. Search and
  category controls appear before the results, featured rooms use a horizontal
  rail, and phone layouts preserve readable single-column cards.
- Search debounces for 350 ms and respects IME composition. Filters, empty
  results, loading states, and retry actions now retain useful context.
- Invalidated or superseded cache requests cannot overwrite newer values.
  Admin user and room queries also discard superseded responses.
- Image uploads derive MIME type and extension from encoded content after
  cropping. Image metadata buffers are disposed even when decoding fails.
- Account room and blocked-user pagination no longer offers an extra empty
  page when the total is an exact multiple of the page size.
- Admin user and room actions wrap below content on narrow screens, fixing
  text squeezed into vertical columns. Repeated record surfaces use restrained
  borders and consistent corners.
- Buttons, switches, checkboxes, and collaboration tabs expose a single
  actionable accessibility node. Glass buttons support keyboard activation;
  affected animations respect reduced-motion preferences.
- Web startup shows loading and recoverable failure states. CanvasKit is
  loaded from bundled build assets, avoiding an external engine CDN dependency.
- Updated file_picker to 12.2.0 and flutter_webrtc to 1.6.1; added mime 2.0.0
  directly for encoded image detection. Direct and development dependencies
  are current within the supported dependency graph. Framework/transitive
  constraints and the existing platform override remain in place.

## Validation Record

Initial-pass validation completed on 2026-09-06 with the repository FVM SDK.
These results predate the follow-up changes; current results are recorded
separately below.

- `fvm flutter test --reporter expanded`: 945 tests passed.
- `fvm flutter analyze`: no issues found.
- `fvm dart run tool/check_architecture.dart`: passed.
- `fvm dart run tool/check_ui_guard.dart`: passed.
- `git diff --check`: passed.
- `fvm flutter build web --release`: passed.
- `fvm flutter build macos --debug`: passed. Some native plugins still use
  CocoaPods and emit Flutter's future Swift Package Manager migration warning.
- Focused regressions cover cache invalidation races, encoded image metadata,
  search/layout, account pagination, admin request races and narrow layouts,
  and shared/player control semantics.
- Browser Use exercised the release application against the local backend in
  Edge, including desktop/phone layouts and light/dark appearance.
- Real video playback advanced with decoded dimensions of 854 x 480. A sampled
  playback synchronization offset was about 0.12 seconds; this is a local
  functional observation, not a cross-network performance guarantee.
- Real browser caught an unavailable external CanvasKit CDN at startup. The
  error/retry screen worked; bootstrap now uses the engine assets shipped with
  the build so deployment does not rely on that CDN.
- Script-load failure and retry recovery were exercised with browser request
  blocking. The failure tab was closed and temporary viewport overrides reset
  after verification.

Local screenshot evidence is stored under the ignored `build/review/browser/`
directory: `home-desktop-light.png`, `room-mobile-dark.png`,
`playback-mobile-dark.png`, and `admin-mobile-light.png`. Test/build logs are
under `build/review/`; generated artifacts are not source changes.

### Follow-up Validation

- Room settings: 13 direct widget regressions passed, including old success
  and failure responses, media realtime snapshots, chat query/cursor behavior,
  search event isolation and switch labels (`fourth-room.log`).
- Shared preference persistence and room/log regressions passed in the focused
  run (`fourth-races.log`).
- Complete suite: 1017 tests passed (`ninth-full-tests.log`). The P2P widget
  regression initializes its controller in the widget test zone so queued
  persistence runs in the same async environment as its assertions.
- Dart analyzer: no issues. Architecture and UI guards and `git diff --check`
  passed.
- Chrome high-bit permission regression passed (`fourth-web-permissions.log`).
- Release Web build passed (`fourth-web-build.log`). Native builds have not
  been repeated after these follow-up changes.
- Browser Use reloaded this release against the local backend and inspected
  desktop room settings plus the member permission dialog at 320 x 568 CSS
  pixels. One scroll region reaches the final P2P permission while cancel,
  clear and save remain visible. The dialog was cancelled without submitting
  permission changes. Switch accessibility names identify their settings.
- New screenshots: `permissions-320-scroll.png` and
  `settings-desktop-followup.png` in the ignored browser evidence directory.
  The temporary viewport override was reset. The browser's captured error log
  was empty during this check; this is not an assertion about all workflows.
- Subsequent provider follow-up: 125 related tests passed
  (`fifth-provider-suite.log`), including five QR race regressions and two Emby
  account-replacement regressions. This is focused validation after the 1003
  test baseline, not a new full-suite count.
- Provider follow-up analyzer and Web release build passed
  (`fifth-final-analyze.log`, `fifth-web-build.log`). Browser Use opened the
  complete connection manager at a fixed 390 x 843 CSS viewport, generated a
  Bilibili QR code, scrolled to cancel, and returned to the unbound state.
  No external account authorization was completed. Screenshot evidence:
  `bindings-390-followup.png`; login QR data was not saved as an artifact.
- Subsequent complete suite: 1012 tests passed (`sixth-full-tests.log`), analyzer
  had no issues (`sixth-analyze.log`), and release Web plus debug macOS builds
  passed (`sixth-web-build.log`, `sixth-macos-build.log`). macOS plugins still
  emit the existing Swift Package Manager migration warning.
- Bootstrap DPR regressions: two Node tests passed; CI runs them on Node 24.
  Binding layout suite: 15 tests passed, including enlarged text in all modes.
- Browser Use reproduced a DPR change from 1.8 to 0.9 where a 390-pixel viewport
  retained a 780-pixel Flutter view. After the bootstrap fix, an open create-room
  dialog resizes without reload: view width 390.00003 for viewport 390, then
  2082.2136 for viewport 2082 on return to desktop. Screenshots show reachable
  actions and correct framing (`dialog-dpr-resize-390.png`). The viewport override
  was reset and the untouched dialog cancelled.
- Latest presence follow-up: all 15 room concurrency tests passed
  (`seventh-room.log`), including online and offline events during refresh.
  This focused run follows the 1012-test complete-suite baseline.
- Settings draft follow-up adds a direct realtime snapshot regression verifying
  both preserved edits and updated untouched fields. Save-during-edit and
  concurrent password/settings mutation coverage remain open.
- Report disposition follow-up: three report tests pass (`ninth-reports.log`),
  including late success/failure after cancellation and disabled repeat submit.
  Analyzer passed (`ninth-analyze.log`).
- Account focused tests pass (`tenth-account.log`) and analyzer passes
  (`tenth-analyze.log`) after notification mutation serialization.
- Account closure guard analyzer and focused account tests pass
  (`twelfth-analyze.log`, `twelfth-account.log`).
- Admin chat history: three widget tests passed (`thirteenth-chat.log`), including
  refresh/pagination races and the existing optimistic moderation rollback.
  The first run exposed a 96-pixel header overflow; the wrapping fix passes the
  same interaction tests. Analyzer passed (`thirteenth-analyze.log`) before the
  final header-only layout change. Browser verification of this dialog is pending.
- Latest full suite: 1019 tests passed (`fourteenth-tests.log`). Release Web
  build passed (`fourteenth-web.log`) and `git diff --check` passed.
- Browser Use reloaded that release and exercised admin chat history on desktop
  and at 390 x 843: refresh, opening message context, scrolling to the target
  and bottom, closing context back to history, and closing history back to rooms.
  Text and controls remained readable and reachable. Screenshot evidence:
  `admin-chat-context-390.png`. The viewport override was reset. The local room
  contains 11 messages, so real multi-page history and destructive actions were
  not exercised; pagination race evidence is from the controlled widget tests.
- Account follow-up: nine widget tests passed (`fifteenth-account.log`), adding
  six direct regressions for single/all notification actions, repeat callbacks,
  disabled controls, retry after errors, and late success/failure after disposal.
  Analyzer passed (`fifteenth-analyze.log`). Selected-notification mutations and
  session switching still require dedicated coverage.
- Selected-notification follow-up: eleven account tests passed
  (`sixteenth-account.log`), including submitted-ID capture and preservation of
  newer selection on success and all selection on failure. Analyzer result:
  `sixteenth-analyze.log`. Session switching remains open.
- Invite flow: four widget tests passed (`seventeenth-invite.log`), covering
  activation success, activation failure, clock synchronization failure, and
  disposal during activation. Missing-server add/cancel coverage remains open.
- Missing-server follow-up: six invite tests passed (`eighteenth-invite.log`).
  Direct cancellation and opening server settings then finishing without adding
  a server preserve the original page and perform no activation/time sync.
  Successful server addition still needs end-to-end flow coverage.
- Successful missing-server addition is now covered through all three UI layers
  with a controlled gateway (`nineteenth-invite.log`, seven tests passed).
  The test verifies the complete subpath address is prefilled, insecure TLS stays
  disabled, the invited server is activated, and the original room ID returns.
  This is widget integration coverage, not a live external server connection.
- Settings save follow-up: seventeen room concurrency widget tests passed
  (`twentieth-room.log`); analyzer passed (`twentieth-analyze.log`). The new test
  scrolls the settings list to Save, changes the draft while saving, delivers the
  realtime echo and HTTP response, and verifies the later draft survives. It
  failed with true instead of false before the echo guard. Concurrent password
  writes and failed-save merging remain open.
- Save retry follow-up: eighteen room tests passed (`twentyfirst-room.log`).
  After a failed settings write, the save action becomes available and retry
  submits the newer draft rather than the failed payload. Concurrent password
  writes and failure while fetching the saved settings remain distinct gaps.
- Save readback follow-up: nineteen room tests passed (`twentysecond-room.log`),
  including successful writes followed by failed reads and retry of the latest
  draft. The settings cache regression verifies a submitted limit of 42 reads
  back the server's value of 17. All 244 API tests passed (`twentysecond-api.log`)
  and analyzer passed (`twentysecond-analyze.log`). Password concurrency remains open.
- Readback ordering follow-up: nineteen room tests passed (`twentythird-room.log`).
  The three save/retry scenarios now receive a newer approval setting while HTTP
  is pending and verify it survives the stale HTTP response alongside local edits.
  Direct concurrent password/settings mutation coverage remains open.
- Password/settings follow-up: twenty room tests passed (`twentyfourth-room.log`).
  A direct UI regression starts password readback, saves ordinary settings, then
  completes the password read last. Before the shared generation guard, it reset
  guest access to false; the regression now preserves true. Reverse ordering,
  reset-settings overlap and concurrent failure paths remain to be audited.
- Read completion matrix: twenty-three room tests passed (`twentyfifth-room.log`),
  analyzer passed (`twentyfifth-analyze.log`). Password-first/settings-second
  writes are tested with both HTTP completion orders, with and without editing
  the draft after save. Reverse write initiation, reset overlap and concurrent
  failure combinations remain separate coverage gaps.
- Reset follow-up: reset, ordinary save and password changes cannot overlap
  with a reset request. Confirmation rechecks the busy state; reset readback
  observes realtime/read generations. Twenty-five room tests passed
  (`twentysixth-room.log`), including reset success/failure releasing Save.
  Reset draft preservation is verified in the subsequent entry.
- Reset draft follow-up: twenty-five room tests and analysis passed
  (`twentyseventh-room.log`, `twentyseventh-analyze.log`). Successful reset
  discards unchanged pre-confirmation drafts while preserving edits made during
  the request. Failure preserves both. Raw numeric input is compared separately
  from the parsed settings baseline; direct numeric-input cases remain open.
- Chat refresh follow-up: twenty-seven room tests and analysis passed
  (`twentyninth-room.log`, `twentyninth-analyze.log`). Request-scoped live updates
  are reapplied after history/search responses, with message-version checks and
  server-defined search membership. Tests cover new messages, newer/older edits,
  and repeated stale HTTP refreshes. Pending pin outcomes are also reapplied;
  dedicated pin/delete and overlapping-refresh regressions remain open.
  The intermediate full suite passed 1045 tests (`twentyeighth-tests.log`);
  the later focused run includes the repeated-refresh version protection.
- Admin room reset follow-up: seven record tests passed (`thirtieth-admin.log`).
  Reset blocks repeat submissions and Save, handles errors inside the dialog,
  and ignores results after cancellation so a late success cannot pop the parent
  route. Direct cases cover late success/failure, same-frame repeat invocation,
  and failure/retry at 390 pixels. Browser Use also inspected the room-settings
  dialog at 390 x 843: switches, numeric input and all actions remained visible.
- Validation checkpoint: the full suite passed 1048 tests
  (`thirtieth-tests.log`), analysis passed (`thirtieth-analyze.log`), and the Web
  release build passed. A final same-frame Reset/Save callback guard passed all
  seven record tests (`thirtyfirst-admin.log`) and a fresh release build
  (`thirtyfirst-web.log`). Browser Use opened the rebuilt home and admin room
  list, inspected the updated settings dialog at desktop and 390 x 843 sizes,
  then cancelled it and restored the desktop viewport. No live settings were
  changed. This browser pass checks layout/navigation; delayed response behavior
  is covered by the controlled widget regressions.
- Admin member/permission follow-up: both permission-editing entry points now
  use `MemberPermissionDialog`; duplicate admin permission state/types/layout
  were removed. Clear edits the draft and Save commits it, so Cancel remains
  non-mutating. Integration tests enter through the room/member lists and check
  both role-specific permission masks, save/cancel and 320 x 568 navigation.
  Member records reuse the responsive admin record layout: the previous trailing
  action group reduced the name to zero width at 320 pixels without a Flutter
  overflow error. Tests now assert readable name width/height, not only the
  absence of framework exceptions. Initial short-screen click failures were
  resolved by waiting for layout after scrolling; they did not prove a toolbar
  defect.
- Admin member requests now reject superseded success/error responses and
  avoid starting dialog refreshes after closure. Two delayed-search regressions
  preserve the newer result. Twenty admin/permission tests passed
  (`thirtyninth-admin.log`); direct post-close mutation cases and role/kick
  failure handling remain follow-up work.
- Full-admin browser testing found a lifecycle issue that isolated tab tests
  missed: crossing the desktop/mobile navigation breakpoint recreated the
  content stack, discarded drafts and left an open permission dialog attached
  to disposed page state. The stack now has a stable global key and section
  storage keys use fixed indexes rather than translated labels. A complete
  administrator-page regression checks resize in both directions, permission
  cancellation returning to the member list, retained search drafts and no
  redundant room reload; it also covers changing locale.
- That complete-page regression exposed a five-pixel vertical overflow at
  320 x 568. Room toolbar, batch controls, pager and lazily built records now
  share a Sliver scroll view, allowing short screens to reach the list rather
  than reserving more fixed header height than the page provides. Fourteen
  admin tests passed after the layout fix (`fortythird-admin.log`).
- Validation checkpoint: all 1055 tests passed (`fortyfourth-tests.log`),
  analysis passed (`fortythird-analyze.log`), the Web release build passed
  (`fortythird-web.log`), and architecture/UI guards passed using FVM Dart.
  Browser Use inspected desktop and 320 x 568 member records and permission
  controls, then reloaded the final build and verified that cancelling an open
  permission dialog after desktop-to-phone resize returns to the original
  ten-member room list. Dialogs were closed and the desktop viewport restored.
  No live member permissions were changed. Member role/kick mutation failures,
  remaining secondary dialogs and infrastructure/device validation are still
  open; this checkpoint does not establish full-project completion.
- Member mutation follow-up: role changes, removal, remark names and display
  labels share a per-member operation guard. Repeated invocation and concurrent
  controls for that member are blocked; errors are caught and allow retry.
  Closed dialogs ignore late success/error and do not trigger another member
  refresh. Twelve added cases cover these four operations across retry and
  post-close success/failure, including submitted IDs and payloads. Twenty-six
  admin tests passed (`fortyseventh-admin.log`) before the final payload checks.
- Those tests exposed a controller-lifetime crash in remark/display-label
  editing: disposing the controller when the dialog future completed raced its
  exit animation. The new `RoomMemberTextDialog` owns and disposes its controller
  with widget lifetime, and guards duplicate completion. Role/kick request
  failures are now directly tested; controller ownership for the member-list
  search and cooldown/add-member dialogs remains a separate follow-up.
- Validation checkpoint: all 1067 tests passed (`fortyeighth-tests.log`),
  analysis and release Web build passed (`fortyeighth-analyze.log`,
  `fortyeighth-web.log`), and architecture/UI guards passed. Browser Use opened
  the rebuilt member-list remark editor, verified autofocus and desktop/320 x
  568 layout, cancelled it, and confirmed that the member's action buttons were
  enabled again. The member list was then closed and the viewport restored;
  no live member data was changed.
- Add/remove form follow-up: `AddRoomMemberDialog` and
  `KickRoomMemberDialog` own their controllers and guard duplicate completion.
  Add validates a nonempty trimmed user ID, locks the submitted fields, retains
  input/role/notification choices after failure, and ignores results after
  Cancel or route dismissal. Success and cancellation return to the member
  list. The cooldown form displays inline range validation for 1-2592000 seconds.
  Nine focused cases cover narrow/enlarged-text forms, invalid values and both
  numeric boundaries, payload normalization, retry and delayed post-close
  results. Thirty-five member tests passed (`fiftieth-members.log`) before the
  final two caller-integration cases. Member-list search-controller ownership
  remains open; the add/cooldown ownership gap is now addressed.
- Validation checkpoint: all 1078 tests passed (`fiftyfirst-tests.log`),
  analysis/Web release build passed (`fiftyfirst-analyze.log`,
  `fiftyfirst-web.log`), and architecture/UI guards passed. Browser Use exercised
  the rebuilt Add member entry, empty-ID inline validation, desktop/320 x 568
  layout and cancellation returning to the original member list. The new
  cooldown confirmation was inspected at 320 x 568 and cancelled; member
  actions became available again. No members were added or removed, dialogs
  were closed and the desktop viewport was restored.

- Session-bound navigation follow-up: authentication expiry now clears routes
  above the application shell before opening login, coalesces expiry events
  while reauthentication is open, and preserves an already open login draft.
  Dismissed shell modals release their guards before login opens. Account room
  lookup/settings lookup and room-creation callbacks check the session epoch;
  account/admin/room route-return callbacks also ignore expired sessions.
  Eight new shell tests cover nested routes and a non-dismissible dialog,
  replacement of an existing join dialog, repeated expiry notifications, and
  late account room/settings responses both before and after reauthentication.
  All 1086 tests passed at this checkpoint (`fiftysecond-tests.log`).
- Browser Use found an additional account overview defect at 320 x 568: metric
  tiles used a fixed aspect ratio, clipping their labels at the tile boundary.
  Metrics now reuse `AppResponsiveWrap`, size vertically to their content and
  allow labels/values to wrap. The redundant outer layout builder was removed.
  Twelve cases check actual label bounds and padding at 320/600/1200 widths,
  normal/1.5x text, and both three- and four-metric account configurations.
  Browser screenshots of the rebuilt app confirm readable narrow tiles and a
  compact desktop row. The desktop viewport was restored; the existing login
  session was retained. Forced expiry was tested with gateway-driven widget
  tests, not by revoking a live browser session.
- Validation checkpoint: all 1098 tests passed (`fiftythird-tests.log`),
  analysis and release Web build passed (`fiftythird-analyze.log`,
  `fiftythird-web.log`), and the diff whitespace check passed. Remaining account
  audit items include logout failure/repeated-action handling, language
  preference persistence/selector lifecycle, and further secondary dialog
  ownership checks. The broader file-by-file audit remains incomplete.

- Language preference follow-up: `AppLocaleController` now reuses
  `PersistedValueController` for ordered writes, revision-protected reads,
  durable rollback and disposal-safe notifications. The SharedPreferences
  adapter treats a false write result as failure. Read/write injection supports
  controlled storage tests without replacing the production default.
  The selector owns its saving/closing state, prevents duplicate selections,
  shows progress, supports retry after rollback, and checks its route before
  closing or showing an error. A covered selector releases its busy state
  without popping the covering route; explicitly closed selectors ignore late
  results. Eight added cases cover these boundaries, with selector cases at
  320 x 568 and 1.3x text. The default singleton test explicitly drains real
  asynchronous work because its serial queue is created outside fake time.
- Validation checkpoint: all 1106 tests passed (`fiftyfourth-tests.log`),
  analysis/Web release build passed (`fiftyfourth-analyze.log`,
  `fiftyfourth-web.log`), and architecture/UI guards and whitespace checks
  passed. Browser Use inspected desktop/320 x 568 language sheets, switched to
  English, and confirmed that a new browser page restored English. The original
  System default setting and desktop viewport were restored.
  Logout remains a separate open item: the API facade deliberately clears the
  local session after remote logout errors, while runtime persistence may still
  fail; shell logout lacks failure/repeated-action handling. Any follow-up must
  account for this partial-success state and concurrent session replacement.

- Same-server session isolation: endpoint generations did not distinguish two
  accounts using the same server. `SyncTvSession` now advances a session
  generation when credentials are activated, a guest is activated, or the
  session is cleared. Token refresh preserves that generation. Protected unary
  requests check it before refresh/retry and before delivering responses;
  refresh results cannot overwrite a replacement session, and refresh work is
  coalesced per endpoint and session. Logout/account closure check both
  generations before clearing credentials. SSE handshake/retry and event
  delivery also reject superseded sessions.
  Eleven tests cover old logout success/401/500/transport failure, normal
  logout with refresh/retry, stale protected success/401, overlapping refresh
  across accounts, account closure followed by guest activation, and stale SSE
  handshake/event delivery. Existing data-layer tests also passed.
- Validation checkpoint: all 1117 tests passed (`fiftyfifth-tests.log`),
  analysis and Web release build passed (`fiftyfifth-analyze.log`,
  `fiftyfifth-web.log`), and architecture/UI/whitespace checks passed. Browser
  Use verified normal authenticated discovery/account reads and desktop/320 x
  568 account rendering; the desktop viewport was restored. Destructive account
  closure and forced session replacement were exercised only in controlled
  tests. Follow-ups remain: shell logout progress/repeat/error handling,
  runtime auth-error emission after delayed persistence and session replacement,
  persistence failure handling, and authentication-completion boundaries.
  These are distinct from the request/refresh isolation completed here.

- Runtime expiry delivery now tracks the cleared session generation during
  persistence and rechecks it when an asynchronous notification is delivered.
  Repeated errors for the same clearing session are coalesced, while a new
  session's own expiry is processed independently. Four tests cover stale
  persistence completion, independent replacement-session expiry, duplicate
  errors, and session replacement between notification subscribers.
- Shell logout now guards repeated opening, repeated confirmation and concurrent
  requests, catches failures and allows retry. Successful logout removes
  protected pages opened during the request. If local credentials are already
  cleared when persistence throws, the UI also clears old account data/routes
  and reports the error. Responses from an expired UI session are ignored.
  Four shell tests cover normal/partially failed clearing, failure with retained
  credentials and retry, and reauthentication before an old failure completes.
  The request remains in progress after the confirmation closes; a dedicated
  visible logout-progress treatment is still a possible interaction follow-up.
- Validation checkpoint: all 1125 tests passed (`fiftyseventh-tests.log`),
  analysis/Web release build passed (`fiftyseventh-analyze.log`,
  `fiftyseventh-web.log`), and architecture/UI/whitespace checks passed. Browser
  Use checked logout confirmation at desktop/320 x 568 and cancelled it,
  preserving the authenticated session and restoring the desktop viewport.
  Storage durability remains open: runtime expiry persistence exceptions and
  false storage write results still need explicit recovery/reporting review.
  Authentication completion and other per-file coverage gaps remain open.

- Session storage now treats false SharedPreferences write/remove results as
  failures, serializes complete server-list/active-endpoint snapshots, and
  permits subsequent saves after failure. Startup reconciliation retains
  readable configuration if its automatic repair cannot be persisted; explicit
  mutations still return errors to their callers. Optional storage loading and
  runtime store construction support controlled fault injection while retaining
  the existing production defaults. Runtime expiry persistence exceptions are
  logged and no longer prevent the current cleared session's UI notification;
  replacement sessions still suppress stale notifications.
  Seven added tests cover false list/active/remove results and successful retry,
  overlapping saves followed by reload, failed startup repair, expiry storage
  failure/retry and failure after account replacement.
- Validation checkpoint: all 1132 tests passed (`fiftyninth-tests.log`),
  analysis and Web release build passed (`fiftyninth-analyze.log`,
  `fiftyninth-web.log`), and architecture/UI/whitespace checks passed. Browser
  Use opened a fresh app page, confirmed the existing server/account restored,
  and inspected server settings at desktop/320 x 568 before closing it and
  restoring the viewport. No saved browser server/account was changed.
  Broader startup recovery for preference reads and other initialization
  failures remains open, as do authentication completion, full per-file review,
  external integrations, devices and controlled performance measurements.

- Startup initialization now renders branded loading/failure states and permits
  retry after an initialization failure. The fallback does not create a
  Navigator, preserving the original OAuth/deep-link path. Initialization
  completion after disposal is ignored; deferred runtime starts after the
  successful application's first frame. Five widget tests cover retry,
  duplicate callbacks, disposal and OAuth path preservation.
- Startup validation: all 1137 tests passed (`sixtieth-tests.log`); the final
  title adjustment passed the five startup tests, analysis and production Web
  build (`sixtyfirst-*` logs). Architecture/UI/whitespace checks passed.
  Browser Use inspected the controlled failure preview at desktop and
  320 x 568 and verified retry into the homepage, then opened the production
  homepage with the existing account. The temporary preview server was stopped.
  Hanging initialization, errors before mounting and deferred-runtime failures
  remain outside this retry boundary.

- Member remark/display-label editing now shares one stateful room component
  between room settings and administration. Its controller follows the widget
  lifecycle; duplicate submissions, callbacks during route exit, callbacks
  after disposal and callbacks while another route covers the editor cannot
  dismiss unrelated routes. Six direct tests cover these cases, trimming and
  clearing values at 320/1200 widths with 1.5x text.
- The admin member list is extracted from its page method into a stateful
  dialog within the existing admin library. It owns and disposes its search
  controller, retains request-generation and per-member mutation guards, and
  returns add/permission intents to the page for the next dialog. Opening the
  list is coalesced. Four additional integration tests cover duplicate opens
  and intents, controller release and late refresh success/failure after close.
- Validation checkpoint: all 1147 tests passed (`sixtysecond-tests.log`),
  analysis and Web release build passed (`sixtysecond-analyze.log`,
  `sixtysecond-web.log`), and architecture/UI/whitespace checks passed. Browser
  Use inspected the rebuilt admin member list at desktop/320 x 568, opened and
  cancelled remark editing, and exercised permission editing and return to the
  member list. No member/account data was changed; viewport was restored.
- Browser follow-up: compact shared selects visibly truncate short Chinese
  labels such as the member role and join-time filters. `AppSelect` estimates
  width from character count with fixed chrome allowance; investigate actual
  text metrics, decoration padding and responsive constraints before revising
  this widely used component. This visual defect remains open. Other remaining
  work includes per-file deep review, secondary forms, room draft/chat/presence
  races, authentication cancellation and controlled performance measurements.

- Compact `AppSelect` sizing now measures option/hint text using the dropdown's
  actual theme style and text scaler, includes decoration/icon space, and caps
  its width by the viewport. Measuring all options keeps selection changes
  from shifting toolbar layout. Existing explicit widths and parent constraints
  remain respected. Thirteen new control tests cover Chinese/English, three
  text scales, two viewport widths, optional leading icons, long options and
  actual menu selection under narrow parent constraints.
- Fifteen room/user/provider admin filters no longer impose fixed 96-126 px
  outer widths on the shared select. `_AdminToolbarItem` supports natural
  control sizing while `_AdminToolbarWrap` constrains every item to available
  space. Four integration tests directly inspect rendered Chinese status,
  ban-state and page-size text for truncation on room/user pages at 320/1200 px.
- Validation checkpoint: all 1164 tests passed (`sixtyfourth-tests.log`),
  analysis/Web release build passed (`sixtyfourth-analyze.log`,
  `sixtyfourth-web.log`), and architecture/UI/whitespace checks passed. Browser
  Use verified complete member role/join-time labels and usable dropdown menus
  at desktop/320 x 568, then verified the final room toolbar with complete
  category/status/ban/sort/page-size labels at both widths. Viewport restored;
  no saved account or member data changed. This resolves the compact-select
  truncation recorded above for the tested defaults and admin filters.
- Remaining visual follow-up: the mobile admin navigation still ellipsizes
  its category-and-labels title in a fixed grid cell. Review that navigation
  layout, other explicit-width select callers, remaining component contracts,
  and the broader per-file/integration/performance gaps already recorded.

- Mobile admin navigation now uses the existing scrollable tab bar instead of
  a four-column fixed-height grid. Labels retain their full text, tab height
  follows text scaling, and the active tab scrolls into view. The existing
  desktop sidebar, lazy section construction and retained section state remain.
  Four new integration cases inspect all 12 tab labels in Chinese/English at
  1x/2x text, exercise room/user switching and preserve an unsent search draft
  through desktop/mobile transitions without reloading the rooms.
- These tests exposed adjacent defects: the users page's fixed header overflowed
  at narrow widths/enlarged text, and room status rows overflowed in narrow
  record content. Users now use one lazy sliver scroll view for filters, batch
  actions, pagination and results. Shared admin records stack actions earlier
  when text is enlarged, and room status/ID metadata wraps naturally.
- Room/user batch bars now share a wrapping component. Two additional tests
  exercise selecting and clearing at 320 x 568 with 2x text and verify all
  batch commands remain within the viewport. The change also removes duplicate
  batch-bar layout code and the separate mobile navigation implementation.
- Validation checkpoint: all 1170 tests passed (`sixtysixth-tests.log`),
  analysis/Web release build passed (`sixtysixth-analyze.log`,
  `sixtysixth-web.log`), and architecture/UI/whitespace checks passed. Browser
  Use inspected 320 x 568 navigation, selected the full category-and-labels
  tab, switched to users and inspected batch selection/clear. All test
  selections were cleared and desktop viewport restored. No user records were
  mutated. The mobile navigation-title truncation recorded above is resolved.
- Further audit candidates remain: providers/reviews/bans/streams/cache and
  some runtime views still contain fixed header/list columns and need direct
  short-viewport/enlarged-text checks. Mobile overview metrics leave substantial
  unused horizontal space at 320 px. Broad per-file, asynchronous boundary,
  external integration/device and controlled performance work remains open.

- Providers, bans, reviews and streams now share a lazy `_AdminPagedList`:
  filters, pagination and results scroll together, so short viewports and
  enlarged text no longer reserve most of the height for fixed headers.
  Provider records reuse the responsive admin record layout; endpoint,
  timestamps, enabled state and actions can wrap or stack on compact screens.
- Cache maintenance controls and statistics now share a sliver scroll view.
  Metrics use responsive column widths that account for text scaling, and
  values no longer have forced single-line truncation. Refresh avoids starting
  another request while loading. Twenty new secondary-list cases cover five
  admin sections at 320 x 480 / 740 x 320 and 1x/2x text; two cache cases
  verify bottom statistics and scrolling back to maintenance controls with
  fake operations. Cache tests wait for layout after scrolling before
  asserting hit-testability.
- Validation checkpoint: all 1192 tests passed (`sixtyeighth-tests.log`),
  analyzer and Web release build passed (`sixtyeighth-analyze.log`,
  `sixtyeighth-web.log`), and architecture/UI/whitespace checks passed.
  Browser Use inspected Provider and cache at 320 x 480, scrolled through
  cache capacity/TTL details, inspected reviews and bans at 740 x 320, and
  checked Provider/streams at 1440 x 900. These lists have no live records;
  nonempty data is covered by widget tests. No maintenance or record
  mutations were performed against the live backend.
- Overview statistics now use `AppResponsiveWrap` instead of 156px fixed
  cards, filling available column width and reducing columns as text grows.
  Browser Use verified six desktop columns and full-width cards at 320 x 480,
  including scrolling to the final statistic. The final overview adjustment
  passed all 97 admin tests (`sixtyninth-admin.log`), analysis, Web release
  build and architecture/UI/whitespace checks. Browser viewport restored.
- Remaining audit candidates include the runtime-settings fixed header and
  two-pane layout, Provider metadata chip limits, other explicit-width select
  callers, remaining form validation/controller lifetimes and asynchronous
  boundaries. Full handwritten-file deep review, external integrations,
  device runtime and controlled performance measurements remain incomplete.

- Runtime settings: new 2x-text cases reproduced horizontal overflow in the
  email and OAuth section headers at 320px (256px and 340px respectively).
  Headers now stack their title and wrapping actions when space is limited.
  Compact layouts scroll the category selector, refresh control, section
  header and settings together; two-pane layout also accounts for text size.
  The settings list remains lazy and existing serial writes/stale-read guards
  remain covered by the concurrency test.
- Browser inspection found another runtime-layout issue: a setting's leading
  icon and trailing switch compressed its description/warning into a narrow
  column. Setting tiles now reuse `_AdminRecordTile`, placing controls beneath
  the content on compact layouts. Six regression cases cover email/OAuth at
  320 x 120, 320 x 240 and 740 x 320 with 2x text. They scroll to actions,
  verify usable description width and switch reachability, then return to the
  category toolbar. Initial 120px-height test failures were finder errors
  caused by looking up a lazy child before scrolling, not production overflow.
- Final validation: all 1198 tests passed (`seventyfirst-tests.log`), analysis
  and production Web build passed (`seventyfirst-analyze.log`,
  `seventyfirst-web.log`), and architecture/UI/whitespace checks passed.
  Browser Use exercised the production runtime components with fixed data via
  `tool/runtime_settings_showcase.dart`: 320 x 240, 740 x 320 and 1800 x 900,
  2x text, scrolling, category-menu selection and compact/desktop transitions.
  The previously authenticated test tab was no longer available; the new
  live-backend tab had no session, so this turn's runtime browser checks use
  the isolated preview rather than a live admin session. Preview server stopped
  and viewport restored. No real configuration writes or email sends occurred.
- Runtime follow-up: `_sendTestEmail` still creates an undisposed text
  controller and needs dialog lifetime/submission review. Other editor forms,
  remaining metadata constraints and the broader per-file/integration/device
  and controlled-performance coverage remain open.

- Test-email workflow now lives in `SendTestEmailDialog`, which owns and
  disposes its text controller. It validates a nonempty trimmed recipient,
  prevents same-frame duplicate submission, keeps input after server failure,
  disables editing during a send, and ignores callbacks after cancellation,
  back navigation or disposal. Address syntax remains server-validated.
  The runtime page coalesces repeated dialog opens and displays success only
  when a send completes through the active dialog. A cancelled in-flight
  request is not cancelled at the transport/server layer.
- Seven new tests cover blank input, trimmed recipients, duplicate button and
  keyboard submission, failure/retry, late success/failure after dismissal,
  disposal, controller release, large-text phone/landscape layout, and repeated
  opening/reopening from the runtime page. All 1205 tests passed
  (`seventysecond-tests.log`). An explicit mounted check was then added for
  the analyzer; all 14 related tests passed (`seventythird-email-runtime.log`),
  final analysis/Web build passed (`seventythird-analyze.log`,
  `seventythird-web.log`), and architecture/UI/whitespace checks passed.
- Browser Use exercised the production dialog through the isolated runtime
  preview with 2x text at 320 x 568, 740 x 320 and 1440 x 900: blank validation,
  retained recipient after a simulated failure, successful retry, reopening
  and cancellation. The preview gateway simulates the first send failing and
  the next succeeding; it never sends email. Preview server stopped and
  viewport restored. The undisposed test-email controller noted above is now
  resolved; other runtime editor open/confirm/lifetime boundaries and broader
  project coverage remain pending.

- Runtime edit intents now coalesce by section/setting key across editor,
  confirmation and write phases. Different setting keys retain independent
  intents and the existing serialized-write behavior. Callbacks from covered
  or departed parent routes cannot start a new edit/write. Ordinary and OAuth
  editors guard save/cancel/close against duplicate or stale callbacks.
- Risk and OAuth-delete confirmation now use the shared `AppConfirmDialog`
  with the dialog's own context and a guarded completion callback. Repeated
  confirmation cannot pop the underlying settings page. Nine new tests cover
  ordinary edits, boolean risks, OAuth edits/deletions, cancellation and
  confirmation, repeated opens/completion, plus callbacks from an editor
  covered by another dialog or already disposed. Tests retain a separate
  parent route and assert write counts as well as navigation survival.
- Validation: all 1214 tests passed (`seventyfourth-tests.log`), analysis and
  Web release build passed (`seventyfourth-analyze.log`,
  `seventyfourth-web.log`), and architecture/UI/whitespace checks passed.
  Browser Use saved a Host value at 1440 x 900, then cancelled and confirmed
  a boolean risk at 320 x 568, checking the unchanged/updated switch states.
  This used the production widgets with the isolated preview gateway, which
  now persists edits in memory. No live server configuration was changed.
  Preview server stopped and viewport restored.
- Remaining runtime work includes complex editor short-viewport/large-text
  layout, refresh-versus-open-draft semantics and other typed-value boundaries.
  This is not a claim of complete editor or whole-project coverage.

- Complex runtime editors now share `_SettingsEditorFrame`. Titles,
  descriptions, warnings and form fields scroll together while actions remain
  available below the content. The duplicate keyboard inset and nested size
  constraints were removed in favor of the existing dialog frame. This also
  removes duplicated ordinary/OAuth editor shell code without moving field
  state or controllers out of their existing owners.
- An 11-editor matrix initially failed 21 of 22 phone/landscape cases with
  enlarged text, mostly because fixed headers/warnings overflowed vertically;
  two cases could not reach the input. Final coverage has 33 cases: text,
  number, optional text, enum, string list, permissions, SMTP credentials,
  SMTP proxy, ICE servers, structured values and OAuth, each at phone,
  landscape and phone with a 220px keyboard inset. Tests verify input and
  action reachability, retained text draft, cancellation, no layout exceptions
  and untruncated save labels. A subsequent keyboard-test setup failure was
  resolved by explicitly selecting the content scrollable.
- Browser Use revealed the OAuth footer's equal-width buttons truncating
  "Save instance" at 320px/2x text. Actions now wrap at their content width,
  and both editor types use the standard "Save" command. Browser checks of
  the final production widgets in the isolated preview covered 320 x 568,
  740 x 320 and desktop, including the long OAuth form's bottom controls and
  cancellation. No provider was created. Preview server stopped and viewport
  restored; native keyboard behavior is represented by widget-test insets,
  not a physical-device run.
- Final validation: all 1247 tests passed (`seventysixth-tests.log`), analysis
  and production Web build passed (`seventysixth-analyze.log`,
  `seventysixth-web.log`), and architecture/UI/whitespace checks passed.
  Remaining runtime concerns include typed-value validation, refresh versus
  an open draft, long helper-label treatment and provider-specific contracts.
  Whole-project deep review and previously recorded integration/performance
  gaps remain open.

- Runtime numeric saving previously converted any numeric input without a
  literal decimal point to an integer: `1e-3` became zero, nonfinite values
  passed validation, and 64-bit values could lose precision on Web. The known
  runtime numeric fields were checked against the backend `admin.proto`
  settings patches and the frontend protobuf JSON conversion path.
- `runtime_setting_number.dart` now validates known uint32/int64/uint64 fields
  as decimal integers within wire-type bounds. It uses BigInt for parsing and
  retains 64-bit values as protobuf JSON decimal strings. Unknown numeric
  fields preserve finite fractions/exponents without forced truncation.
  The form and save path use the same parser, with localized integer guidance.
  These bounds are transport bounds; server-specific business limits remain
  server-validated.
- Ten new tests cover protobuf round-trips for 32/64-bit boundaries, values
  beyond JavaScript's safe integer range, overflow, unsigned negatives,
  fractions/exponents, nonfinite values, invalid form input with no write,
  unchanged large-integer saves and fractional generic saves. All 1257 tests
  passed (`seventyseventh-tests.log`); final analysis/Web build and
  architecture/UI/whitespace checks passed (`seventyseventh-analyze.log`,
  `seventyseventh-web.log`).
- Browser Use verified an unchanged uint64 maximum value after saving on Web
  at 1440 x 900, and an inline rejection of `1e-3` for SMTP port at 320 x 568.
  Checks used the isolated preview's in-memory data; no live configuration
  was changed. Preview server stopped and viewport restored. Permission-bit
  preservation, SMTP structured-value rules, open-draft refresh conflicts and
  the wider coverage gaps remain to be examined.

### Runtime Permission Wire Preservation (Seventy-eighth Pass)

- Confirmed that the server retains numeric permission bits, while the editor
  previously rebuilt values from known names and silently discarded unknown
  permissions. Numeric JSON decoding and integer bitwise operations also made
  this unsafe for Web uint64 values.
- Permission strings now bypass numeric JSON decoding. BigInt masks preserve
  all original unknown bits while updating known selections; saves use exact
  protobuf decimal strings. Existing integer and name-list inputs remain
  supported.
- Eleven regression cases exercise unchanged saves, toggling the chat bit,
  unknown high bits, values beyond JavaScript integer precision, uint64 max,
  legacy input formats and protobuf patch round-trips. They pass on both the
  native test runner and Edge's Web test runner. All 1268 tests, static analysis,
  production Web build, architecture/UI guards and whitespace checks passed
  (`seventyeighth-*` logs).
- Browser Use inspected the production permission editor in the isolated
  in-memory preview at desktop size and 320 x 568. Saving and reopening retained
  the selected state; the complete mobile list and footer actions were reachable
  without overlap. Exact wire preservation is asserted by the Web regression
  tests. No live settings were changed; viewport restored afterward.
- Open-draft refresh conflicts, structured SMTP values, unknown-permission
  presentation, wider per-file review and the validation limits below remain
  open. Passing this checkpoint does not complete the full audit.

### Runtime Draft Conflicts And Queued Writes (Seventy-ninth Pass)

- A pending refresh can complete after a setting editor or confirmation opens.
  Saving previously overwrote the refreshed target with the old draft, including
  an entire OAuth provider list. Writes now compare the target field against the
  latest received settings immediately before dispatch. A changed or removed
  target produces localized conflict feedback without sending a write.
- Structural equality allows equivalent nested maps with different key order,
  and changes to unrelated fields do not prevent saving. The existing transitive
  `collection` package is now a direct dependency for its deep equality API.
- Queued writes also stop after disposal. Responses are applied inside the
  serial operation before the next queued operation validates its snapshot.
  A new test initially exposed this ordering gap and passes with that correction.
- Fourteen new cases cover text, boolean, OAuth edit/delete, changed/removed
  targets, unrelated refreshes, structurally equivalent maps, queued conflicts
  and disposal. Final full suite: 1282 passing tests. Final analysis, production
  Web build, architecture/UI guards and whitespace checks passed. Use the
  `seventyninth-*-final.log` and `seventyninth-web.log` results; earlier runs
  captured the queue ordering failure and a subsequently corrected lint.
- Browser Use reproduced delayed-refresh conflicts on desktop and at 320 x 568
  in the isolated preview. The new value remained visible, the conflict message
  wrapped correctly, and reopening the editor used the new value. No live
  configuration was changed; preview server stopped and viewport restored.
- This protects changes already received by this frontend. Atomic cross-client
  conflict prevention needs a server revision/precondition contract. Conflicts
  currently close the old editor and require reopening; retaining a draft for
  comparison remains a possible UX improvement. Structured SMTP validation,
  unknown-permission presentation and wider per-file audit remain open.

### SMTP Validation And Complete Form Errors (Eightieth Pass)

- Checked SMTP credential patch semantics against the server: omitted passwords
  preserve existing credentials for the same username, explicit configuration
  removal clears them, and password whitespace must be preserved. Regression
  tests now exercise those editor-to-gateway behaviors.
- Replaced the SOCKS5 prefix-only check with URI validation for host, scheme,
  credentials, path/query/fragment and port bounds. A lazy `Uri.port` exception
  for huge inputs and URI normalization of literal spaces were caught during
  testing and handled. Proxy credentials enforce the server's 255 UTF-8 byte
  bound independently for username and password.
- Browser testing exposed single-line truncation of validation errors at large
  text sizes. Shared `AppTextField` now renders both explicit and validator
  errors as wrapping text. Four rendering tests cover both error sources at
  320/740 widths with 2x text; eight SMTP tests cover endpoint rules, validation,
  secret preservation/clearing, username changes and UTF-8 boundaries.
- Final suite: 1294 tests passed (`eightieth-tests-verified.log`). Analysis,
  production Web build and architecture/UI/whitespace guards passed. Final
  focused results are in `eightieth-ui-final.log`; earlier SMTP runs record
  issues corrected before the final suite.
- Browser Use verified complete error text, scrolling and reachable actions at
  1440 x 900 and 320 x 568 with 2x text. The isolated preview made no network
  writes or email sends. Preview stopped and browser viewport restored.
- Further findings remain open: a success toast can intercept a subsequently
  opened dialog's action briefly, and long floating field labels truncate at
  narrow widths with enlarged text. Unknown-permission presentation, the wider
  module inventory/deep audit and device/integration limits also remain open.

### Notification Hit Testing And Lifecycle (Eighty-first Pass)

- Passive global notifications previously intercepted taps on controls beneath
  them, including a reopened SMTP dialog's Save action. They now ignore pointer
  events while retaining a live-region semantic announcement. Notifications
  with actions remain interactive.
- Action callbacks verify that their notification is still active, dismiss it
  before invoking the action, and ignore repeated/stale invocations. Removed
  overlay entries are disposed, including expiry after the owning overlay ends.
- Four added tests verify pointer passthrough and actual live-region semantics,
  once-only actions, stale callbacks after replacement and post-disposal expiry.
  The SMTP repeated-edit test now saves immediately without a toast-expiry wait.
  All 1298 tests, static analysis, production Web build and architecture/UI/
  whitespace checks passed (`eightyfirst-*`; focused final results in
  `eightyfirst-notifications-final.log`).
- Browser Use verified actual overlap between a passive toast and an underlying
  button on desktop and at 320 x 568: the underlying counter advanced while the
  notification remained visible. Undo actions were also exercised on both
  widths. The isolated preview was stopped and the viewport restored.
- This resolves blocked interaction; temporary visual overlap, long actionable
  notification layout, and real screen-reader behavior still need wider review.
  Long floating field labels, unknown permissions and the full handwritten
  module inventory remain open. Subsequent passes should broaden the inventory
  instead of treating these targeted runtime fixes as whole-project coverage.

### Reproducible File Inventory (Eighty-second Pass)

- Added a deterministic source inventory spanning application Dart, Web source,
  platform entrypoints, local packages and maintenance scripts. Generated code
  and browser vendor bundles are listed separately; test directories, assets
  and build caches are excluded. Configuration and device/performance reviews
  remain explicitly separate scope requirements.
- The evidence ledger distinguishes partial review from reviewed source scope.
  Changed source fingerprints produce `needs-review`; new files are unreviewed.
  Missing evidence, missing source records and stale generated reports fail
  validation instead of silently disappearing.
- Three focused tests exercise companion-source inclusion, exclusions,
  deterministic output, changed/new files and missing evidence/source records.
  Focused tests, static analysis and inventory consistency checks passed. This
  pass changes audit tooling/documentation only, so no new app build or browser
  run is claimed; the previous 1298-test/browser baseline remains applicable
  to unchanged product code.
- Initial inventory: 382 handwritten/support files, with 5 explicitly scoped
  records backfilled. This is coverage bookkeeping, not a claim that the other
  files have never been exercised or that the full audit is complete.

### Session Recovery And Data-Layer Inventory (Eighty-third Pass)

- Read the session store and memory cache, and inspected protected-request /
  token-refresh generation guards. Registered their precise partial-review
  scopes in the source ledger instead of inferring full coverage from tests.
- A malformed saved `session` value previously threw during a Map cast and
  prevented the entire server list from loading. Recovery now treats invalid
  session shapes as anonymous while preserving server metadata and valid
  neighboring profiles. Non-string preference values no longer throw through
  typed getters. Numeric/list token and guest fields are no longer coerced into
  credential strings; a valid remaining refresh token can still be recovered.
- Eight added tests cover malformed sessions, wrong preference types, guest
  field types, retained neighboring credentials and subsequent server switching.
  Full suite: 1309 passing tests. Analysis, production Web build, architecture/
  UI/whitespace guards and source-inventory checks passed (`eightythird-*`).
- Browser Use exercised the real startup component, session store and server
  settings dialog with isolated mock preferences. Startup recovered anonymously
  and server metadata remained readable at desktop and 320 x 568. Web hides
  server switching by design; credential recovery on switching is asserted in
  automated tests. No real preferences or external servers were modified.
- Cache capacity/expired-entry retention, raw upload/header precision, full
  response conversion and concurrent load/mutation review remain open. The
  temporary preview was stopped and browser dimensions restored.

### Bounded Memory Cache (Eighty-fourth Pass)

- Room and notification cache keys include search/filter/page variants. The
  previous cache retained every completed result indefinitely in its map even
  after TTL expiry. It now has a configurable positive capacity (default 256
  completed entries), LRU ordering, and lazy expiry cleanup on reads/writes.
- Loader results and explicit puts share the same eviction policy. Zero or
  negative TTL results do not displace live entries. In-flight coalescing and
  invalidated/superseded-result protection remain independent of LRU eviction.
- Six added tests cover recency, expiry at the boundary, loader/put capacity,
  pending-request coalescing during eviction, nonpositive TTL and invalid
  capacity. Full suite: 1315 tests passed. A subsequent collection-literal lint
  adjustment was rechecked by all 13 cache tests; final static analysis/Web
  build and architecture/UI/whitespace/inventory checks passed.
- Browser Use exercised the real backend homepage: desktop category filtering,
  mobile refresh with retained filters, and search returning the expected room
  at 320 x 568. These are integration smoke checks; cache capacity/eviction is
  established by automated tests, not inferred from the screenshots. Search was
  cleared and browser dimensions restored.
- The limit counts completed entries, not bytes or active network requests.
  Idle expired entries are reclaimed on the next access/write; no background
  timer is introduced. This bounds retention without claiming measured frame
  rate/startup gains. Caller key policy and broader data-layer review remain
  open; the cache's implementation scope is recorded in the source ledger.

### Upload Session Boundaries And Web Encoding (Eighty-fifth Pass)

- All six image upload workflows now retain the original account/session and
  endpoint generation through plan creation, session creation, multipart PUTs,
  completion and attachment updates. A change stops subsequent requests and
  rejects stale results; refreshing tokens within the same session continues.
  Already-dispatched requests are not cancelled or rolled back.
- Running the new tests in Edge exposed an existing Web upload failure:
  `ByteData.setInt64/setUint64` are unsupported in JavaScript builds. Manifest
  and ownership-proof encoding now uses the existing `fixnum` byte conversion
  in big-endian order. A fixed ownership-proof vector independently computed
  from the backend's wire layout verifies the resulting bytes and hashes.
- Raw object response sizes and content ranges now parse exact nonnegative
  signed64 decimal values without an intermediate JavaScript number. Overflow,
  negative sizes, reversed ranges and endpoints outside the total are rejected;
  malformed metadata retains the existing fallback behavior.
- Added 87 upload workflow cases across six image types and 19 header cases.
  All 106 pass in Edge's Web test runner; focused native/protocol tests pass
  (309), and the full suite passes (1421). Final static analysis, release Web
  build, architecture/UI guards, whitespace and source-inventory checks pass.
  Initial Web failure logs are retained separately from the successful
  `eightyfifth-browser-tests-fixed.log`; final native/build logs use
  `eightyfifth-*-final.log`.
- Browser Use inspected the latest release against the real backend: desktop
  login, 320 x 568 login/registration and user-agreement dialogs. No overlapping
  controls were observed in these states. Agreement content scrolls while its
  actions remain visible; reaching the bottom enables acceptance, and choosing
  disagreement exits to a blank page. No account, image or configuration was
  submitted. Browser dimensions were restored.
- These browser screenshots establish layout smoke coverage, while mocked Web
  protocol tests establish upload/session regressions. Real storage uploads,
  deduplication integration, malformed upload plans, uploaded-part header IDs,
  native device behavior and adverse-network testing remain open. The source
  ledger therefore records partial upload-service and API-client coverage.

### Upload Plan And Proof Validation (Eighty-sixth Pass)

- Upload plans previously validated individual ranges only. They now require
  the backend's SHA-256 algorithm, positive part size, consecutive part numbers,
  contiguous offsets, expected part lengths and exact full-file coverage before
  hashing or sending the second session request. Missing, overlapping, repeated,
  reordered or oversized parts fail with a domain error.
- Validation compares `Int64` values before converting bounded byte offsets.
  Ownership-proof ranges likewise use subtraction-based bounds checks before
  conversion, avoiding overflow or Web rounding in range arithmetic. Part-size
  metadata stays `Int64` through manifest serialization, including values above
  the JavaScript safe-integer range.
- Added 30 tests for malformed plans, unsupported algorithms, invalid proof
  ranges, a short final part and a fixed large-part-size digest vector. Focused
  native/protocol tests pass (320), Web plan/session tests pass in Edge (117),
  and the complete suite passes (1451). Static analysis, release Web build,
  architecture/UI guards, whitespace and inventory checks pass. Logs use the
  `eightysixth-*` prefix in the local review output directory.
- Browser Use inspected the real backend's latest release: guest authentication
  form at desktop and 320 x 568, readable copy, input/action layout, visible
  agreement controls and dismissal back to discovery. No overlap was observed
  in these states. No guest session or server data was created; dimensions were
  restored. Upload validation is established by mocked protocol tests, not
  these unrelated UI smoke checks.
- Remaining upload-session metadata, storage-provider integration and adverse
  networking still require review. Session-store loading is reached through
  runtime initialization; its ordering against state mutations remains the
  next data-layer audit item. Upload-service coverage remains partial.

### Session Restore Ordering (Eighty-seventh Pass)

- A delayed preference loader could overwrite a newer logout, token refresh,
  server selection or inactive server addition. Restore now checks its load
  revision, store mutation revision, session generation and identity before
  applying persisted state. The latest load wins if loaders finish out of order.
- Store mutations share a persistence wrapper that tracks pending saves and
  clears its counter on success or failure. Restore preserves current memory
  while a save or startup repair is pending, preventing reads of an older or
  partially written server/active-endpoint pair. Normal subsequent loads and
  retries remain supported; this does not make the underlying two preference
  writes atomic across application crashes.
- Nine added regressions cover delayed logout/selection/inactive addition,
  token refresh, clearing an already-anonymous session, out-of-order loads,
  pending saves, startup repair and loader retry. All 38 native store/runtime
  tests pass, along with the full 1460-test suite, static analysis, release Web
  build and architecture/UI/whitespace/inventory checks.
- The complete store/runtime file was also attempted in Edge: 35 tests passed
  and three native-only runtime expectations failed because Web deployments
  enforce the current origin and secure TLS policy. The targeted restore run
  passes all 11 tests, including the nine new regressions. The full attempt and
  targeted result are retained as `eightyseventh-browser.log` and
  `eightyseventh-browser-restore.log`; native verification uses the
  `eightyseventh-*` review logs.
- Browser Use verified startup against the real backend's latest release and
  the server-information sheet at desktop and 320 x 568. Server metadata wraps,
  the completion action remains available, and dismissal returns to discovery.
  No remote configuration or credentials were changed; dimensions restored.
- The store's mutable public fields can still be changed without its mutation
  methods; those direct writes are outside the new revision contract. Runtime
  initialization/selection/probe integration and actual native storage remain
  open, so the source-ledger entry continues to report partial coverage.

### Server Selection Consistency (Eighty-eighth Pass)

- Adding a server previously advanced selection revision only after its probe
  finished, allowing a slow earlier probe to override later user selection.
  It now records revision on dispatch and rejects superseded results before
  changing API configuration or persisting a profile. A newer failed attempt
  also supersedes the older intent; the existing active server stays selected.
- Runtime removal now verifies the profile exists and is removable before
  configuring the API. Previously removing an active built-in profile changed
  the API endpoint even though the store correctly retained that profile.
  Valid removals also supersede outstanding selection attempts.
- Seven new native-only tests cover slow additions versus selection, direct
  endpoint change, newer addition and removal, a failed newer addition,
  built-in removal, and inactive removal preserving endpoint and credentials.
  All 45 focused store/runtime tests and the full 1467-test suite pass, along
  with static analysis, release Web build, architecture/UI/whitespace and
  inventory checks. Review logs use the `eightyeighth-*` prefix.
- Browser Use verified the latest release's fixed-origin startup and server
  information sheet on desktop and 320 x 568, including a real information
  refresh, unchanged endpoint, readable metadata and dismissal. Dimensions
  restored. Multi-server mutation regressions are established by native tests;
  browser deployments intentionally do not expose those operations.
- The runtime source is newly registered as partial coverage. Full init/auth
  and resource lifetimes, native device integration and remaining room/shared
  UI audits are still open.

### Long Notification Actions (Eighty-ninth Pass)

- A long notification action at 2x text caused a horizontal RenderFlex overflow
  of 605 pixels at a 320-pixel viewport. Actionable notifications now place the
  action below the message. Shared `AppActionButton` has opt-in label wrapping,
  enabled for toast actions, so operation names remain readable. Default button
  behavior and the notification's three-line message limit remain unchanged.
- Two regressions check 320/740 widths at 2x text, absence of layout overflow,
  contained button bounds, untruncated action text and successful activation.
  Existing duplicate/stale callback, passive hit-testing and disposal tests
  pass. Focused notification/shared-control tests pass (103); the full suite
  passes (1469), along with static analysis, release Web build, architecture/UI
  guards, whitespace and source-inventory checks.
- The notification showcase now includes a long restore action and 2x text.
  Browser Use verified the compiled preview on desktop and 320 x 568: message
  and action fit, the narrow action wraps over two lines, clicking dismisses
  the toast, and the operation counter advances from zero to one to two.
  The temporary preview server was stopped and browser dimensions restored.
- Initial failing logs demonstrate both overflow and truncation before the
  final changes; successful focused/analysis/preview logs use
  `eightyninth-*-final.log`, with full-suite/build results in the corresponding
  `eightyninth-tests.log` and `eightyninth-web.log`.
- Keyboard/safe-area combinations, extreme content height and actual screen
  readers remain open. Room delayed mutations/chat state were searched in
  this pass but are not claimed as reviewed by this notification fix.

### Chat Read Cursor Deduplication (Ninetieth Pass)

- History loading, realtime events and chat-panel visibility can report the
  same visible message repeatedly. The read-state coordinator now remembers
  only the last successfully acknowledged cursor and suppresses duplicate
  sends, including duplicate visibility events queued during that request.
  Failed requests remain eligible for a later visibility-driven retry.
- Five added tests cover in-flight/successful duplicates, failure retry,
  first/second/first transitions and disposal during successful/failed requests.
  All seven coordinator tests pass on native and Edge Web. The full 1474-test
  suite, static analysis, release Web build, architecture/UI guards, whitespace
  and inventory checks pass; review logs use the `ninetieth-*` prefix.
- This pass changes request coordination only and adds no new visual coverage
  claim. The earlier Browser Use layout evidence remains separately scoped.
  The coordinator implementation is recorded as reviewed, with message ordering
  and backend read semantics outside its contract. It does not infer chronology
  from opaque message IDs or schedule autonomous retries.
- Room chat inspection identified a remaining consistency risk: realtime list
  replacement and `_indexChatMessage` can accept an older version, while pin,
  reply and history paths maintain additional copies. A delayed edit response
  can overwrite a newer event. The next room task must coordinate version and
  deletion handling across those copies, with tests for response/event ordering;
  the current cursor change does not claim to fix that issue.

### Canonical Chat Message State (Ninety-first Pass)

- Room chat previously replaced timeline entries and reply cache independently,
  permitting delayed older edits or history to undo newer content and allowing
  deleted messages to reappear. `RoomChatMessageState` now owns canonical content,
  timeline and pinned projections, rejects lower versions, and retains terminal
  deletion tombstones for the room lifetime.
- History, pin snapshots, realtime messages, edit/reaction/send results and
  reply/context loads use the shared merge path. Local snapshot revisions keep
  same-version reads from overwriting active updates received during the request;
  passive reads do not invalidate concurrent initial history/pin snapshots.
  New content updates existing pins and references, while pin metadata remains
  independently managed because backend message versions cover edit/delete.
- History/pin completion checks current history permission. Incoming paths
  recheck blocked users. Delete/edit confirmations check mounted state and send
  completion only clears the input controller while mounted. Realtime resume
  cursors still advance when stale message content is ignored.
- Fourteen state tests cover version ordering, terminal deletions, history
  repair, same-version reactions, newer-version precedence, unrelated entries,
  concurrent initial reads and pin refresh/unpin/add races. All pass natively
  and in Edge. The full 1488-test suite, final analysis, release Web build,
  architecture/UI guards, whitespace and inventory checks pass. Final logs use
  `ninetyfirst-*-final.log`, plus `ninetyfirst-browser.log` and
  `ninetyfirst-web.log` for Web tests and production output.
- Browser Use exercised the shared state in an isolated compiled preview:
  desktop edit followed by late history preserves updated timeline/pin/reply
  text; 320 x 568 deletion followed by late history leaves both lists empty and
  the reply marked deleted. Controls wrap without overlap. The temporary server
  was stopped and dimensions restored. This validates the state-backed preview,
  not a real multi-client backend conversation.
- Equal-version ordering between independent read snapshots, independent live
  pin/reaction streams, retention of cached entries/revision metadata and full
  RoomScreen integration/device workflows remain open. The new state and room
  source records therefore report partial coverage rather than full room review.

### Independent Chat Updates And Snapshot Ordering (Ninety-second Pass)

- A shared update marker let reaction changes suppress pending pin responses
  and pin changes suppress pending reaction responses. Content and pin updates
  now track independent revisions. Pin changes preserve newer canonical content
  and cannot revive deleted messages.
- History, pin, reply and context reads allocate snapshot tokens at dispatch.
  Older same-version snapshots cannot replace newer accepted reads. Full pin
  snapshots retain their sequence even when empty, preventing an older nonempty
  response from restoring removed pins. Missing pins can be removed without
  discarding a newer reaction update.
- Nine added regressions bring the state suite to 23 tests, all passing natively
  and in Edge Web. All 1497 full-suite tests, static analysis, production Web
  build, architecture/UI guards, whitespace and inventory checks pass. Logs use
  the `ninetysecond-*` prefix.
- Browser Use exercised the compiled state preview on desktop and at 320 x 568:
  React and unpin followed by Late response retains Reactions: 2, Pinned: 0 and
  consistent message/reply text. Controls wrap without overlap. Viewport was
  restored and the temporary preview server stopped. This is isolated preview
  evidence; live multi-client backend conversation remains unverified.
- Cache and revision-map retention, direct collection mutations, full room
  lifecycle/permission integration and same-version live event delivery ordering
  remain open. Source records remain partial, and the broader goal stays active.

### Chat Permission Reset (Ninety-third Pass)

- Revoking chat-history access previously cleared only visible lists, leaving
  message/reply and receipt caches intact. Pending context and reply requests
  could still complete after revocation; checking only current permission also
  allowed pre-revocation requests after permission was granted again.
- Message state now clears projections, canonical cache and revision maps while
  advancing a reset boundary. All response merge paths reject older tokens,
  including uncached history entries and full pin snapshots. New requests can
  load independently after a reset.
- Room permission revocation clears reply/receipt caches, loading IDs, message
  keys, active action references and highlights. History, pins, reply, context
  and receipt reads check current access and the reset boundary. Old completions
  cannot clear a newer request's post-reset loading state. Realtime chat/pin
  events are ignored while history access is forbidden.
- Five new tests cover complete clearing, old history/pin/mutation completions,
  new reads after tombstones and old empty pin responses after fresh loads.
  All 28 state tests pass natively and in Edge Web; the full 1502-test suite,
  analysis, production Web build, architecture/UI guards, whitespace and source
  inventory checks pass. Logs use the `ninetythird-*` prefix.
- Browser Use on the compiled preview verifies Revoke access then Late response
  leaves Messages: 0, Pinned: 0 and an empty reply on desktop and 320 x 568.
  Controls wrap without overlap. Viewport was restored and preview server
  stopped. The preview exercises the state reset, not a live member permission
  change in RoomScreen.
- Already-open detail dialogs, blocked-user pending receipt responses, send-only
  workflows, complete permission transition integration and room-lifetime cache
  retention remain to be examined. The source records and overall goal remain
  partial and active respectively.

### Chat Detail Dialog Recovery And Layout (Ninety-fourth Pass)

- Reaction-user loads had no catch handler, so initial and paginated failures
  escaped as asynchronous exceptions without a retry action. The dialog now
  shows a localized failure and retry, preserves existing members and the cursor
  on pagination failures, and contains failures after disposal. Successful
  retries retain the existing member deduplication behavior.
- Read receipts now stack reader/unread sections below 600 logical pixels or
  above 1.5 text scale, retaining desktop side-by-side comparison and independent
  scrolling lists. The shared divider preserves project UI conventions.
- Six widget tests cover initial retry, pagination recovery with the same
  cursor, failure after disposal and layouts at 320/800 widths including 2x text.
  Final full suite: 1508 tests passed. Static analysis, standalone showcase
  analysis, release Web build, architecture/UI guards and whitespace/inventory
  checks pass. Logs use `ninetyfourth-*`; final full-suite and preview builds use
  `ninetyfourth-full-final.log` and `ninetyfourth-preview-final.log`.
- Browser Use exercised the actual dialogs with fixture loaders: desktop and
  320 x 568 reaction failures recover to two members after retry; read details
  switch from parallel columns to stacked sections, with both phone lists
  independently scrolled to their final member. Close remains visible and works.
  No overlapping text was observed. Viewport was restored and preview server
  stopped. Backend data loading and live permission changes were not exercised.
- Both sources now have partial evidence records. Pending blocked-user receipt
  responses, already-open dialog permission lifecycle, abnormal timestamps and
  reaction cursor/identity transitions remain open, alongside the broader audit.

### Reaction Pagination And Identity (Ninety-fifth Pass)

- Repeated next cursors allowed indefinitely repeated Load more requests.
  Successful cursors are now remembered per dialog identity, ending pagination
  for direct repeats and longer cycles. Failed requests do not consume their
  cursor, preserving retry behavior.
- Both initial and subsequent pages merge by user ID. Duplicate first-page
  members render once, and newer overlapping records update existing member
  names/timestamps without changing their position.
- Changing room, message or reaction clears prior rows/cursors and starts a
  fresh load. Request revisions keep old successes, failures and finally blocks
  from replacing current rows, errors or loading state.
- Nine new tests cover initial duplicates/overlap updates, direct and multi-hop
  cursor cycles, and successful/failed obsolete requests for all three identity
  fields. All 15 dialog tests and the full 1517-test suite pass. Analysis,
  standalone showcase analysis, production Web build, architecture/UI guards,
  whitespace and inventory checks pass; logs use `ninetyfifth-*`.
- Browser Use with fixture pages exercised retry, first page and Load more:
  Alex becomes Alex updated, Sam appears once, and repeated cursor removes
  Load more. Desktop and 320 x 568 screenshots show both rows without overlap.
  Viewport was restored and preview server stopped. No live backend pagination
  or external service was used.
- Permission transitions for already-open dialogs, loader-only replacement,
  malformed timestamps and pending blocked-user receipt requests remain open.
  The evidence record remains partial and the overall goal stays active.

### Chat Detail Timestamp Bounds (Ninety-sixth Pass)

- Both detail dialogs multiplied arbitrary positive seconds before constructing
  DateTime. Two new widget regressions reproduced RangeError during rendering
  with an out-of-range server timestamp; evidence is in
  `ninetysixth-before.log` (two expected failures).
- A shared presentation formatter validates seconds before multiplication using
  DateTime's positive upper bound. Unsupported/nonpositive times omit only the
  timestamp label, preserving member rows. Valid local month/day/hour/minute
  formatting remains unchanged and duplicate formatting code is removed.
- Six formatter tests cover local zero-padding, nonpositive input, values above
  the DateTime range, a large Web-safe integer and the supported upper boundary.
  All pass on VM and Edge Web. Both widget regressions pass; 23 focused tests
  and the full 1525-test suite pass, as do analysis, production Web build,
  architecture/UI guards, whitespace and inventory checks. Final evidence uses
  the `ninetysixth-*` log prefix.
- Browser Use inspected fixture-backed read receipts on desktop and 320 x 568:
  Member 1 keeps its row without an invalid time while other members retain
  timestamps. The phone reaction dialog similarly retains Alex without a time
  and Sam with a valid time after pagination. Viewport was restored and the
  preview server stopped. This does not claim live malformed backend responses.
- The small formatter is reviewed for its stated contract; both dialogs remain
  partial because permission lifecycle and broader integration remain open.
  Other time formatting callers, including admin chat timestamps, are outside
  this change and remain candidates for the ongoing audit.

### Blocked Author Response Invalidation (Ninety-seventh Pass)

- Removing blocked content directly from lists/cache left pending requests valid.
  After unblocking, an old history, pin or mutation response could reinsert that
  user's content. Message state now owns per-user removal and advances a user
  reset boundary even when no messages were cached. It removes the user's
  projections and per-message revision metadata while preserving other users.
- Response merges and history fallback reject snapshots from before that user's
  removal. New reads remain valid after unblocking, while obsolete callbacks
  stay invalid. Room resets still invalidate snapshots for all users.
- Read-receipt entry/completion now checks author block/reset and message
  deletion before caching, showing an error or opening a dialog. Repeated clicks
  during loading are ignored. The old request's finally block cannot clear a
  post-unblock request's loading marker. Existing message-reference cleanup uses
  the entries returned by the state removal method.
- Six added state tests cover removal isolation, uncached history fallback,
  pin/mutation rejection, new versus old reads, post-removal live pins and room
  reset. All 34 state tests pass on VM and Edge Web; the full 1531-test suite,
  analysis, production Web build, architecture/UI guards, whitespace and source
  inventory checks pass. Logs use `ninetyseventh-*`.
- Browser Use in the compiled state preview verified Block author then Late
  response leaves Messages: 0, Pinned: 0 and an empty reply. Desktop and
  320 x 568 layouts remain nonoverlapping. Viewport was restored and preview
  server stopped. This is state-preview evidence, not a live account block or
  receipt-request integration test.
- Already-open dialogs, reply-loading token ownership across block/unblock,
  full receipt workflow integration and room-lifetime retention remain open.
  Both source records and the overall goal retain partial/active status.

### Reply Request Ownership (Ninety-eighth Pass)

- Reply previews used a set of loading message IDs. After block cleanup and a
  same-ID restart, an older request's finally block could remove the newer
  request's marker and allow duplicate work.
- Added a keyed async coordinator alongside the existing coordinators. Same-key
  callers share a future; different keys run concurrently. Selective/global
  invalidation expires callbacks, while old success/failure completion cannot
  remove a replacement task. Entries are released when their task finishes.
- Reply loading now uses this coordinator, checks task ownership before merging,
  and invalidates known blocked message IDs, permission-reset loads and all
  outstanding callbacks on disposal. The manually maintained reply-loading set
  and its cleanup are removed.
- Seven added coordinator tests cover coalescing, concurrent keys, obsolete
  success/failure, selective/global invalidation, synchronous failure retry and
  completed-key reuse. All pass on VM and Edge Web. Fourteen combined coordinator
  tests, the full 1538-test suite, analysis, production Web build, architecture/UI
  guards, whitespace and inventory checks pass; logs use `ninetyeighth-*`.
- Browser Use opened the final production homepage on desktop and 320 x 568.
  Room covers, navigation and responsive carousel rendered; viewport was restored.
  This is startup/layout smoke evidence only. The reply race is covered by
  coordinator tests and inspected integration, not a live room end-to-end test.
- Reply retry policy, unknown-author pending references, already-open dialog
  permission lifecycle and full room/receipt integration remain open. Coordinator
  and room file records remain partial; the broader goal remains active.

### Owned Chat Detail Dialog Routes (Ninety-ninth Pass)

- Read-receipt and reaction-member dialogs previously stayed open after their
  message was deleted, author blocked or history permission revoked. They now
  use a room-owned detail controller that tracks each route's message/author and
  removes only matching routes. Permission loss closes all details; room disposal
  and terminal session closure also prevent later detail opens.
- Route removal is deferred to the end of the frame to avoid Navigator locks
  during parent disposal. Exact route removal preserves unrelated covering
  dialogs/pages and tolerates a manual dismissal before the callback runs.
  Reaction-detail entry now checks current chat/message access before opening.
- Six widget tests cover selective message/author invalidation, covered routes,
  manual dismissal races, terminal disposal and owner disposal during navigation.
  All pass, along with the full 1544-test suite, final analysis, production Web
  build, architecture/UI guards, whitespace and inventory checks. Logs use
  `ninetyninth-*`, with `ninetyninth-analyze-final.log` for final analysis.
- Browser Use exercised the controller with an actual read-detail dialog and a
  fixture invalidation timer. Desktop and 320 x 568 views opened normally, then
  closed back to the same page after invalidation. Viewport was restored and the
  preview server stopped. This proves the controller/rendering path, not live
  backend permission, block or session-expiry events.
- The route controller implementation is reviewed; full room integration and
  live event-driven transitions remain open. Reply retry policy, unknown-author
  references and broader source/device/performance coverage also remain in the
  active goal.

### Startup Lifecycle And Dependency Inventory (Hundredth Pass)

- Revisited the unregistered app module. A retained retry callback after startup
  failure and disposal called setState before checking mounted. A new regression
  reproduced `setState() called after dispose()` in `hundredth-before.log`.
  Startup now checks mounted at the retry entrypoint.
- Added coverage for that stale callback and synchronous initialization failure
  recovery. All seven startup tests pass, including existing async failure,
  duplicate retry, delayed success/failure after disposal, ready notification and
  initial OAuth callback-path preservation cases. Full suite: 1546 tests passed.
- Static analysis, production Web build, architecture/UI guards, whitespace and
  inventory checks pass; logs use `hundredth-*`. Browser Use showed the localized
  startup failure state on desktop and 320 x 568, then retried successfully into
  the homepage fixture. Viewport was restored and preview server stopped. This
  exercises the startup wrapper with a simulated failure, not actual storage or
  backend outages.
- Inspected all fields and mappings in AppDependencies and its AppShell projection
  against the entrypoint and registry lookup contract. Both immutable containers
  receive source-review records; no behavior change or new tests were warranted
  for those passive mappings. Concrete service initialization and disposal are
  explicitly outside these records. Startup also receives a reviewed source
  record supported by its behavioral tests and browser fixture.
- The broader goal remains active. Runtime service initialization, native window
  setup, startup/frame/heap measurements and the remaining source inventory still
  require separate evidence.

### Runtime Initialization Ownership (Hundred-and-first Pass)

- Runtime initialization now shares pending work and retains a successful result.
  Retrying application startup after another service fails therefore preserves
  the established API client. Storage or single-server persistence failures clear
  the pending result so the next call can retry.
- Six new tests cover concurrent loads, client identity after success, synchronous
  and asynchronous load failures, shared failure recovery and single-server
  persistence retry. Four failed before the fix. All six pass on native and Web;
  the combined runtime/selection/storage suite passes 51 tests.
- The first full run exposed five protocol fixtures depending on the static
  runtime reloading new mock preferences between tests. Those fixtures now create
  independent runtime/domain instances and close their clients at teardown.
  All 203 protocol tests pass, including refresh-only session restoration.
- Production Web build and static analysis pass. Browser Use inspected the
  production homepage on desktop and at 320 x 568, plus the narrow login dialog.
  Normal startup and layout passed; the viewport was restored. Browser inspection
  did not simulate storage failures; native/Web regressions cover those cases.
- Logs use `hundred-first-*`. Full-suite revalidation passes all 1552 tests;
  architecture/UI guards, inventory and whitespace checks pass.
  Runtime remains partially reviewed: auth/resource lifetimes,
  wrapper domain recreation, native storage and broader inventory remain open.

### Service Wrapper Initialization (Hundred-and-second Pass)

- The static service wrapper still recreated all domain services and reset the
  synchronized clock after every runtime init call. It now commits its successful
  initialization once, preserving domain caches and in-flight request sharing on
  subsequent startup retries. Explicit endpoint changes retain their existing
  domain and clock invalidation behavior.
- Four local HTTP regressions verify cached metadata, pending metadata request
  reuse, synchronized clock preservation and explicit endpoint replacement.
  The first three failed before the fix. The focused runtime/wrapper/protocol
  suite passes 213 tests; the full suite passes 1556 tests. Static analysis,
  production Web build and architecture/UI guards pass. Logs use
  `hundred-second-*`.
- Browser Use inspected production server settings on desktop and 320 x 568.
  Long server identity text wraps, endpoint details remain readable, refresh
  returns to an enabled control, and Done closes the sheet. Viewport restored.
  This covers visible server metadata interaction; repeated initialization and
  request deduplication are established by the local HTTP tests.
- Registered a partial source record for the service facade. Other facade
  methods and resource/auth lifetimes remain outside this record. The entrypoint
  text-scaling clamp, native window setup, device integration and the remaining
  handwritten inventory still require further audit. The goal remains active.

### System Text Scaling And Home Layout (Hundred-and-third Pass)

- Removed the entrypoint's global 0.85-1.3 text scaling clamp. Extracted the
  responsive/debug accessibility composition into AppViewport, now shared by
  production and the home showcase. Linear and nonlinear system scalers pass
  through unchanged. Four native/Web regressions failed with the old clamp and
  now pass.
- Expanded the existing home viewport matrix to 1x, 2x and 3x text at 320, 390,
  834 and 1440 logical pixels. This exposed a narrow header overflow and card
  content overflow. Header actions now switch to compact mode using scaled text
  width, while the brand fits available space. Room rail/grid and category-strip
  heights grow with text; card cover allocation no longer caps text reservation
  at 2x.
- All 24 focused tests and 1560 full-suite tests pass. Web scaler tests pass 4/4.
  Analysis, production/preview builds and architecture/UI guards pass. Logs use
  `hundred-third-*`; original failures are retained in before/layout logs.
- Browser Use inspected the shared production viewport/home components with an
  explicit 2x fixture on desktop and 320 x 568. Checked top controls, room cards
  through the bottom of the page, and account menu through Log out. Text and
  controls remained accessible; viewport restored and preview server stopped.
  This is a fixture rendering check, not authenticated backend integration.
- Registered scoped records for entrypoint, viewport and home sources. Other
  pages/dialogs at large system text sizes remain open, as do native window and
  runtime lifetimes, devices and the wider source inventory. Goal stays active.

### Server Dialog Large Text And Semantics (Hundred-and-fourth Pass)

- Settings header now stacks actions when width or system text size requires
  it. The add-server form scrolls as a unit and its action buttons wrap, keeping
  cancellation accessible when the keyboard occupies a narrow viewport.
- Four new English/Chinese regressions at 320 x 568 with 2x/3x text and keyboard
  insets failed before the layout changes and now pass. Existing and new focused
  tests pass 9/9; full suite passes 1564 tests. Static analysis, preview and
  production Web builds pass. Logs use `hundred-fourth-*`.
- A shared add-dialog entry allows an isolated preview to render the production
  component. Browser Use inspected desktop/mobile 2x layout. It also exposed
  duplicate nested TLS switch semantics; MergeSemantics now produces one named
  switch. Verified its state changes and Cancel closes the dialog at 320px.
  The fixture uses an in-memory gateway; no real server TLS setting was changed.
  Temporary viewport restored and preview server stopped.
- Source records remain scoped: other list states, platform keyboards, auth
  dialogs, runtime lifetimes and the broader handwritten inventory remain open.
  The overall modernization goal remains active.

### Authentication Large Text Layout (Hundred-and-fifth Pass)

- Auth tabs become horizontally scrollable at narrow widths or enlarged text.
  A 320px/2x regression exposed a 157px overflow in the third-party login divider;
  its title now receives bounded width and wraps centered between the rules.
- Browser Use exposed a fixed agreement footer squeezing the form into a tiny
  viewport. Large text and short available heights now scroll the whole panel,
  with the inner form using simple padding instead of a nested list. Removed an
  invalid 360px lower clamp bound that could throw on short landscape displays.
- Focused tests verify OAuth return behavior, narrow login action reachability,
  guest tab selection and a 568 x 320 landscape resize. Full suite passes 1565
  tests; the final height-bound edit additionally passed the focused suite.
  Analysis, production Web build and architecture/UI guards pass; logs use
  `hundred-fifth-*`.
- Browser preview inspected desktop and 320 x 568 at 2x text. Following the
  scroll fix, Continue and GitHub actions are fully visible, and scrolling
  reaches both agreement links. This is rendering evidence with static providers,
  not live authentication. Viewport restored and temporary server stopped.
- Registration, password reset, MFA and keyboard/locale combinations still need
  broader coverage. Auth source is registered as partially reviewed; goal active.

### Registration Titles And Text Scale Matrix (Hundred-and-sixth Pass)

- Expanded auth layout coverage to English/Chinese at 2x/3x text, including
  initial registration input, a 240px keyboard inset, guest selection and
  landscape resize. Three of four combinations failed before this pass.
- Bounded registration section titles with Expanded to fix up to 416px of
  horizontal overflow. Tab heights now grow with text scale, fixing the 3x
  vertical overflow. Five focused tests and all 1568 full-suite tests pass;
  static analysis, production Web build and architecture/UI guards pass.
  Logs use `hundred-sixth-*`.
- Browser Use checked the production registration component in its isolated
  2x preview on desktop and 320 x 568. Section titles fit, and scrolling reaches
  the username field, Continue action and agreement links. Viewport restored;
  temporary preview server stopped. No registration was submitted.
- Browser observation identified untranslated Chinese auth policy hints on the
  English page. This remains open alongside later registration, reset and MFA
  states. These findings do not establish complete auth coverage; goal active.

### Localized Authentication Policy Hints (Hundred-and-seventh Pass)

- PublicSettingsInfo returned hardcoded Chinese strings, causing language mixing
  on English registration pages. It now returns AuthPolicyHint values; the auth
  presentation maps these exhaustively to localized text. Existing review and
  guest-disabled translations are reused; the email allowlist explanation has
  dedicated English/Chinese strings. Policy conditions and ordering are retained.
- Protocol tests assert typed policy values, and the four auth layout cases now
  assert the localized guest-disabled hint. All 208 focused and 1568 full-suite
  tests pass. Analysis, production/preview builds and architecture/UI guards pass.
  Logs use `hundred-seventh-*`.
- Browser Use confirms English policy text on desktop and 320 x 568 at 2x text;
  the longer translated hint wraps within the panel. Viewport restored and
  preview server stopped. Live registration and remaining policy combinations
  are not implied by this rendering check. The broad audit goal remains active.

### Password Reset Form And Pending Requests (Hundred-and-eighth Pass)

- Shared password-reset dialog entry now serves production and the isolated
  preview. Email input occupies its own row; previously its width shrank to
  106-134px and English 3x text overflowed. Sending now guards against duplicate
  same-frame invocation before the disabled button rebuilds.
- Four English/Chinese 2x/3x regressions check usable email width, a single
  pending request, keyboard inset, cancellation and completion after disposal.
  All four and the full 1572-test suite pass. Analysis, production/preview
  builds and architecture/UI guards pass. Logs use `hundred-eighth-*`.
- Browser Use inspected desktop and 320 x 568 at 2x, then cancelled. Email,
  Send and bottom actions fit. Long placeholder labels still ellipsize; full
  labels remain in accessibility text, but shared field label presentation
  needs further review. Viewport restored and preview server stopped.
- Full reset submission, return-to-parent lifecycle and MFA remain open. The
  broader audit remains active; no real reset email or password change occurred.

### Password Reset Duplicate Submission (Hundred-and-ninth Pass)

- Two reset submissions before the next frame could pop both the dialog and
  its parent route. Submission now requires a mounted, current dialog route.
  A navigation-stack regression failed before the guard and now passes; it also
  verifies trimmed email/token and preserved password whitespace in the result.
- All five focused reset tests and 1573 full-suite tests pass. Static analysis, production Web build and
  architecture/UI guards pass. Logs use `hundred-ninth-*`.
- No visual layout changed in this pass. The preceding desktop/mobile browser
  rendering evidence remains applicable; duplicate submission is established by
  the widget test's real Navigator stack, not a live password change.
- Parent disposal before reset completion and end-to-end reset integration
  remain open alongside MFA and the broader source audit. Goal remains active.

## Hundred-and-tenth Pass: Auth Reset Parent Lifetime

- Reproduced `setState() called after dispose()` when a password reset dialog
  returned after its originating AuthPanel was removed from the widget tree.
- The shared loading entry now checks `mounted` before changing state or
  invoking the operation. A production-panel regression opens the password
  flow, removes its parent, submits the surviving reset dialog, and verifies
  the replacement page remains visible with zero OPAQUE gateway calls.
- Focused authentication tests: 11 passed. Full suite: 1574 passed. Static
  analysis, production Web build, architecture and UI guards passed.
- Real Edge browser inspection covered the production home and login dialog
  at desktop and a requested 320x568 viewport, including closing the dialog.
  The viewport was restored. No credentials or account mutations were used.
  Some Chinese glyphs appeared missing in the first desktop dialog capture;
  the later mobile capture rendered them correctly. Font loading/rendering
  needs a separate reproducibility check; this is not a clean visual signoff.
- Browser inspection did not reproduce parent disposal; that race is covered
  by the regression test. Passkey/MFA multi-stage continuations and complete
  registration/reset integration still need review.

## Hundred-and-eleventh Pass: Passkey Continuation Lifetimes

- Passkey login, registration and MFA previously continued after AuthPanel
  disposal: a delayed server challenge could open system credential UI, and
  a delayed credential result could submit authentication after leaving.
  Each flow now checks mounted after challenge and credential completion.
- Nine production-panel widget cases cover disposal at both stages and
  mounted completion for all three flows. Registration tests explicitly
  wait for scroll rendering and assert hit-testable submission. A separate
  before-fix run confirms both registration disposal failures while normal
  completion passes; initial registration test failures were interaction
  setup failures and are not treated as defect evidence.
- Focused auth panel suite: 15 passed. The fake clients establish frontend
  continuation behavior only; they do not validate platform credential UI
  cancellation or reverse requests that were already submitted.
- Full suite: 1583 passed. Static analysis, production Web build,
  architecture/UI guards, inventory consistency and diff checks passed.
- Real Edge inspection of a newly loaded production page reproduced missing
  Chinese glyphs immediately after opening login. A later desktop capture
  without interaction rendered them correctly, as did a requested 320x568
  mobile viewport. Font fallback/loading remains unresolved. Dialog close
  was exercised and viewport restored; no credentials were submitted.

## Hundred-and-twelfth Pass: First-render Chinese Fonts

- Reproduced missing Chinese glyphs on first opening the production login
  dialog. Flutter Web had no bundled CJK font and loaded fallback glyphs
  asynchronously. Added a 337660-byte Noto Sans SC UI subset containing all
  783 printable codepoints in current Chinese localization messages. The
  asset font manifest loads it during engine initialization; both themes
  configure it as a fallback. Normal external-content fallback remains.
- The first browser verification exposed another cause: button themes
  replaced their complete text style with weight alone, discarding font
  fallback. They now derive their bold style from theme labelLarge.
  RenderParagraph assertions for six button variants in both themes failed
  before this fix and pass afterward.
- Added pinned-source/checksum FontTools generation, renamed subset family,
  upstream OFL license asset, regeneration instructions, and CI cmap coverage
  checking. Two generation runs produced identical SHA-256 output. Python
  companion tools are now included in the audit inventory.
- Focused theme/auth/reset suite: 22 passed. Full suite: 1585 passed.
  Static analysis, production Web build, architecture/UI guards and workflow
  actionlint passed. Inventory discovery has an additional Python case.
- Real Edge verification on a newly loaded final build showed complete
  Chinese text in the first desktop login capture, including Continue and
  privacy links that previously failed. Requested 320x568 mobile login and
  first registration captures also rendered correctly. Close was exercised
  and viewport restored. No account mutations were performed.
- This fixes the observed UI-label glyph issue. Arbitrary user content,
  unavailable font assets, platform-specific typography and controlled
  network/performance comparisons remain separate validation work. The
  raw subset adds about 330 KiB before transfer compression.

## Hundred-and-thirteenth Pass: Email-code Form Layouts

- Audited email-code login, email registration and MFA email verification
  at 320x568 in English/Chinese at 2x/3x text scale. Nine of twelve cases
  exposed input widths below 160 pixels, reaching only 54 pixels at English
  3x. All three now share a full-width input with Send aligned below it.
- Browser inspection then exposed truncated primary action labels. Enabled
  wrapping for the three email-code submit actions. Nine of twelve explicit
  RenderParagraph truncation checks failed before this fix and pass after it.
  The matrix also verifies scroll reachability with a 240-pixel keyboard inset.
- Auth panel tests: 27 passed. Full suite: 1597 passed. Static analysis,
  production and isolated preview Web builds, architecture/UI guards passed.
- Extended the isolated auth preview with PREVIEW_EMAIL_CODE capabilities
  and static login discovery. Real Edge desktop/mobile 2x inspection covered
  login and registration code fields, Send positioning, wrapped submit labels
  and scrolling. Only a synthetic identifier was entered; no passwords,
  code requests or account mutations were submitted. MFA layout is covered
  by widget tests, not browser integration. Viewport restored; preview stopped.
- OAuth provider buttons still truncate their provider names at narrow 2x
  layouts, observed in the same browser session. This remains open together
  with real email delivery, complete validation/retry flows and device keyboards.

## Hundred-and-fourteenth Pass: OAuth Provider Labels

- Browser OAuth buttons in login/registration and account binding defaulted
  to ellipsis, hiding provider identity at large text sizes. Both existing
  AppActionButton call sites now enable wrapping. Native Apple buttons keep
  their platform control implementation.
- Four auth en/zh 2x/3x cases now assert complete provider text in both tabs.
  Four new account cases scroll the lazy bindings list to a long instance
  name and check hit testing and rendered text truncation. All four account
  cases and the auth cases failed their text checks before the fix.
- Focused auth/account suite: 54 passed. Full suite: 1601 passed. Analysis,
  production and preview Web builds, architecture/UI guards passed.
- Real Edge English 2x inspection confirmed desktop login and narrow mobile
  login/registration provider labels display in full. No provider action or
  account mutation was submitted. Account binding layout is widget-tested;
  no authenticated browser binding or native Apple device was exercised.
  Temporary viewport override restored and preview server stopped.
- Binding concurrency/callback lifetime, native platform-view callbacks,
  full external OAuth integrations and remaining account-center states
  still require scoped audit.

## Hundred-and-fifteenth Pass: OAuth Binding Attempts

- Binding now reserves its in-flight state before callback session creation.
  A captured button callback invoked twice in one frame previously created
  two sessions; the regression now requires one. Browser and native paths
  share entry/cleanup and check the attempt after asynchronous stages.
- Ten added lifecycle cases cover duplicate entry, disposal during session,
  verification, start, authorization and finish, plus cancel/restart during
  session, start, authorization and finish. Old completion cannot clear the
  newer binding or trigger downstream calls. The five disposal cases passed
  before this change; they are coverage, not evidence of an earlier leak.
- Focused account suite: 37 passed. Full suite: 1611 passed. Analysis,
  production/preview Web builds and architecture/UI guards passed.
- Edge exercised the real account component with an isolated fake gateway:
  desktop and 320x568 at English 2x show full provider names, disabled binding
  during authorization, reachable waiting/cancel controls and restored entry
  after cancellation. Viewport restored; temporary server stopped.
- Cancellation invalidates results but closes the session only after the
  pending operation settles. Real providers and native Apple devices remain
  untested. Browser inspection also found an ellipsized desktop Notifications
  navigation label at 2x; it is the next scoped layout review.

## Hundred-and-sixteenth Pass: Account Navigation Labels

- Desktop navigation ellipsized Notifications at English 2x. Labels now
  wrap and the rail measures the localized bold label with the current
  text scaler. Width is bounded between 232 and one third of the viewport.
- Four en/zh 2x/3x cases verify all seven navigation labels remain readable
  and hit-testable, then enter Bindings directly. Both English cases failed
  before the fix. Focused account suite: 41 passed; full suite: 1615 passed.
  Analysis, production/preview Web builds, architecture/UI guards and
  whitespace checks passed.
- Edge at 1200x900 and English 2x confirms the full Notifications word fits
  on one line; 320x568 retains the top tab navigation and enters Bindings.
  Viewport reset and temporary preview server stopped.
- A broader sequential navigation probe at English 3x reported a 228-pixel
  vertical overflow while moving from Rooms to Privacy. Its diagnostic is
  retained in `build/review/hundred-sixteenth-overflow.log`. The exact source
  and transition behavior need separate investigation; these navigation
  label tests do not claim every tab's content is sound. Browser overview
  also still ellipsizes Manage rooms and Manage security at 1200x900/2x.

## Hundred-and-seventeenth Pass: Account Page Scrolling And Actions

- Restored sequential page visits and expanded the matrix to en/zh, 2x/3x,
  1200x900/320x568 and loading/empty/error paged responses: 24 cases.
  Diagnostics localized vertical overflow to the Rooms Column (684 pixels
  at the tested desktop 3x width), with independent Profile action width,
  notification summary width, error banner size and close-account trailing
  ListTile assertions exposed as coverage expanded.
- Rooms, Privacy and Notifications now scroll their headers using the
  existing NestedScrollView pattern; populated lists remain lazy and use
  the primary controller. Error content has a coordinated scroll view.
  Error summary/banner retries sit below descriptions. Notification tools
  wrap. Profile actions use bounded width; overview/close labels wrap,
  and the close-account action sits below the descriptive tile.
- Real Edge English 3x inspected desktop Rooms, then narrow Rooms/Privacy/
  Notifications and reachable error retries. The first narrow Rooms design
  split title/button words despite passing overflow tests; its create action
  was moved below the full-width title and visually rechecked. A fake retry
  displayed the expected failure notification without changing account data.
  Viewport restored and temporary preview server stopped.
- Full suite: 1635 passed before the final Rooms header placement adjustment.
  Final account suite: 61 passed, including all 24 page-state cases and key
  command text/hit-testing plus retry reachability. Final analysis and Web
  production/preview builds passed; architecture/UI and whitespace checks
  passed. The previous pass's vertical overflow and overview button truncation
  findings are addressed in the tested states.
- This matrix leaves account preferences pending and uses no populated room
  or blocked-user entries. Populated security/binding/list states and dialogs
  still need review. Browser 3x also shows truncation in the room sort control,
  search hints, account identity and error notifications; these are separate
  follow-up scopes, not claims covered by the passing layout matrix.

## Hundred-and-eighteenth Pass: Populated Account Components

- Added a shared read-only populated account gateway for browser/widget
  checks. It enables email/password/TOTP/Passkey settings and one room,
  blocked user, notification, Passkey and linked OAuth account. Unsupported
  calls and mutations throw; the fixture performs no network requests.
- Eight en/zh 2x/3x desktop/mobile populated cases expand the page matrix to
  32. Six initially failed; later probes scroll to real list content and
  verify security action labels. Long multi-line linked-account text is
  checked for viewport intersection, not a center-point hit test that would
  incorrectly require all content to fit within one screen.
- AppTile offers opt-in stackedSuffix; account text/multi-action rows use
  it to avoid trailing widgets consuming the tile width. A shared-control
  regression verifies wrapping and independent row/action taps. The Passkey
  header and account action labels wrap; desktop room actions are bounded.
  Preview Passkey capability now explicitly reports unsupported.
- Full suite: 1644 passed. Analysis, release Web build, architecture/UI
  guards and whitespace checks passed. Focused account/shared-control run
  passed 164 cases before the final content-reachability assertions, which
  are included in the passing full suite.
- Edge English 3x inspected desktop security and room operations, narrow
  TOTP recovery/Passkey controls, and populated notification body/actions.
  No account/security mutation was submitted. Viewport restored and preview
  server stopped.
- Remaining scopes include unconfigured-factor variants, long lists and
  other data shapes, identity/name truncation, room-sort truncation, sensitive
  operation dialogs/lifetimes and real provider/device integrations. This
  pass does not establish full account or shared-control completion.

## Hundred-and-nineteenth Pass: Password Lifetimes And Account Dialog Layout

- Four live password operations passed before the fix, while all four parent
  disposal cases reproduced an unwanted authenticator call: current password,
  email token, Passkey and email reset. Both page handlers now check mounted
  after their dialog result. Password updates also stop before reading page
  dependencies when the account page disappears during the update.
- Eight lifecycle tests preserve leading/trailing new-password whitespace and
  verify zero service calls after disposal. They use an authenticator spy and
  keep the root navigator alive while replacing the account page.
- Eight en/zh 3x desktop/mobile layout cases initially reproduced horizontal
  action overflow and vertical overflow from fixed dialog headers/footers.
  The shared account action dialog now scrolls as one surface, wraps commands,
  and puts the title below its icon/close toolbar. Reset mail controls stack;
  the obsolete LayoutBuilder width branch was removed. Tests use AppTheme.light
  and check keyboard insets, field/button reachability, command text and cancel.
- Edge inspected English 3x desktop/mobile password dialogs. The first narrow
  screenshot exposed split title words despite passing overflow tests; the
  title now uses titleMedium. The email action uses the existing Send label
  within the recipient/email-code context to avoid a split verification word.
  No credential entry, password mutation or email sending was performed.
- Full suite: 1660 passed before final title/Send copy adjustments; final
  account suite: 85 passed. Analysis, release production/preview Web builds,
  architecture/UI guards and whitespace checks passed.
- Field labels and the read-only recipient value still truncate at large
  text scales; remaining account dialog states, duplicate-submit/route-pop
  boundaries and other sensitive-operation lifetimes require separate review.
  These are recorded gaps, and this pass does not establish complete account
  or frontend coverage.

## Hundred-and-twentieth Pass: Account Field Readability

- Extended the eight password dialog layout cases to inspect every field
  label's rendered lines and recipient internal scroll extent. Seven cases
  reproduced label truncation before the fix, including desktop English and
  narrow Chinese. The original overflow-only checks did not establish this.
- AppTextField provides opt-in labelAbove: a wrapping label above the native
  field, with one input semantic name and no duplicate label announcement.
  Account dialog input/read-only wrappers enable it. AppReadOnlyField accepts
  null maxLines so complete recipient values can expand vertically.
- Two shared regressions verify label wrapping, a uniquely named text-field
  semantic node, password visibility without value changes, and multiline
  read-only value updates with selection enabled and zero internal scroll
  extent. All eight account layout cases pass, including keyboard insets.
- Full suite: 1662 passed. Static analysis, release production/preview Web
  builds, architecture/UI guards and whitespace checks passed. Edge English
  3x desktop/mobile screenshots verified complete current/new/confirm-password
  labels, reset-code label and recipient email. Accessibility tree retained
  input names. No credentials or sensitive operations were submitted; viewport
  restored and temporary preview server stopped.
- Remaining scopes include other dialog states, verification mode controls,
  default floating labels elsewhere, legacy read-only selectable/overflow
  parameter behavior, duplicate submission boundaries and sensitive operation
  lifetimes. Actual screen-reader speech and native device keyboards were not
  exercised. This pass resolves the observed account field clipping, without
  claiming complete shared-control coverage.

## Hundred-and-twenty-first Pass: Password Dialog Route Preservation

- Ordinary repeated pointer taps were intercepted by Flutter's exit barrier;
  that experiment did not reproduce a defect. A focused test then invoked
  queued keyboard-submit and button-submit callbacks before the exit animation
  completed. All four password methods removed the underlying account page
  before the fix, while their live/disposed-parent baseline cases passed.
- Password update/reset submit handlers now require both mounted state and
  their modal route to be current before reading controllers or popping.
  This also prevents callbacks during cancellation and after dialog disposal.
  The existing password-reset email request guard needed no change.
- The password matrix now has 20 cases: four methods across live submission,
  parent disposal, queued duplicate submit, cancel transition and complete
  dialog disposal. It checks call counts, account-page preservation, exceptions
  and unmodified password whitespace. Only the queued duplicate cases were
  demonstrated failing before this fix; cancellation cases extend coverage.
- Full suite: 1674 passed. Static analysis, production/preview release Web
  builds, architecture/UI guards and whitespace checks passed. Edge inspected
  desktop reset layout and narrow 3x empty submission: validation retained
  the dialog, and Cancel returned to the account page. No password or email
  operation was submitted. Viewport restored and preview server stopped.
- This browser check covers ordinary interaction, not deterministic callback
  races. Other text-input/TOTP dialogs, notification detail actions, shared
  close/cancel callbacks and sensitive verification continuations still need
  their own lifecycle/route-preservation coverage.

## Hundred-and-twenty-second Pass: Shared Dialog Dismissal

- Six rename dialog regressions reproduced queued duplicate submit, Cancel
  and Close callbacks removing the account page during exit, or accessing
  disposed state/context after exit. Shared dismissal and single-text submit
  handlers now require a mounted current route before accessing navigation
  or controllers.
- The cases verify account-page preservation, exactly one trimmed username
  update on submission, and no update after cancellation followed by a late
  submit. The fake gateway performs no external account mutation. Success
  toast timers are drained explicitly in the tests.
- Full suite: 1680 passed. Analysis, production and preview release builds,
  architecture and UI guards passed. Edge checked the 3x username dialog at
  desktop and 320x568: labels wrap, footer commands are reachable by scrolling,
  and closing/canceling retains the account page. Callback races are covered
  by widget tests; ordinary browser interaction does not prove their timing.
- Browser inspection also found the profile page Change username command
  splits its last word at desktop 3x. That layout, parent-disposal rename
  continuation, TOTP and notification dialog actions remain separate open
  review items. This pass does not establish complete frontend coverage.

## Hundred-and-twenty-third Pass: Profile Action Readability

- Browser evidence from the preceding pass showed the username action split
  a word at desktop 3x. Extended existing page-layout tests to inspect selection
  boxes for each English action word; sixteen English cases failed before
  the fix. These widget tests use test font metrics, so the browser evidence
  remains necessary for production typography.
- The profile action now says Edit in its profile context; the dialog retains
  its explicit Change username title. The horizontal-layout threshold follows
  text scaling so large text gives the action its own full-width row.
- Account suite: 103 passed, including en/zh, 2x/3x, desktop/mobile and four
  data states. Analysis, production/preview release builds and architecture/UI
  guards passed. The previous pass's 1680-test full-suite result is the earlier
  baseline; this local layout change used the complete account suite.
- Edge screenshots at desktop and 320x568 with 3x text showed a complete Edit
  label. Mobile scrolling reached the button, which opened Change username;
  Close worked. No account mutation was submitted. Viewport restored and
  temporary preview server stopped.
- Remaining profile issues include sidebar identity truncation and narrow
  avatar/details layout causing excessive username/email wrapping. Other
  account dialogs and the wider source inventory remain partially reviewed.

## Hundred-and-twenty-fourth Pass: Narrow Profile Identity Layout

- At 320px and 3x text, the profile card previously kept a horizontal avatar/details row, leaving too little width for the username and email. A targeted layout assertion reproduced the constrained width.
- The card now stacks avatar and identity details below a scaled 420px threshold; normal-width layouts retain the compact row. The Edit action remains full width on narrow screens.
- Account suite: 103 passed. Analysis and release builds completed; browser Edge verified the 320px/3x profile card with readable stacked identity content and reachable Edit action.
- Sidebar identity truncation and other account/dialog surfaces remain open audit items.

## Hundred-and-twenty-fifth Pass: Rename Parent Lifetime

- Rename now checks mounted immediately after the text dialog returns, before
  reading the context-backed gateway. Previously a disposed page still tried
  that lookup inside its catch block. This is a source-identified lifecycle
  gap; no pre-fix test failure or external mutation was demonstrated.
- Expanded rename cases from six to nine, retaining the root navigator while
  replacing the account page. Submit/Cancel/Close after parent disposal keep
  the replacement page and issue no username mutation. Account suite: 106
  passed; architecture/UI guards passed. A lint-only brace adjustment followed
  the tests. No visual code changed or new browser interaction was claimed.
- TOTP setup verification, dialog-return and refresh boundaries remain open,
  as do setup/recovery-code dialog layout and callback checks. The complete
  frontend goal remains active.

## Hundred-and-twenty-sixth Pass: Recovery Code Dialog

- English/Chinese desktop 3x tests reproduced horizontal and vertical overflow
  in the recovery-code dialog. Initial mobile attempts missed the offscreen
  Security tab; corrected navigation tests now cover both viewport sizes.
- The dialog scrolls as a whole, uses a smaller heading and wrapping footer
  actions. Saved confirmation checks mounted/current route before popping.
  Four tests check command reachability, label clipping, queued duplicate
  confirmation and callbacks after disposal. Callback cases extend coverage;
  their pre-fix failure was not separately demonstrated.
- A recovery preview gateway returns explicitly fake TEST-CODE values and
  fake completed verification without external services. The recovery preview
  state shares this fixture with tests. Other mutations remain unsupported.
- Full suite: 1687 passed. Analysis, production/preview release builds passed.
  Edge desktop/mobile 3x screenshots show scrolling content and reachable
  Copy all/Saved commands; Saved closes the dialog. Clipboard interaction was
  not exercised. Mobile individual codes still wrap and need readability review.
- TOTP setup/refresh lifetimes, setup dialog callbacks/layout, sidebar identity
  truncation and remaining module coverage are still open.

## Hundred-and-twenty-seventh Pass: Preserve Generated Recovery Codes

- Regeneration tests reproduced missing recovery codes when the subsequent
  preferences refresh failed or never completed; the ready baseline passed.
  Generated codes were previously withheld behind that secondary request.
- Setup and regeneration now share a display helper that opens the one-time
  codes immediately and refreshes preferences independently using the existing
  module loader/error state. Both flows check parent lifetime after verification;
  setup also checks it after the setup dialog returns.
- Recovery cases now cover en/zh, desktop/mobile 3x and ready/failed/pending
  refresh. All 118 account tests passed. This pass changes sequencing, not
  layout; prior browser screenshots cover layout only, not refresh failures.
  Setup's separate verification and submission paths still need direct tests.
- No real account mutation occurred. The broader audit remains incomplete.

## Hundred-and-twenty-eighth Pass: TOTP Setup Submission

- Three new tests open the real setup dialog using an unconfigured fake
  account. Queued keyboard/button submission removed the account page before
  the fix; cancel-transition and disposed-dialog callbacks also failed with
  navigation/state errors. Some later failures in the pre-fix run cascaded
  from navigation teardown, so they are not independent defect counts.
- TOTP submission now checks mounted/current route before reading the code
  controller. Tests verify one finish call with the entered code for duplicate
  submission, zero calls after cancellation, and the account page remaining
  after recovery-code confirmation.
- Account suite: 121 passed. Analysis, production release build, architecture
  and UI guards passed. This callback-only change used widget tests; no new
  browser layout verification is claimed. Fake setup data never reaches a
  real account or verification service.
- Setup QR/manual-key narrow layout, code validation edge cases, parent
  disposal across individual requests and concurrent setup entry remain open.
  The wider frontend audit remains incomplete.

## Hundred-and-twenty-ninth Pass: TOTP Input Validation

- A widget regression demonstrated that integer parsing accepted 0x1234 and
  sent it to finishTotpSetup. Setup validation now requires exactly six ASCII
  digits after trimming surrounding whitespace.
- Existing setup callback cases now reject hexadecimal, signed, short, long,
  embedded-space and alphabetic inputs while retaining the dialog and showing
  validation. Valid input with surrounding spaces preserves its leading zero.
  Only the hexadecimal case was demonstrated failing before the change.
- Account suite: 121 passed. Analysis and architecture/UI guards passed.
  This validation-only change had no new browser run. Other verification
  surfaces, including authentication's length-only code check, need review.

## Hundred-and-thirtieth Pass: Login TOTP Format

- Backend TOTP verification requires six ASCII digits. Login MFA previously
  checked only length; a new widget test demonstrated abcdef reaching the
  verification gateway. Login now applies the six-digit format check locally.
- The regression rejects letters, hexadecimal/signed forms, embedded spaces
  and wrong lengths, then verifies a trimmed value retains its leading zero.
  The fake gateway rejects the valid-format attempt deliberately; no real
  login is performed. Only letters were demonstrated failing before the fix.
- Auth panel suite: 28 passed. Analysis, production Web build, architecture/UI
  guards passed. No new browser check for this validation-only change.
- Account sensitive-operation TOTP also has a length-only check and remains
  an identified follow-up, alongside setup layout and wider audit coverage.

## Hundred-and-thirty-first Pass: Sensitive TOTP Verification

- A pending sensitive-operation challenge in the setup test reproduced
  alphabetic input reaching finishSensitiveOperationVerification. The TOTP
  branch now validates six ASCII digits, keeping recovery-code rules separate.
- The test rejects letters, signed/hex forms, embedded spaces and incorrect
  lengths; a valid trimmed code preserves its leading zero and opens setup.
  It then completes the existing setup/callback test. Only alphabetic input
  was demonstrated failing before the change.
- Account/auth suites: 150 passed. Analysis and architecture/UI guards passed.
  No new browser run for this validation-only change. Provider server-account
  two-factor length checks require their own protocol review. Remaining
  lifecycle, layout and all-source audit gaps are still open.

## Hundred-and-thirty-second Pass: FNOS Two-Factor Submission

- Confirmed FNOS backend validation requires six ASCII digits. The frontend
  previously checked only length and passed untrimmed codes. It now checks
  digit format, trims code whitespace and retains password whitespace.
- Added mounted/current-route/in-flight guards. Initial tests recorded two
  concurrent calls carrying the same code. That run also contained unrelated
  fixture errors because all provider lists load on entry; the corrected fake
  supplies empty lists for other providers. Those errors are not additional
  production defects established by this pass.
- Two FNOS tests verify invalid input never makes a second login request,
  a valid code retains its leading zero, queued duplicate calls coalesce and
  callbacks after disposal are ignored. All 17 provider binding tests passed;
  analysis and architecture/UI guards passed. No real provider login or new
  browser validation occurred.
- FNOS setup-required challenges, switching instances/credentials while
  requests are pending, response-route handling and provider layouts remain
  open. Other forms in this source file are still unreviewed.

## Hundred-and-thirty-third Pass: FNOS Canceled Response

- New cancellation tests reproduced a late FNOS success popping the underlying
  binding page during the dialog exit animation, and a late failure showing
  an error after cancellation. Fully disposed success/error baselines passed.
- Response application and error notifications now require the dialog route
  to remain current. Six FNOS cases cover format, in-flight duplicates and
  success/error after cancel transition or complete disposal; they also check
  no extra binding-list refresh follows a canceled success.
- All 21 provider binding tests passed. Analysis and architecture/UI guards
  passed. No new browser run for this async response change.
- Backend review confirms setupRequired means enforced 2FA without a bound
  secret; frontend still treats it as a normal code challenge. That flow,
  mutable request fields and provider layout remain open audit items.

## Hundred-and-thirty-fourth Pass: FNOS Enforced Setup

- FNOS setupRequired means enforced two-factor authentication without an
  enrolled secret. The old UI incorrectly requested a code; the backend
  continues returning setupRequired regardless of a supplied code.
- This state now shows a persistent localized instruction to configure 2FA
  in FNOS and retry. It does not require a code until the retry returns a
  normal challenge. Challenge transitions clear the previous code.
- A new test demonstrated the missing guidance before the change, then
  verifies retry is allowed without a code and normal challenge restores the
  code field and removes guidance. All 22 provider binding tests passed.
  Analysis, architecture/UI guards and Chinese font coverage passed.
- Initial compile failed due to the banner's Widget title contract and was
  corrected. New message/browser large-text layout is not yet verified and
  remains an explicit gap, as do credential/instance changes while pending.

## Hundred-and-thirty-fifth Pass: FNOS Browser Layout

- Real Edge English 3x preview reproduced truncated FNOS field labels and
  Trust device splitting into letter fragments on a narrow screen. FNOS now
  opts into existing wrapping external field labels through createFormField.
  Trust text and its switch wrap together and expose one labeled switch.
- Four en/zh 3x layout cases at 320x568 and 1200x900 cover field readability,
  normal challenge controls, switch toggling and cancel preserving the page.
  Initial narrow English empty-page layout overflowed by 40 pixels; generic
  provider empty content now scrolls within its allocated area.
- All 26 provider binding tests passed. A preliminary word-box assertion
  failed with the widget test font; actual word integrity was checked in Edge.
  Tests retain content bounds, truncation, interaction and overflow checks.
- Edge viewport presets 320x568 and 1200x900 verified complete Host label,
  ordinary 2FA controls, trust toggling and cancellation. Setup-required
  guidance was scrolled on mobile before the layout edit and read on desktop
  in the preceding preview; setup-to-code retry also exercised after edits.
  Preview uses fake credentials and no external provider requests.
- Final UI guard required using the existing AppSwitch wrapper; this keeps
  the same native Switch layout and adds shared semantics. Widget checks
  cover that final wrapper; browser screenshots precede this substitution.
- Final 26 provider tests, analysis, production Web build, architecture/UI
  guards, inventory check and diff whitespace check passed. The full suite
  was not rerun. Temporary preview server stopped and browser viewport reset.
- Remaining: instance selector label/value truncation, section title word
  breaks, oversized fixed header at 3x, hardcoded provider labels, keyboard
  insets, populated states and credentials/instance changes during requests.
  This pass does not establish complete provider or application coverage.

## Hundred-and-thirty-sixth Pass: FNOS Challenge Ownership

- Editing any of the five connection/credential fields or changing provider
  instance previously retained the old setup/code challenge and code. Twelve
  regression cases reproduced that state leak before the fix.
- Text changes now clear the challenge and code; selection-only controller
  notifications preserve them. During submission, all fields, instance
  selection and trust control are disabled. Instance selector exposes an
  optional enabled flag with an unchanged true default for other consumers.
- Full suite passed 1724 tests. After adding the remote instance to the test
  fixture, all 24 FNOS cases passed again. Analysis, production and preview
  release builds, architecture/UI guards, inventory and diff checks passed.
- Edge English 3x desktop verified username edits remove setup guidance and
  retry obtains a new challenge. Mobile verified focusing username preserves
  the challenge, while text editing removes it. One stale node index after
  resizing entered a fake value in WebDAV; it was cleared before retry and
  the intended code/username interaction was repeated with fresh node state.
- Browser uses an immediate simulated gateway; pending-control checks use
  deferred widget-test responses. Real FNOS, native keyboard and all provider
  lifecycle variants remain open. Preview stopped and viewport restored.

## Hundred-and-thirty-seventh Pass: Provider Instance Readability

- AppSelect now offers opt-in labelAbove and wrapText. Labels wrap outside
  the input, selected values no longer force ellipsis, and menu item heights
  follow content. Existing callers retain the previous defaults.
- Shared provider instance selector enables both options. Its repeated
  decoration icon was removed after Edge showed it still split instance
  words at mobile 3x. The preview includes a fake long instance name.
- Four en/zh 3x shared-control tests at 220/440 content widths check complete
  labels, long menu selection, no layout exceptions and stable dimensions
  across selection. All 140 shared control/provider tests passed; analysis,
  production/preview builds and architecture/UI guards passed.
- Edge English 3x at 320x568 and 1200x900 verified local and long selected
  names, labeled selector semantics and scrolling/selection of the long menu
  option. Mobile words remain intact after removing the icon. Content taller
  than the form viewport remains reachable through its existing scroll area.
- Full suite was last run in pass 136. Other provider form states, extremely
  long names, keyboard insets, section-title word breaks, fixed header height
  and ignored AppSelect options still need review. Preview server stopped and
  viewport reset; no external provider calls made.

## Pass 138: Select Clear Command

- AppSelect accepted clearable without rendering a clear command. Room
  creation and admin category selectors already request it. Enabled non-null
  selections now expose a localized icon button that emits null; disabled
  fields and empty selections do not expose it.
- Four enabled/nullable-option combinations check one null callback, saved
  form state, button removal and disabled behavior. All 105 shared-control
  tests and 200 create-room/admin tests passed. Initial test failures included
  a tooltip finder mismatch; they are not clean before/after bug evidence.
- Isolated English 3x Edge checks at 1200x900 and 320x568 confirmed distinct
  Clear semantics, direct clearing without opening the menu, wrapping empty
  values and no text overlap. Mobile menu selection restored Music visually,
  but the accessibility tree remained at Dismiss after closure. This needs
  investigation; the browser check does not establish complete menu access.
- The preview uses fake local state with no server mutation. Ignored select
  onReset/canRequestFocus/expands and read-only field options remain open.
- Analysis, release preview/production builds, architecture/UI guards,
  inventory validation and diff whitespace checks passed. Temporary preview
  server stopped and browser viewport reset after verification. Last full
  test suite remains pass 136; this pass ran the 305 targeted tests above.

## Pass 139: Recovery Code Boundaries

- Recovery codes previously formed one newline-joined selectable paragraph.
  Narrow 3x layouts wrapped each code without a distinct visual boundary.
  Codes now render as separate selectable values with spaced, visible
  dividers. Copy all still writes the original newline-joined payload.
- Twelve en/zh desktop/mobile 3x ready/failed/pending refresh cases check all
  ten entries, at least 24 pixels between entries, exact clipboard writes,
  reachable commands and safe dismissal. All 122 account tests passed.
  Clipboard tests capture platform writes; initial attempts to read the
  test clipboard stalled and notification timers required explicit pumping.
- Final English 3x Edge build at 1200x900 and 320x568 confirmed visible
  dividers and mobile wrapping boundaries. Scrolling reached the final code
  and both commands; Copy all showed feedback, and saved confirmation
  returned to account security. Dialog semantics briefly lagged the visual
  dismissal and recovered on the next read. The persistent select Dismiss
  observation from pass 138 remains unresolved.
- Analysis and preview/production Web builds passed. The preview uses fake
  codes; no live account regeneration or provider requests were performed.
  Native clipboard, screen readers, dark theme and arbitrary code formats
  remain outside these browser checks. Account overview identity truncation
  and statistic word breaks at 3x remain visible audit gaps.
- UI guard required the existing AppDivider wrapper after browser checks.
  Its explicit height/thickness/color forward unchanged to Divider; twelve
  recovery cases were rerun after this substitution. The final wrapper was
  not separately exercised in the browser. Full suite remains pass 136.

## Pass 140: Overview Reflow And Avatar Initials

- Overview columns used fixed pixel thresholds despite larger text, splitting
  metric words across lines. Metric minimum widths and summary breakpoints
  now follow text scaling sampled at 14px, with normal-scale floors.
- Overview identity stacks at scaled widths, wraps username/email and uses
  titleMedium for its compact content area. Browser checks first revealed
  that merely removing ellipsis still split the larger headline's words.
- Browser also exposed clipped avatar initials. Shared AppAvatar now fits
  its padded initial with scaleDown, keeping fixed bounds and preserving
  smaller text. The image-error path reuses the same fallback. Eight tests
  check transformed text bounds for two shapes, two sizes and 1x/3x text.
- Populated overview tests check identity truncation and metric word boxes
  when the longest word can intrinsically fit in the test font. The default
  Ahem font made notifications wider than the mobile container; those cases
  do not assert impossible word fitting or establish real-font readability.
- Final English Edge 3x at 320x568/1200x900 verified complete username/email,
  unclipped account initial and intact metric words including notifications
  and Bound. Desktop summaries reflowed into a readable column; View profile
  navigated correctly. The preview made no external account mutations.
- All 235 targeted tests and all 1740 tests in the full suite passed, along
  with analysis and preview/production release Web builds. Sidebar identity
  truncation, arbitrary long content, dark theme/native and failed-image
  browser states remain incomplete. Select Dismiss semantics remain open.

## Pass 141: Scrollable Account Identity And Navigation

- Sidebar identity previously forced username/email to one line while the
  navigation scrolled separately. It now wraps both identity values and
  scrolls the header together with seven eagerly built navigation items.
  A single scrollable column keeps long identity from consuming a fixed
  portion of the navigation viewport.
- Account layout coverage expands to 48 en/zh, 2x/3x, desktop/short-window/
  mobile and loading/empty/error/populated cases. Loading uses a longer
  username/email; desktop identity assertions check no truncation and all
  cases visit the seven navigation sections. All 138 account tests passed.
  An initial lazy-list variant prevented test lookup of unbuilt entries;
  the final fixed-size navigation set is built together in one scroll view.
- English Edge 3x at 1200x360 confirmed full identity and scrolling to the
  last Bindings entry, followed by a successful page switch. At 1200x900 the
  sidebar identity remained readable. At 320x568, returning to Overview and
  selecting Profile through top tabs worked. Preview uses fake account data.
- Analysis and preview/production release builds passed. Last full suite is
  pass 140 with 1740 tests. Binding provider names such as Cloudreve still
  split in dense cards, and the mobile Personal profile heading splits words
  at 3x; these remain concrete layout gaps. Real screen readers, keyboard
  traversal, arbitrary identity lengths and select Dismiss semantics remain
  unverified or incomplete.

## Pass 142: Readable Media Binding Entries

- Media provider entries previously used fixed desktop three-column layout
  and two-line descriptions. They now use the existing responsive wrap with
  a text-scaled minimum width. Narrow entries put icon/action above the full
  label and description. The section is unframed, removing nested card
  padding and giving mobile content more usable width.
- Twelve populated en/zh 2x/3x desktop/short-window/mobile combinations check
  all nine core provider callback IDs and untruncated titles/descriptions.
  OAuth lifecycle tests now scroll to lazily built entries instead of assuming
  they are already mounted. All 138 account tests passed after the final edit.
- English Edge at 1200x900 and 320x568 with 3x text checked real rendering.
  Cloudreve and Nextcloud retain whole names; mobile Synology DSM wraps at
  its space. TikTok's long description is complete and OAuth links remain
  reachable by scrolling. These previews use fake data and no-op provider
  callbacks; actual callback IDs are verified by widget tests, not live login.
- Analysis, architecture/UI guards and preview/production release builds
  passed. Last full-suite run remains pass 140 with 1740 passing tests.
  Profile header word breaks and the mobile linked-OAuth row's narrow text
  column remain confirmed gaps. Native device, screen reader and external
  provider integration coverage remains incomplete.

## Pass 143: OAuth Unlink Lifetimes And Account Rows

- Unlink previously resumed after verification without checking whether the
  account page still existed, and repeated callbacks could launch duplicate
  verification/unlink operations. A synchronous busy guard now covers
  verification through link reload, disables related actions, and resets on
  cancellation/failure. Bind/unlink entry points reject overlapping attempts.
  Mounted checks stop new unlink/reload requests after parent disposal.
- Five lifecycle tests cover duplicate callbacks, disposal during verification
  and unlink, cancellation, and failure followed by retry. They assert exact
  target/verification ID, request counts, reload boundaries and button recovery.
  All 143 account tests and the full 1761-test suite passed.
- Linked OAuth entries now own a small feature-local responsive row. At narrow
  widths relative to text scale, icon and unlink action sit above the full-width
  title/details. Populated mobile tests check the detail width. English Edge
  3x at 320x568 and 1200x900 confirmed full account/address/time rendering.
  The mobile unlink button opened identity verification and Close returned
  to the list with its action enabled; the fake preview rejects verification
  requests and performs no external account mutation. The transient Dismiss
  accessibility state recovered on the next read; the earlier select-menu
  semantics issue remains a separate unresolved case.
- Static analysis, architecture/UI guards and preview/production release
  builds passed. Profile heading and verification empty-state word breaks,
  long error toast truncation, concurrent global refresh ordering, external
  identity-provider integration and native-device coverage remain incomplete.

## Pass 144: Complete Notification Details

- Long notifications previously exposed only a three-line visual summary.
  Overflow measurement now adds a localized details command that opens the
  complete selectable message. Short passive notifications retain pointer
  passthrough. Details preserve retry/undo actions with single-execution and
  stale-overlay guards, and remain readable after the toast expires.
- Toasts respect available height and keyboard/safe-area insets, with scrolling
  for tall actionable content. Message live-region semantics remain present.
  The details title uses compact typography after browser inspection exposed
  excessive title size at 3x text.
- Twelve en/zh desktop/mobile/short-window cases cover full messages, actions,
  keyboard bounds, scroll reachability, timeout survival and Close. A separate
  replacement case verifies stale details cannot open. All 22 notification
  tests passed after the title adjustment; the full 1774-test suite passed
  before that title-only adjustment. Analysis, architecture/UI guards and
  production/preview release builds passed.
- Edge at 320x568 and 1200x900 with 3x text verified the updated title, complete
  fake error message and Close; mobile scrolling reached the final reference.
  Browser evidence does not establish real identity-provider integration,
  screen-reader behavior or native-device coverage. Notification automatic
  expiry/accessibility timing remains open. Preview-only Restore playlist
  truncation and fixed-height Refresh clipping were observed and remain open,
  alongside the earlier account headings and select-menu semantics findings.

## Pass 145: Account Headings And Verification Notices

- Account section headings now use compact title typography and move the icon
  above full-width text when available width is small relative to text scale.
  Verification notices use the same responsive arrangement locally, preserving
  their title and full explanation without reserving a permanent icon column.
- A deterministic preview gateway supplies a pending challenge with no available
  methods. Four English/Chinese desktop/mobile 3x cases check profile heading
  and description, complete verification messages, English word integrity,
  scroll reachability and cancellation. Tests load Flutter's Roboto fonts and
  the bundled CJK font; default Ahem metrics were unsuitable for word wrapping.
  All 147 account tests passed, including existing lifecycle and page matrices.
- English Edge 3x at 320x568 and 1200x900 confirmed the final profile heading
  and description. Desktop/mobile verification showed intact title/notice words and
  complete explanation, with a reachable Cancel and disabled Verify. These are
  fake-data checks, not proof of identity-provider integration or screen-reader
  operation. Other verification methods, arbitrary content, native devices,
  remaining room identity truncation and the earlier select semantics finding
  still require review.
- Static analysis, architecture/UI guards and production/preview release builds
  passed. This pass ran the account suite; the last full-suite result remains
  the 1774 tests recorded in Pass 144 before its final title adjustment.

## Pass 146: Accessible Notification Lifetimes

- Notifications with retry/undo or full-message details no longer expire while
  MediaQuery.accessibleNavigation is enabled. They expose a localized Close
  command. Switching the setting off starts a fresh requested duration; short
  passive messages retain their configured expiry and pointer passthrough.
  Replacement and manual dismissal invalidate old timeout/close callbacks.
- Three policy tests cover action/details/passive messages, enabling the
  setting during a visible toast, disabling it, manual dismissal, replacement
  with a stale Close callback, and action execution after the original timeout.
  All 25 notification tests and the full 1781-test suite passed. Static analysis,
  architecture/UI guards and production/preview release builds passed.
- English Edge at 320x568 with 3x text and simulated accessibleNavigation kept
  Undo visible beyond the preview's original 30-second duration. Clicking Undo
  changed the count from zero to one and dismissed the notification. At 1200x900,
  the long-message Close and Details entries rendered clearly and Close worked.
  The simulation verifies the app's setting response, not a real screen reader.
  Default reading duration, focus/hover timing, native accessibility and the
  preview's previously recorded fixed-height/long-label clipping remain open.

## Pass 147: Select Clear Form Events And Menu Investigation

- AppSelect clear previously called only the external value callback. Saving
  could observe the updated parent value, but Form.onChanged never fired and
  onUserInteraction validation was skipped. Clear now calls its enclosing
  FormFieldState.didChange; clearable fields explicitly accept null even when
  the option list contains no null entry.
- The four enabled/nullable-option cases now assert exactly one form event and
  immediate required validation. Both enabled cases failed before the fix with
  zero events. All 113 shared-control tests and the full 1781-test suite passed.
  Static analysis, architecture/UI guards and preview/production builds passed.
- The 3x English form preview showed Required and Changes: 1 immediately after
  desktop Clear; both remained fully visible at 320x568. The invalid mobile
  field could reopen its menu; choosing Music removed Required and displayed
  Changes: 2 while the separate stale-Dismiss AX issue remained. Preview data
  is local and performs no requests.
- Independently reproduced the earlier mobile menu issue: after Clear, opening
  and selecting Music updated the visible field, but Edge AX retained only
  Dismiss across multiple reads. Resizing to desktop restored field semantics.
  Required validation also changes the field's AX button role to a container,
  although clicking it still opens the menu. Both accessibility issues remain
  unresolved. AppSelect's unused onReset/canRequestFocus/expands parameters and
  comprehensive input/error semantics remain audit items.

## Pass 148: Select Button Semantics And Focus Restoration

- Custom selected entries returned plain Text. Flutter's dropdown assumes
  child button semantics when a hint exists, so these entries could lose their
  button role, including after Clear with validation. Each custom selected
  entry now explicitly supplies button semantics and its enabled state while
  retaining the dropdown's tap and expanded behavior.
- Four initial enabled/error cases reproduced missing button roles. Eight final
  cases also cover a selected null option and verify role, enabled state and
  tap availability. All 121 shared-control tests and the full 1789-test suite
  passed. The final test-only migration to flagsCollection was followed by
  another successful shared-control run and clean static analysis. Architecture
  and UI guards plus production/preview release builds passed.
- English Edge at 320x568 with 3x text now exposes the required-error field as
  an expandable button. Clear, select Music, reopen, select No category produced
  Changes: 1/2/3 with appropriate validation. Both menu selections restored
  field semantics and focus without resizing; the previous stale-Dismiss path
  no longer reproduced in this mobile sequence. At 1200x900 the error-state
  button role remained correct, but selecting Music after resizing reproduced
  stale Dismiss AX while the visible field showed Music and Changes: 4. Thus
  menu-close semantics remain unresolved. This does not establish behavior for
  every browser or a real screen reader. Remaining control parameters, menu
  variants, native accessibility and full shared-component coverage stay open.

## Pass 149: Select Migration Comparison and Unused API Cleanup

- Added raw legacy and modern select implementations to the isolated preview,
  selected with PREVIEW_SELECT_IMPLEMENTATION=native/modern. The default
  remains AppSelect. Both comparison release builds and static analysis pass.
- Real Edge at 1200x900, English 3x: legacy Music -> No category -> Music
  restored the named field, validation and focus after both closes, with form
  change counts 1/2. A fresh 320x568 legacy page also restored the named error
  field after selecting No category. Its default dense selected area clipped
  the second text line, confirming the need for existing AppSelect wrapping.
  These sequences did not reproduce stale Dismiss and do not establish a cause
  or fix for the previously observed AppSelect failure.
- Modern selectOnly closed successfully after desktop null selection and
  mobile Music selection, with change counts 1/2. However, its collapsed Web
  AX button lacked both label and selected value; the visible Required error
  was absent from AX. At 320x568 its single-line selected No category was
  clipped. SDK ExcludeSemantics around its Web TextField explains the missing
  text. Its external initialSelection synchronization also differs after user
  interaction. Direct production migration is deferred pending preservation
  of those existing contracts.
- Removed unused AppSelect onReset, canRequestFocus and expands parameters:
  none had implementation or repository callers. This removes misleading API
  promises without changing runtime behavior. All 121 shared-control tests,
  static analysis, architecture and UI guards pass. No new full-suite run was
  needed for removal of unused declarations; the previous 1789-test result
  remains the most recent full run.
- Full shared-control coverage, stale-Dismiss diagnosis, cross-browser and
  real screen-reader verification remain open. The project goal stays active.

## Pass 150: Preserve Notification Actions During Interaction

- Interactive notifications previously expired even while the pointer hovered
  over Undo or the keyboard focus was on an action/details button. Added
  independent hover and descendant-focus retention alongside the existing
  accessibleNavigation policy. Timing resumes for the full requested duration
  only after all retention reasons clear. Passive messages keep pointer
  passthrough and ordinary expiry.
- Timeout updates check active-entry identity before touching the shared timer,
  preventing late focus/exit callbacks from affecting a replacement. A resize
  that makes a details message passive clears interaction retention.
- Initial hover/focus cases failed before implementation. Six final cases cover
  action/details controls with hover, focus and both; releasing hover while
  focus remains does not resume timing. Combined cases replace the active
  notification and verify normal expiry of the replacement. A seventh case
  resizes focused truncated content into a passive message and verifies expiry.
- All 32 notification tests pass. The full 1795-test suite passed before the
  final test-only resize addition; final focused tests cover that addition.
  Static analysis, architecture/UI guards and production/preview builds pass.
- Real English Edge, 3x text: desktop 1200x900 hover kept Undo visible beyond
  the configured 30-second timeout; after pointer exit, the toast expired.
  At 320x568, Tab traversal reached Undo and retained it beyond the deadline;
  Return dismissed the toast and changed Undos from 0 to 1. Tests used only
  isolated preview data. The preview's fixed-height Refresh and long Restore
  playlist launch button still need large-text layout cleanup.
- Real screen readers, native devices, default reading-duration policy and
  exhaustive inset combinations remain outside this pass. The goal remains
  active and shared-component coverage remains partial.

## Pass 151: Tooltip Bounds and Interaction Lifetime

- Shared tooltips measured text at a fixed width and leaked their TextPainter.
  The new measurement respects available overlay width and disposes the painter
  in finally. Rendering now explicitly uses the same direction, scaler and
  ellipsis as measurement.
- Hover, keyboard focus and long press now retain visibility independently.
  Leaving hover no longer hides a focused tooltip. Message changes refresh
  visible content after the normal delay; inherited size/theme/text changes
  refresh geometry. Size subscription is explicit because textScalerOf alone
  does not rebuild on window resizing. Pending display timers are canceled
  when the control disappears.
- Two initial regressions reproduced narrow-window overflow and hiding a
  focused tooltip on mouse exit. The added resize regression then reproduced
  retained desktop coordinates. Four final added cases cover independent
  interactions, 240px bounds, message updates, resize and disposal.
  All 125 shared-control tests, full 1800-test suite, static analysis,
  architecture/UI guards and production/preview release builds pass.
- Real English Edge at 3x: desktop hover shows complete playback-settings
  text. At 240x568, keyboard focus displays the updated advanced label within
  the viewport; pointer enter/exit retains it. Return changes the label, and
  resizing to 320x568 repositions/reflows the tooltip. The preview contains
  only local icon controls and state.
- Short-height/safe-area bounds, scrolling anchor movement, Escape dismissal,
  native long press and comprehensive tooltip lifetime coverage still need
  review. Shared source coverage stays partial and the goal remains active.

## Pass 152: Dismiss Tooltips With Escape

- Escape dismisses all visible shared tooltips without changing focus. A
  temporary early key handler supports hovered controls even when focus is
  elsewhere, consuming the event before normal dialog dismissal shortcuts.
  Repeat events stay consumed until key-up, preventing held-key dialog closure.
  The handler unregisters when idle.
- Dismissed tooltips remain hidden for the current interaction; fresh hover,
  keyboard focus or long press may show them again. Hiding/disposal removes
  the tooltip from the visible registry.
- Three pre-fix cases failed for hover, focus and simultaneous tooltips in a
  dialog. Final cases verify dismissal, preserved focus/dialog, key repeats,
  fresh hover and subsequent ordinary dialog dismissal. All 128 shared tests
  and full 1803-test suite pass. Static analysis passes after a test-only brace
  correction; architecture/UI guards and production/preview builds pass.
- Real English Edge at 3x: desktop 1200x900 hover showed a tooltip over a
  dialog. First Escape hid the tooltip, second closed the dialog and restored
  the entry button. At 320x568, Tab focused settings; Escape hid its tooltip
  while preserving focus/dialog, and another Escape closed the dialog.
  All interactions used the isolated preview.
- Native input, short-height/inset bounds, scroll anchoring and full tooltip
  lifetime coverage remain open. Source coverage is partial; goal stays active.

## Pass 153: Bound Tooltip Height and Remove Inert Read-Only Options

- Tooltip layout now measures the current overlay constraints and applies
  safe-area and keyboard inset bounds from the overlay MediaQuery. It fits
  complete text lines into the available height with ellipsis, preserving the
  full accessible control name. Width changes remeasure the current geometry.
- Two 3x regressions reproduce short-window and dynamic keyboard-inset overflow
  before the fix. A full-suite run exposed an anchor detached during notification
  resizing; mounted/attached/size guards prevent late geometry reads.
- Final combined notification/shared-control tests pass (162), as do the full
  suite (1805), static analysis and production release build.
- Real English Edge at 3x: 740x200 displays the long settings tooltip with
  bounded ellipsis; resizing to 320x568 restores the complete five-line text.
  Escape hides it while preserving button focus. Browser checks use the local
  isolated preview; keyboard inset changes are covered by widget tests only.
- AppReadOnlyField exposed overflow/selectable options without implementing
  them. No callers pass either option. Removing both avoids a false API contract
  and preserves the existing selectable read-only field behavior. After this
  declaration-only cleanup, all 130 shared-control tests and static analysis
  pass. Architecture/UI guards, inventory freshness and diff checks also pass.
- Heights smaller than one scaled text line, scroll-anchor tracking, native
  input, select-menu stale accessibility nodes and broader component/state
  coverage remain open. The goal stays active.

## Pass 154: Missing-Server Invite Dialog Lifetime

- Audited all three room-invite sources and traced server settings and runtime
  endpoint constraints. Missing-server confirmation previously opened settings
  from the parent context and popped that navigator after awaiting the sheet.
  Captured repeated callbacks opened two sheets, including after cancellation.
- Confirmation now uses dialog-scoped current-route, mounted and completion
  guards. It finishes before settings opens, so no delayed parent-context pop
  remains. The shared scrollable AppDialog provides a wrapping compact title,
  full-width content and wrapping actions at large text scales.
- Both callback regressions fail before the fix and pass afterward. Four en/zh
  3x cases cover 320x568 and 1200x360 layout/cancellation. All 13 invite cases and
  22 combined invite/server-settings tests pass. Analysis, architecture/UI guards
  and both production/preview release builds pass. The full suite was last run
  in Pass 153; this pass runs the directly affected feature tests.
- Real English Edge at 3x: desktop 1200x900 displays the complete title and
  description, opens one settings sheet and returns to the entry button. At
  320x568 the title wraps; End scrolls to the final sentence while both actions
  remain reachable. Cancel restores the entry page. The preview is local with
  no external server requests, persistence or clipboard mutations.
- New explicit gap: browser deployments restrict connections to their single
  server, but foreign invites still offer Add server and open a sheet whose Web
  branch hides that action. A platform-specific invitation flow is required.
  Malformed/legacy invite parsing, nested navigators, simultaneous invites and
  clipboard/platform integration also remain open. All three source records
  are partial; the goal remains active.

## Pass 155: Usable Web Foreign-Server Invite Actions

- Unmatched Web invitations now open a dedicated dialog instead of a server
  settings sheet that hides Add server. It displays the validated target
  endpoint and selectable room ID, with Copy room ID and Open server actions.
  Native missing-server setup retains the existing flow.
- Opening calls url_launcher directly from the gesture and targets a new tab.
  It preserves the current server/session. Duplicate and stale actions are
  guarded; false/throwing launches and clipboard failures show localized errors
  and can be retried. Closing remains available during an operation.
- Eleven new cases cover en/zh 3x mobile/short-window layouts, exact copy/launch
  payloads, successful/failed operations, retries, disposal and duplicates.
  Initial tests needed explicit toast cleanup before their timer invariant;
  analyzer-required explicit mounted checks were added to async continuations.
  Final full suite passes all 1822 tests. Analysis, architecture/UI guards and
  production/preview builds pass. Existing font covers all 783 localization
  codepoints, including the added messages; font assets did not grow.
- Real Edge English 3x: desktop 1200x900 shows the target and room ID, Copy
  displays success, and Open server creates an actual second local tab at the
  target origin. The current dialog remains. At 320x568, title/actions wrap and
  End scrolls to the complete room ID and copy action. Escape hides its tooltip.
  Preview navigation only targets its own local origin; no external login or
  server/account mutations were performed. Clipboard received a preview ID.
- Remaining: keyboard focus reaches the offscreen copy button without automatic
  scroll; screen-reader field values and blocked-popup variants need review.
  This opens a server and supplies the room ID; startup deep-link handling and
  automatic joining after authentication remain separate missing capabilities.
  Goal remains active and source coverage partial.

## Pass 156: Reveal Directly Focused Icon Buttons

- AppIconButton now observes descendant focus without adding a keyboard stop.
  On focus it asks its attached render object to showOnScreen, using framework
  viewport behavior to reveal an offscreen control without shifting an already
  visible one. This covers browser accessibility focus that can bypass normal
  Flutter traversal's scrolling callback, including buttons without tooltips.
- Four pre-fix regressions fail for horizontal/vertical scrolling and tooltip
  enabled/disabled variants. They now verify focusing below the viewport,
  returning above it, unchanged visible offsets and disposal. All 158 combined
  shared-control/invite tests and the full 1826-test suite pass. Analysis,
  architecture/UI guards and production/preview release builds pass.
- Real English Edge at 3x: in 320x568 the copy action starts offscreen;
  Shift+Tab focuses it and immediately reveals the room ID and copy button,
  with no End key or explicit scroll. Repeating at 1200x360 also reveals the
  focused button while preserving the footer actions. Escape dismisses the
  tooltip and Close returns to the preview entry.
- The specific Pass 155 focus-visibility gap is resolved. Other control types,
  nested/custom scroll physics, native screen readers, invite deep links and
  live cross-server login/join remain unverified or incomplete. Goal stays active.

## Pass 157: Invite Target Parsing Boundaries

- Canonical /rooms/join links without a room parameter previously resolved to
  room ID join. Legacy links under a proxy prefix fell back to the whole URL as
  an ID. Parsing now uses URI path segments for canonical and legacy room
  routes, preserving the endpoint prefix and trailing-slash compatibility.
  Query links on a bare server endpoint also retain their endpoint path.
- Nonempty room_id/roomId/r aliases and any legacy path ID must agree; repeated
  identical IDs remain valid. Empty, missing and conflicting targets raise
  FormatException before server activation. Credential-bearing URLs now reach
  the existing endpoint credential rejection instead of silently dropping user
  info. HTTP(S) validation remains owned by ServerEndpointIdentity.
- Nineteen domain cases include twelve failures reproduced before the fix.
  Three additional flow cases verify warnings, null results and zero activation
  or time-sync calls for malformed targets. All 46 invite-module tests and
  1848 full-suite tests pass. Analysis, architecture/UI guards and both release
  builds pass.
- Real English Edge 3x: desktop 1200x900 missing-ID preview shows only the
  warning and preserves the page. At 320x568 the legacy local /sync/rooms/ID
  variant displays the /sync server prefix and exact room ID; keyboard focus
  reveals those fields. All previews use local-origin fixtures; this pass did
  not navigate to another server, copy data or mutate a backend.
- Protocol-relative/custom-scheme compatibility, full ID grammar, fragments,
  startup deep links and real cross-server authentication/join remain incomplete.
  Domain coverage remains partial and the goal stays active.

## Pass 158: Join Dialog Layout and Lookup Lifetime

- Join and password dialogs now use the shared scrollable AppDialog with
  wrapping field labels and actions. Long room names display in full. Removed
  duplicated private header/action framing and inaccurate invitation guidance.
- Submissions reject duplicate, covered and disposed callbacks. Join errors
  can render inline; password rejection preserves selection and retry, without
  trimming the password. Deferred autofocus checks disposal.
- The shell receives the originating join dialog context and checks its route
  and home epoch after invitation parsing and room lookup. A cancelled lookup
  can no longer dismiss a replacement dialog or show its stale failure there.
  Two shell regressions reproduced both failures before this fix.
- Eight en/zh 3x mobile-with-keyboard and short-window layout tests failed
  before the rewrite. Eleven dialog tests and 25 combined shell/dialog cases
  pass; the full suite passes 1860 tests. Analysis, architecture/UI guards,
  localization font coverage, inventory checks and release builds pass.
- Real Edge English 3x checks desktop password rejection and selected input,
  320x568 scrolling to full error/field content and cancellation, join input
  enabling Continue, and 1200x360 join layout. Browser previews use local
  fixtures with no backend joining; keyboard insets are automated simulations.
- Source records remain partial. Taxonomy filter long-label layout, nested
  invitation/server activation lifetime, password dismissal versus server join
  completion, native accessibility and real authentication remain open. Browser
  tabs and the temporary server were closed; the whole-project goal is active.

## Pass 159: Home Label Filter Form

- Extracted the label draft UI from AppShell into the home feature. The
  shared scrollable dialog uses checkbox rows with wrapping names, swatches
  and wrapping actions. A pre-fix integration fixture reproduced 648 pixels
  of horizontal overflow. Local horizontal padding was reduced after narrow
  browser inspection so short labels retain more usable space.
- Cancel discards the draft; Clear returns an empty selection; Apply returns
  a copied set limited to available labels. Current-route, completion and
  mounted checks reject stale finish/toggle callbacks. Shell integration
  prevents duplicate openings and rejects stale epoch/category results.
- Seven dialog cases cover en/zh 3x mobile/short-window layout, key fallback,
  obsolete IDs and cancel/clear/apply/disposed callbacks. Sixteen shell cases
  include replacement-page preservation and selected/cleared discovery query
  parameters. All 1869 full-suite tests pass; the final padding adjustment
  passes the seven dialog tests again. Analysis, architecture/UI and inventory
  checks pass. Production and isolated preview release builds pass.
- Real Edge English desktop checks complete long names, checkbox state and
  selection count changing from one to two after Apply. Mobile checks End
  scrolling after focus and Clear returning zero. Final Chinese 3x checks at
  320x568 and 1200x360 verify full label content through scrolling and reachable
  actions. Local preview has no networking or persistence.
- Large taxonomy performance, category-strip long names, loading/error
  concurrency, live taxonomy changes and native accessibility remain open.
  Source records are partial and the whole-project goal remains active.

## Pass 160: Taxonomy Request Lifetime and Empty Results

- Successful empty taxonomy is tracked independently of category count, so
  searches no longer fetch category/label lists repeatedly on servers with no
  categories. Explicit home refresh refreshes both taxonomy and rooms.
- The existing operation coordinator shares an in-progress taxonomy request.
  Filter opening awaits that request instead of prematurely displaying an empty
  draft. Failed filter loads show localized feedback and can be retried.
- Session reset invalidates taxonomy requests and releases the pending filter's
  modal guard. Its old completion cannot release a newer modal's guard. This
  fixes expiration during loading suppressing the login window; stale failure
  results cannot update the new session or notify it.
- Twenty shell tests pass, including empty-cache, shared-load, failed retry and
  expiration scenarios. Empty-cache/shared-load and expiration regressions were
  reproduced before their fixes. Analysis, architecture/UI guards and release
  build pass. The full suite passes 1873 tests.
- Real Edge loads the production home against the local backend, refreshes,
  opens the ten-label list and verifies desktop rendering. At 320x568 repeated
  Tab traversal reveals the final label and keeps actions accessible. No room
  joining, authentication changes or backend writes were performed. Controlled
  failure/concurrency behavior is established by tests, not this browser run.
- Same-name labels from different categories lack distinguishing context in
  the list. Taxonomy changes also need further reconciliation with already
  loaded discovery results. These and whole-project coverage remain open.

## Pass 161: Category Context and Filter Reconciliation

- All-category label filtering now includes each label's category as a
  wrapping subtitle and in its checkbox accessible name. A scoped category
  omits redundant subtitles. Empty category names fall back to keys; absent
  bindings and unknown categories use existing localized labels. Selection
  remains ID-based when visible label names are identical.
- Taxonomy refresh clears deleted selected categories and unavailable label
  IDs, resets the page and reloads rooms when filters changed. Set membership
  replaces repeated linear scans while pruning. A pre-fix shell regression
  reproduced the stale selected category after deletion.
- Nine dialog and 21 shell tests pass, including same-name independent IDs,
  subtitle fallbacks/scoped omission and final discovery parameters after
  taxonomy removal. The full suite passes 1876 tests. Analysis, architecture/UI
  guards and production/preview release builds pass.
- Real Edge at English 3x distinguishes Film & TV and Music & Live under
  identical Weekend labels. At 320x568 keyboard traversal reveals the target
  label and subtitle; selecting and applying it updates the count to two.
  This preview performs no backend changes. Backend taxonomy deletion is
  exercised through the test gateway, not live administration.
- Very large catalogs, duplicate category names, all stale draft/refresh
  combinations, native screen readers and broader page coverage remain open.
  The goal remains active.

## Pass 162: Discovery Pagination After Depletion

- Room loading captures the requested page. A current response whose total
  no longer includes that page updates the page to the last valid page and
  re-queries it; an empty result set uses page one. Epoch and request-generation
  checks run before correction so stale responses cannot cause navigation.
- Three pre-fix regressions reproduce a page-three refresh after totals shrink
  from 49 to 0, 24 and 25. All now query the corrected page. Two additional
  cases complete an older request with empty success or failure after a newer
  search and verify unchanged page, total, errors and request count.
- Twenty-six shell tests, analysis, architecture/UI guards and production
  release build pass. The full suite passes 1881 tests.
- Real Edge production regression selects Film & TV and shows two rooms,
  page 1/1 and disabled paging actions. At 320x568 the summary and controls
  remain distinct and visible. The local dataset has no multi-page depletion;
  automated gateway tests establish that behavior without backend mutations.
- Recovery-request failure, repeated concurrent depletion, category-strip long
  text/focus, native devices and wider frontend coverage remain open. The goal
  remains active.

## Pass 163: Long Category Names and Recovery Failure

- Category chips fit the available width (maximum 360 logical pixels), with
  single-line ellipsis and full names in tooltip/accessibility text.
- Two 320px tests at 1x/3x verify bounds, held long-press disclosure and selection
  by category ID. The existing preview accepts a long-category query fixture.
- A shell regression verifies a failed corrected-page request followed by a
  successful refresh: valid page, stopped loading, visible error and recovery.
- Combined home/shell tests: 38 passed. Analysis, architecture/UI guards and
  release Web build passed. Edge desktop and 320x568 at 3x confirm bounded chips,
  full accessible names, keyboard scroll into view and wrapping full-name tooltip.
- Full regression suite: 1884 passed. Audit inventory and whitespace checks pass.
- Preview callbacks do not change backend filters; ID dispatch and failure
  recovery are established by tests. Very large/duplicate category catalogs,
  native screen readers and complete homepage state coverage remain open.

## Pass 164: Filter Context After Awaited Taxonomy

- Opening labels during taxonomy refresh previously captured the old category.
  If refresh removed that category, the dialog hid category subtitles and Apply
  silently discarded the selection because the old category no longer matched.
- Capture category context after refresh/reconciliation, immediately before opening
  the dialog. Existing post-dialog stale-category and session guards remain.
- New regression fails before the fix and verifies subtitle context, applied count
  and final discovery label IDs. All 37 shell/label-dialog tests pass; analysis,
  architecture/UI guards and release Web build pass.
- Real Edge desktop/320px verifies scoped label layout and applying Weekly Pick
  under Film & TV reduces live discovery from two rooms to one. The asynchronous
  category-deletion race is exercised by the regression, not by backend mutation.
- Full suite was last run in Pass 163 (1884 passed); this narrow state-capture
  change runs the affected shell/dialog suites. Live administrative deletion and
  complete taxonomy concurrency combinations remain outside this evidence.

## Pass 165: Home Room Deletion Lifetime

- Deletion previously used the home navigator context for confirmation and captured
  session epoch only after confirmation. Repeated actions stacked dialogs; a saved
  callback from a cancelled dialog could dismiss its replacement.
- Extracted production confirmation using shared AppDialog, full wrapping room name,
  consistent title style and destructive action. Completed/mounted/current-route
  checks scope callbacks to the originating dialog.
- Per-room operation tokens cover confirmation through request completion; session
  reset clears tokens, and only the owning operation can release its token. Epoch
  checks surround confirmation and request, suppressing stale session effects.
- Two pre-fix regressions fail. Added expiration and four en/zh 3x mobile/short-window
  cases; 35 related tests and full 1892 tests pass. Analysis and architecture/UI guards
  pass. Preview and production Web builds succeed.
- Edge desktop and 320x568 at 3x verify the full accessible room name, wrapping controls,
  destructive appearance, Tab access and Return confirmation in a local-only preview.
  No live room was deleted. Native accessibility, complete long-body scroll interaction,
  concurrent different-room dialogs and backend deletion integration remain open.

## Pass 166: Favorite State Versus In-Flight Discovery

- A home refresh issued before favorite completion could later overwrite the local
  successful or rollback value with an older list response.
- Favorite value/revision overrides and a snapshot of pending IDs reconcile reads
  overlapping mutations across popular, featured and joined rooms. Subsequent reads
  begun after completion retire overrides and accept fresh server state. Session
  reset clears overrides.
- Four pre-fix cases reproduce incorrect false values (after correcting a test's
  animation wait). Eight tests cover success/failure, read start before/during the
  mutation, read completion before/after it, pending flags and later server changes.
- All 39 shell tests pass; analysis, architecture/UI guards and Web release build
  pass. Edge desktop/320px checks live anonymous refresh and card rendering.
- Full regression suite: 1900 passed. Audit inventory and whitespace checks pass.
- Authenticated favorite races are verified through controlled async tests, not
  live browser mutations. Multi-room stress and session changes during overlapping
  favorite/discovery operations remain additional coverage work.

## Pass 167: Select Popup Long-Option Height

- Default compact AppSelect constrained popup rows to 48 pixels even when the
  option label needed several lines. Popup rows now size to their contents;
  collapsed-field density and ellipsis remain controlled by wrapText.
- A 320px/3x regression fails with a 48px item before the fix and verifies expanded
  row height and selecting the long value afterward. All 135 shared-control tests,
  full 1901 tests, analysis, architecture/UI guards and release Web builds pass.
- Edge 320px/desktop at 3x displays the full three-line International cinema
  screenings option. Selecting it increments form changes once and restores the
  full named collapsed button; the selected field retains compact ellipsis.
- Rechecked Clear/required validation/menu selection and resize: Dismiss appeared
  transiently after closing and recovered on subsequent reads. These observations
  do not resolve earlier persistent Dismiss reports. Cross-browser/native readers,
  very large option sets and nested modal combinations remain open.

## Pass 168: Select Values Removed From Dynamic Options

- Passing an external selected value after its option disappeared triggered the
  Flutter unique-item assertion. The shared select now supplies a null form value
  when the external value is absent from current options.
- Reconciliation leaves parent state untouched and emits no user change callback.
  Reappearing options restore the external selection. The regression verifies
  removal, empty options, restoration, Form.save and required validation; it fails
  with the unique-item assertion before the fix.
- All 136 shared-control tests, full 1902 tests, analysis, architecture/UI guards,
  release Web build and audit inventory checks pass.
- Edge desktop/320px at 3x verifies Music removal to No category, restoration and
  unchanged Changes: 0. The fixture mutates only its local option list.
- Popup-open option changes, duplicate option values and native screen-reader
  behavior remain outside this pass; persistent Dismiss diagnosis stays open.

## Pass 169: Reject Stale Popup Options Before Form Mutation

- Flutter retains popup options from opening time. Removing Film while the popup
  was open still allowed submitting Film, mutating form state and firing callbacks.
  A new regression reproduces that obsolete callback before the fix.
- AppSelect now composes its FormField state, InputDecorator and DropdownButton.
  Current-option validation runs before didChange. Existing initial-value sync,
  save/validation, clear/reset callbacks and focus decoration remain covered by
  the 137-test shared suite. The full 1903-test suite passes, as do analysis,
  architecture/UI guards and release Web build.
- Edge 320px/3x verifies Music removed while the popup stays open: selecting the old
  item closes the menu, retains No category and Changes: 0, and restores named field
  focus. At desktop, Clear shows Required with exactly one form change.
- The local live fixture uses a cancellable focus-triggered timer. An initial
  pointer-only fixture did not fire for accessibility activation and was corrected
  before using browser results as evidence. No backend data is modified.
- Full decorated-field tap coverage, stale disabled callbacks, duplicate values,
  native readers and persistent Dismiss diagnosis remain further audit work.

## Pass 170: Reject Invalidated Select Callbacks

- Saved clear and popup callbacks could mutate a field after disabling it,
  removing its callback or changing accepted options/clearability. Seven of eight
  regression scenarios failed before the fix; disposed clear was already guarded.
- Both actions now validate the current mounted FormField configuration before
  mutation. The 145 shared-control tests and full 1911-test suite pass, as do
  analysis, architecture/UI guards and the release Web build.
- Edge at 320px and English 3x opens a menu, observes delayed field disabling,
  selects its old No category item and retains Music with Changes: 0. Reenabling
  and clearing yields No category, Required and Changes: 1. Disabled semantics and
  the narrow layout were inspected. The fixture performs only local state changes.
- Decorated-field tap coverage, duplicate values, native readers and persistent
  Dismiss diagnosis remain open. The overall audit remains partial.

## Pass 171: Restore Decorated Select Hit Targets

- The FormField composition change left the prefix icon and surrounding input
  padding outside the dropdown's hit target. Four tests reproduce missed taps at
  1x/3x before the fix, affecting otherwise enabled fields.
- A gesture detector forwards decorated-area taps through the dropdown's existing
  ActivateIntent action using its focus context. It excludes redundant semantics,
  respects disabling and leaves the clear button independent. The state disposes
  its own fallback FocusNode; externally supplied focus nodes remain supported.
- Regression cases verify disabled taps, prefix/padding activation, internal and
  external focus nodes, one selection callback and clear without a popup. All 149
  shared-control tests and full 1915 tests pass; analysis, architecture/UI guards
  and release Web build pass.
- Edge mobile 320px/English 3x uses real coordinate clicks on the prefix and top
  padding, then checks selected text, validation and exact change counts. Desktop
  1200px verifies prefix activation, independent clear and Escape cancellation.
  Field focus and named semantics return after closing animations. These sequences
  do not resolve earlier persistent Dismiss cases. The local prefix fixture has no
  backend effects. Browser viewport and temporary server were cleaned up.
- Hover styling, duplicate values, native readers and broader component/code
  organization coverage remain further work; the overall goal stays active.

## Pass 172: Nextcloud Binding Lifetime And Usable Forms

- Extracted the Nextcloud form from the multi-provider account-dialog file into
  its own part, keeping existing gateway and presentation boundaries.
- Eight regression cases reproduce duplicate browser/password requests, mutable
  inputs during submission, external launch after cancellation, polling after
  cancellation and late success dismissing a replacement dialog. Submissions now
  check current-route lifetime and loading state, capture the target instance,
  disable inputs/modes and reject stale callbacks before further UI actions.
  Poll retries stop after cancellation; active failures retain retry support.
- English mobile 3x exposed a 74px dialog overflow and a title consuming most of
  the viewport. Provider-form headers now use titleMedium. Nextcloud labels sit
  above fields, actions scroll with the form, and modes use vertical segments at
  constrained widths. AppSegmentedControl exposes direction with its horizontal
  default preserved. Vertical labels are explicitly bounded because Flutter's
  intrinsic vertical layout otherwise extended outside the narrow dialog.
- All 16 Nextcloud tests pass, covering the eight races, active success paths,
  password retry, canceled polling delay and four en/zh 3x layout cases. The full
  1931-test suite, final static analysis, architecture/UI guards and release Web
  build pass. Notification timers are explicitly dismissed in success tests.
- Edge English 3x at 320px and desktop verifies scroll access, full mode labels,
  mode switching, disabled inputs/instance/modes during a simulated request, and
  cancellation followed by its late failure without navigation or notification.
  The isolated gateway cannot authenticate or return an external login URL.
- Real Nextcloud authorization, native redirects, HTTP request cancellation,
  polling error classification, translations, long action-label truncation and
  broader provider variants remain incomplete. The audit and goal remain active.

## Pass 173: Full Dialog Actions And Scroll Access

- Shared cancel/confirm buttons and generic provider bind/rebind actions now
  wrap labels. Four 320px styled-dialog cases at 1x/3x and existing en/zh
  provider layout cases reproduce five failures before the fixes.
- Styled-dialog actions scroll with content beneath the fixed header, resolving
  the 1px/181px overflow exposed by multiline buttons. FNOS actions scroll with
  the form to preserve access to challenge/trust controls.
- All 61 related tests and the full 1935-test suite pass, together with static
  analysis, architecture/UI guards and the production release Web build.
  Tests cover complete labels, bounds, hit testing and dismissal callbacks.
- Edge English 3x at 320x568 verifies full Bind Nextcloud and Open browser
  labels, FNOS setup/retry/challenge, trust toggling and cancellation. The actual
  styled dialog shows complete four-line confirmation on mobile and two-line
  confirmation at 1200x700; both actions return to the preview entrance.
  Provider checks use an isolated fake gateway without real authentication.
- Remaining gaps include other fixed-action consumers, specialized Bilibili
  controls, header truncation, extreme window/inset combinations, caller-context
  lifetime, real provider integration and native/performance tests. The shared
  instance selector keys options by display label: a named instance matching
  the localized local-instance label can overwrite that option. This source
  finding still needs a regression and repair. Broad source coverage remains
  incomplete; the goal stays active.

## Pass 174: Provider Instance Identity Under Label Collisions

- Two en/zh binding regressions and a room-media regression reproduce local
  instance loss when a remote name equals the localized local-instance label.
  Both selectors used display labels as map keys and silently overwrote the
  empty local identifier.
- A shared provider presentation helper preserves raw identifiers, remote names
  and order. It adds localized default wording only to a conflicting local
  label, reserving every remote name before choosing a numeric suffix. Tests
  include remote names matching both the fallback label and its second suffix.
  Binding and room media selectors use this helper; the obsolete room-only
  single-label function is removed.
- Tests select each binding target through the popup and inspect login arguments;
  room tests select remote/local targets and inspect listMediaLibrary arguments.
  All 46 related tests and the full 1938-test suite pass, as do final analysis,
  architecture/UI guards and the production release Web build. Existing Web
  Wasm dry-run incompatibilities remain; this is a JavaScript release build.
- Edge English 3x at 320x568 verifies full wrapping labels, separate local/remote
  choices and switching in both directions. The isolated preview contains a
  deliberate three-level label collision and performs no real authentication.
  The final extracted-helper build at 1200x800 displays all five menu choices;
  ArrowDown/Enter selects the named remote instance and restores field focus.
  Resizing that build to 320px still permits returning to the local instance.
- Other provider/account display surfaces may still be visually ambiguous when
  names coincide. Broad dialog layout/lifetime coverage, native readers, all
  locales and real integrations remain incomplete. The goal stays active.

## Pass 175: Bilibili QR Cancellation And Retry

- Three regression cases reproduce work continuing during dialog exit: instance
  loading starts a QR request, QR creation starts polling, and a successful poll
  dismisses a replacement dialog. Mounted alone does not identify a current route.
  QR entry points, periodic polling and asynchronous completions now check route
  lifetime as well as the existing instance generation. Stale instance callbacks
  are rejected; active success still refreshes bindings once and closes normally.
- A fourth failing regression exposes missing recovery after QR creation errors.
  Failed creation now offers Retry; the loading guard prevents two immediate
  clicks from starting duplicate requests. Existing expired-code regeneration
  and instance-switch isolation retain their behavior.
- All ten Bilibili tests and the full 1943-test suite pass, together with final
  analysis, architecture/UI guards, inventory/whitespace checks and the production
  release Web build. The normal-success test verifies refresh count and stopped
  polling; cancellation tests exercise the exit-animation window directly.
- Edge English at 320x568 with normal text verifies a visible failure, Retry,
  rendered QR and closing before the fake 30-second success. After that delay,
  the entrance remains visible without success notification or navigation.
  Desktop 1200x800 shows the QR, complete tabs and reachable copy/open/cancel
  controls; keeping that dialog open lets fake success close it and return focus
  to the binding entrance. The preview performs no real authentication or external
  launch.
- SMS session/captcha/send/login lifetime, external launch and clipboard results,
  recovery after rate limiting, temporarily covered routes and Bilibili large-text
  layouts remain incomplete. Browser cancellation complements the widget race
  tests; it does not reproduce their exact sub-animation timing. Goal stays active.

## Pass 176: Bilibili SMS Session Ownership

- Opening the SMS tab reproduced a Flutter inherited-localization assertion from
  initState. Initialization now runs in didChangeDependencies. The cohesive SMS
  panel moves into its own part file with the existing parent/gateway API intact.
- After the entry fix, regressions expose verification continuing into send after
  cancellation or mode changes, late login refreshing/dismissing another flow,
  duplicate verification requests, login with an unsent session and retained
  codes after phone changes. Current-route/active-mode and generation checks now
  guard each continuation, including the gap after preparing a missing session.
  Mode/instance changes invalidate work; phone edits clear sent sessions/codes.
  Busy guards prevent duplicate submissions and disable phone/code inputs.
- Thirteen SMS tests cover close/switch/switch-back at captcha/send/login,
  reversed preparation results, duplicate send/login, active success, unsent
  rejection and phone changes. Tests use the existing verification-client port
  with a Linux target variant. Test setup also required notification timer cleanup
  and explicit tab animation frames; these are distinct from runtime defects.
- All 1956 tests pass with final static analysis, architecture/UI guards and the
  production release Web build. The original QR regressions remain passing.
- Edge normal-text desktop 1200x800 verifies the SMS tab, fake send, code input,
  disabled fields/actions during login, and cancel returning to the entrance.
  Mobile 320x568 shows the wrapping action layout and reachable form. Verification
  and SMS responses are simulated; no SMS, external captcha or authentication
  request is made. Browser timing does not prove the sub-animation races covered
  by widget tests.
- Mobile fake send followed by code entry and phone replacement clears the code
  visually. That check exposed a misleading switch-tab prompt in the active SMS
  tab; reset now uses the active form guidance, with a regression assertion.
  The browser accessibility snapshot retained the old code value despite an empty
  rendered input; refocusing the code field removed that stale value. Native
  screen readers and synchronization without refocusing remain unverified.
- Large-text layouts, native captcha window lifetime, real SMS/authentication,
  rate limits, temporarily covered routes and error classification remain further
  work. The source record is partial and the goal stays active.

## Pass 177: Bilibili Large-Text Login Layout

- Four en/zh desktop/mobile 3x cases fail before the layout changes. Login mode
  now uses responsive segmented buttons, vertical under width/text pressure.
  State-preserving visible panels remove the fixed 48px tab and 374px content
  constraints. Mode selection is through these buttons; the former TabBarView
  swipe interaction is removed along with its controller/ticker.
- SMS phone/code labels sit above their fields and wrap. Bind and secondary
  action labels wrap within available width. Mobile testing also exposes Bilibili
  entry overflow of 469px English/175px Chinese; entry information now scrolls
  and its unbound action wraps.
- All 27 related tests and the full 1960-test suite pass, together with analysis,
  architecture/UI guards and production Web build. Tests use the project theme;
  long labels are centered into view before tapping because their test-font
  height may exceed the remaining viewport. Existing SMS/QR race tests pass.
- Edge English 320x568 at 3x verifies the scrolling entry, visible mode controls,
  switching to SMS, complete multi-line code label and bottom Verify again,
  Send SMS, Bind and Cancel actions. Cancel returns to the binding entrance.
  The preview uses fake gateways without external authentication or SMS.
- Edge English 1200x800 at 3x verifies the vertical mode controls, rendered QR,
  complete wrapped link, and scroll access to Copy link, Open login and Cancel.
  Cancel restores the binding entry. The preview's `qr=hold` option keeps fake
  polling pending for inspection; external launch and clipboard were not invoked.
- Long-word breaks, bound-account entry actions, native keyboards/readers, extreme
  insets and the remaining provider forms still need review. Goal remains active.

## Pass 178: QR Link Action Lifetime and Errors

- QR copy/open previously awaited platform calls without error handling and
  checked only mounted before notifying. Both actions now catch platform
  failures, reject duplicate requests and disable their own pending control.
  Route validity and operation generations discard results after cancellation,
  login-mode changes and instance/QR replacement, including switching away/back.
- Thirteen new platform-channel tests cover success, exceptions, launch returning
  false, duplicate taps, cancellation during both successful/failed operations,
  and mode/instance replacement. All 1973 full-suite tests pass. Final explicit
  mounted checks satisfy static analysis; production Web build and architecture/UI
  guards pass. All 40 final QR/SMS tests pass after those analyzer-only edits.
- Edge 1200x800 and 320x568 at normal text scale render the QR and link actions;
  clicking Copy link invokes the real browser clipboard API and shows success.
  Mobile scroll reaches both actions and Cancel, which restores the entry.
  The preview uses a fake QR URL and no account authentication. External launch
  success/failure is covered through mocked platform responses, not a real app.
- Mobile success toasts temporarily cover Copy link/Open login, although Cancel
  remains visible. AX retains a Dismiss container after the toast expires. These
  shared notification issues, native platform integration, bound-account actions
  and the remaining provider surfaces stay open. Goal remains active.

## Pass 179: Bilibili Bound Entry and Unbind Confirmation

- Extracted the Bilibili entry into `bilibili_binding_view.dart`. Information and
  actions share one scroll region; responsive buttons account for text scaling,
  narrow headers stack, and complete instance/server labels wrap. Metadata uses
  theme foreground colors after browser inspection exposed low-contrast pink.
- Eight en/zh normal/3x mobile/short-desktop tests fail before the entry change
  due to truncated metadata, then pass with reachable action labels and canceled
  unbinds issuing no logout. SMS fixtures now scroll to the entry Bind action.
- Browser inspection additionally found the unbind title truncated at 3x. Three
  title assertions reproduce it. Provider unbind confirmation now uses a standard
  scrollable AppDialog with a wrapping titleMedium title, a destructive action
  and the dialog builder's own context for dismissal. All eight tests pass.
- Final full suite: 1981 passed; final analysis, architecture/UI guards and release
  production/preview builds pass. The 100-test binding subset passed before the
  final confirmation change, which is covered again by the final full suite.
- Edge English 320x568 and 1200x360 at 3x verify full metadata, responsive action
  layout, complete confirmation text, destructive styling and cancellation back
  to the bound entry. The preview's bound=1 fixture has fake account details and
  an in-memory-only logout; no real account operations occur.
- Account detail rows still use a fixed 72px label column. Unbind submission and
  details-request lifetime/duplicates, other provider variants, dark-theme/native
  visual checks and shared notification overlap remain open. Goal stays active.

## Pass 180: Account Details Loading, Lifetime and Layout

- Details previously waited before opening, allowed repeated requests and could
  open after the user moved on. Details now open immediately with a Close action,
  loading feedback and in-place failure/retry. Entry route/provider/lifetime guards
  prevent duplicate/stale opens; future identity guards reject repeated retries.
- Extracted the dialog, selectable rows and provider row mapping into
  `provider_account_info_dialog.dart`. Captured gateway/localization values avoid
  reading an old page context after disposal. FutureBuilder owns results, so late
  success/error neither navigates nor notifies after closure. Labels and values
  use full-width stacked rows instead of a fixed 72px label column.
- Seven regressions fail before the change: no immediate Close, duplicate
  requests, and truncated 3x titles. All pass afterward, including retry recovery,
  target instance forwarding and en/zh mobile/short-desktop layout. Final full
  suite passes 1988 tests; analysis, architecture/UI guards and production/preview
  Web builds pass. Final test-only brace formatting does not change behavior.
- Edge English 1200x800 at 3x verifies loading, simulated failure, Retry, loading
  again and successful long account data in the same dialog. At 320x568, full
  username, server and instance values wrap and scroll; Close remains reachable
  and restores the bound entry. Preview calls are simulated, not real accounts.
- Unbind mutation lifecycle remains separate work. Provider-specific payloads,
  remaining hard-coded detail labels, dark/native accessibility and temporarily
  covered routes remain unverified. Goal remains active.

## Pass 181: Provider Unbind Lifecycle

- Unbind previously removed the account before the request completed, permitting
  rebind/logout races. Per-provider confirming/submitting state now disables
  add/details/unbind, retains the account until success and recovers after failure.
  Confirmation revalidates page/provider/binding; gateway access is captured before
  awaiting. Success removes locally and refreshes; old load generations cannot
  restore pre-mutation data. Covered-route results refresh without notifications.
- Extracted confirmation and gateway dispatch into `provider_unbind_dialog.dart`.
  Completed/mounted/current-route checks protect both cancel and confirm callbacks
  from duplicate submission or popping replacement dialogs. Confirming has no
  loading animation; submission shows a stable indicator in the Bilibili action
  or a progress bar above other provider lists.
- Six regressions cover duplicate/stale confirmation, conflicting callbacks,
  retained state and disabled actions, failure/retry, covered success/error and
  parent disposal before confirmation. Four fail before the fix. Final full suite
  passes 1994 tests; analysis, architecture/UI guards and both Web builds pass.
- Edge English 1200x800 and 320x568 at 3x verify disabled submitting controls,
  account retention after a simulated failure, restored actions and a successful
  retry reaching the unbound entry. The unbind=retry fixture waits ten seconds
  per attempt and changes in-memory preview state only; no real accounts mutate.
- After resizing, the horizontal provider tabs can leave the selected Bilibili
  tab offscreen while the correct content remains selected. Navigation visibility,
  generic populated provider lists, provider-specific logout integration and
  broader refresh/session races still need review. Goal remains active.

## Pass 182: Selected Tab Visibility After Resize

- Shared AppTabBar now reveals the selected tab through its nearest horizontal
  scroll position after viewport width, text scaling or text direction changes.
  Initial layout and ordinary scroll/rebuild events preserve manual browsing.
  Keyed tab content retains PreferredSize for icon/text tab height behavior.
- Eight regressions cover LTR/RTL, viewport/scale changes and implicit/explicit
  controllers; the first four fail before the fix. Existing account-page tests
  exposed interference when selected-font changes altered content extent, so
  extent-only changes do not trigger correction. Final 304 shared/account tests
  and the full 2002-test suite pass. Analysis, architecture/UI guards and final
  production/preview Web builds pass.
- Edge English 3x verifies Bilibili at 1200x800 shrinking to 320x568, retained
  manual wheel scrolling and confirmed Twitch selection followed by shrinking.
  Selected labels remain visible and corresponding content stays selected.
  Preview data is simulated. One mobile AX click immediately followed by resize
  showed Cloudreve while Twitch retained focus; a separate settled desktop click
  selected Twitch correctly. Rapid input/resize and Web AX geometry need a
  dedicated reproduction before attributing this observation to app code.
- Oversized individual tab labels, dynamic content/style changes, nested custom
  scrolling, dark themes and native accessibility remain further audit work.
  Goal remains active.

## Pass 183: Tab Pointer Direction And Controller Ownership

- AppTabBar owns/disposes Flutter's TabBarScrollController and passes it directly
  to mouse handling. This removes a GlobalKey and recursive descendant traversal
  from every drag/wheel event. Native tab scrolling, selected-tab reveal and
  preferred heights remain covered by existing tests; no timing benchmark is
  claimed for the structural reduction.
- Mouse deltas now respect the horizontal axis direction. Two pre-fix failures
  reproduce RTL dragging stuck at the start and vertical-wheel mapping opposite
  to native horizontal wheel input. Six direction/input cases verify forward and
  return drag distances, exact wheel offsets and unchanged tab selection. Final
  309 shared/account tests and 2007 full tests pass, along with analysis,
  architecture/UI guards and production/preview release builds.
- The fake provider preview gains direction=rtl. English 3x Edge at 320x568
  verifies RTL wheel movement and Emby selection, then 1200x800 verifies selected
  desktop layout. Default-direction mobile wheel input and Twitch selection also
  pass. This checks directionality only, not full RTL locale support. Mouse drag
  itself remains automated-widget coverage rather than a browser drag check.
- Separated mobile scroll/click/result reads also selected Twitch correctly before
  this fix. The previous rapid click/resize mismatch is not attributed to this
  pointer-direction fix and remains an unconfirmed timing observation. Native
  devices/readers, custom physics and oversized labels remain open. Goal active.

## Pass 184: Populated Provider Account Lists

- Extracted the generic bound list and account card into provider_bind_list.dart.
  Removed single-line title/metadata truncation and the fixed 180px chip limit.
  A distinct nonempty subtitle now displays the loaded username/user identifier,
  helping distinguish records with the same host. Cards put actions below content
  under width/text-scale pressure, and metadata uses theme foreground colors.
  Lazy list construction and existing loading/submitting/Bilibili paths remain.
- Sixteen Emby cases cover en/zh, 1x/3x, 320x568/1200x360 and light/dark themes.
  All fail before the fix and pass afterward, checking complete text, bounds,
  reachable unbind/cancel and zero logout calls. Full 2023 tests, analysis,
  architecture/UI guards and production/preview Web builds pass.
- Fake accounts=long supplies three Emby records with shared host and distinct
  account/server IDs; dark=1 enables the existing dark theme. Edge English 3x
  light desktop/mobile verifies wrapping, metadata scrolling, reachable actions
  and unbind cancellation. Dark short desktop verifies theme colors, record
  identification and scrolling to the second record. No live provider mutates.
- The unbind dialog still names only the provider, leaving the specific account
  ambiguous when multiple records exist. Identity confirmation, generic mutation
  races, all-provider mapping/integration and native accessibility remain open.
  This pass also reconciles the parent file's omitted Pass 181 audit fingerprint
  with its current guarded unbind implementation and passing regression suite.
  Goal remains active.

## Pass 185: Specific Account Unbind Confirmation

- Confirmation receives the same selected immutable binding item used for
  submission. It shows account title/subtitle, server identifier and instance
  through the existing wrapping/selectable account-info view. Duplicate account
  text is collapsed; existing local-instance/server display fallbacks apply.
  Confirmation callback guards and post-confirmation identity checks remain.
- Sixteen en/zh, light/dark, 1x/3x mobile/short-desktop cases now verify
  confirmation identity fields, bounds, scroll access and cancellation. One new
  two-account shared-host case checks the selected identity and exact submitted
  Emby server ID. All 17 identity assertions fail before the change. Final 31
  related and 2024 full tests pass, as do analysis, architecture/UI guards and
  production/preview release builds. The success test explicitly dismisses its
  notification; the final full run includes that timer cleanup.
- Edge English 3x at 1200x800 selects the second fake Emby record and verifies
  its account/server suffix. Resizing the same dialog to 320x568 preserves
  readable scrolling through full server and instance values, with Cancel and
  Unbind reachable throughout. Cancel restores the list; no real account mutates.
- Generic mutation races, all-provider payload/dispatch semantics, malformed
  identifiers, duplicate remote display labels and native readers remain open.
  Goal remains active.

## Pass 186: Provider Initial Load Failure And Recovery

- Initial binding-load failures previously emitted transient notifications and
  then displayed the same empty/bind entrance as a successful empty response.
  Per-provider errors now render a scrollable error message and Retry in the
  affected tab. Background failures stay in that tab. Retry checks route,
  selected provider, loading state and current error; success clears the error.
- Ten regressions cover Emby/Bilibili, en/zh, 3x mobile/short desktop, complete
  error text, reachable Retry, duplicate/stale callbacks, hidden-provider isolation
  and disposal during retry. The first nine fail before the fix. Full 2034 tests,
  analysis, architecture/UI guards and production/preview Web builds pass.
- The fake Emby bindings=retry fixture fails once after three seconds and returns
  its configured fake records on retry. English Edge 3x desktop/mobile verifies
  failure, error scrolling, Retry, visible loading and populated recovery. No
  real provider networking or mutation occurs. Emby logout request inspection
  also confirmed its existing server-ID argument matches the backend API.
- showLoading=false refresh failures retain their existing silent behavior and
  need a separate stale-data recovery review. Cross-instance partial failures,
  dark/native error states and loading semantics remain open: the immediate Web
  loading screenshot showed a spinner without a corresponding AX status node.
  This observation does not establish native screen-reader behavior. Goal active.

## Pass 187: Named Loading Semantics

- Shared circular and linear progress indicators now expose localized loading
  names, with optional custom semantic labels and an English fallback outside
  app localization. Native progress roles and numerical values are preserved;
  visual layout and dimensions are unchanged.
- Nine regressions fail before the fix and pass afterward, covering en/zh,
  determinate/indeterminate progress, overrides, bounds, locale changes and
  removal. Full 2043 tests, analysis, architecture/UI guards and both release
  Web builds pass. Tests target the actual progress semantics node and dispose
  their semantics handles before test completion.
- Edge English 3x at 1200x800 and 320x568 verifies the visible spinner and named
  Loading AX container using a thirty-second fake Emby load. Account content
  replaces the node on completion. Flutter roles are widget-tested; browser
  role mapping and native screen-reader behavior remain separate limitations.

## Pass 188: Post-Mutation Binding Refresh Recovery

- Binding reload errors now reach the provider-local error/retry view even when
  the reload follows a mutation without a loading screen. This prevents silent
  refresh failures from presenting stale bound/empty content as current data.
  Shared readiness checks also reject captured add, details and unbind commands
  during loading, an error or an active unbind operation.
- Two regressions first reproduce the missing recovery UI after successful and
  failed logout. Final cases check stale commands, duplicate Retry, exactly one
  logout submission and recovery to bound/unbound content. All 142 binding tests
  and 2045 full tests pass, with clean analysis, architecture/UI guards and
  production/preview release Web builds.
- The fake Bilibili bindings=refresh fixture rejects its first post-mutation
  reload. Edge English 3x desktop verifies account confirmation, local unbind
  success and refresh failure; 320x568 verifies complete scrollable error text,
  reachable Retry, recovery and reachable Bind Bilibili. Immediate post-dialog
  AX labels were transient; the next read restored complete labels without a
  resize. No real accounts or provider services were mutated.
- Reconciled the Bilibili entrance's omitted Pass 181 source fingerprint after
  reviewing nullable callbacks and submitting-progress forwarding against the
  existing and current unbind tests. Cross-instance partial responses, every
  provider's live mutation, pending silent-refresh presentation and native
  readers still need review. Goal remains active.

## Pass 189: Pending Binding Refresh State

- Silent reloads after binding previously left old commands active without
  refresh feedback. An independent refreshing state now keeps existing content,
  shows linear progress and disables add/details/unbind until the reload ends.
  The shared readiness and retry guards reject captured callbacks during this
  interval; request-generation checks govern cleanup. Bilibili progress remains
  above its scroll region so long content cannot scroll it out of view.
- Six Nextcloud regressions fail before the fix. Final cases cover empty and
  existing account lists, stale commands, success, failure and disposal. Two
  Bilibili cases verify pending reload feedback after successful/failed logout.
  All 2053 tests pass, with clean analysis, architecture/UI guards and release
  production/preview Web builds.
- The fake Bilibili bindings=refresh-slow fixture delays reloads thirty seconds.
  English Edge 3x desktop/mobile verifies visible named Loading, disabled Bind,
  scrolling with persistent progress, completion at the same scroll position
  and a working binding entrance. Closing that form briefly exposes Dismiss;
  the next AX read restores list labels and focus without resize.
- Generic refresh scrolling with large lists, dark refresh states, dependency
  replacement, native readers and live provider workflows remain unverified.
  Read-only inspection confirms cross-instance queries use Future.wait and fail
  as a whole when an instance fails; partial-result UX needs separate design
  and tests. Goal remains active.

## Pass 190: Account Snapshot Command Ownership

- Provider readiness alone allowed old record callbacks to reopen details or an
  unbind confirmation after a list refresh. Account commands now require their
  exact item to remain in the current presentation snapshot. The same check
  runs after confirmation, replacing the previous identifier-only membership
  check. Ordinary rebuilds retain items; refreshed lists invalidate old handlers.
- Six regressions fail before the fix, covering details/unbind after removal,
  replacement or refresh with unchanged backend identifiers. Final tests verify
  no stale details query or dialog, no logout, and working current details and
  unbind commands. Full 2059 tests, analysis, architecture/UI guards and both
  release Web builds pass.
- The fake Emby fixture now supports in-memory logout by server ID. Edge English
  3x desktop deletes the second of three same-host records and verifies first
  and third remain. The refreshed third record opens the correct confirmation;
  mobile 320x568 verifies long identity scrolling and cancellation. Direct stale
  callback invocation is automated-only. No real account was mutated.
- Cross-instance partial-result behavior, live provider identity changes,
  native readers and broader source coverage remain open. Goal remains active.

## Pass 191: Single-Request Provider Binding Queries

- Read-only backend review confirms all 14 binding endpoints return all readable
  bindings when the instance filter is omitted. Synology applies its optional
  filter in the API layer; the other providers apply it in their core layer.
  The earlier cross-instance partial-result concern in passes 189/190 is
  superseded for these aggregate methods by this contract verification.
- Each aggregate query now makes one request, replacing discovery plus default
  and named-instance requests (N+2 requests for N distinct named instances).
  This removes the directory failure dependency and redundant deduplication.
- All 42 new regression cases fail before the fix and pass afterward. They
  cover 14 providers with populated, empty and failed binding responses,
  authentication, cross-instance records and exactly one unfiltered request.
  Two HTTP facade fixtures now follow the actual backend contract and assert
  that discovery is not called. Full 2101 tests pass, alongside analysis,
  architecture/UI guards and production/preview release Web builds.
- The transport=api preview uses the real domain service/API client with mocked
  HTTP responses. Edge English 3x desktop shows local and remote same-host
  accounts with reachable actions. Mobile 320x568 verifies the remote account
  confirmation, full identity scrolling and cancellation. This does not verify
  live backend transport or account mutations in this fixture mode.
- Source coverage remains partial. Other provider service methods, live
  integrations, native readers and broad unreviewed modules remain open.
  Goal remains active.

## Pass 192: Media Source Account Selection

- The shared provider account selector used a string sentinel for the default
  source and accepted a removed account from an already-open menu. Both defects
  are reproduced. It now uses AppSelect with a nullable default, current-option
  validation, wrapping labels and content. Duplicate labels and labels matching
  generated disambiguation text retain distinct account identities.
- Browser inspection found that hidden long options inflated the collapsed
  select height. AppSelect adds opt-in selected-only height, enabled by the
  account selector; existing stable-height callers preserve their behavior.
  Two additional 1x/3x regressions reproduce this and verify selection resizing.
- Twelve new tests cover default-ID collisions, duplicate/fallback labels,
  removal/disable/replacement during open menus, external selection changes,
  en/zh 3x mobile/short-desktop layouts and collapsed sizing. The four reproduced
  failures now pass. Full 2113 tests, analysis, architecture/UI guards and both
  release Web builds pass. The existing direct binding-entry test also passes.
- Edge English 3x desktop verifies keyboard selection of the remote same-label
  account and one change. Mobile 320x568 verifies full identity scrolling and
  switching to default with two total changes and reduced field height. These
  are standalone UI fixtures without provider requests or credential mutations.
- Extreme-text popup reopening did not automatically reveal the selected remote
  item; initial menu scroll positioning remains a follow-up. Complete provider
  parent layouts, dark/native behavior and live integration remain unverified.
  Other media-library sources were scanned, not fully reviewed. Goal stays active.

## Pass 193: Current Account Menu Positioning

- Flutter's native dropdown estimates initial scrolling with fixed item heights
  before multiline options are laid out. Four regressions reproduce the missing
  current item with 4/40 preceding options on mobile and short desktop. A reveal
  callback alone cannot reach options that the lazy list has not created.
- AppSelect offers an opt-in MenuAnchor mode, now used by provider account
  selection. Its eager layout enables a single post-frame reveal after actual
  measurement. Native dropdown callers retain their existing implementation.
  Anchored fields naturally size to the selected label, so the pass-192
  selected-height switch is removed after its only production caller migrates.
- The new mode reuses current form state and option validation. Existing account
  tests preserve removal/disable guards, current-object resolution and identity
  collision handling. Seven new core tests cover multiline positioning, manual
  scrolling, reopening, keyboard selection, Escape focus return, disposal and
  selected semantics independent of focus. Checkmarks distinguish selection
  from hover. Full 2120 tests, clean analysis, architecture/UI guards and release
  production/preview builds pass; the final nondeprecated semantics assertions
  also pass in a focused rerun.
- Edge English 3x desktop selects the remote same-name account by keyboard.
  At 320x568, reopening reveals that current account with its full suffix and
  checkmark, and focus is on it. Escape restores trigger focus and retains one
  change. This resolves pass 192's positioning issue for the account selector.
- Other native dropdowns still use estimated offsets and require separate
  evaluation. Eager-menu stress/performance, all provider parent layouts,
  dark/native readers and live provider integration remain unverified.
  Goal remains active.

## Pass 194: Discovery Row Command Validity

- Switching away from media selection hid checkboxes but left row taps active,
  allowing invisible changes to the selected collection. Read-only previews had
  the same problem. Row selection now uses the same mode/callback predicate as
  checkbox presentation, and validates that predicate again when invoked.
- Selection and container opening require their exact row object in the current
  list, a mounted/nonloading widget and the current route. Removed/replaced rows,
  loading states, covered routes and disposed widgets reject stale callbacks.
  Directory opening remains available independently of media selection.
- Eleven regressions reproduce failures before the fix. Fourteen final tests
  include covered-route and stale mode transitions, plus current replacement-row
  recovery. Existing cross-directory selected items remain covered. Full 2134
  tests, static analysis, architecture/UI guards and both release Web builds pass.
- Edge English 3x desktop selects Folder, disables media selection, clicks the
  read-only row and opens the folder: Selected remains 1 while Opened becomes 1.
  Mobile 320x568 clicks Movie while selection is disabled, then restores mode;
  only Folder remains selected and normal Movie selection becomes available.
  This is a simulated UI fixture, without live provider navigation or mutation.
- Pagination, bulk toolbar command lifecycle, full scope/controller replacement,
  complex item layouts and live provider behavior remain outside this review.
  YouTube preview was read but remains unreviewed in the ledger. Goal stays active.

## Pass 195: Cursor Pagination Request Ownership

- Scroll notifications and the footer could start duplicate cursor requests
  before a parent rebuilt with loading enabled. Both now share a locally guarded
  awaited operation, with synchronous pending state and finally-based release.
- The footer displays pending progress. Nested scroll notifications are ignored;
  invocation checks the current route, loading, remaining pages, pagination mode
  and callback availability. Callback errors retain their original propagation.
- Six regressions reproduce failures before the fix; ten final cases cover
  concurrency, nested scrolling, retry, disposal and stale command states.
  Full 2144 tests, analysis, architecture/UI guards and production/preview
  release Web builds pass.
- Edge English 3x checks the desktop initial layout and mobile 320x568 behavior.
  Clicking Load more and scrolling repeatedly keeps Requests at 1, displays a
  named Loading indicator, then appends exactly one row and removes the exhausted
  footer. The fixture uses a simulated 30-second operation without provider calls.
- Explicit page navigation, bulk toolbar lifecycle, source changes during pending
  operations and live provider integration remain unverified. Goal stays active.

## Pass 196: Discovery Bulk Command Validity

- Read-only media previews exposed select-all and clear controls, and retained
  toolbar callbacks could mutate selection or submit after loading, mode changes,
  route coverage or disposal. Both toolbar layouts now share guarded commands;
  read-only previews hide the toolbar. Target switching also checks current state.
- Selected-media and current-list submission share synchronous pending state.
  Repeated invocations are ignored until completion; progress is displayed and
  row/selection commands are disabled. Submission uses a selection snapshot,
  preserves errors and releases pending state after success or failure without
  setState after disposal. Selection notifications follow the local state change.
- Pre-fix tests reproduce the read-only toolbar, stale commands and duplicate
  submission. Twenty-four final new cases cover those paths, failure/retry,
  pending selection guards, recovery and disposal. All 55 related tests and all
  2168 tests pass. Analysis, architecture/UI guards and production/preview release
  Web builds also pass.
- Edge English 3x desktop verifies selecting both rows and one pending addition.
  Mobile 320x568 verifies disabled pending controls, completion recovery, hiding
  the read-only toolbar, preserved selection after a read-only row click, and
  restored clear with empty-selection commands disabled. Screenshots show no
  overlap in these states. The 30-second fixture performs no backend writes.
- Explicit page callbacks, source/controller changes during pending operations,
  current-list large-text layouts, complete provider forms and live integrations
  remain outside this pass. Goal stays active.

## Pass 197: Current-List Toolbar Width

- The playlist footer laid out an unconstrained action beside an expanded name
  field. Three 3x mobile cases reproduce right overflow: English without/with the
  field by 386/394 pixels and Chinese with the field by 25 pixels. Wider layouts
  also restricted the input to the space remaining beside the button.
- The optional name field now sits above the action at full width. A directional
  start alignment constrains the button so its label can wrap within the panel.
  Existing callback, pending-state and input ownership behavior is preserved.
- Eight new en/zh 3x tests cover 320x568 mobile and 1200x400 short desktop with
  and without the field, including editing and submission. Full 2176 tests,
  clean analysis, architecture/UI guards and production/preview release builds
  pass.
- Edge English 3x short desktop/mobile verifies the full-width field and wrapped
  mobile button; submission shows Added: Cinema. Chinese mobile verifies full
  labels and clearing the field. Screenshots show no overlap in these states.
  These are local fixtures without backend writes.
- The Bilibili call site is the only current playlistActionLeading consumer.
  Its complete parent workspace, software-keyboard height, arbitrary leading
  widgets and live creation remain unverified. Page callback guards and source
  transition behavior remain open. Goal stays active.

## Pass 198: Explicit Page Command Validity

- Previous/next buttons directly forwarded parent callbacks. Retained callbacks
  could navigate during loading or submission, after page/scope/mode changes,
  under a covering route or after disposal. Invocation now checks current state
  and the originating page/scope before resolving the current callback.
- Buttons independently disable at first/last boundaries and during busy states,
  even when a parent still supplies both callbacks. Public callback signatures
  are unchanged; asynchronous request ownership remains in provider forms.
- Eighteen new tests fail before the fix and pass afterward, including submission
  recovery and current button boundary states. All 2194 tests, analysis,
  architecture/UI guards and production/preview release Web builds pass.
- Edge English 3x desktop reaches page 3 with Next disabled. Mobile 320x568
  verifies both directions disabled during loading on page 2, recovery after
  loading, and reaching page 1 with Previous disabled and Requests: 3.
  Screenshots show no overlap. The fixture has no network calls.
- Empty-result rendering bypasses the page bar and requires a recovery review.
  Complete provider source transitions, async request races and live integrations
  remain open. YouTube preview was read: repeated map entry traversal, retained
  callbacks and its selection toolbar still need review. Goal stays active.

## Pass 199: Empty Page Recovery

- Empty results bypassed the explicit pagination layout, hiding both navigation
  directions and preventing return from an empty last page. Page mode now keeps
  its pagination layout for empty/loading results and reuses a shared empty
  content builder with cursor mode.
- Compact page layouts scroll empty content and navigation together; taller
  layouts keep navigation below the flexible content. Existing command validity
  and loading guards apply to both populated and empty pages.
- Eight new tests fail before the fix and pass afterward, including en/zh 3x
  at 320x568, 320x160 and 1200x400, real taps returning to populated page 1,
  and empty-page next/loading states. All 15 related tests and all 2202 tests
  pass, along with analysis, architecture/UI guards and both release Web builds.
- Edge English 3x short desktop returns from empty page 2 to populated page 1.
  Mobile 320x568 shows the empty page and retained navigation, disables both
  directions during loading, then reaches populated page 3 with Requests: 3.
  Screenshots show no overlap. The fixture performs no provider network calls.
- This resolves pass 198's shared-component empty-page recovery gap. Parent
  replacement of the browser with a loading widget, source transitions, async
  races, full provider layouts and live responses remain separate review areas.
  Goal stays active.

## Pass 200: YouTube Preview Commands And Rendering

- Row building repeatedly traversed map entries with elementAt(index). A single
  fixed-length entry list per build now supplies constant-time row indexing.
  Source filtering and map ordering are preserved; no frame-time benchmark was
  collected, so this is an algorithmic improvement rather than measured FPS.
- Row taps and checkboxes share current-object validation. Selection commands
  reject loading, disabled selection, covering routes and disposal; submission
  resolves current data/callbacks, and load-more checks current availability and
  exhaustion. Parent asynchronous request ownership remains unchanged.
- The toolbar wraps and presents grouped named icon controls below 480px.
  This removes the reproduced English 3x overflow and keeps the two compact
  actions together while retaining the complete selection count.
- Twenty-four of 25 new cases fail before the fix. All 25 new cases pass.
  Full 2227 tests pass before the final icon-group layout adjustment; the final
  31 related tests, clean analysis, architecture/UI guards and release production
  and preview builds pass afterward.
- Edge English 3x desktop exercises deselection. Final mobile 320x568 verifies
  grouped icons, scrolling the second film fully into view, deselecting it,
  submitting one item (Added: 1), and hiding selection controls in read-only mode.
  These are local fixtures without live provider calls or thumbnail assets.
- Source-scope replacement, fallback identity/dedup edge cases, asynchronous
  submission/load exclusivity, empty/loading feedback, thumbnail stress, complete
  provider forms and live YouTube integration remain unverified. Goal stays active.

## Pass 201: YouTube Preview Request Ownership

- Separate preview and submission pending state. Preview epochs and captured
  identity reject obsolete success/error after account or destination changes;
  an old completion cannot unlock a newer request. Duplicate submission entry
  is guarded synchronously, including before a rebuild.
- Sixteen new regressions and four existing form tests pass. Ten of the initial
  twelve cases reproduced failures before the fix. Full 2243 tests, analysis,
  architecture/UI guards and release builds pass.
- Edge English 3x desktop verifies overlapping account/default requests; finishing
  request 1 leaves request 2 busy, and finishing request 2 displays only its result.
  Mobile 320x568 scrolls the full form to Preview 2 (default).
- Submission completion may still clear a newer destination draft. Bulk adds
  still read destination properties between iterations. Source/session changes,
  pagination races and live integration remain open. Goal stays active.

## Pass 202: Adaptive Provider Target Controls

- The full form browser check exposed severe English 3x target-label fragmentation.
  The shared selector now measures words with current text scaling and switches
  to vertical segments when horizontal words cannot fit. Label width constraints
  also address Flutter vertical intrinsic sizing outside the hit-test bounds.
- Natural word wrapping retains horizontal two-option controls when space permits.
  This resolves a discovered 17px Bilibili dialog overflow from the initial overly
  aggressive vertical threshold.
- Eight en/zh narrow/wide 1x/3x layout cases cover selection and disabling; all 18
  combined selector and complete add-dialog preparation tests pass.
- Final full 2251 tests, clean analysis, architecture/UI guards, production and
  preview release builds, inventory freshness and whitespace checks pass.
- Edge English 3x mobile verifies complete target labels and switching to Dynamic
  playlist; desktop verifies full labels in the narrow form sidebar.
- Other provider compositions, custom theme styles, extreme widths, dark/native
  states and retained selector callbacks remain unverified. Long input labels in
  the complete YouTube form still truncate and need a separate form-label review.

## Pass 203: YouTube Submission Scope

- Submission completion now requires the original preview epoch, request identity
  and draft name. Room/playlist changes, including switching away and back, cannot
  let an old completion clear the current draft. Success cleanup is shared; stale
  failures and covered-route notifications are suppressed.
- Bulk additions snapshot names, source messages, room, playlist and gateway before
  the first await. Accepted batches finish against their original target even if
  the form changes or is disposed. A new target cannot receive later batch items.
- Ten valid pre-fix single/list cases reproduced stale-completion failures. Initial
  bulk harness failures were setup errors and are excluded from regression evidence.
  Nineteen final new tests and 20 related tests pass. Coverage includes current
  success, obsolete failure, destination round-trips, name changes, gateway
  replacement, mutated remaining item names and disposal completion.
- Full 2270 tests, clean analysis, architecture/UI guards and production build pass.
  The preview release build passes; the later source change only adds lint braces.
- Edge English 3x desktop starts a controlled submission, switches room, completes
  the old request and verifies retained URL/name, restored Preview and disabled Add
  until another preview. Mobile 320x568 scrolls to the retained Keep draft field.
  The fixture simulates requests and does not perform real backend writes.
- Partial-batch failure/retry deduplication, service-internal session changes,
  source freshness, long field labels and live provider integration remain open.
  Goal stays active.

## Pass 204: YouTube Partial Batch Recovery

- A failure after an acknowledged addition kept every item selected and retry
  resubmitted successful items. The parent now records confirmed objects in the
  current preview. Retained callbacks require current, not-yet-added objects;
  duplicate references within one batch are also skipped.
- The preview excludes added objects using original indices, preserving fallback
  keys and deselected later items. Failed items remain selected. Invalidation
  clears progress; appending a page preserves current progress.
- All six new regressions fail before and pass after. Seventy related tests,
  full 2276 tests, clean analysis, architecture/UI guards and production/preview
  release builds pass.
- The bulk=true fixture simulates two writes and a one-time failure on Second.
  Edge English 3x desktop observes Added: 1, the error and Selected 1 / 1.
  Mobile 320x568 shows only Second, retries it and ends with Added: 2.
- Lost responses after server writes require backend idempotency. Fresh previews,
  duplicate pages and cross-session progress remain outside this guarantee.
- Browser verification exposes a stable blank scrolled result area after mobile
  success. Workspace scrolling/result removal needs the next layout recovery
  review. No live backend/provider writes are performed. Goal stays active.

## Pass 205: Empty Workspace Recovery

- Empty widget results left a viewport of blank space and retained a collapsed
  form header after mobile submission. ProviderWorkspace now takes a nullable
  result and removes the separate hasResults flag. No-result layouts contain only
  scrollable controls, preserving desktop control width without a divider.
- YouTube, Twitch, TikTok, Douyin, AcFun, CCTV, Douyu, Huya and Bilibili callers
  express absent results with null. Existing real empty/loading browser widgets
  in other file providers retain their current result layouts.
- Eight YouTube 1x/3x success/destination-invalidation cases return to the form top.
  Initial test setup errors in destination updates were corrected and do not count
  as reproduced product failures. Sixteen initial cases exercise eight providers
  at 320/1200px; three existing workspace cases cover present-result layouts.
- These tests exposed 48px action-row overflow in AcFun/CCTV/Douyu/Huya and a
  YouTube 3x dropdown overflow. Actions now wrap; the mode dropdown is expanded.
  All 27 layout cases and final clean analysis pass.
- Final full 2300 tests, architecture/UI guards, production release build,
  inventory freshness and whitespace checks pass. The YouTube preview build
  includes the final workspace/YouTube changes; later edits only wrap buttons in
  the four other live-provider forms.
- Edge English 3x desktop verifies no-result controls without the divider. Mobile
  320x568 scrolls to a resolved preview, completes a simulated direct submission
  and immediately shows the form top. This resolves pass 204's observed blank
  result-screen recovery for the shared transition exercised here.
- Full provider-specific transitions, software keyboard/focus restoration,
  enlarged-text instance selectors, long labels, dark/native layouts and live
  provider integration remain unverified. Goal stays active.

## Pass 206: Shared Live Instance Selection

- AcFun/CCTV/Douyu/Huya duplicated native instance dropdowns with inconsistent
  labels and long-name intrinsic overflow. A small ProviderInstanceSelector
  adapter reuses the guarded account selector's identity handling, wrapping
  labels and anchored menus, with instance-specific text and icon overrides.
- Empty/default, duplicate and default-named instances remain distinct. Removed
  or disabled open-menu choices are rejected; external fallback emits no command.
  Parent callbacks also guard loading, disposal and covered routes.
- All 16 en/zh 3x parent long-name layout regressions fail before and pass after.
  Eight adapter cases plus existing account/provider tests give 44 focused passes.
  Full 2324 tests, clean analysis, architecture/UI guards and release builds pass.
- Edge English 3x desktop verifies Default versus Default (Default), then selects
  a long remote name. Mobile scrolls its full text, reopens to the marked current
  item, selects it again (Changes: 2), and removes it. Default returns without
  another change. The browser fixture uses local selector state without requests.
- Re-selecting a current item still emits a change and may invalidate its parent
  preview. Stale preview responses, build-time instance removal, software keyboard,
  dark/native states and live integrations remain open. Goal stays active.

## Pass 207: Live Form Operation Ownership

- AcFun/CCTV/Douyu/Huya now use AsyncStateEpoch for preview and submission
  ownership. Room/playlist changes and selected-instance removal invalidate
  obsolete work in didUpdateWidget; build no longer mutates instance selection.
- Preview/add entry guards prevent duplicate invocation before a rebuild.
  Re-selecting the same instance preserves its preview. Removed-instance results
  cannot be submitted under the fallback instance. Old success/error cannot
  replace current results or release a newer operation's loading state.
- Submission completion checks operation ownership and captured draft values
  before clearing fields. Obsolete failures and covered-route notifications are
  suppressed. Already dispatched backend writes still target their original room.
- All 24 new cross-provider regression cases fail before and pass after; 324
  related tests and full 2348 tests pass. Analysis, architecture/UI guards and
  production/fixture release Web builds pass.
- Edge desktop 1200x900 starts a preview, changes room, starts another, completes
  the old request and verifies the newer request remains busy without old results.
  Completing the current request shows Preview 2. Same-instance selection retains
  it. Mobile 320x568 verifies readable controls/results, submits, changes room and
  completes the old submission: resource 660000 remains. A remote-instance preview
  is then resolved and its instance removed: default returns, preview disappears,
  add is disabled and the draft remains. Screenshots and accessibility state were
  inspected through Browser Use using tool/live_form_showcase.dart.
- Browser evidence uses the actual Huya form with controlled callbacks, not live
  provider traffic. The other three providers have automated coverage here.
  Service/session replacement, dark/native states, software keyboard, loading
  indicator placement and full metadata localization remain open. Goal stays active.

## Pass 208: Reactive Live Gateway and Accurate Progress

- DependencyScope and DependencyRegistryScope expose nullable reactive maybeOf.
  Typed overrides retain precedence; missing optional dependencies remain valid.
  Five new tests verify absent scopes, typed/registry replacement, registry entry
  insertion/removal and typed-override isolation from registry updates.
- Four live forms subscribe to ProviderGateway changes in didChangeDependencies.
  Replacing the gateway invalidates previews and pending operation ownership.
  Same-object gateway and unrelated registry changes preserve existing previews.
  The existing request guards suppress obsolete success/error and draft clearing.
- Preview and adding flags now identify the active command; preview progress no
  longer appears on the Add media button. Both operations still block duplicates.
- Before changes, 24 gateway replacement cases and four progress-location cases
  fail; eight unchanged-gateway controls pass. Final 36 form cases and five new
  dependency tests pass. Initial edit compilation and toast timer teardown failures
  were corrected and are excluded from product-regression evidence.
- All 368 related and full 2389 tests pass, with clean analysis, architecture/UI
  guards and release production/fixture builds.
- Edge desktop 1200x900 runs the actual Huya form through controlled gateway
  implementations. It starts a preview, replaces the service, starts another and
  completes the old one: Loading Preview remains until the current response.
  The current preview submits with Loading Add media. Replacing the service before
  completion preserves the resource draft and removes the obsolete preview.
- Edge mobile 320x568 at 3x text scrolls the active preview and add buttons, inspects
  screenshots/accessibility labels, completes submission and restores the empty
  editable form. Buttons fit the width. Large input labels remain truncated, and
  fixture switches consume substantial vertical space; those are not claims of
  complete enlarged-text usability.
- Same-gateway internal session changes, live provider traffic, dark/native layouts
  and software keyboard behavior remain open. Goal stays active.

## Pass 209: Complete Live Form Labels

- The prior browser pass exposed truncated resource labels at 3x. AcFun, CCTV,
  Douyu and Huya now reuse AppTextField.labelAbove for both resource and name.
  Existing wrapping text and single semantic field label provide the solution;
  the shared text control behavior and other forms are unchanged.
- Sixteen en/zh cases at 320/1200px and 3x assert external label layout, complete
  paragraphs, one accessible field name and editable input enabling Preview.
  Baseline tests reject the previous single-line label contract. Initial semantics
  handle teardown failures were test cleanup issues, corrected before final checks.
- Full 2405 tests pass. Analysis, architecture/UI guards and production/fixture
  release builds pass.
- Edge Huya 3x desktop 1200x900 and mobile 320x568 screenshots show the complete
  resource label wrapping across lines above the field. Name also stays visible.
  Mobile enters resource 660000 and Keep name, scrolls to Preview, completes a
  controlled resolve and scrolls to Preview 1 and Add media. No horizontal overlap
  is observed. Additional vertical space remains reachable through existing scroll.
- Browser verification uses the Huya fixture; the other three forms have automated
  layout evidence. Other form labels, dark/native layouts, software keyboards and
  real provider traffic remain open. Goal stays active.

## Pass 210: Localized Complete Live Preview Content

- AcFun/CCTV/Douyu/Huya single-result previews no longer truncate title/detail
  paragraphs to two or three lines. Complete content wraps in the existing result
  scroll view. Huya filters empty format names before joining.
- Existing translations now cover qualities, chapters, viewers, live/video/offline
  states and danmaku. Added en/zh entries cover replay, live danmaku, CDN routes,
  media streams, HLS audio/video and protected media. Generated localization output
  was refreshed through Flutter gen-l10n.
- Sixteen en/zh 3x long-content cases at 320/1200px verify paragraphs do not exceed
  line caps and Chinese metadata uses translated labels. After correcting mobile
  test setup to scroll to the result, all 16 fail before and pass after the fix.
  The initial offscreen finder failure is not counted as a product defect.
- All 392 related and full 2421 tests pass, with clean analysis, architecture/UI
  guards and release production/fixture builds.
- Edge Chinese 3x desktop 1200x900 resolves the actual Huya form through local
  callbacks and shows a complete long title plus translated live/quality/CDN
  details. Mobile 320x568 scrolls from the title start through its end and the
  final CDN line without ellipsis. Screenshots and accessibility state inspected.
  The fixture's large fixed switches reduce the result viewport; native keyboard
  behavior and real provider traffic were not exercised.
- Missing metadata/source combinations, thumbnail-and-text layouts, other provider
  previews, dark/native states and full live integration remain open. Goal active.

## Pass 211: Responsive Shared Preview and Metadata Fallback

- AcFun, CCTV, Douyu and Huya share ProviderSourcePreview. Desktop keeps the image
  beside text; narrow widths and enlarged text place it above full-width title and
  details. Paragraphs remain uncapped and the existing image fallback is reused.
- Missing metadata still shows the trimmed resource. Blank metadata titles use the
  same fallback, including default submission names. Absent metadata contributes
  no fabricated status or counts.
- Eight parent missing/blank-title regressions fail before and pass after the fix;
  eight component tests cover image/no-image layouts, 320/900px at 1x/3x and image
  failure. All 408 related and 2437 full tests pass. Analysis, architecture/UI
  guards and release production/fixture builds pass.
- Edge desktop 1200x900 and mobile 320x568 screenshots inspect a loaded local
  application-icon bitmap: horizontal desktop layout and stacked mobile layout
  with complete scrollable title/details. This is fixture media, not a provider
  thumbnail. A separate missing-metadata browser flow previews resource 660000,
  submits it, shows success and restores the empty editable form.
- Real provider traffic/images, same-object session changes, native/dark states,
  software keyboards and full protobuf source validation remain open. Browser
  inspection also identified English count singular/plural wording for follow-up.
  Coverage remains partial and the goal stays active.

## Pass 212: Source Readiness Matches the Submission Contract

- AcFun/CCTV/Douyu/Huya enabled Add for any present source message, including
  empty configs that the common submission layer rejects. They now require a
  media provider config in both button readiness and the submit command guard.
  Wrong-type playlist responses stay unsubmitable in these single-media forms.
- DiscoveredSourceAccess exposes hasMediaSource/hasPlaylistSource and reuses them
  in requireMedia/requirePlaylist. Existing deep-copy and rejection behavior stays
  intact. This checks structure, not every nested provider field or playability.
  Backend common.proto/source_config.proto and all four provider resolvers were
  inspected: the resolvers produce discovered media configs.
- Twenty-four form cases cover absent sources, empty wrappers, empty media and
  playlist configs, configured playlists and valid media. Sixteen reject the old
  behavior before the fix; all 24 pass afterward. A new contract case checks both
  source kinds, rejection consistency and returned-copy isolation. All 29 focused
  and 2462 full tests pass; analysis, architecture/UI guards and release builds pass.
- The browser fixture now uses an actual Huya live source config by default.
  invalid=true intentionally returns an empty media config. Edge desktop 1200x900
  and mobile 320x568 screenshots show its visible preview, editable inputs and
  disabled Add. A mobile missing-metadata flow through controlled gateways uses a
  configured source, enables Add, submits successfully and resets the form.
- These are local controlled responses, not live provider playback. Other forms'
  source readiness, nested config validation, same-object sessions, dark/native
  states, localization plurals and wider audit coverage remain open. Goal active.

## Pass 213: Consistent Integer Count Localization

- Browser-visible "1 qualities" and "1 CDNs" exposed a broader translation gap.
  Twenty-five English messages now use ICU singular/plural branches: provider
  formats/subtitles/variants/qualities/chapters/views/viewers/CDNs/streams, player
  ranges/peers, bytes, event retention/filter counts, room presence/member summaries,
  authentication factors, OAuth providers and configurable character limits.
  Dynamic media keeps its zero-state label and adds the one-byte branch.
- Multiple-count summaries pluralize each independent value. All 25 changes retain
  their placeholder names/types and numeric values; Chinese resources are unchanged.
  Flutter gen-l10n regenerated derived output. Source comparison confirms exactly
  25 message changes with no placeholder metadata changes.
- Five new localization cases cover counts 0/1/2, mixed independent counts and
  Chinese media counts. The two singular/mixed cases fail before and pass after.
  Four outdated text assertions in three provider tests now expect singular words.
  All nine localization tests and full 2467 tests pass. Analysis, architecture/UI
  guards and release production/fixture builds pass.
- Edge desktop 1200x900 at 3x shows the actual Huya preview with "1 quality" and
  "1 CDN". Mobile 320x568 at 3x scrolls through the complete wrapping detail text.
  Screenshots and accessibility text were inspected. Responses use the existing
  controlled fixture; other summary placements have automated localization
  evidence, not fresh page-by-page browser evidence.
- Localization resources remain separate from the handwritten-source inventory.
  English resource SHA-256 for this pass:
  6e1a532004fa8404040a4801b767ec1223f45dc800297a95b836cf39614504ba.
  String-formatted seconds, broader translation quality, native/dark states and
  remaining page/component/performance audits remain open. Goal stays active.

## Pass 214: Refresh Resolvable Dependencies and Native Build Evidence

- Re-ran pub outdated and reviewed published source/changelog differences.
  Upgraded flutter_webrtc 1.6.1 to 1.6.2 and transitive platform 3.1.6 to 3.2.0.
  The resolver confirms exactly two dependency changes. No experiment is enabled:
  WARP and zero playout delay retain native defaults.
- Checked the five remaining constraint owners, the passkeys_darwin published
  baseline and strict lockfile restoration. Findings and explicit follow-ups are
  recorded in [the dependency audit](frontend-dependencies.md). Hosted Dart
  resolution is current within existing constraints; other dependency ecosystems
  and unpublished fork changes remain separate work.
- Full 2467 tests, analysis and architecture/UI guards pass. Production Web and
  debug macOS builds pass with the upgraded dependency. macOS still reports
  CocoaPods fallback for two media-kit plugins; this is an open build migration.
- Edge production startup loads actual room covers and navigation at 1200x900.
  Selecting Music & Live returns one room from the backend. At 320x568, the dark
  responsive room layout and login dialog render correctly; screenshots and
  accessibility state inspected. Browser smoke coverage does not test native
  WebRTC changes or multi-device calls.
- Native runtime, other platform builds, performance measurements, remaining
  dependency ecosystems and the broad source/UI audit remain open. Goal active.

## Pass 215: Cache Storage Failure Does Not Break Online Resources

- The service worker opened CacheStorage before fetching navigation and static
  assets. A rejected open therefore failed online requests; a rejected read also
  broke the versioned-asset path. Cache open/read failures now degrade to network
  access, while a network failure still returns cached content when available.
  If both fail, the network error is preserved. Cache write failures remain
  non-fatal. Failed old-cache enumeration/deletion no longer prevents client claim.
- New Node worker tests cover three resource routes, open/read/write failures,
  cached offline fallback, simultaneous network/storage failures, successful cache
  population, API bypass and activation cleanup failure. Seven of the original
  19 cases fail before the fix. Final 22 worker tests plus two existing bootstrap
  tests pass, and CI now runs both suites.
- A dedicated browser fixture runs the actual worker and injects CacheStorage
  open/keys failures. A message probe confirms unavailable cache inside the
  controlling worker. Edge desktop 1200x900 and mobile 320x568 load ordinary and
  versioned resources with 200 Network OK, display the local bitmap and navigate
  successfully to a second page. Screenshots/accessibility state inspected.
  This tests injected storage errors, not a real exhausted browser quota.
- Architecture/UI guards and release Web build pass. The built worker hash equals
  the reviewed source. Flutter code/dependencies are unchanged from pass 214's
  full 2467-test baseline; this pass adds Web-specific runtime verification.
- P2P stream lifetime, cache hangs, cache freshness policy, subpath deployments,
  private-mode browser differences and broader offline behavior remain open.
  Goal stays active.

## Pass 216: IndexedDB Retry and P2P Cache Queue Cleanup

- The browser P2P bridge retained a failed database-open promise for the rest of
  the session. It now forgets failed openings, closed connections and connections
  displaced by version changes. A blocked open that later succeeds closes its
  stale connection without replacing or clearing a newer one.
- Namespace queue cleanup now consumes its internal promise rejection while
  preserving the original operation rejection for callers. Previously, a caller
  could catch the operation error and still receive an unhandled rejection from
  the separate cleanup promise.
- Six lifecycle regressions fail before the fix, including observed unhandled
  rejections. They pass after the fix. Tests cover open error/blocked retry,
  late blocked success, version changes, unexpected closure and shared openings
  across namespaces. All 30 Web runtime tests pass and run together in CI.
- The browser fixture's new P2P route injects one synchronous open failure and
  then uses native IndexedDB with the production bridge. Edge desktop 1200x900
  retries and verifies five exact bytes after write/read. At mobile 320x568,
  deleting the database triggers versionchange release, then recreation and a
  second successful byte round trip. Unhandled rejection count stays zero.
  Screenshots and accessibility state inspected.
- Architecture/UI guards and release Web build pass; the built bridge matches
  the source hash. Flutter source/dependencies remain at pass 214's verified
  2467-test baseline. The browser fixture exercises storage, not media peers.
- Full transaction failure/abort behavior, cache-key encoding, blocked-upgrade
  real multi-tab behavior, quota/private-mode policy and peer transport remain
  separate audits. Goal active.

## Pass 217: P2P Cache Metadata Scans and Replacement Correctness

- Cache statistics and eviction previously cloned every stored media payload
  through index getAll. Schema v2 adds a compound namespace/access-time/size
  index while preserving existing records. Key cursors now read only metadata.
  This removes payload cloning; frame time and peak memory are not benchmarked.
- Replacing a key with content larger than the capacity now deletes the old
  value. Previously the skipped replacement left stale bytes available to reads.
- All 34 Node Web runtime tests pass, including four new migration and metadata
  cursor cases. The six native IndexedDB browser checks pass in Edge at desktop
  and narrow-screen sizes: preserved v1 bytes, no payload getAll, oversized
  replacement, namespace isolation, LRU capacity and exact TTL expiration.
  Screenshots and accessibility results inspected; the fixture uses a controlled
  clock and isolated data, with real browser storage and the production bridge.
- Architecture/UI guards and production release Web build pass; the built
  bridge hash equals source. No Dart source or dependency changes this pass;
  full Flutter coverage remains at pass 214's 2467-test baseline.
- Real multi-tab upgrade conflicts, quota failures, transaction aborts,
  large-cache index migration cost and peer traffic remain open. Goal active.

## Pass 218: Bounded Service Worker Startup

- The P2P bridge's five-second timeout previously started only after registration
  and activation readiness. Either earlier promise could remain pending forever,
  leaving the Web media engine's initialize call waiting indefinitely.
- One deadline now covers registration, activation and controller acquisition.
  Success/failure clears both timer and controller listener. Late completion
  after timeout cannot attach listeners or change the settled readiness result.
- Six startup tests cover all three pending phases, late completion, existing
  and delayed control, and registration rejection. Three regressions fail before
  the fix; all 40 Web runtime tests pass after it.
- Edge desktop/narrow-screen fixture injects pending register/ready promises.
  Both report unavailable after 5.0 seconds; normal already-controlled startup
  reports ready. Each reports zero remaining controller listeners and unhandled
  rejections. Screenshots/accessibility state inspected; real stalled network
  registration and end-to-end media playback were not simulated.
- Architecture/UI guards and production release build pass; source/built bridge
  hashes match. Dart/dependencies retain the pass 214 full 2467-test baseline.
  Late-worker retry, Dart engine initialization/disposal ownership, peer traffic
  and other storage failure scenarios still require review. Goal active.

## Pass 219: Web Engine Initialization and Callback Ownership

- The Web engine previously registered a global request callback before readiness,
  allowed repeated initialization, and unconditionally cleared the callback on
  failure/disposal. An old engine could therefore clear a newer engine's handler.
- Initialization now shares one future, waits for worker readiness before
  allocating its HTTP client/registering its callback, and rejects completion
  after disposal. Pre-ready media localization fails. Disposal asks the bridge
  to clear only the exact registered callback; the factory disposes failed
  instances before rethrowing initialization errors.
- Seven Chrome Dart tests cover concurrent initialization, pre-ready localization,
  disposal during initialization, old/new handler ownership, failed replacement,
  rejected readiness and missing bridge. They are explicitly included in CI.
  A direct JavaScript bridge test dispatches messages after stale and owner
  cleanup. All 41 Node Web tests and the full 2467 Flutter tests pass.
- Edge runs the same seven Dart checks in a release Flutter fixture using a
  controlled JS bridge. Desktop/narrow-screen runs pass, with rendered app icon,
  wrapping results and accessible button/status. Screenshots inspected.
  This is lifecycle evidence; it does not simulate media peers or room navigation.
- Analysis, architecture/UI guards and production/fixture release builds pass.
  Source/built bridge hashes match. Factory cleanup was source-inspected and
  compiled; a direct factory failure regression remains absent.
- Room-level asynchronous engine creation during exit, other engine transport
  and cancellation paths, late-worker retry and cross-tab behavior remain open.
  Goal active.

## Pass 220: Room Lifetime and Pending P2P Engine Ownership

- Room disposal previously captured only an already-created engine. A pending
  factory call could complete afterward and store an engine in the disposed
  room. Acquisition/ownership now lives in P2pMediaEngineOwner: closing admission
  is immediate, late/superseded results self-dispose, concurrent creation is
  shared, and current engines transfer to the existing serial disposal queue.
- Room exit clears the session reference and active resources. Queued preference,
  swarm-sync and static-resource operations check lifetime before acting and
  after relevant awaits. Preference updates stop after deactivation if disposal
  has started, leaving current-engine release to the queued exit cleanup.
- Eight owner tests cover closed acquisition, late/superseded results,
  concurrent creation, synchronous/asynchronous failure retry, ordered ownership
  transfer and late disposal errors. Full 2475 Flutter tests pass.
- The release lifecycle fixture reuses all eight owner checks and the previous
  seven Web engine checks. All 15 pass in Edge desktop and narrow-screen runs;
  scrolling, result wrapping, rendered icon and accessibility state inspected.
  These are module checks, not a complete RoomScreen navigation simulation.
- Analysis, architecture/UI guards, production/fixture release builds and
  whitespace checks pass. Production bridge/engine logic from pass 219 is
  unchanged; its 41 Node and seven Chrome test results remain the baseline.
- Full room exit/creation integration was source-inspected and compiled. A
  dedicated room navigation regression, current-engine disposal failure
  handling, other player lifetimes and actual peer traffic remain open.
  Goal active.

## Pass 221: Web Request Cancellation and Port Cleanup

- Delayed cache reads previously updated a disposed stats notifier. They now
  return no data after disposal; cache-write completions and integrity-report
  continuations also guard lifetime before updating stats.
- Worker requests now close their message port and clear its callback on
  completion, rejection or cancellation. Cleanup is idempotent. Retained engine
  callbacks after disposal close the incoming port without starting work.
  Response metadata, chunks, end and errors require an active request control;
  chunk sending checks again after awaiting backpressure credit.
- Cache follow-up and origin/peer admission check request cancellation. Origin
  helpers use the initialized client, preventing a disposed engine from
  recreating a client. Manifest and length continuations guard their lifetime.
- Seven new Chrome checks all failed before the fix: two reported disposed
  notifier access and five reported unclosed ports. Afterward all 14 Chrome
  checks pass, including assertions for no peer request or response after cache
  cancellation and complete meta/chunk/end delivery for a successful cache hit.
- The release fixture runs these seven plus the existing 15 lifecycle/ownership
  checks. All 22 pass in real Edge desktop and 320px narrow-screen runs. Icon,
  heading, button, long result wrapping and scrolling through the final item
  were visually inspected. The temporary preview server/tab were closed and
  viewport restored; the production endpoint remains available on port 8080.
- Full 2475 Flutter tests, analysis, architecture/UI guards, production/fixture
  release builds and whitespace checks pass. Evidence logs use `pass221-*`.
  This is controlled module validation. Actual peer traffic, streaming abort
  races, delayed cache-write/integrity-report regression scenarios, and complete
  room navigation remain open. Other modules retain their recorded partial or
  unreviewed scope. Goal active.

## Pass 222: Interruptible Pending Web Requests

- Closing a worker port did not finish its processing task when cache, peer or
  length lookup futures remained pending. Active request records survived until
  those operations eventually settled. Worker cache reads, peer requests and
  combined length waits now race cancellation. Length resolution cancels its
  child requests in a finally block, including when the parent wait is aborted.
- The shared wait helper keeps the original operation's error listener attached
  after cancellation. Late successes cannot update cache-hit statistics or
  continue response processing, and late failures remain handled. A test-only
  active-request count verifies cleanup before pending operations are resolved.
- Six cancellation regressions in `test/support/p2p_web_pending_request_checks.dart`
  all failed before with retained active requests. They pass after, exercising
  late success and failure for cache, peer and length lookups. Six active-request
  controls also verify successful response delivery and normal error reporting;
  cache/peer success checks inspect payload bytes and their statistics.
- All 26 Chrome checks and full 2475 Flutter tests pass. Analysis, architecture/UI
  guards, production/fixture release builds and whitespace checks pass. Logs use
  `pass222-*`. The release fixture runs 34 shared checks, all passing in real
  Edge desktop and 320px narrow-screen runs. Heading, icon, controls, long result
  wrapping and scrolling through the final result were visually inspected.
- JS cache and HTTP operations in the new fixture are controlled. Ending a wait
  does not guarantee that an underlying API has stopped all work; actual origin
  transport abort, pending cache-write/integrity-report behavior, complete room
  navigation and multi-device playback remain separate coverage requirements.
  Temporary browser/server resources were closed and the viewport restored.
  Production remains available on port 8080. Goal active.

## Pass 223: Agreement Consent and Low-Height Auth Surfaces

- AuthPanel previously ignored the agreement dialog's boolean result, so pressing
  Agree left consent unchecked. It now synchronizes explicit acceptance, preserves
  consent on dismissal and checks mounted after completion. Repeated protocol
  links share one open dialog. Dialog completion rejects repeated or covered-route
  callbacks so a stale action cannot pop another route.
- The agreement's fixed header/body/footer column overflowed at low height and
  large text. It now uses one scrollable document with theme typography/colors,
  visible scrollbar and wrapping actions. The read-to-end gate remains, including
  immediate acceptance availability for content that fits. Removed the nested
  decorative panel and redundant fixed sizing.
- The OAuth callback page retains centered content on desktop and now scrolls
  when its height exceeds the viewport. Before-fix checks reported 64-1344px
  overflows for en/zh at 2x/3x text, plus 471px for the agreement. Acceptance and
  duplicate-open checks also failed: seven reproduced failures in total.
- Ten added tests cover four callback locale/scale combinations, low-height
  agreement actions, accept/dismiss consent, duplicate opening, and two route
  completion cases. Full 2485 tests pass, along with analysis, architecture/UI
  guards, production/fixture release builds, whitespace and inventory checks.
  Evidence logs use `pass223-*`.
- Real Edge release checks exercised English desktop agreement reading and
  unchecked-to-checked consent, plus Chinese dark 3x text at 320px width and
  300px height. Scrolling exposes full bottom actions and acceptance updates the
  parent checkbox. The English callback page was inspected at normal desktop
  size and at 320x300/3x, scrolling through the final line without overflow.
- The auth fixture adds query-selected locale/theme/scale and callback preview.
  Its dispatcher is a no-op; external OAuth delivery/failure remains unverified.
  Dynamic agreement replacement, Markdown link behavior, actual system exit and
  other unreviewed authentication states remain open. Temporary tabs/server were
  closed and viewport restored. Production remains on port 8080. Goal active.

## Pass 224: Web OAuth Callback Session Isolation

- Web authorization completed its pending future on any same-origin callback
  message and only then checked state. A parallel session's callback could end
  the current login with a state error. Callback candidates now match redirect
  identity and exactly one matching state before completion, across messages,
  storage events and storage polling. Matching callback errors still reach the
  caller through the existing parser.
- Popup-close detection now runs even when storage contains an unrelated value;
  ignored data cannot mask user cancellation. Invalid or duplicate-state
  candidates leave the current session available for its valid callback.
- Eight of 11 Chrome cases fail before and all pass after. Checks include foreign
  state/path/origin, malformed callback, message origin, parallel sessions,
  matching errors, storage success, wrong-state storage events, duplicate states
  and cancellation with unrelated storage. Added a dedicated Web OAuth CI step.
- Full 2485 Flutter tests, analysis, architecture/UI guards and production/fixture
  release builds pass. Evidence logs use `pass224-*`. The shared 11 checks also
  pass in real Edge desktop and 320px narrow-screen runs, with screenshots of
  controls, icon, wrapping and scrolling through the final result.
- The fixture uses real browser events/storage and controlled popup handles.
  Actual popup restrictions and external OAuth providers remain unverified.
  Storage access/cleanup exceptions, timeouts and remaining callback transport
  lifetimes require further coverage. Temporary preview server/tab were closed
  and viewport restored; production remains on port 8080. Goal active.

## Pass 225: OAuth Storage Failures and Outcome Preservation

- Storage polling errors previously escaped the timer repeatedly while the
  authorization future stayed pending. Initial storage errors were raw browser
  exceptions, and final cleanup failures replaced valid authorization outcomes.
- Web sessions now probe callback-key writability before navigation and report
  OAuth2CallbackStorageUnavailable for setup or polling failures. A polling
  failure completes the pending future and follows normal listener/timer cleanup.
  Final deletion attempts each key independently and preserves the received
  success, rejection, cancellation or timeout result.
- Seven fault-injection cases all fail before and pass after, including setup
  deletion denial, write denial, polling failure, and cleanup failure for each
  outcome. The polling case checks that reads stop after completion; cleanup
  cases check that failure on one key does not skip the other key.
- All 18 Chrome checks and full 2485 Flutter tests pass. Analysis, architecture/UI
  guards and production/fixture release builds pass. Logs use `pass225-*`. Real
  Edge desktop and 320px narrow runs pass the shared 18 checks; icon, controls,
  long result wrapping and scrolling were visually inspected.
- Storage faults are injected into the fixture's temporary window property and
  restored afterward. Browser settings and user storage policies are unchanged.
  The small write probe cannot guarantee future quota or permission availability.
  Real callback dispatch, external providers and actual browser storage-policy
  changes remain unverified. Goal active.

## Pass 226: OAuth Callback Dispatch Recovery

- The callback page previously called its synchronous dispatcher from initState
  without catching failures while its presentation only described success.
  Dispatch failures now show localized error text and a retry action; raw errors
  containing callback credentials are never rendered.
- Retry remains available after repeated failure and disappears after success.
  Retained callbacks ignore successful, covered and disposed pages.
- Four added widget tests cover recovery, stale actions and English/Chinese
  320x300 layouts at 3x text. All 10 callback-page tests and 2489 full Flutter
  tests pass. Analysis, architecture and UI guards pass.
- Browser Use in real Edge verifies English desktop failure/recovery and dark
  Chinese 320x300/3x scrolling, final retry-button reachability and recovery.
  The release fixture injects a first dispatch failure; actual transport delivery,
  provider authorization and native browser storage policies remain unverified.
- Font coverage detected a newly required Chinese glyph. Regenerated the pinned
  font subset; all 784 localization codepoints are covered. Production and
  fixture release builds pass. Logs are under build/review/pass226-*.

## Pass 227: OAuth Delivery Outcome Preservation

- The Web dispatcher wrote its legacy compatibility key before the state-scoped
  key required by the current client. Legacy write failure therefore prevented
  current-session delivery. The state-scoped write now happens first, and the
  compatibility write is best effort after that succeeds. Required write failure
  still propagates and leaves the callback window available for retry.
- Closing a window after successful storage or opener delivery could also throw,
  making the callback page report failure after sending the result. Window close
  is now best effort after delivery; delivery errors remain observable.
- Seven new shared browser checks exercise those cases, no-state legacy behavior
  and opener payload/target-origin preservation. Three fail before the fix;
  all 25 combined OAuth Chrome checks pass after. Temporary window properties
  and history URL are restored in finally.
- Real Edge desktop and 320x568 release-fixture runs pass all 25 checks. Result
  wrapping, icon rendering and scrolling to the final row are inspected.
  Faults use controlled storage/window replacements. External OAuth providers,
  real popup policies, embedded parent delivery and receiver acknowledgement
  remain unverified.
- All 2489 Flutter tests, analysis, architecture/UI guards, production and fixture
  release builds pass. Validation logs are under build/review/pass227-*.

## Pass 228: Native Loopback Callback Session Matching

- Native loopback callbacks previously checked path before separately parsing
  success and authorization-error responses. Error responses used a single-value
  state lookup, and success parsing did not require the current redirect origin.
- Both paths now use the existing session matcher before interpreting callbacks.
  This requires exactly one matching state and the configured scheme, host, port
  and path. Success parsing also receives the expected redirect URI.
- Four real local HTTP tests cover duplicate-state and foreign-Host requests for
  both success and denial responses. All four fail before the fix and pass after:
  invalid requests receive 400, the pending authorization stays open, and a later
  matching callback completes with its expected code.
- All 24 service tests and 2493 full Flutter tests pass, along with analysis,
  architecture/UI guards and the production Web release build.
- Browser Use attempts against a temporary live native listener returned
  ERR_BLOCKED_BY_CLIENT. The first manual fixture also hit Flutter's default
  30-second test timeout; a longer-lived attempt confirmed the browser block.
  The temporary fixture was removed and its process stopped. Native landing-page
  browser rendering, external providers and physical device behavior remain open.
  Logs are under build/review/pass228-*.

## Pass 229: OAuth Callback Parameter Ambiguity

- Shared callback parsing previously used single-value query accessors, so
  repeated `code` or `state` parameters could be silently collapsed to one
  value. The parser now requires exactly one of each while retaining trimming
  and unrelated multi-value parameters.
- Four duplicate-parameter regressions fail before and pass after the change;
  the positive control passes on native and Chrome. Existing native loopback
  and Web session suites remain green.
- Full validation reaches 2498 Flutter tests, 30 Chrome callback checks,
  analysis, architecture/UI guards and the production Web build. URI
  canonicalization and external provider behavior remain outside this pass.

## Pass 230: Late Microphone Acquisition Cleanup

- Voice join timed out getUserMedia after 12 seconds, but Future.timeout does
  not cancel the permission request. A stream returned later had no owner to
  stop its tracks or dispose it.
- Extracted microphone acquisition with explicit ownership of late results.
  Timely success transfers the stream to the manager; timed-out results stop
  every track and dispose the stream. A track-stop failure does not skip the
  remaining cleanup, and cleanup failures are handled independently.
- Six controlled-stream tests cover success, original failure, timeout cleanup,
  failed track stop, late acquisition error and failed disposal. Three fail
  against the previous timeout-only behavior. All six pass on native and Chrome;
  the existing voice prerequisite test also passes.
- All 2504 Flutter tests, analysis, architecture/UI guards and the production
  Web build pass. Logs are under build/review/pass230-*.
- No physical microphone or Browser Use permission-prompt verification is
  claimed. Pending join versus leave/dispose, concurrent joins, peer negotiation
  ownership and never-settling cleanup remain open for subsequent work.

## Pass 231: Voice Join and Exit Ownership

- Pending joins now share one acquisition. Leave invalidates earlier joins
  synchronously, detaches owned resources and shares its cleanup operation.
  Subsequent joins wait for cleanup; disposed managers reject new joins.
- Each join checks its lifecycle after asynchronous boundaries. Late microphone
  success is released without signaling; a stale microphone error cannot leave
  a newer session. Synchronous rejection during join signaling cannot reconnect.
- Eight new manager tests cover pending ICE/microphone exit, duplicate joins,
  disposal, late success/error after rejoin, cleanup barriers and failure retry.
  All 15 voice tests pass on native and Chrome; all 2512 Flutter tests pass.
- Real Edge desktop fixture verifies join/leave/late acquisition gives no join
  signal and exactly one released stream. Narrow 320x568 normal rejoin/leave
  succeeds, sends join/leave and releases the second stream. Controls and counters
  fit. Controlled streams do not establish actual microphone or peer behavior.
- Analysis, architecture/UI guards and production/fixture Web builds pass.
  Audio-routing calls already in progress, peer-negotiation ownership, signaling
  callback exceptions and failures early in cleanup remain open.

## Pass 232: Voice Cleanup Failure Isolation

- Leaving previously stopped at a signaling exception, skipping microphone and
  peer cleanup. Cleanup now attempts every stage and reports the first failure
  afterwards. Failed joins preserve their original error when cleanup also fails.
- Three new regressions fail before and pass after, covering signal failure,
  later state-notification failure and original join-error preservation. All 18
  voice checks pass on native and Chrome; all 2515 Flutter tests pass.
- Real Edge 320x568 controlled-stream fixture verifies signaling failure leaves
  disconnected state, one stopped track and one disposed stream, with visible
  error and usable controls. Physical devices and peer-close fault injection
  remain unverified. Analysis, guards and release builds pass.

## Pass 233: Voice Signaling Input Boundaries

- The signaling entry now ignores inactive/disposed sessions and rejects
  non-string or blank sender IDs. Active valid messages preserve their routing,
  including synchronous responses during the outgoing join announcement.
- Offer tie breakers reject nonnumeric and nonfinite values before conversion,
  preventing malformed input from escaping as an unhandled async exception.
- Three new regressions fail before and pass after, with a fourth synchronous
  join-response control. All 2519 Flutter tests and 22 Chrome voice tests pass,
  along with analysis, architecture/UI guards and the production Web build.
- This pass adds browser-runtime tests, not new Browser Use visual evidence.
  Already-running peer negotiations and physical media behavior remain open.

## Pass 234: Voice Peer Creation Ownership

- Peer creation now carries a per-peer operation identity invalidated by local
  exit, peer leave and replacement. A late created connection closes instead of
  becoming active. Track attachment is awaited before negotiation proceeds.
- Offer/answer continuations, candidate flushing and retained connection events
  check current connection identity before changing state or signaling.
- Five new controlled-connection tests cover late creation after leave, peer
  leave and disposal, late offer completion with retained event callbacks, and
  out-of-order replacement. A current replacement still emits its normal offer.
  All 27 voice tests pass on native and Chrome; all 2524 Flutter tests pass.
- Analysis, guards, audit inventory and production Web build pass. This pass
  adds no Browser Use visual evidence. Actual media transport, track-attachment
  failure cleanup and answer-stage failure scenarios remain unverified.

## Pass 235: Voice Negotiation Failure Cleanup

- Track attachment, offer/answer generation and SDP-setting failures previously
  logged errors while leaving the peer registered. They now close the owned
  connection and remove its negotiation state. Identity checks prevent old
  failures from cleaning up a newer replacement.
- Six failure regressions fail before and pass after. A seventh control confirms
  a late old offer error preserves the replacement. All 34 voice tests pass on
  native and Chrome, and all 2531 Flutter tests pass.
- Analysis, guards, inventory checks and production Web build pass. No new
  Browser Use or real-call evidence is claimed. Underlying close failures,
  connected-peer removal notifications and actual media transport remain open.

## Pass 236: Voice Participant Removal Notifications

- Removing a connected peer changed internal participant state without notifying
  listeners, while retained close callbacks were correctly ignored as stale.
  Peer removal now notifies once after close completes or throws.
- Two regressions fail before and pass after for normal and failing close.
  Duplicate departure and retained closed events do not notify again. All 36
  voice tests pass on native and Chrome; all 2533 Flutter tests pass.
- Analysis, guards, inventory and production Web build pass. This pass adds no
  Browser Use room UI evidence. Never-settling close, notification exceptions,
  physical resource release after close failure and actual call behavior remain
  outside the verified scope.

## Pass 237: Immediate Voice Participant Updates

- Participant removal notification no longer waits for peer close to complete.
  A pending native close therefore cannot keep the visible participant count
  stale. Notification exceptions are captured so resource closure is attempted.
- If close and notification both fail, the close error remains the reported
  outcome; notification-only failure is still reported. Two regressions fail
  before and pass after, plus one notification-only control.
- All 39 voice checks pass on native and Chrome, and all 2536 Flutter tests pass.
  Analysis, guards, inventory and production Web build pass. No new Browser Use
  or physical-device evidence is claimed; actual native resource release and
  complete room integration remain open.

## Pass 238: Notification Text Contrast

- Standard success/error/warning and toggle feedback used white text on colors
  measuring 3.30, 4.23 and 2.37 contrast respectively. Success/error backgrounds
  now deepen; warning/disabled feedback uses black foreground. Custom explicit
  color contracts remain caller-owned.
- Five contrast tests fail before and pass at 4.5 or greater after. Added tests
  also dismiss their timers before teardown; the initial full run caught that
  test cleanup omission. Corrected notification tests pass all 37 cases, and
  the rerun full suite passes all 2541 tests.
- Real Edge desktop at 2x text confirms success rendering. At 320x568/2x the
  warning uses black text/icons, truncation exposes Details, and the full message
  and Close button fit in the dialog. Analysis, guards, inventory and release
  builds pass. Whole-app contrast and real assistive-device audits remain open.

## Pass 239: Styled Dialog Short Viewports

- The fixed styled-dialog header could consume almost the entire short viewport:
  at 320x240 with 3x text, Cancel remained unhittable after scrolling to it.
  Header, body and actions now share one scroll region; titles no longer truncate
  after two lines. The regression fails before and passes after, including dismissal.
- All seven dialog layout tests and the full 2542-test suite pass. Analysis,
  architecture/UI guards and production/fixture release builds pass.
- Real Edge 1200x900 and 320x240 screenshots at 3x text confirm title rendering
  and scrolling to a complete Cancel button; the button was clicked in both.
  Narrow title word breaks remain visibly excessive because header icons consume
  horizontal space. Adaptive header layout, caller-context lifetime and complete
  consumer/integration coverage remain open.

## Pass 240: Adaptive Styled Dialog Titles

- Narrow and enlarged-text styled headers now place icon/Close above the title,
  giving the title the full content width. Ordinary desktop headers stay inline.
  At 320px the title grows from 152px to 256px; Close is initially visible above
  even a long title. Words longer than the entire line still wrap naturally.
- Four en/zh 3x mobile/desktop cases verify title width, Close placement and
  dismissal. Initial desktop assertions measured the outer route surface;
  corrected assertions use the dialog scroll content. Mobile cases reproduced
  the original width loss. All 11 dialog layout tests and 2546 full tests pass.
- Edge 320x568/3x screenshots verify improved title width and scrolling to Cancel;
  cancellation returns to Open. At 1200x900/3x the title uses complete words and
  the top Close button returns to Open. Analysis, guards and release builds pass.
  Other shared headers, complete consumer coverage and caller-context lifetime
  remain outside this pass.

## Pass 241: Styled Dialog Close Lifetime

- Shared Cancel now uses its own route context instead of the caller's navigator.
  Close/Cancel require a mounted context and current route before popping. This
  prevents retained callbacks from dismissing the underlying page or a replacement
  dialog, and makes cancellation work when the caller uses a nested Navigator.
- Five lifecycle regressions fail before and pass after, including callbacks
  repeated during dismissal and after disposal. All 16 shared-dialog tests and
  2551 full tests pass. Analysis, architecture/UI guards and release builds pass.
- The release fixture now uses a nested caller. Real Edge 320x568/3x scrolls to
  Cancel and returns to Open; at 1200x900 the same page reopens the dialog and
  Close returns to Open. Both layouts were inspected in screenshots. Browser
  verification covers real cancellation; stale callback ordering uses widget tests.
  Caller-owned confirm/action callbacks and other dialog types remain open.

## Pass 242: Confirm Callback Lifetime

- Shared confirmation now checks its own mounted/current-route context before
  invoking caller code. A retained callback cannot start an operation after the
  dialog has been canceled, confirmed, replaced or disposed. Validation retries
  remain possible while the dialog stays current.
- Four stale-callback regressions fail before and pass after; a fifth verifies
  normal retry behavior. All 21 shared-dialog tests and 2556 full tests pass.
  Analysis, architecture/UI guards and production/fixture release builds pass.
- The nested-navigation fixture adds a dialog-scoped Confirm callback. Edge
  320x568 and 1200x900 at 3x show complete action labels; normal confirmation
  returns to Open at both sizes. Real server operations are outside this fixture.
  Already-running async work, duplicate requests while current and caller-owned
  navigation closures still need consumer-specific checks.

## Pass 243: User Creation Form Ownership

- Extracted creation from the user-list part into AddUserDialog, following the
  existing member-dialog pattern. The dialog owns and disposes controllers,
  validates required fields, rebuilds selected role/status, locks submission
  synchronously and disables inputs while saving. Cancel remains available.
  Only a current dialog accepts request completion; the parent refreshes once
  after an accepted success.
- Three old-flow regressions reproduce duplicate requests, late success closing
  a replacement and late error leaking a notification. They pass after the fix.
  Six total tests cover retry, selected values, input locking and en/zh mobile
  3x access. Initial test entry used the dialog title instead of toolbar Add and
  was corrected before the before/after run.
- Full suite passes 2562 tests. Analysis initially requested explicit mounted
  guards in the asynchronous error branch; after that equivalent guard addition,
  analysis and all six focused tests pass again. Architecture/UI guards and
  production/fixture release builds pass.
- Real Edge 1200x900/3x screenshot verifies the form; at 320x568/3x empty Create
  exposes readable required errors, scrolling reaches role/status, Administrator
  selection updates immediately, and Cancel returns to Add user. This uses a
  simulated gateway. Real user mutation, server validation rules, other user
  editing/batch operations and native devices remain incomplete.

## Pass 244: Preserve Failed Batch Selections

- Batch ban/delete now snapshot target IDs before confirmation, use the same
  snapshot for the displayed count and request, and remove only explicitly
  successful submitted IDs from selection. Failed users and newly selected
  users remain available for retry, including when a response reports success
  for an ID outside the submitted batch.
- Two controlled gateway regressions fail before and pass after the change.
  They verify request targets and selection after mixed results while another
  user is selected during the pending request. Confirmation-time selection
  mutation is not separately exercised.
- All 2564 tests, static analysis, architecture/UI guards and production/preview
  release builds pass.
- Real Edge at 1200x900 selects three users, confirms Ban and resolves a delayed
  partial result: only the failed user remains selected. Screenshots at 320x568
  verify wrapping batch actions and scrolling to the retained checkbox. This
  uses the real tab with a simulated gateway, whose list remains unchanged.
  Browser Delete and real backend mutation are not covered by this preview.
- Concurrent batch submission, controller disposal, stale refresh and remaining
  user management flows still require audit; this module remains partial.

## Pass 245: Batch Request Singleflight

- User batch commands now share a synchronous operation lock from confirmation
  through request and awaited list refresh. Both batch commands are disabled
  while an operation owns the lock; the pending command shows a loading icon.
  Cancel, error and completion release the lock. Saved callbacks invoked after
  the tab is disposed return before reading context.
- Four regressions fail on the previous implementation: repeated callbacks stack
  three dialogs and disposed callbacks access invalid context for both Ban and
  Delete. They pass after the change and cover cancel/error release, retry,
  both actions disabled, and late request errors after disposal. The initial
  fixture omitted the required user role and was corrected before these runs.
  The previous two selection recovery tests still pass with bounded pumping
  while the loading animation is active.
- All 2568 tests, static analysis, architecture/UI guards and production/preview
  release builds pass.
- Real Edge at 1200x900 confirms Delete for three simulated users. Screenshots
  at desktop and 320x568 show the loading Delete and disabled Ban. Resolving
  the request restores both commands and retains one failed selection; Ban
  then opens for one user and Cancel returns. No real accounts were modified.
- Single-user operations concurrent with a batch, covered-but-mounted route
  completion and batch reason controller lifetime still need review. Browser
  inspection also identifies the shared loading icon's theme-blue color on
  the red destructive button as a remaining contrast concern.

## Pass 246: Loading Button Colors And Semantics

- Action and icon progress now inherit the resolved text/icon foreground inside
  their Material button. Action progress uses the same 18px slot as its normal
  icon. Loading retains a named disabled button with localized Loading value;
  nested progress semantics no longer replace the button's role.
- Twenty light/dark variant checks reproduce the previous progress-color
  mismatch. The added destructive contrast check also revealed dark error/onError
  at 2.77:1; the dark theme now uses a dark onError foreground, passing 4.5:1
  for destructive action text and progress in both themes.
- Four en/zh semantic checks verify label, loading value, disabled button role,
  absence of tap semantics and blocked activation. Their first node lookup
  targeted the outer layout; it was corrected to the named semantic node.
  Semantics handles are disposed before test completion. Analysis migration to
  flagsCollection briefly misplaced an import; it was corrected and rerun.
- All 195 shared-control tests and the full 2592-test suite pass. After the
  test-only API cleanup, all 24 new tests and static analysis pass again.
  Architecture/UI guards and production/preview release builds pass.
- Real Edge screenshots at 1200x900 light/dark and 320x568 dark show production
  controls without overlapping content. All loading controls expose named
  disabled buttons with Loading. Turning off loading restores ordinary command
  names; mobile Delete increments the fixture counter from 0 to 1.
- This resolves the destructive loading-color concern recorded in Pass 245.
  Other disabled-state contrast, every semantic theme pair, custom theme
  overrides, extreme text and native reader announcements remain unverified.

## Pass 247: Semantic Theme Contrast

- Added luminance checks for 15 semantic text/background pairs in each theme,
  including primary/secondary/tertiary/error and their containers, surfaces,
  inverse surface, secondary text and scaffold body text. Dark errorContainer
  with onErrorContainer failed at 4.05:1. The corrected dark red container and
  pale foreground pass the 4.5:1 threshold alongside all other tested pairs.
- Traced an actual consumer: playback proxy direct-risk text and icon. Existing
  control tests plus theme tests pass (11 tests), and all 2594 tests pass.
  Analysis, architecture/UI guards and production/preview builds pass. A test
  brace lint was corrected; analysis and the two contrast tests rerun cleanly.
- Real Edge inspects the production control with a fixed policy at dark
  1200x900 and dark/light 320x568. Risk text remains complete. Mobile selection
  of Proxy only removes the risk notice; returning to Direct only restores it.
- This does not establish contrast for alpha-modified feature colors, all
  interactive states or custom surfaces. The proxy control's async policy
  lifetime, stale callbacks and extreme-text layout remain further audit work.

## Pass 248: Reject Stale Playback Mode Selections

- Dropdown and segmented selections now pass through the owning State, which
  checks mounted status, current enabled state, active policy identity and
  supported modes before invoking the latest parent callback. This prevents
  old menus/callbacks from submitting removed modes or changing disabled or
  disposed forms, and avoids calling a replaced parent callback.
- Eight regressions fail before and pass after the fix, covering disabled,
  policy replacement, disposal and callback replacement at 360/800px.
  All 15 control tests and 2602 full tests pass. Static analysis,
  architecture/UI guards and production/preview release builds pass.
- Real Edge dark 1200x900 shows all five segments disabled after toggling
  Editing enabled. At 320x568 the disabled dropdown ignores a click; restoring
  editing allows Proxy only selection and updates the description. Screenshots
  inspected. Browser AX still advertises Expand for the disabled dropdown,
  which remains an accessibility gap despite blocked pointer activation.
- Async policy resolution, normalization races, in-place policy mutation,
  extreme text and real provider integration remain incomplete. The browser
  fixture uses a supplied policy; stale callbacks are tested with widgets.

## Pass 249: Disabled Playback Dropdown Semantics

- Disabled narrow playback dropdowns now expose the localized field name and
  selected value as one disabled button. Inactive descendant semantics are
  excluded, removing the unusable Expand action observed in Pass 248.
  Enabled menus retain their existing interaction.
- Two en/zh regressions fail before and pass after the fix. They verify the
  named disabled state, selected value, no semantic tap, blocked pointer
  selection and successful selection after re-enabling. All 17 control tests
  and 2604 full tests pass; analysis, architecture/UI guards and both
  production/preview release builds pass.
- Real Edge at 320x568 reports disabled Playback route Direct only without
  Expand; the screenshot retains the selected value and complete description.
  Re-enable restores the ordinary menu entry. At 1200x900 the segmented layout
  is intact and selecting Proxy only updates the description.
- Native screen readers, toggling enabled while a popup is already open,
  asynchronous policy/normalization races and extreme text remain incomplete.

## Pass 250: Playback Route Large Text Layout

- Header labels now wrap within their available width. At large text sizes,
  desktop and mobile use a dropdown with content-driven option height instead
  of crowded segments or fixed-height menu rows.
- Four en/zh tests at widths 320/1200 and 3x text verify selected-label bounds,
  popup access and selection. Before the fix, the English mobile header
  overflowed by 327px and desktop retained the segmented layout.
- An initial full run exposed a 1px Bilibili playlist overflow caused by
  increasing normal-size dropdown height. Normal density and label padding
  are preserved; all 31 integrated tests and 2608 full tests now pass.
  Analysis, architecture/UI guards and production/preview release builds pass.
- Real Edge 320x568 at 3x shows wrapped header/value, readable five-option
  popup and a scrollable complete warning. Selecting Proxy only updates the
  description and removes the warning. Desktop 1200x900 uses the dropdown
  without overlap. Final rebuilt preview mobile popup/selection was rechecked.
- Async policy resolution, normalization races, in-place policy changes,
  native screen readers and real provider integration remain incomplete.
  Logs use the `pass250-*` prefix under the local review build directory.

## Pass 251: Playback Policy Gateway Replacement

- Policy loading now subscribes to the gateway dependency and refreshes when
  its identity changes. It tracks the gateway used for the request so unrelated
  rebuilds retain the current future. Existing source/policy changes continue
  to invalidate the active policy and pending normalization.
- Four regressions reproduce the missing refresh before the fix, covering
  pending and resolved requests through direct and registry scopes. Two
  additional controls verify late success/error from a replaced source cannot
  overwrite the new policy. All 27 focused and 2614 full tests pass.
- The existing browser fixture now has an async mode with independent first
  and second gateway completions. Real Edge 1200x900 switches to the second
  gateway, resolves Proxy only, then completes the old Direct only request;
  Proxy only remains selected. At 320x568, switching between both resolved
  gateways updates the dropdown, description and direct-playback warning.
- Analysis, architecture/UI guards and production/preview release builds pass.
  Logs use `pass251-*`. Requests use controlled futures; real server transport,
  missing/reappearing scopes, mutable input and normalization races remain
  incomplete. The loading spinner has no accessible name in the observed
  browser tree and needs a separate accessibility correction.

## Pass 252: Named Playback Policy Loading

- Replaced the raw adaptive spinner with the existing AppLoadingIndicator,
  retaining the 40px slot and inheriting the shared localized loading label,
  loadingSpinner semantic role and themed color.
- Four en/zh Android/macOS-theme regressions fail before and pass after.
  They verify the loading name/role, stable slot height and removal after a
  policy resolves. These are widget theme variants, not device tests.
- UI guard now recognizes CircularProgressIndicator.adaptive. The new adaptive
  constructor regression fails before the scanner change; default constructor
  detection and wrapper/comment/string controls also pass. All 35 focused and
  2621 full tests pass, together with analysis, architecture/UI guards and
  production/preview release builds. Logs use `pass252-*`.
- Real Edge desktop 1200x900 and mobile 320x568 expose a Loading description
  with a visible themed spinner. Resolving the first policy removes that node
  and displays Direct only, its description and warning without overlap.
  Native announcements and all scanner syntax/exclusion cases remain open.
- Initial reading of content-report detail/disposition actions identified
  duplicate-opening and controller-lifetime candidates for the next review;
  they are not yet reproduced or claimed fixed.

## Pass 253: Content Report Disposition Ownership

- Extracted ReportDispositionDialog so the form owns its controller, selected
  status, submission lock and close state. Pending submissions disable status
  and note editing. Cancel remains available, and route identity checks prevent
  late success/error from closing or notifying a covering page.
- Four regressions fail on the prior implementation: editable pending fields,
  controller disposal before the closing animation ends, success popping an
  unrelated covering route, and errors leaking into that route. They pass after
  extraction. Additional tests cover retry and en/zh 320/1200 layouts at 3x,
  including selected status, note text and room scope sent to the gateway.
- All 12 focused and 2630 full tests pass. Analysis, architecture/UI guards and
  final production/fixture builds pass. An explicit mounted condition was added
  to the already guarded async error branch for analyzer recognition; focused
  tests and analysis were rerun. Logs use `pass253-*`.
- Real Edge desktop 1200x900 and mobile 320x568 at 3x show a complete scrollable
  dialog with reachable actions. Pending mobile submission exposes disabled
  status/note/Save and Cancel returns Saved reports: 0. A separate successful
  run selects Resolved from the four-option popup and returns Saved reports: 1.
- This is controlled-gateway dialog verification. Full list/server integration,
  detail/disposition entry singleflight, gateway/scope changes and filter/total
  reconciliation remain open. Disabled AppSelect still advertises Expand in
  the browser tree and needs a shared accessibility follow-up.

## Pass 254: Shared Disabled Select Semantics

- AppSelect now excludes inactive menu semantics and names the selected value
  or hint as a disabled button. The wrapper covers both native and anchored
  menus while keeping field labels and validation outside the excluded subtree.
  Enabled menu semantics and pointer behavior remain intact.
- Twelve regressions fail before and pass after across both menu modes, inline
  and external labels, and explicit disable/missing callback/empty options.
  They verify no expanded state or tap/expand action, retained label/error,
  blocked taps and successful selection once after re-enabling.
- All 195 focused and 2642 full tests, analysis, architecture/UI guards and
  production/preview release builds pass. Logs use `pass254-*`.
- Real Edge 1200x900 and 320x568 at 3x confirm pending report status is now
  a disabled Reviewing button without Expand. The value and note remain
  readable; Cancel returns Saved reports: 0 and reopening restores the enabled
  selector's normal Expand action. Anchored mode has widget-test coverage;
  native screen-reader announcements and already-open anchored-menu disabling
  remain unverified.

## Pass 255: Report Detail And Disposition Entry Lifecycle

- One synchronous lock now covers detail requests, the details dialog and the
  transition into disposition. Repeated and cross-entry calls are ignored,
  rows/Resolve commands disable, and the current row shows a named fixed-size
  spinner only during the detail fetch. Cancellation/failure releases the lock.
- Detail completion checks the page route before opening UI. The details
  dialog returns a boolean through its own navigator; the same flow then opens
  disposition, avoiding a page-level pop in nested navigation.
- Six regressions fail before and pass after: three detail requests instead
  of one, cross-entry access during disposition, covered late success/error,
  disposed callback requests, and nested navigation losing the report page.
  Controls verify error fallback, cancellation and re-entry. All 18 focused
  and 2648 full tests pass, with analysis, architecture/UI guards and release
  builds. Logs use `pass255-*`.
- Real Edge desktop 1200x900 and mobile 320x568 at normal text scale inspect
  the production list and dialogs with a controlled gateway. Loading and
  disabled entries accompany Detail requests: 1. Details transitions into one
  disposition dialog; Cancel restores the list, and another detail request
  increments the counter to 2. This is not live backend verification.
- Gateway/room changes, hidden-tab and complex nested-route coverage,
  cancellation of never-completing detail requests, and status-filter/total
  reconciliation remain incomplete.

## Pass 256: Report Filter And Pagination Reconciliation

- Backend report queries filter status and calculate matching totals. Successful
  disposition now reloads the current query; when totals shrink beyond the
  current page, the view refetches the last valid page. Manual refresh also
  shows loading feedback while retaining existing results.
- Three regressions fail before and pass after: missing post-save query and
  total reconciliation, an empty last page after disposition, and a newer
  search superseding the pending post-save query. All 21 focused and 2651 full
  tests pass. Analysis, architecture/UI guards and release builds pass; logs
  use `pass256-*`.
- The controlled browser gateway now mutates status/notes and filters/paginates
  its collection. Edge desktop 1200x900 verifies Pending total 1 becomes 0 after
  saving Reviewing. Mobile 320x568 finds that record under Reviewing, and a
  separate 51-record collection returns from page 2 to page 1, total 50, after
  processing its last-page record. Screenshots inspect list, empty state,
  status menu and disposition layout; loading fields disable correctly.
- Live server mutations, gateway/room replacement, hidden-route behavior,
  never-completing detail cancellation and the remaining report layouts are
  still incomplete. This pass does not complete the project audit.

## Pass 257: Report Data Source And Dialog Ownership

- Gateway and initial room/query changes now reset filters, pagination, tabs,
  results and action state. Scoped/registry gateways are subscribed to, and
  ordinary rebuilds preserve search without refetching. Recreated tab
  controllers use a ticker provider supporting the full page lifetime.
- A source revision guards pending operations and retained entry callbacks.
  Replacement/disposal removes owned dialog routes after the frame while
  preserving covering routes. Disposition checks source validity before
  mutation/completion; details render with their own context. Open status
  menus disappear with their dialog.
- Browser inspection exposed missing All targets in room-scoped dropdowns.
  This option now represents and restores the existing unspecified backend
  query, which remains restricted by the backend's room-context scope.
- Ten regressions fail before their fixes: three injection variants,
  room/page/tab replacement, old detail success/error, two covered dialog
  ownership cases, retained callbacks and the missing target option. Four
  controls cover unchanged rebuilds, pending save success/error and menu/stale
  Save cleanup. All 35 focused and 2665 full tests pass, with analysis,
  architecture/UI guards and release builds. Logs use `pass257-*`; the final
  full suite is `pass257-full-final.log`.
- Edge desktop 1200x900 shows old detail Loading then replacement data without
  stale details. Mobile 320x568 verifies disposition removal on replacement
  and the complete target menu. Controlled-gateway browser tests do not verify
  live backend writes; pending mutation completion across replacement is
  widget-tested. Hidden tabs, cancellation of never-completing requests, all
  query combinations, extreme content/layouts and device/live integration
  behavior remain incomplete.

## Pass 258: Cancellable Details And Short-Screen Report Layout

- Pending detail retrieval now exposes a tonal Cancel command on its readable
  active row. An action revision releases the entry lock and prevents old
  success/error/finalizers or retained Cancel callbacks from affecting a retry.
  This cancels frontend waiting; the gateway has no transport-abort contract.
- Filters, pager and lazy report records now share the CustomScrollView pattern
  used by other admin lists. This fixes en/zh 320x568 at 3x text overflowing
  vertically and losing the list. Long title/summary previews use two/three
  lines; full content remains selectable in details. A before-fix long reason
  produced a 24236px row, making its action difficult to reach.
- Six regressions fail before their fixes: three cancellation/retry cases,
  two short-screen layouts and the oversized preview. Two desktop large-text
  controls also cover long detail scrolling and transition to disposition.
  All 43 focused and 2673 full tests pass, with analysis, architecture/UI
  guards and release builds. Logs use `pass258-*`; the final full run is
  `pass258-full-final.log`.
- Real Edge desktop 1200x900 and mobile 320x568 verify permanent-wait Loading,
  an enabled Cancel command, and restored entries after cancellation. The
  final mobile screenshot verifies normal row contrast and the tonal command.
  Mobile 3x scrolls past filters into bounded previews, opens full details,
  scrolls through long unbroken metadata, and activates Resolve into the
  disposition dialog. These are controlled-gateway browser checks.
- Hidden-tab behavior, transport cancellation, all query/content permutations,
  keyboard/device behavior and live backend integration remain incomplete.

## Pass 259: Preserve Search Scope And Expose Exact Filters

- Text search/clear now preserves initial and explicit ID constraints. Removed
  prefix/numeric heuristics that generated unrelated AND predicates. Backend
  repository/service contracts confirm the independent query semantics.
  Four regressions failed before the fix.
- Extracted an owned exact-filter dialog with seven admin or two room fields,
  draft Reset/Cancel/Apply, trimmed IDs, positive message-ID validation and
  source/current-route guards. Labels and search hints support en/zh.
- All 56 focused and 2686 full tests pass; analysis, architecture/UI guards
  and production/showcase release builds pass. Logs use `pass259-*`.
  Tests cover en/zh 3x at 1200x900 and 320x568, validation, preserved scope,
  independent predicates, cancelled reset and source replacement.
- Real Edge at 1200x900 verifies search screening plus reporter usr_alex
  reduces two records to one while preserving text. At 320x568, screenshots
  confirm list/modal layout, scrolling to final fields and accessible actions;
  Reset then Cancel preserves both conditions and the single result.
  The controlled gateway simulates selected predicates only.
- Hidden tabs, all scope/predicate combinations, message integer precision,
  transport abort, native keyboard/device behavior and real backend writes
  remain incomplete. Dependencies were not re-audited in this pass.

## Pass 260: Nested Tab Activity And Stale Report Dialogs

- User details embed reports in nested application tab views. Route-current
  checks alone allowed a late detail success or fallback after failure to open
  over another tab. Four inner/outer keepalive regressions reproduce this.
  Two additional controls verify owned filter/disposition modal dismissal.
- AppTabBarView now supplies a composed AppTabActivity signal using its
  selected controller and ancestor activity. Keyed child identity is preserved;
  a default-controller GlobalKey keepalive counter checks state across tabs.
  Reports expire pending action/context revisions and dismiss owned dialogs
  when inactive, retaining loaded data while mounted. Hidden load failures
  no longer display notifications over another tab.
- All 56 report-view and 2693 full tests pass, along with analysis,
  architecture/UI guards and production/showcase builds (`pass260-*` logs).
  The initial before log contains four behavioral failures and two tooltip
  finder mistakes; the latter were corrected before the passing run.
- Real Edge desktop 1200x900 and mobile 320x568 observe detail Loading,
  scheduled tab replacement, then other-tab content without a stale modal
  after the delayed request finishes. Returning restores usable entries;
  mobile opens the Resolve form with accessible controls and no overlap.
  The controlled fixture can dispose inactive children; nested keepalive
  correctness is established by widget tests, not this browser scenario.
- The new signal covers application tabs only. Other consumers must explicitly
  adopt it; raw tabs, IndexedStack, browser document visibility, complex route
  combinations, message integer precision and real device/backend integration
  remain incomplete. No general visibility or complete audit claim is made.

## Pass 261: Activity During Nonadjacent Tab Animations

- Expanded shared-tab checks to drag, controller replacement and keyed child
  reorder. These controls passed, but a first-to-third animated transition
  reproduced stale activity: the old page remained active at 100ms into a
  one-second animation. Flutter retains old children during this page warp.
- Each private _AppTabPage now subscribes independently to the controller and
  composes ancestor activity. Retained pages update immediately on selection;
  the whole TabBarView no longer rebuilds for each selection notification.
  Keyed state and default-controller behavior remain covered.
- Added a nested report integration control that completes detail retrieval
  before the cross-page animation ends and checks no modal before/after
  settlement. Five shared-tab and 57 report tests pass (62 focused total).
  All 2698 full tests, analysis, architecture/UI guards and production/showcase
  builds pass. Logs use `pass261-*`; `pass261-before.log` records the failure.
- The browser fixture animates first-to-third for five seconds while its detail
  request finishes after two. Real Edge 1200x900 and 320x568 screenshots inspect
  the Loading state and final third-tab content without stale dialogs, and
  return navigation. Layout remains readable without overlaps. Intermediate
  animation timing is proven by widget tests; screenshots do not cover every
  frame. Browser verification uses a controlled gateway.
- Rapid animation interruption/reversal, dynamic tab-count changes during
  animation, other consumers and live device/backend integrations remain open.

## Pass 262: Packaging Dependency Security And Rust Advisory Audit

- Rechecked Dart resolution: the same five upstream-constrained transitive
  versions remain; no newer version is currently upgradable/resolvable.
  Native OPAQUE and web Wasm Cargo lockfiles report no known vulnerabilities
  or informational warnings (60 and 48 dependencies respectively).
- npm audit found an affected xmldom 0.9.10 in DMG packaging. Updated its lock
  to compatible 0.9.12 with no manifest/override changes. Invalid entity-name
  and strict-serialization checks plus packaging plist round-trip assertions
  pass. This removes an affected dependency; application exploitability was
  not demonstrated because the reviewed plist path does not use that serializer.
- Post-update npm audit still reports three high package entries arising from
  two image-size advisories. All published image-size releases remain affected.
  Reviewed usage reads the packaging tool's own PNG background; the release
  script has no custom background input. This bounds current usage without
  claiming the vulnerable library is fixed or suppressing audit results.
- Clean npm installation/native rebuild, real unsigned DMG creation from
  an existing debug bundle and hdiutil checksum verification pass.
  An initial mixed-Node ABI failure was resolved
  by running in the dependency build environment. Local Node 23 packaging does
  not substitute for Node 24 CI or signed/notarized release validation.
- Details, advisory links and limits are recorded in
  [frontend-dependencies.md](frontend-dependencies.md), with `pass262-*` logs.
  No runtime UI code changed; the prior 2698-test/Web/browser baseline remains
  applicable, and no new browser rendering coverage is claimed this pass.
  Vendored media scripts, native dependencies and full goal coverage remain open.

## Pass 263: Vendored HLS Upgrade And Browser Playback Verification

- Updated vendored HLS.js 1.7.1 to 1.7.2 with its upstream license, versioned
  runtime path and matching SRI. Verified the npm archive integrity and all
  three playback bundle hashes. dashjs 5.2.1 and mpegts.js 1.8.2 remain current.
- Upstream fixes include end-gap seek duration, low-latency playlist refresh
  and subtitle timing/parsing. These specific malformed/live cases were not
  reproduced in this pass; ordinary playback compatibility was verified.
- Added a reusable standalone production-runtime fixture. Edge selects native
  HLS by default; its query-controlled native-capability override exercises
  the actual HLS.js loader/MSE engine without changing production selection.
- Browser Use desktop and 320x568 screenshots show HLS.js 1.7.2, 640x360
  nonblank video, accessible controls, successful seek to 12 seconds and
  advancing playback through the 24-second end. No overlap was observed.
  This covers the runtime fixture, not every authenticated room/player surface.
- All 2698 application tests, 16 local player-package tests, 22 Service Worker
  tests, analysis, architecture/UI guards and both release Web builds pass.
  Production output includes only the new HLS version. Logs use `pass263-*`.
  Further loader lifecycle, live/subtitle/codec and native-device coverage
  remains open; the broader goal is still active.

## Pass 264: Bounded Playback Engine Loading And Retry Cleanup

- Found that the adaptive engine script load had no timeout. The later media
  metadata timer starts only after script loading, so an unresponsive script
  request kept the shared future pending and trapped subsequent retries.
- Extracted script loading into `web_engine_loader.dart`, shared by the three
  production engines. Loads now time out after 15 seconds, remove listeners
  and their script element, and release the failed shared future for retry.
  Missing document head fails immediately; successful APIs remain reusable.
  Cleanup also covers synchronous script attachment errors.
- Seven checks use a detached browser document and controlled load/error
  events. The stalled-load check visibly failed before the timeout fix with
  `Loader remained pending`. Edge desktop and 320x568 run all seven checks
  successfully after the fix, covering timeout/retry, concurrent sharing,
  script error, missing global, successful/existing API and missing head.
  Old script events cannot settle a new attempt; SRI, CORS and base-relative
  URL configuration are also asserted. This is browser DOM verification with
  controlled events, not fault injection into a live media origin.
- All 2698 application tests, 16 player-package tests, analysis, architecture/UI
  guards and production/two fixture release builds pass. Browser checks are
  separate from the application test total. Logs use `pass264-*`.
- The real HLS fixture loads 1.7.2 through the extracted loader, shows 640x360
  video and advances after user-initiated seek/play. It also exposed a separate
  early autoplay AbortError during platform-view DOM adoption. Waiting one
  Flutter frame did not fix it; that ineffective fixture edit was removed.
  The fixture retains this error even after manual playback recovers. Actual
  mount-time autoplay and its production room caller need the next audit.
- Removing a script does not guarantee cancellation of the browser's underlying
  fetch or prevent a late script from registering its global. Shared-load
  subscriber cancellation and those late global-registration effects remain
  unverified; no stronger cancellation guarantee is claimed.

## Pass 265: Preserve Playback Intent Across Platform View Mounting

- Traced the pass 264 autoplay failure to Flutter moving the connected video
  into a detached platform-view wrapper before inserting it. This can reject
  an in-flight play promise with AbortError or pause already-started playback.
  The room uses the same production runtime and autoplay adapter; the adapter
  intentionally handles NotAllowedError separately from this mounting failure.
- Extracted browser playback intent into `web_video_playback_controller.dart`.
  The view factory starts a bounded ResizeObserver attachment check. A play
  interrupted during that mount is retried once after connection; already
  started playback can resume after adoption. Original play attempts remain
  immediate, preserving browser user-activation handling.
- Pause, media reset and disposal invalidate old play commands. Unrelated
  aborts and permission denial remain errors, failed recovery is not repeated,
  and asynchronous recovery failures reach the owner. The observer disconnects
  at attachment, disposal or its three-second deadline. Completed media and
  native browser pauses are not automatically restarted by a later mount.
- Twelve shared browser checks cover those paths, including a pending and an
  already-settled play request, cancellation, stale failures, bounded waiting,
  completed media and native pause. Together with the seven prior loader
  checks, real Edge desktop/mobile runs report all 19 passing. These use real
  DOM adoption/ResizeObserver with controlled media promises and native-state
  values, not actual PiP controls or adverse media networks.
- The unchanged HLS production-runtime fixture now autoplays without pressing
  Play: desktop shows advancing time and video; 320x568 reaches the 24-second
  end with no AbortError. This reproducer failed before in pass 264. Actual
  authenticated room playback, audible autoplay and Safari/PiP remain separate
  integration gaps. Background-page observer throttling also remains untested.
- All 2698 application tests, analysis, architecture/UI guards and production
  plus both fixture release builds pass. The 19 browser checks are separate
  from the application test count. Logs use `pass265-*`. The broad goal remains
  active; this pass does not establish complete player or page coverage.

## Pass 266: Exact Report Message IDs On Web

- Real Edge reproduced `9007199254740993` becoming
  `9007199254740992` after applying the report filter. Backend report APIs use
  signed i64 IDs; JavaScript integer precision cannot represent the full range.
- Report models, query state, filter drafts, facade methods and room/admin
  navigation now carry decimal strings. API boundaries validate the range and
  use `Int64.parseInt`; responses use `toString`. Room report navigation passes
  the original message ID without parsing it through a Dart int.
- A shared BigInt-based parser canonicalizes leading zeroes, accepts the
  optional zero sentinel and rejects malformed or out-of-range input. English
  and Chinese validation explain the accepted range. Localized labels accept
  string IDs without numeric conversion.
- Parser, dialog and transport regressions cover IDs above 2^53, signed-i64
  maximum, invalid formats and rejected requests before transport. A further
  view regression covers initial scope, editing, reopening and chip removal.
- Real Edge verifies the corrected large-ID chip on desktop, maximum-ID chip
  at 320x568, exact value after reopening and rejection of maximum plus one.
  Mobile screenshots show the full chip, scrollable fields, wrapped range
  feedback and reachable actions without overlap. Browser interaction uses
  the local report fixture; transport behavior is verified by API tests.
- All 2708 application tests pass, followed by the additional view regression
  passing independently. Analysis, architecture/UI guards, fixture and
  production Web builds pass. Logs use `pass266-*`.
- General chat message-ID conversions, other provider numeric identifiers,
  complete page/state coverage, native devices and live integrations remain
  incomplete. This pass closes the report path only; the broad goal is active.

## Pass 267: Exact Event Cursors Across Room Transports

- Followed report precision findings into replay cursors. Room management,
  media subscriptions and WebSocket encoding duplicated `int.tryParse` before
  constructing Int64; event decoding converted Int64 back through Dart int.
  Chat history/search responses also rounded their initial event cursors.
- A real Edge before-build ran the room settings/member boundary checks:
  only 4/18 passed. `9007199254740993` rounded down in both directions;
  maximum signed-i64 became `-9223372036854775808` in outgoing requests and
  `9223372036854776000` after incoming decoding. Native tests exposed two
  malformed-cursor failures but retained large integer precision, showing why
  native-only testing was insufficient for this bug.
- Shared `parseEventSequence` validates exact decimal strings and constructs
  Int64 directly. All three transports use it; cursor versions format Int64
  directly, preserving legacy event-ID fallback for zero. Chat history and
  search retain exact sequence strings while preserving their absent-cursor
  behavior. Opaque or malformed versions omit the numeric replay parameter.
- Thirty-four shared checks exercise history/search response boundaries,
  settings/member/playlist SSE request and observed/changed event mappings,
  zero/legacy/malformed cursors, plus WebSocket room-settings request encoding
  and observed/changed decoding. The same checks pass natively and in real
  Edge desktop and 320x568 viewports. Mobile screenshots verify readable long
  numbers, wrapping and scrolling through the final result without overlap.
- All 2743 application tests, analysis, architecture/UI guards, fixture and
  production Web builds pass. Source inventory fingerprints are current.
  Logs use `pass267-*`; the original 18-check browser fixture is retained as
  before evidence in build output. Production preview remains available.
- HTTP/SSE responses are controlled and WebSocket checks use production
  encode/decode without a live socket. Actual disconnect/replay, every resource
  payload, playback snapshot numeric versions, other chat identifiers, native
  devices and remaining whole-project UI/code coverage are incomplete. This
  pass establishes exact cursor boundaries, not complete realtime correctness.

## Pass 268: Foundation Review And Endpoint Identity Finding

- Reviewed the complete 75-line generic preference controller together with
  its serial coordinator and six controlled-completer tests. Ordered writes,
  optimistic revisions, durable rollback, shared/retryable loading and disposed
  notification handling remain coherent. No production edit was warranted by
  this review. Concrete stores, subclass policies and consuming UI/device
  behavior remain separate verification scopes.
- Reviewed resource origin/API-path matching and credential header replacement.
  Six existing tests pass; encoded/malformed URLs, redirects and every external
  transport are not established by those tests, so the record remains partial.
- Endpoint syntax, origin/default-port normalization and hashing have four
  passing existing tests. A separate executable probe exposes non-idempotence:
  `https://example.test/team/api/api` normalizes to
  `https://example.test/team/api`, then to `https://example.test/team`.
  The same problem occurs with `/api/api`. A `/team` control stays stable.
- This is an open defect, not a completed repair. Runtime selection passes
  normalized addresses into API configuration and session storage, which also
  normalize; invitation parsing/matching likewise reuse the operation. Removing
  suffix stripping outright would alter the existing accepted API-address input
  convention. Follow-up must separate external API-address convenience parsing
  from canonical deployment-root identity and audit storage/request/invite
  boundaries together, with repeat-normalization and nested-path regressions.
- All 16 focused existing tests pass. Only audit records change in this pass;
  prior pass 267 full tests, production build and browser checks remain the
  last runtime validation. No new UI or browser correctness claim is added.
  The full goal and endpoint defect remain open.

## Pass 269: Separate Input API URLs From Canonical Deployment Roots

- Repairs the non-idempotent endpoint identity found in pass 268. Internal
  `normalize` now preserves meaningful path segments, including `/api`.
  `fromUserInput` retains the convenience of pasting an API URL by removing its
  suffix once, before the address enters runtime selection or storage.
- Runtime add/set input boundaries perform that conversion once. Explicit
  built-in configuration is also parsed once; its already-resolved default is
  not parsed again. Internal API clients, restored profiles, activation,
  namespace hashing, certificate endpoint checks and invitation paths consume
  canonical deployment roots. API client documentation states this contract.
- One hundred direct-client test fixtures previously supplied API URLs while
  expecting root deployment requests. They now supply explicit deployment
  roots, retaining their existing request assertions. An invite regression now
  verifies that an internal `/api` deployment remains in the generated link.
  User-facing API URL acceptance remains covered at the input boundary.
- Seventeen shared checks cover `/api`, `/team/api`, `/team/api/api` and an
  encoded-space path: repeated normalization, exact API/resource requests,
  distinct namespaces, invite roundtrips, stored session isolation/reload and
  fixed-server runtime input/activation. Four native tests additionally verify
  add/probe/profile creation and runtime restart with the same deployment path.
- Real Edge desktop/mobile reports 17/17 checks passing. At 320x568, long paths
  wrap and all results remain scrollable without overlap. HTTP responses and
  preferences are controlled; no live backend mutation or real browser storage
  is used. The original executable probe now reports stable paths throughout.
- All 2764 application tests, analysis, architecture/UI guards and fixture plus
  production Web builds pass. Source fingerprints and generated inventory are
  current. Logs use `pass269-*` and production preview remains available.
- Stored addresses already shortened by older code cannot reveal their lost
  path segments and are not guessed or migrated to another endpoint. Live
  reverse proxies, actual native storage, full URL encoding/security cases and
  whole-project page/component coverage remain incomplete. The broad goal is
  active; the specific repeated-normalization defect is closed.

## Pass 270: Register Latest Operations Before Reentrant Callbacks

- Reviewed the latest-operation coordinator and its taxonomy/video initialization
  consumers. The coordinator invoked callbacks before publishing the active
  future/key, allowing synchronous reentry to start duplicate work or replace
  its registration. The outer invocation then overwrote that newer state.
- Four controlled regressions fail before the fix in both native tests and
  real Edge: same-key duplicate execution, replacement loss after old success
  or failure, and synchronous invalidation preventing immediate retry. A
  synchronous-error/retry control passes; the before browser shows 1/5.
- Publish a Completer-backed active future and key before invoking the callback,
  following the existing keyed coordinator pattern. A guarded async runner
  forwards completion/errors and clears only its own active registration.
  Callbacks still start synchronously, preserving existing initiation timing.
- All five shared checks pass after the change in real Edge desktop and
  320x568 viewports. Mobile screenshots show readable wrapped results without
  overflow or overlap. Sixty-four focused async/preference/app-shell tests,
  all 2769 application tests, analysis, architecture/UI guards and fixture plus
  production Web builds pass. Source inventory fingerprints are current and
  logs use `pass270-*`.
- These are production-coordinator checks with controlled callbacks. No actual
  taxonomy or player callback was observed reentering synchronously in this
  pass. Self-awaiting the same coalesced operation is a dependency cycle and
  remains outside the supported usage. Transport cancellation, every consuming
  UI lifecycle and whole-project coverage remain incomplete; the goal is active.

## Pass 271: Resilient and Readable Playback History

- Playback history converted untrusted signed-i64 seconds before validating the
  DateTime range. Out-of-range values threw during rendering; real Edge displayed
  a large gray error area for the maximum signed-i64 entry. Validate Int64 values
  before conversion/multiplication, omit absent/invalid dates and retain a
  localized year and the user's clock convention for valid local dates.
- At 320 logical pixels and 3x text, the original title had only 96 pixels of
  available width beside the icon and two actions. Reuse AppTile, stack actions
  under text on narrow/large-text layouts, and highlight the current entry.
  Explicit line limits avoid the inherited single-line subtitle default; the
  typical title, playlist and timestamp now wrap without overlap. Missing delete
  callbacks disable their button.
- Two regressions fail before the fix. All five focused tests pass, including
  a final rendering assertion for untruncated typical metadata and its year.
  The full suite passes 2771 tests; final focused verification, analysis,
  architecture/UI guards and final fixture/production builds pass.
- Real Edge compares before/after desktop and 320px mobile rendering. The final
  build preserves the year, renders invalid-date entries, wraps normal/3x text,
  scrolls to subsequent actions, switches the cursor and deletes an entry.
  These use the real widget with controlled in-memory entries; live backend
  mutations and actual media playback are not claimed. Pending transitions,
  arbitrary metadata length, RTL and native assistive technology remain open.
  The broad audit goal remains active.

## Pass 272: Responsive Chat Message Menu Placement

- The chat menu computed its coordinates before opening, retained stale viewport
  bounds after resizing and provided no scrolling for content taller than the
  remaining window. A short-viewport layout regression fails before the fix.
- Extract ChatContextMenuPopup from RoomScreen. It recalculates layout when
  constraints or safe/keyboard insets change, translates the anchor into the
  remaining coordinate space and constrains AppSingleChildScrollView. Popup
  elevation stays outside the scroll clip. The size model now includes its
  border, preventing six 28px controls from unexpectedly wrapping at full width.
- Five model and three popup tests verify width/wrapping, viewport edges, bounded
  height, open-popup resize, safe-area/keyboard changes, final-action reachability
  and zero unwanted scroll extent for a correctly sized bordered panel. The
  initial full run identified a direct-scroll-widget guard violation; switching
  to the shared wrapper fixes it. Final full suite: 2775 passing tests. Final
  analysis, architecture/UI guards and fixture/production builds pass.
- With the browser extension unavailable, native Edge UI automation opens the
  actual page and configures DevTools device emulation. Desktop and 320x568
  screenshots verify the open menu remains visible across resizing. A simulated
  500px keyboard inset constrains its height; real scrolling reveals the action
  row and Delete closes the menu and updates the fixture state. Report also
  executes in the normal mobile layout. Final wrapper build is rechecked.
- The fixture uses the production popup with a representative icon panel and
  local callbacks. Real chat reaction text, permission/message changes while
  open, backend mutations, physical soft keyboards and native devices remain
  incomplete. The broad audit goal remains active.

## Pass 273: Reject Invalid Active Playback Expiry

- Active-source retention constructed DateTime from unbounded expiry seconds.
  Its caller evaluates the helper before choosing the player update action, so
  invalid server data can interrupt status reconciliation with RangeError.
  Reject nonpositive, absent and out-of-range values before multiplication and
  conversion; valid source expiry keeps its existing strict future comparison.
- Twelve shared checks cover invalid values, exact expiry, one microsecond on
  either side, future/expired sources, local instants and the maximum valid
  DateTime. Native and real Edge before-build each pass 10/12, reproducing both
  out-of-range exceptions. The after-build passes 12/12. Desktop and 320x568
  device-emulation screenshots show readable results and a reachable final row.
- Review the playback-update policy and the small playlist-selection policy;
  their existing decision and interaction tests also pass. All 30 focused and
  2787 full tests pass, along with analysis, architecture/UI guards and fixture
  and production builds. File-specific scopes are now registered for both.
- Browser checks use controlled expiry values and clocks against the real
  helper. Actual media playback, backend refresh payloads, network changes,
  exhaustive decision combinations and platform player integrations remain
  separate coverage. The broad audit goal remains active.

## Pass 274: Preserve ICE Candidates Across Queue Restoration

- WebRtcNegotiationState restored a fixed-length list, so subsequent candidates
  threw on add. Restoring also overwrote candidates queued during an awaited
  peer close. Copy into a growable list, retain newer queued entries after the
  older restored batch and keep ownership separate from the supplied iterable.
- Two core regressions fail before the fix; an additional control covers empty
  restoration and input independence. A VoiceChatManager integration regression
  delays old-peer close and delivers candidates before, during and after it:
  previously only the first reached the replacement, now all three arrive in
  order. All 45 focused and 2791 full tests pass, with analysis, architecture/UI
  guards and fixture/production builds passing.
- Real Edge before-build reproduces the fixed-length-add error and displays
  only the oldest candidate. After-build desktop and 320x568 screenshots show
  all three entries in order. The browser fixture uses the real queue class
  with controlled labels; real ICE connectivity and microphone use are outside
  its evidence scope.
- Follow-up found in P2pMediaManager: _closePeer awaits channel/connection close
  before clearPeer, which can still erase candidates received during closing.
  Shared queue restoration is repaired, but that separate owner-lifetime race
  needs a manager-level regression and fix. Tie-break collisions and queue
  bounds also remain open. The broad audit goal stays active.

## Pass 275: Preserve P2P Candidates During Transport Shutdown

- P2pMediaManager kept the old peer registered while awaiting channel close,
  then cleared negotiation after awaiting peer close. Candidates arriving in
  either interval could reach the obsolete peer or be erased. Detach both
  transports and clear old request/negotiation state synchronously first;
  close the peer in finally so channel shutdown cannot skip that cleanup.
- Two manager regressions fail before the fix, covering delayed channel close
  and delayed peer close. The replacement now receives both candidates in
  order. All 13 focused and 2793 full tests pass, with analysis, architecture/UI
  guards and fixture/production builds passing.
- Real Edge before-build displays only the after-replacement candidate and a
  failure. The final desktop and 320x568 browser layouts display 2/2 candidates
  in order with readable results and accessible controls. This exercises the
  production manager with controlled transports; it does not verify actual
  network connectivity. The delayed-channel branch has native test coverage.
- Stale channel callbacks, competing connection creations, shutdown error
  handling and full disposal remain separate lifetime audit work. The broad
  audit goal remains active.

## Pass 276: Ignore Replaced Data-Channel Callbacks

- Replaced P2P data channels retained active message/state callbacks. Late
  messages still read cached pieces and state events still notified the UI.
  Closing the previous channel before publishing its replacement also allowed
  synchronous shutdown callbacks to run with obsolete ownership.
- Publish the replacement first and guard both callback entrypoints by current
  channel identity and disposal. Two before-failing manager regressions cover
  callbacks during close and after replacement. They assert obsolete reads and
  notifications are absent while current-channel cache requests still execute.
- All 9 manager tests and 2795 full tests pass. Analysis, architecture/UI guards,
  browser fixture and production web builds pass. Real Edge before-build shows
  obsolete cache reads/extra notifications; the final desktop and 320x568 layouts
  show both ownership scenarios passing with readable controls/results.
- Browser evidence uses the production manager with controlled transports.
  Binary callbacks share the identity gate, but binary transfer isolation has
  no new independent regression here. Already-running async handlers, competing
  creations, shutdown errors and real network connectivity remain incomplete.
  The broad source/page/component audit goal stays active.

## Pass 277: Honor the Player Minimum at the Split Breakpoint

- Read the shared responsive helpers and trace their consumers. RoomShellView
  reserves 680 pixels for primary content and 320 for its sidebar, but the
  proportional sidebar calculation reduced the primary to 675.52 pixels at
  the 1014-pixel split threshold. Bound sidebar growth by the space remaining
  after primary minimum and spacing are reserved.
- One before-failing widget regression checks four desktop widths, primary
  minimum, sidebar range, exact spacing and right edge. All 175 focused tests
  and 2796 full tests pass, along with analysis, architecture/UI guards and
  fixture/production builds.
- Real Edge before-build shows 675.5/324.5 player/sidebar widths; after shows
  680/320. At 320x568, the production shared layout stacks representative panels,
  scrolls to the sidebar bottom and activates its action successfully. Actual
  player/chat contents and large-text combinations remain separate evidence.
- Also read and register PlaylistSearchField and playlistSourceFacts with their
  RoomScreen callers. Existing tests confirm submit/clear behavior and public
  source facts without credential fields or URL query secrets. No additional
  defect justified changes. IME/live search, malformed source payloads, every
  provider and localized chip layouts remain outside this pass. Unbounded
  layout constraints and invalid constructor combinations remain unaudited
  behavior; the broad goal stays active.

## Pass 278: Keep Room Empty States Inside Short Panels

- PlaybackEmptyState and PlaylistEmptyState used non-scrolling columns. Long
  errors were clipped by short player panels; large playlist messages/actions
  painted outside their allocated area. Wrap each centered component in the
  shared single-child scroll view, retaining their visual styling and actions.
- Four before-failing widget regressions cover 320x180 panels at 1x/3x text,
  absence of overflow, error scrolling and reaching/tapping Add media. Existing
  permission tests still verify editable/read-only action visibility. All 175
  focused and 2800 full tests pass; analysis, architecture/UI guards and both
  fixture/production builds pass.
- Real Edge before-build clips the error and paints the 3x playlist outside
  its panel. AX activation of the old add button still succeeds, so this is
  not evidence of universal input failure. Final desktop scroll reveals the
  error reference and keeps large playlist content inside the panel. At
  320x568, scroll exposes the complete add button and Tab/Return confirms its
  callback. Native AX coordinate clicks under device scaling were unreliable.
- These are real production components with controlled data. Actual media
  loading, every locale/state transition, live permission changes and physical
  touch devices remain separate coverage. Realtime event-log retention and
  free-mode slider layout received exploratory reads only; no full audit claim
  is registered for those modules. The broad goal remains active.

## Pass 279: Make Retention Dialog Cancellation Side-Effect Free

- Custom realtime-log retention cancellation previously saved the current value
  and notified the parent. Its controller was disposed one frame after closing,
  while the outgoing route still used it, producing widget exceptions.
- A private stateful dialog owns controller disposal at unmount and guards
  duplicate completion. Cancel returns without saving; preferences are captured
  before awaits, callbacks require a mounted owner and receive normalized values.
- The new interaction regression fails before with disposed-controller errors
  and an unexpected write of 100. After it verifies no writes/notifications on
  cancel, then reopens and saves 9999 as 2000 in storage, notifier and callback
  without route exceptions. All 2801 full tests, analysis, architecture/UI guards
  and fixture/production builds pass. The initial six focused tests passed;
  the subsequent save assertions are included in the full run.
- Real Edge before cancel increments writes from 0 to 1; final cancel leaves 0.
  Desktop and 320x568 dialog screenshots show readable fields and both buttons.
  Browser save was inconclusive after stale native AX indexes; successful save
  evidence is limited to widget tests. Storage-failure feedback, overlapping
  saves, invalid-input feedback and complete event-log UI remain open. The broad
  audit goal stays active.

## Pass 280: Trace Preference Contracts and Record Coverage Gaps

- Read the playback-mode config and four preference controllers in full, with
  their shared persistence base, mode/volume storage adapters and ownership
  lookups. Register five narrowly scoped partial records; preserve prior base
  controller evidence. All 29 selected persistence, preference and playback
  policy tests pass.
- Found a source-level mismatch: mode normalization accepts automatic thresholds
  0.05–30 seconds and manual thresholds 0.1–5 seconds, while the settings sliders
  clamp to 0.1–10 and 0.1–1. A dedicated interaction regression is still needed.
- Multi-key volume write atomicity, malformed/nonfinite mode values, hostile
  overlay color/map values and complete lifecycle/integration coverage remain
  open. This pass changes audit evidence only; it makes no new browser or visual
  verification claim. The broad goal remains active.

## Pass 281: Align Playback Threshold Controls with Saved Values

- Domain normalization allows automatic thresholds 0.05–30 seconds and manual
  thresholds 0.1–5, but UI sliders clamped saved values to 0.1–10 and 0.1–1.
  Extract unchanged domain limits into shared constants and use 0.05-second UI
  steps. Labels preserve 0.05/0.15 precision; slider semantics announce seconds.
- Replace the competing title/value row with a bounded text column. Three new
  regressions fail before on low/high values and two 3x-text horizontal overflows
  at 320x568; all four component tests and 18 focused tests pass after. The full
  suite passes all 2804 tests, analysis and architecture/UI guards pass, and both
  fixture and production web builds succeed. The first concurrent UI-guard run
  hit a native asset signing race; its independent rerun passes.
- Real Edge before shows full tracks for saved 20/4 seconds and severe mobile
  text clipping. After, desktop track positions agree with values; 320x568
  screenshots show accurate 0.05/0.15 labels and wrapping enlarged text. At 3x,
  manual slider ArrowRight changes 0.15 to 0.2 seconds. Checks use the production
  widget with fixture state, not live backend synchronization or preference
  storage. Dark theme, all locales and physical devices remain separate scopes.
- Source coverage remains partial. Malformed mode preferences, multi-key durable
  volume writes and complete overlay preference validation still need review.

## Pass 282: Recover Corrupt Playback Preferences During Startup

- Read all four room preference adapters and their controller/startup callers.
  All are awaited by application initialization, so a malformed mode document
  or a wrong storage type could repeatedly fail startup. Type-check root values
  and independent fields before conversion; fall back to defaults while retaining
  valid siblings. Mode JSON format failures recover without deleting raw data.
  Storage acquisition failures remain outside the recovery catch.
- Normalize NaN/infinite mode thresholds to defaults rather than extreme drift
  limits. The new 17-case suite has 14 failures before the fix and passes after;
  it covers corrupt roots/fields, sibling preservation, nonfinite/overflowing
  numbers, read-without-deletion and a successful later save/load. All 46 focused
  and 2821 full tests pass; analysis, architecture/UI guards, fixture and
  production web builds pass. Audit inventory and scoped diff checks pass.
- A browser fixture writes actual SharedPreferences on an isolated origin and
  uses production AppStartup/controllers/stores. Real Edge before shows startup
  failure. After it reaches the settings page, restores defaults, preserves last
  audible volume 0.7 and grouping=true, and permits free-mode toggling with the
  expected automatic-disabled/manual-enabled controls. Desktop and measured
  355x631 narrow-screen layouts are inspected; browser zoom affects the requested
  viewport override. Reload reseeds data, so it does not prove edited values
  survive a browser restart. Backend initialization and native storage were not
  exercised by this fixture.
- Four adapter coverage records are now registered. False setter return values,
  volume multi-key write atomicity, invalid overlay field isolation and platform
  storage errors remain open. The broad goal remains active.

## Pass 283: Decode Complete Live Danmaku Events Across Platforms

- Read both HTTP danmaku adapters, source interfaces, subtitle adapter/caller,
  and the danmaku stream consumer. Backend transport emits named `danmaku` and
  `error` events; its pinned Axum implementation does use `data: `, so missing
  spaces are not claimed as a current backend defect. The client discarded event
  types and treated provider diagnostic messages as viewer chat.
- Share a complete SSE payload decoder between native and Web. It joins data
  lines until a blank event boundary, handles optional spaces, resets event type,
  omits error payloads and drops unfinished EOF data. The native HTTP regression
  fails before with an error payload/two fragments and a missing compact event.
  Five decoder tests cover fragmented UTF-8/BOM/CRLF, event reset, empty data,
  whitespace, metadata and EOF. Keep await-for inside the existing transport
  catch: an intermediate yield-star implementation failed stream teardown tests.
- All 21 focused and 2827 full tests pass, including existing compressed document,
  replacement, expired-access and forbidden-access cases. Final analysis,
  architecture/UI guards and fixture/production builds pass.
- Real Edge uses the production HTTP adapter against a finite same-origin file:
  before it displays the provider error and invalid fragments; after desktop
  and measured 355x631 show exactly First chat, Compact chat and Multiline chat.
  Build `tool/danmaku_stream_showcase.dart`, copy
  `tool/fixtures/danmaku-events.txt` into its output directory as `events.txt`,
  and serve that directory to reproduce. This proves Web parsing, not actual
  video overlay rendering, long-lived streaming or external provider operation.
- Register eight narrowly scoped source/support records. Subtitle transport has
  source-only coverage in this pass. Size limits, malformed UTF-8 handling,
  cancellation before headers, richer provider error feedback, cross-origin
  behavior and physical-device networking remain open.

## Pass 284: Keep Visible Danmaku Synchronized with Playback State

- Read the complete overlay, history adapter, model and AcFun document codec,
  plus normal/PiP overlay callers and the canvas animation implementation.
  The overlay previously stopped inserting comments when paused but left the
  existing canvas animation running. Buffering had the same visual defect.
- Bind canvas pause/resume to initialized, playing and nonbuffering video state.
  Rebind listeners when the video controller changes and remove them on dispose;
  discard the disabled child controller reference and guard deferred timer
  startup after unmount. Keep the existing insertion polling cadence and skip
  insertion during buffering.
- Two actual painter-position regressions fail before and pass after for pause
  and buffering; a third checks controller replacement and disposal. Six existing
  codec/history cases pass. All 2830 full tests, analysis, architecture/UI guards,
  fixture and production release Web builds pass.
- Real Edge before shows a fixed 400 ms video position while its visible comment
  travels from the right edge to the left. After, desktop and measured 355x631
  screenshots keep the paused comment fixed for over twenty seconds; resuming
  playback moves it again. Build `tool/danmaku_playback_showcase.dart` as the Web
  target to reproduce. The fixture uses the real canvas overlay with controlled
  video values; it does not load media or establish real network buffering,
  native video, provider integration or PiP behavior.
- Five new partial records distinguish this tested fix from source-only findings.
  List mutation, seek/re-enable semantics, option/opacity updates, large-list
  throughput, hostile numeric conversion and complete history window behavior
  remain open. Full-project coverage remains incomplete.

## Pass 285: Apply Danmaku Visibility and Opacity Updates

- Trace normal and PiP overlay construction. The normal player retains the
  overlay state while toggling enabled, so clearing its canvas without clearing
  consumed indices prevented current comments from returning when re-enabled.
  Reset those indices on disable; resumed playback inserts currently valid
  comments through the existing time-window filter.
- The independent opacity override was applied only at construction. Unify the
  effective option for creation, change detection and updates, including removal
  of the override and unrelated font changes. This is a component API defect;
  the main player supplies style opacity through the option object and is not
  claimed to have the same opacity failure.
- Two new regressions fail before with an empty restored canvas and opacity
  1.0 instead of 0.2. All five overlay tests pass after, including prior pause,
  buffering and controller lifecycle cases. Full tests, analysis, architecture/UI
  guards, formatting, inventory checks and production/fixture Web builds pass.
- Extend the existing playback fixture with a display switch and two opacity
  buttons. Real Edge before shows an unchanged bright comment after selecting
  20%, then an empty canvas after toggling off/on and resuming. After, the same
  sequence restores the comment and changes visible opacity immediately, even
  while paused. Desktop-width and measured 355x631 layouts are inspected.
- Preserve earlier scoped evidence in both audit records. Real media, native
  PiP, paused re-enable timing, list mutation, seek behavior, other option
  combinations and large-list throughput remain incomplete.

## Pass 286: Preserve New Arrivals After Danmaku Retention Trims

- Trace the controller's mutable item list: individual arrivals exceeding 500
  entries remove the oldest range, retaining 400. The overlay's consumed-index
  set outlived these shifts, causing new messages in reused slots to be skipped.
  Replace index tracking with object identity and prune consumed entries that
  no longer belong to the current list. Existing visible comments finish their
  animation; surviving data items are not replayed just because their index moves.
- A real canvas regression fails before when a trimmed list receives a new
  comment. After it verifies the new arrival, unchanged survivors, repeated
  polling and a distinct same-text message inserted at the front. All six overlay
  tests and 2833 full tests pass, with analysis, architecture/UI guards,
  formatting, inventory checks and release fixture/production builds passing.
- Extend the existing fixture with same-list trim-and-append. Real Edge before
  shows only the old comment after the action; after it shows the new arrival on
  another track while the old animation remains. Desktop-width and measured
  355x631 checks cover repeated arrivals and resumed motion. The fixture uses a
  small deterministic reproduction, not a live 500-message load benchmark.
- Preserve earlier audit evidence. Polling remains linear and constructs a
  current identity set; no throughput improvement is claimed. Whole-list
  replacement, clear/repopulate transitions, seeks, native integration and
  large document performance remain incomplete.

## Pass 287: Recover Valid Comments from Hostile Numeric Fields

- AcFun JSON comments used unchecked integer conversion: exponent overflow such
  as 1e999 throws during decoding, discarding valid siblings. Very large integer
  timestamps also exceed portable Duration arithmetic. Validate finite numbers
  before conversion and bound positions so microseconds plus the eight-second
  lifetime remain within JavaScript's exact integer range. Invalid positions are
  omitted; invalid optional mode/size use existing defaults.
- Two regressions fail before for mixed valid/invalid numeric fields and unsafe
  native/Web timestamps. Existing format, timing/color/mode and mutable-list
  tests remain passing. Final full suite passes 2835 tests; analysis,
  architecture/UI guards, formatting and final fixture/production builds pass.
- Real Edge first reproduces total parsing failure. An intermediate fix passes
  native tests but recovers an invalid size as 12 on Web because the separate int
  branch bypasses finite-number validation. Use one num conversion branch. Final
  desktop and measured 355x631 show three valid comments, all with size 25,
  including the recovered optional fields; unsafe timestamps are absent.
- Reproduce with `tool/danmaku_document_showcase.dart`. Its error label belongs
  to the fixture, not the production player. Backend source declares u64
  positions: this hardens malformed documents and is not evidence that normal
  backend responses emit infinite numbers. No live provider HTTP, native video,
  payload-size benchmark or complete color/text coercion audit is claimed.

## Pass 288: Recover Startup from Invalid Stored Locale Types

- Read the locale controller and language sheet completely. A non-string locale
  throws in getString before decoding and rejects the startup Future.wait.
  Read the raw preference and decode strings only, falling back to system locale;
  a subsequent explicit selection replaces the malformed value normally.
- Four bool/int/double/list regressions fail before and pass after, including
  subsequent save and restore. All 18 focused tests and 2839 full tests pass.
  Analysis, architecture/UI guards, formatting and release fixture/production
  builds pass.
- Extend the preference recovery fixture with the real locale startup load and
  language sheet. Real Edge before displays startup failure; after displays
  ready with system locale. Desktop selection saves English, and measured
  355x631 selection saves Chinese and closes the sheet. Inspect the sheet's
  desktop and narrow layouts. The fixture fixes MaterialApp to English and
  reseeds corruption on reload; global translation switching and cross-reload
  fixture persistence are not claimed.
- Read the image picker/editor and upload model; existing MIME signature tests
  pass and image decoder cleanup is inspected. Crop callback route ownership,
  controls during cropping, fixed canvas height and file-read failures still
  require dedicated validation. Register narrow partial scopes for these four
  sources and preserve the previous fixture evidence.

## Pass 289: Image Editor Layout, Route Ownership and Web Dimensions

- The crop body's unbounded intrinsic-width query triggers a LayoutBuilder
  assertion in debug widget layout. Give the body a definite preferred width,
  still constrained by the dialog. Release Edge before already renders; no
  release-wide blank-editor claim is made. Bound canvas height by viewport room
  reserved for header, wrapped choices and actions. At actual320x568 the square
  choice is hit-testable, and measured355x631 browser visuals show all choices
  and actions initially. Tests set the physical view and pixel ratio together.
- Late successful crop callbacks previously pop newer routes; late failures
  display notifications over them. Guard route ownership and closing state,
  release busy state for covered results, guard repeated requests and disable
  aspect choices during processing. Four controlled crop completion regressions
  fail after the layout-only repair and pass with the ownership fix. A separate
  duplicate/failure/retry test verifies request count and disabled choices.
- Actual Edge crop and original results reveal0x0 metadata despite valid image
  previews. Flutter Web encoded ImageDescriptor width/height are unsupported.
  Decode one frame on Web and dispose image/codec; preserve descriptor/buffer
  cleanup and lightweight dimension reads on native. Browser after returns
  original640x360 and actual square crop360x360, with valid previews. Two widget
  tests cover original and successful-callback metadata on the native test host.
- Nine editor tests plus two existing upload tests pass. Final full suite passes
  2848 tests; static analysis, architecture/UI guards, formatting and diff checks
  pass. Release fixture and production builds pass. The fixture substitutes
  file selection only; the real production editor and crop plugin execute.
- Scope remains partial: native file dialogs, live uploads, large/corrupt images,
  pre-ready crop actions, crop gesture mutation, large text and caller-level
  selection/upload races still need dedicated coverage. Preserve Pass288 scope
  and add fixture records without treating these checks as full image coverage.

## Pass 290: Gate Image Editing on Decoder Readiness

- Trace crop_your_image's first ready callback and its parsed-image requirement
  for crop/ratio operations. The editor previously enabled these controls while
  decoding. Track ready status, disable crop and ratio choices until ready,
  recheck readiness and route ownership inside handlers, and block canvas
  gestures while preparing or cropping. Original upload and cancellation remain
  available during preparation.
- One regression fails before because the initial crop button is enabled. After,
  controlled ready/loading transitions verify disabled choices, reject a stale
  saved action, permit the next ready request, block crop gestures, and ignore a
  status callback after disposal. All12 focused tests and2849 full tests pass;
  analysis, architecture/UI guards, formatting, diff and release builds pass.
- Real Edge desktop and measured355x631 inspect the ready-state dialog and
  exercise actual square cropping. The browser sample decodes normally; its
  loading phase is not artificially prolonged. Pre-ready refusal and stale
  callback evidence comes from the controlled widget regression. Keep the
  existing fixture/native-picker limitations and prior audit scopes.
- Pending selection/read route ownership, malformed decoder feedback, large
  images and native picker/upload integration remain open. Goal stays active.

## Pass 291: Keep Pending Image Selection on Its Initiating Route

- The picker only checked mounted after reading bytes. A covered but mounted
  source still opened an editor above a newer page, and late file errors reached
  its caller. Capture the initiating route and recheck ownership at selection,
  read, editor-return and dimension-return boundaries. Return null for inactive
  results/errors; current file errors still propagate normally.
- Four controlled selection/read success/failure regressions fail before and
  pass after. Two additional tests verify current error forwarding. All18 focused
  and2855 full tests pass, with analysis, architecture/UI guards, formatting,
  diff checks and release fixture/production builds passing.
- Extend the existing fixture with selection/read gates and a covering page.
  Real Edge before shows the old editor above Another page after releasing either
  boundary. After, desktop selection and measured355x631 read report discarded
  while preserving the covering page. The delays are controlled platform-fixture
  Futures; no native chooser or physical disk-latency claim is made.
- Preserve previous audit scopes. Ancestor/nested navigators, leaving and
  returning before completion, simultaneous same-route requests, malformed-image
  feedback, native picker and live upload integrations remain open.

## Pass 292: Recover Image Parsing and Preserve Tiny Crop Pixels

- The crop plugin leaves parser failures unhandled and its format detector maps
  GIF to PNG. Own preparation through a FutureBuilder, parse using automatic
  format detection, reuse the parsed image, and display English/Chinese recovery
  text on failure. Cancellation and the existing original-upload escape remain;
  this does not validate original uploads or prove backend format acceptance.
- Invalid bytes, truncated PNG and valid GIF fail before. Extending the GIF test
  through actual cropping reveals fractional1-pixel selections becoming zero-size
  encoded images. Round rectangle dimensions to the nearest integer with a
  minimum of one pixel, preserving the delegate's origin handling, validator,
  encoder and concrete generic type. Native tests run actual crop computation,
  verifying1x1PNG and positive square output within ordinary source dimensions.
- Final22 focused and2859 full tests pass, along with analysis, architecture/UI
  guards, formatting and release fixture/production builds. Localization outputs
  are regenerated. The readiness test now covers preparation before the crop
  widget is built as well as the plugin's later ready/loading transitions.
- Real Edge before records persistent loading for malformed bytes and GIF. After,
  desktop and measured355x631 inspect readable recovery text and cancellation;
  the same entry can then edit a valid GIF and return1x1PNG. Browser verification
  caught an intermediate outward-coordinate rounding regression that made an
  ordinary square crop361x360; final dimension rounding restores360x360.
  Browser language is
  English; complete translated/large-text and screen-reader checks remain open.
- Parsing is performed once, but the plugin's cached-parser compute still adds
  native isolate transfers and decoded-image retention. No speed or memory gain
  is claimed; large-image measurements and alternative adapter design remain
  necessary. Animated/EXIF/other-format corpora, fractional bounds beyond the
  tested case, native chooser and live uploads remain incomplete.

## Pass 293: Recover Bootstrap Resource Failure Before Flutter Starts

- Read the Web entry document, Flutter bootstrap, worker cache policy and their
  Node checks. Real Edge reproduces a missing bootstrap script leaving only an
  indefinite loading bar: the previous error handler lived inside that script.
  Register recovery in a small synchronous external startup script before the
  bootstrap request. Resource/evaluation failures and loader/engine/run failures
  expose the existing localized retry UI; successful first frame cleans up the
  listeners. Flutter still removes the overlay and tracks DPR when the recovery
  script itself is unavailable. No inline-script CSP exception is introduced.
- Mobile emulation reveals the pre-Flutter document uses a980-pixel layout on a
  320-pixel device. Add the initial viewport declaration. Final real Edge measures
  320x568 with readable Chinese recovery text and a44-pixel-high retry button.
  Desktop recovery and actual retry-to-application are exercised. The final
  failure fixture also enforces script-src 'self' 'wasm-unsafe-eval', matching the
  backend's script directive; this is not a full backend-header integration test.
- Include startup.js in the worker's existing network-first static asset policy.
  Final57 Web tests pass, covering12 bootstrap tests,28 worker tests and17 P2P
  bridge tests. New checks include both missing scripts, Chinese recovery,
  evaluation/rejection errors, unrelated resources, first-frame cleanup and
  missing-recovery-script success; worker checks cover storage failure and cached
  offline fallback for the new asset. Architecture/UI guards and production Web
  build pass. Dart sources are unchanged; the prior2859-test Flutter run is not
  reported as a fresh run for this pass.
- The local recovery server intentionally has no API. Successful application
  startup exposes a separate issue: an HTML API error body appears as raw markup
  in the room-list error UI. Record that for follow-up. Resource hangs, failure
  of both recovery and Flutter scripts, complete offline browser restart, physical
  mobile devices, English visual layout and screen-reader behavior remain open.

## Pass 294: Keep Unstructured HTTP Bodies Out of API Error Messages

- Trace the real homepage HTML404 display to the shared API error decoder.
  Unknown response bodies previously became the entire message, and message
  objects/lists/numbers were stringified. Use the HTTP status as fallback and
  accept only trimmed, nonempty structured string messages. Keep valid business
  messages, status, request method/URI and structured diagnostic fields. Invalid
  protocol text, including plain text, now uses the status fallback. Remove the
  duplicate empty-body exception constructor and avoid logging JSON parse errors
  that include raw response fragments.
- Thirteen new tests fail before and pass after: HTML/plain/truncated/list/string
  responses, missing/object/list/numeric/blank messages, structured diagnostics,
  and the shared raw-upload and SSE failure paths. Final2872 Flutter tests pass;
  analysis, architecture/UI guards, formatting and production Web build pass.
- Real Edge uses the production application against a static server whose API
  routes return HTML404. Before, the error UI displays the whole document; after,
  desktop and measured355x631 show a short HTTP404 message. Narrow-screen retry
  issues new category/label/discovery requests and returns to the compact error
  state. This verifies real HTTP decoding and UI, not a working backend endpoint.
- Technical method/path prefixes remain in the existing exception display. A
  broader localized, actionable error presentation policy, oversized valid
  structured messages,200 responses containing HTML, response byte limits and
  all downstream dialogs remain separate audit work. The protocol cleanup is
  not claimed as comprehensive error UX or response-resource hardening.

## Pass 295: Reject Impossible Clock Samples and Expand Shared-Module Audit

- Read the synchronized clock and its service caller. Reversed client/server
  intervals and processing time exceeding total elapsed time previously mutated
  the global clock, clamping negative network RTT to zero. Reject these samples
  before mutation, preserving either the unsynchronized state or the previous
  valid offset, sample timestamp and latency. Genuine zero network RTT remains
  accepted. Six native regressions fail before and pass after.
- Real Edge before passes only3/10 shared checks: the six invalid-sample cases
  fail, and a valid +2-second sample exposes Web nanosecond precision followed by
  truncation below the target clock tick. Round the final offset to microseconds.
  Final real Edge passes10/10 on desktop and measured355x631, including negative,
  zero and positive offsets. Fixture layout is inspected; this does not exercise
  multi-device playback or a live server-time endpoint.
- Final20 focused and2882 full Flutter tests pass, along with analysis,
  architecture/UI guards, formatting and fixture/production Web builds.
  The shared checks invoke production SyncedClock and reset its static state
  after each case. They use controlled timestamps rather than wall-clock/network
  disturbance injection. Timestamp freshness, echoed-request validation, signed
  integer extremes, exact nanosecond arithmetic and live playback remain open.
- Also read the media variant formatter, provider-brand mapping, SVG brand mark
  and device-display-name service and trace their callers. Existing focused
  tests verify representative Chinese media labels, SVG loading/radius scaling,
  and device-name normalization/fallback/cache limits. Register narrow evidence
  without inventing edits: unknown variant naming, all brand colors/contrast,
  localized provider fallback, actual native device lookup and complete visual
  coverage remain incomplete.

## Pass 296: Bind Clock Replies to Their Originating Request

- The time-sync facade previously accepted an unrelated echoed client timestamp,
  allowing a wrong response to establish or replace clock calibration. Compare
  its protocol Int64 with the request timestamp before lossy Web conversion, then
  use the owned request timestamp for calibration. Keep revision and endpoint
  generation guards. The Rust implementation was read and echoes the input.
- Four native real-HTTP regressions fail before and pass after: echoes offset by
  minus 60 seconds or plus 1 nanosecond, with and without existing calibration.
  A matching-response control still calibrates. Final 19 focused and 2887 full
  Flutter tests pass; analysis, architecture/UI guards and release production
  and fixture Web builds pass.
- Real Edge final desktop and measured 355x631 each pass all five HTTP checks.
  Inspect the run button and all result rows, including narrow-screen wrapping.
  The fixture exercises production HTTP transport, protobuf parsing, service and
  clock with controlled same-origin responses. An initial fixture base-path
  setup was rejected by the app's origin restriction and corrected; that attempt
  is not before-regression evidence. Native failures provide the before evidence.
- Full time-sync lifecycle, freshness, extreme timestamps, actual Rust HTTP
  integration and multi-device playback remain open. This narrow service fix
  does not establish complete page, dialog, component or visual coverage.

## Pass 297: Preserve Overlay Routes When Authentication Completes

- Auth success previously popped the navigator's top route, which could be an
  independent dialog opened during the request. Close the route containing the
  auth panel: pop it when current, or remove that specific route with a true
  result when covered. Guest completion uses the same helper. Existing mounted
  checks remain; inactive routes are ignored.
- Email, Passkey, TOTP and recovery-code MFA submissions now dispatch their
  AuthResult through the same authentication-state handler. Previously every
  nonthrowing response was treated as completed authentication. A TOTP regression
  verifies a replacement recovery-only challenge stays on the auth screen.
- Three new widget tests cover current/covered OAuth success, caller return
  values, preservation of the covering dialog and MFA replacement. Final 34
  auth-panel tests and 2890 full Flutter tests pass, with analysis, architecture
  and UI guards, formatting and production/fixture release Web builds.
- Real Edge final desktop and measured 355x631 run the production AuthPanel with
  controlled OAuth callbacks and a pending gateway response. Read and accept the
  agreement, verify the waiting state, open the independent dialog and complete
  authentication. The dialog stays visible while the auth route disappears;
  closing it reveals Login result: true. Inspect visible text and stacked narrow
  dialog actions. The first unaccepted attempt never entered authentication and
  is excluded from completion evidence. No browser-before failure is claimed.
- Read the complete recovery-code wrapper and provider widget module, registering
  narrow partial evidence from their existing tests and traced callers. Actual
  recovery entry/back browser interactions, every MFA result and navigation
  arrangement, all provider visuals and native Apple/Passkey/OAuth integration
  remain open. No backend authentication or credential issuance occurs in the
  browser fixture.

## Pass 298: Keep Recovery-Code Actions Readable at Large Text Sizes

- Recovery entry/back buttons used ellipsis, truncating navigation labels in
  three of four 320-wide locale/scale cases (English 2x/3x and Chinese 3x).
  Enable complete wrapping for entry, back and recovery submission actions.
  The wrapper suite changes from 2 passes/3 failures to all 5 passing.
- Four additional production AuthPanel tests cover English/Chinese 2x/3x
  complete submission labels and clearing drafts on back/reopen. Final 43
  focused and 2898 full Flutter tests pass, together with analysis,
  architecture/UI guards, production and fixture release Web builds.
- Real Edge English 2x desktop enters the production recovery form through a
  controlled MFA challenge. During submission, input/submit/back are disabled;
  after a rejected fixture code they become available and preserve the input.
  Returning to the authenticator view and reopening clears that draft. At
  measured 355x631, submit and back labels wrap completely and remain reachable
  by scrolling; a valid fixture code returns Login result: true.
- The recovery fixture initially inherited the previous pass's independent
  dialog toolbar, whose long label clipped at narrow width. Hide that unrelated
  toolbar in recovery mode; rebuild and confirm a fresh narrow auth entry.
  Production form code is identical across these two fixture builds. This is
  final browser validation, not a browser-before regression comparison.
- Brief error-notification wording, Chinese/3x browser rendering, screen-reader
  focus, physical-device keyboards, real OAuth and backend one-use recovery-code
  behavior remain open. The fake gateway never authenticates a real account.

## Pass 299: Order Voice Audio Routing and Release Capture Promptly

- A delayed voice-mode or speakerphone enable could finish after leave restored
  routing, leaving the last applied configuration enabled. Inject the two platform
  operations and run both through a per-manager queue. Preserve each operation's
  error for its caller while allowing cleanup and retries after a failure.
- Previously microphone release waited for speakerphone shutdown. Start capture
  release independently before awaiting audio routing; leave still waits for its
  release before completing and admitting the next join. Three regressions fail
  before and pass after for delayed mode enable, delayed speaker enable and slow
  speaker shutdown. A fourth verifies failed mode configuration cleanup/retry.
- Final full 2902 Flutter tests include all 44 voice tests. Analysis,
  architecture/UI guards, formatting and production/fixture release Web builds
  pass. Read and register partial scopes for the session interface, conditional
  audio export and both platform adapters; no unsupported native coverage claim.
- Real Edge desktop and measured 355x631 each acquire a controlled stream,
  pause the speakerphone enable, then leave. Track-stop and stream-disposal counts
  advance while routing is still pending. Completing that call produces ordered
  enable-complete, disable-start, disable-complete; connected and speaker-enabled
  states remain false and no join signal is emitted. Inspect wrapped controls
  and complete narrow status/event text. This uses the production manager with
  injected streams/routing, not a physical microphone or actual peer transport.
- Permanent platform/track cleanup hangs can still keep leave or a later join
  pending. Cross-manager coordination of process-global audio configuration,
  actual native routing flags and hardware behavior, permission prompts and full
  room/peer audio integration remain open. No browser-before failure is claimed;
  the three controlled native regressions establish the before evidence.

## Pass 300: Avoid Big-Integer Work for Oversized Decimal IDs

- The shared exact-ID validator previously constructed BigInt from arbitrary
  decimal input before checking the signed-int64 range. Scan leading zeroes,
  reject more than 19 significant digits, validate ASCII digits and compare
  equal-width strings with the exact maximum. Preserve trimming, leading-zero
  normalization, the optional zero sentinel and JavaScript-unsafe exact values.
  Event cursors and report message-ID filters inherit the bounded conversion.
- Two added tests cover 100000-digit inputs, long padded valid IDs, malformed
  input and 101 values around the signed-int64 maximum with/without padding.
  These functional tests pass before and after; this is a parsing-cost fix.
  Final 53 focused and 2904 full tests pass. Analysis passes after a braces-only
  lint correction; formatting, architecture/UI guards and release builds pass.
- Real Edge runs the same six-case release fixture before and after. Baseline
  takes 5903100 microseconds for three 100000-significant-digit calls; the click
  observation times out while the synchronous computation blocks, then a fresh
  snapshot confirms completion and six correct results. Final desktop measures
  300 microseconds for that sample, with all six results correct; measured
  355x631 rerun also passes and is below timer resolution for that sample.
  Inspect complete narrow result wrapping and run control. Single-run stopwatch
  samples include runtime noise and exclude input construction; they do not
  establish ordinary-page latency, sustained throughput or exact zero cost.
- Also read and register narrow partial scopes for the distribution policy,
  UUID entry point, three HTTP adapters, home access decision and home interface
  plus concrete gateway. Existing policy/TLS/access tests pass. No fabricated
  production edits or full transport/visual claims accompany these records.
- Leading-zero scans and input allocation remain proportional to input length.
  Transport/input-size limits, actual native TLS/certificates, provider edge
  classifications, UUID entropy/concurrent clients and full home authentication
  integration remain open. This pass does not establish total source coverage.

## Pass 301: Separate the Password-Reset Dialog Module

- Move the standalone reset opener and private dialog from AuthPanel into
  password_reset_dialog.dart. Production callers, existing tests and the preview
  import this cohesive module directly. Exact source comparison confirms both
  moved blocks unchanged; no behavior fix or performance gain is claimed.
- All 71 auth presentation tests and 2904 full tests pass. Analysis,
  architecture/UI guards, formatting and production/fixture release builds pass.
  Existing reset tests cover route preservation, password whitespace, duplicate
  requests, narrow large-text layouts and cancellation with late completion.
- Real Edge inspects desktop layout and measured 355x631 submission with all
  four fields visibly populated, returning to the fixture entry. Reopening
  shows empty fields; Cancel returns to the entry. Initial batched fills only
  populated email and are excluded from successful evidence. Separate fills
  and a screenshot establish the successful submission inputs.
- Semantic entry clicks did not reopen the dialog under viewport emulation;
  an observed-coordinate pointer click did. The narrow English confirmation
  hint remains ellipsized, with its full accessible name present. These checks
  do not establish complete visual/accessibility coverage or real backend
  email sending and password resetting. Physical keyboards remain untested.

## Pass 302: Keep Reset-Form Field Names Fully Readable

- The login reset dialog still placed field names inside single-line inputs.
  Strengthen its four narrow English/Chinese 2x/3x cases to inspect actual
  RenderParagraph truncation: English 2x/3x and Chinese 3x fail before the fix;
  the suite reports two passes and three failures.
- Use the shared AppTextField labelAbove option for all four fields. Labels
  can use the full form width, wrap and remain visible after entry. Account
  password dialogs already use this option through their existing wrapper;
  no shared-widget or account behavior change is needed.
- All five reset cases, 71 auth presentation tests and 2904 full tests pass.
  Analysis, architecture/UI guards and production/fixture release builds pass.
- Real Edge English 2x desktop shows all labels completely. At measured
  355x631, inspect top fields then scroll to the complete confirmation label
  and reachable actions. Entering a password preserves the visible label;
  Cancel returns to the entry. This resolves the narrow label issue recorded
  in Pass301. No browser-before comparison at 2x is claimed; the widget
  failures and prior 1x browser screenshot establish the earlier limitation.
- Chinese/3x browser visuals, physical keyboards, complete accessibility
  navigation and actual backend password resetting remain unverified.

## Pass 303: Recover Admin Requests Beneath Another Dialog

- Send-test-email and add-member dialogs gated request completion and busy-state
  cleanup on being the current route. If another dialog covered them, success
  lost its caller result and failure left controls disabled after returning.
  Four controlled overlay regressions fail before and pass after the fix.
  Initial test synchronization waited on a running spinner and timed out;
  corrected bounded pumps establish the actual state/result failures.
- Success now closes only the owned active route, using removeRoute with its
  result when covered. Cancel still requires the current route. Failed requests
  clear busy state for mounted active dialogs even when covered, preserving
  draft and retry; disposed or already-closing dialogs remain guarded.
- All 211 admin presentation and 2908 full Flutter tests pass, with analysis,
  architecture/UI guards and production/fixture release builds. Read and add
  narrow partial audits for the two changed dialogs, kick cooldown dialog,
  gateway-scope extensions and controlled browser preview.
- Real Edge desktop email success leaves the independent overlay visible;
  closing it reveals Result: Accepted. At measured355x631, a member request
  fails while covered, returns to retained preview-member and enabled controls,
  retries, then succeeds beneath the preserved overlay and returns Result:true.
  Inspect the narrow production form and wrapped preview overlay actions.
- The preview invokes no real email or membership changes and does not model
  parent member-list reopening or notification presentation. Those ordering
  effects, every nested navigator arrangement, covered-error notification
  delivery and actual backend integration remain open. No browser-before
  regression comparison or full dialog coverage is claimed.

## Pass 304: Keep Member-List Returns Behind Active User Navigation

- Follow the Pass303 result into the production room-management parent. Its
  unconditional member-list reopening could cover an independent dialog after
  an add completed or a delayed member read returned. Two parent-level tests
  fail before because the independent overlay's close button becomes blocked.
- Check the parent route before starting a member read, after it completes and
  before following the member-dialog result. The single-open flag still resets;
  users can reopen members manually. Existing ordinary add/cancel return
  behavior remains covered and passes.
- Final 213 admin presentation and 2910 full tests pass, with analysis,
  architecture/UI guards and production/fixture release builds. Correct a
  missing fixture model import and allow the test notification timer to finish
  before the final passing runs. Separate fixture analysis also passes.
- Extend the controlled preview with the actual RoomManagementTab. Real Edge
  desktop opens members, adds through a controlled request, resolves success
  while covered and confirms the independent overlay remains on top. Closing
  it returns to rooms. At measured355x631, inspect the room card and member
  list, manually reopen members, enter add and cancel back to the member list.
- Delayed-read browser mode is built but not exercised; its route race is
  covered by the new widget regression. Same-route tab changes, notifications
  while covered, other room operations and real backend integration remain
  open. This registers only the examined member-navigation source scope.

## Pass 305: Report Provider Verification SDK Exceptions Reliably

- The standalone browser verification page handled a missing SDK but allowed
  initialization, asynchronous setup/mount and result-read exceptions to escape,
  leaving stale loading/ready feedback until the outer flow timed out. Catch
  these failures and send a readable terminal error through the existing bridge.
- A shared completion latch also preserves the first success/error, ignoring
  subsequent ready/success/error callbacks. Eight Node VM tests report three
  passes/five failures before and eight passes after. The combined 48 JavaScript
  tests and 2910 full Flutter tests pass, together with analysis, architecture/UI
  guards and production Web build. Fixture Python syntax also passes.
- Real Edge uses production HTML/CSS/JS with only a controlled SDK replacement
  and an evidence paragraph. Dark desktop init failure shows its full message
  and one received error. At measured355x631, result-read failure remains visible
  after later callbacks, with one received error. A separate successful run
  retains success after immediate error/ready callbacks and sends one result.
- Read and register partial scopes for all three standalone assets and the two
  new verification tools. No real captcha, SMS or cross-origin iframe cleanup
  is exercised. CDN hangs, original native WebView implementation, light theme,
  high zoom and screen-reader announcement remain open. Browser checks are final
  validation; the controlled VM failures establish the regression comparison.

## Pass 306: Protect Native-Generated Verification HTML Terminal State

- Extract the native verification HTML into a pure Dart generator while keeping
  its existing public export and bridge formats. Catch SDK initialization,
  asynchronous mount/setup and result-read exceptions. Preserve the first
  success/error against later callbacks and expose status as a polite live region.
- Export actual generated HTML for seven Node VM regressions: all seven fail
  before and pass after. Direct, WebKit and WebView bridge objects are simulated.
  Combined native/browser JavaScript tests pass 15 cases; all 2910 Flutter tests,
  analysis, architecture/UI guards and production Web build pass. Correct four
  interpolation lints and verify the resulting HTML is byte-identical.
- Real Edge renders the generated document with a controlled SDK. Dark desktop
  initialization failure and measured355x631 result-read failure show complete
  feedback and one error message. A successful desktop run keeps its success
  status after immediate error/ready callbacks and sends exactly one result.
- Register narrow partial source scopes for the generator, flow extraction and
  supporting tools. Actual native WebViews, bridge transport failures, live SDK,
  SMS, light theme and screen-reader behavior remain unverified. The enclosing
  native dialog's timeout/success route ownership and resource-error lifecycle
  remain follow-up work; this pass does not claim full native-flow coverage.

## Pass 307: Close Only the Owned Native Verification Route

- Trace native verification completion beyond the generated HTML. Success and
  timeout previously popped the navigator's top route, dismissing an independent
  overlay and leaving verification unresolved beneath it. Two Android widget
  regressions reproduce that visible overlay loss before the fix.
- Centralize success, timeout and cancel in an owned-route finish method. Check
  mounted/completed/active state, cancel the timer immediately and pop the current
  route or remove the covered verification route with its result. Later bridge
  messages cannot dismiss the preserved overlay or replace the delivered result.
- Six widget regressions pass across Android/iOS/macOS platform variants using
  simulated WebView controllers. Declare the already-resolved platform interface
  as a direct dev dependency for those tests. Correct test platform teardown by
  using Flutter's platform variant support; the initial full run retained those
  two test-harness failures and must not be counted as a passing run. The final
  corrected full run passes all 2916 Flutter tests. Existing hit-test warnings
  elsewhere in the suite remain separate audit work.
- Static analysis, architecture/UI guards and production Web build pass. This
  native-only route change has no new browser verification claim: Pass306 Edge
  coverage concerns generated HTML, and does not validate native route behavior.
  Actual device/WebView integration, controller setup failures, reload/error
  feedback, screen readers and native responsive layout remain open.

## Pass 308: Sequence Native Verification Setup and Recover Refresh Errors

- Native WebView setup previously launched configuration and HTML loading
  concurrently through discarded futures. Await each configuration step before
  loading, stop continuation after cancel/completion, and catch setup/load/reload
  failures as visible feedback. Refresh clears stale errors, restores loading
  feedback and retries incomplete setup; pending platform requests disable refresh.
- Resource and bridge errors now stop the loading indicator. Successful page
  completion clears it. The original overall timeout remains in effect across
  retries. Synchronous controller construction and delegate-internal callback
  registration failures are not covered by this change.
- Initial tests exposed unordered loading, an uncaught setup exception and a
  stuck resource-error spinner. Cancellation initially failed at the test locator;
  correct it to target the close icon and use standard platform variants. All
  ten focused tests pass, including six existing covered-route variants. Initial
  full testing used the broken locator and is not a passing verification run.
  The final corrected full run passes all 2920 Flutter tests.
- Analysis, architecture/UI guards and production Web build pass. No new real
  browser or native device claim is made for this native-controller change.
  Actual WebViews, late callbacks across refresh generations, subresource versus
  main-frame error policy and native narrow-screen layout remain audit gaps.

## Pass 309: Reject Invalid P2P Transfer Starts

- The transfer object accepted a negative length and allowed a second `begin`
  to overwrite the expected size. The manager already rejects negative network
  lengths; the domain check is defense in depth. Repeated starts could change
  final size validation. Existing idle and completion timeouts bound waiting.
- Invalid or repeated starts now complete the transfer with the existing format
  error path. Completed transfers ignore later starts; normal chunk and budget
  handling is unchanged. Two focused regressions cover negative and repeated
  starts, and the P2P suite passes 100 tests.
- Full Flutter tests pass 2922 items; production Web build, analysis and the
  architecture guard pass. This is protocol-level coverage; hostile peers,
  packet ordering across actual WebRTC transports and performance under load
  remain unverified.

## Pass 310: Finish Inbound P2P Transfers During Manager Disposal

- Add a final defensive completion loop for transfers remaining after transport
  and upload cleanup. The existing `_closePeer` already completes transfers for
  each peer before awaiting transport closure. A normal teardown hang was not
  reproduced, and this final loop does not establish immediate cancellation.
- Nine existing manager tests and the full 2922-test suite pass. These tests do
  not directly exercise a residual inbound transfer at the final clear. The
  previous 100-test P2P run belongs to Pass309; no separate full P2P run occurred
  here. Analysis and production Web build pass; no new architecture-guard run
  was recorded for this pass.
- Browser and actual WebRTC transport validation remain applicable future work.
  This shared manager is not native-only. Disconnect timing, teardown errors,
  pending-request completion and concurrent disposal still require direct tests.

## Pass 311: Reconcile P2P Audit Claims With Source Evidence

- Read dispose, peer cleanup, request error/finally paths and the existing manager
  tests together. Correct Pass310's unsupported immediate-cancellation and
  reproduced-hang claims, and distinguish its actual checks from Pass309 checks.
- Correct Pass309's indefinite-wait claim: existing transfer deadlines bound
  waits, and network negative lengths were already rejected by the manager.
  The two domain tests prove rejection at the transfer-object boundary only.
- Keep both source records partial. Green aggregate tests do not establish the
  untested teardown race, real browser behavior or complete protocol coverage.

## Pass 312: Make P2P Disposal Awaitable Across Concurrent Callers

- Concurrent `P2pMediaManager.dispose()` calls previously let the second caller
  return immediately while the first still awaited peer/channel shutdown. A room
  replacement could therefore continue before the old manager finished releasing
  transports.
- Share one disposal Future: the first caller owns cleanup, later callers await
  the same completion. A focused regression holds peer close, invokes dispose
  twice and proves the second call remains pending until release. Manager tests
  (10), full Flutter tests (2923), analysis and production Web build pass.
- This is a lifecycle contract test with simulated WebRTC objects. Actual device
  transport shutdown, disposal errors and cross-manager replacement remain open.

## Pass 313: Honor Mobile OAuth Authorization Timeouts

- `OAuth2CallbackService.createSession` accepted a caller-provided authorization
  timeout, but the Android `flutter_web_auth_2` session ignored it and always used
  the global default. Short-lived login flows could therefore remain blocked much
  longer than their caller contract allowed.
- Store the timeout on `_FlutterWebAuth2CallbackSession` and apply it to the
  authentication Future. Existing callback transport coverage (24 tests) passes;
  analysis also passes. Loopback and web sessions already use their supplied
  timeout and are unchanged.
- No browser run is added because this is the native plugin branch. Real Android
  plugin cancellation and OS-level activity teardown remain device validation
  gaps.

## Pass 315: Preserve Actual Cache Over-Capacity Statistics

- Revalidate Pass314 against backend slice-cache statistics: ratio_u64 divides
  current size by configured capacity without capping the ratio. The earlier
  frontend change incorrectly hid 135% usage as 100%; restore actual percentage
  text and retain the progress bar's required 0..1 bounds.
- Replace the regression that enforced information loss with assertions that
  135.0% remains visible while the bar value is 1.0. Register the previously
  missing cache-page partial audit record. This is a rendering-contract test,
  not real browser or backend maintenance evidence.

## Pass 316: Preserve Shared P2P Disposal Failures

- Exercise delayed peer-close failure as well as success. Pass312's finally
  block completed the shared future successfully even when the first caller
  received an exception. The new regression fails before the fix and checks
  that concurrent and subsequent callers all receive the original error.
- Register one completion future before cleanup starts; return it to every
  caller and forward cleanup errors with their original stack trace. All 102
  P2P tests and static analysis pass. No full-suite/build or real-browser claim
  is added for this pass. Transport failure recovery and continuing other peer
  cleanup after one failure remain separate outstanding work.

## Pass 317: Continue P2P Cleanup After a Peer Close Failure

- Two simulated peers establish the regression: when the first peer close
  throws, the second was never closed. The new test fails before the change.
- Record the first cleanup error and stack while attempting each membership
  announcement, peer closure and pending upload drain. Clear residual state
  before returning the original failure through the shared disposal future.
- All 103 P2P tests, static analysis and architecture guard pass. No new full
  suite, production build or browser/device validation is claimed. Hanging
  platform futures and multiple simultaneous transport failures remain open.

## Pass 318: Directly Verify Android OAuth Timeout Behavior

- Add a controlled MethodChannel regression for Pass313. Hold authentication
  pending, assert no completion at 19 ms and OAuth2AuthorizationTimedOut at the
  configured 20 ms, then deliver a late successful callback and assert one
  unchanged timeout result. The test passes with a test callback origin define.
- Run with `flutter test --dart-define=SYNCTV_OAUTH2_APP_LINK_ORIGIN=https://example.test test/features/auth/infrastructure/oauth2_android_timeout_test.dart`.
  Without an origin define this native-configuration test explicitly skips.
  Static analysis passes after correcting the test's skip argument and import.
- This adds direct coverage missing from the earlier 24 transport tests. It
  does not prove OS window cancellation, plugin cleanup or real Android behavior.

## Pass 319: Recheck Served Home and Authentication Layout in Edge

- Open the existing production preview in real Edge. Desktop renders the SyncTV
  header, search/category controls and four featured room covers/cards. At a
  measured 355x631 viewport, inspect the responsive header and horizontal room
  rail with its deliberate next-card preview.
- A coordinate click intended for the rail arrow actually activates a room card
  and opens authentication. Inspect the resulting narrow login dialog: identifier
  field, continue button and wrapped agreement text are visible without overlap.
  Do not count this as a successful rail-navigation check.
- The accessibility enable click did not expose a semantic control tree in this
  run. Keyboard/screen-reader behavior remains unverified. This checks the served
  build only; it does not prove that recent source changes are included, and no
  login, backend mutation or all-page coverage is claimed.

## Pass 320: Register Engine Creation Before Synchronous Reentry

- A creation callback can synchronously call acquire again before the original
  pending future is assigned. The new regression reproduces two engine creations
  and different results for those callers.
- Register a completion future before invoking creation and forward its result
  or failure to all callers. All nine owner tests and analysis pass, including
  failure retry, superseded creation and late disposal. No new browser/device
  or full-suite/build claim is made for this pass.

## Pass 321: Verify Combined Changes and Run Android Timeout in CI

- Add an explicit CI step for the Android OAuth timeout regression with the
  test callback-origin define. The ordinary suite skips this configuration-bound
  test; the separate local invocation passes, and actionlint validates the step.
- Current full Flutter run passes 2927 tests with one skip. The separately
  configured Android regression passes. Analysis, architecture/UI guards and
  production Web build pass. Real Edge renders the served desktop home with
  room covers and controls after the build; no interaction or cache-version
  equivalence claim is inferred from that screenshot.
- Repository-wide format check fails on room_settings_page.dart,
  chat_context_menu_popup.dart, live_form_label_layout_test.dart and
  youtube_preview_commands_test.dart. It also reports package-resolution
  warnings in nested packages. The check used output=none and changed no files;
  these remain open formatting checks, not a green CI claim.

## Pass 322: Resolve the Repository Formatting Gate

- Apply the configured Dart formatter to the four files identified in Pass321:
  room settings, chat context popup, live-form label layout tests and YouTube
  preview command tests. Update the two runtime audit fingerprints while
  retaining their existing partial scopes.
- Repeat the complete CI format command across lib, test, tool and packages:
  901 files checked, zero changes, exit success. Nested-package resolution
  warnings remain diagnostic output. No behavioral or browser coverage is
  inferred from this formatting-only maintenance.

## Pass 323: Keep Provider Verification Regressions Active in CI

- Add a CI step that exports actual native verification HTML with the production
  Dart generator into runner temporary storage, then runs both provider JS suites
  against their real sources. The native tests receive GEETEST_NATIVE_HTML via
  the step environment, preserving the required generation-before-test order.
- Locally execute the same generation and Node test commands: all 15 tests pass,
  none skip. actionlint validates the updated workflow. These controlled SDK and
  bridge tests supplement prior browser observations; they do not establish live
  provider integration or successful execution on a remote CI runner.

## Pass 324: Deliver Invalid Transfer Errors to Their Caller

- Reproduce uncaught errors when a P2P transfer fails while wait is awaiting
  activity, and when failure precedes a delayed wait subscription. Both added
  regressions fail before the fix; the internal result Future had no error
  subscriber in either case.
- Retain the failure and its stack on the transfer, then throw it through wait.
  Length mismatches use the same path, preserving the caller's FormatException
  contract without an unobserved internal error Future.
- All 106 P2P tests, analysis and architecture guard pass. This pass adds no
  real WebRTC, browser, full-suite or production-build evidence.

## Pass 325: Prevent Duplicate Administrative Stream Disconnects

- A new widget regression reproduces two requests from repeated activation of
  the same disconnect action. Track pending room/media pairs matching the API
  request, disable matching actions, and keep the guard through the list refresh.
  Failure restores retry; refreshed model instances retain the pending state.
- Add a defensive mounted check after ban-record confirmation before accessing
  its context-backed gateway. This small consistency fix has no independent
  before/after lifecycle reproduction.
- All 215 admin tests, analysis and architecture/UI guards pass. After adding
  the refreshed-model assertion, all 31 secondary-list tests pass again.
- The subsequent release Web build passes and the existing preview responds
  with HTTP 200. Wasm dry-run warnings remain, including video-player JS
  interop runtime type checks; this does not establish Wasm compatibility.
- Real Edge inspects the served desktop home and opens its language sheet.
  Desktop and measured 355x631 screenshots show readable options and close
  controls without overlap; a later click dismisses the sheet. No successful
  language change, reader accessibility or administrative browser interaction
  is inferred. The served build predates this pass's administrative changes.

## Pass 326: Guard the Full Unban Interaction

- Reproduce two stacked confirmation dialogs from rapid activation. Track
  pending operations by target type and target ID from confirmation through
  request completion and list refresh. Cancellation and failure restore retry.
- Add user and room regressions covering duplicate activation, cancel, pending
  requests, failure, retry and refresh protection. All 217 admin tests, analysis,
  architecture/UI guards and separate preview analysis pass.
- Extend the existing overlay preview with a controlled ban-record route.
  Its release Web build passes. Real Edge verifies desktop confirmation,
  controlled failure and reopening. At measured 355x631, confirm the retry,
  resolve success and return to a record showing Ended without an unban button.
  Confirmation text, actions and record content have no visible overlap.
- Browser requests use a fake gateway with explicit completion controls, not
  real moderation endpoints. Full filter/pagination semantics, cross-record
  target collisions and physical-device accessibility remain separate checks.
- The production release Web build also passes; the existing preview responds
  with HTTP 200. Audit inventory and diff whitespace checks pass. No full-suite
  run or new Wasm compatibility claim is made for this pass.

## Pass 327: Reject Misleading Ban Search Filters

- Compare the UI with backend optional user/room ID parsing. Arbitrary text
  produced a visible filter chip but sent empty ID conditions, querying all
  records under the other filters. A regression reproduces the extra request.
- Reject unrecognized and bare prefixes with the existing localized ID-format
  hint while preserving the last applied filter. Continue trimming supported
  ID input and allow clearing; final encoding validation remains server-owned.
- All 34 secondary-list tests pass, covering preserved records/chip and request
  arguments for user, room and cleared filters. Analysis and architecture/UI
  guards pass. This pass adds no browser interaction evidence; Pass326's
  controlled browser moderation evidence remains limited to its stated scope.
- Production release Web build, audit inventory and diff whitespace checks
  pass. No full-suite run or new Wasm compatibility claim is made.

## Pass 328: Recover Out-of-Range Administrative Pages

- Ban, stream and review lists could remain on page two after their total fell
  below one page. Three regressions reproduce requests ending at page two.
- After checking that a response is current, calculate the last valid page and
  reload it when necessary. Corrections strictly decrease the page and preserve
  the existing generation guard against stale results.
- All 221 admin tests pass before expanding the boundary cases; the final 40
  secondary-list tests include six recovery cases for zero and 50 remaining
  records. No new browser or full-suite run is claimed for this pass.
- Analysis, architecture/UI guards, production release Web build, audit
  inventory and diff whitespace checks pass. An unused test import reported
  by the first analysis was removed before the successful rerun.

## Pass 329: Verify Combined Changes and Adopt the WebRTC Hotfix

- Before changing dependencies, the combined Flutter suite passes 2939 tests
  with one configuration-dependent skip. The complete format check reports
  901 files with zero changes; nested-package resolution warnings remain.
- Current pub.dev metadata identifies WebRTC 1.6.2+hotfix.1 and OAuth
  6.0.0-alpha.8. Inspect downloaded package source differences: WebRTC moves
  device-change registration until after initialization, guards Android camera
  names before dereference, and releases Darwin event handlers on disposal.
  Its Dart sources are unchanged. Raise the WebRTC constraint and lockfile;
  dependency resolution reports exactly one changed package.
- Keep OAuth at the locked alpha.7: alpha.8's stated change migrates to
  material_ui and introduces UI dependencies, without an identified application
  requirement for that migration. Other outdated packages remain constrained
  transitively; no forced dependency overrides are introduced.
- After the WebRTC update, all 150 P2P/voice tests and analysis pass. These tests
  do not establish native crash or resource-lifetime fixes on physical devices.
  Windows/Linux initialization, Android capture and Darwin disposal still need
  their respective native integration checks. No post-upgrade full-suite or
  new browser interaction result is claimed here.
- Post-upgrade production Web build and audit inventory check pass. Normalize
  the changed dependency line's inherited CRLF to satisfy diff whitespace
  validation without rewriting the rest of the mixed-ending manifest.

## Pass 330: Exclude Conflicting Review Decisions

- Reproduce duplicate approval requests from repeated activation. Add a shared
  kind/ID pending set to approval and rejection, including the rejection dialog
  and post-success refresh. Cancel and failure restore both actions.
- Preserve delayed controller disposal after dialog closure and dispose the
  controller directly if its dialog content was never built.
- All 225 admin tests and analysis pass. The final expanded decision regression
  includes rejection submission; all 41 secondary-list tests pass. It verifies
  duplicate suppression, approval failure recovery, conflicting approval during
  rejection confirmation, cancellation and refresh protection.
- No new browser, native-device, cross-client moderation or full-suite evidence
  is claimed for this pass.
- Audit inventory, architecture/UI guards and diff whitespace validation pass;
  the prior production Web build remains the latest build evidence.

- Architecture/UI guards, production release Web build, audit inventory and
  diff whitespace validation also pass.

## Pass 331: Verify Pagination Recovery in Real Edge

- Extend the existing admin preview with shrink=1: an initial total of 51 drops
  to zero when requesting a later page. Production ban-list logic drives the
  corrective load; fixture data replaces backend calls.
- Real Edge desktop and measured 355x631 each start with Page 1, 51 total,
  activate Next page and return to Page 1, 0 total, No ban records. Inspect
  screenshots before and after: filters, pager, record and empty-state content
  remain readable without overlap.
- Preview analysis and release Web build pass. This adds browser evidence for
  the ban-list zero-total case only; stream/review pagination, nonzero residual
  data, live server changes and failed corrective requests remain unverified in
  the browser. Production code is unchanged during this pass.

## Pass 332: Keep the Source Audit Inventory Current in CI

- The quality job ran inventory unit tests indirectly through flutter test but
  never compared the repository inventory with its current source and ledger.
  Add the existing --check command after formatting so stale inventories fail
  CI instead of silently retaining outdated counts or fingerprints.
- Local inventory checking, all three inventory unit tests, actionlint and
  diff whitespace validation pass. Tests cover source discovery/exclusions,
  changed fingerprints, newly unreviewed files, missing evidence and orphaned
  ledger entries.
- The gate checks truthful synchronization, not audit completion: regenerated
  partial, unreviewed and needs-review states remain visible. No remote CI run,
  full application suite or browser verification is claimed for this CI-only
  change.

## Pass 333: Recover Provider and Administrator Pagination

- Extend the pagination audit to provider instances and administrators. Their
  parallel auxiliary-data reads had generation protection, but neither list
  corrected its page after the total shrank. Four added regressions fail before
  the change while the existing six pagination cases pass.
- After validating the latest response, reload the last valid page using each
  list's current page size. Cover zero and one remaining page for providers at
  50 items and administrators at 20 items. All 229 admin tests and analysis pass.
- Register narrow partial source records for both files, preserving outstanding
  editor, deletion, permission and concurrency audits. No real browser checks
  for these two pages or complete audit claim is inferred from this change.
- Architecture/UI guards, production release Web build, audit inventory and
  diff whitespace validation pass. No full-suite run is claimed for this pass.

## Pass 334: Stop Administrator Dialog Chains After Disposal

- A regression removes the administrators tab while its mode dialog remains
  open, then returns the existing-user mode. Before the fix this throws from
  State.context when opening the promotion dialog. The initial test locator
  targeted nonexistent visible text; after targeting the actual icon button,
  the pre-fix run reproduces the lifecycle assertion.
- Check mounted before branching on the selected mode. Add consistent mounted
  checks after create, promote and remove confirmations as defensive guards;
  those three guards have no independent before/after failure reproduction.
- All 230 admin tests and analysis pass. No browser lifecycle, complete
  administrator mutation audit or full-suite evidence is claimed here.
- Architecture/UI guards, production release Web build, audit inventory and
  diff whitespace validation pass.

## Pass 335: Scope Administrator Mode Actions to Their Dialog

- A retained promotion-mode callback invoked after opening the next dialog
  tries to pop that bool route with a String result, triggering a navigator
  type assertion. The new regression reproduces this before the fix.
- Resolve the button's own dialog context through Builder and require it to
  remain mounted and current before popping. The next promotion dialog now
  survives the stale callback. All 47 secondary-list tests pass.
- This is a controlled callback regression, not a browser double-click or
  physical-input reproduction. Full administrator workflow and browser checks
  remain incomplete.

- Analysis, architecture/UI guards, production Web build, inventory and diff
  whitespace checks pass. The initial missing-braces lint was corrected before
  the successful analysis rerun. No full-suite run is claimed for this pass.

## Pass 336: Verify Audit Gate Exit Status

- Inspect checkout line endings and the Linux quality runner; no demonstrated
  CI mismatch justifies changing the byte-based fingerprint contract.
- Add a temporary-directory regression invoking the actual inventory main
  entry point. Missing inventory and newly added source yield exit code 1;
  regeneration followed by checking yields success. Restore process directory
  and exit status in finally so the test cannot contaminate later checks.
- All four inventory tests and focused analysis pass. This directly exercises
  command-entry exit status in-process, not a remote CI runner or child-process
  invocation. No production behavior or browser coverage is added.

## Pass 337: Guard Provider Enable Requests

- Repeated switch activation sent identical enable commands while the row
  still held its previous enabled value. A regression reproduces two pending
  requests before the fix.
- Track toggles by instance name, disable the matching switch and await list
  refresh before releasing the guard. Failure restores retry. All 232 admin
  tests and analysis pass, including pending, failure and refresh states.
- This guards switch requests only. Coordination with editing, deletion and
  reconnecting, real browser toggle behavior and actual endpoint effects remain
  separate audits. No full-suite or new browser run is claimed here.
- Architecture/UI guards, production release Web build, audit inventory and
  diff whitespace validation pass.

## Pass 338: Coordinate Provider Instance Operations

- Extend the existing name-keyed pending state across edit, delete, reconnect
  and enable operations. Disable all row actions until the dialog, request and
  refresh finish; cancellation/failure release the state in finally.
- Before the fix a strengthened toggle test finds edit still enabled. After
  the fix, retained callbacks cannot start edit/reconnect/toggle during delete
  confirmation, cancelling restores actions, and reconnect failure releases
  the guard. All 233 admin tests and analysis pass.
- Successful edit/delete submission, new-instance name collisions, browser
  operation checks and actual backend concurrency remain separate verification
  tasks. No full-suite or new browser evidence is claimed for this pass.
- Architecture/UI guards, production release Web build, audit inventory and
  diff whitespace checks pass.

## Pass 339: Verify Provider Delete Completion and Retry

- Extend the existing provider operation regression beyond dialog cancellation:
  confirm deletion, assert the instance name, reject the request, retry, resolve
  success and provide the refreshed list. The row stays disabled until refresh;
  the original record disappears and the remaining row is actionable.
- All 49 secondary-list tests and focused analysis pass. Production code is
  unchanged. These controlled gateway responses supplement Pass338 operation
  coverage without establishing real backend deletion, browser behavior or
  complete successful-edit coverage.

## Pass 340: Guard Server Removal and Inspect Connection Adapters

- Unlike add/activate, removal lacked a busy entry guard. A retained callback
  regression reproduces two concurrent gateway calls; check mounted/busy before
  removal. All 10 server-settings tests pass, including failure and retry.
- Inspect connection contract/adapter mappings and record their narrow source
  scope: six profile fields, nullable active server and refresh/TLS forwarding.
  Service session transitions, persistence and live transport remain separate.
- Analysis and architecture guard pass. This pass provides no new browser,
  real server removal or full-suite evidence.
- UI guard, production release Web build, inventory and diff whitespace checks
  also pass.

## Pass 341: Verify Combined VM and Browser Runtime Regressions

- With the WebRTC hotfix and recent management/server fixes in place, the full
  Flutter suite passes 2950 tests with one configuration-dependent skip. The
  separate Android OAuth timeout test with its callback-origin define passes.
- Run the CI-selected permission-bit, P2P lifecycle and OAuth callback-isolation
  suites on the Chrome platform: all 52 tests pass. These are browser runtime
  tests, not visual inspection or live provider/device integrations.
- All 57 bootstrap/service-worker/P2P bridge JS tests pass. Export current
  native verification HTML and run both provider JS suites: all 15 pass.
- Repository formatting checks 901 files with zero changes. Nested-package
  resolution warnings remain. Inventory and diff whitespace checks pass.
  Production code is unchanged this pass; no new build, screenshot, physical
  device or complete audit claim is inferred from the combined verification.

## Pass 342: Verify Provider Edit Completion

- Add a controlled editor regression covering endpoint trimming, instance name,
  sorted provider arguments and typed update result. The edit action remains
  disabled through the update and replacement-list refresh, then becomes
  actionable again.
- All 50 secondary-list tests and focused analysis pass. The first run exposed
  only a test double returning Future<void> for an API that returns an instance;
  the corrected typed double passes without production changes.
- Real backend persistence, every editor validation branch, and browser visual
  editor interaction remain unverified. No full-suite or new browser evidence
  is claimed for this pass.

## Pass 343: Server Activation Failure Recovery

The server settings audit now covers activation failure recovery: a rejected
server switch releases the dialog busy lock so a later switch can be retried.
The controlled gateway test checks the rebuilt button is enabled, executes
a second switch, records both attempted endpoints, and checks metadata refresh.
It consumes the error notification timer. All 11 server-settings tests pass.
Real Edge inspection of the existing Web preview covers desktop server metadata
and a measured 400x711 viewport: the long server ID and explanatory text wrap,
and Done closes the sheet. This preview was not rebuilt in this test-only pass.
The accessibility tree still exposes only Enable accessibility; this is not
screen-reader evidence. Real backend activation, native server management and
persistence remain unverified.

## Pass 344: Preserve Decimal Notification IDs

Notification IDs now remain decimal strings across account contracts, gateway
calls, selection state, details, read, and delete operations. Conversion to
protobuf Int64 happens only at the transport boundary after strict decimal
range validation, preventing Web JavaScript number rounding. Boundary tests
cover adjacent IDs above 2^53, the signed int64 maximum, duplicate and invalid
values; account component tests cover newer selection preservation. The API
regression suite and release Web build pass. The focused Chrome account test
initially exposed a fixture import outside the test bundle; the fixture was
moved into test/support and the tool path now re-exports it. The full native
suite passes 2955 tests with one skip; no backend notification mutation was sent.

## Pass 345: Restore Chrome Account Selection Regression

After fixture packaging was corrected, the Chrome account test remained in
setUpAll while loading fonts. Skip this native font setup on Web, which also
avoids the following SDK filesystem lookup. Native layout checks retain their
explicit CJK/Roboto setup. Both targeted selection success/failure tests now
pass in Chrome, preserving distinct adjacent large notification IDs and newer
selection. This verifies component state, not font accuracy or complete Web
account layouts. File-specific notification audit records now include this
evidence; other methods in these broad modules remain partial.

## Pass 346: Preserve Newer Moderation Snapshots

The administrator chat cache accepted every arriving history snapshot, even
when a higher-version deletion response or edit was already recorded. It now
rejects lower-version snapshots, preserving the latest confirmed state both
for display and after optimistic rollback. Two regressions fail before and
pass after the fix. Four added cases cover confirmed deletion, rollback,
overlapping intentions and refresh retention; all six state tests pass in
Chrome, and all 238 administrator tests pass natively. Focused analysis,
architecture/UI guards, inventory checks and the release Web build pass.
Equal-version snapshots
can still refresh ancillary data. Bulk-intent retirement, actual backend
ordering and real-browser dialog race reproduction remain unverified.

## Pass 347: Refresh Accepted Moderation Overlays

The Rust moderation endpoint inserts an asynchronous job and returns an empty
response; successful submission does not prove deletion has completed. The
frontend previously retained every successful optimistic intention even after
explicit refresh, masking server state indefinitely. Accepted intentions now
retire on refresh while unresolved submissions remain projected. A late accept
callback cannot recreate a discarded intention. Eight helper tests pass in
Chrome and 240 administrator tests pass natively; focused analysis passes.
This introduces no polling or claim of worker completion. Automatic
reconciliation, job failure presentation and real-browser race reproduction
remain open.

## Pass 348: Verify Moderation Refresh Wiring And Correct Stale Evidence

The existing production chat-dialog widget fixture now covers accepted
submission followed by explicit refresh: the optimistic deleted state appears,
then server content reappears after a second history request. Failure recovery
and stale pagination success/error controls remain covered. The fixture now
counts every history call, including ordinary mode. All four widget cases
pass natively and in Chrome; focused analysis passes. The shared-admin
record's destructive progress warning was stale:
Pass246 had resolved it, and all 24 loading-button checks pass again, including
light/dark destructive contrast. No new production button change was needed.
Actual backend job execution and complete browser/reader coverage remain open.

## Pass 349: Bound Pending Realtime Connection Cleanup

Closing a realtime connection before socket setup awaited an unlistened
outgoing queue's close Future indefinitely, preventing the socket timeout
from running. Stream cancellation had the same problem and no setup timeout.
Both paths now signal queue closure without waiting for event consumption,
then wait for socket setup within the existing two-second bound. Late sockets
close themselves; late sends to a closed queue are ignored. Two controlled-clock
tests fail before and pass after natively and in Chrome. Setup-error handling
and local real-WebSocket initial observations also pass. All 40 room-data tests,
focused analysis, architecture/UI guards, inventory checks and the release
Web build pass. These checks do not
cover paused subscriptions, every remote-close path or actual browser races.

## Pass 350: Stop Heartbeats On Remote Completion

A paused incoming subscriber delayed its stream completion and cancellation
callback, leaving the heartbeat timer alive after the socket had completed.
Socket completion now cancels the timer and closes outgoing immediately,
independent of incoming event consumption. The controlled-clock regression
fails before and passes after, including a 30-second advance with no outgoing
heartbeat. All 41 room-data tests and three Chrome lifecycle tests pass;
focused analysis, architecture/UI guards, inventory checks and the release Web
build pass. Actual browser transport teardown and queued-send
races remain unverified.

## Pass 351: Propagate Outgoing Realtime Failures

Exceptions in outgoing encoding, instrumentation or socket.send escaped the
stream listener into the zone instead of reaching the connection error stream
used by RoomScreen to schedule reconnection. The outgoing listener now catches
these failures, reports their original error/stack and closes the connection.
Already queued messages are ignored after closure, avoiding duplicate failures.
Three regression cases fail before and pass after; all 44 room-data tests and
six Chrome lifecycle tests pass. Focused analysis passes. The tests verify
error delivery, socket closure and stopped heartbeats; actual browser network
failure and end-to-end successful reconnection remain unverified.

## Pass 352: Close On Malformed Realtime Frames

Malformed incoming JSON/protobuf frames were reported to the stream while the
socket and heartbeat remained active, allowing a bad transport to continue
producing failures. The first decode error now reports through the existing
stream, closes the connection and stops the heartbeat. A controlled regression
fails before and passes after; all 45 room-data tests and seven Chrome
lifecycle tests pass. Focused analysis and the release Web build pass. Actual
browser malformed-frame transport and full reconnect completion remain
unverified.

## Pass 353: Make Realtime Close Idempotent

Concurrent user disposal, malformed-frame handling, outgoing failures and late
socket setup could each call the underlying socket close operation. A shared
one-shot close gate now covers all paths, including late connection completion,
so reconnection does not see duplicate teardown side effects. The regression
initially observed two closes and passes after the fix. Eight room-data lifecycle
tests pass natively and in Chrome; focused analysis and the release Web build
pass. Actual network teardown remains unverified.

## Pass 354: Suppress Queued Events After Transport Failure

The previous single-frame regression did not establish suppression of further
bad frames. With two queued frames it fails; a second new case also shows that
socket-stream errors leave transport resources active. A shared failTransport
handler now reports the first failure and initiates close, and the frame
listener skips data once the outgoing queue is closed. Queued data/errors
cannot produce additional decoding or repeated errors. Nine lifecycle tests
pass natively and in Chrome, with all 47 room-data tests and focused analysis
passing. Corrected Pass353's test count from nine to eight. Actual browser
network failures and successful full reconnection remain unverified.
Architecture/UI guards, inventory validation and the release Web build pass.

## Pass 355: Share Realtime Teardown Completion

The one-shot boolean gates prevented duplicate socket calls but let concurrent
close callers finish before teardown completed. This also affected a close
started during connection setup when late-socket cleanup won the race.
Connection and socket cleanup now cache their completion Futures, retaining
the existing bounded waits. Two delayed-close regressions fail before and
pass after; both callers complete only after the controlled socket teardown.
All 49 room-data tests, eleven Chrome lifecycle tests and focused analysis pass.
Real browser teardown and complete synchronous callback reentrancy remain open.
Release Web build, UI guard and inventory checks pass. Architecture guard's
first launch failed inside Dart's macOS native-asset install-name parser;
an isolated rerun passes.

## Pass 356: Normalize Realtime Setup Failures

A synchronous ticket callback exception escaped connect before a channel was
returned, unlike the existing asynchronous ticket failure contract. Future.sync
now preserves synchronous invocation while delivering failure through ready
and the incoming stream. Setup failure also closes outgoing immediately without
awaiting consumption of the incoming completion event. The new callback test
fails before and passes after; all 50 room-data tests, twelve Chrome lifecycle
tests and focused analysis pass. This is interface hardening, not evidence of
a synchronous failure in the current Rust ticket endpoint. Actual browser
setup failures and every paused/unlistened-stream combination remain open.
Release Web build, architecture/UI guards, inventory validation and diff checks
pass.

## Pass 357: Browser Authentication And Server Layout Smoke Check

Real Edge reloaded the existing local preview. Desktop screenshots show loaded
room artwork, search/category controls and the login form. After the entrance
animation settled, switching to registration displayed its username field and
full-width action. At a measured 355x631 CSS viewport, registration and guest
tabs display their fields, complete primary labels and wrapping agreement text.
Closing the guest dialog returns to the room list. Server information at that
width wraps the long ID and explanatory text; its Done control was exercised.
The temporary viewport override was reset.

No credentials, agreement acceptance or authentication submission was performed.
The accessibility tree still exposed only Enable accessibility, so these visual
checks do not prove screen-reader behavior. No new production code changed.
The existing served preview was inspected; its assets were not fingerprinted
against the latest build, and this is not realtime teardown/reconnect evidence.

## Pass 358: Verify Served Build And Browser Semantics

HTTP reads of main.dart.js, flutter_bootstrap.js and index.html match the
current release output byte-for-byte by SHA-256. The served main.dart.js hash
is 2eb6716d16e0ff78f589caf3a8e7ac88145b5b7a0448627e90d9a299392d0774.
This verifies server output, not independently the browser's cached asset bytes.
The active Edge session returned no captured warning/error logs.

Activating Enable accessibility through its AX button successfully exposes the
home controls, search field, selected categories and full room descriptions.
The login dialog exposes named controls, selected tabs and unchecked agreement.
AX actions switch registration and guest tabs; at the narrow viewport from
Pass357 the registration screenshot remains readable. During transitions the
old form briefly appears in the tree; after animation it disappears. Guest
room input and submit remain named, and AX close returns to the page. The
temporary viewport override is reset. This supersedes the current-session
inability to expand semantics reported in Pass357, but does not prove native
screen-reader announcements, keyboard traversal or complete authentication.
No credentials or agreements were submitted, and no production code changed.

## Pass 359: Real Browser Authentication Keyboard Traversal

With Edge semantics enabled, opening Login and pressing Tab focuses Close;
the next Tab focuses the selected Login tab. Right Arrow did not change focus
or selection. Tab followed by Enter activates Registration and updates its
selected semantic state. Escape closes the dialog and restores focus to the
home Login button, as observed in the AX tree. Source inspection confirms this
uses AppTabBar backed by Flutter TabBar.

This verifies the observed desktop Tab/Enter/Escape path, not a complete focus
loop, mobile keyboard behavior or screen-reader announcements. Directional
tab navigation remains an explicit follow-up requiring framework and shared
shortcut review. No account data was entered or submitted, and no production
code changed.

## Pass 360: Shared Tab Keyboard Navigation

AppTabBar now locally maps horizontal arrow keys to Flutter directional focus
intents. Web defaults previously interpreted these keys as scrolling, leaving
authentication tab focus unchanged. Selection remains explicit through Enter.
The mapping follows physical direction in both LTR and RTL layouts and does
not wrap the surrounding form in shortcuts.

Four focused cases cover both directions and fixed/scrollable tabs, focus
movement, Enter activation, reverse navigation and external input focus.
All four pass on VM and Chrome; 228 shared-widget/room-tab tests, targeted
analysis, architecture/UI guards and release build pass. Browser-native cursor
editing is not asserted by synthetic Chrome widget keys: real Edge input of
abc followed by Left produces selection offset 2 without changing the tab.

Edge on the rebuilt preview verifies Login -> Right -> Registration focus,
Enter activation and Left/Enter return. Desktop and narrow login screenshots
show readable controls and wrapped agreement links. Test input was cleared,
the dialog dismissed and viewport restored; no agreement or form submission
occurred. No captured browser warning/error logs were returned. Strict modal
focus cycling remains unproven: earlier Tab traversal included unnamed or
container transitions. This pass does not establish every tab consumer,
screen-reader, device or external integration state as complete.

## Pass 361: Checkbox Tile Focus And State Share One Node

Real Edge inspection exposed AppCheckboxTile keyboard focus on a nested text
group while its named checkbox state lived on an ancestor. Move checked,
enabled, label and tap semantics inside InkWell so they merge with its focus
semantics. Interactive title links remain independent children. A regression
requiring one named, focused unchecked node fails before and passes afterward.
Keyboard Space toggles once, Tab/Enter activates the nested link without
toggling, and disabled tiles preserve independently focusable links while
exposing checked/disabled state without a tap action.

298 shared-widget/authentication tests and two focused Chrome cases pass.
The full suite passes 2979 tests with one skip; targeted analysis, architecture
and UI guards, formatting and release build pass. Edge after rebuilding shows
the active element with role=checkbox, its agreement label and
aria-checked=false. Tab focuses the agreement link; Enter opens its details
and Escape restores that link. Desktop agreement and narrow login screenshots
are readable; Shift+Tab on narrow layout focuses the named checkbox and shows
its visual focus highlight. No agreement was accepted or form submitted.
Viewport was restored and login dismissed; captured warning/error logs were
empty. Actual screen-reader announcements, exhaustive tile consumers and the
previously noted modal focus-loop limitations remain unverified.

## Pass 362: Labeled Toggle Focus Stops

Labeled AppSwitch and AppCheckbox controls previously exposed both their native
control and wrapping InkWell as keyboard focus candidates. The wrapper now
keeps pointer row activation while opting out of focus, leaving one keyboard
stop and one state change per toggle. VM and Chrome cases cover Space,
forward/reverse traversal and activation after focus leaves the control. An
Edge showcase confirms switch -> checkbox -> Next, single changes, semantic
roles and a narrow 320px layout with visible focus rings.

229 shared-widget tests, focused Chrome tests, analysis, architecture/UI
guards and the release build pass. Native assistive technologies and every
consumer page remain outside this focused control verification.

## Pass 367: Language Sheet Scrolling And Radio Semantics

The language sheet now scrolls under short-window/large-text constraints.
A 320x300, 3x regression failed with a 1682px RenderFlex overflow before the
fix and now reveals the English option. Language options merge named checked,
enabled and mutually-exclusive semantics with their existing tap/focus nodes.
The initial missing-name suspicion was disproven by a baseline test; no
explicit duplicate label was retained. Ordinary selected-button semantics did
not expose selection in Edge, so the final options use radio semantics.

18 localization tests and seven Chrome sheet tests pass, together with targeted
analysis, architecture/UI guards and release build. Final selected/unselected
state assertions pass. Real Edge verifies three radio options with Simplified
Chinese checked; short-window scrolling reveals the bottom options, and desktop
layout remains readable. No preference was changed. Viewport restored; no
captured warnings/errors. Physical screen readers and all scale/device
combinations remain unverified. Duplicate Pass 362 documentation was removed.

## Page Coverage

## Pass 370: Search Submission Normalization

AppSearchField now trims leading and trailing whitespace at the submission
boundary while preserving the controller's original text and raw onChanged
updates. This prevents whitespace-only or padded queries from reaching
consumers that do not normalize themselves. VM and Chrome tests cover clear,
ordinary submission and padded submission; targeted analysis passes.

## Pass 368: Agreement Content Replacement Reset

UserAgreementDialog now resets its read-to-end gate and scroll position when
agreementContent changes. A before-failing regression replaces a completed
short/long agreement, verifies the new long content requires reading again,
then replaces it with short content. Six VM and six Chrome dialog tests pass;
targeted analysis and formatting pass. Native back navigation and external
content sources remain outside this focused check.

The goal includes the widest practical page and component coverage. Existing
tests cover provider-specific forms and platform services; real browser checks
exercise the shared application and reachable local workflows.

Pass 371: audited `AppTile`, the shared list-row primitive. Confirmed enabled
rows expose tap semantics and can receive focus; disabled rows expose neither
tap action nor enabled state and reject focus. Added a focused widget regression
test; the targeted test passes.

Pass 372: audited the shared `AppDialog` and `AppDialogFrame` constraints and
their layout coverage. Existing tests exercise 320px phone surfaces, keyboard
insets, 1.5x text scaling, long content scrolling, action hit testing and wide
desktop dialogs. No additional production change was justified; business
dialogs and third-party/native flows remain separate coverage.

Pass 373: reran the room realtime connection lifecycle and transport suites
after the shared close/error handling changes. All 15 focused tests pass,
including synchronous ticket failures, malformed frames, single-close gating,
heartbeat shutdown and setup error reporting. Live backend transport,
decoder reentrancy and adverse-network behavior remain unverified.

Pass 374: full-suite replay exposed a brittle `AppTile` semantics assertion
that depended on `SemanticsFlags` collection equality. Replaced it with the
stable semantics bitmask check; the focused regression now passes without
deprecation warnings. The earlier full-suite result was therefore a test
harness failure, not a production regression.

Pass 375: completed the full Flutter test run after the assertion fix. All
`2987` tests passed with one expected skip; no failure or exception output was
reported. This validates the current worktree across the automated test
surface, while browser, native-device and external-integration limits remain
as documented.

Pass 376: rechecked the running Web preview in real Edge at desktop size.
Screenshot and accessibility tree confirm the home search, category filters,
authentication/server controls and featured room cards render without visible
overlap; controls expose expected labels, roles and selected states. Mobile
and deeper business routes remain separately tracked.

Pass 377: upgraded the direct `flutter_web_auth_2` dependency from
`6.0.0-alpha.7` to `6.0.0-alpha.8`. The auth and platform test suites pass
(`113` tests, one expected skip); larger available upgrades remain constrained
by the current Flutter/dependency graph.

Pass 378: built the Web release after the dependency upgrade. `flutter build
web --release` completed and generated `build/web`; existing JS interop lint
warnings in the media-kit web package and informational wasm flags remain
unchanged and do not block the build.

Pass 379: removed platform-unstable `error is JSObject` checks from the Web
video playback controller and used the SDK's `Object?.isA<DOMException>()`
interop check. Analysis passes; playback mount/recovery coverage passes all 12
Chrome scenarios, including AbortError retry, cancellation, disposal and
permission failures.

Pass 380: simplified Web engine error-message deduplication to a set literal,
removing an unnecessary intermediate list allocation. Package analysis now
reports no issues; the audit hash and generated inventory are updated.

Pass 381: ran full static analysis across `lib` and all local `packages` after
the Web playback changes. The analyzer reports no issues.

Pass 382: rebuilt the Web release with the explicit `flutter_web_auth_2`
alpha.8 constraint. `flutter build web --release` completed successfully and
generated the production Web bundle.

Pass 383: reran the UI guard and architecture guard after dependency and Web
runtime changes. Both guards pass with the current worktree.

Pass 384: reviewed all remaining anonymous exception catches in the shared
player, persistence and local-image flows. Each catch either preserves base
playback, rolls back and rethrows, or handles disposal safely; no swallowed
business error was found and no production change was warranted.

Pass 385: ran the complete media-kit package test suite. All 17 tests pass,
covering Web transport selection, HLS variant parsing, cancellable media open
and disposal, adaptive tracks, error delivery and picture-in-picture routing.

Pass 386: reran the `AppTile` enabled/disabled focus and semantics regression
after dependency resolution. The test passes with the explicit auth alpha.8
constraint in effect.

Pass 387: attempted an additional real-Edge language-dialog activation. The
current CUA adapter exposes AX state and screenshots but rejected both node-ID
and tree-index click forms; no interaction result was recorded. Existing
language-dialog browser evidence remains authoritative, and this adapter limit
is documented as an unverified edge rather than treated as a pass.

Pass 388: began the dedicated test-environment browser/macOS functional sweep.
The real macOS app was inspected at its current window size: home controls,
featured-room rail, create-room dialog, form fields, category/tags, visibility,
password options and actions were reachable. A test room was created through
the live backend and opened successfully; the room page rendered playback
waiting state, collaboration tabs, playlist/member/realtime actions, invite
sharing and voice-chat join. The room title input accepted the numeric portion
of the mixed CUA text payload only, so the created fixture is `20260909`; this
is an automation text-entry limitation rather than a product localization
result. Room settings activation needs a follow-up with the correct macOS AX
targeting syntax.

Pass 389: continued the live macOS sweep in the created test room. Room
information and settings rendered at the narrow current window without clipped
tab labels; all 12 settings tabs were visible and the access-control, voice,
P2P and chat controls exposed labeled states. A guest-join toggle was exercised
and returned to its original off state; the final screenshot confirmed the
rollback. No visual or interaction defect was found.

| Surface | Browser verification | Automated coverage |
| --- | --- | --- |
| Discovery/search/categories | Exercised: desktop/phone, empty search and API failure | Layout, lazy grid, loading/error, commands |
| Authentication/server settings | Exercised: local login/logout and server controls | Login/recovery/OAuth, server dialog |
| Room/create/join/settings | Exercised: create/join, settings and free mode | Responsive shell, permissions, dialogs |
| Player/chat/playlist/history | Exercised: desktop/phone player, playback, chat and playlist | Playback controls, sync, chat, P2P |
| Media/provider forms | Reachable add-media workflow exercised | Provider forms and add-media layout |
| Account/profile/privacy/security/notifications/bindings | All account sections opened | Account controller and pagination boundaries |
| Admin/users/rooms/providers/reviews/streams/taxonomy/cache/runtime | 12 admin sections opened; phone user/room records inspected | Admin cache/review/moderation/runtime, layout and request races |
| Reports/voice/shared controls | Reachable UI inspected; live voice needs separate devices | Reports, voice engine, controls |

## Remaining Validation Limits

- Android and iOS were not exercised on physical devices or emulators. The
  macOS build passed; native runtime behavior still needs device validation.
- External OAuth, passkeys, email delivery, and provider-specific credentials
  were not available for complete live integrations; their existing automated
  tests do not substitute for third-party end-to-end checks.
- Multi-device microphone/WebRTC/P2P behavior and adverse-network playback need
  separate clients and network conditions beyond the local browser run.
- Lazy rendering and debouncing are covered structurally and functionally.
  No controlled before/after frame-time or startup benchmark was collected.
