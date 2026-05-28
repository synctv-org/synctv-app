import 'dart:async';
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/pages/mobile/watch_together_room_screen.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/theme/app_theme.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';
import 'package:synctv_app/widgets/auth_panel.dart';
import 'package:synctv_app/services/smart_grip_service.dart';
import 'package:synctv_app/pages/mobile/admin_settings_page.dart';
import 'package:synctv_app/pages/account_center_page.dart';
import 'package:synctv_app/widgets/cinema_room_card.dart';
import 'package:synctv_app/widgets/create_room_dialog.dart';
import 'package:synctv_app/widgets/join_room_dialog.dart';
import 'package:synctv_app/widgets/server_settings_dialog.dart';
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
      iOS: false,
      windows: true,
      macOS: false,
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
        final newMediaQueryData = mediaQueryData.copyWith(
          textScaler: mediaQueryData.textScaler
              .clamp(minScaleFactor: 0.8, maxScaleFactor: 1.1),
        );

        return _GlobalTextEditingShortcuts(
          child: MediaQuery(
            data: newMediaQueryData,
            child: child!,
          ),
        );
      },
      // home: const LargeScreenHome(),
      home: const SplashPage(),
    );
  }
}

class _PasteIntoFocusedTextIntent extends Intent {
  const _PasteIntoFocusedTextIntent();
}

class _GlobalTextEditingShortcuts extends StatelessWidget {
  const _GlobalTextEditingShortcuts({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.keyV, meta: true):
            _PasteIntoFocusedTextIntent(),
        SingleActivator(LogicalKeyboardKey.keyV, control: true):
            _PasteIntoFocusedTextIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _PasteIntoFocusedTextIntent:
              CallbackAction<_PasteIntoFocusedTextIntent>(
            onInvoke: (_) {
              _pasteIntoFocusedEditable();
              return null;
            },
          ),
        },
        child: child,
      ),
    );
  }

  static Future<void> _pasteIntoFocusedEditable() async {
    final focusContext = FocusManager.instance.primaryFocus?.context;
    final editable = focusContext?.findAncestorStateOfType<EditableTextState>();
    if (editable == null) return;

    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboard?.text;
    if (text == null || text.isEmpty) return;

    final value = editable.textEditingValue;
    final selection = value.selection;
    final replacementRange = selection.isValid
        ? selection
        : TextSelection.collapsed(offset: value.text.length);
    editable.userUpdateTextEditingValue(
      value.replaced(replacementRange, text),
      SelectionChangedCause.keyboard,
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
  int _currentIndex = 0;
  bool _isLoading = true;
  List<WRoom> _rooms = [];
  int _roomsTotal = 0;
  int _roomPage = 1;
  static const int _roomPageSize = 20;
  _RoomFeed _roomFeed = _RoomFeed.public;
  bool _isLoggedIn = false;
  WUser? _currentUser;
  StreamSubscription? _authErrorSubscription;

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
        _handleLoginSuccess();
      }
      return true;
    }
    return false;
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
              RefreshIndicator(
                onRefresh: () async {
                  await _loadRooms(silent: true);
                },
                child: _buildScrollView(isDark),
              ),

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
    final actions = <Widget>[
      if (!_isLoggedIn)
        _buildProfileOption(
          icon: Icons.login_rounded,
          title: '登录账号',
          subtitle: '同步账号、创建房间和管理成员',
          onTap: _showLoginDialog,
          theme: theme,
        ),
      if (_isLoggedIn) ...[
        _buildProfileOption(
          icon: Icons.account_circle_outlined,
          title: '账号中心',
          subtitle: '资料、安全和多因素认证',
          onTap: _showAccountCenter,
          theme: theme,
        ),
        _buildProfileOption(
          icon: Icons.add_box_outlined,
          title: '创建房间',
          subtitle: '创建新的同步观影空间',
          onTap: _showCreateRoomDialog,
          theme: theme,
        ),
      ],
      _buildProfileOption(
        icon: Icons.dns_outlined,
        title: '服务器设置',
        subtitle: '切换服务器、添加地址和查看连接状态',
        onTap: _showServerSettingsDialog,
        theme: theme,
      ),
      if (isAdmin)
        _buildProfileOption(
          icon: Icons.admin_panel_settings_outlined,
          title: '管理员设置',
          subtitle: '进入独立系统管理页面',
          onTap: _showAdminSettingsPage,
          theme: theme,
        ),
      if (_isLoggedIn)
        _buildProfileOption(
          icon: Icons.logout_rounded,
          title: '退出登录',
          subtitle: '仅退出当前服务器账号',
          onTap: _handleLogout,
          theme: theme,
          danger: true,
        ),
    ];

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 88,
          pinned: true,
          elevation: 0,
          backgroundColor:
              isDark ? const Color(0xFF121212) : const Color(0xFFF7F7FC),
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            title: Text(
              '我的',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
            background: ColoredBox(
              color: isDark ? const Color(0xFF121212) : const Color(0xFFF7F7FC),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 112),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildProfileIdentityPanel(theme),
                const SizedBox(height: 12),
                Material(
                  color: theme.colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: theme.dividerColor.withValues(alpha: 0.7),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(children: actions),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileIdentityPanel(ThemeData theme) {
    final user = _currentUser;
    final signedIn = _isLoggedIn && user != null;
    final title = signedIn ? user.username : '未登录';
    final subtitle = signedIn
        ? '${_roleLabel(user.role)} · ${WatchTogetherService.activeServer?.name ?? '当前服务器'}'
        : '可以先浏览公开房间，登录后可创建和管理房间';

    return Material(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.7)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: signedIn
                  ? Text(
                      _profileInitial(user.username),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : Icon(
                      Icons.person_outline_rounded,
                      color: theme.colorScheme.primary,
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.62),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ThemeData theme,
    bool danger = false,
  }) {
    final foreground =
        danger ? theme.colorScheme.error : theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: foreground.withValues(alpha: danger ? 0.08 : 0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: foreground, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: danger ? theme.colorScheme.error : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.58),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.34),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _profileInitial(String username) {
    final trimmed = username.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed.characters.first.toUpperCase();
  }

  String _roleLabel(int role) {
    if (role == common_enum.UserRole.USER_ROLE_ROOT.value) return 'Root';
    if (role == common_enum.UserRole.USER_ROLE_ADMIN.value) return '管理员';
    if (role == common_enum.UserRole.USER_ROLE_USER.value) return '用户';
    return '角色 $role';
  }

  Widget _buildScrollView(bool isDark) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        _buildAppBar(),
        SliverToBoxAdapter(child: _buildRoomControls(Theme.of(context))),
        if (_isLoading)
          const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_rooms.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _buildEmptyRooms(isDark),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 104),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildRoomCard(_rooms[index], index),
                ),
                childCount: _rooms.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyRooms(bool isDark) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.meeting_room_outlined,
                color: theme.colorScheme.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '暂无房间',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _roomFeed == _RoomFeed.mine ? '加入或创建房间后会出现在这里' : '当前筛选下没有可显示的房间',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: () => _loadRooms(silent: false),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('刷新'),
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
      child: Material(
        color: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.7)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SegmentedButton<_RoomFeed>(
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  textStyle:
                      WidgetStateProperty.all(theme.textTheme.labelMedium),
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
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.62),
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    tooltip: '刷新',
                    onPressed: () => _loadRooms(silent: false),
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                  if (supportsPaging) ...[
                    const SizedBox(width: 6),
                    IconButton(
                      tooltip: '上一页',
                      onPressed: _roomPage <= 1
                          ? null
                          : () => _goRoomPage(_roomPage - 1),
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
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: 96,
      pinned: true,
      elevation: 0,
      backgroundColor:
          isDark ? const Color(0xFF121212) : const Color(0xFFF7F7FC),
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.live_tv_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '看搭子',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            const Spacer(),
            IconButton.filledTonal(
              tooltip: '服务器设置',
              onPressed: _showServerSettingsDialog,
              icon: const Icon(Icons.dns_rounded),
            ),
            if (_isLoggedIn) ...[
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: '创建房间',
                onPressed: _showCreateRoomDialog,
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ],
        ),
        background: ColoredBox(
            color: isDark ? const Color(0xFF121212) : const Color(0xFFF7F7FC)),
      ),
    );
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WatchTogetherRoomScreen(room: room),
          ),
        );
      }
    } catch (e) {
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
      bottom: 16,
      left: 0,
      right: 0,
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: Material(
          color: theme.colorScheme.surface,
          elevation: 6,
          shadowColor: Colors.black.withValues(alpha: isDark ? 0.42 : 0.12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.7)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.movie_filter_rounded,
                    label: '影厅',
                    index: 0,
                    isSelected: _currentIndex == 0,
                    theme: theme,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.person_rounded,
                    label: '我的',
                    index: 1,
                    isSelected: _currentIndex == 1,
                    theme: theme,
                    isDark: isDark,
                  ),
                ),
              ],
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
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.62);

    return Material(
      color: isSelected
          ? theme.colorScheme.primary.withValues(alpha: 0.10)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 46,
          child: Center(
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
        ),
      ),
    );
  }
}
