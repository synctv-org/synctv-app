import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synctv_app/models/account_models.dart';
import 'package:synctv_app/models/public_models.dart';
import 'package:synctv_app/models/realtime_event_log.dart';
import 'package:synctv_app/models/room_realtime_codec.dart';
import 'package:synctv_app/models/synctv_models.dart';
import 'package:synctv_app/pages/mobile/room_settings_page.dart';
import 'package:synctv_app/pages/room_screen.dart';
import 'package:synctv_app/services/oauth2_deep_link_service.dart';
import 'package:synctv_app/services/opaque_authenticator_service.dart';
import 'package:synctv_app/services/passkey_authenticator_service.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/utils/local_image_picker.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';
import 'package:synctv_app/widgets/app_responsive_layout.dart';
import 'package:synctv_app/widgets/create_room_dialog.dart';
import 'package:synctv_app/widgets/platform_binding_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class _AccountSection {
  final String label;
  final IconData icon;

  const _AccountSection({
    required this.label,
    required this.icon,
  });
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

  const AccountCenterPage({super.key, required this.initialUser});

  @override
  State<AccountCenterPage> createState() => _AccountCenterPageState();
}

class _AccountCenterPageState extends State<AccountCenterPage>
    with SingleTickerProviderStateMixin {
  static const int _notificationPageSize = 50;
  static const int _roomsPageSize = 24;
  static const List<_AccountSection> _sections = [
    _AccountSection(label: '概览', icon: Icons.space_dashboard_outlined),
    _AccountSection(label: '资料', icon: Icons.person_outline_rounded),
    _AccountSection(label: '房间', icon: Icons.meeting_room_outlined),
    _AccountSection(label: '安全', icon: Icons.security_rounded),
    _AccountSection(label: '通知', icon: Icons.notifications_none_rounded),
    _AccountSection(label: '绑定', icon: Icons.link_rounded),
  ];
  static const Map<String, _AccountModuleInfo> _moduleInfo = {
    '账号偏好': _AccountModuleInfo(
      label: '账号偏好',
      impact: '多因素认证状态、通知偏好和安全能力判断不可用。',
      icon: Icons.tune_rounded,
    ),
    '通知': _AccountModuleInfo(
      label: '通知中心',
      impact: '未读数量、通知列表、标记已读和删除通知不可用。',
      icon: Icons.notifications_none_rounded,
    ),
    '房间': _AccountModuleInfo(
      label: '我的房间',
      impact: '账号中心内的房间列表、房间搜索和房间管理不可用。',
      icon: Icons.meeting_room_outlined,
    ),
    'OAuth2 Provider': _AccountModuleInfo(
      label: 'OAuth2 可绑定账号',
      impact: '无法展示可绑定的第三方登录 Provider。',
      icon: Icons.add_link_rounded,
    ),
    'OAuth2 绑定': _AccountModuleInfo(
      label: 'OAuth2 已绑定账号',
      impact: '无法查看或解除已经绑定的第三方登录账号。',
      icon: Icons.link_rounded,
    ),
    'Passkey': _AccountModuleInfo(
      label: 'Passkey 凭据',
      impact: '无法查看、绑定或删除服务器上的 Passkey 凭据。',
      icon: Icons.fingerprint_rounded,
    ),
    '本机 Passkey': _AccountModuleInfo(
      label: '本机 Passkey 能力',
      impact: '无法确认当前设备是否支持创建 Passkey。',
      icon: Icons.devices_rounded,
    ),
    '公开设置': _AccountModuleInfo(
      label: '服务器公开设置',
      impact: '无法判断邮箱和 Passkey 当前是否启用。',
      icon: Icons.tune_rounded,
    ),
  };

  late TabController _tabController;
  late SyncTvUser _user;
  AccountPreferences? _preferences;
  UserNotificationsPage? _notifications;
  RoomsPage? _myRooms;
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
  client_enum.MyRoomRelation _roomRelationFilter =
      client_enum.MyRoomRelation.MY_ROOM_RELATION_ALL;
  client_enum.MyRoomListSortBy _roomSortBy =
      client_enum.MyRoomListSortBy.MY_ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT;
  final Set<int> _selectedNotificationIds = <int>{};
  final TextEditingController _notificationSearchController =
      TextEditingController();
  final TextEditingController _roomSearchController = TextEditingController();
  late final OpaqueAuthenticatorService _opaqueAuthenticator;

  bool get _passkeyEnabled =>
      _publicSettings?.enableWebauthn == true && _passkeyAvailable;

  bool get _emailFeatureEnabled => _publicSettings?.enableEmail == true;
  bool get _showEmailBindingControls => _user.hasEmail || _emailFeatureEnabled;

  _EmailStatusView _emailStatusView(ThemeData theme) {
    if (!_user.hasEmail) {
      return _EmailStatusView(
        icon: Icons.alternate_email_rounded,
        label: '未绑定',
        tone: theme.colorScheme.onSurface.withValues(alpha: 0.58),
      );
    }
    return const _EmailStatusView(
      icon: Icons.mark_email_read_rounded,
      label: '已绑定',
      tone: Color(0xFF15803D),
    );
  }

  @override
  void initState() {
    super.initState();
    _user = widget.initialUser;
    _tabController = TabController(length: _sections.length, vsync: this);
    _opaqueAuthenticator = OpaqueAuthenticatorService();
    _load(refresh: false);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notificationSearchController.dispose();
    _roomSearchController.dispose();
    super.dispose();
  }

  Future<void> _load({bool refresh = false}) async {
    setState(() => _loading = true);
    try {
      final errors = <String, String>{};
      final user = await SyncTvService.getMe(refresh: refresh);
      final publicSettings = await _loadOptional(
        errors,
        '公开设置',
        () => SyncTvService.getPublicSettings(refresh: refresh),
      );
      final serverPasskeyEnabled = publicSettings?.enableWebauthn == true;
      final results = await Future.wait<dynamic>([
        _loadOptional(
          errors,
          '账号偏好',
          () => SyncTvService.getAccountPreferences(refresh: refresh),
        ),
        _loadOptional(
          errors,
          '通知',
          () => SyncTvService.listNotifications(
            page: _notificationPage,
            pageSize: _notificationPageSize,
            refresh: refresh,
          ),
        ),
        _loadOptional(
          errors,
          '房间',
          () => SyncTvService.getMyRoomsPage(
            page: _roomsPage,
            pageSize: _roomsPageSize,
            relation: _roomRelationFilter,
            sortBy: _roomSortBy,
          ),
        ),
        _loadOptional(
          errors,
          'OAuth2 Provider',
          SyncTvService.listOAuth2Providers,
        ),
        _loadOptional(
          errors,
          'OAuth2 绑定',
          SyncTvService.getLinkedOAuth2Accounts,
        ),
        if (serverPasskeyEnabled)
          _loadOptional(
            errors,
            'Passkey',
            () => SyncTvService.listPasskeys(refresh: refresh),
          )
        else
          Future<List<PasskeyCredentialInfo>?>.value(const []),
        if (serverPasskeyEnabled)
          _loadOptional(
            errors,
            '本机 Passkey',
            PasskeyAuthenticatorService.isSupported,
          )
        else
          Future<bool?>.value(false),
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
        _loadErrors = Map.unmodifiable(errors);
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      MessageUtils.showError(context, '加载账号信息失败: $e');
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
        title: '修改用户名',
        subtitle: '设置这个服务器上的公开用户名',
        icon: Icons.badge_outlined,
        label: '用户名',
        initialValue: _user.username,
        primaryLabel: '保存',
      ),
    );
    if (next == null || next.isEmpty || next == _user.username) return;

    try {
      final user = await SyncTvService.updateUsername(next);
      if (!mounted) return;
      setState(() => _user = user);
      MessageUtils.showSuccess(context, '用户名已更新');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '更新用户名失败: $e');
    }
  }

  Future<void> _updateAvatar() async {
    if (_updatingAvatar) return;
    try {
      final image = await pickLocalImageUpload(context, aspectRatio: 1);
      if (image == null || !mounted) return;
      setState(() => _updatingAvatar = true);
      final user = await SyncTvService.updateUserAvatar(image.upload);
      if (!mounted) return;
      setState(() => _user = user);
      MessageUtils.showSuccess(context, '头像已更新');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '更新头像失败: $e');
    } finally {
      if (mounted) setState(() => _updatingAvatar = false);
    }
  }

  Future<void> _clearAvatar() async {
    if (_updatingAvatar || _user.avatarUrl.isEmpty) return;
    try {
      setState(() => _updatingAvatar = true);
      final user = await SyncTvService.clearUserAvatar();
      if (!mounted) return;
      setState(() => _user = user);
      MessageUtils.showSuccess(context, '头像已移除');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '移除头像失败: $e');
    } finally {
      if (mounted) setState(() => _updatingAvatar = false);
    }
  }

  Future<void> _updateNotifications(NotificationPreferences preferences) async {
    setState(() => _savingPreferences = true);
    try {
      final updated = await SyncTvService.updateAccountPreferences(
        notifications: preferences,
      );
      if (!mounted) return;
      setState(() => _preferences = updated);
      MessageUtils.showSuccess(context, '通知偏好已保存');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '保存通知偏好失败: $e');
    } finally {
      if (mounted) setState(() => _savingPreferences = false);
    }
  }

  Future<void> _toggleTwoFactor(bool value) async {
    setState(() => _savingPreferences = true);
    try {
      final updated = await SyncTvService.updateAccountPreferences(
        twoFactorEnabled: value,
      );
      if (!mounted) return;
      setState(() => _preferences = updated);
      MessageUtils.showSuccess(context, '多因素认证设置已保存');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '保存多因素认证设置失败: $e');
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
        title: '解绑邮箱',
        content: const Text('解绑后将无法继续使用这个邮箱接收验证码、邮件通知或密码重置邮件。'),
        confirmLabel: '解绑',
        confirmIcon: Icons.link_off_rounded,
        destructive: true,
        onConfirm: () => Navigator.pop(context, true),
      ),
    );
    if (confirmed != true) return;

    try {
      final verificationId = await _verifySensitiveOperation();
      if (verificationId == null) return;
      final user = await SyncTvService.unbindEmail(
        verificationId: verificationId,
      );
      final preferences =
          await SyncTvService.getAccountPreferences(refresh: true);
      if (!mounted) return;
      setState(() {
        _user = user;
        _preferences = preferences;
        if (_notificationTypeFilter ==
            client_enum.NotificationType.NOTIFICATION_TYPE_EMAIL_BIND) {
          _notificationTypeFilter = null;
        }
      });
      MessageUtils.showSuccess(context, '邮箱已解绑');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '解绑邮箱失败: $e');
    }
  }

  Future<void> _bindEmail() async {
    if (!_emailFeatureEnabled) return;
    final user = await showAppDialog<SyncTvUser>(
      context: context,
      builder: (context) => _EmailBindDialog(
        verifySensitiveOperation: _verifySensitiveOperation,
      ),
    );
    if (user == null || !mounted) return;
    final preferences = await SyncTvService.getAccountPreferences();
    if (!mounted) return;
    setState(() {
      _user = user;
      _preferences = preferences;
    });
    MessageUtils.showSuccess(context, '邮箱已绑定');
  }

  Future<String?> _verifySensitiveOperation() {
    return showAppDialog<String>(
      context: context,
      builder: (context) => const _SensitiveOperationDialog(),
    );
  }

  Future<void> _changePassword() async {
    final preferences = _preferences;
    final canUseCurrentPassword = preferences?.canUsePassword == true;
    final canUseEmail = preferences?.canUseEmail == true && _user.hasEmail;
    final canUsePasskey = preferences?.canUsePasskey == true && _passkeyEnabled;
    if (!canUseCurrentPassword && !canUseEmail && !canUsePasskey) {
      MessageUtils.showWarning(context, '当前账号没有可用的密码验证方式');
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
      final updatedPreferences = await SyncTvService.getAccountPreferences();
      if (!mounted) return;
      setState(() {
        _user = user;
        _preferences = updatedPreferences;
      });
      MessageUtils.showSuccess(context, '密码已更新');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '更新密码失败: $e');
    }
  }

  Future<void> _resetPasswordByEmail() async {
    final email = _user.email;
    if (email == null || email.isEmpty) {
      MessageUtils.showWarning(context, '当前账号没有邮箱');
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
      if (mounted) MessageUtils.showSuccess(context, '密码已重置');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '重置密码失败: $e');
    }
  }

  Future<void> _deletePasskey(PasskeyCredentialInfo credential) async {
    final label =
        credential.name.isEmpty ? credential.credentialId : credential.name;
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '删除 Passkey',
      icon: const Icon(Icons.fingerprint_rounded),
      iconColor: Theme.of(context).colorScheme.error,
      content: Text(
        '确定删除「$label」吗？删除后这台设备将不能继续使用该 Passkey 登录。',
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        AppActionButton(
          onPressed: () => Navigator.pop(context, true),
          icon: Icons.delete_outline_rounded,
          label: '删除',
          style: AppActionButtonStyle.destructive,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      await SyncTvService.deletePasskey(credential.credentialId);
      final passkeys = await SyncTvService.listPasskeys(refresh: true);
      final preferences =
          await SyncTvService.getAccountPreferences(refresh: true);
      if (!mounted) return;
      setState(() {
        _passkeys = passkeys;
        _preferences = preferences;
      });
      MessageUtils.showSuccess(context, 'Passkey 已删除');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '删除 Passkey 失败: $e');
    }
  }

  Future<void> _bindPasskey() async {
    final name = await showAppDialog<String>(
      context: context,
      builder: (_) => const _SingleTextInputDialog(
        title: '绑定 Passkey',
        subtitle: '为当前设备创建一个可识别的名称',
        icon: Icons.fingerprint_rounded,
        label: '设备名称',
        hintText: '例如 MacBook、手机',
        primaryLabel: '继续',
      ),
    );
    if (name == null) return;

    setState(() => _bindingPasskey = true);
    try {
      final start = await SyncTvService.startPasskeyBind(name: name);
      final credential = await PasskeyAuthenticatorService.createCredential(
        start.options,
      );
      await SyncTvService.finishPasskeyBind(
        sessionId: start.sessionId,
        credential: credential,
      );
      if (!mounted) return;
      final passkeys = await SyncTvService.listPasskeys();
      final preferences = await SyncTvService.getAccountPreferences();
      if (!mounted) return;
      setState(() {
        _passkeys = passkeys;
        _preferences = preferences;
      });
      MessageUtils.showSuccess(context, 'Passkey 已绑定');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '绑定 Passkey 失败: $e');
    } finally {
      if (mounted) setState(() => _bindingPasskey = false);
    }
  }

  Future<void> _markAllRead() async {
    try {
      await SyncTvService.markAllNotificationsAsRead();
      await _reloadNotifications(refresh: true);
      if (mounted) MessageUtils.showSuccess(context, '已全部标记为已读');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '操作失败: $e');
    }
  }

  Future<void> _markSelectedRead() async {
    final ids = _selectedNotificationIds.toList(growable: false);
    if (ids.isEmpty) return;

    try {
      await SyncTvService.markNotificationsAsRead(ids);
      if (!mounted) return;
      setState(() => _selectedNotificationIds.clear());
      await _reloadNotifications(refresh: true);
      if (mounted) MessageUtils.showSuccess(context, '已标记所选通知');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '标记失败: $e');
    }
  }

  Future<void> _deleteAllRead() async {
    try {
      await SyncTvService.deleteAllReadNotifications();
      await _reloadNotifications(refresh: true);
      if (mounted) MessageUtils.showSuccess(context, '已删除已读通知');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '删除失败: $e');
    }
  }

  Future<void> _markRead(UserNotificationItem item) async {
    try {
      await SyncTvService.markNotificationAsRead(item);
      if (mounted) {
        setState(() => _selectedNotificationIds.remove(item.numericId));
      }
      await _reloadNotifications(refresh: true);
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '标记失败: $e');
    }
  }

  Future<void> _deleteNotification(UserNotificationItem item) async {
    try {
      await SyncTvService.deleteNotification(item);
      if (mounted) {
        setState(() => _selectedNotificationIds.remove(item.numericId));
      }
      await _reloadNotifications(refresh: true);
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '删除失败: $e');
    }
  }

  Future<void> _openNotification(UserNotificationItem item) async {
    UserNotificationItem detail = item;
    try {
      detail = await SyncTvService.getNotification(item.numericId);
    } catch (e) {
      if (mounted) {
        MessageUtils.showWarning(context, '加载通知详情失败，显示列表内容: $e');
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

  Future<void> _reloadNotifications({
    int? page,
    bool refresh = true,
  }) async {
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
        _clearLoadError('通知');
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
        _setLoadError('通知', e);
      });
      MessageUtils.showError(context, '加载通知失败: $e');
    }
  }

  Future<UserNotificationsPage> _fetchNotificationsPage(
    int page, {
    bool refresh = false,
  }) {
    return SyncTvService.listNotifications(
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
    try {
      final verificationId = await _verifySensitiveOperation();
      if (verificationId == null) return;
      final callbackSession = await OAuth2DeepLinkService.createSession();
      final start = await SyncTvService.startOAuth2Bind(
        provider.name,
        redirectUrl: callbackSession.redirectUrl,
        verificationId: verificationId,
      );
      try {
        if (!mounted) return;
        setState(() {
          _bindProvider = provider.name;
          _bindAttempt++;
        });
        final attempt = _bindAttempt;
        final uri = Uri.parse(start.authorizationUrl);
        final opened =
            await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (!opened && mounted) {
          MessageUtils.showError(context, '无法打开授权链接');
          return;
        } else if (mounted) {
          MessageUtils.showInfo(context, '请在浏览器完成授权');
        }
        final parsed = await callbackSession.waitForCallback(
          expectedState: start.state,
        );
        if (!mounted || attempt != _bindAttempt) return;
        await SyncTvService.finishOAuth2Bind(
          provider: provider.name,
          code: parsed.code,
          state: parsed.state,
        );
        final linked = await SyncTvService.getLinkedOAuth2Accounts();
        if (!mounted) return;
        setState(() {
          _linkedOAuth2 = linked;
          _clearLoadError('OAuth2 绑定');
          _bindProvider = null;
        });
        MessageUtils.showSuccess(context, 'OAuth2 账号已绑定');
      } finally {
        await callbackSession.close();
      }
    } catch (e) {
      if (mounted) MessageUtils.showError(context, 'OAuth2 绑定失败: $e');
    }
  }

  Future<void> _unlinkOAuth2(OAuth2LinkedAccount account) async {
    try {
      final verificationId = await _verifySensitiveOperation();
      if (verificationId == null) return;
      await SyncTvService.unlinkOAuth2Account(
        account,
        verificationId: verificationId,
      );
      final linked = await SyncTvService.getLinkedOAuth2Accounts();
      if (!mounted) return;
      setState(() {
        _linkedOAuth2 = linked;
        _clearLoadError('OAuth2 绑定');
      });
      MessageUtils.showSuccess(context, '已解除绑定');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '解绑失败: $e');
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
        _clearLoadError('房间');
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingRooms = false;
        _setLoadError('房间', e);
      });
      MessageUtils.showError(context, '加载我的房间失败: $e');
    }
  }

  String? _loadError(String label) => _loadErrors[label];

  void _setLoadError(String label, Object error) {
    _loadErrors = Map.unmodifiable({
      ..._loadErrors,
      label: error.toString(),
    });
  }

  void _clearLoadError(String label) {
    if (!_loadErrors.containsKey(label)) return;
    final next = Map<String, String>.from(_loadErrors)..remove(label);
    _loadErrors = Map.unmodifiable(next);
  }

  Future<RoomsPage> _fetchRoomsPage(int page, {bool refresh = false}) {
    return SyncTvService.getMyRoomsPage(
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
      final latest = await SyncTvService.getRoomInfo(room.roomId);
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RoomScreen(room: latest),
        ),
      );
      if (mounted) await _reloadRooms();
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '打开房间失败: $e');
    }
  }

  Future<void> _createRoom() async {
    await showCreateRoomDialog(
      context: context,
      onCreated: (room) async {
        await _reloadRooms(page: 1, refresh: true);
        if (!mounted) return;
        await _openRoom(room);
      },
    );
  }

  Future<void> _manageRoom(SyncTvRoom room) async {
    try {
      final settings = await SyncTvService.getRoomSettings(room.roomId);
      if (!mounted) return;
      await Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => RoomSettingsPage(
            roomId: room.roomId,
            roomName: room.roomName,
            creatorId: room.creatorId,
            currentUserId: _user.id,
            currentSettings: settings,
            realtime: RoomRealtimeSession(
              send: (_) {},
              messages: const Stream<RoomRealtimeMessage>.empty(),
              events: const Stream<RealtimeEventLogEntry>.empty(),
              reconnects: const Stream<void>.empty(),
            ),
          ),
        ),
      );
      if (mounted) await _reloadRooms(refresh: true);
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '打开房间管理失败: $e');
    }
  }

  Future<void> _leaveOrDeleteRoom(SyncTvRoom room) async {
    final isOwner = _isMyCreatedRoom(room);
    final actionText = isOwner ? '删除房间' : '退出房间';
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: actionText,
      icon: Icon(isOwner ? Icons.delete_forever_rounded : Icons.logout),
      iconColor: isOwner
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.primary,
      content: Text(
        isOwner
            ? '这会永久删除「${room.roomName}」及其房间数据，所有成员都会失去访问权限。'
            : '确定退出「${room.roomName}」吗？退出后需要重新加入才能访问。',
      ),
      actions: [
        ChatUtils.createCancelButton(context),
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
        await SyncTvService.deleteRoom(room.roomId);
      } else {
        await SyncTvService.leaveRoom(room.roomId);
      }
      await _reloadRooms();
      if (mounted) MessageUtils.showSuccess(context, '$actionText 已完成');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '$actionText 失败: $e');
    }
  }

  Future<void> _closeAccount() async {
    const confirmationText = '关闭账户';
    final controller = TextEditingController();
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '关闭账户',
      icon: const Icon(Icons.warning_amber_rounded),
      iconColor: Theme.of(context).colorScheme.error,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '此操作会永久关闭当前账户及相关个人数据。',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: controller,
            label: '输入 关闭账户 确认',
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
        ChatUtils.createCancelButton(context),
        AppActionButton(
          onPressed: () => Navigator.pop(
            context,
            controller.text.trim() == confirmationText,
          ),
          icon: Icons.delete_forever_rounded,
          label: '关闭账户',
          style: AppActionButtonStyle.destructive,
        ),
      ],
    );
    _disposeTextControllersAfterDialog([controller]);
    if (confirmed != true) {
      if (confirmed == false && mounted) {
        MessageUtils.showWarning(context, '确认文本不匹配');
      }
      return;
    }

    try {
      await SyncTvService.closeAccount();
      if (!mounted) return;
      MessageUtils.showSuccess(context, '账户已关闭');
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '关闭账户失败: $e');
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
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF4F6FA),
      appBar: AppAppBar(
        title: const Text(
          '账号中心',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
        actions: [
          AppIconButton(
            onPressed: () => _load(refresh: true),
            icon: Icons.refresh_rounded,
            tooltip: '刷新',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final useRail = constraints.maxWidth >= 900;
          final content =
              _loading ? const AppLoadingIndicator() : _buildTabView(theme);

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
                            _user.username.isEmpty ? '当前账号' : _user.username,
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
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.58),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: AppListView.separated(
                        itemCount: _sections.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 4),
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
            unselectedLabelColor:
                theme.colorScheme.onSurface.withValues(alpha: 0.62),
            labelStyle: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            tabs: _sections
                .map((section) => Tab(
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
                    ))
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
          ].where((value) => value).length;

    return _responsiveList(
      children: [
        _AccountHero(
          user: _user,
          roleLabel: _userRoleLabel(_user.role),
          statusLabel: _userStatusLabel(_user.status),
          activeServerName: SyncTvService.activeServer?.name ?? '未连接服务器',
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
                label: '我的房间',
                value: '$roomCount',
                tone: theme.colorScheme.primary,
              ),
              _MetricTile(
                icon: Icons.notifications_none_rounded,
                label: '未读通知',
                value: '$unread',
                tone: const Color(0xFF0F766E),
              ),
              _MetricTile(
                icon: Icons.security_rounded,
                label: '登录因素',
                value: '$activeFactors',
                tone: const Color(0xFFB45309),
              ),
              if (_showEmailBindingControls)
                _MetricTile(
                  icon: emailStatus.icon,
                  label: '邮箱状态',
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
        const _SectionHeader(
          title: '个人资料',
          subtitle: '管理这个服务器上的公开身份和账号状态',
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
                          label: '邮箱${emailStatus.label}',
                          color: emailStatus.tone,
                        ),
                      if (_user.isBanned)
                        const _StatusPill(
                          icon: Icons.block_rounded,
                          label: '已封禁',
                          danger: true,
                        ),
                    ],
                  ),
                  if (_showEmailBindingControls) ...[
                    const SizedBox(height: 12),
                    Text(
                      _user.hasEmail ? _user.email! : '未绑定邮箱',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ],
              );
              final action = AppActionButton(
                onPressed: _rename,
                icon: Icons.edit_rounded,
                label: '修改用户名',
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
          title: '账号信息',
          child: _InfoGrid(
            entries: [
              _InfoEntry('用户 ID', _user.id),
              _InfoEntry('账号状态', _userStatusLabel(_user.status)),
              _InfoEntry('创建时间', _formatTimestamp(_user.createdAt)),
              _InfoEntry('更新时间', _formatTimestamp(_user.updatedAt)),
              _InfoEntry('在线连接', '${_user.onlineCount}'),
              if (_user.isBanned) _InfoEntry('封禁原因', _user.bannedReason),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (preferences != null)
          _Section(
            title: '通知偏好',
            subtitle: '按场景控制站内通知和邮件通知',
            child: AppResponsiveWrap(
              minItemWidth: 320,
              maxColumns: 2,
              runSpacing: 4,
              children: [
                _PreferenceSwitch(
                  title: '房间邀请站内通知',
                  value: notifications.roomInvitationInApp,
                  onChanged: _savingPreferences
                      ? null
                      : (value) => _updateNotifications(
                            notifications.copyWith(
                              roomInvitationInApp: value,
                            ),
                          ),
                ),
                _PreferenceSwitch(
                  title: '房间事件站内通知',
                  value: notifications.roomEventInApp,
                  onChanged: _savingPreferences
                      ? null
                      : (value) => _updateNotifications(
                            notifications.copyWith(roomEventInApp: value),
                          ),
                ),
                _PreferenceSwitch(
                  title: '系统公告站内通知',
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
                    title: '房间邀请邮件通知',
                    value: notifications.roomInvitationEmail,
                    onChanged: _savingPreferences
                        ? null
                        : (value) => _updateNotifications(
                              notifications.copyWith(
                                roomInvitationEmail: value,
                              ),
                            ),
                  ),
                if (_user.hasEmail && _emailFeatureEnabled)
                  _PreferenceSwitch(
                    title: '房间事件邮件通知',
                    value: notifications.roomEventEmail,
                    onChanged: _savingPreferences
                        ? null
                        : (value) => _updateNotifications(
                              notifications.copyWith(roomEventEmail: value),
                            ),
                  ),
                if (_user.hasEmail && _emailFeatureEnabled)
                  _PreferenceSwitch(
                    title: '系统公告邮件通知',
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
        else if (_loadError('账号偏好') != null)
          _LoadErrorBanner(
            title: '通知偏好不可用',
            moduleInfo: _moduleInfo['账号偏好'],
            message: _loadError('账号偏好')!,
            onRetry: () => _load(refresh: true),
          ),
      ],
    );
  }

  Widget _buildRoomsTab(ThemeData theme) {
    final page = _myRooms;
    final loadError = _loadError('房间');
    final rooms = page?.rooms ?? const <SyncTvRoom>[];
    final total = page?.total ?? 0;
    final maxPage = _roomsMaxPage(total);
    final pageStart = total == 0 ? 0 : ((_roomsPage - 1) * _roomsPageSize) + 1;
    final pageEnd =
        total == 0 ? 0 : (_roomsPage * _roomsPageSize).clamp(0, total);

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
                      const Expanded(
                        child: _SectionHeader(
                          title: '我的房间',
                          subtitle: '管理你创建、加入或被授权的同步观影空间',
                          icon: Icons.meeting_room_outlined,
                          dense: true,
                        ),
                      ),
                      AppActionButton(
                        onPressed: _createRoom,
                        icon: Icons.add_rounded,
                        label: '创建房间',
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
                        hintText: '搜索房间名称或描述',
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
                            label: '全部',
                            value:
                                client_enum.MyRoomRelation.MY_ROOM_RELATION_ALL,
                            groupValue: _roomRelationFilter,
                            onSelected: _setRoomRelationFilter,
                          ),
                          _RelationChip(
                            label: '我创建的',
                            value: client_enum
                                .MyRoomRelation.MY_ROOM_RELATION_CREATED,
                            groupValue: _roomRelationFilter,
                            onSelected: _setRoomRelationFilter,
                          ),
                          _RelationChip(
                            label: '我加入的',
                            value: client_enum
                                .MyRoomRelation.MY_ROOM_RELATION_PARTICIPATING,
                            groupValue: _roomRelationFilter,
                            onSelected: _setRoomRelationFilter,
                          ),
                          AppSelect<client_enum.MyRoomListSortBy>(
                            value: _roomSortBy,
                            options: const {
                              '最近活跃': client_enum.MyRoomListSortBy
                                  .MY_ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
                              '更新时间': client_enum.MyRoomListSortBy
                                  .MY_ROOM_LIST_SORT_BY_UPDATED_AT,
                              '创建时间': client_enum.MyRoomListSortBy
                                  .MY_ROOM_LIST_SORT_BY_CREATED_AT,
                              '名称': client_enum
                                  .MyRoomListSortBy.MY_ROOM_LIST_SORT_BY_NAME,
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
                            tooltip: '刷新房间',
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
                    label:
                        '第 $_roomsPage / $maxPage 页 · $pageStart-$pageEnd / $total',
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
                      title: '我的房间暂时不可用',
                      moduleInfo: _moduleInfo['房间'],
                      message: loadError,
                      onRetry: _reloadRooms,
                    ),
                  ),
                )
              : rooms.isEmpty
                  ? const AppEmptyMessage(message: '没有匹配的房间')
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
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final room = rooms[index];
                              return Center(
                                child: ConstrainedBox(
                                  constraints:
                                      BoxConstraints(maxWidth: maxWidth),
                                  child: _RoomManagementTile(
                                    room: room,
                                    roleLabel: _roomRoleLabel(room.myRole),
                                    relationLabel:
                                        _roomRelationLabel(room.myRelation),
                                    updatedAtLabel:
                                        _formatTimestamp(room.updatedAt),
                                    isOwner: _isMyCreatedRoom(room),
                                    canManage:
                                        _canManageRoomFromListEntry(room),
                                    onOpen: () => _openRoom(room),
                                    onManage: () => _manageRoom(room),
                                    onLeaveOrDelete: () =>
                                        _leaveOrDeleteRoom(room),
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

  Widget _buildSecurityTab(ThemeData theme) {
    final preferences = _preferences;
    final emailStatus = _emailStatusView(theme);
    final preferencesError = _loadError('账号偏好');
    final passkeyErrorKey =
        _loadError('Passkey') != null ? 'Passkey' : '本机 Passkey';
    final passkeyError = _loadError(passkeyErrorKey);
    return _responsiveList(
      children: [
        const _SectionHeader(
          title: '账号安全',
          subtitle: '管理登录因素、设备凭据和高风险账号操作',
          icon: Icons.security_rounded,
        ),
        const SizedBox(height: 12),
        if (preferences != null)
          _Section(
            title: '登录保护',
            subtitle: '多因素认证会在密码之外要求额外验证因素',
            child: Column(
              children: [
                AppSwitchTile(
                  value: preferences.twoFactorEnabled,
                  onChanged: _savingPreferences
                      ? null
                      : (value) => _toggleTwoFactor(value),
                  title: const Text('多因素认证'),
                  subtitle: Text(
                    '可用因素：${_factorLabels(preferences).join('、')}',
                  ),
                ),
                if (_showEmailBindingControls) ...[
                  const AppDivider(height: 1),
                  AppTile(
                    contentPadding: EdgeInsets.zero,
                    prefix: Icon(emailStatus.icon, color: emailStatus.tone),
                    title: const Text('邮箱'),
                    subtitle: Text(
                      _user.hasEmail ? _user.email! : '绑定邮箱后可接收验证码、通知和密码重置邮件',
                    ),
                    suffix: _user.hasEmail
                        ? AppActionButton(
                            onPressed: _unbindEmail,
                            icon: Icons.link_off_rounded,
                            label: '解绑',
                            style: AppActionButtonStyle.outlined,
                          )
                        : AppActionButton(
                            onPressed: _emailFeatureEnabled ? _bindEmail : null,
                            icon: Icons.add_link_rounded,
                            label: '绑定',
                            style: AppActionButtonStyle.tonal,
                          ),
                  ),
                ],
                const AppDivider(height: 1),
                AppTile(
                  contentPadding: EdgeInsets.zero,
                  prefix: const Icon(Icons.password_rounded),
                  title: const Text('登录密码'),
                  subtitle: const Text('通过 OPAQUE 协议更新账号密码'),
                  suffix: Wrap(
                    spacing: 8,
                    children: [
                      if (_user.hasEmail && _emailFeatureEnabled)
                        AppActionButton(
                          onPressed: _resetPasswordByEmail,
                          label: '邮件重置',
                          style: AppActionButtonStyle.outlined,
                        ),
                      AppActionButton(
                        onPressed: _changePassword,
                        label: '修改',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else if (preferencesError != null)
          _LoadErrorBanner(
            title: '登录保护信息不可用',
            moduleInfo: _moduleInfo['账号偏好'],
            message: preferencesError,
            onRetry: () => _load(refresh: true),
          ),
        const SizedBox(height: 12),
        if (_publicSettings?.enableWebauthn == true) ...[
          _Section(
            title: 'Passkey',
            subtitle: '使用系统凭据管理器完成无密码或多因素验证',
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
                      label: '绑定',
                      style: AppActionButtonStyle.tonal,
                    ),
                    const SizedBox(width: 8),
                    AppActionButton(
                      onPressed: () async {
                        final passkeys = await SyncTvService.listPasskeys();
                        if (mounted) setState(() => _passkeys = passkeys);
                      },
                      icon: Icons.refresh_rounded,
                      label: '刷新',
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
                  Text('暂无 Passkey', style: TextStyle(color: theme.hintColor))
                else
                  for (final credential in _passkeys)
                    AppTile(
                      contentPadding: EdgeInsets.zero,
                      prefix: const Icon(Icons.fingerprint_rounded),
                      title: Text(
                        credential.name.isEmpty
                            ? '未命名 Passkey'
                            : credential.name,
                      ),
                      subtitle: Text(
                        [
                          _shortCredentialId(credential.credentialId),
                          '创建 ${_formatTimestamp(credential.createdAt)}',
                          if (credential.lastUsedAt > 0)
                            '最近使用 ${_formatTimestamp(credential.lastUsedAt)}',
                        ].join(' · '),
                      ),
                      suffix: AppIconButton(
                        onPressed: () => _deletePasskey(credential),
                        icon: Icons.delete_outline_rounded,
                        tooltip: '删除 Passkey',
                        style: AppIconButtonStyle.destructive,
                      ),
                    ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        _Section(
          title: '危险操作',
          subtitle: '这些操作会影响账号可用性或永久删除数据',
          danger: true,
          child: AppTile(
            contentPadding: EdgeInsets.zero,
            prefix: const Icon(
              Icons.person_off_rounded,
              color: Colors.red,
            ),
            title: const Text('关闭账户'),
            subtitle: const Text('永久关闭当前账户，并清除本机登录状态'),
            suffix: AppActionButton(
              onPressed: _closeAccount,
              icon: Icons.person_remove_rounded,
              label: '关闭',
              style: AppActionButtonStyle.destructive,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsTab(ThemeData theme) {
    final page = _notifications;
    final loadError = _loadError('通知');
    final items = page?.notifications ?? const <UserNotificationItem>[];
    final unreadSelectableIds = items
        .where((item) => !item.isRead && item.numericId > 0)
        .map((item) => item.numericId)
        .toSet();
    final selectedUnreadCount =
        _selectedNotificationIds.where(unreadSelectableIds.contains).length;
    final total = page?.total ?? 0;
    final maxPage = _notificationMaxPage(total);
    final pageStart =
        total == 0 ? 0 : ((_notificationPage - 1) * _notificationPageSize) + 1;
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
                  Text('未读 ${page?.unreadCount ?? 0} / 总计 $total'),
                  const Spacer(),
                  if (_loadingNotifications)
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: AppLoadingIndicator(
                            size: AppLoadingSize.sm, centered: false),
                      ),
                    ),
                  if (_selectedNotificationIds.isNotEmpty) ...[
                    AppActionButton(
                      onPressed: () =>
                          setState(() => _selectedNotificationIds.clear()),
                      icon: Icons.close_rounded,
                      label: '已选 ${_selectedNotificationIds.length}',
                      style: AppActionButtonStyle.text,
                    ),
                    AppIconButton(
                      onPressed:
                          selectedUnreadCount == 0 ? null : _markSelectedRead,
                      icon: Icons.mark_email_read_rounded,
                      tooltip: '标记所选未读通知',
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
                      tooltip: '选择当前未读通知',
                    ),
                  AppIconButton(
                    onPressed: items.isEmpty ? null : _markAllRead,
                    icon: Icons.done_all_rounded,
                    tooltip: '全部标记为已读',
                  ),
                  AppIconButton(
                    onPressed: items.isEmpty ? null : _deleteAllRead,
                    icon: Icons.delete_sweep_rounded,
                    tooltip: '删除已读通知',
                    style: AppIconButtonStyle.destructive,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AppSearchField(
                controller: _notificationSearchController,
                hintText: '搜索标题或内容',
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
                    label: '全部',
                    selected: _notificationReadFilter == null,
                    onSelected: () {
                      setState(() => _notificationReadFilter = null);
                      _reloadNotificationsFromFirstPage();
                    },
                  ),
                  _NotificationFilterChip(
                    label: '未读',
                    selected: _notificationReadFilter == false,
                    onSelected: () {
                      setState(() => _notificationReadFilter = false);
                      _reloadNotificationsFromFirstPage();
                    },
                  ),
                  _NotificationFilterChip(
                    label: '已读',
                    selected: _notificationReadFilter == true,
                    onSelected: () {
                      setState(() => _notificationReadFilter = true);
                      _reloadNotificationsFromFirstPage();
                    },
                  ),
                  AppSelect<client_enum.NotificationType?>(
                    value: _notificationTypeFilter,
                    hintText: '通知类型',
                    options: {
                      '全部类型': null,
                      '房间邀请': client_enum
                          .NotificationType.NOTIFICATION_TYPE_ROOM_INVITATION,
                      '系统公告': client_enum.NotificationType
                          .NOTIFICATION_TYPE_SYSTEM_ANNOUNCEMENT,
                      '房间事件': client_enum
                          .NotificationType.NOTIFICATION_TYPE_ROOM_EVENT,
                      '密码重置': client_enum
                          .NotificationType.NOTIFICATION_TYPE_PASSWORD_RESET,
                      if (_showEmailBindingControls)
                        '邮箱绑定': client_enum
                            .NotificationType.NOTIFICATION_TYPE_EMAIL_BIND,
                    },
                    onChanged: (value) {
                      setState(() => _notificationTypeFilter = value);
                      _reloadNotificationsFromFirstPage();
                    },
                  ),
                  AppSelect<client_enum.NotificationListSortBy>(
                    value: _notificationSortBy,
                    options: const {
                      '创建时间': client_enum.NotificationListSortBy
                          .NOTIFICATION_LIST_SORT_BY_CREATED_AT,
                      '更新时间': client_enum.NotificationListSortBy
                          .NOTIFICATION_LIST_SORT_BY_UPDATED_AT,
                      '标题': client_enum.NotificationListSortBy
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
                                    client_enum
                                        .SortDirection.SORT_DIRECTION_DESC
                                ? client_enum.SortDirection.SORT_DIRECTION_ASC
                                : client_enum.SortDirection.SORT_DIRECTION_DESC;
                      });
                      _reloadNotificationsFromFirstPage();
                    },
                    icon: _notificationSortDirection ==
                            client_enum.SortDirection.SORT_DIRECTION_DESC
                        ? Icons.south_rounded
                        : Icons.north_rounded,
                    tooltip: _notificationSortDirection ==
                            client_enum.SortDirection.SORT_DIRECTION_DESC
                        ? '降序'
                        : '升序',
                    style: AppIconButtonStyle.outlined,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AppPaginationBar(
                padding: EdgeInsets.zero,
                label:
                    '第 $_notificationPage / $maxPage 页 · $pageStart-$pageEnd',
                onPrevious: _loadingNotifications || _notificationPage <= 1
                    ? null
                    : () => _reloadNotifications(
                          page: _notificationPage - 1,
                        ),
                onNext: _loadingNotifications || _notificationPage >= maxPage
                    ? null
                    : () => _reloadNotifications(
                          page: _notificationPage + 1,
                        ),
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
                      title: '通知暂时不可用',
                      moduleInfo: _moduleInfo['通知'],
                      message: loadError,
                      onRetry: _reloadNotifications,
                    ),
                  ),
                )
              : items.isEmpty
                  ? const AppEmptyMessage(message: '暂无通知')
                  : AppRefreshIndicator(
                      onRefresh: _reloadNotifications,
                      child: AppListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final selected =
                              _selectedNotificationIds.contains(item.numericId);
                          final selectable = item.numericId > 0;
                          return _Section(
                            child: AppTile(
                              contentPadding: EdgeInsets.zero,
                              selected: selected,
                              onPressed: selected
                                  ? () {
                                      if (!selectable) return;
                                      setState(() {
                                        _selectedNotificationIds
                                            .remove(item.numericId);
                                      });
                                    }
                                  : () => _openNotification(item),
                              onLongPress: selectable
                                  ? () => setState(() {
                                        if (selected) {
                                          _selectedNotificationIds
                                              .remove(item.numericId);
                                        } else {
                                          _selectedNotificationIds
                                              .add(item.numericId);
                                        }
                                      })
                                  : null,
                              prefix: AppCheckbox(
                                value: selected,
                                semanticsLabel: '选择通知',
                                onChanged: selectable
                                    ? (value) => setState(() {
                                          if (value) {
                                            _selectedNotificationIds
                                                .add(item.numericId);
                                          } else {
                                            _selectedNotificationIds
                                                .remove(item.numericId);
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
                                  if (item.content.isNotEmpty)
                                    Text(item.content),
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
                                    tooltip: '查看详情',
                                    size: AppIconButtonSize.sm,
                                  ),
                                  if (!item.isRead)
                                    AppIconButton(
                                      onPressed: selected
                                          ? null
                                          : () => _markRead(item),
                                      icon: Icons.mark_email_read_rounded,
                                      tooltip: '标记已读',
                                      size: AppIconButtonSize.sm,
                                    ),
                                  AppIconButton(
                                    onPressed: selected
                                        ? null
                                        : () => _deleteNotification(item),
                                    icon: Icons.delete_outline_rounded,
                                    tooltip: '删除',
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
    final bindableProviders = oauth2BindableProviders(_availableOAuth2);
    final oauth2Available = OAuth2DeepLinkService.canCreateSession;
    final linkedError = _loadError('OAuth2 绑定');
    final providersError = _loadError('OAuth2 Provider');
    final showLinkedOAuth2 = linkedError != null || _linkedOAuth2.isNotEmpty;
    final showBindableOAuth2 =
        providersError != null || bindableProviders.isNotEmpty;
    final showOAuth2Bindings = showLinkedOAuth2 || showBindableOAuth2;
    return AppListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Section(
          title: '媒体源账号',
          subtitle: '绑定个人媒体库账号后，可在添加影片时直接浏览 AList、Emby 和 Bilibili 资源。',
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 640;
              final cards = [
                _MediaProviderBindCard(
                  label: 'AList',
                  description: '个人网盘与目录资源',
                  icon: Icons.cloud_circle_rounded,
                  color: Colors.amber,
                  onTap: () => PlatformBindingDialog.show(
                    context,
                    initialIndex: 0,
                  ),
                ),
                _MediaProviderBindCard(
                  label: 'Emby',
                  description: '个人媒体库与影视资源',
                  icon: Icons.video_library_rounded,
                  color: Colors.green,
                  onTap: () => PlatformBindingDialog.show(
                    context,
                    initialIndex: 1,
                  ),
                ),
                _MediaProviderBindCard(
                  label: 'Bilibili',
                  description: 'Bilibili 账号与收藏资源',
                  icon: Icons.tv_rounded,
                  color: const Color(0xFFFB7299),
                  onTap: () => PlatformBindingDialog.show(
                    context,
                    initialIndex: 2,
                  ),
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
              return Row(
                children: [
                  for (final card in cards) ...[
                    Expanded(child: card),
                    if (card != cards.last) const SizedBox(width: 10),
                  ],
                ],
              );
            },
          ),
        ),
        if (showOAuth2Bindings) ...[
          const SizedBox(height: 12),
          if (showLinkedOAuth2) ...[
            _Section(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '已绑定 OAuth2',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  if (linkedError != null)
                    _InlineModuleError(
                      moduleInfo: _moduleInfo['OAuth2 绑定'],
                      message: linkedError,
                      onRetry: () => _load(refresh: true),
                    )
                  else
                    for (final account in _linkedOAuth2)
                      AppTile(
                        contentPadding: EdgeInsets.zero,
                        prefix: const Icon(Icons.link_rounded),
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
                          tooltip: '解绑',
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
                  const Text('绑定新账号',
                      style: TextStyle(fontWeight: FontWeight.w700)),
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
                        for (final provider in bindableProviders)
                          AppActionButton(
                            onPressed: oauth2Available
                                ? () => _startOAuth2Bind(provider)
                                : null,
                            icon: Icons.open_in_new_rounded,
                            label: '${provider.type} (${provider.name})',
                            style: AppActionButtonStyle.outlined,
                          ),
                      ],
                    ),
                  if (!oauth2Available) ...[
                    const SizedBox(height: 10),
                    Text(
                      '当前构建未配置 OAuth2 App Link，无法在本设备完成授权回跳。',
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
                              size: AppLoadingSize.sm, centered: false),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '等待 $_bindProvider 授权回跳',
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
                        label: '取消绑定',
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
      title: '资料',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(label: '用户名', value: _user.username),
          if (_user.hasEmail) _InfoRow(label: '邮箱', value: _user.email!),
          _InfoRow(label: '角色', value: _userRoleLabel(_user.role)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: AppActionButton(
              onPressed: () => _tabController.animateTo(1),
              icon: Icons.person_outline_rounded,
              label: '查看资料',
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
      title: '安全',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            label: '多因素认证',
            value: preferences?.twoFactorEnabled == true ? '已启用' : '未启用',
          ),
          _InfoRow(
            label: '可用因素',
            value: preferences == null
                ? '-'
                : _factorLabels(preferences).join('、'),
          ),
          if (_publicSettings?.enableWebauthn == true)
            _InfoRow(label: 'Passkey', value: '${_passkeys.length} 个'),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: AppActionButton(
              onPressed: () => _tabController.animateTo(3),
              icon: Icons.security_rounded,
              label: '管理安全',
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
      title: '最近房间',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (rooms.isEmpty)
            const AppEmptyMessage(
              message: '暂无房间',
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
                      '创建者 ${room.creator.trim()}',
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
              label: '创建房间',
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: AppActionButton(
              onPressed: () => _tabController.animateTo(2),
              icon: Icons.meeting_room_outlined,
              label: '管理房间',
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
            client_enum.MyRoomRelation.MY_ROOM_RELATION_CREATED.value ||
        room.myRole ==
            common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR.value ||
        room.creatorId == _user.id;
  }

  bool _canManageRoomFromListEntry(SyncTvRoom room) {
    return _isMyCreatedRoom(room) ||
        room.myRole ==
            common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value ||
        _user.role == common_enum.UserRole.USER_ROLE_ROOT.value ||
        _user.role == common_enum.UserRole.USER_ROLE_ADMIN.value;
  }

  String _userRoleLabel(int role) {
    return switch (role) {
      1 => 'Root',
      2 => '管理员',
      3 => '用户',
      _ => '用户',
    };
  }

  String _userStatusLabel(int status) {
    return switch (status) {
      1 => '正常',
      2 => '待审核',
      3 => '已封禁',
      4 => '已关闭',
      _ => '正常',
    };
  }

  String _roomRoleLabel(int role) {
    return switch (role) {
      1 => '创建者',
      2 => '房间管理员',
      3 => '成员',
      4 => '访客',
      _ => '成员',
    };
  }

  String _roomRelationLabel(int relation) {
    return switch (relation) {
      2 => '我创建的',
      3 => '我加入的',
      _ => '我的房间',
    };
  }

  List<String> _factorLabels(AccountPreferences preferences) {
    final labels = <String>[];
    if (preferences.canUsePassword) labels.add('密码');
    if (preferences.canUsePasskey && _passkeyEnabled) labels.add('Passkey');
    if (preferences.canUseEmail && _user.hasEmail) labels.add('邮箱');
    if (labels.isEmpty) labels.add('无');
    return labels;
  }

  String _notificationType(int type) {
    return switch (type) {
      1 => '房间邀请',
      2 => '系统公告',
      3 => '房间事件',
      4 => '密码重置',
      5 => '邮箱绑定',
      _ => '通知',
    };
  }

  String _shortCredentialId(String credentialId) {
    if (credentialId.length <= 18) return credentialId;
    return '${credentialId.substring(0, 8)}...${credentialId.substring(credentialId.length - 6)}';
  }

  String _formatTimestamp(int seconds) {
    if (seconds <= 0) return '-';
    return DateFormat('yyyy-MM-dd HH:mm').format(
      DateTime.fromMillisecondsSinceEpoch(seconds * 1000),
    );
  }
}

enum _NotificationDetailAction { markRead, delete }

enum _PasswordUpdateMethod { currentPassword, emailToken, passkey }

enum _SensitiveOperationMethod { password, email, passkey }

class _PasswordUpdateInput {
  final _PasswordUpdateMethod method;
  final String currentPassword;
  final String emailToken;
  final String newPassword;

  const _PasswordUpdateInput({
    required this.method,
    this.currentPassword = '',
    this.emailToken = '',
    required this.newPassword,
  });
}

class _PasswordResetInput {
  final String token;
  final String newPassword;

  const _PasswordResetInput({
    required this.token,
    required this.newPassword,
  });
}

class _PasswordUpdateDialog extends StatefulWidget {
  final bool canUseCurrentPassword;
  final bool canUseEmail;
  final bool canUsePasskey;

  const _PasswordUpdateDialog({
    required this.canUseCurrentPassword,
    required this.canUseEmail,
    required this.canUsePasskey,
  });

  @override
  State<_PasswordUpdateDialog> createState() => _PasswordUpdateDialogState();
}

class _PasswordUpdateDialogState extends State<_PasswordUpdateDialog> {
  late _PasswordUpdateMethod _method;
  final _currentPasswordController = TextEditingController();
  final _emailTokenController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _method = widget.canUseCurrentPassword
        ? _PasswordUpdateMethod.currentPassword
        : widget.canUseEmail
            ? _PasswordUpdateMethod.emailToken
            : _PasswordUpdateMethod.passkey;
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _emailTokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;
    if (newPassword.isEmpty || newPassword != confirmPassword) return;
    switch (_method) {
      case _PasswordUpdateMethod.currentPassword:
        final currentPassword = _currentPasswordController.text;
        if (currentPassword.isEmpty) return;
        Navigator.pop(
          context,
          _PasswordUpdateInput(
            method: _method,
            currentPassword: currentPassword,
            newPassword: newPassword,
          ),
        );
      case _PasswordUpdateMethod.emailToken:
        final emailToken = _emailTokenController.text.trim();
        if (emailToken.isEmpty) return;
        Navigator.pop(
          context,
          _PasswordUpdateInput(
            method: _method,
            emailToken: emailToken,
            newPassword: newPassword,
          ),
        );
      case _PasswordUpdateMethod.passkey:
        Navigator.pop(
          context,
          _PasswordUpdateInput(method: _method, newPassword: newPassword),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final methods = <ButtonSegment<_PasswordUpdateMethod>>[
      if (widget.canUseCurrentPassword)
        const ButtonSegment(
          value: _PasswordUpdateMethod.currentPassword,
          icon: Icon(Icons.password_rounded),
          label: Text('当前密码'),
        ),
      if (widget.canUseEmail)
        const ButtonSegment(
          value: _PasswordUpdateMethod.emailToken,
          icon: Icon(Icons.mark_email_read_rounded),
          label: Text('邮箱'),
        ),
      if (widget.canUsePasskey)
        const ButtonSegment(
          value: _PasswordUpdateMethod.passkey,
          icon: Icon(Icons.fingerprint_rounded),
          label: Text('Passkey'),
        ),
    ];
    final methodDescriptions = {
      _PasswordUpdateMethod.currentPassword: '使用当前密码验证身份',
      _PasswordUpdateMethod.emailToken: '使用邮箱收到的验证码验证身份',
      _PasswordUpdateMethod.passkey: '调用系统 Passkey 完成身份验证',
    };
    return _AccountActionDialog(
      icon: Icons.lock_reset_rounded,
      title: '修改密码',
      subtitle: '选择一种可用的验证方式，然后设置新的登录密码。',
      maxWidth: 560,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DialogFieldGroup(
            title: '验证方式',
            subtitle: methodDescriptions[_method] ?? '',
            child: AppSingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: AppSegmentedControl<_PasswordUpdateMethod>(
                segments: methods,
                value: _method,
                onChanged: (selected) => setState(() => _method = selected),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _DialogFieldGroup(
            title: '身份验证',
            children: [
              if (_method == _PasswordUpdateMethod.currentPassword)
                _DialogTextField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  autofocus: true,
                  label: '当前密码',
                  icon: Icons.lock_outline_rounded,
                  textInputAction: TextInputAction.next,
                ),
              if (_method == _PasswordUpdateMethod.emailToken)
                _DialogTextField(
                  controller: _emailTokenController,
                  autofocus: true,
                  label: '邮箱验证码',
                  icon: Icons.mark_email_read_outlined,
                  textInputAction: TextInputAction.next,
                ),
              if (_method == _PasswordUpdateMethod.passkey)
                const _DialogNotice(
                  icon: Icons.fingerprint_rounded,
                  title: 'Passkey 验证',
                  message: '保存后会弹出系统验证窗口，验证通过后写入新密码。',
                ),
            ],
          ),
          const SizedBox(height: 16),
          _DialogFieldGroup(
            title: '新密码',
            children: [
              _DialogTextField(
                controller: _newPasswordController,
                obscureText: true,
                label: '新密码',
                icon: Icons.lock_reset_rounded,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              _DialogTextField(
                controller: _confirmPasswordController,
                obscureText: true,
                label: '确认新密码',
                icon: Icons.check_circle_outline_rounded,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ],
      ),
      primaryLabel: '保存密码',
      onPrimary: _submit,
    );
  }
}

class _PasswordResetDialog extends StatefulWidget {
  final String email;

  const _PasswordResetDialog({required this.email});

  @override
  State<_PasswordResetDialog> createState() => _PasswordResetDialogState();
}

class _PasswordResetDialogState extends State<_PasswordResetDialog> {
  final _tokenController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _requesting = false;

  @override
  void dispose() {
    _tokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _requestResetEmail() async {
    if (_requesting) return;
    setState(() => _requesting = true);
    try {
      final message = await SyncTvService.requestPasswordReset(
        widget.email,
      );
      if (!mounted) return;
      MessageUtils.showSuccess(
        context,
        message.isEmpty ? '密码重置邮件已发送' : message,
      );
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '发送重置邮件失败: $e');
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  void _submit() {
    final token = _tokenController.text.trim();
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;
    if (token.isEmpty || newPassword.isEmpty) {
      MessageUtils.showWarning(context, '请输入验证码和新密码');
      return;
    }
    if (newPassword != confirmPassword) {
      MessageUtils.showWarning(context, '两次输入的新密码不一致');
      return;
    }
    Navigator.pop(
      context,
      _PasswordResetInput(token: token, newPassword: newPassword),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _AccountActionDialog(
      icon: Icons.mark_email_read_rounded,
      title: '邮件重置密码',
      subtitle: '向当前绑定邮箱发送一次性验证码，用验证码完成密码重置。',
      maxWidth: 560,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DialogFieldGroup(
            title: '接收邮箱',
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 420;
                final emailField = _DialogReadOnlyField(
                  label: '邮箱',
                  value: widget.email,
                  icon: Icons.email_outlined,
                );
                final sendButton = AppActionButton(
                  onPressed: _requestResetEmail,
                  loading: _requesting,
                  icon: Icons.send_rounded,
                  label: '发送验证码',
                  style: AppActionButtonStyle.outlined,
                );
                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      emailField,
                      const SizedBox(height: 10),
                      sendButton,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: emailField),
                    const SizedBox(width: 10),
                    SizedBox(height: 48, child: sendButton),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _DialogFieldGroup(
            title: '验证码',
            children: [
              _DialogTextField(
                controller: _tokenController,
                autofocus: true,
                label: '重置验证码',
                icon: Icons.mark_email_read_outlined,
                textInputAction: TextInputAction.next,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DialogFieldGroup(
            title: '新密码',
            children: [
              _DialogTextField(
                controller: _newPasswordController,
                obscureText: true,
                label: '新密码',
                icon: Icons.lock_reset_rounded,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 12),
              _DialogTextField(
                controller: _confirmPasswordController,
                obscureText: true,
                label: '确认新密码',
                icon: Icons.check_circle_outline_rounded,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ],
      ),
      primaryLabel: '重置密码',
      onPrimary: _submit,
    );
  }
}

class _EmailBindDialog extends StatefulWidget {
  final Future<String?> Function() verifySensitiveOperation;

  const _EmailBindDialog({required this.verifySensitiveOperation});

  @override
  State<_EmailBindDialog> createState() => _EmailBindDialogState();
}

class _EmailBindDialogState extends State<_EmailBindDialog> {
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  String _maskedEmail = '';
  bool _requesting = false;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _requestToken() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || _requesting) return;
    setState(() => _requesting = true);
    try {
      final maskedEmail = await SyncTvService.startEmailBind(email);
      if (!mounted) return;
      setState(() => _maskedEmail = maskedEmail);
      MessageUtils.showSuccess(context, '绑定确认邮件已发送');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '发送绑定邮件失败: $e');
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final token = _tokenController.text.trim();
    if (email.isEmpty || token.isEmpty || _submitting) return;
    setState(() => _submitting = true);
    try {
      final verificationId = await widget.verifySensitiveOperation();
      if (verificationId == null) return;
      final user = await SyncTvService.confirmEmailBind(
        email: email,
        token: token,
        verificationId: verificationId,
      );
      if (mounted) Navigator.pop(context, user);
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '绑定邮箱失败: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _AccountActionDialog(
      icon: Icons.alternate_email_rounded,
      title: '绑定邮箱',
      subtitle: '邮箱绑定成功后可用于登录、找回密码和接收账号通知。',
      maxWidth: 560,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DialogFieldGroup(
            title: '邮箱地址',
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 420;
                final emailField = _DialogTextField(
                  controller: _emailController,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  label: '邮箱',
                  icon: Icons.email_outlined,
                  textInputAction: TextInputAction.next,
                );
                final sendButton = AppActionButton(
                  onPressed: _requestToken,
                  loading: _requesting,
                  icon: Icons.send_rounded,
                  label: '发送验证码',
                  style: AppActionButtonStyle.outlined,
                );
                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      emailField,
                      const SizedBox(height: 10),
                      sendButton,
                    ],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: emailField),
                    const SizedBox(width: 10),
                    SizedBox(height: 48, child: sendButton),
                  ],
                );
              },
            ),
          ),
          if (_maskedEmail.isNotEmpty) ...[
            const SizedBox(height: 12),
            _DialogNotice(
              icon: Icons.mark_email_read_rounded,
              title: '确认邮件已发送',
              message: '验证码已发送至 $_maskedEmail。',
            ),
          ],
          const SizedBox(height: 16),
          _DialogFieldGroup(
            title: '确认绑定',
            children: [
              _DialogTextField(
                controller: _tokenController,
                label: '绑定验证码',
                icon: Icons.mark_email_read_outlined,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ],
      ),
      primaryLabel: '绑定邮箱',
      primaryLoading: _submitting,
      onPrimary: _submitting ? null : _submit,
    );
  }
}

class _SensitiveOperationDialog extends StatefulWidget {
  const _SensitiveOperationDialog();

  @override
  State<_SensitiveOperationDialog> createState() =>
      _SensitiveOperationDialogState();
}

class _SensitiveOperationDialogState extends State<_SensitiveOperationDialog> {
  final _passwordController = TextEditingController();
  final _emailTokenController = TextEditingController();
  SensitiveOperationVerificationInfo? _verification;
  SensitiveOperationEmailCodeInfo? _emailCode;
  _SensitiveOperationMethod? _method;
  bool _loading = true;
  bool _requestingEmail = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailTokenController.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    setState(() => _loading = true);
    try {
      final verification =
          await SyncTvService.startSensitiveOperationVerification();
      if (!mounted) return;
      final method = _defaultMethod(verification.challenge);
      setState(() {
        _verification = verification;
        _method = method;
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        MessageUtils.showError(context, '身份验证初始化失败: $e');
      }
    }
  }

  _SensitiveOperationMethod? _defaultMethod(
    SensitiveOperationVerificationChallengeInfo challenge,
  ) {
    if (_method != null && _methodAvailable(challenge, _method!)) {
      return _method;
    }
    if (_methodAvailable(challenge, _SensitiveOperationMethod.password)) {
      return _SensitiveOperationMethod.password;
    }
    if (_methodAvailable(challenge, _SensitiveOperationMethod.passkey)) {
      return _SensitiveOperationMethod.passkey;
    }
    if (_methodAvailable(challenge, _SensitiveOperationMethod.email)) {
      return _SensitiveOperationMethod.email;
    }
    return null;
  }

  bool _methodAvailable(
    SensitiveOperationVerificationChallengeInfo challenge,
    _SensitiveOperationMethod method,
  ) {
    return challenge.availableMethods.contains(_methodProto(method).value);
  }

  client_enum.SensitiveOperationVerificationMethod _methodProto(
    _SensitiveOperationMethod method,
  ) {
    return switch (method) {
      _SensitiveOperationMethod.password => client_enum
          .SensitiveOperationVerificationMethod
          .SENSITIVE_OPERATION_VERIFICATION_METHOD_PASSWORD,
      _SensitiveOperationMethod.email => client_enum
          .SensitiveOperationVerificationMethod
          .SENSITIVE_OPERATION_VERIFICATION_METHOD_EMAIL,
      _SensitiveOperationMethod.passkey => client_enum
          .SensitiveOperationVerificationMethod
          .SENSITIVE_OPERATION_VERIFICATION_METHOD_WEBAUTHN,
    };
  }

  List<ButtonSegment<_SensitiveOperationMethod>> _methodSegments(
    SensitiveOperationVerificationChallengeInfo challenge,
  ) {
    return [
      if (_methodAvailable(challenge, _SensitiveOperationMethod.password))
        const ButtonSegment(
          value: _SensitiveOperationMethod.password,
          icon: Icon(Icons.password_rounded),
          label: Text('密码'),
        ),
      if (_methodAvailable(challenge, _SensitiveOperationMethod.passkey))
        const ButtonSegment(
          value: _SensitiveOperationMethod.passkey,
          icon: Icon(Icons.fingerprint_rounded),
          label: Text('Passkey'),
        ),
      if (_methodAvailable(challenge, _SensitiveOperationMethod.email))
        const ButtonSegment(
          value: _SensitiveOperationMethod.email,
          icon: Icon(Icons.mark_email_read_rounded),
          label: Text('邮箱'),
        ),
    ];
  }

  Future<void> _requestEmailCode() async {
    final verification = _verification;
    if (verification == null || _requestingEmail) return;
    setState(() => _requestingEmail = true);
    try {
      final info = await SyncTvService.requestSensitiveOperationEmailCode(
        verification.challenge.sessionId,
      );
      if (!mounted) return;
      setState(() => _emailCode = info);
      MessageUtils.showSuccess(
        context,
        info.message.isEmpty ? '验证码已发送' : info.message,
      );
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '发送验证码失败: $e');
    } finally {
      if (mounted) setState(() => _requestingEmail = false);
    }
  }

  Future<void> _submit() async {
    final verification = _verification;
    final method = _method;
    if (verification == null || method == null || _submitting) return;
    if (method == _SensitiveOperationMethod.password &&
        _passwordController.text.isEmpty) {
      MessageUtils.showWarning(context, '请输入当前密码');
      return;
    }
    if (method == _SensitiveOperationMethod.email &&
        _emailTokenController.text.trim().isEmpty) {
      MessageUtils.showWarning(context, '请输入邮箱验证码');
      return;
    }
    setState(() => _submitting = true);
    try {
      var passkeySessionId = '';
      Object? passkeyCredential;
      if (method == _SensitiveOperationMethod.passkey) {
        final passkey = await SyncTvService.startSensitiveOperationPasskey(
          verification.challenge.sessionId,
        );
        if (passkey.passkeySessionId.isEmpty || passkey.options.isEmpty) {
          throw const FormatException('服务器未返回 Passkey 验证 challenge');
        }
        passkeySessionId = passkey.passkeySessionId;
        passkeyCredential = await PasskeyAuthenticatorService.getCredential(
          passkey.options,
        );
      }
      final finished = await SyncTvService.finishSensitiveOperationVerification(
        sessionId: verification.challenge.sessionId,
        method: _methodProto(method),
        password: _passwordController.text,
        emailToken: _emailTokenController.text.trim(),
        passkeySessionId: passkeySessionId,
        passkeyCredential: passkeyCredential,
      );
      if (!mounted) return;
      Navigator.pop(context, finished.verificationId);
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '身份验证失败: $e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final verification = _verification;
    final challenge = verification?.challenge;
    final method = _method;
    final segments = challenge == null
        ? const <ButtonSegment<_SensitiveOperationMethod>>[]
        : _methodSegments(challenge);
    return _AccountActionDialog(
      icon: Icons.verified_user_rounded,
      title: '身份验证',
      subtitle: '选择一种可用方式以继续账号安全操作。',
      maxWidth: 560,
      content: _loading
          ? const SizedBox(
              height: 72,
              child: Center(child: AppLoadingIndicator()),
            )
          : challenge == null || method == null || segments.isEmpty
              ? const _DialogNotice(
                  icon: Icons.error_outline_rounded,
                  title: '没有可用验证方式',
                  message: '当前账号缺少密码、邮箱或 Passkey 验证能力。',
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _DialogFieldGroup(
                      title: '验证方式',
                      child: AppSingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: AppSegmentedControl<_SensitiveOperationMethod>(
                          segments: segments,
                          value: method,
                          onChanged: (selected) =>
                              setState(() => _method = selected),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _DialogFieldGroup(
                      title: '验证信息',
                      children: [
                        if (method == _SensitiveOperationMethod.password)
                          _DialogTextField(
                            controller: _passwordController,
                            autofocus: true,
                            obscureText: true,
                            label: '当前密码',
                            icon: Icons.lock_outline_rounded,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _submit(),
                          ),
                        if (method == _SensitiveOperationMethod.passkey)
                          const _DialogNotice(
                            icon: Icons.fingerprint_rounded,
                            title: 'Passkey 验证',
                            message: '点击验证后会弹出系统验证窗口。',
                          ),
                        if (method == _SensitiveOperationMethod.email)
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final compact = constraints.maxWidth < 420;
                              final field = _DialogTextField(
                                controller: _emailTokenController,
                                autofocus: true,
                                label: '邮箱验证码',
                                icon: Icons.mark_email_read_outlined,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _submit(),
                              );
                              final sendButton = AppActionButton(
                                onPressed:
                                    _requestingEmail ? null : _requestEmailCode,
                                loading: _requestingEmail,
                                icon: Icons.send_rounded,
                                label: _emailCode == null ? '发送验证码' : '重新发送',
                                style: AppActionButtonStyle.outlined,
                              );
                              final maskedEmail = _emailCode?.maskedEmail ?? '';
                              final children = [
                                Expanded(child: field),
                                const SizedBox(width: 10),
                                SizedBox(height: 48, child: sendButton),
                              ];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (compact) ...[
                                    field,
                                    const SizedBox(height: 10),
                                    sendButton,
                                  ] else
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: children,
                                    ),
                                  if (maskedEmail.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      '验证码已发送至 $maskedEmail',
                                      style: TextStyle(
                                        color: Theme.of(context).hintColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ),
      primaryLabel: '验证',
      primaryLoading: _submitting,
      onPrimary:
          _loading || challenge == null || method == null ? null : _submit,
    );
  }
}

class _NotificationDetailSheet extends StatelessWidget {
  final UserNotificationItem notification;
  final String typeLabel;
  final String createdAtLabel;
  final String updatedAtLabel;

  const _NotificationDetailSheet({
    required this.notification,
    required this.typeLabel,
    required this.createdAtLabel,
    required this.updatedAtLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataText = notification.data.isEmpty
        ? ''
        : const JsonEncoder.withIndent('  ').convert(notification.data);

    return AppSafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: AppMetrics.dialogMaxHeight(context, null),
          ),
          child: AppSingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      notification.isRead
                          ? Icons.notifications_none_rounded
                          : Icons.notifications_active_rounded,
                      color: notification.isRead
                          ? theme.hintColor
                          : theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        notification.title.isEmpty
                            ? typeLabel
                            : notification.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    AppChip(label: Text(typeLabel)),
                    AppChip(label: Text(notification.isRead ? '已读' : '未读')),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  [
                    '创建 $createdAtLabel',
                    if (updatedAtLabel != '-' &&
                        updatedAtLabel != createdAtLabel)
                      '更新 $updatedAtLabel',
                  ].join(' · '),
                  style: TextStyle(color: theme.hintColor, fontSize: 12),
                ),
                if (notification.content.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    notification.content,
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
                if (dataText.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    '数据',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppPanelSurface(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                    child: AppSelectableText(
                      dataText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: AppActionButton(
                        onPressed: notification.isRead
                            ? null
                            : () => Navigator.pop(
                                  context,
                                  _NotificationDetailAction.markRead,
                                ),
                        icon: Icons.mark_email_read_rounded,
                        label: '标记已读',
                        style: AppActionButtonStyle.outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppActionButton(
                        onPressed: () => Navigator.pop(
                          context,
                          _NotificationDetailAction.delete,
                        ),
                        icon: Icons.delete_outline_rounded,
                        label: '删除',
                        style: AppActionButtonStyle.destructive,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountActionDialog extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget content;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final bool primaryLoading;
  final double maxWidth;

  const _AccountActionDialog({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.primaryLabel,
    required this.onPrimary,
    this.primaryLoading = false,
    this.maxWidth = 520,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppDialogFrame(
      maxWidth: maxWidth,
      backgroundColor: Colors.transparent,
      child: AppInkSurface(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.72),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppIconBadge(
                    icon: icon,
                    color: theme.colorScheme.primary,
                    size: 42,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.62),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppIconButton(
                    tooltip: '关闭',
                    onPressed: () => Navigator.pop(context),
                    icon: Icons.close_rounded,
                  ),
                ],
              ),
            ),
            Flexible(
              child: AppSingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                child: content,
              ),
            ),
            AppPanelSurface(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.42),
              borderRadius: BorderRadius.zero,
              border: Border(
                top: BorderSide(
                  color:
                      theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                ),
              ),
              child: Row(
                children: [
                  const Spacer(),
                  AppActionButton(
                    onPressed:
                        primaryLoading ? null : () => Navigator.pop(context),
                    label: '取消',
                    style: AppActionButtonStyle.text,
                  ),
                  const SizedBox(width: 10),
                  AppActionButton(
                    onPressed: onPrimary,
                    loading: primaryLoading,
                    icon: Icons.check_rounded,
                    label: primaryLabel,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SingleTextInputDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String label;
  final String hintText;
  final String initialValue;
  final String primaryLabel;

  const _SingleTextInputDialog({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.label,
    required this.primaryLabel,
    this.hintText = '',
    this.initialValue = '',
  });

  @override
  State<_SingleTextInputDialog> createState() => _SingleTextInputDialogState();
}

class _SingleTextInputDialogState extends State<_SingleTextInputDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.pop(context, _controller.text.trim());

  @override
  Widget build(BuildContext context) {
    return _AccountActionDialog(
      icon: widget.icon,
      title: widget.title,
      subtitle: widget.subtitle,
      primaryLabel: widget.primaryLabel,
      onPrimary: _submit,
      content: _DialogTextField(
        controller: _controller,
        label: widget.label,
        hintText: widget.hintText,
        icon: widget.icon,
        autofocus: true,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
      ),
    );
  }
}

class _DialogFieldGroup extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? child;
  final List<Widget>? children;

  const _DialogFieldGroup({
    required this.title,
    this.subtitle,
    this.child,
    this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final body = child ??
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children ?? const [],
        );
    return AppPanelSurface(
      padding: const EdgeInsets.all(14),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.36),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.68),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
              ),
            ),
          ],
          const SizedBox(height: 12),
          body,
        ],
      ),
    );
  }
}

class _DialogTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const _DialogTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.hintText = '',
    this.obscureText = false,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      hintText: hintText.isEmpty ? null : hintText,
      prefixIcon: icon,
      autofocus: autofocus,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      autocorrect: false,
      smartDashesType: SmartDashesType.disabled,
      smartQuotesType: SmartQuotesType.disabled,
    );
  }
}

class _DialogReadOnlyField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DialogReadOnlyField({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppReadOnlyField(
      label: label,
      value: value,
      prefixIcon: icon,
    );
  }
}

class _DialogNotice extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _DialogNotice({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppInfoBanner(
      padding: const EdgeInsets.all(12),
      icon: icon,
      color: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: theme.colorScheme.primary.withValues(alpha: 0.18),
      ),
      crossAxisAlignment: CrossAxisAlignment.start,
      iconSize: 22,
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      message: Text(
        message,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.68),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool dense;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppIconBadge(
          icon: icon,
          color: theme.colorScheme.primary,
          size: dense ? 36 : 42,
          iconSize: dense ? 20 : 22,
          borderRadius: BorderRadius.circular(8),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: (dense
                        ? theme.textTheme.titleMedium
                        : theme.textTheme.titleLarge)
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool danger;
  final Widget child;

  const _Section({
    this.title,
    this.subtitle,
    this.danger = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasHeader = title != null || subtitle != null;
    return AppInkSurface(
      color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: danger
            ? Colors.red.withValues(alpha: 0.38)
            : theme.dividerColor.withValues(alpha: 0.55),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: hasHeader
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: danger ? Colors.red.shade700 : null,
                      ),
                    ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.62),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  child,
                ],
              )
            : child,
      ),
    );
  }
}

class _LoadErrorSummary extends StatelessWidget {
  final Map<String, String> errors;
  final Map<String, _AccountModuleInfo> moduleInfo;
  final VoidCallback onRetry;

  const _LoadErrorSummary({
    required this.errors,
    required this.moduleInfo,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Section(
      danger: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '部分账号模块暂时不可用',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              AppActionButton(
                onPressed: onRetry,
                icon: Icons.refresh_rounded,
                label: '全部重试',
                style: AppActionButtonStyle.text,
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final entry in errors.entries) ...[
            _ModuleErrorRow(
              info: moduleInfo[entry.key],
              fallbackLabel: entry.key,
              message: entry.value,
            ),
            if (entry.key != errors.keys.last) const AppDivider(height: 16),
          ],
        ],
      ),
    );
  }
}

class _LoadErrorBanner extends StatelessWidget {
  final String title;
  final _AccountModuleInfo? moduleInfo;
  final String message;
  final VoidCallback onRetry;

  const _LoadErrorBanner({
    required this.title,
    this.moduleInfo,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Section(
      danger: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                moduleInfo?.icon ?? Icons.warning_amber_rounded,
                color: Colors.red,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  moduleInfo == null ? title : '$title：${moduleInfo!.label}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              AppActionButton(
                onPressed: onRetry,
                icon: Icons.refresh_rounded,
                label: '重试',
                style: AppActionButtonStyle.text,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (moduleInfo != null) ...[
            Text(
              moduleInfo!.impact,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
              ),
            ),
            const SizedBox(height: 6),
          ],
          Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModuleErrorRow extends StatelessWidget {
  final _AccountModuleInfo? info;
  final String fallbackLabel;
  final String message;

  const _ModuleErrorRow({
    required this.info,
    required this.fallbackLabel,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final module = info;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          module?.icon ?? Icons.error_outline_rounded,
          color: Colors.red,
          size: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                module?.label ?? fallbackLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                module?.impact ?? '此模块当前无法加载。',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                message,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MediaProviderBindCard extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MediaProviderBindCard({
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppInkSurface(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          AppIconBadge(
            icon: icon,
            color: color,
            size: 40,
            backgroundAlpha: 0.14,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_rounded, color: color),
        ],
      ),
    );
  }
}

class _InlineModuleError extends StatelessWidget {
  final _AccountModuleInfo? moduleInfo;
  final String message;
  final VoidCallback onRetry;

  const _InlineModuleError({
    this.moduleInfo,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppInfoBanner(
      padding: const EdgeInsets.all(12),
      icon: moduleInfo?.icon ?? Icons.error_outline_rounded,
      color: Colors.red,
      backgroundColor: Colors.red.withValues(alpha: 0.06),
      border: Border.all(color: Colors.red.withValues(alpha: 0.26)),
      crossAxisAlignment: CrossAxisAlignment.start,
      title: Text(
        moduleInfo?.label ?? '模块不可用',
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      message: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (moduleInfo != null) ...[
            Text(
              moduleInfo!.impact,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.70),
              ),
            ),
            const SizedBox(height: 3),
          ],
          Text(
            message,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
            ),
          ),
        ],
      ),
      trailing: AppActionButton(
        onPressed: onRetry,
        label: '重试',
        style: AppActionButtonStyle.text,
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String username;
  final String avatarUrl;
  final double size;

  const _ProfileAvatar({
    required this.username,
    required this.size,
    this.avatarUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = SyncTvService.resolveResourceUrl(avatarUrl);
    return AppAvatar(
      name: username,
      imageUrl: imageUrl,
      size: size,
      shape: BoxShape.rectangle,
      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
      foregroundColor: theme.colorScheme.primary,
      textStyle: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _EditableProfileAvatar extends StatelessWidget {
  const _EditableProfileAvatar({
    required this.username,
    required this.avatarUrl,
    required this.size,
    required this.updating,
    required this.onPick,
    this.onClear,
  });

  final String username;
  final String avatarUrl;
  final double size;
  final bool updating;
  final VoidCallback onPick;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              _ProfileAvatar(
                username: username,
                avatarUrl: avatarUrl,
                size: size,
              ),
              Positioned.fill(
                child: AppInkSurface(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  onTap: updating ? null : onPick,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: AppPanelSurface(
                      margin: const EdgeInsets.all(4),
                      width: 26,
                      height: 26,
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                      child: updating
                          ? const Padding(
                              padding: EdgeInsets.all(6),
                              child: AppLoadingIndicator(
                                size: AppLoadingSize.sm,
                                centered: false,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.photo_camera_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (onClear != null) ...[
            const SizedBox(height: 8),
            AppActionButton(
              onPressed: updating ? null : onClear,
              label: '移除',
              style: AppActionButtonStyle.text,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool danger;
  final Color? color;

  const _StatusPill({
    required this.icon,
    required this.label,
    this.danger = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        this.color ?? (danger ? Colors.red : theme.colorScheme.primary);
    return AppBadge(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      borderRadius: BorderRadius.circular(999),
      borderSide: BorderSide(color: color.withValues(alpha: 0.20)),
      icon: icon,
      iconSize: 14,
      color: color,
      backgroundColor: color.withValues(alpha: 0.10),
      textStyle: theme.textTheme.labelSmall?.copyWith(
        color: color,
        fontWeight: FontWeight.w700,
      ),
      label: Text(label),
    );
  }
}

class _AccountNavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AccountNavTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground =
        selected ? theme.colorScheme.primary : theme.colorScheme.onSurface;
    return AppInkSurface(
      color: selected
          ? theme.colorScheme.primary.withValues(alpha: 0.10)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      child: Row(
        children: [
          Icon(icon, size: 20, color: foreground),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: foreground,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountHero extends StatelessWidget {
  final SyncTvUser user;
  final String roleLabel;
  final String statusLabel;
  final String activeServerName;
  final String createdAtLabel;

  const _AccountHero({
    required this.user,
    required this.roleLabel,
    required this.statusLabel,
    required this.activeServerName,
    required this.createdAtLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return AppInkSurface(
      color: isDark ? const Color(0xFF1C1C1F) : Colors.white,
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.55)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 680;
            final identity = Row(
              children: [
                _ProfileAvatar(username: user.username, size: wide ? 76 : 60),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username.isEmpty ? '当前账号' : user.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (user.hasEmail) ...[
                        const SizedBox(height: 6),
                        Text(
                          user.email!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.66),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
            final metadata = Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _StatusPill(
                  icon: Icons.dns_outlined,
                  label: activeServerName,
                ),
                _StatusPill(
                  icon: Icons.admin_panel_settings_outlined,
                  label: roleLabel,
                ),
                _StatusPill(
                  icon: Icons.circle_outlined,
                  label: statusLabel,
                ),
                _StatusPill(
                  icon: Icons.calendar_month_outlined,
                  label: createdAtLabel,
                ),
              ],
            );
            if (!wide) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  identity,
                  const SizedBox(height: 14),
                  metadata,
                ],
              );
            }
            return Row(
              children: [
                Expanded(child: identity),
                const SizedBox(width: 18),
                Flexible(child: metadata),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color tone;

  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Section(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: tone, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoEntry {
  final String label;
  final String value;

  const _InfoEntry(this.label, this.value);
}

class _InfoGrid extends StatelessWidget {
  final List<_InfoEntry> entries;

  const _InfoGrid({required this.entries});

  @override
  Widget build(BuildContext context) {
    return AppResponsiveWrap(
      minItemWidth: 240,
      maxColumns: 3,
      children: [
        for (final entry in entries)
          _InfoRow(label: entry.label, value: entry.value),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: 3),
          AppSelectableText(
            value.isEmpty ? '-' : value,
            maxLines: 2,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RelationChip extends StatelessWidget {
  final String label;
  final client_enum.MyRoomRelation value;
  final client_enum.MyRoomRelation groupValue;
  final ValueChanged<client_enum.MyRoomRelation> onSelected;

  const _RelationChip({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppChip(
      label: Text(label),
      selected: value == groupValue,
      onSelected: (_) => onSelected(value),
      showCheckmark: false,
    );
  }
}

class _RoomManagementTile extends StatelessWidget {
  final SyncTvRoom room;
  final String roleLabel;
  final String relationLabel;
  final String updatedAtLabel;
  final bool isOwner;
  final bool canManage;
  final VoidCallback onOpen;
  final VoidCallback onManage;
  final VoidCallback onLeaveOrDelete;

  const _RoomManagementTile({
    required this.room,
    required this.roleLabel,
    required this.relationLabel,
    required this.updatedAtLabel,
    required this.isOwner,
    required this.canManage,
    required this.onOpen,
    required this.onManage,
    required this.onLeaveOrDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _Section(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 720;
          final title = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                room.roomName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                room.description.isEmpty ? room.roomId : room.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
                ),
              ),
            ],
          );
          final chips = Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatusPill(icon: Icons.badge_outlined, label: roleLabel),
              _StatusPill(icon: Icons.group_outlined, label: relationLabel),
              if (room.needPassword)
                const _StatusPill(
                    icon: Icons.lock_outline_rounded, label: '密码'),
              if (room.needVerify)
                const _StatusPill(
                  icon: Icons.fact_check_outlined,
                  label: '审核',
                ),
              if (room.isBanned)
                const _StatusPill(
                  icon: Icons.block_rounded,
                  label: '已封禁',
                  danger: true,
                ),
            ],
          );
          final meta = Text(
            '成员 ${room.memberCount} · 更新 $updatedAtLabel',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
            ),
          );
          final actions = Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppActionButton(
                onPressed: onOpen,
                icon: Icons.open_in_new_rounded,
                label: '打开',
              ),
              if (canManage)
                AppActionButton(
                  onPressed: onManage,
                  icon: Icons.settings_outlined,
                  label: '管理',
                  style: AppActionButtonStyle.outlined,
                ),
              AppActionButton(
                onPressed: onLeaveOrDelete,
                icon: isOwner
                    ? Icons.delete_outline_rounded
                    : Icons.logout_rounded,
                label: isOwner ? '删除' : '退出',
                style: AppActionButtonStyle.outlined,
              ),
            ],
          );
          if (!wide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RoomCoverThumb(room: room, size: 88, wide: true),
                const SizedBox(height: 10),
                title,
                const SizedBox(height: 10),
                _RoomCreatorLine(room: room),
                const SizedBox(height: 10),
                chips,
                const SizedBox(height: 10),
                meta,
                const SizedBox(height: 12),
                actions,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RoomCoverThumb(room: room, size: 88, wide: true),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
                    const SizedBox(height: 10),
                    _RoomCreatorLine(room: room),
                    const SizedBox(height: 10),
                    chips,
                    const SizedBox(height: 10),
                    meta,
                  ],
                ),
              ),
              const SizedBox(width: 16),
              actions,
            ],
          );
        },
      ),
    );
  }
}

class _RoomCreatorLine extends StatelessWidget {
  const _RoomCreatorLine({required this.room});

  final SyncTvRoom room;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final creatorName =
        room.creator.trim().isEmpty ? '未知创建者' : room.creator.trim();
    return Row(
      children: [
        AppAvatar(
          name: creatorName,
          imageUrl: SyncTvService.resolveResourceUrl(room.creatorAvatarUrl),
          radius: 12,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.10),
          foregroundColor: theme.colorScheme.primary,
          textStyle: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '创建者 $creatorName',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.66),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _RoomCoverThumb extends StatelessWidget {
  const _RoomCoverThumb({
    required this.room,
    required this.size,
    this.wide = false,
  });

  final SyncTvRoom room;
  final double size;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(7);
    final fallback = ColoredBox(
      color: theme.colorScheme.primary.withValues(alpha: 0.12),
      child: Icon(
        Icons.meeting_room_outlined,
        color: theme.colorScheme.primary,
        size: wide ? 28 : 18,
      ),
    );
    final width = wide ? size * 1.35 : size;
    if (room.coverUrl.isEmpty) {
      return AppPanelSurface(
        width: width,
        height: size,
        borderRadius: borderRadius,
        child: fallback,
      );
    }
    return AppImageThumbnail(
      url: room.coverUrl,
      width: width,
      height: size,
      borderRadius: borderRadius,
      errorChild: fallback,
    );
  }
}

class _NotificationFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _NotificationFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AppChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
    );
  }
}

class _PreferenceSwitch extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _PreferenceSwitch({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppSwitchTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
