# Frontend Real Client Sweep

Date: 2026-09-09–10. Scope: normal text size; browser and macOS; wide and narrow layouts. The executable sweep is closed with the explicit exclusions below. This is not complete authenticated two-client acceptance.

## Status meanings

- Functional pass: an action and its visible result were exercised. Persistence is listed separately.
- Visual observation: controls/layout were inspected; mutations and complete workflows remain pending.
- Pending: not yet exercised sufficiently. External services are skipped only where prerequisites are absent.
- Browser viewport override works. Earlier claims that narrow testing was unavailable were incorrect.
- Earlier native 800px observations describe the stacked layout, not the wide sidebar layout. Wide observations below used approximately 1219px; narrow native used 600px. Browser narrow override was 390 × 844.

## Current evidence reconciliation

The historical table below is an initial snapshot. Its remaining-work cells and historical active/pending statements are superseded by the final closeout below; they must not drive duplicate tests. Functional evidence, visual inspection and exclusions remain distinct.

| Previously pending area | Current evidence / outstanding boundary |
|---|---|
| Locale and server profiles | System-default persistence, language round trips, active/inactive profile removal, fallback, unreachable target and live metadata passed in later follow-ups. |
| Account, notifications and taxonomy | Avatar lifecycle, room leave/delete, all account-room sorts, populated pagination/shrink, notification query/selection/shrink, categories and labels have real native evidence. |
| Media library | Batch add/delete, move, all selection renderers, cover/access/order/nested playlists, combined filters, populated page navigation/search/refresh and source draft preservation passed. External successful source resolution remains limited to available local fixtures. |
| Invitations, history and chat | Native invite round trip, browser startup routing, history replay/clear, chat mutation/image viewer and report moderation have later evidence. Browser room entry remains skipped at the unchecked agreement boundary; multi-user authenticated delivery is unverified. |
| Room policy | Capacity, password projection, chat/voice/P2P switches, seven member and four guest permission save/readback/restoration passed. Cross-role enforcement is not established by creator-session configuration tests. |
| Reviews/admin | Populated join, creation and registration decisions, bans/unban, taxonomy and selected runtime/cache operations passed. Uncategorized creation-review failure is fixed and real-client retested below; other runtime inputs and administrator-management actions need explicit assessment. |
| Playback | Local MP4/FLV rendering, seek, pause/resume, rate selection, fullscreen/Escape, PiP, wide next/previous and paused default subtitle restoration passed. Alternate/off subtitle selection now passes actual narrow/wide/fullscreen retest; style rendering and free-mode threshold save/readback/restoration also pass. Narrow next/previous and end-of-list behavior now have actual-client evidence below. |

Current result: the 33 named page/dialog/screen files and their feature entry points have been reconciled with the follow-ups. Final Flutter regression: 3043 passed, 1 skipped; analyze clean; macOS debug and Web release builds passed. Final client retests and fixture cleanup are recorded at the end. Authenticated browser and fresh authentication, protected credential/administrator creation, unavailable providers/transports and multi-client enforcement remain explicit exclusions, not functional passes. No unverified browser mutation is inferred from native results.

## Historical initial coverage

| Area | Browser evidence | macOS evidence | Remaining work |
|---|---|---|---|
| Locale | Wide and 390px English/Chinese round trip, homepage and language sheet observed | Chinese→English→Chinese passed at 600px/wide; English survived cold restart | System-default selection and persistence completed; see follow-up |
| Home search/categories/labels | Narrow search produced empty result and clear restored rooms. Weekly Pick / Film & TV returned Friday Film Club after checked-state verification | Wide/800px/600px home; favorite/unfavorite + refresh passed; carousel forward/end/back passed at 600px | Other filters, pagination, authenticated browser |
| Auth | Login/register/guest forms inspected. Guest room entry exercised; guest session reused on a fresh tab | Existing root session survives cold restart | Authenticated browser sign-in; available account workflows. Guest submission returning home needs reproducible investigation |
| Server settings | Wide identity/endpoint modal observed; refresh succeeded; 390px sheet wraps ID/address/help and Done returns home | Wide/narrow info refresh, validation, add/switch/remove passed; alternate endpoint starts unauthenticated, original endpoint restores root; removal survives restart; unreachable address retains draft and current session; active-profile removal restores built-in connection | No remaining available connection mutation workflow identified |
| Room creation/settings | Guest entry to test room works | Test room created; guest-join setting saved; capacity 100→101 saved and read back after reentry, restored to 100 and reread | Password state fixed and verified via five live API projections and native wide/narrow readback; remaining writable settings |
| Actual playback | Local H264/AAC MP4 rendered in wide and narrow layouts. Native seek propagated and both video timestamps advanced | Local MP4 added through UI; rendered, advanced, and seek moved to approximately 20 seconds. Stop returned player to waiting state | Controlled pause/resume passed via native Space: both advanced from 10.3s to 36.4s, then stayed paused for over a minute, with approximately one frame difference. Browser narrow fullscreen enter/exit passed. Rate, native fullscreen, subtitles, next/previous, reconnect remain pending. One native transient load error recovered; investigate repeatability. |
| Chat | Guest has no chat controls; renewed guest session pending agreement decision | Send/reply/edit/reaction/undo/delete, quote highlight, deleted-quote fallback and deletion persistence passed; wide and 600px inspected. Read-detail modal opened | Multi-user delivery and image workflows remain pending. Edit, pin/unpin, search and context exercised; see notes below. |
| Members/invite | Guest and native presence observed together | Added a test member with notifications off, saved alias/display label, refreshed, changed member to guest, verified role filters, removed temporary membership; narrow and wide layouts checked | Invite round trip, search/sorting, remaining permissions and report flows |
| Playlist creation/edit | Pending authenticated browser | Created playlist, refreshed, reopened and confirmed name/description. Blank name save used to dismiss silently; fixed and retested at 600px and wide. Invalid edit remains open; cancel preserves saved entry | Enter validation covered automatically; remaining move/reorder/cover/access flows |
| Playlist help text | Pending authenticated browser | Browse-access description now wraps fully in 600px and wide dialogs | Browser narrow visual retest |
| Media views/mutations | Playback selection propagated | Direct URLs, rename/move, search/clear, compact/detailed/grid, batch select/deselect/cancel and cross-directory selection exercised; see follow-up | Batch add/delete passed with 2 disposable direct URLs; remaining filters and available source forms |
| Room realtime/network | Pending renewed guest session | Event type filter, grouping/expand, retention truncation/restore, custom retention validation/save/readback, clear/new-event recovery passed. Wide/narrow filter-state regression fixed and retested. ICE draft add/remove/cancel passed | Event copy and remaining resource/network workflows |
| Free mode/streaming/moderation | Pending | Free mode enabled/saved/reentered with value retained; auto-correction disabled correctly while manual threshold stays enabled; Restore defaults saved off/1.2s/0.2s. Streaming/moderation controls observed only | Threshold slider/P2P settings mutations and moderation; skip unavailable external streaming services |
| Account | Pending | 600px overview/profile, username dialog, privacy/notification/security/provider catalog/rooms observed. Notification toggle saved/refreshed/restored | Actual remaining account workflows in both widths |
| Admin categories | Pending authenticated browser | At 600px: created, renamed, disabled, refreshed, deleted disposable category; count restored to 5. Empty-required and invalid-sort dialogs retain drafts after fix | Wide category editor subsequently inspected; see taxonomy follow-up. Remaining admin workflows tracked separately |
| Admin users/bans/reviews | Pending authenticated browser | Temporary user ban/unban, active/ended filtering and refresh; join request approval/rejection/readback and member cleanup passed wide/600px. Cross-section stale data and numeric role display fixed/retested | Registration and creation approvals/rejections subsequently passed; see populated review follow-ups. Remaining admin mutations and external services tracked separately |
| Admin labels | Pending authenticated browser | Wide: created with General parent and color 3af, reopened as #33AAFF, disabled and deleted. Required/color validation retains dialog after fix | Narrow create/edit/readback/delete and category binding/unbinding subsequently passed; see taxonomy follow-up |
| External provider integrations | No external credentials | Provider catalog inspected; no configured provider records | Skip real provider binding/content workflows where service/credentials absent; inspect locally reachable forms |

## Fixes and verification

- Category/label save validation now occurs before dialog dismissal. Required fields, invalid sort, and invalid color were retested in the rebuilt native app.
- Shared select helper text uses a wrapping widget. Playlist browse-permission help is fully visible in native 600px and wide dialogs.
- Playlist/media entry name validation now occurs inside a Form before save or Enter dismissal. Empty/whitespace names retain the description. Native create and edit were visually retested; valid create, refresh, and edit readback passed.
- Latest room-settings suite: 33 passed together after member validation/count fixes. Shared message-edit test passed in the prior run. Analyze clean. Native debug and Web release builds passed after member validation/count fixes.
- Earlier baseline full suite: 2987 passed, 1 skipped; shared form-controls suite: 175 passed. These are prior results, not a new full run after the latest fix.

## Test fixtures and next checks

- Keep room `20260909` (`room_6`) for continued testing. It contains `Sweep playback` (public URL returned HTTP 403), `Local playback edited` (local fixture server, media renamed and persisted), and `Validation sweep` playlist with description `Preserve draft on validation`.
- Public sample video failures were traced to HTTP 403. A generated 60-second MP4 served with CORS and byte ranges removed this dependency; both clients rendered it. Do not count public-resource errors as decoder regressions.
- Native stop was exercised earlier. Playback was stopped again after the pause/resume checks. Test chat message #51 now says `UI sweep context edit`, edited and unpinned, retained for further operations.
- Disposable taxonomy entries were deleted. Current playback/playlist fixtures are intentionally retained for remaining workflows.
- Investigate homepage total: header says one room while featured and popular sections show more. Confirm count semantics before changing behavior.
- Direct-link preview shows URL filename although the saved entry correctly uses the supplied custom name; assess preview consistency.
- Finish authenticated browser coverage and remaining playback controls before declaring overall sweep complete.

## Automation observations

Native AX text can disagree with actual Flutter field content. Prefer screenshot verification; coordinate focus plus typing was reliable. URL colons require explicit key input under the active keyboard layout. Native accessibility occasionally lost the full Flutter subtree or returned AX failure; cold restart restored controls. Browser fresh tabs worked, but the accessibility placeholder sometimes failed to activate, so visual coordinate interactions were used. These harness failures are not counted as product defects without independent reproduction.

## Additional verified workflows

- Media detail and rename: renamed local media, reopened after cold restart, confirmed saved name. Move dialog initially rendered blank due to an intrinsic-size/shrink-wrapping viewport assertion. Replaced the nested viewport with children inside the existing scrollable dialog and guarded refresh after dismissal. Regression reproduced before the fix and passes afterward. Native 800px/600px target selection and refresh work; moved local media into Validation sweep and back, verified counts and contents at both destinations.
- Playback history: latest/earliest sorting visibly reversed the two real records. Deleted only the failed public sample history record via confirmation; local historical title remains preserved. Replay and clear-all remain pending.
- Chat editor: empty save previously closed the dialog and sent an invalid backend request. Shared validated editor now retains empty input with a required error; native 600px real retest passed. Valid edit and pin persisted on refresh. Search `edited` returned the expected single result.
- Context sheet: 600px and approximately 1219px layouts displayed all three messages without overflow. Actual unpin exposed stale sheet data while background history updated. Context mutation callbacks now refresh server data and guard asynchronous completion after dismissal. Rebuilt native app passed consecutive pin/unpin and valid edit with immediate visible updates. Mutation retest used 800px. Test covers updated pin actions plus closing during refresh. Delete confirmation cancel retained the message; actual deletion remains pending.
- Message report viewer: native wide and 600px opened with message #51 filter and zero-record state. No actual report moderation is claimed yet.
- Playback: local fixture HEAD and byte-range requests succeeded. Native briefly showed a load error, then recovered to a rendered frame without code changes. Native seek from ended state to 10.3s propagated to browser; both remained paused. Space resumed actual video progression, then Space paused both at 36.4s for over a minute. Browser guest Play is disabled as expected. Native mouse automation on playback control returned AX failure; keyboard operation was reliable.
- Browser 390×844: paused video and collaboration layout inspected, subtitle-style sheet opened/closed, fullscreen entered and exited with video preserved. No subtitle track is present, so subtitle rendering is unverified. Browser media DOM confirmed muted state; wide player subsequently showed unmute action. Narrow menu label did not visibly update before reopening; recheck interaction/state before classifying a defect. Viewport override reset afterward.

## Member management follow-up

- Added existing seeded test user daniel to the test room as a member with notification disabled. The first malformed ID attempt was rejected by the backend: native input method converted punctuation. After switching input language and visually confirming the exact ID, addition succeeded and count changed from 1 to 2.
- Empty user ID originally produced no feedback on Add. Added Form validation using existing localized required text and Enter submission. Widget regression covers empty/whitespace Add and Enter. Rebuilt macOS at 600px visibly retains dialog and displays required error.
- Saved alias `Sweep member` and display tag `UI validation`; refresh preserved both while retaining original username/ID. Native 600px and approximately 1219px member-card layouts were inspected.
- Member role filter returned the test member alone. Changed its role to guest, confirmed the member filter became empty, then guest filter displayed the changed role. Removed the temporary membership using the confirmation with default 60-second cooldown; all-role filter returned only the original owner. The seeded user account was retained.
- The empty member filter exposed `1 online / 0 members`: a room-wide count was used with filtered totals. Filtered HTTP results now derive presence from returned members; an empty list also ignores late online-count messages. Regression covers an empty HTTP response carrying online count 1 plus a delayed count event. Rebuilt native 800px, 600px and approximately 1219px actual filter/refresh now shows `0 online / 0 members`.
- Browser auth dialog remains unauthenticated; it requires agreement confirmation. No agreement was accepted. Other testable native/guest workflows continue; account creation/authenticated browser remain pending prerequisite handling.
- Latest native position: Room settings → Members, 600px, member-role filter selected, empty results. Playback stopped. Temporary membership cleaned up.

## Settings and browser follow-up

- Native 600px room settings: changed capacity from 100 to 101, saved, left/reentered settings and visually confirmed 101. Restored 100, saved, left/reentered and confirmed 100. Access, communications, member permissions and guest permissions sections were scrolled and inspected; their individual toggles are not claimed as functional passes.
- Free mode: native 600px and approximately 1219px layouts inspected. Wide toggle enabled free mode, disabled automatic-correction threshold and retained manual-threshold controls. Save succeeded; leaving/reentering retained on. Restore defaults returned off with 1.2s automatic and 0.2s manual threshold and showed saved feedback. No video was playing during this configuration test. Actual independence from room sync still needs a playback test.
- Native free-mode accessibility subtree was intermittently missing and narrow click/scroll returned AX failure. Wide coordinate interaction later succeeded without code changes. Keep this as a harness observation, not a proven product regression.
- Browser server sheet: refresh completed, 390×844 view showed full address/ID/help without overflow; Done returned to home. Browser supports identity information here, not endpoint mutation.
- Browser 390×844 language round trip: Chinese→English changed the selected radio and displayed English home labels; English→Chinese restored the homepage. Language selection automatically dismissed the sheet; one subsequent stale close-node attempt failed because it had already closed.
- Browser viewport reset. Current native state is wide Room settings → Free mode, defaults restored. Room capacity is 100. No production code changed in this follow-up; previous 33-test/analyze/build results remain the latest code verification.

## Reports and runtime administration follow-up

- Created one explicit test-only room report with reason `other: UI sweep test report. No actual violation.` The native process exited during submission; the report was saved exactly once. Cause remains unconfirmed; no diagnostic report was found. The app relaunched with its root session retained. Reproduction remains pending.
- Native report details inspected wide and at 600px. At 600px, changed status to Dismissed with note `UI validation only. No action required.` Pending count changed to zero. Selected Dismissed, refreshed, reopened details and verified status, reviewer, review time and note persisted. The test record remains dismissed.
- Native 600px review queues: registration, room creation and joining showed empty records; joining status changed to Approved with correct selected label. Actual approval needs a test request and remains pending.
- Native 600px streaming: empty active-stream state, sorting direction and refresh exercised. No actual stream stop is claimed. Ban records showed an empty active list; ban/unban remains pending.
- Native 600px cache: expired-item eviction returned zero removed. Clear-cache confirmation fit the window; confirmation returned zero items removed and zero bytes released. This verifies the empty-cache operation and feedback, not eviction of populated media data.
- Runtime server name changed from SyncTV to a temporary validation name in native 600px. Refresh All and resizing to approximately 1219px retained the value. Browser server information independently displayed the new name. Restored SyncTV in native wide editor; browser information refresh confirmed the restored name.
- Runtime default-member-limit editor: clearing the number and saving retained the dialog with required-number error. Wide and 600px layouts showed the field, error and actions correctly. Cancel preserved the original value 100. Narrow section selector navigated to Chat.
- Found missing localized descriptors for server name and per-room pinned-message limit; their cards displayed raw `Name` and `MaxPinnedMessagesPerRoom`. Added English/Chinese labels, useful descriptions and matching icons. Rebuilt-client visual verification and current build results are recorded below when complete.
- Rebuilt native verification: server-name card displays its Chinese name and description at 800px. Pinned-message card and editor display localized title, description and unchanged value 20 at 600px; approximately 1219px editor also fits. Cancel leaves configuration unchanged. Native root session survived this deliberate restart.
- Current checks after the localization fix: analyze clean, 43 existing runtime numeric/editor-layout tests passed, macOS debug and Web release builds passed, and diff whitespace check passed. Browser name propagation checks used the actual backend; authenticated browser admin coverage remains pending.
- Current continuation point: native approximately 1219px Admin → Settings → Chat, editor closed; browser guest homepage retained. Server name restored to SyncTV. Full Goal remains active; remaining workflows in the coverage table are not claimed complete.

## Chat and responsive diagnostics follow-up

- Admin WebRTC editor: opened the two configured ICE entries wide, added a third draft, inspected at 600px, deleted the draft and cancelled. Returned configuration still contains the original two entries; no ICE configuration was saved. Playback-history retention cards were visually inspected wide only.
- Native 600px: sent `UI sweep disposable chat`, added 👍 (count 1), replied with `UI sweep reply`, and verified the reply composer cleared after sending and the message contained the original quotation.
- Room-screen shared editor: empty content was blocked with a visible required error. Saved `UI sweep reply edited`; edited marker appeared and the original quote remained. Wide layout displayed both messages and the quote; clicking the quote located and highlighted its source.
- Removed the reaction, confirmed its badge disappeared, then deleted the original disposable message. The reply immediately replaced the original quote with “Message deleted”. Deleted the reply as well. Leaving and reentering the room confirmed both disposable messages remained absent and the earlier messages were retained. This verifies local mutation/persistence, not delivery to another authenticated user.
- Browser guest reentry encountered expired-session feedback and opened the login dialog. The dialog requires agreement acceptance; a specific confirmation question is pending. No agreement was accepted, and browser authenticated/renewed-guest flows remain pending. Native testing continued independently.
- Native realtime log: actual heartbeat/resource events continued arriving. Selected heartbeatAck alone; filtered count and rows matched. Group mode and expansion worked. Changed retention from 100 to 50 and observed immediate total truncation to 50; restored 100 and observed the total grow back to 100. Cleared local events: zero-record state appeared, followed by newly arriving events. These operations did not interrupt the room connection.
- Found a responsive-state regression: changing native width from approximately 1219px to 600px discarded the selected event filter. The room now gives its realtime log a stable widget identity across layout changes. Rebuilt native retest with heartbeatAck selected and expanded passed wide→600px→wide: selected filter, one-group count, actual event types and expansion all remained intact.
- Latest checks after the responsive-state fix: analyze clean, existing realtime-log retention test passed, macOS debug and Web release builds passed, diff whitespace check passed. No new large-font manual testing was performed.
- Current native position: approximately 1219px test room → Realtime, heartbeatAck-only filter, grouped and expanded, retention restored to 100. Playback remains stopped. Browser is on the login dialog awaiting the agreement decision. Full Goal remains active.


## Playback and selection follow-up

- Native playlist search: submitted `Local` and obtained only `Local playback edited` (total 1); clear restored all 3 fixtures. Grid layout inspected at 600px and approximately 1219px. Batch selection starts at zero with Delete disabled, and Select All selects all 3.
- Found that the apparent selection circle on playlist entries navigated into the directory instead of changing selection. Replaced decorative circles with named, interactive checkboxes across compact, detailed and grid renderers. Compact 600px retest: select all 3, deselect the playlist, count becomes 2 without navigation. Grid retest: select playlist again (3), resize wide, deselect it (2), then click its artwork to enter the empty playlist while preserving selection. Cancel and return restored the root list with all 3 fixtures intact. Detailed renderer received a separate real-client retest in the account and selection follow-up below.
- Custom realtime retention previously ignored empty Save without feedback. Added Form validation using existing localized required/number messages. Rebuilt native wide and 600px show a required error and retain the dialog. Saved 75, reopened and confirmed 75, then restored 100. Existing regression now covers empty Save, keyboard submission, cancellation and upper-bound normalization.
- Local MP4 loaded and rendered again; Space paused around 27 seconds. Native F entered fullscreen and F returned with progress preserved. Escape initially did nothing; added fullscreen-only Escape handling. Rebuilt native 600px F→Escape now returns to the room with paused progress preserved. Regression also verifies Escape does not enter fullscreen from normal room view.
- Found narrow player More → Playback speed did nothing: its callback referenced an unmounted wide-only speed control. The overflow entry now opens an independent speed chooser. Native 600px selection of 1.5x succeeded; reopening at approximately 1219px displayed its checkmark, then restored 1x. Dialog fits both sizes. This verifies selection/readback, not timed 1.5x progression or cross-client rate propagation. Playback stopped afterward.
- Current validation: player interaction suite 50 passed; playlist selection plus realtime retention suites 5 passed; analyze clean; macOS debug and Web release builds passed; diff whitespace check passed. Earlier full-suite totals remain historical.
- Native accessibility subtree disappeared after fullscreen/menu interactions; screenshots still showed a responsive scene, while several automation clicks returned AX failure. Deliberate app restart restored the tree and retained the root login. No cause is established; this remains an automation/accessibility investigation item.
- Browser login still awaits the previously requested agreement decision. No agreement was accepted. The live tab is preserved for continuation; these new fixes have not yet been functionally retested in an authenticated browser.
- Continuation: native approximately 1219px, test room root playlist, grid, selection cancelled, playback stopped. Retention restored to 100; all 3 fixtures retained. Goal remains active, including account/admin/invite/source workflows and outstanding browser coverage.

## Account and selection follow-up

- Native detailed playlist renderer: selected the Validation sweep checkbox wide, resized to 600px with count 1 retained, inspected title/description/badges, then deselected without entering the directory. Zero selection exited batch mode. This completes the separate detailed-renderer checkbox retest.
- Copy invite showed success, but native keyboard/menu Paste did not insert content into Join room. No invite-link round trip is claimed. Manually entering the exact test room ID successfully joined the room; empty Continue was disabled.
- Account Rooms at 600px: All showed 2 rooms; Joined and Created each showed their expected single room. Created filter survived resizing wide. Search for a missing title showed zero results and correct pagination. Privacy empty state and notification type filtering fit both sizes; Room invitation filter survived resizing to 600px. Populated notifications and actual block/unblock remain pending.
- Found empty username Save silently closed its dialog. Added localized required-field validation; empty Save and keyboard submission retain the dialog. Rebuilt native wide and 600px visually show the required error and intact actions.
- Valid rename to a temporary test name succeeded and survived Refresh. The backend rejects the original root name as reserved on rename, so the test account original username was restored through a narrowly guarded test-database update. Native Refresh and cold restart both confirmed root. No password or login factors changed.
- Found server-rejected rename discarded the input. The username dialog now awaits the request, disables repeated Save while pending, displays server errors within the field and retains the draft. Real backend rejection of admin preserved the text and complete error at 800px, 600px and approximately 1219px; correcting to the unchanged root name dismissed cleanly. The server reserved-name policy itself was not changed.
- System-announcement notification preference: switched off wide, refreshed and confirmed off; restored on, inspected the three vertically stacked switches at 600px, then refreshed before navigating away. Other preferences remain on.
- Checks: 9 rename regression tests passed, including empty/whitespace Save, keyboard submission, failure/draft preservation/retry and late callbacks. macOS debug build passed. Final analyze clean, Web release build passed, and diff whitespace check passed.
- Browser authentication remains subject to the previously pending agreement decision; no agreement was accepted. Full sweep Goal stays active. Current native position: Account → Privacy, 600px, empty blocked-user list; account name root and notification preferences restored.

## Password validation and blocking follow-up

- Reproduced native 600px password-change empty Save doing nothing. Added field-level validation for current password, email verification code, new password and confirmation; matching preserves exact password text. Twenty password-operation regressions passed, including required fields and mismatched keyboard submission for password/email/passkey, valid submission, cancellation, duplicate and disposed callbacks.
- Rebuilt native 600px: all three required errors display; scrolling reaches Save and Cancel. Different new/confirmation values show the localized mismatch after Enter. At approximately 1219px the values/errors persist; correcting confirmation removes mismatch while the missing-current-password error remains. Cancel closes cleanly. No real password change or authentication-factor change occurred; credential-changing GUI flows require user handoff and are excluded from autonomous execution.
- Native room members: blocked seeded owner olivia through confirmation at 600px. Card immediately displayed blocked status. Cold restart retained the block: featured discovery excluded the owner's room, while Continue watching retained the existing room relation with a blocked-creator badge.
- Account Privacy: populated block record and timestamp fit wide and 600px. Unblock confirmation and success cleared the record. Returning home exposed stale discovery and blocked badges; explicit Refresh restored both, confirming a frontend return-navigation refresh omission.
- Fixed account-center return to reload room data as well as user information under the existing session epoch guard. A regression verifies restored featured discovery and removed blocked-creator marker after closing the account route. Rebuilt real-client verification and latest checks follow.
- Native AX occasionally lost the Flutter subtree during room navigation; deliberate restart recovered it. No separate product crash was established. Browser agreement decision remains pending; no agreement accepted.

- Latest native build real retest: blocked the same seeded owner again, returned home and confirmed discovery exclusion; opened Account Privacy, unblocked at 600px and returned home without pressing Refresh. Featured room immediately reappeared. Resized to approximately 1219px: featured/Continue watching lists restored and blocked-creator badge absent. Temporary block removed; account/password/preferences retained.
- App-shell checks: 39 existing tests passed in the suite run; the new regression initially timed out because the account test gateway intentionally stays loading. Using the established bounded route-animation pump resolved it; the new regression then passed. Analyze clean and macOS debug build passed. Diff whitespace check passed. Web release build passed.
- Continuation: native wide homepage with original room visibility restored. Goal remains active for outstanding browser authentication, populated notifications/admin queues, media/source and playback workflows. The unavailable public trailer encountered during the member test showed its load-failure message; no media data was changed.

## Populated notifications follow-up

- Added two disposable notifications directly to the local test database (system announcement and room event), without sending email or realtime broadcasts. Account overview read 2 unread. Native wide and 600px detail sheets displayed the complete mixed-language text, type, time and action controls without overflow. Marking the system notification read changed unread to 1 and survived Refresh. Type filtering returned the room event; read filtering returned the system announcement.
- Found ambiguous summary wording: global unread count and filtered result count were both presented as if they described the same scope. Updated English and Chinese localization to explicitly label All unread / Results. Rebuilt native real retest: all results 1/2, read filter 1/1, submitted missing search 1/0; 600px and approximately 1219px layouts fit.
- Select current unread selected only the event; Mark selected cleared selection and produced unread 0/results 2. Refresh retained both read states. Single Delete removed only the disposable event, results 1; Delete read removed the remaining disposable announcement, results 0. Refresh and account overview confirmed 0 unread. Both fixtures cleaned through the UI.
- Analyze clean, native debug build and Web release build passed. Browser discovery currently fails with an unavailable Codex authentication token; native testing remains available. Existing agreement decision also remains pending.

## History replay and cleanup follow-up

- Replayed an older local media history record. The fixture server had stopped; restarted it and verified HTTP 200 before further playback checks. A different history record then rendered the actual local test video with advancing time at 600px.
- Reproduced a frontend defect: Stop retains the backend history cursor, but the list disabled Play for the cursor entry, preventing that same record from being replayed. Removed the cursor-based disabling; navigation permission checks and controller in-flight guarding remain. Extended the existing list regression to invoke both another entry and the cursor entry. History list/controller suites: 9 passed.
- Rebuilt native real retest: Stop → History → current highlighted entry Play at 600px restored the actual video at its saved approximately 59-second position. Resizing to approximately 1219px retained the rendered frame and player controls. Playback stopped afterward. This verifies replay restoration, not restart-from-zero semantics.
- Clear history confirmation inspected wide and 600px. Cancel retained all 3 test-generated records. Confirm cleared the test room history to the empty state; media library retained its original playlist and 2 media entries. Active-playback continuity during clear was not exercised because playback had been stopped.
- Latest checks: analyze clean; macOS debug build and Web release build passed; diff whitespace check clean. No additional large-font manual testing.
- Current native position: 600px test room management → Media, 3 fixtures intact, playback stopped, history cleared. Notification fixtures removed, account/preferences unchanged. Full Goal remains active for source/batch media operations, remaining playback/admin flows and browser coverage. Browser connector token unavailable and prior agreement decision pending; neither counted as a product defect.

## Multiline URL and batch mutation follow-up

- Reproduced native direct URL field discarding Return/Shift+Return, concatenating two addresses despite its one-address-per-line hint. Its keyboard type was URL; switched to multiline while retaining newline action and disabling autocorrection/suggestions. Real rebuilt native input now preserves a newline and backend preview recognizes two addresses. Extended the existing prepare/partial-selection regression with the native input configuration contract. All 10 prepare tests passed.
- Two query-distinguished local fixture URLs produced two selected preview items. At 600px, deselecting one changed selection to 1; Select all restored 2. Submission reported 2 added, and refreshed room playlist total increased from 3 to 5.
- Batch management: selected only the 2 newly created sweep.mp4 entries at 600px; confirmation correctly said 2. Cancel retained both selection and data; resizing to approximately 1219px preserved selected 2. Confirm delete removed the 2 fixtures and exited selection mode, restoring 3 original entries.
- Native debug build, Web release build and analyze passed. Browser retry can list Edge but listing tabs still reports unavailable Codex authentication token. Goal remains active.

## Favorites, carousel, locale and server metadata follow-up

- Native favorite mutation: favorite the test room wide; both Featured and Continue watching actions immediately changed to Remove favorite. Refresh retained it, then resize to 600px displayed the filled favorite icon. Unfavorite and Refresh restored both actions. No favorite retained.
- Native 600px Featured carousel: Next moved through the middle items, next reached the final pair and removed the forward action, Previous returned through the middle to the start. Cards/controls remained reachable; intentional horizontal clipping acts as the scroll affordance.
- Native locale: Chinese→English at 600px updated homepage/menus immediately; wide English homepage and server dialog inspected. Cold restart retained English. Restored Chinese in the wide language sheet; homepage updated immediately.
- Native Add server at 600px: empty Add retained the form and displayed Enter a server address. Cancel/close via restart left the configured server unchanged. TLS preference remained off. No server added.
- Found stale active server metadata display: live summary used the fresh declaration while its saved-server card showed a prior declaration. Current server card now uses the same successfully read info, guarded by the existing endpoint/revision check; inactive cards retain their own metadata. This is a display correction, not a rewrite of saved connection profiles. Removed misleading above/below wording from identity explanation in both languages.
- Rebuilt real native verification: current summary/card IDs match at 800px, 600px and approximately 1219px, including after Refresh. English explanation wraps cleanly in both widths. Seven server-dialog regressions passed, including live ID replacing stale active data while inactive identity remains unchanged. Analyze clean and native debug build passed. Final Web release build passed.
- Multiline/batch follow-up persistence: Refresh after batch deletion still returned the original 3 entries. Current native position is wide Chinese homepage → Server dialog; Chinese explanation also visually verified. No extra notifications/media/favorites remain; test room and 3 original media fixtures are retained, playback stopped. Full Goal remains active for outstanding playback/source/admin workflows and browser coverage.

## Populated bans and cross-section refresh follow-up

- Native wide: temporarily banned seeded test user daniel with an explicit UI-sweep reason. At 600px, the user status became Banned and the Only banned filter returned exactly one record. Resizing wide retained the filter. Ban records displayed the exact reason, operator and time; Refresh retained the record. Both widths fit.
- At 600px, Cancel unban retained the record; confirmed Unban removed it from active results. Revoked/expired filtering displayed the ended record and survived Refresh. The user account was restored; audit history remains intentionally retained.
- Found a real cross-section stale-data defect: after successful unban in Ban records, returning to Users still showed the banned user and an Unban action. Retained admin sections now refresh on reactivation for Users, Rooms (including taxonomy), Administrators, Bans and Overview, preserving filters/drafts and responsive state. Overview refresh also ignores superseded responses.
- Rebuilt macOS regression: temporarily banned daniel again; Overview changed to 12 active / 1 banned. At 600px, unbanned from Ban records then returned to Users without Refresh: Only banned remained selected and results immediately became 0. Approximately 1219px retained the correct filter/zero count. Returning to Overview restored 13 active / 0 banned. Test user restored; two ended test audit records retained.
- 98 admin record/secondary-list/batch regression tests passed, including return refresh with search preserved and no extra request on resize. Analyze clean; macOS debug and Web release builds passed; diff whitespace check passed. Existing suite contains historical large-text regressions; manual sweep continued at normal text size.
- Browser tab discovery was retried and still fails with unavailable connector authentication token. Native frontend remains usable.
- Added two disposable pending join-review fixtures for the test room: daniel and chloe. These are for the next approve/reject workflows; cleanup remains pending. Goal remains active.

## Join approval and review details follow-up

- Seeded two pending join requests for the retained test room. Wide list showed both requests. At 600px, rejected chloe with the explicit test-only reason; pending count changed 2→1. Approved daniel; pending count became 0. Rejected and Approved filters each showed one record, including reviewer/time and the saved rejection reason. Rejected record survived Refresh.
- Found that join-review cards hid the applicant name and displayed requested role as the opaque number 3. The model/adapter now retain room/user IDs as structured fields; presentation displays the applicant name and localized identity/role labels. Rebuilt macOS wide and 600px both display daniel, room/user IDs and Role: Member in the current Chinese locale. Locale-switch regression verifies English/Chinese rendering without refetching the record. Five review tests passed.
- Admin Rooms → Members confirmed the approval actually created daniel as a member (2 total). Removed only that temporary membership through the 600px Kick dialog with default 60-second cooldown. Refresh and approximately 1219px readback showed only original root (1 total). Rejected chloe was not added. Both processed review records are retained as test audit evidence; no pending join fixtures or temporary memberships remain.
- Analyze clean; latest macOS debug build passed. Latest Web release rebuild passed for the review-detail change. Earlier cross-section refresh build passed both platforms. Native current position: wide Admin Rooms → test room Members, only root. Full Goal remains active.
- Registration/creation review details still contain legacy adapter-formatted labels; this was noticed during join review inspection and remains a separate localization cleanup candidate. These populated workflows have not yet been exercised.

- Independent test-database readback confirmed join review 1 is Approved, review 2 is Rejected by root with the exact test reason, and the test room contains only member root after cleanup.

## Room creation review follow-up

- Seeded two disposable creation requests. Requests with no category produced a backend service-unavailable response in the real frontend. Assigning the existing General category to those same records made the list return both records successfully. This isolates a backend nullable-category path; no frontend fix is claimed. Uncategorized approval remains unavailable in the current backend.
- At native 600px, rejected the explicitly named rejection fixture with reason UI sweep creation rejection; test only. Pending count went 2→1. Approved the other request; pending count became 0. Rejected filter displayed exact reason, reviewer and time; Refresh retained it and wide layout remained readable.
- Returning to Admin Rooms showed 7 rooms, including the newly created room_7. Its detail sheet verified name UI sweep approved room, original description, General category, root creator and 1 member. Wide/600px details were readable; scrolling at 600px reached every footer action. Confirmed deletion of only this disposable room, returning total to 6. Processed creation-review fixtures remain for readback; generated room cleaned up.
- Browser native-window control is available even though extension tab discovery reports missing auth token. Selected the existing SyncTV test tab and dismissed its unchecked login dialog; actual unauthenticated wide homepage is visible. No agreement accepted. This provides a usable fallback for further browser testing.

## Browser native fallback and playback polling follow-up

- Native Edge control restored real browser testing. Wide refresh corrected previously stale online counts. Narrow homepage label selection returned the expected Animation room; switching to Film & TV cleared its incompatible label and returned two rooms. Missing search showed a clearable empty state; clearing search and filters restored discovery.
- DevTools verified the actual viewport as 390 × 844. The labels dialog scrolled to its final Discussion Film & TV option; applying it returned Classic Cinema Society. Clear filters restored discovery. Normal font size throughout.
- Historical browser Console contained 1,003 errors, including playback-messages HTTP 403 requests approximately every 100 ms for a guest without chat-history permission, and native FlutterWebRTC method/event-channel exceptions on room cleanup. Current source inspection confirmed both defects remained. Extension-context errors are external and excluded.
- Added chat-history permission checks before polling and before applying results, serialized requests, and a per-source 30-second failure cooldown. Another source can load immediately. Browser speakerphone configuration now skips the plugin's native-only helper.
- Three polling regressions passed (permission changes, 299 playback ticks during cooldown followed by recovery, concurrent request/source replacement). All 38 native voice lifecycle tests passed. Chrome browser cleanup regression passed without native plugin exceptions. Analyze and whitespace checks passed. Client builds and real-client retest are ongoing.
- Reloading the production browser clears the previous expired guest session and presents an unchecked agreement before entering the test room. Agreement acceptance remains pending; no agreement was accepted. Authenticated browser/guest playback retest is not claimed.

- macOS debug and Web release builds passed. Rebuilt macOS played the local fixture from the media list through its end. A briefly visible thin player was confirmed to be outer-page scroll clipping: scrolling upward restored the full player, so no height defect is claimed.
- Real macOS wide playback: selected 2x, sought to an earlier position and resumed actual video. Reopening the speed menu confirmed 2x selected. Screenshot timing is unsuitable for precise speed measurement because automation latency varies. Restored 1x; the later picture-in-picture controller explicitly read 1.00x.
- Fullscreen rendered the actual frame and Escape returned to the room. Resizing to an approximately 627px window restored the stacked player/collaboration layout. Narrow settings menu showed all controls; subtitle styling sheet fit and Escape returned through the correct overlay levels. No subtitle resource is attached to this fixture, so actual subtitle rendering remains pending.
- Native picture-in-picture entered a 360x203 video window. Its overlay exposed back, progress, previous/next, play, sync, volume, speed and source controls. Return to room restored the prior narrow window and selected media tab. Stopped playback afterward; wait-for-playback state confirmed. The single new playback history record is retained for subsequent playback navigation tests. Full sweep Goal remains active.

## Report submission retry and connection switching

- Repeated room-report submission in the rebuilt native narrow client with an explicit test-only reason. The dialog dismissed normally; room settings, room return, homepage and admin navigation remained usable. The earlier process exit did not reproduce; no crash fix is claimed.
- System Room reports showed exactly one new pending record with the submitted reason. Dismissed it with a test-only disposition note; pending count returned to zero. Dismissed filtering showed the previous and current test records. Refresh followed by detail readback retained status, reviewer, time and exact disposition. Both narrow and wide detail layouts fit. Both dismissed records remain as test audit history.
- Added a local alternate address for the same test backend through the wide server dialog with insecure TLS disabled. Addition automatically activated the new profile; homepage became unauthenticated, confirming the original address's root session was not reused. Both profiles and actions fit the narrow sheet.
- Switched back to the original address at narrow width: root session restored immediately and current-server identity refreshed. Removed only the temporary inactive connection; success feedback appeared and only the built-in original profile remained. Cold-start persistence check follows. No backend data changed in this connection workflow.
- Cold restart confirmed the original root session and exactly one built-in profile; the deleted alternate profile did not return. An unreachable local endpoint failed immediately with a connection-refused notification, retained the full draft and left the original connection/session active. Repeated at 600px; form and actions fit. Cancelled the failed addition. Error-detail expansion was not completed because the transient notification expired before the delayed automation action; no detail-view defect is claimed.

## Current connection removal and actual subtitles

- Added the temporary alternate local connection again and removed it while active at narrow width. The app automatically selected the built-in original connection and restored its root session. Temporary profile removed; fallback passed.
- Temporarily attached a local two-cue WebVTT file to the retained local test media. Real wide playback displayed first-half text at 18 seconds and second-half text at 56 seconds. No external subtitle service was needed.
- Found paused subtitles disappearing after a responsive layout rebuild: subtitle loading populated cues but only later player notifications selected the current text. Loaded subtitle cues now immediately select text for the controller's current position, including paused and ended playback. A delayed-load regression checks display without a player tick and clearing after seeking beyond the cue. All 51 player interaction tests passed; analyze, macOS debug build, Web release build and whitespace checks passed.
- Rebuilt real macOS: cold-start room entry at paused 59.5 seconds immediately rendered the second cue. Switching to wide and back to narrow preserved it at the same position. Temporary subtitle configuration was then removed from exactly the fixture media and its original source configuration read back. Stop cleanup follows; history may retain the original snapshot for later navigation tests.
- Cleanup completed: reentered the room after restoring source configuration, confirmed the paused video no longer had the temporary subtitle, then pressed Stop. Waiting-for-playback state and stopped notification confirmed. Subtitle selection/off and style mutations still need their own actual workflow checks; this pass proves cue rendering, timing and paused responsive restoration.

## Room chat switch enforcement

- Saved Chat off through native room settings. Independent database readback confirmed chatEnabled=false, but the room still exposed message input, image selection and Send. Backend chat/upload checks reject this state even for administrators; the frontend had applied the switch only to danmaku sending.
- Room UI capabilities now apply the room chat switch to message sending for members, creators and system administrators while preserving history visibility. Image picking and message submission recheck access; submission also checks after an asynchronous image upload. The same capability controls danmaku sending.
- All 40 capability and room-settings tests passed, including disabled/re-enabled chat for all three roles with history retained. Analyze clean; macOS debug and Web release builds passed; whitespace check clean.
- Rebuilt real macOS wide and narrow: saved disabled state hides message/image/send controls while history remains readable. Reopened settings showed Chat off. Restored on and saved through the narrow UI; database readback confirmed true. Returning directly to the wide room restored all composer controls without manual Refresh. No test message was sent; original chat setting restored, playback remains stopped.

## Media source and availability filters

- Native wide: position descending reversed the two media entries. Direct URL filtering excluded the static playlist and showed exactly two media. Combining it with Unavailable returned zero; resizing narrow preserved source, availability and direction.
- Found misleading filtered-empty wording claiming the current directory had no media. The media management view now distinguishes active search/source/instance/availability filters from a genuinely empty directory, with English and Chinese no-matching-results text.
- Rebuilt native 600px and wide both displayed the new filtered-empty message for Unavailable. Clearing availability restored the original static playlist and two media entries. Source returned to All and sorting to position ascending. No media records were modified.
- Analyze clean; macOS debug and Web release builds passed. This narrow display change was verified in the real client without adding a redundant widget test. Goal remains active for remaining source forms and playback order workflows.

## Provider forms and localization follow-up

- Native connection management and binding forms were exercised for AList, Cloudreve, Emby, FNOS, QNAP, Synology DSM and Nextcloud. Empty submissions retain each dialog and show the localized complete-fields error; scrollable forms keep credentials and actions reachable. All seven were inspected narrow; Cloudreve, Emby, FNOS, Synology and Nextcloud also received wide form checks. QNAP wide was subsequently verified; see follow-up.
- Emby password, API Key and passwordless modes were switched and visually checked. Nextcloud Browser and App password modes were checked; no external account was created because credentials/services are unavailable.
- Fixed hard-coded English labels exposed in the Chinese UI: Synology device name/OTP, Cloudreve email, and Nextcloud login mode, app password and browser action. Generated localization files, rebuilt macOS and Web, and rechecked Chinese forms at approximately 600px and 1169px. Labels now render as 设备名称、一次性验证码、邮箱、浏览器登录、应用密码 and 打开浏览器.
- Seafile was checked wide and narrow, including scroll and empty-submit retention. TrueNAS API Key form was checked narrow and wide; empty-submit feedback was checked narrow. Successful binding/content browsing is skipped because external services/credentials are absent. Bilibili and Twitch local forms were subsequently verified; see follow-up.
- Corrected the prior viewport note: TrueNAS API Key and empty-submit were first captured at approximately 600px, then explicitly rechecked at approximately 1169px; both layouts fit. YouTube was inspected in the native narrow account-center flow and its empty-submit message is now localized and specific. Existing YouTube, Douyin and TikTok binding tests pass after updating the localized instance label assertion.
- Follow-up measured layouts: rebuilt YouTube, Douyin and TikTok forms were each inspected at approximately 600/627px and 1169px. Empty submission in narrow windows displays the specific Chinese credential requirement and retains the form. Closing returns to the selected provider with zero accounts. No credentials were entered and no binding records were created. This completes native visual/empty-validation retest of the three localized forms; successful external binding remains skipped.

## Playback history replay and clear

- Replayed the latest retained local fixture through the history action. Returning to the room rendered the actual video in wide and narrow windows. The first screenshot was already at the end, so the initial playback position was not established. Narrow seek/resume then advanced the burned-in video time from 18.917 to 40.375 seconds with changed frames. Stop restored the waiting state; cold restart and room reentry retained stopped playback.
- The test room contained two local playback history records. At 600px, the clear confirmation text/actions fit; Cancel retained both records. Reopened and confirmed Clear: the list became empty. Media management still contained the original one playlist and two media entries (three total).
- Returned to history and resized to approximately 1169px: empty state remained readable. Left management, returned to the room, reopened management and history: the newly loaded list was still empty. Only this disposable test room's playback history was cleared. Chat/system messages and media fixtures remain; playback is stopped.
- Native AX access was lost after a responsive transition; a cold restart restored it. Screenshots showed a normal stopped room, so this remains an automation limitation. No production changes or new build/test run in this follow-up; the preceding three provider regressions, analyze and client builds remain the latest code verification. Goal remains active.

## Communication switches and ICE access

- Room Network is a read-only ICE list with Refresh. Two configured STUN entries rendered wide and at approximately 600px; refresh retained both without errors.
- Saved room-level voice and P2P off, leaving member permissions and Chat unchanged. Voice Join disappeared immediately on returning to the room in narrow and wide layouts. Reentering settings retained both off values. Restored both on and saved; Voice Join returned.
- Found Network navigation incorrectly tied to room feature switches captured when opening management. The backend ICE endpoint checks voice/P2P business permission independently of those switches. Management now receives those permission capabilities directly, so permitted users can inspect ICE information even with both features disabled; actual voice/P2P usage remains switch-gated.
- Rebuilt native retest: disabled both again, saved, opened Network and refreshed successfully at 600px. Returned to the room (Voice Join absent), reopened management while both remained off: Network was still available. Settings read back both off. Restored both on through Save and confirmed both on with success feedback. Playback remains stopped; no voice call or peer transfer was started.
- Analyze, macOS debug and Web release builds passed. Existing room capability tests were run; this change does not claim end-to-end voice or P2P transport coverage. Goal remains active.

## Room review filters and threshold access follow-up

- Room-scoped review page: Approved showed the retained daniel request; Refresh at 600px retained the record and count one. Rejected showed chloe with the exact prior test-only rejection reason. Entering usr_13 under Rejected returned zero records; switching to approximately 1169px preserved the input, selected status and empty result. The clear button immediately restored chloe and count one. Returned to Pending with an empty user filter and zero requests. No review/member mutations were made.
- Free-mode threshold panel was visually checked at 600px and 1169px with original values off / 1.2s / 0.2s. Native coordinate clicks and drag each failed with AXError.failure before changing values; screenshots retained defaults. No save was attempted. Threshold mutation remains unverified; the interface failure is not classified as a product defect. Cold restart restored access to other native controls, allowing review tests to proceed.
- No production code changed in this follow-up. Earlier builds and seven capability tests remain the latest code checks. Playback remains stopped, history empty, communication switches restored on. Goal remains active for outstanding workflows.

## Room password state follow-up

- Room information showed no password before the test. A temporary password was entered at 1169px, retained across resize to approximately 600px, and Save reported success. The card still showed “未设置” after save and after Refresh, exposing a stale state mapping: OPAQUE password state is maintained separately from RoomSettings, while the card and action label read only `requirePassword` from RoomSettings.
- Fixed the settings page to merge the room summary’s authoritative `needPassword` projection into the password card state whenever room info loads, and reload room info after a password mutation. This keeps the card/action state aligned with the server’s OPAQUE password state instead of the unrelated policy snapshot.
- Follow-up on the rebuilt client reproduced the same symptom: Save reports success, but the room summary still reports “未设置” after refresh. The added merge uses the authoritative summary when available and preserves the just-confirmed mutation in the open page, but the summary itself is currently false; this indicates a backend/projection consistency issue that needs separate investigation. Do not count password persistence as passed. Analyze, macOS Debug and Web Release builds pass; the test password was not left enabled according to the client summary. Goal remains active.

## Password projection investigation and remaining provider forms

- Database readback corrected the prior client-only assumption: the temporary room password was actually enabled while the UI said “未设置”. The old summary does not establish successful cleanup. Cleanup is pending actual server readback.
- Root cause: client/admin RoomSettings never had `requirePassword`; both frontend room adapters read this nonexistent field. Added an independent `password_enabled` room response field in the backend and the app-owned proto snapshots. Discovery/My Rooms/admin lists reuse batched password queries; detail, mutation, and management responses load credential state. The room management UI now reads its room projection independently of policy watch snapshots. Removed the administrator settings password toggle, which had no corresponding backend write; the existing explicit set/clear password actions remain.
- Backend API check passed. Frontend mapping/policy-snapshot tests passed; the full selected run passed 237 other cases, with the new test initially failing only because its notification timer needed draining. That timer cleanup was added and the new test passed. Three admin settings regressions passed. Web release build passed; final native/backend builds and real-client password retest are ongoing.
- Real macOS Bilibili QR mode loaded a QR code and login URL. QR and SMS modes fit at 600×800 and 1169×768; mode switching retained content, and empty Bind displayed the localized prerequisite without dismissal. No SMS or external login was completed. External authenticated binding remains skipped for missing credentials.

- Twitch wide/narrow form and empty-submit retention passed, with localized incomplete-fields feedback; no account created. QNAP form was explicitly rechecked at 600×800 and 1169×768, completing its pending wide inspection.
- Rebuilt test backend started successfully with existing configuration/database. Live regression verified enabled password state consistently across client detail, admin detail, discovery, My Rooms, and admin room listing. Real rebuilt macOS room information displayed “已设置” at 1169×768 and 600×800; the narrow scrolled password card displayed “当前房间需要密码” and an enabled “移除密码” action. Credential cleanup is being performed through the test API, followed by frontend refresh verification.

- Password clear via the test API passed the same five live projection checks. Database readback confirmed credential disabled, version incremented. Actual macOS Refresh displayed “未设置” at 600×800 and retained it after resizing to 1169×768. Temporary password is now removed.
- During browser reload, the first rebuilt backend binary redirected `/` to the project website because the initial build omitted `web-ui-dynamic`. This is test setup, not a frontend regression. Rebuilding with the original runtime Web UI capability before continuing browser checks. No browser authenticated coverage is claimed from this attempt.

## Password fix completion and browser recovery

- Final test backend was rebuilt with `web-ui-dynamic`, restarted with the existing configuration/database, and served `/` locally with HTTP 200. SHA-256 comparison confirmed the served `main.dart.js` exactly matches the latest Web release output. The temporary redirect from the earlier missing feature flag is resolved.
- Administrator room settings dialog was actually rechecked at 1169×768 and 600×800. It contains approval, guest, chat and capacity controls, without the ineffective password toggle. Cancel returned to the six-room list; no policy changes were made. Explicit room-password actions remain in the room edit flow.
- Latest macOS Debug and Web Release builds passed; analyze has no issues; frontend/backend whitespace checks passed. Backend API check and runnable service build passed. The backend changes live in the backend checkout as well as the frontend-owned proto snapshot; both are needed for the complete password-state fix.
- Browser extension inventory still reports missing connector authentication. Real Edge native-window control was used successfully. The latest public homepage rendered at wide width, then DevTools confirmed 390×844. Labels were additionally inspected at 390×483 while adjusting preview scale, and at 390×844 with 100% preview after docking DevTools right. All final label options and Cancel/Clear/Apply remained reachable, with no horizontal overflow.
- Selected Restored Classics / Film & TV and applied it: only Classic Cinema Society appeared. Added a no-match search: localized current-filter empty state appeared. Clearing search restored the selected-label result; clearing labels restored featured and popular rooms. Browser remains unauthenticated; no legal agreement, SMS, CAPTCHA or external-provider login was completed. Authenticated browser workflows remain unverified.
- Temporary room password is confirmed disabled by database readback and five real API readbacks. Playback remains stopped, room/media fixtures retained, room policy switches unchanged. Sensitive temporary process/test configuration files were removed after validation.

## Next sweep targets after this follow-up

- Continue native locally testable media source forms, previous/next playback order, image upload/message flows, invitation round trip, and remaining account/admin workflows from the coverage table. Do not treat older pending rows as passed solely because their widgets were visible.
- Browser authenticated room/account/admin checks still lack an accepted test-session agreement; record the boundary explicitly. External providers without credentials/services remain skipped.
- Goal remains active. This follow-up closes the password-state defect and the Bilibili/Twitch/QNAP form gaps, not the entire frontend sweep.

## Image attachment upload and full-image viewer

- Native image picker loaded a generated 640×360 test PNG. Crop mode switching, narrow/wide editor layout and Cancel were exercised; cancellation left no attachment draft. Upload original retained the selected draft across resize and successfully sent it with the caption `UI sweep image fixture`. The sent message persisted after cold restart and the composer draft cleared. Actual cropped-image export remains pending.
- Found chat attachments had only fixed cropped thumbnails with no way to inspect the complete image. Added a shared full-image viewer to room chat, room-management chat and administrator chat grids, with contain fitting, pan/zoom, zoom buttons, reset, localized load failure and close. Cover thumbnails retain their existing behavior.
- Rebuilt macOS actual retest at 600×800 and 1169×768 showed both marked corners of the original image. Zoom in/out worked; Reset and Escape returned correctly. Room-management search found the single fixture and its preview opened. A preview nested inside message context closed only its own layer on Escape. Search and context state persisted. Administrator chat history also opened the fixture image and returned to its original dialog after resizing and closing.
- Both new viewer regressions pass, including 390px/wide transitions, zoom/reset, keyboard dismissal and failed-image recovery. Analyze is clean. macOS Debug and Web Release builds passed. Browser authenticated image workflows remain unverified due to the existing test-session agreement boundary. The single fixture message remains for subsequent tests; no external messages were sent.

## Direct-link preview naming and playback sequence follow-up

- Reproduced a direct-link confirmation mismatch: the entered custom title was saved correctly but the prepared item still displayed the URL filename. Preview now follows the effective custom title for a single prepared link or a sole selected item from multiple links, matching existing save semantics. Subsequent name edits update the visible item without re-preparing its source.
- All 11 media preparation tests pass, including new single-link editable-title coverage and an assertion for partial batch selection. Analyze, macOS Debug build, Web Release build and whitespace checks pass.
- Actual rebuilt native retest at 600×800 and 1169×768 displayed the custom title in the prepared item. Editing/clearing/re-entering the name updated the preview; scrolling exposed the selected-item action. Saved `Sequence sweep B` using the same local test MP4. The resulting media list and actual player both displayed the saved title.
- Wide player: started `Local playback edited`, clicked Next and confirmed `Sequence sweep B` with decoded moving test video at 18 seconds. Previous returned to `Local playback edited` near the beginning; resizing to 600×800 rendered the video correctly. A subsequent narrow Next attempt returned AXError.failure, so narrow button operation and end-of-list behavior remain unverified. A later playback-change event exists, but its trigger was not observed reliably; do not count it as successful automatic advancement.
- Native AX access intermittently disappears while video is rendered; screenshots remain normal and cold restart restores controls. This remains a test-harness observation without a demonstrated product root cause. After restart, Stop succeeded. Selected only the temporary sequence media, confirmed single-item deletion, and refreshed: the original playlist plus two media remain (three total). Playback is stopped. Playback history/system events from this test remain; image fixture retained.
- Goal remains active for the outstanding browser and native workflows. Current browser is the unauthenticated public homepage at 390×844. No additional authenticated browser coverage is claimed in this follow-up.

## Browser invitation startup routing

- Real native Copy invitation reported success. Pasting into Edge's address bar independently confirmed the generated same-server `/rooms/join?room_id=room_6` URL. Navigating twice returned to `/` and silently lost the invitation. The backend serves HTML navigation for this route with HTTP 200; the application only registered OAuth callback routes and had no invitation startup route.
- Added invitation route handling in the application entry point, with one initial route instead of duplicate home shells. AppShell consumes the invitation once through the existing authentication/join workflow. Relative invitation parsing shares room-ID validation with absolute links; missing/ambiguous IDs fail without requesting a room. Ordinary startup and OAuth callback routing remain supported.
- All 74 selected shell, invitation and OAuth callback tests passed. New regressions verify startup target lookup, room-specific authentication, cancellation/refresh without reopening, and ambiguous-parameter rejection. Analyze is clean; macOS Debug and Web Release builds and whitespace checks pass.
- Real rebuilt Edge: navigating the copied URL now preserves the invitation address and opens Guest authentication with `room_6` prefilled. Inspected 390×844 at 100% preview and 1169×768 at 50% DevTools preview scaling (normal application text size). An intermediate attempted wide setting was clamped to 836px; final 1169px width was independently read back. All fields and actions fit. Closing returns to home; in-page Refresh does not reopen authentication. Browser reload preserves the URL and restores the intended guest target. Agreement remained unchecked, so actual guest sign-in/room entry is skipped at this boundary.
- Latest macOS cold startup restored root and normal homepage. Pasting the same absolute invitation into Join room and pressing Continue entered `20260909`, confirming same-server native invitation round trip. Playback remains stopped and previous fixture data remains. No account or room-policy mutation was made.
- Goal remains active. Remaining media source forms and other pending coverage are not claimed complete by this invitation fix.

## Live-source forms and local URL validation

- Actual native 600×800 / 1169×768: inspected RTMP and WHEP forms, RTSP TCP/UDP transport and explicit video-track index, and HTTP-FLV fields. RTMP Audio only selection survived resize. Empty source disables Preview and Add. RTSP track-index control fit the narrow form. No upstream RTMP/RTSP/WHEP service is available for this pass, so actual transport is skipped.
- Found malformed source input reached the prepare API and displayed an English transport exception with the internal endpoint. Added local source-field validation matching current backend rules: RTMP/RTSP scheme and host, HTTP-FLV HTTP(S) path ending in `.flv`, and HTTP(S) WHEP. Validation errors are localized and update after editing or protocol changes. Add still requires a valid prepared result.
- All 15 media preparation tests pass. Four new cases verify invalid input does not call the gateway or add media, the form stays open, and correction restores successful preview. Includes a query-only `.flv` false positive and a hostless WHEP URL. Analyze, macOS Debug, Web Release and whitespace checks pass.
- Rebuilt native: malformed RTMP address displays a Chinese inline error at 600px. Switching to HTTP-FLV and resizing to 1169px displays the matching path requirement; entering a complete local HTTP-FLV-shaped address immediately clears the error. This address was used for format recovery only, with no Preview request or media creation, and is not a real streaming fixture.
- Huya, Douyu, AcFun and CCTV source forms were each inspected at 600×800 and 1169×768; fields, default instance and actions fit, and empty resource inputs disable Preview/Add. Huya instance menu contained only Default instance. External resource resolution/playback for these public providers has not been attempted and is not counted as passed or unavailable solely for lacking credentials.
- Closing the add dialog correctly prompted to discard the retained live-source draft even after switching providers. Confirmed discard returned to the original playlist plus two media (three total), with playback stopped. No media records were created in this pass. Goal remains active for remaining source forms, available mutations and the existing browser/auth boundaries.


## Avatar cropping and resize regression

- Actual native account profile initially had no avatar. Selected the generated grid PNG and panned toward its green bottom-right marker. Resizing from 600×800 to 1169×768 reset the image position in the previous crop editor. No avatar was submitted before reproduction.
- The crop library resets its internal editing state on viewport dependency changes. The editor now uses a stable logical canvas scaled to fit its available space, isolating crop coordinates from dialog resizing. A full-width container keeps that canvas centered in short windows. No third-party package source was modified.
- All 21 picker tests pass, including actual pan/scroll-zoom and export through 600×800 → 1169×768 → 320×568 → 600×800. The resized export matches the non-resized export byte for byte. Existing malformed image, square/tiny crop, cancellation, stale route and crop retry tests remain passing. Analyze and macOS/Web builds pass.
- Real native fixed editor retained the green corner selection across 600×800 and 1169×768. Use edited image completed an actual avatar upload, displayed success, and showed the selected green corner in the saved square avatar. Refresh, narrow profile and cold restart retained the uploaded image. Final full-width layout was additionally inspected at 800×632, 600×800 and 1169×768; another pan/resize retained the selected content, and Cancel discarded that second editor draft.
- The uploaded test avatar revealed a separate overview defect: profile showed the image but the account overview still showed the initial. The hero omitted the existing avatar URL argument; this binding is now supplied. All 147 account page tests pass. Real rebuilt overview displayed the saved image at both 600×800 and 1169×768. Removed the disposable avatar through the confirmation dialog; success appeared, and refresh plus overview navigation restored the default R avatar. No avatar fixture remains on the account.
- Edge real reload successfully loaded the current Web build and restored the invitation target in the Guest dialog. Agreement remains unchecked; no authenticated browser avatar workflow is claimed. Goal remains active.


## Account room lifecycle and cover ratio switching

- Native account Rooms: changed Frequent to Name and observed the list reorder (the API currently defaults to descending order). The selected sort survived 1169×768 → 600×800. Created a disposable private room from the account list with a description and General category; General correctly displayed no available labels. Name, description, category and private setting survived widening before submission. Creation entered the new room and returning to account automatically increased the list from two to three records, preserving Name sorting. Account Manage opened that room's settings.
- Uploaded a generated cover through the actual image editor, refreshed, and checked the resulting cover in room information at 600×800/1169×768. Returning to account immediately showed the cover thumbnail. Cold restart retained the private room under Continue watching and retained its cover.
- Found another image-editor defect while switching Square → target ratio: all four drag handles could move outside the visible canvas. Actual export ratio remained correct; the defect prevented further visible handle adjustment. Ratio switching now fits the new selection inside the visible portion of the image without resetting image pan/zoom.
- New regression first failed on handle visibility, then passed after the fix; it also exports and checks the target 16:9 ratio. All 22 picker tests pass, including prior resize/pan/zoom byte-equality coverage. Analyze, macOS Debug, Web Release and whitespace checks pass.
- Real rebuilt editor: Square → target ratio leaves all four handles visible at 600×800. Dragged the top-left handle, widened to 1169×768, and confirmed the adjusted rectangle persisted; Use edited image successfully uploaded the new cover. Removed the cover through its action (immediate removal, no confirmation dialog), then refreshed and confirmed the placeholder.
- Room deletion confirmation displayed the disposable room name and impact at 1169×768 and 600×800. Cancel retained the room. Reopened and confirmed Delete from room management: application returned to home, removed the room from Continue watching, and showed success. Account overview returned to two rooms; account Rooms plus Refresh confirmed the original two entries only. Disposable room and cover have been cleaned; existing room/media/chat fixtures remain.
- Browser authenticated coverage is unchanged. Overall Goal remains active. Account-list Delete/Leave actions themselves, additional sort modes, pagination with sufficient fixtures, and other remaining matrix workflows are still pending; this pass validates deletion from active room management, not every deletion entry point.


## Account overview scope and membership refresh

- Found a real scope defect after leaving Friday Film Club through Account Rooms: Joined correctly became empty, but Overview also reported zero rooms and no recent rooms even though the created room still existed. Overview had reused the searched/filtered/paginated list response.
- Overview now loads an independent unfiltered first page ordered by last visit, with its own request revision, loading and error state. Create/manage/open/leave/delete return paths refresh both projections. Global refresh now uses the same search/relation/sort/refresh parameters as the room list's own reload.
- Added a regression that submits a missing-room search, returns to Overview, performs global refresh, confirms search preservation, and changes membership through the room action callback. All 148 account page tests pass; analyze, macOS Debug and Web Release builds and whitespace checks pass.
- Real rebuilt macOS: Joined zero plus missing search and global Refresh retained the correct one-room overview. Rejoined Friday Film Club through the public card; overview showed two and placed Friday first. Screenshots at 600×800 and 1169×768 showed readable statistics and recent-room actions; narrow scrolling reached both records and footer actions.
- Exercised all six account room sorts: frequent, last visit, last activity, update, creation and name. Last visit/activity/update/name placed Friday first; creation placed the newer owned room first. Filtered Joined correctly retained only Friday.
- Actual Leave confirmation was inspected at both widths. Confirming at 600px removed the joined result and immediately changed Overview from two to one, preserving the owned room. Rejoined Friday again through its public card; the home card and Continue watching both show Joined. The original two memberships are restored; generated join/system audit events remain. No avatar or additional room fixtures remain from the account lifecycle work.
- Browser account coverage remains skipped at the existing unchecked agreement boundary. Goal remains active; account-list owned-room deletion, sufficient-data pagination, remaining source/subtitle/admin workflows still need coverage.


## Browser fallback icon and system locale persistence

- Real Edge loaded the new account build at 1169×768, then 390×844. The invitation retained room_6; the narrow guest sheet was inspected at 100% DevTools preview with all fields/actions readable and agreement unchecked. Authenticated actions remain skipped at that boundary.
- Browser Console revealed two missing favicon.ico requests. Added a standard ICO fallback using the existing 64px PNG brand asset. Web Release rebuild passed; actual test-backend readback now returns HTTP 200 and image/x-icon. Cleared the old Console messages and reloaded the real browser: no errors remained; only the browser extension's informational LanguageDetector message appeared.
- Browser 390×844: selected Follow system, reopened the language sheet and verified its checkmark. Reloaded the page, closed the restored invitation, reopened language and confirmed Follow system persisted. Restored Simplified Chinese.
- Native 600px: selected Follow system and cold restarted. Root session and both original room relations survived; reopened the language sheet, resized to 1169×768 and verified Follow system remained selected. Restored Simplified Chinese. Current system language resolves to Chinese on both clients; no operating-system language setting was modified.
- Current position: native wide public homepage with root; browser 390×844 public homepage, Chinese, normal application text size. No pending temporary membership, avatar, cover or language change from this follow-up. Full Goal remains active for outstanding matrix workflows.


## Account pagination and list deletion

- Created 25 private, disposable pagination fixtures with creator membership and settings in the isolated UI test database. The account overview correctly reported 27 rooms. Searching Pagination sweep returned 25 matches, page one 1–24 and page two 25–25. Wide→600px resizing preserved the second page and search; global refresh retained the search and page while data was unchanged.
- Account-list Delete confirmation for Pagination sweep 01 fit at 600×800 and 1169×768. Cancel retained the sole last-page record. Confirmed deletion through this entry point: the filtered total became 24 and automatically returned to page one, while Overview immediately became 26.
- Found a separate global-refresh defect by removing the remaining fixtures externally while the account list was on page two: it displayed page 2 of 1, range 25–2 of 2 and an empty list despite two surviving rooms. The list reload already corrected out-of-range pages; global refresh bypassed that logic.
- Both paths now share a valid-page fetch helper that reloads the last valid page when totals shrink. A regression simulates external deletion on page two and requires requests for page two followed by page one, with the surviving room visible. All 149 account tests pass; analyze, macOS Debug, Web Release and whitespace checks pass.
- Rebuilt native real retest repeated the external deletion at 600px: global refresh returned to page one, range 1–2 of 2, and restored the original two records. Resizing to 1169px retained correct pagination and displayed both records with intact actions.
- Cleanup: the one fixture deleted through the UI and the remaining 24 externally soft-deleted fixtures are absent from active rooms; database readback shows the original six active rooms only. Test fixture IDs 9–33 remain as deleted test records, with no active added room. Original root membership in Friday Film Club and ownership of 20260909 remain intact. Browser authenticated account pagination remains skipped at the agreement boundary.
- Current native position: wide Account Rooms, All, no search, frequent sort, page one with the two original rooms. Goal remains active for outstanding media/subtitle/admin and other matrix workflows.

## Notification query, pagination and selection refresh

- Seeded 51 disposable account notifications (50 unread, one read) in the isolated test database. Actual native Read filtering returned only the read fixture; global Refresh incorrectly replaced it with all 51 while leaving Read selected. With page two open, externally deleting 50 fixtures reproduced page 2 of 1, range 51–1 and an empty list despite a surviving notification.
- Global and module refresh now share notification query parameters and a valid-page fetch helper. Both apply the resolved page and reconcile selected IDs against current results. Existing module request-revision guards remain in place.
- Added regressions covering read/type/search/title/ascending/refresh parameter preservation, stale selection removal, and page-two shrink requiring requests for page two followed by page one. All 151 account tests pass; analyze, macOS Debug, Web Release and whitespace checks pass.
- Rebuilt real native Read→global Refresh retained one read result at 600×800 and 1169×768. Repeated external deletion while on page two; Refresh at 600px returned to page one, range 1–1, with the surviving record visible. Wide layout retained correct pagination.
- Real System announcement filtering returned zero and stayed zero after global Refresh; Room invitation restored the sample. Missing-keyword search stayed empty after Refresh. Three fixture titles sorted descending 03→02→01, then ascending 01→02→03; global Refresh and wide→narrow resizing preserved search, type and ascending order.
- Selected a fixture, removed all remaining disposable notification records externally, then refreshed the native client: selected-count action disappeared and the account returned to zero total / zero unread with a valid empty first page. Database readback independently confirmed zero notifications for the account. No notification fixture remains.
- Browser refreshed the latest Web build at 390×844; authenticated notification workflow remains outside current browser session coverage. Goal remains active for remaining matrix workflows.

## Subtitle selection across player replacement

- Temporarily attached two independently named local WebVTT tracks to the retained local video. Actual native default track rendered at paused 21 seconds. Wide selection sheet showed both tracks and selected English; selecting Alternate eventually rendered its distinct text without advancing playback.
- Reproduced a responsive state defect: resizing from 1169px to 600px changed Alternate back to the default English track. Subtitle selection lived only in the disposable player widget state.
- Added a room-session subtitle selection controller shared by embedded and fullscreen players. Explicit selected/off state is scoped to playback resource identity; rebuilt players restore it, and another resource uses its own default. Existing async subtitle load-generation guards remain.
- New widget regression selects the alternate track, replaces the complete player widget, confirms that track is loaded and visible while paused, turns subtitles off, replaces again without loading a track, then changes resource and verifies default-track rendering. All 52 player interaction tests pass; analyze, macOS Debug, Web Release and whitespace checks pass.
- Real rebuilt native loaded the paused fixture and default subtitle, but repeated settings-coordinate actions failed with AXError.failure. Cold restart, window activation, keyboard traversal and automation reconnection did not provide a reliable post-fix selection action. The actual fixed selection/resize/fullscreen retest is NOT claimed complete. Subtitle-style mutations also remain unverified.
- Investigated semantic merging as a possible automation cause. The test could independently locate Playback progress; its temporary failure was a test-handle cleanup problem. No semantics change was retained, and no product cause for AX failure is claimed.
- Cleanup: restored exactly the retained video's original source configuration without subtitles and read it back from the database. Actual Stop returned the native room to waiting-for-playback with success feedback. Playback had advanced during container-focus experimentation before Stop; do not infer continuous pause throughout automation troubleshooting. Original media entries remain. Test playback history may retain the subtitle snapshot.
- Goal remains active. Next pass should prioritize other available workflows, and retry the outstanding real subtitle-selection/style checks when native control access is reliable.

## Populated registration review and required rejection reason

- Seeded two disposable registration requests with synthetic OAuth identity metadata, without contacting an external provider. The original registration queue was empty. Native pending queue displayed both applicants, method, email, instance and provider identity; normal 600px and 1169px layouts were inspected.
- Reproduced blank rejection submission closing the dialog and returning a database constraint error. The shared registration/creation/join rejection dialog now validates a trimmed, required reason within a Form and supports Enter submission. Empty input stays open with localized required feedback instead of issuing a request.
- Extended decision/concurrency regression to cover empty and whitespace-only input, no extra gateway calls, retained dialog and valid Enter submission. All 55 review/secondary-list tests pass; analyze, macOS Debug, Web Release and whitespace checks pass.
- Native approval created the intended test user and reduced pending count 2→1. Database confirmed approved status/reviewer and a newly created user; cold-start admin overview showed users 13→14.
- Rebuilt native empty rejection at 600px retained its dialog with 请输入原因. Widening to 1169px retained the readable error and actions. Entering the explicit test rejection reason and pressing Return succeeded; pending count became zero. Rejected filtering showed exact reason, reviewer and review time; Refresh at 600px retained those values. Approved filtering independently showed the approved applicant and review metadata.
- Cleanup removed both disposable requests, the synthetic OAuth identity and the generated user in one guarded transaction. Initial direct user deletion was refused by the identity foreign key and rolled back; dependent identity was then removed before the user. Database confirms registration requests zero, users restored to 13, and no synthetic OAuth identity remains.
- This validates admin review of prepared test requests, not external OAuth signup/login. Browser authenticated workflows and the previous subtitle post-fix real-client checks remain outside this pass. Goal remains active.


## Taxonomy binding and cache scope follow-up

- Native 600×800: the label create/edit form shows all fields, category selection, enable switch and actions. Created a disposable unbound label using default color; count changed 10→11 and its card/readback showed unbound category. The color swatch is an input preview, not a separate picker.
- Changed the same label to General, saved, reopened and confirmed General. Used the category field's Clear action, saved again, and the list returned to unbound category. The narrow card wraps name, slug, category, color and sort without overflow.
- Inspected the narrow deletion confirmation with the explicit fixture name and consequences, then deleted that fixture through the UI. The label count returned to 10. No original category or label was mutated.
- Native 1169×768 category editor: inspected the existing Film & TV slug, name, description, sort, enable switch and footer actions; Cancel preserved it. This closes the prior missing wide category-editor observation.
- Cache management currently reports one enabled memory backend with zero bytes/items/metadata, 512 MiB capacity and 2 MiB slices. All nodes toggling returned the same single node. Wide and 600px layouts show the metrics and scrollable configuration; All nodes disables the node-ID input.
- A nonexistent node query returned the backend's unavailable-cluster-client error, retained its input and displayed no statistics. Clearing the input restored current-node statistics. No cache mutation was made in this pass. Populated cache eviction is not claimed; cross-node operations require a cluster client absent from this environment.
- No production code changed in this follow-up. Prior 55 review tests, analyze and macOS/Web builds remain the latest verification. Current native view is narrow cache management, All nodes off, node filter empty. Goal remains active.


## Playlist access, cover, ordering and nested cleanup

- Created a disposable static playlist through native media management. Default access saved and reopened correctly; changed to Room members, saved/reopened, then Creator only, saved/reopened. Name and description remained intact. Actual edit dialog inspected at 600×800 and 1169×768. This verifies settings persistence for the creator session; another member's authorization enforcement is not claimed.
- Moved the fixture above the retained Validation sweep playlist, refreshed, and resized wide→narrow: the new order persisted. Moved it down again successfully, restoring the original relative order. The current playlist menu offers relative ordering, not a move-to-parent/destination action.
- Uploaded the existing generated test image via the native file chooser and real crop editor. Narrow editor displayed crop selection and all actions. Use edited image succeeded; Refresh plus widening retained the new thumbnail. Playlist details displayed the cover, name, description, ID, child/media counts and footer actions at both widths without overflow.
- Removed the cover through the playlist menu; the thumbnail immediately returned to a folder placeholder. Entered the disposable playlist, created Nested playlist sweep, and opened it. The wide breadcrumb displayed both levels and the empty child state; Up returned to the correct parent with one child.
- Inspected Clear current level confirmation at both widths, then confirmed in the disposable parent. Child count changed 1→0, the parent remained navigable, and returning to root retained both original media and the original playlist. Deleted the temporary parent through its explicit named confirmation. Final wide UI shows the original three root entries only: Validation sweep, Sweep playback and Local playback edited. Both temporary playlists are removed from the active media library; no test cover remains assigned.
- System file chooser briefly required explicit activation before Return worked; no application defect was inferred from that automation focus issue. No production code changed and no new build/test run was necessary. Browser authenticated coverage and the subtitle post-fix real-control limitation remain as previously recorded. Goal remains active.


## Provider form drafts across responsive layouts

- Actual CCTV add-media form: empty resource disables Preview and Add. Entering an invalid test resource produced backend invalid-URL feedback. Found that changing between 1169px and 600px cleared both resource and custom name. Independently reproduced with populated fields and no request: resizing alone discarded the draft.
- Root cause was replacement of the outer Row/Column and the stateful source subtree. The dialog now uses a stable Flex with responsive direction and a keyed Expanded source panel. Provider-local controllers and operation state remain attached across the responsive breakpoint; no provider API or source-switch policy changed.
- Added a regression using the actual compact source selector, CCTV resource/name input and repeated resizing through 1169, 600, 1300 and 430px. It failed on missing draft text before the fix and passed afterward. All 25 dialog layout/prepare tests passed. Analyze, macOS Debug, Web Release and whitespace checks passed.
- Real rebuilt macOS: entered resource and name at 1169px, resized to 600px and visually confirmed both complete strings. Requested invalid preview at 600px, resized back to 1169px and confirmed error feedback plus both intact inputs. Fields and actions fit at both widths. Close still displayed discard confirmation; explicitly discarded the test draft and returned to the original three-entry media library.
- No media record was added. CCTV valid external-resource resolution has not been exercised; no claim of external-service failure is made from the intentionally invalid input. Other locally reachable add-media source forms remain to be swept. Browser authenticated checks remain outside the current agreement boundary. Goal remains active.


## Live pull forms and local HTTP-FLV playback

- Native RTMP empty form inspected wide; Preview/Add disabled without a source. RTSP inspected at 600px and 1169px: selected explicit video track index (displayed 02 after appending to default 0), changed TCP to UDP, resized wide and confirmed both selections survived. No RTSP connection was attempted.
- WHEP form exposes optional masked authorization input and name. Invalid source produced localized inline HTTP/HTTPS URL guidance and retained the draft at 600px. Switching to HTTP-FLV changed the validation guidance appropriately; entering a valid HTTP URL ending in .flv removed the error. Wide/narrow protocol controls and footer actions fit.
- Remuxed the existing generated local MP4 into a finite FLV fixture and confirmed its test-server URL returned HTTP 200. Actual narrow Preview returned sweep.flv marked Live. Set a custom name and added the source through the UI; media count changed 3→4. Details showed the saved custom name, live-media type, liveProxy provider and httpFlv URL/source configuration.
- Selected the new entry in the room playback list. Real wide playback rendered the generated video at approximately 14 seconds; narrow playback also rendered it, with normal live-player controls. After responsive switching, the finite source displayed approximately 5 seconds; this observation alone did not establish that resizing caused a reconnect. This proves actual local HTTP-FLV playback at both widths, not seamless live continuity or long-running streaming stability. The fixed-window follow-up below reproduced source repetition without resizing.
- Stop returned to waiting-for-playback. Deleted only HTTP FLV sweep through its named confirmation; media library returned to the original playlist and two media entries. Local FLV file remains available for later transport/continuity checks; playback history/system events may retain the test snapshot. No persistent RTSP/WHEP or protocol draft remains.
- No production code changed in this follow-up. Previous 25 dialog tests, analyze and macOS/Web builds remain the latest checks. Browser authenticated workflows and other source/transport coverage remain as previously scoped. Goal remains active.


## Finite FLV repetition control experiment

- Audited the native video lifecycle: the room owns its VideoPlayerController; CustomVideoPlayer disposal removes listeners/timers without disposing the video controller. The platform view binds the existing media-kit controller. No layout-triggered reopen call was found in these paths, so no speculative lifecycle change was made.
- Backend HTTP-FLV puller treats clean EOF after a complete FLV header/tags as ReconnectRequired and retries established frame-based sources. A finite file therefore differs from a continuously produced live feed.
- Tried replaying the previously deleted HTTP-FLV media through its retained history. Backend returned Playback history media not found; the page remained usable and no playback started. Recreated a disposable source through the existing Preview/Add flow for an independent control.
- Held the real native window at 600px throughout playback. The local test video visibly advanced to approximately 47 seconds, then a later observation showed approximately 9 seconds with the window unchanged. Only outer-page scrolling exposed the full player; no resize, reload, seek or fullscreen action occurred. This establishes that finite-source repetition also occurs without responsive switching and invalidates the prior resize-only causal inference. It does not prove seamless continuous-stream behavior.
- Stopped playback and deleted only FLV continuity sweep through its named confirmation. Media management returned to the original three entries. Test history/system events remain; no additional active media remains. No production code changed. Previous test/build checks remain valid; whitespace check passed. Goal remains active for outstanding available workflows.


## Provider source switching and remaining live-provider forms

- Reproduced a distinct AcFun draft-loss defect after the responsive fix: switching AcFun → Huya → AcFun cleared resource and name without a discard prompt. The add-media dialog now lazily retains visited source forms in a keyed IndexedStack; inactive forms exclude focus and disable tickers. Source-local form state survives switching without eagerly constructing every provider.
- Extended the actual compact-selector layout regression to switch away and back before the existing width sequence. It failed before the fix; all 25 layout/prepare tests pass afterward. Analyze, macOS Debug, Web Release and whitespace checks pass.
- Rebuilt native real retest: entered separate AcFun and Huya resource/name drafts, switched both ways, and resized through 800px, 1169px and 600px. Screenshots confirmed each source retained its own input at wide and narrow widths. Closing from another source with an empty current subform still displayed discard confirmation for existing drafts. Explicit discard returned to the original three media entries; no media was added.
- Huya and Douyu empty forms disable Preview/Add. Invalid Huya resource preview returned Resource not found; a non-Douyu URL returned URL is not a Douyu room. Fields remained usable; Douyu draft persisted through narrow-to-wide resizing. No valid external resource or HEVC/audio resolution is claimed.
- Twitch wide resolve form and narrow media-selector/dynamic-list forms fit with normal font size. Non-Twitch URL preview returned URL host is not Twitch. Media selection exposes channel archive, followed live, category browse and live-channel search. Followed-live Preview with the default unconfigured account returned Credential required and retained the form. Authenticated external Twitch data is skipped without configured credentials; successful remote playback/list creation is not claimed.
- Native is left in narrow room media management with the original playlist and two media. Goal remains active for outstanding available workflows; browser authenticated and subtitle real-control limitations remain as recorded above.


## Media combined filters and source-to-connection navigation

- Real native media management: Direct URL filtering returned only the two direct media, excluding the static playlist. Refresh and 600px→1169px resizing preserved that selection and count. Instance remained disabled at Local instance for this source.
- Unavailable filtering returned a clear no-matching-media state; Refresh and 1169px→600px preserved both filters and zero results. Available restored the two media. This verifies current stored availability filtering, not live reachability probing: the historical public URL failure does not imply a stored unavailable flag.
- Name ascending ordered Local playback edited before Sweep playback; descending reversed it. Refresh retained descending order. Search Local combined with Direct URL, Available and descending returned one matching media; Refresh and widening retained query, all selections and the result. Clearing search restored both results.
- Restored All sources, All availability, Position ascending and empty search. Original three entries returned. No data mutation occurred in these filter checks. Sufficient-data media pagination still lacks a real-client pass; the single-page checks do not establish page-shrink behavior.
- FNOS add-media empty state displayed the binding prerequisite. Its Bind now action opened Connection management on the correct FNOS tab. Opened the binding form wide, resized to 600px and scrolled to password/actions; all fields and Cancel remained reachable. Cancel returned to the empty FNOS account list, closing management returned to the FNOS source, and closing add-media returned to the original media library without an unnecessary discard dialog. No binding or credential was submitted. Other provider binding forms already have earlier evidence; successful external access remains skipped without services/credentials.
- No production code changed; prior 25 layout/prepare tests, analyze and macOS/Web builds remain the latest verification. Goal remains active. Native is left at 600px in media management with default filters and the original three entries.


## Media management pagination with populated fixtures

- Inserted 51 uniquely named disposable direct-media fixtures in the isolated room, cloning only the retained local source configuration. Root total became 54 including the original playlist and two media. Native 600px Refresh showed 50 entries on page one; scrolling reached the visible page-one footer and enabled Next.
- Next displayed page two with four remaining entries and disabled Next. Resizing to 1169px preserved page two and its contents. Search for Pagination sweep 51 from page two returned the single matching fixture on page one; clearing restored the full 54-entry result. Returned to page two again through the real footer.
- Deleted exactly the 51 disposable database records while the native client remained on page two. Actual Refresh returned to page one, total three, displaying the retained playlist and two media with valid navigation controls. This exercises the UI refresh path, which restarts at page one; it does not claim automatic page correction before a refresh or every server-push race.
- Database cleanup confirmed the retained room's two original active media only; the original playlist also remains visible. No test media was played and no new playback history was generated in this pass. Default filters and empty search remain. Native is left in wide media management.
- No production issue was found and no production code changed. Whitespace check passed; previous test/build results remain valid. Goal remains active for the remaining sweep; sufficient-data media page navigation/search/refresh now has actual native evidence.


## Member and guest permission persistence

- Recorded the original room settings from the test database. In the real wide native settings, enabled all four guest permissions and saved successfully. Backend readback showed the four-bit guest allowance and no removal; revisiting settings at 600px showed all four enabled with intact labels/actions. Restored all four off through the narrow UI and saved.
- Disabled all seven ordinary-member permissions through the narrow UI: chat/danmaku, add media, browse library, member list, chat history, voice and P2P. Save succeeded; database readback showed memberRemovedPermissions=127, guest policy restored, and the independent room chat/voice/P2P switches still true. Wide layout displayed the disabled member controls.
- Re-enabled all seven member permissions in the wide UI and saved. Independent database readback exactly matched the original settings JSON, including permission masks, communication flags, capacity, join policy and autoplay configuration. No member, guest or media fixture was created in this pass.
- This is creator-session configuration and persistence coverage, not a second user's authorization or actual voice/P2P transport test. No new defect or production change was found. Native remains wide in room settings. Historical pending items were reconciled above to prevent repeating completed workflows; Goal remains active.


## Room-management realtime resource diagnostics

- Actual native management diagnostics Overview showed four subscribed resources, zero events and zero exceptions. Copy diagnostics displayed its success notification. Attempt to open an independent text viewer timed out; pasting into an unsubmitted native search field inserted nothing. Clipboard payload completeness remains unverified; no clipboard defect is inferred from the automation result. Search stayed empty.
- Resource cards displayed room settings, members, media and chat state. Wide layout uses two columns; resizing to 600px uses one column and retains the selected Resources tab. Long versions wrap, and the scrollable resource cards remain readable. These are resource snapshot observations, not live event-delivery assertions.
- Clicked Reset listeners at 600px, then Overview: four of four resources returned ready, with zero exceptions. The media watch received a new generation identifier. Events displayed a readable zero-event state; no individual event copy or detail workflow is claimed from that empty list.
- Returned to Media after resetting listeners: the original playlist and two media still render with valid first-page controls. No database mutation, source playback or settings change occurred. Native remains narrow in media management with empty search. No production changes or additional builds were needed. Goal remains active; copy payload and individual event workflows remain limited as above.


## Uncategorized creation-review decoding repair

- Investigated the previously observed uncategorized creation-request failure. The list query LEFT JOINs categories but its SQLx offline metadata marked category_id non-nullable; the detail query's metadata differed. A new isolated PostgreSQL regression inserted an uncategorized pending request and failed on the list with ColumnDecode / UnexpectedNullError before any production edit.
- Backend review repository now explicitly marks the joined category ID nullable in both list and detail queries. Updated the corresponding query aliases and hashed offline cache files without changing query semantics. The new regression now passes list and detail checks with category=None; all eight secondary-read repository integration tests pass. Backend builds, including the required web-ui-dynamic feature, and whitespace checks pass.
- Test backend was restarted with the original development target, isolated database, static frontend directory and development configuration. Shutdown required approximately 30 seconds; an initial short wait expired, and the first build lacked the dynamic Web feature. Both operational issues were corrected. Final local frontend returns HTTP 200, and the existing authenticated macOS room session reconnects with live latency and normal chat/settings controls.
- No creation request was inserted into the shared UI database in this pass: regression fixtures used the isolated integration-test database. Actual rebuilt native creation-review list at wide/narrow widths remains the next required verification; this entry does not claim that GUI regression is complete. Goal remains active.


## Uncategorized creation-review real-client verification

- Inserted one disposable request with category=NULL into the shared UI test database. Corrected its manually seeded status from 0 to the backend Pending enum value 1 before exercising the list; the initial zero-result state was test-data preparation, not a product defect.
- Rebuilt backend/native pending creation queue displayed the uncategorized request normally at 600px and 1169px. No service-unavailable or decode failure occurred. Rejected the fixture through the real dialog using an explicit test-only reason; pending count returned to zero.
- Rejected filtering showed the exact reason, reviewer and review time at both widths. Refresh retained the result. Database independently confirmed rejected status, unchanged NULL category, root reviewer and exact reason. This completes real list/rejection/readback regression for the nullable-category repair; uncategorized approval was not executed in this pass.
- Deleted exactly the disposable request using its ID, name, description, rejected status and reviewer guards. Database confirmed no matching fixture remains; native Refresh returned to the original single rejected creation request. No new room or user was created. Eight prior repository integration tests and the dynamic-Web backend build remain the relevant checks. Goal remains active; native is left at narrow Admin Reviews → Creation → Rejected.


## Administrator form validation and role round trip

- Native 600px reproduced empty Promote closing the dialog and showing only a warning. The creation path had the same post-dismissal required-field validation, and both paths discarded input on backend failure.
- Replaced those inline forms with one dedicated administrator dialog for creation/promotion. Required fields validate before closing, requests retain the form until success, duplicate submissions are blocked, and cancelled/covered routes cannot dismiss unrelated dialogs after a late response. Password content is preserved exactly; identity values are trimmed at submission.
- Rebuilt native 600px: empty Promote retains its field and visible required error. A nonexistent test ID returns the real backend User not found error while preserving the editable ID. Maximizing the native window retains the draft and usable actions.
- Promoted the existing test user olivia through the native wide dialog; the list increased from one to two administrators. Refresh and return to 600px retained both records. The current root account retained its disabled removal action. Removed olivia through the narrow confirmation; list returned to root only. Database independently confirms olivia role restored to original USER (3), root remains ROOT (1), and total users remains 13.
- New-administrator empty submission displays both username/password required errors without closing at 600px and maximized width. Cancel closes normally. Successful creation of a new administrator was not performed in this pass.
- 54 administrator dialog/list regression tests passed, analyze clean, macOS debug and Web release builds passed, whitespace check passed. Real verification in this pass is native only; authenticated browser administration remains outside the current usable session boundary.
- Native continuation: maximized Admin → Administrators, one original root record, no dialog. Remaining runtime inputs and other outstanding areas in the reconciliation still need assessment; Goal remains active.


## Runtime editor server-failure retention and history settings

- Native playback-history retention: empty Save retains the editor with its required-number error. Changed 90 days to 91 at 600px, refreshed all settings and reopened to confirm 91, then restored 90. Wide and narrow description/error/action layouts were inspected.
- Found a second post-dismissal validation defect: setting history quantity to -1 closed the editor before the backend rejected its allowed range (0–100000). The stored quantity remained 1000, but the correction draft was lost.
- Runtime setting editors now await confirmation and the write before dismissing. Rejected writes retain the draft for correction, submission blocks repeated Save and editing, and success removes only the originating route even when another route covers it. Existing warning confirmations remain in place. Covered editors stop their loading indicator while confirmation is visible.
- Rebuilt native 600px: -1 returned the real server range error and retained the open editor, -1 text and enabled Save. Maximizing retained the draft; corrected it to 1001 and successfully saved. Refresh All retained 1001. Reopened and restored 1000; the companion retention remained 90. No history was intentionally removed or created in this pass.
- Relevant runtime suites: 75 existing non-numeric cases passed; all 11 numeric cases (including the new server-rejection/correction regression) passed after fixing the test's protobuf string expectation and notification timer cleanup. Analyze clean, macOS debug and Web release builds passed, whitespace check passed. Browser authenticated runtime mutation remains skipped at the known session boundary.
- Continuation: native maximized Admin → Settings → Playback history, quantity 1000 and days 90, editor closed. Remaining runtime categories still require the available-function assessment; this follow-up does not claim the complete settings sweep.


## Room-default and chat runtime mutation follow-up

- Native wide room-default settings: changed new-room chat snapshot limit 500→501, refreshed all, resized to 600px and confirmed 501 persisted. Reopened the narrow editor and restored 500.
- Default room member limit: changed 100→101 at 600px, refreshed all, maximized and confirmed 101 persisted. Reopened and restored 100. This verifies the runtime setting write/readback; no new room was created to assert inheritance in this pass.
- Chat runtime settings: changed per-room pinned-message limit 20→21 wide, refreshed all and resized to 600px; 21 persisted. Reopened and restored 20. Other chat values stayed at 500 messages and 90 days. Narrow scrolling exposed the complete final retention card and its edit action without clipping or unreachable controls.
- No new product defect was observed and no code/build changes were needed for these checks. No rooms, users or chat messages were created or deleted. Existing retention tests/builds remain the latest validation, not newly rerun results.
- Continuation: native 600px Admin → Settings → Chat, scrolled to the bottom. Remaining runtime categories and broader reconciliation gaps remain active.


## Creation, user-policy and optional RTMP editor follow-up

- Native creation runtime category inspected at 600px (including bottom scroll) and maximized width: creation review off, creation allowed, max rooms 10, password policy Optional. Password-policy radio cards and descriptions fit both widths; selected Required as a draft, maximized with selection retained, then Cancel restored the saved Optional state. No password policy mutation was submitted.
- User runtime category: all seven switches were inspected wide and through narrow scrolling. Guest access and password registration are enabled; email/Passkey registration and all three registration-review switches are off. Guest toggle opened its warning confirmation; wide and 600px content/actions fit. Cancel preserved guest access on. No registration/security policy was changed in this pass.
- RTMP optional-address editor: original unset state opened with its switch off. Enabled draft editing, entered invalid-address, and Save returned the real backend invalid URL error while retaining the editor and input. Narrow resize retained the draft and readable descriptions/actions. Switched the optional field off and saved successfully; page returned to Unset, with TS-as-PNG still off. This exercises the clear/unset request and server-failure retention, not valid RTMP connectivity or active-stream behavior.
- No new product defect was observed or code changed in this pass. Native continuation: 600px Admin → Settings → Streaming, no dialog, original effective values retained. Other remaining runtime categories still require assessment; Goal remains active.


## Email-list and CORS confirmation follow-up

- Email runtime inventory confirms mail disabled, SMTP host/from/credentials/proxy unset, sender name SyncTV, port 587, TLS on, whitelist empty and disabled. Actual mail delivery is skipped without configured SMTP service. Test-mail empty recipient retains its dialog and localized required error; inspected wide and at 600px, then cancelled. No email was sent.
- Email whitelist editor: entered example.test, added a second @example.test draft, resized to 600px with both visible, deleted the second row and verified the first stayed intact. Cancel returned to the original empty whitelist. Bottom email cards and actions are reachable by scrolling.
- CORS editor: entered disposable origin text, selected Save and inspected the warning confirmation wide/600px. The editor beneath it remained open with Save disabled. Cancelling confirmation restored the editable draft and enabled Save; cancelling the editor retained the original empty list. No CORS change was submitted. The keyboard-layout colon issue means this was confirmation/draft coverage, not valid-origin validation or cross-origin networking evidence.
- No new product defect or code change in this pass. Native continuation: 600px Admin → Settings → CORS, no dialog. SMTP proxy/credential local form assessment and remaining runtime categories still need reconciliation; Goal remains active.


## SMTP authentication and proxy local-form follow-up

- SMTP authentication editor: enabled only its draft switch, submitted blank fields, and observed localized username/password required errors at maximized width and 600px. Cancel preserved the unset credentials. No credential was entered or saved.
- SMTP proxy editor: enabled its draft switch and submitted the empty URL; the field displayed the SOCKS5 host/port requirement. Enabled nested proxy authentication and submitted again; URL, username and password errors all fit the 600px dialog with Save/Cancel visible. Cancel closed normally. No proxy endpoint or credential was saved; real SMTP/proxy connectivity remains skipped without configured services.
- No new product defect or code change. Native continuation: 600px Admin → Settings → Email, no dialog. Full Flutter regression started for the accumulated frontend changes; its result is pending and must not be inferred from earlier suite counts.


## Final regression repair and OAuth2 local forms

- Full suite exposed a playlist Checkbox bypassing the app wrapper. Switched it to AppCheckbox and exposed optional shape/activeColor forwarding to retain its existing circular appearance and selection behavior. No wrapper-guard exclusion was added.
- Three Nextcloud Chinese test failures were caused by hard-coded English selectors; tests now resolve the active localized app-password and browser labels. Icon generation failed because the child Dart command used a different SDK on PATH; running with the project Flutter SDK first on PATH resolved the kernel mismatch without product changes.
- Focused regression: 35 passed. Complete rerun with the project SDK: 3030 passed, 1 skipped. Flutter analyze reports no issues; git diff --check passes. Latest native/Web rebuilds pending.
- Native OAuth2: no provider instances configured. OIDC empty Save preserves the dialog and displays Client ID, Client Secret and Issuer validation. Narrow and maximized error layouts inspected; switching to GitHub updates the generated instance name and removes OIDC-only endpoint fields while preserving applicable errors. No credential entered or provider saved. Actual authorization skipped without a configured identity service.
- Goal remains active. Remaining real-client playback/realtime controls and final build verification are not claimed complete.


## WebRTC limit readback and build verification

- Native WebRTC runtime cards inspected maximized and at 600px. Voice participant limit changed 8 to 9, Refresh All retained 9, narrow layout displayed the saved value, then the narrow editor restored 8 successfully. An input automation selection failure first produced 89; the rejected save retained that draft and the original saved value 8. The input was visually corrected before the successful mutation. No voice session or ICE configuration was changed.
- Latest macOS debug and Web release builds both passed after the wrapper repair. Complete Flutter regression remains 3030 passed / 1 skipped, analyze clean.
- Native continuation: 600px Admin Settings / WebRTC, no dialog, original voice limit 8 and two existing ICE servers. Remaining matrix gaps still require continuation; Goal is active.


## Realtime clipboard and live group identity repair

- Native Copy events displayed success. Independently parsed the resulting clipboard as JSON: exactly 100 retained entries, all carrying timestamp/direction/label/detail/byte_length/payload, with incoming and outgoing records. This completes actual clipboard-payload evidence.
- Real live inspection found expansion moving from resourceEvent to heartbeatAck as groups reordered by latest timestamp. Group rows previously reused positional state. Added stable group keys and view-owned expansion identities, pruned when groups disappear; the shared accordion forwards expansion changes.
- New regression exercises expanding resource, receiving a newer heartbeat, reordering, preserving resource payload visibility and keeping heartbeat collapsed. Together with shared controls and UI guard, 181 tests pass; analyze clean, macOS debug and Web release builds pass, whitespace clean. Earlier full suite 3030/1 predates this repair.
- Rebuilt native real retest used keyboard Tab/Return after video rendering caused AX control-tree loss and mouse AXError.failure. Expanded heartbeatAck at the top; subsequent real resource/WebRTC events moved it to third position while it remained expanded and preceding groups stayed collapsed. Resized to about 768px: heartbeatAck JSON remained expanded/readable; about 630px still showed other groups correctly collapsed. Local video remained rendered at its end frame.
- Browser inventory currently fails with Codex auth token unavailable. No new browser functional pass claimed. Native coordinate resize and keyboard work; click/scroll AX failures limit remaining playback controls. Goal remains active.


## Free-mode thresholds and cache preference persistence

- Native coordinate actions recovered at about 630px. Stop playback succeeded and returned the player to Waiting. Free-mode sliders changed correction threshold 1.2s to 4.15s and manual trigger tolerance 0.2s to 0.5s. Save displayed success. After the app connection was reacquired and the room/settings reopened, both values persisted. Maximized view retained them.
- Restore defaults immediately saved free mode off / 1.2s / 0.2s. Left settings and reopened; those restored values persisted. This completes the previously blocked slider mutation/readback/restoration path at normal text size, with narrow interaction and wide readback.
- P2P cache capacity dropdown exposed 64/128/256/512/1024 MiB. Selected 256 MiB from original 128 MiB, left settings and reopened, and confirmed 256 MiB persisted. Restored 128 MiB. P2P remained enabled and Peer validation remained Standard; no peer connection, credential, permission or network policy changed. Actual multi-peer transfer remains skipped without a second usable authenticated client.
- No new product defect or code change in this pass. Prior 181 focused regressions/analyze/native/Web builds remain the latest checks after the realtime repair. Native continuation: maximized Room management / Free mode, playback stopped, original thresholds and cache capacity restored. Goal remains active for other matrix gaps.


## Subtitle selection and style actual-client completion

- Temporarily attached two local WebVTT tracks to the retained local media. Actual narrow playback rendered the default first-half cue; paused at 18.125 seconds. Selected Alternate sweep through More → Subtitles and maximized: the alternate text remained visible at the same paused position. Fullscreen retained that text and its selected checkmark.
- Turned subtitles off in fullscreen, exited with Escape, then resized narrow. No cue reappeared; reopening the narrow chooser confirmed Off selected. Selecting Default sweep restored the original cue without resuming playback. This completes the previously blocked real-client subtitle selection/rebuild regression.
- Subtitle style: size 18→25 survived closing/reopening and narrow resizing. A separate actual-rendering check changed size to 28 and text to yellow: the paused cue visibly changed. Restore defaults returned size 18 and white text in the actual video. Normal system text size was used throughout.
- Restored the media's exact original source configuration with guarded database update and independent readback. Native Stop returned to Waiting with success feedback. No temporary subtitle attachment remains; history may retain the test playback snapshot. Original playlist and two media remain.
- Browser inventory retried and still returns Codex auth token unavailable; no additional browser pass is claimed. No production code changed in this follow-up; previous 181 focused tests/analyze/native/Web builds remain applicable. Goal stays active for remaining available coverage.

## Management diagnostics clipboard completion

- Actual management Overview showed four resources, zero events and zero exceptions. Copy diagnostics succeeded; independently parsed clipboard JSON contains room_id, room_name, captured_at, events and resources, with four resource snapshots and zero events. This supersedes the earlier unverified clipboard payload entry.
- Resources displayed room settings, members, media and chat cards; refreshing Events retained the valid empty state. Exception/event details are skipped for this empty diagnostic snapshot, with no claim of populated exception handling.


## Narrow sequence and end-of-list completion

- Created one disposable local-video clone after the retained local media. At approximately 630px, started Local playback edited, pressed Next, and observed Narrow sequence sweep rendering and advancing. Paused around 46.9 seconds and pressed Next again at the final entry; the same media and paused position remained. Backend code confirms a missing next target persists the current media in a stopped state; no wraparound is expected.
- Pressed Previous in the narrow player; original Local playback edited returned and rendered. Without subsequent navigation input, it reached the end and the next observation showed Narrow sequence sweep. This establishes automatic advancement under the current room policy; precise timing and continuity were not measured.
- Stopped playback through the native UI, deleted only the guarded disposable clone, and independently confirmed two original active media remain (plus the original playlist). No source configuration or policy change remains. Test history/events may retain the fixture snapshot.
- No new product defect or production code change in this pass. Existing relevant checks remain valid.


## Administrator user creation, email validation and cleanup

- Route/dialog inventory identified AddUserDialog without a real-client creation record. Native empty Create retained the dialog and displayed username/password required errors at narrow and maximized widths. Submitting malformed optional email reached the backend and showed a raw validation error; the draft survived.
- Added basic optional-email format validation with localized English/Chinese field feedback and validation during editing. Empty email remains allowed; trimming matches submission. This checks obvious malformed structure, leaving the backend authoritative for complete address policy.
- All eight add-user regressions pass, including malformed/multiple-at/whitespace input rejection, correction to a trimmed plus-address, blank optional email, duplicate-submit and late-response handling. Analyze clean, macOS debug/Web release builds passed, whitespace check passed.
- Real native successful creation used a disposable ordinary active user without email. The backend first rejected the test password complexity and retained all fields; correction succeeded, increasing users 13→14. Cold restart into the newly built application retained the test user and original root session.
- Rebuilt real UI: malformed email now displays its Chinese inline error with the other required errors; wide→approximately 630px preserves the input and all actions. Clearing the optional email immediately clears only its format error. Cancel closes without creating another account.
- Deleted the disposable user through its explicitly named confirmation after inspecting narrow/wide layouts. Success restored the visible count to 13; database independently confirms the disposable user has a deletion timestamp and active (not deleted) users total 13. The soft-deleted test record remains according to backend deletion semantics. No existing account credentials, roles or statuses changed.
- Goal remains active: this closes one additional dialog workflow and its discovered issue, not the complete route/dialog audit. Browser connection and unavailable external-service limitations remain as recorded.


## User detail tabs and room-toolbar reachability

- Real native user details: profile displays ID, optional-email placeholder, localized role/status and timestamps. Related Rooms returned four seeded memberships. Searching Friday returned one; wide→approximately 630px retained query/result, and Clear restored four.
- Found room-filter controls hidden beyond the dialog's right edge: sorting, page size and Refresh required horizontal scrolling even in the maximized app. Mouse drag did not expose them. Replaced the horizontal strip with a wrapping toolbar, keeping all query callbacks unchanged.
- Rebuilt native narrow and maximized details now display every filter/action in two visible rows. At narrow width, changed creation sort from descending to ascending and refreshed: the four entries reversed correctly. Widening preserved ascending order and the full toolbar, with room rows and Close still visible.
- User-detail Reports tabs correctly scoped the seeded user's received and initiated reports, showing the corresponding user-ID filter and valid empty state. Both were exercised at narrow width; populated report moderation already has separate evidence, not inferred here.
- User-detail Preferences at narrow width: toggled only system-announcement in-app notification off; success appeared. Cold restart and reopened details retained off. Restored on via UI and independently confirmed the database value true. Other switches, authentication factors, roles and credentials were unchanged; no message was sent.
- Existing admin record/layout and user batch selection/lifecycle suites: 52 passed. Analyze clean; macOS debug and Web release builds passed; whitespace check clean. Native real regression above uses the rebuilt app. This is toolbar layout coverage, not proof of race handling or populated pagination inside the user-detail room panel.
- Goal remains active. Main user-list batch workflow and other unaudited entry points still need the complete coverage reconciliation.


## User batch selection and cancellation boundary

- Actual native wide list: selected daniel and chloe individually; selected count became two. Batch Delete opened its two-user confirmation. Narrow resize retained the confirmation with complete impact text and Cancel/Delete controls. Cancel retained both users and the two selections.
- Searched noah at narrow width and submitted: exactly one result remained, original hidden selections were removed and the batch toolbar disappeared. No seeded user was banned or deleted.
- Prepared two unrelated disposable database users for an actual batch-delete check. Before any client interaction with these fixtures, the Mac became locked and CUA reported that automatic unlock failed. Removed exactly those two IDs with matching-name guards; database confirms 13 non-deleted original users. Actual batch deletion remains pending; cancellation/selection evidence does not establish that mutation.
- No production code changed in this follow-up. Prior 52 relevant regressions/analyze/native/Web builds remain latest applicable validation. That attempt ended at a locked desktop; the continuation below supersedes this environment boundary.


## User batch mutation and populated pagination completion

- Desktop interaction recovered. Native narrow batch Delete confirmed exactly two disposable users; the filtered list became zero and selection controls disappeared. Independent database readback confirms both deletion timestamps and 13 original active users.
- Added 22 separate disposable users for populated main-list pagination. Narrow first page displayed 20 per page / 22 total; Next displayed page two with the expected final two records. Maximizing retained page two, both records and the disabled Next boundary.
- Selected the second page and used Batch Ban. Empty reason was accepted by the backend; success reported exactly two and both rows displayed Banned with selection cleared. This establishes an accepted empty-reason path, not required-field validation.
- Only Banned filtering reset page two to page one with exactly two records. Narrow resize retained the filter and records. Individually confirmed Unban for each named fixture; the filtered count reduced 2→1→0. Independent user-account-profile readback confirms both is_banned values false.
- Guarded cleanup soft-deleted all 22 pagination fixtures; independent readback confirms 13 active original users. Soft-deleted fixtures and ended ban history remain according to test-data retention. No original account was banned, deleted or otherwise changed.
- No production code change or new defect in this pass. Earlier relevant tests/builds remain applicable. Goal remains active for full inventory reconciliation and outstanding context-specific image export; this does not claim complete browser/native coverage.


## Remaining dialog evidence audit

- Browser inventory was retried and still fails with `Codex auth token is unavailable`; no new browser pass. Native app reacquisition returned only window chrome and an empty content accessibility tree. This alone does not prove the desktop is locked or the application has crashed.
- Source inventory contains 30 named page/dialog files. Cross-check identified no explicit real-client evidence for the reaction-member list dialog, administrator user rename/reset-password actions, or the password-reset local form. These remain pending; missing SMTP only excludes actual reset-email delivery, not local form inspection.
- Chat cropped-image send remains pending. The existing generated PNG is available and the test room has only the current test account as a member; no image was selected or sent in this continuation. Earlier original-image send and cover/avatar crop results do not establish this path.
- No test data or production code changed in this audit. Goal remains active; complete route/dialog evidence reconciliation is still required.


## Native interaction recovery and user-editor audit

- Reacquired native accessibility tree with the previously open ban-filter menu. Selecting All bans successfully closed it and rendered the narrow Users page; clearing the previous fixture search also worked. Native interaction is available again, superseding the prior empty-tree observation.
- Source inspection of the administrator rename and reset-password handlers shows both dialogs pop before the gateway request. Consequently server rejection cannot preserve an open editor for correction. This is a source-confirmed lifecycle concern; actual invalid-submit reproduction and repair remain pending.
- Disposable users prepared for this follow-up received no client mutation and were removed with exact ID/name guards. Independent database readback confirms 13 active users. No existing username or password changed.


## Administrator user editor lifecycle repair

- Replaced the rename/reset-password handlers' pre-request dismissal with a feature-local stateful editor. Both now retain drafts on gateway failure, validate empty input locally, disable editing/submission while saving, and close only on success or explicit cancellation. Controllers are disposed. Username/reason trimming and exact password bytes retain the existing API contract.
- Added six focused regressions: each editor rejects empty submission, preserves a failed draft, retries successfully, suppresses duplicate submission and ignores late success/failure after cancellation while a newer editor remains open. All six pass.
- Final analyze reports no issues; macOS debug and Web release builds pass; git diff --check passes. These checks include the explicit mounted guard and final test-style cleanup.
- Actual rebuilt native rename/reset-password wide/narrow retest remains pending. No real account credentials or username changed in this repair. Goal remains active, and automated coverage does not replace that pending client verification.


## Rebuilt native startup verification

- Terminated the old native process and reopened the built app after its exit. An initial launch raced process termination and returned Launch Services -600; the subsequent launch succeeded. The application framework timestamp matches the latest editor repair build.
- Reacquired native home with the original authenticated root session, owned test room and Friday membership intact. No editor workflow has yet been exercised in this new process, so rename/reset-password real-client retest remains pending.
- An unused disposable editor fixture was removed with exact ID/name guards; database independently confirms 13 active users. No account credential changed.


## User editor actual-client regression completed

- Rebuilt native rename dialog: narrow empty Save retained the editor with localized required feedback. Submitting root was rejected as a reserved name (not a duplicate-name constraint); the draft remained. Maximized view preserved it and displayed the backend failure. Corrected to a valid disposable name, saved, and observed the updated row; independent database readback confirmed the name.
- Password reset: maximized empty Reset retained the required error. Narrow short-password submission was rejected by backend length validation; masked password and audit-reason draft both remained, and the error was readable. Corrected the password and submitted successfully: the dialog closed. Independent readback confirmed the previously credential-free fixture now had one password credential. Actual login with that credential was not tested.
- Deleted only the renamed fixture via its named native confirmation. Independent readback confirms its soft-deletion timestamp and 13 active original users. The password credential row remains attached to the soft-deleted fixture; physical credential deletion is not established. Original usernames/passwords were unchanged.
- This completes actual normal-text wide/narrow validation and failure/correction/save coverage for the two repaired editors. Earlier six focused regressions, clean analyze and successful macOS/Web builds remain applicable. Other matrix gaps remain; Goal stays active.


## Cropped chat-image export and reaction-member dialog

- Sent the actual image-editor output with caption `cropexporttest` in the isolated test room. Narrow editor controls and attachment draft were visible; send cleared the composer/draft. The full image viewer showed the central square crop without the original corner markers in both narrow and maximized windows.
- Left and reentered the room. The same caption and cropped attachment loaded from history. The image preview remained available in the management chat search.
- Adding a thumbs-up exposed a backend defect: mutation persisted, but HTTP returned 500 (`chat attachment url is missing`) and the live resource observer disconnected. This is a real failure, not a successful reaction workflow.
- Management search independently loaded the persisted thumbs-up count of one. Clicking it opened the reaction-member dialog with root and its reaction time; wide and narrow layouts kept the title, count, member and Close visible. This completes the populated single-member dialog check, not multi-page real-client coverage.
- Added a PostgreSQL regression with an image whose stored URL is absent. It failed at the expected missing response URL before the repair and passes after reaction-event attachment metadata is resolved. Rebuilt-backend native reaction verification is completed in the next follow-up. The test image message is retained temporarily for editing and cleanup.
- Browser inventory still fails with `Codex auth token is unavailable`; no new browser pass is claimed.


## Image mutation attachment metadata and editor recovery

- Rebuilt backend: native narrow added/removed thumbs-up and wide added/removed heart on the cropped image; all four reaction requests returned 200 with no missing attachment URL or observer disconnection. Reaction-member dialog had already displayed the actual root response at both widths.
- Editing the image reproduced the same missing attachment URL error: the database committed its caption while the request returned 500 and the live UI remained stale. Added response metadata hydration for message edits, pin/unpin normal and idempotent outcomes, associated pin events and pin lists. Durable pin event replay now resolves its stored attachment metadata before protocol conversion.
- PostgreSQL regression explicitly removes the stored image URL, then exercises reactions, pin/list, edit, unpin, idempotent replays and the actual stored pin-event snapshot. Five related Docker-backed chat tests pass. Backend binary build and whitespace check pass; existing linker unwind-size warning remains.
- Actual macOS retest against the rebuilt backend: reentering the room read back the earlier committed edit. Wide edit returned 200 and immediately updated caption/image; pin and Refresh displayed the saved caption. At narrow width, clicking the pin located the image, editing updated both message and pin summary, and unpin removed the pin strip. No missing-URL error or 500 appears in this rebuilt-server interval. Browser connection remains unavailable; no new browser pass is claimed.
- Retrying the stale pre-reentry message correctly returned 409, but exposed an additional frontend defect: the edit dialog closed and lost the draft. Both room and management chat editors now await successful save inside the shared form, retain the draft on failure, prevent duplicate requests, and guard late completion after dismissal. Three editor tests plus shell/detail-dialog checks pass (23 total); analyze clean. Native/Web builds and real-client editor failure retest are in progress.
- Wide-to-narrow resizing reproducibly reset chat to the oldest loaded message. The chat subtree now retains its identity across responsive reparenting; actual rebuilt-client verification is still required. Image fixture message remains available for the remaining edit/resize/delete checks.


## Editor conflict recovery and remaining account form

- Actual rebuilt native message editor: advanced only the disposable image message's version to induce a 409. Narrow Save retained the whole draft and editor, with error feedback. Widening retained the same text/actions. Restored exactly that synthetic version change with a content/version guard; retrying the open editor succeeded, closed it and updated the visible image caption. No original user message was altered.
- Scroll verification found that preserving widget identity alone prevented oldest-message reset but did not retain bottom alignment when viewport height and lazy image extents changed. Added a dedicated chat scroll controller that transfers tail alignment when Flutter replaces a scroll position and maintains it across new content dimensions. A real widget regression covers responsive reparenting, delayed image height, widening and preserving an older reading offset. It passes; final native retest remains required.
- Opened the locally available password-reset form using a temporary unauthenticated connection to the same test backend, preserving the original authenticated profile. Normal narrow and maximized layouts fit. Empty Reset retained the form with required-fields feedback; empty Send showed email-required feedback. An invalid address returned the backend's generic anti-enumeration success text, revealing absent frontend format validation.
- Added basic email format validation before both reset-code request and form completion, sharing the same structural rule as administrator user creation. Regression confirms zero requests for malformed email, retained token/draft and successful request dispatch after correction. Actual delivery/reset remains skipped without SMTP; no credential was changed. Latest builds and actual corrected-form retest are in progress. The temporary connection still requires removal/restoration after this retest.


## Final client retests, cleanup and validation

- Final rebuilt native chat: bottom-aligned wide chat remains at the latest image when narrowed; scrolling up to an older original image before narrowing retains the older reading region. The controller regression also covers delayed image dimensions and viewport height changes. This supersedes the pending scroll notes above.
- Final rebuilt native password-reset form: malformed email is rejected locally with localized feedback at narrow and maximized widths. Dummy mismatched-password validation retains the form; no reset request or credential change was made. Removed the temporary unauthenticated connection through the UI and restored the original authenticated connection.
- Management chat search found the disposable cropped image. A real narrow edit saved and refreshed its caption. Delete confirmation was inspected at both widths; Delete and Refresh produced zero matching results. Independent readback confirms that only image message 84 is soft-deleted, message 51 remains, and the attachment row is retained under backend soft-deletion semantics.
- Final backend includes dynamic Web serving and the image event repairs. Both root document and application script return 200; the served application script hash matches the latest Web build. The earlier feature-less local backend build was replaced and is not the running server.
- Real Edge native control remains usable despite the browser connector inventory error. Latest Web build: 390 × 844 invitation sheet at 100% preview fits; wide homepage search returns an empty state and clearing restores the gallery. The final browser has no search, modal or DevTools open. Authentication was not submitted.
- Full Flutter suite completed: 3043 passed, 1 skipped. Final analyze has no issues; macOS debug and Web release builds pass. Five Docker-backed backend chat regression tests pass. Existing native-plugin Swift Package Manager adoption and Rust linker warnings remain; no new build failure.
- Original active users remain 13 and rooms remain 6. Original room membership, policies and root session are retained; playback is stopped. Disposable pagination, moderation and image fixtures were cleaned as described in their individual sections. Soft-deleted rows, ended bans and test audit/history snapshots are intentionally not purged.

## Final local dialog gaps and browser diagnostics

- Native RTMP publishing form: exercised one-time, reusable-until-expiry and permanent key drafts. Permanent warning text fits at 600px; no key was generated. Date and time pickers fit at narrow and maximized widths. Selecting the next day and confirming the time returns the exact combined date/time to the wide form; reopening and cancelling preserves the draft. Closing returns to the original three media entries. Actual publishing, key display/regeneration and live-stream stop are excluded without a configured publishing workflow/producer.
- Real browser agreement reading: visible text link opens the complete agreement; inspected wide and at 390 × 844 with normal text and 100% preview. Closing returns to the login form with agreement unchecked. An initial accessibility-target click temporarily toggled the checkbox; this was reverted using the visible checkbox, and no login/register/guest request or agreement-dialog acceptance was submitted. Coordinate-link verification opened the intended document. This is a harness targeting observation, not a reproduced visual-click product defect.
- DevTools Issues reports zero page errors and zero breaking changes, with one deprecated API notice and six input-name recommendations. The deprecation is Intl.v8BreakIterator used by the current Flutter Web engine. Inspecting a live recommended input identifies the Flutter-generated room-search semantics input, with a correct accessible label and autocomplete disabled. Search already passes real input/clear testing. These engine/DOM recommendations remain recorded; generated output and SDK files were not patched to silence them.

## Final route and feature reconciliation

The inventory includes 33 named page/dialog/screen Dart files, plus inline editors and the home/auth/media/provider feature entry points. This table maps the inventory to actual evidence or an explicit boundary; it does not imply every state combination was tested.

| Inventory group | Evidence and remaining boundary |
|---|---|
| Language selector; server settings | Native profile lifecycle, validation, refresh, language persistence and wide/narrow layouts; browser locale and server information passed. |
| Home; room label filter; room delete confirmation | Search/filter/empty recovery, categories, labels, carousel, favorites and native disposable room deletion passed. |
| Create room; join room; Web invitation | Native create/join/invite and review flows passed; browser invitation routing and wide/narrow auth presentation passed. Browser entry after agreement is excluded. |
| Auth panel; user agreement; password reset; OAuth callback | Local validation, reading/dismissal, native existing-session recovery and password-reset correction passed. Fresh login/registration after agreement, real email reset and OAuth callback success are excluded. |
| Account center | Profile/avatar, notifications, rooms, sorting/pagination and leave/delete lifecycle passed. Real authentication-factor changes and external provider success are excluded. |
| Room screen; room settings | Playback controls/subtitles, media organization, policy persistence, chat, history and diagnostic entry points have native wide/narrow evidence. Cross-role enforcement and true multi-client free-mode independence are excluded. |
| Chat receipts; reaction users; shared message editor | Read-detail presentation, populated reaction-member presentation, image/text mutation, edit conflict recovery and pin synchronization passed. Multiple-user receipt/reaction pagination and authenticated browser mutations are excluded. |
| Member text/permission; admin room members/add/kick | Native member addition/removal, alias/label, role filters, permission edits/readback/restoration and confirmations have evidence. Configuration results do not establish second-user enforcement. |
| Report filters and disposition | Populated submission/moderation, detail/filter and retry paths have evidence. No actual abuse decision was made. |
| Admin settings; add user; edit user; add administrator | Disposable ordinary-user creation/deletion, rename/reset validation/retry, batch operations, reviews, taxonomy/runtime/cache and existing-user administrator round trip passed. New administrator success and login with the reset fixture credential were not executed. |
| Test email dialog | Required-field and wide/narrow form checks passed; delivery excluded without SMTP. |
| Add media; RTMP publish key | Direct/local media, batch, search/selection, source drafts and date/time options passed. Publish-key result/regeneration and unavailable live transports are excluded. |
| Platform binding; Nextcloud dialog; provider account info/unbind | Available provider modes, local validation, cancellation, responsive drafts and navigation inspected. Account-info/unbind success and remote browsing require absent provider accounts/services and are excluded. |

## Explicit closeout exclusions

- Browser authenticated room/account/admin mutations and renewed guest playback: no accepted test-session agreement. Earlier guest playback evidence is retained with its actual build/session scope; it is not a final authenticated-browser pass.
- Fresh signup/login, new administrator creation and real credential/factor changes: successful final actions were not performed under the current agreement/credential/access boundary. The CUA confirmation policy requires separate handling for agreement acceptance, credential changes and expansion of privileged access; these are not reclassified as backend failures. Ordinary test-data CRUD authorization was used throughout the remaining sweep.
- SMTP/OAuth/Passkey and provider binding/content: missing configured delivery, identity, authenticator or upstream accounts/services. Provider account details and unbinding cannot be exercised on nonexistent bindings.
- RTMP/RTSP/WHEP publication/transport, populated active-stream stop, real voice/P2P transfer, cross-role authorization and multi-client synchronization/receipts: required live producer or second usable client absent. Local forms/configuration and available local MP4/FLV behavior have separate evidence.
- Populated exception diagnostics and distributed/remote instance operations: absent corresponding records/services. Empty/local diagnostics were exercised.

Within these recorded boundaries, the available sweep, discovered-defect repairs, client retests, validation and cleanup are complete. The exclusions remain unverified and are not a claim that all functionality or every browser/native combination passed.
