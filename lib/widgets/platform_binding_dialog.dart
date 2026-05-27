import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/services/bilibili_geetest_service.dart';
import 'package:synctv_app/services/smart_grip_service.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/src/generated/proto/providers/bilibili.pbenum.dart'
    as bilibili_enum;
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

enum _ProviderKind { alist, emby, bilibili }

List<String> _mergeInstanceNames(List<String> remoteInstances) {
  final names = <String>[''];
  for (final instance in remoteInstances) {
    final trimmed = instance.trim();
    if (trimmed.isNotEmpty && !names.contains(trimmed)) {
      names.add(trimmed);
    }
  }
  return names;
}

String _providerInstanceLabel(String instanceName) {
  return instanceName.isEmpty ? '本地实例' : instanceName;
}

class PlatformBindingDialog extends StatefulWidget {
  final int initialIndex;

  const PlatformBindingDialog({super.key, this.initialIndex = 0});

  static Future<void> show(BuildContext context, {int initialIndex = 0}) {
    return ChatUtils.showStyledDialog(
      context: context,
      title: '账号绑定',
      icon: Icon(Icons.link_rounded, color: Theme.of(context).primaryColor),
      content: PlatformBindingDialog(initialIndex: initialIndex),
      actions: [],
    );
  }

  @override
  State<PlatformBindingDialog> createState() => _PlatformBindingDialogState();
}

class _PlatformBindingDialogState extends State<PlatformBindingDialog>
    with SingleTickerProviderStateMixin {
  static const _providers = [
    _ProviderSpec(
      kind: _ProviderKind.alist,
      label: 'AList',
      tabLabel: 'AList',
      icon: Icons.cloud_circle_rounded,
      emptyIcon: Icons.cloud_off_rounded,
      color: Colors.amber,
    ),
    _ProviderSpec(
      kind: _ProviderKind.emby,
      label: 'Emby',
      tabLabel: 'Emby',
      icon: Icons.video_library_rounded,
      emptyIcon: Icons.videocam_off_rounded,
      color: Colors.green,
    ),
    _ProviderSpec(
      kind: _ProviderKind.bilibili,
      label: 'Bilibili',
      tabLabel: 'Bilibili',
      icon: Icons.tv_rounded,
      emptyIcon: Icons.live_tv_rounded,
      color: Color(0xFFFB7299),
    ),
  ];

  late TabController _tabController;
  final Map<_ProviderKind, List<_ProviderBindItem>> _binds = {
    for (final provider in _ProviderKind.values) provider: [],
  };
  final Map<_ProviderKind, bool> _loading = {
    for (final provider in _ProviderKind.values) provider: true,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _providers.length,
      vsync: this,
      initialIndex: widget.initialIndex.clamp(0, _providers.length - 1),
    );
    for (final provider in _providers) {
      _loadBinds(provider.kind);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBinds(
    _ProviderKind kind, {
    bool showLoading = true,
  }) async {
    if (!mounted) return;
    if (showLoading) setState(() => _loading[kind] = true);
    try {
      final list = switch (kind) {
        _ProviderKind.alist =>
          (await WatchTogetherService.getAllAlistBindInfos())
              .map(
                (bind) => _ProviderBindItem(
                  id: bind.id,
                  serverId: bind.serverId,
                  instanceName: bind.providerInstanceName,
                  title: bind.host.isNotEmpty ? bind.host : bind.username,
                  subtitle: bind.username,
                ),
              )
              .toList(),
        _ProviderKind.emby => (await WatchTogetherService.getAllEmbyBindInfos())
            .map(
              (bind) => _ProviderBindItem(
                id: bind.id,
                serverId: bind.serverId,
                instanceName: bind.providerInstanceName,
                title: bind.host,
                subtitle: bind.userId,
              ),
            )
            .toList(),
        _ProviderKind.bilibili =>
          (await WatchTogetherService.getAllBilibiliBindInfos())
              .map(
                (bind) => _ProviderBindItem(
                  id: bind.id,
                  serverId: bind.serverId,
                  instanceName: bind.providerInstanceName,
                  title: 'Bilibili 账号',
                  subtitle: bind.id,
                ),
              )
              .toList(),
      };
      if (mounted) setState(() => _binds[kind] = list);
    } catch (e) {
      if (mounted && showLoading) {
        MessageUtils.showError(context, '获取 ${_spec(kind).label} 绑定失败: $e');
      }
    } finally {
      if (mounted && showLoading) setState(() => _loading[kind] = false);
    }
  }

  Future<void> _unbind(_ProviderKind kind, _ProviderBindItem item) async {
    final provider = _spec(kind);
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '确认解绑',
      icon: const Icon(Icons.delete_outline, color: Colors.red),
      content: Text('确定要解除此 ${provider.label} 账号绑定吗？'),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: '解绑',
        ),
      ],
    );

    if (confirm != true) return;

    if (mounted) {
      setState(() {
        _binds[kind]?.removeWhere(
          (bind) =>
              bind.serverId == item.serverId &&
              bind.instanceName == item.instanceName,
        );
      });
    }

    try {
      switch (kind) {
        case _ProviderKind.alist:
          await WatchTogetherService.logoutAList(
            item.serverId,
            instanceName: item.instanceName,
          );
        case _ProviderKind.emby:
          await WatchTogetherService.logoutEmby(
            item.serverId,
            instanceName: item.instanceName,
          );
        case _ProviderKind.bilibili:
          await WatchTogetherService.logoutBilibili(
            instanceName: item.instanceName,
          );
      }
      if (!mounted) return;
      MessageUtils.showSuccess(context, '解绑成功');
      await _loadBinds(kind, showLoading: false);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '解绑失败: $e');
      await _loadBinds(kind, showLoading: false);
    }
  }

  void _showAdd(_ProviderKind kind) {
    final provider = _spec(kind);
    if (kind == _ProviderKind.bilibili) {
      ChatUtils.showStyledDialog(
        context: context,
        title: '登录 Bilibili',
        icon: const Icon(Icons.tv_rounded, color: Color(0xFFFB7299)),
        iconColor: const Color(0xFFFB7299),
        content: _BilibiliLoginDialog(
          instanceNamesLoader: () =>
              WatchTogetherService.listAvailableProviderInstances(
            providerType: _providerType(kind),
          ),
          onSuccess: () => _loadBinds(kind, showLoading: false),
        ),
        actions: [],
      );
      return;
    }

    ChatUtils.showStyledDialog(
      context: context,
      title: '登录 ${provider.label}',
      icon: Icon(provider.icon, color: provider.color),
      iconColor: provider.color,
      content: _PasswordAccountDialog(
        kind: kind,
        instanceNamesLoader: () =>
            WatchTogetherService.listAvailableProviderInstances(
          providerType: _providerType(kind),
        ),
        onSuccess: () => _loadBinds(kind, showLoading: false),
      ),
      actions: [],
    );
  }

  Future<void> _showInfo(_ProviderKind kind, _ProviderBindItem item) async {
    try {
      final provider = _spec(kind);
      final rows = await _loadAccountRows(kind, item);
      if (!mounted) return;
      ChatUtils.showStyledDialog(
        context: context,
        title: '${provider.label} 详情',
        icon: Icon(provider.icon, color: provider.color),
        iconColor: provider.color,
        content: _AccountInfoView(rows: rows),
        actions: [
          ChatUtils.createConfirmButton(
            context,
            () => Navigator.pop(context),
            text: '关闭',
          ),
        ],
      );
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '获取详情失败: $e');
    }
  }

  Future<List<(String, String)>> _loadAccountRows(
    _ProviderKind kind,
    _ProviderBindItem item,
  ) async {
    switch (kind) {
      case _ProviderKind.alist:
        final info = await WatchTogetherService.getAlistAccount(
          item.serverId,
          instanceName: item.instanceName,
        );
        return [
          ('用户名', info.username),
          ('根目录', info.basePath),
          ('服务器', item.serverId),
          ('实例', _providerInstanceLabel(item.instanceName)),
        ];
      case _ProviderKind.emby:
        final info = await WatchTogetherService.getEmbyAccount(
          item.serverId,
          instanceName: item.instanceName,
        );
        return [
          ('用户名', info.name),
          ('用户 ID', info.id),
          ('服务器', item.serverId),
          ('实例', _providerInstanceLabel(item.instanceName)),
        ];
      case _ProviderKind.bilibili:
        final info = await WatchTogetherService.getBilibiliAccount(
          instanceName: item.instanceName,
        );
        return [
          ('登录状态', info.isLogin ? '已登录' : '未登录'),
          ('用户名', info.username),
          ('大会员', info.isVip ? '是' : '否'),
          ('服务器', item.serverId),
          ('实例', _providerInstanceLabel(item.instanceName)),
        ];
    }
  }

  String _providerType(_ProviderKind kind) {
    return switch (kind) {
      _ProviderKind.alist => 'alist',
      _ProviderKind.emby => 'emby',
      _ProviderKind.bilibili => 'bilibili',
    };
  }

  _ProviderSpec _spec(_ProviderKind kind) {
    return _providers.firstWhere((provider) => provider.kind == kind);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 430,
      width: double.maxFinite,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(4),
            child: TabBar(
              controller: _tabController,
              labelColor: isDark ? Colors.white : theme.primaryColor,
              unselectedLabelColor: theme.hintColor,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: theme.scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: [
                for (final provider in _providers) Tab(text: provider.tabLabel),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                for (final provider in _providers)
                  _ProviderBindList(
                    provider: provider,
                    items: _binds[provider.kind] ?? const [],
                    isLoading: _loading[provider.kind] ?? true,
                    onAdd: () => _showAdd(provider.kind),
                    onInfo: (item) => _showInfo(provider.kind, item),
                    onUnbind: (item) => _unbind(provider.kind, item),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderSpec {
  final _ProviderKind kind;
  final String label;
  final String tabLabel;
  final IconData icon;
  final IconData emptyIcon;
  final Color color;

  const _ProviderSpec({
    required this.kind,
    required this.label,
    required this.tabLabel,
    required this.icon,
    required this.emptyIcon,
    required this.color,
  });
}

class _ProviderBindItem {
  final String id;
  final String serverId;
  final String instanceName;
  final String title;
  final String subtitle;

  const _ProviderBindItem({
    required this.id,
    required this.serverId,
    required this.instanceName,
    required this.title,
    required this.subtitle,
  });
}

class _ProviderBindList extends StatelessWidget {
  final _ProviderSpec provider;
  final List<_ProviderBindItem> items;
  final bool isLoading;
  final ValueChanged<_ProviderBindItem> onUnbind;
  final ValueChanged<_ProviderBindItem> onInfo;
  final VoidCallback onAdd;

  const _ProviderBindList({
    required this.provider,
    required this.items,
    required this.isLoading,
    required this.onUnbind,
    required this.onInfo,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Expanded(
          child: items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        provider.emptyIcon,
                        size: 48,
                        color: theme.disabledColor.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '暂无绑定的 ${provider.label} 账号',
                        style: TextStyle(color: theme.hintColor),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final serverId =
                        item.serverId.isNotEmpty ? item.serverId : item.id;
                    final title = _itemTitle(item, serverId);
                    final instanceLabel =
                        _providerInstanceLabel(item.instanceName);
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: provider.color.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(provider.icon, color: provider.color),
                      ),
                      title: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '$instanceLabel · ID: $serverId',
                        style: TextStyle(fontSize: 10, color: theme.hintColor),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.info_outline, size: 20),
                            onPressed: () => onInfo(item),
                            tooltip: '详情',
                            color: theme.primaryColor,
                          ),
                          IconButton(
                            icon: const Icon(Icons.link_off_rounded, size: 20),
                            onPressed: () => onUnbind(item),
                            tooltip: '解绑',
                            color: Colors.redAccent,
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Center(
            child: Material(
              color: provider.color.withValues(alpha: isDark ? 0.18 : 0.12),
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: onAdd,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_rounded, color: provider.color, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '添加 ${provider.label} 账号',
                        style: TextStyle(
                          color: isDark ? Colors.white : provider.color,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _itemTitle(_ProviderBindItem item, String serverId) {
    if (item.title.isNotEmpty) return item.title;
    if (item.subtitle.isNotEmpty) return item.subtitle;
    return '${provider.label} 账号 $serverId';
  }
}

class _PasswordAccountDialog extends StatefulWidget {
  final _ProviderKind kind;
  final Future<List<String>> Function() instanceNamesLoader;
  final VoidCallback onSuccess;

  const _PasswordAccountDialog({
    required this.kind,
    required this.instanceNamesLoader,
    required this.onSuccess,
  });

  @override
  State<_PasswordAccountDialog> createState() => _PasswordAccountDialogState();
}

class _PasswordAccountDialogState extends State<_PasswordAccountDialog> {
  final _hostController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _secretController = TextEditingController();
  final _otpCodeController = TextEditingController();
  final _otpSecretController = TextEditingController();
  List<String> _instanceNames = const [''];
  String _instanceName = '';
  bool _useApiKey = false;
  bool _useHashedPassword = false;
  bool _loadingInstances = true;
  bool _isLoading = false;

  bool get _isAlist => widget.kind == _ProviderKind.alist;
  bool get _isEmby => widget.kind == _ProviderKind.emby;
  String get _label => _isAlist ? 'AList' : 'Emby';

  @override
  void initState() {
    super.initState();
    _loadInstances();
  }

  @override
  void dispose() {
    _hostController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _secretController.dispose();
    _otpCodeController.dispose();
    _otpSecretController.dispose();
    super.dispose();
  }

  Future<void> _loadInstances() async {
    try {
      final remoteInstances = await widget.instanceNamesLoader();
      if (!mounted) return;
      setState(() {
        _instanceNames = _mergeInstanceNames(remoteInstances);
        _instanceName = _instanceNames.first;
        _loadingInstances = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingInstances = false);
      MessageUtils.showError(context, '获取媒体源实例失败: $e');
    }
  }

  Future<void> _submit() async {
    final host = _hostController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final hashedPassword = _secretController.text.trim();
    final apiKey = _secretController.text.trim();
    final otpCode = _otpCodeController.text.trim();
    final otpSecret = _otpSecretController.text.trim();

    if (host.isEmpty ||
        username.isEmpty ||
        (_isEmby && _useApiKey
            ? apiKey.isEmpty
            : _isAlist && _useHashedPassword
                ? hashedPassword.isEmpty
                : password.isEmpty)) {
      MessageUtils.showError(context, '请填写完整信息');
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_isAlist) {
        await WatchTogetherService.loginAList(
          host,
          username,
          _useHashedPassword ? '' : password,
          hashedPassword: _useHashedPassword ? hashedPassword : '',
          otpCode: otpCode,
          otpSecret: otpSecret,
          instanceName: _instanceName,
        );
      } else {
        await WatchTogetherService.loginEmbyInfo(
          host,
          username,
          password,
          apiKey: _useApiKey ? apiKey : '',
          instanceName: _instanceName,
        );
      }
      if (!mounted) return;
      Navigator.pop(context);
      MessageUtils.showSuccess(context, '绑定成功');
      widget.onSuccess();
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '绑定失败: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isAlist)
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: Colors.amber,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '仅支持 AList 3.25.0 及以上版本',
                      style: TextStyle(fontSize: 12, color: Colors.amber),
                    ),
                  ),
                ],
              ),
            ),
          _ProviderInstanceSelector(
            instanceNames: _instanceNames,
            selected: _instanceName,
            loading: _loadingInstances,
            onChanged: (value) => setState(() => _instanceName = value),
          ),
          const SizedBox(height: 16),
          ChatUtils.createFormField(
            context: context,
            label: '$_label 地址',
            controller: _hostController,
            hintText: 'https://example.com',
            prefixIcon: Icons.link_rounded,
          ),
          const SizedBox(height: 16),
          ChatUtils.createFormField(
            context: context,
            label: '用户名',
            controller: _usernameController,
            prefixIcon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 16),
          if (_isAlist) ...[
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: false,
                  icon: Icon(Icons.lock_outline_rounded),
                  label: Text('密码'),
                ),
                ButtonSegment(
                  value: true,
                  icon: Icon(Icons.tag_rounded),
                  label: Text('哈希'),
                ),
              ],
              selected: {_useHashedPassword},
              onSelectionChanged: (selected) => setState(() {
                _useHashedPassword = selected.single;
                _passwordController.clear();
                _secretController.clear();
              }),
            ),
            const SizedBox(height: 16),
          ],
          if (_isEmby) ...[
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: false,
                  icon: Icon(Icons.lock_outline_rounded),
                  label: Text('密码'),
                ),
                ButtonSegment(
                  value: true,
                  icon: Icon(Icons.key_rounded),
                  label: Text('API Key'),
                ),
              ],
              selected: {_useApiKey},
              onSelectionChanged: (selected) =>
                  setState(() => _useApiKey = selected.single),
            ),
            const SizedBox(height: 16),
          ],
          if (_isAlist && _useHashedPassword)
            ChatUtils.createFormField(
              context: context,
              label: '已哈希密码',
              controller: _secretController,
              hintText: 'AList hashed_password',
              prefixIcon: Icons.tag_rounded,
              obscureText: true,
            )
          else if (_useApiKey)
            ChatUtils.createFormField(
              context: context,
              label: 'API Key',
              controller: _secretController,
              prefixIcon: Icons.key_rounded,
              obscureText: true,
            )
          else
            ChatUtils.createFormField(
              context: context,
              label: '密码',
              controller: _passwordController,
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: true,
            ),
          if (_isAlist) ...[
            const SizedBox(height: 16),
            ChatUtils.createFormField(
              context: context,
              label: '一次性验证码',
              controller: _otpCodeController,
              hintText: '启用 2FA 时填写',
              prefixIcon: Icons.pin_outlined,
            ),
            const SizedBox(height: 16),
            ChatUtils.createFormField(
              context: context,
              label: 'TOTP Secret',
              controller: _otpSecretController,
              hintText: '可选，用于后续自动刷新',
              prefixIcon: Icons.shield_outlined,
              obscureText: true,
            ),
          ],
          const SizedBox(height: 24),
          _DialogActions(
            isLoading: _isLoading,
            onSubmit: _submit,
            submitText: '登录',
          ),
        ],
      ),
    );
  }
}

class _BilibiliLoginDialog extends StatefulWidget {
  final Future<List<String>> Function() instanceNamesLoader;
  final VoidCallback onSuccess;

  const _BilibiliLoginDialog({
    required this.instanceNamesLoader,
    required this.onSuccess,
  });

  @override
  State<_BilibiliLoginDialog> createState() => _BilibiliLoginDialogState();
}

class _BilibiliLoginDialogState extends State<_BilibiliLoginDialog> {
  Timer? _pollTimer;
  String _url = '';
  String _key = '';
  String _statusText = '正在创建登录链接...';
  bool _isLoading = true;
  bool _isExpired = false;
  List<String> _instanceNames = const [''];
  String _instanceName = '';
  bool _loadingInstances = true;

  @override
  void initState() {
    super.initState();
    _loadInstances();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadInstances() async {
    try {
      final remoteInstances = await widget.instanceNamesLoader();
      if (!mounted) return;
      setState(() {
        _instanceNames = _mergeInstanceNames(remoteInstances);
        _instanceName = _instanceNames.first;
        _loadingInstances = false;
      });
      await _startLogin();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingInstances = false;
        _statusText = '获取媒体源实例失败: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _startLogin() async {
    _pollTimer?.cancel();
    setState(() {
      _url = '';
      _key = '';
      _statusText = '正在创建登录链接...';
      _isLoading = true;
      _isExpired = false;
    });

    try {
      final response = await WatchTogetherService.startBilibiliQrLogin(
        instanceName: _instanceName,
      );
      if (!mounted) return;
      setState(() {
        _url = response.url;
        _key = response.key;
        _statusText = '请在浏览器或 Bilibili App 中完成登录';
        _isLoading = false;
      });
      _pollTimer = Timer.periodic(
        const Duration(seconds: 2),
        (_) => _checkStatus(),
      );
      await _checkStatus();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _statusText = '创建登录链接失败: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _checkStatus() async {
    if (_key.isEmpty) return;
    try {
      final status = await WatchTogetherService.checkBilibiliQrLogin(
        _key,
        instanceName: _instanceName,
      );
      if (!mounted) return;
      switch (status) {
        case bilibili_enum.QRLoginStatus.QR_LOGIN_STATUS_SUCCESS:
          _pollTimer?.cancel();
          MessageUtils.showSuccess(context, '绑定成功');
          widget.onSuccess();
          Navigator.pop(context);
        case bilibili_enum.QRLoginStatus.QR_LOGIN_STATUS_EXPIRED:
          _pollTimer?.cancel();
          setState(() {
            _statusText = '登录链接已过期，请重新生成';
            _isExpired = true;
          });
        case bilibili_enum.QRLoginStatus.QR_LOGIN_STATUS_SCANNED:
          setState(() => _statusText = '已扫码，请在 Bilibili 中确认登录');
        case bilibili_enum.QRLoginStatus.QR_LOGIN_STATUS_NOT_SCANNED:
          setState(() => _statusText = '等待扫码或打开链接登录');
        case bilibili_enum.QRLoginStatus.QR_LOGIN_STATUS_UNSPECIFIED:
          setState(() => _statusText = '等待 Bilibili 返回登录状态');
      }
    } catch (e) {
      if (mounted) setState(() => _statusText = '检查登录状态失败: $e');
    }
  }

  Future<void> _openLoginUrl() async {
    if (_url.isEmpty) return;
    final uri = Uri.parse(_url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) MessageUtils.showError(context, '无法打开登录链接');
  }

  Future<void> _copyLoginUrl() async {
    if (_url.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: _url));
    if (mounted) MessageUtils.showSuccess(context, '登录链接已复制');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ProviderInstanceSelector(
            instanceNames: _instanceNames,
            selected: _instanceName,
            loading: _loadingInstances,
            onChanged: (value) {
              setState(() {
                _instanceName = value;
              });
              _startLogin();
            },
          ),
          const SizedBox(height: 16),
          DefaultTabController(
            length: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(icon: Icon(Icons.qr_code_2_rounded), text: '扫码'),
                      Tab(icon: Icon(Icons.sms_rounded), text: '验证码'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 430,
                  child: TabBarView(
                    children: [
                      _buildQrLogin(Theme.of(context)),
                      _BilibiliSmsLoginPanel(
                        key: ValueKey(_instanceName),
                        instanceName: _instanceName,
                        onSuccess: () {
                          MessageUtils.showSuccess(context, '绑定成功');
                          widget.onSuccess();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrLogin(ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFB7299).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFFB7299).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                if (_isLoading)
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Icon(
                    _isExpired
                        ? Icons.refresh_rounded
                        : Icons.qr_code_2_rounded,
                    color: const Color(0xFFFB7299),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _statusText,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_url.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: QrImageView(
                        data: _url,
                        version: QrVersions.auto,
                        size: 196,
                        gapless: false,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Colors.black,
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    _url,
                    style: TextStyle(fontSize: 12, color: theme.hintColor),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.end,
            children: [
              _SecondaryActionButton(
                icon: Icons.copy_rounded,
                label: '复制链接',
                onTap: _url.isEmpty ? null : _copyLoginUrl,
              ),
              _SecondaryActionButton(
                icon: Icons.open_in_new_rounded,
                label: '打开登录',
                onTap: _url.isEmpty ? null : _openLoginUrl,
              ),
              if (_isExpired)
                _SecondaryActionButton(
                  icon: Icons.refresh_rounded,
                  label: '重新生成',
                  onTap: _startLogin,
                ),
            ],
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ChatUtils.createCancelButton(context),
          ),
        ],
      ),
    );
  }
}

class _BilibiliSmsLoginPanel extends StatefulWidget {
  final String instanceName;
  final VoidCallback onSuccess;

  const _BilibiliSmsLoginPanel({
    super.key,
    required this.instanceName,
    required this.onSuccess,
  });

  @override
  State<_BilibiliSmsLoginPanel> createState() => _BilibiliSmsLoginPanelState();
}

class _BilibiliSmsLoginPanelState extends State<_BilibiliSmsLoginPanel> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  BilibiliSmsLoginInfo? _session;
  String _statusText = '正在准备安全验证...';
  bool _starting = true;
  bool _sending = false;
  bool _loggingIn = false;
  bool _smsSent = false;

  bool get _busy => _starting || _sending || _loggingIn;

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _startSession() async {
    setState(() {
      _starting = true;
      _smsSent = false;
      _session = null;
      _statusText = '正在准备安全验证...';
    });
    try {
      final session = await WatchTogetherService.startBilibiliSmsLogin(
        instanceName: widget.instanceName,
      );
      if (!mounted) return;
      setState(() {
        _session = session;
        _starting = false;
        _statusText = '输入手机号后完成安全验证，即可发送短信验证码';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _starting = false;
        _statusText = '安全验证准备失败: $e';
      });
    }
  }

  Future<void> _sendSms() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      MessageUtils.showWarning(context, '请输入手机号');
      return;
    }
    var session = _session;
    if (session == null) {
      await _startSession();
      if (!mounted) return;
      session = _session;
    }
    if (session == null) return;

    setState(() {
      _sending = true;
      _statusText = '请完成 Bilibili 安全验证';
    });

    try {
      final result = await BilibiliGeetestService.verify(
        context,
        gt: session.gt,
        challenge: session.challenge,
      );
      await WatchTogetherService.sendBilibiliSms(
        sessionId: session.sessionId,
        phone: phone,
        validate: result.validate,
      );
      if (!mounted) return;
      setState(() {
        _sending = false;
        _smsSent = true;
        _statusText = '短信验证码已发送';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _sending = false;
        _statusText = '短信发送失败: $e';
      });
    }
  }

  Future<void> _login() async {
    final session = _session;
    final code = _codeController.text.trim();
    if (session == null) {
      MessageUtils.showWarning(context, '请先发送短信验证码');
      return;
    }
    if (code.isEmpty) {
      MessageUtils.showWarning(context, '请输入短信验证码');
      return;
    }

    setState(() {
      _loggingIn = true;
      _statusText = '正在绑定 Bilibili 账号...';
    });
    try {
      await WatchTogetherService.loginBilibiliSms(
        sessionId: session.sessionId,
        code: code,
      );
      if (!mounted) return;
      widget.onSuccess();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loggingIn = false;
        _statusText = '绑定失败: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFB7299).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFFB7299).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                if (_busy)
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  const Icon(Icons.sms_rounded, color: Color(0xFFFB7299)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _statusText,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ChatUtils.createFormField(
            context: context,
            label: '手机号',
            controller: _phoneController,
            hintText: '请输入 Bilibili 绑定手机号',
            prefixIcon: Icons.phone_iphone_rounded,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 14),
          ChatUtils.createFormField(
            context: context,
            label: '短信验证码',
            controller: _codeController,
            hintText: _smsSent ? '请输入收到的验证码' : '发送短信后填写验证码',
            prefixIcon: Icons.pin_rounded,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.end,
            children: [
              _SecondaryActionButton(
                icon: Icons.refresh_rounded,
                label: '重新验证',
                onTap: _busy ? null : _startSession,
              ),
              _SecondaryActionButton(
                icon: Icons.send_to_mobile_rounded,
                label: '发送短信',
                onTap: _busy ? null : _sendSms,
              ),
              FilledButton.icon(
                onPressed: _busy ? null : _login,
                icon: _loggingIn
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.onPrimary,
                        ),
                      )
                    : const Icon(Icons.login_rounded),
                label: const Text('绑定'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: ChatUtils.createCancelButton(context),
          ),
        ],
      ),
    );
  }
}

class _ProviderInstanceSelector extends StatelessWidget {
  final List<String> instanceNames;
  final String selected;
  final bool loading;
  final ValueChanged<String> onChanged;

  const _ProviderInstanceSelector({
    required this.instanceNames,
    required this.selected,
    required this.loading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final value = instanceNames.contains(selected)
        ? selected
        : (instanceNames.isEmpty ? '' : instanceNames.first);
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: '媒体源实例',
        prefixIcon: loading
            ? const Padding(
                padding: EdgeInsets.all(14),
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : const Icon(Icons.account_tree_rounded),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        isDense: true,
      ),
      items: [
        for (final instanceName in instanceNames)
          DropdownMenuItem(
            value: instanceName,
            child: Text(
              _providerInstanceLabel(instanceName),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: loading ? null : (value) => onChanged(value ?? ''),
    );
  }
}

class _AccountInfoView extends StatelessWidget {
  final List<(String, String)> rows;

  const _AccountInfoView({
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final row in rows) ...[
          _InfoRow(label: row.$1, value: row.$2),
          const SizedBox(height: 10),
        ],
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(label, style: TextStyle(color: theme.hintColor)),
        ),
        Expanded(
          child: SelectableText(
            value.isEmpty ? '-' : value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _DialogActions extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSubmit;
  final String submitText;

  const _DialogActions({
    required this.isLoading,
    required this.onSubmit,
    required this.submitText,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SmartGripStatus>(
      stream: SmartGripService().onStatusChanged,
      initialData: SmartGripService().currentStatus,
      builder: (context, snapshot) {
        final isLeftHand = snapshot.data == SmartGripStatus.leftHand;
        final actions = [
          ChatUtils.createCancelButton(context),
          const SizedBox(width: 8),
          isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : ChatUtils.createConfirmButton(
                  context,
                  onSubmit,
                  text: submitText,
                ),
        ];
        return Row(
          mainAxisAlignment:
              isLeftHand ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: isLeftHand ? actions.reversed.toList() : actions,
        );
      },
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _SecondaryActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final theme = Theme.of(context);
    return Material(
      color: enabled
          ? theme.primaryColor.withValues(alpha: 0.08)
          : theme.disabledColor.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: enabled ? theme.primaryColor : theme.disabledColor,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: enabled ? theme.primaryColor : theme.disabledColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
