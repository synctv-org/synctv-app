import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:synctv_app/models/account_models.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/oauth2_deep_link_service.dart';
import 'package:synctv_app/services/opaque_authenticator_service.dart';
import 'package:synctv_app/services/passkey_authenticator_service.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/utils/message_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountCenterPage extends StatefulWidget {
  final WUser initialUser;

  const AccountCenterPage({super.key, required this.initialUser});

  @override
  State<AccountCenterPage> createState() => _AccountCenterPageState();
}

class _AccountCenterPageState extends State<AccountCenterPage>
    with SingleTickerProviderStateMixin {
  static const int _notificationPageSize = 50;

  late TabController _tabController;
  late WUser _user;
  AccountPreferences? _preferences;
  UserNotificationsPage? _notifications;
  List<OAuth2ProviderOption> _availableOAuth2 = const [];
  List<OAuth2LinkedAccount> _linkedOAuth2 = const [];
  List<PasskeyCredentialInfo> _passkeys = const [];
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
  final Set<int> _selectedNotificationIds = <int>{};
  final TextEditingController _notificationSearchController =
      TextEditingController();
  late final OpaqueAuthenticatorService _opaqueAuthenticator;

  @override
  void initState() {
    super.initState();
    _user = widget.initialUser;
    _tabController = TabController(length: 4, vsync: this);
    _opaqueAuthenticator = OpaqueAuthenticatorService();
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _notificationSearchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait<dynamic>([
        WatchTogetherService.getMe(),
        WatchTogetherService.getAccountPreferences(),
        WatchTogetherService.listNotifications(
          page: _notificationPage,
          pageSize: _notificationPageSize,
        ),
        WatchTogetherService.listOAuth2Providers(),
        WatchTogetherService.getLinkedOAuth2Accounts(),
        WatchTogetherService.listPasskeys(),
        PasskeyAuthenticatorService.isSupported().catchError((_) => false),
      ]);
      if (!mounted) return;
      setState(() {
        _user = results[0] as WUser;
        _preferences = results[1] as AccountPreferences;
        _notifications = results[2] as UserNotificationsPage;
        _availableOAuth2 = results[3] as List<OAuth2ProviderOption>;
        _linkedOAuth2 = results[4] as List<OAuth2LinkedAccount>;
        _passkeys = results[5] as List<PasskeyCredentialInfo>;
        _passkeyAvailable = results[6] as bool;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      MessageUtils.showError(context, '加载账号信息失败: $e');
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
        final visibleIds = notifications.notifications
            .map((item) => item.numericId)
            .where((id) => id > 0)
            .toSet();
        _selectedNotificationIds.removeWhere((id) => !visibleIds.contains(id));
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingNotifications = false);
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
      setState(() => _linkedOAuth2 = linked);
      MessageUtils.showSuccess(context, '已解除绑定');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '解绑失败: $e');
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('账号中心'),
        actions: [
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: '刷新',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '资料'),
            Tab(text: '安全'),
            Tab(text: '通知'),
            Tab(text: '绑定'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildProfileTab(theme),
                _buildSecurityTab(theme),
                _buildNotificationsTab(theme),
                _buildBindingsTab(theme),
              ],
            ),
    );
  }

  Widget _buildProfileTab(ThemeData theme) {
    final preferences = _preferences;
    final notifications =
        preferences?.notifications ?? NotificationPreferences.defaults();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Section(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              radius: 26,
              child: Text(
                _user.username.isEmpty ? '?' : _user.username[0].toUpperCase(),
              ),
            ),
            title: Text(
              _user.username,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              [
                _user.email ?? '未绑定邮箱',
                if (_user.email != null) _user.emailVerified ? '已验证' : '未验证',
              ].join(' · '),
            ),
            trailing: IconButton(
              onPressed: _rename,
              icon: const Icon(Icons.edit_rounded),
              tooltip: '修改用户名',
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (preferences != null)
          _Section(
            child: Column(
              children: [
                _PreferenceSwitch(
                  title: '房间邀请站内通知',
                  value: notifications.roomInvitationInApp,
                  onChanged: _savingPreferences
                      ? null
                      : (value) => _updateNotifications(
                            notifications.copyWith(roomInvitationInApp: value),
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
                                systemAnnouncementInApp: value),
                          ),
                ),
                _PreferenceSwitch(
                  title: '房间邀请邮件通知',
                  value: notifications.roomInvitationEmail,
                  onChanged: _savingPreferences
                      ? null
                      : (value) => _updateNotifications(
                            notifications.copyWith(roomInvitationEmail: value),
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
                                systemAnnouncementEmail: value),
                          ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSecurityTab(ThemeData theme) {
    final preferences = _preferences;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (preferences != null)
          _Section(
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
          ),
        const SizedBox(height: 12),
        _Section(
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
        const SizedBox(height: 12),
        _Section(
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
              if (_passkeys.isEmpty)
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
      ],
    );
  }

  Widget _buildNotificationsTab(ThemeData theme) {
    final page = _notifications;
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
          child: items.isEmpty
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
                                  onPressed:
                                      selected ? null : () => _markRead(item),
                                  icon:
                                      const Icon(Icons.mark_email_read_rounded),
                                  tooltip: '标记已读',
                                ),
                              IconButton(
                                onPressed: selected
                                    ? null
                                    : () => _deleteNotification(item),
                                icon: const Icon(Icons.delete_outline_rounded),
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
              if (_linkedOAuth2.isEmpty)
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
              if (bindableProviders.isEmpty)
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

class _Section extends StatelessWidget {
  final Widget child;

  const _Section({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
      ),
      child: child,
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
