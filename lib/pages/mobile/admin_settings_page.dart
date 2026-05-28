import 'dart:convert';

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

class _AdminSection {
  final String label;
  final IconData icon;
  final Widget page;

  const _AdminSection({
    required this.label,
    required this.icon,
    required this.page,
  });
}

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
  static const List<_AdminSection> _sections = [
    _AdminSection(
      label: '总览',
      icon: Icons.dashboard_rounded,
      page: AdminOverviewTab(),
    ),
    _AdminSection(
      label: '房间',
      icon: Icons.meeting_room_rounded,
      page: RoomManagementTab(),
    ),
    _AdminSection(
      label: '用户',
      icon: Icons.people_alt_rounded,
      page: UserManagementTab(),
    ),
    _AdminSection(
      label: '审核',
      icon: Icons.fact_check_rounded,
      page: AdminReviewTab(),
    ),
    _AdminSection(
      label: 'Provider',
      icon: Icons.hub_rounded,
      page: AdminProviderTab(),
    ),
    _AdminSection(
      label: '推流',
      icon: Icons.podcasts_rounded,
      page: AdminStreamsTab(),
    ),
    _AdminSection(
      label: '封禁',
      icon: Icons.gavel_rounded,
      page: AdminBanRecordsTab(),
    ),
    _AdminSection(
      label: '设置',
      icon: Icons.tune_rounded,
      page: AdminSettingsGroupsTab(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _sections.length, vsync: this);
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
          backgroundColor:
              isDark ? const Color(0xFF121212) : const Color(0xFFF7F7FC),
          centerTitle: true,
          systemOverlayStyle: systemUiOverlayStyle,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final useRail = constraints.maxWidth >= 920;
            if (!useRail) {
              return Column(
                children: [
                  _buildTopTabs(theme, isDark),
                  Expanded(child: _buildTabView()),
                ],
              );
            }

            return Row(
              children: [
                _buildSideNavigation(theme, isDark),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: theme.dividerColor.withValues(alpha: 0.55),
                ),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF151518)
                          : const Color(0xFFF3F5F8),
                    ),
                    child: _buildTabView(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabView() {
    return TabBarView(
      controller: _tabController,
      children: _sections.map((section) => section.page).toList(),
    );
  }

  Widget _buildSideNavigation(ThemeData theme, bool isDark) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        return SizedBox(
          width: 232,
          child: Material(
            color: isDark ? const Color(0xFF101012) : Colors.white,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 14),
                      child: Text(
                        '系统管理',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.68),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: _sections.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          final section = _sections[index];
                          final selected = _tabController.index == index;
                          return _SettingsNavTile(
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

  Widget _buildTopTabs(ThemeData theme, bool isDark) {
    return Material(
      color: theme.colorScheme.surface,
      elevation: 0,
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
            unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w500,
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
}

class _SettingsNavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SettingsNavTile({
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
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
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
  final Set<String> _savingSettings = <String>{};

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

  Future<void> _updateSetting(
    AdminSettingsGroup group,
    String key,
    dynamic nextValue,
  ) async {
    final settingId = '${group.name}.$key';
    setState(() => _savingSettings.add(settingId));

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
        _savingSettings.remove(settingId);
      });
      MessageUtils.showSuccess(context, '设置已更新');
    } catch (e) {
      if (!mounted) return;
      setState(() => _savingSettings.remove(settingId));
      MessageUtils.showError(context, '更新设置失败: $e');
    }
  }

  Future<void> _editSetting(
    AdminSettingsGroup group,
    String key,
    dynamic value,
  ) async {
    final descriptor = _settingDescriptor(group.name, key, value);
    final normalizedValue = _normalizedSettingValue(group.name, key, value);

    if (normalizedValue is bool) {
      final confirmed = await _confirmRiskIfNeeded(descriptor);
      if (!confirmed) return;
      await _updateSetting(group, key, !normalizedValue);
      return;
    }

    final nextValue = await showModalBottomSheet<dynamic>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SettingEditorSheet(
        descriptor: descriptor,
        groupName: group.name,
        settingKey: key,
        value: normalizedValue,
      ),
    );
    if (nextValue == null) return;

    final confirmed = await _confirmRiskIfNeeded(descriptor);
    if (!confirmed) return;
    await _updateSetting(group, key, nextValue);
  }

  Future<void> _editOAuth2Provider(
    AdminSettingsGroup group,
    Map<String, dynamic> providers,
    String? name,
  ) async {
    final current = name == null
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(providers[name] as Map? ?? const {});
    final result = await showModalBottomSheet<_OAuth2ProviderEditResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _OAuth2ProviderEditorSheet(
        initialName: name,
        initialValue: current,
        existingNames: providers.keys.toSet(),
      ),
    );
    if (result == null) return;

    final descriptor = _settingDescriptor('oauth2', 'providers', providers);
    final confirmed = await _confirmRiskIfNeeded(descriptor);
    if (!confirmed) return;

    final next = Map<String, dynamic>.from(providers);
    if (name != null && name != result.name) next.remove(name);
    next[result.name] = result.value;
    await _updateSetting(group, 'providers', next);
  }

  Future<void> _deleteOAuth2Provider(
    AdminSettingsGroup group,
    Map<String, dynamic> providers,
    String name,
  ) async {
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '删除登录提供方',
      icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE5484D)),
      content: Text('确认删除 OAuth2 登录提供方 "$name"？删除后用户不能再通过该入口登录。'),
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
    final next = Map<String, dynamic>.from(providers)..remove(name);
    await _updateSetting(group, 'providers', next);
  }

  Future<bool> _confirmRiskIfNeeded(_SettingDescriptor descriptor) async {
    final warning = descriptor.warning;
    if (warning == null || warning.isEmpty) return true;
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '确认修改',
      icon: const Icon(Icons.warning_amber_rounded, color: Color(0xFFE09F3E)),
      content: Text(warning),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: '确认修改',
        ),
      ],
    );
    return confirmed == true;
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
    final useTwoPane = MediaQuery.sizeOf(context).width >= 860;

    final isOAuth2Group = selected?.name == 'oauth2' &&
        selected!.settings.containsKey('providers');
    final oauth2Providers = isOAuth2Group
        ? _oauth2ProvidersFromValue(
            _normalizedSettingValue(
              selected.name,
              'providers',
              selected.settings['providers'],
            ),
          )
        : <String, dynamic>{};

    final settingsList = selected == null || entries.isEmpty
        ? Center(child: Text('暂无设置', style: TextStyle(color: theme.hintColor)))
        : isOAuth2Group
            ? ListView(
                padding: EdgeInsets.fromLTRB(useTwoPane ? 8 : 16, 0, 16, 24),
                children: [
                  _SettingsGroupHeader(
                    groupName: selected.name,
                    entryCount: oauth2Providers.length,
                    isLoading: _isLoadingGroup,
                    action: FilledButton.icon(
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('添加登录提供方'),
                      onPressed: _savingSettings.contains('oauth2.providers')
                          ? null
                          : () => _editOAuth2Provider(
                              selected, oauth2Providers, null),
                    ),
                    onRefresh:
                        _isLoadingGroup ? null : () => _refreshSelectedGroup(),
                  ),
                  _OAuth2ProvidersList(
                    providers: oauth2Providers,
                    saving: _savingSettings.contains('oauth2.providers'),
                    onEdit: (name) =>
                        _editOAuth2Provider(selected, oauth2Providers, name),
                    onDelete: (name) =>
                        _deleteOAuth2Provider(selected, oauth2Providers, name),
                  ),
                ],
              )
            : ListView.builder(
                padding: EdgeInsets.fromLTRB(useTwoPane ? 8 : 16, 0, 16, 24),
                itemCount: entries.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _SettingsGroupHeader(
                      groupName: selected.name,
                      entryCount: entries.length,
                      isLoading: _isLoadingGroup,
                      onRefresh: _isLoadingGroup
                          ? null
                          : () => _refreshSelectedGroup(),
                    );
                  }
                  final entry = entries[index - 1];
                  final normalized = _normalizedSettingValue(
                      selected.name, entry.key, entry.value);
                  final descriptor =
                      _settingDescriptor(selected.name, entry.key, normalized);
                  final settingId = '${selected.name}.${entry.key}';
                  return _AdminPanelCard(
                    isDark: isDark,
                    child: _SettingTile(
                      descriptor: descriptor,
                      value: normalized,
                      saving: _savingSettings.contains(settingId),
                      onEdit: () =>
                          _editSetting(selected, entry.key, normalized),
                    ),
                  );
                },
              );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: useTwoPane
                    ? Text(
                        '运行时设置',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : _SettingsGroupDropdown(
                        groups: _groups,
                        selectedGroup: _selectedGroup,
                        enabled: !_isLoadingGroup,
                        onChanged: _selectGroup,
                      ),
              ),
              const SizedBox(width: 12),
              IconButton.filledTonal(
                tooltip: '发送测试邮件',
                icon: const Icon(Icons.outgoing_mail),
                onPressed: _sendTestEmail,
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                tooltip: '刷新全部',
                icon: const Icon(Icons.sync_rounded),
                onPressed:
                    _isLoadingGroup ? null : () => _loadSettings(silent: true),
              ),
            ],
          ),
        ),
        Expanded(
          child: useTwoPane
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 280,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 8, 24),
                        children: [
                          for (final group in _groups)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _SettingsGroupButton(
                                groupName: group.name,
                                selected: group.name == _selectedGroup,
                                count: group.settings.length,
                                onTap: _isLoadingGroup
                                    ? null
                                    : () => _selectGroup(group.name),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(child: settingsList),
                  ],
                )
              : settingsList,
        ),
      ],
    );
  }

  dynamic _normalizedSettingValue(String group, String key, dynamic value) {
    final descriptor = _settingDescriptor(group, key, value);
    if (value is String) {
      switch (descriptor.kind) {
        case _SettingEditorKind.oauth2Providers:
        case _SettingEditorKind.iceServers:
        case _SettingEditorKind.stringList:
        case _SettingEditorKind.permissionList:
        case _SettingEditorKind.map:
        case _SettingEditorKind.list:
          try {
            return jsonDecode(value);
          } catch (_) {
            if (descriptor.kind == _SettingEditorKind.stringList) {
              return value
                  .split(RegExp(r'[\n,]'))
                  .map((item) => item.trim())
                  .where((item) => item.isNotEmpty)
                  .toList();
            }
          }
          break;
        case _SettingEditorKind.boolean:
        case _SettingEditorKind.enumChoice:
        case _SettingEditorKind.number:
        case _SettingEditorKind.text:
          break;
      }
    }
    return value;
  }
}

enum _SettingEditorKind {
  boolean,
  number,
  text,
  enumChoice,
  stringList,
  permissionList,
  oauth2Providers,
  iceServers,
  map,
  list,
}

class _SettingDescriptor {
  final String group;
  final String key;
  final String title;
  final String description;
  final IconData icon;
  final _SettingEditorKind kind;
  final List<_SettingChoice> choices;
  final String? warning;
  final bool secret;

  const _SettingDescriptor({
    required this.group,
    required this.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.kind,
    this.choices = const [],
    this.warning,
    this.secret = false,
  });
}

class _SettingChoice {
  final String value;
  final String label;
  final String description;

  const _SettingChoice(this.value, this.label, this.description);
}

const Map<String, String> _settingsGroupLabels = {
  'server': '服务',
  'room': '房间',
  'user': '用户',
  'oauth2': 'OAuth2',
  'proxy': '代理',
  'rtmp': '推流',
  'email': '邮件',
  'webrtc': 'WebRTC',
  'chat': '聊天',
  'cors': '跨域',
  'permissions': '权限',
};

const List<_SettingChoice> _roomPasswordChoices = [
  _SettingChoice('optional', '可选', '创建房间时可自行决定是否设置密码'),
  _SettingChoice('required', '必须', '所有新房间都必须设置密码'),
  _SettingChoice('forbidden', '禁用', '不允许新房间设置密码'),
];

const List<String> _oauth2ProviderTypes = ['github', 'google', 'logto', 'oidc'];

const Map<String, String> _oauth2ProviderTypeLabels = {
  'github': 'GitHub',
  'google': 'Google',
  'logto': 'Logto',
  'oidc': 'OIDC',
};

const List<String> _knownPermissions = [
  'chat',
  'create_media_resource',
  'view_media_resources',
  'view_member_list',
  'view_chat_history',
  'use_webrtc',
  'delete_media_resource_any',
  'reorder_media_resources',
  'clear_media_resources',
  'live_control',
  'play_control',
  'change_current_media',
  'change_playback_rate',
  'approve_member',
  'kick_member',
  'set_member_permissions',
  'add_member',
  'set_room_settings',
  'delete_chat',
  'delete_room',
];

const Map<String, String> _permissionLabels = {
  'chat': '发送聊天',
  'create_media_resource': '添加媒体',
  'view_media_resources': '查看媒体',
  'view_member_list': '查看成员',
  'view_chat_history': '查看聊天历史',
  'use_webrtc': '使用 WebRTC',
  'delete_media_resource_any': '删除任意媒体',
  'reorder_media_resources': '调整播放列表',
  'clear_media_resources': '清空播放列表',
  'live_control': '直播控制',
  'play_control': '播放控制',
  'change_current_media': '切换影片',
  'change_playback_rate': '调整倍速',
  'approve_member': '审批成员',
  'kick_member': '踢出成员',
  'set_member_permissions': '设置成员权限',
  'add_member': '添加成员',
  'set_room_settings': '修改房间设置',
  'delete_chat': '删除聊天',
  'delete_room': '删除房间',
};

_SettingDescriptor _settingDescriptor(
  String group,
  String key,
  dynamic value,
) {
  final id = '$group.$key';
  final known = <String, _SettingDescriptor>{
    'server.allow_room_creation': const _SettingDescriptor(
      group: 'server',
      key: 'allow_room_creation',
      title: '允许创建房间',
      description: '控制普通用户是否可以创建新房间。',
      icon: Icons.add_home_work_outlined,
      kind: _SettingEditorKind.boolean,
    ),
    'server.max_rooms_per_user': const _SettingDescriptor(
      group: 'server',
      key: 'max_rooms_per_user',
      title: '每个用户最多房间数',
      description: '限制单个用户可拥有的房间数量。',
      icon: Icons.meeting_room_outlined,
      kind: _SettingEditorKind.number,
    ),
    'server.max_members_per_room': const _SettingDescriptor(
      group: 'server',
      key: 'max_members_per_room',
      title: '每个房间最多成员数',
      description: '限制单个房间的成员上限。',
      icon: Icons.groups_2_outlined,
      kind: _SettingEditorKind.number,
    ),
    'server.max_chat_messages': const _SettingDescriptor(
      group: 'server',
      key: 'max_chat_messages',
      title: '房间聊天快照条数',
      description: '服务端保留并推送给客户端的聊天消息上限，0 表示不限制。',
      icon: Icons.forum_outlined,
      kind: _SettingEditorKind.number,
    ),
    'room.disable_create_room': const _SettingDescriptor(
      group: 'room',
      key: 'disable_create_room',
      title: '关闭创建房间',
      description: '打开后用户不能创建新房间，适合维护或封闭运营。',
      icon: Icons.block_outlined,
      kind: _SettingEditorKind.boolean,
      warning: '关闭创建房间会立刻影响所有用户的新建房间入口。',
    ),
    'room.create_room_need_review': const _SettingDescriptor(
      group: 'room',
      key: 'create_room_need_review',
      title: '创建房间需要审核',
      description: '打开后新建房间进入审核流程，通过后才可正常使用。',
      icon: Icons.fact_check_outlined,
      kind: _SettingEditorKind.boolean,
    ),
    'room.password_policy': const _SettingDescriptor(
      group: 'room',
      key: 'password_policy',
      title: '房间密码策略',
      description: '统一约束新房间是否必须或禁止设置密码。',
      icon: Icons.password_rounded,
      kind: _SettingEditorKind.enumChoice,
      choices: _roomPasswordChoices,
    ),
    'user.enable_password_signup': const _SettingDescriptor(
      group: 'user',
      key: 'enable_password_signup',
      title: '允许密码注册',
      description: '用户可以使用用户名和密码注册账号。',
      icon: Icons.person_add_alt_1_outlined,
      kind: _SettingEditorKind.boolean,
    ),
    'user.password_signup_need_review': const _SettingDescriptor(
      group: 'user',
      key: 'password_signup_need_review',
      title: '密码注册需要审核',
      description: '新账号注册后需要管理员审核。',
      icon: Icons.how_to_reg_outlined,
      kind: _SettingEditorKind.boolean,
    ),
    'user.enable_email_signup': const _SettingDescriptor(
      group: 'user',
      key: 'enable_email_signup',
      title: '允许邮箱注册',
      description: '用户可以通过邮箱验证码注册账号。',
      icon: Icons.alternate_email_rounded,
      kind: _SettingEditorKind.boolean,
    ),
    'user.email_signup_need_review': const _SettingDescriptor(
      group: 'user',
      key: 'email_signup_need_review',
      title: '邮箱注册需要审核',
      description: '邮箱注册完成后仍需管理员审核。',
      icon: Icons.mark_email_read_outlined,
      kind: _SettingEditorKind.boolean,
    ),
    'user.enable_webauthn_signup': const _SettingDescriptor(
      group: 'user',
      key: 'enable_webauthn_signup',
      title: '允许 Passkey 注册',
      description: '用户可以使用系统 Passkey 能力创建账号。',
      icon: Icons.fingerprint_rounded,
      kind: _SettingEditorKind.boolean,
    ),
    'user.webauthn_signup_need_review': const _SettingDescriptor(
      group: 'user',
      key: 'webauthn_signup_need_review',
      title: 'Passkey 注册需要审核',
      description: 'Passkey 注册后需要管理员审核。',
      icon: Icons.verified_user_outlined,
      kind: _SettingEditorKind.boolean,
    ),
    'user.enable_guest': const _SettingDescriptor(
      group: 'user',
      key: 'enable_guest',
      title: '允许游客',
      description: '未登录用户可以以游客身份进入允许游客的房间。',
      icon: Icons.person_outline_rounded,
      kind: _SettingEditorKind.boolean,
      warning: '允许游客会降低房间访问门槛，请确认公开房间和默认权限配置符合预期。',
    ),
    'oauth2.providers': const _SettingDescriptor(
      group: 'oauth2',
      key: 'providers',
      title: '第三方登录',
      description: '管理 OAuth2/OIDC 登录提供方实例、注册策略和回调配置。',
      icon: Icons.account_tree_outlined,
      kind: _SettingEditorKind.oauth2Providers,
      warning: 'OAuth2 配置会影响登录入口。错误的回调地址、密钥或端点会导致第三方登录不可用。',
    ),
    'proxy.movie_proxy': const _SettingDescriptor(
      group: 'proxy',
      key: 'movie_proxy',
      title: '影片代理',
      description: '允许服务端代理影片资源请求。',
      icon: Icons.movie_filter_outlined,
      kind: _SettingEditorKind.boolean,
      warning: '代理能力可能把用户配置的认证信息发送给目标媒体站点，并随播放资源发布给房间成员。仅在信任成员和媒体来源时启用。',
    ),
    'proxy.live_proxy': const _SettingDescriptor(
      group: 'proxy',
      key: 'live_proxy',
      title: '直播代理',
      description: '允许服务端代理直播流请求。',
      icon: Icons.live_tv_outlined,
      kind: _SettingEditorKind.boolean,
      warning: '直播代理可能转发敏感请求头或 Cookie，并通过播放信息暴露给房间成员。请确认来源可信。',
    ),
    'rtmp.custom_publish_host': const _SettingDescriptor(
      group: 'rtmp',
      key: 'custom_publish_host',
      title: '推流发布地址',
      description: '覆盖对外展示的 RTMP 发布主机，留空使用服务端默认地址。',
      icon: Icons.podcasts_outlined,
      kind: _SettingEditorKind.text,
    ),
    'rtmp.ts_disguised_as_png': const _SettingDescriptor(
      group: 'rtmp',
      key: 'ts_disguised_as_png',
      title: 'TS 分片伪装为 PNG',
      description: '将 HLS TS 分片以 PNG 后缀暴露，用于部分网络环境兼容。',
      icon: Icons.image_outlined,
      kind: _SettingEditorKind.boolean,
    ),
    'email.whitelist_enabled': const _SettingDescriptor(
      group: 'email',
      key: 'whitelist_enabled',
      title: '启用邮箱白名单',
      description: '限制邮箱注册只能使用指定域名或邮箱。',
      icon: Icons.mark_email_unread_outlined,
      kind: _SettingEditorKind.boolean,
    ),
    'email.whitelist': const _SettingDescriptor(
      group: 'email',
      key: 'whitelist',
      title: '邮箱白名单',
      description: '每行一个邮箱或域名。域名可使用 example.com 或 @example.com。',
      icon: Icons.playlist_add_check_rounded,
      kind: _SettingEditorKind.stringList,
    ),
    'webrtc.external_ice_servers': const _SettingDescriptor(
      group: 'webrtc',
      key: 'external_ice_servers',
      title: '外部 ICE 服务器',
      description: '向客户端下发的 STUN/TURN 服务器列表。',
      icon: Icons.settings_input_antenna_rounded,
      kind: _SettingEditorKind.iceServers,
      warning: 'TURN 用户名和凭据会下发给客户端。请使用最小权限、可轮换的账号。',
    ),
    'chat.max_messages_per_room': const _SettingDescriptor(
      group: 'chat',
      key: 'max_messages_per_room',
      title: '每个房间保留聊天数',
      description: '聊天消息按房间保留的数量上限，0 表示不限制。',
      icon: Icons.chat_bubble_outline_rounded,
      kind: _SettingEditorKind.number,
    ),
    'chat.message_retention_days': const _SettingDescriptor(
      group: 'chat',
      key: 'message_retention_days',
      title: '聊天保留天数',
      description: '聊天消息的最长保留时间。',
      icon: Icons.history_toggle_off_rounded,
      kind: _SettingEditorKind.number,
    ),
    'cors.allowed_origins': const _SettingDescriptor(
      group: 'cors',
      key: 'allowed_origins',
      title: '允许跨域来源',
      description: '允许访问代理接口的 Web Origin 列表，原生客户端通常不需要配置。',
      icon: Icons.public_rounded,
      kind: _SettingEditorKind.stringList,
      warning: '跨域来源配置过宽会扩大浏览器侧访问面。只添加明确可信的 https Origin。',
    ),
    'permissions.admin_default': const _SettingDescriptor(
      group: 'permissions',
      key: 'admin_default',
      title: '管理员默认权限',
      description: '房间管理员的默认权限集合。',
      icon: Icons.admin_panel_settings_outlined,
      kind: _SettingEditorKind.permissionList,
    ),
    'permissions.member_default': const _SettingDescriptor(
      group: 'permissions',
      key: 'member_default',
      title: '成员默认权限',
      description: '普通成员加入房间后的默认权限集合。',
      icon: Icons.group_outlined,
      kind: _SettingEditorKind.permissionList,
    ),
    'permissions.guest_default': const _SettingDescriptor(
      group: 'permissions',
      key: 'guest_default',
      title: '游客默认权限',
      description: '游客进入房间后的默认权限集合。后端会拒绝不安全权限。',
      icon: Icons.person_pin_circle_outlined,
      kind: _SettingEditorKind.permissionList,
      warning: '游客权限会影响未登录用户。请只授予查看和低风险操作权限。',
    ),
  };
  final descriptor = known[id];
  if (descriptor != null) return descriptor;

  final kind = switch (value) {
    bool _ => _SettingEditorKind.boolean,
    int _ || double _ || num _ => _SettingEditorKind.number,
    Map _ => _SettingEditorKind.map,
    List _ => _SettingEditorKind.list,
    _ => _SettingEditorKind.text,
  };
  return _SettingDescriptor(
    group: group,
    key: key,
    title: _humanizeSettingKey(key),
    description: '${_settingsGroupLabel(group)} 运行时配置。',
    icon: Icons.tune_rounded,
    kind: kind,
    secret: _isSecretKey(key),
  );
}

String _settingsGroupLabel(String group) =>
    _settingsGroupLabels[group] ?? group;

String _humanizeSettingKey(String key) {
  return key
      .replaceAll('_', ' ')
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join(' ');
}

bool _isSecretKey(String key) {
  final lower = key.toLowerCase();
  return lower.contains('secret') ||
      lower.contains('password') ||
      lower.contains('credential') ||
      lower.contains('token') ||
      lower.contains('key');
}

String _settingSummary(dynamic value, _SettingDescriptor descriptor) {
  if (value == null) return '未设置';
  switch (descriptor.kind) {
    case _SettingEditorKind.boolean:
      return value == true ? '已开启' : '已关闭';
    case _SettingEditorKind.oauth2Providers:
      final map = value is Map ? value : const {};
      if (map.isEmpty) return '未配置第三方登录';
      final enabled = map.values.where((entry) {
        if (entry is! Map) return false;
        return (entry['config'] is Map) &&
            (entry['config']['client_id'] ?? '').toString().isNotEmpty;
      }).length;
      return '${map.length} 个实例，$enabled 个已填写 Client ID';
    case _SettingEditorKind.iceServers:
      final list = value is List ? value : const [];
      return list.isEmpty ? '未配置 ICE 服务器' : '${list.length} 个 ICE 服务器';
    case _SettingEditorKind.stringList:
    case _SettingEditorKind.permissionList:
    case _SettingEditorKind.list:
      final list = _valueAsStringList(value);
      return list.isEmpty ? '空列表' : list.join('、');
    case _SettingEditorKind.enumChoice:
      return descriptor.choices
          .firstWhere(
            (choice) => choice.value == value.toString(),
            orElse: () =>
                _SettingChoice(value.toString(), value.toString(), ''),
          )
          .label;
    case _SettingEditorKind.map:
      final map = value is Map ? value : const {};
      return map.isEmpty ? '空对象' : '${map.length} 项配置';
    case _SettingEditorKind.number:
    case _SettingEditorKind.text:
      if (descriptor.secret && value.toString().isNotEmpty) return '已设置';
      return value.toString().isEmpty ? '未设置' : value.toString();
  }
}

List<String> _valueAsStringList(dynamic value) {
  if (value is List) {
    return value
        .map((item) => item.toString())
        .where((item) => item.isNotEmpty)
        .toList();
  }
  if (value is String) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return <String>[];
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is List) {
        return decoded.map((item) => item.toString()).toList();
      }
    } catch (_) {}
    return trimmed
        .split(RegExp(r'[\n,]'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
  return <String>[];
}

class _SettingsGroupDropdown extends StatelessWidget {
  final List<AdminSettingsGroup> groups;
  final String? selectedGroup;
  final bool enabled;
  final ValueChanged<String?> onChanged;

  const _SettingsGroupDropdown({
    required this.groups,
    required this.selectedGroup,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: selectedGroup,
      decoration: const InputDecoration(
        labelText: '设置组',
        prefixIcon: Icon(Icons.folder_outlined),
        border: OutlineInputBorder(),
        isDense: true,
      ),
      items: [
        for (final group in groups)
          DropdownMenuItem(
            value: group.name,
            child: Text(_settingsGroupLabel(group.name)),
          ),
      ],
      onChanged: enabled ? onChanged : null,
    );
  }
}

class _SettingsGroupButton extends StatelessWidget {
  final String groupName;
  final bool selected;
  final int count;
  final VoidCallback? onTap;

  const _SettingsGroupButton({
    required this.groupName,
    required this.selected,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;
    return Material(
      color: selected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.7)
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.folder_outlined, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _settingsGroupLabel(groupName),
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              Text(
                count.toString(),
                style: theme.textTheme.labelMedium?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsGroupHeader extends StatelessWidget {
  final String groupName;
  final int entryCount;
  final bool isLoading;
  final Widget? action;
  final VoidCallback? onRefresh;

  const _SettingsGroupHeader({
    required this.groupName,
    required this.entryCount,
    required this.isLoading,
    this.action,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _settingsGroupLabel(groupName),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$entryCount 项可配置设置',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: 12),
            action!,
          ],
          const SizedBox(width: 8),
          IconButton.filledTonal(
            tooltip: '刷新当前组',
            icon: isLoading
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded),
            onPressed: onRefresh,
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final _SettingDescriptor descriptor;
  final dynamic value;
  final bool saving;
  final VoidCallback onEdit;

  const _SettingTile({
    required this.descriptor,
    required this.value,
    required this.saving,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBool =
        descriptor.kind == _SettingEditorKind.boolean && value is bool;
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(descriptor.icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  descriptor.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  descriptor.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _settingSummary(value, descriptor),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
                if (descriptor.warning != null) ...[
                  const SizedBox(height: 10),
                  _InlineWarning(text: descriptor.warning!),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (saving)
            const SizedBox.square(
              dimension: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else if (isBool)
            Switch(value: value == true, onChanged: (_) => onEdit())
          else
            IconButton.filledTonal(
              tooltip: '编辑',
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }
}

class _InlineWarning extends StatelessWidget {
  final String text;

  const _InlineWarning({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: const Color(0xFFE0A800).withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded,
              size: 18, color: Colors.amber.shade900),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: const Color(0xFF6B4E00)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingEditorSheet extends StatefulWidget {
  final _SettingDescriptor descriptor;
  final String groupName;
  final String settingKey;
  final dynamic value;

  const _SettingEditorSheet({
    required this.descriptor,
    required this.groupName,
    required this.settingKey,
    required this.value,
  });

  @override
  State<_SettingEditorSheet> createState() => _SettingEditorSheetState();
}

class _SettingEditorSheetState extends State<_SettingEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late dynamic _value;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _value = _deepCopySettingValue(widget.value);
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _controller(String id, [String initial = '']) {
    return _controllers.putIfAbsent(
        id, () => TextEditingController(text: initial));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760, maxHeight: 760),
          child: Material(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            clipBehavior: Clip.antiAlias,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 12, 10),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer
                                .withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(widget.descriptor.icon,
                              color: theme.colorScheme.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.descriptor.title,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.descriptor.description,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: '关闭',
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  if (widget.descriptor.warning != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                      child: _InlineWarning(text: widget.descriptor.warning!),
                    ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                      child: _buildEditor(),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                              color:
                                  theme.dividerColor.withValues(alpha: 0.45)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('取消'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.icon(
                              icon: const Icon(Icons.check_rounded),
                              label: const Text('保存'),
                              onPressed: _save,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditor() {
    switch (widget.descriptor.kind) {
      case _SettingEditorKind.number:
        return _NumberSettingEditor(
          controller: _controller('number', _value?.toString() ?? ''),
        );
      case _SettingEditorKind.text:
        return _TextSettingEditor(
          controller: _controller('text', _value?.toString() ?? ''),
          secret: widget.descriptor.secret,
        );
      case _SettingEditorKind.enumChoice:
        return _EnumSettingEditor(
          choices: widget.descriptor.choices,
          value: _value?.toString() ?? '',
          onChanged: (value) => setState(() => _value = value),
        );
      case _SettingEditorKind.stringList:
        return _StringListSettingEditor(
          values: _valueAsStringList(_value),
          label: '条目',
          hintText: _stringListHint(widget.groupName, widget.settingKey),
          onChanged: (values) => setState(() => _value = values),
        );
      case _SettingEditorKind.permissionList:
        return _PermissionListSettingEditor(
          values: _valueAsStringList(_value).toSet(),
          onChanged: (values) =>
              setState(() => _value = values.toList()..sort()),
        );
      case _SettingEditorKind.oauth2Providers:
        return _OAuth2ProvidersEditor(
          providers: _oauth2ProvidersFromValue(_value),
          onChanged: (providers) => setState(() => _value = providers),
        );
      case _SettingEditorKind.iceServers:
        return _IceServersEditor(
          servers: _iceServersFromValue(_value),
          onChanged: (servers) => setState(() => _value = servers),
        );
      case _SettingEditorKind.map:
        return _StructuredValueEditor(
          value: _value is Map
              ? Map<String, dynamic>.from(_value)
              : <String, dynamic>{},
          onChanged: (value) => setState(() => _value = value),
        );
      case _SettingEditorKind.list:
        return _StringListSettingEditor(
          values: _valueAsStringList(_value),
          label: '条目',
          hintText: '输入条目',
          onChanged: (values) => setState(() => _value = values),
        );
      case _SettingEditorKind.boolean:
        return SwitchListTile(
          value: _value == true,
          onChanged: (value) => setState(() => _value = value),
          title: Text(widget.descriptor.title),
          subtitle: Text(widget.descriptor.description),
        );
    }
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    dynamic result = _value;
    switch (widget.descriptor.kind) {
      case _SettingEditorKind.number:
        final raw = _controller('number').text.trim();
        result = num.tryParse(raw);
        if (result == null) return;
        if (!raw.contains('.') && result is num) result = result.toInt();
        break;
      case _SettingEditorKind.text:
        result = _controller('text').text.trim();
        break;
      case _SettingEditorKind.stringList:
        if (widget.groupName == 'email' && widget.settingKey == 'whitelist') {
          result = _valueAsStringList(_value).join('\n');
        } else {
          result = _valueAsStringList(_value);
        }
        break;
      case _SettingEditorKind.oauth2Providers:
      case _SettingEditorKind.iceServers:
      case _SettingEditorKind.permissionList:
      case _SettingEditorKind.map:
      case _SettingEditorKind.list:
      case _SettingEditorKind.enumChoice:
      case _SettingEditorKind.boolean:
        result = _value;
        break;
    }
    Navigator.pop(context, result);
  }

  String _stringListHint(String group, String key) {
    if (group == 'cors') return 'https://app.example.com';
    if (group == 'email') return '@example.com';
    return '输入条目';
  }
}

dynamic _deepCopySettingValue(dynamic value) {
  if (value is Map || value is List) return jsonDecode(jsonEncode(value));
  return value;
}

class _NumberSettingEditor extends StatelessWidget {
  final TextEditingController controller;

  const _NumberSettingEditor({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: '数值',
        prefixIcon: Icon(Icons.pin_outlined),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return '请输入数值';
        return num.tryParse(value.trim()) == null ? '请输入有效数值' : null;
      },
    );
  }
}

class _TextSettingEditor extends StatefulWidget {
  final TextEditingController controller;
  final bool secret;

  const _TextSettingEditor({
    required this.controller,
    required this.secret,
  });

  @override
  State<_TextSettingEditor> createState() => _TextSettingEditorState();
}

class _TextSettingEditorState extends State<_TextSettingEditor> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.secret && _obscure,
      minLines: widget.secret ? 1 : null,
      maxLines: widget.secret ? 1 : 4,
      decoration: InputDecoration(
        labelText: '内容',
        prefixIcon: const Icon(Icons.edit_outlined),
        border: const OutlineInputBorder(),
        suffixIcon: widget.secret
            ? IconButton(
                tooltip: _obscure ? '显示' : '隐藏',
                icon: Icon(_obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
      ),
    );
  }
}

class _EnumSettingEditor extends StatelessWidget {
  final List<_SettingChoice> choices;
  final String value;
  final ValueChanged<String> onChanged;

  const _EnumSettingEditor({
    required this.choices,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final choice in choices)
          Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              onTap: () => onChanged(choice.value),
              leading: Icon(
                value == choice.value
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
              ),
              title: Text(choice.label),
              subtitle: Text(choice.description),
            ),
          ),
      ],
    );
  }
}

class _StringListSettingEditor extends StatefulWidget {
  final List<String> values;
  final String label;
  final String hintText;
  final ValueChanged<List<String>> onChanged;

  const _StringListSettingEditor({
    required this.values,
    required this.label,
    required this.hintText,
    required this.onChanged,
  });

  @override
  State<_StringListSettingEditor> createState() =>
      _StringListSettingEditorState();
}

class _StringListSettingEditorState extends State<_StringListSettingEditor> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = [
      for (final value in widget.values) TextEditingController(text: value),
    ];
    if (_controllers.isEmpty) _controllers.add(TextEditingController());
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _emit() {
    widget.onChanged(
      _controllers
          .map((controller) => controller.text.trim())
          .where((value) => value.isNotEmpty)
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < _controllers.length; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controllers[index],
                    decoration: InputDecoration(
                      labelText: '${widget.label} ${index + 1}',
                      hintText: widget.hintText,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => _emit(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  tooltip: '删除',
                  icon: const Icon(Icons.remove_rounded),
                  onPressed: _controllers.length == 1
                      ? null
                      : () {
                          setState(() {
                            _controllers.removeAt(index).dispose();
                          });
                          _emit();
                        },
                ),
              ],
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.add_rounded),
            label: const Text('添加'),
            onPressed: () {
              setState(() => _controllers.add(TextEditingController()));
              _emit();
            },
          ),
        ),
      ],
    );
  }
}

class _PermissionListSettingEditor extends StatelessWidget {
  final Set<String> values;
  final ValueChanged<Set<String>> onChanged;

  const _PermissionListSettingEditor({
    required this.values,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final permission in _knownPermissions)
          FilterChip(
            label: Text(_permissionLabels[permission] ?? permission),
            selected: values.contains(permission),
            onSelected: (selected) {
              final next = {...values};
              if (selected) {
                next.add(permission);
              } else {
                next.remove(permission);
              }
              onChanged(next);
            },
          ),
      ],
    );
  }
}

Map<String, dynamic> _oauth2ProvidersFromValue(dynamic value) {
  if (value is Map) return Map<String, dynamic>.from(value);
  if (value is String && value.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
  }
  return <String, dynamic>{};
}

List<Map<String, dynamic>> _iceServersFromValue(dynamic value) {
  if (value is List) {
    return value
        .whereType<Map>()
        .map((entry) => Map<String, dynamic>.from(entry))
        .toList();
  }
  if (value is String && value.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is List) return _iceServersFromValue(decoded);
    } catch (_) {}
  }
  return <Map<String, dynamic>>[];
}

class _OAuth2ProvidersEditor extends StatelessWidget {
  final Map<String, dynamic> providers;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const _OAuth2ProvidersEditor({
    required this.providers,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final entries = providers.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (entries.isEmpty)
          const _EmptySettingsNotice(
            icon: Icons.account_tree_outlined,
            title: '还没有第三方登录实例',
            message: '添加 GitHub、Google、Logto 或通用 OIDC 实例后，登录页会自动展示对应入口。',
          )
        else
          for (final entry in entries)
            _OAuth2ProviderCard(
              name: entry.key,
              value: entry.value is Map
                  ? Map<String, dynamic>.from(entry.value)
                  : <String, dynamic>{},
              onEdit: () => _editProvider(context, entry.key),
              onDelete: () {
                final next = Map<String, dynamic>.from(providers)
                  ..remove(entry.key);
                onChanged(next);
              },
            ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            icon: const Icon(Icons.add_rounded),
            label: const Text('添加登录提供方'),
            onPressed: () => _editProvider(context, null),
          ),
        ),
      ],
    );
  }

  Future<void> _editProvider(BuildContext context, String? name) async {
    final current = name == null
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(providers[name] as Map? ?? const {});
    final result = await showModalBottomSheet<_OAuth2ProviderEditResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _OAuth2ProviderEditorSheet(
        initialName: name,
        initialValue: current,
        existingNames: providers.keys.toSet(),
      ),
    );
    if (result == null) return;
    final next = Map<String, dynamic>.from(providers);
    if (name != null && name != result.name) next.remove(name);
    next[result.name] = result.value;
    onChanged(next);
  }
}

class _OAuth2ProvidersList extends StatelessWidget {
  final Map<String, dynamic> providers;
  final bool saving;
  final ValueChanged<String> onEdit;
  final ValueChanged<String> onDelete;

  const _OAuth2ProvidersList({
    required this.providers,
    required this.saving,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final entries = providers.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (saving)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: LinearProgressIndicator(),
          ),
        if (entries.isEmpty)
          const _EmptySettingsNotice(
            icon: Icons.account_tree_outlined,
            title: '还没有第三方登录实例',
            message: '点击右上角添加 GitHub、Google、Logto 或通用 OIDC 登录入口。',
          )
        else
          for (final entry in entries)
            _OAuth2ProviderCard(
              name: entry.key,
              value: entry.value is Map
                  ? Map<String, dynamic>.from(entry.value)
                  : <String, dynamic>{},
              onEdit: saving ? null : () => onEdit(entry.key),
              onDelete: saving ? null : () => onDelete(entry.key),
            ),
      ],
    );
  }
}

class _OAuth2ProviderCard extends StatelessWidget {
  final String name;
  final Map<String, dynamic> value;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _OAuth2ProviderCard({
    required this.name,
    required this.value,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final providerType = (value['type'] ?? '').toString();
    final config = value['config'] is Map
        ? Map<String, dynamic>.from(value['config'])
        : const {};
    final hasClientId = (config['client_id'] ?? '').toString().isNotEmpty;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.55)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.login_rounded, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_oauth2ProviderTypeLabels[providerType] ?? providerType} · ${hasClientId ? '已配置客户端' : '未填写 Client ID'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _StatusChip(
                        label:
                            value['enable_signup'] == true ? '允许注册' : '仅登录绑定',
                        icon: value['enable_signup'] == true
                            ? Icons.person_add_alt_1_outlined
                            : Icons.login_rounded,
                      ),
                      if (value['signup_need_review'] == true)
                        const _StatusChip(
                            label: '注册需审核', icon: Icons.fact_check_outlined),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: '编辑',
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit,
            ),
            IconButton(
              tooltip: '删除',
              icon: const Icon(Icons.delete_outline_rounded),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _StatusChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSecondaryContainer),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _OAuth2ProviderEditResult {
  final String name;
  final Map<String, dynamic> value;

  const _OAuth2ProviderEditResult(this.name, this.value);
}

class _OAuth2ProviderEditorSheet extends StatefulWidget {
  final String? initialName;
  final Map<String, dynamic> initialValue;
  final Set<String> existingNames;

  const _OAuth2ProviderEditorSheet({
    required this.initialName,
    required this.initialValue,
    required this.existingNames,
  });

  @override
  State<_OAuth2ProviderEditorSheet> createState() =>
      _OAuth2ProviderEditorSheetState();
}

class _OAuth2ProviderEditorSheetState
    extends State<_OAuth2ProviderEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _clientId;
  late final TextEditingController _clientSecret;
  late final TextEditingController _redirectUrl;
  late final TextEditingController _endpoint;
  late final TextEditingController _issuer;
  late final TextEditingController _authUrl;
  late final TextEditingController _tokenUrl;
  late final TextEditingController _userinfoUrl;
  late final TextEditingController _jwksUrl;
  late String _type;
  late bool _enableSignup;
  late bool _signupNeedReview;
  bool _showSecret = false;

  @override
  void initState() {
    super.initState();
    final config = widget.initialValue['config'] is Map
        ? Map<String, dynamic>.from(widget.initialValue['config'])
        : <String, dynamic>{};
    _type = (widget.initialValue['type'] ?? 'github').toString();
    if (!_oauth2ProviderTypes.contains(_type)) _type = 'oidc';
    _enableSignup = widget.initialValue['enable_signup'] == true;
    _signupNeedReview = widget.initialValue['signup_need_review'] == true;
    _name = TextEditingController(text: widget.initialName ?? _type);
    _clientId =
        TextEditingController(text: (config['client_id'] ?? '').toString());
    _clientSecret =
        TextEditingController(text: (config['client_secret'] ?? '').toString());
    _redirectUrl =
        TextEditingController(text: (config['redirect_url'] ?? '').toString());
    _endpoint =
        TextEditingController(text: (config['endpoint'] ?? '').toString());
    _issuer = TextEditingController(text: (config['issuer'] ?? '').toString());
    _authUrl =
        TextEditingController(text: (config['auth_url'] ?? '').toString());
    _tokenUrl =
        TextEditingController(text: (config['token_url'] ?? '').toString());
    _userinfoUrl =
        TextEditingController(text: (config['userinfo_url'] ?? '').toString());
    _jwksUrl =
        TextEditingController(text: (config['jwks_url'] ?? '').toString());
  }

  @override
  void dispose() {
    _name.dispose();
    _clientId.dispose();
    _clientSecret.dispose();
    _redirectUrl.dispose();
    _endpoint.dispose();
    _issuer.dispose();
    _authUrl.dispose();
    _tokenUrl.dispose();
    _userinfoUrl.dispose();
    _jwksUrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720, maxHeight: 760),
          child: Material(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            clipBehavior: Clip.antiAlias,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 12, 10),
                    child: Row(
                      children: [
                        const Icon(Icons.login_rounded),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.initialName == null ? '添加第三方登录' : '编辑第三方登录',
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        IconButton(
                          tooltip: '关闭',
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _name,
                            decoration: const InputDecoration(
                              labelText: '实例名称',
                              helperText: '只能使用字母、数字、下划线和连字符',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.badge_outlined),
                            ),
                            validator: _validateProviderName,
                          ),
                          const SizedBox(height: 12),
                          DropdownButtonFormField<String>(
                            initialValue: _type,
                            decoration: const InputDecoration(
                              labelText: '提供方类型',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.account_tree_outlined),
                            ),
                            items: [
                              for (final type in _oauth2ProviderTypes)
                                DropdownMenuItem(
                                  value: type,
                                  child: Text(
                                      _oauth2ProviderTypeLabels[type] ?? type),
                                ),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                _type = value;
                                if (widget.initialName == null &&
                                    (_name.text.trim().isEmpty ||
                                        _oauth2ProviderTypes
                                            .contains(_name.text.trim()))) {
                                  _name.text = value;
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          _oauthTextField(
                              _clientId, 'Client ID', Icons.key_outlined,
                              required: true),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _clientSecret,
                            obscureText: !_showSecret,
                            decoration: InputDecoration(
                              labelText: 'Client Secret',
                              border: const OutlineInputBorder(),
                              prefixIcon: const Icon(Icons.password_outlined),
                              suffixIcon: IconButton(
                                tooltip: _showSecret ? '隐藏' : '显示',
                                icon: Icon(_showSecret
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined),
                                onPressed: () =>
                                    setState(() => _showSecret = !_showSecret),
                              ),
                            ),
                            validator: (value) =>
                                (value == null || value.trim().isEmpty)
                                    ? '请输入 Client Secret'
                                    : null,
                          ),
                          const SizedBox(height: 12),
                          _oauthTextField(
                            _redirectUrl,
                            '回调地址',
                            Icons.link_rounded,
                            required: true,
                            hintText: 'https://example.com/api/oauth2/callback',
                            validator: _validateHttpUrl,
                          ),
                          if (_type == 'logto') ...[
                            const SizedBox(height: 12),
                            _oauthTextField(
                              _endpoint,
                              'Logto Endpoint',
                              Icons.hub_outlined,
                              required: true,
                              hintText: 'https://auth.example.com',
                              validator: _validateHttpUrl,
                            ),
                          ],
                          if (_type == 'oidc') ...[
                            const SizedBox(height: 12),
                            _oauthTextField(
                              _issuer,
                              'Issuer',
                              Icons.verified_outlined,
                              required: true,
                              hintText: 'https://issuer.example.com',
                              validator: _validateHttpUrl,
                            ),
                            const SizedBox(height: 12),
                            _oauthTextField(
                                _authUrl, '授权端点', Icons.open_in_browser_rounded,
                                hintText: '留空使用 OIDC Discovery',
                                validator: _validateOptionalHttpUrl),
                            const SizedBox(height: 12),
                            _oauthTextField(
                                _tokenUrl, 'Token 端点', Icons.token_outlined,
                                hintText: '留空使用 OIDC Discovery',
                                validator: _validateOptionalHttpUrl),
                            const SizedBox(height: 12),
                            _oauthTextField(_userinfoUrl, 'UserInfo 端点',
                                Icons.person_search_outlined,
                                hintText: '留空使用 OIDC Discovery',
                                validator: _validateOptionalHttpUrl),
                            const SizedBox(height: 12),
                            _oauthTextField(
                                _jwksUrl, 'JWKS 端点', Icons.security_rounded,
                                hintText: '留空使用 OIDC Discovery',
                                validator: _validateOptionalHttpUrl),
                          ],
                          const SizedBox(height: 8),
                          SwitchListTile(
                            value: _enableSignup,
                            onChanged: (value) =>
                                setState(() => _enableSignup = value),
                            title: const Text('允许用此提供方注册'),
                            subtitle: const Text('关闭后只允许绑定过的用户登录。'),
                          ),
                          SwitchListTile(
                            value: _signupNeedReview,
                            onChanged: _enableSignup
                                ? (value) =>
                                    setState(() => _signupNeedReview = value)
                                : null,
                            title: const Text('注册后需要审核'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('取消'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton.icon(
                              icon: const Icon(Icons.check_rounded),
                              label: const Text('保存实例'),
                              onPressed: _save,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _oauthTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool required = false,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: validator ??
          (required
              ? (value) =>
                  (value == null || value.trim().isEmpty) ? '请输入 $label' : null
              : null),
    );
  }

  String? _validateProviderName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return '请输入实例名称';
    if (name.length > 64) return '实例名称不能超过 64 个字符';
    if (!RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(name)) return '只能使用字母、数字、下划线和连字符';
    if (name != widget.initialName && widget.existingNames.contains(name)) {
      return '实例名称已存在';
    }
    return null;
  }

  String? _validateHttpUrl(String? value) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) return '请输入 URL';
    final uri = Uri.tryParse(raw);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) return '请输入有效 URL';
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return '只允许 http 或 https 地址';
    }
    return null;
  }

  String? _validateOptionalHttpUrl(String? value) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) return null;
    return _validateHttpUrl(raw);
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final config = <String, dynamic>{
      'client_id': _clientId.text.trim(),
      'client_secret': _clientSecret.text,
      'redirect_url': _redirectUrl.text.trim(),
    };
    if (_type == 'logto') {
      config['endpoint'] = _endpoint.text.trim();
    }
    if (_type == 'oidc') {
      config['issuer'] = _issuer.text.trim();
      for (final entry in {
        'auth_url': _authUrl.text.trim(),
        'token_url': _tokenUrl.text.trim(),
        'userinfo_url': _userinfoUrl.text.trim(),
        'jwks_url': _jwksUrl.text.trim(),
      }.entries) {
        if (entry.value.isNotEmpty) config[entry.key] = entry.value;
      }
    }
    Navigator.pop(
      context,
      _OAuth2ProviderEditResult(
        _name.text.trim(),
        {
          'type': _type,
          'enable_signup': _enableSignup,
          'signup_need_review': _enableSignup && _signupNeedReview,
          'config': config,
        },
      ),
    );
  }
}

class _IceServersEditor extends StatelessWidget {
  final List<Map<String, dynamic>> servers;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;

  const _IceServersEditor({
    required this.servers,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (servers.isEmpty)
          const _EmptySettingsNotice(
            icon: Icons.settings_input_antenna_rounded,
            title: '未配置 ICE 服务器',
            message: '添加 STUN 或 TURN 服务器后，客户端会优先使用这里的连接配置。',
          )
        else
          for (var index = 0; index < servers.length; index++)
            _IceServerCard(
              index: index,
              value: servers[index],
              onChanged: (value) {
                final next = [...servers];
                next[index] = value;
                onChanged(next);
              },
              onDelete: () {
                final next = [...servers]..removeAt(index);
                onChanged(next);
              },
            ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            icon: const Icon(Icons.add_rounded),
            label: const Text('添加 ICE 服务器'),
            onPressed: () {
              onChanged([
                ...servers,
                {
                  'urls': ['stun:stun.l.google.com:19302'],
                },
              ]);
            },
          ),
        ),
      ],
    );
  }
}

class _IceServerCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> value;
  final ValueChanged<Map<String, dynamic>> onChanged;
  final VoidCallback onDelete;

  const _IceServerCard({
    required this.index,
    required this.value,
    required this.onChanged,
    required this.onDelete,
  });

  @override
  State<_IceServerCard> createState() => _IceServerCardState();
}

class _IceServerCardState extends State<_IceServerCard> {
  late final TextEditingController _urls;
  late final TextEditingController _username;
  late final TextEditingController _credential;
  bool _showCredential = false;

  @override
  void initState() {
    super.initState();
    final urls = widget.value['urls'];
    _urls = TextEditingController(
      text: urls is List ? urls.map((item) => item.toString()).join('\n') : '',
    );
    _username = TextEditingController(
        text: (widget.value['username'] ?? '').toString());
    _credential = TextEditingController(
        text: (widget.value['credential'] ?? '').toString());
  }

  @override
  void dispose() {
    _urls.dispose();
    _username.dispose();
    _credential.dispose();
    super.dispose();
  }

  void _emit() {
    final next = <String, dynamic>{
      'urls': _urls.text
          .split(RegExp(r'[\n,]'))
          .map((url) => url.trim())
          .where((url) => url.isNotEmpty)
          .toList(),
    };
    if (_username.text.trim().isNotEmpty) {
      next['username'] = _username.text.trim();
    }
    if (_credential.text.isNotEmpty) next['credential'] = _credential.text;
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.55)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'ICE 服务器 ${widget.index + 1}',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                IconButton(
                  tooltip: '删除',
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
            TextFormField(
              controller: _urls,
              minLines: 1,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'URL',
                helperText: '每行一个，例如 stun:host:3478 或 turns:host:5349',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link_rounded),
              ),
              onChanged: (_) => _emit(),
              validator: (value) {
                final urls = value
                        ?.split(RegExp(r'[\n,]'))
                        .map((url) => url.trim())
                        .where((url) => url.isNotEmpty)
                        .toList() ??
                    const [];
                if (urls.isEmpty) return '至少填写一个 URL';
                final invalid = urls.where((url) => !(url.startsWith('stun:') ||
                    url.startsWith('turn:') ||
                    url.startsWith('turns:')));
                return invalid.isNotEmpty ? '只支持 stun:/turn:/turns: URL' : null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _username,
              decoration: const InputDecoration(
                labelText: '用户名',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              onChanged: (_) => _emit(),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _credential,
              obscureText: !_showCredential,
              decoration: InputDecoration(
                labelText: '凭据',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.password_outlined),
                suffixIcon: IconButton(
                  tooltip: _showCredential ? '隐藏' : '显示',
                  icon: Icon(
                    _showCredential
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () =>
                      setState(() => _showCredential = !_showCredential),
                ),
              ),
              onChanged: (_) => _emit(),
            ),
          ],
        ),
      ),
    );
  }
}

class _StructuredValueEditor extends StatelessWidget {
  final Map<String, dynamic> value;
  final ValueChanged<Map<String, dynamic>> onChanged;

  const _StructuredValueEditor({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final entries = value.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Column(
      children: [
        for (final entry in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _DynamicValueField(
              name: entry.key,
              value: entry.value,
              onChanged: (nextValue) {
                final next = Map<String, dynamic>.from(value);
                next[entry.key] = nextValue;
                onChanged(next);
              },
            ),
          ),
      ],
    );
  }
}

class _DynamicValueField extends StatefulWidget {
  final String name;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  const _DynamicValueField({
    required this.name,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_DynamicValueField> createState() => _DynamicValueFieldState();
}

class _DynamicValueFieldState extends State<_DynamicValueField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value?.toString() ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.value;
    if (value is bool) {
      return SwitchListTile(
        value: value,
        onChanged: widget.onChanged,
        title: Text(_humanizeSettingKey(widget.name)),
      );
    }
    return TextFormField(
      controller: _controller,
      obscureText: _isSecretKey(widget.name),
      keyboardType: value is num ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: _humanizeSettingKey(widget.name),
        border: const OutlineInputBorder(),
      ),
      onChanged: (raw) {
        if (value is int) {
          widget.onChanged(int.tryParse(raw) ?? value);
        } else if (value is double || value is num) {
          widget.onChanged(num.tryParse(raw) ?? value);
        } else {
          widget.onChanged(raw);
        }
      },
    );
  }
}

class _EmptySettingsNotice extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptySettingsNotice({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.55)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: theme.colorScheme.primary),
          const SizedBox(height: 10),
          Text(title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
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
