import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/models/account_models.dart';
import 'package:synctv_app/models/room_management_models.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/providers/common.pbenum.dart'
    as provider_common_enum;
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/utils/chat_utils.dart';

const Map<String, String> _providerTypeLabels = {
  'alist': 'Alist',
  'emby': 'Emby',
  'bilibili': 'Bilibili',
  'rtmp': 'RTMP',
};

String _providerTypeLabel(String provider) {
  return _providerTypeLabels[provider] ?? provider;
}

List<String> _providerTypeOptions({
  String selectedFilter = '',
  Iterable<String> selectedProviders = const [],
}) {
  final values = <String>{
    ..._providerTypeLabels.keys,
    ...selectedProviders.where((value) => value.isNotEmpty),
  };
  if (selectedFilter.isNotEmpty) values.add(selectedFilter);
  return values.toList(growable: false)..sort();
}

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final systemUiOverlayStyle =
        isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF121212) : const Color(0xFFF7F7FC),
        appBar: AppBar(
          title: const Text('管理员设置',
              style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          systemOverlayStyle: systemUiOverlayStyle,
        ),
        body: Column(
          children: [
            _buildTopTabs(theme, isDark),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  AdminOverviewTab(),
                  RoomManagementTab(),
                  UserManagementTab(),
                  AdminReviewTab(),
                  AdminProviderTab(),
                  AdminStreamsTab(),
                  AdminBanRecordsTab(),
                  AdminSettingsGroupsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTabs(ThemeData theme, bool isDark) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Material(
          color: isDark
              ? Colors.black.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.72),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.hintColor,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(icon: Icon(Icons.dashboard_rounded), text: '总览'),
              Tab(icon: Icon(Icons.meeting_room_rounded), text: '房间'),
              Tab(icon: Icon(Icons.people_alt_rounded), text: '用户'),
              Tab(icon: Icon(Icons.fact_check_rounded), text: '审核'),
              Tab(icon: Icon(Icons.hub_rounded), text: 'Provider'),
              Tab(icon: Icon(Icons.podcasts_rounded), text: '流'),
              Tab(icon: Icon(Icons.gavel_rounded), text: '封禁'),
              Tab(icon: Icon(Icons.tune_rounded), text: '设置'),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminOverviewTab extends StatefulWidget {
  const AdminOverviewTab({super.key});

  @override
  State<AdminOverviewTab> createState() => _AdminOverviewTabState();
}

class _AdminOverviewTabState extends State<AdminOverviewTab> {
  AdminSystemStats? _stats;
  List<WUser> _admins = const [];
  int _adminTotal = 0;
  int _adminPage = 1;
  int _adminPageSize = 20;
  String _adminSearch = '';
  admin_enum.UserListSortBy _adminSortBy =
      admin_enum.UserListSortBy.USER_LIST_SORT_BY_CREATED_AT;
  admin_enum.SortDirection _adminSortDirection =
      admin_enum.SortDirection.SORT_DIRECTION_DESC;
  bool _isLoading = true;

  int get _adminPageCount =>
      _adminTotal <= 0 ? 1 : ((_adminTotal - 1) ~/ _adminPageSize) + 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        WatchTogetherService.adminGetSystemStats(),
        WatchTogetherService.adminListAdminsPage(
          page: _adminPage,
          pageSize: _adminPageSize,
          search: _adminSearch,
          sortBy: _adminSortBy,
          sortDirection: _adminSortDirection,
        ),
      ]);
      if (!mounted) return;
      final adminsPage = results[1] as AdminsPage;
      setState(() {
        _stats = results[0] as AdminSystemStats;
        _admins = adminsPage.admins;
        _adminTotal = adminsPage.total;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      MessageUtils.showError(context, '加载总览失败: $e');
    }
  }

  Future<void> _addAdmin() async {
    final controller = TextEditingController();
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '添加管理员',
      icon: const Icon(Icons.admin_panel_settings_rounded,
          color: Color(0xFF5D5FEF)),
      content: ChatUtils.createFormField(
        context: context,
        label: '用户 ID',
        controller: controller,
        hintText: 'usr_...',
        prefixIcon: Icons.person_add_alt_rounded,
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: '添加',
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      await WatchTogetherService.adminAddAdmin(controller.text.trim());
      if (!mounted) return;
      MessageUtils.showSuccess(context, '管理员已添加');
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '添加失败: $e');
    }
  }

  Future<void> _removeAdmin(WUser user) async {
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '移除管理员',
      icon: const Icon(Icons.remove_moderator_outlined, color: Colors.red),
      content: Text('确定移除 ${user.username} 的管理员权限吗？'),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: '移除',
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      await WatchTogetherService.adminRemoveAdmin(user.id);
      if (!mounted) return;
      MessageUtils.showSuccess(context, '管理员已移除');
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '移除失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final stats = _stats;
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return RefreshIndicator(
      onRefresh: () => _load(silent: true),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (stats != null)
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _StatTile('用户', stats.totalUsers, Icons.people_alt_rounded,
                    Colors.blue, isDark),
                _StatTile('活跃用户', stats.activeUsers,
                    Icons.person_pin_circle_rounded, Colors.green, isDark),
                _StatTile('封禁用户', stats.bannedUsers, Icons.block_rounded,
                    Colors.red, isDark),
                _StatTile('房间', stats.totalRooms, Icons.meeting_room_rounded,
                    Colors.indigo, isDark),
                _StatTile('活跃房间', stats.activeRooms, Icons.sensors_rounded,
                    Colors.teal, isDark),
                _StatTile('媒体', stats.totalMedia, Icons.video_library_rounded,
                    Colors.deepPurple, isDark),
                _StatTile('Provider', stats.providerInstances,
                    Icons.hub_rounded, Colors.orange, isDark),
              ],
            ),
          const SizedBox(height: 20),
          _AdminPanelCard(
            isDark: isDark,
            child: Column(
              children: [
                ListTile(
                  title: const Text('管理员'),
                  subtitle: Text('共 $_adminTotal 个管理员账号'),
                  trailing: IconButton(
                    tooltip: '添加管理员',
                    icon: const Icon(Icons.add_moderator_outlined),
                    onPressed: _addAdmin,
                  ),
                ),
                Divider(
                    height: 1,
                    color: theme.dividerColor.withValues(alpha: 0.08)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 220,
                        child: TextField(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search_rounded),
                            hintText: '搜索管理员',
                            isDense: true,
                          ),
                          onSubmitted: (value) {
                            setState(() {
                              _adminSearch = value.trim();
                              _adminPage = 1;
                            });
                            _load(silent: true);
                          },
                        ),
                      ),
                      DropdownButton<admin_enum.UserListSortBy>(
                        value: _adminSortBy,
                        items: const [
                          DropdownMenuItem(
                            value: admin_enum
                                .UserListSortBy.USER_LIST_SORT_BY_CREATED_AT,
                            child: Text('创建时间'),
                          ),
                          DropdownMenuItem(
                            value: admin_enum
                                .UserListSortBy.USER_LIST_SORT_BY_UPDATED_AT,
                            child: Text('更新时间'),
                          ),
                          DropdownMenuItem(
                            value: admin_enum
                                .UserListSortBy.USER_LIST_SORT_BY_USERNAME,
                            child: Text('用户名'),
                          ),
                          DropdownMenuItem(
                            value: admin_enum
                                .UserListSortBy.USER_LIST_SORT_BY_EMAIL,
                            child: Text('邮箱'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _adminSortBy = value;
                            _adminPage = 1;
                          });
                          _load(silent: true);
                        },
                      ),
                      IconButton(
                        tooltip: _adminSortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? '降序'
                            : '升序',
                        icon: Icon(
                          _adminSortDirection ==
                                  admin_enum.SortDirection.SORT_DIRECTION_DESC
                              ? Icons.south_rounded
                              : Icons.north_rounded,
                        ),
                        onPressed: () {
                          setState(() {
                            _adminSortDirection = _adminSortDirection ==
                                    admin_enum.SortDirection.SORT_DIRECTION_DESC
                                ? admin_enum.SortDirection.SORT_DIRECTION_ASC
                                : admin_enum.SortDirection.SORT_DIRECTION_DESC;
                            _adminPage = 1;
                          });
                          _load(silent: true);
                        },
                      ),
                      DropdownButton<int>(
                        value: _adminPageSize,
                        items: const [
                          DropdownMenuItem(value: 20, child: Text('20 / 页')),
                          DropdownMenuItem(value: 50, child: Text('50 / 页')),
                          DropdownMenuItem(value: 100, child: Text('100 / 页')),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _adminPageSize = value;
                            _adminPage = 1;
                          });
                          _load(silent: true);
                        },
                      ),
                      IconButton(
                        tooltip: '刷新',
                        icon: const Icon(Icons.refresh_rounded),
                        onPressed: () => _load(silent: true),
                      ),
                    ],
                  ),
                ),
                if (_admins.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child:
                        Text('暂无管理员', style: TextStyle(color: theme.hintColor)),
                  )
                else
                  for (final admin in _admins)
                    ListTile(
                      leading: CircleAvatar(
                        child: Text(admin.username.isEmpty
                            ? '?'
                            : admin.username.characters.first.toUpperCase()),
                      ),
                      title: Text(admin.username),
                      subtitle: Text(admin.id),
                      trailing: IconButton(
                        tooltip: '移除管理员',
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Colors.redAccent,
                        onPressed: () => _removeAdmin(admin),
                      ),
                    ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                  child: Row(
                    children: [
                      Text('第 $_adminPage / $_adminPageCount 页'),
                      const Spacer(),
                      IconButton(
                        tooltip: '上一页',
                        icon: const Icon(Icons.chevron_left_rounded),
                        onPressed: _adminPage <= 1
                            ? null
                            : () {
                                setState(() => _adminPage -= 1);
                                _load(silent: true);
                              },
                      ),
                      IconButton(
                        tooltip: '下一页',
                        icon: const Icon(Icons.chevron_right_rounded),
                        onPressed: _adminPage >= _adminPageCount
                            ? null
                            : () {
                                setState(() => _adminPage += 1);
                                _load(silent: true);
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
}

class RoomManagementTab extends StatefulWidget {
  const RoomManagementTab({super.key});

  @override
  State<RoomManagementTab> createState() => _RoomManagementTabState();
}

class _RoomManagementTabState extends State<RoomManagementTab> {
  List<WRoom> _rooms = [];
  bool _isLoading = true;
  int _page = 1;
  int _pageSize = 20;
  int _total = 0;
  String _searchQuery = '';
  common_enum.RoomStatus _statusFilter =
      common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED;
  bool? _bannedFilter;
  admin_enum.RoomListSortBy _sortBy =
      admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_CREATED_AT;
  admin_enum.SortDirection _sortDirection =
      admin_enum.SortDirection.SORT_DIRECTION_DESC;
  final Set<String> _selectedRoomIds = {};

  int get _pageCount =>
      _total <= 0 ? 1 : ((_total + _pageSize - 1) ~/ _pageSize);

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final data = await WatchTogetherService.adminListRoomsPage(
        page: _page,
        pageSize: _pageSize,
        search: _searchQuery,
        status: _statusFilter,
        isBanned: _bannedFilter,
        sortBy: _sortBy,
        sortDirection: _sortDirection,
      );

      if (!mounted) return;

      setState(() {
        _rooms = data.rooms;
        _total = data.total;
        _selectedRoomIds.removeWhere(
          (id) => !_rooms.any((room) => room.roomId == id),
        );
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        MessageUtils.showError(context, '加载房间失败: $e');
      }
    }
  }

  Future<void> _banRoom(WRoom room, bool ban) async {
    final action = ban ? '封禁' : '解封';
    final reasonController = TextEditingController();
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '$action房间',
      icon: Icon(ban ? Icons.block : Icons.check_circle,
          color: ban ? Colors.red : Colors.green),
      content: ban
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('确定要$action房间 "${room.roomName}" 吗？'),
                const SizedBox(height: 12),
                ChatUtils.createFormField(
                  context: context,
                  label: '封禁原因',
                  controller: reasonController,
                  hintText: '可选',
                  prefixIcon: Icons.edit_note_rounded,
                ),
              ],
            )
          : Text('确定要$action房间 "${room.roomName}" 吗？'),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
            context, () => Navigator.pop(context, true),
            text: action),
      ],
    );

    if (confirm == true) {
      try {
        await WatchTogetherService.adminBanRoom(
          room.roomId,
          ban,
          reason: reasonController.text.trim(),
        );
        if (!mounted) return;
        MessageUtils.showSuccess(context, '操作成功');
        _loadRooms(silent: true);
      } catch (e) {
        if (!mounted) return;
        MessageUtils.showError(context, '操作失败: $e');
      }
    }
  }

  Future<void> _deleteRoom(WRoom room) async {
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '删除房间',
      icon: const Icon(Icons.delete_forever, color: Colors.red),
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
        await WatchTogetherService.adminDeleteRoom(room.roomId);
        if (!mounted) return;
        MessageUtils.showSuccess(context, '房间已删除');
        _loadRooms(silent: true);
      } catch (e) {
        if (!mounted) return;
        MessageUtils.showError(context, '删除失败: $e');
      }
    }
  }

  void _toggleRoomSelection(String roomId, bool selected) {
    setState(() {
      if (selected) {
        _selectedRoomIds.add(roomId);
      } else {
        _selectedRoomIds.remove(roomId);
      }
    });
  }

  Future<void> _batchBanRooms() async {
    if (_selectedRoomIds.isEmpty) return;
    final reasonController = TextEditingController();
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '批量封禁房间',
      icon: const Icon(Icons.block_rounded, color: Colors.redAccent),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('将封禁 ${_selectedRoomIds.length} 个房间。'),
          const SizedBox(height: 12),
          ChatUtils.createFormField(
            context: context,
            label: '封禁原因',
            controller: reasonController,
            hintText: '可选',
            prefixIcon: Icons.edit_note_rounded,
          ),
        ],
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: '封禁',
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      final result = await WatchTogetherService.adminBatchBanRooms(
        _selectedRoomIds.toList(),
        reason: reasonController.text.trim(),
      );
      if (!mounted) return;
      _showBatchResult('批量封禁完成', result);
      setState(_selectedRoomIds.clear);
      _loadRooms(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '批量封禁失败: $e');
    }
  }

  Future<void> _batchDeleteRooms() async {
    if (_selectedRoomIds.isEmpty) return;
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '批量删除房间',
      icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
      content: Text('确定删除 ${_selectedRoomIds.length} 个房间吗？此操作不可撤销。'),
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
    if (confirmed != true) return;
    try {
      final result = await WatchTogetherService.adminBatchDeleteRooms(
        _selectedRoomIds.toList(),
      );
      if (!mounted) return;
      _showBatchResult('批量删除完成', result);
      setState(_selectedRoomIds.clear);
      _loadRooms(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '批量删除失败: $e');
    }
  }

  void _showBatchResult(String title, AdminBatchOperationResult result) {
    final failedItems = result.results.where((item) => !item.success).toList();
    final message = failedItems.isEmpty
        ? '$title：成功 ${result.succeeded} 个'
        : '$title：成功 ${result.succeeded} 个，失败 ${result.failed} 个';
    if (failedItems.isEmpty) {
      MessageUtils.showSuccess(context, message);
      return;
    }
    final detail = failedItems
        .take(3)
        .map((item) => '${item.id}: ${item.error}')
        .join('\n');
    MessageUtils.showWarning(context, '$message\n$detail');
  }

  Future<void> _showRoomDetails(WRoom room) async {
    try {
      final detail = await WatchTogetherService.adminGetRoom(room.roomId);
      if (!mounted) return;
      await ChatUtils.showStyledDialog(
        context: context,
        title: detail.roomName,
        icon: const Icon(Icons.meeting_room_rounded, color: Color(0xFF5D5FEF)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoLine('房间 ID', detail.roomId),
            _InfoLine('创建者', '${detail.creator} (${detail.creatorId})'),
            if (detail.description.isNotEmpty)
              _InfoLine('描述', detail.description),
            _InfoLine('成员数', detail.memberCount.toString()),
            _InfoLine('状态', _roomStatusLabel(detail)),
            _InfoLine('创建者状态', _userStatusText(detail.creatorStatus)),
            _InfoLine('资源可用性', _resourceAvailabilityText(detail.availability)),
            _InfoLine('创建时间', _formatTimestamp(detail.createdAt)),
            _InfoLine('更新时间', _formatTimestamp(detail.updatedAt)),
            if (detail.version > 0) _InfoLine('版本', detail.version.toString()),
          ],
        ),
        actions: [_closeButton(context)],
      );
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '加载房间详情失败: $e');
    }
  }

  Future<void> _showRoomMembers(WRoom room) async {
    final searchController = TextEditingController();
    var page = 1;
    var pageSize = 20;
    var roleFilter = common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_UNSPECIFIED;
    var sortBy =
        admin_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_JOINED_AT;
    var sortDirection = admin_enum.SortDirection.SORT_DIRECTION_DESC;

    try {
      final data = await WatchTogetherService.adminListRoomMembersPage(
        room.roomId,
        page: page,
        pageSize: pageSize,
        sortBy: sortBy,
        sortDirection: sortDirection,
      );
      if (!mounted) return;
      var members = data.members;
      var total = data.total;
      var loading = false;
      await ChatUtils.showStyledDialog(
        context: context,
        title: '房间成员',
        icon: const Icon(Icons.group_rounded, color: Color(0xFF5D5FEF)),
        content: SizedBox(
          width: 620,
          height: 560,
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              Future<void> loadMembers() async {
                setDialogState(() => loading = true);
                try {
                  final next =
                      await WatchTogetherService.adminListRoomMembersPage(
                    room.roomId,
                    page: page,
                    pageSize: pageSize,
                    search: searchController.text.trim(),
                    role: roleFilter ==
                            common_enum
                                .RoomMemberRole.ROOM_MEMBER_ROLE_UNSPECIFIED
                        ? null
                        : roleFilter,
                    sortBy: sortBy,
                    sortDirection: sortDirection,
                  );
                  if (!context.mounted) return;
                  setDialogState(() {
                    members = next.members;
                    total = next.total;
                    loading = false;
                  });
                } catch (e) {
                  if (!context.mounted) return;
                  setDialogState(() => loading = false);
                  MessageUtils.showError(context, '加载成员失败: $e');
                }
              }

              final totalPages = total <= 0 ? 1 : ((total - 1) ~/ pageSize) + 1;
              final canPrev = page > 1;
              final canNext = page < totalPages;

              return Column(
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 190,
                        child: TextField(
                          controller: searchController,
                          decoration: const InputDecoration(
                            labelText: '搜索成员',
                            prefixIcon: Icon(Icons.search_rounded),
                            isDense: true,
                          ),
                          onSubmitted: (_) {
                            page = 1;
                            loadMembers();
                          },
                        ),
                      ),
                      DropdownButton<common_enum.RoomMemberRole>(
                        value: roleFilter,
                        items: const [
                          DropdownMenuItem(
                            value: common_enum
                                .RoomMemberRole.ROOM_MEMBER_ROLE_UNSPECIFIED,
                            child: Text('全部角色'),
                          ),
                          DropdownMenuItem(
                            value: common_enum
                                .RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR,
                            child: Text('创建者'),
                          ),
                          DropdownMenuItem(
                            value: common_enum
                                .RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
                            child: Text('管理员'),
                          ),
                          DropdownMenuItem(
                            value: common_enum
                                .RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
                            child: Text('成员'),
                          ),
                          DropdownMenuItem(
                            value: common_enum
                                .RoomMemberRole.ROOM_MEMBER_ROLE_GUEST,
                            child: Text('访客'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          roleFilter = value;
                          page = 1;
                          loadMembers();
                        },
                      ),
                      DropdownButton<admin_enum.RoomMemberListSortBy>(
                        value: sortBy,
                        items: const [
                          DropdownMenuItem(
                            value: admin_enum.RoomMemberListSortBy
                                .ROOM_MEMBER_LIST_SORT_BY_JOINED_AT,
                            child: Text('加入时间'),
                          ),
                          DropdownMenuItem(
                            value: admin_enum.RoomMemberListSortBy
                                .ROOM_MEMBER_LIST_SORT_BY_USERNAME,
                            child: Text('用户名'),
                          ),
                          DropdownMenuItem(
                            value: admin_enum.RoomMemberListSortBy
                                .ROOM_MEMBER_LIST_SORT_BY_ROLE,
                            child: Text('角色'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          sortBy = value;
                          page = 1;
                          loadMembers();
                        },
                      ),
                      IconButton(
                        tooltip: sortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? '降序'
                            : '升序',
                        icon: Icon(
                          sortDirection ==
                                  admin_enum.SortDirection.SORT_DIRECTION_DESC
                              ? Icons.south_rounded
                              : Icons.north_rounded,
                        ),
                        onPressed: () {
                          sortDirection = sortDirection ==
                                  admin_enum.SortDirection.SORT_DIRECTION_DESC
                              ? admin_enum.SortDirection.SORT_DIRECTION_ASC
                              : admin_enum.SortDirection.SORT_DIRECTION_DESC;
                          page = 1;
                          loadMembers();
                        },
                      ),
                      DropdownButton<int>(
                        value: pageSize,
                        items: const [
                          DropdownMenuItem(value: 20, child: Text('20 / 页')),
                          DropdownMenuItem(value: 50, child: Text('50 / 页')),
                          DropdownMenuItem(value: 100, child: Text('100 / 页')),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          pageSize = value;
                          page = 1;
                          loadMembers();
                        },
                      ),
                      IconButton(
                        tooltip: '刷新',
                        icon: const Icon(Icons.refresh_rounded),
                        onPressed: loadMembers,
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _addRoomMember(room);
                        },
                        icon: const Icon(Icons.person_add_alt_rounded),
                        label: const Text('添加成员'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: loading
                        ? const Center(child: CircularProgressIndicator())
                        : members.isEmpty
                            ? const Center(child: Text('暂无成员'))
                            : ListView.builder(
                                itemCount: members.length,
                                itemBuilder: (context, index) {
                                  final member = members[index];
                                  return ListTile(
                                    leading: Icon(
                                      member.isOnline
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      color:
                                          member.isOnline ? Colors.green : null,
                                    ),
                                    title: Text(member.username),
                                    subtitle: Text(
                                      '${member.userId} · ${_roomMemberRoleText(member.role)} · ${_formatTimestamp(member.joinedAt)}',
                                    ),
                                    trailing: Wrap(
                                      spacing: 4,
                                      children: [
                                        IconButton(
                                          tooltip: '切换管理员',
                                          icon: const Icon(Icons
                                              .admin_panel_settings_outlined),
                                          onPressed: () async {
                                            final nextRole = member.role ==
                                                    common_enum
                                                        .RoomMemberRole
                                                        .ROOM_MEMBER_ROLE_ADMIN
                                                        .value
                                                ? common_enum
                                                    .RoomMemberRole
                                                    .ROOM_MEMBER_ROLE_MEMBER
                                                    .value
                                                : common_enum
                                                    .RoomMemberRole
                                                    .ROOM_MEMBER_ROLE_ADMIN
                                                    .value;
                                            await WatchTogetherService
                                                .adminSetRoomMemberRole(
                                              room.roomId,
                                              member.userId,
                                              nextRole,
                                            );
                                            await loadMembers();
                                          },
                                        ),
                                        IconButton(
                                          tooltip: '权限覆盖',
                                          icon: const Icon(Icons.tune_rounded),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            await _editRoomMemberPermissionOverrides(
                                              room,
                                              member,
                                            );
                                          },
                                        ),
                                        IconButton(
                                          tooltip: '踢出',
                                          icon:
                                              const Icon(Icons.logout_rounded),
                                          color: Colors.redAccent,
                                          onPressed: () async {
                                            final cooldown =
                                                await _askKickCooldownSeconds();
                                            if (cooldown == null) return;
                                            await WatchTogetherService
                                                .adminKickRoomMember(
                                              room.roomId,
                                              member.userId,
                                              kickCooldownSeconds: cooldown,
                                            );
                                            await loadMembers();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('共 $total 个成员，第 $page / $totalPages 页'),
                      const Spacer(),
                      IconButton(
                        tooltip: '上一页',
                        icon: const Icon(Icons.chevron_left_rounded),
                        onPressed: canPrev
                            ? () {
                                page -= 1;
                                loadMembers();
                              }
                            : null,
                      ),
                      IconButton(
                        tooltip: '下一页',
                        icon: const Icon(Icons.chevron_right_rounded),
                        onPressed: canNext
                            ? () {
                                page += 1;
                                loadMembers();
                              }
                            : null,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        actions: [_closeButton(context)],
      );
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '加载成员失败: $e');
    }
  }

  Future<void> _addRoomMember(WRoom room) async {
    final controller = TextEditingController();
    int role = common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value;
    var notify = true;
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '添加成员',
      icon: const Icon(Icons.person_add_alt_rounded, color: Color(0xFF5D5FEF)),
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ChatUtils.createFormField(
                context: context,
                label: '用户 ID',
                controller: controller,
                hintText: 'usr_...',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: role,
                decoration: const InputDecoration(labelText: '房间角色'),
                items: [
                  DropdownMenuItem(
                    value: common_enum
                        .RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
                    child: const Text('成员'),
                  ),
                  DropdownMenuItem(
                    value:
                        common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value,
                    child: const Text('管理员'),
                  ),
                ],
                onChanged: (value) => setDialogState(
                  () => role = value ??
                      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
                ),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('通知成员'),
                value: notify,
                onChanged: (value) => setDialogState(() => notify = value),
              ),
            ],
          );
        },
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: '添加',
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      await WatchTogetherService.adminAddRoomMember(
        room.roomId,
        controller.text.trim(),
        role: role,
        notify: notify,
      );
      if (!mounted) return;
      MessageUtils.showSuccess(context, '成员已添加');
      _showRoomMembers(room);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '添加成员失败: $e');
    }
  }

  Future<int?> _askKickCooldownSeconds() async {
    final controller = TextEditingController(text: '60');
    final value = await ChatUtils.showStyledDialog<int>(
      context: context,
      title: '踢出成员',
      icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
      content: ChatUtils.createFormField(
        context: context,
        label: '冷却秒数',
        controller: controller,
        hintText: '1 - 2592000',
        prefixIcon: Icons.timer_outlined,
        keyboardType: TextInputType.number,
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () {
            final seconds = int.tryParse(controller.text.trim());
            if (seconds == null || seconds < 1 || seconds > 2592000) {
              MessageUtils.showWarning(context, '请输入 1 到 2592000 之间的秒数');
              return;
            }
            Navigator.pop(context, seconds);
          },
          text: '踢出',
        ),
      ],
    );
    return value;
  }

  Future<void> _editRoomMemberPermissionOverrides(
    WRoom room,
    AdminRoomMember member,
  ) async {
    final result = await _showPermissionOverrideDialog(member);
    if (result == null) {
      await _showRoomMembers(room);
      return;
    }
    try {
      await WatchTogetherService.adminUpdateRoomMemberPermissionOverrides(
        room.roomId,
        member.userId,
        role: member.role,
        addedPermissions: result.addedPermissions,
        removedPermissions: result.removedPermissions,
        adminAddedPermissions: result.adminAddedPermissions,
        adminRemovedPermissions: result.adminRemovedPermissions,
      );
      if (!mounted) return;
      MessageUtils.showSuccess(context, '成员权限已更新');
      await _showRoomMembers(room);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '更新成员权限失败: $e');
      await _showRoomMembers(room);
    }
  }

  Future<_PermissionOverrideResult?> _showPermissionOverrideDialog(
    AdminRoomMember member,
  ) {
    final isAdmin =
        member.role == common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value;
    var added =
        isAdmin ? member.adminAddedPermissions : member.addedPermissions;
    var removed =
        isAdmin ? member.adminRemovedPermissions : member.removedPermissions;

    return ChatUtils.showStyledDialog<_PermissionOverrideResult>(
      context: context,
      title: '权限覆盖',
      icon: const Icon(Icons.tune_rounded, color: Color(0xFF5D5FEF)),
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          void setOverride(int flag, _PermissionOverrideMode mode) {
            setDialogState(() {
              added &= ~flag;
              removed &= ~flag;
              switch (mode) {
                case _PermissionOverrideMode.inherit:
                  break;
                case _PermissionOverrideMode.allow:
                  added |= flag;
                case _PermissionOverrideMode.deny:
                  removed |= flag;
              }
            });
          }

          return SizedBox(
            width: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: RoomMemberPermissions.descriptions.entries
                  .map(
                    (entry) => _permissionOverrideRow(
                      entry.value,
                      entry.key,
                      added,
                      removed,
                      setOverride,
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
              const _PermissionOverrideResult(
                addedPermissions: 0,
                removedPermissions: 0,
                adminAddedPermissions: 0,
                adminRemovedPermissions: 0,
              ),
            );
          },
          child: const Text('清除覆盖'),
        ),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () {
            Navigator.pop(
              context,
              _PermissionOverrideResult(
                addedPermissions: isAdmin ? 0 : added,
                removedPermissions: isAdmin ? 0 : removed,
                adminAddedPermissions: isAdmin ? added : 0,
                adminRemovedPermissions: isAdmin ? removed : 0,
              ),
            );
          },
          text: '保存',
        ),
      ],
    );
  }

  Widget _permissionOverrideRow(
    String title,
    int flag,
    int added,
    int removed,
    void Function(int flag, _PermissionOverrideMode mode) onChanged,
  ) {
    final mode = (added & flag) != 0
        ? _PermissionOverrideMode.allow
        : (removed & flag) != 0
            ? _PermissionOverrideMode.deny
            : _PermissionOverrideMode.inherit;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          SegmentedButton<_PermissionOverrideMode>(
            segments: const [
              ButtonSegment(
                value: _PermissionOverrideMode.inherit,
                label: Text('继承'),
              ),
              ButtonSegment(
                value: _PermissionOverrideMode.allow,
                label: Text('允许'),
              ),
              ButtonSegment(
                value: _PermissionOverrideMode.deny,
                label: Text('拒绝'),
              ),
            ],
            selected: {mode},
            onSelectionChanged: (selection) {
              onChanged(flag, selection.single);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _editRoomSettings(WRoom room) async {
    try {
      final settings = await WatchTogetherService.adminGetRoomSettings(
        room.roomId,
      );
      if (!mounted) return;
      final maxMembers =
          TextEditingController(text: settings.maxMembers.toString());
      final password = TextEditingController();
      bool requirePassword = settings.requirePassword;
      bool requireApproval = settings.requireApproval;
      bool allowGuestJoin = settings.allowGuestJoin;
      bool chatEnabled = settings.chatEnabled;
      bool danmakuEnabled = settings.danmakuEnabled;
      var passwordAction = _RoomPasswordAction.keep;
      final confirmed = await ChatUtils.showStyledDialog<bool>(
        context: context,
        title: '房间设置',
        icon: const Icon(Icons.tune_rounded, color: Color(0xFF5D5FEF)),
        content: StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    value: requirePassword,
                    onChanged: (value) =>
                        setDialogState(() => requirePassword = value),
                    title: const Text('需要密码'),
                  ),
                  SwitchListTile(
                    value: requireApproval,
                    onChanged: (value) =>
                        setDialogState(() => requireApproval = value),
                    title: const Text('加入需要审核'),
                  ),
                  SwitchListTile(
                    value: allowGuestJoin,
                    onChanged: (value) =>
                        setDialogState(() => allowGuestJoin = value),
                    title: const Text('允许访客加入'),
                  ),
                  SwitchListTile(
                    value: chatEnabled,
                    onChanged: (value) =>
                        setDialogState(() => chatEnabled = value),
                    title: const Text('聊天'),
                  ),
                  SwitchListTile(
                    value: danmakuEnabled,
                    onChanged: (value) =>
                        setDialogState(() => danmakuEnabled = value),
                    title: const Text('弹幕'),
                  ),
                  ChatUtils.createFormField(
                    context: dialogContext,
                    label: '最大成员数',
                    controller: maxMembers,
                    hintText: '100',
                    prefixIcon: Icons.groups_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<_RoomPasswordAction>(
                    initialValue: passwordAction,
                    decoration: const InputDecoration(labelText: '密码操作'),
                    items: const [
                      DropdownMenuItem(
                        value: _RoomPasswordAction.keep,
                        child: Text('保持不变'),
                      ),
                      DropdownMenuItem(
                        value: _RoomPasswordAction.update,
                        child: Text('设置新密码'),
                      ),
                      DropdownMenuItem(
                        value: _RoomPasswordAction.clear,
                        child: Text('清除密码'),
                      ),
                    ],
                    onChanged: (value) => setDialogState(() {
                      passwordAction = value ?? _RoomPasswordAction.keep;
                      if (passwordAction != _RoomPasswordAction.update) {
                        password.clear();
                      }
                    }),
                  ),
                  if (passwordAction == _RoomPasswordAction.update) ...[
                    const SizedBox(height: 12),
                    ChatUtils.createFormField(
                      context: dialogContext,
                      label: '新密码',
                      controller: password,
                      hintText: '请输入新密码',
                      prefixIcon: Icons.lock_outline,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await WatchTogetherService.adminResetRoomSettings(room.roomId);
              if (!mounted) return;
              Navigator.pop(context, false);
              MessageUtils.showSuccess(context, '房间设置已重置');
            },
            child: const Text('重置'),
          ),
          ChatUtils.createCancelButton(context),
          const SizedBox(width: 8),
          ChatUtils.createConfirmButton(
            context,
            () => Navigator.pop(context, true),
            text: '保存',
          ),
        ],
      );
      if (confirmed != true) return;
      if (!mounted) return;
      final nextPassword = password.text.trim();
      if (passwordAction == _RoomPasswordAction.update &&
          nextPassword.isEmpty) {
        MessageUtils.showWarning(context, '请输入新密码');
        return;
      }
      settings.requirePassword = requirePassword;
      settings.requireApproval = requireApproval;
      settings.allowGuestJoin = allowGuestJoin;
      settings.chatEnabled = chatEnabled;
      settings.danmakuEnabled = danmakuEnabled;
      settings.maxMembers =
          int.tryParse(maxMembers.text.trim()) ?? settings.maxMembers;
      await WatchTogetherService.adminUpdateRoomSettings(
        room.roomId,
        settings,
      );
      switch (passwordAction) {
        case _RoomPasswordAction.keep:
          break;
        case _RoomPasswordAction.update:
          await WatchTogetherService.adminUpdateRoomPassword(
            room.roomId,
            nextPassword,
          );
        case _RoomPasswordAction.clear:
          await WatchTogetherService.adminUpdateRoomPassword(room.roomId, '');
      }
      if (!mounted) return;
      MessageUtils.showSuccess(context, '房间设置已保存');
      _loadRooms(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '保存房间设置失败: $e');
    }
  }

  String _getStatusText(int status) {
    switch (status) {
      case 1:
        return '活跃';
      case 2:
        return '已关闭';
      default:
        return '未知';
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _roomStatusLabel(WRoom room) {
    return room.isBanned ? '已封禁' : _getStatusText(room.status);
  }

  Color _roomStatusColorForRoom(WRoom room) {
    return room.isBanned ? Colors.red : _getStatusColor(room.status);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: _buildStyledTextField(
                  onSubmitted: (val) {
                    setState(() {
                      _searchQuery = val;
                      _page = 1;
                    });
                    _loadRooms();
                  },
                  hint: '搜索房间',
                  icon: Icons.search,
                  isDark: isDark,
                  theme: theme,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade900 : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<common_enum.RoomStatus>(
                    value: _statusFilter,
                    icon: const Icon(Icons.filter_list_rounded, size: 20),
                    items: const [
                      DropdownMenuItem(
                        value: common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED,
                        child: Text('全部状态'),
                      ),
                      DropdownMenuItem(
                        value: common_enum.RoomStatus.ROOM_STATUS_ACTIVE,
                        child: Text('活跃'),
                      ),
                      DropdownMenuItem(
                        value: common_enum.RoomStatus.ROOM_STATUS_CLOSED,
                        child: Text('已关闭'),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _statusFilter = val ??
                            common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED;
                        _page = 1;
                      });
                      _loadRooms();
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<bool?>(
                value: _bannedFilter,
                items: const [
                  DropdownMenuItem(value: null, child: Text('全部封禁')),
                  DropdownMenuItem(value: true, child: Text('仅封禁')),
                  DropdownMenuItem(value: false, child: Text('未封禁')),
                ],
                onChanged: (value) {
                  setState(() {
                    _bannedFilter = value;
                    _page = 1;
                  });
                  _loadRooms();
                },
              ),
              const SizedBox(width: 8),
              DropdownButton<admin_enum.RoomListSortBy>(
                value: _sortBy,
                items: const [
                  DropdownMenuItem(
                    value:
                        admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_CREATED_AT,
                    child: Text('创建时间'),
                  ),
                  DropdownMenuItem(
                    value:
                        admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_UPDATED_AT,
                    child: Text('更新时间'),
                  ),
                  DropdownMenuItem(
                    value: admin_enum
                        .RoomListSortBy.ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
                    child: Text('最近活跃'),
                  ),
                  DropdownMenuItem(
                    value: admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_NAME,
                    child: Text('房间名'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _sortBy = value;
                    _page = 1;
                  });
                  _loadRooms();
                },
              ),
              IconButton(
                tooltip: _sortDirection ==
                        admin_enum.SortDirection.SORT_DIRECTION_DESC
                    ? '降序'
                    : '升序',
                icon: Icon(
                  _sortDirection == admin_enum.SortDirection.SORT_DIRECTION_DESC
                      ? Icons.south_rounded
                      : Icons.north_rounded,
                ),
                onPressed: () {
                  setState(() {
                    _sortDirection = _sortDirection ==
                            admin_enum.SortDirection.SORT_DIRECTION_DESC
                        ? admin_enum.SortDirection.SORT_DIRECTION_ASC
                        : admin_enum.SortDirection.SORT_DIRECTION_DESC;
                    _page = 1;
                  });
                  _loadRooms();
                },
              ),
              DropdownButton<int>(
                value: _pageSize,
                items: const [
                  DropdownMenuItem(value: 20, child: Text('20 / 页')),
                  DropdownMenuItem(value: 50, child: Text('50 / 页')),
                  DropdownMenuItem(value: 100, child: Text('100 / 页')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _pageSize = value;
                    _page = 1;
                  });
                  _loadRooms();
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: '选择当前页',
                icon: const Icon(Icons.select_all_rounded),
                onPressed: _rooms.isEmpty
                    ? null
                    : () {
                        setState(() {
                          _selectedRoomIds.addAll(
                            _rooms.map((room) => room.roomId),
                          );
                        });
                      },
              ),
            ],
          ),
        ),
        if (_selectedRoomIds.isNotEmpty) _buildRoomBatchBar(theme, isDark),
        _AdminPager(
          page: _page,
          pageSize: _pageSize,
          total: _total,
          onPrevious: _page <= 1
              ? null
              : () {
                  setState(() => _page -= 1);
                  _loadRooms();
                },
          onNext: _page >= _pageCount
              ? null
              : () {
                  setState(() => _page += 1);
                  _loadRooms();
                },
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _rooms.isEmpty
                  ? Center(
                      child: Text('暂无房间',
                          style: TextStyle(color: theme.hintColor)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: _rooms.length,
                      itemBuilder: (context, index) {
                        final room = _rooms[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey.shade900 : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: Checkbox(
                              value: _selectedRoomIds.contains(room.roomId),
                              onChanged: (value) => _toggleRoomSelection(
                                room.roomId,
                                value ?? false,
                              ),
                            ),
                            title: Text(room.roomName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _roomStatusColorForRoom(room)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                          color: _roomStatusColorForRoom(room)
                                              .withValues(alpha: 0.5)),
                                    ),
                                    child: Text(
                                      _roomStatusLabel(room),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: _roomStatusColorForRoom(room),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                      child: Text('ID: ${room.roomId}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: theme.hintColor))),
                                ],
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!room.isBanned)
                                  IconButton(
                                    icon: const Icon(Icons.block, size: 22),
                                    color: Colors.orange,
                                    tooltip: '封禁',
                                    onPressed: () => _banRoom(room, true),
                                  )
                                else
                                  IconButton(
                                    icon: const Icon(Icons.check_circle,
                                        size: 22),
                                    color: Colors.green,
                                    tooltip: '解封',
                                    onPressed: () => _banRoom(room, false),
                                  ),
                                IconButton(
                                  icon:
                                      const Icon(Icons.info_outline, size: 22),
                                  color: Colors.blueGrey,
                                  tooltip: '详情',
                                  onPressed: () => _showRoomDetails(room),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.group_outlined,
                                      size: 22),
                                  color: Colors.blue,
                                  tooltip: '成员',
                                  onPressed: () => _showRoomMembers(room),
                                ),
                                IconButton(
                                  icon:
                                      const Icon(Icons.tune_rounded, size: 22),
                                  color: Colors.deepPurple,
                                  tooltip: '设置',
                                  onPressed: () => _editRoomSettings(room),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      size: 22),
                                  color: Colors.redAccent,
                                  tooltip: '删除',
                                  onPressed: () => _deleteRoom(room),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildRoomBatchBar(ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(Icons.checklist_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text('已选择 ${_selectedRoomIds.length} 个房间')),
          TextButton(
            onPressed: () => setState(_selectedRoomIds.clear),
            child: const Text('清空'),
          ),
          const SizedBox(width: 4),
          FilledButton.icon(
            onPressed: _batchBanRooms,
            icon: const Icon(Icons.block_rounded),
            label: const Text('封禁'),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: _batchDeleteRooms,
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('删除'),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledTextField({
    required Function(String) onSubmitted,
    required String hint,
    required IconData icon,
    required bool isDark,
    required ThemeData theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onSubmitted: onSubmitted,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: theme.hintColor, size: 20),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          isDense: true,
        ),
      ),
    );
  }
}

class UserManagementTab extends StatefulWidget {
  const UserManagementTab({super.key});

  @override
  State<UserManagementTab> createState() => _UserManagementTabState();
}

class _UserManagementTabState extends State<UserManagementTab> {
  List<WUser> _users = [];
  bool _isLoading = true;
  int _page = 1;
  int _pageSize = 20;
  int _total = 0;
  String _searchQuery = '';
  common_enum.UserStatus _statusFilter =
      common_enum.UserStatus.USER_STATUS_UNSPECIFIED;
  common_enum.UserRole _roleFilter = common_enum.UserRole.USER_ROLE_UNSPECIFIED;
  bool? _bannedFilter;
  admin_enum.UserListSortBy _sortBy =
      admin_enum.UserListSortBy.USER_LIST_SORT_BY_CREATED_AT;
  admin_enum.SortDirection _sortDirection =
      admin_enum.SortDirection.SORT_DIRECTION_DESC;
  final Set<String> _selectedUserIds = {};

  int get _pageCount =>
      _total <= 0 ? 1 : ((_total + _pageSize - 1) ~/ _pageSize);

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final data = await WatchTogetherService.adminListUsersPage(
        page: _page,
        pageSize: _pageSize,
        search: _searchQuery,
        status: _statusFilter,
        role: _roleFilter,
        isBanned: _bannedFilter,
        sortBy: _sortBy,
        sortDirection: _sortDirection,
      );

      if (!mounted) return;

      setState(() {
        _users = data.users;
        _total = data.total;
        _selectedUserIds.removeWhere(
          (id) => !_users.any((user) => user.id == id),
        );
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        MessageUtils.showError(context, '加载用户失败: $e');
      }
    }
  }

  Future<void> _addUser() async {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    int role = common_enum.UserRole.USER_ROLE_USER.value;
    var status = common_enum.UserStatus.USER_STATUS_ACTIVE;

    await ChatUtils.showStyledDialog(
      context: context,
      title: '新增用户',
      icon: const Icon(Icons.person_add, color: Color(0xFF5D5FEF)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChatUtils.createFormField(
            context: context,
            label: '用户名',
            controller: usernameController,
            hintText: '请输入用户名',
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          ChatUtils.createFormField(
            context: context,
            label: '邮箱',
            controller: emailController,
            hintText: '可选',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          ChatUtils.createFormField(
            context: context,
            label: '密码',
            controller: passwordController,
            hintText: '请输入密码',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: role,
            decoration: const InputDecoration(labelText: '角色'),
            items: [
              DropdownMenuItem(
                value: common_enum.UserRole.USER_ROLE_USER.value,
                child: const Text('普通用户'),
              ),
              DropdownMenuItem(
                value: common_enum.UserRole.USER_ROLE_ADMIN.value,
                child: const Text('管理员'),
              ),
            ],
            onChanged: (val) => role = val!,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<common_enum.UserStatus>(
            initialValue: status,
            decoration: const InputDecoration(labelText: '状态'),
            items: const [
              DropdownMenuItem(
                value: common_enum.UserStatus.USER_STATUS_ACTIVE,
                child: Text('正常'),
              ),
              DropdownMenuItem(
                value: common_enum.UserStatus.USER_STATUS_BANNED,
                child: Text('已封禁'),
              ),
            ],
            onChanged: (val) =>
                status = val ?? common_enum.UserStatus.USER_STATUS_ACTIVE,
          ),
        ],
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(context, () async {
          if (usernameController.text.isEmpty ||
              passwordController.text.isEmpty) {
            MessageUtils.showWarning(context, '请填写完整信息');
            return;
          }
          try {
            await WatchTogetherService.adminAddUser(
              usernameController.text,
              passwordController.text,
              role,
              email: emailController.text.trim(),
              status: status,
            );
            if (!mounted) return;
            Navigator.pop(context);
            MessageUtils.showSuccess(context, '用户创建成功');
            _loadUsers(silent: true);
          } catch (e) {
            if (!mounted) return;
            MessageUtils.showError(context, '创建失败: $e');
          }
        }, text: '创建'),
      ],
    );
  }

  Future<void> _deleteUser(WUser user) async {
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '删除用户',
      icon: const Icon(Icons.warning, color: Colors.red),
      content: Text('确定要删除用户 "${user.username}" 吗？此操作不可撤销。'),
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
        await WatchTogetherService.adminDeleteUser(user.id);
        if (!mounted) return;
        MessageUtils.showSuccess(context, '用户已删除');
        _loadUsers(silent: true);
      } catch (e) {
        if (!mounted) return;
        MessageUtils.showError(context, '删除失败: $e');
      }
    }
  }

  Future<void> _toggleAdmin(WUser user) async {
    final isAdmin = user.role == common_enum.UserRole.USER_ROLE_ADMIN.value ||
        user.role == common_enum.UserRole.USER_ROLE_ROOT.value;
    if (user.role == common_enum.UserRole.USER_ROLE_ROOT.value) {
      MessageUtils.showWarning(context, 'Root 用户不能在这里降级');
      return;
    }
    final action = isAdmin ? '取消管理员' : '设为管理员';

    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '修改权限',
      icon: const Icon(Icons.admin_panel_settings, color: Color(0xFF5D5FEF)),
      content: Text('确定要将用户 "${user.username}" $action 吗？'),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
            context, () => Navigator.pop(context, true),
            text: '确定'),
      ],
    );

    if (confirm == true) {
      try {
        await WatchTogetherService.adminSetAdmin(user.id, !isAdmin);
        if (!mounted) return;
        MessageUtils.showSuccess(context, '操作成功');
        _loadUsers(silent: true);
      } catch (e) {
        if (!mounted) return;
        MessageUtils.showError(context, '操作失败: $e');
      }
    }
  }

  Future<void> _banUser(WUser user, bool ban) async {
    final action = ban ? '封禁' : '解封';
    final reasonController = TextEditingController();
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '$action用户',
      icon: Icon(ban ? Icons.block : Icons.check_circle,
          color: ban ? Colors.red : Colors.green),
      content: ban
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('确定要$action用户 "${user.username}" 吗？'),
                const SizedBox(height: 12),
                ChatUtils.createFormField(
                  context: context,
                  label: '封禁原因',
                  controller: reasonController,
                  hintText: '可选',
                  prefixIcon: Icons.edit_note_rounded,
                ),
              ],
            )
          : Text('确定要$action用户 "${user.username}" 吗？'),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
            context, () => Navigator.pop(context, true),
            text: '确定'),
      ],
    );

    if (confirm == true) {
      try {
        await WatchTogetherService.adminBanUser(
          user.id,
          ban,
          reason: reasonController.text.trim(),
        );
        if (!mounted) return;
        MessageUtils.showSuccess(context, '操作成功');
        _loadUsers(silent: true);
      } catch (e) {
        if (!mounted) return;
        MessageUtils.showError(context, '操作失败: $e');
      }
    }
  }

  void _toggleUserSelection(String userId, bool selected) {
    setState(() {
      if (selected) {
        _selectedUserIds.add(userId);
      } else {
        _selectedUserIds.remove(userId);
      }
    });
  }

  Future<void> _batchBanUsers() async {
    if (_selectedUserIds.isEmpty) return;
    final reasonController = TextEditingController();
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '批量封禁用户',
      icon: const Icon(Icons.block_rounded, color: Colors.redAccent),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('将封禁 ${_selectedUserIds.length} 个用户。'),
          const SizedBox(height: 12),
          ChatUtils.createFormField(
            context: context,
            label: '封禁原因',
            controller: reasonController,
            hintText: '可选',
            prefixIcon: Icons.edit_note_rounded,
          ),
        ],
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: '封禁',
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      final result = await WatchTogetherService.adminBatchBanUsers(
        _selectedUserIds.toList(),
        reason: reasonController.text.trim(),
      );
      if (!mounted) return;
      _showBatchResult('批量封禁完成', result);
      setState(_selectedUserIds.clear);
      _loadUsers(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '批量封禁失败: $e');
    }
  }

  Future<void> _batchDeleteUsers() async {
    if (_selectedUserIds.isEmpty) return;
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '批量删除用户',
      icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
      content: Text('确定删除 ${_selectedUserIds.length} 个用户吗？此操作不可撤销。'),
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
    if (confirmed != true) return;
    try {
      final result = await WatchTogetherService.adminBatchDeleteUsers(
        _selectedUserIds.toList(),
      );
      if (!mounted) return;
      _showBatchResult('批量删除完成', result);
      setState(_selectedUserIds.clear);
      _loadUsers(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '批量删除失败: $e');
    }
  }

  void _showBatchResult(String title, AdminBatchOperationResult result) {
    final failedItems = result.results.where((item) => !item.success).toList();
    final message = failedItems.isEmpty
        ? '$title：成功 ${result.succeeded} 个'
        : '$title：成功 ${result.succeeded} 个，失败 ${result.failed} 个';
    if (failedItems.isEmpty) {
      MessageUtils.showSuccess(context, message);
      return;
    }
    final detail = failedItems
        .take(3)
        .map((item) => '${item.id}: ${item.error}')
        .join('\n');
    MessageUtils.showWarning(context, '$message\n$detail');
  }

  Future<void> _showUserDetails(WUser user) async {
    try {
      final results = await Future.wait([
        WatchTogetherService.adminGetUser(user.id),
        WatchTogetherService.adminGetUserPreferences(user.id),
      ]);
      if (!mounted) return;
      final detail = results[0] as WUser;
      final preferences = results[1] as AccountPreferences;
      await ChatUtils.showStyledDialog(
        context: context,
        title: detail.username,
        icon: const Icon(Icons.person_rounded, color: Color(0xFF5D5FEF)),
        content: SizedBox(
          width: 620,
          height: 520,
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: '资料'),
                    Tab(text: '房间'),
                    Tab(text: '偏好'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildUserProfileDetails(detail),
                      _buildUserRoomsPanel(user.id),
                      _buildUserPreferencesPanel(user.id, preferences),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [_closeButton(context)],
      );
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '加载用户详情失败: $e');
    }
  }

  Widget _buildUserProfileDetails(WUser detail) {
    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        _InfoLine('用户 ID', detail.id),
        _InfoLine('邮箱', detail.email ?? '-'),
        _InfoLine('角色', _systemRoleText(detail.role)),
        _InfoLine('状态', _userStatusText(detail.status)),
        _InfoLine('创建时间', _formatTimestamp(detail.createdAt)),
        if (detail.updatedAt > 0)
          _InfoLine('更新时间', _formatTimestamp(detail.updatedAt)),
        if (detail.isBanned) ...[
          _InfoLine('封禁时间', _formatTimestamp(detail.bannedAt)),
          if (detail.bannedBy.isNotEmpty) _InfoLine('封禁操作者', detail.bannedBy),
          if (detail.bannedReason.isNotEmpty)
            _InfoLine('封禁原因', detail.bannedReason),
        ],
      ],
    );
  }

  Widget _buildUserRoomsPanel(String userId) {
    var rooms = <WRoom>[];
    var total = 0;
    var page = 1;
    var pageSize = 20;
    var search = '';
    var status = common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED;
    bool? isBanned;
    var sortBy = admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_CREATED_AT;
    var sortDirection = admin_enum.SortDirection.SORT_DIRECTION_DESC;
    var loading = true;
    var initialized = false;

    return StatefulBuilder(
      builder: (context, setDialogState) {
        Future<void> loadRooms() async {
          setDialogState(() => loading = true);
          try {
            final data = await WatchTogetherService.adminListUserRoomsPage(
              userId,
              page: page,
              pageSize: pageSize,
              search: search,
              status: status,
              isBanned: isBanned,
              sortBy: sortBy,
              sortDirection: sortDirection,
            );
            if (!context.mounted) return;
            setDialogState(() {
              rooms = data.rooms;
              total = data.total;
              loading = false;
            });
          } catch (e) {
            if (!context.mounted) return;
            setDialogState(() => loading = false);
            MessageUtils.showError(context, '加载用户房间失败: $e');
          }
        }

        if (!initialized) {
          initialized = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) loadRooms();
          });
        }

        final pageCount = total <= 0 ? 1 : ((total + pageSize - 1) ~/ pageSize);
        return Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 180,
                    child: TextField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded),
                        hintText: '搜索房间',
                        isDense: true,
                      ),
                      onSubmitted: (value) {
                        search = value.trim();
                        page = 1;
                        loadRooms();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<common_enum.RoomStatus>(
                    value: status,
                    items: const [
                      DropdownMenuItem(
                        value: common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED,
                        child: Text('全部状态'),
                      ),
                      DropdownMenuItem(
                        value: common_enum.RoomStatus.ROOM_STATUS_ACTIVE,
                        child: Text('活跃'),
                      ),
                      DropdownMenuItem(
                        value: common_enum.RoomStatus.ROOM_STATUS_CLOSED,
                        child: Text('已关闭'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      status = value;
                      page = 1;
                      loadRooms();
                    },
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<bool?>(
                    value: isBanned,
                    items: const [
                      DropdownMenuItem(value: null, child: Text('全部封禁')),
                      DropdownMenuItem(value: true, child: Text('仅封禁')),
                      DropdownMenuItem(value: false, child: Text('未封禁')),
                    ],
                    onChanged: (value) {
                      isBanned = value;
                      page = 1;
                      loadRooms();
                    },
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<admin_enum.RoomListSortBy>(
                    value: sortBy,
                    items: const [
                      DropdownMenuItem(
                        value: admin_enum
                            .RoomListSortBy.ROOM_LIST_SORT_BY_CREATED_AT,
                        child: Text('创建时间'),
                      ),
                      DropdownMenuItem(
                        value: admin_enum
                            .RoomListSortBy.ROOM_LIST_SORT_BY_UPDATED_AT,
                        child: Text('更新时间'),
                      ),
                      DropdownMenuItem(
                        value: admin_enum
                            .RoomListSortBy.ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
                        child: Text('最近活跃'),
                      ),
                      DropdownMenuItem(
                        value: admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_NAME,
                        child: Text('房间名'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      sortBy = value;
                      page = 1;
                      loadRooms();
                    },
                  ),
                  IconButton(
                    tooltip: sortDirection ==
                            admin_enum.SortDirection.SORT_DIRECTION_DESC
                        ? '降序'
                        : '升序',
                    icon: Icon(
                      sortDirection ==
                              admin_enum.SortDirection.SORT_DIRECTION_DESC
                          ? Icons.south_rounded
                          : Icons.north_rounded,
                    ),
                    onPressed: () {
                      sortDirection = sortDirection ==
                              admin_enum.SortDirection.SORT_DIRECTION_DESC
                          ? admin_enum.SortDirection.SORT_DIRECTION_ASC
                          : admin_enum.SortDirection.SORT_DIRECTION_DESC;
                      page = 1;
                      loadRooms();
                    },
                  ),
                  DropdownButton<int>(
                    value: pageSize,
                    items: const [
                      DropdownMenuItem(value: 20, child: Text('20 / 页')),
                      DropdownMenuItem(value: 50, child: Text('50 / 页')),
                      DropdownMenuItem(value: 100, child: Text('100 / 页')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      pageSize = value;
                      page = 1;
                      loadRooms();
                    },
                  ),
                  IconButton(
                    tooltip: '刷新',
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: loadRooms,
                  ),
                ],
              ),
            ),
            _AdminPager(
              page: page,
              pageSize: pageSize,
              total: total,
              onPrevious: page <= 1
                  ? null
                  : () {
                      page -= 1;
                      loadRooms();
                    },
              onNext: page >= pageCount
                  ? null
                  : () {
                      page += 1;
                      loadRooms();
                    },
            ),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : rooms.isEmpty
                      ? const Center(child: Text('暂无房间'))
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 8),
                          itemCount: rooms.length,
                          itemBuilder: (context, index) {
                            final room = rooms[index];
                            return ListTile(
                              dense: true,
                              leading: Icon(
                                Icons.meeting_room_outlined,
                                color: room.isBanned
                                    ? Colors.red
                                    : _roomStatusColor(room.status),
                              ),
                              title: Text(
                                room.roomName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${room.roomId} · ${room.isBanned ? '已封禁' : _roomStatusText(room.status)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                        ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserPreferencesPanel(
    String userId,
    AccountPreferences initialPreferences,
  ) {
    AccountPreferences preferences = initialPreferences;
    var notifications = preferences.notifications;

    return StatefulBuilder(
      builder: (context, setDialogState) {
        Future<void> savePreferences({
          bool? twoFactorEnabled,
          NotificationPreferences? nextNotifications,
        }) async {
          try {
            final updated =
                await WatchTogetherService.adminUpdateUserPreferences(
              userId,
              twoFactorEnabled: twoFactorEnabled,
              notifications: nextNotifications,
            );
            if (!context.mounted) return;
            setDialogState(() {
              preferences = updated;
              notifications = updated.notifications;
            });
            MessageUtils.showSuccess(context, '偏好已更新');
          } catch (e) {
            if (!context.mounted) return;
            MessageUtils.showError(context, '保存偏好失败: $e');
          }
        }

        Widget notificationSwitch(
          String title,
          bool value,
          NotificationPreferences Function(bool value) update,
        ) {
          return SwitchListTile(
            dense: true,
            value: value,
            title: Text(title),
            onChanged: (value) {
              final next = update(value);
              setDialogState(() => notifications = next);
              savePreferences(nextNotifications: next);
            },
          );
        }

        return ListView(
          padding: const EdgeInsets.only(top: 12),
          children: [
            SwitchListTile(
              value: preferences.twoFactorEnabled,
              title: const Text('多因素认证'),
              subtitle: Text(
                '可用因子 ${preferences.eligibleFactorCount} 个：'
                '密码 ${preferences.canUsePassword ? '可用' : '不可用'}，'
                '邮箱 ${preferences.canUseEmail ? '可用' : '不可用'}，'
                'Passkey ${preferences.canUsePasskey ? '可用' : '不可用'}',
              ),
              onChanged: (value) => savePreferences(twoFactorEnabled: value),
            ),
            const Divider(height: 20),
            notificationSwitch(
              '房间邀请站内通知',
              notifications.roomInvitationInApp,
              (value) => notifications.copyWith(roomInvitationInApp: value),
            ),
            notificationSwitch(
              '房间事件站内通知',
              notifications.roomEventInApp,
              (value) => notifications.copyWith(roomEventInApp: value),
            ),
            notificationSwitch(
              '系统公告站内通知',
              notifications.systemAnnouncementInApp,
              (value) => notifications.copyWith(systemAnnouncementInApp: value),
            ),
            notificationSwitch(
              '房间邀请邮件',
              notifications.roomInvitationEmail,
              (value) => notifications.copyWith(roomInvitationEmail: value),
            ),
            notificationSwitch(
              '房间事件邮件',
              notifications.roomEventEmail,
              (value) => notifications.copyWith(roomEventEmail: value),
            ),
            notificationSwitch(
              '系统公告邮件',
              notifications.systemAnnouncementEmail,
              (value) => notifications.copyWith(systemAnnouncementEmail: value),
            ),
          ],
        );
      },
    );
  }

  Future<void> _renameUser(WUser user) async {
    final controller = TextEditingController(text: user.username);
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '修改用户名',
      icon: const Icon(Icons.drive_file_rename_outline_rounded,
          color: Color(0xFF5D5FEF)),
      content: ChatUtils.createFormField(
        context: context,
        label: '新用户名',
        controller: controller,
        hintText: '3-50 个字符',
        prefixIcon: Icons.person_outline,
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: '保存',
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      await WatchTogetherService.adminUpdateUsername(
        user.id,
        controller.text.trim(),
      );
      if (!mounted) return;
      MessageUtils.showSuccess(context, '用户名已更新');
      _loadUsers(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '修改失败: $e');
    }
  }

  Future<void> _resetPassword(WUser user) async {
    final password = TextEditingController();
    final reason = TextEditingController();
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '重置密码',
      icon: const Icon(Icons.lock_reset_rounded, color: Colors.orange),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChatUtils.createFormField(
            context: context,
            label: '新密码',
            controller: password,
            hintText: '至少 8 个字符',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),
          const SizedBox(height: 12),
          ChatUtils.createFormField(
            context: context,
            label: '审计原因',
            controller: reason,
            hintText: '可选',
            prefixIcon: Icons.edit_note_rounded,
          ),
        ],
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: '重置',
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      await WatchTogetherService.adminUpdatePassword(
        user.id,
        password.text,
        reason: reason.text.trim(),
      );
      if (!mounted) return;
      MessageUtils.showSuccess(context, '密码已重置');
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '重置失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStyledTextField(
                      onSubmitted: (val) {
                        setState(() {
                          _searchQuery = val;
                          _page = 1;
                        });
                        _loadUsers();
                      },
                      hint: '搜索用户',
                      icon: Icons.search,
                      isDark: isDark,
                      theme: theme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade900 : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _addUser,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 14),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person_add_rounded,
                                  color: theme.primaryColor, size: 20),
                              const SizedBox(width: 8),
                              Text('新增',
                                  style: TextStyle(
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: '选择当前页',
                    icon: const Icon(Icons.select_all_rounded),
                    onPressed: _users.isEmpty
                        ? null
                        : () {
                            setState(() {
                              _selectedUserIds.addAll(
                                _users.map((user) => user.id),
                              );
                            });
                          },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    DropdownButton<common_enum.UserStatus>(
                      value: _statusFilter,
                      items: const [
                        DropdownMenuItem(
                          value: common_enum.UserStatus.USER_STATUS_UNSPECIFIED,
                          child: Text('全部状态'),
                        ),
                        DropdownMenuItem(
                          value: common_enum.UserStatus.USER_STATUS_ACTIVE,
                          child: Text('正常'),
                        ),
                        DropdownMenuItem(
                          value: common_enum.UserStatus.USER_STATUS_BANNED,
                          child: Text('已封禁'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _statusFilter = value ??
                              common_enum.UserStatus.USER_STATUS_UNSPECIFIED;
                          _page = 1;
                        });
                        _loadUsers();
                      },
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<common_enum.UserRole>(
                      value: _roleFilter,
                      items: const [
                        DropdownMenuItem(
                          value: common_enum.UserRole.USER_ROLE_UNSPECIFIED,
                          child: Text('全部角色'),
                        ),
                        DropdownMenuItem(
                          value: common_enum.UserRole.USER_ROLE_ROOT,
                          child: Text('Root'),
                        ),
                        DropdownMenuItem(
                          value: common_enum.UserRole.USER_ROLE_ADMIN,
                          child: Text('管理员'),
                        ),
                        DropdownMenuItem(
                          value: common_enum.UserRole.USER_ROLE_USER,
                          child: Text('用户'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _roleFilter = value ??
                              common_enum.UserRole.USER_ROLE_UNSPECIFIED;
                          _page = 1;
                        });
                        _loadUsers();
                      },
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<bool?>(
                      value: _bannedFilter,
                      items: const [
                        DropdownMenuItem(value: null, child: Text('全部封禁')),
                        DropdownMenuItem(value: true, child: Text('仅封禁')),
                        DropdownMenuItem(value: false, child: Text('未封禁')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _bannedFilter = value;
                          _page = 1;
                        });
                        _loadUsers();
                      },
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<admin_enum.UserListSortBy>(
                      value: _sortBy,
                      items: const [
                        DropdownMenuItem(
                          value: admin_enum
                              .UserListSortBy.USER_LIST_SORT_BY_CREATED_AT,
                          child: Text('创建时间'),
                        ),
                        DropdownMenuItem(
                          value: admin_enum
                              .UserListSortBy.USER_LIST_SORT_BY_UPDATED_AT,
                          child: Text('更新时间'),
                        ),
                        DropdownMenuItem(
                          value: admin_enum
                              .UserListSortBy.USER_LIST_SORT_BY_USERNAME,
                          child: Text('用户名'),
                        ),
                        DropdownMenuItem(
                          value:
                              admin_enum.UserListSortBy.USER_LIST_SORT_BY_EMAIL,
                          child: Text('邮箱'),
                        ),
                        DropdownMenuItem(
                          value: admin_enum
                              .UserListSortBy.USER_LIST_SORT_BY_STATUS,
                          child: Text('状态'),
                        ),
                        DropdownMenuItem(
                          value:
                              admin_enum.UserListSortBy.USER_LIST_SORT_BY_ROLE,
                          child: Text('角色'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _sortBy = value;
                          _page = 1;
                        });
                        _loadUsers();
                      },
                    ),
                    IconButton(
                      tooltip: _sortDirection ==
                              admin_enum.SortDirection.SORT_DIRECTION_DESC
                          ? '降序'
                          : '升序',
                      icon: Icon(
                        _sortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? Icons.south_rounded
                            : Icons.north_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          _sortDirection = _sortDirection ==
                                  admin_enum.SortDirection.SORT_DIRECTION_DESC
                              ? admin_enum.SortDirection.SORT_DIRECTION_ASC
                              : admin_enum.SortDirection.SORT_DIRECTION_DESC;
                          _page = 1;
                        });
                        _loadUsers();
                      },
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _pageSize,
                      items: const [
                        DropdownMenuItem(value: 20, child: Text('20 / 页')),
                        DropdownMenuItem(value: 50, child: Text('50 / 页')),
                        DropdownMenuItem(value: 100, child: Text('100 / 页')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _pageSize = value;
                          _page = 1;
                        });
                        _loadUsers();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_selectedUserIds.isNotEmpty) _buildUserBatchBar(theme, isDark),
        _AdminPager(
          page: _page,
          pageSize: _pageSize,
          total: _total,
          onPrevious: _page <= 1
              ? null
              : () {
                  setState(() => _page -= 1);
                  _loadUsers();
                },
          onNext: _page >= _pageCount
              ? null
              : () {
                  setState(() => _page += 1);
                  _loadUsers();
                },
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    final isAdmin = user.role ==
                            common_enum.UserRole.USER_ROLE_ADMIN.value ||
                        user.role == common_enum.UserRole.USER_ROLE_ROOT.value;
                    final isBanned = user.status ==
                        common_enum.UserStatus.USER_STATUS_BANNED.value;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade900 : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _selectedUserIds.contains(user.id),
                              onChanged: (value) => _toggleUserSelection(
                                user.id,
                                value ?? false,
                              ),
                            ),
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: isAdmin
                                  ? Colors.amber.withValues(alpha: 0.2)
                                  : theme.primaryColor.withValues(alpha: 0.1),
                              child: Text(
                                user.username.isNotEmpty
                                    ? user.username
                                        .substring(0, 1)
                                        .toUpperCase()
                                    : '?',
                                style: TextStyle(
                                  color: isAdmin
                                      ? Colors.amber.shade800
                                      : theme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(user.username,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                              'ID: ${user.id} · ${_systemRoleText(user.role)} · ${_userStatusText(user.status)}',
                              style: TextStyle(
                                  fontSize: 12, color: theme.hintColor)),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isBanned) ...[
                              IconButton(
                                icon: const Icon(Icons.check_circle_outline,
                                    size: 24),
                                color: Colors.orange,
                                tooltip: '解封',
                                onPressed: () => _banUser(user, false),
                              ),
                            ] else ...[
                              IconButton(
                                icon: const Icon(Icons.info_outline, size: 22),
                                color: Colors.blueGrey,
                                tooltip: '详情',
                                onPressed: () => _showUserDetails(user),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 22),
                                color: Colors.blue,
                                tooltip: '改名',
                                onPressed: () => _renameUser(user),
                              ),
                              IconButton(
                                icon: const Icon(Icons.lock_reset_rounded,
                                    size: 22),
                                color: Colors.orange,
                                tooltip: '重置密码',
                                onPressed: () => _resetPassword(user),
                              ),
                              IconButton(
                                icon: const Icon(Icons.block, size: 22),
                                color: Colors.redAccent,
                                tooltip: '封禁',
                                onPressed: () => _banUser(user, true),
                              ),
                              IconButton(
                                icon: Icon(
                                  isAdmin
                                      ? Icons.admin_panel_settings
                                      : Icons.admin_panel_settings_outlined,
                                  size: 22,
                                ),
                                color: isAdmin ? Colors.orange : Colors.blue,
                                tooltip: isAdmin ? '取消管理员' : '设为管理员',
                                onPressed: () => _toggleAdmin(user),
                              ),
                            ],
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 22),
                              color: Colors.redAccent,
                              tooltip: '删除用户',
                              onPressed: () => _deleteUser(user),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildUserBatchBar(ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(Icons.checklist_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text('已选择 ${_selectedUserIds.length} 个用户')),
          TextButton(
            onPressed: () => setState(_selectedUserIds.clear),
            child: const Text('清空'),
          ),
          const SizedBox(width: 4),
          FilledButton.icon(
            onPressed: _batchBanUsers,
            icon: const Icon(Icons.block_rounded),
            label: const Text('封禁'),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: _batchDeleteUsers,
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('删除'),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledTextField({
    required Function(String) onSubmitted,
    required String hint,
    required IconData icon,
    required bool isDark,
    required ThemeData theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onSubmitted: onSubmitted,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: theme.hintColor, size: 20),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          isDense: true,
        ),
      ),
    );
  }
}

class AdminReviewTab extends StatefulWidget {
  const AdminReviewTab({super.key});

  @override
  State<AdminReviewTab> createState() => _AdminReviewTabState();
}

class _AdminReviewTabState extends State<AdminReviewTab> {
  String _kind = 'user';
  int _status = common_enum.ReviewStatus.REVIEW_STATUS_PENDING.value;
  String _search = '';
  String _requestedBy = '';
  String _roomId = '';
  String _userId = '';
  int _page = 1;
  int _pageSize = 50;
  int _total = 0;
  bool _isLoading = true;
  List<AdminReviewItem> _reviews = const [];

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final data = await WatchTogetherService.adminListReviewsPage(
        kind: _kind,
        page: _page,
        pageSize: _pageSize,
        status: _status,
        search: _search,
        requestedBy: _requestedBy,
        roomId: _roomId,
        userId: _userId,
      );
      if (!mounted) return;
      setState(() {
        _reviews = data.reviews;
        _total = data.total;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      MessageUtils.showError(context, '加载审核失败: $e');
    }
  }

  Future<void> _approve(AdminReviewItem review) async {
    try {
      await WatchTogetherService.adminApproveReview(_kind, review.id);
      if (!mounted) return;
      MessageUtils.showSuccess(context, '审核已通过');
      _loadReviews(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '操作失败: $e');
    }
  }

  Future<void> _reject(AdminReviewItem review) async {
    final controller = TextEditingController();
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '拒绝审核',
      icon: const Icon(Icons.cancel_outlined, color: Colors.red),
      content: ChatUtils.createFormField(
        context: context,
        label: '原因',
        controller: controller,
        hintText: '填写拒绝原因',
        prefixIcon: Icons.edit_note_rounded,
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: '拒绝',
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      await WatchTogetherService.adminRejectReview(
        _kind,
        review.id,
        reason: controller.text.trim(),
      );
      if (!mounted) return;
      MessageUtils.showSuccess(context, '审核已拒绝');
      _loadReviews(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '操作失败: $e');
    }
  }

  void _applySearch(String value) {
    final normalized = value.trim();
    setState(() {
      _search = normalized;
      _requestedBy =
          _kind == 'room' && normalized.startsWith('usr_') ? normalized : '';
      _roomId =
          _kind == 'join' && normalized.startsWith('room_') ? normalized : '';
      _userId =
          _kind == 'join' && normalized.startsWith('usr_') ? normalized : '';
      _page = 1;
    });
    _loadReviews();
  }

  int get _pageCount {
    if (_total <= 0) return 1;
    return ((_total + _pageSize - 1) ~/ _pageSize).clamp(1, 1 << 31);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'user', label: Text('注册')),
                  ButtonSegment(value: 'room', label: Text('建房')),
                  ButtonSegment(value: 'join', label: Text('加入')),
                ],
                selected: {_kind},
                onSelectionChanged: (value) {
                  setState(() {
                    _kind = value.first;
                    _page = 1;
                    _requestedBy = '';
                    _roomId = '';
                    _userId = '';
                  });
                  _loadReviews();
                },
              ),
              DropdownButton<int>(
                value: _status,
                items: [
                  DropdownMenuItem(
                    value: common_enum.ReviewStatus.REVIEW_STATUS_PENDING.value,
                    child: const Text('待审核'),
                  ),
                  DropdownMenuItem(
                    value:
                        common_enum.ReviewStatus.REVIEW_STATUS_APPROVED.value,
                    child: const Text('已通过'),
                  ),
                  DropdownMenuItem(
                    value:
                        common_enum.ReviewStatus.REVIEW_STATUS_REJECTED.value,
                    child: const Text('已拒绝'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _status = value;
                    _page = 1;
                  });
                  _loadReviews();
                },
              ),
              DropdownButton<int>(
                value: _pageSize,
                items: const [
                  DropdownMenuItem(value: 20, child: Text('20 / 页')),
                  DropdownMenuItem(value: 50, child: Text('50 / 页')),
                  DropdownMenuItem(value: 100, child: Text('100 / 页')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _pageSize = value;
                    _page = 1;
                  });
                  _loadReviews();
                },
              ),
              SizedBox(
                width: 260,
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search_rounded),
                    hintText: '搜索或输入 room_/usr_ ID',
                    isDense: true,
                  ),
                  onSubmitted: _applySearch,
                ),
              ),
              IconButton(
                tooltip: '刷新',
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () => _loadReviews(silent: true),
              ),
            ],
          ),
        ),
        _AdminPager(
          page: _page,
          pageSize: _pageSize,
          total: _total,
          onPrevious: _page <= 1
              ? null
              : () {
                  setState(() => _page -= 1);
                  _loadReviews();
                },
          onNext: _page >= _pageCount
              ? null
              : () {
                  setState(() => _page += 1);
                  _loadReviews();
                },
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _reviews.isEmpty
                  ? Center(
                      child: Text('暂无审核记录',
                          style: TextStyle(color: theme.hintColor)))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: _reviews.length,
                      itemBuilder: (context, index) {
                        final review = _reviews[index];
                        final pending = review.status ==
                            common_enum
                                .ReviewStatus.REVIEW_STATUS_PENDING.value;
                        return _AdminPanelCard(
                          isDark: isDark,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildReviewSummary(review, theme),
                                ),
                                const SizedBox(width: 8),
                                pending
                                    ? Wrap(
                                        spacing: 4,
                                        children: [
                                          IconButton(
                                            tooltip: '通过',
                                            icon: const Icon(
                                                Icons.check_circle_outline),
                                            color: Colors.green,
                                            onPressed: () => _approve(review),
                                          ),
                                          IconButton(
                                            tooltip: '拒绝',
                                            icon: const Icon(
                                                Icons.cancel_outlined),
                                            color: Colors.red,
                                            onPressed: () => _reject(review),
                                          ),
                                        ],
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                            _reviewStatusText(review.status)),
                                      ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildReviewSummary(AdminReviewItem review, ThemeData theme) {
    final meta = [
      review.id,
      _formatTimestamp(review.requestedAt),
      if (review.reviewedBy.isNotEmpty) '审核人 ${review.reviewedBy}',
      if (review.reviewedAt > 0) '审核 ${_formatTimestamp(review.reviewedAt)}',
    ];
    final details = review.details.isEmpty
        ? [review.subtitle, review.detail]
        : review.details;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          review.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          meta.where((value) => value.isNotEmpty).join(' · '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, color: theme.hintColor),
        ),
        if (details.any((value) => value.isNotEmpty)) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final detail in details.where((value) => value.isNotEmpty))
                _ReviewInfoChip(label: detail),
            ],
          ),
        ],
        if (review.rejectionReason.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            review.rejectionReason,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ],
      ],
    );
  }
}

class _ReviewInfoChip extends StatelessWidget {
  const _ReviewInfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.08),
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}

class _ProviderTypeSelector extends StatelessWidget {
  const _ProviderTypeSelector({
    required this.selectedProviders,
    required this.options,
    required this.onChanged,
  });

  final Set<String> selectedProviders;
  final List<String> options;
  final void Function(String provider, bool selected) onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Provider 类型',
          prefixIcon: Icon(Icons.category_outlined),
          border: OutlineInputBorder(),
          isDense: true,
        ),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final provider in options)
              FilterChip(
                label: Text(_providerTypeLabel(provider)),
                selected: selectedProviders.contains(provider),
                onSelected: (selected) => onChanged(provider, selected),
                showCheckmark: true,
                visualDensity: VisualDensity.compact,
              ),
            if (options.isEmpty)
              Text(
                '暂无可选类型',
                style: TextStyle(color: theme.hintColor),
              ),
          ],
        ),
      ),
    );
  }
}

class AdminProviderTab extends StatefulWidget {
  const AdminProviderTab({super.key});

  @override
  State<AdminProviderTab> createState() => _AdminProviderTabState();
}

class _AdminProviderTabState extends State<AdminProviderTab> {
  bool _isLoading = true;
  String _providerType = '';
  String _search = '';
  int _page = 1;
  int _pageSize = 50;
  int _total = 0;
  bool? _enabledFilter;
  bool? _tlsFilter;
  provider_common_enum.ProviderInstanceListSortBy _sortBy = provider_common_enum
      .ProviderInstanceListSortBy.PROVIDER_INSTANCE_LIST_SORT_BY_NAME;
  provider_common_enum.SortDirection _sortDirection =
      provider_common_enum.SortDirection.SORT_DIRECTION_ASC;
  List<AdminProviderInstance> _instances = const [];
  List<String> _backends = const [];

  int get _pageCount =>
      _total <= 0 ? 1 : ((_total + _pageSize - 1) ~/ _pageSize);

  @override
  void initState() {
    super.initState();
    _loadInstances();
  }

  Future<void> _loadInstances({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        WatchTogetherService.adminListProviderInstancesPage(
          page: _page,
          pageSize: _pageSize,
          providerType: _providerType,
          search: _search,
          enabled: _enabledFilter,
          tls: _tlsFilter,
          sortBy: _sortBy,
          sortDirection: _sortDirection,
        ),
        _providerType.isEmpty
            ? Future<List<String>>.value(const [])
            : WatchTogetherService.listProviderBackends(_providerType),
      ]);
      if (!mounted) return;
      final instancesPage = results[0] as AdminProviderInstancesPage;
      setState(() {
        _instances = instancesPage.instances;
        _total = instancesPage.total;
        _backends = results[1] as List<String>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      MessageUtils.showError(context, '加载 Provider 实例失败: $e');
    }
  }

  Future<void> _editInstance([AdminProviderInstance? instance]) async {
    final name = TextEditingController(text: instance?.name ?? '');
    final endpoint = TextEditingController(text: instance?.endpoint ?? '');
    final comment = TextEditingController(text: instance?.comment ?? '');
    final timeout = TextEditingController(
      text: (instance?.timeoutSeconds ?? 30).toString(),
    );
    final selectedProviders = <String>{
      ...?instance?.providers,
      if (instance == null && _providerType.isNotEmpty) _providerType,
    };
    final jwtSecret = TextEditingController();
    final customCa = TextEditingController();
    bool tls = instance?.tls ?? true;
    bool insecureTls = instance?.insecureTls ?? false;
    bool clearComment = false;
    bool clearJwtSecret = false;
    bool clearCustomCa = false;
    final editing = instance != null;

    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: editing ? '编辑 Provider' : '新增 Provider',
      icon: const Icon(Icons.hub_rounded, color: Color(0xFF5D5FEF)),
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ChatUtils.createFormField(
                  context: context,
                  label: '名称',
                  controller: name,
                  hintText: 'provider_main',
                  prefixIcon: Icons.badge_outlined,
                  enabled: !editing,
                ),
                const SizedBox(height: 12),
                ChatUtils.createFormField(
                  context: context,
                  label: 'Endpoint',
                  controller: endpoint,
                  hintText: 'https://provider.example.com',
                  prefixIcon: Icons.link_rounded,
                ),
                const SizedBox(height: 12),
                _ProviderTypeSelector(
                  selectedProviders: selectedProviders,
                  options: _providerTypeOptions(
                    selectedFilter: _providerType,
                    selectedProviders: selectedProviders,
                  ),
                  onChanged: (provider, selected) => setDialogState(() {
                    if (selected) {
                      selectedProviders.add(provider);
                    } else {
                      selectedProviders.remove(provider);
                    }
                  }),
                ),
                const SizedBox(height: 12),
                ChatUtils.createFormField(
                  context: context,
                  label: '备注',
                  controller: comment,
                  hintText: '可选',
                  prefixIcon: Icons.notes_rounded,
                  enabled: !clearComment,
                ),
                if (editing)
                  CheckboxListTile(
                    value: clearComment,
                    onChanged: (value) => setDialogState(() {
                      clearComment = value ?? false;
                      if (clearComment) comment.clear();
                    }),
                    title: const Text('清除备注'),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                const SizedBox(height: 12),
                ChatUtils.createFormField(
                  context: context,
                  label: '超时秒数',
                  controller: timeout,
                  hintText: '30',
                  prefixIcon: Icons.timer_outlined,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                ChatUtils.createFormField(
                  context: context,
                  label: 'JWT Secret',
                  controller: jwtSecret,
                  hintText: editing ? '留空不修改' : '可选',
                  prefixIcon: Icons.key_rounded,
                  enabled: !clearJwtSecret,
                ),
                if (editing)
                  CheckboxListTile(
                    value: clearJwtSecret,
                    onChanged: (value) => setDialogState(() {
                      clearJwtSecret = value ?? false;
                      if (clearJwtSecret) jwtSecret.clear();
                    }),
                    title: const Text('清除 JWT Secret'),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                const SizedBox(height: 12),
                ChatUtils.createFormField(
                  context: context,
                  label: 'Custom CA',
                  controller: customCa,
                  hintText: editing ? 'PEM 内容，留空不修改' : 'PEM 内容，可选',
                  prefixIcon: Icons.verified_user_outlined,
                  maxLines: 5,
                  enabled: !clearCustomCa,
                ),
                if (editing)
                  CheckboxListTile(
                    value: clearCustomCa,
                    onChanged: (value) => setDialogState(() {
                      clearCustomCa = value ?? false;
                      if (clearCustomCa) customCa.clear();
                    }),
                    title: const Text('清除 Custom CA'),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                SwitchListTile(
                  value: tls,
                  onChanged: (value) => setDialogState(() => tls = value),
                  title: const Text('TLS'),
                ),
                SwitchListTile(
                  value: insecureTls,
                  onChanged: (value) =>
                      setDialogState(() => insecureTls = value),
                  title: const Text('允许不安全 TLS'),
                ),
              ],
            ),
          );
        },
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: editing ? '保存' : '创建',
        ),
      ],
    );
    if (confirmed != true) return;
    if (!mounted) return;

    final trimmedName = name.text.trim();
    final trimmedEndpoint = endpoint.text.trim();
    final trimmedComment = comment.text.trim();
    final parsedTimeout = int.tryParse(timeout.text.trim());
    final providerList = selectedProviders.toList(growable: false)..sort();
    if (!editing && trimmedName.isEmpty) {
      MessageUtils.showError(context, '名称不能为空');
      return;
    }
    if (trimmedEndpoint.isEmpty) {
      MessageUtils.showError(context, 'Endpoint 不能为空');
      return;
    }
    if (providerList.isEmpty) {
      MessageUtils.showError(context, '至少需要填写一个 Provider 类型');
      return;
    }
    if (parsedTimeout == null || parsedTimeout <= 0) {
      MessageUtils.showError(context, '超时秒数必须是大于 0 的整数');
      return;
    }
    try {
      if (editing) {
        await WatchTogetherService.adminUpdateProviderInstance(
          name: instance.name,
          endpoint: trimmedEndpoint,
          comment: clearComment ? null : trimmedComment,
          timeoutSeconds: parsedTimeout,
          tls: tls,
          insecureTls: insecureTls,
          providers: providerList,
          jwtSecret: clearJwtSecret || jwtSecret.text.trim().isEmpty
              ? null
              : jwtSecret.text.trim(),
          customCa: clearCustomCa || customCa.text.trim().isEmpty
              ? null
              : customCa.text.trim(),
          clearComment: clearComment,
          clearJwtSecret: clearJwtSecret,
          clearCustomCa: clearCustomCa,
        );
      } else {
        await WatchTogetherService.adminAddProviderInstance(
          name: trimmedName,
          endpoint: trimmedEndpoint,
          providers: providerList,
          comment: trimmedComment,
          timeoutSeconds: parsedTimeout,
          tls: tls,
          insecureTls: insecureTls,
          jwtSecret:
              jwtSecret.text.trim().isEmpty ? null : jwtSecret.text.trim(),
          customCa: customCa.text.trim().isEmpty ? null : customCa.text.trim(),
        );
      }
      if (!mounted) return;
      MessageUtils.showSuccess(context, editing ? '实例已更新' : '实例已创建');
      _loadInstances(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '保存失败: $e');
    }
  }

  Future<void> _deleteInstance(AdminProviderInstance instance) async {
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '删除 Provider',
      icon: const Icon(Icons.delete_forever, color: Colors.red),
      content: Text('确定要删除 ${instance.name} 吗？'),
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
    if (confirmed != true) return;
    try {
      await WatchTogetherService.adminDeleteProviderInstance(instance.name);
      if (!mounted) return;
      MessageUtils.showSuccess(context, '实例已删除');
      _loadInstances(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '删除失败: $e');
    }
  }

  Future<void> _toggleEnabled(AdminProviderInstance instance) async {
    try {
      await WatchTogetherService.adminSetProviderInstanceEnabled(
        instance.name,
        !instance.enabled,
      );
      if (!mounted) return;
      _loadInstances(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '操作失败: $e');
    }
  }

  Future<void> _reconnect(AdminProviderInstance instance) async {
    try {
      await WatchTogetherService.adminReconnectProviderInstance(instance.name);
      if (!mounted) return;
      MessageUtils.showSuccess(context, '已发起重连');
      _loadInstances(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '重连失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded),
                        hintText: '搜索名称、Endpoint',
                        isDense: true,
                      ),
                      onSubmitted: (value) {
                        setState(() {
                          _search = value.trim();
                          _page = 1;
                        });
                        _loadInstances();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    tooltip: '新增',
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    onPressed: () => _editInstance(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    DropdownButton<bool?>(
                      value: _enabledFilter,
                      items: const [
                        DropdownMenuItem(value: null, child: Text('全部状态')),
                        DropdownMenuItem(value: true, child: Text('已启用')),
                        DropdownMenuItem(value: false, child: Text('已停用')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _enabledFilter = value;
                          _page = 1;
                        });
                        _loadInstances();
                      },
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<bool?>(
                      value: _tlsFilter,
                      items: const [
                        DropdownMenuItem(value: null, child: Text('全部 TLS')),
                        DropdownMenuItem(value: true, child: Text('TLS 开启')),
                        DropdownMenuItem(value: false, child: Text('TLS 关闭')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _tlsFilter = value;
                          _page = 1;
                        });
                        _loadInstances();
                      },
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<String>(
                      value: _providerType,
                      items: const [
                        DropdownMenuItem(value: '', child: Text('全部类型')),
                        DropdownMenuItem(value: 'alist', child: Text('AList')),
                        DropdownMenuItem(value: 'emby', child: Text('Emby')),
                        DropdownMenuItem(
                            value: 'bilibili', child: Text('Bilibili')),
                        DropdownMenuItem(value: 'rtmp', child: Text('RTMP')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _providerType = value ?? '';
                          _page = 1;
                        });
                        _loadInstances();
                      },
                    ),
                    const SizedBox(width: 16),
                    DropdownButton<
                        provider_common_enum.ProviderInstanceListSortBy>(
                      value: _sortBy,
                      items: const [
                        DropdownMenuItem(
                          value: provider_common_enum.ProviderInstanceListSortBy
                              .PROVIDER_INSTANCE_LIST_SORT_BY_NAME,
                          child: Text('按名称'),
                        ),
                        DropdownMenuItem(
                          value: provider_common_enum.ProviderInstanceListSortBy
                              .PROVIDER_INSTANCE_LIST_SORT_BY_ENDPOINT,
                          child: Text('按 Endpoint'),
                        ),
                        DropdownMenuItem(
                          value: provider_common_enum.ProviderInstanceListSortBy
                              .PROVIDER_INSTANCE_LIST_SORT_BY_CREATED_AT,
                          child: Text('按创建'),
                        ),
                        DropdownMenuItem(
                          value: provider_common_enum.ProviderInstanceListSortBy
                              .PROVIDER_INSTANCE_LIST_SORT_BY_UPDATED_AT,
                          child: Text('按更新'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _sortBy = value ??
                              provider_common_enum.ProviderInstanceListSortBy
                                  .PROVIDER_INSTANCE_LIST_SORT_BY_NAME;
                          _page = 1;
                        });
                        _loadInstances();
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: _sortDirection ==
                              provider_common_enum
                                  .SortDirection.SORT_DIRECTION_DESC
                          ? '降序'
                          : '升序',
                      icon: Icon(
                        _sortDirection ==
                                provider_common_enum
                                    .SortDirection.SORT_DIRECTION_DESC
                            ? Icons.south_rounded
                            : Icons.north_rounded,
                      ),
                      onPressed: () {
                        setState(() {
                          _sortDirection = _sortDirection ==
                                  provider_common_enum
                                      .SortDirection.SORT_DIRECTION_DESC
                              ? provider_common_enum
                                  .SortDirection.SORT_DIRECTION_ASC
                              : provider_common_enum
                                  .SortDirection.SORT_DIRECTION_DESC;
                          _page = 1;
                        });
                        _loadInstances();
                      },
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _pageSize,
                      items: const [
                        DropdownMenuItem(value: 20, child: Text('20 / 页')),
                        DropdownMenuItem(value: 50, child: Text('50 / 页')),
                        DropdownMenuItem(value: 100, child: Text('100 / 页')),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _pageSize = value;
                          _page = 1;
                        });
                        _loadInstances();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_providerType.isNotEmpty) _buildBackendsBar(theme, isDark),
        _AdminPager(
          page: _page,
          pageSize: _pageSize,
          total: _total,
          onPrevious: _page <= 1
              ? null
              : () {
                  setState(() => _page -= 1);
                  _loadInstances();
                },
          onNext: _page >= _pageCount
              ? null
              : () {
                  setState(() => _page += 1);
                  _loadInstances();
                },
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _instances.isEmpty
                  ? Center(
                      child: Text('暂无 Provider 实例',
                          style: TextStyle(color: theme.hintColor)))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: _instances.length,
                      itemBuilder: (context, index) {
                        final instance = _instances[index];
                        return _AdminPanelCard(
                          isDark: isDark,
                          child: _ProviderInstanceTile(
                            instance: instance,
                            onToggleEnabled: () => _toggleEnabled(instance),
                            onEdit: () => _editInstance(instance),
                            onReconnect: () => _reconnect(instance),
                            onDelete: () => _deleteInstance(instance),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildBackendsBar(ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.dns_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: _backends.isEmpty
                ? Text(
                    '当前类型暂无可用 Backend',
                    style: TextStyle(color: theme.hintColor),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final backend in _backends)
                        ActionChip(
                          label: Text(backend),
                          avatar: const Icon(Icons.copy_rounded, size: 16),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: backend));
                            MessageUtils.showSuccess(context, 'Backend 已复制');
                          },
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
          ),
          IconButton(
            tooltip: '刷新 Backend',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => _loadInstances(silent: true),
          ),
        ],
      ),
    );
  }
}

class _ProviderInstanceTile extends StatelessWidget {
  final AdminProviderInstance instance;
  final VoidCallback onToggleEnabled;
  final VoidCallback onEdit;
  final VoidCallback onReconnect;
  final VoidCallback onDelete;

  const _ProviderInstanceTile({
    required this.instance,
    required this.onToggleEnabled,
    required this.onEdit,
    required this.onReconnect,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusText = _providerStatusText(instance.status);
    final tlsText = !instance.tls
        ? 'TLS 关闭'
        : instance.insecureTls
            ? 'TLS 不校验'
            : 'TLS 校验';
    final timeText = '创建 ${_formatTimestamp(instance.createdAt)}'
        ' · 更新 ${_formatTimestamp(instance.updatedAt)}';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Switch(
            value: instance.enabled,
            onChanged: (_) => onToggleEnabled(),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        instance.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _ProviderMetaChip(
                      label: instance.enabled ? '已启用' : '已停用',
                      icon: instance.enabled
                          ? Icons.power_settings_new_rounded
                          : Icons.power_off_rounded,
                      color: instance.enabled
                          ? theme.colorScheme.primary
                          : theme.hintColor,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SelectableText(
                  instance.endpoint,
                  maxLines: 1,
                  style: TextStyle(color: theme.hintColor),
                ),
                if (instance.comment.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    instance.comment,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.hintColor),
                  ),
                ],
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ProviderMetaChip(
                      label: statusText,
                      icon: _providerStatusIcon(instance.status),
                      color: _providerStatusColor(theme, instance.status),
                    ),
                    _ProviderMetaChip(
                      label: '${instance.timeoutSeconds}s',
                      icon: Icons.timer_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    _ProviderMetaChip(
                      label: tlsText,
                      icon: instance.tls
                          ? Icons.verified_user_outlined
                          : Icons.no_encryption_outlined,
                      color: instance.tls && !instance.insecureTls
                          ? Colors.green
                          : Colors.orange,
                    ),
                    for (final provider in instance.providers)
                      _ProviderMetaChip(
                        label: provider,
                        icon: Icons.category_outlined,
                        color: theme.colorScheme.secondary,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  timeText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: theme.hintColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Wrap(
            spacing: 2,
            children: [
              IconButton(
                tooltip: '编辑',
                icon: const Icon(Icons.edit_outlined),
                onPressed: onEdit,
              ),
              IconButton(
                tooltip: '重连',
                icon: const Icon(Icons.sync_rounded),
                onPressed: onReconnect,
              ),
              IconButton(
                tooltip: '删除',
                icon: const Icon(Icons.delete_outline),
                color: Colors.redAccent,
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProviderMetaChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _ProviderMetaChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 140),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

IconData _providerStatusIcon(int status) {
  switch (status) {
    case 1:
      return Icons.cloud_done_outlined;
    case 2:
      return Icons.cloud_off_outlined;
    case 3:
      return Icons.error_outline_rounded;
    default:
      return Icons.help_outline_rounded;
  }
}

Color _providerStatusColor(ThemeData theme, int status) {
  switch (status) {
    case 1:
      return Colors.green;
    case 2:
      return theme.hintColor;
    case 3:
      return Colors.redAccent;
    default:
      return theme.colorScheme.primary;
  }
}

class AdminStreamsTab extends StatefulWidget {
  const AdminStreamsTab({super.key});

  @override
  State<AdminStreamsTab> createState() => _AdminStreamsTabState();
}

class _AdminStreamsTabState extends State<AdminStreamsTab> {
  bool _isLoading = true;
  String _search = '';
  String _roomId = '';
  String _userId = '';
  String _nodeId = '';
  int _page = 1;
  int _pageSize = 50;
  admin_enum.ActiveStreamListSortBy _sortBy =
      admin_enum.ActiveStreamListSortBy.ACTIVE_STREAM_LIST_SORT_BY_STARTED_AT;
  admin_enum.SortDirection _sortDirection =
      admin_enum.SortDirection.SORT_DIRECTION_DESC;
  List<AdminActiveStream> _streams = const [];
  int _total = 0;

  int get _pageCount =>
      _total <= 0 ? 1 : ((_total + _pageSize - 1) ~/ _pageSize);

  @override
  void initState() {
    super.initState();
    _loadStreams();
  }

  Future<void> _loadStreams({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final page = await WatchTogetherService.adminListActiveStreamsPage(
        page: _page,
        pageSize: _pageSize,
        search: _search,
        roomId: _roomId.isNotEmpty
            ? _roomId
            : _search.startsWith('room_')
                ? _search
                : '',
        userId: _userId.isNotEmpty
            ? _userId
            : _search.startsWith('usr_')
                ? _search
                : '',
        nodeId: _nodeId,
        sortBy: _sortBy,
        sortDirection: _sortDirection,
      );
      if (!mounted) return;
      setState(() {
        _streams = page.streams;
        _total = page.total;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      MessageUtils.showError(context, '加载活跃流失败: $e');
    }
  }

  Future<void> _kick(AdminActiveStream stream) async {
    try {
      await WatchTogetherService.adminKickStream(stream);
      if (!mounted) return;
      MessageUtils.showSuccess(context, '流已踢出');
      _loadStreams(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '操作失败: $e');
    }
  }

  void _applyStreamSearch(String value) {
    final normalized = value.trim();
    setState(() {
      _search = normalized;
      _roomId = normalized.startsWith('room_') ? normalized : '';
      _userId = normalized.startsWith('usr_') ? normalized : '';
      _nodeId = normalized.startsWith('node_') ? normalized : '';
      _page = 1;
    });
    _loadStreams();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 280,
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search_rounded),
                    hintText: '搜索，或输入 room_/usr_/node_ ID',
                    isDense: true,
                  ),
                  onSubmitted: _applyStreamSearch,
                ),
              ),
              DropdownButton<int>(
                value: _pageSize,
                items: const [
                  DropdownMenuItem(value: 20, child: Text('20 / 页')),
                  DropdownMenuItem(value: 50, child: Text('50 / 页')),
                  DropdownMenuItem(value: 100, child: Text('100 / 页')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _pageSize = value;
                    _page = 1;
                  });
                  _loadStreams();
                },
              ),
              DropdownButton<admin_enum.ActiveStreamListSortBy>(
                value: _sortBy,
                items: const [
                  DropdownMenuItem(
                    value: admin_enum.ActiveStreamListSortBy
                        .ACTIVE_STREAM_LIST_SORT_BY_STARTED_AT,
                    child: Text('开始时间'),
                  ),
                  DropdownMenuItem(
                    value: admin_enum.ActiveStreamListSortBy
                        .ACTIVE_STREAM_LIST_SORT_BY_ROOM_ID,
                    child: Text('房间'),
                  ),
                  DropdownMenuItem(
                    value: admin_enum.ActiveStreamListSortBy
                        .ACTIVE_STREAM_LIST_SORT_BY_MEDIA_ID,
                    child: Text('媒体'),
                  ),
                  DropdownMenuItem(
                    value: admin_enum.ActiveStreamListSortBy
                        .ACTIVE_STREAM_LIST_SORT_BY_USER_ID,
                    child: Text('用户'),
                  ),
                  DropdownMenuItem(
                    value: admin_enum.ActiveStreamListSortBy
                        .ACTIVE_STREAM_LIST_SORT_BY_NODE_ID,
                    child: Text('节点'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _sortBy = value;
                    _page = 1;
                  });
                  _loadStreams();
                },
              ),
              IconButton(
                tooltip: _sortDirection ==
                        admin_enum.SortDirection.SORT_DIRECTION_DESC
                    ? '降序'
                    : '升序',
                icon: Icon(
                  _sortDirection == admin_enum.SortDirection.SORT_DIRECTION_DESC
                      ? Icons.south_rounded
                      : Icons.north_rounded,
                ),
                onPressed: () {
                  setState(() {
                    _sortDirection = _sortDirection ==
                            admin_enum.SortDirection.SORT_DIRECTION_DESC
                        ? admin_enum.SortDirection.SORT_DIRECTION_ASC
                        : admin_enum.SortDirection.SORT_DIRECTION_DESC;
                    _page = 1;
                  });
                  _loadStreams();
                },
              ),
              IconButton(
                tooltip: '刷新',
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () => _loadStreams(silent: true),
              ),
            ],
          ),
        ),
        _AdminPager(
          page: _page,
          pageSize: _pageSize,
          total: _total,
          onPrevious: _page <= 1
              ? null
              : () {
                  setState(() => _page -= 1);
                  _loadStreams();
                },
          onNext: _page >= _pageCount
              ? null
              : () {
                  setState(() => _page += 1);
                  _loadStreams();
                },
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _streams.isEmpty
                  ? Center(
                      child: Text('暂无活跃流',
                          style: TextStyle(color: theme.hintColor)))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: _streams.length,
                      itemBuilder: (context, index) {
                        final stream = _streams[index];
                        return _AdminPanelCard(
                          isDark: isDark,
                          child: ListTile(
                            leading: const Icon(Icons.podcasts_rounded),
                            title: Text(stream.mediaId),
                            subtitle: Text(
                              '${stream.roomId} · ${stream.userId}\nNode: ${stream.nodeId} · ${_formatTimestamp(stream.startedAt)}',
                            ),
                            isThreeLine: true,
                            trailing: IconButton(
                              tooltip: '踢出流',
                              icon:
                                  const Icon(Icons.power_settings_new_rounded),
                              color: Colors.redAccent,
                              onPressed: () => _kick(stream),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

class AdminBanRecordsTab extends StatefulWidget {
  const AdminBanRecordsTab({super.key});

  @override
  State<AdminBanRecordsTab> createState() => _AdminBanRecordsTabState();
}

class _AdminBanRecordsTabState extends State<AdminBanRecordsTab> {
  bool _isLoading = true;
  int _targetType = 0;
  bool? _active = true;
  String _search = '';
  String _userId = '';
  String _roomId = '';
  int _page = 1;
  int _pageSize = 50;
  int _total = 0;
  List<AdminBanRecord> _records = const [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final data = await WatchTogetherService.adminListBanRecordsPage(
        page: _page,
        pageSize: _pageSize,
        targetType: _targetType,
        active: _active,
        userId: _userId,
        roomId: _roomId,
      );
      if (!mounted) return;
      setState(() {
        _records = data.records;
        _total = data.total;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      MessageUtils.showError(context, '加载封禁记录失败: $e');
    }
  }

  void _applyBanSearch(String value) {
    final normalized = value.trim();
    setState(() {
      _search = normalized;
      _userId = normalized.startsWith('usr_') ? normalized : '';
      _roomId = normalized.startsWith('room_') ? normalized : '';
      _page = 1;
    });
    _loadRecords();
  }

  Future<void> _unbanRecord(AdminBanRecord record) async {
    final isUserBan = record.targetType == 1;
    final targetName = isUserBan
        ? (record.username.isEmpty ? record.userId : record.username)
        : (record.roomName.isEmpty ? record.roomId : record.roomName);
    final targetId = isUserBan ? record.userId : record.roomId;
    if (targetId.isEmpty) {
      MessageUtils.showWarning(context, '封禁记录缺少目标 ID，无法解封');
      return;
    }

    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: isUserBan ? '解封用户' : '解封房间',
      icon: const Icon(Icons.lock_open_rounded, color: Colors.green),
      content: Text('确定要解除 "$targetName" 的封禁吗？'),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: '解封',
        ),
      ],
    );
    if (confirmed != true) return;

    try {
      if (isUserBan) {
        await WatchTogetherService.adminBanUser(targetId, false);
      } else {
        await WatchTogetherService.adminBanRoom(targetId, false);
      }
      if (!mounted) return;
      MessageUtils.showSuccess(context, '已解除封禁');
      _loadRecords(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '解封失败: $e');
    }
  }

  int get _pageCount {
    if (_total <= 0) return 1;
    return ((_total + _pageSize - 1) ~/ _pageSize).clamp(1, 1 << 31);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              DropdownButton<int>(
                value: _targetType,
                items: const [
                  DropdownMenuItem(value: 0, child: Text('全部对象')),
                  DropdownMenuItem(value: 1, child: Text('用户')),
                  DropdownMenuItem(value: 2, child: Text('房间')),
                ],
                onChanged: (value) {
                  setState(() {
                    _targetType = value ?? 0;
                    _page = 1;
                  });
                  _loadRecords();
                },
              ),
              DropdownButton<bool?>(
                value: _active,
                items: const [
                  DropdownMenuItem(value: null, child: Text('全部状态')),
                  DropdownMenuItem(value: true, child: Text('生效中')),
                  DropdownMenuItem(value: false, child: Text('已撤销/过期')),
                ],
                onChanged: (value) {
                  setState(() {
                    _active = value;
                    _page = 1;
                  });
                  _loadRecords();
                },
              ),
              DropdownButton<int>(
                value: _pageSize,
                items: const [
                  DropdownMenuItem(value: 20, child: Text('20 / 页')),
                  DropdownMenuItem(value: 50, child: Text('50 / 页')),
                  DropdownMenuItem(value: 100, child: Text('100 / 页')),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _pageSize = value;
                    _page = 1;
                  });
                  _loadRecords();
                },
              ),
              SizedBox(
                width: 260,
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search_rounded),
                    hintText: '输入 usr_/room_ ID',
                    isDense: true,
                  ),
                  onSubmitted: _applyBanSearch,
                ),
              ),
              if (_search.isNotEmpty)
                ActionChip(
                  label: Text(_search),
                  avatar: const Icon(Icons.close_rounded, size: 16),
                  onPressed: () => _applyBanSearch(''),
                ),
              IconButton(
                tooltip: '刷新',
                icon: const Icon(Icons.refresh_rounded),
                onPressed: () => _loadRecords(silent: true),
              ),
            ],
          ),
        ),
        _AdminPager(
          page: _page,
          pageSize: _pageSize,
          total: _total,
          onPrevious: _page <= 1
              ? null
              : () {
                  setState(() => _page -= 1);
                  _loadRecords();
                },
          onNext: _page >= _pageCount
              ? null
              : () {
                  setState(() => _page += 1);
                  _loadRecords();
                },
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _records.isEmpty
                  ? Center(
                      child: Text('暂无封禁记录',
                          style: TextStyle(color: theme.hintColor)))
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: _records.length,
                      itemBuilder: (context, index) {
                        final record = _records[index];
                        final target = record.targetType == 1
                            ? '${record.username} (${record.userId})'
                            : '${record.roomName} (${record.roomId})';
                        return _AdminPanelCard(
                          isDark: isDark,
                          child: ListTile(
                            leading: Icon(
                              record.isActive
                                  ? Icons.block_rounded
                                  : Icons.check_circle_outline,
                              color:
                                  record.isActive ? Colors.red : Colors.green,
                            ),
                            title: Text(target),
                            subtitle: Text(
                              '${record.reason.isEmpty ? '无原因' : record.reason}\n操作者: ${record.bannedByUsername} · ${_formatTimestamp(record.startsAt)}',
                            ),
                            isThreeLine: true,
                            trailing: record.isActive
                                ? IconButton(
                                    tooltip: '解除封禁',
                                    icon: const Icon(Icons.lock_open_rounded),
                                    color: Colors.green,
                                    onPressed: () => _unbanRecord(record),
                                  )
                                : const Text('已结束'),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

class AdminSettingsGroupsTab extends StatefulWidget {
  const AdminSettingsGroupsTab({super.key});

  @override
  State<AdminSettingsGroupsTab> createState() => _AdminSettingsGroupsTabState();
}

class _AdminSettingsGroupsTabState extends State<AdminSettingsGroupsTab> {
  bool _isLoading = true;
  bool _isLoadingGroup = false;
  List<AdminSettingsGroup> _groups = const [];
  String? _selectedGroup;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final groups = await WatchTogetherService.adminGetAllSettings();
      if (!mounted) return;
      setState(() {
        _groups = groups;
        _selectedGroup =
            _selectedGroup ?? (groups.isEmpty ? null : groups.first.name);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      MessageUtils.showError(context, '加载设置失败: $e');
    }
  }

  Future<void> _selectGroup(String? groupName) async {
    if (groupName == null || groupName == _selectedGroup) return;
    setState(() {
      _selectedGroup = groupName;
      _isLoadingGroup = true;
    });
    await _refreshSelectedGroup(silent: true);
  }

  Future<void> _refreshSelectedGroup({bool silent = false}) async {
    final groupName = _selectedGroup;
    if (groupName == null) return;
    if (!silent) setState(() => _isLoadingGroup = true);
    try {
      final group = await WatchTogetherService.adminGetSettingsGroup(groupName);
      if (!mounted) return;
      setState(() {
        _groups = [
          for (final item in _groups) item.name == group.name ? group : item,
        ];
        _isLoadingGroup = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingGroup = false);
      MessageUtils.showError(context, '刷新设置组失败: $e');
    }
  }

  Future<void> _editSetting(
    AdminSettingsGroup group,
    String key,
    dynamic value,
  ) async {
    dynamic nextValue;
    if (value is bool) {
      nextValue = !value;
    } else {
      final controller = TextEditingController(text: value?.toString() ?? '');
      final raw = await ChatUtils.showStyledDialog<String>(
        context: context,
        title: key,
        icon: const Icon(Icons.tune_rounded, color: Color(0xFF5D5FEF)),
        content: ChatUtils.createFormField(
          context: context,
          label: '值',
          controller: controller,
          hintText: '输入新值',
          prefixIcon: Icons.edit_rounded,
          keyboardType:
              value is num ? TextInputType.number : TextInputType.text,
        ),
        actions: [
          ChatUtils.createCancelButton(context),
          const SizedBox(width: 8),
          ChatUtils.createConfirmButton(
            context,
            () => Navigator.pop(context, controller.text.trim()),
            text: '保存',
          ),
        ],
      );
      if (raw == null) return;
      nextValue = _parseSettingValue(raw, value);
    }

    try {
      final updated = await WatchTogetherService.adminUpdateSettingInGroup(
        group.name,
        key,
        nextValue,
      );
      if (!mounted) return;
      setState(() {
        _groups = [
          for (final item in _groups)
            item.name == updated.name ? updated : item,
        ];
      });
      MessageUtils.showSuccess(context, '设置已更新');
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '更新设置失败: $e');
    }
  }

  Future<void> _sendTestEmail() async {
    final controller = TextEditingController();
    final email = await ChatUtils.showStyledDialog<String>(
      context: context,
      title: '发送测试邮件',
      icon: const Icon(Icons.outgoing_mail, color: Color(0xFF5D5FEF)),
      content: ChatUtils.createFormField(
        context: context,
        label: '收件人',
        controller: controller,
        hintText: 'name@example.com',
        prefixIcon: Icons.email_outlined,
        keyboardType: TextInputType.emailAddress,
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, controller.text.trim()),
          text: '发送',
        ),
      ],
    );
    if (email == null || email.isEmpty) return;
    try {
      final message = await WatchTogetherService.adminSendTestEmail(email);
      if (!mounted) return;
      MessageUtils.showSuccess(
        context,
        message.isEmpty ? '测试邮件已发送' : message,
      );
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '发送测试邮件失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    final selected =
        _groups.where((group) => group.name == _selectedGroup).firstOrNull;
    final entries = selected == null
        ? <MapEntry<String, dynamic>>[]
        : (selected.settings.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedGroup,
                  decoration: const InputDecoration(
                    labelText: '设置组',
                    prefixIcon: Icon(Icons.folder_outlined),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: [
                    for (final group in _groups)
                      DropdownMenuItem(
                        value: group.name,
                        child: Text(group.name),
                      ),
                  ],
                  onChanged: _isLoadingGroup ? null : _selectGroup,
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                tooltip: '发送测试邮件',
                icon: const Icon(Icons.outgoing_mail),
                onPressed: _sendTestEmail,
              ),
              IconButton(
                tooltip: '刷新当前组',
                icon: _isLoadingGroup
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh_rounded),
                onPressed:
                    _isLoadingGroup ? null : () => _refreshSelectedGroup(),
              ),
              IconButton(
                tooltip: '刷新全部',
                icon: const Icon(Icons.sync_rounded),
                onPressed:
                    _isLoadingGroup ? null : () => _loadSettings(silent: true),
              ),
            ],
          ),
        ),
        Expanded(
          child: selected == null || entries.isEmpty
              ? Center(
                  child: Text('暂无设置', style: TextStyle(color: theme.hintColor)))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return _AdminPanelCard(
                      isDark: isDark,
                      child: ListTile(
                        title: Text(entry.key),
                        subtitle: Text(_settingValueLabel(entry.value)),
                        trailing: entry.value is bool
                            ? Switch(
                                value: entry.value == true,
                                onChanged: (_) => _editSetting(
                                  selected,
                                  entry.key,
                                  entry.value,
                                ),
                              )
                            : IconButton(
                                tooltip: '编辑',
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => _editSetting(
                                  selected,
                                  entry.key,
                                  entry.value,
                                ),
                              ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  dynamic _parseSettingValue(String raw, dynamic currentValue) {
    if (currentValue is int) return int.tryParse(raw) ?? currentValue;
    if (currentValue is double) return double.tryParse(raw) ?? currentValue;
    if (currentValue is num) return num.tryParse(raw) ?? currentValue;
    return raw;
  }

  String _settingValueLabel(dynamic value) {
    if (value is bool) return value ? 'true' : 'false';
    if (value == null) return 'null';
    return value.toString();
  }
}

class _AdminPanelCard extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const _AdminPanelCard({
    required this.isDark,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _AdminPager extends StatelessWidget {
  final int page;
  final int pageSize;
  final int? total;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const _AdminPager({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = this.total;
    final label = total == null
        ? '第 $page 页 · 每页 $pageSize'
        : '第 $page 页 · 每页 $pageSize · 共 $total 条';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: theme.hintColor)),
          const Spacer(),
          IconButton(
            tooltip: '上一页',
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: onPrevious,
          ),
          IconButton(
            tooltip: '下一页',
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(label, style: TextStyle(color: theme.hintColor)),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _StatTile(
    this.label,
    this.value,
    this.icon,
    this.color,
    this.isDark,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 156,
      child: _AdminPanelCard(
        isDark: isDark,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 12),
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: Theme.of(context).hintColor)),
            ],
          ),
        ),
      ),
    );
  }
}

String _reviewStatusText(int status) {
  return switch (status) {
    1 => '待审核',
    2 => '已通过',
    3 => '已拒绝',
    _ => '未知',
  };
}

String _providerStatusText(int status) {
  return switch (status) {
    1 => '已连接',
    2 => '已断开',
    3 => '错误',
    _ => '未知',
  };
}

String _systemRoleText(int role) {
  return switch (role) {
    1 => 'Root',
    2 => '管理员',
    3 => '用户',
    _ => '未知',
  };
}

String _userStatusText(int status) {
  return switch (status) {
    1 => '正常',
    2 => '已封禁',
    _ => '未知',
  };
}

String _roomStatusText(int status) {
  return switch (status) {
    1 => '活跃',
    2 => '已关闭',
    _ => '未知',
  };
}

String _resourceAvailabilityText(int availability) {
  return switch (availability) {
    1 => '可用',
    2 => '创建者不可用',
    _ => '未知',
  };
}

Color _roomStatusColor(int status) {
  return switch (status) {
    1 => Colors.green,
    2 => Colors.grey,
    _ => Colors.grey,
  };
}

String _roomMemberRoleText(int role) {
  return switch (role) {
    1 => '创建者',
    2 => '管理员',
    3 => '成员',
    4 => '访客',
    _ => '未知',
  };
}

enum _RoomPasswordAction { keep, update, clear }

enum _PermissionOverrideMode { inherit, allow, deny }

class _PermissionOverrideResult {
  final int addedPermissions;
  final int removedPermissions;
  final int adminAddedPermissions;
  final int adminRemovedPermissions;

  const _PermissionOverrideResult({
    required this.addedPermissions,
    required this.removedPermissions,
    required this.adminAddedPermissions,
    required this.adminRemovedPermissions,
  });
}

Widget _closeButton(BuildContext context) {
  return TextButton(
    onPressed: () => Navigator.pop(context),
    child: const Text('关闭'),
  );
}

String _formatTimestamp(int timestamp) {
  if (timestamp <= 0) return '-';
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')} '
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
}
