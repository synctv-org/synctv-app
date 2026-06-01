import 'dart:async';
import 'package:flutter/material.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/pages/desktop/desktop_room_screen.dart';
//import 'package:synctv_app/widgets/watch_together_admin_settings.dart';
import 'package:synctv_app/pages/mobile/admin_settings_page.dart';
import 'package:synctv_app/pages/account_center_page.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/widgets/cinema_room_card.dart';
import 'package:synctv_app/widgets/create_room_dialog.dart';
import 'package:synctv_app/widgets/join_room_dialog.dart';
import 'package:synctv_app/widgets/room_invite_flow.dart';
import 'package:synctv_app/widgets/server_settings_dialog.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;

import 'package:synctv_app/widgets/auth_panel.dart';

enum _RoomFeed { public, mine, hot }

class DesktopHomeScreen extends StatefulWidget {
  const DesktopHomeScreen({super.key});

  @override
  State<DesktopHomeScreen> createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends State<DesktopHomeScreen> {
  bool _isLoading = true;
  List<WRoom> _rooms = [];
  int _roomsTotal = 0;
  int _roomPage = 1;
  static const int _roomPageSize = 24;
  _RoomFeed _roomFeed = _RoomFeed.public;
  bool _isLoggedIn = false;
  WUser? _currentUser;
  StreamSubscription? _authErrorSubscription;
  final Set<String> _joiningRoomIds = <String>{};
  final TextEditingController _roomSearchController = TextEditingController();
  bool _modalOpen = false;

  @override
  void initState() {
    super.initState();
    _authErrorSubscription = WatchTogetherService.onAuthError.listen((_) {
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _currentUser = null;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showLoginDialog();
        });
      }
    });
    _checkLoginAndLoadData();
  }

  @override
  void dispose() {
    _authErrorSubscription?.cancel();
    _roomSearchController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final user = await WatchTogetherService.getMe();
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      // Ignore
    }
  }

  Future<void> _checkLoginAndLoadData() async {
    final hasSession = WatchTogetherService.hasRecoverableSession;
    if (!hasSession) {
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _isLoading = false;
        });
        _loadRooms(silent: false);
      }
    } else {
      setState(() {
        _isLoggedIn = true;
      });
      _loadRooms(silent: false);
      await _fetchUserInfo();
    }
  }

  Future<void> _loadRooms({bool silent = false}) async {
    if (WatchTogetherService.activeServer == null) {
      if (mounted) {
        setState(() {
          _rooms = const [];
          _roomsTotal = 0;
          _isLoading = false;
        });
      }
      return;
    }
    if (!_isLoggedIn && _roomFeed == _RoomFeed.mine) {
      setState(() {
        _rooms = const [];
        _roomsTotal = 0;
        _isLoading = false;
      });
      return;
    }

    if (!silent) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      final search = _roomSearchController.text.trim();
      final List<WRoom> rooms;
      final int total;
      switch (_roomFeed) {
        case _RoomFeed.public:
          final page = await WatchTogetherService.getRoomsPage(
            page: _roomPage,
            pageSize: _roomPageSize,
            search: search.isEmpty ? null : search,
            sortBy:
                client_enum.RoomListSortBy.ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
            sortDirection: client_enum.SortDirection.SORT_DIRECTION_DESC,
          );
          rooms = page.rooms;
          total = page.total;
          break;
        case _RoomFeed.mine:
          final page = await WatchTogetherService.getMyRoomsPage(
            page: _roomPage,
            pageSize: _roomPageSize,
            search: search.isEmpty ? null : search,
            relation: client_enum.MyRoomRelation.MY_ROOM_RELATION_ALL,
            sortBy: client_enum
                .MyRoomListSortBy.MY_ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
            sortDirection: client_enum.SortDirection.SORT_DIRECTION_DESC,
          );
          rooms = page.rooms;
          total = page.total;
          break;
        case _RoomFeed.hot:
          rooms = await WatchTogetherService.getHotRooms(limit: _roomPageSize);
          total = rooms.length;
          break;
      }

      if (mounted) {
        setState(() {
          _rooms = rooms;
          _roomsTotal = total;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        MessageUtils.showError(context, '加载房间列表失败: $e');
      }
    }
  }

  int get _roomPageCount =>
      _roomsTotal <= 0 ? 1 : ((_roomsTotal - 1) ~/ _roomPageSize) + 1;

  void _setRoomFeed(_RoomFeed feed) {
    if (!_isLoggedIn && feed == _RoomFeed.mine) {
      _showLoginDialog();
      return;
    }
    if (_roomFeed == feed) return;
    setState(() {
      _roomFeed = feed;
      _roomPage = 1;
    });
    _loadRooms(silent: false);
  }

  void _applyRoomSearch(String value) {
    setState(() => _roomPage = 1);
    _loadRooms(silent: false);
  }

  void _goRoomPage(int page) {
    final next = page.clamp(1, _roomPageCount);
    if (next == _roomPage) return;
    setState(() => _roomPage = next);
    _loadRooms(silent: false);
  }

  Future<bool> _showLoginDialog({String? guestRoomId}) async {
    if (_modalOpen) return false;
    _modalOpen = true;
    final bool? result;
    try {
      result = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withValues(alpha: 0.48),
        builder: (context) => AuthPanel(initialGuestRoomId: guestRoomId),
      );
    } finally {
      _modalOpen = false;
    }
    if (result == true) {
      if (mounted) {
        setState(() {
          _isLoggedIn = true;
        });
        _loadRooms(silent: false);
        _fetchUserInfo();
      }
      return true;
    }
    if (mounted) setState(() => _isLoading = false);
    return false;
  }

  void _showCreateRoomDialog() {
    if (_modalOpen) return;
    _modalOpen = true;
    () async {
      try {
        await showCreateRoomDialog(
          context: context,
          width: 300,
          onCreated: (room) async {
            if (mounted) {
              _handleJoinRoom(room);
            }
          },
        );
      } finally {
        _modalOpen = false;
      }
    }();
  }

  void _showJoinRoomDialog() {
    if (_modalOpen) return;
    _modalOpen = true;
    () async {
      try {
        await showJoinRoomDialog(
          context: context,
          onSubmitted: _joinRoomById,
        );
      } finally {
        _modalOpen = false;
      }
    }();
  }

  Future<void> _joinRoomById(String value) async {
    if (value.trim().isEmpty) {
      MessageUtils.showWarning(context, '请输入房间ID');
      return;
    }
    try {
      final id = await parseInviteOrShowError(context: context, value: value);
      if (id == null || id.isEmpty) return;
      final check = await WatchTogetherService.checkRoom(id);
      if (!check.exists) {
        if (mounted) MessageUtils.showWarning(context, '房间不存在');
        return;
      }
      if (!check.isAvailable) {
        if (mounted) MessageUtils.showWarning(context, '房间暂不可用');
        return;
      }
      if (!_isLoggedIn) {
        final authenticated = await _showLoginDialog(guestRoomId: id);
        if (!authenticated || !mounted) return;
      }
      final room = await WatchTogetherService.getRoomInfo(id);
      if (!mounted) return;
      Navigator.pop(context);
      _handleJoinRoom(room);
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '查找房间失败: $e');
    }
  }

  void _showAdminSettingsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AdminSettingsPage(),
      ),
    ).then((_) {
      _loadRooms(silent: true);
    });
  }

  void _showAccountCenter() {
    final user = _currentUser;
    if (user == null) return;
    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AccountCenterPage(initialUser: user),
      ),
    ).then((accountClosed) {
      if (accountClosed == true) {
        setState(() {
          _isLoggedIn = false;
          _currentUser = null;
          _rooms = [];
          _roomsTotal = 0;
        });
      } else {
        _fetchUserInfo();
      }
    });
  }

  void _showServerSettingsDialog() {
    if (_modalOpen) return;
    _modalOpen = true;
    () async {
      try {
        final changed = await showServerSettingsDialog(context: context);
        if (!mounted || changed != true) return;
        final hasSession = WatchTogetherService.hasRecoverableSession;
        setState(() {
          _isLoggedIn = hasSession;
          if (!hasSession) _currentUser = null;
          _roomPage = 1;
        });
        _loadRooms(silent: false);
        if (hasSession) _fetchUserInfo();
      } finally {
        _modalOpen = false;
      }
    }();
  }

  Future<void> _handleLogout() async {
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '退出登录',
      icon: const Icon(Icons.logout, color: Colors.red),
      content: const Text('确定要退出当前账号吗？'),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
            context, () => Navigator.pop(context, true),
            text: '退出'),
      ],
    );

    if (confirm == true) {
      await WatchTogetherService.logout();
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _currentUser = null;
          _rooms = [];
          _roomsTotal = 0;
          _roomFeed = _RoomFeed.public;
          _roomPage = 1;
        });
        MessageUtils.showSuccess(context, '已退出登录');
        _loadRooms(silent: false);
      }
    }
  }

  Future<void> _handleJoinRoom(WRoom room) async {
    if (_joiningRoomIds.contains(room.roomId)) return;
    _joiningRoomIds.add(room.roomId);
    String password = '';

    try {
      if (!_isLoggedIn) {
        final authenticated = await _showLoginDialog(guestRoomId: room.roomId);
        if (!authenticated || !mounted) return;
      }

      if (room.needPassword) {
        final result = await showRoomPasswordDialog(
          context: context,
          roomName: room.roomName,
        );

        if (result == null) return;
        if (result.isEmpty) {
          if (mounted) MessageUtils.showWarning(context, '请输入密码');
          return;
        }
        password = result;
      }

      await WatchTogetherService.joinRoom(room.roomId, password);
      if (mounted) {
        _navigateToRoom(room);
      }
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加入房间失败: $e');
    } finally {
      _joiningRoomIds.remove(room.roomId);
    }
  }

  void _navigateToRoom(WRoom room) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: true,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) =>
            DesktopRoomScreen(room: room),
      ),
    );
  }

  Future<void> _handleDeleteRoom(WRoom room) async {
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '删除房间',
      icon: const Icon(Icons.delete_outline, color: Colors.red),
      content: Text('确定要删除房间 "${room.roomName}" 吗？此操作不可撤销。'),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
            context, () => Navigator.pop(context, true),
            text: '删除'),
      ],
    );

    if (confirm == true) {
      try {
        await WatchTogetherService.deleteRoom(room.roomId);
        if (mounted) {
          MessageUtils.showSuccess(context, '房间已删除');
          _loadRooms(silent: true);
        }
      } catch (e) {
        if (mounted) MessageUtils.showError(context, '删除失败: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAdmin =
        _currentUser?.role == common_enum.UserRole.USER_ROLE_ROOT.value ||
            _currentUser?.role == common_enum.UserRole.USER_ROLE_ADMIN.value;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: Material(
          color: theme.appBarTheme.backgroundColor,
          elevation: 0,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 760;
              final extraCompact = constraints.maxWidth < 560;
              final horizontalPadding = compact ? 16.0 : 28.0;
              return Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: Row(
                        children: [
                          GestureDetector(
                            onLongPress: _showServerSettingsDialog,
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.live_tv_rounded,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                if (!extraCompact) ...[
                                  const SizedBox(width: 12),
                                  Text(
                                    '看搭子',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF111827),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const Spacer(),
                          if (!_isLoggedIn && compact)
                            FilledButton.tonalIcon(
                              onPressed: _showServerSettingsDialog,
                              icon: const Icon(Icons.dns_rounded, size: 18),
                              label: const Text('服务器'),
                            )
                          else
                            IconButton.filledTonal(
                              tooltip: '服务器设置',
                              onPressed: _showServerSettingsDialog,
                              icon: const Icon(Icons.dns_rounded),
                            ),
                          SizedBox(width: compact ? 8 : 12),
                          if (_isLoggedIn) ...[
                            if (compact)
                              IconButton.filledTonal(
                                tooltip: '加入房间',
                                onPressed: _showJoinRoomDialog,
                                icon: const Icon(Icons.login_rounded),
                              )
                            else
                              OutlinedButton.icon(
                                onPressed: _showJoinRoomDialog,
                                icon: const Icon(Icons.login_rounded, size: 18),
                                label: const Text('加入房间'),
                              ),
                            SizedBox(width: compact ? 8 : 10),
                            if (compact)
                              IconButton.filled(
                                tooltip: '创建房间',
                                onPressed: _showCreateRoomDialog,
                                icon: const Icon(Icons.add_rounded),
                              )
                            else
                              FilledButton.icon(
                                onPressed: _showCreateRoomDialog,
                                icon: const Icon(Icons.add_rounded, size: 18),
                                label: const Text('创建房间'),
                              ),
                            SizedBox(width: compact ? 8 : 12),
                            compact
                                ? _buildCompactAccountMenu(theme, isAdmin)
                                : _buildAccountMenu(theme, isAdmin, isDark),
                          ] else if (compact)
                            FilledButton.icon(
                              onPressed: _showLoginDialog,
                              icon: const Icon(Icons.login_rounded, size: 18),
                              label: const Text('登录'),
                            )
                          else
                            FilledButton.icon(
                              onPressed: _showLoginDialog,
                              icon: const Icon(Icons.login_rounded, size: 18),
                              label: const Text('登录'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                children: [
                  _buildRoomControls(theme),
                  const SizedBox(height: 14),
                  Expanded(child: _buildRoomGrid()),
                ],
              ),
            ),
    );
  }

  Widget _buildCompactAccountMenu(ThemeData theme, bool isAdmin) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 46),
      tooltip: '账号菜单',
      child: CircleAvatar(
        radius: 18,
        backgroundColor: theme.colorScheme.primary,
        child: Text(
          _currentUser?.username.isNotEmpty == true
              ? _currentUser!.username[0].toUpperCase()
              : '?',
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'account',
          child: Row(
            children: [
              Icon(Icons.account_circle_rounded, size: 18),
              SizedBox(width: 8),
              Text('账号中心'),
            ],
          ),
        ),
        if (isAdmin)
          const PopupMenuItem(
            value: 'admin',
            child: Row(
              children: [
                Icon(Icons.admin_panel_settings_rounded, size: 18),
                SizedBox(width: 8),
                Text('管理员设置'),
              ],
            ),
          ),
        const PopupMenuItem(
          value: 'server',
          child: Row(
            children: [
              Icon(Icons.dns_rounded, size: 18),
              SizedBox(width: 8),
              Text('服务器设置'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout_rounded, color: Colors.red, size: 18),
              SizedBox(width: 8),
              Text('退出登录', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'account':
            _showAccountCenter();
            break;
          case 'admin':
            _showAdminSettingsPage();
            break;
          case 'server':
            _showServerSettingsDialog();
            break;
          case 'logout':
            _handleLogout();
            break;
        }
      },
    );
  }

  Widget _buildAccountMenu(ThemeData theme, bool isAdmin, bool isDark) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 46),
      tooltip: '账号菜单',
      child: Material(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.7)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  _currentUser?.username.isNotEmpty == true
                      ? _currentUser!.username[0].toUpperCase()
                      : '?',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 140),
                child: Text(
                  _currentUser?.username ?? 'User',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.expand_more_rounded, size: 18),
            ],
          ),
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'account',
          child: Row(
            children: [
              Icon(Icons.account_circle_rounded, size: 18),
              SizedBox(width: 8),
              Text('账号中心'),
            ],
          ),
        ),
        if (isAdmin)
          const PopupMenuItem(
            value: 'admin',
            child: Row(
              children: [
                Icon(Icons.admin_panel_settings_rounded, size: 18),
                SizedBox(width: 8),
                Text('管理员设置'),
              ],
            ),
          ),
        const PopupMenuItem(
          value: 'server',
          child: Row(
            children: [
              Icon(Icons.dns_rounded, size: 18),
              SizedBox(width: 8),
              Text('服务器设置'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout_rounded, color: Colors.red, size: 18),
              SizedBox(width: 8),
              Text('退出登录', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'account':
            _showAccountCenter();
            break;
          case 'admin':
            _showAdminSettingsPage();
            break;
          case 'server':
            _showServerSettingsDialog();
            break;
          case 'logout':
            _handleLogout();
            break;
        }
      },
    );
  }

  Widget _buildRoomControls(ThemeData theme) {
    final supportsPaging = _roomFeed != _RoomFeed.hot;
    final summary = supportsPaging
        ? '共 $_roomsTotal 个房间 · 第 $_roomPage / $_roomPageCount 页'
        : '显示 ${_rooms.length} 个热门房间';

    return Material(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.7)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SegmentedButton<_RoomFeed>(
                    segments: const [
                      ButtonSegment(
                        value: _RoomFeed.public,
                        icon: Icon(Icons.public_rounded),
                        label: Text('公开'),
                      ),
                      ButtonSegment(
                        value: _RoomFeed.mine,
                        icon: Icon(Icons.video_library_rounded),
                        label: Text('我的'),
                      ),
                      ButtonSegment(
                        value: _RoomFeed.hot,
                        icon: Icon(Icons.local_fire_department_rounded),
                        label: Text('热门'),
                      ),
                    ],
                    selected: {_roomFeed},
                    onSelectionChanged: (value) => _setRoomFeed(value.first),
                  ),
                  SizedBox(
                    width: 320,
                    child: TextField(
                      controller: _roomSearchController,
                      enabled: _roomFeed != _RoomFeed.hot,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _roomSearchController.text.isEmpty
                            ? null
                            : IconButton(
                                tooltip: '清空',
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _roomSearchController.clear();
                                  _applyRoomSearch('');
                                },
                              ),
                        hintText:
                            _roomFeed == _RoomFeed.hot ? '热门房间不支持搜索' : '搜索房间',
                      ),
                      onSubmitted: _applyRoomSearch,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              summary,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.68),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filledTonal(
              tooltip: '刷新',
              onPressed: () => _loadRooms(silent: false),
              icon: const Icon(Icons.refresh_rounded),
            ),
            if (supportsPaging) ...[
              IconButton(
                tooltip: '上一页',
                onPressed:
                    _roomPage <= 1 ? null : () => _goRoomPage(_roomPage - 1),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              IconButton(
                tooltip: '下一页',
                onPressed: _roomPage >= _roomPageCount
                    ? null
                    : () => _goRoomPage(_roomPage + 1),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRoomGrid() {
    final theme = Theme.of(context);
    final hasServer = WatchTogetherService.activeServer != null;
    return Material(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.7)),
      ),
      clipBehavior: Clip.antiAlias,
      child: _rooms.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    hasServer ? Icons.meeting_room_outlined : Icons.dns_rounded,
                    size: 56,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    hasServer ? '暂无房间' : '添加服务器后开始使用',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hasServer
                        ? (_roomFeed == _RoomFeed.mine
                            ? '加入或创建房间后会出现在这里'
                            : '当前筛选下没有可显示的房间')
                        : '输入服务器地址即可浏览公开房间、登录账号和加入观影房间。',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.58),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.tonalIcon(
                    onPressed: hasServer
                        ? () => _loadRooms(silent: false)
                        : _showServerSettingsDialog,
                    icon: Icon(
                        hasServer ? Icons.refresh_rounded : Icons.add_link),
                    label: Text(hasServer ? '刷新' : '添加服务器'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async => await _loadRooms(silent: true),
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 380,
                  childAspectRatio: 1.35,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _rooms.length,
                itemBuilder: (context, index) =>
                    _buildRoomCard(_rooms[index], index),
              ),
            ),
    );
  }

  Widget _buildRoomCard(WRoom room, int index) {
    return CinemaRoomCard(
      roomId: room.roomId,
      roomName: room.roomName,
      description: room.description,
      viewerCount: room.viewerCount,
      memberCount: room.memberCount,
      availability: room.availability,
      isBanned: room.isBanned,
      needPassword: room.needPassword,
      hidden: room.hidden,
      createdAt: room.createdAt,
      onTap: () => _handleJoinRoom(room),
      onLongPress: _currentUser != null && _currentUser!.id == room.creatorId
          ? () => _handleDeleteRoom(room)
          : null,
    );
  }
}
