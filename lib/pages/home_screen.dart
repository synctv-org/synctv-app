import 'dart:async';
import 'package:flutter/material.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/pages/room_screen.dart';
//import 'package:synctv_app/widgets/watch_together_admin_settings.dart';
import 'package:synctv_app/pages/mobile/admin_settings_page.dart';
import 'package:synctv_app/pages/account_center_page.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/widgets/cinema_room_card.dart';
import 'package:synctv_app/widgets/create_room_dialog.dart';
import 'package:synctv_app/widgets/join_room_dialog.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';
import 'package:synctv_app/widgets/room_invite_flow.dart';
import 'package:synctv_app/widgets/server_settings_dialog.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;

import 'package:synctv_app/widgets/auth_panel.dart';

enum _RoomFeed { public, mine, hot }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _startRoomId = String.fromEnvironment(
    'SYNCTV_START_ROOM_ID',
    defaultValue: '',
  );

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
  bool _startRoomHandled = false;

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
      _openStartRoomIfRequested();
    }
  }

  void _openStartRoomIfRequested() {
    final roomId = _startRoomId.trim();
    if (_startRoomHandled || roomId.isEmpty) return;
    _startRoomHandled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final room = await WatchTogetherService.getRoomInfo(roomId);
        if (mounted) await _handleJoinRoom(room);
      } catch (e) {
        if (mounted) MessageUtils.showError(context, '打开房间失败: $e');
      }
    });
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
      result = await showAppBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: false,
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

  Future<void> _navigateToRoom(WRoom room) async {
    final deleted = await Navigator.push<bool>(
      context,
      PageRouteBuilder(
        opaque: true,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) =>
            RoomScreen(room: room),
      ),
    );
    if (!mounted) return;
    if (deleted == true) {
      setState(() {
        _rooms = _rooms.where((item) => item.roomId != room.roomId).toList();
        if (_roomsTotal > 0) _roomsTotal -= 1;
      });
      await _loadRooms(silent: true);
    }
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

    return AppScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: AppInkSurface(
          color: theme.appBarTheme.backgroundColor,
          elevation: 0,
          clipBehavior: Clip.none,
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
                          AppInkSurface(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            onLongPress: _showServerSettingsDialog,
                            semanticLabel: '打开服务器设置',
                            child: Row(
                              children: [
                                AppIconBadge(
                                  icon: Icons.live_tv_rounded,
                                  color: theme.colorScheme.primary,
                                  size: 36,
                                  iconSize: 22,
                                  backgroundAlpha: 0.12,
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
                            AppActionButton(
                              onPressed: _showServerSettingsDialog,
                              icon: Icons.dns_rounded,
                              label: '服务器',
                              style: AppActionButtonStyle.tonal,
                            )
                          else
                            AppIconButton(
                              tooltip: '服务器设置',
                              onPressed: _showServerSettingsDialog,
                              icon: Icons.dns_rounded,
                              style: AppIconButtonStyle.tonal,
                            ),
                          SizedBox(width: compact ? 8 : 12),
                          if (_isLoggedIn) ...[
                            if (compact)
                              AppIconButton(
                                tooltip: '加入房间',
                                onPressed: _showJoinRoomDialog,
                                icon: Icons.login_rounded,
                                style: AppIconButtonStyle.tonal,
                              )
                            else
                              AppActionButton(
                                onPressed: _showJoinRoomDialog,
                                icon: Icons.login_rounded,
                                label: '加入房间',
                                style: AppActionButtonStyle.outlined,
                              ),
                            SizedBox(width: compact ? 8 : 10),
                            if (compact)
                              AppIconButton(
                                tooltip: '创建房间',
                                onPressed: _showCreateRoomDialog,
                                icon: Icons.add_rounded,
                                style: AppIconButtonStyle.filled,
                              )
                            else
                              AppActionButton(
                                onPressed: _showCreateRoomDialog,
                                icon: Icons.add_rounded,
                                label: '创建房间',
                              ),
                            SizedBox(width: compact ? 8 : 12),
                            compact
                                ? _buildCompactAccountMenu(theme, isAdmin)
                                : _buildAccountMenu(theme, isAdmin, isDark),
                          ] else if (compact)
                            AppActionButton(
                              onPressed: _showLoginDialog,
                              icon: Icons.login_rounded,
                              label: '登录',
                            )
                          else
                            AppActionButton(
                              onPressed: _showLoginDialog,
                              icon: Icons.login_rounded,
                              label: '登录',
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
          ? const AppLoadingIndicator()
          : Padding(
              padding: AppMetrics.pagePadding(context),
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
    return AppPopupMenuButton<String>(
      offset: const Offset(0, 46),
      tooltip: '账号菜单',
      child: AppAvatar(
        name: _currentUser?.username,
        radius: 18,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        textStyle: const TextStyle(fontSize: 13),
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
    return AppPopupMenuButton<String>(
      offset: const Offset(0, 46),
      tooltip: '账号菜单',
      child: AppInkSurface(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        borderSide:
            BorderSide(color: theme.dividerColor.withValues(alpha: 0.7)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            children: [
              AppAvatar(
                name: _currentUser?.username,
                radius: 15,
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                textStyle: const TextStyle(fontSize: 13),
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
    final compact = AppBreakpoints.widthOf(context) < 1080;

    return AppInkSurface(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.7)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: compact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildRoomFilterControls(),
                  const SizedBox(height: 12),
                  _buildRoomControlActions(theme, supportsPaging, summary),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _buildRoomFilterControls()),
                  const SizedBox(width: 12),
                  _buildRoomControlActions(theme, supportsPaging, summary),
                ],
              ),
      ),
    );
  }

  Widget _buildRoomFilterControls() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppSegmentedControl<_RoomFeed>(
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
              value: _roomFeed,
              onChanged: _setRoomFeed,
            ),
            AppSearchField(
              controller: _roomSearchController,
              width: compact ? constraints.maxWidth : 320,
              hintText: _roomFeed == _RoomFeed.hot ? '热门房间不支持搜索' : '搜索房间',
              enabled: _roomFeed != _RoomFeed.hot,
              onChanged: (value) {
                if (value.isEmpty) _applyRoomSearch('');
              },
              onSubmitted: _applyRoomSearch,
            ),
          ],
        );
      },
    );
  }

  Widget _buildRoomControlActions(
    ThemeData theme,
    bool supportsPaging,
    String summary,
  ) {
    final summaryStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.68),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: AppBreakpoints.widthOf(context) < 1080
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.end,
      children: [
        Flexible(
          child: supportsPaging
              ? AppPaginationBar(
                  padding: EdgeInsets.zero,
                  label: summary,
                  labelStyle: summaryStyle,
                  onPrevious:
                      _roomPage <= 1 ? null : () => _goRoomPage(_roomPage - 1),
                  onNext: _roomPage >= _roomPageCount
                      ? null
                      : () => _goRoomPage(_roomPage + 1),
                )
              : Text(
                  summary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: summaryStyle,
                ),
        ),
        const SizedBox(width: 8),
        AppIconButton(
          tooltip: '刷新',
          onPressed: () => _loadRooms(silent: false),
          icon: Icons.refresh_rounded,
          style: AppIconButtonStyle.tonal,
        ),
      ],
    );
  }

  Widget _buildRoomGrid() {
    final theme = Theme.of(context);
    final hasServer = WatchTogetherService.activeServer != null;
    return AppInkSurface(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.7)),
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
                  AppActionButton(
                    onPressed: hasServer
                        ? () => _loadRooms(silent: false)
                        : _showServerSettingsDialog,
                    icon: hasServer ? Icons.refresh_rounded : Icons.add_link,
                    label: hasServer ? '刷新' : '添加服务器',
                    style: AppActionButtonStyle.tonal,
                  ),
                ],
              ),
            )
          : AppRefreshIndicator(
              onRefresh: () async => await _loadRooms(silent: true),
              child: AppGridView.builder(
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
      coverUrl: room.coverUrl,
      viewerCount: room.viewerCount,
      connectionCount: room.connectionCount,
      memberCount: room.memberCount,
      creatorName: room.creator,
      creatorAvatarUrl: room.creatorAvatarUrl,
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
