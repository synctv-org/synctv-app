import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/core/network/resource_url_resolver.dart';
import 'package:synctv_app/features/account/application/account_gateway.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/platform/device_display_name_service.dart';
import 'package:synctv_app/features/auth/application/oauth2_callback_client.dart';
import 'package:synctv_app/features/auth/application/native_apple_sign_in_client.dart';
import 'package:synctv_app/core/config/distribution_profile.dart';
import 'package:synctv_app/features/auth/application/opaque_authenticator.dart';
import 'package:synctv_app/features/auth/application/passkey_client.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/core/presentation/image/local_image_picker.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/core/presentation/widgets/app_responsive_layout.dart';
import 'package:synctv_app/features/auth/presentation/auth_recovery_code_fallback.dart';
import 'package:synctv_app/features/auth/presentation/oauth_provider_widgets.dart';

part 'account_dialogs.dart';
part 'account_widgets.dart';

AccountGateway _accountGateway(BuildContext context) =>
    DependencyScope.read<AccountGateway>(context);

PasskeyClient _passkeyClient(BuildContext context) =>
    DependencyScope.read<PasskeyClient>(context);

OAuth2CallbackClient _oauth2Callbacks(BuildContext context) =>
    DependencyScope.read<OAuth2CallbackClient>(context);

NativeAppleSignInClient _nativeAppleSignIn(BuildContext context) =>
    DependencyScope.read<NativeAppleSignInClient>(context);

class _AccountSection {
  final String label;
  final IconData icon;

  const _AccountSection({required this.label, required this.icon});
}

class _AccountModuleInfo {
  final String label;
  final String impact;
  final IconData icon;

  const _AccountModuleInfo({
    required this.label,
    required this.impact,
    required this.icon,
  });
}

class _EmailStatusView {
  final IconData icon;
  final String label;
  final Color tone;

  const _EmailStatusView({
    required this.icon,
    required this.label,
    required this.tone,
  });
}

class AccountCenterPage extends StatefulWidget {
  final SyncTvUser initialUser;
  final Future<void> Function(SyncTvRoom room) onOpenRoom;
  final Future<void> Function() onCreateRoom;
  final Future<void> Function(SyncTvRoom room) onManageRoom;
  final Future<void> Function(String providerType) onOpenProviderBinding;

  const AccountCenterPage({
    super.key,
    required this.initialUser,
    required this.onOpenRoom,
    required this.onCreateRoom,
    required this.onManageRoom,
    required this.onOpenProviderBinding,
  });

  @override
  State<AccountCenterPage> createState() => _AccountCenterPageState();
}

class _AccountCenterPageState extends State<AccountCenterPage>
    with SingleTickerProviderStateMixin {
  AccountGateway get _gateway => _accountGateway(context);
  PasskeyClient get _passkeysClient => _passkeyClient(context);

  static const int _notificationPageSize = 50;
  static const int _roomsPageSize = 24;
  static const int _blockedUsersPageSize = 24;
  static const int _sectionCount = 7;
  static const String _moduleAccountPreferences = 'account_preferences';
  static const String _moduleNotifications = 'notifications';
  static const String _moduleRooms = 'rooms';
  static const String _moduleBlockedUsers = 'blocked_users';
  final DeviceDisplayNameService _deviceDisplayNameService =
      DeviceDisplayNameService();
  static const String _moduleOAuthProviders = 'oauth_providers';
  static const String _moduleOAuthLinks = 'oauth_links';
  static const String _modulePasskeys = 'passkeys';
  static const String _moduleLocalPasskey = 'local_passkey';
  static const String _modulePublicSettings = 'public_settings';

  List<_AccountSection> get _sections => [
    _AccountSection(
      label: context.l10n.overview,
      icon: Icons.space_dashboard_outlined,
    ),
    _AccountSection(
      label: context.l10n.profile,
      icon: Icons.person_outline_rounded,
    ),
    _AccountSection(
      label: context.l10n.rooms,
      icon: Icons.meeting_room_outlined,
    ),
    _AccountSection(
      label: context.l10n.privacy,
      icon: Icons.privacy_tip_outlined,
    ),
    _AccountSection(label: context.l10n.security, icon: Icons.security_rounded),
    _AccountSection(
      label: context.l10n.notifications,
      icon: Icons.notifications_none_rounded,
    ),
    _AccountSection(label: context.l10n.bindings, icon: Icons.link_rounded),
  ];

  Map<String, _AccountModuleInfo> get _moduleInfo => {
    _moduleAccountPreferences: _AccountModuleInfo(
      label: context.l10n.accountPreferences,
      impact: context.l10n.accountPreferencesUnavailableImpact,
      icon: Icons.tune_rounded,
    ),
    _moduleNotifications: _AccountModuleInfo(
      label: context.l10n.notificationCenter,
      impact: context.l10n.notificationsUnavailableImpact,
      icon: Icons.notifications_none_rounded,
    ),
    _moduleRooms: _AccountModuleInfo(
      label: context.l10n.myRooms,
      impact: context.l10n.myRoomsUnavailableImpact,
      icon: Icons.meeting_room_outlined,
    ),
    _moduleBlockedUsers: _AccountModuleInfo(
      label: context.l10n.blockedUsers,
      impact: context.l10n.blockedUsersDescription,
      icon: Icons.person_off_outlined,
    ),
    _moduleOAuthProviders: _AccountModuleInfo(
      label: context.l10n.oauthAvailableAccounts,
      impact: context.l10n.oauthProvidersUnavailableImpact,
      icon: Icons.add_link_rounded,
    ),
    _moduleOAuthLinks: _AccountModuleInfo(
      label: context.l10n.oauthLinkedAccounts,
      impact: context.l10n.oauthLinksUnavailableImpact,
      icon: Icons.link_rounded,
    ),
    _modulePasskeys: _AccountModuleInfo(
      label: context.l10n.passkeyCredentials,
      impact: context.l10n.passkeysUnavailableImpact,
      icon: Icons.fingerprint_rounded,
    ),
    _moduleLocalPasskey: _AccountModuleInfo(
      label: context.l10n.localPasskeyCapability,
      impact: context.l10n.localPasskeyUnavailableImpact,
      icon: Icons.devices_rounded,
    ),
    _modulePublicSettings: _AccountModuleInfo(
      label: context.l10n.serverPublicSettings,
      impact: context.l10n.publicSettingsUnavailableImpact,
      icon: Icons.tune_rounded,
    ),
  };

  late TabController _tabController;
  late SyncTvUser _user;
  AccountPreferences? _preferences;
  UserNotificationsPage? _notifications;
  RoomsPage? _myRooms;
  BlockedUsersPage? _blockedUsers;
  PublicSettingsInfo? _publicSettings;
  List<OAuth2ProviderOption> _availableOAuth2 = const [];
  List<OAuth2LinkedAccount> _linkedOAuth2 = const [];
  List<PasskeyCredentialInfo> _passkeys = const [];
  Map<String, String> _loadErrors = const {};
  bool _loading = true;
  bool _savingPreferences = false;
  bool _updatingAvatar = false;
  bool _bindingPasskey = false;
  bool _passkeyAvailable = false;
  String? _bindProvider;
  int _bindAttempt = 0;
  bool? _notificationReadFilter;
  client_enum.NotificationType? _notificationTypeFilter;
  client_enum.NotificationListSortBy _notificationSortBy =
      client_enum.NotificationListSortBy.NOTIFICATION_LIST_SORT_BY_CREATED_AT;
  client_enum.SortDirection _notificationSortDirection =
      client_enum.SortDirection.SORT_DIRECTION_DESC;
  int _notificationPage = 1;
  bool _loadingNotifications = false;
  int _roomsPage = 1;
  bool _loadingRooms = false;
  int _blockedUsersPage = 1;
  bool _loadingBlockedUsers = false;
  client_enum.MyRoomRelation _roomRelationFilter =
      client_enum.MyRoomRelation.MY_ROOM_RELATION_ALL;
  client_enum.MyRoomListSortBy _roomSortBy =
      client_enum.MyRoomListSortBy.MY_ROOM_LIST_SORT_BY_FREQUENT;
  final Set<int> _selectedNotificationIds = <int>{};
  final TextEditingController _notificationSearchController =
      TextEditingController();
  final TextEditingController _roomSearchController = TextEditingController();
  final TextEditingController _blockedUserSearchController =
      TextEditingController();
  late final OpaqueAuthenticatorService _opaqueAuthenticator;

  bool get _passkeyEnabled =>
      _publicSettings?.enableWebauthn == true && _passkeyAvailable;

  bool get _emailFeatureEnabled => _publicSettings?.enableEmail == true;
  bool get _showEmailBindingControls => _user.hasEmail || _emailFeatureEnabled;

  _EmailStatusView _emailStatusView(ThemeData theme) {
    if (!_user.hasEmail) {
      return _EmailStatusView(
        icon: Icons.alternate_email_rounded,
        label: context.l10n.notBound,
        tone: theme.colorScheme.onSurface.withValues(alpha: 0.58),
      );
    }
    return _EmailStatusView(
      icon: Icons.mark_email_read_rounded,
      label: context.l10n.bound,
      tone: const Color(0xFF15803D),
    );
  }

  @override
  void initState() {
    super.initState();
    _user = widget.initialUser;
    _tabController = TabController(length: _sectionCount, vsync: this);
    _opaqueAuthenticator = DependencyScope.read<OpaqueAuthenticatorService>(
      context,
    );
    _load(refresh: false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notificationSearchController.dispose();
    _roomSearchController.dispose();
    _blockedUserSearchController.dispose();
    super.dispose();
  }

  Future<void> _load({bool refresh = false}) async {
    setState(() => _loading = true);
    try {
      final errors = <String, String>{};
      final user = await _gateway.getCurrentUser(refresh: refresh);
      final publicSettings = await _loadOptional(
        errors,
        _modulePublicSettings,
        () => _gateway.getPublicSettings(refresh: refresh),
      );
      final serverPasskeyEnabled = publicSettings?.enableWebauthn == true;
      final results = await Future.wait<dynamic>([
        _loadOptional(
          errors,
          _moduleAccountPreferences,
          () => _gateway.getPreferences(refresh: refresh),
        ),
        _loadOptional(
          errors,
          _moduleNotifications,
          () => _gateway.listNotifications(
            page: _notificationPage,
            pageSize: _notificationPageSize,
            refresh: refresh,
          ),
        ),
        _loadOptional(
          errors,
          _moduleRooms,
          () => _gateway.getRooms(
            page: _roomsPage,
            pageSize: _roomsPageSize,
            relation: _roomRelationFilter,
            sortBy: _roomSortBy,
          ),
        ),
        if (ProviderDistributionPolicy.current.allowsOAuth2)
          _loadOptional(
            errors,
            _moduleOAuthProviders,
            _gateway.listOAuth2Providers,
          )
        else
          Future<List<OAuth2ProviderOption>?>.value(const []),
        if (ProviderDistributionPolicy.current.allowsOAuth2)
          _loadOptional(
            errors,
            _moduleOAuthLinks,
            _gateway.getLinkedOAuth2Accounts,
          )
        else
          Future<List<OAuth2LinkedAccount>?>.value(const []),
        if (serverPasskeyEnabled)
          _loadOptional(
            errors,
            _modulePasskeys,
            () => _gateway.listPasskeys(refresh: refresh),
          )
        else
          Future<List<PasskeyCredentialInfo>?>.value(const []),
        if (serverPasskeyEnabled)
          _loadOptional(
            errors,
            _moduleLocalPasskey,
            () => _passkeysClient.isSupported(
              serverBaseUrl: _gateway.serverBaseUrl,
              rpId: publicSettings!.webauthnRpId,
            ),
          )
        else
          Future<bool?>.value(false),
        _loadOptional(
          errors,
          _moduleBlockedUsers,
          () => _gateway.listBlockedUsers(
            page: _blockedUsersPage,
            pageSize: _blockedUsersPageSize,
            search: _blockedUserSearchController.text.trim(),
          ),
        ),
      ]);
      if (!mounted) return;
      setState(() {
        _user = user;
        _publicSettings = publicSettings;
        _preferences = results[0] as AccountPreferences?;
        _notifications = results[1] as UserNotificationsPage?;
        _myRooms = results[2] as RoomsPage?;
        _availableOAuth2 =
            results[3] as List<OAuth2ProviderOption>? ?? const [];
        _linkedOAuth2 = results[4] as List<OAuth2LinkedAccount>? ?? const [];
        _passkeys = results[5] as List<PasskeyCredentialInfo>? ?? const [];
        _passkeyAvailable = results[6] as bool? ?? false;
        _blockedUsers = results[7] as BlockedUsersPage?;
        _loadErrors = Map.unmodifiable(errors);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      AppNotifications.showError(context, context.l10n.loadAccountFailed('$e'));
    }
  }

  Future<T?> _loadOptional<T>(
    Map<String, String> errors,
    String label,
    Future<T> Function() load,
  ) async {
    try {
      return await load();
    } catch (e, stackTrace) {
      debugPrint('Account center optional load failed [$label]: $e');
      debugPrint('$stackTrace');
      errors[label] = e.toString();
      return null;
    }
  }

  Future<void> _rename() async {
    final next = await showAppDialog<String>(
      context: context,
      builder: (_) => _SingleTextInputDialog(
        title: context.l10n.changeUsername,
        subtitle: context.l10n.changeUsernameDescription,
        icon: Icons.badge_outlined,
        label: context.l10n.username,
        initialValue: _user.username,
        primaryLabel: context.l10n.save,
      ),
    );
    if (next == null || next.isEmpty || next == _user.username) return;

    try {
      final user = await _gateway.updateUsername(next);
      if (!mounted) return;
      setState(() => _user = user);
      AppNotifications.showSuccess(context, context.l10n.usernameUpdated);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.updateUsernameFailed('$e'),
        );
      }
    }
  }

  Future<void> _updateAvatar() async {
    if (_updatingAvatar) return;
    try {
      final image = await pickLocalImageUpload(context, aspectRatio: 1);
      if (image == null || !mounted) return;
      setState(() => _updatingAvatar = true);
      final user = await _gateway.updateAvatar(image.upload);
      if (!mounted) return;
      setState(() => _user = user);
      AppNotifications.showSuccess(context, context.l10n.avatarUpdated);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.updateAvatarFailed('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _updatingAvatar = false);
    }
  }

  Future<void> _clearAvatar() async {
    if (_updatingAvatar || _user.avatarUrl.isEmpty) return;
    final confirmed = await showAppDialog<bool>(
      context: context,
      builder: (context) => AppConfirmDialog(
        icon: const Icon(Icons.delete_outline_rounded),
        title: context.l10n.removeAvatar,
        content: Text(context.l10n.confirmRemoveAvatar),
        confirmLabel: context.l10n.remove,
        confirmIcon: Icons.delete_outline_rounded,
        destructive: true,
        onConfirm: () => Navigator.pop(context, true),
      ),
    );
    if (confirmed != true) return;

    try {
      setState(() => _updatingAvatar = true);
      final user = await _gateway.clearAvatar();
      if (!mounted) return;
      setState(() => _user = user);
      AppNotifications.showSuccess(context, context.l10n.avatarRemoved);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.removeAvatarFailed('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _updatingAvatar = false);
    }
  }

  Future<void> _updateNotifications(NotificationPreferences preferences) async {
    setState(() => _savingPreferences = true);
    try {
      final updated = await _gateway.updatePreferences(
        notifications: preferences,
      );
      if (!mounted) return;
      setState(() => _preferences = updated);
      AppNotifications.showSuccess(
        context,
        context.l10n.notificationPreferencesSaved,
      );
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.saveNotificationPreferencesFailed('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _savingPreferences = false);
    }
  }

  Future<void> _toggleTwoFactor(bool value) async {
    setState(() => _savingPreferences = true);
    try {
      final verificationId = await _verifySensitiveOperation();
      if (verificationId == null || verificationId.isEmpty) return;
      final updated = await _gateway.setTwoFactorEnabled(
        enabled: value,
        verificationId: verificationId,
      );
      if (!mounted) return;
      setState(() => _preferences = updated);
      AppNotifications.showSuccess(context, context.l10n.mfaSettingsSaved);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.saveMfaSettingsFailed('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _savingPreferences = false);
    }
  }

  Future<void> _unbindEmail() async {
    if (!_user.hasEmail) return;
    final confirmed = await showAppDialog<bool>(
      context: context,
      builder: (context) => AppConfirmDialog(
        icon: const Icon(Icons.link_off_rounded),
        title: context.l10n.unbindEmail,
        content: Text(context.l10n.unbindEmailDescription),
        confirmLabel: context.l10n.unbind,
        confirmIcon: Icons.link_off_rounded,
        destructive: true,
        onConfirm: () => Navigator.pop(context, true),
      ),
    );
    if (confirmed != true) return;

    try {
      final verificationId = await _verifySensitiveOperation();
      if (verificationId == null) return;
      final user = await _gateway.unbindEmail(verificationId: verificationId);
      final preferences = await _gateway.getPreferences(refresh: true);
      if (!mounted) return;
      setState(() {
        _user = user;
        _preferences = preferences;
        if (_notificationTypeFilter ==
            client_enum.NotificationType.NOTIFICATION_TYPE_EMAIL_BIND) {
          _notificationTypeFilter = null;
        }
      });
      AppNotifications.showSuccess(context, context.l10n.emailUnbound);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.unbindEmailFailed('$e'),
        );
      }
    }
  }

  Future<void> _bindEmail() async {
    if (!_emailFeatureEnabled) return;
    final user = await showAppDialog<SyncTvUser>(
      context: context,
      builder: (context) =>
          _EmailBindDialog(verifySensitiveOperation: _verifySensitiveOperation),
    );
    if (user == null || !mounted) return;
    final preferences = await _gateway.getPreferences();
    if (!mounted) return;
    setState(() {
      _user = user;
      _preferences = preferences;
    });
    AppNotifications.showSuccess(context, context.l10n.emailBound);
  }

  Future<String?> _verifySensitiveOperation() {
    return showAppDialog<String>(
      context: context,
      builder: (context) =>
          _SensitiveOperationDialog(passkeyAvailable: _passkeyAvailable),
    );
  }

  Future<void> _changePassword() async {
    final preferences = _preferences;
    final canUseCurrentPassword = preferences?.canUsePassword == true;
    final canUseEmail = preferences?.canUseEmail == true && _user.hasEmail;
    final canUsePasskey = preferences?.canUsePasskey == true && _passkeyEnabled;
    if (!canUseCurrentPassword && !canUseEmail && !canUsePasskey) {
      AppNotifications.showWarning(
        context,
        context.l10n.noPasswordVerificationMethod,
      );
      return;
    }

    final result = await showAppDialog<_PasswordUpdateInput>(
      context: context,
      builder: (context) => _PasswordUpdateDialog(
        canUseCurrentPassword: canUseCurrentPassword,
        canUseEmail: canUseEmail,
        canUsePasskey: canUsePasskey,
      ),
    );
    if (result == null) return;

    try {
      final user = switch (result.method) {
        _PasswordUpdateMethod.currentPassword =>
          await _opaqueAuthenticator.updateWithCurrentPassword(
            currentPassword: result.currentPassword,
            newPassword: result.newPassword,
          ),
        _PasswordUpdateMethod.emailToken =>
          await _opaqueAuthenticator.updateWithEmailToken(
            emailToken: result.emailToken,
            newPassword: result.newPassword,
          ),
        _PasswordUpdateMethod.passkey =>
          await _opaqueAuthenticator.updateWithPasskey(
            newPassword: result.newPassword,
          ),
      };
      final updatedPreferences = await _gateway.getPreferences();
      if (!mounted) return;
      setState(() {
        _user = user;
        _preferences = updatedPreferences;
      });
      AppNotifications.showSuccess(context, context.l10n.passwordUpdated);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.updatePasswordFailed('$e'),
        );
      }
    }
  }

  Future<void> _resetPasswordByEmail() async {
    final email = _user.email;
    if (email == null || email.isEmpty) {
      AppNotifications.showWarning(context, context.l10n.accountHasNoEmail);
      return;
    }

    final result = await showAppDialog<_PasswordResetInput>(
      context: context,
      builder: (context) => _PasswordResetDialog(email: email),
    );
    if (result == null) return;

    try {
      await _opaqueAuthenticator.resetWithEmailToken(
        email: email,
        token: result.token,
        newPassword: result.newPassword,
      );
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.passwordReset);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.resetPasswordFailed('$e'),
        );
      }
    }
  }

  Future<void> _deletePasskey(PasskeyCredentialInfo credential) async {
    final label = credential.name.isEmpty
        ? credential.credentialId
        : credential.name;
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.deletePasskey,
      icon: const Icon(Icons.fingerprint_rounded),
      iconColor: Theme.of(context).colorScheme.error,
      content: Text(context.l10n.confirmDeletePasskey(label)),
      actions: [
        AppDialogs.createCancelButton(context),
        AppActionButton(
          onPressed: () => Navigator.pop(context, true),
          icon: Icons.delete_outline_rounded,
          label: context.l10n.delete,
          style: AppActionButtonStyle.destructive,
        ),
      ],
    );
    if (confirmed != true) return;
    final verificationId = await _verifySensitiveOperation();
    if (verificationId == null || verificationId.isEmpty) return;
    try {
      await _gateway.deletePasskey(
        credential.credentialId,
        verificationId: verificationId,
      );
      final passkeys = await _gateway.listPasskeys(refresh: true);
      final preferences = await _gateway.getPreferences(refresh: true);
      if (!mounted) return;
      setState(() {
        _passkeys = passkeys;
        _preferences = preferences;
      });
      AppNotifications.showSuccess(context, context.l10n.passkeyDeleted);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.deletePasskeyFailed('$e'),
        );
      }
    }
  }

  Future<void> _bindPasskey() async {
    final suggestedName = await _deviceDisplayNameService
        .suggestedPasskeyName();
    if (!mounted) return;
    final name = await showAppDialog<String>(
      context: context,
      builder: (_) => _SingleTextInputDialog(
        title: context.l10n.bindPasskey,
        subtitle: context.l10n.bindPasskeyDescription,
        icon: Icons.fingerprint_rounded,
        label: context.l10n.deviceName,
        hintText: context.l10n.deviceNameExample,
        initialValue: suggestedName,
        primaryLabel: context.l10n.continueAction,
      ),
    );
    if (name == null) return;

    final verificationId = await _verifySensitiveOperation();
    if (verificationId == null || verificationId.isEmpty) return;

    setState(() => _bindingPasskey = true);
    try {
      final start = await _gateway.startPasskeyBind(name: name);
      final credential = await _passkeysClient.createCredential(
        start.options,
        serverBaseUrl: _gateway.serverBaseUrl,
      );
      await _gateway.finishPasskeyBind(
        sessionId: start.sessionId,
        credential: credential,
        verificationId: verificationId,
      );
      if (!mounted) return;
      final passkeys = await _gateway.listPasskeys();
      final preferences = await _gateway.getPreferences();
      if (!mounted) return;
      setState(() {
        _passkeys = passkeys;
        _preferences = preferences;
      });
      AppNotifications.showSuccess(context, context.l10n.passkeyBound);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.bindPasskeyFailed('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _bindingPasskey = false);
    }
  }

  Future<void> _setupTotp() async {
    final verificationId = await _verifySensitiveOperation();
    if (verificationId == null || verificationId.isEmpty) return;
    try {
      final setup = await _gateway.startTotpSetup(
        verificationId: verificationId,
      );
      if (!mounted) return;
      final code = await showAppDialog<String>(
        context: context,
        builder: (context) => _TotpSetupDialog(setup: setup),
      );
      if (code == null || code.isEmpty) return;
      final recoveryCodes = await _gateway.finishTotpSetup(
        setupId: setup.setupId,
        code: code,
      );
      final preferences = await _gateway.getPreferences(refresh: true);
      if (!mounted) return;
      setState(() => _preferences = preferences);
      await showAppDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => _TotpRecoveryCodesDialog(codes: recoveryCodes),
      );
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.setupAuthenticatorFailed('$error'),
        );
      }
    }
  }

  Future<void> _regenerateTotpRecoveryCodes() async {
    final verificationId = await _verifySensitiveOperation();
    if (verificationId == null || verificationId.isEmpty) return;
    try {
      final codes = await _gateway.regenerateTotpRecoveryCodes(
        verificationId: verificationId,
      );
      final preferences = await _gateway.getPreferences(refresh: true);
      if (!mounted) return;
      setState(() => _preferences = preferences);
      await showAppDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => _TotpRecoveryCodesDialog(codes: codes),
      );
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.regenerateRecoveryCodesFailed('$error'),
        );
      }
    }
  }

  Future<void> _deleteTotp() async {
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.removeAuthenticatorApp,
      icon: const Icon(Icons.shield_outlined),
      iconColor: Theme.of(context).colorScheme.error,
      content: Text(context.l10n.removeAuthenticatorAppConfirmation),
      actions: [
        AppDialogs.createCancelButton(context),
        AppActionButton(
          onPressed: () => Navigator.pop(context, true),
          icon: Icons.delete_outline_rounded,
          label: context.l10n.remove,
          style: AppActionButtonStyle.destructive,
        ),
      ],
    );
    if (confirmed != true) return;
    final verificationId = await _verifySensitiveOperation();
    if (verificationId == null || verificationId.isEmpty) return;
    try {
      await _gateway.deleteTotp(verificationId: verificationId);
      final preferences = await _gateway.getPreferences(refresh: true);
      if (!mounted) return;
      setState(() => _preferences = preferences);
      AppNotifications.showSuccess(
        context,
        context.l10n.authenticatorAppRemoved,
      );
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.removeAuthenticatorFailed('$error'),
        );
      }
    }
  }

  Future<void> _markAllRead() async {
    try {
      await _gateway.markAllNotificationsAsRead();
      await _reloadNotifications(refresh: true);
      if (mounted) {
        AppNotifications.showSuccess(context, context.l10n.allMarkedRead);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.operationFailed('$e'));
      }
    }
  }

  Future<void> _markSelectedRead() async {
    final ids = _selectedNotificationIds.toList(growable: false);
    if (ids.isEmpty) return;

    try {
      await _gateway.markNotificationsAsRead(ids);
      if (!mounted) return;
      setState(() => _selectedNotificationIds.clear());
      await _reloadNotifications(refresh: true);
      if (mounted) {
        AppNotifications.showSuccess(
          context,
          context.l10n.selectedNotificationsMarked,
        );
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.markFailed('$e'));
      }
    }
  }

  Future<void> _deleteAllRead() async {
    try {
      await _gateway.deleteAllReadNotifications();
      await _reloadNotifications(refresh: true);
      if (mounted) {
        AppNotifications.showSuccess(
          context,
          context.l10n.readNotificationsDeleted,
        );
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.deleteEntryFailed('$e'),
        );
      }
    }
  }

  Future<void> _markRead(UserNotificationItem item) async {
    try {
      await _gateway.markNotificationAsRead(item);
      if (mounted) {
        setState(() => _selectedNotificationIds.remove(item.numericId));
      }
      await _reloadNotifications(refresh: true);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.markFailed('$e'));
      }
    }
  }

  Future<void> _deleteNotification(UserNotificationItem item) async {
    try {
      await _gateway.deleteNotification(item);
      if (mounted) {
        setState(() => _selectedNotificationIds.remove(item.numericId));
      }
      await _reloadNotifications(refresh: true);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.deleteEntryFailed('$e'),
        );
      }
    }
  }

  Future<void> _openNotification(UserNotificationItem item) async {
    UserNotificationItem detail = item;
    try {
      detail = await _gateway.getNotification(item.numericId);
    } catch (e) {
      if (mounted) {
        AppNotifications.showWarning(
          context,
          context.l10n.loadNotificationDetailsFailed('$e'),
        );
      }
    }
    if (!mounted) return;

    final action = await showAppBottomSheet<_NotificationDetailAction>(
      context: context,
      builder: (context) => _NotificationDetailSheet(
        notification: detail,
        typeLabel: _notificationType(detail.type),
        createdAtLabel: _formatTimestamp(detail.createdAt),
        updatedAtLabel: _formatTimestamp(detail.updatedAt),
      ),
    );
    if (!mounted || action == null) return;

    switch (action) {
      case _NotificationDetailAction.markRead:
        await _markRead(detail);
        break;
      case _NotificationDetailAction.delete:
        await _deleteNotification(detail);
        break;
    }
  }

  Future<void> _reloadNotifications({int? page, bool refresh = true}) async {
    var targetPage = page ?? _notificationPage;
    if (targetPage < 1) targetPage = 1;
    setState(() => _loadingNotifications = true);
    try {
      var notifications = await _fetchNotificationsPage(
        targetPage,
        refresh: refresh,
      );
      var actualPage = targetPage;
      final maxPage = _notificationMaxPage(notifications.total);
      if (targetPage > maxPage) {
        actualPage = maxPage;
        notifications = await _fetchNotificationsPage(
          actualPage,
          refresh: refresh,
        );
      }
      if (!mounted) return;
      setState(() {
        _notifications = notifications;
        _notificationPage = actualPage;
        _loadingNotifications = false;
        _clearLoadError(_moduleNotifications);
        final visibleIds = notifications.notifications
            .map((item) => item.numericId)
            .where((id) => id > 0)
            .toSet();
        _selectedNotificationIds.removeWhere((id) => !visibleIds.contains(id));
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingNotifications = false;
        _setLoadError(_moduleNotifications, e);
      });
      AppNotifications.showError(
        context,
        context.l10n.loadNotificationsFailed('$e'),
      );
    }
  }

  Future<UserNotificationsPage> _fetchNotificationsPage(
    int page, {
    bool refresh = false,
  }) {
    return _gateway.listNotifications(
      page: page,
      pageSize: _notificationPageSize,
      isRead: _notificationReadFilter,
      notificationType: _notificationTypeFilter,
      search: _notificationSearchController.text.trim(),
      sortBy: _notificationSortBy,
      sortDirection: _notificationSortDirection,
      refresh: refresh,
    );
  }

  int _notificationMaxPage(int total) {
    if (total <= 0) return 1;
    return ((total + _notificationPageSize - 1) / _notificationPageSize)
        .floor();
  }

  Future<void> _reloadNotificationsFromFirstPage() {
    return _reloadNotifications(page: 1);
  }

  Future<void> _startOAuth2Bind(OAuth2ProviderOption provider) async {
    final authorizationMode = selectOAuth2AuthorizationMode(
      provider,
      platform: defaultTargetPlatform,
      browserAvailable: _oauth2Callbacks(context).canCreateSession,
      nativeAvailable: _nativeAppleSignIn(context).isSupported,
    );
    if (authorizationMode == OAuth2ClientAuthorizationMode.native) {
      await _startNativeAppleOAuth2Bind(provider);
      return;
    }
    if (authorizationMode != OAuth2ClientAuthorizationMode.browser) return;
    final oauth2Callbacks = _oauth2Callbacks(context);
    try {
      for (
        var bindAttempt = 1;
        bindAttempt <= oauth2CallbackBindMaxAttempts;
        bindAttempt++
      ) {
        final verificationId = await _verifySensitiveOperation();
        if (verificationId == null) {
          if (mounted && _bindProvider != null) {
            setState(() => _bindProvider = null);
          }
          return;
        }
        try {
          await withOAuth2CallbackSession(oauth2Callbacks, (
            callbackSession,
          ) async {
            final start = await _gateway.startOAuth2Bind(
              provider.name,
              redirectUrl: callbackSession.redirectUrl,
              verificationId: verificationId,
            );
            if (!mounted) return;
            setState(() {
              _bindProvider = provider.name;
              _bindAttempt++;
            });
            final attempt = _bindAttempt;
            final authorizationUrl = start.authorizationUrl;
            if (authorizationUrl == null || authorizationUrl.isEmpty) {
              throw StateError('Browser authorization URL is missing');
            }
            final uri = Uri.parse(authorizationUrl);
            late final OAuth2CallbackPayload parsed;
            try {
              parsed = await callbackSession.authorize(
                authorizationUrl: uri,
                expectedState: start.state,
              );
            } on OAuth2AuthorizationCanceled {
              if (mounted && attempt == _bindAttempt) {
                setState(() => _bindProvider = null);
              }
              return;
            } on OAuth2AuthorizationTimedOut {
              if (mounted && attempt == _bindAttempt) {
                setState(() => _bindProvider = null);
                AppNotifications.showError(
                  context,
                  context.l10n.oauthAuthorizationTimedOut,
                );
              }
              return;
            }
            if (!mounted || attempt != _bindAttempt) return;
            await _gateway.finishOAuth2Bind(
              code: parsed.code,
              state: parsed.state,
            );
            final linked = await _gateway.getLinkedOAuth2Accounts();
            if (!mounted) return;
            setState(() {
              _linkedOAuth2 = linked;
              _clearLoadError(_moduleOAuthLinks);
              _bindProvider = null;
            });
            AppNotifications.showSuccess(
              context,
              context.l10n.oauthAccountBound,
            );
          }, maxBindAttempts: 1);
          return;
        } on OAuth2CallbackBindFailed {
          if (mounted && _bindProvider != null) {
            setState(() => _bindProvider = null);
          }
          if (bindAttempt >= oauth2CallbackBindMaxAttempts) {
            rethrow;
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _bindProvider = null);
        AppNotifications.showError(
          context,
          context.l10n.oauthBindingFailed('$e'),
        );
      }
    }
  }

  Future<void> _startNativeAppleOAuth2Bind(
    OAuth2ProviderOption provider,
  ) async {
    try {
      final verificationId = await _verifySensitiveOperation();
      if (verificationId == null) return;
      final start = await _gateway.startOAuth2Bind(
        provider.name,
        verificationId: verificationId,
        native: true,
      );
      final nonce = start.nonce;
      if (nonce == null || nonce.isEmpty) {
        throw StateError('Apple authorization nonce is missing');
      }
      if (!mounted) return;
      setState(() {
        _bindProvider = provider.name;
        _bindAttempt++;
      });
      final attempt = _bindAttempt;
      final parsed = await _nativeAppleSignIn(
        context,
      ).authorize(expectedState: start.state, nonce: nonce);
      if (!mounted || attempt != _bindAttempt) return;
      await _gateway.finishOAuth2Bind(code: parsed.code, state: parsed.state);
      final linked = await _gateway.getLinkedOAuth2Accounts();
      if (!mounted) return;
      setState(() {
        _linkedOAuth2 = linked;
        _clearLoadError(_moduleOAuthLinks);
        _bindProvider = null;
      });
      AppNotifications.showSuccess(context, context.l10n.oauthAccountBound);
    } on OAuth2AuthorizationCanceled {
      if (mounted) setState(() => _bindProvider = null);
    } on OAuth2AuthorizationTimedOut {
      if (mounted) {
        setState(() => _bindProvider = null);
        AppNotifications.showError(
          context,
          context.l10n.oauthAuthorizationTimedOut,
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _bindProvider = null);
        AppNotifications.showError(
          context,
          context.l10n.oauthBindingFailed('$e'),
        );
      }
    }
  }

  Future<void> _unlinkOAuth2(OAuth2LinkedAccount account) async {
    try {
      final verificationId = await _verifySensitiveOperation();
      if (verificationId == null) return;
      await _gateway.unlinkOAuth2Account(
        account,
        verificationId: verificationId,
      );
      final linked = await _gateway.getLinkedOAuth2Accounts();
      if (!mounted) return;
      setState(() {
        _linkedOAuth2 = linked;
        _clearLoadError(_moduleOAuthLinks);
      });
      AppNotifications.showSuccess(context, context.l10n.unboundSuccessfully);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.unbindFailed('$e'));
      }
    }
  }

  Future<void> _reloadRooms({int? page, bool refresh = true}) async {
    var targetPage = page ?? _roomsPage;
    if (targetPage < 1) targetPage = 1;
    setState(() => _loadingRooms = true);
    try {
      var rooms = await _fetchRoomsPage(targetPage, refresh: refresh);
      var actualPage = targetPage;
      final maxPage = _roomsMaxPage(rooms.total);
      if (targetPage > maxPage) {
        actualPage = maxPage;
        rooms = await _fetchRoomsPage(actualPage, refresh: refresh);
      }
      if (!mounted) return;
      setState(() {
        _myRooms = rooms;
        _roomsPage = actualPage;
        _loadingRooms = false;
        _clearLoadError(_moduleRooms);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingRooms = false;
        _setLoadError(_moduleRooms, e);
      });
      AppNotifications.showError(context, context.l10n.loadMyRoomsFailed('$e'));
    }
  }

  Future<void> _reloadBlockedUsers({int? page}) async {
    var targetPage = page ?? _blockedUsersPage;
    if (targetPage < 1) targetPage = 1;
    setState(() => _loadingBlockedUsers = true);
    try {
      var blockedUsers = await _fetchBlockedUsersPage(targetPage);
      var actualPage = targetPage;
      final maxPage = _blockedUsersMaxPage(blockedUsers.total);
      if (targetPage > maxPage) {
        actualPage = maxPage;
        blockedUsers = await _fetchBlockedUsersPage(actualPage);
      }
      if (!mounted) return;
      setState(() {
        _blockedUsers = blockedUsers;
        _blockedUsersPage = actualPage;
        _loadingBlockedUsers = false;
        _clearLoadError(_moduleBlockedUsers);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingBlockedUsers = false;
        _setLoadError(_moduleBlockedUsers, e);
      });
      AppNotifications.showError(
        context,
        context.l10n.blockedUsersTemporarilyUnavailable,
      );
    }
  }

  Future<BlockedUsersPage> _fetchBlockedUsersPage(int page) {
    return _gateway.listBlockedUsers(
      page: page,
      pageSize: _blockedUsersPageSize,
      search: _blockedUserSearchController.text.trim(),
    );
  }

  Future<void> _reloadBlockedUsersFromFirstPage() {
    return _reloadBlockedUsers(page: 1);
  }

  int _blockedUsersMaxPage(int total) {
    if (total <= 0) return 1;
    return ((total + _blockedUsersPageSize - 1) / _blockedUsersPageSize).ceil();
  }

  Future<void> _unblockUser(BlockedUserInfo blockedUser) async {
    final user = blockedUser.user;
    final name = user.username.trim().isEmpty ? user.id : user.username.trim();
    final confirmed = await showAppDialog<bool>(
      context: context,
      builder: (context) => AppConfirmDialog(
        icon: const Icon(Icons.person_add_alt_1_outlined),
        title: context.l10n.unblockUser,
        content: Text(context.l10n.confirmUnblockUser(name)),
        confirmLabel: context.l10n.unblockUser,
        confirmIcon: Icons.person_add_alt_1_outlined,
        onConfirm: () => Navigator.pop(context, true),
      ),
    );
    if (confirmed != true) return;

    try {
      await _gateway.unblockUser(user.id);
      if (!mounted) return;
      await _reloadBlockedUsers();
      if (!mounted) return;
      AppNotifications.showSuccess(context, context.l10n.userUnblocked);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.unblockUserFailed('$e'),
        );
      }
    }
  }

  String? _loadError(String label) => _loadErrors[label];

  void _setLoadError(String label, Object error) {
    _loadErrors = Map.unmodifiable({..._loadErrors, label: error.toString()});
  }

  void _clearLoadError(String label) {
    if (!_loadErrors.containsKey(label)) return;
    final next = Map<String, String>.from(_loadErrors)..remove(label);
    _loadErrors = Map.unmodifiable(next);
  }

  Future<RoomsPage> _fetchRoomsPage(int page, {bool refresh = false}) {
    return _gateway.getRooms(
      page: page,
      pageSize: _roomsPageSize,
      search: _roomSearchController.text.trim(),
      relation: _roomRelationFilter,
      sortBy: _roomSortBy,
      sortDirection: client_enum.SortDirection.SORT_DIRECTION_DESC,
      refresh: refresh,
    );
  }

  Future<void> _reloadRoomsFromFirstPage() {
    return _reloadRooms(page: 1);
  }

  int _roomsMaxPage(int total) {
    if (total <= 0) return 1;
    return ((total + _roomsPageSize - 1) / _roomsPageSize).ceil();
  }

  Future<void> _openRoom(SyncTvRoom room) async {
    try {
      await widget.onOpenRoom(room);
      if (mounted) await _reloadRooms();
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.openRoomFailed('$e'));
      }
    }
  }

  Future<void> _createRoom() async {
    await widget.onCreateRoom();
    if (mounted) await _reloadRooms(page: 1, refresh: true);
  }

  Future<void> _manageRoom(SyncTvRoom room) async {
    try {
      await widget.onManageRoom(room);
      if (mounted) await _reloadRooms(refresh: true);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.openRoomManagementFailed('$e'),
        );
      }
    }
  }

  Future<void> _leaveOrDeleteRoom(SyncTvRoom room) async {
    final isOwner = _isMyCreatedRoom(room);
    final actionText = isOwner
        ? context.l10n.deleteRoom
        : context.l10n.leaveRoom;
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: actionText,
      icon: Icon(isOwner ? Icons.delete_forever_rounded : Icons.logout),
      iconColor: isOwner
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.primary,
      content: Text(
        isOwner
            ? context.l10n.deleteOwnedRoomDescription(room.roomName)
            : context.l10n.leaveRoomDescription(room.roomName),
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        AppActionButton(
          onPressed: () => Navigator.pop(context, true),
          icon: isOwner ? Icons.delete_outline : Icons.logout,
          label: actionText,
          style: isOwner
              ? AppActionButtonStyle.destructive
              : AppActionButtonStyle.tonal,
        ),
      ],
    );
    if (confirmed != true) return;

    try {
      if (isOwner) {
        await _gateway.deleteRoom(room.roomId);
      } else {
        await _gateway.leaveRoom(room.roomId);
      }
      await _reloadRooms();
      if (mounted) {
        AppNotifications.showSuccess(
          context,
          context.l10n.actionCompleted(actionText),
        );
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.actionFailed(actionText, '$e'),
        );
      }
    }
  }

  Future<void> _closeAccount() async {
    final confirmationText = context.l10n.closeAccount;
    final controller = TextEditingController();
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.closeAccount,
      icon: const Icon(Icons.warning_amber_rounded),
      iconColor: Theme.of(context).colorScheme.error,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.closeAccountDescription,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: controller,
            label: context.l10n.enterCloseAccountToConfirm(confirmationText),
            prefixIcon: Icons.warning_amber_rounded,
            autofocus: true,
            onSubmitted: (_) => Navigator.pop(
              context,
              controller.text.trim() == confirmationText,
            ),
          ),
        ],
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        AppActionButton(
          onPressed: () => Navigator.pop(
            context,
            controller.text.trim() == confirmationText,
          ),
          icon: Icons.delete_forever_rounded,
          label: context.l10n.closeAccount,
          style: AppActionButtonStyle.destructive,
        ),
      ],
    );
    _disposeTextControllersAfterDialog([controller]);
    if (confirmed != true) {
      if (confirmed == false && mounted) {
        AppNotifications.showWarning(
          context,
          context.l10n.confirmationTextMismatch,
        );
      }
      return;
    }

    try {
      await _gateway.closeAccount();
      if (!mounted) return;
      AppNotifications.showSuccess(context, context.l10n.accountClosed);
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.closeAccountFailed('$e'),
        );
      }
    }
  }

  void _disposeTextControllersAfterDialog(
    List<TextEditingController> controllers,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final controller in controllers) {
        controller.dispose();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return AppScaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF4F6FA),
      appBar: AppPageBar(
        title: Text(
          context.l10n.accountCenter,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
        actions: [
          AppIconButton(
            onPressed: () => _load(refresh: true),
            icon: Icons.refresh_rounded,
            tooltip: context.l10n.refresh,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final useRail = constraints.maxWidth >= 900;
          final content = _loading
              ? const AppLoadingIndicator()
              : _buildTabView(theme);

          if (!useRail) {
            return Column(
              children: [
                _buildTopTabs(theme),
                Expanded(child: content),
              ],
            );
          }

          return Row(
            children: [
              _buildSideNavigation(theme),
              AppVerticalDivider(
                width: 1,
                thickness: 1,
                color: theme.dividerColor.withValues(alpha: 0.55),
              ),
              Expanded(child: content),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabView(ThemeData theme) {
    return AppTabBarView(
      controller: _tabController,
      children: [
        _buildOverviewTab(theme),
        _buildProfileTab(theme),
        _buildRoomsTab(theme),
        _buildPrivacyTab(theme),
        _buildSecurityTab(theme),
        _buildNotificationsTab(theme),
        _buildBindingsTab(theme),
      ],
    );
  }

  Widget _buildSideNavigation(ThemeData theme) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        return SizedBox(
          width: 232,
          child: AppInkSurface(
            color: theme.colorScheme.surface,
            clipBehavior: Clip.none,
            child: AppSafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _user.username.isEmpty
                                ? context.l10n.currentAccount
                                : _user.username,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (_user.hasEmail)
                            Text(
                              _user.email!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.58,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: AppListView.separated(
                        itemCount: _sections.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          final section = _sections[index];
                          final selected = _tabController.index == index;
                          return _AccountNavTile(
                            icon: section.icon,
                            label: section.label,
                            selected: selected,
                            onTap: () => setState(() {
                              _tabController.animateTo(index);
                            }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopTabs(ThemeData theme) {
    return AppInkSurface(
      color: theme.colorScheme.surface,
      clipBehavior: Clip.none,
      child: AppSafeArea(
        bottom: false,
        child: AppPanelSurface(
          color: Colors.transparent,
          borderRadius: BorderRadius.zero,
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.65),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
          child: AppTabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerColor: Colors.transparent,
            indicator: appTabPillIndicator(
              color: theme.colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurface.withValues(
              alpha: 0.62,
            ),
            labelStyle: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            tabs: _sections
                .map(
                  (section) => Tab(
                    height: 42,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(section.icon, size: 18),
                          const SizedBox(width: 6),
                          Text(section.label),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _responsiveList({
    required List<Widget> children,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth >= 1180
            ? 1040.0
            : constraints.maxWidth >= 760
            ? 860.0
            : double.infinity;
        return AppListView(
          padding: padding,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOverviewTab(ThemeData theme) {
    final preferences = _preferences;
    final rooms = _myRooms;
    final emailStatus = _emailStatusView(theme);
    final unread = _notifications?.unreadCount ?? 0;
    final roomCount = rooms?.total ?? 0;
    final activeFactors = preferences == null
        ? 0
        : [
            preferences.canUsePassword,
            preferences.canUseEmail && _user.hasEmail,
            preferences.canUsePasskey && _passkeyEnabled,
            preferences.canUseTotp,
          ].where((value) => value).length;

    return _responsiveList(
      children: [
        _AccountHero(
          user: _user,
          roleLabel: _userRoleLabel(_user.role),
          statusLabel: _userStatusLabel(_user.status),
          activeServerName:
              _gateway.activeServerName ?? context.l10n.noServerConnected,
          createdAtLabel: _formatTimestamp(_user.createdAt),
        ),
        if (_loadErrors.isNotEmpty) ...[
          const SizedBox(height: 12),
          _LoadErrorSummary(
            errors: _loadErrors,
            moduleInfo: _moduleInfo,
            onRetry: () => _load(refresh: true),
          ),
        ],
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final tiles = [
              _MetricTile(
                icon: Icons.meeting_room_outlined,
                label: context.l10n.myRooms,
                value: '$roomCount',
                tone: theme.colorScheme.primary,
              ),
              _MetricTile(
                icon: Icons.notifications_none_rounded,
                label: context.l10n.unreadNotifications,
                value: '$unread',
                tone: const Color(0xFF0F766E),
              ),
              _MetricTile(
                icon: Icons.security_rounded,
                label: context.l10n.loginFactors,
                value: '$activeFactors',
                tone: const Color(0xFFB45309),
              ),
              if (_showEmailBindingControls)
                _MetricTile(
                  icon: emailStatus.icon,
                  label: context.l10n.emailStatus,
                  value: emailStatus.label,
                  tone: emailStatus.tone,
                ),
            ];
            final columns = constraints.maxWidth >= 820
                ? tiles.length.clamp(1, 4)
                : tiles.length == 1
                ? 1
                : 2;
            return AppGridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: columns,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: columns == 4 ? 1.75 : 1.95,
              children: tiles,
            );
          },
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 840;
            final panels = [
              _buildQuickProfilePanel(theme),
              _buildQuickSecurityPanel(theme),
              _buildRecentRoomsPanel(theme),
            ];
            if (!wide) {
              return Column(
                children: [
                  for (final panel in panels) ...[
                    panel,
                    if (panel != panels.last) const SizedBox(height: 12),
                  ],
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: panels[0]),
                const SizedBox(width: 12),
                Expanded(child: panels[1]),
                const SizedBox(width: 12),
                Expanded(child: panels[2]),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildProfileTab(ThemeData theme) {
    final preferences = _preferences;
    final emailStatus = _emailStatusView(theme);
    final notifications =
        preferences?.notifications ?? NotificationPreferences.defaults();
    return _responsiveList(
      children: [
        _SectionHeader(
          title: context.l10n.personalProfile,
          subtitle: context.l10n.personalProfileDescription,
          icon: Icons.person_outline_rounded,
        ),
        const SizedBox(height: 12),
        _Section(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 620;
              final avatar = _EditableProfileAvatar(
                username: _user.username,
                avatarUrl: _user.avatarUrl,
                size: 68,
                updating: _updatingAvatar,
                onPick: _updateAvatar,
                onClear: _user.avatarUrl.isEmpty ? null : _clearAvatar,
              );
              final details = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _user.username,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _StatusPill(
                        icon: Icons.admin_panel_settings_outlined,
                        label: _userRoleLabel(_user.role),
                      ),
                      if (_showEmailBindingControls)
                        _StatusPill(
                          icon: emailStatus.icon,
                          label: context.l10n.emailWithStatus(
                            emailStatus.label,
                          ),
                          color: emailStatus.tone,
                        ),
                      if (_user.isBanned)
                        _StatusPill(
                          icon: Icons.block_rounded,
                          label: context.l10n.banned,
                          danger: true,
                        ),
                    ],
                  ),
                  if (_showEmailBindingControls) ...[
                    const SizedBox(height: 12),
                    Text(
                      _user.hasEmail
                          ? _user.email!
                          : context.l10n.emailNotBound,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                    ),
                  ],
                ],
              );
              final action = AppActionButton(
                onPressed: _rename,
                icon: Icons.edit_rounded,
                label: context.l10n.changeUsername,
              );
              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        avatar,
                        const SizedBox(width: 14),
                        Expanded(child: details),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(width: double.infinity, child: action),
                  ],
                );
              }
              return Row(
                children: [
                  avatar,
                  const SizedBox(width: 18),
                  Expanded(child: details),
                  const SizedBox(width: 16),
                  action,
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _Section(
          title: context.l10n.accountInformation,
          child: _InfoGrid(
            entries: [
              _InfoEntry(context.l10n.userId, _user.id),
              _InfoEntry(
                context.l10n.accountStatus,
                _userStatusLabel(_user.status),
              ),
              _InfoEntry(
                context.l10n.createdAt,
                _formatTimestamp(_user.createdAt),
              ),
              _InfoEntry(
                context.l10n.updatedAt,
                _formatTimestamp(_user.updatedAt),
              ),
              _InfoEntry(
                context.l10n.onlineConnectionsLabel,
                '${_user.onlineCount}',
              ),
              if (_user.isBanned)
                _InfoEntry(context.l10n.banReason, _user.bannedReason),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (preferences != null)
          _Section(
            title: context.l10n.notificationPreferences,
            subtitle: context.l10n.notificationPreferencesDescription,
            child: AppResponsiveWrap(
              minItemWidth: 320,
              maxColumns: 2,
              runSpacing: 4,
              children: [
                _PreferenceSwitch(
                  title: context.l10n.roomInviteInAppNotifications,
                  value: notifications.roomInvitationInApp,
                  onChanged: _savingPreferences
                      ? null
                      : (value) => _updateNotifications(
                          notifications.copyWith(roomInvitationInApp: value),
                        ),
                ),
                _PreferenceSwitch(
                  title: context.l10n.roomEventInAppNotifications,
                  value: notifications.roomEventInApp,
                  onChanged: _savingPreferences
                      ? null
                      : (value) => _updateNotifications(
                          notifications.copyWith(roomEventInApp: value),
                        ),
                ),
                _PreferenceSwitch(
                  title: context.l10n.systemAnnouncementInAppNotifications,
                  value: notifications.systemAnnouncementInApp,
                  onChanged: _savingPreferences
                      ? null
                      : (value) => _updateNotifications(
                          notifications.copyWith(
                            systemAnnouncementInApp: value,
                          ),
                        ),
                ),
                if (_user.hasEmail && _emailFeatureEnabled)
                  _PreferenceSwitch(
                    title: context.l10n.roomInviteEmailNotifications,
                    value: notifications.roomInvitationEmail,
                    onChanged: _savingPreferences
                        ? null
                        : (value) => _updateNotifications(
                            notifications.copyWith(roomInvitationEmail: value),
                          ),
                  ),
                if (_user.hasEmail && _emailFeatureEnabled)
                  _PreferenceSwitch(
                    title: context.l10n.roomEventEmailNotifications,
                    value: notifications.roomEventEmail,
                    onChanged: _savingPreferences
                        ? null
                        : (value) => _updateNotifications(
                            notifications.copyWith(roomEventEmail: value),
                          ),
                  ),
                if (_user.hasEmail && _emailFeatureEnabled)
                  _PreferenceSwitch(
                    title: context.l10n.systemAnnouncementEmailNotifications,
                    value: notifications.systemAnnouncementEmail,
                    onChanged: _savingPreferences
                        ? null
                        : (value) => _updateNotifications(
                            notifications.copyWith(
                              systemAnnouncementEmail: value,
                            ),
                          ),
                  ),
              ],
            ),
          )
        else if (_loadError(_moduleAccountPreferences) != null)
          _LoadErrorBanner(
            title: context.l10n.notificationPreferencesUnavailable,
            moduleInfo: _moduleInfo[_moduleAccountPreferences],
            message: _loadError(_moduleAccountPreferences)!,
            onRetry: () => _load(refresh: true),
          ),
      ],
    );
  }

  Widget _buildRoomsTab(ThemeData theme) {
    final page = _myRooms;
    final loadError = _loadError(_moduleRooms);
    final rooms = page?.rooms ?? const <SyncTvRoom>[];
    final total = page?.total ?? 0;
    final maxPage = _roomsMaxPage(total);
    final pageStart = total == 0 ? 0 : ((_roomsPage - 1) * _roomsPageSize) + 1;
    final pageEnd = total == 0
        ? 0
        : (_roomsPage * _roomsPageSize).clamp(0, total);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1040),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _SectionHeader(
                          title: context.l10n.myRooms,
                          subtitle: context.l10n.myRoomsDescription,
                          icon: Icons.meeting_room_outlined,
                          dense: true,
                        ),
                      ),
                      AppActionButton(
                        onPressed: _createRoom,
                        icon: Icons.add_rounded,
                        label: context.l10n.createRoom,
                      ),
                      if (_loadingRooms)
                        const Padding(
                          padding: EdgeInsetsDirectional.only(start: 10),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: AppLoadingIndicator(
                              size: AppLoadingSize.sm,
                              centered: false,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 760;
                      final search = AppSearchField(
                        controller: _roomSearchController,
                        hintText: context.l10n.searchRoomNameOrDescription,
                        onChanged: (value) {
                          if (value.isEmpty) _reloadRoomsFromFirstPage();
                        },
                        onSubmitted: (_) => _reloadRoomsFromFirstPage(),
                      );
                      final filters = Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _RelationChip(
                            label: context.l10n.all,
                            value:
                                client_enum.MyRoomRelation.MY_ROOM_RELATION_ALL,
                            groupValue: _roomRelationFilter,
                            onSelected: _setRoomRelationFilter,
                          ),
                          _RelationChip(
                            label: context.l10n.createdByMe,
                            value: client_enum
                                .MyRoomRelation
                                .MY_ROOM_RELATION_CREATED,
                            groupValue: _roomRelationFilter,
                            onSelected: _setRoomRelationFilter,
                          ),
                          _RelationChip(
                            label: context.l10n.joinedByMe,
                            value: client_enum
                                .MyRoomRelation
                                .MY_ROOM_RELATION_PARTICIPATING,
                            groupValue: _roomRelationFilter,
                            onSelected: _setRoomRelationFilter,
                          ),
                          AppSelect<client_enum.MyRoomListSortBy>(
                            value: _roomSortBy,
                            options: {
                              context.l10n.frequentlyVisited: client_enum
                                  .MyRoomListSortBy
                                  .MY_ROOM_LIST_SORT_BY_FREQUENT,
                              context.l10n.recentlyVisited: client_enum
                                  .MyRoomListSortBy
                                  .MY_ROOM_LIST_SORT_BY_LAST_VISITED_AT,
                              context.l10n.recentActivity: client_enum
                                  .MyRoomListSortBy
                                  .MY_ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
                              context.l10n.updatedAt: client_enum
                                  .MyRoomListSortBy
                                  .MY_ROOM_LIST_SORT_BY_UPDATED_AT,
                              context.l10n.createdAt: client_enum
                                  .MyRoomListSortBy
                                  .MY_ROOM_LIST_SORT_BY_CREATED_AT,
                              context.l10n.name: client_enum
                                  .MyRoomListSortBy
                                  .MY_ROOM_LIST_SORT_BY_NAME,
                            },
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() => _roomSortBy = value);
                              _reloadRoomsFromFirstPage();
                            },
                          ),
                          AppIconButton(
                            onPressed: _reloadRooms,
                            icon: Icons.refresh_rounded,
                            tooltip: context.l10n.refreshRooms,
                          ),
                        ],
                      );
                      if (!wide) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            search,
                            const SizedBox(height: 10),
                            filters,
                          ],
                        );
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: search),
                          const SizedBox(width: 12),
                          Flexible(child: filters),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  AppPaginationBar(
                    padding: EdgeInsets.zero,
                    label: context.l10n.pageRangeSummary(
                      _roomsPage,
                      maxPage,
                      pageStart,
                      pageEnd,
                      total,
                    ),
                    onPrevious: _loadingRooms || _roomsPage <= 1
                        ? null
                        : () => _reloadRooms(page: _roomsPage - 1),
                    onNext: _loadingRooms || _roomsPage >= maxPage
                        ? null
                        : () => _reloadRooms(page: _roomsPage + 1),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: loadError != null && page == null
              ? Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: _LoadErrorBanner(
                      title: context.l10n.myRoomsTemporarilyUnavailable,
                      moduleInfo: _moduleInfo[_moduleRooms],
                      message: loadError,
                      onRetry: _reloadRooms,
                    ),
                  ),
                )
              : rooms.isEmpty
              ? AppEmptyMessage(message: context.l10n.noMatchingRooms)
              : AppRefreshIndicator(
                  onRefresh: _reloadRooms,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final maxWidth = constraints.maxWidth >= 1180
                          ? 1040.0
                          : constraints.maxWidth >= 760
                          ? 900.0
                          : double.infinity;
                      return AppListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                        itemCount: rooms.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final room = rooms[index];
                          return Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: maxWidth),
                              child: _RoomManagementTile(
                                room: room,
                                roleLabel: _roomRoleLabel(room.myRole),
                                relationLabel: _roomRelationLabel(
                                  room.myRelation,
                                ),
                                updatedAtLabel: _formatTimestamp(
                                  room.updatedAt,
                                ),
                                isOwner: _isMyCreatedRoom(room),
                                canManage: _canManageRoomFromListEntry(room),
                                onOpen: () => _openRoom(room),
                                onManage: () => _manageRoom(room),
                                onLeaveOrDelete: () => _leaveOrDeleteRoom(room),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildPrivacyTab(ThemeData theme) {
    final page = _blockedUsers;
    final loadError = _loadError(_moduleBlockedUsers);
    final users = page?.users ?? const <BlockedUserInfo>[];
    final total = page?.total ?? 0;
    final maxPage = _blockedUsersMaxPage(total);
    final pageStart = total == 0
        ? 0
        : ((_blockedUsersPage - 1) * _blockedUsersPageSize) + 1;
    final pageEnd = total == 0
        ? 0
        : (_blockedUsersPage * _blockedUsersPageSize).clamp(0, total);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _SectionHeader(
                          title: context.l10n.blockedUsers,
                          subtitle: context.l10n.blockedUsersDescription,
                          icon: Icons.person_off_outlined,
                          dense: true,
                        ),
                      ),
                      AppIconButton(
                        onPressed: _loadingBlockedUsers
                            ? null
                            : _reloadBlockedUsers,
                        icon: Icons.refresh_rounded,
                        tooltip: context.l10n.refresh,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppSearchField(
                    controller: _blockedUserSearchController,
                    hintText: context.l10n.searchBlockedUsers,
                    enabled: !_loadingBlockedUsers,
                    onChanged: (value) {
                      if (value.isEmpty) _reloadBlockedUsersFromFirstPage();
                    },
                    onSubmitted: (_) => _reloadBlockedUsersFromFirstPage(),
                  ),
                  const SizedBox(height: 8),
                  AppPaginationBar(
                    padding: EdgeInsets.zero,
                    label: context.l10n.pageRangeSummary(
                      _blockedUsersPage,
                      maxPage,
                      pageStart,
                      pageEnd,
                      total,
                    ),
                    onPrevious: _loadingBlockedUsers || _blockedUsersPage <= 1
                        ? null
                        : () =>
                              _reloadBlockedUsers(page: _blockedUsersPage - 1),
                    onNext: _loadingBlockedUsers || _blockedUsersPage >= maxPage
                        ? null
                        : () =>
                              _reloadBlockedUsers(page: _blockedUsersPage + 1),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: loadError != null && page == null
              ? Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: _LoadErrorBanner(
                      title: context.l10n.blockedUsersTemporarilyUnavailable,
                      moduleInfo: _moduleInfo[_moduleBlockedUsers],
                      message: loadError,
                      onRetry: _reloadBlockedUsers,
                    ),
                  ),
                )
              : users.isEmpty
              ? AppEmptyMessage(message: context.l10n.noBlockedUsers)
              : AppRefreshIndicator(
                  onRefresh: _reloadBlockedUsers,
                  child: AppListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                    itemCount: users.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final blockedUser = users[index];
                      final user = blockedUser.user;
                      final name = user.username.trim().isEmpty
                          ? user.id
                          : user.username.trim();
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 900),
                          child: AppPanelSurface(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.dividerColor.withValues(alpha: 0.6),
                            ),
                            child: AppTile(
                              prefix: AppAvatar(
                                name: name,
                                imageUrl: user.avatarUrl,
                                size: 42,
                              ),
                              title: Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                context.l10n.blockedAt(
                                  _formatTimestamp(blockedUser.blockedAt),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              suffix: AppActionButton(
                                onPressed: _loadingBlockedUsers
                                    ? null
                                    : () => _unblockUser(blockedUser),
                                icon: Icons.person_add_alt_1_outlined,
                                label: context.l10n.unblockUser,
                                style: AppActionButtonStyle.outlined,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSecurityTab(ThemeData theme) {
    final preferences = _preferences;
    final emailStatus = _emailStatusView(theme);
    final preferencesError = _loadError(_moduleAccountPreferences);
    final passkeyErrorKey = _loadError('Passkey') != null
        ? 'Passkey'
        : context.l10n.localPasskey;
    final passkeyError = _loadError(passkeyErrorKey);
    return _responsiveList(
      children: [
        _SectionHeader(
          title: context.l10n.accountSecurity,
          subtitle: context.l10n.accountSecurityDescription,
          icon: Icons.security_rounded,
        ),
        const SizedBox(height: 12),
        if (preferences != null)
          _Section(
            title: context.l10n.loginProtection,
            subtitle: context.l10n.loginProtectionDescription,
            child: Column(
              children: [
                AppSwitchTile(
                  value: preferences.twoFactorEnabled,
                  onChanged: _savingPreferences
                      ? null
                      : (value) => _toggleTwoFactor(value),
                  title: Text(context.l10n.multiFactorAuthentication),
                  subtitle: Text(
                    context.l10n.availableFactors(
                      _factorLabels(
                        preferences,
                      ).join(context.l10n.listSeparator),
                    ),
                  ),
                ),
                if (_showEmailBindingControls) ...[
                  const AppDivider(height: 1),
                  AppTile(
                    contentPadding: EdgeInsets.zero,
                    prefix: Icon(emailStatus.icon, color: emailStatus.tone),
                    title: Text(context.l10n.email),
                    subtitle: Text(
                      _user.hasEmail
                          ? _user.email!
                          : context.l10n.bindEmailDescription,
                    ),
                    suffix: _user.hasEmail
                        ? AppActionButton(
                            onPressed: _unbindEmail,
                            icon: Icons.link_off_rounded,
                            label: context.l10n.unbind,
                            style: AppActionButtonStyle.outlined,
                          )
                        : AppActionButton(
                            onPressed: _emailFeatureEnabled ? _bindEmail : null,
                            icon: Icons.add_link_rounded,
                            label: context.l10n.bind,
                            style: AppActionButtonStyle.tonal,
                          ),
                  ),
                ],
                const AppDivider(height: 1),
                AppTile(
                  contentPadding: EdgeInsets.zero,
                  prefix: const Icon(Icons.password_rounded),
                  title: Text(context.l10n.loginPassword),
                  subtitle: Text(context.l10n.opaquePasswordDescription),
                  suffix: Wrap(
                    spacing: 8,
                    children: [
                      if (_user.hasEmail && _emailFeatureEnabled)
                        AppActionButton(
                          onPressed: _resetPasswordByEmail,
                          label: context.l10n.emailReset,
                          style: AppActionButtonStyle.outlined,
                        ),
                      AppActionButton(
                        onPressed: _changePassword,
                        label: context.l10n.edit,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else if (preferencesError != null)
          _LoadErrorBanner(
            title: context.l10n.loginProtectionUnavailable,
            moduleInfo: _moduleInfo[_moduleAccountPreferences],
            message: preferencesError,
            onRetry: () => _load(refresh: true),
          ),
        const SizedBox(height: 12),
        if (preferences != null) ...[
          _Section(
            title: context.l10n.authenticatorApp,
            subtitle: context.l10n.authenticatorAppDescription,
            child: AppTile(
              contentPadding: EdgeInsets.zero,
              prefix: Icon(
                preferences.canUseTotp
                    ? Icons.verified_user_rounded
                    : Icons.shield_outlined,
                color: preferences.canUseTotp
                    ? const Color(0xFF0F766E)
                    : theme.colorScheme.onSurfaceVariant,
              ),
              title: Text(
                preferences.canUseTotp
                    ? context.l10n.authenticatorAppConfigured
                    : context.l10n.authenticatorAppNotConfigured,
              ),
              subtitle: Text(
                preferences.canUseTotp
                    ? context.l10n.recoveryCodesRemaining(
                        preferences.totpRecoveryCodesRemaining,
                      )
                    : context.l10n.authenticatorAppSetupHint,
              ),
              suffix: preferences.canUseTotp
                  ? Wrap(
                      spacing: 8,
                      children: [
                        AppActionButton(
                          onPressed: _regenerateTotpRecoveryCodes,
                          icon: Icons.refresh_rounded,
                          label: context.l10n.recoveryCodes,
                          style: AppActionButtonStyle.outlined,
                        ),
                        AppIconButton(
                          onPressed: _deleteTotp,
                          icon: Icons.delete_outline_rounded,
                          tooltip: context.l10n.removeAuthenticatorApp,
                          style: AppIconButtonStyle.destructive,
                        ),
                      ],
                    )
                  : AppActionButton(
                      onPressed: _setupTotp,
                      icon: Icons.add_rounded,
                      label: context.l10n.setup,
                      style: AppActionButtonStyle.tonal,
                    ),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (_publicSettings?.enableWebauthn == true) ...[
          _Section(
            title: 'Passkey',
            subtitle: context.l10n.passkeyManagementDescription,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Passkey',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    AppActionButton(
                      onPressed: _passkeyAvailable ? _bindPasskey : null,
                      loading: _bindingPasskey,
                      icon: Icons.add_rounded,
                      label: context.l10n.bind,
                      style: AppActionButtonStyle.tonal,
                    ),
                    const SizedBox(width: 8),
                    AppActionButton(
                      onPressed: () async {
                        final passkeys = await _gateway.listPasskeys();
                        if (mounted) setState(() => _passkeys = passkeys);
                      },
                      icon: Icons.refresh_rounded,
                      label: context.l10n.refresh,
                      style: AppActionButtonStyle.text,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (passkeyError != null)
                  _InlineModuleError(
                    moduleInfo: _moduleInfo[passkeyErrorKey],
                    message: passkeyError,
                    onRetry: () => _load(refresh: true),
                  )
                else if (_passkeys.isEmpty)
                  Text(
                    context.l10n.noPasskeys,
                    style: TextStyle(color: theme.hintColor),
                  )
                else
                  for (final credential in _passkeys)
                    AppTile(
                      contentPadding: EdgeInsets.zero,
                      prefix: const Icon(Icons.fingerprint_rounded),
                      title: Text(
                        credential.name.isEmpty
                            ? context.l10n.unnamedPasskey
                            : credential.name,
                      ),
                      subtitle: Text(
                        [
                          _shortCredentialId(credential.credentialId),
                          context.l10n.createdAtValue(
                            _formatTimestamp(credential.createdAt),
                          ),
                          if (credential.lastUsedAt > 0)
                            context.l10n.lastUsedAt(
                              _formatTimestamp(credential.lastUsedAt),
                            ),
                        ].join(' · '),
                      ),
                      suffix: AppIconButton(
                        onPressed: () => _deletePasskey(credential),
                        icon: Icons.delete_outline_rounded,
                        tooltip: context.l10n.deletePasskey,
                        style: AppIconButtonStyle.destructive,
                      ),
                    ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        _Section(
          title: context.l10n.dangerousActions,
          subtitle: context.l10n.dangerousActionsDescription,
          danger: true,
          child: AppTile(
            contentPadding: EdgeInsets.zero,
            prefix: const Icon(Icons.person_off_rounded, color: Colors.red),
            title: Text(context.l10n.closeAccount),
            subtitle: Text(context.l10n.closeAccountTileDescription),
            suffix: AppActionButton(
              onPressed: _closeAccount,
              icon: Icons.person_remove_rounded,
              label: context.l10n.close,
              style: AppActionButtonStyle.destructive,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsTab(ThemeData theme) {
    final page = _notifications;
    final loadError = _loadError(_moduleNotifications);
    final items = page?.notifications ?? const <UserNotificationItem>[];
    final unreadSelectableIds = items
        .where((item) => !item.isRead && item.numericId > 0)
        .map((item) => item.numericId)
        .toSet();
    final selectedUnreadCount = _selectedNotificationIds
        .where(unreadSelectableIds.contains)
        .length;
    final total = page?.total ?? 0;
    final maxPage = _notificationMaxPage(total);
    final pageStart = total == 0
        ? 0
        : ((_notificationPage - 1) * _notificationPageSize) + 1;
    final pageEnd = total == 0
        ? 0
        : (_notificationPage * _notificationPageSize).clamp(0, total);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    context.l10n.unreadTotalSummary(
                      page?.unreadCount ?? 0,
                      total,
                    ),
                  ),
                  const Spacer(),
                  if (_loadingNotifications)
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: AppLoadingIndicator(
                          size: AppLoadingSize.sm,
                          centered: false,
                        ),
                      ),
                    ),
                  if (_selectedNotificationIds.isNotEmpty) ...[
                    AppActionButton(
                      onPressed: () =>
                          setState(() => _selectedNotificationIds.clear()),
                      icon: Icons.close_rounded,
                      label: context.l10n.selectedCount(
                        _selectedNotificationIds.length,
                      ),
                      style: AppActionButtonStyle.text,
                    ),
                    AppIconButton(
                      onPressed: selectedUnreadCount == 0
                          ? null
                          : _markSelectedRead,
                      icon: Icons.mark_email_read_rounded,
                      tooltip: context.l10n.markSelectedUnreadNotifications,
                    ),
                  ] else
                    AppIconButton(
                      onPressed: unreadSelectableIds.isEmpty
                          ? null
                          : () => setState(() {
                              _selectedNotificationIds
                                ..clear()
                                ..addAll(unreadSelectableIds);
                            }),
                      icon: Icons.select_all_rounded,
                      tooltip: context.l10n.selectCurrentUnreadNotifications,
                    ),
                  AppIconButton(
                    onPressed: items.isEmpty ? null : _markAllRead,
                    icon: Icons.done_all_rounded,
                    tooltip: context.l10n.markAllRead,
                  ),
                  AppIconButton(
                    onPressed: items.isEmpty ? null : _deleteAllRead,
                    icon: Icons.delete_sweep_rounded,
                    tooltip: context.l10n.deleteReadNotifications,
                    style: AppIconButtonStyle.destructive,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AppSearchField(
                controller: _notificationSearchController,
                hintText: context.l10n.searchTitleOrContent,
                onChanged: (value) {
                  if (value.isEmpty) _reloadNotificationsFromFirstPage();
                },
                onSubmitted: (_) => _reloadNotificationsFromFirstPage(),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _NotificationFilterChip(
                    label: context.l10n.all,
                    selected: _notificationReadFilter == null,
                    onSelected: () {
                      setState(() => _notificationReadFilter = null);
                      _reloadNotificationsFromFirstPage();
                    },
                  ),
                  _NotificationFilterChip(
                    label: context.l10n.unread,
                    selected: _notificationReadFilter == false,
                    onSelected: () {
                      setState(() => _notificationReadFilter = false);
                      _reloadNotificationsFromFirstPage();
                    },
                  ),
                  _NotificationFilterChip(
                    label: context.l10n.read,
                    selected: _notificationReadFilter == true,
                    onSelected: () {
                      setState(() => _notificationReadFilter = true);
                      _reloadNotificationsFromFirstPage();
                    },
                  ),
                  AppSelect<client_enum.NotificationType?>(
                    value: _notificationTypeFilter,
                    hintText: context.l10n.notificationType,
                    options: {
                      context.l10n.allTypes: null,
                      context.l10n.roomInvitation: client_enum
                          .NotificationType
                          .NOTIFICATION_TYPE_ROOM_INVITATION,
                      context.l10n.systemAnnouncement: client_enum
                          .NotificationType
                          .NOTIFICATION_TYPE_SYSTEM_ANNOUNCEMENT,
                      context.l10n.roomEvent: client_enum
                          .NotificationType
                          .NOTIFICATION_TYPE_ROOM_EVENT,
                      context.l10n.passwordResetNotification: client_enum
                          .NotificationType
                          .NOTIFICATION_TYPE_PASSWORD_RESET,
                      if (_showEmailBindingControls)
                        context.l10n.emailBinding: client_enum
                            .NotificationType
                            .NOTIFICATION_TYPE_EMAIL_BIND,
                    },
                    onChanged: (value) {
                      setState(() => _notificationTypeFilter = value);
                      _reloadNotificationsFromFirstPage();
                    },
                  ),
                  AppSelect<client_enum.NotificationListSortBy>(
                    value: _notificationSortBy,
                    options: {
                      context.l10n.createdAt: client_enum
                          .NotificationListSortBy
                          .NOTIFICATION_LIST_SORT_BY_CREATED_AT,
                      context.l10n.updatedAt: client_enum
                          .NotificationListSortBy
                          .NOTIFICATION_LIST_SORT_BY_UPDATED_AT,
                      context.l10n.title: client_enum
                          .NotificationListSortBy
                          .NOTIFICATION_LIST_SORT_BY_TITLE,
                    },
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _notificationSortBy = value);
                      _reloadNotificationsFromFirstPage();
                    },
                  ),
                  AppIconButton(
                    onPressed: () {
                      setState(() {
                        _notificationSortDirection =
                            _notificationSortDirection ==
                                client_enum.SortDirection.SORT_DIRECTION_DESC
                            ? client_enum.SortDirection.SORT_DIRECTION_ASC
                            : client_enum.SortDirection.SORT_DIRECTION_DESC;
                      });
                      _reloadNotificationsFromFirstPage();
                    },
                    icon:
                        _notificationSortDirection ==
                            client_enum.SortDirection.SORT_DIRECTION_DESC
                        ? Icons.south_rounded
                        : Icons.north_rounded,
                    tooltip:
                        _notificationSortDirection ==
                            client_enum.SortDirection.SORT_DIRECTION_DESC
                        ? context.l10n.descending
                        : context.l10n.ascending,
                    style: AppIconButtonStyle.outlined,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AppPaginationBar(
                padding: EdgeInsets.zero,
                label: context.l10n.notificationPageRange(
                  _notificationPage,
                  maxPage,
                  pageStart,
                  pageEnd,
                ),
                onPrevious: _loadingNotifications || _notificationPage <= 1
                    ? null
                    : () => _reloadNotifications(page: _notificationPage - 1),
                onNext: _loadingNotifications || _notificationPage >= maxPage
                    ? null
                    : () => _reloadNotifications(page: _notificationPage + 1),
              ),
            ],
          ),
        ),
        Expanded(
          child: loadError != null && page == null
              ? Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: _LoadErrorBanner(
                      title: context.l10n.notificationsTemporarilyUnavailable,
                      moduleInfo: _moduleInfo[_moduleNotifications],
                      message: loadError,
                      onRetry: _reloadNotifications,
                    ),
                  ),
                )
              : items.isEmpty
              ? AppEmptyMessage(message: context.l10n.noNotifications)
              : AppRefreshIndicator(
                  onRefresh: _reloadNotifications,
                  child: AppListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final selected = _selectedNotificationIds.contains(
                        item.numericId,
                      );
                      final selectable = item.numericId > 0;
                      return _Section(
                        child: AppTile(
                          contentPadding: EdgeInsets.zero,
                          selected: selected,
                          onPressed: selected
                              ? () {
                                  if (!selectable) return;
                                  setState(() {
                                    _selectedNotificationIds.remove(
                                      item.numericId,
                                    );
                                  });
                                }
                              : () => _openNotification(item),
                          onLongPress: selectable
                              ? () => setState(() {
                                  if (selected) {
                                    _selectedNotificationIds.remove(
                                      item.numericId,
                                    );
                                  } else {
                                    _selectedNotificationIds.add(
                                      item.numericId,
                                    );
                                  }
                                })
                              : null,
                          prefix: AppCheckbox(
                            value: selected,
                            semanticsLabel: context.l10n.selectNotification,
                            onChanged: selectable
                                ? (value) => setState(() {
                                    if (value) {
                                      _selectedNotificationIds.add(
                                        item.numericId,
                                      );
                                    } else {
                                      _selectedNotificationIds.remove(
                                        item.numericId,
                                      );
                                    }
                                  })
                                : null,
                          ),
                          title: Text(
                            item.title.isEmpty
                                ? _notificationType(item.type)
                                : item.title,
                            style: TextStyle(
                              fontWeight: item.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.content.isNotEmpty) Text(item.content),
                              const SizedBox(height: 4),
                              Text(
                                _formatTimestamp(item.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.hintColor,
                                ),
                              ),
                            ],
                          ),
                          suffix: Wrap(
                            spacing: 2,
                            children: [
                              AppIconButton(
                                onPressed: selected
                                    ? null
                                    : () => _openNotification(item),
                                icon: Icons.open_in_new_rounded,
                                tooltip: context.l10n.viewDetails,
                                size: AppIconButtonSize.sm,
                              ),
                              if (!item.isRead)
                                AppIconButton(
                                  onPressed: selected
                                      ? null
                                      : () => _markRead(item),
                                  icon: Icons.mark_email_read_rounded,
                                  tooltip: context.l10n.markRead,
                                  size: AppIconButtonSize.sm,
                                ),
                              AppIconButton(
                                onPressed: selected
                                    ? null
                                    : () => _deleteNotification(item),
                                icon: Icons.delete_outline_rounded,
                                tooltip: context.l10n.delete,
                                size: AppIconButtonSize.sm,
                                style: AppIconButtonStyle.destructive,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildBindingsTab(ThemeData theme) {
    final browserAvailable = _oauth2Callbacks(context).canCreateSession;
    final nativeAvailable = _nativeAppleSignIn(context).isSupported;
    final bindableProviders = oauth2BindableProviders(_availableOAuth2)
        .where(
          (provider) => isOAuthProviderAvailable(
            provider,
            browserAvailable: browserAvailable,
            nativeAvailable: nativeAvailable,
          ),
        )
        .toList(growable: false);
    final oauth2Available = browserAvailable || nativeAvailable;
    final linkedError = _loadError(_moduleOAuthLinks);
    final providersError = _loadError('OAuth2 Provider');
    final showLinkedOAuth2 = linkedError != null || _linkedOAuth2.isNotEmpty;
    final showBindableOAuth2 =
        providersError != null || bindableProviders.isNotEmpty;
    final showOAuth2Bindings = showLinkedOAuth2 || showBindableOAuth2;
    return AppListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Section(
          title: context.l10n.mediaSourceAccounts,
          subtitle: context.l10n.mediaSourceAccountsDescription,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 640;
              final cards = [
                _MediaProviderBindCard(
                  label: 'AList',
                  description: context.l10n.alistAccountDescription,
                  icon: Icons.cloud_circle_rounded,
                  color: Colors.amber,
                  onTap: () => widget.onOpenProviderBinding('alist'),
                ),
                _MediaProviderBindCard(
                  label: 'Cloudreve',
                  description: context.l10n.cloudreveAccountDescription,
                  icon: Icons.cloud_rounded,
                  color: Colors.teal,
                  onTap: () => widget.onOpenProviderBinding('cloudreve'),
                ),
                _MediaProviderBindCard(
                  label: 'Emby',
                  description: context.l10n.embyAccountDescription,
                  icon: Icons.video_library_rounded,
                  color: Colors.green,
                  onTap: () => widget.onOpenProviderBinding('emby'),
                ),
                if (ProviderDistributionPolicy.current.allowsProvider(
                  'bilibili',
                ))
                  _MediaProviderBindCard(
                    label: 'Bilibili',
                    description: context.l10n.bilibiliAccountDescription,
                    icon: Icons.tv_rounded,
                    color: const Color(0xFFFB7299),
                    onTap: () => widget.onOpenProviderBinding('bilibili'),
                  ),
                if (ProviderDistributionPolicy.current.allowsProvider('twitch'))
                  _MediaProviderBindCard(
                    label: 'Twitch',
                    description: context.l10n.twitchAccountDescription,
                    icon: Icons.live_tv_rounded,
                    color: const Color(0xFF9146FF),
                    onTap: () => widget.onOpenProviderBinding('twitch'),
                  ),
                _MediaProviderBindCard(
                  label: 'FNOS',
                  description: context.l10n.fnosAccountDescription,
                  icon: Icons.storage_rounded,
                  color: const Color(0xFF087F5B),
                  onTap: () => widget.onOpenProviderBinding('fnos'),
                ),
                _MediaProviderBindCard(
                  label: 'QNAP',
                  description: context.l10n.qnapAccountDescription,
                  icon: Icons.storage_rounded,
                  color: const Color(0xFF0076A8),
                  onTap: () => widget.onOpenProviderBinding('qnap'),
                ),
                _MediaProviderBindCard(
                  label: 'Synology DSM',
                  description: context.l10n.synologyAccountDescription,
                  icon: Icons.video_library_rounded,
                  color: const Color(0xFF1578D3),
                  onTap: () => widget.onOpenProviderBinding('synology'),
                ),
                _MediaProviderBindCard(
                  label: 'Nextcloud',
                  description: context.l10n.nextcloudAccountDescription,
                  icon: Icons.cloud_outlined,
                  color: const Color(0xFF0082C9),
                  onTap: () => widget.onOpenProviderBinding('nextcloud'),
                ),
                _MediaProviderBindCard(
                  label: 'Seafile',
                  description: context.l10n.seafileAccountDescription,
                  icon: Icons.cloud_queue_rounded,
                  color: const Color(0xFFED7109),
                  onTap: () => widget.onOpenProviderBinding('seafile'),
                ),
                _MediaProviderBindCard(
                  label: 'TrueNAS',
                  description: context.l10n.truenasAccountDescription,
                  icon: Icons.dns_rounded,
                  color: const Color(0xFF0095D5),
                  onTap: () => widget.onOpenProviderBinding('truenas'),
                ),
                if (ProviderDistributionPolicy.current.allowsProvider(
                  'youtube',
                ))
                  _MediaProviderBindCard(
                    label: 'YouTube',
                    description: context.l10n.youtubeAccountDescription,
                    icon: Icons.smart_display_rounded,
                    color: const Color(0xFFFF0033),
                    onTap: () => widget.onOpenProviderBinding('youtube'),
                  ),
                if (ProviderDistributionPolicy.current.allowsProvider('douyin'))
                  _MediaProviderBindCard(
                    label: 'Douyin',
                    description: context.l10n.douyinAccountDescription,
                    icon: Icons.music_video_rounded,
                    color: const Color(0xFF00AFA7),
                    onTap: () => widget.onOpenProviderBinding('douyin'),
                  ),
                if (ProviderDistributionPolicy.current.allowsProvider('tiktok'))
                  _MediaProviderBindCard(
                    label: 'TikTok',
                    description: context.l10n.tiktokAccountDescription,
                    icon: Icons.music_video_rounded,
                    color: const Color(0xFFFE2C55),
                    onTap: () => widget.onOpenProviderBinding('tiktok'),
                  ),
              ];
              if (compact) {
                return Column(
                  children: [
                    for (final card in cards) ...[
                      card,
                      if (card != cards.last) const SizedBox(height: 10),
                    ],
                  ],
                );
              }
              final cardWidth = (constraints.maxWidth - 20) / 3;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final card in cards)
                    SizedBox(width: cardWidth, child: card),
                ],
              );
            },
          ),
        ),
        if (ProviderDistributionPolicy.current.allowsOAuth2 &&
            showOAuth2Bindings) ...[
          const SizedBox(height: 12),
          if (showLinkedOAuth2) ...[
            _Section(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.linkedOAuth2,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  if (linkedError != null)
                    _InlineModuleError(
                      moduleInfo: _moduleInfo[_moduleOAuthLinks],
                      message: linkedError,
                      onRetry: () => _load(refresh: true),
                    )
                  else
                    for (final account in _linkedOAuth2)
                      AppTile(
                        contentPadding: EdgeInsets.zero,
                        prefix: OAuthProviderIcon(
                          type: account.providerType,
                          name: account.providerInstanceName,
                        ),
                        title: Text(
                          '${account.providerType} / ${account.providerInstanceName}',
                        ),
                        subtitle: Text(
                          [
                            if (account.providerUsername.isNotEmpty)
                              account.providerUsername,
                            if (account.providerUserId.isNotEmpty)
                              account.providerUserId,
                            if (account.providerIssuer.isNotEmpty)
                              account.providerIssuer,
                            _formatTimestamp(account.linkedAt),
                          ].join(' · '),
                        ),
                        suffix: AppIconButton(
                          onPressed: () => _unlinkOAuth2(account),
                          icon: Icons.link_off_rounded,
                          tooltip: context.l10n.unbind,
                          style: AppIconButtonStyle.destructive,
                        ),
                      ),
                ],
              ),
            ),
            if (showBindableOAuth2) const SizedBox(height: 12),
          ],
          if (showBindableOAuth2)
            _Section(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.bindNewAccount,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  if (providersError != null)
                    _InlineModuleError(
                      moduleInfo: _moduleInfo['OAuth2 Provider'],
                      message: providersError,
                      onRetry: () => _load(refresh: true),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final provider in bindableProviders) ...[
                          if (selectOAuth2AuthorizationMode(
                                    provider,
                                    platform: defaultTargetPlatform,
                                    browserAvailable: browserAvailable,
                                    nativeAvailable: nativeAvailable,
                                  ) ==
                                  OAuth2ClientAuthorizationMode.native &&
                              shouldUseAppleSignInButton(
                                provider,
                                defaultTargetPlatform,
                              ))
                            SizedBox(
                              width: 240,
                              child: AppleSignInButton(
                                semanticLabel: context.l10n
                                    .continueWithProvider('Apple'),
                                onPressed: () => _startOAuth2Bind(provider),
                              ),
                            )
                          else
                            AppActionButton(
                              onPressed:
                                  selectOAuth2AuthorizationMode(
                                        provider,
                                        platform: defaultTargetPlatform,
                                        browserAvailable: browserAvailable,
                                        nativeAvailable: nativeAvailable,
                                      ) !=
                                      null
                                  ? () => _startOAuth2Bind(provider)
                                  : null,
                              prefix: OAuthProviderIcon(
                                type: provider.type,
                                name: provider.name,
                              ),
                              label:
                                  '${oauthProviderDisplayName(type: provider.type, name: provider.name)} (${provider.name})',
                              style: AppActionButtonStyle.outlined,
                            ),
                        ],
                      ],
                    ),
                  if (!oauth2Available) ...[
                    const SizedBox(height: 10),
                    Text(
                      context.l10n.oauthAppLinkUnavailable,
                      style: TextStyle(color: theme.hintColor),
                    ),
                  ],
                  if (_bindProvider != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: AppLoadingIndicator(
                            size: AppLoadingSize.sm,
                            centered: false,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            context.l10n.waitingForAuthorizationCallback(
                              _bindProvider!,
                            ),
                            style: TextStyle(color: theme.hintColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AppActionButton(
                        onPressed: () => setState(() {
                          _bindProvider = null;
                          _bindAttempt++;
                        }),
                        icon: Icons.close_rounded,
                        label: context.l10n.cancelBinding,
                        style: AppActionButtonStyle.text,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildQuickProfilePanel(ThemeData theme) {
    return _Section(
      title: context.l10n.profile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(label: context.l10n.username, value: _user.username),
          if (_user.hasEmail)
            _InfoRow(label: context.l10n.email, value: _user.email!),
          _InfoRow(label: context.l10n.role, value: _userRoleLabel(_user.role)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: AppActionButton(
              onPressed: () => _tabController.animateTo(1),
              icon: Icons.person_outline_rounded,
              label: context.l10n.viewProfile,
              style: AppActionButtonStyle.outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSecurityPanel(ThemeData theme) {
    final preferences = _preferences;
    return _Section(
      title: context.l10n.security,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            label: context.l10n.multiFactorAuthentication,
            value: preferences?.twoFactorEnabled == true
                ? context.l10n.enabled
                : context.l10n.disabled,
          ),
          _InfoRow(
            label: context.l10n.availableFactorsLabel,
            value: preferences == null
                ? '-'
                : _factorLabels(preferences).join('、'),
          ),
          if (_publicSettings?.enableWebauthn == true)
            _InfoRow(
              label: 'Passkey',
              value: context.l10n.itemCount(_passkeys.length),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: AppActionButton(
              onPressed: () => _tabController.animateTo(4),
              icon: Icons.security_rounded,
              label: context.l10n.manageSecurity,
              style: AppActionButtonStyle.outlined,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRoomsPanel(ThemeData theme) {
    final rooms = (_myRooms?.rooms ?? const <SyncTvRoom>[]).take(3).toList();
    return _Section(
      title: context.l10n.recentRooms,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (rooms.isEmpty)
            AppEmptyMessage(
              message: context.l10n.noRooms,
              centered: false,
              padding: EdgeInsets.zero,
            )
          else
            for (final room in rooms)
              AppTile(
                contentPadding: EdgeInsets.zero,
                prefix: _RoomCoverThumb(room: room, size: 36),
                title: Text(
                  room.roomName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  [
                    _roomRoleLabel(room.myRole),
                    if (room.creator.trim().isNotEmpty)
                      context.l10n.creatorName(room.creator.trim()),
                  ].join(' · '),
                ),
                onPressed: () => _openRoom(room),
              ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: AppActionButton(
              onPressed: _createRoom,
              icon: Icons.add_rounded,
              label: context.l10n.createRoom,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: AppActionButton(
              onPressed: () => _tabController.animateTo(2),
              icon: Icons.meeting_room_outlined,
              label: context.l10n.manageRooms,
              style: AppActionButtonStyle.outlined,
            ),
          ),
        ],
      ),
    );
  }

  void _setRoomRelationFilter(client_enum.MyRoomRelation relation) {
    setState(() => _roomRelationFilter = relation);
    _reloadRoomsFromFirstPage();
  }

  bool _isMyCreatedRoom(SyncTvRoom room) {
    return room.myRelation ==
            client_enum.MyRoomRelation.MY_ROOM_RELATION_CREATED ||
        room.myRole == common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR ||
        room.creatorId == _user.id;
  }

  bool _canManageRoomFromListEntry(SyncTvRoom room) {
    return _isMyCreatedRoom(room) ||
        room.myRole == common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN ||
        _user.role.hasSystemAdminPrivileges;
  }

  String _userRoleLabel(SyncTvUserRole role) {
    return switch (role) {
      AccountUserRole(value: common_enum.UserRole.USER_ROLE_ROOT) => 'Root',
      AccountUserRole(value: common_enum.UserRole.USER_ROLE_ADMIN) =>
        context.l10n.administrator,
      AccountUserRole(value: common_enum.UserRole.USER_ROLE_USER) =>
        context.l10n.user,
      RoomMembershipRole(value: final value) => _roomRoleLabel(value),
      AccountUserRole() => context.l10n.unknown,
    };
  }

  String _userStatusLabel(common_enum.UserStatus status) {
    return switch (status) {
      common_enum.UserStatus.USER_STATUS_ACTIVE => context.l10n.normal,
      common_enum.UserStatus.USER_STATUS_BANNED => context.l10n.banned,
      _ => context.l10n.unknown,
    };
  }

  String _roomRoleLabel(common_enum.RoomMemberRole role) {
    return switch (role) {
      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR =>
        context.l10n.creator,
      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN =>
        context.l10n.roomAdministrator,
      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER => context.l10n.member,
      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_GUEST => context.l10n.guest,
      _ => context.l10n.unknown,
    };
  }

  String _roomRelationLabel(client_enum.MyRoomRelation relation) {
    return switch (relation) {
      client_enum.MyRoomRelation.MY_ROOM_RELATION_CREATED =>
        context.l10n.createdByMe,
      client_enum.MyRoomRelation.MY_ROOM_RELATION_PARTICIPATING =>
        context.l10n.joinedByMe,
      _ => context.l10n.myRooms,
    };
  }

  List<String> _factorLabels(AccountPreferences preferences) {
    final labels = <String>[];
    if (preferences.canUsePassword) labels.add(context.l10n.password);
    if (preferences.canUsePasskey && _passkeyEnabled) labels.add('Passkey');
    if (preferences.canUseTotp) labels.add(context.l10n.authenticatorApp);
    if (preferences.canUseEmail && _user.hasEmail) {
      labels.add(context.l10n.email);
    }
    if (labels.isEmpty) labels.add(context.l10n.none);
    return labels;
  }

  String _notificationType(client_enum.NotificationType type) {
    return switch (type) {
      client_enum.NotificationType.NOTIFICATION_TYPE_ROOM_INVITATION =>
        context.l10n.roomInvitation,
      client_enum.NotificationType.NOTIFICATION_TYPE_SYSTEM_ANNOUNCEMENT =>
        context.l10n.systemAnnouncement,
      client_enum.NotificationType.NOTIFICATION_TYPE_ROOM_EVENT =>
        context.l10n.roomEvent,
      client_enum.NotificationType.NOTIFICATION_TYPE_PASSWORD_RESET =>
        context.l10n.passwordResetNotification,
      client_enum.NotificationType.NOTIFICATION_TYPE_EMAIL_BIND =>
        context.l10n.emailBinding,
      _ => context.l10n.notifications,
    };
  }

  String _shortCredentialId(String credentialId) {
    if (credentialId.length <= 18) return credentialId;
    return '${credentialId.substring(0, 8)}...${credentialId.substring(credentialId.length - 6)}';
  }

  String _formatTimestamp(int seconds) {
    if (seconds <= 0) return '-';
    return DateFormat(
      'yyyy-MM-dd HH:mm',
    ).format(DateTime.fromMillisecondsSinceEpoch(seconds * 1000));
  }
}
