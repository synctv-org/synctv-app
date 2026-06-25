import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/models/account_models.dart';
import 'package:synctv_app/models/room_management_models.dart';
import 'package:synctv_app/models/synctv_models.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/providers/common.pbenum.dart'
    as provider_common_enum;
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/utils/chat_reactions.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/utils/room_taxonomy.dart';
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';

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

class _AdminToolbarItem {
  final Widget child;
  final double width;

  const _AdminToolbarItem({
    required this.child,
    required this.width,
  });
}

class _AdminToolbarWrap extends StatelessWidget {
  final List<_AdminToolbarItem> items;

  const _AdminToolbarWrap({required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fallbackWidth = MediaQuery.sizeOf(context).width - 32;
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : math.max(280.0, fallbackWidth);

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final item in items)
              SizedBox(
                width: math.min(item.width, availableWidth),
                child: item.child,
              ),
          ],
        );
      },
    );
  }
}

void _disposeControllersAfterRouteClose(
  BuildContext context,
  List<TextEditingController> controllers,
) {
  final route = ModalRoute.of(context);
  if (route?.completed case final completed?) {
    completed.whenComplete(() {
      for (final controller in controllers) {
        controller.dispose();
      }
    });
    return;
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    for (final controller in controllers) {
      controller.dispose();
    }
  });
}

Future<void> _openContentReportsViewer(
  BuildContext context, {
  required String title,
  int targetType = 0,
  String reporterUserId = '',
  String roomId = '',
  String targetRoomId = '',
  String targetUserId = '',
  String targetMemberRoomId = '',
  String targetMemberUserId = '',
  int targetChatMessageId = 0,
  int scope = 0,
  String search = '',
}) {
  return ChatUtils.showStyledDialog<void>(
    context: context,
    title: title,
    icon: const Icon(Icons.report_gmailerrorred_rounded, color: Colors.red),
    content: SizedBox(
      width: 900,
      height: 620,
      child: AdminContentReportsTab(
        title: '',
        initialTargetType: targetType,
        initialReporterUserId: reporterUserId,
        initialRoomId: roomId,
        initialTargetRoomId: targetRoomId,
        initialTargetUserId: targetUserId,
        initialTargetMemberRoomId: targetMemberRoomId,
        initialTargetMemberUserId: targetMemberUserId,
        initialTargetChatMessageId: targetChatMessageId,
        initialScope: scope,
        initialSearch: search,
        showTargetTypeTabs: targetType == 0,
      ),
    ),
    actions: [_closeButton(context)],
  );
}

const Map<String, String> _providerTypeLabels = {
  'direct_url': 'Direct URL',
  'alist': 'AList',
  'emby': 'Emby',
  'bilibili': 'Bilibili',
  'rtmp': 'RTMP',
  'live_proxy': 'Live Proxy',
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
  int _selectedSectionIndex = 0;
  final Set<int> _builtSectionIndexes = <int>{0};
  static const List<_AdminSection> _sections = [
    _AdminSection(
      label: '总览',
      icon: Icons.dashboard_rounded,
      page: AdminOverviewTab(),
    ),
    _AdminSection(
      label: '管理员',
      icon: Icons.admin_panel_settings_rounded,
      page: AdminAdminsTab(),
    ),
    _AdminSection(
      label: '房间',
      icon: Icons.meeting_room_rounded,
      page: RoomManagementTab(),
    ),
    _AdminSection(
      label: '分类标签',
      icon: Icons.category_rounded,
      page: AdminRoomTaxonomyTab(),
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
      label: '举报',
      icon: Icons.report_gmailerrorred_rounded,
      page: AdminContentReportsTab(),
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
    _tabController.addListener(_handleTabControllerChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabControllerChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabControllerChanged() {
    final nextIndex = _tabController.index;
    if (nextIndex == _selectedSectionIndex || !mounted) return;
    setState(() {
      _selectedSectionIndex = nextIndex;
      _builtSectionIndexes.add(nextIndex);
    });
  }

  void _selectSection(int index, {bool syncController = true}) {
    if (index < 0 || index >= _sections.length) return;

    if (index != _selectedSectionIndex ||
        !_builtSectionIndexes.contains(index)) {
      setState(() {
        _selectedSectionIndex = index;
        _builtSectionIndexes.add(index);
      });
    }

    if (syncController && _tabController.index != index) {
      _tabController.animateTo(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final systemUiOverlayStyle =
        isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: AppScaffold(
        backgroundColor:
            isDark ? const Color(0xFF121212) : const Color(0xFFF7F7FC),
        appBar: AppAppBar(
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
                AppVerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: theme.dividerColor.withValues(alpha: 0.55),
                ),
                Expanded(
                  child: AppPanelSurface(
                    color: isDark
                        ? const Color(0xFF151518)
                        : const Color(0xFFF3F5F8),
                    borderRadius: BorderRadius.zero,
                    clipBehavior: Clip.none,
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
    return IndexedStack(
      index: _selectedSectionIndex,
      children: List.generate(_sections.length, (index) {
        if (!_builtSectionIndexes.contains(index)) {
          return const SizedBox.shrink();
        }

        final section = _sections[index];
        return KeyedSubtree(
          key: PageStorageKey<String>('admin_section_${section.label}'),
          child: section.page,
        );
      }),
    );
  }

  Widget _buildSideNavigation(ThemeData theme, bool isDark) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        return SizedBox(
          width: 232,
          child: AppInkSurface(
            color: isDark ? const Color(0xFF101012) : Colors.white,
            clipBehavior: Clip.none,
            child: AppSafeArea(
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
                      child: AppListView.separated(
                        itemCount: _sections.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          final section = _sections[index];
                          final selected = _selectedSectionIndex == index;
                          return _SettingsNavTile(
                            icon: section.icon,
                            label: section.label,
                            selected: selected,
                            onTap: () => _selectSection(index),
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 640;
        return AppInkSurface(
          color: theme.colorScheme.surface,
          elevation: 0,
          clipBehavior: Clip.none,
          child: AppSafeArea(
            bottom: false,
            child: AppPanelSurface(
              borderRadius: BorderRadius.zero,
              clipBehavior: Clip.none,
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor.withValues(alpha: 0.65),
                ),
              ),
              padding: compact
                  ? const EdgeInsets.fromLTRB(10, 6, 10, 8)
                  : const EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: compact
                  ? _buildCompactTopTabs(theme)
                  : AppTabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      onTap: (index) =>
                          _selectSection(index, syncController: false),
                      dividerColor: Colors.transparent,
                      indicator: appTabPillIndicator(
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.10),
                      ),
                      labelColor: theme.colorScheme.primary,
                      unselectedLabelColor:
                          theme.colorScheme.onSurface.withValues(alpha: 0.62),
                      labelStyle: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: theme.textTheme.labelMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                      tabs: _sections
                          .map((section) => Tab(
                                height: 42,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
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
      },
    );
  }

  Widget _buildCompactTopTabs(ThemeData theme) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        return AppGridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisExtent: 42,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
          ),
          itemCount: _sections.length,
          itemBuilder: (context, index) {
            final section = _sections[index];
            final selected = _selectedSectionIndex == index;
            final foreground = selected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.68);
            return AppInkSurface(
              color: selected
                  ? theme.colorScheme.primary.withValues(alpha: 0.12)
                  : theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.42),
              borderRadius: BorderRadius.circular(8),
              onTap: () => _selectSection(index),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(section.icon, size: 16, color: foreground),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      section.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: foreground,
                        fontWeight:
                            selected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
    return AppInkSurface(
      color: selected
          ? theme.colorScheme.primary.withValues(alpha: 0.10)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final stats = await SyncTvService.adminGetSystemStats();
      if (!mounted) return;
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      MessageUtils.showError(context, '加载总览失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stats = _stats;
    if (_isLoading) return const AppLoadingIndicator();

    return AppRefreshIndicator(
      onRefresh: () => _load(silent: true),
      child: AppListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (stats == null)
            const AppEmptyMessage(message: '暂无统计数据')
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _StatTile('用户', stats.totalUsers, Icons.people_alt_rounded,
                    Colors.blue, isDark),
                _StatTile('活跃用户', stats.activeUsers,
                    Icons.person_pin_circle_rounded, Colors.green, isDark),
                _StatTile('在线用户', stats.onlineUsers,
                    Icons.online_prediction_rounded, Colors.lightGreen, isDark),
                _StatTile('在线连接', stats.onlineConnections, Icons.link_rounded,
                    Colors.cyan, isDark),
                _StatTile('封禁用户', stats.bannedUsers, Icons.block_rounded,
                    Colors.red, isDark),
                _StatTile('房间', stats.totalRooms, Icons.meeting_room_rounded,
                    Colors.indigo, isDark),
                _StatTile('活跃房间', stats.activeRooms, Icons.sensors_rounded,
                    Colors.teal, isDark),
                _StatTile('在线房间', stats.activePresenceRooms,
                    Icons.wifi_tethering_rounded, Colors.blueGrey, isDark),
                _StatTile('媒体', stats.totalMedia, Icons.video_library_rounded,
                    Colors.deepPurple, isDark),
                _StatTile('Provider', stats.providerInstances,
                    Icons.hub_rounded, Colors.orange, isDark),
              ],
            ),
        ],
      ),
    );
  }
}

class AdminAdminsTab extends StatefulWidget {
  const AdminAdminsTab({super.key});

  @override
  State<AdminAdminsTab> createState() => _AdminAdminsTabState();
}

class _AdminAdminsTabState extends State<AdminAdminsTab> {
  List<SyncTvUser> _admins = const [];
  String _currentUserId = '';
  int _adminTotal = 0;
  int _adminPage = 1;
  int _adminPageSize = 20;
  String _adminSearch = '';
  admin_enum.UserListSortBy _adminSortBy =
      admin_enum.UserListSortBy.USER_LIST_SORT_BY_CREATED_AT;
  admin_enum.SortDirection _adminSortDirection =
      admin_enum.SortDirection.SORT_DIRECTION_DESC;
  bool _isLoading = true;
  final _adminSearchController = TextEditingController();

  int get _adminPageCount =>
      _adminTotal <= 0 ? 1 : ((_adminTotal - 1) ~/ _adminPageSize) + 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _adminSearchController.dispose();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        SyncTvService.adminListAdminsPage(
          page: _adminPage,
          pageSize: _adminPageSize,
          search: _adminSearch,
          sortBy: _adminSortBy,
          sortDirection: _adminSortDirection,
        ),
        SyncTvService.getMe(),
      ]);
      if (!mounted) return;
      final adminsPage = results[0] as AdminsPage;
      final currentUser = results[1] as SyncTvUser;
      setState(() {
        _admins = adminsPage.admins;
        _currentUserId = currentUser.id;
        _adminTotal = adminsPage.total;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      MessageUtils.showError(context, '加载管理员失败: $e');
    }
  }

  Future<void> _addAdmin() async {
    final mode = await ChatUtils.showStyledDialog<String>(
      context: context,
      title: '添加管理员',
      icon: const Icon(Icons.admin_panel_settings_rounded,
          color: Color(0xFF5D5FEF)),
      content: const SizedBox(
        width: 420,
        child: Text('可以创建新的管理员账号，也可以把已有用户提升为管理员。'),
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        AppActionButton(
          onPressed: () => Navigator.pop(context, 'existing'),
          icon: Icons.person_search_rounded,
          label: '提升已有用户',
          style: AppActionButtonStyle.tonal,
        ),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, 'new'),
          text: '新建管理员',
        ),
      ],
    );
    if (mode == 'existing') {
      await _promoteExistingUser();
      return;
    }
    if (mode != 'new') return;
    if (!mounted) return;

    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    var disposeScheduled = false;
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '添加管理员',
      icon: const Icon(Icons.admin_panel_settings_rounded,
          color: Color(0xFF5D5FEF)),
      content: Builder(
        builder: (dialogContext) {
          if (!disposeScheduled) {
            disposeScheduled = true;
            _disposeControllersAfterRouteClose(dialogContext, [
              usernameController,
              passwordController,
            ]);
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ChatUtils.createFormField(
                context: dialogContext,
                label: '用户名',
                controller: usernameController,
                hintText: '请输入用户名',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              ChatUtils.createFormField(
                context: dialogContext,
                label: '密码',
                controller: passwordController,
                hintText: '请输入密码',
                prefixIcon: Icons.lock_outline,
                obscureText: true,
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
      final username = usernameController.text.trim();
      final password = passwordController.text;
      if (username.isEmpty || password.isEmpty) {
        if (!mounted) return;
        MessageUtils.showWarning(context, '请填写用户名和密码');
        return;
      }
      await SyncTvService.adminAddUser(
        username,
        password,
        common_enum.UserRole.USER_ROLE_ADMIN.value,
      );
      if (!mounted) return;
      MessageUtils.showSuccess(context, '管理员已添加');
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '添加失败: $e');
    }
  }

  Future<void> _promoteExistingUser() async {
    final userIdController = TextEditingController();
    var disposeScheduled = false;
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '提升已有用户',
      icon: const Icon(Icons.person_search_rounded, color: Color(0xFF5D5FEF)),
      content: Builder(
        builder: (dialogContext) {
          if (!disposeScheduled) {
            disposeScheduled = true;
            _disposeControllersAfterRouteClose(dialogContext, [
              userIdController,
            ]);
          }
          return SizedBox(
            width: 420,
            child: ChatUtils.createFormField(
              context: dialogContext,
              label: '用户 ID',
              controller: userIdController,
              hintText: '请输入已有用户 ID',
              prefixIcon: Icons.badge_outlined,
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
          text: '提升',
        ),
      ],
    );
    if (confirmed != true) return;
    final userId = userIdController.text.trim();
    if (userId.isEmpty) {
      if (!mounted) return;
      MessageUtils.showWarning(context, '请填写用户 ID');
      return;
    }
    try {
      await SyncTvService.adminAddAdmin(userId);
      if (!mounted) return;
      MessageUtils.showSuccess(context, '管理员已添加');
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '添加失败: $e');
    }
  }

  Future<void> _removeAdmin(SyncTvUser user) async {
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
      await SyncTvService.adminRemoveAdmin(user.id);
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
    if (_isLoading) return const AppLoadingIndicator();

    return AppRefreshIndicator(
      onRefresh: () => _load(silent: true),
      child: AppListView(
        padding: const EdgeInsets.all(16),
        children: [
          _AdminPanelCard(
            isDark: isDark,
            child: Column(
              children: [
                AppTile(
                  title: const Text('管理员'),
                  subtitle: Text('共 $_adminTotal 个管理员账号'),
                  suffix: AppIconButton(
                    tooltip: '添加管理员',
                    icon: Icons.add_moderator_outlined,
                    onPressed: _addAdmin,
                  ),
                ),
                AppDivider(
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
                        child: AppSearchField(
                          controller: _adminSearchController,
                          hintText: '搜索管理员',
                          onChanged: (value) {
                            if (value.isEmpty && _adminSearch.isNotEmpty) {
                              setState(() {
                                _adminSearch = '';
                                _adminPage = 1;
                              });
                              _load(silent: true);
                            }
                          },
                          onSubmitted: (value) {
                            setState(() {
                              _adminSearch = value.trim();
                              _adminPage = 1;
                            });
                            _load(silent: true);
                          },
                        ),
                      ),
                      AppSelect<admin_enum.UserListSortBy>(
                        value: _adminSortBy,
                        options: const {
                          '创建时间': admin_enum
                              .UserListSortBy.USER_LIST_SORT_BY_CREATED_AT,
                          '更新时间': admin_enum
                              .UserListSortBy.USER_LIST_SORT_BY_UPDATED_AT,
                          '用户名': admin_enum
                              .UserListSortBy.USER_LIST_SORT_BY_USERNAME,
                          '邮箱':
                              admin_enum.UserListSortBy.USER_LIST_SORT_BY_EMAIL,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _adminSortBy = value;
                            _adminPage = 1;
                          });
                          _load(silent: true);
                        },
                      ),
                      AppIconButton(
                        tooltip: _adminSortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? '降序'
                            : '升序',
                        icon: _adminSortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? Icons.south_rounded
                            : Icons.north_rounded,
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
                      AppSelect<int>(
                        value: _adminPageSize,
                        options: const {
                          '20 / 页': 20,
                          '50 / 页': 50,
                          '100 / 页': 100,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _adminPageSize = value;
                            _adminPage = 1;
                          });
                          _load(silent: true);
                        },
                      ),
                      AppIconButton(
                        tooltip: '刷新',
                        icon: Icons.refresh_rounded,
                        onPressed: () => _load(silent: true),
                      ),
                    ],
                  ),
                ),
                if (_admins.isEmpty)
                  const AppEmptyMessage(message: '暂无管理员')
                else
                  for (final admin in _admins)
                    Builder(
                      builder: (context) {
                        final removeDisabledReason =
                            _adminRemoveDisabledReason(admin);
                        return AppTile(
                          prefix: AppAvatar(name: admin.username),
                          title: Text(admin.username),
                          subtitle: Text(admin.id),
                          suffix: AppIconButton(
                            tooltip: removeDisabledReason ?? '移除管理员',
                            icon: Icons.remove_circle_outline,
                            style: removeDisabledReason == null
                                ? AppIconButtonStyle.destructive
                                : AppIconButtonStyle.ghost,
                            onPressed: removeDisabledReason == null
                                ? () => _removeAdmin(admin)
                                : null,
                          ),
                        );
                      },
                    ),
                AppPaginationBar(
                  label: '第 $_adminPage / $_adminPageCount 页',
                  onPrevious: _adminPage <= 1
                      ? null
                      : () {
                          setState(() => _adminPage -= 1);
                          _load(silent: true);
                        },
                  onNext: _adminPage >= _adminPageCount
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
    );
  }

  String? _adminRemoveDisabledReason(SyncTvUser admin) {
    if (_currentUserId.isNotEmpty && admin.id == _currentUserId) {
      return '不能移除当前登录账号的管理员权限';
    }
    if (_adminTotal <= 1) {
      return '至少保留一个管理员账号';
    }
    return null;
  }
}

class RoomManagementTab extends StatefulWidget {
  const RoomManagementTab({super.key});

  @override
  State<RoomManagementTab> createState() => _RoomManagementTabState();
}

class _RoomManagementTabState extends State<RoomManagementTab> {
  List<SyncTvRoom> _rooms = [];
  List<RoomCategoryInfo> _categories = const [];
  List<RoomLabelInfo> _labels = const [];
  bool _isLoading = true;
  bool _isLoadingTaxonomy = false;
  int _page = 1;
  int _pageSize = 20;
  int _total = 0;
  String _searchQuery = '';
  String _categoryFilter = '';
  final Set<String> _labelFilters = {};
  common_enum.RoomStatus _statusFilter =
      common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED;
  bool? _bannedFilter;
  admin_enum.RoomListSortBy _sortBy =
      admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_CREATED_AT;
  admin_enum.SortDirection _sortDirection =
      admin_enum.SortDirection.SORT_DIRECTION_DESC;
  final Set<String> _selectedRoomIds = {};
  final _searchController = TextEditingController();

  int get _pageCount =>
      _total <= 0 ? 1 : ((_total + _pageSize - 1) ~/ _pageSize);

  @override
  void initState() {
    super.initState();
    _loadTaxonomy();
    _loadRooms();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRooms({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final data = await SyncTvService.adminListRoomsPage(
        page: _page,
        pageSize: _pageSize,
        search: _searchQuery,
        categoryId: _categoryFilter,
        labelIds: _labelFilters.toList(growable: false),
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

  Future<void> _loadTaxonomy() async {
    if (_isLoadingTaxonomy) return;
    setState(() => _isLoadingTaxonomy = true);
    try {
      final results = await Future.wait([
        SyncTvService.adminListRoomCategories(
          includeDisabled: true,
          refresh: true,
        ),
        SyncTvService.adminListRoomLabels(
          includeDisabled: true,
          refresh: true,
        ),
      ]);
      if (!mounted) return;
      final categories = results[0].cast<RoomCategoryInfo>().toList()
        ..sort((a, b) {
          final order = a.sortOrder.compareTo(b.sortOrder);
          if (order != 0) return order;
          return _roomCategoryDisplay(a).compareTo(_roomCategoryDisplay(b));
        });
      final labels = results[1].cast<RoomLabelInfo>().toList()
        ..sort((a, b) {
          final order = a.sortOrder.compareTo(b.sortOrder);
          if (order != 0) return order;
          return _roomLabelDisplay(a).compareTo(_roomLabelDisplay(b));
        });
      setState(() {
        _categories = categories;
        _labels = labels;
        _labelFilters.removeWhere(
          (id) => !_availableFilterLabels.any((label) => label.id == id),
        );
        _isLoadingTaxonomy = false;
      });
    } catch (e) {
      debugPrint('Failed to load admin room taxonomy filters: $e');
      if (!mounted) return;
      setState(() => _isLoadingTaxonomy = false);
    }
  }

  List<RoomLabelInfo> get _availableFilterLabels {
    if (_categoryFilter.isEmpty) return _labels;
    return _labels
        .where((label) => label.categoryId == _categoryFilter)
        .toList(growable: false);
  }

  Future<void> _showRoomLabelFilterDialog() async {
    if (_labels.isEmpty) {
      await _loadTaxonomy();
    }
    if (!mounted) return;
    final selectedIds = Set<String>.from(_labelFilters);
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '筛选标签',
      icon: const Icon(Icons.sell_outlined, color: Color(0xFF5D5FEF)),
      content: StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          final theme = Theme.of(dialogContext);
          final labels = _availableFilterLabels;
          return SizedBox(
            width: 520,
            child: AppSingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (labels.isEmpty)
                    Text(
                      _categoryFilter.isEmpty ? '暂无可用标签' : '当前分类下暂无标签',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: labels.map((label) {
                        final selected = selectedIds.contains(label.id);
                        final color = parseRoomLabelColor(
                          label.color,
                          theme.colorScheme.primary,
                        );
                        return AppChip(
                          selected: selected,
                          style: selected
                              ? AppChipStyle.filled
                              : AppChipStyle.outlined,
                          onSelected: (value) => setDialogState(() {
                            if (value) {
                              selectedIds.add(label.id);
                            } else {
                              selectedIds.remove(label.id);
                            }
                          }),
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(_roomLabelDisplay(label)),
                            ],
                          ),
                        );
                      }).toList(growable: false),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        AppActionButton(
          onPressed: () => Navigator.pop(context, false),
          icon: Icons.filter_alt_off_rounded,
          label: '清空',
          style: AppActionButtonStyle.tonal,
        ),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: '应用',
        ),
      ],
    );
    if (confirmed == null) return;
    setState(() {
      _labelFilters
        ..clear()
        ..addAll(confirmed ? selectedIds : const <String>{});
      _page = 1;
    });
    _loadRooms();
  }

  Future<void> _banRoom(SyncTvRoom room, bool ban) async {
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
        await SyncTvService.adminBanRoom(
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

  Future<void> _deleteRoom(SyncTvRoom room) async {
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '删除房间',
      icon: const Icon(Icons.delete_forever, color: Colors.red),
      content: _destructiveDialogContent(
        '将永久删除房间 "${room.roomName}"。',
        const [
          '所有成员会立即失去访问权限。',
          '房间设置、成员关系、播放列表、聊天记录和实时状态会同步清除。',
          '正在观看的成员会收到房间数据变更并退出当前协作流程。',
        ],
      ),
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
        await SyncTvService.adminDeleteRoom(room.roomId);
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
      final result = await SyncTvService.adminBatchBanRooms(
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
      content: _destructiveDialogContent(
        '将永久删除 ${_selectedRoomIds.length} 个房间。',
        const [
          '相关成员会立即失去访问权限。',
          '房间设置、成员关系、播放列表、聊天记录和实时状态会同步清除。',
          '批量操作完成后只能通过备份恢复数据。',
        ],
      ),
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
      final result = await SyncTvService.adminBatchDeleteRooms(
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

  Widget _destructiveDialogContent(String title, List<String> impacts) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...impacts.map(
          (impact) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 16,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    impact,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showRoomDetails(SyncTvRoom room) async {
    try {
      final detail = await SyncTvService.adminGetRoom(room.roomId);
      if (!mounted) return;
      final passwordController = TextEditingController();
      var passwordAction = _RoomPasswordAction.keep;
      await ChatUtils.showStyledDialog(
        context: context,
        title: '房间信息',
        icon: const Icon(Icons.meeting_room_rounded, color: Color(0xFF5D5FEF)),
        content: StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return SizedBox(
              width: 560,
              child: AppSingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _RoomCoverPreview(room: detail),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detail.roomName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                detail.roomId,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        AppAvatar(
                          name: detail.creator,
                          imageUrl: detail.creatorAvatarUrl,
                          radius: 14,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _InfoLine(
                            '创建者',
                            '${detail.creator} (${detail.creatorId})',
                          ),
                        ),
                      ],
                    ),
                    if (detail.description.isNotEmpty)
                      _InfoLine('描述', detail.description),
                    if (detail.category != null)
                      _InfoLine('分类', _roomCategoryDisplay(detail.category!)),
                    if (detail.labels.isNotEmpty)
                      _InfoLine(
                        '标签',
                        detail.labels.map(_roomLabelDisplay).join('、'),
                      ),
                    _InfoLine('成员数', detail.memberCount.toString()),
                    _InfoLine('状态', _roomStatusLabel(detail)),
                    _InfoLine('创建者状态', _userStatusText(detail.creatorStatus)),
                    _InfoLine(
                      '资源可用性',
                      _resourceAvailabilityText(detail.availability),
                    ),
                    _InfoLine('创建时间', _formatTimestamp(detail.createdAt)),
                    _InfoLine('更新时间', _formatTimestamp(detail.updatedAt)),
                    if (detail.version > 0)
                      _InfoLine('版本', detail.version.toString()),
                    const SizedBox(height: 16),
                    AppDivider(
                      color: Theme.of(context)
                          .dividerColor
                          .withValues(alpha: 0.65),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '房间密码',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 8),
                    AppSelect<_RoomPasswordAction>(
                      value: passwordAction,
                      label: '密码操作',
                      options: const {
                        '保持不变': _RoomPasswordAction.keep,
                        '设置新密码': _RoomPasswordAction.update,
                        '清除密码': _RoomPasswordAction.clear,
                      },
                      onChanged: (value) => setDialogState(() {
                        passwordAction = value ?? _RoomPasswordAction.keep;
                        if (passwordAction != _RoomPasswordAction.update) {
                          passwordController.clear();
                        }
                      }),
                    ),
                    if (passwordAction == _RoomPasswordAction.update) ...[
                      const SizedBox(height: 12),
                      ChatUtils.createFormField(
                        context: dialogContext,
                        label: '新密码',
                        controller: passwordController,
                        hintText: '请输入新密码',
                        prefixIcon: Icons.lock_outline,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
        actions: [
          AppActionButton(
            onPressed: () async {
              final nextPassword = passwordController.text.trim();
              if (passwordAction == _RoomPasswordAction.update &&
                  nextPassword.isEmpty) {
                MessageUtils.showWarning(context, '请输入新密码');
                return;
              }
              try {
                switch (passwordAction) {
                  case _RoomPasswordAction.keep:
                    Navigator.pop(context);
                    return;
                  case _RoomPasswordAction.update:
                    await SyncTvService.adminUpdateRoomPassword(
                      detail.roomId,
                      nextPassword,
                    );
                  case _RoomPasswordAction.clear:
                    await SyncTvService.adminUpdateRoomPassword(
                      detail.roomId,
                      '',
                    );
                }
                if (!mounted) return;
                Navigator.pop(context);
                MessageUtils.showSuccess(context, '房间密码已更新');
                _loadRooms(silent: true);
              } catch (e) {
                if (mounted) MessageUtils.showError(context, '更新房间密码失败: $e');
              }
            },
            icon: Icons.password_rounded,
            label: '保存密码',
            style: AppActionButtonStyle.tonal,
          ),
          AppActionButton(
            onPressed: () {
              Navigator.pop(context);
              _showRoomChatHistory(detail);
            },
            icon: Icons.forum_outlined,
            label: '聊天历史',
            style: AppActionButtonStyle.tonal,
          ),
          AppActionButton(
            onPressed: () {
              Navigator.pop(context);
              _editRoomTaxonomy(detail);
            },
            icon: Icons.category_outlined,
            label: '分类标签',
            style: AppActionButtonStyle.tonal,
          ),
          AppActionButton(
            onPressed: () {
              Navigator.pop(context);
              _openContentReportsViewer(
                context,
                title: '${detail.roomName} 的举报',
                targetType: 1,
                targetRoomId: detail.roomId,
                scope: admin_enum
                    .ContentReportScope.CONTENT_REPORT_SCOPE_TARGET_ROOM.value,
              );
            },
            icon: Icons.report_gmailerrorred_outlined,
            label: '举报记录',
            style: AppActionButtonStyle.tonal,
          ),
          AppActionButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteRoom(detail);
            },
            icon: Icons.delete_outline_rounded,
            label: '删除房间',
            style: AppActionButtonStyle.destructive,
          ),
          _closeButton(context),
        ],
      );
      passwordController.dispose();
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '加载房间详情失败: $e');
    }
  }

  String _roomCategoryDisplay(RoomCategoryInfo category) {
    final name = category.name.trim();
    return name.isEmpty ? category.key : name;
  }

  String _roomLabelDisplay(RoomLabelInfo label) {
    final name = label.name.trim();
    return name.isEmpty ? label.key : name;
  }

  Future<void> _editRoomTaxonomy(SyncTvRoom room) async {
    try {
      final results = await Future.wait([
        SyncTvService.adminListRoomCategories(
          includeDisabled: false,
          refresh: true,
        ),
        SyncTvService.adminListRoomLabels(
          includeDisabled: false,
          refresh: true,
        ),
      ]);
      if (!mounted) return;
      final categories = results[0]
          .cast<RoomCategoryInfo>()
          .where((category) => category.isEnabled)
          .toList()
        ..sort((a, b) {
          final order = a.sortOrder.compareTo(b.sortOrder);
          if (order != 0) return order;
          return _roomCategoryDisplay(a).compareTo(_roomCategoryDisplay(b));
        });
      final labels = results[1]
          .cast<RoomLabelInfo>()
          .where((label) => label.isEnabled)
          .toList()
        ..sort((a, b) {
          final order = a.sortOrder.compareTo(b.sortOrder);
          if (order != 0) return order;
          return _roomLabelDisplay(a).compareTo(_roomLabelDisplay(b));
        });
      var selectedCategoryId = room.category?.id ?? '';
      if (selectedCategoryId.isNotEmpty &&
          categories.every((category) => category.id != selectedCategoryId)) {
        selectedCategoryId = '';
      }
      final selectedLabelIds = room.labels.map((label) => label.id).toSet();

      List<RoomLabelInfo> availableLabels() {
        if (selectedCategoryId.isEmpty) return labels;
        return labels
            .where((label) => label.categoryId == selectedCategoryId)
            .toList(growable: false);
      }

      void pruneSelectedLabels() {
        final availableIds = availableLabels().map((label) => label.id).toSet();
        selectedLabelIds.removeWhere((id) => !availableIds.contains(id));
      }

      pruneSelectedLabels();
      final confirmed = await ChatUtils.showStyledDialog<bool>(
        context: context,
        title: '分类标签',
        icon: const Icon(Icons.category_outlined, color: Color(0xFF5D5FEF)),
        content: StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            final theme = Theme.of(dialogContext);
            final visibleLabels = availableLabels();
            return SizedBox(
              width: 560,
              child: AppSingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSelect<String?>(
                      value: selectedCategoryId.isEmpty
                          ? null
                          : selectedCategoryId,
                      label: '房间分类',
                      hintText: '不设置分类',
                      prefixIcon: Icons.category_outlined,
                      clearable: true,
                      options: {
                        '不设置分类': null,
                        for (final category in categories)
                          _roomCategoryDisplay(category): category.id,
                      },
                      onChanged: (value) => setDialogState(() {
                        selectedCategoryId = value ?? '';
                        pruneSelectedLabels();
                      }),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '房间标签',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (visibleLabels.isEmpty)
                      Text(
                        selectedCategoryId.isEmpty ? '暂无可用标签' : '当前分类下暂无标签',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: visibleLabels.map((label) {
                          final selected = selectedLabelIds.contains(label.id);
                          final color = parseRoomLabelColor(
                            label.color,
                            theme.colorScheme.primary,
                          );
                          return AppChip(
                            selected: selected,
                            onSelected: (value) => setDialogState(() {
                              if (value) {
                                selectedLabelIds.add(label.id);
                              } else {
                                selectedLabelIds.remove(label.id);
                              }
                            }),
                            style: selected
                                ? AppChipStyle.filled
                                : AppChipStyle.outlined,
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(_roomLabelDisplay(label)),
                              ],
                            ),
                          );
                        }).toList(growable: false),
                      ),
                  ],
                ),
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
            text: '保存',
          ),
        ],
      );
      if (confirmed != true) return;
      final labelIds = availableLabels()
          .where((label) => selectedLabelIds.contains(label.id))
          .map((label) => label.id)
          .toList(growable: false);
      await SyncTvService.adminUpdateRoomTaxonomy(
        room.roomId,
        categoryId: selectedCategoryId.isEmpty ? null : selectedCategoryId,
        clearCategory: selectedCategoryId.isEmpty,
        labelIds: labelIds,
      );
      if (!mounted) return;
      MessageUtils.showSuccess(context, '分类标签已保存');
      _loadRooms(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '保存分类标签失败: $e');
    }
  }

  Future<void> _showRoomChatHistory(SyncTvRoom room) async {
    await showAppDialog<void>(
      context: context,
      builder: (_) => _RoomChatHistoryDialog(room: room),
    );
  }

  Future<void> _showRoomMembers(SyncTvRoom room) async {
    final searchController = TextEditingController();
    var page = 1;
    var pageSize = 20;
    var roleFilter = common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_UNSPECIFIED;
    var sortBy =
        admin_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_JOINED_AT;
    var sortDirection = admin_enum.SortDirection.SORT_DIRECTION_DESC;

    try {
      final data = await SyncTvService.adminListRoomMembersPage(
        room.roomId,
        page: page,
        pageSize: pageSize,
        sortBy: sortBy,
        sortDirection: sortDirection,
      );
      if (!mounted) return;
      var members = data.members;
      var total = data.total;
      var onlineCount = data.onlineCount;
      var connectionCount = data.connectionCount;
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
                  final next = await SyncTvService.adminListRoomMembersPage(
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
                    onlineCount = next.onlineCount;
                    connectionCount = next.connectionCount;
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
                        child: AppSearchField(
                          controller: searchController,
                          hintText: '搜索成员',
                          onChanged: (value) {
                            if (value.isEmpty) {
                              page = 1;
                              loadMembers();
                            }
                          },
                          onSubmitted: (_) {
                            page = 1;
                            loadMembers();
                          },
                        ),
                      ),
                      AppSelect<common_enum.RoomMemberRole>(
                        value: roleFilter,
                        options: const {
                          '全部角色': common_enum
                              .RoomMemberRole.ROOM_MEMBER_ROLE_UNSPECIFIED,
                          '创建者': common_enum
                              .RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR,
                          '管理员':
                              common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
                          '成员': common_enum
                              .RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
                          '访客':
                              common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_GUEST,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          roleFilter = value;
                          page = 1;
                          loadMembers();
                        },
                      ),
                      AppSelect<admin_enum.RoomMemberListSortBy>(
                        value: sortBy,
                        options: const {
                          '加入时间': admin_enum.RoomMemberListSortBy
                              .ROOM_MEMBER_LIST_SORT_BY_JOINED_AT,
                          '用户名': admin_enum.RoomMemberListSortBy
                              .ROOM_MEMBER_LIST_SORT_BY_USERNAME,
                          '角色': admin_enum.RoomMemberListSortBy
                              .ROOM_MEMBER_LIST_SORT_BY_ROLE,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          sortBy = value;
                          page = 1;
                          loadMembers();
                        },
                      ),
                      AppIconButton(
                        tooltip: sortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? '降序'
                            : '升序',
                        icon: sortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? Icons.south_rounded
                            : Icons.north_rounded,
                        onPressed: () {
                          sortDirection = sortDirection ==
                                  admin_enum.SortDirection.SORT_DIRECTION_DESC
                              ? admin_enum.SortDirection.SORT_DIRECTION_ASC
                              : admin_enum.SortDirection.SORT_DIRECTION_DESC;
                          page = 1;
                          loadMembers();
                        },
                      ),
                      AppSelect<int>(
                        value: pageSize,
                        options: const {
                          '20 / 页': 20,
                          '50 / 页': 50,
                          '100 / 页': 100,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          pageSize = value;
                          page = 1;
                          loadMembers();
                        },
                      ),
                      AppIconButton(
                        tooltip: '刷新',
                        icon: Icons.refresh_rounded,
                        onPressed: loadMembers,
                      ),
                      AppActionButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _addRoomMember(room);
                        },
                        icon: Icons.person_add_alt_rounded,
                        label: '添加成员',
                        style: AppActionButtonStyle.text,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '总数 $total · 在线 $onlineCount · 连接 $connectionCount',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).hintColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: loading
                        ? const AppLoadingIndicator()
                        : members.isEmpty
                            ? const AppEmptyMessage(message: '暂无成员')
                            : AppListView.builder(
                                itemCount: members.length,
                                itemBuilder: (context, index) {
                                  final member = members[index];
                                  return AppTile(
                                    prefix: Icon(
                                      member.isOnline
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      color:
                                          member.isOnline ? Colors.green : null,
                                    ),
                                    title: Text(member.username),
                                    subtitle: Text(
                                      '${member.userId} · ${_roomMemberRoleText(member.role)} · ${member.isOnline ? '${member.connectionCount} 连接' : '离线'} · ${_formatTimestamp(member.joinedAt)}',
                                    ),
                                    suffix: Wrap(
                                      spacing: 4,
                                      children: [
                                        AppIconButton(
                                          tooltip: '切换管理员',
                                          icon: Icons
                                              .admin_panel_settings_outlined,
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
                                            await SyncTvService
                                                .adminSetRoomMemberRole(
                                              room.roomId,
                                              member.userId,
                                              nextRole,
                                            );
                                            await loadMembers();
                                          },
                                        ),
                                        AppIconButton(
                                          tooltip: '权限覆盖',
                                          icon: Icons.tune_rounded,
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            await _editRoomMemberPermissionOverrides(
                                              room,
                                              member,
                                            );
                                          },
                                        ),
                                        AppIconButton(
                                          tooltip: '踢出',
                                          icon: Icons.logout_rounded,
                                          style: AppIconButtonStyle.destructive,
                                          onPressed: () async {
                                            final cooldown =
                                                await _askKickCooldownSeconds();
                                            if (cooldown == null) return;
                                            await SyncTvService
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
                  AppPaginationBar(
                    padding: EdgeInsets.zero,
                    label: '共 $total 个成员，第 $page / $totalPages 页',
                    onPrevious: canPrev
                        ? () {
                            page -= 1;
                            loadMembers();
                          }
                        : null,
                    onNext: canNext
                        ? () {
                            page += 1;
                            loadMembers();
                          }
                        : null,
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

  Future<void> _addRoomMember(SyncTvRoom room) async {
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
              AppSelect<int>(
                value: role,
                label: '房间角色',
                options: {
                  '成员':
                      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
                  '管理员':
                      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value,
                },
                onChanged: (value) => setDialogState(
                  () => role = value ??
                      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
                ),
              ),
              const SizedBox(height: 12),
              AppSwitchTile(
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
      await SyncTvService.adminAddRoomMember(
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
    SyncTvRoom room,
    AdminRoomMember member,
  ) async {
    final result = await _showPermissionOverrideDialog(member);
    if (result == null) {
      await _showRoomMembers(room);
      return;
    }
    try {
      await SyncTvService.adminUpdateRoomMemberPermissionOverrides(
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
        AppActionButton(
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
          label: '清除覆盖',
          style: AppActionButtonStyle.text,
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
          AppSegmentedControl<_PermissionOverrideMode>(
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
            value: mode,
            onChanged: (selection) => onChanged(flag, selection),
          ),
        ],
      ),
    );
  }

  Future<void> _editRoomSettings(SyncTvRoom room) async {
    try {
      final settings = await SyncTvService.adminGetRoomSettings(
        room.roomId,
      );
      if (!mounted) return;
      final maxMembers =
          TextEditingController(text: settings.maxMembers.toString());
      bool requirePassword = settings.requirePassword;
      bool requireApproval = settings.requireApproval;
      bool allowGuestJoin = settings.allowGuestJoin;
      bool chatEnabled = settings.chatEnabled;
      bool danmakuEnabled = settings.danmakuEnabled;
      final confirmed = await ChatUtils.showStyledDialog<bool>(
        context: context,
        title: '房间设置',
        icon: const Icon(Icons.tune_rounded, color: Color(0xFF5D5FEF)),
        content: StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AppSingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppSwitchTile(
                    value: requirePassword,
                    onChanged: (value) =>
                        setDialogState(() => requirePassword = value),
                    title: const Text('需要密码'),
                  ),
                  AppSwitchTile(
                    value: requireApproval,
                    onChanged: (value) =>
                        setDialogState(() => requireApproval = value),
                    title: const Text('加入需要审核'),
                  ),
                  AppSwitchTile(
                    value: allowGuestJoin,
                    onChanged: (value) =>
                        setDialogState(() => allowGuestJoin = value),
                    title: const Text('允许访客加入'),
                  ),
                  AppSwitchTile(
                    value: chatEnabled,
                    onChanged: (value) =>
                        setDialogState(() => chatEnabled = value),
                    title: const Text('聊天'),
                  ),
                  AppSwitchTile(
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
                ],
              ),
            );
          },
        ),
        actions: [
          AppActionButton(
            onPressed: () async {
              await SyncTvService.adminResetRoomSettings(room.roomId);
              if (!mounted) return;
              Navigator.pop(context, false);
              MessageUtils.showSuccess(context, '房间设置已重置');
            },
            label: '重置',
            style: AppActionButtonStyle.text,
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
      settings.requirePassword = requirePassword;
      settings.requireApproval = requireApproval;
      settings.allowGuestJoin = allowGuestJoin;
      settings.chatEnabled = chatEnabled;
      settings.danmakuEnabled = danmakuEnabled;
      settings.maxMembers =
          int.tryParse(maxMembers.text.trim()) ?? settings.maxMembers;
      await SyncTvService.adminUpdateRoomSettings(
        room.roomId,
        settings,
      );
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

  String _roomStatusLabel(SyncTvRoom room) {
    return room.isBanned ? '已封禁' : _getStatusText(room.status);
  }

  Color _roomStatusColorForRoom(SyncTvRoom room) {
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
          child: _AdminToolbarWrap(
            items: [
              _AdminToolbarItem(
                width: 240,
                child: _buildStyledTextField(
                  controller: _searchController,
                  onSubmitted: (val) {
                    setState(() {
                      _searchQuery = val;
                      _page = 1;
                    });
                    _loadRooms();
                  },
                  hint: '搜索房间',
                  icon: Icons.search,
                ),
              ),
              _AdminToolbarItem(
                width: 112,
                child: AppSelect<String?>(
                  value: _categoryFilter.isEmpty ? null : _categoryFilter,
                  hintText: '全部分类',
                  prefixIcon: Icons.category_outlined,
                  clearable: true,
                  enabled: !_isLoadingTaxonomy && _categories.isNotEmpty,
                  options: {
                    '全部分类': null,
                    for (final category in _categories)
                      _roomCategoryDisplay(category): category.id,
                  },
                  onChanged: (value) {
                    setState(() {
                      _categoryFilter = value ?? '';
                      _labelFilters.removeWhere(
                        (id) => !_availableFilterLabels.any(
                          (label) => label.id == id,
                        ),
                      );
                      _page = 1;
                    });
                    _loadRooms();
                  },
                ),
              ),
              _AdminToolbarItem(
                width: 112,
                child: AppActionButton(
                  onPressed:
                      _isLoadingTaxonomy ? null : _showRoomLabelFilterDialog,
                  icon: Icons.sell_outlined,
                  label: _labelFilters.isEmpty
                      ? '标签'
                      : '标签 ${_labelFilters.length}',
                  style: _labelFilters.isEmpty
                      ? AppActionButtonStyle.outlined
                      : AppActionButtonStyle.tonal,
                ),
              ),
              _AdminToolbarItem(
                width: 112,
                child: AppSelect<common_enum.RoomStatus>(
                  value: _statusFilter,
                  options: const {
                    '全部状态': common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED,
                    '活跃': common_enum.RoomStatus.ROOM_STATUS_ACTIVE,
                    '已关闭': common_enum.RoomStatus.ROOM_STATUS_CLOSED,
                  },
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() {
                      _statusFilter = val;
                      _page = 1;
                    });
                    _loadRooms();
                  },
                ),
              ),
              _AdminToolbarItem(
                width: 112,
                child: AppSelect<bool?>(
                  value: _bannedFilter,
                  options: const {
                    '全部封禁': null,
                    '仅封禁': true,
                    '未封禁': false,
                  },
                  onChanged: (value) {
                    setState(() {
                      _bannedFilter = value;
                      _page = 1;
                    });
                    _loadRooms();
                  },
                ),
              ),
              _AdminToolbarItem(
                width: 126,
                child: AppSelect<admin_enum.RoomListSortBy>(
                  value: _sortBy,
                  options: const {
                    '创建时间':
                        admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_CREATED_AT,
                    '更新时间':
                        admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_UPDATED_AT,
                    '最近活跃': admin_enum
                        .RoomListSortBy.ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
                    '房间名': admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_NAME,
                  },
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _sortBy = value;
                      _page = 1;
                    });
                    _loadRooms();
                  },
                ),
              ),
              _AdminToolbarItem(
                width: 44,
                child: AppIconButton(
                  tooltip: _sortDirection ==
                          admin_enum.SortDirection.SORT_DIRECTION_DESC
                      ? '降序'
                      : '升序',
                  icon: _sortDirection ==
                          admin_enum.SortDirection.SORT_DIRECTION_DESC
                      ? Icons.south_rounded
                      : Icons.north_rounded,
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
              ),
              _AdminToolbarItem(
                width: 96,
                child: AppSelect<int>(
                  value: _pageSize,
                  options: const {
                    '20 / 页': 20,
                    '50 / 页': 50,
                    '100 / 页': 100,
                  },
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _pageSize = value;
                      _page = 1;
                    });
                    _loadRooms();
                  },
                ),
              ),
              if (_categoryFilter.isNotEmpty || _labelFilters.isNotEmpty)
                _AdminToolbarItem(
                  width: 44,
                  child: AppIconButton(
                    tooltip: '清除分类标签筛选',
                    icon: Icons.filter_alt_off_rounded,
                    onPressed: () {
                      setState(() {
                        _categoryFilter = '';
                        _labelFilters.clear();
                        _page = 1;
                      });
                      _loadRooms();
                    },
                    style: AppIconButtonStyle.tonal,
                  ),
                ),
              _AdminToolbarItem(
                width: 44,
                child: AppIconButton(
                  tooltip: '选择当前页',
                  icon: Icons.select_all_rounded,
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
              ? const AppLoadingIndicator()
              : _rooms.isEmpty
                  ? const AppEmptyMessage(message: '暂无房间')
                  : AppListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: _rooms.length,
                      itemBuilder: (context, index) {
                        final room = _rooms[index];
                        final statusColor = _roomStatusColorForRoom(room);
                        return _AdminPanelCard(
                          isDark: isDark,
                          child: AppTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            prefix: AppCheckbox(
                              value: _selectedRoomIds.contains(room.roomId),
                              semanticsLabel: '选择房间',
                              onChanged: (value) => _toggleRoomSelection(
                                room.roomId,
                                value,
                              ),
                            ),
                            title: Text(room.roomName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  AppBadge(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    borderRadius: BorderRadius.circular(6),
                                    color: statusColor,
                                    borderSide: BorderSide(
                                      color:
                                          statusColor.withValues(alpha: 0.50),
                                    ),
                                    label: Text(
                                      _roomStatusLabel(room),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: statusColor,
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
                            suffix: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!room.isBanned)
                                  AppIconButton(
                                    icon: Icons.block,
                                    iconSize: 22,
                                    tooltip: '封禁',
                                    style: AppIconButtonStyle.destructive,
                                    onPressed: () => _banRoom(room, true),
                                  )
                                else
                                  AppIconButton(
                                    icon: Icons.check_circle,
                                    iconSize: 22,
                                    tooltip: '解封',
                                    onPressed: () => _banRoom(room, false),
                                  ),
                                AppActionButton(
                                  icon: Icons.info_outline_rounded,
                                  label: '房间信息',
                                  size: AppActionButtonSize.sm,
                                  style: AppActionButtonStyle.tonal,
                                  onPressed: () => _showRoomDetails(room),
                                ),
                                AppIconButton(
                                  icon: Icons.group_outlined,
                                  iconSize: 22,
                                  tooltip: '成员',
                                  onPressed: () => _showRoomMembers(room),
                                ),
                                AppIconButton(
                                  icon: Icons.forum_outlined,
                                  iconSize: 22,
                                  tooltip: '聊天历史',
                                  onPressed: () => _showRoomChatHistory(room),
                                ),
                                AppIconButton(
                                  icon: Icons.report_gmailerrorred_outlined,
                                  iconSize: 22,
                                  tooltip: '举报',
                                  onPressed: () => _openContentReportsViewer(
                                    context,
                                    title: '${room.roomName} 的举报',
                                    targetType: 1,
                                    targetRoomId: room.roomId,
                                    scope: admin_enum.ContentReportScope
                                        .CONTENT_REPORT_SCOPE_TARGET_ROOM.value,
                                  ),
                                ),
                                AppIconButton(
                                  icon: Icons.tune_rounded,
                                  iconSize: 22,
                                  tooltip: '设置',
                                  onPressed: () => _editRoomSettings(room),
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
    return AppPanelSurface(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: isDark ? Colors.grey.shade900 : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: theme.dividerColor.withValues(alpha: 0.12),
      ),
      child: Row(
        children: [
          Icon(Icons.checklist_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text('已选择 ${_selectedRoomIds.length} 个房间')),
          AppActionButton(
            onPressed: () => setState(_selectedRoomIds.clear),
            label: '清空',
            style: AppActionButtonStyle.text,
          ),
          const SizedBox(width: 4),
          AppActionButton(
            onPressed: _batchBanRooms,
            icon: Icons.block_rounded,
            label: '封禁',
            style: AppActionButtonStyle.tonal,
          ),
          const SizedBox(width: 8),
          AppActionButton(
            onPressed: _batchDeleteRooms,
            icon: Icons.delete_outline_rounded,
            label: '删除',
            style: AppActionButtonStyle.destructive,
          ),
        ],
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required Function(String) onSubmitted,
    required String hint,
    required IconData icon,
  }) {
    return AppSearchField(
      controller: controller,
      hintText: hint,
      icon: icon,
      onSubmitted: onSubmitted,
    );
  }
}

class AdminRoomTaxonomyTab extends StatefulWidget {
  const AdminRoomTaxonomyTab({super.key});

  @override
  State<AdminRoomTaxonomyTab> createState() => _AdminRoomTaxonomyTabState();
}

class _AdminRoomTaxonomyTabState extends State<AdminRoomTaxonomyTab> {
  bool _isLoading = true;
  List<RoomCategoryInfo> _categories = const [];
  List<RoomLabelInfo> _labels = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        SyncTvService.adminListRoomCategories(
          includeDisabled: true,
          refresh: true,
        ),
        SyncTvService.adminListRoomLabels(
          includeDisabled: true,
          refresh: true,
        ),
      ]);
      if (!mounted) return;
      final categories = results[0].cast<RoomCategoryInfo>().toList()
        ..sort(_compareCategories);
      final labels = results[1].cast<RoomLabelInfo>().toList()
        ..sort(_compareLabels);
      setState(() {
        _categories = categories;
        _labels = labels;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      MessageUtils.showError(context, '加载分类标签失败: $e');
    }
  }

  int _compareCategories(RoomCategoryInfo a, RoomCategoryInfo b) {
    final order = a.sortOrder.compareTo(b.sortOrder);
    if (order != 0) return order;
    return _categoryDisplay(a).compareTo(_categoryDisplay(b));
  }

  int _compareLabels(RoomLabelInfo a, RoomLabelInfo b) {
    final category = _categoryDisplayById(a.categoryId)
        .compareTo(_categoryDisplayById(b.categoryId));
    if (category != 0) return category;
    final order = a.sortOrder.compareTo(b.sortOrder);
    if (order != 0) return order;
    return _labelDisplay(a).compareTo(_labelDisplay(b));
  }

  String _categoryDisplay(RoomCategoryInfo category) {
    final name = category.name.trim();
    return name.isEmpty ? category.key : name;
  }

  String _labelDisplay(RoomLabelInfo label) {
    final name = label.name.trim();
    return name.isEmpty ? label.key : name;
  }

  String _categoryDisplayById(String categoryId) {
    if (categoryId.isEmpty) return '未绑定分类';
    for (final category in _categories) {
      if (category.id == categoryId) return _categoryDisplay(category);
    }
    return '未知分类';
  }

  String _normalizeColor(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    var hex = trimmed.startsWith('#') ? trimmed.substring(1) : trimmed;
    hex = hex.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');
    if (hex.length == 3) {
      hex = hex.split('').map((part) => '$part$part').join();
    }
    if (hex.length != 6) return trimmed;
    return '#${hex.toUpperCase()}';
  }

  Future<void> _editCategory([RoomCategoryInfo? category]) async {
    final keyController = TextEditingController(text: category?.key ?? '');
    final nameController = TextEditingController(text: category?.name ?? '');
    final descriptionController =
        TextEditingController(text: category?.description ?? '');
    final sortController =
        TextEditingController(text: '${category?.sortOrder ?? 0}');
    var enabled = category?.isEnabled ?? true;
    var disposeScheduled = false;
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: category == null ? '新增分类' : '编辑分类',
      icon: const Icon(Icons.category_rounded, color: Color(0xFF5D5FEF)),
      content: StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          if (!disposeScheduled) {
            disposeScheduled = true;
            _disposeControllersAfterRouteClose(dialogContext, [
              keyController,
              nameController,
              descriptionController,
              sortController,
            ]);
          }
          return SizedBox(
            width: 520,
            child: AppSingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ChatUtils.createFormField(
                    context: dialogContext,
                    label: '标识',
                    controller: keyController,
                    hintText: '例如 movie',
                    prefixIcon: Icons.key_rounded,
                  ),
                  const SizedBox(height: 12),
                  ChatUtils.createFormField(
                    context: dialogContext,
                    label: '名称',
                    controller: nameController,
                    hintText: '例如 电影',
                    prefixIcon: Icons.drive_file_rename_outline_rounded,
                  ),
                  const SizedBox(height: 12),
                  ChatUtils.createFormField(
                    context: dialogContext,
                    label: '描述',
                    controller: descriptionController,
                    hintText: '可选',
                    prefixIcon: Icons.notes_rounded,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  ChatUtils.createFormField(
                    context: dialogContext,
                    label: '排序',
                    controller: sortController,
                    hintText: '数字越小越靠前',
                    prefixIcon: Icons.sort_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  AppSwitchTile(
                    value: enabled,
                    onChanged: (value) => setDialogState(() => enabled = value),
                    title: const Text('启用分类'),
                    prefix: const Icon(Icons.toggle_on_outlined),
                  ),
                ],
              ),
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
          text: '保存',
        ),
      ],
    );
    if (confirmed != true) return;

    final key = keyController.text.trim();
    final name = nameController.text.trim();
    final sortOrder = int.tryParse(sortController.text.trim());
    if (key.isEmpty || name.isEmpty) {
      if (!mounted) return;
      MessageUtils.showWarning(context, '请填写分类标识和名称');
      return;
    }
    if (sortOrder == null) {
      if (!mounted) return;
      MessageUtils.showWarning(context, '排序需要填写整数');
      return;
    }

    try {
      await SyncTvService.adminUpsertRoomCategory(
        key: key,
        name: name,
        description: descriptionController.text.trim(),
        sortOrder: sortOrder,
        isEnabled: enabled,
      );
      if (!mounted) return;
      MessageUtils.showSuccess(context, '分类已保存');
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '保存分类失败: $e');
    }
  }

  Future<void> _deleteCategory(RoomCategoryInfo category) async {
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '删除分类',
      icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
      content: _destructiveDialogContent(
        '将永久删除分类 "${_categoryDisplay(category)}"。',
        const [
          '已绑定该分类的房间会失去对应分类。',
          '后台筛选和房间展示会立即使用最新分类数据。',
        ],
      ),
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
      await SyncTvService.adminDeleteRoomCategory(category.id);
      if (!mounted) return;
      MessageUtils.showSuccess(context, '分类已删除');
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '删除分类失败: $e');
    }
  }

  Future<void> _editLabel([RoomLabelInfo? label]) async {
    final keyController = TextEditingController(text: label?.key ?? '');
    final nameController = TextEditingController(text: label?.name ?? '');
    final descriptionController =
        TextEditingController(text: label?.description ?? '');
    final colorController =
        TextEditingController(text: _normalizeColor(label?.color ?? ''));
    final sortController =
        TextEditingController(text: '${label?.sortOrder ?? 0}');
    var categoryId = label?.categoryId ?? '';
    var enabled = label?.isEnabled ?? true;
    var disposeScheduled = false;
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: label == null ? '新增标签' : '编辑标签',
      icon: const Icon(Icons.sell_rounded, color: Color(0xFF5D5FEF)),
      content: StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          if (!disposeScheduled) {
            disposeScheduled = true;
            _disposeControllersAfterRouteClose(dialogContext, [
              keyController,
              nameController,
              descriptionController,
              colorController,
              sortController,
            ]);
          }
          final previewColor = parseRoomLabelColor(
            colorController.text,
            Theme.of(dialogContext).colorScheme.primary,
          );
          return SizedBox(
            width: 520,
            child: AppSingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ChatUtils.createFormField(
                    context: dialogContext,
                    label: '标识',
                    controller: keyController,
                    hintText: '例如 hot',
                    prefixIcon: Icons.key_rounded,
                  ),
                  const SizedBox(height: 12),
                  ChatUtils.createFormField(
                    context: dialogContext,
                    label: '名称',
                    controller: nameController,
                    hintText: '例如 热门',
                    prefixIcon: Icons.drive_file_rename_outline_rounded,
                  ),
                  const SizedBox(height: 12),
                  AppSelect<String?>(
                    value: categoryId.isEmpty ? null : categoryId,
                    label: '所属分类',
                    hintText: '不绑定分类',
                    prefixIcon: Icons.category_outlined,
                    clearable: true,
                    options: {
                      '不绑定分类': null,
                      for (final category in _categories)
                        _categoryDisplay(category): category.id,
                    },
                    onChanged: (value) =>
                        setDialogState(() => categoryId = value ?? ''),
                  ),
                  const SizedBox(height: 12),
                  ChatUtils.createFormField(
                    context: dialogContext,
                    label: '颜色',
                    controller: colorController,
                    hintText: '#5D5FEF',
                    prefixIcon: Icons.palette_outlined,
                    suffix: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: previewColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ChatUtils.createFormField(
                    context: dialogContext,
                    label: '描述',
                    controller: descriptionController,
                    hintText: '可选',
                    prefixIcon: Icons.notes_rounded,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  ChatUtils.createFormField(
                    context: dialogContext,
                    label: '排序',
                    controller: sortController,
                    hintText: '数字越小越靠前',
                    prefixIcon: Icons.sort_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  AppSwitchTile(
                    value: enabled,
                    onChanged: (value) => setDialogState(() => enabled = value),
                    title: const Text('启用标签'),
                    prefix: const Icon(Icons.toggle_on_outlined),
                  ),
                ],
              ),
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
          text: '保存',
        ),
      ],
    );
    if (confirmed != true) return;

    final key = keyController.text.trim();
    final name = nameController.text.trim();
    final sortOrder = int.tryParse(sortController.text.trim());
    final color = _normalizeColor(colorController.text);
    if (key.isEmpty || name.isEmpty) {
      if (!mounted) return;
      MessageUtils.showWarning(context, '请填写标签标识和名称');
      return;
    }
    if (sortOrder == null) {
      if (!mounted) return;
      MessageUtils.showWarning(context, '排序需要填写整数');
      return;
    }
    if (color.isNotEmpty &&
        !RegExp(r'^#[0-9A-F]{6}$').hasMatch(color.toUpperCase())) {
      if (!mounted) return;
      MessageUtils.showWarning(context, '颜色格式需要类似 #5D5FEF');
      return;
    }

    try {
      await SyncTvService.adminUpsertRoomLabel(
        key: key,
        name: name,
        description: descriptionController.text.trim(),
        color: color,
        categoryId: categoryId,
        sortOrder: sortOrder,
        isEnabled: enabled,
      );
      if (!mounted) return;
      MessageUtils.showSuccess(context, '标签已保存');
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '保存标签失败: $e');
    }
  }

  Future<void> _deleteLabel(RoomLabelInfo label) async {
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '删除标签',
      icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
      content: _destructiveDialogContent(
        '将永久删除标签 "${_labelDisplay(label)}"。',
        const [
          '已绑定该标签的房间会失去对应标签。',
          '房间详情、筛选和列表展示会立即使用最新标签数据。',
        ],
      ),
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
      await SyncTvService.adminDeleteRoomLabel(label.id);
      if (!mounted) return;
      MessageUtils.showSuccess(context, '标签已删除');
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '删除标签失败: $e');
    }
  }

  Widget _destructiveDialogContent(String title, List<String> impacts) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...impacts.map(
          (impact) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 16,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(impact)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppSingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AdminToolbarWrap(
            items: [
              _AdminToolbarItem(
                width: 150,
                child: AppActionButton(
                  onPressed: () => _editCategory(),
                  icon: Icons.add_rounded,
                  label: '新增分类',
                ),
              ),
              _AdminToolbarItem(
                width: 150,
                child: AppActionButton(
                  onPressed: () => _editLabel(),
                  icon: Icons.add_rounded,
                  label: '新增标签',
                  style: AppActionButtonStyle.tonal,
                ),
              ),
              _AdminToolbarItem(
                width: 112,
                child: AppActionButton(
                  onPressed: () => _load(),
                  icon: Icons.refresh_rounded,
                  label: '刷新',
                  style: AppActionButtonStyle.outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const AppLoadingIndicator(padding: EdgeInsets.all(32))
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 900;
                final panels = [
                  _buildCategoryPanel(theme),
                  _buildLabelPanel(theme),
                ];
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: panels[0]),
                      const SizedBox(width: 16),
                      Expanded(child: panels[1]),
                    ],
                  );
                }
                return Column(
                  children: [
                    panels[0],
                    const SizedBox(height: 16),
                    panels[1],
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryPanel(ThemeData theme) {
    return AppPanelSurface(
      padding: const EdgeInsets.all(16),
      border: Border.all(color: theme.colorScheme.outlineVariant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TaxonomyPanelHeader(
            icon: Icons.category_rounded,
            title: '房间分类',
            count: _categories.length,
          ),
          const SizedBox(height: 12),
          if (_categories.isEmpty)
            const AppEmptyState(
              icon: Icons.category_outlined,
              title: '暂无分类',
              subtitle: '新增分类后可在房间管理中分配',
            )
          else
            ..._categories.map(
              (category) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _CategoryCard(
                  category: category,
                  onEdit: () => _editCategory(category),
                  onDelete: () => _deleteCategory(category),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLabelPanel(ThemeData theme) {
    return AppPanelSurface(
      padding: const EdgeInsets.all(16),
      border: Border.all(color: theme.colorScheme.outlineVariant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TaxonomyPanelHeader(
            icon: Icons.sell_rounded,
            title: '房间标签',
            count: _labels.length,
          ),
          const SizedBox(height: 12),
          if (_labels.isEmpty)
            const AppEmptyState(
              icon: Icons.sell_outlined,
              title: '暂无标签',
              subtitle: '新增标签后可在房间管理中分配',
            )
          else
            ..._labels.map(
              (label) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _LabelCard(
                  label: label,
                  categoryName: _categoryDisplayById(label.categoryId),
                  onEdit: () => _editLabel(label),
                  onDelete: () => _deleteLabel(label),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TaxonomyPanelHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;

  const _TaxonomyPanelHeader({
    required this.icon,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        AppChip(
          label: Text('$count'),
          style: AppChipStyle.outlined,
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final RoomCategoryInfo category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryCard({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  String get _displayName {
    final name = category.name.trim();
    return name.isEmpty ? category.key : name;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      padding: const EdgeInsets.all(12),
      color: theme.colorScheme.surfaceContainerLowest,
      border: Border.all(color: theme.colorScheme.outlineVariant),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            category.isEnabled
                ? Icons.category_rounded
                : Icons.category_outlined,
            color: category.isEnabled
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
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
                        _displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    AppChip(
                      label: Text(category.isEnabled ? '启用' : '停用'),
                      style: category.isEnabled
                          ? AppChipStyle.filled
                          : AppChipStyle.outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _TaxonomyMetaChip(
                      icon: Icons.key_rounded,
                      label: category.key,
                    ),
                    _TaxonomyMetaChip(
                      icon: Icons.sort_rounded,
                      label: '${category.sortOrder}',
                    ),
                  ],
                ),
                if (category.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    category.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIconButton(
                onPressed: onEdit,
                icon: Icons.edit_outlined,
                tooltip: '编辑分类',
                style: AppIconButtonStyle.tonal,
                size: AppIconButtonSize.sm,
              ),
              const SizedBox(height: 6),
              AppIconButton(
                onPressed: onDelete,
                icon: Icons.delete_outline_rounded,
                tooltip: '删除分类',
                style: AppIconButtonStyle.destructive,
                size: AppIconButtonSize.sm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LabelCard extends StatelessWidget {
  final RoomLabelInfo label;
  final String categoryName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _LabelCard({
    required this.label,
    required this.categoryName,
    required this.onEdit,
    required this.onDelete,
  });

  String get _displayName {
    final name = label.name.trim();
    return name.isEmpty ? label.key : name;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = parseRoomLabelColor(label.color, theme.colorScheme.primary);
    return AppPanelSurface(
      padding: const EdgeInsets.all(12),
      color: theme.colorScheme.surfaceContainerLowest,
      border: Border.all(color: theme.colorScheme.outlineVariant),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
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
                        _displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    AppChip(
                      label: Text(label.isEnabled ? '启用' : '停用'),
                      style: label.isEnabled
                          ? AppChipStyle.filled
                          : AppChipStyle.outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _TaxonomyMetaChip(
                      icon: Icons.key_rounded,
                      label: label.key,
                    ),
                    _TaxonomyMetaChip(
                      icon: Icons.category_outlined,
                      label: categoryName,
                    ),
                    _TaxonomyMetaChip(
                      icon: Icons.palette_outlined,
                      label: label.color.trim().isEmpty
                          ? '默认颜色'
                          : label.color.trim(),
                    ),
                    _TaxonomyMetaChip(
                      icon: Icons.sort_rounded,
                      label: '${label.sortOrder}',
                    ),
                  ],
                ),
                if (label.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    label.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIconButton(
                onPressed: onEdit,
                icon: Icons.edit_outlined,
                tooltip: '编辑标签',
                style: AppIconButtonStyle.tonal,
                size: AppIconButtonSize.sm,
              ),
              const SizedBox(height: 6),
              AppIconButton(
                onPressed: onDelete,
                icon: Icons.delete_outline_rounded,
                tooltip: '删除标签',
                style: AppIconButtonStyle.destructive,
                size: AppIconButtonSize.sm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaxonomyMetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TaxonomyMetaChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppChip(
      style: AppChipStyle.outlined,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
  List<SyncTvUser> _users = [];
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
  final _searchController = TextEditingController();

  int get _pageCount =>
      _total <= 0 ? 1 : ((_total + _pageSize - 1) ~/ _pageSize);

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final data = await SyncTvService.adminListUsersPage(
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
          AppSelect<int>(
            value: role,
            label: '角色',
            options: {
              '普通用户': common_enum.UserRole.USER_ROLE_USER.value,
              '管理员': common_enum.UserRole.USER_ROLE_ADMIN.value,
            },
            onChanged: (value) {
              if (value != null) role = value;
            },
          ),
          const SizedBox(height: 12),
          AppSelect<common_enum.UserStatus>(
            value: status,
            label: '状态',
            options: const {
              '正常': common_enum.UserStatus.USER_STATUS_ACTIVE,
              '已封禁': common_enum.UserStatus.USER_STATUS_BANNED,
            },
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
            await SyncTvService.adminAddUser(
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

  Future<void> _deleteUser(SyncTvUser user) async {
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '删除用户',
      icon: const Icon(Icons.warning, color: Colors.red),
      content: _destructiveDialogContent(
        '将永久删除用户 "${user.username}"。',
        const [
          '该用户的登录会话、第三方绑定和个人资料会被清除。',
          '该用户创建或参与的房间关系、聊天记录归属和权限状态会受到影响。',
          '在线客户端会立即失去当前账号访问能力。',
        ],
      ),
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
        await SyncTvService.adminDeleteUser(user.id);
        if (!mounted) return;
        MessageUtils.showSuccess(context, '用户已删除');
        _loadUsers(silent: true);
      } catch (e) {
        if (!mounted) return;
        MessageUtils.showError(context, '删除失败: $e');
      }
    }
  }

  Future<void> _toggleAdmin(SyncTvUser user) async {
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
        await SyncTvService.adminSetAdmin(user.id, !isAdmin);
        if (!mounted) return;
        MessageUtils.showSuccess(context, '操作成功');
        _loadUsers(silent: true);
      } catch (e) {
        if (!mounted) return;
        MessageUtils.showError(context, '操作失败: $e');
      }
    }
  }

  Future<void> _banUser(SyncTvUser user, bool ban) async {
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
        await SyncTvService.adminBanUser(
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
      final result = await SyncTvService.adminBatchBanUsers(
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
      content: _destructiveDialogContent(
        '将永久删除 ${_selectedUserIds.length} 个用户。',
        const [
          '相关用户的登录会话、第三方绑定和个人资料会被清除。',
          '这些用户关联的房间关系、聊天记录归属和权限状态会受到影响。',
          '批量操作完成后只能通过备份恢复数据。',
        ],
      ),
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
      final result = await SyncTvService.adminBatchDeleteUsers(
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

  Widget _destructiveDialogContent(String title, List<String> impacts) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...impacts.map(
          (impact) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 16,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    impact,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showUserDetails(SyncTvUser user) async {
    try {
      final results = await Future.wait([
        SyncTvService.adminGetUser(user.id),
        SyncTvService.adminGetUserPreferences(user.id),
      ]);
      if (!mounted) return;
      final detail = results[0] as SyncTvUser;
      final preferences = results[1] as AccountPreferences;
      await ChatUtils.showStyledDialog(
        context: context,
        title: detail.username,
        icon: const Icon(Icons.person_rounded, color: Color(0xFF5D5FEF)),
        content: SizedBox(
          width: 620,
          height: 520,
          child: AppDefaultTabController(
            length: 4,
            child: Column(
              children: [
                const AppTabBar(
                  tabs: [
                    Tab(text: '资料'),
                    Tab(text: '房间'),
                    Tab(text: '举报'),
                    Tab(text: '偏好'),
                  ],
                ),
                Expanded(
                  child: AppTabBarView(
                    children: [
                      _buildUserProfileDetails(detail),
                      _buildUserRoomsPanel(user.id),
                      _buildUserReportsPanel(detail),
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

  Widget _buildUserReportsPanel(SyncTvUser user) {
    return AppDefaultTabController(
      length: 2,
      child: Column(
        children: [
          const AppTabBar(
            tabs: [
              Tab(text: '被举报'),
              Tab(text: '发起举报'),
            ],
          ),
          Expanded(
            child: AppTabBarView(
              children: [
                AdminContentReportsTab(
                  title: '',
                  initialTargetType: 2,
                  initialTargetUserId: user.id,
                  initialScope: admin_enum.ContentReportScope
                      .CONTENT_REPORT_SCOPE_TARGET_USER.value,
                  showTargetTypeTabs: false,
                ),
                AdminContentReportsTab(
                  title: '',
                  initialReporterUserId: user.id,
                  showTargetTypeTabs: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileDetails(SyncTvUser detail) {
    return AppListView(
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
    var rooms = <SyncTvRoom>[];
    var total = 0;
    var page = 1;
    var pageSize = 20;
    final searchController = TextEditingController();
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
            final data = await SyncTvService.adminListUserRoomsPage(
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
            AppSingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 180,
                    child: AppSearchField(
                      controller: searchController,
                      hintText: '搜索房间',
                      onChanged: (value) {
                        if (value.isEmpty && search.isNotEmpty) {
                          search = '';
                          page = 1;
                          loadRooms();
                        }
                      },
                      onSubmitted: (value) {
                        search = value.trim();
                        page = 1;
                        loadRooms();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  AppSelect<common_enum.RoomStatus>(
                    value: status,
                    options: const {
                      '全部状态': common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED,
                      '活跃': common_enum.RoomStatus.ROOM_STATUS_ACTIVE,
                      '已关闭': common_enum.RoomStatus.ROOM_STATUS_CLOSED,
                    },
                    onChanged: (value) {
                      if (value == null) return;
                      status = value;
                      page = 1;
                      loadRooms();
                    },
                  ),
                  const SizedBox(width: 12),
                  AppSelect<bool?>(
                    value: isBanned,
                    options: const {
                      '全部封禁': null,
                      '仅封禁': true,
                      '未封禁': false,
                    },
                    onChanged: (value) {
                      isBanned = value;
                      page = 1;
                      loadRooms();
                    },
                  ),
                  const SizedBox(width: 12),
                  AppSelect<admin_enum.RoomListSortBy>(
                    value: sortBy,
                    options: const {
                      '创建时间': admin_enum
                          .RoomListSortBy.ROOM_LIST_SORT_BY_CREATED_AT,
                      '更新时间': admin_enum
                          .RoomListSortBy.ROOM_LIST_SORT_BY_UPDATED_AT,
                      '最近活跃': admin_enum
                          .RoomListSortBy.ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
                      '房间名': admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_NAME,
                    },
                    onChanged: (value) {
                      if (value == null) return;
                      sortBy = value;
                      page = 1;
                      loadRooms();
                    },
                  ),
                  AppIconButton(
                    tooltip: sortDirection ==
                            admin_enum.SortDirection.SORT_DIRECTION_DESC
                        ? '降序'
                        : '升序',
                    icon: sortDirection ==
                            admin_enum.SortDirection.SORT_DIRECTION_DESC
                        ? Icons.south_rounded
                        : Icons.north_rounded,
                    onPressed: () {
                      sortDirection = sortDirection ==
                              admin_enum.SortDirection.SORT_DIRECTION_DESC
                          ? admin_enum.SortDirection.SORT_DIRECTION_ASC
                          : admin_enum.SortDirection.SORT_DIRECTION_DESC;
                      page = 1;
                      loadRooms();
                    },
                  ),
                  AppSelect<int>(
                    value: pageSize,
                    options: const {
                      '20 / 页': 20,
                      '50 / 页': 50,
                      '100 / 页': 100,
                    },
                    onChanged: (value) {
                      if (value == null) return;
                      pageSize = value;
                      page = 1;
                      loadRooms();
                    },
                  ),
                  AppIconButton(
                    tooltip: '刷新',
                    icon: Icons.refresh_rounded,
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
                  ? const AppLoadingIndicator()
                  : rooms.isEmpty
                      ? const AppEmptyMessage(message: '暂无房间')
                      : AppListView.builder(
                          padding: const EdgeInsets.only(top: 8),
                          itemCount: rooms.length,
                          itemBuilder: (context, index) {
                            final room = rooms[index];
                            return AppTile(
                              prefix: Icon(
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
            final updated = await SyncTvService.adminUpdateUserPreferences(
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
          return AppSwitchTile(
            value: value,
            title: Text(title),
            onChanged: (value) {
              final next = update(value);
              setDialogState(() => notifications = next);
              savePreferences(nextNotifications: next);
            },
          );
        }

        return AppListView(
          padding: const EdgeInsets.only(top: 12),
          children: [
            AppSwitchTile(
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
            const AppDivider(height: 20),
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

  Future<void> _renameUser(SyncTvUser user) async {
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
      await SyncTvService.adminUpdateUsername(
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

  Future<void> _resetPassword(SyncTvUser user) async {
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
      await SyncTvService.adminUpdatePassword(
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
              _AdminToolbarWrap(
                items: [
                  _AdminToolbarItem(
                    width: 240,
                    child: _buildStyledTextField(
                      controller: _searchController,
                      onSubmitted: (val) {
                        setState(() {
                          _searchQuery = val;
                          _page = 1;
                        });
                        _loadUsers();
                      },
                      hint: '搜索用户',
                      icon: Icons.search,
                    ),
                  ),
                  _AdminToolbarItem(
                    width: 104,
                    child: _AdminPanelCard(
                      isDark: isDark,
                      child: AppInkSurface(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        onTap: _addUser,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Align(
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
                  ),
                  _AdminToolbarItem(
                    width: 44,
                    child: AppIconButton(
                      tooltip: '选择当前页',
                      icon: Icons.select_all_rounded,
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
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _AdminToolbarWrap(
                  items: [
                    _AdminToolbarItem(
                      width: 112,
                      child: AppSelect<common_enum.UserStatus>(
                        value: _statusFilter,
                        options: const {
                          '全部状态':
                              common_enum.UserStatus.USER_STATUS_UNSPECIFIED,
                          '正常': common_enum.UserStatus.USER_STATUS_ACTIVE,
                          '已封禁': common_enum.UserStatus.USER_STATUS_BANNED,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _statusFilter = value;
                            _page = 1;
                          });
                          _loadUsers();
                        },
                      ),
                    ),
                    _AdminToolbarItem(
                      width: 112,
                      child: AppSelect<common_enum.UserRole>(
                        value: _roleFilter,
                        options: const {
                          '全部角色': common_enum.UserRole.USER_ROLE_UNSPECIFIED,
                          'Root': common_enum.UserRole.USER_ROLE_ROOT,
                          '管理员': common_enum.UserRole.USER_ROLE_ADMIN,
                          '用户': common_enum.UserRole.USER_ROLE_USER,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _roleFilter = value;
                            _page = 1;
                          });
                          _loadUsers();
                        },
                      ),
                    ),
                    _AdminToolbarItem(
                      width: 112,
                      child: AppSelect<bool?>(
                        value: _bannedFilter,
                        options: const {
                          '全部封禁': null,
                          '仅封禁': true,
                          '未封禁': false,
                        },
                        onChanged: (value) {
                          setState(() {
                            _bannedFilter = value;
                            _page = 1;
                          });
                          _loadUsers();
                        },
                      ),
                    ),
                    _AdminToolbarItem(
                      width: 126,
                      child: AppSelect<admin_enum.UserListSortBy>(
                        value: _sortBy,
                        options: const {
                          '创建时间': admin_enum
                              .UserListSortBy.USER_LIST_SORT_BY_CREATED_AT,
                          '更新时间': admin_enum
                              .UserListSortBy.USER_LIST_SORT_BY_UPDATED_AT,
                          '用户名': admin_enum
                              .UserListSortBy.USER_LIST_SORT_BY_USERNAME,
                          '邮箱':
                              admin_enum.UserListSortBy.USER_LIST_SORT_BY_EMAIL,
                          '状态': admin_enum
                              .UserListSortBy.USER_LIST_SORT_BY_STATUS,
                          '角色':
                              admin_enum.UserListSortBy.USER_LIST_SORT_BY_ROLE,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _sortBy = value;
                            _page = 1;
                          });
                          _loadUsers();
                        },
                      ),
                    ),
                    _AdminToolbarItem(
                      width: 44,
                      child: AppIconButton(
                        tooltip: _sortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? '降序'
                            : '升序',
                        icon: _sortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? Icons.south_rounded
                            : Icons.north_rounded,
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
                    ),
                    _AdminToolbarItem(
                      width: 96,
                      child: AppSelect<int>(
                        value: _pageSize,
                        options: const {
                          '20 / 页': 20,
                          '50 / 页': 50,
                          '100 / 页': 100,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _pageSize = value;
                            _page = 1;
                          });
                          _loadUsers();
                        },
                      ),
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
              ? const AppLoadingIndicator()
              : AppListView.builder(
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

                    return _AdminPanelCard(
                      isDark: isDark,
                      child: AppTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        prefix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppCheckbox(
                              value: _selectedUserIds.contains(user.id),
                              semanticsLabel: '选择用户',
                              onChanged: (value) => _toggleUserSelection(
                                user.id,
                                value,
                              ),
                            ),
                            AppAvatar(
                              name: user.username,
                              radius: 24,
                              backgroundColor: isAdmin
                                  ? Colors.amber.withValues(alpha: 0.2)
                                  : theme.primaryColor.withValues(alpha: 0.1),
                              foregroundColor: isAdmin
                                  ? Colors.amber.shade800
                                  : theme.primaryColor,
                              textStyle: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        title: Text(user.username,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                              'ID: ${user.id} · ${_systemRoleText(user.role)} · ${_userStatusText(user.status)} · ${user.connectionCount > 0 ? '${user.connectionCount} 连接' : '离线'}',
                              style: TextStyle(
                                  fontSize: 12, color: theme.hintColor)),
                        ),
                        suffix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isBanned) ...[
                              AppIconButton(
                                icon: Icons.check_circle_outline,
                                iconSize: 24,
                                tooltip: '解封',
                                onPressed: () => _banUser(user, false),
                              ),
                            ] else ...[
                              AppIconButton(
                                icon: Icons.info_outline,
                                iconSize: 22,
                                tooltip: '详情',
                                onPressed: () => _showUserDetails(user),
                              ),
                              AppIconButton(
                                icon: Icons.report_gmailerrorred_outlined,
                                iconSize: 22,
                                tooltip: '查看举报',
                                onPressed: () => _openContentReportsViewer(
                                  context,
                                  title: '${user.username} 的举报',
                                  targetType: 2,
                                  targetUserId: user.id,
                                  scope: admin_enum.ContentReportScope
                                      .CONTENT_REPORT_SCOPE_TARGET_USER.value,
                                ),
                              ),
                              AppIconButton(
                                icon: Icons.edit_outlined,
                                iconSize: 22,
                                tooltip: '改名',
                                onPressed: () => _renameUser(user),
                              ),
                              AppIconButton(
                                icon: Icons.lock_reset_rounded,
                                iconSize: 22,
                                tooltip: '重置密码',
                                onPressed: () => _resetPassword(user),
                              ),
                              AppIconButton(
                                icon: Icons.block,
                                iconSize: 22,
                                style: AppIconButtonStyle.destructive,
                                tooltip: '封禁',
                                onPressed: () => _banUser(user, true),
                              ),
                              AppIconButton(
                                icon: isAdmin
                                    ? Icons.admin_panel_settings
                                    : Icons.admin_panel_settings_outlined,
                                iconSize: 22,
                                tooltip: isAdmin ? '取消管理员' : '设为管理员',
                                onPressed: () => _toggleAdmin(user),
                              ),
                            ],
                            AppIconButton(
                              icon: Icons.delete_outline,
                              iconSize: 22,
                              style: AppIconButtonStyle.destructive,
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
    return AppPanelSurface(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: isDark ? Colors.grey.shade900 : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: theme.dividerColor.withValues(alpha: 0.12),
      ),
      child: Row(
        children: [
          Icon(Icons.checklist_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text('已选择 ${_selectedUserIds.length} 个用户')),
          AppActionButton(
            onPressed: () => setState(_selectedUserIds.clear),
            label: '清空',
            style: AppActionButtonStyle.text,
          ),
          const SizedBox(width: 4),
          AppActionButton(
            onPressed: _batchBanUsers,
            icon: Icons.block_rounded,
            label: '封禁',
            style: AppActionButtonStyle.tonal,
          ),
          const SizedBox(width: 8),
          AppActionButton(
            onPressed: _batchDeleteUsers,
            icon: Icons.delete_outline_rounded,
            label: '删除',
            style: AppActionButtonStyle.destructive,
          ),
        ],
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required Function(String) onSubmitted,
    required String hint,
    required IconData icon,
  }) {
    return AppSearchField(
      controller: controller,
      hintText: hint,
      icon: icon,
      onSubmitted: onSubmitted,
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
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadReviews({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final data = await SyncTvService.adminListReviewsPage(
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
      await SyncTvService.adminApproveReview(_kind, review.id);
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
      await SyncTvService.adminRejectReview(
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
              AppSegmentedControl<String>(
                segments: const [
                  ButtonSegment(value: 'user', label: Text('注册')),
                  ButtonSegment(value: 'room', label: Text('建房')),
                  ButtonSegment(value: 'join', label: Text('加入')),
                ],
                value: _kind,
                onChanged: (value) {
                  setState(() {
                    _kind = value;
                    _page = 1;
                    _requestedBy = '';
                    _roomId = '';
                    _userId = '';
                  });
                  _loadReviews();
                },
              ),
              AppSelect<int>(
                value: _status,
                options: {
                  '待审核': common_enum.ReviewStatus.REVIEW_STATUS_PENDING.value,
                  '已通过': common_enum.ReviewStatus.REVIEW_STATUS_APPROVED.value,
                  '已拒绝': common_enum.ReviewStatus.REVIEW_STATUS_REJECTED.value,
                },
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _status = value;
                    _page = 1;
                  });
                  _loadReviews();
                },
              ),
              AppSelect<int>(
                value: _pageSize,
                options: const {
                  '20 / 页': 20,
                  '50 / 页': 50,
                  '100 / 页': 100,
                },
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
                child: AppSearchField(
                  controller: _searchController,
                  hintText: '搜索或输入 room_/usr_ ID',
                  onChanged: (value) {
                    if (value.isEmpty && _search.isNotEmpty) _applySearch('');
                  },
                  onSubmitted: _applySearch,
                ),
              ),
              AppIconButton(
                tooltip: '刷新',
                icon: Icons.refresh_rounded,
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
              ? const AppLoadingIndicator()
              : _reviews.isEmpty
                  ? Center(
                      child: Text('暂无审核记录',
                          style: TextStyle(color: theme.hintColor)))
                  : AppListView.builder(
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
                                          AppIconButton(
                                            tooltip: '通过',
                                            icon: Icons.check_circle_outline,
                                            onPressed: () => _approve(review),
                                          ),
                                          AppIconButton(
                                            tooltip: '拒绝',
                                            icon: Icons.cancel_outlined,
                                            style:
                                                AppIconButtonStyle.destructive,
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
    return AppBadge(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      backgroundColor:
          theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
      color: theme.colorScheme.onSurface,
      borderSide: BorderSide(
        color: theme.dividerColor.withValues(alpha: 0.08),
      ),
      label: Text(
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
    this.hasError = false,
  });

  final Set<String> selectedProviders;
  final List<String> options;
  final void Function(String provider, bool selected) onChanged;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: hasError
            ? theme.colorScheme.error
            : theme.colorScheme.outlineVariant.withValues(alpha: 0.72),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.category_outlined,
                  size: 18,
                  color: hasError
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Provider 类型',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: hasError ? theme.colorScheme.error : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final provider in options)
                AppChip(
                  label: Text(_providerTypeLabel(provider)),
                  avatar: Icon(_providerTypeIcon(provider), size: 16),
                  selected: selectedProviders.contains(provider),
                  onSelected: (selected) => onChanged(provider, selected),
                  showCheckmark: true,
                ),
              if (options.isEmpty)
                Text(
                  '暂无可选类型',
                  style: TextStyle(color: theme.hintColor),
                ),
            ],
          ),
          if (hasError) ...[
            const SizedBox(height: 8),
            Text(
              '至少选择一个 Provider 类型',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

IconData _providerTypeIcon(String provider) {
  return switch (provider) {
    'direct_url' => Icons.link_rounded,
    'alist' => Icons.folder_copy_outlined,
    'emby' => Icons.movie_filter_outlined,
    'bilibili' => Icons.live_tv_outlined,
    'rtmp' => Icons.podcasts_outlined,
    'live_proxy' => Icons.route_rounded,
    _ => Icons.extension_outlined,
  };
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
  final _searchController = TextEditingController();

  int get _pageCount =>
      _total <= 0 ? 1 : ((_total + _pageSize - 1) ~/ _pageSize);

  @override
  void initState() {
    super.initState();
    _loadInstances();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInstances({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        SyncTvService.adminListProviderInstancesPage(
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
            : SyncTvService.listProviderBackends(_providerType),
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
    final editing = instance != null;
    final result = await showAppDialog<_ProviderInstanceEditResult>(
      context: context,
      builder: (context) => _ProviderInstanceEditorDialog(
        instance: instance,
        selectedFilter: _providerType,
      ),
    );
    if (result == null) return;
    if (!mounted) return;

    try {
      if (editing) {
        await SyncTvService.adminUpdateProviderInstance(
          name: instance.name,
          endpoint: result.endpoint,
          comment: result.clearComment ? null : result.comment,
          timeoutSeconds: result.timeoutSeconds,
          tls: result.tls,
          insecureTls: result.insecureTls,
          providers: result.providers,
          jwtSecret: result.clearJwtSecret || result.jwtSecret.isEmpty
              ? null
              : result.jwtSecret,
          customCa: result.clearCustomCa || result.customCa.isEmpty
              ? null
              : result.customCa,
          clearComment: result.clearComment,
          clearJwtSecret: result.clearJwtSecret,
          clearCustomCa: result.clearCustomCa,
        );
      } else {
        await SyncTvService.adminAddProviderInstance(
          name: result.name,
          endpoint: result.endpoint,
          providers: result.providers,
          comment: result.comment,
          timeoutSeconds: result.timeoutSeconds,
          tls: result.tls,
          insecureTls: result.insecureTls,
          jwtSecret: result.jwtSecret.isEmpty ? null : result.jwtSecret,
          customCa: result.customCa.isEmpty ? null : result.customCa,
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
      await SyncTvService.adminDeleteProviderInstance(instance.name);
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
      await SyncTvService.adminSetProviderInstanceEnabled(
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
      await SyncTvService.adminReconnectProviderInstance(instance.name);
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
              _AdminToolbarWrap(
                items: [
                  _AdminToolbarItem(
                    width: 260,
                    child: AppSearchField(
                      controller: _searchController,
                      hintText: '搜索名称、Endpoint',
                      onChanged: (value) {
                        if (value.isEmpty && _search.isNotEmpty) {
                          setState(() {
                            _search = '';
                            _page = 1;
                          });
                          _loadInstances();
                        }
                      },
                      onSubmitted: (value) {
                        setState(() {
                          _search = value.trim();
                          _page = 1;
                        });
                        _loadInstances();
                      },
                    ),
                  ),
                  _AdminToolbarItem(
                    width: 44,
                    child: AppIconButton(
                      tooltip: '新增',
                      icon: Icons.add_circle_outline_rounded,
                      onPressed: () => _editInstance(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _AdminToolbarWrap(
                  items: [
                    _AdminToolbarItem(
                      width: 112,
                      child: AppSelect<bool?>(
                        value: _enabledFilter,
                        options: const {
                          '全部状态': null,
                          '已启用': true,
                          '已停用': false,
                        },
                        onChanged: (value) {
                          setState(() {
                            _enabledFilter = value;
                            _page = 1;
                          });
                          _loadInstances();
                        },
                      ),
                    ),
                    _AdminToolbarItem(
                      width: 112,
                      child: AppSelect<bool?>(
                        value: _tlsFilter,
                        options: const {
                          '全部 TLS': null,
                          'TLS 开启': true,
                          'TLS 关闭': false,
                        },
                        onChanged: (value) {
                          setState(() {
                            _tlsFilter = value;
                            _page = 1;
                          });
                          _loadInstances();
                        },
                      ),
                    ),
                    _AdminToolbarItem(
                      width: 112,
                      child: AppSelect<String>(
                        value: _providerType,
                        options: const {
                          '全部类型': '',
                          'Direct URL': 'direct_url',
                          'AList': 'alist',
                          'Emby': 'emby',
                          'Bilibili': 'bilibili',
                          'RTMP': 'rtmp',
                          'Live Proxy': 'live_proxy',
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _providerType = value;
                            _page = 1;
                          });
                          _loadInstances();
                        },
                      ),
                    ),
                    _AdminToolbarItem(
                      width: 126,
                      child: AppSelect<
                          provider_common_enum.ProviderInstanceListSortBy>(
                        value: _sortBy,
                        options: const {
                          '按名称': provider_common_enum.ProviderInstanceListSortBy
                              .PROVIDER_INSTANCE_LIST_SORT_BY_NAME,
                          '按 Endpoint': provider_common_enum
                              .ProviderInstanceListSortBy
                              .PROVIDER_INSTANCE_LIST_SORT_BY_ENDPOINT,
                          '按创建': provider_common_enum.ProviderInstanceListSortBy
                              .PROVIDER_INSTANCE_LIST_SORT_BY_CREATED_AT,
                          '按更新': provider_common_enum.ProviderInstanceListSortBy
                              .PROVIDER_INSTANCE_LIST_SORT_BY_UPDATED_AT,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _sortBy = value;
                            _page = 1;
                          });
                          _loadInstances();
                        },
                      ),
                    ),
                    _AdminToolbarItem(
                      width: 44,
                      child: AppIconButton(
                        tooltip: _sortDirection ==
                                provider_common_enum
                                    .SortDirection.SORT_DIRECTION_DESC
                            ? '降序'
                            : '升序',
                        icon: _sortDirection ==
                                provider_common_enum
                                    .SortDirection.SORT_DIRECTION_DESC
                            ? Icons.south_rounded
                            : Icons.north_rounded,
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
                    ),
                    _AdminToolbarItem(
                      width: 96,
                      child: AppSelect<int>(
                        value: _pageSize,
                        options: const {
                          '20 / 页': 20,
                          '50 / 页': 50,
                          '100 / 页': 100,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _pageSize = value;
                            _page = 1;
                          });
                          _loadInstances();
                        },
                      ),
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
              ? const AppLoadingIndicator()
              : _instances.isEmpty
                  ? Center(
                      child: Text('暂无 Provider 实例',
                          style: TextStyle(color: theme.hintColor)))
                  : AppListView.builder(
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
    return AppPanelSurface(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: isDark ? Colors.grey.shade900 : Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: theme.dividerColor.withValues(alpha: 0.12),
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
                        AppChip(
                          label: Text(backend),
                          avatar: const Icon(Icons.copy_rounded, size: 16),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: backend));
                            MessageUtils.showSuccess(context, 'Backend 已复制');
                          },
                        ),
                    ],
                  ),
          ),
          AppIconButton(
            tooltip: '刷新 Backend',
            icon: Icons.refresh_rounded,
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
          AppSwitch(
            value: instance.enabled,
            semanticsLabel: '启用实例',
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
                AppSelectableText(
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
              AppIconButton(
                tooltip: '编辑',
                icon: Icons.edit_outlined,
                onPressed: onEdit,
              ),
              AppIconButton(
                tooltip: '重连',
                icon: Icons.sync_rounded,
                onPressed: onReconnect,
              ),
              AppIconButton(
                tooltip: '删除',
                icon: Icons.delete_outline,
                style: AppIconButtonStyle.destructive,
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
    return AppBadge(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      borderRadius: BorderRadius.circular(8),
      icon: icon,
      iconSize: 14,
      color: color,
      backgroundColor: color.withValues(alpha: 0.1),
      borderSide: BorderSide(color: color.withValues(alpha: 0.18)),
      label: ConstrainedBox(
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
    );
  }
}

class _ProviderInstanceEditResult {
  final String name;
  final String endpoint;
  final String comment;
  final int timeoutSeconds;
  final List<String> providers;
  final bool tls;
  final bool insecureTls;
  final String jwtSecret;
  final String customCa;
  final bool clearComment;
  final bool clearJwtSecret;
  final bool clearCustomCa;

  const _ProviderInstanceEditResult({
    required this.name,
    required this.endpoint,
    required this.comment,
    required this.timeoutSeconds,
    required this.providers,
    required this.tls,
    required this.insecureTls,
    required this.jwtSecret,
    required this.customCa,
    required this.clearComment,
    required this.clearJwtSecret,
    required this.clearCustomCa,
  });
}

class _ProviderInstanceEditorDialog extends StatefulWidget {
  final AdminProviderInstance? instance;
  final String selectedFilter;

  const _ProviderInstanceEditorDialog({
    required this.instance,
    required this.selectedFilter,
  });

  @override
  State<_ProviderInstanceEditorDialog> createState() =>
      _ProviderInstanceEditorDialogState();
}

class _ProviderInstanceEditorDialogState
    extends State<_ProviderInstanceEditorDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _endpointController;
  late final TextEditingController _commentController;
  late final TextEditingController _timeoutController;
  late final TextEditingController _jwtSecretController;
  late final TextEditingController _customCaController;
  late final Set<String> _selectedProviders;
  late bool _tls;
  late bool _insecureTls;
  bool _clearComment = false;
  bool _clearJwtSecret = false;
  bool _clearCustomCa = false;
  bool _submitted = false;

  bool get _editing => widget.instance != null;

  @override
  void initState() {
    super.initState();
    final instance = widget.instance;
    _nameController = TextEditingController(text: instance?.name ?? '');
    _endpointController = TextEditingController(text: instance?.endpoint ?? '');
    _commentController = TextEditingController(text: instance?.comment ?? '');
    _timeoutController = TextEditingController(
      text: (instance?.timeoutSeconds ?? 30).toString(),
    );
    _jwtSecretController = TextEditingController();
    _customCaController = TextEditingController();
    _selectedProviders = <String>{
      ...?instance?.providers,
      if (instance == null && widget.selectedFilter.isNotEmpty)
        widget.selectedFilter,
    };
    _tls = instance?.tls ?? true;
    _insecureTls = instance?.insecureTls ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _endpointController.dispose();
    _commentController.dispose();
    _timeoutController.dispose();
    _jwtSecretController.dispose();
    _customCaController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _submitted = true);
    final name = _nameController.text.trim();
    final endpoint = _endpointController.text.trim();
    final timeout = int.tryParse(_timeoutController.text.trim());
    final providers = _selectedProviders.toList(growable: false)..sort();
    if (!_editing && name.isEmpty) return;
    if (endpoint.isEmpty) return;
    if (providers.isEmpty) return;
    if (timeout == null || timeout <= 0) return;
    Navigator.pop(
      context,
      _ProviderInstanceEditResult(
        name: name,
        endpoint: endpoint,
        comment: _commentController.text.trim(),
        timeoutSeconds: timeout,
        providers: providers,
        tls: _tls,
        insecureTls: _insecureTls,
        jwtSecret: _jwtSecretController.text.trim(),
        customCa: _customCaController.text.trim(),
        clearComment: _clearComment,
        clearJwtSecret: _clearJwtSecret,
        clearCustomCa: _clearCustomCa,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompact =
        AppBreakpoints.widthOf(context) < AppBreakpoints.expandedStart;
    final title = _editing ? '编辑 Provider 实例' : '新增 Provider 实例';
    return AppDialogFrame(
      maxWidth: 860,
      maxHeight: 760,
      child: Column(
        children: [
          _ProviderEditorHeader(
            title: title,
            subtitle: _editing ? widget.instance!.name : '配置外部媒体 Provider 节点',
            editing: _editing,
            onClose: () => Navigator.pop(context),
          ),
          Expanded(
            child: AppSingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                isCompact ? 18 : 24,
                22,
                isCompact ? 18 : 24,
                24,
              ),
              child: isCompact
                  ? Column(
                      children: _editorSections(theme, compact: true),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Column(
                            children: _primarySections(theme),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: _secondarySections(theme),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          _ProviderEditorFooter(
            editing: _editing,
            onCancel: () => Navigator.pop(context),
            onSubmit: _submit,
          ),
        ],
      ),
    );
  }

  List<Widget> _editorSections(ThemeData theme, {required bool compact}) => [
        ..._primarySections(theme),
        ..._secondarySections(theme),
      ];

  List<Widget> _primarySections(ThemeData theme) => [
        _ProviderEditorSection(
          icon: Icons.badge_outlined,
          title: '基础信息',
          children: [
            AppTextField(
              controller: _nameController,
              label: '实例名称',
              hintText: 'provider_main',
              prefixIcon: Icons.badge_outlined,
              enabled: !_editing,
              errorText:
                  _submitted && !_editing && _nameController.text.trim().isEmpty
                      ? '请输入实例名称'
                      : null,
              autocorrect: false,
              smartDashesType: SmartDashesType.disabled,
              smartQuotesType: SmartQuotesType.disabled,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _endpointController,
              label: 'Endpoint',
              hintText: 'https://provider.example.com',
              prefixIcon: Icons.link_rounded,
              keyboardType: TextInputType.url,
              errorText: _submitted && _endpointController.text.trim().isEmpty
                  ? '请输入 Endpoint'
                  : null,
              autocorrect: false,
              smartDashesType: SmartDashesType.disabled,
              smartQuotesType: SmartQuotesType.disabled,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _timeoutController,
              label: '请求超时',
              prefixIcon: Icons.timer_outlined,
              suffix: const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Center(
                  widthFactor: 1,
                  child: Text('秒'),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              errorText: _submitted &&
                      ((int.tryParse(_timeoutController.text.trim()) ?? 0) <= 0)
                  ? '请输入大于 0 的整数'
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 16),
        _ProviderEditorSection(
          icon: Icons.category_outlined,
          title: '能力类型',
          description: '一个实例可以同时承载多个 Provider 类型。',
          children: [
            _ProviderTypeSelector(
              selectedProviders: _selectedProviders,
              options: _providerTypeOptions(
                selectedFilter: widget.selectedFilter,
                selectedProviders: _selectedProviders,
              ),
              hasError: _submitted && _selectedProviders.isEmpty,
              onChanged: (provider, selected) => setState(() {
                if (selected) {
                  _selectedProviders.add(provider);
                } else {
                  _selectedProviders.remove(provider);
                }
              }),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ];

  List<Widget> _secondarySections(ThemeData theme) => [
        _ProviderEditorSection(
          icon: Icons.security_rounded,
          title: '连接安全',
          description: '不安全 TLS 只应用于受控内网或测试环境。',
          children: [
            _ProviderOptionSwitch(
              icon: Icons.verified_user_outlined,
              title: '启用 TLS',
              subtitle: _tls ? '使用 HTTPS/TLS 连接 Provider' : '使用非 TLS 连接',
              value: _tls,
              onChanged: (value) => setState(() {
                _tls = value;
                if (!_tls) _insecureTls = false;
              }),
            ),
            const SizedBox(height: 10),
            _ProviderOptionSwitch(
              icon: Icons.warning_amber_rounded,
              title: '允许不安全 TLS',
              subtitle: '跳过证书校验，可能被中间人攻击',
              value: _insecureTls,
              enabled: _tls,
              danger: true,
              onChanged: (value) => setState(() => _insecureTls = value),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _jwtSecretController,
              label: 'JWT Secret',
              hintText: _editing ? '留空则不修改' : '可选',
              prefixIcon: Icons.key_rounded,
              enabled: !_clearJwtSecret,
              obscureText: true,
              autocorrect: false,
              smartDashesType: SmartDashesType.disabled,
              smartQuotesType: SmartQuotesType.disabled,
            ),
            if (_editing)
              AppCheckboxTile(
                value: _clearJwtSecret,
                onChanged: (value) => setState(() {
                  _clearJwtSecret = value;
                  if (_clearJwtSecret) _jwtSecretController.clear();
                }),
                title: const Text('清除 JWT Secret'),
              ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _customCaController,
              label: 'Custom CA',
              hintText: _editing ? 'PEM 内容，留空则不修改' : 'PEM 内容，可选',
              prefixIcon: Icons.verified_outlined,
              enabled: !_clearCustomCa,
              minLines: 4,
              maxLines: 7,
              autocorrect: false,
              smartDashesType: SmartDashesType.disabled,
              smartQuotesType: SmartQuotesType.disabled,
            ),
            if (_editing)
              AppCheckboxTile(
                value: _clearCustomCa,
                onChanged: (value) => setState(() {
                  _clearCustomCa = value;
                  if (_clearCustomCa) _customCaController.clear();
                }),
                title: const Text('清除 Custom CA'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        _ProviderEditorSection(
          icon: Icons.notes_rounded,
          title: '备注',
          children: [
            AppTextField(
              controller: _commentController,
              label: '备注',
              hintText: '可选，用于标记部署位置、用途或维护信息',
              prefixIcon: Icons.notes_rounded,
              enabled: !_clearComment,
              minLines: 2,
              maxLines: 4,
            ),
            if (_editing)
              AppCheckboxTile(
                value: _clearComment,
                onChanged: (value) => setState(() {
                  _clearComment = value;
                  if (_clearComment) _commentController.clear();
                }),
                title: const Text('清除备注'),
              ),
          ],
        ),
      ];
}

class _ProviderEditorHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool editing;
  final VoidCallback onClose;

  const _ProviderEditorHeader({
    required this.title,
    required this.subtitle,
    required this.editing,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      padding: const EdgeInsets.fromLTRB(24, 22, 16, 18),
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.42),
      borderRadius: BorderRadius.zero,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          AppIconBadge(
            icon: Icons.hub_rounded,
            color: theme.colorScheme.primary,
            iconColor: theme.colorScheme.onPrimary,
            backgroundColor: theme.colorScheme.primary,
            size: 46,
            borderRadius: BorderRadius.circular(14),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          _ProviderMetaChip(
            label: editing ? '编辑' : '新增',
            icon: editing ? Icons.edit_outlined : Icons.add_rounded,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          AppIconButton(
            tooltip: '关闭',
            icon: Icons.close_rounded,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _ProviderEditorSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final List<Widget> children;

  const _ProviderEditorSection({
    required this.icon,
    required this.title,
    this.description,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          if (description != null) ...[
            const SizedBox(height: 4),
            Text(
              description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _ProviderOptionSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final bool enabled;
  final bool danger;
  final ValueChanged<bool> onChanged;

  const _ProviderOptionSwitch({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    this.enabled = true,
    this.danger = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = danger ? theme.colorScheme.error : theme.colorScheme.primary;
    return AppPanelSurface(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: color.withValues(alpha: danger && value ? 0.09 : 0.04),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: color.withValues(alpha: 0.14),
      ),
      child: Row(
        children: [
          Icon(icon, color: enabled ? color : theme.disabledColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: enabled ? null : theme.disabledColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: enabled
                        ? theme.colorScheme.onSurfaceVariant
                        : theme.disabledColor,
                  ),
                ),
              ],
            ),
          ),
          AppSwitch(
            value: enabled && value,
            semanticsLabel: title,
            onChanged: enabled ? onChanged : null,
          ),
        ],
      ),
    );
  }
}

class _ProviderEditorFooter extends StatelessWidget {
  final bool editing;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  const _ProviderEditorFooter({
    required this.editing,
    required this.onCancel,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.zero,
      clipBehavior: Clip.none,
      border: Border(
        top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.55)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              editing ? '仅提交已填写或明确清除的敏感字段' : '创建后可在列表中启停、重连或编辑',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 16),
          AppActionButton(
            onPressed: onCancel,
            label: '取消',
            style: AppActionButtonStyle.outlined,
          ),
          const SizedBox(width: 10),
          AppActionButton(
            onPressed: onSubmit,
            icon: editing ? Icons.save_outlined : Icons.add_rounded,
            label: editing ? '保存' : '创建',
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
  final _searchController = TextEditingController();

  int get _pageCount =>
      _total <= 0 ? 1 : ((_total + _pageSize - 1) ~/ _pageSize);

  @override
  void initState() {
    super.initState();
    _loadStreams();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStreams({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final page = await SyncTvService.adminListActiveStreamsPage(
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
      await SyncTvService.adminKickStream(stream);
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
                width: 240,
                child: AppSearchField(
                  controller: _searchController,
                  hintText: '搜索，或输入 room_/usr_/node_ ID',
                  onChanged: (value) {
                    if (value.isEmpty && _search.isNotEmpty) {
                      _applyStreamSearch('');
                    }
                  },
                  onSubmitted: _applyStreamSearch,
                ),
              ),
              AppSelect<int>(
                value: _pageSize,
                options: const {
                  '20 / 页': 20,
                  '50 / 页': 50,
                  '100 / 页': 100,
                },
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _pageSize = value;
                    _page = 1;
                  });
                  _loadStreams();
                },
              ),
              AppSelect<admin_enum.ActiveStreamListSortBy>(
                value: _sortBy,
                options: const {
                  '开始时间': admin_enum.ActiveStreamListSortBy
                      .ACTIVE_STREAM_LIST_SORT_BY_STARTED_AT,
                  '房间': admin_enum.ActiveStreamListSortBy
                      .ACTIVE_STREAM_LIST_SORT_BY_ROOM_ID,
                  '媒体': admin_enum.ActiveStreamListSortBy
                      .ACTIVE_STREAM_LIST_SORT_BY_MEDIA_ID,
                  '用户': admin_enum.ActiveStreamListSortBy
                      .ACTIVE_STREAM_LIST_SORT_BY_USER_ID,
                  '节点': admin_enum.ActiveStreamListSortBy
                      .ACTIVE_STREAM_LIST_SORT_BY_NODE_ID,
                },
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _sortBy = value;
                    _page = 1;
                  });
                  _loadStreams();
                },
              ),
              AppIconButton(
                tooltip: _sortDirection ==
                        admin_enum.SortDirection.SORT_DIRECTION_DESC
                    ? '降序'
                    : '升序',
                icon: _sortDirection ==
                        admin_enum.SortDirection.SORT_DIRECTION_DESC
                    ? Icons.south_rounded
                    : Icons.north_rounded,
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
              AppIconButton(
                tooltip: '刷新',
                icon: Icons.refresh_rounded,
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
              ? const AppLoadingIndicator()
              : _streams.isEmpty
                  ? Center(
                      child: Text('暂无活跃流',
                          style: TextStyle(color: theme.hintColor)))
                  : AppListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: _streams.length,
                      itemBuilder: (context, index) {
                        final stream = _streams[index];
                        return _AdminPanelCard(
                          isDark: isDark,
                          child: AppTile(
                            prefix: const Icon(Icons.podcasts_rounded),
                            title: Text(stream.mediaId),
                            subtitle: Text(
                              '${stream.roomId} · ${stream.userId}\nNode: ${stream.nodeId} · ${_formatTimestamp(stream.startedAt)}',
                            ),
                            suffix: AppIconButton(
                              tooltip: '踢出流',
                              icon: Icons.power_settings_new_rounded,
                              style: AppIconButtonStyle.destructive,
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
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecords({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final data = await SyncTvService.adminListBanRecordsPage(
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
        await SyncTvService.adminBanUser(targetId, false);
      } else {
        await SyncTvService.adminBanRoom(targetId, false);
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
              AppSelect<int>(
                value: _targetType,
                options: const {
                  '全部对象': 0,
                  '用户': 1,
                  '房间': 2,
                },
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _targetType = value;
                    _page = 1;
                  });
                  _loadRecords();
                },
              ),
              AppSelect<bool?>(
                value: _active,
                options: const {
                  '全部状态': null,
                  '生效中': true,
                  '已撤销/过期': false,
                },
                onChanged: (value) {
                  setState(() {
                    _active = value;
                    _page = 1;
                  });
                  _loadRecords();
                },
              ),
              AppSelect<int>(
                value: _pageSize,
                options: const {
                  '20 / 页': 20,
                  '50 / 页': 50,
                  '100 / 页': 100,
                },
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
                child: AppSearchField(
                  controller: _searchController,
                  hintText: '输入 usr_/room_ ID',
                  onChanged: (value) {
                    if (value.isEmpty && _search.isNotEmpty) {
                      _applyBanSearch('');
                    }
                  },
                  onSubmitted: _applyBanSearch,
                ),
              ),
              if (_search.isNotEmpty)
                AppChip(
                  label: Text(_search),
                  avatar: const Icon(Icons.close_rounded, size: 16),
                  onPressed: () {
                    _searchController.clear();
                    _applyBanSearch('');
                  },
                ),
              AppIconButton(
                tooltip: '刷新',
                icon: Icons.refresh_rounded,
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
              ? const AppLoadingIndicator()
              : _records.isEmpty
                  ? Center(
                      child: Text('暂无封禁记录',
                          style: TextStyle(color: theme.hintColor)))
                  : AppListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: _records.length,
                      itemBuilder: (context, index) {
                        final record = _records[index];
                        final target = record.targetType == 1
                            ? '${record.username} (${record.userId})'
                            : '${record.roomName} (${record.roomId})';
                        return _AdminPanelCard(
                          isDark: isDark,
                          child: AppTile(
                            prefix: Icon(
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
                            suffix: record.isActive
                                ? AppIconButton(
                                    tooltip: '解除封禁',
                                    icon: Icons.lock_open_rounded,
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

class AdminContentReportsTab extends StatefulWidget {
  final String title;
  final int initialTargetType;
  final String initialReporterUserId;
  final String initialRoomId;
  final String initialTargetRoomId;
  final String initialTargetUserId;
  final String initialTargetMemberRoomId;
  final String initialTargetMemberUserId;
  final int initialTargetChatMessageId;
  final int initialScope;
  final String initialSearch;
  final bool showTargetTypeTabs;
  final String roomScopedRoomId;

  const AdminContentReportsTab({
    super.key,
    this.title = '举报',
    this.initialTargetType = 0,
    this.initialReporterUserId = '',
    this.initialRoomId = '',
    this.initialTargetRoomId = '',
    this.initialTargetUserId = '',
    this.initialTargetMemberRoomId = '',
    this.initialTargetMemberUserId = '',
    this.initialTargetChatMessageId = 0,
    this.initialScope = 0,
    this.initialSearch = '',
    this.showTargetTypeTabs = true,
    this.roomScopedRoomId = '',
  });

  @override
  State<AdminContentReportsTab> createState() => _AdminContentReportsTabState();
}

class _AdminContentReportsTabState extends State<AdminContentReportsTab>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  int _status = admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_OPEN.value;
  int _targetType = 0;
  String _search = '';
  String _reporterUserId = '';
  String _roomId = '';
  String _targetRoomId = '';
  String _targetUserId = '';
  String _targetMemberRoomId = '';
  String _targetMemberUserId = '';
  int _targetChatMessageId = 0;
  int _scope = 0;
  int _page = 1;
  int _pageSize = 50;
  int _total = 0;
  List<AdminContentReport> _reports = const [];
  final _searchController = TextEditingController();
  TabController? _targetTypeTabController;

  static const _targetTypeTabs = <_ReportTargetTypeTab>[
    _ReportTargetTypeTab('全部', 0),
    _ReportTargetTypeTab('房间', 1),
    _ReportTargetTypeTab('用户', 2),
    _ReportTargetTypeTab('成员', 3),
    _ReportTargetTypeTab('消息', 4),
  ];

  bool get _isRoomScoped => widget.roomScopedRoomId.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _targetType = widget.initialTargetType;
    _reporterUserId = widget.initialReporterUserId;
    _roomId = _isRoomScoped ? widget.roomScopedRoomId : widget.initialRoomId;
    _targetRoomId = widget.initialTargetRoomId;
    _targetUserId = widget.initialTargetUserId;
    _targetMemberRoomId = widget.initialTargetMemberRoomId;
    _targetMemberUserId = widget.initialTargetMemberUserId;
    _targetChatMessageId = widget.initialTargetChatMessageId;
    _scope = widget.initialScope;
    _search = widget.initialSearch;
    _searchController.text = _search;
    if (widget.showTargetTypeTabs) {
      final visibleTabs = _visibleTargetTypeTabs;
      if (_targetType == 0) {
        _targetType = visibleTabs.first.targetType;
      }
      final initialIndex = visibleTabs.indexWhere(
        (tab) => tab.targetType == _targetType,
      );
      if (initialIndex < 0) {
        _targetType = visibleTabs.first.targetType;
      }
      _targetTypeTabController = TabController(
        length: visibleTabs.length,
        initialIndex: initialIndex < 0 ? 0 : initialIndex,
        vsync: this,
      )..addListener(_handleTargetTypeTabChanged);
    }
    _loadReports();
  }

  @override
  void dispose() {
    _targetTypeTabController?.removeListener(_handleTargetTypeTabChanged);
    _targetTypeTabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleTargetTypeTabChanged() {
    final controller = _targetTypeTabController;
    if (controller == null || controller.indexIsChanging) return;
    final next = _visibleTargetTypeTabs[controller.index].targetType;
    if (_targetType == next) return;
    setState(() {
      _targetType = next;
      _page = 1;
    });
    _loadReports();
  }

  Future<void> _loadReports({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final data = _isRoomScoped
          ? await SyncTvService.listRoomContentReportsPage(
              widget.roomScopedRoomId,
              page: _page,
              pageSize: _pageSize,
              status: _status,
              targetType: _targetType,
              targetMemberUserId: _targetMemberUserId,
              targetChatMessageId: _targetChatMessageId,
              search: _search,
            )
          : await SyncTvService.adminListContentReportsPage(
              page: _page,
              pageSize: _pageSize,
              status: _status,
              targetType: _targetType,
              reporterUserId: _reporterUserId,
              roomId: _roomId,
              targetRoomId: _targetRoomId,
              targetUserId: _targetUserId,
              targetMemberRoomId: _targetMemberRoomId,
              targetMemberUserId: _targetMemberUserId,
              targetChatMessageId: _targetChatMessageId,
              scope: _scope,
              search: _search,
            );
      if (!mounted) return;
      setState(() {
        _reports = data.reports;
        _total = data.total;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      MessageUtils.showError(context, '加载举报记录失败: $e');
    }
  }

  void _applySearch(String value) {
    final normalized = value.trim();
    setState(() {
      _search = normalized;
      _reporterUserId = _isRoomScoped
          ? ''
          : normalized.startsWith('usr_')
              ? normalized
              : '';
      if (!_isRoomScoped && widget.initialRoomId.isEmpty) {
        _roomId = normalized.startsWith('room_') ? normalized : '';
      }
      _targetRoomId = _isRoomScoped
          ? ''
          : normalized.startsWith('room_')
              ? normalized
              : '';
      _targetUserId = _isRoomScoped
          ? ''
          : normalized.startsWith('usr_')
              ? normalized
              : '';
      _targetMemberRoomId = _isRoomScoped
          ? ''
          : normalized.startsWith('room_')
              ? normalized
              : '';
      _targetMemberUserId = normalized.startsWith('usr_') ? normalized : '';
      _targetChatMessageId = int.tryParse(normalized) ?? 0;
      _page = 1;
    });
    _loadReports();
  }

  Future<void> _openReport(AdminContentReport report) async {
    AdminContentReport detail = report;
    try {
      detail = _isRoomScoped
          ? await SyncTvService.getRoomContentReport(
              widget.roomScopedRoomId,
              report.id,
            )
          : await SyncTvService.adminGetContentReport(report.id);
    } catch (_) {
      detail = report;
    }
    if (!mounted) return;
    await ChatUtils.showStyledDialog<void>(
      context: context,
      title: '举报详情',
      icon: const Icon(Icons.report_gmailerrorred_rounded, color: Colors.red),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: AppSingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReportDetailRow(
                  label: '状态', value: _reportStatusText(detail.status)),
              _ReportDetailRow(label: '目标', value: _reportTargetText(detail)),
              _ReportDetailRow(label: '举报人', value: _reporterText(detail)),
              _ReportDetailRow(label: '原因', value: _reportReasonText(detail)),
              if (detail.targetChatMessagePreview.isNotEmpty)
                _ReportDetailRow(
                  label: '消息内容',
                  value: detail.targetChatMessagePreview,
                ),
              _ReportDetailRow(
                  label: '创建时间', value: _formatTimestamp(detail.createdAt)),
              if (detail.reviewedByUsername.isNotEmpty ||
                  detail.reviewedBy.isNotEmpty)
                _ReportDetailRow(
                  label: '处理人',
                  value: detail.reviewedByUsername.isEmpty
                      ? detail.reviewedBy
                      : detail.reviewedByUsername,
                ),
              if (detail.reviewedAt > 0)
                _ReportDetailRow(
                    label: '处理时间', value: _formatTimestamp(detail.reviewedAt)),
              if (detail.resolutionNote.isNotEmpty)
                _ReportDetailRow(label: '处置说明', value: detail.resolutionNote),
              if (detail.metadata.isNotEmpty)
                _ReportDetailRow(
                  label: '元数据',
                  value: const JsonEncoder.withIndent('  ')
                      .convert(detail.metadata),
                ),
            ],
          ),
        ),
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () {
            Navigator.pop(context);
            _openDisposition(detail);
          },
          text: '处置',
        ),
      ],
    );
  }

  Future<void> _openDisposition(AdminContentReport report) async {
    int nextStatus = report.status ==
            admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_OPEN.value
        ? admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_REVIEWING.value
        : report.status;
    final noteController = TextEditingController(text: report.resolutionNote);
    final updated = await ChatUtils.showStyledDialog<AdminContentReport>(
      context: context,
      title: '处置举报',
      icon: const Icon(Icons.rule_rounded, color: Colors.orange),
      content: StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_reportTargetText(report)),
                const SizedBox(height: 12),
                AppSelect<int>(
                  value: nextStatus,
                  options: const {
                    '处理中': 2,
                    '已处理': 3,
                    '已驳回': 4,
                    '待处理': 1,
                  },
                  onChanged: (value) {
                    if (value == null) return;
                    setDialogState(() => nextStatus = value);
                  },
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: noteController,
                  label: '处置说明',
                  maxLines: 4,
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
          () async {
            try {
              final result = _isRoomScoped
                  ? await SyncTvService.updateRoomContentReportStatus(
                      widget.roomScopedRoomId,
                      report.id,
                      nextStatus,
                      resolutionNote: noteController.text,
                    )
                  : await SyncTvService.adminUpdateContentReportStatus(
                      report.id,
                      nextStatus,
                      resolutionNote: noteController.text,
                    );
              if (!mounted) return;
              Navigator.pop(context, result);
            } catch (e) {
              if (!mounted) return;
              MessageUtils.showError(context, '处置失败: $e');
            }
          },
          text: '保存',
        ),
      ],
    );
    noteController.dispose();
    if (updated == null || !mounted) return;
    setState(() {
      _reports = [
        for (final item in _reports) item.id == updated.id ? updated : item,
      ];
    });
    MessageUtils.showSuccess(context, '举报状态已更新');
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
        if (widget.title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Icon(Icons.report_gmailerrorred_rounded,
                    color: theme.colorScheme.error),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (widget.showTargetTypeTabs && _targetTypeTabController != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AppPanelSurface(
                borderRadius: BorderRadius.circular(8),
                padding: const EdgeInsets.all(3),
                child: TabBar(
                  controller: _targetTypeTabController!,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  dividerColor: Colors.transparent,
                  tabs: [
                    for (final tab in _visibleTargetTypeTabs)
                      Tab(text: tab.label),
                  ],
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AppSelect<int>(
                value: _status,
                options: const {
                  '全部状态': 0,
                  '待处理': 1,
                  '处理中': 2,
                  '已处理': 3,
                  '已驳回': 4,
                },
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _status = value;
                    _page = 1;
                  });
                  _loadReports();
                },
              ),
              if (!widget.showTargetTypeTabs)
                AppSelect<int>(
                  value: _targetType,
                  options: _isRoomScoped
                      ? const {
                          '成员': 3,
                          '消息': 4,
                        }
                      : const {
                          '全部对象': 0,
                          '房间': 1,
                          '用户': 2,
                          '成员': 3,
                          '消息': 4,
                        },
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _targetType = value;
                      _page = 1;
                    });
                    _loadReports();
                  },
                ),
              AppSelect<int>(
                value: _pageSize,
                options: const {
                  '20 / 页': 20,
                  '50 / 页': 50,
                  '100 / 页': 100,
                },
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _pageSize = value;
                    _page = 1;
                  });
                  _loadReports();
                },
              ),
              SizedBox(
                width: 300,
                child: AppSearchField(
                  controller: _searchController,
                  hintText: '搜索原因、对象、usr_/room_ ID',
                  onChanged: (value) {
                    if (value.isEmpty && _search.isNotEmpty) {
                      _applySearch('');
                    }
                  },
                  onSubmitted: _applySearch,
                ),
              ),
              if (_search.isNotEmpty)
                AppChip(
                  label: Text(_search),
                  avatar: const Icon(Icons.close_rounded, size: 16),
                  onPressed: () {
                    _searchController.clear();
                    _applySearch('');
                  },
                ),
              ..._activeFilterChips(),
              AppIconButton(
                tooltip: '刷新',
                icon: Icons.refresh_rounded,
                onPressed: () => _loadReports(silent: true),
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
                  _loadReports();
                },
          onNext: _page >= _pageCount
              ? null
              : () {
                  setState(() => _page += 1);
                  _loadReports();
                },
        ),
        Expanded(
          child: _isLoading
              ? const AppLoadingIndicator()
              : _reports.isEmpty
                  ? Center(
                      child: Text('暂无举报记录',
                          style: TextStyle(color: theme.hintColor)))
                  : AppListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: _reports.length,
                      itemBuilder: (context, index) {
                        final report = _reports[index];
                        return _AdminPanelCard(
                          isDark: isDark,
                          child: AppTile(
                            onPressed: () => _openReport(report),
                            prefix: Icon(
                              _reportStatusIcon(report.status),
                              color: _reportStatusColor(report.status),
                            ),
                            title: Text(_reportTargetText(report)),
                            subtitle: Text(
                              '${_reportReasonText(report)}\n举报人: ${_reporterText(report)} · ${_formatTimestamp(report.createdAt)}',
                            ),
                            suffix: AppIconButton(
                              tooltip: '处置',
                              icon: Icons.rule_rounded,
                              onPressed: () => _openDisposition(report),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  List<Widget> _activeFilterChips() {
    final chips = <Widget>[];
    void addChip(String label, VoidCallback onClear) {
      chips.add(
        AppChip(
          label: Text(label),
          avatar: const Icon(Icons.close_rounded, size: 16),
          onPressed: () {
            setState(() {
              onClear();
              _page = 1;
            });
            _loadReports();
          },
        ),
      );
    }

    if (_reporterUserId.isNotEmpty) {
      addChip('举报人 $_reporterUserId', () => _reporterUserId = '');
    }
    if (!_isRoomScoped && _roomId.isNotEmpty) {
      addChip('上下文房间 $_roomId', () => _roomId = '');
    }
    if (_targetRoomId.isNotEmpty) {
      addChip('被举报房间 $_targetRoomId', () => _targetRoomId = '');
    }
    if (_targetUserId.isNotEmpty) {
      addChip('被举报用户 $_targetUserId', () => _targetUserId = '');
    }
    if (_targetMemberRoomId.isNotEmpty) {
      addChip('成员所在房间 $_targetMemberRoomId', () => _targetMemberRoomId = '');
    }
    if (_targetMemberUserId.isNotEmpty) {
      addChip('被举报成员 $_targetMemberUserId', () => _targetMemberUserId = '');
    }
    if (_targetChatMessageId > 0) {
      addChip('消息 #$_targetChatMessageId', () => _targetChatMessageId = 0);
    }
    return chips;
  }

  List<_ReportTargetTypeTab> get _visibleTargetTypeTabs {
    if (_isRoomScoped) {
      return _targetTypeTabs
          .where((tab) => tab.targetType == 3 || tab.targetType == 4)
          .toList(growable: false);
    }
    if (widget.initialTargetType == 0 &&
        widget.initialReporterUserId.isEmpty &&
        widget.initialRoomId.isEmpty &&
        widget.initialTargetRoomId.isEmpty &&
        widget.initialTargetUserId.isEmpty &&
        widget.initialTargetMemberRoomId.isEmpty &&
        widget.initialTargetMemberUserId.isEmpty &&
        widget.initialTargetChatMessageId <= 0 &&
        widget.initialScope == 0 &&
        widget.initialSearch.isEmpty) {
      return _targetTypeTabs.skip(1).toList(growable: false);
    }
    if (widget.initialScope ==
        admin_enum.ContentReportScope.CONTENT_REPORT_SCOPE_ROOM_CONTEXT.value) {
      return _targetTypeTabs
          .where((tab) => tab.targetType == 3 || tab.targetType == 4)
          .toList(growable: false);
    }
    return _targetTypeTabs;
  }
}

class _ReportTargetTypeTab {
  final String label;
  final int targetType;

  const _ReportTargetTypeTab(this.label, this.targetType);
}

class _ReportDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReportDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelMedium),
          const SizedBox(height: 4),
          AppSelectableText(value.isEmpty ? '-' : value),
        ],
      ),
    );
  }
}

String _reportTargetText(AdminContentReport report) {
  switch (report.targetType) {
    case 1:
      return '房间 ${_nameOrId(report.targetRoomName, report.targetRoomId)}';
    case 2:
      return '用户 ${_nameOrId(report.targetUsername, report.targetUserId)}';
    case 3:
      final room =
          _nameOrId(report.targetMemberRoomName, report.targetMemberRoomId);
      final user =
          _nameOrId(report.targetMemberUsername, report.targetMemberUserId);
      return '成员 $user · $room';
    case 4:
      final room = _nameOrId(report.roomName, report.roomId);
      return '聊天消息 #${report.targetChatMessageId} · $room';
    default:
      return '未知对象 ${report.id}';
  }
}

String _reporterText(AdminContentReport report) {
  return _nameOrId(report.reporterUsername, report.reporterUserId);
}

String _reportReasonText(AdminContentReport report) {
  if (report.reason.isEmpty) return report.reasonCode;
  if (report.reasonCode.isEmpty) return report.reason;
  return '${report.reasonCode}: ${report.reason}';
}

String _nameOrId(String name, String id) {
  if (name.isEmpty) return id;
  if (id.isEmpty) return name;
  return '$name ($id)';
}

String _reportStatusText(int status) {
  switch (status) {
    case 1:
      return '待处理';
    case 2:
      return '处理中';
    case 3:
      return '已处理';
    case 4:
      return '已驳回';
    default:
      return '未知';
  }
}

IconData _reportStatusIcon(int status) {
  switch (status) {
    case 1:
      return Icons.error_outline_rounded;
    case 2:
      return Icons.pending_actions_rounded;
    case 3:
      return Icons.check_circle_outline_rounded;
    case 4:
      return Icons.cancel_outlined;
    default:
      return Icons.help_outline_rounded;
  }
}

Color _reportStatusColor(int status) {
  switch (status) {
    case 1:
      return Colors.red;
    case 2:
      return Colors.orange;
    case 3:
      return Colors.green;
    case 4:
      return Colors.grey;
    default:
      return Colors.blueGrey;
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
    _loadSettings(refresh: false);
  }

  Future<void> _loadSettings({
    bool silent = false,
    bool refresh = false,
  }) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final groups = await SyncTvService.adminGetAllSettings(refresh: refresh);
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
    await _refreshSelectedGroup(silent: true, refresh: false);
  }

  Future<void> _refreshSelectedGroup({
    bool silent = false,
    bool refresh = true,
  }) async {
    final groupName = _selectedGroup;
    if (groupName == null) return;
    if (!silent) setState(() => _isLoadingGroup = true);
    try {
      final group = await SyncTvService.adminGetSettingsGroup(
        groupName,
        refresh: refresh,
      );
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
      final updated = await SyncTvService.adminUpdateSettingInGroup(
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

    final nextValue = await showAppDialog<dynamic>(
      context: context,
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
    final result = await showAppDialog<_OAuth2ProviderEditResult>(
      context: context,
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
      final message = await SyncTvService.adminSendTestEmail(email);
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
    if (_isLoading) return const AppLoadingIndicator();

    final selected =
        _groups.where((group) => group.name == _selectedGroup).firstOrNull;
    final entries = selected == null
        ? <MapEntry<String, dynamic>>[]
        : (selected.settings.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key)));
    final useTwoPane =
        AppBreakpoints.widthOf(context) >= AppBreakpoints.expandedStart;

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
        ? const AppEmptyMessage(message: '暂无设置')
        : isOAuth2Group
            ? AppListView(
                padding: EdgeInsets.fromLTRB(useTwoPane ? 8 : 16, 0, 16, 24),
                children: [
                  _SettingsGroupHeader(
                    groupName: selected.name,
                    entryCount: oauth2Providers.length,
                    isLoading: _isLoadingGroup,
                    action: AppActionButton(
                      icon: Icons.add_rounded,
                      label: '添加登录提供方',
                      onPressed: _savingSettings.contains('oauth2.providers')
                          ? null
                          : () => _editOAuth2Provider(
                              selected, oauth2Providers, null),
                    ),
                    onRefresh: _isLoadingGroup
                        ? null
                        : () => _refreshSelectedGroup(refresh: true),
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
            : AppListView.builder(
                padding: EdgeInsets.fromLTRB(useTwoPane ? 8 : 16, 0, 16, 24),
                itemCount: entries.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _SettingsGroupHeader(
                      groupName: selected.name,
                      entryCount: entries.length,
                      isLoading: _isLoadingGroup,
                      action: selected.name == 'email'
                          ? AppActionButton(
                              icon: Icons.outgoing_mail,
                              label: '发送测试邮件',
                              onPressed: _sendTestEmail,
                              style: AppActionButtonStyle.tonal,
                            )
                          : null,
                      onRefresh: _isLoadingGroup
                          ? null
                          : () => _refreshSelectedGroup(refresh: true),
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
              AppIconButton(
                tooltip: '刷新全部',
                icon: Icons.sync_rounded,
                style: AppIconButtonStyle.tonal,
                onPressed: _isLoadingGroup
                    ? null
                    : () => _loadSettings(silent: true, refresh: true),
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
                      width: 240,
                      child: AppListView(
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
  final List<String>? permissions;
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
    this.permissions,
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

const List<String> _guestPermissions = [
  'view_member_list',
  'view_chat_history',
  'use_webrtc',
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
    'email.enabled': const _SettingDescriptor(
      group: 'email',
      key: 'enabled',
      title: '启用邮件服务',
      description: '打开后服务端可以发送邮箱绑定、密码重置、MFA 和通知邮件。',
      icon: Icons.outgoing_mail,
      kind: _SettingEditorKind.boolean,
      warning: '启用前请确认 SMTP 主机、发件地址和认证信息正确，否则邮件登录、邮箱绑定、找回密码和通知会不可用。',
    ),
    'email.smtp_host': const _SettingDescriptor(
      group: 'email',
      key: 'smtp_host',
      title: 'SMTP 主机',
      description: '邮件服务器地址。留空表示不配置发信能力。',
      icon: Icons.dns_outlined,
      kind: _SettingEditorKind.text,
    ),
    'email.smtp_port': const _SettingDescriptor(
      group: 'email',
      key: 'smtp_port',
      title: 'SMTP 端口',
      description: '常用端口为 587、465 或 25。',
      icon: Icons.numbers_rounded,
      kind: _SettingEditorKind.number,
    ),
    'email.smtp_username': const _SettingDescriptor(
      group: 'email',
      key: 'smtp_username',
      title: 'SMTP 用户名',
      description: 'SMTP 登录用户名，通常是发件邮箱或服务商生成的账号。',
      icon: Icons.person_outline_rounded,
      kind: _SettingEditorKind.text,
    ),
    'email.smtp_password': const _SettingDescriptor(
      group: 'email',
      key: 'smtp_password',
      title: 'SMTP 密码',
      description: 'SMTP 登录密码或服务商生成的应用专用密码。',
      icon: Icons.password_rounded,
      kind: _SettingEditorKind.text,
      secret: true,
      warning: 'SMTP 密码属于敏感凭据。保存前请确认当前环境和管理员账号可信。',
    ),
    'email.use_tls': const _SettingDescriptor(
      group: 'email',
      key: 'use_tls',
      title: '使用 TLS',
      description: '启用 SMTP TLS/STARTTLS。除本地调试外通常应保持开启。',
      icon: Icons.enhanced_encryption_outlined,
      kind: _SettingEditorKind.boolean,
      warning: '关闭 TLS 可能导致邮件认证信息明文传输，只应在受控内网或调试环境使用。',
    ),
    'email.from_email': const _SettingDescriptor(
      group: 'email',
      key: 'from_email',
      title: '发件邮箱',
      description: '邮件 From 地址。配置 SMTP 时必须是合法邮箱地址。',
      icon: Icons.alternate_email_rounded,
      kind: _SettingEditorKind.text,
    ),
    'email.from_name': const _SettingDescriptor(
      group: 'email',
      key: 'from_name',
      title: '发件人显示名',
      description: '用户收到邮件时看到的发件人名称。',
      icon: Icons.badge_outlined,
      kind: _SettingEditorKind.text,
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
      description: '游客进入房间后的默认权限集合，仅包含服务端定义的游客可用权限。',
      icon: Icons.person_pin_circle_outlined,
      kind: _SettingEditorKind.permissionList,
      permissions: _guestPermissions,
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
    return AppSelect<String>(
      value: selectedGroup,
      label: '设置组',
      prefixIcon: Icons.folder_outlined,
      options: {
        for (final group in groups) _settingsGroupLabel(group.name): group.name,
      },
      enabled: enabled,
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
    return AppInkSurface(
      color: selected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.7)
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
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
          AppIconButton(
            tooltip: '刷新当前组',
            icon: Icons.refresh_rounded,
            loading: isLoading,
            style: AppIconButtonStyle.tonal,
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
          AppIconBadge(
            icon: descriptor.icon,
            color: theme.colorScheme.primary,
            backgroundColor:
                theme.colorScheme.primaryContainer.withValues(alpha: 0.65),
            size: 42,
            borderRadius: BorderRadius.circular(12),
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
              child:
                  AppLoadingIndicator(size: AppLoadingSize.sm, centered: false),
            )
          else if (isBool)
            AppSwitch(
              value: value == true,
              semanticsLabel: descriptor.title,
              onChanged: (_) => onEdit(),
            )
          else
            AppIconButton(
              tooltip: '编辑',
              icon: Icons.edit_outlined,
              style: AppIconButtonStyle.tonal,
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
    return AppInfoBanner(
      icon: Icons.warning_amber_rounded,
      color: Colors.amber.shade900,
      backgroundColor: const Color(0xFFFFF3CD),
      padding: const EdgeInsets.all(10),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(
        color: const Color(0xFFE0A800).withValues(alpha: 0.35),
      ),
      crossAxisAlignment: CrossAxisAlignment.start,
      iconSize: 18,
      title: Text(
        text,
        style:
            theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF6B4E00)),
      ),
    );
  }
}

class _SettingsDialogHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onClose;

  const _SettingsDialogHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      padding: const EdgeInsets.fromLTRB(22, 20, 14, 16),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.38),
      borderRadius: BorderRadius.zero,
      clipBehavior: Clip.none,
      border: Border(
        bottom: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBadge(
            icon: icon,
            color: theme.colorScheme.primary,
            backgroundColor:
                theme.colorScheme.primaryContainer.withValues(alpha: 0.78),
            size: 44,
            borderRadius: BorderRadius.circular(14),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          AppIconButton(
            tooltip: '关闭',
            icon: Icons.close_rounded,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _SettingsDialogActions extends StatelessWidget {
  final String confirmLabel;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const _SettingsDialogActions({
    required this.confirmLabel,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppSafeArea(
      top: false,
      child: AppPanelSurface(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.zero,
        clipBehavior: Clip.none,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: AppActionButton(
                onPressed: onCancel,
                label: '取消',
                style: AppActionButtonStyle.outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppActionButton(
                icon: Icons.check_rounded,
                label: confirmLabel,
                onPressed: onConfirm,
              ),
            ),
          ],
        ),
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
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return AppDialogFrame(
      maxWidth: 780,
      maxHeight: 760,
      insetPadding: EdgeInsets.fromLTRB(16, 24, 16, 24 + bottom),
      borderRadius: const BorderRadius.all(Radius.circular(22)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 780, maxHeight: 760),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SettingsDialogHeader(
                icon: widget.descriptor.icon,
                title: widget.descriptor.title,
                subtitle: widget.descriptor.description,
                onClose: () => Navigator.pop(context),
              ),
              if (widget.descriptor.warning != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 22, 14),
                  child: _InlineWarning(text: widget.descriptor.warning!),
                ),
              Flexible(
                child: AppSingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 4, 22, 22),
                  child: _buildEditor(),
                ),
              ),
              _SettingsDialogActions(
                confirmLabel: '保存',
                onCancel: () => Navigator.pop(context),
                onConfirm: _save,
              ),
            ],
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
          permissions: widget.descriptor.permissions ?? _knownPermissions,
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
        return AppSwitchTile(
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
    return AppTextField(
      controller: controller,
      label: '数值',
      prefixIcon: Icons.pin_outlined,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      label: '内容',
      prefixIcon: Icons.edit_outlined,
      obscureText: widget.secret,
      minLines: widget.secret ? 1 : null,
      maxLines: widget.secret ? 1 : 4,
      autocorrect: false,
      smartDashesType: SmartDashesType.disabled,
      smartQuotesType: SmartQuotesType.disabled,
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
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AppCard(
              padding: EdgeInsets.zero,
              child: AppTile(
                onPressed: () => onChanged(choice.value),
                prefix: Icon(
                  value == choice.value
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                ),
                title: Text(choice.label),
                subtitle: Text(choice.description),
              ),
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
                  child: AppTextField(
                    controller: _controllers[index],
                    label: '${widget.label} ${index + 1}',
                    hintText: widget.hintText,
                    onChanged: (_) => _emit(),
                  ),
                ),
                const SizedBox(width: 8),
                AppIconButton(
                  tooltip: '删除',
                  icon: Icons.remove_rounded,
                  style: AppIconButtonStyle.destructive,
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
          child: AppActionButton(
            icon: Icons.add_rounded,
            label: '添加',
            onPressed: () {
              setState(() => _controllers.add(TextEditingController()));
              _emit();
            },
            style: AppActionButtonStyle.outlined,
          ),
        ),
      ],
    );
  }
}

class _PermissionListSettingEditor extends StatelessWidget {
  final Set<String> values;
  final List<String> permissions;
  final ValueChanged<Set<String>> onChanged;

  const _PermissionListSettingEditor({
    required this.values,
    required this.permissions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final permission in permissions)
          AppChip(
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
          child: AppActionButton(
            icon: Icons.add_rounded,
            label: '添加登录提供方',
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
    final result = await showAppDialog<_OAuth2ProviderEditResult>(
      context: context,
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
            child: AppLinearProgress(),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
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
            AppIconButton(
              tooltip: '编辑',
              icon: Icons.edit_outlined,
              onPressed: onEdit,
            ),
            AppIconButton(
              tooltip: '删除',
              icon: Icons.delete_outline_rounded,
              style: AppIconButtonStyle.destructive,
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
    return AppBadge(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      borderRadius: BorderRadius.circular(999),
      icon: icon,
      iconSize: 14,
      color: theme.colorScheme.onSecondaryContainer,
      backgroundColor:
          theme.colorScheme.secondaryContainer.withValues(alpha: 0.7),
      label: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSecondaryContainer,
        ),
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
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return AppDialogFrame(
      maxWidth: 740,
      maxHeight: 760,
      insetPadding: EdgeInsets.fromLTRB(16, 24, 16, 24 + bottom),
      borderRadius: const BorderRadius.all(Radius.circular(22)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 740, maxHeight: 760),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _SettingsDialogHeader(
                icon: Icons.login_rounded,
                title: widget.initialName == null ? '添加第三方登录' : '编辑第三方登录',
                subtitle: '配置 OAuth2/OIDC 登录实例、回调地址和注册策略。',
                onClose: () => Navigator.pop(context),
              ),
              Flexible(
                child: AppSingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _name,
                        label: '实例名称',
                        helperText: '只能使用字母、数字、下划线和连字符',
                        prefixIcon: Icons.badge_outlined,
                        validator: _validateProviderName,
                        autocorrect: false,
                        smartDashesType: SmartDashesType.disabled,
                        smartQuotesType: SmartQuotesType.disabled,
                      ),
                      const SizedBox(height: 12),
                      AppSelect<String>(
                        value: _type,
                        label: '提供方类型',
                        prefixIcon: Icons.account_tree_outlined,
                        options: {
                          for (final type in _oauth2ProviderTypes)
                            _oauth2ProviderTypeLabels[type] ?? type: type,
                        },
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
                        _clientId,
                        'Client ID',
                        Icons.key_outlined,
                        required: true,
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _clientSecret,
                        label: 'Client Secret',
                        prefixIcon: Icons.password_outlined,
                        obscureText: true,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? '请输入 Client Secret'
                                : null,
                        autocorrect: false,
                        smartDashesType: SmartDashesType.disabled,
                        smartQuotesType: SmartQuotesType.disabled,
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
                          _authUrl,
                          '授权端点',
                          Icons.open_in_browser_rounded,
                          hintText: '留空使用 OIDC Discovery',
                          validator: _validateOptionalHttpUrl,
                        ),
                        const SizedBox(height: 12),
                        _oauthTextField(
                          _tokenUrl,
                          'Token 端点',
                          Icons.token_outlined,
                          hintText: '留空使用 OIDC Discovery',
                          validator: _validateOptionalHttpUrl,
                        ),
                        const SizedBox(height: 12),
                        _oauthTextField(
                          _userinfoUrl,
                          'UserInfo 端点',
                          Icons.person_search_outlined,
                          hintText: '留空使用 OIDC Discovery',
                          validator: _validateOptionalHttpUrl,
                        ),
                        const SizedBox(height: 12),
                        _oauthTextField(
                          _jwksUrl,
                          'JWKS 端点',
                          Icons.security_rounded,
                          hintText: '留空使用 OIDC Discovery',
                          validator: _validateOptionalHttpUrl,
                        ),
                      ],
                      const SizedBox(height: 8),
                      AppSwitchTile(
                        value: _enableSignup,
                        onChanged: (value) =>
                            setState(() => _enableSignup = value),
                        title: const Text('允许用此提供方注册'),
                        subtitle: const Text('关闭后只允许绑定过的用户登录。'),
                      ),
                      AppSwitchTile(
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
              _SettingsDialogActions(
                confirmLabel: '保存实例',
                onCancel: () => Navigator.pop(context),
                onConfirm: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _oauthTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool required = false,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    return AppTextField(
      controller: controller,
      label: label,
      hintText: hintText,
      prefixIcon: icon,
      validator: validator ??
          (required
              ? (value) =>
                  (value == null || value.trim().isEmpty) ? '请输入 $label' : null
              : null),
      autocorrect: false,
      smartDashesType: SmartDashesType.disabled,
      smartQuotesType: SmartQuotesType.disabled,
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
          child: AppActionButton(
            icon: Icons.add_rounded,
            label: '添加 ICE 服务器',
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
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
                AppIconButton(
                  tooltip: '删除',
                  icon: Icons.delete_outline_rounded,
                  style: AppIconButtonStyle.destructive,
                  onPressed: widget.onDelete,
                ),
              ],
            ),
            AppTextField(
              controller: _urls,
              label: 'URL',
              helperText: '每行一个，例如 stun:host:3478 或 turns:host:5349',
              prefixIcon: Icons.link_rounded,
              minLines: 1,
              maxLines: 4,
              onChanged: (_) => _emit(),
              autocorrect: false,
              smartDashesType: SmartDashesType.disabled,
              smartQuotesType: SmartQuotesType.disabled,
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
            AppTextField(
              controller: _username,
              label: '用户名',
              prefixIcon: Icons.person_outline_rounded,
              onChanged: (_) => _emit(),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _credential,
              label: '凭据',
              prefixIcon: Icons.password_outlined,
              obscureText: true,
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
      return AppSwitchTile(
        value: value,
        onChanged: widget.onChanged,
        title: Text(_humanizeSettingKey(widget.name)),
      );
    }
    return AppTextField(
      controller: _controller,
      label: _humanizeSettingKey(widget.name),
      obscureText: _isSecretKey(widget.name),
      keyboardType: value is num ? TextInputType.number : TextInputType.text,
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
    return AppEmptyState(
      icon: icon,
      title: title,
      subtitle: message,
      padding: const EdgeInsets.all(18),
      iconSize: 32,
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
    return AppPanelSurface(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? Colors.grey.shade900 : Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
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
    final total = this.total;
    final label = total == null
        ? '第 $page 页 · 每页 $pageSize'
        : '第 $page 页 · 每页 $pageSize · 共 $total 条';
    return AppPaginationBar(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      label: label,
      onPrevious: onPrevious,
      onNext: onNext,
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
            child: AppSelectableText(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomCoverPreview extends StatelessWidget {
  const _RoomCoverPreview({required this.room});

  final SyncTvRoom room;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fallback = ColoredBox(
      color: theme.colorScheme.primary.withValues(alpha: 0.12),
      child: Icon(
        Icons.meeting_room_outlined,
        color: theme.colorScheme.primary,
      ),
    );
    if (room.coverUrl.isEmpty) {
      return AppPanelSurface(
        width: 96,
        height: 64,
        borderRadius: BorderRadius.circular(8),
        child: fallback,
      );
    }
    return AppImageThumbnail(
      url: SyncTvService.resolveResourceUrl(room.coverUrl),
      width: 96,
      height: 64,
      borderRadius: BorderRadius.circular(8),
      errorChild: fallback,
    );
  }
}

class _RoomChatHistoryDialog extends StatefulWidget {
  const _RoomChatHistoryDialog({required this.room});

  final SyncTvRoom room;

  @override
  State<_RoomChatHistoryDialog> createState() => _RoomChatHistoryDialogState();
}

class _RoomChatHistoryDialogState extends State<_RoomChatHistoryDialog> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, RoomChatMessageInfo> _messageIndex = {};
  final List<RoomChatMessageInfo> _messages = [];
  bool _loading = true;
  bool _loadingMore = false;
  String _nextCursor = '';
  String? _highlightedMessageId;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    setState(() {
      _loading = true;
      _messages.clear();
      _messageIndex.clear();
      _nextCursor = '';
    });
    await _loadPage(cursor: '');
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _loadMore() async {
    if (_nextCursor.isEmpty || _loadingMore) return;
    setState(() => _loadingMore = true);
    await _loadPage(cursor: _nextCursor);
    if (mounted) setState(() => _loadingMore = false);
  }

  Future<void> _loadPage({required String cursor}) async {
    try {
      final page = await SyncTvService.getChatHistory(
        widget.room.roomId,
        limit: 40,
        cursor: cursor,
      );
      if (!mounted) return;
      setState(() {
        for (final message in page.messages) {
          if (!_messageIndex.containsKey(message.id)) {
            _messages.add(message);
          }
          _messageIndex[message.id] = message;
        }
        _nextCursor = page.nextCursor;
      });
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, '加载聊天历史失败: $e');
    }
  }

  Future<void> _copyMessage(RoomChatMessageInfo message) async {
    final text = _messagePreview(message).trim();
    if (text.isEmpty) {
      MessageUtils.showInfo(context, '这条消息没有可复制内容');
      return;
    }
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) MessageUtils.showSuccess(context, '消息已复制');
  }

  Future<void> _deleteMessage(RoomChatMessageInfo message) async {
    if (message.id.isEmpty) return;
    final confirmed = await showAppDialog<bool>(
      context: context,
      builder: (context) => AppConfirmDialog(
        title: '删除消息',
        icon: const Icon(Icons.delete_outline_rounded),
        content: Text('删除 ${message.username} 的这条消息。'),
        confirmLabel: '删除',
        confirmIcon: Icons.delete_outline_rounded,
        destructive: true,
        onConfirm: () => Navigator.pop(context, true),
      ),
    );
    if (confirmed != true) return;
    try {
      final updated = await SyncTvService.deleteChatMessage(
        widget.room.roomId,
        message.id,
        expectedVersion: message.version,
        reason: 'admin_deleted',
      );
      if (!mounted) return;
      setState(() {
        final index = _messages.indexWhere((entry) => entry.id == message.id);
        if (index >= 0) _messages[index] = updated;
        _messageIndex[updated.id] = updated;
      });
      MessageUtils.showSuccess(context, '消息已删除');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '删除消息失败: $e');
    }
  }

  Future<void> _reportMessage(RoomChatMessageInfo message) async {
    if (message.id.isEmpty) return;
    const reasons = <String, String>{
      'spam': '垃圾广告',
      'abuse': '辱骂骚扰',
      'illegal': '违法违规',
      'sexual': '低俗色情',
      'other': '其他问题',
    };
    var selectedReason = 'spam';
    final detailController = TextEditingController();
    final submitted = await showAppDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AppDialog(
              title: const Text('举报消息'),
              icon: const Icon(Icons.flag_outlined),
              body: SizedBox(
                width: 380,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: reasons.entries
                          .map(
                            (entry) => ChoiceChip(
                              label: Text(entry.value),
                              selected: selectedReason == entry.key,
                              onSelected: (_) => setDialogState(
                                () => selectedReason = entry.key,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      controller: detailController,
                      label: '补充说明',
                      hintText: '描述具体问题',
                      minLines: 3,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
              actions: [
                AppActionButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  icon: Icons.flag_outlined,
                  label: '提交',
                ),
                _closeButton(dialogContext),
              ],
            );
          },
        );
      },
    );
    try {
      if (submitted != true) return;
      await SyncTvService.reportChatMessage(
        widget.room.roomId,
        message.id,
        reasonCode: selectedReason,
        reason: detailController.text,
      );
      if (mounted) MessageUtils.showSuccess(context, '举报已提交');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '举报失败: $e');
    } finally {
      detailController.dispose();
    }
  }

  Future<void> _showContext(RoomChatMessageInfo message) async {
    try {
      final contextInfo = await SyncTvService.getChatMessageContext(
        widget.room.roomId,
        message.id,
        beforeLimit: 8,
        afterLimit: 8,
        includeDeleted: true,
      );
      if (!mounted) return;
      await showAppDialog<void>(
        context: context,
        builder: (_) => _RoomChatContextDialog(
          room: widget.room,
          contextInfo: contextInfo,
          onCopy: _copyMessage,
          onDelete: _deleteMessage,
          onReport: _reportMessage,
        ),
      );
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载消息上下文失败: $e');
    }
  }

  void _jumpToReply(RoomChatMessageInfo message) {
    final replyId = message.replyToMessageId;
    if (replyId.isEmpty) return;
    final index = _messages.indexWhere((entry) => entry.id == replyId);
    if (index < 0) {
      _showContext(message);
      return;
    }
    _scrollController.animateTo(
      index * 118.0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
    setState(() => _highlightedMessageId = replyId);
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted || _highlightedMessageId != replyId) return;
      setState(() => _highlightedMessageId = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppDialogFrame(
      maxWidth: 920,
      maxHeight: MediaQuery.sizeOf(context).height * 0.88,
      child: AppPanelSurface(
        color: theme.colorScheme.surface,
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppDialogHeader(
              icon: Icons.forum_outlined,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('聊天历史'),
                  Text(
                    widget.room.roomName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              onClose: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Row(
                children: [
                  AppBadge(
                    icon: Icons.message_outlined,
                    label: Text('${_messages.length} 条已加载'),
                  ),
                  const SizedBox(width: 8),
                  if (_nextCursor.isNotEmpty)
                    const AppBadge(
                      icon: Icons.more_horiz_rounded,
                      label: Text('还有更早消息'),
                    ),
                  const Spacer(),
                  AppIconButton(
                    tooltip: '刷新',
                    icon: Icons.refresh_rounded,
                    onPressed: _loadInitial,
                  ),
                ],
              ),
            ),
            Flexible(
              child: SizedBox(
                height: 620,
                child: _loading
                    ? const AppLoadingIndicator()
                    : _messages.isEmpty
                        ? const AppEmptyMessage(message: '暂无聊天消息')
                        : AppListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                            itemCount: _messages.length +
                                (_nextCursor.isEmpty ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index >= _messages.length) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: AppActionButton(
                                      onPressed:
                                          _loadingMore ? null : _loadMore,
                                      icon: Icons.history_rounded,
                                      label: _loadingMore ? '加载中' : '加载更早消息',
                                      style: AppActionButtonStyle.outlined,
                                    ),
                                  ),
                                );
                              }
                              final message = _messages[index];
                              return _AdminChatMessageCard(
                                message: message,
                                quoted: _messageIndex[message.replyToMessageId],
                                highlighted:
                                    _highlightedMessageId == message.id,
                                onCopy: () => _copyMessage(message),
                                onDelete: () => _deleteMessage(message),
                                onReport: () => _reportMessage(message),
                                onContext: () => _showContext(message),
                                onJumpToReply: () => _jumpToReply(message),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomChatContextDialog extends StatelessWidget {
  const _RoomChatContextDialog({
    required this.room,
    required this.contextInfo,
    required this.onCopy,
    required this.onDelete,
    required this.onReport,
  });

  final SyncTvRoom room;
  final ChatMessageContextInfo contextInfo;
  final Future<void> Function(RoomChatMessageInfo message) onCopy;
  final Future<void> Function(RoomChatMessageInfo message) onDelete;
  final Future<void> Function(RoomChatMessageInfo message) onReport;

  @override
  Widget build(BuildContext context) {
    final messages = [
      ...contextInfo.before,
      contextInfo.message,
      ...contextInfo.after,
    ];
    return AppDialogFrame(
      maxWidth: 760,
      maxHeight: MediaQuery.sizeOf(context).height * 0.78,
      child: AppPanelSurface(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppDialogHeader(
              icon: Icons.manage_search_rounded,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('消息上下文'),
                  Text(
                    room.roomName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              onClose: () => Navigator.pop(context),
            ),
            Flexible(
              child: AppListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return _AdminChatMessageCard(
                    message: message,
                    highlighted: message.id == contextInfo.message.id,
                    onCopy: () => onCopy(message),
                    onDelete: () => onDelete(message),
                    onReport: () => onReport(message),
                    onContext: null,
                    onJumpToReply: null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminChatMessageCard extends StatelessWidget {
  const _AdminChatMessageCard({
    required this.message,
    this.quoted,
    this.highlighted = false,
    required this.onCopy,
    required this.onDelete,
    required this.onReport,
    this.onContext,
    this.onJumpToReply,
  });

  final RoomChatMessageInfo message;
  final RoomChatMessageInfo? quoted;
  final bool highlighted;
  final VoidCallback onCopy;
  final VoidCallback onDelete;
  final VoidCallback onReport;
  final VoidCallback? onContext;
  final VoidCallback? onJumpToReply;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDeleted = message.isDeleted;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: highlighted
            ? scheme.primary.withValues(alpha: 0.10)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AppPanelSurface(
        color: isDeleted
            ? scheme.errorContainer.withValues(alpha: 0.16)
            : scheme.surfaceContainerHighest.withValues(alpha: 0.52),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: highlighted
              ? scheme.primary.withValues(alpha: 0.36)
              : scheme.outlineVariant.withValues(alpha: 0.64),
        ),
        padding: const EdgeInsets.all(11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppAvatar(
                  name: message.username,
                  radius: 15,
                  backgroundColor: scheme.primary.withValues(alpha: 0.10),
                  foregroundColor: scheme.primary,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.username.isEmpty ? '已删除用户' : message.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${message.userId.isEmpty ? '匿名' : message.userId} · ${_formatTimestamp(message.timestamp)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (message.isEdited && !isDeleted)
                  const AppBadge(
                    icon: Icons.edit_outlined,
                    label: Text('已编辑'),
                  ),
                if (isDeleted)
                  AppBadge(
                    icon: Icons.delete_outline_rounded,
                    label: const Text('已删除'),
                    color: scheme.error,
                    backgroundColor: scheme.errorContainer.withValues(
                      alpha: 0.32,
                    ),
                  ),
              ],
            ),
            if (message.replyToMessageId.isNotEmpty) ...[
              const SizedBox(height: 9),
              _AdminQuotedMessage(
                messageId: message.replyToMessageId,
                quoted: quoted,
                onTap: onJumpToReply,
              ),
            ],
            if (message.content.trim().isNotEmpty) ...[
              const SizedBox(height: 9),
              Text(
                isDeleted ? '这条消息已删除' : message.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDeleted ? scheme.onSurfaceVariant : scheme.onSurface,
                  height: 1.34,
                ),
              ),
            ],
            if (message.images.isNotEmpty) ...[
              const SizedBox(height: 10),
              _AdminChatImageGrid(images: message.images),
            ],
            if (message.reactions.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: topChatReactions(message.reactions, limit: 8)
                    .map(
                      (reaction) => AppBadge(
                        label: Text('${reaction.key} ${reaction.count}'),
                        color: reaction.reactedByMe
                            ? scheme.primary
                            : scheme.onSurfaceVariant,
                        backgroundColor: reaction.reactedByMe
                            ? scheme.primary.withValues(alpha: 0.12)
                            : scheme.surface.withValues(alpha: 0.64),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                AppActionButton(
                  onPressed: onCopy,
                  icon: Icons.copy_rounded,
                  label: '复制',
                  size: AppActionButtonSize.sm,
                  style: AppActionButtonStyle.text,
                ),
                if (onContext != null)
                  AppActionButton(
                    onPressed: onContext,
                    icon: Icons.manage_search_rounded,
                    label: '上下文',
                    size: AppActionButtonSize.sm,
                    style: AppActionButtonStyle.text,
                  ),
                AppActionButton(
                  onPressed: onReport,
                  icon: Icons.flag_outlined,
                  label: '举报',
                  size: AppActionButtonSize.sm,
                  style: AppActionButtonStyle.text,
                ),
                AppActionButton(
                  onPressed: isDeleted ? null : onDelete,
                  icon: Icons.delete_outline_rounded,
                  label: '删除',
                  size: AppActionButtonSize.sm,
                  style: AppActionButtonStyle.destructive,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminQuotedMessage extends StatelessWidget {
  const _AdminQuotedMessage({
    required this.messageId,
    required this.quoted,
    this.onTap,
  });

  final String messageId;
  final RoomChatMessageInfo? quoted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final title =
        quoted?.username.trim().isNotEmpty == true ? quoted!.username : '引用消息';
    final preview = quoted == null ? '点击查看上下文' : _messagePreview(quoted!);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: AppPanelSurface(
        color: scheme.surface.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.22)),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        child: Row(
          children: [
            Container(
              width: 3,
              height: 34,
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    preview.isEmpty ? messageId : preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
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
}

class _AdminChatImageGrid extends StatelessWidget {
  const _AdminChatImageGrid({required this.images});

  final List<StoredImageInfo> images;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: images.map((image) {
        final url = SyncTvService.resolveResourceUrl(image.url);
        return AppImageThumbnail(
          url: url,
          width: 116,
          height: 86,
          borderRadius: BorderRadius.circular(7),
          errorChild: ColoredBox(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.8),
            child: const Icon(Icons.broken_image_outlined),
          ),
        );
      }).toList(),
    );
  }
}

String _messagePreview(RoomChatMessageInfo message) {
  final parts = <String>[];
  if (message.content.trim().isNotEmpty) parts.add(message.content.trim());
  if (message.images.isNotEmpty) parts.add('[图片 ${message.images.length}]');
  final reactionSuffix = chatReactionSummarySuffix(message.reactions, limit: 2);
  if (reactionSuffix.isNotEmpty) parts.add(reactionSuffix.trim());
  return parts.join(' ');
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
  return AppActionButton(
    onPressed: () => Navigator.pop(context),
    label: '关闭',
    style: AppActionButtonStyle.text,
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
