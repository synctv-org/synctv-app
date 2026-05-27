import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/pages/mobile/watch_together_room_screen.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/theme/app_theme.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';
import 'package:synctv_app/widgets/huawei_login_panel.dart';
import 'package:synctv_app/services/smart_grip_service.dart';
import 'package:synctv_app/pages/mobile/admin_settings_page.dart';
import 'package:synctv_app/pages/account_center_page.dart';
import 'package:synctv_app/widgets/cinema_room_card.dart';
import 'package:synctv_app/widgets/create_room_dialog.dart';
import 'package:synctv_app/pages/splash_page.dart';
import 'package:synctv_app/services/oauth2_deep_link_service.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;

enum _RoomFeed { public, mine, hot }

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (runWebViewTitleBarWidget(args)) {
    return;
  }
  await WatchTogetherService.init();
  await OAuth2DeepLinkService.initialize();
  SmartGripService().init();

  try {
    VideoPlayerMediaKit.ensureInitialized(
      android: true,
      iOS: true,
      windows: true,
      macOS: true,
      linux: true,
    );
  } catch (e) {
    debugPrint('Failed to initialize media playback: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '看搭子',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        var newMediaQueryData = mediaQueryData;
        Widget newChild = child!;
        if (mediaQueryData.size.width < 600 && mediaQueryData.size.width > 0) {
          const double targetWidth = 414.0;
          if (mediaQueryData.size.width < targetWidth) {
            final double scale = mediaQueryData.size.width / targetWidth;
            newMediaQueryData = mediaQueryData.copyWith(
              size: Size(targetWidth, mediaQueryData.size.height / scale),
              devicePixelRatio: mediaQueryData.devicePixelRatio * scale,
              padding: mediaQueryData.padding / scale,
              viewPadding: mediaQueryData.viewPadding / scale,
              viewInsets: mediaQueryData.viewInsets / scale,
              systemGestureInsets: mediaQueryData.systemGestureInsets / scale,
              textScaler: mediaQueryData.textScaler
                  .clamp(minScaleFactor: 0.8, maxScaleFactor: 1.0),
            );

            newChild = FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: SizedBox(
                width: targetWidth,
                height: mediaQueryData.size.height / scale,
                child: newChild,
              ),
            );
          } else {
            newMediaQueryData = mediaQueryData.copyWith(
              textScaler: mediaQueryData.textScaler
                  .clamp(minScaleFactor: 0.8, maxScaleFactor: 1.0),
            );
          }
        } else {
          newMediaQueryData = mediaQueryData.copyWith(
            textScaler: mediaQueryData.textScaler
                .clamp(minScaleFactor: 0.8, maxScaleFactor: 1.0),
          );
        }

        return MediaQuery(
          data: newMediaQueryData,
          child: newChild,
        );
      },
      // home: const LargeScreenHome(),
      home: const SplashPage(),
    );
  }
}

class WatchTogetherHomeScreen extends StatefulWidget {
  const WatchTogetherHomeScreen({super.key});

  @override
  State<WatchTogetherHomeScreen> createState() =>
      _WatchTogetherHomeScreenState();
}

class _WatchTogetherHomeScreenState extends State<WatchTogetherHomeScreen> {
  int _currentIndex = 0; // 0 for "影厅" (Rooms), 1 for "我的" (Profile)
  bool _isLoading = true;
  List<WRoom> _rooms = [];
  int _roomsTotal = 0;
  int _roomPage = 1;
  static const int _roomPageSize = 20;
  _RoomFeed _roomFeed = _RoomFeed.public;
  bool _isLoggedIn = false;
  WUser? _currentUser;
  StreamSubscription? _authErrorSubscription;

  final TextEditingController _joinRoomController = TextEditingController();
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
    _joinRoomController.dispose();
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
      debugPrint('Failed to fetch current user: $e');
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
    showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const HuaweiLoginPanel(),
    ).then((result) {
      if (result == true) {
        _handleLoginSuccess();
      }
    });
  }

  void _handleLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
    _loadRooms(silent: false);
    _fetchUserInfo();
  }

  void _showCreateRoomDialog() {
    showCreateRoomDialog(
      context: context,
      width: 360,
      onCreated: (_) async {
        if (mounted) {
          await _loadRooms(silent: true);
        }
      },
    );
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountCenterPage(initialUser: user),
      ),
    ).then((_) {
      _fetchUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF7F7FC),
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: [
              // Tab 0: 影厅 (Rooms)
              _isLoggedIn
                  ? RefreshIndicator(
                      onRefresh: () async {
                        await _loadRooms(silent: true);
                      },
                      child: _buildScrollView(isDark),
                    )
                  : _buildScrollView(isDark),

              // Tab 1: 我的 (Profile)
              _buildProfileTab(theme, isDark),
            ],
          ),

          // Bottom Navigation Bar
          _buildBottomNavigationBar(theme, isDark),
        ],
      ),
    );
  }

  Widget _buildProfileTab(ThemeData theme, bool isDark) {
    final isAdmin =
        _currentUser?.role == common_enum.UserRole.USER_ROLE_ROOT.value ||
            _currentUser?.role == common_enum.UserRole.USER_ROLE_ADMIN.value;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 120,
          pinned: true,
          elevation: 0,
          backgroundColor:
              isDark ? const Color(0xFF121212) : const Color(0xFFF7F7FC),
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
            title: Text(
              '我的',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            background: Container(
              color: isDark ? const Color(0xFF121212) : const Color(0xFFF7F7FC),
              child: Stack(
                children: [
                  Positioned(
                    right: -40,
                    top: -40,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF5D5FEF).withValues(alpha: 0.03),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isLoggedIn && _currentUser != null) ...[
                  // User Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade900 : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.primaryColor.withValues(alpha: 0.1),
                          ),
                          child: Center(
                            child: Text(
                              _currentUser!.username.isNotEmpty
                                  ? _currentUser!.username[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentUser!.username,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Role: ${_currentUser!.role}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // Action List
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade900 : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      if (!_isLoggedIn)
                        _buildProfileOption(
                          icon: Icons.login_rounded,
                          title: '登录账号',
                          onTap: _showLoginDialog,
                          theme: theme,
                        ),
                      if (_isLoggedIn)
                        _buildProfileOption(
                          icon: Icons.account_circle_outlined,
                          title: '账号中心',
                          onTap: _showAccountCenter,
                          theme: theme,
                          iconColor: const Color(0xFF5D5FEF),
                        ),
                      if (_isLoggedIn)
                        _buildProfileOption(
                          icon: Icons.add_box_outlined,
                          title: '创建房间',
                          onTap: _showCreateRoomDialog,
                          theme: theme,
                          iconColor: const Color(0xFF5D5FEF),
                        ),
                      _buildProfileOption(
                        icon: Icons.dns_outlined,
                        title: '服务器设置',
                        onTap: _showServerSettingsDialog,
                        theme: theme,
                        iconColor: Colors.purple,
                      ),
                      if (isAdmin)
                        _buildProfileOption(
                          icon: Icons.admin_panel_settings,
                          title: '管理员设置',
                          onTap: _showAdminSettingsPage,
                          theme: theme,
                          iconColor: Colors.orange,
                        ),
                      if (_isLoggedIn)
                        _buildProfileOption(
                          icon: Icons.logout,
                          title: '退出登录',
                          onTap: _handleLogout,
                          theme: theme,
                          iconColor: Colors.red,
                          isLast: true,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 120), // Padding for bottom nav bar
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required ThemeData theme,
    Color? iconColor,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: iconColor ?? theme.iconTheme.color, size: 24),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color:
                        isLast && iconColor == Colors.red ? Colors.red : null,
                  ),
                ),
                const Spacer(),
                Icon(Icons.chevron_right,
                    color: Colors.grey.shade400, size: 20),
              ],
            ),
          ),
          if (!isLast)
            Divider(
              height: 1,
              indent: 60,
              endIndent: 20,
              color: theme.dividerColor.withValues(alpha: 0.05),
            ),
        ],
      ),
    );
  }

  Widget _buildScrollView(bool isDark) {
    return CustomScrollView(
      physics: _isLoggedIn
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      slivers: [
        _buildAppBar(),
        if (_isLoggedIn)
          SliverToBoxAdapter(child: _buildRoomControls(Theme.of(context))),
        if (_isLoading)
          const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          )
        else if (!_isLoggedIn)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _buildLoginRequired(isDark),
          )
        else if (_rooms.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _buildEmptyRooms(isDark),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 116),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildRoomCard(_rooms[index], index),
                childCount: _rooms.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLoginRequired(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.transparent,
                child: Image.asset('assets/icon/robot_3.png'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '请先登录以使用功能',
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showLoginDialog,
              icon: const Icon(Icons.login),
              label: const Text('立即登录'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D5FEF),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyRooms(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.transparent,
                child: Image.asset('assets/icon/robot_3.png'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '暂无房间，快去创建一个吧！',
              style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadRooms(silent: false),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D5FEF),
                foregroundColor: Colors.white,
              ),
              child: const Text('刷新列表'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomControls(ThemeData theme) {
    final supportsPaging = _roomFeed != _RoomFeed.hot;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedButton<_RoomFeed>(
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              textStyle: WidgetStateProperty.all(theme.textTheme.labelMedium),
            ),
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
          const SizedBox(height: 10),
          TextField(
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onSubmitted: _applyRoomSearch,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  supportsPaging
                      ? '共 $_roomsTotal 个 · 第 $_roomPage / $_roomPageCount 页'
                      : '显示 ${_rooms.length} 个热门房间',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              IconButton.filledTonal(
                tooltip: '刷新',
                onPressed: () => _loadRooms(silent: false),
                icon: const Icon(Icons.refresh_rounded),
              ),
              if (supportsPaging) ...[
                const SizedBox(width: 8),
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
        ],
      ),
    );
  }

  Widget _buildJoinRoomCapsule(ThemeData theme, bool isDark) {
    final capsuleColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);
    final textColor = isDark ? Colors.white70 : Colors.black54;

    return Container(
      height: 28,
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: capsuleColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: TextField(
              controller: _joinRoomController,
              textInputAction: TextInputAction.go,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: '输入ID加入',
                hintStyle: TextStyle(
                  color: textColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (value) async {
                await _joinRoomById(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      elevation: 0,
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF7F7FC),
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        title: Row(
          children: [
            Text(
              '看搭子',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 32, // Magnified as requested
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const Spacer(),
            if (_isLoggedIn)
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: _buildJoinRoomCapsule(theme, isDark),
              ),
          ],
        ),
        background: Container(
          color: isDark ? const Color(0xFF121212) : const Color(0xFFF7F7FC),
          child: Stack(
            children: [
              Positioned(
                right: -40,
                top: -40,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF5D5FEF).withValues(alpha: 0.03),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showServerSettingsDialog() {
    final controller =
        TextEditingController(text: WatchTogetherService.baseUrl);

    ChatUtils.showStyledDialog(
      context: context,
      title: '服务器设置',
      icon: const Icon(Icons.dns_outlined, color: Colors.purple),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChatUtils.createFormField(
            context: context,
            label: '服务器地址',
            controller: controller,
            hintText: '例如: https://tv.test.com',
            prefixIcon: Icons.link_rounded,
          ),
          const SizedBox(height: 8),
          Text(
            '修改后可能需要重新登录',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
        ],
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

  void _handleLogout() {
    ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '退出登录',
      icon: const Icon(Icons.logout, color: Colors.red),
      content: const Text('确定要退出当前账号吗？'),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: '退出',
        ),
      ],
    ).then((confirm) async {
      if (confirm == true) {
        await WatchTogetherService.logout();
        if (mounted) {
          setState(() {
            _isLoggedIn = false;
            _currentUser = null;
            _rooms = [];
            _roomsTotal = 0;
          });
          MessageUtils.showSuccess(context, '已退出登录');
        }
      }
    });
  }

  Future<void> _joinRoomById(String value) async {
    final id = value.trim();
    if (id.isEmpty) {
      MessageUtils.showWarning(context, '请输入房间ID');
      return;
    }
    try {
      final check = await WatchTogetherService.checkRoom(id);
      if (!check.exists) {
        if (mounted) MessageUtils.showWarning(context, '房间不存在');
        return;
      }
      if (!check.isAvailable) {
        if (mounted) MessageUtils.showWarning(context, '房间暂不可用');
        return;
      }
      final room = await WatchTogetherService.getRoomInfo(id);
      _joinRoomController.clear();
      if (mounted) _handleJoinRoom(room);
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '查找房间失败: $e');
    }
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

      // 2. Join the room in the background
      await WatchTogetherService.joinRoom(room.roomId, password);

      // 3. Navigate silently underneath the overlay
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WatchTogetherRoomScreen(room: room),
          ),
        );
      }
    } catch (e) {
      overlayEntry?.remove();
      if (mounted) MessageUtils.showError(context, '加入房间失败: $e');
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
          context,
          () => Navigator.pop(context, true),
          text: '删除',
        ),
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

  Widget _buildBottomNavigationBar(ThemeData theme, bool isDark) {
    return Positioned(
      bottom: 32, // Lifted slightly for a more floating look
      left: 0,
      right: 0,
      child: SafeArea(
        child: Center(
          child: Container(
            height: 64, // Fixed height for the capsule
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter:
                    ImageFilter.blur(sigmaX: 20, sigmaY: 20), // Stronger blur
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.4)
                        : Colors.white
                            .withValues(alpha: 0.6), // More transparent
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.black.withValues(alpha: 0.05),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Animated sliding background block
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutBack, // Spring-like physics
                        left: _currentIndex *
                            96.0, // Width of one item (80) + padding (16)
                        child: Container(
                          width: 80,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.15)
                                : Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                      // Navigation items
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildNavItem(
                            icon: Icons.movie_filter_rounded,
                            label: '影厅',
                            index: 0,
                            isSelected: _currentIndex == 0,
                            theme: theme,
                            isDark: isDark,
                          ),
                          const SizedBox(width: 16),
                          _buildNavItem(
                            icon: Icons.person_rounded,
                            label: '我的',
                            index: 1,
                            isSelected: _currentIndex == 1,
                            theme: theme,
                            isDark: isDark,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required ThemeData theme,
    required bool isDark,
  }) {
    final color = isSelected
        ? (isDark ? Colors.white : Colors.black)
        : (isDark ? Colors.white54 : Colors.black54);

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 80, // Fixed width for each item to match sliding block
        height: 48,
        alignment: Alignment.center,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            color: color,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: isSelected ? 14 : 13,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: isSelected ? 20 : 18, color: color),
              const SizedBox(width: 6),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double cutoutRadius = 8.0;
    double cutoutPosition =
        size.width * 0.28; // Position for the theater icon section

    path.lineTo(cutoutPosition - cutoutRadius, 0);
    path.arcToPoint(
      Offset(cutoutPosition + cutoutRadius, 0),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(cutoutPosition + cutoutRadius, size.height);
    path.arcToPoint(
      Offset(cutoutPosition - cutoutRadius, size.height),
      radius: Radius.circular(cutoutRadius),
      clockwise: false,
    );
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class DashLinePainter extends CustomPainter {
  final Color color;
  DashLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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
