import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synctv_app/models/account_models.dart';
import 'package:synctv_app/models/public_models.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/pages/desktop/desktop_room_screen.dart';
import 'package:synctv_app/pages/large_screen/large_screen_room.dart';
import 'package:synctv_app/pages/mobile/watch_together_room_screen.dart';
import 'package:synctv_app/services/oauth2_deep_link_service.dart';
import 'package:synctv_app/services/opaque_authenticator_service.dart';
import 'package:synctv_app/services/passkey_authenticator_service.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/utils/message_utils.dart';
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

class AccountCenterPage extends StatefulWidget {
  final WUser initialUser;

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
  };

  late TabController _tabController;
  late WUser _user;
  AccountPreferences? _preferences;
  UserNotificationsPage? _notifications;
  RoomsPage? _myRooms;
  List<OAuth2ProviderOption> _availableOAuth2 = const [];
  List<OAuth2LinkedAccount> _linkedOAuth2 = const [];
  List<PasskeyCredentialInfo> _passkeys = const [];
  Map<String, String> _loadErrors = const {};
  bool _loading = true;
  bool _savingPreferences = false;
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

  @override
  void initState() {
    super.initState();
    _user = widget.initialUser;
    _tabController = TabController(length: _sections.length, vsync: this);
    _opaqueAuthenticator = OpaqueAuthenticatorService();
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notificationSearchController.dispose();
    _roomSearchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final errors = <String, String>{};
      final user = await WatchTogetherService.getMe();
      final results = await Future.wait<dynamic>([
        _loadOptional(
          errors,
          '账号偏好',
          WatchTogetherService.getAccountPreferences,
        ),
        _loadOptional(
          errors,
          '通知',
          () => WatchTogetherService.listNotifications(
            page: _notificationPage,
            pageSize: _notificationPageSize,
          ),
        ),
        _loadOptional(
          errors,
          '房间',
          () => WatchTogetherService.getMyRoomsPage(
            page: _roomsPage,
            pageSize: _roomsPageSize,
            relation: _roomRelationFilter,
            sortBy: _roomSortBy,
          ),
        ),
        _loadOptional(
          errors,
          'OAuth2 Provider',
          WatchTogetherService.listOAuth2Providers,
        ),
        _loadOptional(
          errors,
          'OAuth2 绑定',
          WatchTogetherService.getLinkedOAuth2Accounts,
        ),
        _loadOptional(
          errors,
          'Passkey',
          WatchTogetherService.listPasskeys,
        ),
        _loadOptional(
          errors,
          '本机 Passkey',
          PasskeyAuthenticatorService.isSupported,
        ),
      ]);
      if (!mounted) return;
      setState(() {
        _user = user;
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
    final controller = TextEditingController(text: _user.username);
    final next = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('修改用户名'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: '用户名',
            prefixIcon: Icon(Icons.badge_outlined),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    if (next == null || next.isEmpty || next == _user.username) return;

    try {
      final user = await WatchTogetherService.updateUsername(next);
      if (!mounted) return;
      setState(() => _user = user);
      MessageUtils.showSuccess(context, '用户名已更新');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '更新用户名失败: $e');
    }
  }

  Future<void> _updateNotifications(NotificationPreferences preferences) async {
    setState(() => _savingPreferences = true);
    try {
      final updated = await WatchTogetherService.updateAccountPreferences(
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
      final updated = await WatchTogetherService.updateAccountPreferences(
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

  Future<void> _sendVerificationEmail() async {
    final email = _user.email;
    if (email == null || email.isEmpty) {
      MessageUtils.showWarning(context, '当前账号没有邮箱');
      return;
    }
    try {
      await WatchTogetherService.sendVerificationEmail(email);
      if (mounted) MessageUtils.showSuccess(context, '验证邮件已发送');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '发送验证邮件失败: $e');
    }
  }

  Future<void> _confirmEmail() async {
    final email = _user.email;
    if (email == null || email.isEmpty) {
      MessageUtils.showWarning(context, '当前账号没有邮箱');
      return;
    }
    final controller = TextEditingController();
    final token = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认邮箱'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: '$email 验证码',
            prefixIcon: const Icon(Icons.mark_email_read_outlined),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('确认'),
          ),
        ],
      ),
    );
    if (token == null || token.isEmpty) return;
    try {
      final user = await WatchTogetherService.confirmEmail(
        email: email,
        token: token,
      );
      if (!mounted) return;
      setState(() => _user = user);
      MessageUtils.showSuccess(context, '邮箱已验证');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '邮箱验证失败: $e');
    }
  }

  Future<void> _changePassword() async {
    final preferences = _preferences;
    final canUseCurrentPassword = preferences?.canUsePassword == true;
    final canUseEmail = preferences?.canUseEmail == true;
    final canUsePasskey =
        preferences?.canUsePasskey == true && _passkeyAvailable;
    if (!canUseCurrentPassword && !canUseEmail && !canUsePasskey) {
      MessageUtils.showWarning(context, '当前账号没有可用的密码验证方式');
      return;
    }

    final result = await showDialog<_PasswordUpdateInput>(
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
      final updatedPreferences =
          await WatchTogetherService.getAccountPreferences();
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

    final result = await showDialog<_PasswordResetInput>(
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除 Passkey'),
        content: Text(
            '确定删除 ${credential.name.isEmpty ? credential.credentialId : credential.name} 吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await WatchTogetherService.deletePasskey(credential.credentialId);
      final passkeys = await WatchTogetherService.listPasskeys();
      final preferences = await WatchTogetherService.getAccountPreferences();
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
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('绑定 Passkey'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: '名称',
            hintText: '例如 MacBook、手机',
            prefixIcon: Icon(Icons.fingerprint_rounded),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('继续'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null) return;

    setState(() => _bindingPasskey = true);
    try {
      final start = await WatchTogetherService.startPasskeyBind(name: name);
      final credential = await PasskeyAuthenticatorService.createCredential(
        start.options,
      );
      await WatchTogetherService.finishPasskeyBind(
        sessionId: start.sessionId,
        credential: credential,
      );
      final results = await Future.wait<dynamic>([
        WatchTogetherService.listPasskeys(),
        WatchTogetherService.getAccountPreferences(),
      ]);
      if (!mounted) return;
      setState(() {
        _passkeys = results[0] as List<PasskeyCredentialInfo>;
        _preferences = results[1] as AccountPreferences;
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
      await WatchTogetherService.markAllNotificationsAsRead();
      await _reloadNotifications();
      if (mounted) MessageUtils.showSuccess(context, '已全部标记为已读');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '操作失败: $e');
    }
  }

  Future<void> _markSelectedRead() async {
    final ids = _selectedNotificationIds.toList(growable: false);
    if (ids.isEmpty) return;

    try {
      await WatchTogetherService.markNotificationsAsRead(ids);
      if (!mounted) return;
      setState(() => _selectedNotificationIds.clear());
      await _reloadNotifications();
      if (mounted) MessageUtils.showSuccess(context, '已标记所选通知');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '标记失败: $e');
    }
  }

  Future<void> _deleteAllRead() async {
    try {
      await WatchTogetherService.deleteAllReadNotifications();
      await _reloadNotifications();
      if (mounted) MessageUtils.showSuccess(context, '已删除已读通知');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '删除失败: $e');
    }
  }

  Future<void> _markRead(UserNotificationItem item) async {
    try {
      await WatchTogetherService.markNotificationAsRead(item);
      if (mounted) {
        setState(() => _selectedNotificationIds.remove(item.numericId));
      }
      await _reloadNotifications();
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '标记失败: $e');
    }
  }

  Future<void> _deleteNotification(UserNotificationItem item) async {
    try {
      await WatchTogetherService.deleteNotification(item);
      if (mounted) {
        setState(() => _selectedNotificationIds.remove(item.numericId));
      }
      await _reloadNotifications();
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '删除失败: $e');
    }
  }

  Future<void> _openNotification(UserNotificationItem item) async {
    UserNotificationItem detail = item;
    try {
      detail = await WatchTogetherService.getNotification(item.numericId);
    } catch (e) {
      if (mounted) {
        MessageUtils.showWarning(context, '加载通知详情失败，显示列表内容: $e');
      }
    }
    if (!mounted) return;

    final action = await showModalBottomSheet<_NotificationDetailAction>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
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

  Future<void> _reloadNotifications({int? page}) async {
    var targetPage = page ?? _notificationPage;
    if (targetPage < 1) targetPage = 1;
    setState(() => _loadingNotifications = true);
    try {
      var notifications = await _fetchNotificationsPage(targetPage);
      var actualPage = targetPage;
      final maxPage = _notificationMaxPage(notifications.total);
      if (targetPage > maxPage) {
        actualPage = maxPage;
        notifications = await _fetchNotificationsPage(actualPage);
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

  Future<UserNotificationsPage> _fetchNotificationsPage(int page) {
    return WatchTogetherService.listNotifications(
      page: page,
      pageSize: _notificationPageSize,
      isRead: _notificationReadFilter,
      notificationType: _notificationTypeFilter,
      search: _notificationSearchController.text.trim(),
      sortBy: _notificationSortBy,
      sortDirection: _notificationSortDirection,
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
      final callbackSession = await OAuth2DeepLinkService.createSession();
      final start = await WatchTogetherService.startOAuth2Bind(
        provider.name,
        redirectUrl: callbackSession.redirectUrl,
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
        await WatchTogetherService.finishOAuth2Bind(
          provider: provider.name,
          code: parsed.code,
          state: parsed.state,
        );
        final linked = await WatchTogetherService.getLinkedOAuth2Accounts();
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
      await WatchTogetherService.unlinkOAuth2Account(account);
      final linked = await WatchTogetherService.getLinkedOAuth2Accounts();
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

  Future<void> _reloadRooms({int? page}) async {
    var targetPage = page ?? _roomsPage;
    if (targetPage < 1) targetPage = 1;
    setState(() => _loadingRooms = true);
    try {
      var rooms = await _fetchRoomsPage(targetPage);
      var actualPage = targetPage;
      final maxPage = _roomsMaxPage(rooms.total);
      if (targetPage > maxPage) {
        actualPage = maxPage;
        rooms = await _fetchRoomsPage(actualPage);
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

  Future<RoomsPage> _fetchRoomsPage(int page) {
    return WatchTogetherService.getMyRoomsPage(
      page: page,
      pageSize: _roomsPageSize,
      search: _roomSearchController.text.trim(),
      relation: _roomRelationFilter,
      sortBy: _roomSortBy,
      sortDirection: client_enum.SortDirection.SORT_DIRECTION_DESC,
    );
  }

  Future<void> _reloadRoomsFromFirstPage() {
    return _reloadRooms(page: 1);
  }

  int _roomsMaxPage(int total) {
    if (total <= 0) return 1;
    return ((total + _roomsPageSize - 1) / _roomsPageSize).ceil();
  }

  Future<void> _openRoom(WRoom room) async {
    try {
      final latest = await WatchTogetherService.getRoomInfo(room.roomId);
      if (!mounted) return;
      final width = MediaQuery.sizeOf(context).width;
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            if (width >= 1100) return DesktopRoomScreen(room: latest);
            if (width >= 700) return LargeScreenRoom(room: latest);
            return WatchTogetherRoomScreen(room: latest);
          },
        ),
      );
      if (mounted) await _reloadRooms();
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '打开房间失败: $e');
    }
  }

  Future<void> _leaveOrDeleteRoom(WRoom room) async {
    final isOwner = _isMyCreatedRoom(room);
    final actionText = isOwner ? '删除房间' : '退出房间';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(actionText),
        content: Text(
          isOwner
              ? '这会永久删除「${room.roomName}」及其房间数据，所有成员都会失去访问权限。'
              : '确定退出「${room.roomName}」吗？退出后需要重新加入才能访问。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: Text(actionText),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      if (isOwner) {
        await WatchTogetherService.deleteRoom(room.roomId);
      } else {
        await WatchTogetherService.leaveRoom(room.roomId);
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('关闭账户'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('此操作会永久关闭当前账户及相关个人数据。'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: '输入 关闭账户 确认',
                prefixIcon: Icon(Icons.warning_amber_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(
              context,
              controller.text.trim() == confirmationText,
            ),
            child: const Text('关闭账户'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (confirmed != true) {
      if (confirmed == false && mounted) {
        MessageUtils.showWarning(context, '确认文本不匹配');
      }
      return;
    }

    try {
      await WatchTogetherService.closeAccount();
      if (!mounted) return;
      MessageUtils.showSuccess(context, '账户已关闭');
      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '关闭账户失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text(
          '账号中心',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: '刷新',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final useRail = constraints.maxWidth >= 900;
          final content = _loading
              ? const Center(child: CircularProgressIndicator())
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
              VerticalDivider(
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
    return TabBarView(
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
          child: Material(
            color: theme.colorScheme.surface,
            child: SafeArea(
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
                          Text(
                            _user.email ?? '未绑定邮箱',
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
                      child: ListView.separated(
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
    return Material(
      color: theme.colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor.withValues(alpha: 0.65),
              ),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
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
        return ListView(
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
    final unread = _notifications?.unreadCount ?? 0;
    final roomCount = rooms?.total ?? 0;
    final activeFactors = preferences == null
        ? 0
        : [
            preferences.canUsePassword,
            preferences.canUseEmail,
            preferences.canUsePasskey,
          ].where((value) => value).length;

    return _responsiveList(
      children: [
        _AccountHero(
          user: _user,
          roleLabel: _userRoleLabel(_user.role),
          statusLabel: _userStatusLabel(_user.status),
          activeServerName: WatchTogetherService.activeServer?.name ?? '当前服务器',
          createdAtLabel: _formatTimestamp(_user.createdAt),
        ),
        if (_loadErrors.isNotEmpty) ...[
          const SizedBox(height: 12),
          _LoadErrorSummary(
            errors: _loadErrors,
            moduleInfo: _moduleInfo,
            onRetry: _load,
          ),
        ],
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 820 ? 4 : 2;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: columns,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: columns == 4 ? 1.75 : 1.95,
              children: [
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
                _MetricTile(
                  icon: _user.emailVerified
                      ? Icons.mark_email_read_rounded
                      : Icons.mark_email_unread_outlined,
                  label: '邮箱状态',
                  value: _user.emailVerified ? '已验证' : '待验证',
                  tone: _user.emailVerified
                      ? const Color(0xFF15803D)
                      : const Color(0xFFB91C1C),
                ),
              ],
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
              final avatar = _ProfileAvatar(username: _user.username, size: 68);
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
                      _StatusPill(
                        icon: _user.emailVerified
                            ? Icons.verified_rounded
                            : Icons.warning_amber_rounded,
                        label: _user.emailVerified ? '邮箱已验证' : '邮箱未验证',
                      ),
                      if (_user.isBanned)
                        const _StatusPill(
                          icon: Icons.block_rounded,
                          label: '已封禁',
                          danger: true,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _user.email ?? '未绑定邮箱',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              );
              final action = FilledButton.icon(
                onPressed: _rename,
                icon: const Icon(Icons.edit_rounded),
                label: const Text('修改用户名'),
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                final twoColumns = constraints.maxWidth >= 720;
                final items = [
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
                  _PreferenceSwitch(
                    title: '房间事件邮件通知',
                    value: notifications.roomEventEmail,
                    onChanged: _savingPreferences
                        ? null
                        : (value) => _updateNotifications(
                              notifications.copyWith(roomEventEmail: value),
                            ),
                  ),
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
                ];
                if (!twoColumns) return Column(children: items);
                return Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    for (final item in items)
                      SizedBox(
                        width: (constraints.maxWidth - 12) / 2,
                        child: item,
                      ),
                  ],
                );
              },
            ),
          )
        else if (_loadError('账号偏好') != null)
          _LoadErrorBanner(
            title: '通知偏好不可用',
            moduleInfo: _moduleInfo['账号偏好'],
            message: _loadError('账号偏好')!,
            onRetry: _load,
          ),
      ],
    );
  }

  Widget _buildRoomsTab(ThemeData theme) {
    final page = _myRooms;
    final loadError = _loadError('房间');
    final rooms = page?.rooms ?? const <WRoom>[];
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
                      if (_loadingRooms)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final wide = constraints.maxWidth >= 760;
                      final search = TextField(
                        controller: _roomSearchController,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          isDense: true,
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _roomSearchController.text.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    _roomSearchController.clear();
                                    _reloadRoomsFromFirstPage();
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                  tooltip: '清除搜索',
                                ),
                          hintText: '搜索房间名称或描述',
                          border: const OutlineInputBorder(),
                        ),
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
                          DropdownButtonHideUnderline(
                            child: DropdownButton<client_enum.MyRoomListSortBy>(
                              value: _roomSortBy,
                              borderRadius: BorderRadius.circular(8),
                              items: const [
                                DropdownMenuItem(
                                  value: client_enum.MyRoomListSortBy
                                      .MY_ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
                                  child: Text('最近活跃'),
                                ),
                                DropdownMenuItem(
                                  value: client_enum.MyRoomListSortBy
                                      .MY_ROOM_LIST_SORT_BY_UPDATED_AT,
                                  child: Text('更新时间'),
                                ),
                                DropdownMenuItem(
                                  value: client_enum.MyRoomListSortBy
                                      .MY_ROOM_LIST_SORT_BY_CREATED_AT,
                                  child: Text('创建时间'),
                                ),
                                DropdownMenuItem(
                                  value: client_enum.MyRoomListSortBy
                                      .MY_ROOM_LIST_SORT_BY_NAME,
                                  child: Text('名称'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() => _roomSortBy = value);
                                _reloadRoomsFromFirstPage();
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: _reloadRooms,
                            icon: const Icon(Icons.refresh_rounded),
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
                  Row(
                    children: [
                      Text(
                        '第 $_roomsPage / $maxPage 页 · $pageStart-$pageEnd / $total',
                        style: TextStyle(color: theme.hintColor),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _loadingRooms || _roomsPage <= 1
                            ? null
                            : () => _reloadRooms(page: _roomsPage - 1),
                        icon: const Icon(Icons.chevron_left_rounded),
                        tooltip: '上一页',
                      ),
                      IconButton(
                        onPressed: _loadingRooms || _roomsPage >= maxPage
                            ? null
                            : () => _reloadRooms(page: _roomsPage + 1),
                        icon: const Icon(Icons.chevron_right_rounded),
                        tooltip: '下一页',
                      ),
                    ],
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
                  ? const Center(child: Text('没有匹配的房间'))
                  : RefreshIndicator(
                      onRefresh: _reloadRooms,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final maxWidth = constraints.maxWidth >= 1180
                              ? 1040.0
                              : constraints.maxWidth >= 760
                                  ? 900.0
                                  : double.infinity;
                          return ListView.separated(
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
                                    onOpen: () => _openRoom(room),
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
    final preferencesError = _loadError('账号偏好');
    final passkeyErrorKey =
        _loadError('Passkey') != null ? 'Passkey' : '本机 Passkey';
    final passkeyError = _loadError(passkeyErrorKey);
    return _responsiveList(
      children: [
        const _SectionHeader(
          title: '账号安全',
          subtitle: '管理登录因素、邮箱验证、Passkey 和高风险账号操作',
          icon: Icons.security_rounded,
        ),
        const SizedBox(height: 12),
        if (preferences != null)
          _Section(
            title: '登录保护',
            subtitle: '多因素认证会在密码之外要求额外验证因素',
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: preferences.twoFactorEnabled,
                  onChanged: _savingPreferences
                      ? null
                      : (value) => _toggleTwoFactor(value),
                  title: const Text('多因素认证'),
                  subtitle: Text(
                    '可用因素：${_factorLabels(preferences).join('、')}',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    _user.emailVerified
                        ? Icons.mark_email_read_rounded
                        : Icons.mark_email_unread_outlined,
                  ),
                  title: const Text('邮箱验证'),
                  subtitle: Text(_user.email ?? '当前账号没有邮箱'),
                  trailing: _user.emailVerified
                      ? const Chip(label: Text('已验证'))
                      : Wrap(
                          spacing: 8,
                          children: [
                            OutlinedButton(
                              onPressed: _sendVerificationEmail,
                              child: const Text('发送'),
                            ),
                            FilledButton(
                              onPressed: _confirmEmail,
                              child: const Text('确认'),
                            ),
                          ],
                        ),
                ),
                const Divider(height: 1),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.password_rounded),
                  title: const Text('登录密码'),
                  subtitle: const Text('通过 OPAQUE 协议更新账号密码'),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: _resetPasswordByEmail,
                        child: const Text('邮件重置'),
                      ),
                      FilledButton(
                        onPressed: _changePassword,
                        child: const Text('修改'),
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
            onRetry: _load,
          ),
        const SizedBox(height: 12),
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
                  FilledButton.tonalIcon(
                    onPressed: _passkeyAvailable && !_bindingPasskey
                        ? _bindPasskey
                        : null,
                    icon: _bindingPasskey
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.add_rounded),
                    label: const Text('绑定'),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () async {
                      final passkeys =
                          await WatchTogetherService.listPasskeys();
                      if (mounted) setState(() => _passkeys = passkeys);
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('刷新'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (passkeyError != null)
                _InlineModuleError(
                  moduleInfo: _moduleInfo[passkeyErrorKey],
                  message: passkeyError,
                  onRetry: _load,
                )
              else if (_passkeys.isEmpty)
                Text('暂无 Passkey', style: TextStyle(color: theme.hintColor))
              else
                for (final credential in _passkeys)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.fingerprint_rounded),
                    title: Text(
                      credential.name.isEmpty ? '未命名 Passkey' : credential.name,
                    ),
                    subtitle: Text(
                      [
                        _shortCredentialId(credential.credentialId),
                        '创建 ${_formatTimestamp(credential.createdAt)}',
                        if (credential.lastUsedAt > 0)
                          '最近使用 ${_formatTimestamp(credential.lastUsedAt)}',
                      ].join(' · '),
                    ),
                    trailing: IconButton(
                      onPressed: () => _deletePasskey(credential),
                      icon: const Icon(Icons.delete_outline_rounded),
                      tooltip: '删除 Passkey',
                    ),
                  ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _Section(
          title: '危险操作',
          subtitle: '这些操作会影响账号可用性或永久删除数据',
          danger: true,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.person_off_rounded,
              color: Colors.red,
            ),
            title: const Text('关闭账户'),
            subtitle: const Text('永久关闭当前账户，并清除本机登录状态'),
            trailing: FilledButton.tonalIcon(
              onPressed: _closeAccount,
              icon: const Icon(Icons.person_remove_rounded),
              label: const Text('关闭'),
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
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  if (_selectedNotificationIds.isNotEmpty) ...[
                    TextButton.icon(
                      onPressed: () =>
                          setState(() => _selectedNotificationIds.clear()),
                      icon: const Icon(Icons.close_rounded),
                      label: Text('已选 ${_selectedNotificationIds.length}'),
                    ),
                    IconButton(
                      onPressed:
                          selectedUnreadCount == 0 ? null : _markSelectedRead,
                      icon: const Icon(Icons.mark_email_read_rounded),
                      tooltip: '标记所选未读通知',
                    ),
                  ] else
                    IconButton(
                      onPressed: unreadSelectableIds.isEmpty
                          ? null
                          : () => setState(() {
                                _selectedNotificationIds
                                  ..clear()
                                  ..addAll(unreadSelectableIds);
                              }),
                      icon: const Icon(Icons.select_all_rounded),
                      tooltip: '选择当前未读通知',
                    ),
                  IconButton(
                    onPressed: items.isEmpty ? null : _markAllRead,
                    icon: const Icon(Icons.done_all_rounded),
                    tooltip: '全部标记为已读',
                  ),
                  IconButton(
                    onPressed: items.isEmpty ? null : _deleteAllRead,
                    icon: const Icon(Icons.delete_sweep_rounded),
                    tooltip: '删除已读通知',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _notificationSearchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  isDense: true,
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _notificationSearchController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _notificationSearchController.clear();
                            _reloadNotificationsFromFirstPage();
                          },
                          icon: const Icon(Icons.close_rounded),
                          tooltip: '清除搜索',
                        ),
                  hintText: '搜索标题或内容',
                  border: const OutlineInputBorder(),
                ),
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
                  DropdownButtonHideUnderline(
                    child: DropdownButton<client_enum.NotificationType?>(
                      value: _notificationTypeFilter,
                      borderRadius: BorderRadius.circular(8),
                      hint: const Text('通知类型'),
                      items: const [
                        DropdownMenuItem(
                          value: null,
                          child: Text('全部类型'),
                        ),
                        DropdownMenuItem(
                          value: client_enum.NotificationType
                              .NOTIFICATION_TYPE_ROOM_INVITATION,
                          child: Text('房间邀请'),
                        ),
                        DropdownMenuItem(
                          value: client_enum.NotificationType
                              .NOTIFICATION_TYPE_SYSTEM_ANNOUNCEMENT,
                          child: Text('系统公告'),
                        ),
                        DropdownMenuItem(
                          value: client_enum
                              .NotificationType.NOTIFICATION_TYPE_ROOM_EVENT,
                          child: Text('房间事件'),
                        ),
                        DropdownMenuItem(
                          value: client_enum.NotificationType
                              .NOTIFICATION_TYPE_PASSWORD_RESET,
                          child: Text('密码重置'),
                        ),
                        DropdownMenuItem(
                          value: client_enum.NotificationType
                              .NOTIFICATION_TYPE_EMAIL_VERIFICATION,
                          child: Text('邮箱验证'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _notificationTypeFilter = value);
                        _reloadNotificationsFromFirstPage();
                      },
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<client_enum.NotificationListSortBy>(
                      value: _notificationSortBy,
                      borderRadius: BorderRadius.circular(8),
                      items: const [
                        DropdownMenuItem(
                          value: client_enum.NotificationListSortBy
                              .NOTIFICATION_LIST_SORT_BY_CREATED_AT,
                          child: Text('创建时间'),
                        ),
                        DropdownMenuItem(
                          value: client_enum.NotificationListSortBy
                              .NOTIFICATION_LIST_SORT_BY_UPDATED_AT,
                          child: Text('更新时间'),
                        ),
                        DropdownMenuItem(
                          value: client_enum.NotificationListSortBy
                              .NOTIFICATION_LIST_SORT_BY_TITLE,
                          child: Text('标题'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _notificationSortBy = value);
                        _reloadNotificationsFromFirstPage();
                      },
                    ),
                  ),
                  IconButton(
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
                    icon: Icon(
                      _notificationSortDirection ==
                              client_enum.SortDirection.SORT_DIRECTION_DESC
                          ? Icons.south_rounded
                          : Icons.north_rounded,
                    ),
                    tooltip: _notificationSortDirection ==
                            client_enum.SortDirection.SORT_DIRECTION_DESC
                        ? '降序'
                        : '升序',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '第 $_notificationPage / $maxPage 页 · $pageStart-$pageEnd',
                    style: TextStyle(color: theme.hintColor),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _loadingNotifications || _notificationPage <= 1
                        ? null
                        : () => _reloadNotifications(
                              page: _notificationPage - 1,
                            ),
                    icon: const Icon(Icons.chevron_left_rounded),
                    tooltip: '上一页',
                  ),
                  IconButton(
                    onPressed:
                        _loadingNotifications || _notificationPage >= maxPage
                            ? null
                            : () => _reloadNotifications(
                                  page: _notificationPage + 1,
                                ),
                    icon: const Icon(Icons.chevron_right_rounded),
                    tooltip: '下一页',
                  ),
                ],
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
                  ? const Center(child: Text('暂无通知'))
                  : RefreshIndicator(
                      onRefresh: _reloadNotifications,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final selected =
                              _selectedNotificationIds.contains(item.numericId);
                          final selectable = item.numericId > 0;
                          return _Section(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              selected: selected,
                              onTap: selected
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
                              leading: Checkbox(
                                value: selected,
                                onChanged: selectable
                                    ? (value) => setState(() {
                                          if (value == true) {
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
                              trailing: Wrap(
                                spacing: 2,
                                children: [
                                  IconButton(
                                    onPressed: selected
                                        ? null
                                        : () => _openNotification(item),
                                    icon: const Icon(Icons.open_in_new_rounded),
                                    tooltip: '查看详情',
                                  ),
                                  if (!item.isRead)
                                    IconButton(
                                      onPressed: selected
                                          ? null
                                          : () => _markRead(item),
                                      icon: const Icon(
                                          Icons.mark_email_read_rounded),
                                      tooltip: '标记已读',
                                    ),
                                  IconButton(
                                    onPressed: selected
                                        ? null
                                        : () => _deleteNotification(item),
                                    icon: const Icon(
                                        Icons.delete_outline_rounded),
                                    tooltip: '删除',
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
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
                  onRetry: _load,
                )
              else if (_linkedOAuth2.isEmpty)
                Text('暂无绑定', style: TextStyle(color: theme.hintColor))
              else
                for (final account in _linkedOAuth2)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.link_rounded),
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
                    trailing: IconButton(
                      onPressed: () => _unlinkOAuth2(account),
                      icon: const Icon(Icons.link_off_rounded),
                      tooltip: '解绑',
                    ),
                  ),
            ],
          ),
        ),
        const SizedBox(height: 12),
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
                  onRetry: _load,
                )
              else if (bindableProviders.isEmpty)
                Text('没有可绑定的 OAuth2 Provider',
                    style: TextStyle(color: theme.hintColor))
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final provider in bindableProviders)
                      OutlinedButton.icon(
                        onPressed: oauth2Available
                            ? () => _startOAuth2Bind(provider)
                            : null,
                        icon: const Icon(Icons.open_in_new_rounded),
                        label: Text('${provider.type} (${provider.name})'),
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
                      child: CircularProgressIndicator(strokeWidth: 2),
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
                  child: TextButton.icon(
                    onPressed: () => setState(() {
                      _bindProvider = null;
                      _bindAttempt++;
                    }),
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('取消绑定'),
                  ),
                ),
              ],
            ],
          ),
        ),
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
          _InfoRow(label: '邮箱', value: _user.email ?? '未绑定'),
          _InfoRow(label: '角色', value: _userRoleLabel(_user.role)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _tabController.animateTo(1),
              icon: const Icon(Icons.person_outline_rounded),
              label: const Text('查看资料'),
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
          _InfoRow(label: 'Passkey', value: '${_passkeys.length} 个'),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _tabController.animateTo(3),
              icon: const Icon(Icons.security_rounded),
              label: const Text('管理安全'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRoomsPanel(ThemeData theme) {
    final rooms = (_myRooms?.rooms ?? const <WRoom>[]).take(3).toList();
    return _Section(
      title: '最近房间',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (rooms.isEmpty)
            Text('暂无房间', style: TextStyle(color: theme.hintColor))
          else
            for (final room in rooms)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.meeting_room_outlined),
                title: Text(
                  room.roomName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(_roomRoleLabel(room.myRole)),
                onTap: () => _openRoom(room),
              ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _tabController.animateTo(2),
              icon: const Icon(Icons.meeting_room_outlined),
              label: const Text('管理房间'),
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

  bool _isMyCreatedRoom(WRoom room) {
    return room.myRelation ==
            client_enum.MyRoomRelation.MY_ROOM_RELATION_CREATED.value ||
        room.myRole ==
            common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR.value ||
        room.creatorId == _user.id;
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
    if (preferences.canUsePasskey) labels.add('Passkey');
    if (preferences.canUseEmail) labels.add('邮箱');
    if (labels.isEmpty) labels.add('无');
    return labels;
  }

  String _notificationType(int type) {
    return switch (type) {
      1 => '房间邀请',
      2 => '系统公告',
      3 => '房间事件',
      4 => '密码重置',
      5 => '邮箱验证',
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
    return AlertDialog(
      title: const Text('修改密码'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SegmentedButton<_PasswordUpdateMethod>(
              segments: methods,
              selected: {_method},
              onSelectionChanged: (selected) {
                setState(() => _method = selected.single);
              },
            ),
            const SizedBox(height: 16),
            if (_method == _PasswordUpdateMethod.currentPassword)
              TextField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '当前密码',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                ),
              ),
            if (_method == _PasswordUpdateMethod.emailToken)
              TextField(
                controller: _emailTokenController,
                decoration: const InputDecoration(
                  labelText: '邮箱验证码',
                  prefixIcon: Icon(Icons.mark_email_read_outlined),
                ),
              ),
            if (_method == _PasswordUpdateMethod.passkey)
              const ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.fingerprint_rounded),
                title: Text('继续后将调用系统 Passkey 验证'),
              ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '新密码',
                prefixIcon: Icon(Icons.lock_reset_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '确认新密码',
                prefixIcon: Icon(Icons.check_circle_outline_rounded),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('保存'),
        ),
      ],
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
      final message = await WatchTogetherService.requestPasswordReset(
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
    return AlertDialog(
      title: const Text('邮件重置密码'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: '邮箱',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    child: Text(
                      widget.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: OutlinedButton(
                    onPressed: _requesting ? null : _requestResetEmail,
                    child: _requesting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('发送'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tokenController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: '重置验证码',
                prefixIcon: Icon(Icons.mark_email_read_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '新密码',
                prefixIcon: Icon(Icons.lock_reset_rounded),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '确认新密码',
                prefixIcon: Icon(Icons.check_circle_outline_rounded),
              ),
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('重置'),
        ),
      ],
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

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.82,
          ),
          child: SingleChildScrollView(
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
                    Chip(label: Text(typeLabel)),
                    Chip(label: Text(notification.isRead ? '已读' : '未读')),
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
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
                      child: OutlinedButton.icon(
                        onPressed: notification.isRead
                            ? null
                            : () => Navigator.pop(
                                  context,
                                  _NotificationDetailAction.markRead,
                                ),
                        icon: const Icon(Icons.mark_email_read_rounded),
                        label: const Text('标记已读'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: () => Navigator.pop(
                          context,
                          _NotificationDetailAction.delete,
                        ),
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: const Text('删除'),
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
        Container(
          width: dense ? 36 : 42,
          height: dense ? 36 : 42,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon,
              color: theme.colorScheme.primary, size: dense ? 20 : 22),
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
    return Material(
      color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: danger
              ? Colors.red.withValues(alpha: 0.38)
              : theme.dividerColor.withValues(alpha: 0.55),
        ),
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
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('全部重试'),
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
            if (entry.key != errors.keys.last) const Divider(height: 16),
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
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('重试'),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withValues(alpha: 0.26)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            moduleInfo?.icon ?? Icons.error_outline_rounded,
            color: Colors.red,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  moduleInfo?.label ?? '模块不可用',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (moduleInfo != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    moduleInfo!.impact,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.70),
                    ),
                  ),
                ],
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
          const SizedBox(width: 10),
          TextButton(
            onPressed: onRetry,
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String username;
  final double size;

  const _ProfileAvatar({required this.username, required this.size});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        username.isEmpty ? '?' : username.characters.first.toUpperCase(),
        style: theme.textTheme.headlineSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool danger;

  const _StatusPill({
    required this.icon,
    required this.label,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = danger ? Colors.red : theme.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
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
    return Material(
      color: selected
          ? theme.colorScheme.primary.withValues(alpha: 0.10)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
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
        ),
      ),
    );
  }
}

class _AccountHero extends StatelessWidget {
  final WUser user;
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
    return Material(
      color: isDark ? const Color(0xFF1C1C1F) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.55)),
      ),
      clipBehavior: Clip.antiAlias,
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
                      const SizedBox(height: 6),
                      Text(
                        user.email ?? '未绑定邮箱',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.66),
                        ),
                      ),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 760 ? 3 : 1;
        final width = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - (columns - 1) * 12) / columns;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final entry in entries)
              SizedBox(
                width: width,
                child: _InfoRow(label: entry.label, value: entry.value),
              ),
          ],
        );
      },
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
          SelectableText(
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
    return FilterChip(
      label: Text(label),
      selected: value == groupValue,
      onSelected: (_) => onSelected(value),
      showCheckmark: false,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _RoomManagementTile extends StatelessWidget {
  final WRoom room;
  final String roleLabel;
  final String relationLabel;
  final String updatedAtLabel;
  final bool isOwner;
  final VoidCallback onOpen;
  final VoidCallback onLeaveOrDelete;

  const _RoomManagementTile({
    required this.room,
    required this.roleLabel,
    required this.relationLabel,
    required this.updatedAtLabel,
    required this.isOwner,
    required this.onOpen,
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
              FilledButton.icon(
                onPressed: onOpen,
                icon: const Icon(Icons.open_in_new_rounded),
                label: const Text('打开'),
              ),
              OutlinedButton.icon(
                onPressed: onLeaveOrDelete,
                icon: Icon(
                  isOwner ? Icons.delete_outline_rounded : Icons.logout_rounded,
                ),
                label: Text(isOwner ? '删除' : '退出'),
              ),
            ],
          );
          if (!wide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title,
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
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      showCheckmark: false,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
