import 'dart:async';
import 'package:flutter/material.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/pages/large_screen/large_screen_room.dart';
import 'package:synctv_app/pages/account_center_page.dart';
import 'package:synctv_app/utils/message_utils.dart';

import 'package:synctv_app/widgets/auth_panel.dart';
import 'package:synctv_app/widgets/cinema_room_card.dart';
import 'package:synctv_app/widgets/create_room_dialog.dart';
import 'package:synctv_app/widgets/join_room_dialog.dart';
import 'package:synctv_app/widgets/room_invite_flow.dart';
import 'package:synctv_app/widgets/server_settings_dialog.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

enum _RoomFeed { public, mine, hot }

class LargeScreenHome extends StatefulWidget {
  const LargeScreenHome({super.key});

  @override
  State<LargeScreenHome> createState() => _LargeScreenHomeState();
}

class _LargeScreenHomeState extends State<LargeScreenHome> {
  bool _isLoading = true;
  List<WRoom> _rooms = [];
  int _roomsTotal = 0;
  int _roomPage = 1;
  static const int _roomPageSize = 24;
  _RoomFeed _roomFeed = _RoomFeed.public;
  bool _isLoggedIn = false;
  WUser? _currentUser;
  StreamSubscription? _authErrorSubscription;
  final FocusNode _createRoomFocus = FocusNode();
  final FocusNode _refreshFocus = FocusNode();
  final TextEditingController _roomSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _authErrorSubscription = WatchTogetherService.onAuthError.listen((_) {
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _currentUser = null;
        });
        _showLoginDialog();
      }
    });
    _checkLoginAndLoadData();
  }

  @override
  void dispose() {
    _authErrorSubscription?.cancel();
    _createRoomFocus.dispose();
    _refreshFocus.dispose();
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
        // Auto focus refresh button if no rooms or create room if rooms exist
        if (_rooms.isEmpty) {
          _refreshFocus.requestFocus();
        } else {
          _createRoomFocus.requestFocus();
        }
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
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AuthPanel(initialGuestRoomId: guestRoomId),
    );
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
    showCreateRoomDialog(
      context: context,
      width: 400,
      onCreated: (_) async {
        if (mounted) {
          await _loadRooms(silent: true);
        }
      },
    );
  }

  void _showJoinRoomDialog() {
    showJoinRoomDialog(
      context: context,
      onSubmitted: _joinRoomById,
    );
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

  void _showServerSettingsDialog() {
    showServerSettingsDialog(context: context).then((changed) {
      if (!mounted || changed != true) return;
      final hasSession = WatchTogetherService.hasRecoverableSession;
      setState(() {
        _isLoggedIn = hasSession;
        if (!hasSession) _currentUser = null;
        _roomPage = 1;
      });
      _loadRooms(silent: false);
      if (hasSession) _fetchUserInfo();
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

  Future<void> _handleJoinRoom(WRoom room) async {
    String password = '';

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

    try {
      await WatchTogetherService.joinRoom(room.roomId, password);
      if (mounted) {
        _navigateToRoom(room);
      }
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加入房间失败: $e');
    }
  }

  void _navigateToRoom(WRoom room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LargeScreenRoom(room: room),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Top Header
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            decoration: BoxDecoration(
              color: theme.appBarTheme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Logo & Name
                Text(
                  '看搭子',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),

                const Spacer(),

                // Server Settings
                IconButton(
                  icon: const Icon(Icons.dns_rounded),
                  onPressed: _showServerSettingsDialog,
                  tooltip: '服务器设置',
                ),
                const SizedBox(width: 8),

                // Refresh
                IconButton(
                  focusNode: _refreshFocus,
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: () => _loadRooms(silent: false),
                  tooltip: '刷新',
                ),
                const SizedBox(width: 24),

                // User Avatar
                if (_isLoggedIn && _currentUser != null)
                  InkWell(
                    onTap: _showAccountCenter,
                    borderRadius: BorderRadius.circular(50),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(0xFF5D5FEF),
                            child: Text(
                              _currentUser!.username.isNotEmpty
                                  ? _currentUser!.username[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentUser!.username,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ElevatedButton.icon(
                    onPressed: _showLoginDialog,
                    icon: const Icon(Icons.login),
                    label: const Text('登录'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCF0A2C),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                  ),

                const SizedBox(width: 24),

                // Create Room Button
                ElevatedButton.icon(
                  onPressed: _showCreateRoomDialog,
                  focusNode: _createRoomFocus,
                  icon: const Icon(Icons.add),
                  label: const Text('创建房间'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D5FEF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: _showJoinRoomDialog,
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('加入房间'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      _buildRoomControls(theme),
                      Expanded(child: _buildRoomGrid()),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomControls(ThemeData theme) {
    final supportsPaging = _roomFeed != _RoomFeed.hot;
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 0),
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
            width: 300,
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
                hintText: _roomFeed == _RoomFeed.hot ? '热门房间不支持搜索' : '搜索房间',
                border: const OutlineInputBorder(),
              ),
              onSubmitted: _applyRoomSearch,
            ),
          ),
          Text(
            supportsPaging
                ? '共 $_roomsTotal 个 · 第 $_roomPage / $_roomPageCount 页'
                : '显示 ${_rooms.length} 个热门房间',
            style: theme.textTheme.bodyLarge,
          ),
          if (supportsPaging) ...[
            IconButton.filledTonal(
              tooltip: '上一页',
              onPressed:
                  _roomPage <= 1 ? null : () => _goRoomPage(_roomPage - 1),
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            IconButton.filledTonal(
              tooltip: '下一页',
              onPressed: _roomPage >= _roomPageCount
                  ? null
                  : () => _goRoomPage(_roomPage + 1),
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRoomGrid() {
    if (_rooms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.weekend_rounded,
              size: 120,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            const Text(
              '暂无房间，去创建一个吧',
              style: TextStyle(fontSize: 24, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(32),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        childAspectRatio: 1.2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemCount: _rooms.length,
      itemBuilder: (context, index) => _buildRoomCard(_rooms[index], index),
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
      showScaleAnimation: true,
    );
  }
}
