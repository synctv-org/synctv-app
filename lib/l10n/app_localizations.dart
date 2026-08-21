import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SyncTV'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Together, wherever you are'**
  String get appTagline;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Display language'**
  String get languageSettingsTitle;

  /// No description provided for @languageSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the language used by SyncTV.'**
  String get languageSettingsDescription;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get languageSystem;

  /// No description provided for @languageChineseSimplified.
  ///
  /// In en, this message translates to:
  /// **'Simplified Chinese'**
  String get languageChineseSimplified;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @serverSettings.
  ///
  /// In en, this message translates to:
  /// **'Server settings'**
  String get serverSettings;

  /// No description provided for @openServerSettings.
  ///
  /// In en, this message translates to:
  /// **'Open server settings'**
  String get openServerSettings;

  /// No description provided for @joinRoom.
  ///
  /// In en, this message translates to:
  /// **'Join room'**
  String get joinRoom;

  /// No description provided for @createRoom.
  ///
  /// In en, this message translates to:
  /// **'Create room'**
  String get createRoom;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @accountMenu.
  ///
  /// In en, this message translates to:
  /// **'Account menu'**
  String get accountMenu;

  /// No description provided for @accountCenter.
  ///
  /// In en, this message translates to:
  /// **'Account center'**
  String get accountCenter;

  /// No description provided for @adminSettings.
  ///
  /// In en, this message translates to:
  /// **'Admin settings'**
  String get adminSettings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @capsLockOn.
  ///
  /// In en, this message translates to:
  /// **'Caps Lock is on'**
  String get capsLockOn;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @builtInLabel.
  ///
  /// In en, this message translates to:
  /// **'Built-in'**
  String get builtInLabel;

  /// No description provided for @switchServer.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get switchServer;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @serverAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a server address'**
  String get serverAddressRequired;

  /// Success message shown after adding a server.
  ///
  /// In en, this message translates to:
  /// **'Connected to {serverName}'**
  String serverConnected(String serverName);

  /// No description provided for @serverConnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to the server: {error}'**
  String serverConnectFailed(String error);

  /// No description provided for @serverSwitched.
  ///
  /// In en, this message translates to:
  /// **'Switched to {serverName}'**
  String serverSwitched(String serverName);

  /// No description provided for @serverSwitchFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not switch servers: {error}'**
  String serverSwitchFailed(String error);

  /// No description provided for @builtInServerCannotRemove.
  ///
  /// In en, this message translates to:
  /// **'The built-in server is part of the app configuration and cannot be removed'**
  String get builtInServerCannotRemove;

  /// No description provided for @serverRemoved.
  ///
  /// In en, this message translates to:
  /// **'Server removed'**
  String get serverRemoved;

  /// No description provided for @serverRemoveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not remove the server: {error}'**
  String serverRemoveFailed(String error);

  /// No description provided for @serverAddress.
  ///
  /// In en, this message translates to:
  /// **'Server address'**
  String get serverAddress;

  /// No description provided for @serverAddressExample.
  ///
  /// In en, this message translates to:
  /// **'Example: https://tv.example.com'**
  String get serverAddressExample;

  /// No description provided for @serverAutoDiscoverDescription.
  ///
  /// In en, this message translates to:
  /// **'Each address is stored as an independent server. SyncTV keeps its account, session, and cached data isolated by address.'**
  String get serverAutoDiscoverDescription;

  /// No description provided for @serverAddressIdentityDescription.
  ///
  /// In en, this message translates to:
  /// **'The address above identifies this server on this device. The ID below is declared by the server and may be shared or imitated by another address.'**
  String get serverAddressIdentityDescription;

  /// No description provided for @serverDeclaredId.
  ///
  /// In en, this message translates to:
  /// **'Server-declared ID: {serverId}'**
  String serverDeclaredId(String serverId);

  /// No description provided for @savedServers.
  ///
  /// In en, this message translates to:
  /// **'Saved servers'**
  String get savedServers;

  /// No description provided for @noSavedServers.
  ///
  /// In en, this message translates to:
  /// **'No servers saved yet. Add one to log in and browse public rooms.'**
  String get noSavedServers;

  /// No description provided for @currentServer.
  ///
  /// In en, this message translates to:
  /// **'Current server'**
  String get currentServer;

  /// No description provided for @serverInfoFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load server information: {error}'**
  String serverInfoFailed(String error);

  /// No description provided for @refreshServerInfo.
  ///
  /// In en, this message translates to:
  /// **'Refresh server information'**
  String get refreshServerInfo;

  /// No description provided for @openRoomFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the room: {error}'**
  String openRoomFailed(String error);

  /// No description provided for @loadRoomsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load rooms: {error}'**
  String loadRoomsFailed(String error);

  /// No description provided for @filterLabels.
  ///
  /// In en, this message translates to:
  /// **'Filter labels'**
  String get filterLabels;

  /// No description provided for @noLabelsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No labels available'**
  String get noLabelsAvailable;

  /// No description provided for @noLabelsForCategory.
  ///
  /// In en, this message translates to:
  /// **'No labels available in this category'**
  String get noLabelsForCategory;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @roomIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a room ID'**
  String get roomIdRequired;

  /// No description provided for @roomNotFound.
  ///
  /// In en, this message translates to:
  /// **'Room not found'**
  String get roomNotFound;

  /// No description provided for @roomUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This room is currently unavailable'**
  String get roomUnavailable;

  /// No description provided for @findRoomFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not find the room: {error}'**
  String findRoomFailed(String error);

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Log out of the current account?'**
  String get logoutConfirmMessage;

  /// No description provided for @logoutAction.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutAction;

  /// No description provided for @loggedOut.
  ///
  /// In en, this message translates to:
  /// **'Logged out'**
  String get loggedOut;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a password'**
  String get passwordRequired;

  /// No description provided for @joinRoomFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not join the room: {error}'**
  String joinRoomFailed(String error);

  /// No description provided for @deleteRoom.
  ///
  /// In en, this message translates to:
  /// **'Delete room'**
  String get deleteRoom;

  /// No description provided for @deleteRoomConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{roomName}\"? This action cannot be undone.'**
  String deleteRoomConfirm(String roomName);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @roomDeleted.
  ///
  /// In en, this message translates to:
  /// **'Room deleted'**
  String get roomDeleted;

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the room: {error}'**
  String deleteFailed(String error);

  /// No description provided for @updateFavoriteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the favorite: {error}'**
  String updateFavoriteFailed(String error);

  /// No description provided for @roomsPageSummary.
  ///
  /// In en, this message translates to:
  /// **'{total, plural, =0{No rooms} =1{1 room} other{{total} rooms}} · Page {page} of {pageCount}'**
  String roomsPageSummary(int total, int page, int pageCount);

  /// No description provided for @searchRooms.
  ///
  /// In en, this message translates to:
  /// **'Search rooms'**
  String get searchRooms;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get allCategories;

  /// No description provided for @labels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get labels;

  /// No description provided for @selectedLabels.
  ///
  /// In en, this message translates to:
  /// **'Labels {count}'**
  String selectedLabels(int count);

  /// No description provided for @clearRoomTaxonomyFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear category and label filters'**
  String get clearRoomTaxonomyFilters;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @addServerToStart.
  ///
  /// In en, this message translates to:
  /// **'Add a server to get started'**
  String get addServerToStart;

  /// No description provided for @noRooms.
  ///
  /// In en, this message translates to:
  /// **'No rooms'**
  String get noRooms;

  /// No description provided for @addServerDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter a server address to browse public rooms, log in, and join a watch room.'**
  String get addServerDescription;

  /// No description provided for @filteredRoomsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'No rooms match the current filters'**
  String get filteredRoomsEmptyDescription;

  /// No description provided for @addServer.
  ///
  /// In en, this message translates to:
  /// **'Add server'**
  String get addServer;

  /// No description provided for @joinRoomSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a room ID or paste an invite link'**
  String get joinRoomSubtitle;

  /// No description provided for @inviteLinkServerHint.
  ///
  /// In en, this message translates to:
  /// **'Invite links identify the server automatically. When several local addresses match, you can choose one in the next step.'**
  String get inviteLinkServerHint;

  /// No description provided for @roomIdOrInviteLink.
  ///
  /// In en, this message translates to:
  /// **'Room ID or invite link'**
  String get roomIdOrInviteLink;

  /// No description provided for @roomIdOrInviteLinkHint.
  ///
  /// In en, this message translates to:
  /// **'room_xxx or https://...'**
  String get roomIdOrInviteLinkHint;

  /// No description provided for @searching.
  ///
  /// In en, this message translates to:
  /// **'Searching'**
  String get searching;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @enterRoomPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter room password'**
  String get enterRoomPassword;

  /// No description provided for @roomPassword.
  ///
  /// In en, this message translates to:
  /// **'Room password'**
  String get roomPassword;

  /// No description provided for @roomPasswordJoinHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the password to join'**
  String get roomPasswordJoinHint;

  /// No description provided for @incorrectRoomPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect room password'**
  String get incorrectRoomPassword;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @roomCreationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Room creation is disabled on this server'**
  String get roomCreationDisabled;

  /// No description provided for @roomSubmittedForReview.
  ///
  /// In en, this message translates to:
  /// **'Room submitted for review'**
  String get roomSubmittedForReview;

  /// No description provided for @roomCreated.
  ///
  /// In en, this message translates to:
  /// **'Room created'**
  String get roomCreated;

  /// No description provided for @createRoomFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the room: {error}'**
  String createRoomFailed(String error);

  /// No description provided for @roomNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a room name'**
  String get roomNameRequired;

  /// No description provided for @roomNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Room names can contain up to {maxLength} characters'**
  String roomNameTooLong(int maxLength);

  /// No description provided for @roomPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a room password'**
  String get roomPasswordRequired;

  /// No description provided for @createPolicyLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the server\'\'s room creation policy. Try again later.'**
  String get createPolicyLoadFailed;

  /// No description provided for @roomCreationDisabledBanner.
  ///
  /// In en, this message translates to:
  /// **'Room creation is disabled on this server.'**
  String get roomCreationDisabledBanner;

  /// No description provided for @roomReviewRequiredBanner.
  ///
  /// In en, this message translates to:
  /// **'New rooms require review. Administrators can manage the room before approval; members cannot access it yet.'**
  String get roomReviewRequiredBanner;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic information'**
  String get basicInformation;

  /// No description provided for @roomName.
  ///
  /// In en, this message translates to:
  /// **'Room name'**
  String get roomName;

  /// No description provided for @roomNameHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Weekend movie night'**
  String get roomNameHint;

  /// No description provided for @roomDescription.
  ///
  /// In en, this message translates to:
  /// **'Room description'**
  String get roomDescription;

  /// No description provided for @roomDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Optional information that helps members understand the room'**
  String get roomDescriptionHint;

  /// No description provided for @accessMethod.
  ///
  /// In en, this message translates to:
  /// **'Access method'**
  String get accessMethod;

  /// No description provided for @roomVisibility.
  ///
  /// In en, this message translates to:
  /// **'Room visibility'**
  String get roomVisibility;

  /// No description provided for @publicRoomVisibilityDescription.
  ///
  /// In en, this message translates to:
  /// **'Listed in discovery; anonymous guests can access when guest joining is enabled'**
  String get publicRoomVisibilityDescription;

  /// No description provided for @privateRoomVisibilityDescription.
  ///
  /// In en, this message translates to:
  /// **'Hidden from discovery and unavailable to anonymous guests'**
  String get privateRoomVisibilityDescription;

  /// No description provided for @passwordProtection.
  ///
  /// In en, this message translates to:
  /// **'Password protection'**
  String get passwordProtection;

  /// No description provided for @noRoomPassword.
  ///
  /// In en, this message translates to:
  /// **'No password'**
  String get noRoomPassword;

  /// No description provided for @noRoomPasswordJoinHint.
  ///
  /// In en, this message translates to:
  /// **'Eligible members can join without a password'**
  String get noRoomPasswordJoinHint;

  /// No description provided for @serverRequiresPassword.
  ///
  /// In en, this message translates to:
  /// **'The server requires a password'**
  String get serverRequiresPassword;

  /// No description provided for @membersEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Members enter this password to join'**
  String get membersEnterPassword;

  /// No description provided for @creating.
  ///
  /// In en, this message translates to:
  /// **'Creating'**
  String get creating;

  /// No description provided for @roomCategory.
  ///
  /// In en, this message translates to:
  /// **'Room category'**
  String get roomCategory;

  /// No description provided for @taxonomyLoadFailedCreateAllowed.
  ///
  /// In en, this message translates to:
  /// **'Could not load categories. You can still create the room.'**
  String get taxonomyLoadFailedCreateAllowed;

  /// No description provided for @noCategory.
  ///
  /// In en, this message translates to:
  /// **'No category'**
  String get noCategory;

  /// No description provided for @roomLabels.
  ///
  /// In en, this message translates to:
  /// **'Room labels'**
  String get roomLabels;

  /// No description provided for @loadingCreationPolicy.
  ///
  /// In en, this message translates to:
  /// **'Loading the server\'\'s room creation policy'**
  String get loadingCreationPolicy;

  /// No description provided for @creationPolicyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Room creation policy unavailable'**
  String get creationPolicyUnavailable;

  /// No description provided for @serverDisallowsNewRooms.
  ///
  /// In en, this message translates to:
  /// **'This server does not allow new rooms'**
  String get serverDisallowsNewRooms;

  /// No description provided for @roomWillBeReviewed.
  ///
  /// In en, this message translates to:
  /// **'The room will be submitted for review'**
  String get roomWillBeReviewed;

  /// No description provided for @passwordRoomAccessHint.
  ///
  /// In en, this message translates to:
  /// **'Only members with the password can join'**
  String get passwordRoomAccessHint;

  /// No description provided for @publicRoomAccessHint.
  ///
  /// In en, this message translates to:
  /// **'Eligible members can join a public room'**
  String get publicRoomAccessHint;

  /// No description provided for @privateRoomAccessHint.
  ///
  /// In en, this message translates to:
  /// **'This room is hidden from discovery and unavailable to anonymous guests'**
  String get privateRoomAccessHint;

  /// No description provided for @createRoomSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set the room name, visibility, and password protection'**
  String get createRoomSubtitle;

  /// No description provided for @publicRoom.
  ///
  /// In en, this message translates to:
  /// **'Public room'**
  String get publicRoom;

  /// No description provided for @publicRoomJoinHint.
  ///
  /// In en, this message translates to:
  /// **'Members can request access or join directly'**
  String get publicRoomJoinHint;

  /// No description provided for @passwordRoom.
  ///
  /// In en, this message translates to:
  /// **'Password room'**
  String get passwordRoom;

  /// No description provided for @serverForbidsPassword.
  ///
  /// In en, this message translates to:
  /// **'The server does not allow room passwords'**
  String get serverForbidsPassword;

  /// No description provided for @passwordRoomJoinHint.
  ///
  /// In en, this message translates to:
  /// **'Members need the password to enter'**
  String get passwordRoomJoinHint;

  /// No description provided for @roomBanned.
  ///
  /// In en, this message translates to:
  /// **'Banned'**
  String get roomBanned;

  /// No description provided for @roomUnavailableShort.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get roomUnavailableShort;

  /// No description provided for @roomJoinable.
  ///
  /// In en, this message translates to:
  /// **'Joinable'**
  String get roomJoinable;

  /// No description provided for @roomGuestAccess.
  ///
  /// In en, this message translates to:
  /// **'Enter as guest'**
  String get roomGuestAccess;

  /// No description provided for @featuredRooms.
  ///
  /// In en, this message translates to:
  /// **'Featured rooms'**
  String get featuredRooms;

  /// No description provided for @featuredRoomsDescription.
  ///
  /// In en, this message translates to:
  /// **'Active spaces for watching together'**
  String get featuredRoomsDescription;

  /// No description provided for @continueWatchingRooms.
  ///
  /// In en, this message translates to:
  /// **'Continue watching'**
  String get continueWatchingRooms;

  /// No description provided for @continueWatchingRoomsDescription.
  ///
  /// In en, this message translates to:
  /// **'Return to rooms you have already joined'**
  String get continueWatchingRoomsDescription;

  /// No description provided for @popularRooms.
  ///
  /// In en, this message translates to:
  /// **'Popular rooms'**
  String get popularRooms;

  /// No description provided for @popularRoomsDescription.
  ///
  /// In en, this message translates to:
  /// **'Ranked by live activity, membership, and recent use'**
  String get popularRoomsDescription;

  /// No description provided for @roomJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get roomJoined;

  /// No description provided for @passwordRequiredShort.
  ///
  /// In en, this message translates to:
  /// **'Password required'**
  String get passwordRequiredShort;

  /// No description provided for @roomApprovalRequired.
  ///
  /// In en, this message translates to:
  /// **'Approval required'**
  String get roomApprovalRequired;

  /// No description provided for @roomApprovalPending.
  ///
  /// In en, this message translates to:
  /// **'Approval pending'**
  String get roomApprovalPending;

  /// No description provided for @roomJoinRequestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Join request submitted for approval'**
  String get roomJoinRequestSubmitted;

  /// No description provided for @signInToJoin.
  ///
  /// In en, this message translates to:
  /// **'Sign in to join'**
  String get signInToJoin;

  /// No description provided for @roomInvitationOnly.
  ///
  /// In en, this message translates to:
  /// **'Invitation only'**
  String get roomInvitationOnly;

  /// No description provided for @roomFull.
  ///
  /// In en, this message translates to:
  /// **'Room full'**
  String get roomFull;

  /// No description provided for @roomJoinCooldown.
  ///
  /// In en, this message translates to:
  /// **'Join unavailable'**
  String get roomJoinCooldown;

  /// No description provided for @roomPresenceSummary.
  ///
  /// In en, this message translates to:
  /// **'Online: {onlineMembers} members · {onlineGuests} guests'**
  String roomPresenceSummary(int onlineMembers, int onlineGuests);

  /// No description provided for @roomOnlineTotal.
  ///
  /// In en, this message translates to:
  /// **'Online: {count}'**
  String roomOnlineTotal(int count);

  /// No description provided for @roomPresenceWithMembers.
  ///
  /// In en, this message translates to:
  /// **'{onlineMembers} members online · {onlineGuests} guests online · {memberCount} members total'**
  String roomPresenceWithMembers(
    int onlineMembers,
    int onlineGuests,
    int memberCount,
  );

  /// No description provided for @roomConnections.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No connections} =1{1 connection} other{{count} connections}}'**
  String roomConnections(int count);

  /// No description provided for @removeFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFavorite;

  /// No description provided for @favoriteRoom.
  ///
  /// In en, this message translates to:
  /// **'Add room to favorites'**
  String get favoriteRoom;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get noDescription;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @hidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get hidden;

  /// No description provided for @unknownCreator.
  ///
  /// In en, this message translates to:
  /// **'Unknown creator'**
  String get unknownCreator;

  /// No description provided for @userAgreement.
  ///
  /// In en, this message translates to:
  /// **'User agreement'**
  String get userAgreement;

  /// No description provided for @readAgreementToEnd.
  ///
  /// In en, this message translates to:
  /// **'Read to the end to continue'**
  String get readAgreementToEnd;

  /// No description provided for @declineAndExit.
  ///
  /// In en, this message translates to:
  /// **'Decline and exit'**
  String get declineAndExit;

  /// No description provided for @agree.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get agree;

  /// No description provided for @authConfigLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load authentication settings: {error}'**
  String authConfigLoadFailed(String error);

  /// No description provided for @acceptTermsFirst.
  ///
  /// In en, this message translates to:
  /// **'Read and accept the user agreement and privacy policy first'**
  String get acceptTermsFirst;

  /// No description provided for @registrationSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Registration submitted for administrator review'**
  String get registrationSubmitted;

  /// No description provided for @registrationSubmittedWithId.
  ///
  /// In en, this message translates to:
  /// **'Registration submitted for administrator review ({reviewId})'**
  String registrationSubmittedWithId(String reviewId);

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get emailRequired;

  /// No description provided for @verificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent'**
  String get verificationCodeSent;

  /// No description provided for @emailAndCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and verification code'**
  String get emailAndCodeRequired;

  /// No description provided for @emailOrUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address or username'**
  String get emailOrUsernameRequired;

  /// No description provided for @enterIdentifierFirst.
  ///
  /// In en, this message translates to:
  /// **'Enter a username or email address first'**
  String get enterIdentifierFirst;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a username'**
  String get usernameRequired;

  /// No description provided for @usernameAndEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a username and email address'**
  String get usernameAndEmailRequired;

  /// No description provided for @registrationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Registration verification code sent'**
  String get registrationCodeSent;

  /// No description provided for @codeAndPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code and password'**
  String get codeAndPasswordRequired;

  /// No description provided for @authorizationPageOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the authorization page'**
  String get authorizationPageOpenFailed;

  /// No description provided for @mfaEmailUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This account does not support email verification'**
  String get mfaEmailUnsupported;

  /// No description provided for @mfaCodeSent.
  ///
  /// In en, this message translates to:
  /// **'Two-factor verification code sent'**
  String get mfaCodeSent;

  /// No description provided for @mfaCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the two-factor verification code'**
  String get mfaCodeRequired;

  /// No description provided for @mfaPasskeyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This account has no available passkey'**
  String get mfaPasskeyUnavailable;

  /// No description provided for @noLoginMethodAvailable.
  ///
  /// In en, this message translates to:
  /// **'This account has no sign-in method available on this device'**
  String get noLoginMethodAvailable;

  /// No description provided for @passwordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset. Log in with your new password.'**
  String get passwordResetSuccess;

  /// No description provided for @connectToSyncTv.
  ///
  /// In en, this message translates to:
  /// **'Connect to SyncTV'**
  String get connectToSyncTv;

  /// No description provided for @noServerConnected.
  ///
  /// In en, this message translates to:
  /// **'No server connected'**
  String get noServerConnected;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @emailOrUsername.
  ///
  /// In en, this message translates to:
  /// **'Email or username'**
  String get emailOrUsername;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get verificationCode;

  /// No description provided for @waitingForAuthorization.
  ///
  /// In en, this message translates to:
  /// **'Waiting for {provider} authorization'**
  String waitingForAuthorization(String provider);

  /// No description provided for @registrationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Account registration is disabled on this server'**
  String get registrationDisabled;

  /// No description provided for @emailRegistrationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Email registration is disabled on this server'**
  String get emailRegistrationDisabled;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPassword;

  /// No description provided for @getCodeFirst.
  ///
  /// In en, this message translates to:
  /// **'Get a code first'**
  String get getCodeFirst;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @emailCodeLogin.
  ///
  /// In en, this message translates to:
  /// **'Log in with verification code'**
  String get emailCodeLogin;

  /// No description provided for @passkeyLogin.
  ///
  /// In en, this message translates to:
  /// **'Log in with passkey'**
  String get passkeyLogin;

  /// No description provided for @passwordLogin.
  ///
  /// In en, this message translates to:
  /// **'Password login'**
  String get passwordLogin;

  /// No description provided for @thirdPartyRegistration.
  ///
  /// In en, this message translates to:
  /// **'Third-party registration'**
  String get thirdPartyRegistration;

  /// No description provided for @accountRegistration.
  ///
  /// In en, this message translates to:
  /// **'Account registration'**
  String get accountRegistration;

  /// No description provided for @usernameOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Username or email'**
  String get usernameOrEmail;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @includeEmail.
  ///
  /// In en, this message translates to:
  /// **'Add an email address'**
  String get includeEmail;

  /// No description provided for @includeEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'You can complete registration with an email verification code.'**
  String get includeEmailDescription;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @emailCodeRegistration.
  ///
  /// In en, this message translates to:
  /// **'Email verification registration'**
  String get emailCodeRegistration;

  /// No description provided for @createAccountWithEmailCode.
  ///
  /// In en, this message translates to:
  /// **'Create account with email code'**
  String get createAccountWithEmailCode;

  /// No description provided for @passkeyRegistration.
  ///
  /// In en, this message translates to:
  /// **'Passkey registration'**
  String get passkeyRegistration;

  /// No description provided for @registrationMethod.
  ///
  /// In en, this message translates to:
  /// **'Registration method'**
  String get registrationMethod;

  /// No description provided for @deviceNameHint.
  ///
  /// In en, this message translates to:
  /// **'Device name, such as MacBook or phone'**
  String get deviceNameHint;

  /// No description provided for @createPasskeyAccount.
  ///
  /// In en, this message translates to:
  /// **'Create passkey account'**
  String get createPasskeyAccount;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @guestAccessDescription.
  ///
  /// In en, this message translates to:
  /// **'Guest access only opens a specific room. Public rooms can be browsed without logging in; creating rooms, account settings, and administration require an account.'**
  String get guestAccessDescription;

  /// No description provided for @roomId.
  ///
  /// In en, this message translates to:
  /// **'Room ID'**
  String get roomId;

  /// No description provided for @guestAccessDisabled.
  ///
  /// In en, this message translates to:
  /// **'Guest access is disabled on this server'**
  String get guestAccessDisabled;

  /// No description provided for @enterAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Enter as guest'**
  String get enterAsGuest;

  /// No description provided for @twoFactorVerification.
  ///
  /// In en, this message translates to:
  /// **'Two-factor verification'**
  String get twoFactorVerification;

  /// No description provided for @additionalVerificationRequired.
  ///
  /// In en, this message translates to:
  /// **'This account requires additional verification.'**
  String get additionalVerificationRequired;

  /// No description provided for @codeSentTo.
  ///
  /// In en, this message translates to:
  /// **'A verification code will be sent to {email}'**
  String codeSentTo(String email);

  /// No description provided for @getMfaCodeFirst.
  ///
  /// In en, this message translates to:
  /// **'Get a two-factor code first'**
  String get getMfaCodeFirst;

  /// No description provided for @completeVerification.
  ///
  /// In en, this message translates to:
  /// **'Complete verification'**
  String get completeVerification;

  /// No description provided for @verifyWithPasskey.
  ///
  /// In en, this message translates to:
  /// **'Verify with passkey'**
  String get verifyWithPasskey;

  /// No description provided for @thirdPartyLogin.
  ///
  /// In en, this message translates to:
  /// **'Third-party login'**
  String get thirdPartyLogin;

  /// No description provided for @continueWithProvider.
  ///
  /// In en, this message translates to:
  /// **'Continue with {provider}'**
  String continueWithProvider(String provider);

  /// No description provided for @oauthCallbackUnavailable.
  ///
  /// In en, this message translates to:
  /// **'OAuth2 requires an App Link or desktop callback in this build.'**
  String get oauthCallbackUnavailable;

  /// No description provided for @oauthAuthorizationTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Authorization took too long. Please try again.'**
  String get oauthAuthorizationTimedOut;

  /// No description provided for @providerReviewRequired.
  ///
  /// In en, this message translates to:
  /// **'{provider} (registration requires review)'**
  String providerReviewRequired(String provider);

  /// No description provided for @providerLoginOnly.
  ///
  /// In en, this message translates to:
  /// **'{provider} (login only)'**
  String providerLoginOnly(String provider);

  /// No description provided for @acceptTermsSemantics.
  ///
  /// In en, this message translates to:
  /// **'Accept the user agreement and privacy policy'**
  String get acceptTermsSemantics;

  /// No description provided for @termsPrefix.
  ///
  /// In en, this message translates to:
  /// **'I have read and accept'**
  String get termsPrefix;

  /// No description provided for @userAgreementLink.
  ///
  /// In en, this message translates to:
  /// **'User Agreement'**
  String get userAgreementLink;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @privacyPolicyLink.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyLink;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent'**
  String get passwordResetEmailSent;

  /// No description provided for @passwordResetEmailFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send the password reset email: {error}'**
  String passwordResetEmailFailed(String error);

  /// No description provided for @resetFieldsRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email, verification code, and new password'**
  String get resetFieldsRequired;

  /// No description provided for @newPasswordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'The new passwords do not match'**
  String get newPasswordsMismatch;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @resetCode.
  ///
  /// In en, this message translates to:
  /// **'Reset verification code'**
  String get resetCode;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @agreementContent.
  ///
  /// In en, this message translates to:
  /// **'# SyncTV User Agreement and Privacy Policy\n\nThis app connects to SyncTV servers owned by users. It does not provide a public content server or store, review, or operate content hosted on user servers.\n\nYou are responsible for lawful authorization of connected servers, rooms, and media, as well as server security, account security, content compliance, and backups.\n\nBy logging in, registering, using guest access, or connecting a server, you agree to follow applicable laws and refrain from distributing unlawful, harmful, infringing, or unauthorized content.\n\nThe app may store server addresses, login tokens, guest tokens, and basic preferences on this device to preserve sessions and support server switching.\n\nOAuth2 opens a browser or system authorization page and returns through an App Link or desktop callback. The app does not ask you to enter callback URLs or authorization codes manually.\n\nStop using the app if you do not accept these terms.'**
  String get agreementContent;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @previousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get previousPage;

  /// No description provided for @nextPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get nextPage;

  /// No description provided for @previousRooms.
  ///
  /// In en, this message translates to:
  /// **'Previous rooms'**
  String get previousRooms;

  /// No description provided for @nextRooms.
  ///
  /// In en, this message translates to:
  /// **'Next rooms'**
  String get nextRooms;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @playlistEmpty.
  ///
  /// In en, this message translates to:
  /// **'The playlist is empty'**
  String get playlistEmpty;

  /// No description provided for @playlistEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a video to start watching together'**
  String get playlistEmptyDescription;

  /// No description provided for @addMedia.
  ///
  /// In en, this message translates to:
  /// **'Add media'**
  String get addMedia;

  /// No description provided for @loadingVideo.
  ///
  /// In en, this message translates to:
  /// **'Loading video'**
  String get loadingVideo;

  /// No description provided for @waitingForPlayback.
  ///
  /// In en, this message translates to:
  /// **'Waiting for playback'**
  String get waitingForPlayback;

  /// No description provided for @messageReadDetails.
  ///
  /// In en, this message translates to:
  /// **'Message read details'**
  String get messageReadDetails;

  /// No description provided for @readCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No readers} =1{1 read} other{{count} read}}'**
  String readCount(int count);

  /// No description provided for @unreadCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{None unread} =1{1 unread} other{{count} unread}}'**
  String unreadCount(int count);

  /// No description provided for @reactionMembers.
  ///
  /// In en, this message translates to:
  /// **'{reaction} reactions'**
  String reactionMembers(String reaction);

  /// No description provided for @memberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No members} =1{1 member} other{{count} members}}'**
  String memberCount(int count);

  /// No description provided for @reactingMembers.
  ///
  /// In en, this message translates to:
  /// **'Reacting members'**
  String get reactingMembers;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get loadMore;

  /// No description provided for @serverRequiredForInvite.
  ///
  /// In en, this message translates to:
  /// **'Add the invite server'**
  String get serverRequiredForInvite;

  /// No description provided for @serverRequiredForInviteDescription.
  ///
  /// In en, this message translates to:
  /// **'This invitation comes from another SyncTV server. Add its address so the app can identify it and continue joining the room.'**
  String get serverRequiredForInviteDescription;

  /// No description provided for @chooseServerEndpoint.
  ///
  /// In en, this message translates to:
  /// **'Choose server address'**
  String get chooseServerEndpoint;

  /// No description provided for @roomIdOrInviteRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a room ID or invitation link'**
  String get roomIdOrInviteRequired;

  /// No description provided for @processInviteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not process the invitation: {error}'**
  String processInviteFailed(String error);

  /// No description provided for @editImage.
  ///
  /// In en, this message translates to:
  /// **'Edit image'**
  String get editImage;

  /// No description provided for @imageCropFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not crop the image: {error}'**
  String imageCropFailed(String error);

  /// No description provided for @cropForPurpose.
  ///
  /// In en, this message translates to:
  /// **'Use target aspect ratio'**
  String get cropForPurpose;

  /// No description provided for @squareCrop.
  ///
  /// In en, this message translates to:
  /// **'Square crop'**
  String get squareCrop;

  /// No description provided for @uploadOriginalImage.
  ///
  /// In en, this message translates to:
  /// **'Upload original'**
  String get uploadOriginalImage;

  /// No description provided for @useEditedImage.
  ///
  /// In en, this message translates to:
  /// **'Use edited image'**
  String get useEditedImage;

  /// No description provided for @imageSelectedDescription.
  ///
  /// In en, this message translates to:
  /// **'Image selected. Add a description, then send it.'**
  String get imageSelectedDescription;

  /// No description provided for @cancelImage.
  ///
  /// In en, this message translates to:
  /// **'Remove image'**
  String get cancelImage;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @describeImage.
  ///
  /// In en, this message translates to:
  /// **'Describe the image...'**
  String get describeImage;

  /// No description provided for @enterMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter a message...'**
  String get enterMessage;

  /// No description provided for @chooseImage.
  ///
  /// In en, this message translates to:
  /// **'Choose image'**
  String get chooseImage;

  /// No description provided for @switchToVoice.
  ///
  /// In en, this message translates to:
  /// **'Switch to voice'**
  String get switchToVoice;

  /// No description provided for @releaseToCancel.
  ///
  /// In en, this message translates to:
  /// **'Release to cancel'**
  String get releaseToCancel;

  /// No description provided for @releaseToSendSwipeToCancel.
  ///
  /// In en, this message translates to:
  /// **'Release to send, swipe up to cancel'**
  String get releaseToSendSwipeToCancel;

  /// No description provided for @holdToTalk.
  ///
  /// In en, this message translates to:
  /// **'Hold to talk'**
  String get holdToTalk;

  /// No description provided for @switchToText.
  ///
  /// In en, this message translates to:
  /// **'Switch to text'**
  String get switchToText;

  /// No description provided for @noRealtimeEvents.
  ///
  /// In en, this message translates to:
  /// **'No realtime events'**
  String get noRealtimeEvents;

  /// No description provided for @realtimeEventsCopied.
  ///
  /// In en, this message translates to:
  /// **'Realtime events copied'**
  String get realtimeEventsCopied;

  /// No description provided for @retentionCount.
  ///
  /// In en, this message translates to:
  /// **'Retention limit'**
  String get retentionCount;

  /// No description provided for @recentEventCount.
  ///
  /// In en, this message translates to:
  /// **'Recent event count'**
  String get recentEventCount;

  /// No description provided for @eventCountRange.
  ///
  /// In en, this message translates to:
  /// **'Range: 20-2000'**
  String get eventCountRange;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @retainEvents.
  ///
  /// In en, this message translates to:
  /// **'Keep {count} events'**
  String retainEvents(int count);

  /// No description provided for @customValue.
  ///
  /// In en, this message translates to:
  /// **'Custom...'**
  String get customValue;

  /// No description provided for @viewChronologically.
  ///
  /// In en, this message translates to:
  /// **'View chronologically'**
  String get viewChronologically;

  /// No description provided for @groupByType.
  ///
  /// In en, this message translates to:
  /// **'Group by type'**
  String get groupByType;

  /// No description provided for @eventCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No events} =1{1 event} other{{count} events}}'**
  String eventCount(int count);

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items} =1{1 item} other{{count} items}}'**
  String itemCount(int count);

  /// No description provided for @copyEvents.
  ///
  /// In en, this message translates to:
  /// **'Copy events'**
  String get copyEvents;

  /// No description provided for @clearEvents.
  ///
  /// In en, this message translates to:
  /// **'Clear events'**
  String get clearEvents;

  /// No description provided for @moreActions.
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get moreActions;

  /// No description provided for @filterEventTypes.
  ///
  /// In en, this message translates to:
  /// **'Filter event types'**
  String get filterEventTypes;

  /// No description provided for @eventTypeFilter.
  ///
  /// In en, this message translates to:
  /// **'Event type filter'**
  String get eventTypeFilter;

  /// No description provided for @selectionCount.
  ///
  /// In en, this message translates to:
  /// **'Selected {selected} / {total}'**
  String selectionCount(int selected, int total);

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get selectAll;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get allTypes;

  /// No description provided for @filteredEventCount.
  ///
  /// In en, this message translates to:
  /// **'{visible} / {total} events'**
  String filteredEventCount(int visible, int total);

  /// No description provided for @realtimeEvents.
  ///
  /// In en, this message translates to:
  /// **'Realtime events'**
  String get realtimeEvents;

  /// No description provided for @groupedEventCount.
  ///
  /// In en, this message translates to:
  /// **'{groups, plural, =0{No groups} =1{1 group} other{{groups} groups}} / {events}'**
  String groupedEventCount(int groups, String events);

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @noFilteredRealtimeEvents.
  ///
  /// In en, this message translates to:
  /// **'No realtime events match the current filter'**
  String get noFilteredRealtimeEvents;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @latestAt.
  ///
  /// In en, this message translates to:
  /// **'Latest {time}'**
  String latestAt(String time);

  /// No description provided for @byteCount.
  ///
  /// In en, this message translates to:
  /// **'{count} bytes'**
  String byteCount(int count);

  /// No description provided for @brightness.
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get brightness;

  /// No description provided for @volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// No description provided for @brightnessPercent.
  ///
  /// In en, this message translates to:
  /// **'Brightness {value}%'**
  String brightnessPercent(int value);

  /// No description provided for @volumePercent.
  ///
  /// In en, this message translates to:
  /// **'Volume {value}%'**
  String volumePercent(int value);

  /// No description provided for @unmute.
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get unmute;

  /// No description provided for @mute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get mute;

  /// No description provided for @muted.
  ///
  /// In en, this message translates to:
  /// **'Muted'**
  String get muted;

  /// No description provided for @chooseSubtitles.
  ///
  /// In en, this message translates to:
  /// **'Choose subtitles'**
  String get chooseSubtitles;

  /// No description provided for @disableSubtitles.
  ///
  /// In en, this message translates to:
  /// **'Turn off subtitles'**
  String get disableSubtitles;

  /// No description provided for @danmaku.
  ///
  /// In en, this message translates to:
  /// **'Danmaku'**
  String get danmaku;

  /// No description provided for @videoDanmaku.
  ///
  /// In en, this message translates to:
  /// **'Video danmaku'**
  String get videoDanmaku;

  /// No description provided for @chatDanmaku.
  ///
  /// In en, this message translates to:
  /// **'Chat danmaku'**
  String get chatDanmaku;

  /// No description provided for @danmakuHint.
  ///
  /// In en, this message translates to:
  /// **'Send a danmaku for this moment...'**
  String get danmakuHint;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @playbackProgress.
  ///
  /// In en, this message translates to:
  /// **'Playback progress'**
  String get playbackProgress;

  /// No description provided for @subtitles.
  ///
  /// In en, this message translates to:
  /// **'Subtitles'**
  String get subtitles;

  /// No description provided for @disableVideoDanmaku.
  ///
  /// In en, this message translates to:
  /// **'Turn off video danmaku'**
  String get disableVideoDanmaku;

  /// No description provided for @enableVideoDanmaku.
  ///
  /// In en, this message translates to:
  /// **'Turn on video danmaku'**
  String get enableVideoDanmaku;

  /// No description provided for @disableChatDanmaku.
  ///
  /// In en, this message translates to:
  /// **'Turn off chat danmaku'**
  String get disableChatDanmaku;

  /// No description provided for @enableChatDanmaku.
  ///
  /// In en, this message translates to:
  /// **'Turn on chat danmaku'**
  String get enableChatDanmaku;

  /// No description provided for @overlaySettings.
  ///
  /// In en, this message translates to:
  /// **'Subtitle and danmaku settings'**
  String get overlaySettings;

  /// No description provided for @subtitleSettings.
  ///
  /// In en, this message translates to:
  /// **'Subtitle settings'**
  String get subtitleSettings;

  /// No description provided for @videoDanmakuSettings.
  ///
  /// In en, this message translates to:
  /// **'Video danmaku settings'**
  String get videoDanmakuSettings;

  /// No description provided for @chatDanmakuSettings.
  ///
  /// In en, this message translates to:
  /// **'Chat danmaku settings'**
  String get chatDanmakuSettings;

  /// No description provided for @subtitleStyle.
  ///
  /// In en, this message translates to:
  /// **'Subtitle style'**
  String get subtitleStyle;

  /// No description provided for @subtitleSize.
  ///
  /// In en, this message translates to:
  /// **'Subtitle size'**
  String get subtitleSize;

  /// No description provided for @subtitleOpacity.
  ///
  /// In en, this message translates to:
  /// **'Subtitle opacity'**
  String get subtitleOpacity;

  /// No description provided for @subtitleBackground.
  ///
  /// In en, this message translates to:
  /// **'Subtitle background'**
  String get subtitleBackground;

  /// No description provided for @subtitlePosition.
  ///
  /// In en, this message translates to:
  /// **'Subtitle position'**
  String get subtitlePosition;

  /// No description provided for @subtitleColor.
  ///
  /// In en, this message translates to:
  /// **'Subtitle color'**
  String get subtitleColor;

  /// No description provided for @subtitleBackgroundColor.
  ///
  /// In en, this message translates to:
  /// **'Subtitle background color'**
  String get subtitleBackgroundColor;

  /// No description provided for @subtitleOutline.
  ///
  /// In en, this message translates to:
  /// **'Subtitle outline'**
  String get subtitleOutline;

  /// No description provided for @videoDanmakuStyle.
  ///
  /// In en, this message translates to:
  /// **'Video danmaku style'**
  String get videoDanmakuStyle;

  /// No description provided for @chatDanmakuStyle.
  ///
  /// In en, this message translates to:
  /// **'Chat danmaku style'**
  String get chatDanmakuStyle;

  /// No description provided for @danmakuSize.
  ///
  /// In en, this message translates to:
  /// **'Danmaku size'**
  String get danmakuSize;

  /// No description provided for @danmakuOpacity.
  ///
  /// In en, this message translates to:
  /// **'Danmaku opacity'**
  String get danmakuOpacity;

  /// No description provided for @danmakuSpeed.
  ///
  /// In en, this message translates to:
  /// **'Danmaku speed'**
  String get danmakuSpeed;

  /// No description provided for @danmakuArea.
  ///
  /// In en, this message translates to:
  /// **'Danmaku area'**
  String get danmakuArea;

  /// No description provided for @danmakuOutline.
  ///
  /// In en, this message translates to:
  /// **'Danmaku outline'**
  String get danmakuOutline;

  /// No description provided for @danmakuMassiveMode.
  ///
  /// In en, this message translates to:
  /// **'Massive danmaku'**
  String get danmakuMassiveMode;

  /// No description provided for @danmakuTop.
  ///
  /// In en, this message translates to:
  /// **'Top danmaku'**
  String get danmakuTop;

  /// No description provided for @danmakuBottom.
  ///
  /// In en, this message translates to:
  /// **'Bottom danmaku'**
  String get danmakuBottom;

  /// No description provided for @danmakuScroll.
  ///
  /// In en, this message translates to:
  /// **'Scrolling danmaku'**
  String get danmakuScroll;

  /// No description provided for @resetOverlaySettings.
  ///
  /// In en, this message translates to:
  /// **'Reset overlay style'**
  String get resetOverlaySettings;

  /// No description provided for @reload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reload;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// No description provided for @sendDanmaku.
  ///
  /// In en, this message translates to:
  /// **'Send danmaku'**
  String get sendDanmaku;

  /// No description provided for @exitFullscreen.
  ///
  /// In en, this message translates to:
  /// **'Exit fullscreen'**
  String get exitFullscreen;

  /// No description provided for @fullscreen.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen'**
  String get fullscreen;

  /// No description provided for @pictureInPicture.
  ///
  /// In en, this message translates to:
  /// **'Picture in picture'**
  String get pictureInPicture;

  /// No description provided for @exitPictureInPicture.
  ///
  /// In en, this message translates to:
  /// **'Return to room'**
  String get exitPictureInPicture;

  /// No description provided for @loopPlayback.
  ///
  /// In en, this message translates to:
  /// **'Loop video'**
  String get loopPlayback;

  /// No description provided for @shufflePlayback.
  ///
  /// In en, this message translates to:
  /// **'Shuffle playlist'**
  String get shufflePlayback;

  /// No description provided for @sequentialPlayback.
  ///
  /// In en, this message translates to:
  /// **'Sequential playback'**
  String get sequentialPlayback;

  /// No description provided for @syncPlayback.
  ///
  /// In en, this message translates to:
  /// **'Sync with room'**
  String get syncPlayback;

  /// No description provided for @reloadLivePlayback.
  ///
  /// In en, this message translates to:
  /// **'Reload live stream'**
  String get reloadLivePlayback;

  /// No description provided for @reloadPlaybackSource.
  ///
  /// In en, this message translates to:
  /// **'Reload playback source'**
  String get reloadPlaybackSource;

  /// No description provided for @copyPlaybackDebugInfo.
  ///
  /// In en, this message translates to:
  /// **'Copy debug information'**
  String get copyPlaybackDebugInfo;

  /// No description provided for @playbackDebugInfoCopied.
  ///
  /// In en, this message translates to:
  /// **'Playback debug information copied'**
  String get playbackDebugInfoCopied;

  /// No description provided for @detailedPlaybackStatistics.
  ///
  /// In en, this message translates to:
  /// **'Detailed playback statistics'**
  String get detailedPlaybackStatistics;

  /// No description provided for @playbackModeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Playback order: {mode}'**
  String playbackModeUpdated(String mode);

  /// No description provided for @updatePlaybackModeFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update playback order: {error}'**
  String updatePlaybackModeFailed(String error);

  /// No description provided for @playerResource.
  ///
  /// In en, this message translates to:
  /// **'Resource'**
  String get playerResource;

  /// No description provided for @playerProvider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get playerProvider;

  /// No description provided for @playerPlaybackRoute.
  ///
  /// In en, this message translates to:
  /// **'Playback route'**
  String get playerPlaybackRoute;

  /// No description provided for @playerFormat.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get playerFormat;

  /// No description provided for @playerViewportVideo.
  ///
  /// In en, this message translates to:
  /// **'Viewport / video'**
  String get playerViewportVideo;

  /// No description provided for @playerPlaybackState.
  ///
  /// In en, this message translates to:
  /// **'Playback'**
  String get playerPlaybackState;

  /// No description provided for @playerBufferHealth.
  ///
  /// In en, this message translates to:
  /// **'Buffer health'**
  String get playerBufferHealth;

  /// No description provided for @playerSpeedVolume.
  ///
  /// In en, this message translates to:
  /// **'Speed / volume'**
  String get playerSpeedVolume;

  /// No description provided for @playerSynchronization.
  ///
  /// In en, this message translates to:
  /// **'Synchronization'**
  String get playerSynchronization;

  /// No description provided for @playerThroughput.
  ///
  /// In en, this message translates to:
  /// **'Throughput / total'**
  String get playerThroughput;

  /// No description provided for @playerP2pDelivery.
  ///
  /// In en, this message translates to:
  /// **'P2P delivery'**
  String get playerP2pDelivery;

  /// No description provided for @playerCache.
  ///
  /// In en, this message translates to:
  /// **'Cache / hit rate'**
  String get playerCache;

  /// No description provided for @playerError.
  ///
  /// In en, this message translates to:
  /// **'Player error'**
  String get playerError;

  /// No description provided for @playerStatePlaying.
  ///
  /// In en, this message translates to:
  /// **'Playing'**
  String get playerStatePlaying;

  /// No description provided for @playerStatePaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get playerStatePaused;

  /// No description provided for @playerStateBuffering.
  ///
  /// In en, this message translates to:
  /// **'Buffering'**
  String get playerStateBuffering;

  /// No description provided for @playerLatencyMilliseconds.
  ///
  /// In en, this message translates to:
  /// **'{value} ms latency'**
  String playerLatencyMilliseconds(int value);

  /// No description provided for @playerDeviationMilliseconds.
  ///
  /// In en, this message translates to:
  /// **'{value} ms drift'**
  String playerDeviationMilliseconds(int value);

  /// No description provided for @playerBufferRangeCount.
  ///
  /// In en, this message translates to:
  /// **'{count} ranges'**
  String playerBufferRangeCount(int count);

  /// No description provided for @playerConnectedPeerCount.
  ///
  /// In en, this message translates to:
  /// **'{count} peers'**
  String playerConnectedPeerCount(int count);

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @playbackSpeed.
  ///
  /// In en, this message translates to:
  /// **'Playback speed'**
  String get playbackSpeed;

  /// No description provided for @playbackSpeedValue.
  ///
  /// In en, this message translates to:
  /// **'Playback speed {speed}x'**
  String playbackSpeedValue(String speed);

  /// No description provided for @loadMediaBindingsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load media source bindings: {error}'**
  String loadMediaBindingsFailed(String error);

  /// No description provided for @directLink.
  ///
  /// In en, this message translates to:
  /// **'Direct link'**
  String get directLink;

  /// No description provided for @rtmpPublishing.
  ///
  /// In en, this message translates to:
  /// **'RTMP publishing'**
  String get rtmpPublishing;

  /// No description provided for @livePull.
  ///
  /// In en, this message translates to:
  /// **'Live stream pull'**
  String get livePull;

  /// No description provided for @alistStorage.
  ///
  /// In en, this message translates to:
  /// **'AList storage'**
  String get alistStorage;

  /// No description provided for @embyLibrary.
  ///
  /// In en, this message translates to:
  /// **'Emby library'**
  String get embyLibrary;

  /// No description provided for @generatePublishingAddress.
  ///
  /// In en, this message translates to:
  /// **'Generate a publishing address'**
  String get generatePublishingAddress;

  /// No description provided for @bilibiliLinkParsing.
  ///
  /// In en, this message translates to:
  /// **'BV / link parsing'**
  String get bilibiliLinkParsing;

  /// No description provided for @mountedDirectoryResources.
  ///
  /// In en, this message translates to:
  /// **'Mounted directory resources'**
  String get mountedDirectoryResources;

  /// No description provided for @personalMediaServer.
  ///
  /// In en, this message translates to:
  /// **'Personal media server'**
  String get personalMediaServer;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @connectedMediaSources.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No connected media sources} =1{1 connected media source} other{{count} connected media sources}}'**
  String connectedMediaSources(int count);

  /// No description provided for @mediaSource.
  ///
  /// In en, this message translates to:
  /// **'Media source'**
  String get mediaSource;

  /// No description provided for @playbackKind.
  ///
  /// In en, this message translates to:
  /// **'Playback type'**
  String get playbackKind;

  /// No description provided for @onDemand.
  ///
  /// In en, this message translates to:
  /// **'On demand'**
  String get onDemand;

  /// No description provided for @videoLinks.
  ///
  /// In en, this message translates to:
  /// **'Video links'**
  String get videoLinks;

  /// No description provided for @videoLinksHint.
  ///
  /// In en, this message translates to:
  /// **'One HTTP, HTTPS, or HLS address per line'**
  String get videoLinksHint;

  /// No description provided for @optionalVideoName.
  ///
  /// In en, this message translates to:
  /// **'Video name (optional for one item)'**
  String get optionalVideoName;

  /// No description provided for @defaultsToFileName.
  ///
  /// In en, this message translates to:
  /// **'Defaults to the file name'**
  String get defaultsToFileName;

  /// No description provided for @playbackProxyMode.
  ///
  /// In en, this message translates to:
  /// **'Playback route'**
  String get playbackProxyMode;

  /// No description provided for @playbackProxyAuto.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get playbackProxyAuto;

  /// No description provided for @playbackProxyPrefer.
  ///
  /// In en, this message translates to:
  /// **'Prefer proxy'**
  String get playbackProxyPrefer;

  /// No description provided for @playbackProxyOnly.
  ///
  /// In en, this message translates to:
  /// **'Proxy only'**
  String get playbackProxyOnly;

  /// No description provided for @playbackProxyDirectPrefer.
  ///
  /// In en, this message translates to:
  /// **'Prefer direct'**
  String get playbackProxyDirectPrefer;

  /// No description provided for @playbackProxyDirectOnly.
  ///
  /// In en, this message translates to:
  /// **'Direct only'**
  String get playbackProxyDirectOnly;

  /// No description provided for @playbackProxyAutoDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the media source\'\'s default playback route'**
  String get playbackProxyAutoDescription;

  /// No description provided for @playbackProxyPreferDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep direct and proxy routes, selecting the proxy by default'**
  String get playbackProxyPreferDescription;

  /// No description provided for @playbackProxyOnlyDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep routes that the SyncTV server can proxy'**
  String get playbackProxyOnlyDescription;

  /// No description provided for @playbackProxyDirectPreferDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep direct and proxy routes, selecting direct by default'**
  String get playbackProxyDirectPreferDescription;

  /// No description provided for @playbackProxyDirectOnlyDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep direct playback routes only'**
  String get playbackProxyDirectOnlyDescription;

  /// No description provided for @playbackProxyDirectRisk.
  ///
  /// In en, this message translates to:
  /// **'Direct playback can expose upstream URLs, signed links, tokens, cookies, or authorization headers to room members. Use it only in a trusted room and network.'**
  String get playbackProxyDirectRisk;

  /// No description provided for @playbackProxyAutoEffective.
  ///
  /// In en, this message translates to:
  /// **'{variant}: {mode} ({reason})'**
  String playbackProxyAutoEffective(Object mode, Object reason, Object variant);

  /// No description provided for @playbackProxyReasonPublicResource.
  ///
  /// In en, this message translates to:
  /// **'public resource'**
  String get playbackProxyReasonPublicResource;

  /// No description provided for @playbackProxyReasonRequestCredentials.
  ///
  /// In en, this message translates to:
  /// **'request credentials'**
  String get playbackProxyReasonRequestCredentials;

  /// No description provided for @playbackProxyReasonSignedResource.
  ///
  /// In en, this message translates to:
  /// **'signed resource'**
  String get playbackProxyReasonSignedResource;

  /// No description provided for @playbackProxyReasonProviderSession.
  ///
  /// In en, this message translates to:
  /// **'provider session'**
  String get playbackProxyReasonProviderSession;

  /// No description provided for @playbackProxyReasonServerTransport.
  ///
  /// In en, this message translates to:
  /// **'server transport'**
  String get playbackProxyReasonServerTransport;

  /// No description provided for @playbackProxyPolicyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Playback route policy is unavailable: {error}'**
  String playbackProxyPolicyUnavailable(Object error);

  /// No description provided for @playbackProxyNoCompatibleMode.
  ///
  /// In en, this message translates to:
  /// **'No compatible playback route is available for this media source.'**
  String get playbackProxyNoCompatibleMode;

  /// No description provided for @addToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add to playlist'**
  String get addToPlaylist;

  /// No description provided for @requestHeaders.
  ///
  /// In en, this message translates to:
  /// **'Request headers'**
  String get requestHeaders;

  /// No description provided for @noExtraRequestHeaders.
  ///
  /// In en, this message translates to:
  /// **'No extra request headers are sent by default.'**
  String get noExtraRequestHeaders;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @removeRequestHeader.
  ///
  /// In en, this message translates to:
  /// **'Remove request header'**
  String get removeRequestHeader;

  /// No description provided for @liveName.
  ///
  /// In en, this message translates to:
  /// **'Live stream name'**
  String get liveName;

  /// No description provided for @liveNameHint.
  ///
  /// In en, this message translates to:
  /// **'For example, Camera or OBS stream'**
  String get liveNameHint;

  /// No description provided for @streamMode.
  ///
  /// In en, this message translates to:
  /// **'Stream mode'**
  String get streamMode;

  /// No description provided for @publishKeyType.
  ///
  /// In en, this message translates to:
  /// **'Publish key type'**
  String get publishKeyType;

  /// No description provided for @singleUsePublishKey.
  ///
  /// In en, this message translates to:
  /// **'One-time key'**
  String get singleUsePublishKey;

  /// No description provided for @expiringPublishKey.
  ///
  /// In en, this message translates to:
  /// **'Reusable until expiration'**
  String get expiringPublishKey;

  /// No description provided for @permanentPublishKey.
  ///
  /// In en, this message translates to:
  /// **'Never expires'**
  String get permanentPublishKey;

  /// No description provided for @permanentPublishKeyDescription.
  ///
  /// In en, this message translates to:
  /// **'Anyone with this key can publish until the server JWT secret changes.'**
  String get permanentPublishKeyDescription;

  /// No description provided for @noExpiration.
  ///
  /// In en, this message translates to:
  /// **'Never expires'**
  String get noExpiration;

  /// No description provided for @publishKeyExpirationMustBeFuture.
  ///
  /// In en, this message translates to:
  /// **'Expiration time must be in the future.'**
  String get publishKeyExpirationMustBeFuture;

  /// No description provided for @audioAndVideo.
  ///
  /// In en, this message translates to:
  /// **'Audio and video'**
  String get audioAndVideo;

  /// No description provided for @videoOnly.
  ///
  /// In en, this message translates to:
  /// **'Video only'**
  String get videoOnly;

  /// No description provided for @audioOnly.
  ///
  /// In en, this message translates to:
  /// **'Audio only'**
  String get audioOnly;

  /// No description provided for @publishAddressGeneratedDescription.
  ///
  /// In en, this message translates to:
  /// **'A publishing address and Stream Key will be generated'**
  String get publishAddressGeneratedDescription;

  /// No description provided for @copyToStreamingToolDescription.
  ///
  /// In en, this message translates to:
  /// **'Copy them to OBS or another streaming tool to start streaming.'**
  String get copyToStreamingToolDescription;

  /// No description provided for @createPublishingEntry.
  ///
  /// In en, this message translates to:
  /// **'Create publishing entry'**
  String get createPublishingEntry;

  /// No description provided for @sourceAddress.
  ///
  /// In en, this message translates to:
  /// **'Source address'**
  String get sourceAddress;

  /// No description provided for @liveSourceAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter an address matching the selected protocol'**
  String get liveSourceAddressHint;

  /// No description provided for @rtspTransport.
  ///
  /// In en, this message translates to:
  /// **'RTSP transport'**
  String get rtspTransport;

  /// No description provided for @videoTrack.
  ///
  /// In en, this message translates to:
  /// **'Video track'**
  String get videoTrack;

  /// No description provided for @audioTrack.
  ///
  /// In en, this message translates to:
  /// **'Audio track'**
  String get audioTrack;

  /// No description provided for @firstCompatibleTrack.
  ///
  /// In en, this message translates to:
  /// **'First compatible'**
  String get firstCompatibleTrack;

  /// No description provided for @trackIndex.
  ///
  /// In en, this message translates to:
  /// **'Track index'**
  String get trackIndex;

  /// No description provided for @optionalLiveName.
  ///
  /// In en, this message translates to:
  /// **'Live stream name (optional)'**
  String get optionalLiveName;

  /// No description provided for @optionalLiveNameHint.
  ///
  /// In en, this message translates to:
  /// **'For example, upstream stream or event feed'**
  String get optionalLiveNameHint;

  /// No description provided for @serverPullsUpstreamLiveSource.
  ///
  /// In en, this message translates to:
  /// **'The SyncTV server pulls the upstream live source'**
  String get serverPullsUpstreamLiveSource;

  /// No description provided for @livePullSupportDescription.
  ///
  /// In en, this message translates to:
  /// **'Supports RTMP, RTSP, and HTTP-FLV sources.'**
  String get livePullSupportDescription;

  /// No description provided for @addLivePull.
  ///
  /// In en, this message translates to:
  /// **'Add live stream pull'**
  String get addLivePull;

  /// No description provided for @unknownTitle.
  ///
  /// In en, this message translates to:
  /// **'Unknown title'**
  String get unknownTitle;

  /// No description provided for @bilibiliAccount.
  ///
  /// In en, this message translates to:
  /// **'Bilibili account'**
  String get bilibiliAccount;

  /// No description provided for @bilibiliVideoLink.
  ///
  /// In en, this message translates to:
  /// **'Video link / BV number'**
  String get bilibiliVideoLink;

  /// No description provided for @bilibiliVideoLinkHint.
  ///
  /// In en, this message translates to:
  /// **'Paste a link to parse it automatically'**
  String get bilibiliVideoLinkHint;

  /// No description provided for @parseBilibiliLink.
  ///
  /// In en, this message translates to:
  /// **'Parse Bilibili link'**
  String get parseBilibiliLink;

  /// No description provided for @pasteBilibiliLink.
  ///
  /// In en, this message translates to:
  /// **'Paste a Bilibili link'**
  String get pasteBilibiliLink;

  /// No description provided for @bilibiliSupportedLinks.
  ///
  /// In en, this message translates to:
  /// **'Supports BV numbers, video links, and live room links.'**
  String get bilibiliSupportedLinks;

  /// No description provided for @noFiles.
  ///
  /// In en, this message translates to:
  /// **'No files'**
  String get noFiles;

  /// No description provided for @noMediaInDirectory.
  ///
  /// In en, this message translates to:
  /// **'This directory has no media resources to add.'**
  String get noMediaInDirectory;

  /// No description provided for @addAsDynamicPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add as dynamic playlist'**
  String get addAsDynamicPlaylist;

  /// No description provided for @addSelectedItems.
  ///
  /// In en, this message translates to:
  /// **'Add {count, plural, =1{the selected item} other{{count} selected items}}'**
  String addSelectedItems(int count);

  /// No description provided for @noMedia.
  ///
  /// In en, this message translates to:
  /// **'No media'**
  String get noMedia;

  /// No description provided for @noMediaLibraryItems.
  ///
  /// In en, this message translates to:
  /// **'This media library directory has no items to add.'**
  String get noMediaLibraryItems;

  /// No description provided for @parentDirectory.
  ///
  /// In en, this message translates to:
  /// **'Parent directory'**
  String get parentDirectory;

  /// No description provided for @parentPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Parent playlist'**
  String get parentPlaylist;

  /// No description provided for @mediaSourceAccount.
  ///
  /// In en, this message translates to:
  /// **'Media source account'**
  String get mediaSourceAccount;

  /// No description provided for @searchCurrentDirectory.
  ///
  /// In en, this message translates to:
  /// **'Search this directory'**
  String get searchCurrentDirectory;

  /// No description provided for @directoryPassword.
  ///
  /// In en, this message translates to:
  /// **'Directory password'**
  String get directoryPassword;

  /// No description provided for @clearDirectoryPassword.
  ///
  /// In en, this message translates to:
  /// **'Clear directory password'**
  String get clearDirectoryPassword;

  /// No description provided for @searchMediaLibrary.
  ///
  /// In en, this message translates to:
  /// **'Search media library'**
  String get searchMediaLibrary;

  /// No description provided for @videoNumber.
  ///
  /// In en, this message translates to:
  /// **'Video {number}'**
  String videoNumber(int number);

  /// No description provided for @liveRoomNumber.
  ///
  /// In en, this message translates to:
  /// **'Live room {number}'**
  String liveRoomNumber(int number);

  /// No description provided for @selectMedia.
  ///
  /// In en, this message translates to:
  /// **'Select media'**
  String get selectMedia;

  /// No description provided for @providerNotBound.
  ///
  /// In en, this message translates to:
  /// **'{provider} is not bound'**
  String providerNotBound(String provider);

  /// No description provided for @bindAccountToAccessResources.
  ///
  /// In en, this message translates to:
  /// **'Bind an account to access resources'**
  String get bindAccountToAccessResources;

  /// No description provided for @bindProviderNow.
  ///
  /// In en, this message translates to:
  /// **'Bind {provider} now'**
  String bindProviderNow(String provider);

  /// No description provided for @localInstance.
  ///
  /// In en, this message translates to:
  /// **'Local instance'**
  String get localInstance;

  /// No description provided for @directLinkVideo.
  ///
  /// In en, this message translates to:
  /// **'Direct-link video'**
  String get directLinkVideo;

  /// No description provided for @completeBlankRequestHeader.
  ///
  /// In en, this message translates to:
  /// **'Complete the empty request header first'**
  String get completeBlankRequestHeader;

  /// No description provided for @completeRequestHeaderNameAndValue.
  ///
  /// In en, this message translates to:
  /// **'Enter both the request header name and value'**
  String get completeRequestHeaderNameAndValue;

  /// No description provided for @duplicateRequestHeader.
  ///
  /// In en, this message translates to:
  /// **'Request header {name} is duplicated'**
  String duplicateRequestHeader(String name);

  /// No description provided for @discardCurrentEdits.
  ///
  /// In en, this message translates to:
  /// **'Discard current edits?'**
  String get discardCurrentEdits;

  /// No description provided for @discardMediaDraftDescription.
  ///
  /// In en, this message translates to:
  /// **'The entered media links, live source, name, and request headers will be cleared.'**
  String get discardMediaDraftDescription;

  /// No description provided for @continueEditing.
  ///
  /// In en, this message translates to:
  /// **'Continue editing'**
  String get continueEditing;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @addedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Added successfully'**
  String get addedSuccessfully;

  /// No description provided for @itemsAdded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item added} other{{count} items added}}'**
  String itemsAdded(int count);

  /// No description provided for @addFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not add media: {error}'**
  String addFailed(String error);

  /// No description provided for @confirmAdd.
  ///
  /// In en, this message translates to:
  /// **'Confirm and add'**
  String get confirmAdd;

  /// No description provided for @enterHttpLinks.
  ///
  /// In en, this message translates to:
  /// **'Enter an HTTP or HTTPS link'**
  String get enterHttpLinks;

  /// No description provided for @rtmpLive.
  ///
  /// In en, this message translates to:
  /// **'RTMP live stream'**
  String get rtmpLive;

  /// No description provided for @createPublishingEntryFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the publishing entry: {error}'**
  String createPublishingEntryFailed(String error);

  /// No description provided for @addLivePullFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not add the live stream pull: {error}'**
  String addLivePullFailed(String error);

  /// No description provided for @enterLiveSourceAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter a live source address'**
  String get enterLiveSourceAddress;

  /// No description provided for @enterValidLiveSourceAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid live source address'**
  String get enterValidLiveSourceAddress;

  /// No description provided for @livePullUrlSupport.
  ///
  /// In en, this message translates to:
  /// **'The address must match the selected RTMP, RTSP, or HTTP-FLV protocol'**
  String get livePullUrlSupport;

  /// No description provided for @selectRtspTrack.
  ///
  /// In en, this message translates to:
  /// **'Enable at least one RTSP track'**
  String get selectRtspTrack;

  /// No description provided for @enterValidTrackIndex.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid track index'**
  String get enterValidTrackIndex;

  /// No description provided for @publishingAddress.
  ///
  /// In en, this message translates to:
  /// **'Publishing address'**
  String get publishingAddress;

  /// No description provided for @publishingHost.
  ///
  /// In en, this message translates to:
  /// **'Publishing host'**
  String get publishingHost;

  /// No description provided for @tsDisguise.
  ///
  /// In en, this message translates to:
  /// **'TS disguise'**
  String get tsDisguise;

  /// No description provided for @pngDisguiseEnabled.
  ///
  /// In en, this message translates to:
  /// **'PNG disguise enabled'**
  String get pngDisguiseEnabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @expirationTime.
  ///
  /// In en, this message translates to:
  /// **'Expiration time'**
  String get expirationTime;

  /// No description provided for @currentStatus.
  ///
  /// In en, this message translates to:
  /// **'Current status'**
  String get currentStatus;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @useServerPublishingHost.
  ///
  /// In en, this message translates to:
  /// **'Use the server default publishing host'**
  String get useServerPublishingHost;

  /// No description provided for @liveSegmentsAsPng.
  ///
  /// In en, this message translates to:
  /// **'Live segments are distributed as PNG files'**
  String get liveSegmentsAsPng;

  /// No description provided for @liveSegmentsAsTs.
  ///
  /// In en, this message translates to:
  /// **'Live segments are distributed as TS files'**
  String get liveSegmentsAsTs;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @parseFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not parse the media: {error}'**
  String parseFailed(String error);

  /// No description provided for @bilibiliVideoInfoUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not get Bilibili video information'**
  String get bilibiliVideoInfoUnavailable;

  /// No description provided for @bilibiliLiveRoomIdUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not get the Bilibili live room ID'**
  String get bilibiliLiveRoomIdUnavailable;

  /// No description provided for @bilibiliCidUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not get the Bilibili CID'**
  String get bilibiliCidUnavailable;

  /// No description provided for @bilibiliIdentifiersUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not get the BVID or CID'**
  String get bilibiliIdentifiersUnavailable;

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load data: {error}'**
  String loadFailed(String error);

  /// No description provided for @chooseBoundAlistAccount.
  ///
  /// In en, this message translates to:
  /// **'Choose a bound AList account'**
  String get chooseBoundAlistAccount;

  /// No description provided for @dynamicPlaylistAdded.
  ///
  /// In en, this message translates to:
  /// **'Dynamic playlist added'**
  String get dynamicPlaylistAdded;

  /// No description provided for @batchAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not add the selected items: {error}'**
  String batchAddFailed(String error);

  /// No description provided for @chooseBoundEmbyAccount.
  ///
  /// In en, this message translates to:
  /// **'Choose a bound Emby account'**
  String get chooseBoundEmbyAccount;

  /// No description provided for @embyMediaIdUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not get the Emby media ID'**
  String get embyMediaIdUnavailable;

  /// No description provided for @embyDirectoryIdUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not get the Emby directory ID'**
  String get embyDirectoryIdUnavailable;

  /// No description provided for @manageConnections.
  ///
  /// In en, this message translates to:
  /// **'Manage connections'**
  String get manageConnections;

  /// No description provided for @bilibiliBound.
  ///
  /// In en, this message translates to:
  /// **'Bilibili bound'**
  String get bilibiliBound;

  /// No description provided for @loadProviderBindingsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load {provider} bindings: {error}'**
  String loadProviderBindingsFailed(String provider, String error);

  /// No description provided for @confirmUnbind.
  ///
  /// In en, this message translates to:
  /// **'Confirm unbinding'**
  String get confirmUnbind;

  /// No description provided for @confirmUnbindProvider.
  ///
  /// In en, this message translates to:
  /// **'Unbind this {provider} account?'**
  String confirmUnbindProvider(String provider);

  /// No description provided for @unbind.
  ///
  /// In en, this message translates to:
  /// **'Unbind'**
  String get unbind;

  /// No description provided for @unboundSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account unbound'**
  String get unboundSuccessfully;

  /// No description provided for @unbindFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not unbind the account: {error}'**
  String unbindFailed(String error);

  /// No description provided for @bindProvider.
  ///
  /// In en, this message translates to:
  /// **'Bind {provider}'**
  String bindProvider(String provider);

  /// No description provided for @providerDetails.
  ///
  /// In en, this message translates to:
  /// **'{provider} details'**
  String providerDetails(String provider);

  /// No description provided for @loadDetailsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load details: {error}'**
  String loadDetailsFailed(String error);

  /// No description provided for @rootDirectory.
  ///
  /// In en, this message translates to:
  /// **'Root directory'**
  String get rootDirectory;

  /// No description provided for @mediaLibraryRoot.
  ///
  /// In en, this message translates to:
  /// **'Media library root'**
  String get mediaLibraryRoot;

  /// No description provided for @userId.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userId;

  /// No description provided for @instance.
  ///
  /// In en, this message translates to:
  /// **'Instance'**
  String get instance;

  /// No description provided for @loginStatus.
  ///
  /// In en, this message translates to:
  /// **'Login status'**
  String get loginStatus;

  /// No description provided for @loggedIn.
  ///
  /// In en, this message translates to:
  /// **'Logged in'**
  String get loggedIn;

  /// No description provided for @loggedOutStatus.
  ///
  /// In en, this message translates to:
  /// **'Logged out'**
  String get loggedOutStatus;

  /// No description provided for @bilibiliVip.
  ///
  /// In en, this message translates to:
  /// **'Bilibili VIP'**
  String get bilibiliVip;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @bilibiliNotBound.
  ///
  /// In en, this message translates to:
  /// **'Bilibili is not bound'**
  String get bilibiliNotBound;

  /// No description provided for @noBoundProviderAccounts.
  ///
  /// In en, this message translates to:
  /// **'No bound {provider} accounts'**
  String noBoundProviderAccounts(String provider);

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @rebindProvider.
  ///
  /// In en, this message translates to:
  /// **'Rebind {provider}'**
  String rebindProvider(String provider);

  /// No description provided for @providerAccount.
  ///
  /// In en, this message translates to:
  /// **'{provider} account {serverId}'**
  String providerAccount(String provider, String serverId);

  /// No description provided for @bilibiliBoundDescription.
  ///
  /// In en, this message translates to:
  /// **'The current account is bound to Bilibili. You can view its status or bind it again.'**
  String get bilibiliBoundDescription;

  /// No description provided for @bilibiliBindingDescription.
  ///
  /// In en, this message translates to:
  /// **'Binding enables Bilibili video, series, and live resource parsing.'**
  String get bilibiliBindingDescription;

  /// No description provided for @viewStatus.
  ///
  /// In en, this message translates to:
  /// **'View status'**
  String get viewStatus;

  /// No description provided for @rebind.
  ///
  /// In en, this message translates to:
  /// **'Rebind'**
  String get rebind;

  /// No description provided for @loadMediaSourceInstancesFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load media source instances: {error}'**
  String loadMediaSourceInstancesFailed(String error);

  /// No description provided for @completeAllFields.
  ///
  /// In en, this message translates to:
  /// **'Complete all required fields'**
  String get completeAllFields;

  /// No description provided for @boundSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account bound'**
  String get boundSuccessfully;

  /// No description provided for @bindingFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not bind the account: {error}'**
  String bindingFailed(String error);

  /// No description provided for @alistVersionRequirement.
  ///
  /// In en, this message translates to:
  /// **'Requires AList 3.25.0 or later'**
  String get alistVersionRequirement;

  /// No description provided for @connectionTarget.
  ///
  /// In en, this message translates to:
  /// **'Connection target'**
  String get connectionTarget;

  /// No description provided for @providerAddress.
  ///
  /// In en, this message translates to:
  /// **'{provider} address'**
  String providerAddress(String provider);

  /// No description provided for @providerAddressHint.
  ///
  /// In en, this message translates to:
  /// **'127.0.0.1 or https://example.com'**
  String get providerAddressHint;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// No description provided for @loginCredentials.
  ///
  /// In en, this message translates to:
  /// **'Login credentials'**
  String get loginCredentials;

  /// No description provided for @twoFactorAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication'**
  String get twoFactorAuthentication;

  /// No description provided for @oneTimeCode.
  ///
  /// In en, this message translates to:
  /// **'One-time code'**
  String get oneTimeCode;

  /// No description provided for @oneTimeCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter when 2FA is enabled'**
  String get oneTimeCodeHint;

  /// No description provided for @totpSecretHint.
  ///
  /// In en, this message translates to:
  /// **'Optional, used for automatic refresh later'**
  String get totpSecretHint;

  /// No description provided for @creatingLoginLink.
  ///
  /// In en, this message translates to:
  /// **'Creating login link...'**
  String get creatingLoginLink;

  /// No description provided for @completeBilibiliLogin.
  ///
  /// In en, this message translates to:
  /// **'Complete login in a browser or the Bilibili app'**
  String get completeBilibiliLogin;

  /// No description provided for @createLoginLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the login link: {error}'**
  String createLoginLinkFailed(String error);

  /// No description provided for @loginLinkExpired.
  ///
  /// In en, this message translates to:
  /// **'The login link expired. Generate a new one.'**
  String get loginLinkExpired;

  /// No description provided for @qrScannedConfirmLogin.
  ///
  /// In en, this message translates to:
  /// **'Code scanned. Confirm login in Bilibili.'**
  String get qrScannedConfirmLogin;

  /// No description provided for @waitingForQrScan.
  ///
  /// In en, this message translates to:
  /// **'Waiting for a scan or for the login link to open'**
  String get waitingForQrScan;

  /// No description provided for @waitingForBilibiliStatus.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Bilibili login status'**
  String get waitingForBilibiliStatus;

  /// No description provided for @bilibiliStatusRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Bilibili login status was checked too frequently. Generate a new login link later.'**
  String get bilibiliStatusRateLimited;

  /// No description provided for @checkLoginStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not check login status: {error}'**
  String checkLoginStatusFailed(String error);

  /// No description provided for @openLoginLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the login link'**
  String get openLoginLinkFailed;

  /// No description provided for @loginLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Login link copied'**
  String get loginLinkCopied;

  /// No description provided for @switchToQrPrompt.
  ///
  /// In en, this message translates to:
  /// **'Switch to the QR tab to generate a login code'**
  String get switchToQrPrompt;

  /// No description provided for @qrCode.
  ///
  /// In en, this message translates to:
  /// **'QR code'**
  String get qrCode;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @openLogin.
  ///
  /// In en, this message translates to:
  /// **'Open login'**
  String get openLogin;

  /// No description provided for @regenerate.
  ///
  /// In en, this message translates to:
  /// **'Regenerate'**
  String get regenerate;

  /// No description provided for @switchToCodePrompt.
  ///
  /// In en, this message translates to:
  /// **'Switch to the code tab to prepare security verification'**
  String get switchToCodePrompt;

  /// No description provided for @preparingSecurityVerification.
  ///
  /// In en, this message translates to:
  /// **'Preparing security verification...'**
  String get preparingSecurityVerification;

  /// No description provided for @enterPhoneForSecurityVerification.
  ///
  /// In en, this message translates to:
  /// **'Enter a phone number and complete security verification to send an SMS code'**
  String get enterPhoneForSecurityVerification;

  /// No description provided for @prepareSecurityVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not prepare security verification: {error}'**
  String prepareSecurityVerificationFailed(String error);

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a phone number'**
  String get enterPhoneNumber;

  /// No description provided for @completeBilibiliSecurityVerification.
  ///
  /// In en, this message translates to:
  /// **'Complete Bilibili security verification'**
  String get completeBilibiliSecurityVerification;

  /// No description provided for @smsCodeSent.
  ///
  /// In en, this message translates to:
  /// **'SMS verification code sent'**
  String get smsCodeSent;

  /// No description provided for @verificationSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'The verification session expired. Restart SMS login.'**
  String get verificationSessionExpired;

  /// No description provided for @sendSmsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send the SMS: {error}'**
  String sendSmsFailed(String error);

  /// No description provided for @sendSmsFirst.
  ///
  /// In en, this message translates to:
  /// **'Send an SMS verification code first'**
  String get sendSmsFirst;

  /// No description provided for @enterSmsCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the SMS verification code'**
  String get enterSmsCode;

  /// No description provided for @completingBilibiliBinding.
  ///
  /// In en, this message translates to:
  /// **'Completing Bilibili binding...'**
  String get completingBilibiliBinding;

  /// No description provided for @loginSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'The login session expired. Verify again before sending an SMS.'**
  String get loginSessionExpired;

  /// No description provided for @authenticationSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'The authentication session expired. Start again.'**
  String get authenticationSessionExpired;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @bilibiliPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone number linked to Bilibili'**
  String get bilibiliPhoneHint;

  /// No description provided for @smsVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'SMS verification code'**
  String get smsVerificationCode;

  /// No description provided for @enterReceivedCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the code you received'**
  String get enterReceivedCode;

  /// No description provided for @enterCodeAfterSms.
  ///
  /// In en, this message translates to:
  /// **'Send an SMS, then enter the code'**
  String get enterCodeAfterSms;

  /// No description provided for @verifyAgain.
  ///
  /// In en, this message translates to:
  /// **'Verify again'**
  String get verifyAgain;

  /// No description provided for @sendSms.
  ///
  /// In en, this message translates to:
  /// **'Send SMS'**
  String get sendSms;

  /// No description provided for @bind.
  ///
  /// In en, this message translates to:
  /// **'Bind'**
  String get bind;

  /// No description provided for @mediaSourceInstance.
  ///
  /// In en, this message translates to:
  /// **'Media source instance'**
  String get mediaSourceInstance;

  /// No description provided for @loginExpired.
  ///
  /// In en, this message translates to:
  /// **'Your login expired. Log in again.'**
  String get loginExpired;

  /// No description provided for @connectionClosedRetry.
  ///
  /// In en, this message translates to:
  /// **'The connection closed. Exit the room and try again.'**
  String get connectionClosedRetry;

  /// No description provided for @playbackResource.
  ///
  /// In en, this message translates to:
  /// **'playback resource'**
  String get playbackResource;

  /// No description provided for @playlist.
  ///
  /// In en, this message translates to:
  /// **'Playlist'**
  String get playlist;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorMessage(String message);

  /// No description provided for @messageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Message deleted'**
  String get messageDeleted;

  /// No description provided for @imageMessage.
  ///
  /// In en, this message translates to:
  /// **'[Image]'**
  String get imageMessage;

  /// No description provided for @genericMessage.
  ///
  /// In en, this message translates to:
  /// **'[Message]'**
  String get genericMessage;

  /// No description provided for @quotedMessageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The quoted message is outside the currently available range'**
  String get quotedMessageUnavailable;

  /// No description provided for @loadQuotedContextFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the quoted message context: {error}'**
  String loadQuotedContextFailed(String error);

  /// No description provided for @serverSnapshotMissing.
  ///
  /// In en, this message translates to:
  /// **'The server did not send a {resource} snapshot'**
  String serverSnapshotMissing(String resource);

  /// No description provided for @latencyValue.
  ///
  /// In en, this message translates to:
  /// **'Latency {value}'**
  String latencyValue(String value);

  /// No description provided for @serverLatency.
  ///
  /// In en, this message translates to:
  /// **'Server latency'**
  String get serverLatency;

  /// No description provided for @deviationValue.
  ///
  /// In en, this message translates to:
  /// **'Drift {value}'**
  String deviationValue(String value);

  /// No description provided for @playbackDeviation.
  ///
  /// In en, this message translates to:
  /// **'Playback drift'**
  String get playbackDeviation;

  /// No description provided for @playbackUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update playback state'**
  String get playbackUpdateFailed;

  /// No description provided for @switchedToPlaybackRoute.
  ///
  /// In en, this message translates to:
  /// **'Switched to {route}'**
  String switchedToPlaybackRoute(String route);

  /// No description provided for @playbackRoute.
  ///
  /// In en, this message translates to:
  /// **'Playback route'**
  String get playbackRoute;

  /// No description provided for @route.
  ///
  /// In en, this message translates to:
  /// **'Route'**
  String get route;

  /// No description provided for @qualityAndMediaLinks.
  ///
  /// In en, this message translates to:
  /// **'Quality and media links'**
  String get qualityAndMediaLinks;

  /// No description provided for @manifestQualities.
  ///
  /// In en, this message translates to:
  /// **'Manifest qualities'**
  String get manifestQualities;

  /// No description provided for @automatic.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get automatic;

  /// No description provided for @selectPlaybackRoute.
  ///
  /// In en, this message translates to:
  /// **'Choose route'**
  String get selectPlaybackRoute;

  /// No description provided for @playbackRouteMain.
  ///
  /// In en, this message translates to:
  /// **'Main route'**
  String get playbackRouteMain;

  /// No description provided for @playbackRouteBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup route {index}'**
  String playbackRouteBackup(int index);

  /// No description provided for @playbackRouteOriginal.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get playbackRouteOriginal;

  /// No description provided for @playbackRouteProgressive.
  ///
  /// In en, this message translates to:
  /// **'Standard video'**
  String get playbackRouteProgressive;

  /// No description provided for @playbackRouteTranscoded.
  ///
  /// In en, this message translates to:
  /// **'Transcoded'**
  String get playbackRouteTranscoded;

  /// No description provided for @playbackRouteVideoHls.
  ///
  /// In en, this message translates to:
  /// **'Video HLS'**
  String get playbackRouteVideoHls;

  /// No description provided for @playbackRouteAudioHls.
  ///
  /// In en, this message translates to:
  /// **'Audio HLS'**
  String get playbackRouteAudioHls;

  /// No description provided for @qualityTrack.
  ///
  /// In en, this message translates to:
  /// **'Quality {id}'**
  String qualityTrack(String id);

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @freeModeSettings.
  ///
  /// In en, this message translates to:
  /// **'Free mode settings'**
  String get freeModeSettings;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @stopPlayback.
  ///
  /// In en, this message translates to:
  /// **'Stop playback'**
  String get stopPlayback;

  /// No description provided for @roomManagement.
  ///
  /// In en, this message translates to:
  /// **'Room management'**
  String get roomManagement;

  /// No description provided for @unknownVideo.
  ///
  /// In en, this message translates to:
  /// **'Unknown video'**
  String get unknownVideo;

  /// No description provided for @roomCollaboration.
  ///
  /// In en, this message translates to:
  /// **'Room collaboration'**
  String get roomCollaboration;

  /// No description provided for @peopleCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No people} =1{1 person} other{{count} people}}'**
  String peopleCount(int count);

  /// No description provided for @copyInviteLink.
  ///
  /// In en, this message translates to:
  /// **'Copy invitation link'**
  String get copyInviteLink;

  /// No description provided for @syncedToLatestProgress.
  ///
  /// In en, this message translates to:
  /// **'Synced to the latest position'**
  String get syncedToLatestProgress;

  /// No description provided for @playbackAddressReloaded.
  ///
  /// In en, this message translates to:
  /// **'Playback address reloaded'**
  String get playbackAddressReloaded;

  /// No description provided for @reloadPlaybackAddressFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not reload the playback address'**
  String get reloadPlaybackAddressFailed;

  /// No description provided for @secondsValue.
  ///
  /// In en, this message translates to:
  /// **'{value} seconds'**
  String secondsValue(String value);

  /// No description provided for @freeMode.
  ///
  /// In en, this message translates to:
  /// **'Free mode'**
  String get freeMode;

  /// No description provided for @freeModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep your local playback position independent from realtime room corrections. Manual sync remains available.'**
  String get freeModeDescription;

  /// No description provided for @syncCorrectionThreshold.
  ///
  /// In en, this message translates to:
  /// **'Room sync correction threshold'**
  String get syncCorrectionThreshold;

  /// No description provided for @manualSyncDriftThreshold.
  ///
  /// In en, this message translates to:
  /// **'Minimum drift for manual sync'**
  String get manualSyncDriftThreshold;

  /// No description provided for @restoreDefaults.
  ///
  /// In en, this message translates to:
  /// **'Restore defaults'**
  String get restoreDefaults;

  /// No description provided for @freeModeSettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Free mode settings saved'**
  String get freeModeSettingsSaved;

  /// No description provided for @loadMemberListFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the member list'**
  String get loadMemberListFailed;

  /// No description provided for @sendDanmakuFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send danmaku: {error}'**
  String sendDanmakuFailed(String error);

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @list.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @realtime.
  ///
  /// In en, this message translates to:
  /// **'Realtime'**
  String get realtime;

  /// No description provided for @realtimeEventsWebSocketDescription.
  ///
  /// In en, this message translates to:
  /// **'Realtime events appear after WebSocket messages are sent or received'**
  String get realtimeEventsWebSocketDescription;

  /// No description provided for @scrollToBottom.
  ///
  /// In en, this message translates to:
  /// **'Scroll to bottom'**
  String get scrollToBottom;

  /// No description provided for @pinned.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get pinned;

  /// No description provided for @refreshPinnedMessages.
  ///
  /// In en, this message translates to:
  /// **'Refresh pinned messages'**
  String get refreshPinnedMessages;

  /// No description provided for @unpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get unpin;

  /// No description provided for @replyingTo.
  ///
  /// In en, this message translates to:
  /// **'Replying to {user}'**
  String replyingTo(String user);

  /// No description provided for @cancelReply.
  ///
  /// In en, this message translates to:
  /// **'Cancel reply'**
  String get cancelReply;

  /// No description provided for @edited.
  ///
  /// In en, this message translates to:
  /// **'Edited'**
  String get edited;

  /// No description provided for @mentionRead.
  ///
  /// In en, this message translates to:
  /// **'@ read'**
  String get mentionRead;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @readUnreadSummary.
  ///
  /// In en, this message translates to:
  /// **'{read} read · {unread} unread'**
  String readUnreadSummary(int read, int unread);

  /// No description provided for @viewMentionReadDetails.
  ///
  /// In en, this message translates to:
  /// **'View @ read details'**
  String get viewMentionReadDetails;

  /// No description provided for @viewReadDetails.
  ///
  /// In en, this message translates to:
  /// **'View read details'**
  String get viewReadDetails;

  /// No description provided for @mentionUnread.
  ///
  /// In en, this message translates to:
  /// **'@ unread'**
  String get mentionUnread;

  /// No description provided for @mentionReadUnreadSummary.
  ///
  /// In en, this message translates to:
  /// **'@ {read} read · {unread} unread'**
  String mentionReadUnreadSummary(int read, int unread);

  /// No description provided for @loadReadDetailsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load read details: {error}'**
  String loadReadDetailsFailed(String error);

  /// No description provided for @quotedMessage.
  ///
  /// In en, this message translates to:
  /// **'Quoted message'**
  String get quotedMessage;

  /// No description provided for @loadingQuotedMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading quoted message...'**
  String get loadingQuotedMessage;

  /// No description provided for @jumpToQuotedMessage.
  ///
  /// In en, this message translates to:
  /// **'Jump to quoted message'**
  String get jumpToQuotedMessage;

  /// No description provided for @reactionSelectedHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to remove reaction; long press to view members'**
  String get reactionSelectedHint;

  /// No description provided for @reactionUnselectedHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to add reaction; long press to view members'**
  String get reactionUnselectedHint;

  /// No description provided for @react.
  ///
  /// In en, this message translates to:
  /// **'React'**
  String get react;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get pin;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @removeReaction.
  ///
  /// In en, this message translates to:
  /// **'Remove reaction {reaction}'**
  String removeReaction(String reaction);

  /// No description provided for @addReaction.
  ///
  /// In en, this message translates to:
  /// **'React with {reaction}'**
  String addReaction(String reaction);

  /// No description provided for @closeMessageActions.
  ///
  /// In en, this message translates to:
  /// **'Close message actions'**
  String get closeMessageActions;

  /// No description provided for @reactionFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the reaction: {error}'**
  String reactionFailed(String error);

  /// No description provided for @noCopyableMessageText.
  ///
  /// In en, this message translates to:
  /// **'This message has no text to copy'**
  String get noCopyableMessageText;

  /// No description provided for @messageCopied.
  ///
  /// In en, this message translates to:
  /// **'Message copied'**
  String get messageCopied;

  /// No description provided for @messageUnpinned.
  ///
  /// In en, this message translates to:
  /// **'Message unpinned'**
  String get messageUnpinned;

  /// No description provided for @messagePinned.
  ///
  /// In en, this message translates to:
  /// **'Message pinned'**
  String get messagePinned;

  /// No description provided for @unpinMessageFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not unpin the message: {error}'**
  String unpinMessageFailed(String error);

  /// No description provided for @pinMessageFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not pin the message: {error}'**
  String pinMessageFailed(String error);

  /// No description provided for @deleteMessageFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the message: {error}'**
  String deleteMessageFailed(String error);

  /// No description provided for @reportMessage.
  ///
  /// In en, this message translates to:
  /// **'Report message'**
  String get reportMessage;

  /// No description provided for @reportMember.
  ///
  /// In en, this message translates to:
  /// **'Report member'**
  String get reportMember;

  /// No description provided for @reportUser.
  ///
  /// In en, this message translates to:
  /// **'Report user'**
  String get reportUser;

  /// No description provided for @reportReasonSpam.
  ///
  /// In en, this message translates to:
  /// **'Spam or advertising'**
  String get reportReasonSpam;

  /// No description provided for @reportReasonAbuse.
  ///
  /// In en, this message translates to:
  /// **'Abuse or harassment'**
  String get reportReasonAbuse;

  /// No description provided for @reportReasonIllegal.
  ///
  /// In en, this message translates to:
  /// **'Illegal content'**
  String get reportReasonIllegal;

  /// No description provided for @reportReasonSexual.
  ///
  /// In en, this message translates to:
  /// **'Sexual content'**
  String get reportReasonSexual;

  /// No description provided for @reportReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other issue'**
  String get reportReasonOther;

  /// No description provided for @additionalDetails.
  ///
  /// In en, this message translates to:
  /// **'Additional details'**
  String get additionalDetails;

  /// No description provided for @describeIssue.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue'**
  String get describeIssue;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @reportSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Report submitted'**
  String get reportSubmitted;

  /// No description provided for @reportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not submit the report: {error}'**
  String reportFailed(String error);

  /// No description provided for @voiceConnected.
  ///
  /// In en, this message translates to:
  /// **'Voice connected ({count, plural, =1{1 person} other{{count} people}})'**
  String voiceConnected(int count);

  /// No description provided for @voiceConnectedMuted.
  ///
  /// In en, this message translates to:
  /// **'Voice connected ({count, plural, =1{1 person} other{{count} people}}) (muted)'**
  String voiceConnectedMuted(int count);

  /// No description provided for @waitingToJoinVoice.
  ///
  /// In en, this message translates to:
  /// **'Waiting to join... ({count, plural, =1{1 person} other{{count} people}})'**
  String waitingToJoinVoice(int count);

  /// No description provided for @waitingToJoinVoiceMuted.
  ///
  /// In en, this message translates to:
  /// **'Waiting to join... ({count, plural, =1{1 person} other{{count} people}}) (muted)'**
  String waitingToJoinVoiceMuted(int count);

  /// No description provided for @voiceChat.
  ///
  /// In en, this message translates to:
  /// **'Voice chat'**
  String get voiceChat;

  /// No description provided for @roomRealtimeFeatures.
  ///
  /// In en, this message translates to:
  /// **'Realtime communication'**
  String get roomRealtimeFeatures;

  /// No description provided for @voiceChatRoomEnabledDescription.
  ///
  /// In en, this message translates to:
  /// **'Allow members to join voice calls in this room'**
  String get voiceChatRoomEnabledDescription;

  /// No description provided for @voiceChatDisabledByRoom.
  ///
  /// In en, this message translates to:
  /// **'A room administrator disabled voice chat'**
  String get voiceChatDisabledByRoom;

  /// No description provided for @p2pMedia.
  ///
  /// In en, this message translates to:
  /// **'P2P media delivery'**
  String get p2pMedia;

  /// No description provided for @p2pMediaRoomEnabledDescription.
  ///
  /// In en, this message translates to:
  /// **'Allow members to share media data with peers in this room'**
  String get p2pMediaRoomEnabledDescription;

  /// No description provided for @p2pMediaDisabledByRoom.
  ///
  /// In en, this message translates to:
  /// **'A room administrator disabled P2P media delivery'**
  String get p2pMediaDisabledByRoom;

  /// No description provided for @p2pMediaDescription.
  ///
  /// In en, this message translates to:
  /// **'Share cached media directly with room members. Peers can see your network address and use your upload bandwidth. Swarm tickets isolate rooms, users, and resources.'**
  String get p2pMediaDescription;

  /// No description provided for @p2pCacheSize.
  ///
  /// In en, this message translates to:
  /// **'Cache capacity'**
  String get p2pCacheSize;

  /// No description provided for @p2pCacheSizeDescription.
  ///
  /// In en, this message translates to:
  /// **'Persistent LRU cache shared across playback sessions. Entries expire after 10 minutes without access.'**
  String get p2pCacheSizeDescription;

  /// No description provided for @p2pSecurityMode.
  ///
  /// In en, this message translates to:
  /// **'Peer data validation'**
  String get p2pSecurityMode;

  /// No description provided for @p2pSecurityStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get p2pSecurityStandard;

  /// No description provided for @p2pSecurityStandardDescription.
  ///
  /// In en, this message translates to:
  /// **'Checks framing, declared length, size limits, and timeouts. Validation adds no network traffic; scheduling can still race origins and peers.'**
  String get p2pSecurityStandardDescription;

  /// No description provided for @p2pSecuritySampled.
  ///
  /// In en, this message translates to:
  /// **'Origin sampling'**
  String get p2pSecuritySampled;

  /// No description provided for @p2pSecuritySampledDescription.
  ///
  /// In en, this message translates to:
  /// **'Compares 10% of peer pieces with the origin using SHA-256. Conflicting peers are isolated for the current swarm session.'**
  String get p2pSecuritySampledDescription;

  /// No description provided for @p2pIntegrityChecks.
  ///
  /// In en, this message translates to:
  /// **'Integrity checks'**
  String get p2pIntegrityChecks;

  /// No description provided for @p2pIntegrityMismatches.
  ///
  /// In en, this message translates to:
  /// **'Integrity conflicts'**
  String get p2pIntegrityMismatches;

  /// No description provided for @p2pIntegrityUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Origin checks unavailable'**
  String get p2pIntegrityUnavailable;

  /// No description provided for @p2pMetrics.
  ///
  /// In en, this message translates to:
  /// **'P2P transfer metrics'**
  String get p2pMetrics;

  /// No description provided for @totalDownload.
  ///
  /// In en, this message translates to:
  /// **'Total download'**
  String get totalDownload;

  /// No description provided for @totalUpload.
  ///
  /// In en, this message translates to:
  /// **'Total upload'**
  String get totalUpload;

  /// No description provided for @httpDownload.
  ///
  /// In en, this message translates to:
  /// **'HTTP download'**
  String get httpDownload;

  /// No description provided for @p2pDownload.
  ///
  /// In en, this message translates to:
  /// **'P2P download'**
  String get p2pDownload;

  /// No description provided for @p2pUpload.
  ///
  /// In en, this message translates to:
  /// **'P2P upload'**
  String get p2pUpload;

  /// No description provided for @connectedPeers.
  ///
  /// In en, this message translates to:
  /// **'Connected peers'**
  String get connectedPeers;

  /// No description provided for @p2pCache.
  ///
  /// In en, this message translates to:
  /// **'Cached data'**
  String get p2pCache;

  /// No description provided for @cacheHitRate.
  ///
  /// In en, this message translates to:
  /// **'Cache hit rate'**
  String get cacheHitRate;

  /// No description provided for @leaveVoice.
  ///
  /// In en, this message translates to:
  /// **'Leave voice chat'**
  String get leaveVoice;

  /// No description provided for @joining.
  ///
  /// In en, this message translates to:
  /// **'Joining'**
  String get joining;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @joinVoiceTimeout.
  ///
  /// In en, this message translates to:
  /// **'Joining voice timed out. Check microphone permission.'**
  String get joinVoiceTimeout;

  /// No description provided for @joinVoiceFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not join voice chat: {error}'**
  String joinVoiceFailed(String error);

  /// No description provided for @cancelSelection.
  ///
  /// In en, this message translates to:
  /// **'Cancel selection'**
  String get cancelSelection;

  /// No description provided for @batchManage.
  ///
  /// In en, this message translates to:
  /// **'Batch manage'**
  String get batchManage;

  /// No description provided for @compactList.
  ///
  /// In en, this message translates to:
  /// **'Compact list'**
  String get compactList;

  /// No description provided for @detailedList.
  ///
  /// In en, this message translates to:
  /// **'Detailed list'**
  String get detailedList;

  /// No description provided for @grid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get grid;

  /// No description provided for @sourceType.
  ///
  /// In en, this message translates to:
  /// **'Source type'**
  String get sourceType;

  /// No description provided for @sourcePath.
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get sourcePath;

  /// No description provided for @sourceQuery.
  ///
  /// In en, this message translates to:
  /// **'Query'**
  String get sourceQuery;

  /// No description provided for @sharedSource.
  ///
  /// In en, this message translates to:
  /// **'Shared source'**
  String get sharedSource;

  /// No description provided for @shareMyCredentials.
  ///
  /// In en, this message translates to:
  /// **'Share my credentials'**
  String get shareMyCredentials;

  /// No description provided for @parseLink.
  ///
  /// In en, this message translates to:
  /// **'Parse link'**
  String get parseLink;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @noItems.
  ///
  /// In en, this message translates to:
  /// **'No items'**
  String get noItems;

  /// No description provided for @addCurrentList.
  ///
  /// In en, this message translates to:
  /// **'Add current list'**
  String get addCurrentList;

  /// No description provided for @addSelectedCount.
  ///
  /// In en, this message translates to:
  /// **'Add selected ({count})'**
  String addSelectedCount(int count);

  /// No description provided for @selectItem.
  ///
  /// In en, this message translates to:
  /// **'Select {name}'**
  String selectItem(String name);

  /// No description provided for @playlistName.
  ///
  /// In en, this message translates to:
  /// **'Playlist name'**
  String get playlistName;

  /// No description provided for @providerInstance.
  ///
  /// In en, this message translates to:
  /// **'Provider instance'**
  String get providerInstance;

  /// No description provided for @defaultMediaSource.
  ///
  /// In en, this message translates to:
  /// **'Default media source'**
  String get defaultMediaSource;

  /// No description provided for @defaultProviderInstance.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultProviderInstance;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @videos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videos;

  /// No description provided for @shorts.
  ///
  /// In en, this message translates to:
  /// **'Shorts'**
  String get shorts;

  /// No description provided for @posts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get posts;

  /// No description provided for @channel.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get channel;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @likedVideos.
  ///
  /// In en, this message translates to:
  /// **'Liked videos'**
  String get likedVideos;

  /// No description provided for @watchLater.
  ///
  /// In en, this message translates to:
  /// **'Watch later'**
  String get watchLater;

  /// No description provided for @movie.
  ///
  /// In en, this message translates to:
  /// **'Movie'**
  String get movie;

  /// No description provided for @movies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get movies;

  /// No description provided for @episode.
  ///
  /// In en, this message translates to:
  /// **'Episode'**
  String get episode;

  /// No description provided for @episodes.
  ///
  /// In en, this message translates to:
  /// **'Episodes'**
  String get episodes;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @folder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get folder;

  /// No description provided for @series.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get series;

  /// No description provided for @bangumi.
  ///
  /// In en, this message translates to:
  /// **'Bangumi'**
  String get bangumi;

  /// No description provided for @vod.
  ///
  /// In en, this message translates to:
  /// **'VOD'**
  String get vod;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popular;

  /// No description provided for @recommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommended;

  /// No description provided for @videoParts.
  ///
  /// In en, this message translates to:
  /// **'Video parts'**
  String get videoParts;

  /// No description provided for @creatorVideos.
  ///
  /// In en, this message translates to:
  /// **'Creator videos'**
  String get creatorVideos;

  /// No description provided for @favoriteVideos.
  ///
  /// In en, this message translates to:
  /// **'Favorite videos'**
  String get favoriteVideos;

  /// No description provided for @collectionVideos.
  ///
  /// In en, this message translates to:
  /// **'Collection videos'**
  String get collectionVideos;

  /// No description provided for @seriesVideos.
  ///
  /// In en, this message translates to:
  /// **'Series videos'**
  String get seriesVideos;

  /// No description provided for @pgcSeason.
  ///
  /// In en, this message translates to:
  /// **'PGC season'**
  String get pgcSeason;

  /// No description provided for @liveRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended live streams'**
  String get liveRecommended;

  /// No description provided for @liveFollowed.
  ///
  /// In en, this message translates to:
  /// **'Followed live streams'**
  String get liveFollowed;

  /// No description provided for @liveArea.
  ///
  /// In en, this message translates to:
  /// **'Live category'**
  String get liveArea;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @pgcTimeline.
  ///
  /// In en, this message translates to:
  /// **'PGC timeline'**
  String get pgcTimeline;

  /// No description provided for @pgcIndex.
  ///
  /// In en, this message translates to:
  /// **'PGC index'**
  String get pgcIndex;

  /// No description provided for @followedAnime.
  ///
  /// In en, this message translates to:
  /// **'Followed anime'**
  String get followedAnime;

  /// No description provided for @followedCinema.
  ///
  /// In en, this message translates to:
  /// **'Followed cinema'**
  String get followedCinema;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// No description provided for @keyword.
  ///
  /// In en, this message translates to:
  /// **'Keyword'**
  String get keyword;

  /// No description provided for @liveCategory.
  ///
  /// In en, this message translates to:
  /// **'Live category'**
  String get liveCategory;

  /// No description provided for @liveSubcategory.
  ///
  /// In en, this message translates to:
  /// **'Live subcategory'**
  String get liveSubcategory;

  /// No description provided for @favoriteFolder.
  ///
  /// In en, this message translates to:
  /// **'Favorite folder'**
  String get favoriteFolder;

  /// No description provided for @privateLabel.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get privateLabel;

  /// No description provided for @continueWatching.
  ///
  /// In en, this message translates to:
  /// **'Continue watching'**
  String get continueWatching;

  /// No description provided for @nextUp.
  ///
  /// In en, this message translates to:
  /// **'Next up'**
  String get nextUp;

  /// No description provided for @recentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently added'**
  String get recentlyAdded;

  /// No description provided for @favoritePeople.
  ///
  /// In en, this message translates to:
  /// **'Favorite people'**
  String get favoritePeople;

  /// No description provided for @serverPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Server playlists'**
  String get serverPlaylists;

  /// No description provided for @collections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get collections;

  /// No description provided for @genres.
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get genres;

  /// No description provided for @files.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get files;

  /// No description provided for @mediaLibrary.
  ///
  /// In en, this message translates to:
  /// **'Media library'**
  String get mediaLibrary;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @starred.
  ///
  /// In en, this message translates to:
  /// **'Starred'**
  String get starred;

  /// No description provided for @libraries.
  ///
  /// In en, this message translates to:
  /// **'Libraries'**
  String get libraries;

  /// No description provided for @tvShows.
  ///
  /// In en, this message translates to:
  /// **'TV shows'**
  String get tvShows;

  /// No description provided for @homeVideos.
  ///
  /// In en, this message translates to:
  /// **'Home videos'**
  String get homeVideos;

  /// No description provided for @tvRecordings.
  ///
  /// In en, this message translates to:
  /// **'TV recordings'**
  String get tvRecordings;

  /// No description provided for @mediaUrl.
  ///
  /// In en, this message translates to:
  /// **'Media URL'**
  String get mediaUrl;

  /// No description provided for @channelArchive.
  ///
  /// In en, this message translates to:
  /// **'Channel archive'**
  String get channelArchive;

  /// No description provided for @followedLive.
  ///
  /// In en, this message translates to:
  /// **'Followed live'**
  String get followedLive;

  /// No description provided for @categoryLive.
  ///
  /// In en, this message translates to:
  /// **'Live by category'**
  String get categoryLive;

  /// No description provided for @searchLive.
  ///
  /// In en, this message translates to:
  /// **'Search live channels'**
  String get searchLive;

  /// No description provided for @highlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get highlights;

  /// No description provided for @uploads.
  ///
  /// In en, this message translates to:
  /// **'Uploads'**
  String get uploads;

  /// No description provided for @clips.
  ///
  /// In en, this message translates to:
  /// **'Clips'**
  String get clips;

  /// No description provided for @loadCategories.
  ///
  /// In en, this message translates to:
  /// **'Load categories'**
  String get loadCategories;

  /// No description provided for @noScheduledStreams.
  ///
  /// In en, this message translates to:
  /// **'No scheduled streams'**
  String get noScheduledStreams;

  /// No description provided for @videoUrlOrId.
  ///
  /// In en, this message translates to:
  /// **'Video URL or ID'**
  String get videoUrlOrId;

  /// No description provided for @playlistUrlOrId.
  ///
  /// In en, this message translates to:
  /// **'Playlist URL or ID'**
  String get playlistUrlOrId;

  /// No description provided for @channelUrlOrId.
  ///
  /// In en, this message translates to:
  /// **'Channel URL or ID'**
  String get channelUrlOrId;

  /// No description provided for @searchQueryLabel.
  ///
  /// In en, this message translates to:
  /// **'Search query'**
  String get searchQueryLabel;

  /// No description provided for @liveUrlOrId.
  ///
  /// In en, this message translates to:
  /// **'Live URL or ID'**
  String get liveUrlOrId;

  /// No description provided for @authorIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Creator identifier'**
  String get authorIdentifier;

  /// No description provided for @liveVodClipUrl.
  ///
  /// In en, this message translates to:
  /// **'Live, VOD, or clip URL'**
  String get liveVodClipUrl;

  /// No description provided for @channelNameOrUrl.
  ///
  /// In en, this message translates to:
  /// **'Channel name or URL'**
  String get channelNameOrUrl;

  /// No description provided for @channelSearch.
  ///
  /// In en, this message translates to:
  /// **'Channel search'**
  String get channelSearch;

  /// No description provided for @creatorSecUid.
  ///
  /// In en, this message translates to:
  /// **'Creator sec_uid'**
  String get creatorSecUid;

  /// No description provided for @usernameOrHandle.
  ///
  /// In en, this message translates to:
  /// **'Username or @handle'**
  String get usernameOrHandle;

  /// No description provided for @videoUrlShortLinkOrId.
  ///
  /// In en, this message translates to:
  /// **'Video URL, short link, or ID'**
  String get videoUrlShortLinkOrId;

  /// No description provided for @liveUrlOrRoomId.
  ///
  /// In en, this message translates to:
  /// **'Live URL or room ID'**
  String get liveUrlOrRoomId;

  /// No description provided for @noPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts'**
  String get noPosts;

  /// No description provided for @noTwitchItems.
  ///
  /// In en, this message translates to:
  /// **'No Twitch items'**
  String get noTwitchItems;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @recurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get recurring;

  /// No description provided for @clip.
  ///
  /// In en, this message translates to:
  /// **'Clip'**
  String get clip;

  /// No description provided for @viewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} views'**
  String viewsCount(int count);

  /// No description provided for @viewersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} viewers'**
  String viewersCount(int count);

  /// No description provided for @previewSourceFirst.
  ///
  /// In en, this message translates to:
  /// **'Preview the source before adding'**
  String get previewSourceFirst;

  /// No description provided for @embyAccount.
  ///
  /// In en, this message translates to:
  /// **'Emby account'**
  String get embyAccount;

  /// No description provided for @listSourceToPreview.
  ///
  /// In en, this message translates to:
  /// **'List a source to preview items'**
  String get listSourceToPreview;

  /// No description provided for @acfunUrl.
  ///
  /// In en, this message translates to:
  /// **'AcFun URL'**
  String get acfunUrl;

  /// No description provided for @cctvUrlOrVideoId.
  ///
  /// In en, this message translates to:
  /// **'CCTV URL or video ID'**
  String get cctvUrlOrVideoId;

  /// No description provided for @liveRoomOrVideoUrl.
  ///
  /// In en, this message translates to:
  /// **'Live room or video URL'**
  String get liveRoomOrVideoUrl;

  /// No description provided for @roomIdAliasOrUrl.
  ///
  /// In en, this message translates to:
  /// **'Room ID, alias, or URL'**
  String get roomIdAliasOrUrl;

  /// No description provided for @embyDiscoveryAndLists.
  ///
  /// In en, this message translates to:
  /// **'Discovery & lists'**
  String get embyDiscoveryAndLists;

  /// No description provided for @noPreparedLinks.
  ///
  /// In en, this message translates to:
  /// **'No prepared links'**
  String get noPreparedLinks;

  /// No description provided for @fileStation.
  ///
  /// In en, this message translates to:
  /// **'File Station'**
  String get fileStation;

  /// No description provided for @videoStation.
  ///
  /// In en, this message translates to:
  /// **'Video Station'**
  String get videoStation;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @selectLibraryFirst.
  ///
  /// In en, this message translates to:
  /// **'Select a library first'**
  String get selectLibraryFirst;

  /// No description provided for @unlockLibrary.
  ///
  /// In en, this message translates to:
  /// **'Unlock {name}'**
  String unlockLibrary(String name);

  /// No description provided for @libraryPassword.
  ///
  /// In en, this message translates to:
  /// **'Library password'**
  String get libraryPassword;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @enterAtLeastThreeCharacters.
  ///
  /// In en, this message translates to:
  /// **'Enter at least 3 characters'**
  String get enterAtLeastThreeCharacters;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @markWatched.
  ///
  /// In en, this message translates to:
  /// **'Mark watched'**
  String get markWatched;

  /// No description provided for @markUnwatched.
  ///
  /// In en, this message translates to:
  /// **'Mark unwatched'**
  String get markUnwatched;

  /// No description provided for @encrypted.
  ///
  /// In en, this message translates to:
  /// **'Encrypted'**
  String get encrypted;

  /// No description provided for @openFolder.
  ///
  /// In en, this message translates to:
  /// **'Open folder'**
  String get openFolder;

  /// No description provided for @sharedFolders.
  ///
  /// In en, this message translates to:
  /// **'Shared folders'**
  String get sharedFolders;

  /// No description provided for @shares.
  ///
  /// In en, this message translates to:
  /// **'Shares'**
  String get shares;

  /// No description provided for @allFiles.
  ///
  /// In en, this message translates to:
  /// **'All files'**
  String get allFiles;

  /// No description provided for @readyQualities.
  ///
  /// In en, this message translates to:
  /// **'Ready: {qualities}'**
  String readyQualities(String qualities);

  /// No description provided for @formatsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} formats'**
  String formatsCount(int count);

  /// No description provided for @subtitlesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} subtitles'**
  String subtitlesCount(int count);

  /// No description provided for @variantsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} variants'**
  String variantsCount(int count);

  /// No description provided for @qualitiesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} qualities'**
  String qualitiesCount(int count);

  /// No description provided for @chaptersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} chapters'**
  String chaptersCount(int count);

  /// No description provided for @watermarkFreeCount.
  ///
  /// In en, this message translates to:
  /// **'{count} watermark-free'**
  String watermarkFreeCount(int count);

  /// No description provided for @storyboard.
  ///
  /// In en, this message translates to:
  /// **'Storyboard'**
  String get storyboard;

  /// No description provided for @hotLabel.
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get hotLabel;

  /// No description provided for @anime.
  ///
  /// In en, this message translates to:
  /// **'Anime'**
  String get anime;

  /// No description provided for @cinema.
  ///
  /// In en, this message translates to:
  /// **'Cinema'**
  String get cinema;

  /// No description provided for @guochuang.
  ///
  /// In en, this message translates to:
  /// **'Chinese animation'**
  String get guochuang;

  /// No description provided for @documentary.
  ///
  /// In en, this message translates to:
  /// **'Documentary'**
  String get documentary;

  /// No description provided for @television.
  ///
  /// In en, this message translates to:
  /// **'TV'**
  String get television;

  /// No description provided for @variety.
  ///
  /// In en, this message translates to:
  /// **'Variety'**
  String get variety;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Recently updated'**
  String get updated;

  /// No description provided for @plays.
  ///
  /// In en, this message translates to:
  /// **'Plays'**
  String get plays;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @started.
  ///
  /// In en, this message translates to:
  /// **'Start date'**
  String get started;

  /// No description provided for @released.
  ///
  /// In en, this message translates to:
  /// **'Release date'**
  String get released;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @daysBefore.
  ///
  /// In en, this message translates to:
  /// **'Days before'**
  String get daysBefore;

  /// No description provided for @daysAfter.
  ///
  /// In en, this message translates to:
  /// **'Days after'**
  String get daysAfter;

  /// No description provided for @sortOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get sortOrder;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @yearOrRange.
  ///
  /// In en, this message translates to:
  /// **'Year or range'**
  String get yearOrRange;

  /// No description provided for @styleId.
  ///
  /// In en, this message translates to:
  /// **'Style ID'**
  String get styleId;

  /// No description provided for @delayed.
  ///
  /// In en, this message translates to:
  /// **'Delayed'**
  String get delayed;

  /// No description provided for @published.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get published;

  /// No description provided for @videoBvid.
  ///
  /// In en, this message translates to:
  /// **'Video BV number'**
  String get videoBvid;

  /// No description provided for @videoAidOptional.
  ///
  /// In en, this message translates to:
  /// **'Video AV number (optional)'**
  String get videoAidOptional;

  /// No description provided for @creatorMid.
  ///
  /// In en, this message translates to:
  /// **'Creator UID'**
  String get creatorMid;

  /// No description provided for @seasonId.
  ///
  /// In en, this message translates to:
  /// **'Season ID'**
  String get seasonId;

  /// No description provided for @collectionSeasonId.
  ///
  /// In en, this message translates to:
  /// **'Collection ID'**
  String get collectionSeasonId;

  /// No description provided for @seriesId.
  ///
  /// In en, this message translates to:
  /// **'Series ID'**
  String get seriesId;

  /// No description provided for @multipleRoutes.
  ///
  /// In en, this message translates to:
  /// **'Multiple routes'**
  String get multipleRoutes;

  /// No description provided for @proxy.
  ///
  /// In en, this message translates to:
  /// **'Proxy'**
  String get proxy;

  /// No description provided for @openable.
  ///
  /// In en, this message translates to:
  /// **'Openable'**
  String get openable;

  /// No description provided for @dynamicPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Dynamic playlist'**
  String get dynamicPlaylist;

  /// No description provided for @dynamicMedia.
  ///
  /// In en, this message translates to:
  /// **'Dynamic media'**
  String get dynamicMedia;

  /// No description provided for @media.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get media;

  /// No description provided for @onlineMembers.
  ///
  /// In en, this message translates to:
  /// **'Online members ({count})'**
  String onlineMembers(int count);

  /// No description provided for @makeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Make administrator'**
  String get makeAdmin;

  /// No description provided for @removeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Remove administrator'**
  String get removeAdmin;

  /// No description provided for @removeMember.
  ///
  /// In en, this message translates to:
  /// **'Remove member'**
  String get removeMember;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @administrator.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// No description provided for @onlineConnections.
  ///
  /// In en, this message translates to:
  /// **'Online · {count, plural, =1{1 connection} other{{count} connections}}'**
  String onlineConnections(int count);

  /// No description provided for @offlineJoinedAt.
  ///
  /// In en, this message translates to:
  /// **'Offline · joined {date}'**
  String offlineJoinedAt(String date);

  /// No description provided for @playlistSubscribeFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not subscribe to the playlist'**
  String get playlistSubscribeFailed;

  /// No description provided for @playlistBrowseAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to browse this playlist'**
  String get playlistBrowseAccessDenied;

  /// No description provided for @switchedAndPlaying.
  ///
  /// In en, this message translates to:
  /// **'Switched and started playback'**
  String get switchedAndPlaying;

  /// No description provided for @switchFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not switch: {error}'**
  String switchFailed(String error);

  /// No description provided for @deleteEntries.
  ///
  /// In en, this message translates to:
  /// **'Delete entries'**
  String get deleteEntries;

  /// No description provided for @confirmDeleteMediaEntries.
  ///
  /// In en, this message translates to:
  /// **'Delete {count, plural, =1{the selected media entry} other{the {count} selected media entries}}?'**
  String confirmDeleteMediaEntries(int count);

  /// No description provided for @dynamicPlaylistCannotDelete.
  ///
  /// In en, this message translates to:
  /// **'Dynamic playlist contents cannot be deleted from the room'**
  String get dynamicPlaylistCannotDelete;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @deleteEntryFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the entry: {error}'**
  String deleteEntryFailed(String error);

  /// No description provided for @playbackStopped.
  ///
  /// In en, this message translates to:
  /// **'Playback stopped'**
  String get playbackStopped;

  /// No description provided for @stopPlaybackFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not stop playback: {error}'**
  String stopPlaybackFailed(String error);

  /// No description provided for @roomManagersOnly.
  ///
  /// In en, this message translates to:
  /// **'Only the room owner and administrators can manage the room'**
  String get roomManagersOnly;

  /// No description provided for @loadSettingsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load settings: {error}'**
  String loadSettingsFailed(String error);

  /// No description provided for @confirmMakeAdmin.
  ///
  /// In en, this message translates to:
  /// **'Make {user} an administrator?\nAdministrators can remove members and manage the room.'**
  String confirmMakeAdmin(String user);

  /// No description provided for @madeAdmin.
  ///
  /// In en, this message translates to:
  /// **'{user} is now an administrator'**
  String madeAdmin(String user);

  /// No description provided for @settingFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the setting: {error}'**
  String settingFailed(String error);

  /// No description provided for @confirmRemoveAdmin.
  ///
  /// In en, this message translates to:
  /// **'Remove administrator access from {user}?'**
  String confirmRemoveAdmin(String user);

  /// No description provided for @removedAdmin.
  ///
  /// In en, this message translates to:
  /// **'Administrator access removed from {user}'**
  String removedAdmin(String user);

  /// No description provided for @cancelActionFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not cancel: {error}'**
  String cancelActionFailed(String error);

  /// No description provided for @memberKicked.
  ///
  /// In en, this message translates to:
  /// **'Member removed'**
  String get memberKicked;

  /// No description provided for @kickMemberFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not remove the member: {error}'**
  String kickMemberFailed(String error);

  /// No description provided for @kickMember.
  ///
  /// In en, this message translates to:
  /// **'Remove member'**
  String get kickMember;

  /// No description provided for @confirmKickMember.
  ///
  /// In en, this message translates to:
  /// **'Remove {user} and set a cooldown before they can rejoin.'**
  String confirmKickMember(String user);

  /// No description provided for @cooldownSeconds.
  ///
  /// In en, this message translates to:
  /// **'Cooldown in seconds'**
  String get cooldownSeconds;

  /// No description provided for @cooldownSecondsRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a value from 1 to 2592000 seconds'**
  String get cooldownSecondsRange;

  /// No description provided for @kick.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get kick;

  /// No description provided for @chooseImageFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not choose the image: {error}'**
  String chooseImageFailed(String error);

  /// No description provided for @sendFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send the message: {error}'**
  String sendFailed(String error);

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @rooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get rooms;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @bindings.
  ///
  /// In en, this message translates to:
  /// **'Bindings'**
  String get bindings;

  /// No description provided for @accountPreferences.
  ///
  /// In en, this message translates to:
  /// **'Account preferences'**
  String get accountPreferences;

  /// No description provided for @accountPreferencesUnavailableImpact.
  ///
  /// In en, this message translates to:
  /// **'Multi-factor authentication status, notification preferences, and security capability checks are unavailable.'**
  String get accountPreferencesUnavailableImpact;

  /// No description provided for @notificationCenter.
  ///
  /// In en, this message translates to:
  /// **'Notification center'**
  String get notificationCenter;

  /// No description provided for @notificationsUnavailableImpact.
  ///
  /// In en, this message translates to:
  /// **'Unread counts, notification lists, marking as read, and notification deletion are unavailable.'**
  String get notificationsUnavailableImpact;

  /// No description provided for @myRooms.
  ///
  /// In en, this message translates to:
  /// **'My rooms'**
  String get myRooms;

  /// No description provided for @myRoomsUnavailableImpact.
  ///
  /// In en, this message translates to:
  /// **'Room listing, room search, and room management in the account center are unavailable.'**
  String get myRoomsUnavailableImpact;

  /// No description provided for @oauthAvailableAccounts.
  ///
  /// In en, this message translates to:
  /// **'Available OAuth2 accounts'**
  String get oauthAvailableAccounts;

  /// No description provided for @oauthProvidersUnavailableImpact.
  ///
  /// In en, this message translates to:
  /// **'Available third-party login providers cannot be displayed.'**
  String get oauthProvidersUnavailableImpact;

  /// No description provided for @oauthLinkedAccounts.
  ///
  /// In en, this message translates to:
  /// **'Linked OAuth2 accounts'**
  String get oauthLinkedAccounts;

  /// No description provided for @oauthLinksUnavailableImpact.
  ///
  /// In en, this message translates to:
  /// **'Linked third-party login accounts cannot be viewed or unlinked.'**
  String get oauthLinksUnavailableImpact;

  /// No description provided for @passkeyCredentials.
  ///
  /// In en, this message translates to:
  /// **'Passkey credentials'**
  String get passkeyCredentials;

  /// No description provided for @passkeysUnavailableImpact.
  ///
  /// In en, this message translates to:
  /// **'Server passkey credentials cannot be viewed, created, or deleted.'**
  String get passkeysUnavailableImpact;

  /// No description provided for @localPasskeyCapability.
  ///
  /// In en, this message translates to:
  /// **'Local passkey capability'**
  String get localPasskeyCapability;

  /// No description provided for @localPasskeyUnavailableImpact.
  ///
  /// In en, this message translates to:
  /// **'Passkey creation support on this device cannot be confirmed.'**
  String get localPasskeyUnavailableImpact;

  /// No description provided for @serverPublicSettings.
  ///
  /// In en, this message translates to:
  /// **'Server public settings'**
  String get serverPublicSettings;

  /// No description provided for @publicSettingsUnavailableImpact.
  ///
  /// In en, this message translates to:
  /// **'Email and passkey availability cannot be determined.'**
  String get publicSettingsUnavailableImpact;

  /// No description provided for @notBound.
  ///
  /// In en, this message translates to:
  /// **'Not bound'**
  String get notBound;

  /// No description provided for @bound.
  ///
  /// In en, this message translates to:
  /// **'Bound'**
  String get bound;

  /// No description provided for @loadAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load account information: {error}'**
  String loadAccountFailed(String error);

  /// No description provided for @changeUsername.
  ///
  /// In en, this message translates to:
  /// **'Change username'**
  String get changeUsername;

  /// No description provided for @changeUsernameDescription.
  ///
  /// In en, this message translates to:
  /// **'Set your public username on this server'**
  String get changeUsernameDescription;

  /// No description provided for @usernameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Username updated'**
  String get usernameUpdated;

  /// No description provided for @updateUsernameFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the username: {error}'**
  String updateUsernameFailed(String error);

  /// No description provided for @avatarUpdated.
  ///
  /// In en, this message translates to:
  /// **'Avatar updated'**
  String get avatarUpdated;

  /// No description provided for @updateAvatarFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the avatar: {error}'**
  String updateAvatarFailed(String error);

  /// No description provided for @removeAvatar.
  ///
  /// In en, this message translates to:
  /// **'Remove avatar'**
  String get removeAvatar;

  /// No description provided for @confirmRemoveAvatar.
  ///
  /// In en, this message translates to:
  /// **'Remove the current avatar? Your account will use the default avatar.'**
  String get confirmRemoveAvatar;

  /// No description provided for @avatarRemoved.
  ///
  /// In en, this message translates to:
  /// **'Avatar removed'**
  String get avatarRemoved;

  /// No description provided for @removeAvatarFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not remove the avatar: {error}'**
  String removeAvatarFailed(String error);

  /// No description provided for @notificationPreferencesSaved.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences saved'**
  String get notificationPreferencesSaved;

  /// No description provided for @saveNotificationPreferencesFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save notification preferences: {error}'**
  String saveNotificationPreferencesFailed(String error);

  /// No description provided for @mfaSettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Multi-factor authentication settings saved'**
  String get mfaSettingsSaved;

  /// No description provided for @saveMfaSettingsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save multi-factor authentication settings: {error}'**
  String saveMfaSettingsFailed(String error);

  /// No description provided for @unbindEmail.
  ///
  /// In en, this message translates to:
  /// **'Unbind email'**
  String get unbindEmail;

  /// No description provided for @unbindEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'After unbinding, this email can no longer receive verification codes, email notifications, or password reset messages.'**
  String get unbindEmailDescription;

  /// No description provided for @emailUnbound.
  ///
  /// In en, this message translates to:
  /// **'Email unbound'**
  String get emailUnbound;

  /// No description provided for @unbindEmailFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not unbind the email: {error}'**
  String unbindEmailFailed(String error);

  /// No description provided for @emailBound.
  ///
  /// In en, this message translates to:
  /// **'Email bound'**
  String get emailBound;

  /// No description provided for @noPasswordVerificationMethod.
  ///
  /// In en, this message translates to:
  /// **'This account has no available password verification method'**
  String get noPasswordVerificationMethod;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get passwordUpdated;

  /// No description provided for @updatePasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the password: {error}'**
  String updatePasswordFailed(String error);

  /// No description provided for @accountHasNoEmail.
  ///
  /// In en, this message translates to:
  /// **'This account has no email address'**
  String get accountHasNoEmail;

  /// No description provided for @passwordReset.
  ///
  /// In en, this message translates to:
  /// **'Password reset'**
  String get passwordReset;

  /// No description provided for @resetPasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not reset the password: {error}'**
  String resetPasswordFailed(String error);

  /// No description provided for @deletePasskey.
  ///
  /// In en, this message translates to:
  /// **'Delete passkey'**
  String get deletePasskey;

  /// No description provided for @confirmDeletePasskey.
  ///
  /// In en, this message translates to:
  /// **'Delete “{name}”? This device will no longer be able to use the passkey to log in.'**
  String confirmDeletePasskey(String name);

  /// No description provided for @passkeyDeleted.
  ///
  /// In en, this message translates to:
  /// **'Passkey deleted'**
  String get passkeyDeleted;

  /// No description provided for @deletePasskeyFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the passkey: {error}'**
  String deletePasskeyFailed(String error);

  /// No description provided for @bindPasskey.
  ///
  /// In en, this message translates to:
  /// **'Bind passkey'**
  String get bindPasskey;

  /// No description provided for @bindPasskeyDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a recognizable name for this device'**
  String get bindPasskeyDescription;

  /// No description provided for @deviceName.
  ///
  /// In en, this message translates to:
  /// **'Device name'**
  String get deviceName;

  /// No description provided for @deviceNameExample.
  ///
  /// In en, this message translates to:
  /// **'For example, MacBook or phone'**
  String get deviceNameExample;

  /// No description provided for @passkeyBound.
  ///
  /// In en, this message translates to:
  /// **'Passkey bound'**
  String get passkeyBound;

  /// No description provided for @bindPasskeyFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not bind the passkey: {error}'**
  String bindPasskeyFailed(String error);

  /// No description provided for @allMarkedRead.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read'**
  String get allMarkedRead;

  /// No description provided for @operationFailed.
  ///
  /// In en, this message translates to:
  /// **'Operation failed: {error}'**
  String operationFailed(String error);

  /// No description provided for @selectedNotificationsMarked.
  ///
  /// In en, this message translates to:
  /// **'Selected notifications marked'**
  String get selectedNotificationsMarked;

  /// No description provided for @markFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not mark the notification: {error}'**
  String markFailed(String error);

  /// No description provided for @readNotificationsDeleted.
  ///
  /// In en, this message translates to:
  /// **'Read notifications deleted'**
  String get readNotificationsDeleted;

  /// No description provided for @loadNotificationDetailsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load notification details; showing list content: {error}'**
  String loadNotificationDetailsFailed(String error);

  /// No description provided for @loadNotificationsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load notifications: {error}'**
  String loadNotificationsFailed(String error);

  /// No description provided for @openAuthorizationLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the authorization link'**
  String get openAuthorizationLinkFailed;

  /// No description provided for @completeAuthorizationInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Complete authorization in your browser'**
  String get completeAuthorizationInBrowser;

  /// No description provided for @oauthAccountBound.
  ///
  /// In en, this message translates to:
  /// **'OAuth2 account linked'**
  String get oauthAccountBound;

  /// No description provided for @oauthBindingFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not link the OAuth2 account: {error}'**
  String oauthBindingFailed(String error);

  /// No description provided for @loadMyRoomsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load your rooms: {error}'**
  String loadMyRoomsFailed(String error);

  /// No description provided for @openRoomManagementFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open room management: {error}'**
  String openRoomManagementFailed(String error);

  /// No description provided for @leaveRoom.
  ///
  /// In en, this message translates to:
  /// **'Leave room'**
  String get leaveRoom;

  /// No description provided for @deleteOwnedRoomDescription.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes “{name}” and its room data. All members will lose access.'**
  String deleteOwnedRoomDescription(String name);

  /// No description provided for @leaveRoomDescription.
  ///
  /// In en, this message translates to:
  /// **'Leave “{name}”? You will need to join again to regain access.'**
  String leaveRoomDescription(String name);

  /// No description provided for @actionCompleted.
  ///
  /// In en, this message translates to:
  /// **'{action} completed'**
  String actionCompleted(String action);

  /// No description provided for @actionFailed.
  ///
  /// In en, this message translates to:
  /// **'{action} failed: {error}'**
  String actionFailed(String action, String error);

  /// No description provided for @closeAccount.
  ///
  /// In en, this message translates to:
  /// **'Close account'**
  String get closeAccount;

  /// No description provided for @closeAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'This permanently closes the current account and its personal data.'**
  String get closeAccountDescription;

  /// No description provided for @enterCloseAccountToConfirm.
  ///
  /// In en, this message translates to:
  /// **'Enter {text} to confirm'**
  String enterCloseAccountToConfirm(String text);

  /// No description provided for @confirmationTextMismatch.
  ///
  /// In en, this message translates to:
  /// **'Confirmation text does not match'**
  String get confirmationTextMismatch;

  /// No description provided for @accountClosed.
  ///
  /// In en, this message translates to:
  /// **'Account closed'**
  String get accountClosed;

  /// No description provided for @closeAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not close the account: {error}'**
  String closeAccountFailed(String error);

  /// No description provided for @currentAccount.
  ///
  /// In en, this message translates to:
  /// **'Current account'**
  String get currentAccount;

  /// No description provided for @unreadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Unread notifications'**
  String get unreadNotifications;

  /// No description provided for @loginFactors.
  ///
  /// In en, this message translates to:
  /// **'Login factors'**
  String get loginFactors;

  /// No description provided for @emailStatus.
  ///
  /// In en, this message translates to:
  /// **'Email status'**
  String get emailStatus;

  /// No description provided for @personalProfile.
  ///
  /// In en, this message translates to:
  /// **'Personal profile'**
  String get personalProfile;

  /// No description provided for @personalProfileDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your public identity and account status on this server'**
  String get personalProfileDescription;

  /// No description provided for @emailWithStatus.
  ///
  /// In en, this message translates to:
  /// **'Email {status}'**
  String emailWithStatus(String status);

  /// No description provided for @banned.
  ///
  /// In en, this message translates to:
  /// **'Banned'**
  String get banned;

  /// No description provided for @emailNotBound.
  ///
  /// In en, this message translates to:
  /// **'Email not bound'**
  String get emailNotBound;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account information'**
  String get accountInformation;

  /// No description provided for @accountStatus.
  ///
  /// In en, this message translates to:
  /// **'Account status'**
  String get accountStatus;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get createdAt;

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated at'**
  String get updatedAt;

  /// No description provided for @onlineConnectionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Online connections'**
  String get onlineConnectionsLabel;

  /// No description provided for @banReason.
  ///
  /// In en, this message translates to:
  /// **'Ban reason'**
  String get banReason;

  /// No description provided for @notificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences'**
  String get notificationPreferences;

  /// No description provided for @notificationPreferencesDescription.
  ///
  /// In en, this message translates to:
  /// **'Control in-app and email notifications by scenario'**
  String get notificationPreferencesDescription;

  /// No description provided for @roomInviteInAppNotifications.
  ///
  /// In en, this message translates to:
  /// **'Room invitation in-app notifications'**
  String get roomInviteInAppNotifications;

  /// No description provided for @roomEventInAppNotifications.
  ///
  /// In en, this message translates to:
  /// **'Room event in-app notifications'**
  String get roomEventInAppNotifications;

  /// No description provided for @systemAnnouncementInAppNotifications.
  ///
  /// In en, this message translates to:
  /// **'System announcement in-app notifications'**
  String get systemAnnouncementInAppNotifications;

  /// No description provided for @roomInviteEmailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Room invitation email notifications'**
  String get roomInviteEmailNotifications;

  /// No description provided for @roomEventEmailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Room event email notifications'**
  String get roomEventEmailNotifications;

  /// No description provided for @systemAnnouncementEmailNotifications.
  ///
  /// In en, this message translates to:
  /// **'System announcement email notifications'**
  String get systemAnnouncementEmailNotifications;

  /// No description provided for @notificationPreferencesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Notification preferences unavailable'**
  String get notificationPreferencesUnavailable;

  /// No description provided for @myRoomsDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage synchronized watch spaces you created, joined, or can access'**
  String get myRoomsDescription;

  /// No description provided for @searchRoomNameOrDescription.
  ///
  /// In en, this message translates to:
  /// **'Search room name or description'**
  String get searchRoomNameOrDescription;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @createdByMe.
  ///
  /// In en, this message translates to:
  /// **'Created by me'**
  String get createdByMe;

  /// No description provided for @joinedByMe.
  ///
  /// In en, this message translates to:
  /// **'Joined by me'**
  String get joinedByMe;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentActivity;

  /// No description provided for @frequentlyVisited.
  ///
  /// In en, this message translates to:
  /// **'Frequently visited'**
  String get frequentlyVisited;

  /// No description provided for @recentlyVisited.
  ///
  /// In en, this message translates to:
  /// **'Recently visited'**
  String get recentlyVisited;

  /// No description provided for @refreshRooms.
  ///
  /// In en, this message translates to:
  /// **'Refresh rooms'**
  String get refreshRooms;

  /// No description provided for @pageRangeSummary.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {pages} · {start}-{end} / {total}'**
  String pageRangeSummary(int page, int pages, int start, int end, int total);

  /// No description provided for @myRoomsTemporarilyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'My rooms are temporarily unavailable'**
  String get myRoomsTemporarilyUnavailable;

  /// No description provided for @noMatchingRooms.
  ///
  /// In en, this message translates to:
  /// **'No matching rooms'**
  String get noMatchingRooms;

  /// No description provided for @localPasskey.
  ///
  /// In en, this message translates to:
  /// **'Local passkey'**
  String get localPasskey;

  /// No description provided for @accountSecurity.
  ///
  /// In en, this message translates to:
  /// **'Account security'**
  String get accountSecurity;

  /// No description provided for @accountSecurityDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage login factors, device credentials, and high-risk account actions'**
  String get accountSecurityDescription;

  /// No description provided for @loginProtection.
  ///
  /// In en, this message translates to:
  /// **'Login protection'**
  String get loginProtection;

  /// No description provided for @loginProtectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Multi-factor authentication requires an additional factor beyond your password'**
  String get loginProtectionDescription;

  /// No description provided for @multiFactorAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Multi-factor authentication'**
  String get multiFactorAuthentication;

  /// No description provided for @availableFactors.
  ///
  /// In en, this message translates to:
  /// **'Available factors: {factors}'**
  String availableFactors(String factors);

  /// No description provided for @listSeparator.
  ///
  /// In en, this message translates to:
  /// **', '**
  String get listSeparator;

  /// No description provided for @bindEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'Bind an email to receive verification codes, notifications, and password reset messages'**
  String get bindEmailDescription;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Login password'**
  String get loginPassword;

  /// No description provided for @opaquePasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Update the account password using the OPAQUE protocol'**
  String get opaquePasswordDescription;

  /// No description provided for @emailReset.
  ///
  /// In en, this message translates to:
  /// **'Email reset'**
  String get emailReset;

  /// No description provided for @loginProtectionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Login protection information unavailable'**
  String get loginProtectionUnavailable;

  /// No description provided for @passkeyManagementDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the system credential manager for passwordless or multi-factor verification'**
  String get passkeyManagementDescription;

  /// No description provided for @noPasskeys.
  ///
  /// In en, this message translates to:
  /// **'No passkeys'**
  String get noPasskeys;

  /// No description provided for @unnamedPasskey.
  ///
  /// In en, this message translates to:
  /// **'Unnamed passkey'**
  String get unnamedPasskey;

  /// No description provided for @createdAtValue.
  ///
  /// In en, this message translates to:
  /// **'Created {value}'**
  String createdAtValue(String value);

  /// No description provided for @lastUsedAt.
  ///
  /// In en, this message translates to:
  /// **'Last used {value}'**
  String lastUsedAt(String value);

  /// No description provided for @dangerousActions.
  ///
  /// In en, this message translates to:
  /// **'Dangerous actions'**
  String get dangerousActions;

  /// No description provided for @dangerousActionsDescription.
  ///
  /// In en, this message translates to:
  /// **'These actions affect account availability or permanently delete data'**
  String get dangerousActionsDescription;

  /// No description provided for @closeAccountTileDescription.
  ///
  /// In en, this message translates to:
  /// **'Permanently close this account and clear the local login state'**
  String get closeAccountTileDescription;

  /// No description provided for @unreadTotalSummary.
  ///
  /// In en, this message translates to:
  /// **'Unread {unread} / Total {total}'**
  String unreadTotalSummary(int unread, int total);

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'Selected {count}'**
  String selectedCount(int count);

  /// No description provided for @markSelectedUnreadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Mark selected unread notifications'**
  String get markSelectedUnreadNotifications;

  /// No description provided for @selectCurrentUnreadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Select unread notifications on this page'**
  String get selectCurrentUnreadNotifications;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllRead;

  /// No description provided for @deleteReadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Delete read notifications'**
  String get deleteReadNotifications;

  /// No description provided for @searchTitleOrContent.
  ///
  /// In en, this message translates to:
  /// **'Search title or content'**
  String get searchTitleOrContent;

  /// No description provided for @unread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// No description provided for @notificationType.
  ///
  /// In en, this message translates to:
  /// **'Notification type'**
  String get notificationType;

  /// No description provided for @roomInvitation.
  ///
  /// In en, this message translates to:
  /// **'Room invitation'**
  String get roomInvitation;

  /// No description provided for @systemAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'System announcement'**
  String get systemAnnouncement;

  /// No description provided for @roomEvent.
  ///
  /// In en, this message translates to:
  /// **'Room event'**
  String get roomEvent;

  /// No description provided for @passwordResetNotification.
  ///
  /// In en, this message translates to:
  /// **'Password reset'**
  String get passwordResetNotification;

  /// No description provided for @emailBinding.
  ///
  /// In en, this message translates to:
  /// **'Email binding'**
  String get emailBinding;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @descending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get descending;

  /// No description provided for @ascending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get ascending;

  /// No description provided for @notificationPageRange.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {pages} · {start}-{end}'**
  String notificationPageRange(int page, int pages, int start, int end);

  /// No description provided for @notificationsTemporarilyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Notifications are temporarily unavailable'**
  String get notificationsTemporarilyUnavailable;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @selectNotification.
  ///
  /// In en, this message translates to:
  /// **'Select notification'**
  String get selectNotification;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetails;

  /// No description provided for @markRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get markRead;

  /// No description provided for @mediaSourceAccounts.
  ///
  /// In en, this message translates to:
  /// **'Media source accounts'**
  String get mediaSourceAccounts;

  /// No description provided for @mediaSourceAccountsDescription.
  ///
  /// In en, this message translates to:
  /// **'Bind personal media accounts to browse AList, Emby, and Bilibili resources while adding videos.'**
  String get mediaSourceAccountsDescription;

  /// No description provided for @alistAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Personal storage and directory resources'**
  String get alistAccountDescription;

  /// No description provided for @cloudreveAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Cloud storage media and directory resources'**
  String get cloudreveAccountDescription;

  /// No description provided for @embyAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Personal media library and video resources'**
  String get embyAccountDescription;

  /// No description provided for @bilibiliAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Bilibili account and favorite resources'**
  String get bilibiliAccountDescription;

  /// No description provided for @twitchAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Twitch live streams, VODs, and clips'**
  String get twitchAccountDescription;

  /// No description provided for @fnosAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'FNOS files and media libraries'**
  String get fnosAccountDescription;

  /// No description provided for @qnapAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'QTS and QuTS hero File Station resources'**
  String get qnapAccountDescription;

  /// No description provided for @synologyAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'File Station and Video Station resources'**
  String get synologyAccountDescription;

  /// No description provided for @nextcloudAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Nextcloud files, favorites, and media search'**
  String get nextcloudAccountDescription;

  /// No description provided for @seafileAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Seafile libraries, starred files, and media search'**
  String get seafileAccountDescription;

  /// No description provided for @truenasAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'TrueNAS ZFS filesystem media'**
  String get truenasAccountDescription;

  /// No description provided for @youtubeAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'YouTube videos, live streams, and dynamic playlists with Cookie, Visitor Data, or PO Token'**
  String get youtubeAccountDescription;

  /// No description provided for @douyinAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Douyin videos, live streams, comments, and creator posts with Cookie'**
  String get douyinAccountDescription;

  /// No description provided for @tiktokAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'TikTok videos, live streams, captions, and creator posts with Cookie'**
  String get tiktokAccountDescription;

  /// No description provided for @linkedOAuth2.
  ///
  /// In en, this message translates to:
  /// **'Linked OAuth2'**
  String get linkedOAuth2;

  /// No description provided for @bindNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Link a new account'**
  String get bindNewAccount;

  /// No description provided for @oauthAppLinkUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This build has no OAuth2 App Link configured, so authorization cannot return to this device.'**
  String get oauthAppLinkUnavailable;

  /// No description provided for @waitingForAuthorizationCallback.
  ///
  /// In en, this message translates to:
  /// **'Waiting for {provider} authorization callback'**
  String waitingForAuthorizationCallback(String provider);

  /// No description provided for @cancelBinding.
  ///
  /// In en, this message translates to:
  /// **'Cancel linking'**
  String get cancelBinding;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View profile'**
  String get viewProfile;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @availableFactorsLabel.
  ///
  /// In en, this message translates to:
  /// **'Available factors'**
  String get availableFactorsLabel;

  /// No description provided for @manageSecurity.
  ///
  /// In en, this message translates to:
  /// **'Manage security'**
  String get manageSecurity;

  /// No description provided for @recentRooms.
  ///
  /// In en, this message translates to:
  /// **'Recent rooms'**
  String get recentRooms;

  /// No description provided for @creatorName.
  ///
  /// In en, this message translates to:
  /// **'Creator {name}'**
  String creatorName(String name);

  /// No description provided for @manageRooms.
  ///
  /// In en, this message translates to:
  /// **'Manage rooms'**
  String get manageRooms;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @pendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending review'**
  String get pendingReview;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @creator.
  ///
  /// In en, this message translates to:
  /// **'Creator'**
  String get creator;

  /// No description provided for @roomAdministrator.
  ///
  /// In en, this message translates to:
  /// **'Room administrator'**
  String get roomAdministrator;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @verifyWithCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Verify with the current password'**
  String get verifyWithCurrentPassword;

  /// No description provided for @verifyWithEmailCode.
  ///
  /// In en, this message translates to:
  /// **'Verify with a code sent by email'**
  String get verifyWithEmailCode;

  /// No description provided for @verifyWithSystemPasskey.
  ///
  /// In en, this message translates to:
  /// **'Use a system passkey for identity verification'**
  String get verifyWithSystemPasskey;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @changePasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose an available verification method, then set a new login password.'**
  String get changePasswordDescription;

  /// No description provided for @verificationMethod.
  ///
  /// In en, this message translates to:
  /// **'Verification method'**
  String get verificationMethod;

  /// No description provided for @identityVerification.
  ///
  /// In en, this message translates to:
  /// **'Identity verification'**
  String get identityVerification;

  /// No description provided for @emailVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Email verification code'**
  String get emailVerificationCode;

  /// No description provided for @passkeyVerification.
  ///
  /// In en, this message translates to:
  /// **'Passkey verification'**
  String get passkeyVerification;

  /// No description provided for @passkeyPasswordUpdateDescription.
  ///
  /// In en, this message translates to:
  /// **'Saving opens the system verification dialog. The new password is applied after successful verification.'**
  String get passkeyPasswordUpdateDescription;

  /// No description provided for @savePassword.
  ///
  /// In en, this message translates to:
  /// **'Save password'**
  String get savePassword;

  /// No description provided for @codeAndNewPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code and new password'**
  String get codeAndNewPasswordRequired;

  /// No description provided for @emailPasswordReset.
  ///
  /// In en, this message translates to:
  /// **'Reset password by email'**
  String get emailPasswordReset;

  /// No description provided for @emailPasswordResetDescription.
  ///
  /// In en, this message translates to:
  /// **'Send a one-time code to the bound email and use it to reset the password.'**
  String get emailPasswordResetDescription;

  /// No description provided for @recipientEmail.
  ///
  /// In en, this message translates to:
  /// **'Recipient email'**
  String get recipientEmail;

  /// No description provided for @sendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send verification code'**
  String get sendVerificationCode;

  /// No description provided for @bindingEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Binding confirmation email sent'**
  String get bindingEmailSent;

  /// No description provided for @sendBindingEmailFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send the binding email: {error}'**
  String sendBindingEmailFailed(String error);

  /// No description provided for @bindEmailFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not bind the email: {error}'**
  String bindEmailFailed(String error);

  /// No description provided for @bindEmail.
  ///
  /// In en, this message translates to:
  /// **'Bind email'**
  String get bindEmail;

  /// No description provided for @bindEmailBenefits.
  ///
  /// In en, this message translates to:
  /// **'A bound email can be used for login, password recovery, and account notifications.'**
  String get bindEmailBenefits;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @confirmationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Confirmation email sent'**
  String get confirmationEmailSent;

  /// No description provided for @confirmBinding.
  ///
  /// In en, this message translates to:
  /// **'Confirm binding'**
  String get confirmBinding;

  /// No description provided for @bindingCode.
  ///
  /// In en, this message translates to:
  /// **'Binding code'**
  String get bindingCode;

  /// No description provided for @initializeVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not initialize identity verification: {error}'**
  String initializeVerificationFailed(String error);

  /// No description provided for @sendCodeFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send the verification code: {error}'**
  String sendCodeFailed(String error);

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter the current password'**
  String get enterCurrentPassword;

  /// No description provided for @enterEmailCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the email verification code'**
  String get enterEmailCode;

  /// No description provided for @passkeyChallengeMissing.
  ///
  /// In en, this message translates to:
  /// **'The server did not return a passkey verification challenge'**
  String get passkeyChallengeMissing;

  /// No description provided for @identityVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Identity verification failed: {error}'**
  String identityVerificationFailed(String error);

  /// No description provided for @identityVerificationDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose an available method to continue the account security action.'**
  String get identityVerificationDescription;

  /// No description provided for @noVerificationMethods.
  ///
  /// In en, this message translates to:
  /// **'No verification methods available'**
  String get noVerificationMethods;

  /// No description provided for @noVerificationMethodsDescription.
  ///
  /// In en, this message translates to:
  /// **'This account has no password, email, or passkey verification capability.'**
  String get noVerificationMethodsDescription;

  /// No description provided for @verificationInformation.
  ///
  /// In en, this message translates to:
  /// **'Verification information'**
  String get verificationInformation;

  /// No description provided for @passkeyVerificationDescription.
  ///
  /// In en, this message translates to:
  /// **'The system verification dialog opens after you select Verify.'**
  String get passkeyVerificationDescription;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @updatedAtValue.
  ///
  /// In en, this message translates to:
  /// **'Updated {value}'**
  String updatedAtValue(String value);

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @someAccountModulesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Some account modules are temporarily unavailable'**
  String get someAccountModulesUnavailable;

  /// No description provided for @retryAll.
  ///
  /// In en, this message translates to:
  /// **'Retry all'**
  String get retryAll;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @moduleCurrentlyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This module is currently unavailable.'**
  String get moduleCurrentlyUnavailable;

  /// No description provided for @moduleUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Module unavailable'**
  String get moduleUnavailable;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @roomMemberUpdateSummary.
  ///
  /// In en, this message translates to:
  /// **'{online} online · {members, plural, =1{1 member} other{{members} members}} · Updated {time}'**
  String roomMemberUpdateSummary(int online, int members, String time);

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @network.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// No description provided for @streaming.
  ///
  /// In en, this message translates to:
  /// **'Streaming'**
  String get streaming;

  /// No description provided for @allSources.
  ///
  /// In en, this message translates to:
  /// **'All sources'**
  String get allSources;

  /// No description provided for @roomCoverUpdated.
  ///
  /// In en, this message translates to:
  /// **'Room cover updated'**
  String get roomCoverUpdated;

  /// No description provided for @updateRoomCoverFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the room cover: {error}'**
  String updateRoomCoverFailed(String error);

  /// No description provided for @roomCoverRemoved.
  ///
  /// In en, this message translates to:
  /// **'Room cover removed'**
  String get roomCoverRemoved;

  /// No description provided for @removeRoomCoverFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not remove the room cover: {error}'**
  String removeRoomCoverFailed(String error);

  /// No description provided for @roomPasswordRemoved.
  ///
  /// In en, this message translates to:
  /// **'Room password removed'**
  String get roomPasswordRemoved;

  /// No description provided for @roomPasswordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Room password updated'**
  String get roomPasswordUpdated;

  /// No description provided for @updateRoomPasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the room password: {error}'**
  String updateRoomPasswordFailed(String error);

  /// No description provided for @removePassword.
  ///
  /// In en, this message translates to:
  /// **'Remove password'**
  String get removePassword;

  /// No description provided for @noActionNeeded.
  ///
  /// In en, this message translates to:
  /// **'No action needed'**
  String get noActionNeeded;

  /// No description provided for @memberOnlineWatchFailed.
  ///
  /// In en, this message translates to:
  /// **'Member online status watch failed'**
  String get memberOnlineWatchFailed;

  /// No description provided for @roomSettingsSnapshotEmpty.
  ///
  /// In en, this message translates to:
  /// **'The room settings snapshot is empty'**
  String get roomSettingsSnapshotEmpty;

  /// No description provided for @roomSettingsWatchFailed.
  ///
  /// In en, this message translates to:
  /// **'Room settings watch failed'**
  String get roomSettingsWatchFailed;

  /// No description provided for @memberWatchFailed.
  ///
  /// In en, this message translates to:
  /// **'Member watch failed'**
  String get memberWatchFailed;

  /// No description provided for @mediaSnapshotEmpty.
  ///
  /// In en, this message translates to:
  /// **'The media list snapshot is empty'**
  String get mediaSnapshotEmpty;

  /// No description provided for @mediaLibraryWatchFailed.
  ///
  /// In en, this message translates to:
  /// **'Media library watch failed'**
  String get mediaLibraryWatchFailed;

  /// No description provided for @chatWatchFailed.
  ///
  /// In en, this message translates to:
  /// **'Chat event watch failed'**
  String get chatWatchFailed;

  /// No description provided for @maxMembersRange.
  ///
  /// In en, this message translates to:
  /// **'Maximum members must be between 0 and 10000'**
  String get maxMembersRange;

  /// No description provided for @settingsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Settings updated'**
  String get settingsUpdated;

  /// No description provided for @roomVisibilityUpdated.
  ///
  /// In en, this message translates to:
  /// **'Room visibility updated'**
  String get roomVisibilityUpdated;

  /// No description provided for @makeRoomPrivate.
  ///
  /// In en, this message translates to:
  /// **'Make room private?'**
  String get makeRoomPrivate;

  /// No description provided for @makeRoomPrivateConfirmation.
  ///
  /// In en, this message translates to:
  /// **'The room will be removed from discovery and current anonymous guests will be disconnected.'**
  String get makeRoomPrivateConfirmation;

  /// No description provided for @makePrivate.
  ///
  /// In en, this message translates to:
  /// **'Make private'**
  String get makePrivate;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed: {error}'**
  String updateFailed(String error);

  /// No description provided for @loadActiveStreamsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load active streams: {error}'**
  String loadActiveStreamsFailed(String error);

  /// No description provided for @loadJoinReviewsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load join requests: {error}'**
  String loadJoinReviewsFailed(String error);

  /// No description provided for @loadMembersFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load members: {error}'**
  String loadMembersFailed(String error);

  /// No description provided for @loadMediaLibraryFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the media library: {error}'**
  String loadMediaLibraryFailed(String error);

  /// No description provided for @realtimeDiagnosticsCopied.
  ///
  /// In en, this message translates to:
  /// **'Realtime diagnostics copied'**
  String get realtimeDiagnosticsCopied;

  /// No description provided for @loadChatHistoryFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load chat history: {error}'**
  String loadChatHistoryFailed(String error);

  /// No description provided for @searchChatHistoryFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not search chat history: {error}'**
  String searchChatHistoryFailed(String error);

  /// No description provided for @loadIceConfigFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load ICE configuration: {error}'**
  String loadIceConfigFailed(String error);

  /// No description provided for @dynamicPlaylistCreatorOnly.
  ///
  /// In en, this message translates to:
  /// **'Only the creator can view this dynamic playlist'**
  String get dynamicPlaylistCreatorOnly;

  /// No description provided for @streamDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Stream disconnected'**
  String get streamDisconnected;

  /// No description provided for @disconnectStreamFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not disconnect the stream: {error}'**
  String disconnectStreamFailed(String error);

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @publisher.
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get publisher;

  /// No description provided for @unknownPublisher.
  ///
  /// In en, this message translates to:
  /// **'Unknown publisher'**
  String get unknownPublisher;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get startTime;

  /// No description provided for @mediaIdCopied.
  ///
  /// In en, this message translates to:
  /// **'Media ID copied'**
  String get mediaIdCopied;

  /// No description provided for @copyId.
  ///
  /// In en, this message translates to:
  /// **'Copy ID'**
  String get copyId;

  /// No description provided for @disconnectStream.
  ///
  /// In en, this message translates to:
  /// **'Disconnect stream'**
  String get disconnectStream;

  /// No description provided for @loadStreamDetailsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load stream details: {error}'**
  String loadStreamDetailsFailed(String error);

  /// No description provided for @requestApproved.
  ///
  /// In en, this message translates to:
  /// **'Request approved'**
  String get requestApproved;

  /// No description provided for @reviewFailed.
  ///
  /// In en, this message translates to:
  /// **'Review failed: {error}'**
  String reviewFailed(String error);

  /// No description provided for @requestRejected.
  ///
  /// In en, this message translates to:
  /// **'Request rejected'**
  String get requestRejected;

  /// No description provided for @memberAdded.
  ///
  /// In en, this message translates to:
  /// **'Member added'**
  String get memberAdded;

  /// No description provided for @addMemberFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not add the member: {error}'**
  String addMemberFailed(String error);

  /// No description provided for @memberRoleUpdated.
  ///
  /// In en, this message translates to:
  /// **'Member role updated'**
  String get memberRoleUpdated;

  /// No description provided for @updateRoleFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the role: {error}'**
  String updateRoleFailed(String error);

  /// No description provided for @memberPermissionsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Member permissions updated'**
  String get memberPermissionsUpdated;

  /// No description provided for @updatePermissionsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update permissions: {error}'**
  String updatePermissionsFailed(String error);

  /// No description provided for @remarkName.
  ///
  /// In en, this message translates to:
  /// **'Remark name'**
  String get remarkName;

  /// No description provided for @remarkNameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Remark name updated'**
  String get remarkNameUpdated;

  /// No description provided for @updateRemarkNameFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the remark name: {error}'**
  String updateRemarkNameFailed(String error);

  /// No description provided for @displayLabel.
  ///
  /// In en, this message translates to:
  /// **'Display label'**
  String get displayLabel;

  /// No description provided for @displayLabelUpdated.
  ///
  /// In en, this message translates to:
  /// **'Display label updated'**
  String get displayLabelUpdated;

  /// No description provided for @updateDisplayLabelFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the display label: {error}'**
  String updateDisplayLabelFailed(String error);

  /// No description provided for @transferOwnership.
  ///
  /// In en, this message translates to:
  /// **'Transfer ownership'**
  String get transferOwnership;

  /// No description provided for @confirmTransferOwnership.
  ///
  /// In en, this message translates to:
  /// **'Transfer room ownership to {user}?'**
  String confirmTransferOwnership(String user);

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @ownershipTransferred.
  ///
  /// In en, this message translates to:
  /// **'Room ownership transferred'**
  String get ownershipTransferred;

  /// No description provided for @transferFailed.
  ///
  /// In en, this message translates to:
  /// **'Transfer failed: {error}'**
  String transferFailed(String error);

  /// No description provided for @memberRemoved.
  ///
  /// In en, this message translates to:
  /// **'Member removed'**
  String get memberRemoved;

  /// No description provided for @removeMemberFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not remove the member: {error}'**
  String removeMemberFailed(String error);

  /// No description provided for @confirmRemoveMember.
  ///
  /// In en, this message translates to:
  /// **'Remove {user} from the room and set a cooldown before they can rejoin.'**
  String confirmRemoveMember(String user);

  /// No description provided for @resetSettings.
  ///
  /// In en, this message translates to:
  /// **'Reset settings'**
  String get resetSettings;

  /// No description provided for @resetRoomSettingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Restore access control, message switches, member permissions, and guest permissions to server defaults? Unsaved room policy changes will be overwritten.'**
  String get resetRoomSettingsDescription;

  /// No description provided for @settingsReset.
  ///
  /// In en, this message translates to:
  /// **'Settings reset'**
  String get settingsReset;

  /// No description provided for @resetFailed.
  ///
  /// In en, this message translates to:
  /// **'Reset failed: {error}'**
  String resetFailed(String error);

  /// No description provided for @confirmLeaveRoom.
  ///
  /// In en, this message translates to:
  /// **'Leave {room}?'**
  String confirmLeaveRoom(String room);

  /// No description provided for @leftRoom.
  ///
  /// In en, this message translates to:
  /// **'Left room'**
  String get leftRoom;

  /// No description provided for @leaveRoomFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not leave the room: {error}'**
  String leaveRoomFailed(String error);

  /// No description provided for @confirmPermanentRoomDeletion.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete {room}? This removes the room, playlist, and related room data.'**
  String confirmPermanentRoomDeletion(String room);

  /// No description provided for @dynamicContentReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Dynamic source content can only be viewed and opened'**
  String get dynamicContentReadOnly;

  /// No description provided for @newPlaylist.
  ///
  /// In en, this message translates to:
  /// **'New playlist'**
  String get newPlaylist;

  /// No description provided for @playlistCreated.
  ///
  /// In en, this message translates to:
  /// **'Playlist created'**
  String get playlistCreated;

  /// No description provided for @createPlaylistFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the playlist: {error}'**
  String createPlaylistFailed(String error);

  /// No description provided for @clearMediaLibrary.
  ///
  /// In en, this message translates to:
  /// **'Clear media library'**
  String get clearMediaLibrary;

  /// No description provided for @clearPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Clear playlist'**
  String get clearPlaylist;

  /// No description provided for @confirmClearMediaLibrary.
  ///
  /// In en, this message translates to:
  /// **'Clear media and playlists from the media library root?'**
  String get confirmClearMediaLibrary;

  /// No description provided for @confirmClearPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Clear media and child playlists from the current playlist? The playlist itself will remain.'**
  String get confirmClearPlaylist;

  /// No description provided for @mediaLibraryCleared.
  ///
  /// In en, this message translates to:
  /// **'Media library cleared'**
  String get mediaLibraryCleared;

  /// No description provided for @clearFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not clear content: {error}'**
  String clearFailed(String error);

  /// No description provided for @editPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Edit playlist'**
  String get editPlaylist;

  /// No description provided for @playlistBrowseAccess.
  ///
  /// In en, this message translates to:
  /// **'Browse access'**
  String get playlistBrowseAccess;

  /// No description provided for @playlistBrowseAccessDescription.
  ///
  /// In en, this message translates to:
  /// **'Default allows room members to browse static playlists and limits dynamic playlists to their creator.'**
  String get playlistBrowseAccessDescription;

  /// No description provided for @playlistBrowseAccessModeDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get playlistBrowseAccessModeDefault;

  /// No description provided for @playlistBrowseAccessModeRoomMembers.
  ///
  /// In en, this message translates to:
  /// **'Room members'**
  String get playlistBrowseAccessModeRoomMembers;

  /// No description provided for @playlistBrowseAccessModeCreatorOnly.
  ///
  /// In en, this message translates to:
  /// **'Creator only'**
  String get playlistBrowseAccessModeCreatorOnly;

  /// No description provided for @editMedia.
  ///
  /// In en, this message translates to:
  /// **'Edit media'**
  String get editMedia;

  /// No description provided for @nameUpdated.
  ///
  /// In en, this message translates to:
  /// **'Name updated'**
  String get nameUpdated;

  /// No description provided for @renameFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not rename the entry: {error}'**
  String renameFailed(String error);

  /// No description provided for @confirmDeletePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Delete playlist {name}? Its child playlists and media will also be removed from the room media library.'**
  String confirmDeletePlaylist(String name);

  /// No description provided for @confirmDeleteMedia.
  ///
  /// In en, this message translates to:
  /// **'Delete media {name}? It will be removed from the room media library and synchronized immediately.'**
  String confirmDeleteMedia(String name);

  /// No description provided for @entryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Entry deleted'**
  String get entryDeleted;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @liveMedia.
  ///
  /// In en, this message translates to:
  /// **'Live media'**
  String get liveMedia;

  /// No description provided for @parent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get parent;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @thumbnail.
  ///
  /// In en, this message translates to:
  /// **'Thumbnail'**
  String get thumbnail;

  /// No description provided for @childPlaylists.
  ///
  /// In en, this message translates to:
  /// **'Child playlists'**
  String get childPlaylists;

  /// No description provided for @mediaCount.
  ///
  /// In en, this message translates to:
  /// **'Media count'**
  String get mediaCount;

  /// No description provided for @metadata.
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get metadata;

  /// No description provided for @sourceConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Source configuration'**
  String get sourceConfiguration;

  /// No description provided for @idCopied.
  ///
  /// In en, this message translates to:
  /// **'ID copied'**
  String get idCopied;

  /// No description provided for @cover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get cover;

  /// No description provided for @loadEntryDetailsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load entry details: {error}'**
  String loadEntryDetailsFailed(String error);

  /// No description provided for @coverUpdated.
  ///
  /// In en, this message translates to:
  /// **'Cover updated'**
  String get coverUpdated;

  /// No description provided for @updateCoverFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the cover: {error}'**
  String updateCoverFailed(String error);

  /// No description provided for @coverRemoved.
  ///
  /// In en, this message translates to:
  /// **'Cover removed'**
  String get coverRemoved;

  /// No description provided for @removeCoverFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not remove the cover: {error}'**
  String removeCoverFailed(String error);

  /// No description provided for @thumbnailUpdated.
  ///
  /// In en, this message translates to:
  /// **'Thumbnail updated'**
  String get thumbnailUpdated;

  /// No description provided for @updateThumbnailFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the thumbnail: {error}'**
  String updateThumbnailFailed(String error);

  /// No description provided for @thumbnailRemoved.
  ///
  /// In en, this message translates to:
  /// **'Thumbnail removed'**
  String get thumbnailRemoved;

  /// No description provided for @removeThumbnailFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not remove the thumbnail: {error}'**
  String removeThumbnailFailed(String error);

  /// No description provided for @deletedMessageCannotEdit.
  ///
  /// In en, this message translates to:
  /// **'Deleted messages cannot be edited'**
  String get deletedMessageCannotEdit;

  /// No description provided for @messageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Message updated'**
  String get messageUpdated;

  /// No description provided for @editMessageFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not edit the message: {error}'**
  String editMessageFailed(String error);

  /// No description provided for @editMessage.
  ///
  /// In en, this message translates to:
  /// **'Edit message'**
  String get editMessage;

  /// No description provided for @deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete message'**
  String get deleteMessage;

  /// No description provided for @confirmDeleteChatMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete this chat message? It will be removed from every member\'\'s chat history.'**
  String get confirmDeleteChatMessage;

  /// No description provided for @roomReportManagement.
  ///
  /// In en, this message translates to:
  /// **'Reports for {room}'**
  String roomReportManagement(String room);

  /// No description provided for @reportRoom.
  ///
  /// In en, this message translates to:
  /// **'Report room'**
  String get reportRoom;

  /// No description provided for @messageContext.
  ///
  /// In en, this message translates to:
  /// **'Message context'**
  String get messageContext;

  /// No description provided for @loadMessageContextFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load message context: {error}'**
  String loadMessageContextFailed(String error);

  /// No description provided for @mediaItemsMoved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 media item moved} other{{count} media items moved}}'**
  String mediaItemsMoved(int count);

  /// No description provided for @moveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not move media: {error}'**
  String moveFailed(String error);

  /// No description provided for @playlistOrderUpdated.
  ///
  /// In en, this message translates to:
  /// **'Playlist order updated'**
  String get playlistOrderUpdated;

  /// No description provided for @reorderFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not reorder the playlist: {error}'**
  String reorderFailed(String error);

  /// No description provided for @moveMedia.
  ///
  /// In en, this message translates to:
  /// **'Move media'**
  String get moveMedia;

  /// No description provided for @parentId.
  ///
  /// In en, this message translates to:
  /// **'Parent {id}'**
  String parentId(String id);

  /// No description provided for @rejectRequest.
  ///
  /// In en, this message translates to:
  /// **'Reject request'**
  String get rejectRequest;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @addMember.
  ///
  /// In en, this message translates to:
  /// **'Add member'**
  String get addMember;

  /// No description provided for @sendNotification.
  ///
  /// In en, this message translates to:
  /// **'Send notification'**
  String get sendNotification;

  /// No description provided for @changeRole.
  ///
  /// In en, this message translates to:
  /// **'Change role'**
  String get changeRole;

  /// No description provided for @permissionOverrides.
  ///
  /// In en, this message translates to:
  /// **'Permission overrides'**
  String get permissionOverrides;

  /// No description provided for @clearOverrides.
  ///
  /// In en, this message translates to:
  /// **'Clear overrides'**
  String get clearOverrides;

  /// No description provided for @inherit.
  ///
  /// In en, this message translates to:
  /// **'Inherit'**
  String get inherit;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @deny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get deny;

  /// No description provided for @maximumMembers.
  ///
  /// In en, this message translates to:
  /// **'Maximum members'**
  String get maximumMembers;

  /// No description provided for @zeroMeansUnlimited.
  ///
  /// In en, this message translates to:
  /// **'0 means unlimited'**
  String get zeroMeansUnlimited;

  /// No description provided for @accessControl.
  ///
  /// In en, this message translates to:
  /// **'Access control'**
  String get accessControl;

  /// No description provided for @allowGuestJoin.
  ///
  /// In en, this message translates to:
  /// **'Allow guests to join'**
  String get allowGuestJoin;

  /// No description provided for @guestTokenCurrentRoomOnly.
  ///
  /// In en, this message translates to:
  /// **'A guest token can access only this room'**
  String get guestTokenCurrentRoomOnly;

  /// No description provided for @joinRequiresApproval.
  ///
  /// In en, this message translates to:
  /// **'Require approval to join'**
  String get joinRequiresApproval;

  /// No description provided for @newMembersRequireApproval.
  ///
  /// In en, this message translates to:
  /// **'New member requests require administrator approval'**
  String get newMembersRequireApproval;

  /// No description provided for @allowAutomaticJoin.
  ///
  /// In en, this message translates to:
  /// **'Allow automatic joining'**
  String get allowAutomaticJoin;

  /// No description provided for @automaticJoinDescription.
  ///
  /// In en, this message translates to:
  /// **'When disabled, members can join only by invitation or administrator action'**
  String get automaticJoinDescription;

  /// No description provided for @regularMemberPermissions.
  ///
  /// In en, this message translates to:
  /// **'Regular member permissions'**
  String get regularMemberPermissions;

  /// No description provided for @sendChatAndDanmaku.
  ///
  /// In en, this message translates to:
  /// **'Send chat and danmaku'**
  String get sendChatAndDanmaku;

  /// No description provided for @browseLibraryList.
  ///
  /// In en, this message translates to:
  /// **'Browse library'**
  String get browseLibraryList;

  /// No description provided for @viewMemberList.
  ///
  /// In en, this message translates to:
  /// **'View member list'**
  String get viewMemberList;

  /// No description provided for @viewChatHistory.
  ///
  /// In en, this message translates to:
  /// **'View chat history'**
  String get viewChatHistory;

  /// No description provided for @webrtcCalls.
  ///
  /// In en, this message translates to:
  /// **'WebRTC calls'**
  String get webrtcCalls;

  /// No description provided for @guestPermissions.
  ///
  /// In en, this message translates to:
  /// **'Guest permissions'**
  String get guestPermissions;

  /// No description provided for @settingsActions.
  ///
  /// In en, this message translates to:
  /// **'Settings actions'**
  String get settingsActions;

  /// No description provided for @savingSettings.
  ///
  /// In en, this message translates to:
  /// **'Saving settings'**
  String get savingSettings;

  /// No description provided for @saveRoomPolicyDescription.
  ///
  /// In en, this message translates to:
  /// **'Save access control, message switches, and permission policies'**
  String get saveRoomPolicyDescription;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save settings'**
  String get saveSettings;

  /// No description provided for @resetRoomSettings.
  ///
  /// In en, this message translates to:
  /// **'Reset room settings'**
  String get resetRoomSettings;

  /// No description provided for @restoreServerRoomPolicy.
  ///
  /// In en, this message translates to:
  /// **'Restore the server default room policy'**
  String get restoreServerRoomPolicy;

  /// No description provided for @activeStreams.
  ///
  /// In en, this message translates to:
  /// **'Active streams'**
  String get activeStreams;

  /// No description provided for @mediaId.
  ///
  /// In en, this message translates to:
  /// **'Media ID'**
  String get mediaId;

  /// No description provided for @mediaIdAscending.
  ///
  /// In en, this message translates to:
  /// **'Media ID ascending'**
  String get mediaIdAscending;

  /// No description provided for @mediaIdDescending.
  ///
  /// In en, this message translates to:
  /// **'Media ID descending'**
  String get mediaIdDescending;

  /// No description provided for @pagedItemSummary.
  ///
  /// In en, this message translates to:
  /// **'Page {page} · {pageSize} per page · {total} total'**
  String pagedItemSummary(int page, int pageSize, int total);

  /// No description provided for @noActiveStreams.
  ///
  /// In en, this message translates to:
  /// **'No active streams'**
  String get noActiveStreams;

  /// No description provided for @joinRequests.
  ///
  /// In en, this message translates to:
  /// **'Join requests'**
  String get joinRequests;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @noJoinRequests.
  ///
  /// In en, this message translates to:
  /// **'No join requests'**
  String get noJoinRequests;

  /// No description provided for @clearCurrentLevel.
  ///
  /// In en, this message translates to:
  /// **'Clear current level'**
  String get clearCurrentLevel;

  /// No description provided for @refreshDynamicList.
  ///
  /// In en, this message translates to:
  /// **'Refresh dynamic list'**
  String get refreshDynamicList;

  /// No description provided for @searchMediaOrPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Search media or playlist'**
  String get searchMediaOrPlaylist;

  /// No description provided for @availability.
  ///
  /// In en, this message translates to:
  /// **'Availability'**
  String get availability;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @addedAt.
  ///
  /// In en, this message translates to:
  /// **'Added at'**
  String get addedAt;

  /// No description provided for @noMediaEntriesAtCurrentLevel.
  ///
  /// In en, this message translates to:
  /// **'No media entries at this level'**
  String get noMediaEntriesAtCurrentLevel;

  /// No description provided for @realtimeDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Realtime diagnostics'**
  String get realtimeDiagnostics;

  /// No description provided for @copyDiagnostics.
  ///
  /// In en, this message translates to:
  /// **'Copy diagnostics'**
  String get copyDiagnostics;

  /// No description provided for @resetWatches.
  ///
  /// In en, this message translates to:
  /// **'Reset watches'**
  String get resetWatches;

  /// No description provided for @resources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get resources;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @watchEventsDescription.
  ///
  /// In en, this message translates to:
  /// **'Watch requests and resource events appear here'**
  String get watchEventsDescription;

  /// No description provided for @roomSettings.
  ///
  /// In en, this message translates to:
  /// **'Room settings'**
  String get roomSettings;

  /// No description provided for @roomSettingsShort.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get roomSettingsShort;

  /// No description provided for @watchingSettingChanges.
  ///
  /// In en, this message translates to:
  /// **'Watching setting changes'**
  String get watchingSettingChanges;

  /// No description provided for @memberList.
  ///
  /// In en, this message translates to:
  /// **'Member list'**
  String get memberList;

  /// No description provided for @refreshingMembers.
  ///
  /// In en, this message translates to:
  /// **'Refreshing members'**
  String get refreshingMembers;

  /// No description provided for @onlineTotalSummary.
  ///
  /// In en, this message translates to:
  /// **'{online} online / {total} total'**
  String onlineTotalSummary(int online, int total);

  /// No description provided for @mediaList.
  ///
  /// In en, this message translates to:
  /// **'Media list'**
  String get mediaList;

  /// No description provided for @waitingForMediaSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Waiting for media snapshot'**
  String get waitingForMediaSnapshot;

  /// No description provided for @playlistMediaSummary.
  ///
  /// In en, this message translates to:
  /// **'{playlists, plural, =1{1 playlist} other{{playlists} playlists}} / {media, plural, =1{1 media item} other{{media} media items}}'**
  String playlistMediaSummary(int playlists, int media);

  /// No description provided for @chatEvents.
  ///
  /// In en, this message translates to:
  /// **'Chat events'**
  String get chatEvents;

  /// No description provided for @refreshingChatHistory.
  ///
  /// In en, this message translates to:
  /// **'Refreshing chat history'**
  String get refreshingChatHistory;

  /// No description provided for @chatHistoryCount.
  ///
  /// In en, this message translates to:
  /// **'Chat history: {count, plural, =1{1 item} other{{count} items}}'**
  String chatHistoryCount(int count);

  /// No description provided for @watchedResources.
  ///
  /// In en, this message translates to:
  /// **'Watched resources'**
  String get watchedResources;

  /// No description provided for @sentReceived.
  ///
  /// In en, this message translates to:
  /// **'Sent / received'**
  String get sentReceived;

  /// No description provided for @errors.
  ///
  /// In en, this message translates to:
  /// **'Errors'**
  String get errors;

  /// No description provided for @runtimeSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Runtime snapshot'**
  String get runtimeSnapshot;

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @currentMediaLocation.
  ///
  /// In en, this message translates to:
  /// **'Current media location'**
  String get currentMediaLocation;

  /// No description provided for @watchStatus.
  ///
  /// In en, this message translates to:
  /// **'Watch status'**
  String get watchStatus;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'Not provided'**
  String get notProvided;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get waiting;

  /// No description provided for @localItems.
  ///
  /// In en, this message translates to:
  /// **'Local items'**
  String get localItems;

  /// No description provided for @latestEvent.
  ///
  /// In en, this message translates to:
  /// **'Latest event'**
  String get latestEvent;

  /// No description provided for @eventCounts.
  ///
  /// In en, this message translates to:
  /// **'Event counts'**
  String get eventCounts;

  /// No description provided for @lastTime.
  ///
  /// In en, this message translates to:
  /// **'Last time'**
  String get lastTime;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @observedWithChanges.
  ///
  /// In en, this message translates to:
  /// **'Observed with changes'**
  String get observedWithChanges;

  /// No description provided for @observedWithoutChanges.
  ///
  /// In en, this message translates to:
  /// **'Observed without changes'**
  String get observedWithoutChanges;

  /// No description provided for @snapshotPushed.
  ///
  /// In en, this message translates to:
  /// **'Snapshot pushed'**
  String get snapshotPushed;

  /// No description provided for @chatHistory.
  ///
  /// In en, this message translates to:
  /// **'Chat history'**
  String get chatHistory;

  /// No description provided for @searchChatContent.
  ///
  /// In en, this message translates to:
  /// **'Search chat content'**
  String get searchChatContent;

  /// No description provided for @searchQuery.
  ///
  /// In en, this message translates to:
  /// **'Search “{query}”'**
  String searchQuery(String query);

  /// No description provided for @noMatchingChatMessages.
  ///
  /// In en, this message translates to:
  /// **'No matching chat messages'**
  String get noMatchingChatMessages;

  /// No description provided for @noChatHistory.
  ///
  /// In en, this message translates to:
  /// **'No chat history'**
  String get noChatHistory;

  /// No description provided for @iceServers.
  ///
  /// In en, this message translates to:
  /// **'ICE servers'**
  String get iceServers;

  /// No description provided for @noIceServers.
  ///
  /// In en, this message translates to:
  /// **'No ICE server configuration'**
  String get noIceServers;

  /// No description provided for @roomMembers.
  ///
  /// In en, this message translates to:
  /// **'Room members'**
  String get roomMembers;

  /// No description provided for @usernameOrUserId.
  ///
  /// In en, this message translates to:
  /// **'Username or user ID'**
  String get usernameOrUserId;

  /// No description provided for @allRoles.
  ///
  /// In en, this message translates to:
  /// **'All roles'**
  String get allRoles;

  /// No description provided for @roomOwner.
  ///
  /// In en, this message translates to:
  /// **'Room owner'**
  String get roomOwner;

  /// No description provided for @joinedAt.
  ///
  /// In en, this message translates to:
  /// **'Joined at'**
  String get joinedAt;

  /// No description provided for @noMembers.
  ///
  /// In en, this message translates to:
  /// **'No members'**
  String get noMembers;

  /// No description provided for @onlineMemberSummary.
  ///
  /// In en, this message translates to:
  /// **'{online} online / {members} members'**
  String onlineMemberSummary(int online, int members);

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @mediaActions.
  ///
  /// In en, this message translates to:
  /// **'Media actions'**
  String get mediaActions;

  /// No description provided for @updateCover.
  ///
  /// In en, this message translates to:
  /// **'Update cover'**
  String get updateCover;

  /// No description provided for @removeCover.
  ///
  /// In en, this message translates to:
  /// **'Remove cover'**
  String get removeCover;

  /// No description provided for @updateThumbnail.
  ///
  /// In en, this message translates to:
  /// **'Update thumbnail'**
  String get updateThumbnail;

  /// No description provided for @removeThumbnail.
  ///
  /// In en, this message translates to:
  /// **'Remove thumbnail'**
  String get removeThumbnail;

  /// No description provided for @moveUp.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get moveUp;

  /// No description provided for @moveDown.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get moveDown;

  /// No description provided for @moveTo.
  ///
  /// In en, this message translates to:
  /// **'Move to...'**
  String get moveTo;

  /// No description provided for @imageMessagePlain.
  ///
  /// In en, this message translates to:
  /// **'Image message'**
  String get imageMessagePlain;

  /// No description provided for @viewContext.
  ///
  /// In en, this message translates to:
  /// **'View context'**
  String get viewContext;

  /// No description provided for @viewReports.
  ///
  /// In en, this message translates to:
  /// **'View reports'**
  String get viewReports;

  /// No description provided for @messageReports.
  ///
  /// In en, this message translates to:
  /// **'Reports for message #{id}'**
  String messageReports(String id);

  /// No description provided for @tapToViewContext.
  ///
  /// In en, this message translates to:
  /// **'Tap to view context'**
  String get tapToViewContext;

  /// No description provided for @viewReactionMembers.
  ///
  /// In en, this message translates to:
  /// **'View reacting members'**
  String get viewReactionMembers;

  /// No description provided for @anonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// No description provided for @creatorOnlyMode.
  ///
  /// In en, this message translates to:
  /// **'{mode} · Creator only'**
  String creatorOnlyMode(String mode);

  /// No description provided for @dynamicMediaSize.
  ///
  /// In en, this message translates to:
  /// **'{size, plural, =0{Dynamic media} other{Dynamic media · {size} bytes}}'**
  String dynamicMediaSize(int size);

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @joinedAtValue.
  ///
  /// In en, this message translates to:
  /// **'Joined {value}'**
  String joinedAtValue(String value);

  /// No description provided for @removeFromRoom.
  ///
  /// In en, this message translates to:
  /// **'Remove from room'**
  String get removeFromRoom;

  /// No description provided for @viewMemberReports.
  ///
  /// In en, this message translates to:
  /// **'View member reports'**
  String get viewMemberReports;

  /// No description provided for @memberReports.
  ///
  /// In en, this message translates to:
  /// **'Member reports for {user}'**
  String memberReports(String user);

  /// No description provided for @moreMemberActions.
  ///
  /// In en, this message translates to:
  /// **'More member actions'**
  String get moreMemberActions;

  /// No description provided for @ownerAccount.
  ///
  /// In en, this message translates to:
  /// **'Owner account'**
  String get ownerAccount;

  /// No description provided for @roomInformation.
  ///
  /// In en, this message translates to:
  /// **'Room information'**
  String get roomInformation;

  /// No description provided for @configured.
  ///
  /// In en, this message translates to:
  /// **'Configured'**
  String get configured;

  /// No description provided for @notConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get notConfigured;

  /// No description provided for @emptyRemovesRoomPassword.
  ///
  /// In en, this message translates to:
  /// **'Submit an empty value to remove the room password'**
  String get emptyRemovesRoomPassword;

  /// No description provided for @roomCurrentlyRequiresPassword.
  ///
  /// In en, this message translates to:
  /// **'This room currently requires a password'**
  String get roomCurrentlyRequiresPassword;

  /// No description provided for @roomCurrentlyNoPassword.
  ///
  /// In en, this message translates to:
  /// **'This room currently has no password'**
  String get roomCurrentlyNoPassword;

  /// No description provided for @roomActions.
  ///
  /// In en, this message translates to:
  /// **'Room actions'**
  String get roomActions;

  /// No description provided for @leaveRoomTileDescription.
  ///
  /// In en, this message translates to:
  /// **'You must join again to access member content after leaving'**
  String get leaveRoomTileDescription;

  /// No description provided for @unspecified.
  ///
  /// In en, this message translates to:
  /// **'Unspecified'**
  String get unspecified;

  /// No description provided for @unknownTime.
  ///
  /// In en, this message translates to:
  /// **'Unknown time'**
  String get unknownTime;

  /// No description provided for @waitingForEvent.
  ///
  /// In en, this message translates to:
  /// **'Waiting for event'**
  String get waitingForEvent;

  /// No description provided for @messageContent.
  ///
  /// In en, this message translates to:
  /// **'Message content'**
  String get messageContent;

  /// No description provided for @systemManagement.
  ///
  /// In en, this message translates to:
  /// **'System management'**
  String get systemManagement;

  /// No description provided for @administrators.
  ///
  /// In en, this message translates to:
  /// **'Administrators'**
  String get administrators;

  /// No description provided for @categoriesAndLabels.
  ///
  /// In en, this message translates to:
  /// **'Categories and labels'**
  String get categoriesAndLabels;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @bans.
  ///
  /// In en, this message translates to:
  /// **'Bans'**
  String get bans;

  /// No description provided for @loadOverviewFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the overview: {error}'**
  String loadOverviewFailed(String error);

  /// No description provided for @noStatistics.
  ///
  /// In en, this message translates to:
  /// **'No statistics available'**
  String get noStatistics;

  /// No description provided for @activeUsers.
  ///
  /// In en, this message translates to:
  /// **'Active users'**
  String get activeUsers;

  /// No description provided for @onlineMembersLabel.
  ///
  /// In en, this message translates to:
  /// **'Online members'**
  String get onlineMembersLabel;

  /// No description provided for @onlineGuestsLabel.
  ///
  /// In en, this message translates to:
  /// **'Online guests'**
  String get onlineGuestsLabel;

  /// No description provided for @bannedUsers.
  ///
  /// In en, this message translates to:
  /// **'Banned users'**
  String get bannedUsers;

  /// No description provided for @activeRooms.
  ///
  /// In en, this message translates to:
  /// **'Active rooms'**
  String get activeRooms;

  /// No description provided for @onlineRooms.
  ///
  /// In en, this message translates to:
  /// **'Online rooms'**
  String get onlineRooms;

  /// No description provided for @loadAdministratorsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load administrators: {error}'**
  String loadAdministratorsFailed(String error);

  /// No description provided for @addAdministrator.
  ///
  /// In en, this message translates to:
  /// **'Add administrator'**
  String get addAdministrator;

  /// No description provided for @addAdministratorDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a new administrator or promote an existing user.'**
  String get addAdministratorDescription;

  /// No description provided for @promoteExistingUser.
  ///
  /// In en, this message translates to:
  /// **'Promote existing user'**
  String get promoteExistingUser;

  /// No description provided for @createAdministrator.
  ///
  /// In en, this message translates to:
  /// **'Create administrator'**
  String get createAdministrator;

  /// No description provided for @usernameAndPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a username and password'**
  String get usernameAndPasswordRequired;

  /// No description provided for @administratorAdded.
  ///
  /// In en, this message translates to:
  /// **'Administrator added'**
  String get administratorAdded;

  /// No description provided for @existingUserIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an existing user ID'**
  String get existingUserIdRequired;

  /// No description provided for @promote.
  ///
  /// In en, this message translates to:
  /// **'Promote'**
  String get promote;

  /// No description provided for @userIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a user ID'**
  String get userIdRequired;

  /// No description provided for @removeAdministrator.
  ///
  /// In en, this message translates to:
  /// **'Remove administrator'**
  String get removeAdministrator;

  /// No description provided for @administratorRemoved.
  ///
  /// In en, this message translates to:
  /// **'Administrator removed'**
  String get administratorRemoved;

  /// No description provided for @removeFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not remove the administrator: {error}'**
  String removeFailed(String error);

  /// No description provided for @administratorCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 administrator} other{{count} administrators}}'**
  String administratorCount(int count);

  /// No description provided for @searchAdministrators.
  ///
  /// In en, this message translates to:
  /// **'Search administrators'**
  String get searchAdministrators;

  /// No description provided for @itemsPerPage.
  ///
  /// In en, this message translates to:
  /// **'{count} / page'**
  String itemsPerPage(int count);

  /// No description provided for @noAdministrators.
  ///
  /// In en, this message translates to:
  /// **'No administrators'**
  String get noAdministrators;

  /// No description provided for @pageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {pageCount}'**
  String pageOf(int page, int pageCount);

  /// No description provided for @cannotRemoveCurrentAdministrator.
  ///
  /// In en, this message translates to:
  /// **'You cannot remove your own administrator access'**
  String get cannotRemoveCurrentAdministrator;

  /// No description provided for @keepAtLeastOneAdministrator.
  ///
  /// In en, this message translates to:
  /// **'At least one administrator must remain'**
  String get keepAtLeastOneAdministrator;

  /// No description provided for @allStatuses.
  ///
  /// In en, this message translates to:
  /// **'All statuses'**
  String get allStatuses;

  /// No description provided for @allBanStates.
  ///
  /// In en, this message translates to:
  /// **'All ban states'**
  String get allBanStates;

  /// No description provided for @bannedOnly.
  ///
  /// In en, this message translates to:
  /// **'Banned only'**
  String get bannedOnly;

  /// No description provided for @notBanned.
  ///
  /// In en, this message translates to:
  /// **'Not banned'**
  String get notBanned;

  /// No description provided for @ban.
  ///
  /// In en, this message translates to:
  /// **'Ban'**
  String get ban;

  /// No description provided for @unban.
  ///
  /// In en, this message translates to:
  /// **'Unban'**
  String get unban;

  /// No description provided for @roomAction.
  ///
  /// In en, this message translates to:
  /// **'{action} room'**
  String roomAction(String action);

  /// No description provided for @confirmRoomAction.
  ///
  /// In en, this message translates to:
  /// **'{action} room \"{roomName}\"?'**
  String confirmRoomAction(String action, String roomName);

  /// No description provided for @permanentlyDeleteRoom.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete room \"{roomName}\".'**
  String permanentlyDeleteRoom(String roomName);

  /// No description provided for @allMembersLoseAccess.
  ///
  /// In en, this message translates to:
  /// **'All members will lose access to the room.'**
  String get allMembersLoseAccess;

  /// No description provided for @roomDataWillBeCleared.
  ///
  /// In en, this message translates to:
  /// **'Room settings, media, and related data will be cleared.'**
  String get roomDataWillBeCleared;

  /// No description provided for @watchingMembersWillExit.
  ///
  /// In en, this message translates to:
  /// **'Connected viewers will be removed immediately.'**
  String get watchingMembersWillExit;

  /// No description provided for @batchBanRooms.
  ///
  /// In en, this message translates to:
  /// **'Ban rooms'**
  String get batchBanRooms;

  /// No description provided for @roomsWillBeBanned.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 room will be banned.} other{{count} rooms will be banned.}}'**
  String roomsWillBeBanned(int count);

  /// No description provided for @batchBanCompleted.
  ///
  /// In en, this message translates to:
  /// **'Room ban completed'**
  String get batchBanCompleted;

  /// No description provided for @batchBanFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not ban rooms: {error}'**
  String batchBanFailed(String error);

  /// No description provided for @batchDeleteRooms.
  ///
  /// In en, this message translates to:
  /// **'Delete rooms'**
  String get batchDeleteRooms;

  /// No description provided for @roomsWillBeDeleted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 room will be permanently deleted.} other{{count} rooms will be permanently deleted.}}'**
  String roomsWillBeDeleted(int count);

  /// No description provided for @relatedMembersLoseAccess.
  ///
  /// In en, this message translates to:
  /// **'Related members will lose access to these rooms.'**
  String get relatedMembersLoseAccess;

  /// No description provided for @batchDeleteBackupOnly.
  ///
  /// In en, this message translates to:
  /// **'Deleted data can be restored only from a backup.'**
  String get batchDeleteBackupOnly;

  /// No description provided for @batchDeleteCompleted.
  ///
  /// In en, this message translates to:
  /// **'Room deletion completed'**
  String get batchDeleteCompleted;

  /// No description provided for @batchDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete rooms: {error}'**
  String batchDeleteFailed(String error);

  /// No description provided for @batchResultSuccess.
  ///
  /// In en, this message translates to:
  /// **'{title}: {succeeded} succeeded'**
  String batchResultSuccess(String title, int succeeded);

  /// No description provided for @batchResultMixed.
  ///
  /// In en, this message translates to:
  /// **'{title}: {succeeded} succeeded, {failed} failed'**
  String batchResultMixed(String title, int succeeded, int failed);

  /// No description provided for @memberCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Member count'**
  String get memberCountLabel;

  /// No description provided for @creatorStatus.
  ///
  /// In en, this message translates to:
  /// **'Creator status'**
  String get creatorStatus;

  /// No description provided for @resourceAvailability.
  ///
  /// In en, this message translates to:
  /// **'Resource availability'**
  String get resourceAvailability;

  /// No description provided for @passwordAction.
  ///
  /// In en, this message translates to:
  /// **'Password action'**
  String get passwordAction;

  /// No description provided for @keepUnchanged.
  ///
  /// In en, this message translates to:
  /// **'Keep unchanged'**
  String get keepUnchanged;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set new password'**
  String get setNewPassword;

  /// No description provided for @clearPassword.
  ///
  /// In en, this message translates to:
  /// **'Clear password'**
  String get clearPassword;

  /// No description provided for @newPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the new password'**
  String get newPasswordRequired;

  /// No description provided for @roomReports.
  ///
  /// In en, this message translates to:
  /// **'Reports for {roomName}'**
  String roomReports(String roomName);

  /// No description provided for @reportRecords.
  ///
  /// In en, this message translates to:
  /// **'Report records'**
  String get reportRecords;

  /// No description provided for @loadRoomDetailsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load room details: {error}'**
  String loadRoomDetailsFailed(String error);

  /// No description provided for @categoriesLabelsSaved.
  ///
  /// In en, this message translates to:
  /// **'Categories and labels saved'**
  String get categoriesLabelsSaved;

  /// No description provided for @saveCategoriesLabelsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save categories and labels: {error}'**
  String saveCategoriesLabelsFailed(String error);

  /// No description provided for @searchMembers.
  ///
  /// In en, this message translates to:
  /// **'Search members'**
  String get searchMembers;

  /// No description provided for @memberAdminSummary.
  ///
  /// In en, this message translates to:
  /// **'{total} members · {online} online · {connections} connections'**
  String memberAdminSummary(int total, int online, int connections);

  /// No description provided for @memberPageSummary.
  ///
  /// In en, this message translates to:
  /// **'{total} members · Page {page} of {pageCount}'**
  String memberPageSummary(int total, int page, int pageCount);

  /// No description provided for @toggleAdministrator.
  ///
  /// In en, this message translates to:
  /// **'Toggle administrator role'**
  String get toggleAdministrator;

  /// No description provided for @notifyMember.
  ///
  /// In en, this message translates to:
  /// **'Notify member'**
  String get notifyMember;

  /// No description provided for @roomRole.
  ///
  /// In en, this message translates to:
  /// **'Room role'**
  String get roomRole;

  /// No description provided for @roomSettingsReset.
  ///
  /// In en, this message translates to:
  /// **'Room settings reset'**
  String get roomSettingsReset;

  /// No description provided for @roomSettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Room settings saved'**
  String get roomSettingsSaved;

  /// No description provided for @saveRoomSettingsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save room settings: {error}'**
  String saveRoomSettingsFailed(String error);

  /// No description provided for @selectCurrentPage.
  ///
  /// In en, this message translates to:
  /// **'Select current page'**
  String get selectCurrentPage;

  /// No description provided for @selectRoom.
  ///
  /// In en, this message translates to:
  /// **'Select room'**
  String get selectRoom;

  /// No description provided for @roomsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 room selected} other{{count} rooms selected}}'**
  String roomsSelected(int count);

  /// No description provided for @roomCategories.
  ///
  /// In en, this message translates to:
  /// **'Room categories'**
  String get roomCategories;

  /// No description provided for @loadCategoriesLabelsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load categories and labels: {error}'**
  String loadCategoriesLabelsFailed(String error);

  /// No description provided for @categoryNotBound.
  ///
  /// In en, this message translates to:
  /// **'No category assigned'**
  String get categoryNotBound;

  /// No description provided for @unknownCategory.
  ///
  /// In en, this message translates to:
  /// **'Unknown category'**
  String get unknownCategory;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get addCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get editCategory;

  /// No description provided for @identifier.
  ///
  /// In en, this message translates to:
  /// **'Identifier'**
  String get identifier;

  /// No description provided for @categoryIdentifierExample.
  ///
  /// In en, this message translates to:
  /// **'Example: movies'**
  String get categoryIdentifierExample;

  /// No description provided for @categoryNameExample.
  ///
  /// In en, this message translates to:
  /// **'Example: Movies'**
  String get categoryNameExample;

  /// No description provided for @lowerNumberFirst.
  ///
  /// In en, this message translates to:
  /// **'Lower numbers appear first'**
  String get lowerNumberFirst;

  /// No description provided for @enableCategory.
  ///
  /// In en, this message translates to:
  /// **'Enable category'**
  String get enableCategory;

  /// No description provided for @categoryIdAndNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the category identifier and name'**
  String get categoryIdAndNameRequired;

  /// No description provided for @sortMustBeInteger.
  ///
  /// In en, this message translates to:
  /// **'Sort order must be an integer'**
  String get sortMustBeInteger;

  /// No description provided for @categorySaved.
  ///
  /// In en, this message translates to:
  /// **'Category saved'**
  String get categorySaved;

  /// No description provided for @saveCategoryFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the category: {error}'**
  String saveCategoryFailed(String error);

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete category'**
  String get deleteCategory;

  /// No description provided for @permanentlyDeleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete category \"{category}\".'**
  String permanentlyDeleteCategory(String category);

  /// No description provided for @roomsLoseCategory.
  ///
  /// In en, this message translates to:
  /// **'Rooms using this category will become uncategorized.'**
  String get roomsLoseCategory;

  /// No description provided for @categoryChangesImmediate.
  ///
  /// In en, this message translates to:
  /// **'The category change takes effect immediately.'**
  String get categoryChangesImmediate;

  /// No description provided for @categoryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Category deleted'**
  String get categoryDeleted;

  /// No description provided for @deleteCategoryFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the category: {error}'**
  String deleteCategoryFailed(String error);

  /// No description provided for @addLabel.
  ///
  /// In en, this message translates to:
  /// **'Add label'**
  String get addLabel;

  /// No description provided for @editLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit label'**
  String get editLabel;

  /// No description provided for @labelIdentifierExample.
  ///
  /// In en, this message translates to:
  /// **'Example: sci-fi'**
  String get labelIdentifierExample;

  /// No description provided for @labelNameExample.
  ///
  /// In en, this message translates to:
  /// **'Example: Science fiction'**
  String get labelNameExample;

  /// No description provided for @parentCategory.
  ///
  /// In en, this message translates to:
  /// **'Parent category'**
  String get parentCategory;

  /// No description provided for @noCategoryBinding.
  ///
  /// In en, this message translates to:
  /// **'No category binding'**
  String get noCategoryBinding;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @enableLabel.
  ///
  /// In en, this message translates to:
  /// **'Enable label'**
  String get enableLabel;

  /// No description provided for @labelIdAndNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the label identifier and name'**
  String get labelIdAndNameRequired;

  /// No description provided for @colorFormatExample.
  ///
  /// In en, this message translates to:
  /// **'Use a hex color such as #5D5FEF'**
  String get colorFormatExample;

  /// No description provided for @labelSaved.
  ///
  /// In en, this message translates to:
  /// **'Label saved'**
  String get labelSaved;

  /// No description provided for @saveLabelFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the label: {error}'**
  String saveLabelFailed(String error);

  /// No description provided for @deleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete label'**
  String get deleteLabel;

  /// No description provided for @permanentlyDeleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete label \"{label}\".'**
  String permanentlyDeleteLabel(String label);

  /// No description provided for @roomsLoseLabel.
  ///
  /// In en, this message translates to:
  /// **'Rooms using this label will lose the label.'**
  String get roomsLoseLabel;

  /// No description provided for @labelChangesImmediate.
  ///
  /// In en, this message translates to:
  /// **'The label change takes effect immediately.'**
  String get labelChangesImmediate;

  /// No description provided for @labelDeleted.
  ///
  /// In en, this message translates to:
  /// **'Label deleted'**
  String get labelDeleted;

  /// No description provided for @deleteLabelFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the label: {error}'**
  String deleteLabelFailed(String error);

  /// No description provided for @noCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories'**
  String get noCategories;

  /// No description provided for @addCategoriesDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a category to organize rooms.'**
  String get addCategoriesDescription;

  /// No description provided for @addLabelsDescription.
  ///
  /// In en, this message translates to:
  /// **'Add labels to help members discover rooms.'**
  String get addLabelsDescription;

  /// No description provided for @defaultColor.
  ///
  /// In en, this message translates to:
  /// **'Default color'**
  String get defaultColor;

  /// No description provided for @loadUserDetailsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load user details: {error}'**
  String loadUserDetailsFailed(String error);

  /// No description provided for @reportsAgainstUser.
  ///
  /// In en, this message translates to:
  /// **'Reports against user'**
  String get reportsAgainstUser;

  /// No description provided for @reportsByUser.
  ///
  /// In en, this message translates to:
  /// **'Reports submitted by user'**
  String get reportsByUser;

  /// No description provided for @bannedAt.
  ///
  /// In en, this message translates to:
  /// **'Banned at'**
  String get bannedAt;

  /// No description provided for @bannedBy.
  ///
  /// In en, this message translates to:
  /// **'Banned by'**
  String get bannedBy;

  /// No description provided for @loadUserRoomsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the user\'\'s rooms: {error}'**
  String loadUserRoomsFailed(String error);

  /// No description provided for @preferencesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Preferences updated'**
  String get preferencesUpdated;

  /// No description provided for @savePreferencesFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save preferences: {error}'**
  String savePreferencesFailed(String error);

  /// No description provided for @authenticationFactorsSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} available factors: password {passwordStatus}, email {emailStatus}, passkey {passkeyStatus}'**
  String authenticationFactorsSummary(
    int count,
    String passwordStatus,
    String emailStatus,
    String passkeyStatus,
  );

  /// No description provided for @roomInvitationInAppNotification.
  ///
  /// In en, this message translates to:
  /// **'In-app room invitation notifications'**
  String get roomInvitationInAppNotification;

  /// No description provided for @roomEventInAppNotification.
  ///
  /// In en, this message translates to:
  /// **'In-app room event notifications'**
  String get roomEventInAppNotification;

  /// No description provided for @systemAnnouncementInAppNotification.
  ///
  /// In en, this message translates to:
  /// **'In-app system announcements'**
  String get systemAnnouncementInAppNotification;

  /// No description provided for @roomInvitationEmail.
  ///
  /// In en, this message translates to:
  /// **'Room invitation emails'**
  String get roomInvitationEmail;

  /// No description provided for @roomEventEmail.
  ///
  /// In en, this message translates to:
  /// **'Room event emails'**
  String get roomEventEmail;

  /// No description provided for @systemAnnouncementEmail.
  ///
  /// In en, this message translates to:
  /// **'System announcement emails'**
  String get systemAnnouncementEmail;

  /// No description provided for @searchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search users'**
  String get searchUsers;

  /// No description provided for @selectUser.
  ///
  /// In en, this message translates to:
  /// **'Select user'**
  String get selectUser;

  /// No description provided for @userListSummary.
  ///
  /// In en, this message translates to:
  /// **'ID: {id} · {role} · {status} · {connectionStatus}'**
  String userListSummary(
    String id,
    String role,
    String status,
    String connectionStatus,
  );

  /// No description provided for @connectionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 connection} other{{count} connections}}'**
  String connectionCount(int count);

  /// No description provided for @userReports.
  ///
  /// In en, this message translates to:
  /// **'Reports for {username}'**
  String userReports(String username);

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @removeAdministratorRole.
  ///
  /// In en, this message translates to:
  /// **'Remove administrator role'**
  String get removeAdministratorRole;

  /// No description provided for @makeAdministrator.
  ///
  /// In en, this message translates to:
  /// **'Make administrator'**
  String get makeAdministrator;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete user'**
  String get deleteUser;

  /// No description provided for @usersSelected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 user selected} other{{count} users selected}}'**
  String usersSelected(int count);

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get disconnected;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @operationSucceeded.
  ///
  /// In en, this message translates to:
  /// **'Operation completed'**
  String get operationSucceeded;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @requiresPassword.
  ///
  /// In en, this message translates to:
  /// **'Requires password'**
  String get requiresPassword;

  /// No description provided for @loadUsersFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load users: {error}'**
  String loadUsersFailed(String error);

  /// No description provided for @addUser.
  ///
  /// In en, this message translates to:
  /// **'Add user'**
  String get addUser;

  /// No description provided for @userCreated.
  ///
  /// In en, this message translates to:
  /// **'User created'**
  String get userCreated;

  /// No description provided for @createUserFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not create the user: {error}'**
  String createUserFailed(String error);

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @permanentlyDeleteUser.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete user \"{username}\".'**
  String permanentlyDeleteUser(String username);

  /// No description provided for @deleteUserClearsAccountData.
  ///
  /// In en, this message translates to:
  /// **'The user\'\'s sessions, external bindings, and profile will be cleared.'**
  String get deleteUserClearsAccountData;

  /// No description provided for @deleteUserAffectsRelatedData.
  ///
  /// In en, this message translates to:
  /// **'Room relationships, chat ownership, and permissions associated with the user will be affected.'**
  String get deleteUserAffectsRelatedData;

  /// No description provided for @deleteUserRevokesOnlineAccess.
  ///
  /// In en, this message translates to:
  /// **'Online clients will lose access to this account immediately.'**
  String get deleteUserRevokesOnlineAccess;

  /// No description provided for @userDeleted.
  ///
  /// In en, this message translates to:
  /// **'User deleted'**
  String get userDeleted;

  /// No description provided for @deleteUserFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the user: {error}'**
  String deleteUserFailed(String error);

  /// No description provided for @rootUserCannotBeDemoted.
  ///
  /// In en, this message translates to:
  /// **'The Root user cannot be demoted here'**
  String get rootUserCannotBeDemoted;

  /// No description provided for @changePermissions.
  ///
  /// In en, this message translates to:
  /// **'Change permissions'**
  String get changePermissions;

  /// No description provided for @confirmUserRoleAction.
  ///
  /// In en, this message translates to:
  /// **'{action} for user \"{username}\"?'**
  String confirmUserRoleAction(String username, String action);

  /// No description provided for @userAction.
  ///
  /// In en, this message translates to:
  /// **'{action} user'**
  String userAction(String action);

  /// No description provided for @confirmUserAction.
  ///
  /// In en, this message translates to:
  /// **'{action} user \"{username}\"?'**
  String confirmUserAction(String action, String username);

  /// No description provided for @batchBanUsers.
  ///
  /// In en, this message translates to:
  /// **'Ban users'**
  String get batchBanUsers;

  /// No description provided for @usersWillBeBanned.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 user will be banned.} other{{count} users will be banned.}}'**
  String usersWillBeBanned(int count);

  /// No description provided for @batchDeleteUsers.
  ///
  /// In en, this message translates to:
  /// **'Delete users'**
  String get batchDeleteUsers;

  /// No description provided for @usersWillBeDeleted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 user will be permanently deleted.} other{{count} users will be permanently deleted.}}'**
  String usersWillBeDeleted(int count);

  /// No description provided for @batchDeleteUsersClearsAccountData.
  ///
  /// In en, this message translates to:
  /// **'The selected users\'\' sessions, external bindings, and profiles will be cleared.'**
  String get batchDeleteUsersClearsAccountData;

  /// No description provided for @batchDeleteUsersAffectsRelatedData.
  ///
  /// In en, this message translates to:
  /// **'Room relationships, chat ownership, and permissions associated with these users will be affected.'**
  String get batchDeleteUsersAffectsRelatedData;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @newUsername.
  ///
  /// In en, this message translates to:
  /// **'New username'**
  String get newUsername;

  /// No description provided for @usernameLengthHint.
  ///
  /// In en, this message translates to:
  /// **'3-50 characters'**
  String get usernameLengthHint;

  /// No description provided for @changeUsernameFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not change the username: {error}'**
  String changeUsernameFailed(String error);

  /// No description provided for @passwordMinimumLength.
  ///
  /// In en, this message translates to:
  /// **'At least {count} characters'**
  String passwordMinimumLength(int count);

  /// No description provided for @auditReason.
  ///
  /// In en, this message translates to:
  /// **'Audit reason'**
  String get auditReason;

  /// No description provided for @loadReviewsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load reviews: {error}'**
  String loadReviewsFailed(String error);

  /// No description provided for @reviewApproved.
  ///
  /// In en, this message translates to:
  /// **'Review approved'**
  String get reviewApproved;

  /// No description provided for @rejectReview.
  ///
  /// In en, this message translates to:
  /// **'Reject review'**
  String get rejectReview;

  /// No description provided for @rejectionReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the rejection reason'**
  String get rejectionReasonHint;

  /// No description provided for @reviewRejected.
  ///
  /// In en, this message translates to:
  /// **'Review rejected'**
  String get reviewRejected;

  /// No description provided for @registration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get registration;

  /// No description provided for @roomCreation.
  ///
  /// In en, this message translates to:
  /// **'Room creation'**
  String get roomCreation;

  /// No description provided for @roomDefaults.
  ///
  /// In en, this message translates to:
  /// **'Room defaults'**
  String get roomDefaults;

  /// No description provided for @joinRequest.
  ///
  /// In en, this message translates to:
  /// **'Join request'**
  String get joinRequest;

  /// No description provided for @searchReviewHint.
  ///
  /// In en, this message translates to:
  /// **'Search or enter a room_/usr_ ID'**
  String get searchReviewHint;

  /// No description provided for @noReviewRecords.
  ///
  /// In en, this message translates to:
  /// **'No review records'**
  String get noReviewRecords;

  /// No description provided for @reviewedBy.
  ///
  /// In en, this message translates to:
  /// **'Reviewed by {reviewer}'**
  String reviewedBy(String reviewer);

  /// No description provided for @reviewedAt.
  ///
  /// In en, this message translates to:
  /// **'Reviewed {time}'**
  String reviewedAt(String time);

  /// No description provided for @roomPasswordOptionalDescription.
  ///
  /// In en, this message translates to:
  /// **'Room creators can choose whether to set a password.'**
  String get roomPasswordOptionalDescription;

  /// No description provided for @roomPasswordRequiredDescription.
  ///
  /// In en, this message translates to:
  /// **'Every new room must have a password.'**
  String get roomPasswordRequiredDescription;

  /// No description provided for @roomPasswordDisabledDescription.
  ///
  /// In en, this message translates to:
  /// **'New rooms cannot use passwords.'**
  String get roomPasswordDisabledDescription;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @cors.
  ///
  /// In en, this message translates to:
  /// **'CORS'**
  String get cors;

  /// No description provided for @permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissions;

  /// No description provided for @sendChat.
  ///
  /// In en, this message translates to:
  /// **'Send chat messages'**
  String get sendChat;

  /// No description provided for @browseLibrary.
  ///
  /// In en, this message translates to:
  /// **'Browse library'**
  String get browseLibrary;

  /// No description provided for @viewMembers.
  ///
  /// In en, this message translates to:
  /// **'View members'**
  String get viewMembers;

  /// No description provided for @useWebRtc.
  ///
  /// In en, this message translates to:
  /// **'Use WebRTC'**
  String get useWebRtc;

  /// No description provided for @deleteMedia.
  ///
  /// In en, this message translates to:
  /// **'Delete media'**
  String get deleteMedia;

  /// No description provided for @reorderPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Reorder playlist'**
  String get reorderPlaylist;

  /// No description provided for @liveControl.
  ///
  /// In en, this message translates to:
  /// **'Live stream control'**
  String get liveControl;

  /// No description provided for @playbackControl.
  ///
  /// In en, this message translates to:
  /// **'Playback control'**
  String get playbackControl;

  /// No description provided for @roomPermissionNavigatePlayback.
  ///
  /// In en, this message translates to:
  /// **'Navigate playback'**
  String get roomPermissionNavigatePlayback;

  /// No description provided for @previousVideo.
  ///
  /// In en, this message translates to:
  /// **'Previous video'**
  String get previousVideo;

  /// No description provided for @nextVideo.
  ///
  /// In en, this message translates to:
  /// **'Next video'**
  String get nextVideo;

  /// No description provided for @playbackHistory.
  ///
  /// In en, this message translates to:
  /// **'Playback history'**
  String get playbackHistory;

  /// No description provided for @playbackHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No playback history'**
  String get playbackHistoryEmpty;

  /// No description provided for @playHistoryEntry.
  ///
  /// In en, this message translates to:
  /// **'Play this entry'**
  String get playHistoryEntry;

  /// No description provided for @viewPlaybackHistory.
  ///
  /// In en, this message translates to:
  /// **'View playback history'**
  String get viewPlaybackHistory;

  /// No description provided for @playbackHistoryRetentionDays.
  ///
  /// In en, this message translates to:
  /// **'Playback history retention'**
  String get playbackHistoryRetentionDays;

  /// No description provided for @playbackHistoryRetentionDaysDescription.
  ///
  /// In en, this message translates to:
  /// **'Days to retain playback history. Use 0 to disable age-based cleanup.'**
  String get playbackHistoryRetentionDaysDescription;

  /// No description provided for @playbackHistoryMaxEntries.
  ///
  /// In en, this message translates to:
  /// **'Playback history limit'**
  String get playbackHistoryMaxEntries;

  /// No description provided for @playbackHistoryMaxEntriesDescription.
  ///
  /// In en, this message translates to:
  /// **'Maximum entries retained per room. Use 0 to disable count-based cleanup.'**
  String get playbackHistoryMaxEntriesDescription;

  /// No description provided for @changePlaybackRate.
  ///
  /// In en, this message translates to:
  /// **'Change playback rate'**
  String get changePlaybackRate;

  /// No description provided for @approveMember.
  ///
  /// In en, this message translates to:
  /// **'Approve members'**
  String get approveMember;

  /// No description provided for @setMemberPermissions.
  ///
  /// In en, this message translates to:
  /// **'Set member permissions'**
  String get setMemberPermissions;

  /// No description provided for @changeRoomSettings.
  ///
  /// In en, this message translates to:
  /// **'Change room settings'**
  String get changeRoomSettings;

  /// No description provided for @deleteChat.
  ///
  /// In en, this message translates to:
  /// **'Delete chat messages'**
  String get deleteChat;

  /// No description provided for @roomPermissionManageOwnMedia.
  ///
  /// In en, this message translates to:
  /// **'Manage own media'**
  String get roomPermissionManageOwnMedia;

  /// No description provided for @roomPermissionReorderMedia.
  ///
  /// In en, this message translates to:
  /// **'Reorder media and playlists'**
  String get roomPermissionReorderMedia;

  /// No description provided for @roomPermissionClearMedia.
  ///
  /// In en, this message translates to:
  /// **'Clear media queue'**
  String get roomPermissionClearMedia;

  /// No description provided for @roomPermissionManageLiveStreams.
  ///
  /// In en, this message translates to:
  /// **'Manage live streams'**
  String get roomPermissionManageLiveStreams;

  /// No description provided for @roomPermissionReviewJoinRequests.
  ///
  /// In en, this message translates to:
  /// **'Review join requests'**
  String get roomPermissionReviewJoinRequests;

  /// No description provided for @roomPermissionRemoveMembers.
  ///
  /// In en, this message translates to:
  /// **'Remove members'**
  String get roomPermissionRemoveMembers;

  /// No description provided for @roomPermissionManageMemberPermissions.
  ///
  /// In en, this message translates to:
  /// **'Manage member permissions'**
  String get roomPermissionManageMemberPermissions;

  /// No description provided for @roomPermissionAddMembers.
  ///
  /// In en, this message translates to:
  /// **'Add members'**
  String get roomPermissionAddMembers;

  /// No description provided for @roomPermissionManageRoomSettings.
  ///
  /// In en, this message translates to:
  /// **'Manage room settings'**
  String get roomPermissionManageRoomSettings;

  /// No description provided for @roomPermissionDeleteChatMessages.
  ///
  /// In en, this message translates to:
  /// **'Delete chat messages'**
  String get roomPermissionDeleteChatMessages;

  /// No description provided for @defaultRoomMemberLimit.
  ///
  /// In en, this message translates to:
  /// **'Default room member limit'**
  String get defaultRoomMemberLimit;

  /// No description provided for @defaultRoomMemberLimitDescription.
  ///
  /// In en, this message translates to:
  /// **'The default member limit for new rooms.'**
  String get defaultRoomMemberLimitDescription;

  /// No description provided for @roomChatSnapshotLimit.
  ///
  /// In en, this message translates to:
  /// **'Room chat snapshot limit'**
  String get roomChatSnapshotLimit;

  /// No description provided for @roomChatSnapshotLimitDescription.
  ///
  /// In en, this message translates to:
  /// **'Maximum chat messages retained and sent to clients for new rooms. Zero means unlimited.'**
  String get roomChatSnapshotLimitDescription;

  /// No description provided for @allowRoomCreation.
  ///
  /// In en, this message translates to:
  /// **'Allow room creation'**
  String get allowRoomCreation;

  /// No description provided for @allowRoomCreationDescription.
  ///
  /// In en, this message translates to:
  /// **'Allow regular users to create rooms.'**
  String get allowRoomCreationDescription;

  /// No description provided for @roomCreationRequiresReview.
  ///
  /// In en, this message translates to:
  /// **'Room creation requires review'**
  String get roomCreationRequiresReview;

  /// No description provided for @roomCreationRequiresReviewDescription.
  ///
  /// In en, this message translates to:
  /// **'New rooms enter the review workflow and become available after approval.'**
  String get roomCreationRequiresReviewDescription;

  /// No description provided for @roomPasswordPolicy.
  ///
  /// In en, this message translates to:
  /// **'Room password policy'**
  String get roomPasswordPolicy;

  /// No description provided for @roomPasswordPolicyDescription.
  ///
  /// In en, this message translates to:
  /// **'Define whether new rooms may, must, or cannot use passwords.'**
  String get roomPasswordPolicyDescription;

  /// No description provided for @maximumRoomsPerUser.
  ///
  /// In en, this message translates to:
  /// **'Maximum rooms per user'**
  String get maximumRoomsPerUser;

  /// No description provided for @maximumRoomsPerUserDescription.
  ///
  /// In en, this message translates to:
  /// **'Limit how many rooms each user can own.'**
  String get maximumRoomsPerUserDescription;

  /// No description provided for @allowPasswordSignup.
  ///
  /// In en, this message translates to:
  /// **'Allow password signup'**
  String get allowPasswordSignup;

  /// No description provided for @allowPasswordSignupDescription.
  ///
  /// In en, this message translates to:
  /// **'Users can register with a username and password.'**
  String get allowPasswordSignupDescription;

  /// No description provided for @passwordSignupRequiresReview.
  ///
  /// In en, this message translates to:
  /// **'Password signup requires review'**
  String get passwordSignupRequiresReview;

  /// No description provided for @passwordSignupRequiresReviewDescription.
  ///
  /// In en, this message translates to:
  /// **'New password accounts require administrator approval.'**
  String get passwordSignupRequiresReviewDescription;

  /// No description provided for @allowEmailSignup.
  ///
  /// In en, this message translates to:
  /// **'Allow email signup'**
  String get allowEmailSignup;

  /// No description provided for @allowEmailSignupDescription.
  ///
  /// In en, this message translates to:
  /// **'Users can register with an email verification code.'**
  String get allowEmailSignupDescription;

  /// No description provided for @emailSignupRequiresReview.
  ///
  /// In en, this message translates to:
  /// **'Email signup requires review'**
  String get emailSignupRequiresReview;

  /// No description provided for @emailSignupRequiresReviewDescription.
  ///
  /// In en, this message translates to:
  /// **'New email accounts require administrator approval.'**
  String get emailSignupRequiresReviewDescription;

  /// No description provided for @allowPasskeySignup.
  ///
  /// In en, this message translates to:
  /// **'Allow passkey signup'**
  String get allowPasskeySignup;

  /// No description provided for @allowPasskeySignupDescription.
  ///
  /// In en, this message translates to:
  /// **'Users can create accounts using a platform passkey.'**
  String get allowPasskeySignupDescription;

  /// No description provided for @passkeySignupRequiresReview.
  ///
  /// In en, this message translates to:
  /// **'Passkey signup requires review'**
  String get passkeySignupRequiresReview;

  /// No description provided for @passkeySignupRequiresReviewDescription.
  ///
  /// In en, this message translates to:
  /// **'New passkey accounts require administrator approval.'**
  String get passkeySignupRequiresReviewDescription;

  /// No description provided for @allowGuests.
  ///
  /// In en, this message translates to:
  /// **'Allow guests'**
  String get allowGuests;

  /// No description provided for @allowGuestsDescription.
  ///
  /// In en, this message translates to:
  /// **'Signed-out users can enter rooms that allow guests.'**
  String get allowGuestsDescription;

  /// No description provided for @allowGuestsWarning.
  ///
  /// In en, this message translates to:
  /// **'Guest access lowers the room access threshold. Verify public room and default permission settings.'**
  String get allowGuestsWarning;

  /// No description provided for @externalLogin.
  ///
  /// In en, this message translates to:
  /// **'External login'**
  String get externalLogin;

  /// No description provided for @externalLoginDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage OAuth2/OIDC login providers, signup policies, and callback settings.'**
  String get externalLoginDescription;

  /// No description provided for @externalLoginWarning.
  ///
  /// In en, this message translates to:
  /// **'OAuth2 settings affect login entry points. Invalid callbacks, secrets, or endpoints prevent external login.'**
  String get externalLoginWarning;

  /// No description provided for @rtmpPublishAddress.
  ///
  /// In en, this message translates to:
  /// **'RTMP publish address'**
  String get rtmpPublishAddress;

  /// No description provided for @rtmpPublishAddressDescription.
  ///
  /// In en, this message translates to:
  /// **'Override the public RTMP publish host. Leave empty to use the server default.'**
  String get rtmpPublishAddressDescription;

  /// No description provided for @tsSegmentsAsPng.
  ///
  /// In en, this message translates to:
  /// **'Expose TS segments as PNG'**
  String get tsSegmentsAsPng;

  /// No description provided for @tsSegmentsAsPngDescription.
  ///
  /// In en, this message translates to:
  /// **'Expose HLS TS segments with PNG extensions for network compatibility.'**
  String get tsSegmentsAsPngDescription;

  /// No description provided for @enableEmailService.
  ///
  /// In en, this message translates to:
  /// **'Enable email service'**
  String get enableEmailService;

  /// No description provided for @enableEmailServiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Allow the server to send email binding, password reset, MFA, and notification messages.'**
  String get enableEmailServiceDescription;

  /// No description provided for @enableEmailServiceWarning.
  ///
  /// In en, this message translates to:
  /// **'Verify the SMTP host, sender address, and credentials before enabling email features.'**
  String get enableEmailServiceWarning;

  /// No description provided for @smtpHost.
  ///
  /// In en, this message translates to:
  /// **'SMTP host'**
  String get smtpHost;

  /// No description provided for @smtpHostDescription.
  ///
  /// In en, this message translates to:
  /// **'Mail server address required when email delivery is enabled.'**
  String get smtpHostDescription;

  /// No description provided for @smtpPort.
  ///
  /// In en, this message translates to:
  /// **'SMTP port'**
  String get smtpPort;

  /// No description provided for @smtpPortDescription.
  ///
  /// In en, this message translates to:
  /// **'Common ports are 587, 465, and 25.'**
  String get smtpPortDescription;

  /// No description provided for @smtpAuthentication.
  ///
  /// In en, this message translates to:
  /// **'SMTP authentication'**
  String get smtpAuthentication;

  /// No description provided for @smtpAuthenticationDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure an SMTP username and password when the server requires authentication.'**
  String get smtpAuthenticationDescription;

  /// No description provided for @smtpAuthenticationWarning.
  ///
  /// In en, this message translates to:
  /// **'SMTP passwords are sensitive credentials. Verify the environment and administrator account before saving.'**
  String get smtpAuthenticationWarning;

  /// No description provided for @smtpProxy.
  ///
  /// In en, this message translates to:
  /// **'SMTP proxy'**
  String get smtpProxy;

  /// No description provided for @smtpProxyDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure an optional SOCKS5 proxy and proxy credentials.'**
  String get smtpProxyDescription;

  /// No description provided for @smtpProxyWarning.
  ///
  /// In en, this message translates to:
  /// **'Email traffic and the SMTP destination pass through this proxy. Use a trusted proxy.'**
  String get smtpProxyWarning;

  /// No description provided for @useTls.
  ///
  /// In en, this message translates to:
  /// **'Use TLS'**
  String get useTls;

  /// No description provided for @useTlsDescription.
  ///
  /// In en, this message translates to:
  /// **'Enable SMTP TLS/STARTTLS.'**
  String get useTlsDescription;

  /// No description provided for @useTlsWarning.
  ///
  /// In en, this message translates to:
  /// **'Disabling TLS can expose mail credentials in plaintext. Use this only in controlled networks or development.'**
  String get useTlsWarning;

  /// No description provided for @senderEmail.
  ///
  /// In en, this message translates to:
  /// **'Sender email'**
  String get senderEmail;

  /// No description provided for @senderEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'Valid From address required when email delivery is enabled.'**
  String get senderEmailDescription;

  /// No description provided for @senderDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Sender display name'**
  String get senderDisplayName;

  /// No description provided for @senderDisplayNameDescription.
  ///
  /// In en, this message translates to:
  /// **'Name shown to recipients for delivered email.'**
  String get senderDisplayNameDescription;

  /// No description provided for @enableEmailWhitelist.
  ///
  /// In en, this message translates to:
  /// **'Enable email whitelist'**
  String get enableEmailWhitelist;

  /// No description provided for @enableEmailWhitelistDescription.
  ///
  /// In en, this message translates to:
  /// **'Restrict email signup to listed addresses and domains.'**
  String get enableEmailWhitelistDescription;

  /// No description provided for @emailWhitelist.
  ///
  /// In en, this message translates to:
  /// **'Email whitelist'**
  String get emailWhitelist;

  /// No description provided for @emailWhitelistDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter one email address or domain per line. Domains may use example.com or @example.com.'**
  String get emailWhitelistDescription;

  /// No description provided for @externalIceServers.
  ///
  /// In en, this message translates to:
  /// **'External ICE servers'**
  String get externalIceServers;

  /// No description provided for @externalIceServersDescription.
  ///
  /// In en, this message translates to:
  /// **'STUN/TURN servers sent to clients.'**
  String get externalIceServersDescription;

  /// No description provided for @externalIceServersWarning.
  ///
  /// In en, this message translates to:
  /// **'TURN usernames and credentials are sent to clients. Use limited, renewable credentials.'**
  String get externalIceServersWarning;

  /// No description provided for @maxVoiceParticipantsPerRoom.
  ///
  /// In en, this message translates to:
  /// **'Voice participants per room'**
  String get maxVoiceParticipantsPerRoom;

  /// No description provided for @maxVoiceParticipantsPerRoomDescription.
  ///
  /// In en, this message translates to:
  /// **'Maximum simultaneous voice participants in one room. Mesh voice supports 2 to 32; 8 is recommended for mobile clients.'**
  String get maxVoiceParticipantsPerRoomDescription;

  /// No description provided for @chatMessagesPerRoom.
  ///
  /// In en, this message translates to:
  /// **'Chat messages retained per room'**
  String get chatMessagesPerRoom;

  /// No description provided for @chatMessagesPerRoomDescription.
  ///
  /// In en, this message translates to:
  /// **'Maximum retained chat messages per room. Zero means unlimited.'**
  String get chatMessagesPerRoomDescription;

  /// No description provided for @chatRetentionDays.
  ///
  /// In en, this message translates to:
  /// **'Chat retention days'**
  String get chatRetentionDays;

  /// No description provided for @chatRetentionDaysDescription.
  ///
  /// In en, this message translates to:
  /// **'Maximum time chat messages are retained.'**
  String get chatRetentionDaysDescription;

  /// No description provided for @allowedCorsOrigins.
  ///
  /// In en, this message translates to:
  /// **'Allowed CORS origins'**
  String get allowedCorsOrigins;

  /// No description provided for @allowedCorsOriginsDescription.
  ///
  /// In en, this message translates to:
  /// **'Web origins allowed to access proxy endpoints. Native clients usually need no entries.'**
  String get allowedCorsOriginsDescription;

  /// No description provided for @allowedCorsOriginsWarning.
  ///
  /// In en, this message translates to:
  /// **'Broad CORS settings expand browser access. Add only explicit trusted HTTPS origins.'**
  String get allowedCorsOriginsWarning;

  /// No description provided for @adminDefaultPermissions.
  ///
  /// In en, this message translates to:
  /// **'Administrator default permissions'**
  String get adminDefaultPermissions;

  /// No description provided for @adminDefaultPermissionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Default permission set for room administrators.'**
  String get adminDefaultPermissionsDescription;

  /// No description provided for @memberDefaultPermissions.
  ///
  /// In en, this message translates to:
  /// **'Member default permissions'**
  String get memberDefaultPermissions;

  /// No description provided for @memberDefaultPermissionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Default permission set for regular room members.'**
  String get memberDefaultPermissionsDescription;

  /// No description provided for @guestDefaultPermissions.
  ///
  /// In en, this message translates to:
  /// **'Guest default permissions'**
  String get guestDefaultPermissions;

  /// No description provided for @guestDefaultPermissionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Default server-supported permission set for guests.'**
  String get guestDefaultPermissionsDescription;

  /// No description provided for @guestDefaultPermissionsWarning.
  ///
  /// In en, this message translates to:
  /// **'Guest permissions apply to signed-out users. Grant only viewing and low-risk actions.'**
  String get guestDefaultPermissionsWarning;

  /// No description provided for @runtimeSectionDescription.
  ///
  /// In en, this message translates to:
  /// **'Runtime settings for {section}.'**
  String runtimeSectionDescription(String section);

  /// No description provided for @noExternalLoginConfigured.
  ///
  /// In en, this message translates to:
  /// **'No external login configured'**
  String get noExternalLoginConfigured;

  /// No description provided for @oauthProviderSummary.
  ///
  /// In en, this message translates to:
  /// **'{total} providers, {configured} with a Client ID'**
  String oauthProviderSummary(int total, int configured);

  /// No description provided for @noIceServersConfigured.
  ///
  /// In en, this message translates to:
  /// **'No ICE servers configured'**
  String get noIceServersConfigured;

  /// No description provided for @iceServerCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 ICE server} other{{count} ICE servers}}'**
  String iceServerCount(int count);

  /// No description provided for @authenticationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Authentication disabled'**
  String get authenticationDisabled;

  /// No description provided for @configuredUser.
  ///
  /// In en, this message translates to:
  /// **'Configured user {username}'**
  String configuredUser(String username);

  /// No description provided for @directConnection.
  ///
  /// In en, this message translates to:
  /// **'Direct connection'**
  String get directConnection;

  /// No description provided for @emptyList.
  ///
  /// In en, this message translates to:
  /// **'Empty list'**
  String get emptyList;

  /// No description provided for @noPermissions.
  ///
  /// In en, this message translates to:
  /// **'No permissions'**
  String get noPermissions;

  /// No description provided for @emptyObject.
  ///
  /// In en, this message translates to:
  /// **'Empty object'**
  String get emptyObject;

  /// No description provided for @configurationCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 setting} other{{count} settings}}'**
  String configurationCount(int count);

  /// No description provided for @configurableSettingsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 configurable setting} other{{count} configurable settings}}'**
  String configurableSettingsCount(int count);

  /// No description provided for @refreshCurrentSection.
  ///
  /// In en, this message translates to:
  /// **'Refresh current section'**
  String get refreshCurrentSection;

  /// No description provided for @refreshSettingsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh settings: {error}'**
  String refreshSettingsFailed(String error);

  /// No description provided for @updateSettingsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update settings: {error}'**
  String updateSettingsFailed(String error);

  /// No description provided for @deleteLoginProvider.
  ///
  /// In en, this message translates to:
  /// **'Delete login provider'**
  String get deleteLoginProvider;

  /// No description provided for @confirmDeleteLoginProvider.
  ///
  /// In en, this message translates to:
  /// **'Delete OAuth2 login provider \"{name}\"? Users will lose access to this login entry point.'**
  String confirmDeleteLoginProvider(String name);

  /// No description provided for @confirmChanges.
  ///
  /// In en, this message translates to:
  /// **'Confirm changes'**
  String get confirmChanges;

  /// No description provided for @sendTestEmail.
  ///
  /// In en, this message translates to:
  /// **'Send test email'**
  String get sendTestEmail;

  /// No description provided for @recipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipient;

  /// No description provided for @testEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Test email sent'**
  String get testEmailSent;

  /// No description provided for @sendTestEmailFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send the test email: {error}'**
  String sendTestEmailFailed(String error);

  /// No description provided for @noSettings.
  ///
  /// In en, this message translates to:
  /// **'No settings'**
  String get noSettings;

  /// No description provided for @addLoginProvider.
  ///
  /// In en, this message translates to:
  /// **'Add login provider'**
  String get addLoginProvider;

  /// No description provided for @runtimeSettings.
  ///
  /// In en, this message translates to:
  /// **'Runtime settings'**
  String get runtimeSettings;

  /// No description provided for @refreshAll.
  ///
  /// In en, this message translates to:
  /// **'Refresh all'**
  String get refreshAll;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @enterSettingValue.
  ///
  /// In en, this message translates to:
  /// **'Enter {setting}'**
  String enterSettingValue(String setting);

  /// No description provided for @enableSmtpAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Enable SMTP authentication'**
  String get enableSmtpAuthentication;

  /// No description provided for @enableSmtpAuthenticationDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure a username and password when the server requires login.'**
  String get enableSmtpAuthenticationDescription;

  /// No description provided for @smtpUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the SMTP username'**
  String get smtpUsernameRequired;

  /// No description provided for @emptyKeepsCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to keep the current password'**
  String get emptyKeepsCurrentPassword;

  /// No description provided for @passwordRequiredForNewCredentials.
  ///
  /// In en, this message translates to:
  /// **'Enter a password for new credentials or a changed username'**
  String get passwordRequiredForNewCredentials;

  /// No description provided for @enableSmtpProxy.
  ///
  /// In en, this message translates to:
  /// **'Enable SMTP proxy'**
  String get enableSmtpProxy;

  /// No description provided for @enableSmtpProxyDescription.
  ///
  /// In en, this message translates to:
  /// **'Connect to the mail server through a SOCKS5 proxy.'**
  String get enableSmtpProxyDescription;

  /// No description provided for @socks5ProxyAddress.
  ///
  /// In en, this message translates to:
  /// **'SOCKS5 proxy address'**
  String get socks5ProxyAddress;

  /// No description provided for @socks5ProxyAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an address beginning with socks5://'**
  String get socks5ProxyAddressRequired;

  /// No description provided for @proxyRequiresAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Proxy requires authentication'**
  String get proxyRequiresAuthentication;

  /// No description provided for @proxyAuthenticationDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure a SOCKS5 username and password.'**
  String get proxyAuthenticationDescription;

  /// No description provided for @proxyUsername.
  ///
  /// In en, this message translates to:
  /// **'Proxy username'**
  String get proxyUsername;

  /// No description provided for @proxyUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the proxy username'**
  String get proxyUsernameRequired;

  /// No description provided for @proxyPassword.
  ///
  /// In en, this message translates to:
  /// **'Proxy password'**
  String get proxyPassword;

  /// No description provided for @providerTypes.
  ///
  /// In en, this message translates to:
  /// **'Provider types'**
  String get providerTypes;

  /// No description provided for @noProviderTypes.
  ///
  /// In en, this message translates to:
  /// **'No provider types available'**
  String get noProviderTypes;

  /// No description provided for @selectAtLeastOneProviderType.
  ///
  /// In en, this message translates to:
  /// **'Select at least one provider type'**
  String get selectAtLeastOneProviderType;

  /// No description provided for @loadProviderInstancesFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load provider instances: {error}'**
  String loadProviderInstancesFailed(String error);

  /// No description provided for @providerInstanceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Provider instance updated'**
  String get providerInstanceUpdated;

  /// No description provided for @providerInstanceCreated.
  ///
  /// In en, this message translates to:
  /// **'Provider instance created'**
  String get providerInstanceCreated;

  /// No description provided for @saveProviderInstanceFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the provider instance: {error}'**
  String saveProviderInstanceFailed(String error);

  /// No description provided for @deleteProvider.
  ///
  /// In en, this message translates to:
  /// **'Delete provider'**
  String get deleteProvider;

  /// No description provided for @confirmDeleteProvider.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String confirmDeleteProvider(String name);

  /// No description provided for @providerInstanceDeleted.
  ///
  /// In en, this message translates to:
  /// **'Provider instance deleted'**
  String get providerInstanceDeleted;

  /// No description provided for @deleteProviderFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the provider: {error}'**
  String deleteProviderFailed(String error);

  /// No description provided for @reconnectStarted.
  ///
  /// In en, this message translates to:
  /// **'Reconnect started'**
  String get reconnectStarted;

  /// No description provided for @reconnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not reconnect: {error}'**
  String reconnectFailed(String error);

  /// No description provided for @searchProviderInstances.
  ///
  /// In en, this message translates to:
  /// **'Search name or endpoint'**
  String get searchProviderInstances;

  /// No description provided for @allTlsStates.
  ///
  /// In en, this message translates to:
  /// **'All TLS states'**
  String get allTlsStates;

  /// No description provided for @tlsEnabled.
  ///
  /// In en, this message translates to:
  /// **'TLS enabled'**
  String get tlsEnabled;

  /// No description provided for @tlsDisabled.
  ///
  /// In en, this message translates to:
  /// **'TLS disabled'**
  String get tlsDisabled;

  /// No description provided for @sortByName.
  ///
  /// In en, this message translates to:
  /// **'By name'**
  String get sortByName;

  /// No description provided for @sortByEndpoint.
  ///
  /// In en, this message translates to:
  /// **'By endpoint'**
  String get sortByEndpoint;

  /// No description provided for @sortByCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'By creation time'**
  String get sortByCreatedAt;

  /// No description provided for @sortByUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'By update time'**
  String get sortByUpdatedAt;

  /// No description provided for @noProviderInstances.
  ///
  /// In en, this message translates to:
  /// **'No provider instances'**
  String get noProviderInstances;

  /// No description provided for @noAvailableBackends.
  ///
  /// In en, this message translates to:
  /// **'No backends available for this type'**
  String get noAvailableBackends;

  /// No description provided for @backendCopied.
  ///
  /// In en, this message translates to:
  /// **'Backend copied'**
  String get backendCopied;

  /// No description provided for @refreshBackends.
  ///
  /// In en, this message translates to:
  /// **'Refresh backends'**
  String get refreshBackends;

  /// No description provided for @tlsUnverified.
  ///
  /// In en, this message translates to:
  /// **'TLS unverified'**
  String get tlsUnverified;

  /// No description provided for @tlsVerified.
  ///
  /// In en, this message translates to:
  /// **'TLS verified'**
  String get tlsVerified;

  /// No description provided for @providerInstanceTimes.
  ///
  /// In en, this message translates to:
  /// **'Created {createdAt} · Updated {updatedAt}'**
  String providerInstanceTimes(String createdAt, String updatedAt);

  /// No description provided for @enableProviderInstance.
  ///
  /// In en, this message translates to:
  /// **'Enable provider instance'**
  String get enableProviderInstance;

  /// No description provided for @reconnect.
  ///
  /// In en, this message translates to:
  /// **'Reconnect'**
  String get reconnect;

  /// No description provided for @editProviderInstance.
  ///
  /// In en, this message translates to:
  /// **'Edit provider instance'**
  String get editProviderInstance;

  /// No description provided for @addProviderInstance.
  ///
  /// In en, this message translates to:
  /// **'Add provider instance'**
  String get addProviderInstance;

  /// No description provided for @configureProviderNode.
  ///
  /// In en, this message translates to:
  /// **'Configure an external media provider node'**
  String get configureProviderNode;

  /// No description provided for @instanceName.
  ///
  /// In en, this message translates to:
  /// **'Instance name'**
  String get instanceName;

  /// No description provided for @instanceNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an instance name'**
  String get instanceNameRequired;

  /// No description provided for @endpointRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an endpoint'**
  String get endpointRequired;

  /// No description provided for @requestTimeout.
  ///
  /// In en, this message translates to:
  /// **'Request timeout'**
  String get requestTimeout;

  /// No description provided for @secondsShort.
  ///
  /// In en, this message translates to:
  /// **'sec'**
  String get secondsShort;

  /// No description provided for @positiveIntegerRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter an integer greater than zero'**
  String get positiveIntegerRequired;

  /// No description provided for @capabilityTypes.
  ///
  /// In en, this message translates to:
  /// **'Capability types'**
  String get capabilityTypes;

  /// No description provided for @capabilityTypesDescription.
  ///
  /// In en, this message translates to:
  /// **'One instance can provide several provider types.'**
  String get capabilityTypesDescription;

  /// No description provided for @connectionSecurity.
  ///
  /// In en, this message translates to:
  /// **'Connection security'**
  String get connectionSecurity;

  /// No description provided for @connectionSecurityDescription.
  ///
  /// In en, this message translates to:
  /// **'Use insecure TLS only in controlled private networks or test environments.'**
  String get connectionSecurityDescription;

  /// No description provided for @enableTls.
  ///
  /// In en, this message translates to:
  /// **'Enable TLS'**
  String get enableTls;

  /// No description provided for @providerTlsConnection.
  ///
  /// In en, this message translates to:
  /// **'Connect to the provider with HTTPS/TLS'**
  String get providerTlsConnection;

  /// No description provided for @providerPlainConnection.
  ///
  /// In en, this message translates to:
  /// **'Connect without TLS'**
  String get providerPlainConnection;

  /// No description provided for @allowInsecureTls.
  ///
  /// In en, this message translates to:
  /// **'Allow insecure TLS'**
  String get allowInsecureTls;

  /// No description provided for @allowInsecureTlsDescription.
  ///
  /// In en, this message translates to:
  /// **'Skip certificate validation, which permits interception attacks.'**
  String get allowInsecureTlsDescription;

  /// No description provided for @emptyKeepsCurrentValue.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to keep the current value'**
  String get emptyKeepsCurrentValue;

  /// No description provided for @clearJwtSecret.
  ///
  /// In en, this message translates to:
  /// **'Clear JWT Secret'**
  String get clearJwtSecret;

  /// No description provided for @pemEmptyKeepsCurrent.
  ///
  /// In en, this message translates to:
  /// **'PEM content; leave empty to keep the current value'**
  String get pemEmptyKeepsCurrent;

  /// No description provided for @pemOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional PEM content'**
  String get pemOptional;

  /// No description provided for @clearCustomCa.
  ///
  /// In en, this message translates to:
  /// **'Clear Custom CA'**
  String get clearCustomCa;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @providerNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Optional deployment location, purpose, or maintenance notes'**
  String get providerNotesHint;

  /// No description provided for @clearNotes.
  ///
  /// In en, this message translates to:
  /// **'Clear notes'**
  String get clearNotes;

  /// No description provided for @providerEditFooterHint.
  ///
  /// In en, this message translates to:
  /// **'Only entered or explicitly cleared sensitive fields will be submitted'**
  String get providerEditFooterHint;

  /// No description provided for @providerCreateFooterHint.
  ///
  /// In en, this message translates to:
  /// **'After creation, the instance can be enabled, reconnected, or edited from the list'**
  String get providerCreateFooterHint;

  /// No description provided for @searchStreamsHint.
  ///
  /// In en, this message translates to:
  /// **'Search or enter a room_/usr_/node_ ID'**
  String get searchStreamsHint;

  /// No description provided for @startedAt.
  ///
  /// In en, this message translates to:
  /// **'Start time'**
  String get startedAt;

  /// No description provided for @node.
  ///
  /// In en, this message translates to:
  /// **'Node'**
  String get node;

  /// No description provided for @loadBanRecordsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load ban records: {error}'**
  String loadBanRecordsFailed(String error);

  /// No description provided for @banRecordMissingTargetId.
  ///
  /// In en, this message translates to:
  /// **'The ban record has no target ID and cannot be revoked'**
  String get banRecordMissingTargetId;

  /// No description provided for @unbanUser.
  ///
  /// In en, this message translates to:
  /// **'Unban user'**
  String get unbanUser;

  /// No description provided for @unbanRoom.
  ///
  /// In en, this message translates to:
  /// **'Unban room'**
  String get unbanRoom;

  /// No description provided for @confirmUnban.
  ///
  /// In en, this message translates to:
  /// **'Remove the ban for \"{target}\"?'**
  String confirmUnban(String target);

  /// No description provided for @unbanned.
  ///
  /// In en, this message translates to:
  /// **'Ban removed'**
  String get unbanned;

  /// No description provided for @unbanFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not remove the ban: {error}'**
  String unbanFailed(String error);

  /// No description provided for @allTargets.
  ///
  /// In en, this message translates to:
  /// **'All targets'**
  String get allTargets;

  /// No description provided for @revokedOrExpired.
  ///
  /// In en, this message translates to:
  /// **'Revoked or expired'**
  String get revokedOrExpired;

  /// No description provided for @userOrRoomIdHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a usr_/room_ ID'**
  String get userOrRoomIdHint;

  /// No description provided for @noBanRecords.
  ///
  /// In en, this message translates to:
  /// **'No ban records'**
  String get noBanRecords;

  /// No description provided for @banRecordSummary.
  ///
  /// In en, this message translates to:
  /// **'{reason}\nOperator: {operator} · {time}'**
  String banRecordSummary(String reason, String operator, String time);

  /// No description provided for @noReason.
  ///
  /// In en, this message translates to:
  /// **'No reason'**
  String get noReason;

  /// No description provided for @ended.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get ended;

  /// No description provided for @loadReportsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load report records: {error}'**
  String loadReportsFailed(String error);

  /// No description provided for @reportDetails.
  ///
  /// In en, this message translates to:
  /// **'Report details'**
  String get reportDetails;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @reporter.
  ///
  /// In en, this message translates to:
  /// **'Reporter'**
  String get reporter;

  /// No description provided for @reviewedByLabel.
  ///
  /// In en, this message translates to:
  /// **'Reviewed by'**
  String get reviewedByLabel;

  /// No description provided for @reviewedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Reviewed at'**
  String get reviewedAtLabel;

  /// No description provided for @resolutionNote.
  ///
  /// In en, this message translates to:
  /// **'Resolution note'**
  String get resolutionNote;

  /// No description provided for @resolve.
  ///
  /// In en, this message translates to:
  /// **'Resolve'**
  String get resolve;

  /// No description provided for @resolveReport.
  ///
  /// In en, this message translates to:
  /// **'Resolve report'**
  String get resolveReport;

  /// No description provided for @reviewing.
  ///
  /// In en, this message translates to:
  /// **'Reviewing'**
  String get reviewing;

  /// No description provided for @resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// No description provided for @dismissed.
  ///
  /// In en, this message translates to:
  /// **'Dismissed'**
  String get dismissed;

  /// No description provided for @reportOpenStatus.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get reportOpenStatus;

  /// No description provided for @resolveReportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not resolve the report: {error}'**
  String resolveReportFailed(String error);

  /// No description provided for @reportStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Report status updated'**
  String get reportStatusUpdated;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @searchReportsHint.
  ///
  /// In en, this message translates to:
  /// **'Search reasons, targets, or usr_/room_ IDs'**
  String get searchReportsHint;

  /// No description provided for @noReportRecords.
  ///
  /// In en, this message translates to:
  /// **'No report records'**
  String get noReportRecords;

  /// No description provided for @reportListSummary.
  ///
  /// In en, this message translates to:
  /// **'{reason}\nReporter: {reporter} · {time}'**
  String reportListSummary(String reason, String reporter, String time);

  /// No description provided for @reporterFilter.
  ///
  /// In en, this message translates to:
  /// **'Reporter {id}'**
  String reporterFilter(String id);

  /// No description provided for @contextRoomFilter.
  ///
  /// In en, this message translates to:
  /// **'Context room {id}'**
  String contextRoomFilter(String id);

  /// No description provided for @reportedRoomFilter.
  ///
  /// In en, this message translates to:
  /// **'Reported room {id}'**
  String reportedRoomFilter(String id);

  /// No description provided for @reportedUserFilter.
  ///
  /// In en, this message translates to:
  /// **'Reported user {id}'**
  String reportedUserFilter(String id);

  /// No description provided for @memberRoomFilter.
  ///
  /// In en, this message translates to:
  /// **'Member room {id}'**
  String memberRoomFilter(String id);

  /// No description provided for @reportedMemberFilter.
  ///
  /// In en, this message translates to:
  /// **'Reported member {id}'**
  String reportedMemberFilter(String id);

  /// No description provided for @messageFilter.
  ///
  /// In en, this message translates to:
  /// **'Message #{id}'**
  String messageFilter(int id);

  /// No description provided for @roomTarget.
  ///
  /// In en, this message translates to:
  /// **'Room {target}'**
  String roomTarget(String target);

  /// No description provided for @userTarget.
  ///
  /// In en, this message translates to:
  /// **'User {target}'**
  String userTarget(String target);

  /// No description provided for @memberTarget.
  ///
  /// In en, this message translates to:
  /// **'Member {user} · {room}'**
  String memberTarget(String user, String room);

  /// No description provided for @chatMessageTarget.
  ///
  /// In en, this message translates to:
  /// **'Chat message #{id} · {room}'**
  String chatMessageTarget(int id, String room);

  /// No description provided for @unknownTarget.
  ///
  /// In en, this message translates to:
  /// **'Unknown target {id}'**
  String unknownTarget(String id);

  /// No description provided for @entry.
  ///
  /// In en, this message translates to:
  /// **'Entry'**
  String get entry;

  /// No description provided for @enterEntry.
  ///
  /// In en, this message translates to:
  /// **'Enter an entry'**
  String get enterEntry;

  /// No description provided for @valueRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a value'**
  String get valueRequired;

  /// No description provided for @validNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get validNumberRequired;

  /// No description provided for @noLoginProviders.
  ///
  /// In en, this message translates to:
  /// **'No external login providers'**
  String get noLoginProviders;

  /// No description provided for @noLoginProvidersDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a GitHub, Google, Logto, or generic OIDC provider to show it on the login screen.'**
  String get noLoginProvidersDescription;

  /// No description provided for @addLoginProviderHint.
  ///
  /// In en, this message translates to:
  /// **'Use the add button to create a GitHub, Google, Logto, or generic OIDC login entry.'**
  String get addLoginProviderHint;

  /// No description provided for @loginProviderSummary.
  ///
  /// In en, this message translates to:
  /// **'{providerType} · {clientStatus}'**
  String loginProviderSummary(String providerType, String clientStatus);

  /// No description provided for @clientConfigured.
  ///
  /// In en, this message translates to:
  /// **'Client configured'**
  String get clientConfigured;

  /// No description provided for @clientIdMissing.
  ///
  /// In en, this message translates to:
  /// **'Client ID missing'**
  String get clientIdMissing;

  /// No description provided for @signupAllowed.
  ///
  /// In en, this message translates to:
  /// **'Signup allowed'**
  String get signupAllowed;

  /// No description provided for @loginBindingOnly.
  ///
  /// In en, this message translates to:
  /// **'Login and binding only'**
  String get loginBindingOnly;

  /// No description provided for @signupRequiresReview.
  ///
  /// In en, this message translates to:
  /// **'Signup requires review'**
  String get signupRequiresReview;

  /// No description provided for @addExternalLogin.
  ///
  /// In en, this message translates to:
  /// **'Add external login'**
  String get addExternalLogin;

  /// No description provided for @editExternalLogin.
  ///
  /// In en, this message translates to:
  /// **'Edit external login'**
  String get editExternalLogin;

  /// No description provided for @externalLoginEditorDescription.
  ///
  /// In en, this message translates to:
  /// **'Configure an OAuth2/OIDC login provider, callback URL, and signup policy.'**
  String get externalLoginEditorDescription;

  /// No description provided for @instanceNameFormatHint.
  ///
  /// In en, this message translates to:
  /// **'Use letters, numbers, underscores, and hyphens only'**
  String get instanceNameFormatHint;

  /// No description provided for @providerType.
  ///
  /// In en, this message translates to:
  /// **'Provider type'**
  String get providerType;

  /// No description provided for @clientSecretRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the Client Secret'**
  String get clientSecretRequired;

  /// No description provided for @callbackUrl.
  ///
  /// In en, this message translates to:
  /// **'Callback URL'**
  String get callbackUrl;

  /// No description provided for @authorizationEndpoint.
  ///
  /// In en, this message translates to:
  /// **'Authorization endpoint'**
  String get authorizationEndpoint;

  /// No description provided for @emptyUsesOidcDiscovery.
  ///
  /// In en, this message translates to:
  /// **'Leave empty to use OIDC Discovery'**
  String get emptyUsesOidcDiscovery;

  /// No description provided for @tokenEndpoint.
  ///
  /// In en, this message translates to:
  /// **'Token endpoint'**
  String get tokenEndpoint;

  /// No description provided for @userInfoEndpoint.
  ///
  /// In en, this message translates to:
  /// **'UserInfo endpoint'**
  String get userInfoEndpoint;

  /// No description provided for @jwksEndpoint.
  ///
  /// In en, this message translates to:
  /// **'JWKS endpoint'**
  String get jwksEndpoint;

  /// No description provided for @allowProviderSignup.
  ///
  /// In en, this message translates to:
  /// **'Allow signup with this provider'**
  String get allowProviderSignup;

  /// No description provided for @allowProviderSignupDescription.
  ///
  /// In en, this message translates to:
  /// **'When disabled, only users who already linked this provider can log in.'**
  String get allowProviderSignupDescription;

  /// No description provided for @saveInstance.
  ///
  /// In en, this message translates to:
  /// **'Save instance'**
  String get saveInstance;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter {field}'**
  String fieldRequired(String field);

  /// No description provided for @instanceNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Instance names can contain up to {maxLength} characters'**
  String instanceNameTooLong(int maxLength);

  /// No description provided for @instanceNameExists.
  ///
  /// In en, this message translates to:
  /// **'An instance with this name already exists'**
  String get instanceNameExists;

  /// No description provided for @urlRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a URL'**
  String get urlRequired;

  /// No description provided for @validUrlRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid URL'**
  String get validUrlRequired;

  /// No description provided for @httpUrlRequired.
  ///
  /// In en, this message translates to:
  /// **'Use an http or https URL'**
  String get httpUrlRequired;

  /// No description provided for @noIceServersDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a STUN or TURN server to make clients prefer this connection configuration.'**
  String get noIceServersDescription;

  /// No description provided for @addIceServer.
  ///
  /// In en, this message translates to:
  /// **'Add ICE server'**
  String get addIceServer;

  /// No description provided for @iceServerNumber.
  ///
  /// In en, this message translates to:
  /// **'ICE server {number}'**
  String iceServerNumber(int number);

  /// No description provided for @iceServerUrlsHint.
  ///
  /// In en, this message translates to:
  /// **'One per line, such as stun:host:3478 or turns:host:5349'**
  String get iceServerUrlsHint;

  /// No description provided for @atLeastOneUrlRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter at least one URL'**
  String get atLeastOneUrlRequired;

  /// No description provided for @iceServerUrlSchemeRequired.
  ///
  /// In en, this message translates to:
  /// **'Use a stun:, turn:, or turns: URL'**
  String get iceServerUrlSchemeRequired;

  /// No description provided for @credential.
  ///
  /// In en, this message translates to:
  /// **'Credential'**
  String get credential;

  /// No description provided for @pageSizeSummary.
  ///
  /// In en, this message translates to:
  /// **'Page {page} · {pageSize} per page'**
  String pageSizeSummary(int page, int pageSize);

  /// No description provided for @pageSizeTotalSummary.
  ///
  /// In en, this message translates to:
  /// **'Page {page} · {pageSize} per page · {total} total'**
  String pageSizeTotalSummary(int page, int pageSize, int total);

  /// No description provided for @messageHasNoCopyableContent.
  ///
  /// In en, this message translates to:
  /// **'This message has no content to copy'**
  String get messageHasNoCopyableContent;

  /// No description provided for @confirmDeleteUserMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete this message from {username}?'**
  String confirmDeleteUserMessage(String username);

  /// No description provided for @messagesLoaded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 message loaded} other{{count} messages loaded}}'**
  String messagesLoaded(int count);

  /// No description provided for @olderMessagesAvailable.
  ///
  /// In en, this message translates to:
  /// **'Older messages available'**
  String get olderMessagesAvailable;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @loadOlderMessages.
  ///
  /// In en, this message translates to:
  /// **'Load older messages'**
  String get loadOlderMessages;

  /// No description provided for @noChatMessages.
  ///
  /// In en, this message translates to:
  /// **'No chat messages'**
  String get noChatMessages;

  /// No description provided for @deletedUser.
  ///
  /// In en, this message translates to:
  /// **'Deleted user'**
  String get deletedUser;

  /// No description provided for @messageAuthorTime.
  ///
  /// In en, this message translates to:
  /// **'{author} · {time}'**
  String messageAuthorTime(String author, String time);

  /// No description provided for @messageDeletedContent.
  ///
  /// In en, this message translates to:
  /// **'This message was deleted'**
  String get messageDeletedContent;

  /// No description provided for @context.
  ///
  /// In en, this message translates to:
  /// **'Context'**
  String get context;

  /// No description provided for @imageCount.
  ///
  /// In en, this message translates to:
  /// **'[Images: {count}]'**
  String imageCount(int count);

  /// No description provided for @creatorUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Creator unavailable'**
  String get creatorUnavailable;

  /// No description provided for @pageNumber.
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String pageNumber(int page);

  /// No description provided for @pageTotalSummary.
  ///
  /// In en, this message translates to:
  /// **'Page {page} · {total} total'**
  String pageTotalSummary(int page, int total);

  /// No description provided for @switchControl.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get switchControl;

  /// No description provided for @selectOption.
  ///
  /// In en, this message translates to:
  /// **'Select an option'**
  String get selectOption;

  /// No description provided for @inviteLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Invite link copied'**
  String get inviteLinkCopied;

  /// No description provided for @playbackAuthenticationRequired.
  ///
  /// In en, this message translates to:
  /// **'The media site requires authentication. Check that the link is publicly accessible or add the media again with valid credentials.'**
  String get playbackAuthenticationRequired;

  /// No description provided for @playbackAccessForbidden.
  ///
  /// In en, this message translates to:
  /// **'The media site denied access to this video. Check the link permissions, origin restrictions, and direct-link headers.'**
  String get playbackAccessForbidden;

  /// No description provided for @playbackNotFound.
  ///
  /// In en, this message translates to:
  /// **'The video address does not exist or has expired. Check the link and add it again.'**
  String get playbackNotFound;

  /// No description provided for @playbackRateLimited.
  ///
  /// In en, this message translates to:
  /// **'The media site is receiving too many requests. Try again later or use another accessible resource.'**
  String get playbackRateLimited;

  /// No description provided for @playbackFormatUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This device cannot play the video format. Use a common format such as MP4 or HLS.'**
  String get playbackFormatUnsupported;

  /// No description provided for @playbackConnectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to the video. Check the network, proxy settings, and media site availability.'**
  String get playbackConnectionFailed;

  /// No description provided for @playbackLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the video. Confirm that the link is publicly accessible and the format is supported on this device.'**
  String get playbackLoadFailed;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @enterAuthenticatorCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit authenticator code'**
  String get enterAuthenticatorCode;

  /// No description provided for @enterRecoveryCode.
  ///
  /// In en, this message translates to:
  /// **'Enter a recovery code'**
  String get enterRecoveryCode;

  /// No description provided for @authenticatorCode.
  ///
  /// In en, this message translates to:
  /// **'Authenticator code'**
  String get authenticatorCode;

  /// No description provided for @verifyWithAuthenticator.
  ///
  /// In en, this message translates to:
  /// **'Verify with authenticator'**
  String get verifyWithAuthenticator;

  /// No description provided for @verifyWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify with email'**
  String get verifyWithEmail;

  /// No description provided for @recoveryCode.
  ///
  /// In en, this message translates to:
  /// **'Recovery code'**
  String get recoveryCode;

  /// No description provided for @useRecoveryCode.
  ///
  /// In en, this message translates to:
  /// **'Use a recovery code'**
  String get useRecoveryCode;

  /// No description provided for @backToVerificationMethods.
  ///
  /// In en, this message translates to:
  /// **'Back to verification methods'**
  String get backToVerificationMethods;

  /// No description provided for @verifyWithRecoveryCode.
  ///
  /// In en, this message translates to:
  /// **'Verify with recovery code'**
  String get verifyWithRecoveryCode;

  /// No description provided for @authenticatorApp.
  ///
  /// In en, this message translates to:
  /// **'Authenticator app'**
  String get authenticatorApp;

  /// No description provided for @setupAuthenticatorFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not set up the authenticator app: {error}'**
  String setupAuthenticatorFailed(String error);

  /// No description provided for @regenerateRecoveryCodesFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not generate new recovery codes: {error}'**
  String regenerateRecoveryCodesFailed(String error);

  /// No description provided for @removeAuthenticatorApp.
  ///
  /// In en, this message translates to:
  /// **'Remove authenticator app'**
  String get removeAuthenticatorApp;

  /// No description provided for @removeAuthenticatorAppConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Remove the authenticator app and all of its recovery codes?'**
  String get removeAuthenticatorAppConfirmation;

  /// No description provided for @authenticatorAppRemoved.
  ///
  /// In en, this message translates to:
  /// **'Authenticator app removed'**
  String get authenticatorAppRemoved;

  /// No description provided for @removeAuthenticatorFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not remove the authenticator app: {error}'**
  String removeAuthenticatorFailed(String error);

  /// No description provided for @authenticatorAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Use time-based codes from a standard authenticator app for multi-factor verification'**
  String get authenticatorAppDescription;

  /// No description provided for @authenticatorAppConfigured.
  ///
  /// In en, this message translates to:
  /// **'Configured'**
  String get authenticatorAppConfigured;

  /// No description provided for @authenticatorAppNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get authenticatorAppNotConfigured;

  /// No description provided for @recoveryCodesRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 recovery code remaining} other{{count} recovery codes remaining}}'**
  String recoveryCodesRemaining(int count);

  /// No description provided for @authenticatorAppSetupHint.
  ///
  /// In en, this message translates to:
  /// **'Add an authenticator app to strengthen account security'**
  String get authenticatorAppSetupHint;

  /// No description provided for @recoveryCodes.
  ///
  /// In en, this message translates to:
  /// **'Recovery codes'**
  String get recoveryCodes;

  /// No description provided for @setup.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get setup;

  /// No description provided for @setupAuthenticatorApp.
  ///
  /// In en, this message translates to:
  /// **'Set up authenticator app'**
  String get setupAuthenticatorApp;

  /// No description provided for @setupAuthenticatorAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code with a standard authenticator app, or enter the setup key manually.'**
  String get setupAuthenticatorAppDescription;

  /// No description provided for @manualSetupKey.
  ///
  /// In en, this message translates to:
  /// **'Manual setup key'**
  String get manualSetupKey;

  /// No description provided for @confirmSetup.
  ///
  /// In en, this message translates to:
  /// **'Confirm setup'**
  String get confirmSetup;

  /// No description provided for @saveRecoveryCodes.
  ///
  /// In en, this message translates to:
  /// **'Save recovery codes'**
  String get saveRecoveryCodes;

  /// No description provided for @recoveryCodesShownOnce.
  ///
  /// In en, this message translates to:
  /// **'Each code works once. Store these codes securely; they are shown only on this screen.'**
  String get recoveryCodesShownOnce;

  /// No description provided for @copyAll.
  ///
  /// In en, this message translates to:
  /// **'Copy all'**
  String get copyAll;

  /// No description provided for @savedRecoveryCodes.
  ///
  /// In en, this message translates to:
  /// **'I saved the codes'**
  String get savedRecoveryCodes;

  /// No description provided for @sliceCache.
  ///
  /// In en, this message translates to:
  /// **'Slice cache'**
  String get sliceCache;

  /// No description provided for @nodeId.
  ///
  /// In en, this message translates to:
  /// **'Node ID'**
  String get nodeId;

  /// No description provided for @currentNode.
  ///
  /// In en, this message translates to:
  /// **'Current node'**
  String get currentNode;

  /// No description provided for @allNodes.
  ///
  /// In en, this message translates to:
  /// **'All nodes'**
  String get allNodes;

  /// No description provided for @loadSliceCacheFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load slice cache statistics: {error}'**
  String loadSliceCacheFailed(String error);

  /// No description provided for @nodeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Node unavailable'**
  String get nodeUnavailable;

  /// No description provided for @noSliceCacheStats.
  ///
  /// In en, this message translates to:
  /// **'No slice cache statistics are available'**
  String get noSliceCacheStats;

  /// No description provided for @evictExpiredSliceCache.
  ///
  /// In en, this message translates to:
  /// **'Evict expired'**
  String get evictExpiredSliceCache;

  /// No description provided for @purgeSliceCache.
  ///
  /// In en, this message translates to:
  /// **'Purge cache'**
  String get purgeSliceCache;

  /// No description provided for @confirmPurgeSliceCache.
  ///
  /// In en, this message translates to:
  /// **'Purge every cached slice for the selected target? Active playback may need to fetch media data again.'**
  String get confirmPurgeSliceCache;

  /// No description provided for @sliceCacheEvictionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Removed {count, plural, =1{1 expired cache entry} other{{count} expired cache entries}}'**
  String sliceCacheEvictionCompleted(int count);

  /// No description provided for @sliceCachePurgeCompleted.
  ///
  /// In en, this message translates to:
  /// **'Removed {count, plural, =1{1 cache entry} other{{count} cache entries}} and freed {size}'**
  String sliceCachePurgeCompleted(int count, String size);

  /// No description provided for @sliceCacheNodeOperationFailed.
  ///
  /// In en, this message translates to:
  /// **'The cache operation failed on this node'**
  String get sliceCacheNodeOperationFailed;

  /// No description provided for @sliceCacheUsage.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get sliceCacheUsage;

  /// No description provided for @sliceCacheSize.
  ///
  /// In en, this message translates to:
  /// **'Stored data'**
  String get sliceCacheSize;

  /// No description provided for @sliceCacheEntries.
  ///
  /// In en, this message translates to:
  /// **'Entries'**
  String get sliceCacheEntries;

  /// No description provided for @sliceCacheUpdating.
  ///
  /// In en, this message translates to:
  /// **'Updating'**
  String get sliceCacheUpdating;

  /// No description provided for @sliceCacheLocks.
  ///
  /// In en, this message translates to:
  /// **'Locks'**
  String get sliceCacheLocks;

  /// No description provided for @sliceCacheBackend.
  ///
  /// In en, this message translates to:
  /// **'Backend'**
  String get sliceCacheBackend;

  /// No description provided for @sliceCacheDirectory.
  ///
  /// In en, this message translates to:
  /// **'Directory'**
  String get sliceCacheDirectory;

  /// No description provided for @sliceCacheCapacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get sliceCacheCapacity;

  /// No description provided for @sliceCacheSliceSize.
  ///
  /// In en, this message translates to:
  /// **'Slice size'**
  String get sliceCacheSliceSize;

  /// No description provided for @sliceCacheSegmentTtl.
  ///
  /// In en, this message translates to:
  /// **'Segment TTL'**
  String get sliceCacheSegmentTtl;

  /// No description provided for @sliceCacheStaleMaxAge.
  ///
  /// In en, this message translates to:
  /// **'Stale max age'**
  String get sliceCacheStaleMaxAge;

  /// No description provided for @sliceCacheEvictionInterval.
  ///
  /// In en, this message translates to:
  /// **'Eviction interval'**
  String get sliceCacheEvictionInterval;

  /// No description provided for @staleWhileRevalidate.
  ///
  /// In en, this message translates to:
  /// **'Stale while revalidate'**
  String get staleWhileRevalidate;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @blockedUsers.
  ///
  /// In en, this message translates to:
  /// **'Blocked users'**
  String get blockedUsers;

  /// No description provided for @blockedUsersDescription.
  ///
  /// In en, this message translates to:
  /// **'Messages from these users are hidden, and rooms they create are excluded from Home discovery.'**
  String get blockedUsersDescription;

  /// No description provided for @blockUser.
  ///
  /// In en, this message translates to:
  /// **'Block user'**
  String get blockUser;

  /// No description provided for @unblockUser.
  ///
  /// In en, this message translates to:
  /// **'Unblock user'**
  String get unblockUser;

  /// No description provided for @confirmBlockUser.
  ///
  /// In en, this message translates to:
  /// **'Block {name}? Their messages will disappear and their rooms will be hidden from Home discovery. Existing room memberships remain available.'**
  String confirmBlockUser(String name);

  /// No description provided for @confirmUnblockUser.
  ///
  /// In en, this message translates to:
  /// **'Unblock {name}? Their messages and rooms will become visible again.'**
  String confirmUnblockUser(String name);

  /// No description provided for @userBlocked.
  ///
  /// In en, this message translates to:
  /// **'User blocked'**
  String get userBlocked;

  /// No description provided for @userUnblocked.
  ///
  /// In en, this message translates to:
  /// **'User unblocked'**
  String get userUnblocked;

  /// No description provided for @blockUserFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not block user: {error}'**
  String blockUserFailed(String error);

  /// No description provided for @unblockUserFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not unblock user: {error}'**
  String unblockUserFailed(String error);

  /// No description provided for @noBlockedUsers.
  ///
  /// In en, this message translates to:
  /// **'No blocked users'**
  String get noBlockedUsers;

  /// No description provided for @searchBlockedUsers.
  ///
  /// In en, this message translates to:
  /// **'Search blocked users'**
  String get searchBlockedUsers;

  /// No description provided for @blockedAt.
  ///
  /// In en, this message translates to:
  /// **'Blocked {time}'**
  String blockedAt(String time);

  /// No description provided for @blockedCreator.
  ///
  /// In en, this message translates to:
  /// **'Blocked creator'**
  String get blockedCreator;

  /// No description provided for @blockedUsersTemporarilyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Blocked users are temporarily unavailable'**
  String get blockedUsersTemporarilyUnavailable;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
