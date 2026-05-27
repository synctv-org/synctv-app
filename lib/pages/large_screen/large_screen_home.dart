import 'dart:async';
import 'package:flutter/material.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/pages/large_screen/large_screen_room.dart';
import 'package:synctv_app/pages/account_center_page.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/utils/chat_utils.dart';

import 'package:synctv_app/widgets/huawei_login_panel.dart';
import 'package:synctv_app/widgets/cinema_room_card.dart';
import 'package:synctv_app/widgets/create_room_dialog.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'dart:math';

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
        WatchTogetherService.logout();
        setState(() {
          _isLoggedIn = false;
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
    final token = await WatchTogetherService.getToken();
    if (token == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showLoginDialog();
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
    if (!_isLoggedIn) return;

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

  void _showLoginDialog() {
    ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '登录/注册',
      icon: Icon(Icons.login, color: Theme.of(context).primaryColor),
      content: const _LoginDialog(),
      actions: [],
    ).then((result) {
      if (result == true) {
        setState(() {
          _isLoggedIn = true;
        });
        _loadRooms(silent: false);
        _fetchUserInfo();
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
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

  void _showServerSettingsDialog() {
    final controller =
        TextEditingController(text: WatchTogetherService.baseUrl);

    ChatUtils.showStyledDialog(
      context: context,
      title: '服务器设置',
      icon: Icon(Icons.dns_rounded, color: Theme.of(context).primaryColor),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChatUtils.createFormField(
              context: context,
              label: '服务器地址',
              controller: controller,
              hintText: '例如: https://tv.test.com',
              prefixIcon: Icons.link,
            ),
            const SizedBox(height: 8),
            Text(
              '修改后可能需要重新登录',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () async {
            if (controller.text.isEmpty) {
              MessageUtils.showWarning(context, '请输入服务器地址');
              return;
            }
            await WatchTogetherService.setBaseUrl(controller.text);
            if (mounted) {
              Navigator.pop(context);
              MessageUtils.showSuccess(context, '服务器地址已更新');
              if (_isLoggedIn) {
                _loadRooms(silent: false);
              }
            }
          },
          text: '保存',
        ),
      ],
    );
  }

  void _showAccountCenter() {
    final user = _currentUser;
    if (user == null) return;
    ChatUtils.showStyledDialog(
      context: context,
      title: '账号中心',
      icon: Icon(Icons.account_circle, color: Theme.of(context).primaryColor),
      content: SizedBox(
        width: 760,
        height: 620,
        child: AccountCenterPage(initialUser: user),
      ),
      actions: [],
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

    if (room.needPassword) {
      final passwordController = TextEditingController();
      final result = await ChatUtils.showStyledDialog<String>(
        context: context,
        title: '输入房间密码',
        icon: const Icon(Icons.lock, color: Color(0xFFCF0A2C)),
        content: ChatUtils.createFormField(
          context: context,
          label: '密码',
          controller: passwordController,
          hintText: '请输入房间密码',
          prefixIcon: Icons.key_rounded,
          obscureText: true,
        ),
        actions: [
          ChatUtils.createCancelButton(context),
          const SizedBox(width: 8),
          ChatUtils.createConfirmButton(
            context,
            () => Navigator.pop(context, passwordController.text),
            text: '确定',
          ),
        ],
      );

      if (result == null) return;
      if (result.isEmpty) {
        if (mounted) MessageUtils.showWarning(context, '请输入密码');
        return;
      }
      password = result;
    }

    OverlayEntry? overlayEntry;

    try {
      // 1. Immediately show the opaque transition overlay
      overlayEntry = OverlayEntry(
        builder: (context) => _TheaterTransitionEasterEgg(
          room: room,
          onComplete: () {
            overlayEntry?.remove();
          },
        ),
      );

      if (mounted) {
        Overlay.of(context).insert(overlayEntry);
      }

      // Briefly yield to ensure the overlay renders before any heavy work
      await Future.delayed(const Duration(milliseconds: 50));

      await WatchTogetherService.joinRoom(room.roomId, password);
      // Large screen might have specific navigation
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
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : !_isLoggedIn
                    ? _buildLoginRequired(isDark)
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

  Widget _buildLoginRequired(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 120,
              height: 120,
              color: Colors.transparent,
              child: Image.asset('assets/icon/robot_3.png'),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '请登录以开始观看',
            style: TextStyle(
              fontSize: 24,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _showLoginDialog,
            icon: const Icon(Icons.login),
            label: const Text('登录'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCF0A2C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
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
              onPressed: _roomPage <= 1
                  ? null
                  : () => _goRoomPage(_roomPage - 1),
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

class _LoginDialog extends StatefulWidget {
  const _LoginDialog();

  @override
  State<_LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<_LoginDialog> {
  bool _sheetOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _showHuaweiLoginPanel());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ChatUtils.createConfirmButton(
              context,
              _showHuaweiLoginPanel,
              text: '打开新版登录',
            ),
          ),
        ],
      ),
    );
  }

  void _showHuaweiLoginPanel() {
    if (_sheetOpen) return;
    _sheetOpen = true;
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const HuaweiLoginPanel(),
    ).then((result) {
      _sheetOpen = false;
      if (result == true) {
        if (mounted) {
          Navigator.pop(context, true);
        }
      }
    });
  }
}

class _TheaterTransitionEasterEgg extends StatefulWidget {
  final WRoom room;
  final VoidCallback onComplete;

  const _TheaterTransitionEasterEgg(
      {required this.room, required this.onComplete});

  @override
  State<_TheaterTransitionEasterEgg> createState() =>
      _TheaterTransitionEasterEggState();
}

class _TheaterTransitionEasterEggState
    extends State<_TheaterTransitionEasterEgg>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _doorSwing;
  late Animation<double> _doorGlow;
  late Animation<double> _cameraZoom;
  late Animation<double> _overlayOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 3800), // Slower, majestic transition
    );

    _doorSwing = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.1, 0.6, curve: Curves.easeInOutCubic)),
    );

    _doorGlow = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.2, 0.5, curve: Curves.easeIn)),
    );

    _cameraZoom = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.6, 0.95, curve: Curves.easeInQuint)),
    );

    _overlayOpacity = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 1), weight: 90),
      TweenSequenceItem(
          tween: Tween<double>(begin: 1, end: 0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 10),
    ]).animate(_controller);

    _controller.forward().then((_) {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDoorPanel(bool isLeft) {
    return Container(
      width: 140, // Half of 280
      height: 400,
      decoration: BoxDecoration(
        color: const Color(0xFF1A0505),
        border: Border(
          left:
              BorderSide(color: const Color(0xFF0A0000), width: isLeft ? 6 : 2),
          right:
              BorderSide(color: const Color(0xFF0A0000), width: isLeft ? 2 : 6),
          top: const BorderSide(color: Color(0xFF0A0000), width: 6),
          bottom: const BorderSide(color: Color(0xFF0A0000), width: 6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.8),
            blurRadius: 20,
            spreadRadius: 2,
            offset: Offset(isLeft ? -5 : 5, 0),
          )
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                Expanded(flex: 3, child: _doorSoftPanel()),
                const SizedBox(height: 16),
                Expanded(flex: 4, child: _doorSoftPanel()),
                const SizedBox(height: 16),
                Expanded(flex: 2, child: _doorSoftPanel()),
              ],
            ),
          ),
          Positioned(
            right: isLeft ? 15 : null,
            left: isLeft ? null : 15,
            top: 180,
            child: Container(
              width: 12,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE5C07B),
                    Color(0xFFD4AF37),
                    Color(0xFF997A00)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black54,
                      blurRadius: 4,
                      offset: Offset(2, 2))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _doorSoftPanel() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF140303),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF250606), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(decoration: TextDecoration.none),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final swingLeft = _doorSwing.value * (pi * 0.45);
          final swingRight = -_doorSwing.value * (pi * 0.45);

          return Opacity(
            opacity: _overlayOpacity.value,
            child: IgnorePointer(
              child: Scaffold(
                backgroundColor: Colors.black,
                body: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Moving Camera Zoom
                    Transform.scale(
                      scale: 1.0 + (_cameraZoom.value * 5.0),
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          // Glowing Screen Behind Door
                          Container(
                            width: 280,
                            height: 400,
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white,
                                  const Color(0xFF00B4D8)
                                      .withValues(alpha: 0.8),
                                  Colors.black,
                                ],
                                radius: 0.8 + (_doorGlow.value * 0.5),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF00B4D8)
                                      .withValues(alpha: _doorGlow.value * 0.8),
                                  blurRadius: 80 * _doorGlow.value,
                                  spreadRadius: 20 * _doorGlow.value,
                                ),
                              ],
                            ),
                          ),

                          // Doors
                          SizedBox(
                            width: 280,
                            height: 400,
                            child: Row(
                              children: [
                                Transform(
                                  alignment: Alignment.centerLeft,
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.0015)
                                    ..rotateY(swingLeft),
                                  child: _buildDoorPanel(true),
                                ),
                                Transform(
                                  alignment: Alignment.centerRight,
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.0015)
                                    ..rotateY(swingRight),
                                  child: _buildDoorPanel(false),
                                ),
                              ],
                            ),
                          ),

                          // Door Frame
                          IgnorePointer(
                            child: Container(
                              width: 320,
                              height: 440,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xFF050000), width: 20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.9),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  )
                                ],
                              ),
                            ),
                          ),

                          // Sign above door
                          Positioned(
                            top: -60,
                            child: Opacity(
                              opacity: 1.0 - _cameraZoom.value,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A0000),
                                  border: Border.all(
                                      color: const Color(0xFF330000), width: 2),
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.redAccent.withValues(
                                          alpha: _doorGlow.value * 0.4),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    )
                                  ],
                                ),
                                child: Text(
                                  widget.room.roomName.toUpperCase(),
                                  style: TextStyle(
                                    color: Color.lerp(
                                        Colors.red.shade900,
                                        const Color(0xFFFF5555),
                                        _doorGlow.value),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 4,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
