// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SyncTV';

  @override
  String get appTagline => 'Together, wherever you are';

  @override
  String get language => 'Language';

  @override
  String get languageSettingsTitle => 'Display language';

  @override
  String get languageSettingsDescription =>
      'Choose the language used by SyncTV.';

  @override
  String get languageSystem => 'System default';

  @override
  String get languageChineseSimplified => 'Simplified Chinese';

  @override
  String get languageEnglish => 'English';

  @override
  String get server => 'Server';

  @override
  String get serverSettings => 'Server settings';

  @override
  String get openServerSettings => 'Open server settings';

  @override
  String get joinRoom => 'Join room';

  @override
  String get createRoom => 'Create room';

  @override
  String get login => 'Log in';

  @override
  String get accountMenu => 'Account menu';

  @override
  String get accountCenter => 'Account center';

  @override
  String get adminSettings => 'Admin settings';

  @override
  String get logout => 'Log out';

  @override
  String get capsLockOn => 'Caps Lock is on';

  @override
  String get done => 'Done';

  @override
  String get add => 'Add';

  @override
  String get builtInLabel => 'Built-in';

  @override
  String get switchServer => 'Switch';

  @override
  String get remove => 'Remove';

  @override
  String get processing => 'Processing';

  @override
  String get serverAddressRequired => 'Enter a server address';

  @override
  String serverConnected(String serverName) {
    return 'Connected to $serverName';
  }

  @override
  String serverConnectFailed(String error) {
    return 'Could not connect to the server: $error';
  }

  @override
  String serverSwitched(String serverName) {
    return 'Switched to $serverName';
  }

  @override
  String serverSwitchFailed(String error) {
    return 'Could not switch servers: $error';
  }

  @override
  String get builtInServerCannotRemove =>
      'The built-in server is part of the app configuration and cannot be removed';

  @override
  String get serverRemoved => 'Server removed';

  @override
  String serverRemoveFailed(String error) {
    return 'Could not remove the server: $error';
  }

  @override
  String get serverAddress => 'Server address';

  @override
  String get serverAddressExample => 'Example: https://tv.example.com';

  @override
  String get serverAutoDiscoverDescription =>
      'Each address is stored as an independent server. SyncTV keeps its account, session, and cached data isolated by address.';

  @override
  String get serverAddressIdentityDescription =>
      'The address above identifies this server on this device. The ID below is declared by the server and may be shared or imitated by another address.';

  @override
  String serverDeclaredId(String serverId) {
    return 'Server-declared ID: $serverId';
  }

  @override
  String get savedServers => 'Saved servers';

  @override
  String get noSavedServers =>
      'No servers saved yet. Add one to log in and browse public rooms.';

  @override
  String get currentServer => 'Current server';

  @override
  String serverInfoFailed(String error) {
    return 'Could not load server information: $error';
  }

  @override
  String get refreshServerInfo => 'Refresh server information';

  @override
  String openRoomFailed(String error) {
    return 'Could not open the room: $error';
  }

  @override
  String loadRoomsFailed(String error) {
    return 'Could not load rooms: $error';
  }

  @override
  String get filterLabels => 'Filter labels';

  @override
  String get noLabelsAvailable => 'No labels available';

  @override
  String get noLabelsForCategory => 'No labels available in this category';

  @override
  String get clear => 'Clear';

  @override
  String get apply => 'Apply';

  @override
  String get roomIdRequired => 'Enter a room ID';

  @override
  String get roomNotFound => 'Room not found';

  @override
  String get roomUnavailable => 'This room is currently unavailable';

  @override
  String findRoomFailed(String error) {
    return 'Could not find the room: $error';
  }

  @override
  String get logoutConfirmMessage => 'Log out of the current account?';

  @override
  String get logoutAction => 'Log out';

  @override
  String get loggedOut => 'Logged out';

  @override
  String get passwordRequired => 'Enter a password';

  @override
  String joinRoomFailed(String error) {
    return 'Could not join the room: $error';
  }

  @override
  String get deleteRoom => 'Delete room';

  @override
  String deleteRoomConfirm(String roomName) {
    return 'Delete \"$roomName\"? This action cannot be undone.';
  }

  @override
  String get delete => 'Delete';

  @override
  String get roomDeleted => 'Room deleted';

  @override
  String deleteFailed(String error) {
    return 'Could not delete the room: $error';
  }

  @override
  String updateFavoriteFailed(String error) {
    return 'Could not update the favorite: $error';
  }

  @override
  String roomsPageSummary(int total, int page, int pageCount) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$total rooms',
      one: '1 room',
      zero: 'No rooms',
    );
    return '$_temp0 · Page $page of $pageCount';
  }

  @override
  String get searchRooms => 'Search rooms';

  @override
  String get allCategories => 'All categories';

  @override
  String get labels => 'Labels';

  @override
  String selectedLabels(int count) {
    return 'Labels $count';
  }

  @override
  String get clearRoomTaxonomyFilters => 'Clear category and label filters';

  @override
  String get refresh => 'Refresh';

  @override
  String get addServerToStart => 'Add a server to get started';

  @override
  String get noRooms => 'No rooms';

  @override
  String get addServerDescription =>
      'Enter a server address to browse public rooms, log in, and join a watch room.';

  @override
  String get filteredRoomsEmptyDescription =>
      'No rooms match the current filters';

  @override
  String get addServer => 'Add server';

  @override
  String get joinRoomSubtitle => 'Enter a room ID or paste an invite link';

  @override
  String get inviteLinkServerHint =>
      'Invite links identify the server automatically. When several local addresses match, you can choose one in the next step.';

  @override
  String get roomIdOrInviteLink => 'Room ID or invite link';

  @override
  String get roomIdOrInviteLinkHint => 'room_xxx or https://...';

  @override
  String get searching => 'Searching';

  @override
  String get continueAction => 'Continue';

  @override
  String get enterRoomPassword => 'Enter room password';

  @override
  String get roomPassword => 'Room password';

  @override
  String get roomPasswordJoinHint => 'Enter the password to join';

  @override
  String get incorrectRoomPassword => 'Incorrect room password';

  @override
  String get close => 'Close';

  @override
  String get cancel => 'Cancel';

  @override
  String get roomCreationDisabled => 'Room creation is disabled on this server';

  @override
  String get roomSubmittedForReview => 'Room submitted for review';

  @override
  String get roomCreated => 'Room created';

  @override
  String createRoomFailed(String error) {
    return 'Could not create the room: $error';
  }

  @override
  String get roomNameRequired => 'Enter a room name';

  @override
  String roomNameTooLong(int maxLength) {
    return 'Room names can contain up to $maxLength characters';
  }

  @override
  String get roomPasswordRequired => 'Enter a room password';

  @override
  String get createPolicyLoadFailed =>
      'Could not load the server\'s room creation policy. Try again later.';

  @override
  String get roomCreationDisabledBanner =>
      'Room creation is disabled on this server.';

  @override
  String get roomReviewRequiredBanner =>
      'New rooms require review. Administrators can manage the room before approval; members cannot access it yet.';

  @override
  String get basicInformation => 'Basic information';

  @override
  String get roomName => 'Room name';

  @override
  String get roomNameHint => 'Example: Weekend movie night';

  @override
  String get roomDescription => 'Room description';

  @override
  String get roomDescriptionHint =>
      'Optional information that helps members understand the room';

  @override
  String get accessMethod => 'Access method';

  @override
  String get roomVisibility => 'Room visibility';

  @override
  String get publicRoomVisibilityDescription =>
      'Listed in discovery; anonymous guests can access when guest joining is enabled';

  @override
  String get privateRoomVisibilityDescription =>
      'Hidden from discovery and unavailable to anonymous guests';

  @override
  String get passwordProtection => 'Password protection';

  @override
  String get noRoomPassword => 'No password';

  @override
  String get noRoomPasswordJoinHint =>
      'Eligible members can join without a password';

  @override
  String get serverRequiresPassword => 'The server requires a password';

  @override
  String get membersEnterPassword => 'Members enter this password to join';

  @override
  String get creating => 'Creating';

  @override
  String get roomCategory => 'Room category';

  @override
  String get taxonomyLoadFailedCreateAllowed =>
      'Could not load categories. You can still create the room.';

  @override
  String get noCategory => 'No category';

  @override
  String get roomLabels => 'Room labels';

  @override
  String get loadingCreationPolicy =>
      'Loading the server\'s room creation policy';

  @override
  String get creationPolicyUnavailable => 'Room creation policy unavailable';

  @override
  String get serverDisallowsNewRooms => 'This server does not allow new rooms';

  @override
  String get roomWillBeReviewed => 'The room will be submitted for review';

  @override
  String get passwordRoomAccessHint =>
      'Only members with the password can join';

  @override
  String get publicRoomAccessHint => 'Eligible members can join a public room';

  @override
  String get privateRoomAccessHint =>
      'This room is hidden from discovery and unavailable to anonymous guests';

  @override
  String get createRoomSubtitle =>
      'Set the room name, visibility, and password protection';

  @override
  String get publicRoom => 'Public room';

  @override
  String get publicRoomJoinHint =>
      'Members can request access or join directly';

  @override
  String get passwordRoom => 'Password room';

  @override
  String get serverForbidsPassword =>
      'The server does not allow room passwords';

  @override
  String get passwordRoomJoinHint => 'Members need the password to enter';

  @override
  String get roomBanned => 'Banned';

  @override
  String get roomUnavailableShort => 'Unavailable';

  @override
  String get roomJoinable => 'Joinable';

  @override
  String get roomGuestAccess => 'Enter as guest';

  @override
  String get featuredRooms => 'Featured rooms';

  @override
  String get featuredRoomsDescription => 'Active spaces for watching together';

  @override
  String get continueWatchingRooms => 'Continue watching';

  @override
  String get continueWatchingRoomsDescription =>
      'Return to rooms you have already joined';

  @override
  String get popularRooms => 'Popular rooms';

  @override
  String get popularRoomsDescription =>
      'Ranked by live activity, membership, and recent use';

  @override
  String get roomJoined => 'Joined';

  @override
  String get passwordRequiredShort => 'Password required';

  @override
  String get roomApprovalRequired => 'Approval required';

  @override
  String get roomApprovalPending => 'Approval pending';

  @override
  String get roomJoinRequestSubmitted => 'Join request submitted for approval';

  @override
  String get signInToJoin => 'Sign in to join';

  @override
  String get roomInvitationOnly => 'Invitation only';

  @override
  String get roomFull => 'Room full';

  @override
  String get roomJoinCooldown => 'Join unavailable';

  @override
  String roomPresenceSummary(int onlineMembers, int onlineGuests) {
    return 'Online: $onlineMembers members · $onlineGuests guests';
  }

  @override
  String roomOnlineTotal(int count) {
    return 'Online: $count';
  }

  @override
  String roomPresenceWithMembers(
    int onlineMembers,
    int onlineGuests,
    int memberCount,
  ) {
    return '$onlineMembers members online · $onlineGuests guests online · $memberCount members total';
  }

  @override
  String roomConnections(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count connections',
      one: '1 connection',
      zero: 'No connections',
    );
    return '$_temp0';
  }

  @override
  String get removeFavorite => 'Remove from favorites';

  @override
  String get favoriteRoom => 'Add room to favorites';

  @override
  String get noDescription => 'No description';

  @override
  String get password => 'Password';

  @override
  String get hidden => 'Hidden';

  @override
  String get unknownCreator => 'Unknown creator';

  @override
  String get userAgreement => 'User agreement';

  @override
  String get readAgreementToEnd => 'Read to the end to continue';

  @override
  String get declineAndExit => 'Decline and exit';

  @override
  String get agree => 'Agree';

  @override
  String authConfigLoadFailed(String error) {
    return 'Could not load authentication settings: $error';
  }

  @override
  String get acceptTermsFirst =>
      'Read and accept the user agreement and privacy policy first';

  @override
  String get registrationSubmitted =>
      'Registration submitted for administrator review';

  @override
  String registrationSubmittedWithId(String reviewId) {
    return 'Registration submitted for administrator review ($reviewId)';
  }

  @override
  String get emailRequired => 'Enter your email address';

  @override
  String get verificationCodeSent => 'Verification code sent';

  @override
  String get emailAndCodeRequired =>
      'Enter your email address and verification code';

  @override
  String get emailOrUsernameRequired => 'Enter your email address or username';

  @override
  String get enterIdentifierFirst => 'Enter a username or email address first';

  @override
  String get usernameRequired => 'Enter a username';

  @override
  String get usernameAndEmailRequired => 'Enter a username and email address';

  @override
  String get registrationCodeSent => 'Registration verification code sent';

  @override
  String get codeAndPasswordRequired =>
      'Enter the verification code and password';

  @override
  String get authorizationPageOpenFailed =>
      'Could not open the authorization page';

  @override
  String get mfaEmailUnsupported =>
      'This account does not support email verification';

  @override
  String get mfaCodeSent => 'Two-factor verification code sent';

  @override
  String get mfaCodeRequired => 'Enter the two-factor verification code';

  @override
  String get mfaPasskeyUnavailable => 'This account has no available passkey';

  @override
  String get noLoginMethodAvailable =>
      'This account has no sign-in method available on this device';

  @override
  String get passwordResetSuccess =>
      'Password reset. Log in with your new password.';

  @override
  String get connectToSyncTv => 'Connect to SyncTV';

  @override
  String get noServerConnected => 'No server connected';

  @override
  String get register => 'Register';

  @override
  String get guest => 'Guest';

  @override
  String get emailOrUsername => 'Email or username';

  @override
  String get verificationCode => 'Verification code';

  @override
  String waitingForAuthorization(String provider) {
    return 'Waiting for $provider authorization';
  }

  @override
  String get registrationDisabled =>
      'Account registration is disabled on this server';

  @override
  String get emailRegistrationDisabled =>
      'Email registration is disabled on this server';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get getCodeFirst => 'Get a code first';

  @override
  String get send => 'Send';

  @override
  String get emailCodeLogin => 'Log in with verification code';

  @override
  String get passkeyLogin => 'Log in with passkey';

  @override
  String get passwordLogin => 'Password login';

  @override
  String get thirdPartyRegistration => 'Third-party registration';

  @override
  String get accountRegistration => 'Account registration';

  @override
  String get usernameOrEmail => 'Username or email';

  @override
  String get username => 'Username';

  @override
  String get includeEmail => 'Add an email address';

  @override
  String get includeEmailDescription =>
      'You can complete registration with an email verification code.';

  @override
  String get email => 'Email';

  @override
  String get createAccount => 'Create account';

  @override
  String get emailCodeRegistration => 'Email verification registration';

  @override
  String get createAccountWithEmailCode => 'Create account with email code';

  @override
  String get passkeyRegistration => 'Passkey registration';

  @override
  String get registrationMethod => 'Registration method';

  @override
  String get deviceNameHint => 'Device name, such as MacBook or phone';

  @override
  String get createPasskeyAccount => 'Create passkey account';

  @override
  String get edit => 'Edit';

  @override
  String get guestAccessDescription =>
      'Guest access only opens a specific room. Public rooms can be browsed without logging in; creating rooms, account settings, and administration require an account.';

  @override
  String get roomId => 'Room ID';

  @override
  String get guestAccessDisabled => 'Guest access is disabled on this server';

  @override
  String get enterAsGuest => 'Enter as guest';

  @override
  String get twoFactorVerification => 'Two-factor verification';

  @override
  String get additionalVerificationRequired =>
      'This account requires additional verification.';

  @override
  String codeSentTo(String email) {
    return 'A verification code will be sent to $email';
  }

  @override
  String get getMfaCodeFirst => 'Get a two-factor code first';

  @override
  String get completeVerification => 'Complete verification';

  @override
  String get verifyWithPasskey => 'Verify with passkey';

  @override
  String get thirdPartyLogin => 'Third-party login';

  @override
  String continueWithProvider(String provider) {
    return 'Continue with $provider';
  }

  @override
  String get oauthCallbackUnavailable =>
      'OAuth2 requires an App Link or desktop callback in this build.';

  @override
  String get oauth2CallbackCompleteTitle => 'Authorization complete';

  @override
  String get oauth2CallbackCompleteMessage =>
      'You can close this window and return to SyncTV.';

  @override
  String get oauthAuthorizationTimedOut =>
      'Authorization took too long. Please try again.';

  @override
  String providerReviewRequired(String provider) {
    return '$provider (registration requires review)';
  }

  @override
  String providerLoginOnly(String provider) {
    return '$provider (login only)';
  }

  @override
  String get acceptTermsSemantics =>
      'Accept the user agreement and privacy policy';

  @override
  String get termsPrefix => 'I have read and accept';

  @override
  String get userAgreementLink => 'User Agreement';

  @override
  String get and => 'and';

  @override
  String get privacyPolicyLink => 'Privacy Policy';

  @override
  String get passwordResetEmailSent => 'Password reset email sent';

  @override
  String passwordResetEmailFailed(String error) {
    return 'Could not send the password reset email: $error';
  }

  @override
  String get resetFieldsRequired =>
      'Enter your email, verification code, and new password';

  @override
  String get newPasswordsMismatch => 'The new passwords do not match';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get resetCode => 'Reset verification code';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get reset => 'Reset';

  @override
  String get agreementContent =>
      '# SyncTV User Agreement and Privacy Policy\n\nThis app connects to SyncTV servers owned by users. It does not provide a public content server or store, review, or operate content hosted on user servers.\n\nYou are responsible for lawful authorization of connected servers, rooms, and media, as well as server security, account security, content compliance, and backups.\n\nBy logging in, registering, using guest access, or connecting a server, you agree to follow applicable laws and refrain from distributing unlawful, harmful, infringing, or unauthorized content.\n\nThe app may store server addresses, login tokens, guest tokens, and basic preferences on this device to preserve sessions and support server switching.\n\nOAuth2 opens a browser or system authorization page and returns through an App Link or desktop callback. The app does not ask you to enter callback URLs or authorization codes manually.\n\nStop using the app if you do not accept these terms.';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get previousPage => 'Previous page';

  @override
  String get nextPage => 'Next page';

  @override
  String get previousRooms => 'Previous rooms';

  @override
  String get nextRooms => 'Next rooms';

  @override
  String get confirm => 'Confirm';

  @override
  String get undo => 'Undo';

  @override
  String get playlistEmpty => 'The playlist is empty';

  @override
  String get playlistEmptyDescription =>
      'Add a video to start watching together';

  @override
  String get addMedia => 'Add media';

  @override
  String get loadingVideo => 'Loading video';

  @override
  String get waitingForPlayback => 'Waiting for playback';

  @override
  String get messageReadDetails => 'Message read details';

  @override
  String readCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count read',
      one: '1 read',
      zero: 'No readers',
    );
    return '$_temp0';
  }

  @override
  String unreadCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unread',
      one: '1 unread',
      zero: 'None unread',
    );
    return '$_temp0';
  }

  @override
  String reactionMembers(String reaction) {
    return '$reaction reactions';
  }

  @override
  String memberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
      zero: 'No members',
    );
    return '$_temp0';
  }

  @override
  String get reactingMembers => 'Reacting members';

  @override
  String get loadMore => 'Load more';

  @override
  String get serverRequiredForInvite => 'Add the invite server';

  @override
  String get serverRequiredForInviteDescription =>
      'This invitation comes from another SyncTV server. Add its address so the app can identify it and continue joining the room.';

  @override
  String get chooseServerEndpoint => 'Choose server address';

  @override
  String get roomIdOrInviteRequired => 'Enter a room ID or invitation link';

  @override
  String processInviteFailed(String error) {
    return 'Could not process the invitation: $error';
  }

  @override
  String get editImage => 'Edit image';

  @override
  String imageCropFailed(String error) {
    return 'Could not crop the image: $error';
  }

  @override
  String get cropForPurpose => 'Use target aspect ratio';

  @override
  String get squareCrop => 'Square crop';

  @override
  String get uploadOriginalImage => 'Upload original';

  @override
  String get useEditedImage => 'Use edited image';

  @override
  String get imageSelectedDescription =>
      'Image selected. Add a description, then send it.';

  @override
  String get cancelImage => 'Remove image';

  @override
  String get message => 'Message';

  @override
  String get describeImage => 'Describe the image...';

  @override
  String get enterMessage => 'Enter a message...';

  @override
  String get chooseImage => 'Choose image';

  @override
  String get switchToVoice => 'Switch to voice';

  @override
  String get releaseToCancel => 'Release to cancel';

  @override
  String get releaseToSendSwipeToCancel =>
      'Release to send, swipe up to cancel';

  @override
  String get holdToTalk => 'Hold to talk';

  @override
  String get switchToText => 'Switch to text';

  @override
  String get noRealtimeEvents => 'No realtime events';

  @override
  String get realtimeEventsCopied => 'Realtime events copied';

  @override
  String get retentionCount => 'Retention limit';

  @override
  String get recentEventCount => 'Recent event count';

  @override
  String get eventCountRange => 'Range: 20-2000';

  @override
  String get save => 'Save';

  @override
  String retainEvents(int count) {
    return 'Keep $count events';
  }

  @override
  String get customValue => 'Custom...';

  @override
  String get viewChronologically => 'View chronologically';

  @override
  String get groupByType => 'Group by type';

  @override
  String eventCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count events',
      one: '1 event',
      zero: 'No events',
    );
    return '$_temp0';
  }

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String get copyEvents => 'Copy events';

  @override
  String get clearEvents => 'Clear events';

  @override
  String get moreActions => 'More actions';

  @override
  String get filterEventTypes => 'Filter event types';

  @override
  String get eventTypeFilter => 'Event type filter';

  @override
  String selectionCount(int selected, int total) {
    return 'Selected $selected / $total';
  }

  @override
  String get selectAll => 'Select all';

  @override
  String get allTypes => 'All types';

  @override
  String filteredEventCount(int visible, int total) {
    return '$visible / $total events';
  }

  @override
  String get realtimeEvents => 'Realtime events';

  @override
  String groupedEventCount(int groups, String events) {
    String _temp0 = intl.Intl.pluralLogic(
      groups,
      locale: localeName,
      other: '$groups groups',
      one: '1 group',
      zero: 'No groups',
    );
    return '$_temp0 / $events';
  }

  @override
  String get copy => 'Copy';

  @override
  String get noFilteredRealtimeEvents =>
      'No realtime events match the current filter';

  @override
  String get sent => 'Sent';

  @override
  String get received => 'Received';

  @override
  String latestAt(String time) {
    return 'Latest $time';
  }

  @override
  String byteCount(int count) {
    return '$count bytes';
  }

  @override
  String get brightness => 'Brightness';

  @override
  String get volume => 'Volume';

  @override
  String brightnessPercent(int value) {
    return 'Brightness $value%';
  }

  @override
  String volumePercent(int value) {
    return 'Volume $value%';
  }

  @override
  String get unmute => 'Unmute';

  @override
  String get mute => 'Mute';

  @override
  String get muted => 'Muted';

  @override
  String get chooseSubtitles => 'Choose subtitles';

  @override
  String get disableSubtitles => 'Turn off subtitles';

  @override
  String get danmaku => 'Danmaku';

  @override
  String get videoDanmaku => 'Video danmaku';

  @override
  String get chatDanmaku => 'Chat danmaku';

  @override
  String get danmakuHint => 'Send a danmaku for this moment...';

  @override
  String get pause => 'Pause';

  @override
  String get play => 'Play';

  @override
  String get info => 'Information';

  @override
  String get live => 'Live';

  @override
  String get playbackProgress => 'Playback progress';

  @override
  String get subtitles => 'Subtitles';

  @override
  String get disableVideoDanmaku => 'Turn off video danmaku';

  @override
  String get enableVideoDanmaku => 'Turn on video danmaku';

  @override
  String get disableChatDanmaku => 'Turn off chat danmaku';

  @override
  String get enableChatDanmaku => 'Turn on chat danmaku';

  @override
  String get overlaySettings => 'Subtitle and danmaku settings';

  @override
  String get subtitleSettings => 'Subtitle settings';

  @override
  String get videoDanmakuSettings => 'Video danmaku settings';

  @override
  String get chatDanmakuSettings => 'Chat danmaku settings';

  @override
  String get subtitleStyle => 'Subtitle style';

  @override
  String get subtitleSize => 'Subtitle size';

  @override
  String get subtitleOpacity => 'Subtitle opacity';

  @override
  String get subtitleBackground => 'Subtitle background';

  @override
  String get subtitlePosition => 'Subtitle position';

  @override
  String get subtitleColor => 'Subtitle color';

  @override
  String get subtitleBackgroundColor => 'Subtitle background color';

  @override
  String get subtitleOutline => 'Subtitle outline';

  @override
  String get videoDanmakuStyle => 'Video danmaku style';

  @override
  String get chatDanmakuStyle => 'Chat danmaku style';

  @override
  String get danmakuSize => 'Danmaku size';

  @override
  String get danmakuOpacity => 'Danmaku opacity';

  @override
  String get danmakuSpeed => 'Danmaku speed';

  @override
  String get danmakuArea => 'Danmaku area';

  @override
  String get danmakuOutline => 'Danmaku outline';

  @override
  String get danmakuMassiveMode => 'Massive danmaku';

  @override
  String get danmakuTop => 'Top danmaku';

  @override
  String get danmakuBottom => 'Bottom danmaku';

  @override
  String get danmakuScroll => 'Scrolling danmaku';

  @override
  String get resetOverlaySettings => 'Reset overlay style';

  @override
  String get reload => 'Reload';

  @override
  String get sync => 'Sync';

  @override
  String get sendDanmaku => 'Send danmaku';

  @override
  String get exitFullscreen => 'Exit fullscreen';

  @override
  String get fullscreen => 'Fullscreen';

  @override
  String get pictureInPicture => 'Picture in picture';

  @override
  String get exitPictureInPicture => 'Return to room';

  @override
  String get loopPlayback => 'Loop video';

  @override
  String get shufflePlayback => 'Shuffle playlist';

  @override
  String get sequentialPlayback => 'Sequential playback';

  @override
  String get syncPlayback => 'Sync with room';

  @override
  String get reloadLivePlayback => 'Reload live stream';

  @override
  String get reloadPlaybackSource => 'Reload playback source';

  @override
  String get copyPlaybackDebugInfo => 'Copy debug information';

  @override
  String get playbackDebugInfoCopied => 'Playback debug information copied';

  @override
  String get detailedPlaybackStatistics => 'Detailed playback statistics';

  @override
  String playbackModeUpdated(String mode) {
    return 'Playback order: $mode';
  }

  @override
  String updatePlaybackModeFailed(String error) {
    return 'Could not update playback order: $error';
  }

  @override
  String get playerResource => 'Resource';

  @override
  String get playerProvider => 'Provider';

  @override
  String get playerPlaybackRoute => 'Playback route';

  @override
  String get playerFormat => 'Format';

  @override
  String get playerViewportVideo => 'Viewport / video';

  @override
  String get playerPlaybackState => 'Playback';

  @override
  String get playerBufferHealth => 'Buffer health';

  @override
  String get playerSpeedVolume => 'Speed / volume';

  @override
  String get playerSynchronization => 'Synchronization';

  @override
  String get playerThroughput => 'Throughput / total';

  @override
  String get playerP2pDelivery => 'P2P delivery';

  @override
  String get playerCache => 'Cache / hit rate';

  @override
  String get playerError => 'Player error';

  @override
  String get playerStatePlaying => 'Playing';

  @override
  String get playerStatePaused => 'Paused';

  @override
  String get playerStateBuffering => 'Buffering';

  @override
  String playerLatencyMilliseconds(int value) {
    return '$value ms latency';
  }

  @override
  String playerDeviationMilliseconds(int value) {
    return '$value ms drift';
  }

  @override
  String playerBufferRangeCount(int count) {
    return '$count ranges';
  }

  @override
  String playerConnectedPeerCount(int count) {
    return '$count peers';
  }

  @override
  String get unknown => 'Unknown';

  @override
  String get playbackSpeed => 'Playback speed';

  @override
  String playbackSpeedValue(String speed) {
    return 'Playback speed ${speed}x';
  }

  @override
  String loadMediaBindingsFailed(String error) {
    return 'Could not load media source bindings: $error';
  }

  @override
  String get directLink => 'Direct link';

  @override
  String get rtmpPublishing => 'RTMP publishing';

  @override
  String get livePull => 'Live stream pull';

  @override
  String get alistStorage => 'AList storage';

  @override
  String get embyLibrary => 'Emby library';

  @override
  String get generatePublishingAddress => 'Generate a publishing address';

  @override
  String get bilibiliLinkParsing => 'BV / link parsing';

  @override
  String get mountedDirectoryResources => 'Mounted directory resources';

  @override
  String get personalMediaServer => 'Personal media server';

  @override
  String get source => 'Source';

  @override
  String connectedMediaSources(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count connected media sources',
      one: '1 connected media source',
      zero: 'No connected media sources',
    );
    return '$_temp0';
  }

  @override
  String get mediaSource => 'Media source';

  @override
  String get playbackKind => 'Playback type';

  @override
  String get onDemand => 'On demand';

  @override
  String get videoLinks => 'Video links';

  @override
  String get videoLinksHint => 'One HTTP, HTTPS, or HLS address per line';

  @override
  String get optionalVideoName => 'Video name (optional for one item)';

  @override
  String get defaultsToFileName => 'Defaults to the file name';

  @override
  String get playbackProxyMode => 'Playback route';

  @override
  String get playbackProxyAuto => 'Automatic';

  @override
  String get playbackProxyPrefer => 'Prefer proxy';

  @override
  String get playbackProxyOnly => 'Proxy only';

  @override
  String get playbackProxyDirectPrefer => 'Prefer direct';

  @override
  String get playbackProxyDirectOnly => 'Direct only';

  @override
  String get playbackProxyAutoDescription =>
      'Use the media source\'s default playback route';

  @override
  String get playbackProxyPreferDescription =>
      'Keep direct and proxy routes, selecting the proxy by default';

  @override
  String get playbackProxyOnlyDescription =>
      'Keep routes that the SyncTV server can proxy';

  @override
  String get playbackProxyDirectPreferDescription =>
      'Keep direct and proxy routes, selecting direct by default';

  @override
  String get playbackProxyDirectOnlyDescription =>
      'Keep direct playback routes only';

  @override
  String get playbackProxyDirectRisk =>
      'Direct playback can expose upstream URLs, signed links, tokens, cookies, or authorization headers to room members. Use it only in a trusted room and network.';

  @override
  String playbackProxyAutoEffective(
    Object mode,
    Object reason,
    Object variant,
  ) {
    return '$variant: $mode ($reason)';
  }

  @override
  String get playbackProxyReasonPublicResource => 'public resource';

  @override
  String get playbackProxyReasonRequestCredentials => 'request credentials';

  @override
  String get playbackProxyReasonSignedResource => 'signed resource';

  @override
  String get playbackProxyReasonProviderSession => 'provider session';

  @override
  String get playbackProxyReasonServerTransport => 'server transport';

  @override
  String playbackProxyPolicyUnavailable(Object error) {
    return 'Playback route policy is unavailable: $error';
  }

  @override
  String get playbackProxyNoCompatibleMode =>
      'No compatible playback route is available for this media source.';

  @override
  String get addToPlaylist => 'Add to playlist';

  @override
  String get requestHeaders => 'Request headers';

  @override
  String get noExtraRequestHeaders =>
      'No extra request headers are sent by default.';

  @override
  String get name => 'Name';

  @override
  String get value => 'Value';

  @override
  String get removeRequestHeader => 'Remove request header';

  @override
  String get liveName => 'Live stream name';

  @override
  String get liveNameHint => 'For example, Camera or OBS stream';

  @override
  String get streamMode => 'Stream mode';

  @override
  String get publishKeyType => 'Publish key type';

  @override
  String get singleUsePublishKey => 'One-time key';

  @override
  String get expiringPublishKey => 'Reusable until expiration';

  @override
  String get permanentPublishKey => 'Never expires';

  @override
  String get permanentPublishKeyDescription =>
      'Anyone with this key can publish until the server JWT secret changes.';

  @override
  String get noExpiration => 'Never expires';

  @override
  String get publishKeyExpirationMustBeFuture =>
      'Expiration time must be in the future.';

  @override
  String get audioAndVideo => 'Audio and video';

  @override
  String get videoOnly => 'Video only';

  @override
  String get audioOnly => 'Audio only';

  @override
  String get publishAddressGeneratedDescription =>
      'A publishing address and Stream Key will be generated';

  @override
  String get copyToStreamingToolDescription =>
      'Copy them to OBS or another streaming tool to start streaming.';

  @override
  String get createPublishingEntry => 'Create publishing entry';

  @override
  String get sourceAddress => 'Source address';

  @override
  String get liveSourceAddressHint =>
      'Enter an address matching the selected protocol';

  @override
  String get rtspTransport => 'RTSP transport';

  @override
  String get videoTrack => 'Video track';

  @override
  String get audioTrack => 'Audio track';

  @override
  String get firstCompatibleTrack => 'First compatible';

  @override
  String get trackIndex => 'Track index';

  @override
  String get optionalLiveName => 'Live stream name (optional)';

  @override
  String get optionalLiveNameHint =>
      'For example, upstream stream or event feed';

  @override
  String get serverPullsUpstreamLiveSource =>
      'The SyncTV server pulls the upstream live source';

  @override
  String get livePullSupportDescription =>
      'Supports RTMP, RTSP, and HTTP-FLV sources.';

  @override
  String get addLivePull => 'Add live stream pull';

  @override
  String get unknownTitle => 'Unknown title';

  @override
  String get bilibiliAccount => 'Bilibili account';

  @override
  String get bilibiliVideoLink => 'Video link / BV number';

  @override
  String get bilibiliVideoLinkHint => 'Paste a link to parse it automatically';

  @override
  String get parseBilibiliLink => 'Parse Bilibili link';

  @override
  String get pasteBilibiliLink => 'Paste a Bilibili link';

  @override
  String get bilibiliSupportedLinks =>
      'Supports BV numbers, video links, and live room links.';

  @override
  String get noFiles => 'No files';

  @override
  String get noMediaInDirectory =>
      'This directory has no media resources to add.';

  @override
  String get addAsDynamicPlaylist => 'Add as dynamic playlist';

  @override
  String addSelectedItems(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected items',
      one: 'the selected item',
    );
    return 'Add $_temp0';
  }

  @override
  String get noMedia => 'No media';

  @override
  String get noMediaLibraryItems =>
      'This media library directory has no items to add.';

  @override
  String get parentDirectory => 'Parent directory';

  @override
  String get parentPlaylist => 'Parent playlist';

  @override
  String get mediaSourceAccount => 'Media source account';

  @override
  String get searchCurrentDirectory => 'Search this directory';

  @override
  String get directoryPassword => 'Directory password';

  @override
  String get clearDirectoryPassword => 'Clear directory password';

  @override
  String get searchMediaLibrary => 'Search media library';

  @override
  String videoNumber(int number) {
    return 'Video $number';
  }

  @override
  String liveRoomNumber(int number) {
    return 'Live room $number';
  }

  @override
  String get selectMedia => 'Select media';

  @override
  String providerNotBound(String provider) {
    return '$provider is not bound';
  }

  @override
  String get bindAccountToAccessResources =>
      'Bind an account to access resources';

  @override
  String bindProviderNow(String provider) {
    return 'Bind $provider now';
  }

  @override
  String get localInstance => 'Local instance';

  @override
  String get directLinkVideo => 'Direct-link video';

  @override
  String get completeBlankRequestHeader =>
      'Complete the empty request header first';

  @override
  String get completeRequestHeaderNameAndValue =>
      'Enter both the request header name and value';

  @override
  String duplicateRequestHeader(String name) {
    return 'Request header $name is duplicated';
  }

  @override
  String get discardCurrentEdits => 'Discard current edits?';

  @override
  String get discardMediaDraftDescription =>
      'The entered media links, live source, name, and request headers will be cleared.';

  @override
  String get continueEditing => 'Continue editing';

  @override
  String get discard => 'Discard';

  @override
  String get addedSuccessfully => 'Added successfully';

  @override
  String itemsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items added',
      one: '1 item added',
    );
    return '$_temp0';
  }

  @override
  String addFailed(String error) {
    return 'Could not add media: $error';
  }

  @override
  String get confirmAdd => 'Confirm and add';

  @override
  String get enterHttpLinks => 'Enter an HTTP or HTTPS link';

  @override
  String get rtmpLive => 'RTMP live stream';

  @override
  String createPublishingEntryFailed(String error) {
    return 'Could not create the publishing entry: $error';
  }

  @override
  String addLivePullFailed(String error) {
    return 'Could not add the live stream pull: $error';
  }

  @override
  String get enterLiveSourceAddress => 'Enter a live source address';

  @override
  String get enterValidLiveSourceAddress => 'Enter a valid live source address';

  @override
  String get livePullUrlSupport =>
      'The address must match the selected RTMP, RTSP, or HTTP-FLV protocol';

  @override
  String get selectRtspTrack => 'Enable at least one RTSP track';

  @override
  String get enterValidTrackIndex => 'Enter a valid track index';

  @override
  String get publishingAddress => 'Publishing address';

  @override
  String get publishingHost => 'Publishing host';

  @override
  String get tsDisguise => 'TS disguise';

  @override
  String get pngDisguiseEnabled => 'PNG disguise enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get expirationTime => 'Expiration time';

  @override
  String get currentStatus => 'Current status';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get useServerPublishingHost =>
      'Use the server default publishing host';

  @override
  String get liveSegmentsAsPng => 'Live segments are distributed as PNG files';

  @override
  String get liveSegmentsAsTs => 'Live segments are distributed as TS files';

  @override
  String get copied => 'Copied';

  @override
  String parseFailed(String error) {
    return 'Could not parse the media: $error';
  }

  @override
  String get bilibiliVideoInfoUnavailable =>
      'Could not get Bilibili video information';

  @override
  String get bilibiliLiveRoomIdUnavailable =>
      'Could not get the Bilibili live room ID';

  @override
  String get bilibiliCidUnavailable => 'Could not get the Bilibili CID';

  @override
  String get bilibiliIdentifiersUnavailable => 'Could not get the BVID or CID';

  @override
  String loadFailed(String error) {
    return 'Could not load data: $error';
  }

  @override
  String get chooseBoundAlistAccount => 'Choose a bound AList account';

  @override
  String get dynamicPlaylistAdded => 'Dynamic playlist added';

  @override
  String batchAddFailed(String error) {
    return 'Could not add the selected items: $error';
  }

  @override
  String get chooseBoundEmbyAccount => 'Choose a bound Emby account';

  @override
  String get embyMediaIdUnavailable => 'Could not get the Emby media ID';

  @override
  String get embyDirectoryIdUnavailable =>
      'Could not get the Emby directory ID';

  @override
  String get manageConnections => 'Manage connections';

  @override
  String get bilibiliBound => 'Bilibili bound';

  @override
  String loadProviderBindingsFailed(String provider, String error) {
    return 'Could not load $provider bindings: $error';
  }

  @override
  String get confirmUnbind => 'Confirm unbinding';

  @override
  String confirmUnbindProvider(String provider) {
    return 'Unbind this $provider account?';
  }

  @override
  String get unbind => 'Unbind';

  @override
  String get unboundSuccessfully => 'Account unbound';

  @override
  String unbindFailed(String error) {
    return 'Could not unbind the account: $error';
  }

  @override
  String bindProvider(String provider) {
    return 'Bind $provider';
  }

  @override
  String providerDetails(String provider) {
    return '$provider details';
  }

  @override
  String loadDetailsFailed(String error) {
    return 'Could not load details: $error';
  }

  @override
  String get rootDirectory => 'Root directory';

  @override
  String get mediaLibraryRoot => 'Media library root';

  @override
  String get userId => 'User ID';

  @override
  String get instance => 'Instance';

  @override
  String get loginStatus => 'Login status';

  @override
  String get loggedIn => 'Logged in';

  @override
  String get loggedOutStatus => 'Logged out';

  @override
  String get bilibiliVip => 'Bilibili VIP';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get bilibiliNotBound => 'Bilibili is not bound';

  @override
  String noBoundProviderAccounts(String provider) {
    return 'No bound $provider accounts';
  }

  @override
  String get details => 'Details';

  @override
  String rebindProvider(String provider) {
    return 'Rebind $provider';
  }

  @override
  String providerAccount(String provider, String serverId) {
    return '$provider account $serverId';
  }

  @override
  String get bilibiliBoundDescription =>
      'The current account is bound to Bilibili. You can view its status or bind it again.';

  @override
  String get bilibiliBindingDescription =>
      'Binding enables Bilibili video, series, and live resource parsing.';

  @override
  String get viewStatus => 'View status';

  @override
  String get rebind => 'Rebind';

  @override
  String loadMediaSourceInstancesFailed(String error) {
    return 'Could not load media source instances: $error';
  }

  @override
  String get completeAllFields => 'Complete all required fields';

  @override
  String get boundSuccessfully => 'Account bound';

  @override
  String bindingFailed(String error) {
    return 'Could not bind the account: $error';
  }

  @override
  String get alistVersionRequirement => 'Requires AList 3.25.0 or later';

  @override
  String get connectionTarget => 'Connection target';

  @override
  String providerAddress(String provider) {
    return '$provider address';
  }

  @override
  String get providerAddressHint => '127.0.0.1 or https://example.com';

  @override
  String get port => 'Port';

  @override
  String get loginCredentials => 'Login credentials';

  @override
  String get twoFactorAuthentication => 'Two-factor authentication';

  @override
  String get oneTimeCode => 'One-time code';

  @override
  String get oneTimeCodeHint => 'Enter when 2FA is enabled';

  @override
  String get totpSecretHint => 'Optional, used for automatic refresh later';

  @override
  String get creatingLoginLink => 'Creating login link...';

  @override
  String get completeBilibiliLogin =>
      'Complete login in a browser or the Bilibili app';

  @override
  String createLoginLinkFailed(String error) {
    return 'Could not create the login link: $error';
  }

  @override
  String get loginLinkExpired => 'The login link expired. Generate a new one.';

  @override
  String get qrScannedConfirmLogin =>
      'Code scanned. Confirm login in Bilibili.';

  @override
  String get waitingForQrScan =>
      'Waiting for a scan or for the login link to open';

  @override
  String get waitingForBilibiliStatus => 'Waiting for Bilibili login status';

  @override
  String get bilibiliStatusRateLimited =>
      'Bilibili login status was checked too frequently. Generate a new login link later.';

  @override
  String checkLoginStatusFailed(String error) {
    return 'Could not check login status: $error';
  }

  @override
  String get openLoginLinkFailed => 'Could not open the login link';

  @override
  String get loginLinkCopied => 'Login link copied';

  @override
  String get switchToQrPrompt =>
      'Switch to the QR tab to generate a login code';

  @override
  String get qrCode => 'QR code';

  @override
  String get copyLink => 'Copy link';

  @override
  String get openLogin => 'Open login';

  @override
  String get regenerate => 'Regenerate';

  @override
  String get switchToCodePrompt =>
      'Switch to the code tab to prepare security verification';

  @override
  String get preparingSecurityVerification =>
      'Preparing security verification...';

  @override
  String get enterPhoneForSecurityVerification =>
      'Enter a phone number and complete security verification to send an SMS code';

  @override
  String prepareSecurityVerificationFailed(String error) {
    return 'Could not prepare security verification: $error';
  }

  @override
  String get enterPhoneNumber => 'Enter a phone number';

  @override
  String get completeBilibiliSecurityVerification =>
      'Complete Bilibili security verification';

  @override
  String get smsCodeSent => 'SMS verification code sent';

  @override
  String get verificationSessionExpired =>
      'The verification session expired. Restart SMS login.';

  @override
  String sendSmsFailed(String error) {
    return 'Could not send the SMS: $error';
  }

  @override
  String get sendSmsFirst => 'Send an SMS verification code first';

  @override
  String get enterSmsCode => 'Enter the SMS verification code';

  @override
  String get completingBilibiliBinding => 'Completing Bilibili binding...';

  @override
  String get loginSessionExpired =>
      'The login session expired. Verify again before sending an SMS.';

  @override
  String get authenticationSessionExpired =>
      'The authentication session expired. Start again.';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get bilibiliPhoneHint => 'Enter the phone number linked to Bilibili';

  @override
  String get smsVerificationCode => 'SMS verification code';

  @override
  String get enterReceivedCode => 'Enter the code you received';

  @override
  String get enterCodeAfterSms => 'Send an SMS, then enter the code';

  @override
  String get verifyAgain => 'Verify again';

  @override
  String get sendSms => 'Send SMS';

  @override
  String get bind => 'Bind';

  @override
  String get mediaSourceInstance => 'Media source instance';

  @override
  String get loginExpired => 'Your login expired. Log in again.';

  @override
  String get connectionClosedRetry =>
      'The connection closed. Exit the room and try again.';

  @override
  String get playbackResource => 'playback resource';

  @override
  String get playlist => 'Playlist';

  @override
  String errorMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get messageDeleted => 'Message deleted';

  @override
  String get imageMessage => '[Image]';

  @override
  String get genericMessage => '[Message]';

  @override
  String get quotedMessageUnavailable =>
      'The quoted message is outside the currently available range';

  @override
  String loadQuotedContextFailed(String error) {
    return 'Could not load the quoted message context: $error';
  }

  @override
  String serverSnapshotMissing(String resource) {
    return 'The server did not send a $resource snapshot';
  }

  @override
  String latencyValue(String value) {
    return 'Latency $value';
  }

  @override
  String get serverLatency => 'Server latency';

  @override
  String deviationValue(String value) {
    return 'Drift $value';
  }

  @override
  String get playbackDeviation => 'Playback drift';

  @override
  String get playbackUpdateFailed => 'Could not update playback state';

  @override
  String switchedToPlaybackRoute(String route) {
    return 'Switched to $route';
  }

  @override
  String get playbackRoute => 'Playback route';

  @override
  String get route => 'Route';

  @override
  String get qualityAndMediaLinks => 'Quality and media links';

  @override
  String get manifestQualities => 'Manifest qualities';

  @override
  String get automatic => 'Auto';

  @override
  String get selectPlaybackRoute => 'Choose route';

  @override
  String get playbackRouteMain => 'Main route';

  @override
  String playbackRouteBackup(int index) {
    return 'Backup route $index';
  }

  @override
  String get playbackRouteOriginal => 'Original';

  @override
  String get playbackRouteProgressive => 'Standard video';

  @override
  String get playbackRouteTranscoded => 'Transcoded';

  @override
  String get playbackRouteVideoHls => 'Video HLS';

  @override
  String get playbackRouteAudioHls => 'Audio HLS';

  @override
  String qualityTrack(String id) {
    return 'Quality $id';
  }

  @override
  String get back => 'Back';

  @override
  String get freeModeSettings => 'Free mode settings';

  @override
  String get stop => 'Stop';

  @override
  String get stopPlayback => 'Stop playback';

  @override
  String get roomManagement => 'Room management';

  @override
  String get unknownVideo => 'Unknown video';

  @override
  String get roomCollaboration => 'Room collaboration';

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
      zero: 'No people',
    );
    return '$_temp0';
  }

  @override
  String get copyInviteLink => 'Copy invitation link';

  @override
  String get syncedToLatestProgress => 'Synced to the latest position';

  @override
  String get playbackAddressReloaded => 'Playback address reloaded';

  @override
  String get reloadPlaybackAddressFailed =>
      'Could not reload the playback address';

  @override
  String secondsValue(String value) {
    return '$value seconds';
  }

  @override
  String get freeMode => 'Free mode';

  @override
  String get freeModeDescription =>
      'Keep your local playback position independent from realtime room corrections. Manual sync remains available.';

  @override
  String get syncCorrectionThreshold => 'Room sync correction threshold';

  @override
  String get manualSyncDriftThreshold => 'Minimum drift for manual sync';

  @override
  String get restoreDefaults => 'Restore defaults';

  @override
  String get freeModeSettingsSaved => 'Free mode settings saved';

  @override
  String get loadMemberListFailed => 'Could not load the member list';

  @override
  String sendDanmakuFailed(String error) {
    return 'Could not send danmaku: $error';
  }

  @override
  String get chat => 'Chat';

  @override
  String get list => 'List';

  @override
  String get members => 'Members';

  @override
  String get realtime => 'Realtime';

  @override
  String get realtimeEventsWebSocketDescription =>
      'Realtime events appear after WebSocket messages are sent or received';

  @override
  String get scrollToBottom => 'Scroll to bottom';

  @override
  String get pinned => 'Pinned';

  @override
  String get refreshPinnedMessages => 'Refresh pinned messages';

  @override
  String get unpin => 'Unpin';

  @override
  String replyingTo(String user) {
    return 'Replying to $user';
  }

  @override
  String get cancelReply => 'Cancel reply';

  @override
  String get edited => 'Edited';

  @override
  String get mentionRead => '@ read';

  @override
  String get read => 'Read';

  @override
  String readUnreadSummary(int read, int unread) {
    return '$read read · $unread unread';
  }

  @override
  String get viewMentionReadDetails => 'View @ read details';

  @override
  String get viewReadDetails => 'View read details';

  @override
  String get mentionUnread => '@ unread';

  @override
  String mentionReadUnreadSummary(int read, int unread) {
    return '@ $read read · $unread unread';
  }

  @override
  String loadReadDetailsFailed(String error) {
    return 'Could not load read details: $error';
  }

  @override
  String get quotedMessage => 'Quoted message';

  @override
  String get loadingQuotedMessage => 'Loading quoted message...';

  @override
  String get jumpToQuotedMessage => 'Jump to quoted message';

  @override
  String get reactionSelectedHint =>
      'Tap to remove reaction; long press to view members';

  @override
  String get reactionUnselectedHint =>
      'Tap to add reaction; long press to view members';

  @override
  String get react => 'React';

  @override
  String get reply => 'Reply';

  @override
  String get pin => 'Pin';

  @override
  String get report => 'Report';

  @override
  String removeReaction(String reaction) {
    return 'Remove reaction $reaction';
  }

  @override
  String addReaction(String reaction) {
    return 'React with $reaction';
  }

  @override
  String get closeMessageActions => 'Close message actions';

  @override
  String reactionFailed(String error) {
    return 'Could not update the reaction: $error';
  }

  @override
  String get noCopyableMessageText => 'This message has no text to copy';

  @override
  String get messageCopied => 'Message copied';

  @override
  String get messageUnpinned => 'Message unpinned';

  @override
  String get messagePinned => 'Message pinned';

  @override
  String unpinMessageFailed(String error) {
    return 'Could not unpin the message: $error';
  }

  @override
  String pinMessageFailed(String error) {
    return 'Could not pin the message: $error';
  }

  @override
  String deleteMessageFailed(String error) {
    return 'Could not delete the message: $error';
  }

  @override
  String get reportMessage => 'Report message';

  @override
  String get reportMember => 'Report member';

  @override
  String get reportUser => 'Report user';

  @override
  String get reportReasonSpam => 'Spam or advertising';

  @override
  String get reportReasonAbuse => 'Abuse or harassment';

  @override
  String get reportReasonIllegal => 'Illegal content';

  @override
  String get reportReasonSexual => 'Sexual content';

  @override
  String get reportReasonOther => 'Other issue';

  @override
  String get additionalDetails => 'Additional details';

  @override
  String get describeIssue => 'Describe the issue';

  @override
  String get submit => 'Submit';

  @override
  String get reportSubmitted => 'Report submitted';

  @override
  String reportFailed(String error) {
    return 'Could not submit the report: $error';
  }

  @override
  String voiceConnected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
    );
    return 'Voice connected ($_temp0)';
  }

  @override
  String voiceConnectedMuted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
    );
    return 'Voice connected ($_temp0) (muted)';
  }

  @override
  String waitingToJoinVoice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
    );
    return 'Waiting to join... ($_temp0)';
  }

  @override
  String waitingToJoinVoiceMuted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
    );
    return 'Waiting to join... ($_temp0) (muted)';
  }

  @override
  String get voiceChat => 'Voice chat';

  @override
  String get roomRealtimeFeatures => 'Realtime communication';

  @override
  String get voiceChatRoomEnabledDescription =>
      'Allow members to join voice calls in this room';

  @override
  String get voiceChatDisabledByRoom =>
      'A room administrator disabled voice chat';

  @override
  String get p2pMedia => 'P2P media delivery';

  @override
  String get p2pMediaRoomEnabledDescription =>
      'Allow members to share media data with peers in this room';

  @override
  String get p2pMediaDisabledByRoom =>
      'A room administrator disabled P2P media delivery';

  @override
  String get p2pMediaDescription =>
      'Share cached media directly with room members. Peers can see your network address and use your upload bandwidth. Swarm tickets isolate rooms, users, and resources.';

  @override
  String get p2pCacheSize => 'Cache capacity';

  @override
  String get p2pCacheSizeDescription =>
      'Persistent LRU cache shared across playback sessions. Entries expire after 10 minutes without access.';

  @override
  String get p2pSecurityMode => 'Peer data validation';

  @override
  String get p2pSecurityStandard => 'Standard';

  @override
  String get p2pSecurityStandardDescription =>
      'Checks framing, declared length, size limits, and timeouts. Validation adds no network traffic; scheduling can still race origins and peers.';

  @override
  String get p2pSecuritySampled => 'Origin sampling';

  @override
  String get p2pSecuritySampledDescription =>
      'Compares 10% of peer pieces with the origin using SHA-256. Conflicting peers are isolated for the current swarm session.';

  @override
  String get p2pIntegrityChecks => 'Integrity checks';

  @override
  String get p2pIntegrityMismatches => 'Integrity conflicts';

  @override
  String get p2pIntegrityUnavailable => 'Origin checks unavailable';

  @override
  String get p2pMetrics => 'P2P transfer metrics';

  @override
  String get totalDownload => 'Total download';

  @override
  String get totalUpload => 'Total upload';

  @override
  String get httpDownload => 'HTTP download';

  @override
  String get p2pDownload => 'P2P download';

  @override
  String get p2pUpload => 'P2P upload';

  @override
  String get connectedPeers => 'Connected peers';

  @override
  String get p2pCache => 'Cached data';

  @override
  String get cacheHitRate => 'Cache hit rate';

  @override
  String get leaveVoice => 'Leave voice chat';

  @override
  String get joining => 'Joining';

  @override
  String get join => 'Join';

  @override
  String get joinVoiceTimeout =>
      'Joining voice timed out. Check microphone permission.';

  @override
  String joinVoiceFailed(String error) {
    return 'Could not join voice chat: $error';
  }

  @override
  String get cancelSelection => 'Cancel selection';

  @override
  String get batchManage => 'Batch manage';

  @override
  String get compactList => 'Compact list';

  @override
  String get detailedList => 'Detailed list';

  @override
  String get grid => 'Grid';

  @override
  String get sourceType => 'Source type';

  @override
  String get sourcePath => 'Path';

  @override
  String get sourceQuery => 'Query';

  @override
  String get sharedSource => 'Shared source';

  @override
  String get shareMyCredentials => 'Share my credentials';

  @override
  String get parseLink => 'Parse link';

  @override
  String get preview => 'Preview';

  @override
  String get noItems => 'No items';

  @override
  String get addCurrentList => 'Add current list';

  @override
  String addSelectedCount(int count) {
    return 'Add selected ($count)';
  }

  @override
  String selectItem(String name) {
    return 'Select $name';
  }

  @override
  String get playlistName => 'Playlist name';

  @override
  String get providerInstance => 'Provider instance';

  @override
  String get defaultMediaSource => 'Default media source';

  @override
  String get defaultProviderInstance => 'Default';

  @override
  String get video => 'Video';

  @override
  String get videos => 'Videos';

  @override
  String get shorts => 'Shorts';

  @override
  String get posts => 'Posts';

  @override
  String get channel => 'Channel';

  @override
  String get search => 'Search';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get likedVideos => 'Liked videos';

  @override
  String get watchLater => 'Watch later';

  @override
  String get movie => 'Movie';

  @override
  String get movies => 'Movies';

  @override
  String get episode => 'Episode';

  @override
  String get episodes => 'Episodes';

  @override
  String get audio => 'Audio';

  @override
  String get folder => 'Folder';

  @override
  String get series => 'Series';

  @override
  String get bangumi => 'Bangumi';

  @override
  String get vod => 'VOD';

  @override
  String get popular => 'Popular';

  @override
  String get recommended => 'Recommended';

  @override
  String get videoParts => 'Video parts';

  @override
  String get creatorVideos => 'Creator videos';

  @override
  String get favoriteVideos => 'Favorite videos';

  @override
  String get collectionVideos => 'Collection videos';

  @override
  String get seriesVideos => 'Series videos';

  @override
  String get pgcSeason => 'PGC season';

  @override
  String get liveRecommended => 'Recommended live streams';

  @override
  String get liveFollowed => 'Followed live streams';

  @override
  String get liveArea => 'Live category';

  @override
  String get history => 'History';

  @override
  String get pgcTimeline => 'PGC timeline';

  @override
  String get pgcIndex => 'PGC index';

  @override
  String get followedAnime => 'Followed anime';

  @override
  String get followedCinema => 'Followed cinema';

  @override
  String get ongoing => 'Ongoing';

  @override
  String get finished => 'Finished';

  @override
  String get keyword => 'Keyword';

  @override
  String get liveCategory => 'Live category';

  @override
  String get liveSubcategory => 'Live subcategory';

  @override
  String get favoriteFolder => 'Favorite folder';

  @override
  String get privateLabel => 'Private';

  @override
  String get continueWatching => 'Continue watching';

  @override
  String get nextUp => 'Next up';

  @override
  String get recentlyAdded => 'Recently added';

  @override
  String get favoritePeople => 'Favorite people';

  @override
  String get serverPlaylists => 'Server playlists';

  @override
  String get collections => 'Collections';

  @override
  String get genres => 'Genres';

  @override
  String get files => 'Files';

  @override
  String get mediaLibrary => 'Media library';

  @override
  String get favorites => 'Favorites';

  @override
  String get starred => 'Starred';

  @override
  String get libraries => 'Libraries';

  @override
  String get tvShows => 'TV shows';

  @override
  String get homeVideos => 'Home videos';

  @override
  String get tvRecordings => 'TV recordings';

  @override
  String get mediaUrl => 'Media URL';

  @override
  String get channelArchive => 'Channel archive';

  @override
  String get followedLive => 'Followed live';

  @override
  String get categoryLive => 'Live by category';

  @override
  String get searchLive => 'Search live channels';

  @override
  String get highlights => 'Highlights';

  @override
  String get uploads => 'Uploads';

  @override
  String get clips => 'Clips';

  @override
  String get loadCategories => 'Load categories';

  @override
  String get noScheduledStreams => 'No scheduled streams';

  @override
  String get videoUrlOrId => 'Video URL or ID';

  @override
  String get playlistUrlOrId => 'Playlist URL or ID';

  @override
  String get channelUrlOrId => 'Channel URL or ID';

  @override
  String get searchQueryLabel => 'Search query';

  @override
  String get liveUrlOrId => 'Live URL or ID';

  @override
  String get authorIdentifier => 'Creator identifier';

  @override
  String get liveVodClipUrl => 'Live, VOD, or clip URL';

  @override
  String get channelNameOrUrl => 'Channel name or URL';

  @override
  String get channelSearch => 'Channel search';

  @override
  String get creatorSecUid => 'Creator sec_uid';

  @override
  String get usernameOrHandle => 'Username or @handle';

  @override
  String get videoUrlShortLinkOrId => 'Video URL, short link, or ID';

  @override
  String get liveUrlOrRoomId => 'Live URL or room ID';

  @override
  String get noPosts => 'No posts';

  @override
  String get noTwitchItems => 'No Twitch items';

  @override
  String get schedule => 'Schedule';

  @override
  String get recurring => 'Recurring';

  @override
  String get clip => 'Clip';

  @override
  String viewsCount(int count) {
    return '$count views';
  }

  @override
  String viewersCount(int count) {
    return '$count viewers';
  }

  @override
  String get previewSourceFirst => 'Preview the source before adding';

  @override
  String get embyAccount => 'Emby account';

  @override
  String get listSourceToPreview => 'List a source to preview items';

  @override
  String get acfunUrl => 'AcFun URL';

  @override
  String get cctvUrlOrVideoId => 'CCTV URL or video ID';

  @override
  String get liveRoomOrVideoUrl => 'Live room or video URL';

  @override
  String get roomIdAliasOrUrl => 'Room ID, alias, or URL';

  @override
  String get embyDiscoveryAndLists => 'Discovery & lists';

  @override
  String get noPreparedLinks => 'No prepared links';

  @override
  String get fileStation => 'File Station';

  @override
  String get videoStation => 'Video Station';

  @override
  String get library => 'Library';

  @override
  String get selectLibraryFirst => 'Select a library first';

  @override
  String unlockLibrary(String name) {
    return 'Unlock $name';
  }

  @override
  String get libraryPassword => 'Library password';

  @override
  String get unlock => 'Unlock';

  @override
  String get enterAtLeastThreeCharacters => 'Enter at least 3 characters';

  @override
  String get favorite => 'Favorite';

  @override
  String get markWatched => 'Mark watched';

  @override
  String get markUnwatched => 'Mark unwatched';

  @override
  String get encrypted => 'Encrypted';

  @override
  String get openFolder => 'Open folder';

  @override
  String get sharedFolders => 'Shared folders';

  @override
  String get shares => 'Shares';

  @override
  String get allFiles => 'All files';

  @override
  String readyQualities(String qualities) {
    return 'Ready: $qualities';
  }

  @override
  String formatsCount(int count) {
    return '$count formats';
  }

  @override
  String subtitlesCount(int count) {
    return '$count subtitles';
  }

  @override
  String variantsCount(int count) {
    return '$count variants';
  }

  @override
  String qualitiesCount(int count) {
    return '$count qualities';
  }

  @override
  String chaptersCount(int count) {
    return '$count chapters';
  }

  @override
  String watermarkFreeCount(int count) {
    return '$count watermark-free';
  }

  @override
  String get storyboard => 'Storyboard';

  @override
  String get hotLabel => 'Hot';

  @override
  String get anime => 'Anime';

  @override
  String get cinema => 'Cinema';

  @override
  String get guochuang => 'Chinese animation';

  @override
  String get documentary => 'Documentary';

  @override
  String get television => 'TV';

  @override
  String get variety => 'Variety';

  @override
  String get updated => 'Recently updated';

  @override
  String get plays => 'Plays';

  @override
  String get followers => 'Followers';

  @override
  String get score => 'Score';

  @override
  String get started => 'Start date';

  @override
  String get released => 'Release date';

  @override
  String get timeline => 'Timeline';

  @override
  String get daysBefore => 'Days before';

  @override
  String get daysAfter => 'Days after';

  @override
  String get sortOrder => 'Order';

  @override
  String get statusLabel => 'Status';

  @override
  String get area => 'Area';

  @override
  String get yearOrRange => 'Year or range';

  @override
  String get styleId => 'Style ID';

  @override
  String get delayed => 'Delayed';

  @override
  String get published => 'Published';

  @override
  String get videoBvid => 'Video BV number';

  @override
  String get videoAidOptional => 'Video AV number (optional)';

  @override
  String get creatorMid => 'Creator UID';

  @override
  String get seasonId => 'Season ID';

  @override
  String get collectionSeasonId => 'Collection ID';

  @override
  String get seriesId => 'Series ID';

  @override
  String get multipleRoutes => 'Multiple routes';

  @override
  String get proxy => 'Proxy';

  @override
  String get openable => 'Openable';

  @override
  String get dynamicPlaylist => 'Dynamic playlist';

  @override
  String get dynamicMedia => 'Dynamic media';

  @override
  String get media => 'Media';

  @override
  String onlineMembers(int count) {
    return 'Online members ($count)';
  }

  @override
  String get makeAdmin => 'Make administrator';

  @override
  String get removeAdmin => 'Remove administrator';

  @override
  String get removeMember => 'Remove member';

  @override
  String get me => 'Me';

  @override
  String get administrator => 'Administrator';

  @override
  String onlineConnections(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count connections',
      one: '1 connection',
    );
    return 'Online · $_temp0';
  }

  @override
  String offlineJoinedAt(String date) {
    return 'Offline · joined $date';
  }

  @override
  String get playlistSubscribeFailed => 'Could not subscribe to the playlist';

  @override
  String get playlistBrowseAccessDenied =>
      'You do not have permission to browse this playlist';

  @override
  String get switchedAndPlaying => 'Switched and started playback';

  @override
  String switchFailed(String error) {
    return 'Could not switch: $error';
  }

  @override
  String get deleteEntries => 'Delete entries';

  @override
  String confirmDeleteMediaEntries(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'the $count selected media entries',
      one: 'the selected media entry',
    );
    return 'Delete $_temp0?';
  }

  @override
  String get dynamicPlaylistCannotDelete =>
      'Dynamic playlist contents cannot be deleted from the room';

  @override
  String get deleted => 'Deleted';

  @override
  String deleteEntryFailed(String error) {
    return 'Could not delete the entry: $error';
  }

  @override
  String get playbackStopped => 'Playback stopped';

  @override
  String stopPlaybackFailed(String error) {
    return 'Could not stop playback: $error';
  }

  @override
  String get roomManagersOnly =>
      'Only the room owner and administrators can manage the room';

  @override
  String loadSettingsFailed(String error) {
    return 'Could not load settings: $error';
  }

  @override
  String confirmMakeAdmin(String user) {
    return 'Make $user an administrator?\nAdministrators can remove members and manage the room.';
  }

  @override
  String madeAdmin(String user) {
    return '$user is now an administrator';
  }

  @override
  String settingFailed(String error) {
    return 'Could not update the setting: $error';
  }

  @override
  String confirmRemoveAdmin(String user) {
    return 'Remove administrator access from $user?';
  }

  @override
  String removedAdmin(String user) {
    return 'Administrator access removed from $user';
  }

  @override
  String cancelActionFailed(String error) {
    return 'Could not cancel: $error';
  }

  @override
  String get memberKicked => 'Member removed';

  @override
  String kickMemberFailed(String error) {
    return 'Could not remove the member: $error';
  }

  @override
  String get kickMember => 'Remove member';

  @override
  String confirmKickMember(String user) {
    return 'Remove $user and set a cooldown before they can rejoin.';
  }

  @override
  String get cooldownSeconds => 'Cooldown in seconds';

  @override
  String get cooldownSecondsRange => 'Enter a value from 1 to 2592000 seconds';

  @override
  String get kick => 'Remove';

  @override
  String chooseImageFailed(String error) {
    return 'Could not choose the image: $error';
  }

  @override
  String sendFailed(String error) {
    return 'Could not send the message: $error';
  }

  @override
  String get overview => 'Overview';

  @override
  String get profile => 'Profile';

  @override
  String get rooms => 'Rooms';

  @override
  String get security => 'Security';

  @override
  String get notifications => 'Notifications';

  @override
  String get bindings => 'Bindings';

  @override
  String get accountPreferences => 'Account preferences';

  @override
  String get accountPreferencesUnavailableImpact =>
      'Multi-factor authentication status, notification preferences, and security capability checks are unavailable.';

  @override
  String get notificationCenter => 'Notification center';

  @override
  String get notificationsUnavailableImpact =>
      'Unread counts, notification lists, marking as read, and notification deletion are unavailable.';

  @override
  String get myRooms => 'My rooms';

  @override
  String get myRoomsUnavailableImpact =>
      'Room listing, room search, and room management in the account center are unavailable.';

  @override
  String get oauthAvailableAccounts => 'Available OAuth2 accounts';

  @override
  String get oauthProvidersUnavailableImpact =>
      'Available third-party login providers cannot be displayed.';

  @override
  String get oauthLinkedAccounts => 'Linked OAuth2 accounts';

  @override
  String get oauthLinksUnavailableImpact =>
      'Linked third-party login accounts cannot be viewed or unlinked.';

  @override
  String get passkeyCredentials => 'Passkey credentials';

  @override
  String get passkeysUnavailableImpact =>
      'Server passkey credentials cannot be viewed, created, or deleted.';

  @override
  String get localPasskeyCapability => 'Local passkey capability';

  @override
  String get localPasskeyUnavailableImpact =>
      'Passkey creation support on this device cannot be confirmed.';

  @override
  String get serverPublicSettings => 'Server public settings';

  @override
  String get publicSettingsUnavailableImpact =>
      'Email and passkey availability cannot be determined.';

  @override
  String get notBound => 'Not bound';

  @override
  String get bound => 'Bound';

  @override
  String loadAccountFailed(String error) {
    return 'Could not load account information: $error';
  }

  @override
  String get changeUsername => 'Change username';

  @override
  String get changeUsernameDescription =>
      'Set your public username on this server';

  @override
  String get usernameUpdated => 'Username updated';

  @override
  String updateUsernameFailed(String error) {
    return 'Could not update the username: $error';
  }

  @override
  String get avatarUpdated => 'Avatar updated';

  @override
  String updateAvatarFailed(String error) {
    return 'Could not update the avatar: $error';
  }

  @override
  String get removeAvatar => 'Remove avatar';

  @override
  String get confirmRemoveAvatar =>
      'Remove the current avatar? Your account will use the default avatar.';

  @override
  String get avatarRemoved => 'Avatar removed';

  @override
  String removeAvatarFailed(String error) {
    return 'Could not remove the avatar: $error';
  }

  @override
  String get notificationPreferencesSaved => 'Notification preferences saved';

  @override
  String saveNotificationPreferencesFailed(String error) {
    return 'Could not save notification preferences: $error';
  }

  @override
  String get mfaSettingsSaved => 'Multi-factor authentication settings saved';

  @override
  String saveMfaSettingsFailed(String error) {
    return 'Could not save multi-factor authentication settings: $error';
  }

  @override
  String get unbindEmail => 'Unbind email';

  @override
  String get unbindEmailDescription =>
      'After unbinding, this email can no longer receive verification codes, email notifications, or password reset messages.';

  @override
  String get emailUnbound => 'Email unbound';

  @override
  String unbindEmailFailed(String error) {
    return 'Could not unbind the email: $error';
  }

  @override
  String get emailBound => 'Email bound';

  @override
  String get noPasswordVerificationMethod =>
      'This account has no available password verification method';

  @override
  String get passwordUpdated => 'Password updated';

  @override
  String updatePasswordFailed(String error) {
    return 'Could not update the password: $error';
  }

  @override
  String get accountHasNoEmail => 'This account has no email address';

  @override
  String get passwordReset => 'Password reset';

  @override
  String resetPasswordFailed(String error) {
    return 'Could not reset the password: $error';
  }

  @override
  String get deletePasskey => 'Delete passkey';

  @override
  String confirmDeletePasskey(String name) {
    return 'Delete “$name”? This device will no longer be able to use the passkey to log in.';
  }

  @override
  String get passkeyDeleted => 'Passkey deleted';

  @override
  String deletePasskeyFailed(String error) {
    return 'Could not delete the passkey: $error';
  }

  @override
  String get bindPasskey => 'Bind passkey';

  @override
  String get bindPasskeyDescription =>
      'Create a recognizable name for this device';

  @override
  String get deviceName => 'Device name';

  @override
  String get deviceNameExample => 'For example, MacBook or phone';

  @override
  String get passkeyBound => 'Passkey bound';

  @override
  String bindPasskeyFailed(String error) {
    return 'Could not bind the passkey: $error';
  }

  @override
  String get allMarkedRead => 'All notifications marked as read';

  @override
  String operationFailed(String error) {
    return 'Operation failed: $error';
  }

  @override
  String get selectedNotificationsMarked => 'Selected notifications marked';

  @override
  String markFailed(String error) {
    return 'Could not mark the notification: $error';
  }

  @override
  String get readNotificationsDeleted => 'Read notifications deleted';

  @override
  String loadNotificationDetailsFailed(String error) {
    return 'Could not load notification details; showing list content: $error';
  }

  @override
  String loadNotificationsFailed(String error) {
    return 'Could not load notifications: $error';
  }

  @override
  String get openAuthorizationLinkFailed =>
      'Could not open the authorization link';

  @override
  String get completeAuthorizationInBrowser =>
      'Complete authorization in your browser';

  @override
  String get oauthAccountBound => 'OAuth2 account linked';

  @override
  String oauthBindingFailed(String error) {
    return 'Could not link the OAuth2 account: $error';
  }

  @override
  String loadMyRoomsFailed(String error) {
    return 'Could not load your rooms: $error';
  }

  @override
  String openRoomManagementFailed(String error) {
    return 'Could not open room management: $error';
  }

  @override
  String get leaveRoom => 'Leave room';

  @override
  String deleteOwnedRoomDescription(String name) {
    return 'This permanently deletes “$name” and its room data. All members will lose access.';
  }

  @override
  String leaveRoomDescription(String name) {
    return 'Leave “$name”? You will need to join again to regain access.';
  }

  @override
  String actionCompleted(String action) {
    return '$action completed';
  }

  @override
  String actionFailed(String action, String error) {
    return '$action failed: $error';
  }

  @override
  String get closeAccount => 'Close account';

  @override
  String get closeAccountDescription =>
      'This permanently closes the current account and its personal data.';

  @override
  String enterCloseAccountToConfirm(String text) {
    return 'Enter $text to confirm';
  }

  @override
  String get confirmationTextMismatch => 'Confirmation text does not match';

  @override
  String get accountClosed => 'Account closed';

  @override
  String closeAccountFailed(String error) {
    return 'Could not close the account: $error';
  }

  @override
  String get currentAccount => 'Current account';

  @override
  String get unreadNotifications => 'Unread notifications';

  @override
  String get loginFactors => 'Login factors';

  @override
  String get emailStatus => 'Email status';

  @override
  String get personalProfile => 'Personal profile';

  @override
  String get personalProfileDescription =>
      'Manage your public identity and account status on this server';

  @override
  String emailWithStatus(String status) {
    return 'Email $status';
  }

  @override
  String get banned => 'Banned';

  @override
  String get emailNotBound => 'Email not bound';

  @override
  String get accountInformation => 'Account information';

  @override
  String get accountStatus => 'Account status';

  @override
  String get createdAt => 'Created at';

  @override
  String get updatedAt => 'Updated at';

  @override
  String get onlineConnectionsLabel => 'Online connections';

  @override
  String get banReason => 'Ban reason';

  @override
  String get notificationPreferences => 'Notification preferences';

  @override
  String get notificationPreferencesDescription =>
      'Control in-app and email notifications by scenario';

  @override
  String get roomInviteInAppNotifications =>
      'Room invitation in-app notifications';

  @override
  String get roomEventInAppNotifications => 'Room event in-app notifications';

  @override
  String get systemAnnouncementInAppNotifications =>
      'System announcement in-app notifications';

  @override
  String get roomInviteEmailNotifications =>
      'Room invitation email notifications';

  @override
  String get roomEventEmailNotifications => 'Room event email notifications';

  @override
  String get systemAnnouncementEmailNotifications =>
      'System announcement email notifications';

  @override
  String get notificationPreferencesUnavailable =>
      'Notification preferences unavailable';

  @override
  String get myRoomsDescription =>
      'Manage synchronized watch spaces you created, joined, or can access';

  @override
  String get searchRoomNameOrDescription => 'Search room name or description';

  @override
  String get all => 'All';

  @override
  String get createdByMe => 'Created by me';

  @override
  String get joinedByMe => 'Joined by me';

  @override
  String get recentActivity => 'Recent activity';

  @override
  String get frequentlyVisited => 'Frequently visited';

  @override
  String get recentlyVisited => 'Recently visited';

  @override
  String get refreshRooms => 'Refresh rooms';

  @override
  String pageRangeSummary(int page, int pages, int start, int end, int total) {
    return 'Page $page of $pages · $start-$end / $total';
  }

  @override
  String get myRoomsTemporarilyUnavailable =>
      'My rooms are temporarily unavailable';

  @override
  String get noMatchingRooms => 'No matching rooms';

  @override
  String get localPasskey => 'Local passkey';

  @override
  String get accountSecurity => 'Account security';

  @override
  String get accountSecurityDescription =>
      'Manage login factors, device credentials, and high-risk account actions';

  @override
  String get loginProtection => 'Login protection';

  @override
  String get loginProtectionDescription =>
      'Multi-factor authentication requires an additional factor beyond your password';

  @override
  String get multiFactorAuthentication => 'Multi-factor authentication';

  @override
  String availableFactors(String factors) {
    return 'Available factors: $factors';
  }

  @override
  String get listSeparator => ', ';

  @override
  String get bindEmailDescription =>
      'Bind an email to receive verification codes, notifications, and password reset messages';

  @override
  String get loginPassword => 'Login password';

  @override
  String get opaquePasswordDescription =>
      'Update the account password using the OPAQUE protocol';

  @override
  String get emailReset => 'Email reset';

  @override
  String get loginProtectionUnavailable =>
      'Login protection information unavailable';

  @override
  String get passkeyManagementDescription =>
      'Use the system credential manager for passwordless or multi-factor verification';

  @override
  String get noPasskeys => 'No passkeys';

  @override
  String get unnamedPasskey => 'Unnamed passkey';

  @override
  String createdAtValue(String value) {
    return 'Created $value';
  }

  @override
  String lastUsedAt(String value) {
    return 'Last used $value';
  }

  @override
  String get dangerousActions => 'Dangerous actions';

  @override
  String get dangerousActionsDescription =>
      'These actions affect account availability or permanently delete data';

  @override
  String get closeAccountTileDescription =>
      'Permanently close this account and clear the local login state';

  @override
  String unreadTotalSummary(int unread, int total) {
    return 'Unread $unread / Total $total';
  }

  @override
  String selectedCount(int count) {
    return 'Selected $count';
  }

  @override
  String get markSelectedUnreadNotifications =>
      'Mark selected unread notifications';

  @override
  String get selectCurrentUnreadNotifications =>
      'Select unread notifications on this page';

  @override
  String get markAllRead => 'Mark all as read';

  @override
  String get deleteReadNotifications => 'Delete read notifications';

  @override
  String get searchTitleOrContent => 'Search title or content';

  @override
  String get unread => 'Unread';

  @override
  String get notificationType => 'Notification type';

  @override
  String get roomInvitation => 'Room invitation';

  @override
  String get systemAnnouncement => 'System announcement';

  @override
  String get roomEvent => 'Room event';

  @override
  String get passwordResetNotification => 'Password reset';

  @override
  String get emailBinding => 'Email binding';

  @override
  String get title => 'Title';

  @override
  String get descending => 'Descending';

  @override
  String get ascending => 'Ascending';

  @override
  String notificationPageRange(int page, int pages, int start, int end) {
    return 'Page $page of $pages · $start-$end';
  }

  @override
  String get notificationsTemporarilyUnavailable =>
      'Notifications are temporarily unavailable';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get selectNotification => 'Select notification';

  @override
  String get viewDetails => 'View details';

  @override
  String get markRead => 'Mark as read';

  @override
  String get mediaSourceAccounts => 'Media source accounts';

  @override
  String get mediaSourceAccountsDescription =>
      'Bind personal media accounts to browse AList, Emby, and Bilibili resources while adding videos.';

  @override
  String get alistAccountDescription =>
      'Personal storage and directory resources';

  @override
  String get cloudreveAccountDescription =>
      'Cloud storage media and directory resources';

  @override
  String get embyAccountDescription =>
      'Personal media library and video resources';

  @override
  String get bilibiliAccountDescription =>
      'Bilibili account and favorite resources';

  @override
  String get twitchAccountDescription => 'Twitch live streams, VODs, and clips';

  @override
  String get fnosAccountDescription => 'FNOS files and media libraries';

  @override
  String get qnapAccountDescription =>
      'QTS and QuTS hero File Station resources';

  @override
  String get synologyAccountDescription =>
      'File Station and Video Station resources';

  @override
  String get nextcloudAccountDescription =>
      'Nextcloud files, favorites, and media search';

  @override
  String get seafileAccountDescription =>
      'Seafile libraries, starred files, and media search';

  @override
  String get truenasAccountDescription => 'TrueNAS ZFS filesystem media';

  @override
  String get youtubeAccountDescription =>
      'YouTube videos, live streams, and dynamic playlists with Cookie, Visitor Data, or PO Token';

  @override
  String get douyinAccountDescription =>
      'Douyin videos, live streams, comments, and creator posts with Cookie';

  @override
  String get tiktokAccountDescription =>
      'TikTok videos, live streams, captions, and creator posts with Cookie';

  @override
  String get linkedOAuth2 => 'Linked OAuth2';

  @override
  String get bindNewAccount => 'Link a new account';

  @override
  String get oauthAppLinkUnavailable =>
      'This build has no OAuth2 App Link configured, so authorization cannot return to this device.';

  @override
  String waitingForAuthorizationCallback(String provider) {
    return 'Waiting for $provider authorization callback';
  }

  @override
  String get cancelBinding => 'Cancel linking';

  @override
  String get role => 'Role';

  @override
  String get viewProfile => 'View profile';

  @override
  String get enabled => 'Enabled';

  @override
  String get availableFactorsLabel => 'Available factors';

  @override
  String get manageSecurity => 'Manage security';

  @override
  String get recentRooms => 'Recent rooms';

  @override
  String creatorName(String name) {
    return 'Creator $name';
  }

  @override
  String get manageRooms => 'Manage rooms';

  @override
  String get user => 'User';

  @override
  String get normal => 'Normal';

  @override
  String get pendingReview => 'Pending review';

  @override
  String get closed => 'Closed';

  @override
  String get creator => 'Creator';

  @override
  String get roomAdministrator => 'Room administrator';

  @override
  String get member => 'Member';

  @override
  String get none => 'None';

  @override
  String get currentPassword => 'Current password';

  @override
  String get verifyWithCurrentPassword => 'Verify with the current password';

  @override
  String get verifyWithEmailCode => 'Verify with a code sent by email';

  @override
  String get verifyWithSystemPasskey =>
      'Use a system passkey for identity verification';

  @override
  String get changePassword => 'Change password';

  @override
  String get changePasswordDescription =>
      'Choose an available verification method, then set a new login password.';

  @override
  String get verificationMethod => 'Verification method';

  @override
  String get identityVerification => 'Identity verification';

  @override
  String get emailVerificationCode => 'Email verification code';

  @override
  String get passkeyVerification => 'Passkey verification';

  @override
  String get passkeyPasswordUpdateDescription =>
      'Saving opens the system verification dialog. The new password is applied after successful verification.';

  @override
  String get savePassword => 'Save password';

  @override
  String get codeAndNewPasswordRequired =>
      'Enter the verification code and new password';

  @override
  String get emailPasswordReset => 'Reset password by email';

  @override
  String get emailPasswordResetDescription =>
      'Send a one-time code to the bound email and use it to reset the password.';

  @override
  String get recipientEmail => 'Recipient email';

  @override
  String get sendVerificationCode => 'Send verification code';

  @override
  String get bindingEmailSent => 'Binding confirmation email sent';

  @override
  String sendBindingEmailFailed(String error) {
    return 'Could not send the binding email: $error';
  }

  @override
  String bindEmailFailed(String error) {
    return 'Could not bind the email: $error';
  }

  @override
  String get bindEmail => 'Bind email';

  @override
  String get bindEmailBenefits =>
      'A bound email can be used for login, password recovery, and account notifications.';

  @override
  String get emailAddress => 'Email address';

  @override
  String get confirmationEmailSent => 'Confirmation email sent';

  @override
  String get confirmBinding => 'Confirm binding';

  @override
  String get bindingCode => 'Binding code';

  @override
  String initializeVerificationFailed(String error) {
    return 'Could not initialize identity verification: $error';
  }

  @override
  String sendCodeFailed(String error) {
    return 'Could not send the verification code: $error';
  }

  @override
  String get enterCurrentPassword => 'Enter the current password';

  @override
  String get enterEmailCode => 'Enter the email verification code';

  @override
  String get passkeyChallengeMissing =>
      'The server did not return a passkey verification challenge';

  @override
  String identityVerificationFailed(String error) {
    return 'Identity verification failed: $error';
  }

  @override
  String get identityVerificationDescription =>
      'Choose an available method to continue the account security action.';

  @override
  String get noVerificationMethods => 'No verification methods available';

  @override
  String get noVerificationMethodsDescription =>
      'This account has no password, email, or passkey verification capability.';

  @override
  String get verificationInformation => 'Verification information';

  @override
  String get passkeyVerificationDescription =>
      'The system verification dialog opens after you select Verify.';

  @override
  String get resend => 'Resend';

  @override
  String get verify => 'Verify';

  @override
  String updatedAtValue(String value) {
    return 'Updated $value';
  }

  @override
  String get data => 'Data';

  @override
  String get someAccountModulesUnavailable =>
      'Some account modules are temporarily unavailable';

  @override
  String get retryAll => 'Retry all';

  @override
  String get retry => 'Retry';

  @override
  String get moduleCurrentlyUnavailable =>
      'This module is currently unavailable.';

  @override
  String get moduleUnavailable => 'Module unavailable';

  @override
  String get review => 'Review';

  @override
  String roomMemberUpdateSummary(int online, int members, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      members,
      locale: localeName,
      other: '$members members',
      one: '1 member',
    );
    return '$online online · $_temp0 · Updated $time';
  }

  @override
  String get open => 'Open';

  @override
  String get manage => 'Manage';

  @override
  String get leave => 'Leave';

  @override
  String get settings => 'Settings';

  @override
  String get reports => 'Reports';

  @override
  String get network => 'Network';

  @override
  String get streaming => 'Streaming';

  @override
  String get allSources => 'All sources';

  @override
  String get roomCoverUpdated => 'Room cover updated';

  @override
  String updateRoomCoverFailed(String error) {
    return 'Could not update the room cover: $error';
  }

  @override
  String get roomCoverRemoved => 'Room cover removed';

  @override
  String removeRoomCoverFailed(String error) {
    return 'Could not remove the room cover: $error';
  }

  @override
  String get roomPasswordRemoved => 'Room password removed';

  @override
  String get roomPasswordUpdated => 'Room password updated';

  @override
  String updateRoomPasswordFailed(String error) {
    return 'Could not update the room password: $error';
  }

  @override
  String get removePassword => 'Remove password';

  @override
  String get noActionNeeded => 'No action needed';

  @override
  String get memberOnlineWatchFailed => 'Member online status watch failed';

  @override
  String get roomSettingsSnapshotEmpty => 'The room settings snapshot is empty';

  @override
  String get roomSettingsWatchFailed => 'Room settings watch failed';

  @override
  String get memberWatchFailed => 'Member watch failed';

  @override
  String get mediaSnapshotEmpty => 'The media list snapshot is empty';

  @override
  String get mediaLibraryWatchFailed => 'Media library watch failed';

  @override
  String get chatWatchFailed => 'Chat event watch failed';

  @override
  String get maxMembersRange => 'Maximum members must be between 0 and 10000';

  @override
  String get settingsUpdated => 'Settings updated';

  @override
  String get roomVisibilityUpdated => 'Room visibility updated';

  @override
  String get makeRoomPrivate => 'Make room private?';

  @override
  String get makeRoomPrivateConfirmation =>
      'The room will be removed from discovery and current anonymous guests will be disconnected.';

  @override
  String get makePrivate => 'Make private';

  @override
  String updateFailed(String error) {
    return 'Update failed: $error';
  }

  @override
  String loadActiveStreamsFailed(String error) {
    return 'Could not load active streams: $error';
  }

  @override
  String loadJoinReviewsFailed(String error) {
    return 'Could not load join requests: $error';
  }

  @override
  String loadMembersFailed(String error) {
    return 'Could not load members: $error';
  }

  @override
  String loadMediaLibraryFailed(String error) {
    return 'Could not load the media library: $error';
  }

  @override
  String get realtimeDiagnosticsCopied => 'Realtime diagnostics copied';

  @override
  String loadChatHistoryFailed(String error) {
    return 'Could not load chat history: $error';
  }

  @override
  String searchChatHistoryFailed(String error) {
    return 'Could not search chat history: $error';
  }

  @override
  String loadIceConfigFailed(String error) {
    return 'Could not load ICE configuration: $error';
  }

  @override
  String get dynamicPlaylistCreatorOnly =>
      'Only the creator can view this dynamic playlist';

  @override
  String get streamDisconnected => 'Stream disconnected';

  @override
  String disconnectStreamFailed(String error) {
    return 'Could not disconnect the stream: $error';
  }

  @override
  String get status => 'Status';

  @override
  String get publisher => 'Publisher';

  @override
  String get unknownPublisher => 'Unknown publisher';

  @override
  String get startTime => 'Start time';

  @override
  String get mediaIdCopied => 'Media ID copied';

  @override
  String get copyId => 'Copy ID';

  @override
  String get disconnectStream => 'Disconnect stream';

  @override
  String loadStreamDetailsFailed(String error) {
    return 'Could not load stream details: $error';
  }

  @override
  String get requestApproved => 'Request approved';

  @override
  String reviewFailed(String error) {
    return 'Review failed: $error';
  }

  @override
  String get requestRejected => 'Request rejected';

  @override
  String get memberAdded => 'Member added';

  @override
  String addMemberFailed(String error) {
    return 'Could not add the member: $error';
  }

  @override
  String get memberRoleUpdated => 'Member role updated';

  @override
  String updateRoleFailed(String error) {
    return 'Could not update the role: $error';
  }

  @override
  String get memberPermissionsUpdated => 'Member permissions updated';

  @override
  String updatePermissionsFailed(String error) {
    return 'Could not update permissions: $error';
  }

  @override
  String get remarkName => 'Remark name';

  @override
  String get remarkNameUpdated => 'Remark name updated';

  @override
  String updateRemarkNameFailed(String error) {
    return 'Could not update the remark name: $error';
  }

  @override
  String get displayLabel => 'Display label';

  @override
  String get displayLabelUpdated => 'Display label updated';

  @override
  String updateDisplayLabelFailed(String error) {
    return 'Could not update the display label: $error';
  }

  @override
  String get transferOwnership => 'Transfer ownership';

  @override
  String confirmTransferOwnership(String user) {
    return 'Transfer room ownership to $user?';
  }

  @override
  String get transfer => 'Transfer';

  @override
  String get ownershipTransferred => 'Room ownership transferred';

  @override
  String transferFailed(String error) {
    return 'Transfer failed: $error';
  }

  @override
  String get memberRemoved => 'Member removed';

  @override
  String removeMemberFailed(String error) {
    return 'Could not remove the member: $error';
  }

  @override
  String confirmRemoveMember(String user) {
    return 'Remove $user from the room and set a cooldown before they can rejoin.';
  }

  @override
  String get resetSettings => 'Reset settings';

  @override
  String get resetRoomSettingsDescription =>
      'Restore access control, message switches, member permissions, and guest permissions to server defaults? Unsaved room policy changes will be overwritten.';

  @override
  String get settingsReset => 'Settings reset';

  @override
  String resetFailed(String error) {
    return 'Reset failed: $error';
  }

  @override
  String confirmLeaveRoom(String room) {
    return 'Leave $room?';
  }

  @override
  String get leftRoom => 'Left room';

  @override
  String leaveRoomFailed(String error) {
    return 'Could not leave the room: $error';
  }

  @override
  String confirmPermanentRoomDeletion(String room) {
    return 'Permanently delete $room? This removes the room, playlist, and related room data.';
  }

  @override
  String get dynamicContentReadOnly =>
      'Dynamic source content can only be viewed and opened';

  @override
  String get newPlaylist => 'New playlist';

  @override
  String get playlistCreated => 'Playlist created';

  @override
  String createPlaylistFailed(String error) {
    return 'Could not create the playlist: $error';
  }

  @override
  String get clearMediaLibrary => 'Clear media library';

  @override
  String get clearPlaylist => 'Clear playlist';

  @override
  String get confirmClearMediaLibrary =>
      'Clear media and playlists from the media library root?';

  @override
  String get confirmClearPlaylist =>
      'Clear media and child playlists from the current playlist? The playlist itself will remain.';

  @override
  String get mediaLibraryCleared => 'Media library cleared';

  @override
  String clearFailed(String error) {
    return 'Could not clear content: $error';
  }

  @override
  String get editPlaylist => 'Edit playlist';

  @override
  String get playlistBrowseAccess => 'Browse access';

  @override
  String get playlistBrowseAccessDescription =>
      'Default allows room members to browse static playlists and limits dynamic playlists to their creator.';

  @override
  String get playlistBrowseAccessModeDefault => 'Default';

  @override
  String get playlistBrowseAccessModeRoomMembers => 'Room members';

  @override
  String get playlistBrowseAccessModeCreatorOnly => 'Creator only';

  @override
  String get editMedia => 'Edit media';

  @override
  String get nameUpdated => 'Name updated';

  @override
  String renameFailed(String error) {
    return 'Could not rename the entry: $error';
  }

  @override
  String confirmDeletePlaylist(String name) {
    return 'Delete playlist $name? Its child playlists and media will also be removed from the room media library.';
  }

  @override
  String confirmDeleteMedia(String name) {
    return 'Delete media $name? It will be removed from the room media library and synchronized immediately.';
  }

  @override
  String get entryDeleted => 'Entry deleted';

  @override
  String get type => 'Type';

  @override
  String get liveMedia => 'Live media';

  @override
  String get parent => 'Parent';

  @override
  String get description => 'Description';

  @override
  String get thumbnail => 'Thumbnail';

  @override
  String get childPlaylists => 'Child playlists';

  @override
  String get mediaCount => 'Media count';

  @override
  String get metadata => 'Metadata';

  @override
  String get sourceConfiguration => 'Source configuration';

  @override
  String get idCopied => 'ID copied';

  @override
  String get cover => 'Cover';

  @override
  String loadEntryDetailsFailed(String error) {
    return 'Could not load entry details: $error';
  }

  @override
  String get coverUpdated => 'Cover updated';

  @override
  String updateCoverFailed(String error) {
    return 'Could not update the cover: $error';
  }

  @override
  String get coverRemoved => 'Cover removed';

  @override
  String removeCoverFailed(String error) {
    return 'Could not remove the cover: $error';
  }

  @override
  String get thumbnailUpdated => 'Thumbnail updated';

  @override
  String updateThumbnailFailed(String error) {
    return 'Could not update the thumbnail: $error';
  }

  @override
  String get thumbnailRemoved => 'Thumbnail removed';

  @override
  String removeThumbnailFailed(String error) {
    return 'Could not remove the thumbnail: $error';
  }

  @override
  String get deletedMessageCannotEdit => 'Deleted messages cannot be edited';

  @override
  String get messageUpdated => 'Message updated';

  @override
  String editMessageFailed(String error) {
    return 'Could not edit the message: $error';
  }

  @override
  String get editMessage => 'Edit message';

  @override
  String get deleteMessage => 'Delete message';

  @override
  String get confirmDeleteChatMessage =>
      'Delete this chat message? It will be removed from every member\'s chat history.';

  @override
  String roomReportManagement(String room) {
    return 'Reports for $room';
  }

  @override
  String get reportRoom => 'Report room';

  @override
  String get messageContext => 'Message context';

  @override
  String loadMessageContextFailed(String error) {
    return 'Could not load message context: $error';
  }

  @override
  String mediaItemsMoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count media items moved',
      one: '1 media item moved',
    );
    return '$_temp0';
  }

  @override
  String moveFailed(String error) {
    return 'Could not move media: $error';
  }

  @override
  String get playlistOrderUpdated => 'Playlist order updated';

  @override
  String reorderFailed(String error) {
    return 'Could not reorder the playlist: $error';
  }

  @override
  String get moveMedia => 'Move media';

  @override
  String parentId(String id) {
    return 'Parent $id';
  }

  @override
  String get rejectRequest => 'Reject request';

  @override
  String get reason => 'Reason';

  @override
  String get reject => 'Reject';

  @override
  String get addMember => 'Add member';

  @override
  String get sendNotification => 'Send notification';

  @override
  String get changeRole => 'Change role';

  @override
  String get permissionOverrides => 'Permission overrides';

  @override
  String get clearOverrides => 'Clear overrides';

  @override
  String get inherit => 'Inherit';

  @override
  String get allow => 'Allow';

  @override
  String get deny => 'Deny';

  @override
  String get maximumMembers => 'Maximum members';

  @override
  String get zeroMeansUnlimited => '0 means unlimited';

  @override
  String get accessControl => 'Access control';

  @override
  String get allowGuestJoin => 'Allow guests to join';

  @override
  String get guestTokenCurrentRoomOnly =>
      'A guest token can access only this room';

  @override
  String get joinRequiresApproval => 'Require approval to join';

  @override
  String get newMembersRequireApproval =>
      'New member requests require administrator approval';

  @override
  String get allowAutomaticJoin => 'Allow automatic joining';

  @override
  String get automaticJoinDescription =>
      'When disabled, members can join only by invitation or administrator action';

  @override
  String get regularMemberPermissions => 'Regular member permissions';

  @override
  String get sendChatAndDanmaku => 'Send chat and danmaku';

  @override
  String get browseLibraryList => 'Browse library';

  @override
  String get viewMemberList => 'View member list';

  @override
  String get viewChatHistory => 'View chat history';

  @override
  String get webrtcCalls => 'WebRTC calls';

  @override
  String get guestPermissions => 'Guest permissions';

  @override
  String get settingsActions => 'Settings actions';

  @override
  String get savingSettings => 'Saving settings';

  @override
  String get saveRoomPolicyDescription =>
      'Save access control, message switches, and permission policies';

  @override
  String get saveSettings => 'Save settings';

  @override
  String get resetRoomSettings => 'Reset room settings';

  @override
  String get restoreServerRoomPolicy =>
      'Restore the server default room policy';

  @override
  String get activeStreams => 'Active streams';

  @override
  String get mediaId => 'Media ID';

  @override
  String get mediaIdAscending => 'Media ID ascending';

  @override
  String get mediaIdDescending => 'Media ID descending';

  @override
  String pagedItemSummary(int page, int pageSize, int total) {
    return 'Page $page · $pageSize per page · $total total';
  }

  @override
  String get noActiveStreams => 'No active streams';

  @override
  String get joinRequests => 'Join requests';

  @override
  String get approved => 'Approved';

  @override
  String get rejected => 'Rejected';

  @override
  String get noJoinRequests => 'No join requests';

  @override
  String get clearCurrentLevel => 'Clear current level';

  @override
  String get refreshDynamicList => 'Refresh dynamic list';

  @override
  String get searchMediaOrPlaylist => 'Search media or playlist';

  @override
  String get availability => 'Availability';

  @override
  String get available => 'Available';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get sort => 'Sort';

  @override
  String get position => 'Position';

  @override
  String get addedAt => 'Added at';

  @override
  String get noMediaEntriesAtCurrentLevel => 'No media entries at this level';

  @override
  String get realtimeDiagnostics => 'Realtime diagnostics';

  @override
  String get copyDiagnostics => 'Copy diagnostics';

  @override
  String get resetWatches => 'Reset watches';

  @override
  String get resources => 'Resources';

  @override
  String get events => 'Events';

  @override
  String get watchEventsDescription =>
      'Watch requests and resource events appear here';

  @override
  String get roomSettings => 'Room settings';

  @override
  String get roomSettingsShort => 'Settings';

  @override
  String get watchingSettingChanges => 'Watching setting changes';

  @override
  String get memberList => 'Member list';

  @override
  String get refreshingMembers => 'Refreshing members';

  @override
  String onlineTotalSummary(int online, int total) {
    return '$online online / $total total';
  }

  @override
  String get mediaList => 'Media list';

  @override
  String get waitingForMediaSnapshot => 'Waiting for media snapshot';

  @override
  String playlistMediaSummary(int playlists, int media) {
    String _temp0 = intl.Intl.pluralLogic(
      playlists,
      locale: localeName,
      other: '$playlists playlists',
      one: '1 playlist',
    );
    String _temp1 = intl.Intl.pluralLogic(
      media,
      locale: localeName,
      other: '$media media items',
      one: '1 media item',
    );
    return '$_temp0 / $_temp1';
  }

  @override
  String get chatEvents => 'Chat events';

  @override
  String get refreshingChatHistory => 'Refreshing chat history';

  @override
  String chatHistoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return 'Chat history: $_temp0';
  }

  @override
  String get watchedResources => 'Watched resources';

  @override
  String get sentReceived => 'Sent / received';

  @override
  String get errors => 'Errors';

  @override
  String get runtimeSnapshot => 'Runtime snapshot';

  @override
  String get room => 'Room';

  @override
  String get currentMediaLocation => 'Current media location';

  @override
  String get watchStatus => 'Watch status';

  @override
  String get version => 'Version';

  @override
  String get notProvided => 'Not provided';

  @override
  String get waiting => 'Waiting';

  @override
  String get localItems => 'Local items';

  @override
  String get latestEvent => 'Latest event';

  @override
  String get eventCounts => 'Event counts';

  @override
  String get lastTime => 'Last time';

  @override
  String get error => 'Error';

  @override
  String get observedWithChanges => 'Observed with changes';

  @override
  String get observedWithoutChanges => 'Observed without changes';

  @override
  String get snapshotPushed => 'Snapshot pushed';

  @override
  String get chatHistory => 'Chat history';

  @override
  String get searchChatContent => 'Search chat content';

  @override
  String searchQuery(String query) {
    return 'Search “$query”';
  }

  @override
  String get noMatchingChatMessages => 'No matching chat messages';

  @override
  String get noChatHistory => 'No chat history';

  @override
  String get iceServers => 'ICE servers';

  @override
  String get noIceServers => 'No ICE server configuration';

  @override
  String get roomMembers => 'Room members';

  @override
  String get usernameOrUserId => 'Username or user ID';

  @override
  String get allRoles => 'All roles';

  @override
  String get roomOwner => 'Room owner';

  @override
  String get joinedAt => 'Joined at';

  @override
  String get noMembers => 'No members';

  @override
  String onlineMemberSummary(int online, int members) {
    return '$online online / $members members';
  }

  @override
  String get approve => 'Approve';

  @override
  String get mediaActions => 'Media actions';

  @override
  String get updateCover => 'Update cover';

  @override
  String get removeCover => 'Remove cover';

  @override
  String get updateThumbnail => 'Update thumbnail';

  @override
  String get removeThumbnail => 'Remove thumbnail';

  @override
  String get moveUp => 'Move up';

  @override
  String get moveDown => 'Move down';

  @override
  String get moveTo => 'Move to...';

  @override
  String get imageMessagePlain => 'Image message';

  @override
  String get viewContext => 'View context';

  @override
  String get viewReports => 'View reports';

  @override
  String messageReports(String id) {
    return 'Reports for message #$id';
  }

  @override
  String get tapToViewContext => 'Tap to view context';

  @override
  String get viewReactionMembers => 'View reacting members';

  @override
  String get anonymous => 'Anonymous';

  @override
  String creatorOnlyMode(String mode) {
    return '$mode · Creator only';
  }

  @override
  String dynamicMediaSize(int size) {
    String _temp0 = intl.Intl.pluralLogic(
      size,
      locale: localeName,
      other: 'Dynamic media · $size bytes',
      zero: 'Dynamic media',
    );
    return '$_temp0';
  }

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String joinedAtValue(String value) {
    return 'Joined $value';
  }

  @override
  String get removeFromRoom => 'Remove from room';

  @override
  String get viewMemberReports => 'View member reports';

  @override
  String memberReports(String user) {
    return 'Member reports for $user';
  }

  @override
  String get moreMemberActions => 'More member actions';

  @override
  String get ownerAccount => 'Owner account';

  @override
  String get roomInformation => 'Room information';

  @override
  String get configured => 'Configured';

  @override
  String get notConfigured => 'Not configured';

  @override
  String get emptyRemovesRoomPassword =>
      'Submit an empty value to remove the room password';

  @override
  String get roomCurrentlyRequiresPassword =>
      'This room currently requires a password';

  @override
  String get roomCurrentlyNoPassword => 'This room currently has no password';

  @override
  String get roomActions => 'Room actions';

  @override
  String get leaveRoomTileDescription =>
      'You must join again to access member content after leaving';

  @override
  String get unspecified => 'Unspecified';

  @override
  String get unknownTime => 'Unknown time';

  @override
  String get waitingForEvent => 'Waiting for event';

  @override
  String get messageContent => 'Message content';

  @override
  String get systemManagement => 'System management';

  @override
  String get administrators => 'Administrators';

  @override
  String get categoriesAndLabels => 'Categories and labels';

  @override
  String get users => 'Users';

  @override
  String get bans => 'Bans';

  @override
  String loadOverviewFailed(String error) {
    return 'Could not load the overview: $error';
  }

  @override
  String get noStatistics => 'No statistics available';

  @override
  String get activeUsers => 'Active users';

  @override
  String get onlineMembersLabel => 'Online members';

  @override
  String get onlineGuestsLabel => 'Online guests';

  @override
  String get bannedUsers => 'Banned users';

  @override
  String get activeRooms => 'Active rooms';

  @override
  String get onlineRooms => 'Online rooms';

  @override
  String loadAdministratorsFailed(String error) {
    return 'Could not load administrators: $error';
  }

  @override
  String get addAdministrator => 'Add administrator';

  @override
  String get addAdministratorDescription =>
      'Create a new administrator or promote an existing user.';

  @override
  String get promoteExistingUser => 'Promote existing user';

  @override
  String get createAdministrator => 'Create administrator';

  @override
  String get usernameAndPasswordRequired => 'Enter a username and password';

  @override
  String get administratorAdded => 'Administrator added';

  @override
  String get existingUserIdRequired => 'Enter an existing user ID';

  @override
  String get promote => 'Promote';

  @override
  String get userIdRequired => 'Enter a user ID';

  @override
  String get removeAdministrator => 'Remove administrator';

  @override
  String get administratorRemoved => 'Administrator removed';

  @override
  String removeFailed(String error) {
    return 'Could not remove the administrator: $error';
  }

  @override
  String administratorCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count administrators',
      one: '1 administrator',
    );
    return '$_temp0';
  }

  @override
  String get searchAdministrators => 'Search administrators';

  @override
  String itemsPerPage(int count) {
    return '$count / page';
  }

  @override
  String get noAdministrators => 'No administrators';

  @override
  String pageOf(int page, int pageCount) {
    return 'Page $page of $pageCount';
  }

  @override
  String get cannotRemoveCurrentAdministrator =>
      'You cannot remove your own administrator access';

  @override
  String get keepAtLeastOneAdministrator =>
      'At least one administrator must remain';

  @override
  String get allStatuses => 'All statuses';

  @override
  String get allBanStates => 'All ban states';

  @override
  String get bannedOnly => 'Banned only';

  @override
  String get notBanned => 'Not banned';

  @override
  String get ban => 'Ban';

  @override
  String get unban => 'Unban';

  @override
  String roomAction(String action) {
    return '$action room';
  }

  @override
  String confirmRoomAction(String action, String roomName) {
    return '$action room \"$roomName\"?';
  }

  @override
  String permanentlyDeleteRoom(String roomName) {
    return 'Permanently delete room \"$roomName\".';
  }

  @override
  String get allMembersLoseAccess =>
      'All members will lose access to the room.';

  @override
  String get roomDataWillBeCleared =>
      'Room settings, media, and related data will be cleared.';

  @override
  String get watchingMembersWillExit =>
      'Connected viewers will be removed immediately.';

  @override
  String get batchBanRooms => 'Ban rooms';

  @override
  String roomsWillBeBanned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rooms will be banned.',
      one: '1 room will be banned.',
    );
    return '$_temp0';
  }

  @override
  String get batchBanCompleted => 'Room ban completed';

  @override
  String batchBanFailed(String error) {
    return 'Could not ban rooms: $error';
  }

  @override
  String get batchDeleteRooms => 'Delete rooms';

  @override
  String roomsWillBeDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rooms will be permanently deleted.',
      one: '1 room will be permanently deleted.',
    );
    return '$_temp0';
  }

  @override
  String get relatedMembersLoseAccess =>
      'Related members will lose access to these rooms.';

  @override
  String get batchDeleteBackupOnly =>
      'Deleted data can be restored only from a backup.';

  @override
  String get batchDeleteCompleted => 'Room deletion completed';

  @override
  String batchDeleteFailed(String error) {
    return 'Could not delete rooms: $error';
  }

  @override
  String batchResultSuccess(String title, int succeeded) {
    return '$title: $succeeded succeeded';
  }

  @override
  String batchResultMixed(String title, int succeeded, int failed) {
    return '$title: $succeeded succeeded, $failed failed';
  }

  @override
  String get memberCountLabel => 'Member count';

  @override
  String get creatorStatus => 'Creator status';

  @override
  String get resourceAvailability => 'Resource availability';

  @override
  String get passwordAction => 'Password action';

  @override
  String get keepUnchanged => 'Keep unchanged';

  @override
  String get setNewPassword => 'Set new password';

  @override
  String get clearPassword => 'Clear password';

  @override
  String get newPasswordRequired => 'Enter the new password';

  @override
  String roomReports(String roomName) {
    return 'Reports for $roomName';
  }

  @override
  String get reportRecords => 'Report records';

  @override
  String loadRoomDetailsFailed(String error) {
    return 'Could not load room details: $error';
  }

  @override
  String get categoriesLabelsSaved => 'Categories and labels saved';

  @override
  String saveCategoriesLabelsFailed(String error) {
    return 'Could not save categories and labels: $error';
  }

  @override
  String get searchMembers => 'Search members';

  @override
  String memberAdminSummary(int total, int online, int connections) {
    return '$total members · $online online · $connections connections';
  }

  @override
  String memberPageSummary(int total, int page, int pageCount) {
    return '$total members · Page $page of $pageCount';
  }

  @override
  String get toggleAdministrator => 'Toggle administrator role';

  @override
  String get notifyMember => 'Notify member';

  @override
  String get roomRole => 'Room role';

  @override
  String get roomSettingsReset => 'Room settings reset';

  @override
  String get roomSettingsSaved => 'Room settings saved';

  @override
  String saveRoomSettingsFailed(String error) {
    return 'Could not save room settings: $error';
  }

  @override
  String get selectCurrentPage => 'Select current page';

  @override
  String get selectRoom => 'Select room';

  @override
  String roomsSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rooms selected',
      one: '1 room selected',
    );
    return '$_temp0';
  }

  @override
  String get roomCategories => 'Room categories';

  @override
  String loadCategoriesLabelsFailed(String error) {
    return 'Could not load categories and labels: $error';
  }

  @override
  String get categoryNotBound => 'No category assigned';

  @override
  String get unknownCategory => 'Unknown category';

  @override
  String get addCategory => 'Add category';

  @override
  String get editCategory => 'Edit category';

  @override
  String get identifier => 'Identifier';

  @override
  String get categoryIdentifierExample => 'Example: movies';

  @override
  String get categoryNameExample => 'Example: Movies';

  @override
  String get lowerNumberFirst => 'Lower numbers appear first';

  @override
  String get enableCategory => 'Enable category';

  @override
  String get categoryIdAndNameRequired =>
      'Enter the category identifier and name';

  @override
  String get sortMustBeInteger => 'Sort order must be an integer';

  @override
  String get categorySaved => 'Category saved';

  @override
  String saveCategoryFailed(String error) {
    return 'Could not save the category: $error';
  }

  @override
  String get deleteCategory => 'Delete category';

  @override
  String permanentlyDeleteCategory(String category) {
    return 'Permanently delete category \"$category\".';
  }

  @override
  String get roomsLoseCategory =>
      'Rooms using this category will become uncategorized.';

  @override
  String get categoryChangesImmediate =>
      'The category change takes effect immediately.';

  @override
  String get categoryDeleted => 'Category deleted';

  @override
  String deleteCategoryFailed(String error) {
    return 'Could not delete the category: $error';
  }

  @override
  String get addLabel => 'Add label';

  @override
  String get editLabel => 'Edit label';

  @override
  String get labelIdentifierExample => 'Example: sci-fi';

  @override
  String get labelNameExample => 'Example: Science fiction';

  @override
  String get parentCategory => 'Parent category';

  @override
  String get noCategoryBinding => 'No category binding';

  @override
  String get color => 'Color';

  @override
  String get enableLabel => 'Enable label';

  @override
  String get labelIdAndNameRequired => 'Enter the label identifier and name';

  @override
  String get colorFormatExample => 'Use a hex color such as #5D5FEF';

  @override
  String get labelSaved => 'Label saved';

  @override
  String saveLabelFailed(String error) {
    return 'Could not save the label: $error';
  }

  @override
  String get deleteLabel => 'Delete label';

  @override
  String permanentlyDeleteLabel(String label) {
    return 'Permanently delete label \"$label\".';
  }

  @override
  String get roomsLoseLabel => 'Rooms using this label will lose the label.';

  @override
  String get labelChangesImmediate =>
      'The label change takes effect immediately.';

  @override
  String get labelDeleted => 'Label deleted';

  @override
  String deleteLabelFailed(String error) {
    return 'Could not delete the label: $error';
  }

  @override
  String get noCategories => 'No categories';

  @override
  String get addCategoriesDescription => 'Add a category to organize rooms.';

  @override
  String get addLabelsDescription =>
      'Add labels to help members discover rooms.';

  @override
  String get defaultColor => 'Default color';

  @override
  String loadUserDetailsFailed(String error) {
    return 'Could not load user details: $error';
  }

  @override
  String get reportsAgainstUser => 'Reports against user';

  @override
  String get reportsByUser => 'Reports submitted by user';

  @override
  String get bannedAt => 'Banned at';

  @override
  String get bannedBy => 'Banned by';

  @override
  String loadUserRoomsFailed(String error) {
    return 'Could not load the user\'s rooms: $error';
  }

  @override
  String get preferencesUpdated => 'Preferences updated';

  @override
  String savePreferencesFailed(String error) {
    return 'Could not save preferences: $error';
  }

  @override
  String authenticationFactorsSummary(
    int count,
    String passwordStatus,
    String emailStatus,
    String passkeyStatus,
  ) {
    return '$count available factors: password $passwordStatus, email $emailStatus, passkey $passkeyStatus';
  }

  @override
  String get roomInvitationInAppNotification =>
      'In-app room invitation notifications';

  @override
  String get roomEventInAppNotification => 'In-app room event notifications';

  @override
  String get systemAnnouncementInAppNotification =>
      'In-app system announcements';

  @override
  String get roomInvitationEmail => 'Room invitation emails';

  @override
  String get roomEventEmail => 'Room event emails';

  @override
  String get systemAnnouncementEmail => 'System announcement emails';

  @override
  String get searchUsers => 'Search users';

  @override
  String get selectUser => 'Select user';

  @override
  String userListSummary(
    String id,
    String role,
    String status,
    String connectionStatus,
  ) {
    return 'ID: $id · $role · $status · $connectionStatus';
  }

  @override
  String connectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count connections',
      one: '1 connection',
    );
    return '$_temp0';
  }

  @override
  String userReports(String username) {
    return 'Reports for $username';
  }

  @override
  String get rename => 'Rename';

  @override
  String get removeAdministratorRole => 'Remove administrator role';

  @override
  String get makeAdministrator => 'Make administrator';

  @override
  String get deleteUser => 'Delete user';

  @override
  String usersSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count users selected',
      one: '1 user selected',
    );
    return '$_temp0';
  }

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get optional => 'Optional';

  @override
  String get operationSucceeded => 'Operation completed';

  @override
  String get category => 'Category';

  @override
  String get requiresPassword => 'Requires password';

  @override
  String loadUsersFailed(String error) {
    return 'Could not load users: $error';
  }

  @override
  String get addUser => 'Add user';

  @override
  String get userCreated => 'User created';

  @override
  String createUserFailed(String error) {
    return 'Could not create the user: $error';
  }

  @override
  String get create => 'Create';

  @override
  String permanentlyDeleteUser(String username) {
    return 'Permanently delete user \"$username\".';
  }

  @override
  String get deleteUserClearsAccountData =>
      'The user\'s sessions, external bindings, and profile will be cleared.';

  @override
  String get deleteUserAffectsRelatedData =>
      'Room relationships, chat ownership, and permissions associated with the user will be affected.';

  @override
  String get deleteUserRevokesOnlineAccess =>
      'Online clients will lose access to this account immediately.';

  @override
  String get userDeleted => 'User deleted';

  @override
  String deleteUserFailed(String error) {
    return 'Could not delete the user: $error';
  }

  @override
  String get rootUserCannotBeDemoted => 'The Root user cannot be demoted here';

  @override
  String get changePermissions => 'Change permissions';

  @override
  String confirmUserRoleAction(String username, String action) {
    return '$action for user \"$username\"?';
  }

  @override
  String userAction(String action) {
    return '$action user';
  }

  @override
  String confirmUserAction(String action, String username) {
    return '$action user \"$username\"?';
  }

  @override
  String get batchBanUsers => 'Ban users';

  @override
  String usersWillBeBanned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count users will be banned.',
      one: '1 user will be banned.',
    );
    return '$_temp0';
  }

  @override
  String get batchDeleteUsers => 'Delete users';

  @override
  String usersWillBeDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count users will be permanently deleted.',
      one: '1 user will be permanently deleted.',
    );
    return '$_temp0';
  }

  @override
  String get batchDeleteUsersClearsAccountData =>
      'The selected users\' sessions, external bindings, and profiles will be cleared.';

  @override
  String get batchDeleteUsersAffectsRelatedData =>
      'Room relationships, chat ownership, and permissions associated with these users will be affected.';

  @override
  String get preferences => 'Preferences';

  @override
  String get newUsername => 'New username';

  @override
  String get usernameLengthHint => '3-50 characters';

  @override
  String changeUsernameFailed(String error) {
    return 'Could not change the username: $error';
  }

  @override
  String passwordMinimumLength(int count) {
    return 'At least $count characters';
  }

  @override
  String get auditReason => 'Audit reason';

  @override
  String loadReviewsFailed(String error) {
    return 'Could not load reviews: $error';
  }

  @override
  String get reviewApproved => 'Review approved';

  @override
  String get rejectReview => 'Reject review';

  @override
  String get rejectionReasonHint => 'Enter the rejection reason';

  @override
  String get reviewRejected => 'Review rejected';

  @override
  String get registration => 'Registration';

  @override
  String get roomCreation => 'Room creation';

  @override
  String get roomDefaults => 'Room defaults';

  @override
  String get joinRequest => 'Join request';

  @override
  String get searchReviewHint => 'Search or enter a room_/usr_ ID';

  @override
  String get noReviewRecords => 'No review records';

  @override
  String reviewedBy(String reviewer) {
    return 'Reviewed by $reviewer';
  }

  @override
  String reviewedAt(String time) {
    return 'Reviewed $time';
  }

  @override
  String get roomPasswordOptionalDescription =>
      'Room creators can choose whether to set a password.';

  @override
  String get roomPasswordRequiredDescription =>
      'Every new room must have a password.';

  @override
  String get roomPasswordDisabledDescription =>
      'New rooms cannot use passwords.';

  @override
  String get required => 'Required';

  @override
  String get cors => 'CORS';

  @override
  String get permissions => 'Permissions';

  @override
  String get sendChat => 'Send chat messages';

  @override
  String get browseLibrary => 'Browse library';

  @override
  String get viewMembers => 'View members';

  @override
  String get useWebRtc => 'Use WebRTC';

  @override
  String get deleteMedia => 'Delete media';

  @override
  String get reorderPlaylist => 'Reorder playlist';

  @override
  String get liveControl => 'Live stream control';

  @override
  String get playbackControl => 'Playback control';

  @override
  String get roomPermissionNavigatePlayback => 'Navigate playback';

  @override
  String get previousVideo => 'Previous video';

  @override
  String get nextVideo => 'Next video';

  @override
  String get playbackHistory => 'Playback history';

  @override
  String get playbackHistoryEmpty => 'No playback history';

  @override
  String get playHistoryEntry => 'Play this entry';

  @override
  String get newestFirst => 'Newest first';

  @override
  String get oldestFirst => 'Oldest first';

  @override
  String get deletePlaybackHistoryEntryTitle => 'Delete history entry';

  @override
  String get deletePlaybackHistoryEntryConfirm =>
      'Delete this entry from the room playback history?';

  @override
  String get deleteCurrentPlaybackHistoryEntryConfirm =>
      'Delete the current entry from the room playback history? Playback will continue, and previous/next history navigation will reset.';

  @override
  String get clearPlaybackHistoryTitle => 'Clear playback history';

  @override
  String get clearPlaybackHistoryConfirm =>
      'Delete all playback history for this room? Current playback will continue, and this action cannot be undone.';

  @override
  String get viewPlaybackHistory => 'View playback history';

  @override
  String get playbackHistoryRetentionDays => 'Playback history retention';

  @override
  String get playbackHistoryRetentionDaysDescription =>
      'Days to retain playback history. Use 0 to disable age-based cleanup.';

  @override
  String get playbackHistoryMaxEntries => 'Playback history limit';

  @override
  String get playbackHistoryMaxEntriesDescription =>
      'Maximum entries retained per room. Use 0 to disable count-based cleanup.';

  @override
  String get changePlaybackRate => 'Change playback rate';

  @override
  String get approveMember => 'Approve members';

  @override
  String get setMemberPermissions => 'Set member permissions';

  @override
  String get changeRoomSettings => 'Change room settings';

  @override
  String get deleteChat => 'Delete chat messages';

  @override
  String get roomPermissionManageOwnMedia => 'Manage own media';

  @override
  String get roomPermissionReorderMedia => 'Reorder media and playlists';

  @override
  String get roomPermissionClearMedia => 'Clear media queue';

  @override
  String get roomPermissionManageLiveStreams => 'Manage live streams';

  @override
  String get roomPermissionReviewJoinRequests => 'Review join requests';

  @override
  String get roomPermissionRemoveMembers => 'Remove members';

  @override
  String get roomPermissionManageMemberPermissions =>
      'Manage member permissions';

  @override
  String get roomPermissionAddMembers => 'Add members';

  @override
  String get roomPermissionManageRoomSettings => 'Manage room settings';

  @override
  String get roomPermissionDeleteChatMessages => 'Delete chat messages';

  @override
  String get defaultRoomMemberLimit => 'Default room member limit';

  @override
  String get defaultRoomMemberLimitDescription =>
      'The default member limit for new rooms.';

  @override
  String get roomChatSnapshotLimit => 'Room chat snapshot limit';

  @override
  String get roomChatSnapshotLimitDescription =>
      'Maximum chat messages retained and sent to clients for new rooms. Zero means unlimited.';

  @override
  String get allowRoomCreation => 'Allow room creation';

  @override
  String get allowRoomCreationDescription =>
      'Allow regular users to create rooms.';

  @override
  String get roomCreationRequiresReview => 'Room creation requires review';

  @override
  String get roomCreationRequiresReviewDescription =>
      'New rooms enter the review workflow and become available after approval.';

  @override
  String get roomPasswordPolicy => 'Room password policy';

  @override
  String get roomPasswordPolicyDescription =>
      'Define whether new rooms may, must, or cannot use passwords.';

  @override
  String get maximumRoomsPerUser => 'Maximum rooms per user';

  @override
  String get maximumRoomsPerUserDescription =>
      'Limit how many rooms each user can own.';

  @override
  String get allowPasswordSignup => 'Allow password signup';

  @override
  String get allowPasswordSignupDescription =>
      'Users can register with a username and password.';

  @override
  String get passwordSignupRequiresReview => 'Password signup requires review';

  @override
  String get passwordSignupRequiresReviewDescription =>
      'New password accounts require administrator approval.';

  @override
  String get allowEmailSignup => 'Allow email signup';

  @override
  String get allowEmailSignupDescription =>
      'Users can register with an email verification code.';

  @override
  String get emailSignupRequiresReview => 'Email signup requires review';

  @override
  String get emailSignupRequiresReviewDescription =>
      'New email accounts require administrator approval.';

  @override
  String get allowPasskeySignup => 'Allow passkey signup';

  @override
  String get allowPasskeySignupDescription =>
      'Users can create accounts using a platform passkey.';

  @override
  String get passkeySignupRequiresReview => 'Passkey signup requires review';

  @override
  String get passkeySignupRequiresReviewDescription =>
      'New passkey accounts require administrator approval.';

  @override
  String get allowGuests => 'Allow guests';

  @override
  String get allowGuestsDescription =>
      'Signed-out users can enter rooms that allow guests.';

  @override
  String get allowGuestsWarning =>
      'Guest access lowers the room access threshold. Verify public room and default permission settings.';

  @override
  String get externalLogin => 'External login';

  @override
  String get externalLoginDescription =>
      'Manage OAuth2/OIDC login providers, signup policies, and callback settings.';

  @override
  String get externalLoginWarning =>
      'OAuth2 settings affect login entry points. Invalid callbacks, secrets, or endpoints prevent external login.';

  @override
  String get rtmpPublishAddress => 'RTMP publish address';

  @override
  String get rtmpPublishAddressDescription =>
      'Override the public RTMP publish host. Leave empty to use the server default.';

  @override
  String get tsSegmentsAsPng => 'Expose TS segments as PNG';

  @override
  String get tsSegmentsAsPngDescription =>
      'Expose HLS TS segments with PNG extensions for network compatibility.';

  @override
  String get enableEmailService => 'Enable email service';

  @override
  String get enableEmailServiceDescription =>
      'Allow the server to send email binding, password reset, MFA, and notification messages.';

  @override
  String get enableEmailServiceWarning =>
      'Verify the SMTP host, sender address, and credentials before enabling email features.';

  @override
  String get smtpHost => 'SMTP host';

  @override
  String get smtpHostDescription =>
      'Mail server address required when email delivery is enabled.';

  @override
  String get smtpPort => 'SMTP port';

  @override
  String get smtpPortDescription => 'Common ports are 587, 465, and 25.';

  @override
  String get smtpAuthentication => 'SMTP authentication';

  @override
  String get smtpAuthenticationDescription =>
      'Configure an SMTP username and password when the server requires authentication.';

  @override
  String get smtpAuthenticationWarning =>
      'SMTP passwords are sensitive credentials. Verify the environment and administrator account before saving.';

  @override
  String get smtpProxy => 'SMTP proxy';

  @override
  String get smtpProxyDescription =>
      'Configure an optional SOCKS5 proxy and proxy credentials.';

  @override
  String get smtpProxyWarning =>
      'Email traffic and the SMTP destination pass through this proxy. Use a trusted proxy.';

  @override
  String get useTls => 'Use TLS';

  @override
  String get useTlsDescription => 'Enable SMTP TLS/STARTTLS.';

  @override
  String get useTlsWarning =>
      'Disabling TLS can expose mail credentials in plaintext. Use this only in controlled networks or development.';

  @override
  String get senderEmail => 'Sender email';

  @override
  String get senderEmailDescription =>
      'Valid From address required when email delivery is enabled.';

  @override
  String get senderDisplayName => 'Sender display name';

  @override
  String get senderDisplayNameDescription =>
      'Name shown to recipients for delivered email.';

  @override
  String get enableEmailWhitelist => 'Enable email whitelist';

  @override
  String get enableEmailWhitelistDescription =>
      'Restrict email signup to listed addresses and domains.';

  @override
  String get emailWhitelist => 'Email whitelist';

  @override
  String get emailWhitelistDescription =>
      'Enter one email address or domain per line. Domains may use example.com or @example.com.';

  @override
  String get externalIceServers => 'External ICE servers';

  @override
  String get externalIceServersDescription =>
      'STUN/TURN servers sent to clients.';

  @override
  String get externalIceServersWarning =>
      'TURN usernames and credentials are sent to clients. Use limited, renewable credentials.';

  @override
  String get maxVoiceParticipantsPerRoom => 'Voice participants per room';

  @override
  String get maxVoiceParticipantsPerRoomDescription =>
      'Maximum simultaneous voice participants in one room. Mesh voice supports 2 to 32; 8 is recommended for mobile clients.';

  @override
  String get chatMessagesPerRoom => 'Chat messages retained per room';

  @override
  String get chatMessagesPerRoomDescription =>
      'Maximum retained chat messages per room. Zero means unlimited.';

  @override
  String get chatRetentionDays => 'Chat retention days';

  @override
  String get chatRetentionDaysDescription =>
      'Maximum time chat messages are retained.';

  @override
  String get allowedCorsOrigins => 'Allowed CORS origins';

  @override
  String get allowedCorsOriginsDescription =>
      'Web origins allowed to access proxy endpoints. Native clients usually need no entries.';

  @override
  String get allowedCorsOriginsWarning =>
      'Broad CORS settings expand browser access. Add only explicit trusted HTTPS origins.';

  @override
  String get adminDefaultPermissions => 'Administrator default permissions';

  @override
  String get adminDefaultPermissionsDescription =>
      'Default permission set for room administrators.';

  @override
  String get memberDefaultPermissions => 'Member default permissions';

  @override
  String get memberDefaultPermissionsDescription =>
      'Default permission set for regular room members.';

  @override
  String get guestDefaultPermissions => 'Guest default permissions';

  @override
  String get guestDefaultPermissionsDescription =>
      'Default server-supported permission set for guests.';

  @override
  String get guestDefaultPermissionsWarning =>
      'Guest permissions apply to signed-out users. Grant only viewing and low-risk actions.';

  @override
  String runtimeSectionDescription(String section) {
    return 'Runtime settings for $section.';
  }

  @override
  String get noExternalLoginConfigured => 'No external login configured';

  @override
  String oauthProviderSummary(int total, int configured) {
    return '$total providers, $configured with a Client ID';
  }

  @override
  String get noIceServersConfigured => 'No ICE servers configured';

  @override
  String iceServerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ICE servers',
      one: '1 ICE server',
    );
    return '$_temp0';
  }

  @override
  String get authenticationDisabled => 'Authentication disabled';

  @override
  String configuredUser(String username) {
    return 'Configured user $username';
  }

  @override
  String get directConnection => 'Direct connection';

  @override
  String get emptyList => 'Empty list';

  @override
  String get noPermissions => 'No permissions';

  @override
  String get emptyObject => 'Empty object';

  @override
  String configurationCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count settings',
      one: '1 setting',
    );
    return '$_temp0';
  }

  @override
  String configurableSettingsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count configurable settings',
      one: '1 configurable setting',
    );
    return '$_temp0';
  }

  @override
  String get refreshCurrentSection => 'Refresh current section';

  @override
  String refreshSettingsFailed(String error) {
    return 'Could not refresh settings: $error';
  }

  @override
  String updateSettingsFailed(String error) {
    return 'Could not update settings: $error';
  }

  @override
  String get deleteLoginProvider => 'Delete login provider';

  @override
  String confirmDeleteLoginProvider(String name) {
    return 'Delete OAuth2 login provider \"$name\"? Users will lose access to this login entry point.';
  }

  @override
  String get confirmChanges => 'Confirm changes';

  @override
  String get sendTestEmail => 'Send test email';

  @override
  String get recipient => 'Recipient';

  @override
  String get testEmailSent => 'Test email sent';

  @override
  String sendTestEmailFailed(String error) {
    return 'Could not send the test email: $error';
  }

  @override
  String get noSettings => 'No settings';

  @override
  String get addLoginProvider => 'Add login provider';

  @override
  String get runtimeSettings => 'Runtime settings';

  @override
  String get refreshAll => 'Refresh all';

  @override
  String get content => 'Content';

  @override
  String enterSettingValue(String setting) {
    return 'Enter $setting';
  }

  @override
  String get enableSmtpAuthentication => 'Enable SMTP authentication';

  @override
  String get enableSmtpAuthenticationDescription =>
      'Configure a username and password when the server requires login.';

  @override
  String get smtpUsernameRequired => 'Enter the SMTP username';

  @override
  String get emptyKeepsCurrentPassword =>
      'Leave empty to keep the current password';

  @override
  String get passwordRequiredForNewCredentials =>
      'Enter a password for new credentials or a changed username';

  @override
  String get enableSmtpProxy => 'Enable SMTP proxy';

  @override
  String get enableSmtpProxyDescription =>
      'Connect to the mail server through a SOCKS5 proxy.';

  @override
  String get socks5ProxyAddress => 'SOCKS5 proxy address';

  @override
  String get socks5ProxyAddressRequired =>
      'Enter an address beginning with socks5://';

  @override
  String get proxyRequiresAuthentication => 'Proxy requires authentication';

  @override
  String get proxyAuthenticationDescription =>
      'Configure a SOCKS5 username and password.';

  @override
  String get proxyUsername => 'Proxy username';

  @override
  String get proxyUsernameRequired => 'Enter the proxy username';

  @override
  String get proxyPassword => 'Proxy password';

  @override
  String get providerTypes => 'Provider types';

  @override
  String get noProviderTypes => 'No provider types available';

  @override
  String get selectAtLeastOneProviderType =>
      'Select at least one provider type';

  @override
  String loadProviderInstancesFailed(String error) {
    return 'Could not load provider instances: $error';
  }

  @override
  String get providerInstanceUpdated => 'Provider instance updated';

  @override
  String get providerInstanceCreated => 'Provider instance created';

  @override
  String saveProviderInstanceFailed(String error) {
    return 'Could not save the provider instance: $error';
  }

  @override
  String get deleteProvider => 'Delete provider';

  @override
  String confirmDeleteProvider(String name) {
    return 'Delete $name?';
  }

  @override
  String get providerInstanceDeleted => 'Provider instance deleted';

  @override
  String deleteProviderFailed(String error) {
    return 'Could not delete the provider: $error';
  }

  @override
  String get reconnectStarted => 'Reconnect started';

  @override
  String reconnectFailed(String error) {
    return 'Could not reconnect: $error';
  }

  @override
  String get searchProviderInstances => 'Search name or endpoint';

  @override
  String get allTlsStates => 'All TLS states';

  @override
  String get tlsEnabled => 'TLS enabled';

  @override
  String get tlsDisabled => 'TLS disabled';

  @override
  String get sortByName => 'By name';

  @override
  String get sortByEndpoint => 'By endpoint';

  @override
  String get sortByCreatedAt => 'By creation time';

  @override
  String get sortByUpdatedAt => 'By update time';

  @override
  String get noProviderInstances => 'No provider instances';

  @override
  String get noAvailableBackends => 'No backends available for this type';

  @override
  String get backendCopied => 'Backend copied';

  @override
  String get refreshBackends => 'Refresh backends';

  @override
  String get tlsUnverified => 'TLS unverified';

  @override
  String get tlsVerified => 'TLS verified';

  @override
  String providerInstanceTimes(String createdAt, String updatedAt) {
    return 'Created $createdAt · Updated $updatedAt';
  }

  @override
  String get enableProviderInstance => 'Enable provider instance';

  @override
  String get reconnect => 'Reconnect';

  @override
  String get editProviderInstance => 'Edit provider instance';

  @override
  String get addProviderInstance => 'Add provider instance';

  @override
  String get configureProviderNode =>
      'Configure an external media provider node';

  @override
  String get instanceName => 'Instance name';

  @override
  String get instanceNameRequired => 'Enter an instance name';

  @override
  String get endpointRequired => 'Enter an endpoint';

  @override
  String get requestTimeout => 'Request timeout';

  @override
  String get secondsShort => 'sec';

  @override
  String get positiveIntegerRequired => 'Enter an integer greater than zero';

  @override
  String get capabilityTypes => 'Capability types';

  @override
  String get capabilityTypesDescription =>
      'One instance can provide several provider types.';

  @override
  String get connectionSecurity => 'Connection security';

  @override
  String get connectionSecurityDescription =>
      'Use insecure TLS only in controlled private networks or test environments.';

  @override
  String get enableTls => 'Enable TLS';

  @override
  String get providerTlsConnection => 'Connect to the provider with HTTPS/TLS';

  @override
  String get providerPlainConnection => 'Connect without TLS';

  @override
  String get allowInsecureTls => 'Allow insecure TLS';

  @override
  String get allowInsecureTlsDescription =>
      'Skip certificate validation, which permits interception attacks.';

  @override
  String get emptyKeepsCurrentValue => 'Leave empty to keep the current value';

  @override
  String get clearJwtSecret => 'Clear JWT Secret';

  @override
  String get pemEmptyKeepsCurrent =>
      'PEM content; leave empty to keep the current value';

  @override
  String get pemOptional => 'Optional PEM content';

  @override
  String get clearCustomCa => 'Clear Custom CA';

  @override
  String get notes => 'Notes';

  @override
  String get providerNotesHint =>
      'Optional deployment location, purpose, or maintenance notes';

  @override
  String get clearNotes => 'Clear notes';

  @override
  String get providerEditFooterHint =>
      'Only entered or explicitly cleared sensitive fields will be submitted';

  @override
  String get providerCreateFooterHint =>
      'After creation, the instance can be enabled, reconnected, or edited from the list';

  @override
  String get searchStreamsHint => 'Search or enter a room_/usr_/node_ ID';

  @override
  String get startedAt => 'Start time';

  @override
  String get node => 'Node';

  @override
  String loadBanRecordsFailed(String error) {
    return 'Could not load ban records: $error';
  }

  @override
  String get banRecordMissingTargetId =>
      'The ban record has no target ID and cannot be revoked';

  @override
  String get unbanUser => 'Unban user';

  @override
  String get unbanRoom => 'Unban room';

  @override
  String confirmUnban(String target) {
    return 'Remove the ban for \"$target\"?';
  }

  @override
  String get unbanned => 'Ban removed';

  @override
  String unbanFailed(String error) {
    return 'Could not remove the ban: $error';
  }

  @override
  String get allTargets => 'All targets';

  @override
  String get revokedOrExpired => 'Revoked or expired';

  @override
  String get userOrRoomIdHint => 'Enter a usr_/room_ ID';

  @override
  String get noBanRecords => 'No ban records';

  @override
  String banRecordSummary(String reason, String operator, String time) {
    return '$reason\nOperator: $operator · $time';
  }

  @override
  String get noReason => 'No reason';

  @override
  String get ended => 'Ended';

  @override
  String loadReportsFailed(String error) {
    return 'Could not load report records: $error';
  }

  @override
  String get reportDetails => 'Report details';

  @override
  String get target => 'Target';

  @override
  String get reporter => 'Reporter';

  @override
  String get reviewedByLabel => 'Reviewed by';

  @override
  String get reviewedAtLabel => 'Reviewed at';

  @override
  String get resolutionNote => 'Resolution note';

  @override
  String get resolve => 'Resolve';

  @override
  String get resolveReport => 'Resolve report';

  @override
  String get reviewing => 'Reviewing';

  @override
  String get resolved => 'Resolved';

  @override
  String get dismissed => 'Dismissed';

  @override
  String get reportOpenStatus => 'Pending';

  @override
  String resolveReportFailed(String error) {
    return 'Could not resolve the report: $error';
  }

  @override
  String get reportStatusUpdated => 'Report status updated';

  @override
  String get messages => 'Messages';

  @override
  String get searchReportsHint => 'Search reasons, targets, or usr_/room_ IDs';

  @override
  String get noReportRecords => 'No report records';

  @override
  String reportListSummary(String reason, String reporter, String time) {
    return '$reason\nReporter: $reporter · $time';
  }

  @override
  String reporterFilter(String id) {
    return 'Reporter $id';
  }

  @override
  String contextRoomFilter(String id) {
    return 'Context room $id';
  }

  @override
  String reportedRoomFilter(String id) {
    return 'Reported room $id';
  }

  @override
  String reportedUserFilter(String id) {
    return 'Reported user $id';
  }

  @override
  String memberRoomFilter(String id) {
    return 'Member room $id';
  }

  @override
  String reportedMemberFilter(String id) {
    return 'Reported member $id';
  }

  @override
  String messageFilter(int id) {
    return 'Message #$id';
  }

  @override
  String roomTarget(String target) {
    return 'Room $target';
  }

  @override
  String userTarget(String target) {
    return 'User $target';
  }

  @override
  String memberTarget(String user, String room) {
    return 'Member $user · $room';
  }

  @override
  String chatMessageTarget(int id, String room) {
    return 'Chat message #$id · $room';
  }

  @override
  String unknownTarget(String id) {
    return 'Unknown target $id';
  }

  @override
  String get entry => 'Entry';

  @override
  String get enterEntry => 'Enter an entry';

  @override
  String get valueRequired => 'Enter a value';

  @override
  String get validNumberRequired => 'Enter a valid number';

  @override
  String get noLoginProviders => 'No external login providers';

  @override
  String get noLoginProvidersDescription =>
      'Add a GitHub, Google, Logto, or generic OIDC provider to show it on the login screen.';

  @override
  String get addLoginProviderHint =>
      'Use the add button to create a GitHub, Google, Logto, or generic OIDC login entry.';

  @override
  String loginProviderSummary(String providerType, String clientStatus) {
    return '$providerType · $clientStatus';
  }

  @override
  String get clientConfigured => 'Client configured';

  @override
  String get clientIdMissing => 'Client ID missing';

  @override
  String get signupAllowed => 'Signup allowed';

  @override
  String get loginBindingOnly => 'Login and binding only';

  @override
  String get signupRequiresReview => 'Signup requires review';

  @override
  String get addExternalLogin => 'Add external login';

  @override
  String get editExternalLogin => 'Edit external login';

  @override
  String get externalLoginEditorDescription =>
      'Configure an OAuth2/OIDC login provider, callback URL, and signup policy.';

  @override
  String get instanceNameFormatHint =>
      'Use letters, numbers, underscores, and hyphens only';

  @override
  String get providerType => 'Provider type';

  @override
  String get clientSecretRequired => 'Enter the Client Secret';

  @override
  String get callbackUrl => 'Callback URL';

  @override
  String get authorizationEndpoint => 'Authorization endpoint';

  @override
  String get emptyUsesOidcDiscovery => 'Leave empty to use OIDC Discovery';

  @override
  String get tokenEndpoint => 'Token endpoint';

  @override
  String get userInfoEndpoint => 'UserInfo endpoint';

  @override
  String get jwksEndpoint => 'JWKS endpoint';

  @override
  String get allowProviderSignup => 'Allow signup with this provider';

  @override
  String get allowProviderSignupDescription =>
      'When disabled, only users who already linked this provider can log in.';

  @override
  String get saveInstance => 'Save instance';

  @override
  String fieldRequired(String field) {
    return 'Enter $field';
  }

  @override
  String instanceNameTooLong(int maxLength) {
    return 'Instance names can contain up to $maxLength characters';
  }

  @override
  String get instanceNameExists => 'An instance with this name already exists';

  @override
  String get urlRequired => 'Enter a URL';

  @override
  String get validUrlRequired => 'Enter a valid URL';

  @override
  String get httpUrlRequired => 'Use an http or https URL';

  @override
  String get noIceServersDescription =>
      'Add a STUN or TURN server to make clients prefer this connection configuration.';

  @override
  String get addIceServer => 'Add ICE server';

  @override
  String iceServerNumber(int number) {
    return 'ICE server $number';
  }

  @override
  String get iceServerUrlsHint =>
      'One per line, such as stun:host:3478 or turns:host:5349';

  @override
  String get atLeastOneUrlRequired => 'Enter at least one URL';

  @override
  String get iceServerUrlSchemeRequired => 'Use a stun:, turn:, or turns: URL';

  @override
  String get credential => 'Credential';

  @override
  String pageSizeSummary(int page, int pageSize) {
    return 'Page $page · $pageSize per page';
  }

  @override
  String pageSizeTotalSummary(int page, int pageSize, int total) {
    return 'Page $page · $pageSize per page · $total total';
  }

  @override
  String get messageHasNoCopyableContent =>
      'This message has no content to copy';

  @override
  String confirmDeleteUserMessage(String username) {
    return 'Delete this message from $username?';
  }

  @override
  String messagesLoaded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count messages loaded',
      one: '1 message loaded',
    );
    return '$_temp0';
  }

  @override
  String get olderMessagesAvailable => 'Older messages available';

  @override
  String get loading => 'Loading';

  @override
  String get loadOlderMessages => 'Load older messages';

  @override
  String get noChatMessages => 'No chat messages';

  @override
  String get deletedUser => 'Deleted user';

  @override
  String messageAuthorTime(String author, String time) {
    return '$author · $time';
  }

  @override
  String get messageDeletedContent => 'This message was deleted';

  @override
  String get context => 'Context';

  @override
  String imageCount(int count) {
    return '[Images: $count]';
  }

  @override
  String get creatorUnavailable => 'Creator unavailable';

  @override
  String pageNumber(int page) {
    return 'Page $page';
  }

  @override
  String pageTotalSummary(int page, int total) {
    return 'Page $page · $total total';
  }

  @override
  String get switchControl => 'Switch';

  @override
  String get selectOption => 'Select an option';

  @override
  String get inviteLinkCopied => 'Invite link copied';

  @override
  String get playbackAuthenticationRequired =>
      'The media site requires authentication. Check that the link is publicly accessible or add the media again with valid credentials.';

  @override
  String get playbackAccessForbidden =>
      'The media site denied access to this video. Check the link permissions, origin restrictions, and direct-link headers.';

  @override
  String get playbackNotFound =>
      'The video address does not exist or has expired. Check the link and add it again.';

  @override
  String get playbackRateLimited =>
      'The media site is receiving too many requests. Try again later or use another accessible resource.';

  @override
  String get playbackFormatUnsupported =>
      'This device cannot play the video format. Use a common format such as MP4 or HLS.';

  @override
  String get playbackConnectionFailed =>
      'Could not connect to the video. Check the network, proxy settings, and media site availability.';

  @override
  String get playbackLoadFailed =>
      'Could not load the video. Confirm that the link is publicly accessible and the format is supported on this device.';

  @override
  String get image => 'Image';

  @override
  String get enterAuthenticatorCode => 'Enter the 6-digit authenticator code';

  @override
  String get enterRecoveryCode => 'Enter a recovery code';

  @override
  String get authenticatorCode => 'Authenticator code';

  @override
  String get verifyWithAuthenticator => 'Verify with authenticator';

  @override
  String get verifyWithEmail => 'Verify with email';

  @override
  String get recoveryCode => 'Recovery code';

  @override
  String get useRecoveryCode => 'Use a recovery code';

  @override
  String get backToVerificationMethods => 'Back to verification methods';

  @override
  String get verifyWithRecoveryCode => 'Verify with recovery code';

  @override
  String get authenticatorApp => 'Authenticator app';

  @override
  String setupAuthenticatorFailed(String error) {
    return 'Could not set up the authenticator app: $error';
  }

  @override
  String regenerateRecoveryCodesFailed(String error) {
    return 'Could not generate new recovery codes: $error';
  }

  @override
  String get removeAuthenticatorApp => 'Remove authenticator app';

  @override
  String get removeAuthenticatorAppConfirmation =>
      'Remove the authenticator app and all of its recovery codes?';

  @override
  String get authenticatorAppRemoved => 'Authenticator app removed';

  @override
  String removeAuthenticatorFailed(String error) {
    return 'Could not remove the authenticator app: $error';
  }

  @override
  String get authenticatorAppDescription =>
      'Use time-based codes from a standard authenticator app for multi-factor verification';

  @override
  String get authenticatorAppConfigured => 'Configured';

  @override
  String get authenticatorAppNotConfigured => 'Not configured';

  @override
  String recoveryCodesRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recovery codes remaining',
      one: '1 recovery code remaining',
    );
    return '$_temp0';
  }

  @override
  String get authenticatorAppSetupHint =>
      'Add an authenticator app to strengthen account security';

  @override
  String get recoveryCodes => 'Recovery codes';

  @override
  String get setup => 'Set up';

  @override
  String get setupAuthenticatorApp => 'Set up authenticator app';

  @override
  String get setupAuthenticatorAppDescription =>
      'Scan the QR code with a standard authenticator app, or enter the setup key manually.';

  @override
  String get manualSetupKey => 'Manual setup key';

  @override
  String get confirmSetup => 'Confirm setup';

  @override
  String get saveRecoveryCodes => 'Save recovery codes';

  @override
  String get recoveryCodesShownOnce =>
      'Each code works once. Store these codes securely; they are shown only on this screen.';

  @override
  String get copyAll => 'Copy all';

  @override
  String get savedRecoveryCodes => 'I saved the codes';

  @override
  String get sliceCache => 'Slice cache';

  @override
  String get nodeId => 'Node ID';

  @override
  String get currentNode => 'Current node';

  @override
  String get allNodes => 'All nodes';

  @override
  String loadSliceCacheFailed(String error) {
    return 'Could not load slice cache statistics: $error';
  }

  @override
  String get nodeUnavailable => 'Node unavailable';

  @override
  String get noSliceCacheStats => 'No slice cache statistics are available';

  @override
  String get evictExpiredSliceCache => 'Evict expired';

  @override
  String get purgeSliceCache => 'Purge cache';

  @override
  String get confirmPurgeSliceCache =>
      'Purge every cached slice for the selected target? Active playback may need to fetch media data again.';

  @override
  String sliceCacheEvictionCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count expired cache entries',
      one: '1 expired cache entry',
    );
    return 'Removed $_temp0';
  }

  @override
  String sliceCachePurgeCompleted(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cache entries',
      one: '1 cache entry',
    );
    return 'Removed $_temp0 and freed $size';
  }

  @override
  String get sliceCacheNodeOperationFailed =>
      'The cache operation failed on this node';

  @override
  String get sliceCacheUsage => 'Usage';

  @override
  String get sliceCacheSize => 'Stored data';

  @override
  String get sliceCacheEntries => 'Entries';

  @override
  String get sliceCacheUpdating => 'Updating';

  @override
  String get sliceCacheLocks => 'Locks';

  @override
  String get sliceCacheBackend => 'Backend';

  @override
  String get sliceCacheDirectory => 'Directory';

  @override
  String get sliceCacheCapacity => 'Capacity';

  @override
  String get sliceCacheSliceSize => 'Slice size';

  @override
  String get sliceCacheSegmentTtl => 'Segment TTL';

  @override
  String get sliceCacheStaleMaxAge => 'Stale max age';

  @override
  String get sliceCacheEvictionInterval => 'Eviction interval';

  @override
  String get staleWhileRevalidate => 'Stale while revalidate';

  @override
  String get privacy => 'Privacy';

  @override
  String get blockedUsers => 'Blocked users';

  @override
  String get blockedUsersDescription =>
      'Messages from these users are hidden, and rooms they create are excluded from Home discovery.';

  @override
  String get blockUser => 'Block user';

  @override
  String get unblockUser => 'Unblock user';

  @override
  String confirmBlockUser(String name) {
    return 'Block $name? Their messages will disappear and their rooms will be hidden from Home discovery. Existing room memberships remain available.';
  }

  @override
  String confirmUnblockUser(String name) {
    return 'Unblock $name? Their messages and rooms will become visible again.';
  }

  @override
  String get userBlocked => 'User blocked';

  @override
  String get userUnblocked => 'User unblocked';

  @override
  String blockUserFailed(String error) {
    return 'Could not block user: $error';
  }

  @override
  String unblockUserFailed(String error) {
    return 'Could not unblock user: $error';
  }

  @override
  String get noBlockedUsers => 'No blocked users';

  @override
  String get searchBlockedUsers => 'Search blocked users';

  @override
  String blockedAt(String time) {
    return 'Blocked $time';
  }

  @override
  String get blockedCreator => 'Blocked creator';

  @override
  String get blockedUsersTemporarilyUnavailable =>
      'Blocked users are temporarily unavailable';
}
