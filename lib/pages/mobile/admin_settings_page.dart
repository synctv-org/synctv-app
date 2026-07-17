import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/l10n/l10n.dart';
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

  const _AdminToolbarItem({required this.child, required this.width});
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
  'directUrl': 'Direct URL',
  'alist': 'AList',
  'emby': 'Emby',
  'bilibili': 'Bilibili',
  'rtmp': 'RTMP',
  'cloudreve': 'Cloudreve',
  'twitch': 'Twitch',
  'youtube': 'YouTube',
  'douyin': 'Douyin',
  'tiktok': 'TikTok',
  'huya': 'Huya',
  'douyu': 'Douyu',
  'acfun': 'AcFun',
  'cctv': 'CCTV',
  'fnos': 'FNOS',
  'qnap': 'QNAP',
  'liveProxy': 'Live Proxy',
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
  static const int _sectionCount = 11;

  List<_AdminSection> get _sections => [
    _AdminSection(
      label: context.l10n.overview,
      icon: Icons.dashboard_rounded,
      page: const AdminOverviewTab(),
    ),
    _AdminSection(
      label: context.l10n.administrators,
      icon: Icons.admin_panel_settings_rounded,
      page: const AdminAdminsTab(),
    ),
    _AdminSection(
      label: context.l10n.rooms,
      icon: Icons.meeting_room_rounded,
      page: const RoomManagementTab(),
    ),
    _AdminSection(
      label: context.l10n.categoriesAndLabels,
      icon: Icons.category_rounded,
      page: const AdminRoomTaxonomyTab(),
    ),
    _AdminSection(
      label: context.l10n.users,
      icon: Icons.people_alt_rounded,
      page: const UserManagementTab(),
    ),
    _AdminSection(
      label: context.l10n.review,
      icon: Icons.fact_check_rounded,
      page: const AdminReviewTab(),
    ),
    _AdminSection(
      label: context.l10n.reports,
      icon: Icons.report_gmailerrorred_rounded,
      page: const AdminContentReportsTab(),
    ),
    const _AdminSection(
      label: 'Provider',
      icon: Icons.hub_rounded,
      page: AdminProviderTab(),
    ),
    _AdminSection(
      label: context.l10n.streaming,
      icon: Icons.podcasts_rounded,
      page: const AdminStreamsTab(),
    ),
    _AdminSection(
      label: context.l10n.bans,
      icon: Icons.gavel_rounded,
      page: const AdminBanRecordsTab(),
    ),
    _AdminSection(
      label: context.l10n.settings,
      icon: Icons.tune_rounded,
      page: const RuntimeSettingsSectionsTab(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _sectionCount, vsync: this);
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

    final systemUiOverlayStyle = isDark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: AppScaffold(
        backgroundColor: isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF7F7FC),
        appBar: AppAppBar(
          title: Text(
            context.l10n.adminSettings,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: isDark
              ? const Color(0xFF121212)
              : const Color(0xFFF7F7FC),
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
                        context.l10n.systemManagement,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.68,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AppListView.separated(
                        itemCount: _sections.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 4),
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
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.10,
                        ),
                      ),
                      labelColor: theme.colorScheme.primary,
                      unselectedLabelColor: theme.colorScheme.onSurface
                          .withValues(alpha: 0.62),
                      labelStyle: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: theme.textTheme.labelMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                      tabs: _sections
                          .map(
                            (section) => Tab(
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
                            ),
                          )
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
                  : theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.42,
                    ),
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
                        fontWeight: selected
                            ? FontWeight.w800
                            : FontWeight.w600,
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
    final foreground = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;
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
  AdminServiceState? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final stats = await SyncTvService.adminGetServiceState();
      if (!mounted) return;
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      MessageUtils.showError(context, context.l10n.loadOverviewFailed('$e'));
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
            AppEmptyMessage(message: context.l10n.noStatistics)
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _StatTile(
                  context.l10n.users,
                  stats.totalUsers,
                  Icons.people_alt_rounded,
                  Colors.blue,
                  isDark,
                ),
                _StatTile(
                  context.l10n.activeUsers,
                  stats.activeUsers,
                  Icons.person_pin_circle_rounded,
                  Colors.green,
                  isDark,
                ),
                _StatTile(
                  context.l10n.onlineUsers,
                  stats.onlineUsers,
                  Icons.online_prediction_rounded,
                  Colors.lightGreen,
                  isDark,
                ),
                _StatTile(
                  context.l10n.onlineConnectionsLabel,
                  stats.onlineConnections,
                  Icons.link_rounded,
                  Colors.cyan,
                  isDark,
                ),
                _StatTile(
                  context.l10n.bannedUsers,
                  stats.bannedUsers,
                  Icons.block_rounded,
                  Colors.red,
                  isDark,
                ),
                _StatTile(
                  context.l10n.rooms,
                  stats.totalRooms,
                  Icons.meeting_room_rounded,
                  Colors.indigo,
                  isDark,
                ),
                _StatTile(
                  context.l10n.activeRooms,
                  stats.activeRooms,
                  Icons.sensors_rounded,
                  Colors.teal,
                  isDark,
                ),
                _StatTile(
                  context.l10n.onlineRooms,
                  stats.activePresenceRooms,
                  Icons.wifi_tethering_rounded,
                  Colors.blueGrey,
                  isDark,
                ),
                _StatTile(
                  context.l10n.media,
                  stats.totalMedia,
                  Icons.video_library_rounded,
                  Colors.deepPurple,
                  isDark,
                ),
                _StatTile(
                  'Provider',
                  stats.providerInstances,
                  Icons.hub_rounded,
                  Colors.orange,
                  isDark,
                ),
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
      MessageUtils.showError(
        context,
        context.l10n.loadAdministratorsFailed('$e'),
      );
    }
  }

  Future<void> _addAdmin() async {
    final mode = await ChatUtils.showStyledDialog<String>(
      context: context,
      title: context.l10n.addAdministrator,
      icon: const Icon(
        Icons.admin_panel_settings_rounded,
        color: Color(0xFF5D5FEF),
      ),
      content: SizedBox(
        width: 420,
        child: Text(context.l10n.addAdministratorDescription),
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        AppActionButton(
          onPressed: () => Navigator.pop(context, 'existing'),
          icon: Icons.person_search_rounded,
          label: context.l10n.promoteExistingUser,
          style: AppActionButtonStyle.tonal,
        ),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, 'new'),
          text: context.l10n.createAdministrator,
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
      title: context.l10n.addAdministrator,
      icon: const Icon(
        Icons.admin_panel_settings_rounded,
        color: Color(0xFF5D5FEF),
      ),
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
                label: context.l10n.username,
                controller: usernameController,
                hintText: context.l10n.usernameRequired,
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              ChatUtils.createFormField(
                context: dialogContext,
                label: context.l10n.password,
                controller: passwordController,
                hintText: context.l10n.passwordRequired,
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
          text: context.l10n.add,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      final username = usernameController.text.trim();
      final password = passwordController.text;
      if (username.isEmpty || password.isEmpty) {
        if (!mounted) return;
        MessageUtils.showWarning(
          context,
          context.l10n.usernameAndPasswordRequired,
        );
        return;
      }
      await SyncTvService.adminAddUser(
        username,
        password,
        common_enum.UserRole.USER_ROLE_ADMIN.value,
      );
      if (!mounted) return;
      MessageUtils.showSuccess(context, context.l10n.administratorAdded);
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, context.l10n.addFailed('$e'));
    }
  }

  Future<void> _promoteExistingUser() async {
    final userIdController = TextEditingController();
    var disposeScheduled = false;
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: context.l10n.promoteExistingUser,
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
              label: context.l10n.userId,
              controller: userIdController,
              hintText: context.l10n.existingUserIdRequired,
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
          text: context.l10n.promote,
        ),
      ],
    );
    if (confirmed != true) return;
    final userId = userIdController.text.trim();
    if (userId.isEmpty) {
      if (!mounted) return;
      MessageUtils.showWarning(context, context.l10n.userIdRequired);
      return;
    }
    try {
      await SyncTvService.adminAddAdmin(userId);
      if (!mounted) return;
      MessageUtils.showSuccess(context, context.l10n.administratorAdded);
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, context.l10n.addFailed('$e'));
    }
  }

  Future<void> _removeAdmin(SyncTvUser user) async {
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: context.l10n.removeAdministrator,
      icon: const Icon(Icons.remove_moderator_outlined, color: Colors.red),
      content: Text(context.l10n.confirmRemoveAdmin(user.username)),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.remove,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      await SyncTvService.adminRemoveAdmin(user.id);
      if (!mounted) return;
      MessageUtils.showSuccess(context, context.l10n.administratorRemoved);
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, context.l10n.removeFailed('$e'));
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
                  title: Text(context.l10n.administrators),
                  subtitle: Text(context.l10n.administratorCount(_adminTotal)),
                  suffix: AppIconButton(
                    tooltip: context.l10n.addAdministrator,
                    icon: Icons.add_moderator_outlined,
                    onPressed: _addAdmin,
                  ),
                ),
                AppDivider(
                  height: 1,
                  color: theme.dividerColor.withValues(alpha: 0.08),
                ),
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
                          hintText: context.l10n.searchAdministrators,
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
                        options: {
                          context.l10n.createdAt: admin_enum
                              .UserListSortBy
                              .USER_LIST_SORT_BY_CREATED_AT,
                          context.l10n.updatedAt: admin_enum
                              .UserListSortBy
                              .USER_LIST_SORT_BY_UPDATED_AT,
                          context.l10n.username: admin_enum
                              .UserListSortBy
                              .USER_LIST_SORT_BY_USERNAME,
                          context.l10n.email:
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
                        tooltip:
                            _adminSortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? context.l10n.descending
                            : context.l10n.ascending,
                        icon:
                            _adminSortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? Icons.south_rounded
                            : Icons.north_rounded,
                        onPressed: () {
                          setState(() {
                            _adminSortDirection =
                                _adminSortDirection ==
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
                        options: {
                          context.l10n.itemsPerPage(20): 20,
                          context.l10n.itemsPerPage(50): 50,
                          context.l10n.itemsPerPage(100): 100,
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
                        tooltip: context.l10n.refresh,
                        icon: Icons.refresh_rounded,
                        onPressed: () => _load(silent: true),
                      ),
                    ],
                  ),
                ),
                if (_admins.isEmpty)
                  AppEmptyMessage(message: context.l10n.noAdministrators)
                else
                  for (final admin in _admins)
                    Builder(
                      builder: (context) {
                        final removeDisabledReason = _adminRemoveDisabledReason(
                          admin,
                        );
                        return AppTile(
                          prefix: AppAvatar(name: admin.username),
                          title: Text(admin.username),
                          subtitle: Text(admin.id),
                          suffix: AppIconButton(
                            tooltip:
                                removeDisabledReason ??
                                context.l10n.removeAdministrator,
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
                  label: context.l10n.pageOf(_adminPage, _adminPageCount),
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
      return context.l10n.cannotRemoveCurrentAdministrator;
    }
    if (_adminTotal <= 1) {
      return context.l10n.keepAtLeastOneAdministrator;
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
        MessageUtils.showError(context, context.l10n.loadRoomsFailed('$e'));
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
        SyncTvService.adminListRoomLabels(includeDisabled: true, refresh: true),
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
      title: context.l10n.filterLabels,
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
                      _categoryFilter.isEmpty
                          ? context.l10n.noLabelsAvailable
                          : context.l10n.noLabelsForCategory,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: labels
                          .map((label) {
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
                          })
                          .toList(growable: false),
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
          label: context.l10n.clear,
          style: AppActionButtonStyle.tonal,
        ),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.apply,
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
    final action = ban ? context.l10n.ban : context.l10n.unban;
    final reasonController = TextEditingController();
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: context.l10n.roomAction(action),
      icon: Icon(
        ban ? Icons.block : Icons.check_circle,
        color: ban ? Colors.red : Colors.green,
      ),
      content: ban
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.l10n.confirmRoomAction(action, room.roomName)),
                const SizedBox(height: 12),
                ChatUtils.createFormField(
                  context: context,
                  label: context.l10n.banReason,
                  controller: reasonController,
                  hintText: context.l10n.optional,
                  prefixIcon: Icons.edit_note_rounded,
                ),
              ],
            )
          : Text(context.l10n.confirmRoomAction(action, room.roomName)),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: action,
        ),
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
        MessageUtils.showSuccess(context, context.l10n.operationSucceeded);
        _loadRooms(silent: true);
      } catch (e) {
        if (!mounted) return;
        MessageUtils.showError(context, context.l10n.operationFailed('$e'));
      }
    }
  }

  Future<void> _deleteRoom(SyncTvRoom room) async {
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: context.l10n.deleteRoom,
      icon: const Icon(Icons.delete_forever, color: Colors.red),
      content: _destructiveDialogContent(
        context.l10n.permanentlyDeleteRoom(room.roomName),
        [
          context.l10n.allMembersLoseAccess,
          context.l10n.roomDataWillBeCleared,
          context.l10n.watchingMembersWillExit,
        ],
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.delete,
        ),
      ],
    );

    if (confirm == true) {
      try {
        await SyncTvService.adminDeleteRoom(room.roomId);
        if (!mounted) return;
        MessageUtils.showSuccess(context, context.l10n.roomDeleted);
        _loadRooms(silent: true);
      } catch (e) {
        if (!mounted) return;
        MessageUtils.showError(context, context.l10n.deleteEntryFailed('$e'));
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
      title: context.l10n.batchBanRooms,
      icon: const Icon(Icons.block_rounded, color: Colors.redAccent),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.roomsWillBeBanned(_selectedRoomIds.length)),
          const SizedBox(height: 12),
          ChatUtils.createFormField(
            context: context,
            label: context.l10n.banReason,
            controller: reasonController,
            hintText: context.l10n.optional,
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
          text: context.l10n.ban,
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
      _showBatchResult(context.l10n.batchBanCompleted, result);
      setState(_selectedRoomIds.clear);
      _loadRooms(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, context.l10n.batchBanFailed('$e'));
    }
  }

  Future<void> _batchDeleteRooms() async {
    if (_selectedRoomIds.isEmpty) return;
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: context.l10n.batchDeleteRooms,
      icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
      content: _destructiveDialogContent(
        context.l10n.roomsWillBeDeleted(_selectedRoomIds.length),
        [
          context.l10n.relatedMembersLoseAccess,
          context.l10n.roomDataWillBeCleared,
          context.l10n.batchDeleteBackupOnly,
        ],
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.delete,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      final result = await SyncTvService.adminBatchDeleteRooms(
        _selectedRoomIds.toList(),
      );
      if (!mounted) return;
      _showBatchResult(context.l10n.batchDeleteCompleted, result);
      setState(_selectedRoomIds.clear);
      _loadRooms(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, context.l10n.batchDeleteFailed('$e'));
    }
  }

  void _showBatchResult(String title, AdminBatchOperationResult result) {
    final failedItems = result.results.where((item) => !item.success).toList();
    final message = failedItems.isEmpty
        ? context.l10n.batchResultSuccess(title, result.succeeded)
        : context.l10n.batchResultMixed(title, result.succeeded, result.failed);
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
                Expanded(child: Text(impact, style: theme.textTheme.bodySmall)),
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
        title: context.l10n.roomInformation,
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
                                style: Theme.of(context).textTheme.titleMedium
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
                            context.l10n.creator,
                            '${detail.creator} (${detail.creatorId})',
                          ),
                        ),
                      ],
                    ),
                    if (detail.description.isNotEmpty)
                      _InfoLine(context.l10n.description, detail.description),
                    if (detail.category != null)
                      _InfoLine(
                        context.l10n.category,
                        _roomCategoryDisplay(detail.category!),
                      ),
                    if (detail.labels.isNotEmpty)
                      _InfoLine(
                        context.l10n.labels,
                        detail.labels.map(_roomLabelDisplay).join('、'),
                      ),
                    _InfoLine(
                      context.l10n.memberCountLabel,
                      detail.memberCount.toString(),
                    ),
                    _InfoLine(context.l10n.status, _roomStatusLabel(detail)),
                    _InfoLine(
                      context.l10n.creatorStatus,
                      _userStatusText(context, detail.creatorStatus),
                    ),
                    _InfoLine(
                      context.l10n.resourceAvailability,
                      _resourceAvailabilityText(context, detail.availability),
                    ),
                    _InfoLine(
                      context.l10n.createdAt,
                      _formatTimestamp(detail.createdAt),
                    ),
                    _InfoLine(
                      context.l10n.updatedAt,
                      _formatTimestamp(detail.updatedAt),
                    ),
                    if (detail.version > 0)
                      _InfoLine(
                        context.l10n.version,
                        detail.version.toString(),
                      ),
                    const SizedBox(height: 16),
                    AppDivider(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.65),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.roomPassword,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AppSelect<_RoomPasswordAction>(
                      value: passwordAction,
                      label: context.l10n.passwordAction,
                      options: {
                        context.l10n.keepUnchanged: _RoomPasswordAction.keep,
                        context.l10n.setNewPassword: _RoomPasswordAction.update,
                        context.l10n.clearPassword: _RoomPasswordAction.clear,
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
                        label: context.l10n.newPassword,
                        controller: passwordController,
                        hintText: context.l10n.newPassword,
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
                MessageUtils.showWarning(
                  context,
                  context.l10n.newPasswordRequired,
                );
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
                MessageUtils.showSuccess(
                  context,
                  context.l10n.roomPasswordUpdated,
                );
                _loadRooms(silent: true);
              } catch (e) {
                if (mounted) {
                  MessageUtils.showError(
                    context,
                    context.l10n.updateRoomPasswordFailed('$e'),
                  );
                }
              }
            },
            icon: Icons.password_rounded,
            label: context.l10n.savePassword,
            style: AppActionButtonStyle.tonal,
          ),
          AppActionButton(
            onPressed: () {
              Navigator.pop(context);
              _showRoomChatHistory(detail);
            },
            icon: Icons.forum_outlined,
            label: context.l10n.chatHistory,
            style: AppActionButtonStyle.tonal,
          ),
          AppActionButton(
            onPressed: () {
              Navigator.pop(context);
              _editRoomTaxonomy(detail);
            },
            icon: Icons.category_outlined,
            label: context.l10n.categoriesAndLabels,
            style: AppActionButtonStyle.tonal,
          ),
          AppActionButton(
            onPressed: () {
              Navigator.pop(context);
              _openContentReportsViewer(
                context,
                title: context.l10n.roomReports(detail.roomName),
                targetType: 1,
                targetRoomId: detail.roomId,
                scope: admin_enum
                    .ContentReportScope
                    .CONTENT_REPORT_SCOPE_TARGET_ROOM
                    .value,
              );
            },
            icon: Icons.report_gmailerrorred_outlined,
            label: context.l10n.reportRecords,
            style: AppActionButtonStyle.tonal,
          ),
          AppActionButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteRoom(detail);
            },
            icon: Icons.delete_outline_rounded,
            label: context.l10n.deleteRoom,
            style: AppActionButtonStyle.destructive,
          ),
          _closeButton(context),
        ],
      );
      passwordController.dispose();
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, context.l10n.loadRoomDetailsFailed('$e'));
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
      final categories =
          results[0]
              .cast<RoomCategoryInfo>()
              .where((category) => category.isEnabled)
              .toList()
            ..sort((a, b) {
              final order = a.sortOrder.compareTo(b.sortOrder);
              if (order != 0) return order;
              return _roomCategoryDisplay(a).compareTo(_roomCategoryDisplay(b));
            });
      final labels =
          results[1]
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
        title: context.l10n.categoriesAndLabels,
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
                      label: context.l10n.roomCategory,
                      hintText: context.l10n.noCategory,
                      prefixIcon: Icons.category_outlined,
                      clearable: true,
                      options: {
                        context.l10n.noCategory: null,
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
                      context.l10n.roomLabels,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (visibleLabels.isEmpty)
                      Text(
                        selectedCategoryId.isEmpty
                            ? context.l10n.noLabelsAvailable
                            : context.l10n.noLabelsForCategory,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: visibleLabels
                            .map((label) {
                              final selected = selectedLabelIds.contains(
                                label.id,
                              );
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
                            })
                            .toList(growable: false),
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
            text: context.l10n.save,
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
      MessageUtils.showSuccess(context, context.l10n.categoriesLabelsSaved);
      _loadRooms(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(
        context,
        context.l10n.saveCategoriesLabelsFailed('$e'),
      );
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
        title: context.l10n.roomMembers,
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
                    role:
                        roleFilter ==
                            common_enum
                                .RoomMemberRole
                                .ROOM_MEMBER_ROLE_UNSPECIFIED
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
                  MessageUtils.showError(
                    context,
                    context.l10n.loadMembersFailed('$e'),
                  );
                }
              }

              Future<void> updateMemberRemarkName(
                AdminRoomMember member,
              ) async {
                final value = await _showRoomMemberTextDialog(
                  title: context.l10n.remarkName,
                  label: context.l10n.remarkName,
                  initialValue: member.remarkName,
                  icon: Icons.drive_file_rename_outline_rounded,
                );
                if (value == null || value == member.remarkName) return;
                try {
                  await SyncTvService.adminUpdateRoomMemberRemarkName(
                    room.roomId,
                    member.userId,
                    value,
                  );
                  await loadMembers();
                  if (!context.mounted) return;
                  MessageUtils.showSuccess(
                    context,
                    context.l10n.remarkNameUpdated,
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  MessageUtils.showError(
                    context,
                    context.l10n.updateRemarkNameFailed('$e'),
                  );
                }
              }

              Future<void> updateMemberDisplayTag(
                AdminRoomMember member,
              ) async {
                final value = await _showRoomMemberTextDialog(
                  title: context.l10n.displayLabel,
                  label: context.l10n.displayLabel,
                  initialValue: member.displayTag,
                  icon: Icons.sell_outlined,
                );
                if (value == null || value == member.displayTag) return;
                try {
                  await SyncTvService.adminUpdateRoomMemberDisplayTag(
                    room.roomId,
                    member.userId,
                    value,
                  );
                  await loadMembers();
                  if (!context.mounted) return;
                  MessageUtils.showSuccess(
                    context,
                    context.l10n.displayLabelUpdated,
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  MessageUtils.showError(
                    context,
                    context.l10n.updateDisplayLabelFailed('$e'),
                  );
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
                          hintText: context.l10n.searchMembers,
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
                        options: {
                          context.l10n.allRoles: common_enum
                              .RoomMemberRole
                              .ROOM_MEMBER_ROLE_UNSPECIFIED,
                          context.l10n.creator: common_enum
                              .RoomMemberRole
                              .ROOM_MEMBER_ROLE_CREATOR,
                          context.l10n.administrator:
                              common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
                          context.l10n.member: common_enum
                              .RoomMemberRole
                              .ROOM_MEMBER_ROLE_MEMBER,
                          context.l10n.guest:
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
                        options: {
                          context.l10n.joinedAt: admin_enum
                              .RoomMemberListSortBy
                              .ROOM_MEMBER_LIST_SORT_BY_JOINED_AT,
                          context.l10n.username: admin_enum
                              .RoomMemberListSortBy
                              .ROOM_MEMBER_LIST_SORT_BY_USERNAME,
                          context.l10n.role: admin_enum
                              .RoomMemberListSortBy
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
                        tooltip:
                            sortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? context.l10n.descending
                            : context.l10n.ascending,
                        icon:
                            sortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? Icons.south_rounded
                            : Icons.north_rounded,
                        onPressed: () {
                          sortDirection =
                              sortDirection ==
                                  admin_enum.SortDirection.SORT_DIRECTION_DESC
                              ? admin_enum.SortDirection.SORT_DIRECTION_ASC
                              : admin_enum.SortDirection.SORT_DIRECTION_DESC;
                          page = 1;
                          loadMembers();
                        },
                      ),
                      AppSelect<int>(
                        value: pageSize,
                        options: {
                          context.l10n.itemsPerPage(20): 20,
                          context.l10n.itemsPerPage(50): 50,
                          context.l10n.itemsPerPage(100): 100,
                        },
                        onChanged: (value) {
                          if (value == null) return;
                          pageSize = value;
                          page = 1;
                          loadMembers();
                        },
                      ),
                      AppIconButton(
                        tooltip: context.l10n.refresh,
                        icon: Icons.refresh_rounded,
                        onPressed: loadMembers,
                      ),
                      AppActionButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _addRoomMember(room);
                        },
                        icon: Icons.person_add_alt_rounded,
                        label: context.l10n.addMember,
                        style: AppActionButtonStyle.text,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context.l10n.memberAdminSummary(
                        total,
                        onlineCount,
                        connectionCount,
                      ),
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
                        ? AppEmptyMessage(message: context.l10n.noMembers)
                        : AppListView.builder(
                            itemCount: members.length,
                            itemBuilder: (context, index) {
                              final member = members[index];
                              final remarkName = member.remarkName.trim();
                              final displayTag = member.displayTag.trim();
                              final username = member.username.isEmpty
                                  ? member.userId
                                  : member.username;
                              final title = remarkName.isEmpty
                                  ? username
                                  : remarkName;
                              final subtitleParts = [
                                if (remarkName.isNotEmpty) username,
                                member.userId,
                                _roomMemberRoleText(context, member.role),
                                if (displayTag.isNotEmpty) displayTag,
                                member.isOnline
                                    ? context.l10n.roomConnections(
                                        member.connectionCount,
                                      )
                                    : context.l10n.offline,
                                _formatTimestamp(member.joinedAt),
                              ];
                              return AppTile(
                                prefix: Icon(
                                  member.isOnline
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: member.isOnline ? Colors.green : null,
                                ),
                                title: Text(title),
                                subtitle: Text(subtitleParts.join(' · ')),
                                suffix: Wrap(
                                  spacing: 4,
                                  children: [
                                    AppIconButton(
                                      tooltip: context.l10n.remarkName,
                                      icon: Icons
                                          .drive_file_rename_outline_rounded,
                                      onPressed: () async {
                                        await updateMemberRemarkName(member);
                                      },
                                    ),
                                    AppIconButton(
                                      tooltip: context.l10n.displayLabel,
                                      icon: Icons.sell_outlined,
                                      onPressed: () async {
                                        await updateMemberDisplayTag(member);
                                      },
                                    ),
                                    AppIconButton(
                                      tooltip: context.l10n.toggleAdministrator,
                                      icon: Icons.admin_panel_settings_outlined,
                                      onPressed: () async {
                                        final nextRole =
                                            member.role ==
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
                                        await SyncTvService.adminSetRoomMemberRole(
                                          room.roomId,
                                          member.userId,
                                          nextRole,
                                        );
                                        await loadMembers();
                                      },
                                    ),
                                    AppIconButton(
                                      tooltip: context.l10n.permissionOverrides,
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
                                      tooltip: context.l10n.kick,
                                      icon: Icons.logout_rounded,
                                      style: AppIconButtonStyle.destructive,
                                      onPressed: () async {
                                        final cooldown =
                                            await _askKickCooldownSeconds();
                                        if (cooldown == null) return;
                                        await SyncTvService.adminKickRoomMember(
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
                    label: context.l10n.memberPageSummary(
                      total,
                      page,
                      totalPages,
                    ),
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
      MessageUtils.showError(context, context.l10n.loadMembersFailed('$e'));
    }
  }

  Future<void> _addRoomMember(SyncTvRoom room) async {
    final controller = TextEditingController();
    int role = common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value;
    var notify = true;
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: context.l10n.addMember,
      icon: const Icon(Icons.person_add_alt_rounded, color: Color(0xFF5D5FEF)),
      content: StatefulBuilder(
        builder: (context, setDialogState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ChatUtils.createFormField(
                context: context,
                label: context.l10n.userId,
                controller: controller,
                hintText: 'usr_...',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 12),
              AppSelect<int>(
                value: role,
                label: context.l10n.roomRole,
                options: {
                  context.l10n.member:
                      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
                  context.l10n.administrator:
                      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value,
                },
                onChanged: (value) => setDialogState(
                  () => role =
                      value ??
                      common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER.value,
                ),
              ),
              const SizedBox(height: 12),
              AppSwitchTile(
                title: Text(context.l10n.notifyMember),
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
          text: context.l10n.add,
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
      MessageUtils.showSuccess(context, context.l10n.memberAdded);
      _showRoomMembers(room);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, context.l10n.addMemberFailed('$e'));
    }
  }

  Future<String?> _showRoomMemberTextDialog({
    required String title,
    required String label,
    required String initialValue,
    required IconData icon,
  }) {
    final controller = TextEditingController(text: initialValue);
    void submit() => Navigator.pop(context, controller.text.trim());

    return ChatUtils.showStyledDialog<String>(
      context: context,
      title: title,
      icon: Icon(icon, color: const Color(0xFF5D5FEF)),
      content: SizedBox(
        width: 360,
        child: AppTextField(
          controller: controller,
          label: label,
          autofocus: true,
          maxLength: 64,
          onSubmitted: (_) => submit(),
        ),
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(context, submit, text: context.l10n.save),
      ],
    ).whenComplete(controller.dispose);
  }

  Future<int?> _askKickCooldownSeconds() async {
    final controller = TextEditingController(text: '60');
    final value = await ChatUtils.showStyledDialog<int>(
      context: context,
      title: context.l10n.kickMember,
      icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
      content: ChatUtils.createFormField(
        context: context,
        label: context.l10n.cooldownSeconds,
        controller: controller,
        hintText: '1 - 2592000',
        prefixIcon: Icons.timer_outlined,
        keyboardType: TextInputType.number,
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(context, () {
          final seconds = int.tryParse(controller.text.trim());
          if (seconds == null || seconds < 1 || seconds > 2592000) {
            MessageUtils.showWarning(
              context,
              context.l10n.cooldownSecondsRange,
            );
            return;
          }
          Navigator.pop(context, seconds);
        }, text: context.l10n.kick),
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
      MessageUtils.showSuccess(context, context.l10n.memberPermissionsUpdated);
      await _showRoomMembers(room);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(
        context,
        context.l10n.updatePermissionsFailed('$e'),
      );
      await _showRoomMembers(room);
    }
  }

  Future<_PermissionOverrideResult?> _showPermissionOverrideDialog(
    AdminRoomMember member,
  ) {
    final isAdmin =
        member.role == common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value;
    var added = isAdmin
        ? member.adminAddedPermissions
        : member.addedPermissions;
    var removed = isAdmin
        ? member.adminRemovedPermissions
        : member.removedPermissions;

    return ChatUtils.showStyledDialog<_PermissionOverrideResult>(
      context: context,
      title: context.l10n.permissionOverrides,
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
          label: context.l10n.clearOverrides,
          style: AppActionButtonStyle.text,
        ),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(context, () {
          Navigator.pop(
            context,
            _PermissionOverrideResult(
              addedPermissions: isAdmin ? 0 : added,
              removedPermissions: isAdmin ? 0 : removed,
              adminAddedPermissions: isAdmin ? added : 0,
              adminRemovedPermissions: isAdmin ? removed : 0,
            ),
          );
        }, text: context.l10n.save),
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
            segments: [
              ButtonSegment(
                value: _PermissionOverrideMode.inherit,
                label: Text(context.l10n.inherit),
              ),
              ButtonSegment(
                value: _PermissionOverrideMode.allow,
                label: Text(context.l10n.allow),
              ),
              ButtonSegment(
                value: _PermissionOverrideMode.deny,
                label: Text(context.l10n.deny),
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
      final settings = await SyncTvService.adminGetRoomSettings(room.roomId);
      if (!mounted) return;
      final maxMembers = TextEditingController(
        text: settings.maxMembers.toString(),
      );
      bool requirePassword = settings.requirePassword;
      bool requireApproval = settings.requireApproval;
      bool allowGuestJoin = settings.allowGuestJoin;
      bool chatEnabled = settings.chatEnabled;
      bool danmakuEnabled = settings.danmakuEnabled;
      final confirmed = await ChatUtils.showStyledDialog<bool>(
        context: context,
        title: context.l10n.roomSettings,
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
                    title: Text(context.l10n.requiresPassword),
                  ),
                  AppSwitchTile(
                    value: requireApproval,
                    onChanged: (value) =>
                        setDialogState(() => requireApproval = value),
                    title: Text(context.l10n.joinRequiresApproval),
                  ),
                  AppSwitchTile(
                    value: allowGuestJoin,
                    onChanged: (value) =>
                        setDialogState(() => allowGuestJoin = value),
                    title: Text(context.l10n.allowGuestJoin),
                  ),
                  AppSwitchTile(
                    value: chatEnabled,
                    onChanged: (value) =>
                        setDialogState(() => chatEnabled = value),
                    title: Text(context.l10n.chat),
                  ),
                  AppSwitchTile(
                    value: danmakuEnabled,
                    onChanged: (value) =>
                        setDialogState(() => danmakuEnabled = value),
                    title: Text(context.l10n.danmaku),
                  ),
                  ChatUtils.createFormField(
                    context: dialogContext,
                    label: context.l10n.maximumMembers,
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
              MessageUtils.showSuccess(context, context.l10n.roomSettingsReset);
            },
            label: context.l10n.reset,
            style: AppActionButtonStyle.text,
          ),
          ChatUtils.createCancelButton(context),
          const SizedBox(width: 8),
          ChatUtils.createConfirmButton(
            context,
            () => Navigator.pop(context, true),
            text: context.l10n.save,
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
      await SyncTvService.adminUpdateRoomSettings(room.roomId, settings);
      if (!mounted) return;
      MessageUtils.showSuccess(context, context.l10n.roomSettingsSaved);
      _loadRooms(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(
        context,
        context.l10n.saveRoomSettingsFailed('$e'),
      );
    }
  }

  String _getStatusText(int status) {
    switch (status) {
      case 1:
        return context.l10n.active;
      case 2:
        return context.l10n.closed;
      default:
        return context.l10n.unknown;
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
    return room.isBanned ? context.l10n.banned : _getStatusText(room.status);
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
                  hint: context.l10n.searchRooms,
                  icon: Icons.search,
                ),
              ),
              _AdminToolbarItem(
                width: 112,
                child: AppSelect<String?>(
                  value: _categoryFilter.isEmpty ? null : _categoryFilter,
                  hintText: context.l10n.allCategories,
                  prefixIcon: Icons.category_outlined,
                  clearable: true,
                  enabled: !_isLoadingTaxonomy && _categories.isNotEmpty,
                  options: {
                    context.l10n.allCategories: null,
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
                  onPressed: _isLoadingTaxonomy
                      ? null
                      : _showRoomLabelFilterDialog,
                  icon: Icons.sell_outlined,
                  label: _labelFilters.isEmpty
                      ? context.l10n.labels
                      : context.l10n.selectedLabels(_labelFilters.length),
                  style: _labelFilters.isEmpty
                      ? AppActionButtonStyle.outlined
                      : AppActionButtonStyle.tonal,
                ),
              ),
              _AdminToolbarItem(
                width: 112,
                child: AppSelect<common_enum.RoomStatus>(
                  value: _statusFilter,
                  options: {
                    context.l10n.allStatuses:
                        common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED,
                    context.l10n.active:
                        common_enum.RoomStatus.ROOM_STATUS_ACTIVE,
                    context.l10n.closed:
                        common_enum.RoomStatus.ROOM_STATUS_CLOSED,
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
                  options: {
                    context.l10n.allBanStates: null,
                    context.l10n.bannedOnly: true,
                    context.l10n.notBanned: false,
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
                  options: {
                    context.l10n.createdAt:
                        admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_CREATED_AT,
                    context.l10n.updatedAt:
                        admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_UPDATED_AT,
                    context.l10n.recentActivity: admin_enum
                        .RoomListSortBy
                        .ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
                    context.l10n.roomName:
                        admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_NAME,
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
                  tooltip:
                      _sortDirection ==
                          admin_enum.SortDirection.SORT_DIRECTION_DESC
                      ? context.l10n.descending
                      : context.l10n.ascending,
                  icon:
                      _sortDirection ==
                          admin_enum.SortDirection.SORT_DIRECTION_DESC
                      ? Icons.south_rounded
                      : Icons.north_rounded,
                  onPressed: () {
                    setState(() {
                      _sortDirection =
                          _sortDirection ==
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
                  options: {
                    context.l10n.itemsPerPage(20): 20,
                    context.l10n.itemsPerPage(50): 50,
                    context.l10n.itemsPerPage(100): 100,
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
                    tooltip: context.l10n.clearRoomTaxonomyFilters,
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
                  tooltip: context.l10n.selectCurrentPage,
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
              ? AppEmptyMessage(message: context.l10n.noRooms)
              : AppListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: _rooms.length,
                  itemBuilder: (context, index) {
                    final room = _rooms[index];
                    final statusColor = _roomStatusColorForRoom(room);
                    return _AdminPanelCard(
                      isDark: isDark,
                      child: AppTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        prefix: AppCheckbox(
                          value: _selectedRoomIds.contains(room.roomId),
                          semanticsLabel: context.l10n.selectRoom,
                          onChanged: (value) =>
                              _toggleRoomSelection(room.roomId, value),
                        ),
                        title: Text(
                          room.roomName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              AppBadge(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                color: statusColor,
                                borderSide: BorderSide(
                                  color: statusColor.withValues(alpha: 0.50),
                                ),
                                label: Text(
                                  _roomStatusLabel(room),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'ID: ${room.roomId}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.hintColor,
                                  ),
                                ),
                              ),
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
                                tooltip: context.l10n.ban,
                                style: AppIconButtonStyle.destructive,
                                onPressed: () => _banRoom(room, true),
                              )
                            else
                              AppIconButton(
                                icon: Icons.check_circle,
                                iconSize: 22,
                                tooltip: context.l10n.unban,
                                onPressed: () => _banRoom(room, false),
                              ),
                            AppActionButton(
                              icon: Icons.info_outline_rounded,
                              label: context.l10n.roomInformation,
                              size: AppActionButtonSize.sm,
                              style: AppActionButtonStyle.tonal,
                              onPressed: () => _showRoomDetails(room),
                            ),
                            AppIconButton(
                              icon: Icons.group_outlined,
                              iconSize: 22,
                              tooltip: context.l10n.members,
                              onPressed: () => _showRoomMembers(room),
                            ),
                            AppIconButton(
                              icon: Icons.forum_outlined,
                              iconSize: 22,
                              tooltip: context.l10n.chatHistory,
                              onPressed: () => _showRoomChatHistory(room),
                            ),
                            AppIconButton(
                              icon: Icons.report_gmailerrorred_outlined,
                              iconSize: 22,
                              tooltip: context.l10n.reports,
                              onPressed: () => _openContentReportsViewer(
                                context,
                                title: context.l10n.roomReports(room.roomName),
                                targetType: 1,
                                targetRoomId: room.roomId,
                                scope: admin_enum
                                    .ContentReportScope
                                    .CONTENT_REPORT_SCOPE_TARGET_ROOM
                                    .value,
                              ),
                            ),
                            AppIconButton(
                              icon: Icons.tune_rounded,
                              iconSize: 22,
                              tooltip: context.l10n.settings,
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
      border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
      child: Row(
        children: [
          Icon(Icons.checklist_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(context.l10n.roomsSelected(_selectedRoomIds.length)),
          ),
          AppActionButton(
            onPressed: () => setState(_selectedRoomIds.clear),
            label: context.l10n.clear,
            style: AppActionButtonStyle.text,
          ),
          const SizedBox(width: 4),
          AppActionButton(
            onPressed: _batchBanRooms,
            icon: Icons.block_rounded,
            label: context.l10n.ban,
            style: AppActionButtonStyle.tonal,
          ),
          const SizedBox(width: 8),
          AppActionButton(
            onPressed: _batchDeleteRooms,
            icon: Icons.delete_outline_rounded,
            label: context.l10n.delete,
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
        SyncTvService.adminListRoomLabels(includeDisabled: true, refresh: true),
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
      MessageUtils.showError(
        context,
        context.l10n.loadCategoriesLabelsFailed('$e'),
      );
    }
  }

  int _compareCategories(RoomCategoryInfo a, RoomCategoryInfo b) {
    final order = a.sortOrder.compareTo(b.sortOrder);
    if (order != 0) return order;
    return _categoryDisplay(a).compareTo(_categoryDisplay(b));
  }

  int _compareLabels(RoomLabelInfo a, RoomLabelInfo b) {
    final category = _categoryDisplayById(
      a.categoryId,
    ).compareTo(_categoryDisplayById(b.categoryId));
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
    if (categoryId.isEmpty) return context.l10n.categoryNotBound;
    for (final category in _categories) {
      if (category.id == categoryId) return _categoryDisplay(category);
    }
    return context.l10n.unknownCategory;
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
    final descriptionController = TextEditingController(
      text: category?.description ?? '',
    );
    final sortController = TextEditingController(
      text: '${category?.sortOrder ?? 0}',
    );
    var enabled = category?.isEnabled ?? true;
    var disposeScheduled = false;
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: category == null
          ? context.l10n.addCategory
          : context.l10n.editCategory,
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
                    label: context.l10n.identifier,
                    controller: keyController,
                    hintText: context.l10n.categoryIdentifierExample,
                    prefixIcon: Icons.key_rounded,
                  ),
                  const SizedBox(height: 12),
                  ChatUtils.createFormField(
                    context: dialogContext,
                    label: context.l10n.name,
                    controller: nameController,
                    hintText: context.l10n.categoryNameExample,
                    prefixIcon: Icons.drive_file_rename_outline_rounded,
                  ),
                  const SizedBox(height: 12),
                  ChatUtils.createFormField(
                    context: dialogContext,
                    label: context.l10n.description,
                    controller: descriptionController,
                    hintText: context.l10n.optional,
                    prefixIcon: Icons.notes_rounded,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  ChatUtils.createFormField(
                    context: dialogContext,
                    label: context.l10n.sort,
                    controller: sortController,
                    hintText: context.l10n.lowerNumberFirst,
                    prefixIcon: Icons.sort_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  AppSwitchTile(
                    value: enabled,
                    onChanged: (value) => setDialogState(() => enabled = value),
                    title: Text(context.l10n.enableCategory),
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
          text: context.l10n.save,
        ),
      ],
    );
    if (confirmed != true) return;

    final key = keyController.text.trim();
    final name = nameController.text.trim();
    final sortOrder = int.tryParse(sortController.text.trim());
    if (key.isEmpty || name.isEmpty) {
      if (!mounted) return;
      MessageUtils.showWarning(context, context.l10n.categoryIdAndNameRequired);
      return;
    }
    if (sortOrder == null) {
      if (!mounted) return;
      MessageUtils.showWarning(context, context.l10n.sortMustBeInteger);
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
      MessageUtils.showSuccess(context, context.l10n.categorySaved);
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, context.l10n.saveCategoryFailed('$e'));
    }
  }

  Future<void> _deleteCategory(RoomCategoryInfo category) async {
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: context.l10n.deleteCategory,
      icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
      content: _destructiveDialogContent(
        context.l10n.permanentlyDeleteCategory(_categoryDisplay(category)),
        [context.l10n.roomsLoseCategory, context.l10n.categoryChangesImmediate],
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.delete,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      await SyncTvService.adminDeleteRoomCategory(category.id);
      if (!mounted) return;
      MessageUtils.showSuccess(context, context.l10n.categoryDeleted);
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, context.l10n.deleteCategoryFailed('$e'));
    }
  }

  Future<void> _editLabel([RoomLabelInfo? label]) async {
    final keyController = TextEditingController(text: label?.key ?? '');
    final nameController = TextEditingController(text: label?.name ?? '');
    final descriptionController = TextEditingController(
      text: label?.description ?? '',
    );
    final colorController = TextEditingController(
      text: _normalizeColor(label?.color ?? ''),
    );
    final sortController = TextEditingController(
      text: '${label?.sortOrder ?? 0}',
    );
    var categoryId = label?.categoryId ?? '';
    var enabled = label?.isEnabled ?? true;
    var disposeScheduled = false;
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: label == null ? context.l10n.addLabel : context.l10n.editLabel,
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
                    label: context.l10n.identifier,
                    controller: keyController,
                    hintText: context.l10n.labelIdentifierExample,
                    prefixIcon: Icons.key_rounded,
                  ),
                  const SizedBox(height: 12),
                  ChatUtils.createFormField(
                    context: dialogContext,
                    label: context.l10n.name,
                    controller: nameController,
                    hintText: context.l10n.labelNameExample,
                    prefixIcon: Icons.drive_file_rename_outline_rounded,
                  ),
                  const SizedBox(height: 12),
                  AppSelect<String?>(
                    value: categoryId.isEmpty ? null : categoryId,
                    label: context.l10n.parentCategory,
                    hintText: context.l10n.noCategoryBinding,
                    prefixIcon: Icons.category_outlined,
                    clearable: true,
                    options: {
                      context.l10n.noCategoryBinding: null,
                      for (final category in _categories)
                        _categoryDisplay(category): category.id,
                    },
                    onChanged: (value) =>
                        setDialogState(() => categoryId = value ?? ''),
                  ),
                  const SizedBox(height: 12),
                  ChatUtils.createFormField(
                    context: dialogContext,
                    label: context.l10n.color,
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
                    label: context.l10n.description,
                    controller: descriptionController,
                    hintText: context.l10n.optional,
                    prefixIcon: Icons.notes_rounded,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  ChatUtils.createFormField(
                    context: dialogContext,
                    label: context.l10n.sort,
                    controller: sortController,
                    hintText: context.l10n.lowerNumberFirst,
                    prefixIcon: Icons.sort_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  AppSwitchTile(
                    value: enabled,
                    onChanged: (value) => setDialogState(() => enabled = value),
                    title: Text(context.l10n.enableLabel),
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
          text: context.l10n.save,
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
      MessageUtils.showWarning(context, context.l10n.labelIdAndNameRequired);
      return;
    }
    if (sortOrder == null) {
      if (!mounted) return;
      MessageUtils.showWarning(context, context.l10n.sortMustBeInteger);
      return;
    }
    if (color.isNotEmpty &&
        !RegExp(r'^#[0-9A-F]{6}$').hasMatch(color.toUpperCase())) {
      if (!mounted) return;
      MessageUtils.showWarning(context, context.l10n.colorFormatExample);
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
      MessageUtils.showSuccess(context, context.l10n.labelSaved);
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, context.l10n.saveLabelFailed('$e'));
    }
  }

  Future<void> _deleteLabel(RoomLabelInfo label) async {
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: context.l10n.deleteLabel,
      icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
      content: _destructiveDialogContent(
        context.l10n.permanentlyDeleteLabel(_labelDisplay(label)),
        [context.l10n.roomsLoseLabel, context.l10n.labelChangesImmediate],
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.delete,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      await SyncTvService.adminDeleteRoomLabel(label.id);
      if (!mounted) return;
      MessageUtils.showSuccess(context, context.l10n.labelDeleted);
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, context.l10n.deleteLabelFailed('$e'));
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
                  label: context.l10n.addCategory,
                ),
              ),
              _AdminToolbarItem(
                width: 150,
                child: AppActionButton(
                  onPressed: () => _editLabel(),
                  icon: Icons.add_rounded,
                  label: context.l10n.addLabel,
                  style: AppActionButtonStyle.tonal,
                ),
              ),
              _AdminToolbarItem(
                width: 112,
                child: AppActionButton(
                  onPressed: () => _load(),
                  icon: Icons.refresh_rounded,
                  label: context.l10n.refresh,
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
                  children: [panels[0], const SizedBox(height: 16), panels[1]],
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
            title: context.l10n.roomCategories,
            count: _categories.length,
          ),
          const SizedBox(height: 12),
          if (_categories.isEmpty)
            AppEmptyState(
              icon: Icons.category_outlined,
              title: context.l10n.noCategories,
              subtitle: context.l10n.addCategoriesDescription,
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
            title: context.l10n.roomLabels,
            count: _labels.length,
          ),
          const SizedBox(height: 12),
          if (_labels.isEmpty)
            AppEmptyState(
              icon: Icons.sell_outlined,
              title: context.l10n.noLabelsAvailable,
              subtitle: context.l10n.addLabelsDescription,
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
        AppChip(label: Text('$count'), style: AppChipStyle.outlined),
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
                      label: Text(
                        category.isEnabled
                            ? context.l10n.enabled
                            : context.l10n.disabled,
                      ),
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
                tooltip: context.l10n.editCategory,
                style: AppIconButtonStyle.tonal,
                size: AppIconButtonSize.sm,
              ),
              const SizedBox(height: 6),
              AppIconButton(
                onPressed: onDelete,
                icon: Icons.delete_outline_rounded,
                tooltip: context.l10n.deleteCategory,
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
                      label: Text(
                        label.isEnabled
                            ? context.l10n.enabled
                            : context.l10n.disabled,
                      ),
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
                          ? context.l10n.defaultColor
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
                tooltip: context.l10n.editLabel,
                style: AppIconButtonStyle.tonal,
                size: AppIconButtonSize.sm,
              ),
              const SizedBox(height: 6),
              AppIconButton(
                onPressed: onDelete,
                icon: Icons.delete_outline_rounded,
                tooltip: context.l10n.deleteLabel,
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

  const _TaxonomyMetaChip({required this.icon, required this.label});

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
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
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
        MessageUtils.showError(context, context.l10n.loadUsersFailed('$e'));
      }
    }
  }

  Future<void> _addUser() async {
    final l10n = context.l10n;
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    int role = common_enum.UserRole.USER_ROLE_USER.value;
    var status = common_enum.UserStatus.USER_STATUS_ACTIVE;

    await ChatUtils.showStyledDialog(
      context: context,
      title: l10n.addUser,
      icon: const Icon(Icons.person_add, color: Color(0xFF5D5FEF)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChatUtils.createFormField(
            context: context,
            label: l10n.username,
            controller: usernameController,
            hintText: l10n.usernameRequired,
            prefixIcon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          ChatUtils.createFormField(
            context: context,
            label: l10n.email,
            controller: emailController,
            hintText: l10n.optional,
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          ChatUtils.createFormField(
            context: context,
            label: l10n.password,
            controller: passwordController,
            hintText: l10n.passwordRequired,
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),
          const SizedBox(height: 12),
          AppSelect<int>(
            value: role,
            label: l10n.role,
            options: {
              l10n.user: common_enum.UserRole.USER_ROLE_USER.value,
              l10n.administrator: common_enum.UserRole.USER_ROLE_ADMIN.value,
            },
            onChanged: (value) {
              if (value != null) role = value;
            },
          ),
          const SizedBox(height: 12),
          AppSelect<common_enum.UserStatus>(
            value: status,
            label: l10n.status,
            options: {
              l10n.active: common_enum.UserStatus.USER_STATUS_ACTIVE,
              l10n.banned: common_enum.UserStatus.USER_STATUS_BANNED,
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
            MessageUtils.showWarning(context, l10n.usernameAndPasswordRequired);
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
            MessageUtils.showSuccess(context, l10n.userCreated);
            _loadUsers(silent: true);
          } catch (e) {
            if (!mounted) return;
            MessageUtils.showError(context, l10n.createUserFailed('$e'));
          }
        }, text: l10n.create),
      ],
    );
  }

  Future<void> _deleteUser(SyncTvUser user) async {
    final l10n = context.l10n;
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: l10n.deleteUser,
      icon: const Icon(Icons.warning, color: Colors.red),
      content:
          _destructiveDialogContent(l10n.permanentlyDeleteUser(user.username), [
            l10n.deleteUserClearsAccountData,
            l10n.deleteUserAffectsRelatedData,
            l10n.deleteUserRevokesOnlineAccess,
          ]),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: l10n.delete,
        ),
      ],
    );

    if (confirm == true) {
      try {
        await SyncTvService.adminDeleteUser(user.id);
        if (!mounted) return;
        MessageUtils.showSuccess(context, l10n.userDeleted);
        _loadUsers(silent: true);
      } catch (e) {
        if (!mounted) return;
        MessageUtils.showError(context, l10n.deleteUserFailed('$e'));
      }
    }
  }

  Future<void> _toggleAdmin(SyncTvUser user) async {
    final l10n = context.l10n;
    final isAdmin =
        user.role == common_enum.UserRole.USER_ROLE_ADMIN.value ||
        user.role == common_enum.UserRole.USER_ROLE_ROOT.value;
    if (user.role == common_enum.UserRole.USER_ROLE_ROOT.value) {
      MessageUtils.showWarning(context, l10n.rootUserCannotBeDemoted);
      return;
    }
    final action = isAdmin
        ? l10n.removeAdministratorRole
        : l10n.makeAdministrator;

    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: l10n.changePermissions,
      icon: const Icon(Icons.admin_panel_settings, color: Color(0xFF5D5FEF)),
      content: Text(l10n.confirmUserRoleAction(user.username, action)),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: l10n.confirm,
        ),
      ],
    );

    if (confirm == true) {
      try {
        await SyncTvService.adminSetAdmin(user.id, !isAdmin);
        if (!mounted) return;
        MessageUtils.showSuccess(context, l10n.operationSucceeded);
        _loadUsers(silent: true);
      } catch (e) {
        if (!mounted) return;
        MessageUtils.showError(context, l10n.operationFailed('$e'));
      }
    }
  }

  Future<void> _banUser(SyncTvUser user, bool ban) async {
    final l10n = context.l10n;
    final action = ban ? l10n.ban : l10n.unban;
    final reasonController = TextEditingController();
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: l10n.userAction(action),
      icon: Icon(
        ban ? Icons.block : Icons.check_circle,
        color: ban ? Colors.red : Colors.green,
      ),
      content: ban
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.confirmUserAction(action, user.username)),
                const SizedBox(height: 12),
                ChatUtils.createFormField(
                  context: context,
                  label: l10n.banReason,
                  controller: reasonController,
                  hintText: l10n.optional,
                  prefixIcon: Icons.edit_note_rounded,
                ),
              ],
            )
          : Text(l10n.confirmUserAction(action, user.username)),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: l10n.confirm,
        ),
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
        MessageUtils.showSuccess(context, l10n.operationSucceeded);
        _loadUsers(silent: true);
      } catch (e) {
        if (!mounted) return;
        MessageUtils.showError(context, l10n.operationFailed('$e'));
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
    final l10n = context.l10n;
    final reasonController = TextEditingController();
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: l10n.batchBanUsers,
      icon: const Icon(Icons.block_rounded, color: Colors.redAccent),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.usersWillBeBanned(_selectedUserIds.length)),
          const SizedBox(height: 12),
          ChatUtils.createFormField(
            context: context,
            label: l10n.banReason,
            controller: reasonController,
            hintText: l10n.optional,
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
          text: l10n.ban,
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
      _showBatchResult(l10n.batchBanCompleted, result);
      setState(_selectedUserIds.clear);
      _loadUsers(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, l10n.batchBanFailed('$e'));
    }
  }

  Future<void> _batchDeleteUsers() async {
    if (_selectedUserIds.isEmpty) return;
    final l10n = context.l10n;
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: l10n.batchDeleteUsers,
      icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
      content: _destructiveDialogContent(
        l10n.usersWillBeDeleted(_selectedUserIds.length),
        [
          l10n.batchDeleteUsersClearsAccountData,
          l10n.batchDeleteUsersAffectsRelatedData,
          l10n.batchDeleteBackupOnly,
        ],
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: l10n.delete,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      final result = await SyncTvService.adminBatchDeleteUsers(
        _selectedUserIds.toList(),
      );
      if (!mounted) return;
      _showBatchResult(l10n.batchDeleteCompleted, result);
      setState(_selectedUserIds.clear);
      _loadUsers(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, l10n.batchDeleteFailed('$e'));
    }
  }

  void _showBatchResult(String title, AdminBatchOperationResult result) {
    final failedItems = result.results.where((item) => !item.success).toList();
    final message = failedItems.isEmpty
        ? context.l10n.batchResultSuccess(title, result.succeeded)
        : context.l10n.batchResultMixed(title, result.succeeded, result.failed);
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
                Expanded(child: Text(impact, style: theme.textTheme.bodySmall)),
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
      final l10n = context.l10n;
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
                AppTabBar(
                  tabs: [
                    Tab(text: l10n.profile),
                    Tab(text: l10n.rooms),
                    Tab(text: l10n.reports),
                    Tab(text: l10n.preferences),
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
      MessageUtils.showError(context, context.l10n.loadUserDetailsFailed('$e'));
    }
  }

  Widget _buildUserReportsPanel(SyncTvUser user) {
    return AppDefaultTabController(
      length: 2,
      child: Column(
        children: [
          AppTabBar(
            tabs: [
              Tab(text: context.l10n.reportsAgainstUser),
              Tab(text: context.l10n.reportsByUser),
            ],
          ),
          Expanded(
            child: AppTabBarView(
              children: [
                AdminContentReportsTab(
                  title: '',
                  initialTargetType: 2,
                  initialTargetUserId: user.id,
                  initialScope: admin_enum
                      .ContentReportScope
                      .CONTENT_REPORT_SCOPE_TARGET_USER
                      .value,
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
        _InfoLine(context.l10n.userId, detail.id),
        _InfoLine(context.l10n.email, detail.email ?? '-'),
        _InfoLine(context.l10n.role, _systemRoleText(context, detail.role)),
        _InfoLine(context.l10n.status, _userStatusText(context, detail.status)),
        _InfoLine(context.l10n.createdAt, _formatTimestamp(detail.createdAt)),
        if (detail.updatedAt > 0)
          _InfoLine(context.l10n.updatedAt, _formatTimestamp(detail.updatedAt)),
        if (detail.isBanned) ...[
          _InfoLine(context.l10n.bannedAt, _formatTimestamp(detail.bannedAt)),
          if (detail.bannedBy.isNotEmpty)
            _InfoLine(context.l10n.bannedBy, detail.bannedBy),
          if (detail.bannedReason.isNotEmpty)
            _InfoLine(context.l10n.banReason, detail.bannedReason),
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
            MessageUtils.showError(
              context,
              context.l10n.loadUserRoomsFailed('$e'),
            );
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
                      hintText: context.l10n.searchRooms,
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
                    options: {
                      context.l10n.allStatuses:
                          common_enum.RoomStatus.ROOM_STATUS_UNSPECIFIED,
                      context.l10n.active:
                          common_enum.RoomStatus.ROOM_STATUS_ACTIVE,
                      context.l10n.closed:
                          common_enum.RoomStatus.ROOM_STATUS_CLOSED,
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
                    options: {
                      context.l10n.allBanStates: null,
                      context.l10n.bannedOnly: true,
                      context.l10n.notBanned: false,
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
                    options: {
                      context.l10n.createdAt: admin_enum
                          .RoomListSortBy
                          .ROOM_LIST_SORT_BY_CREATED_AT,
                      context.l10n.updatedAt: admin_enum
                          .RoomListSortBy
                          .ROOM_LIST_SORT_BY_UPDATED_AT,
                      context.l10n.recentActivity: admin_enum
                          .RoomListSortBy
                          .ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
                      context.l10n.roomName:
                          admin_enum.RoomListSortBy.ROOM_LIST_SORT_BY_NAME,
                    },
                    onChanged: (value) {
                      if (value == null) return;
                      sortBy = value;
                      page = 1;
                      loadRooms();
                    },
                  ),
                  AppIconButton(
                    tooltip:
                        sortDirection ==
                            admin_enum.SortDirection.SORT_DIRECTION_DESC
                        ? context.l10n.descending
                        : context.l10n.ascending,
                    icon:
                        sortDirection ==
                            admin_enum.SortDirection.SORT_DIRECTION_DESC
                        ? Icons.south_rounded
                        : Icons.north_rounded,
                    onPressed: () {
                      sortDirection =
                          sortDirection ==
                              admin_enum.SortDirection.SORT_DIRECTION_DESC
                          ? admin_enum.SortDirection.SORT_DIRECTION_ASC
                          : admin_enum.SortDirection.SORT_DIRECTION_DESC;
                      page = 1;
                      loadRooms();
                    },
                  ),
                  AppSelect<int>(
                    value: pageSize,
                    options: {
                      context.l10n.itemsPerPage(20): 20,
                      context.l10n.itemsPerPage(50): 50,
                      context.l10n.itemsPerPage(100): 100,
                    },
                    onChanged: (value) {
                      if (value == null) return;
                      pageSize = value;
                      page = 1;
                      loadRooms();
                    },
                  ),
                  AppIconButton(
                    tooltip: context.l10n.refresh,
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
                  ? AppEmptyMessage(message: context.l10n.noRooms)
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
                            '${room.roomId} · ${room.isBanned ? context.l10n.banned : _roomStatusText(context, room.status)}',
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
            MessageUtils.showSuccess(context, context.l10n.preferencesUpdated);
          } catch (e) {
            if (!context.mounted) return;
            MessageUtils.showError(
              context,
              context.l10n.savePreferencesFailed('$e'),
            );
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
              title: Text(context.l10n.multiFactorAuthentication),
              subtitle: Text(
                context.l10n.authenticationFactorsSummary(
                  preferences.eligibleFactorCount,
                  preferences.canUsePassword
                      ? context.l10n.available
                      : context.l10n.unavailable,
                  preferences.canUseEmail
                      ? context.l10n.available
                      : context.l10n.unavailable,
                  preferences.canUsePasskey
                      ? context.l10n.available
                      : context.l10n.unavailable,
                ),
              ),
              onChanged: (value) => savePreferences(twoFactorEnabled: value),
            ),
            const AppDivider(height: 20),
            notificationSwitch(
              context.l10n.roomInvitationInAppNotification,
              notifications.roomInvitationInApp,
              (value) => notifications.copyWith(roomInvitationInApp: value),
            ),
            notificationSwitch(
              context.l10n.roomEventInAppNotification,
              notifications.roomEventInApp,
              (value) => notifications.copyWith(roomEventInApp: value),
            ),
            notificationSwitch(
              context.l10n.systemAnnouncementInAppNotification,
              notifications.systemAnnouncementInApp,
              (value) => notifications.copyWith(systemAnnouncementInApp: value),
            ),
            notificationSwitch(
              context.l10n.roomInvitationEmail,
              notifications.roomInvitationEmail,
              (value) => notifications.copyWith(roomInvitationEmail: value),
            ),
            notificationSwitch(
              context.l10n.roomEventEmail,
              notifications.roomEventEmail,
              (value) => notifications.copyWith(roomEventEmail: value),
            ),
            notificationSwitch(
              context.l10n.systemAnnouncementEmail,
              notifications.systemAnnouncementEmail,
              (value) => notifications.copyWith(systemAnnouncementEmail: value),
            ),
          ],
        );
      },
    );
  }

  Future<void> _renameUser(SyncTvUser user) async {
    final l10n = context.l10n;
    final controller = TextEditingController(text: user.username);
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: l10n.changeUsername,
      icon: const Icon(
        Icons.drive_file_rename_outline_rounded,
        color: Color(0xFF5D5FEF),
      ),
      content: ChatUtils.createFormField(
        context: context,
        label: l10n.newUsername,
        controller: controller,
        hintText: l10n.usernameLengthHint,
        prefixIcon: Icons.person_outline,
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: l10n.save,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      await SyncTvService.adminUpdateUsername(user.id, controller.text.trim());
      if (!mounted) return;
      MessageUtils.showSuccess(context, l10n.usernameUpdated);
      _loadUsers(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, l10n.changeUsernameFailed('$e'));
    }
  }

  Future<void> _resetPassword(SyncTvUser user) async {
    final l10n = context.l10n;
    final password = TextEditingController();
    final reason = TextEditingController();
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: l10n.resetPassword,
      icon: const Icon(Icons.lock_reset_rounded, color: Colors.orange),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ChatUtils.createFormField(
            context: context,
            label: l10n.newPassword,
            controller: password,
            hintText: l10n.passwordMinimumLength(8),
            prefixIcon: Icons.lock_outline,
            obscureText: true,
          ),
          const SizedBox(height: 12),
          ChatUtils.createFormField(
            context: context,
            label: l10n.auditReason,
            controller: reason,
            hintText: l10n.optional,
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
          text: l10n.reset,
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
      MessageUtils.showSuccess(context, l10n.passwordReset);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, l10n.resetPasswordFailed('$e'));
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
                      hint: context.l10n.searchUsers,
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
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.person_add_rounded,
                                  color: theme.primaryColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  context.l10n.add,
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
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
                      tooltip: context.l10n.selectCurrentPage,
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
                        options: {
                          context.l10n.allStatuses:
                              common_enum.UserStatus.USER_STATUS_UNSPECIFIED,
                          context.l10n.active:
                              common_enum.UserStatus.USER_STATUS_ACTIVE,
                          context.l10n.banned:
                              common_enum.UserStatus.USER_STATUS_BANNED,
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
                        options: {
                          context.l10n.allRoles:
                              common_enum.UserRole.USER_ROLE_UNSPECIFIED,
                          'Root': common_enum.UserRole.USER_ROLE_ROOT,
                          context.l10n.administrator:
                              common_enum.UserRole.USER_ROLE_ADMIN,
                          context.l10n.user:
                              common_enum.UserRole.USER_ROLE_USER,
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
                        options: {
                          context.l10n.allBanStates: null,
                          context.l10n.bannedOnly: true,
                          context.l10n.notBanned: false,
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
                        options: {
                          context.l10n.createdAt: admin_enum
                              .UserListSortBy
                              .USER_LIST_SORT_BY_CREATED_AT,
                          context.l10n.updatedAt: admin_enum
                              .UserListSortBy
                              .USER_LIST_SORT_BY_UPDATED_AT,
                          context.l10n.username: admin_enum
                              .UserListSortBy
                              .USER_LIST_SORT_BY_USERNAME,
                          context.l10n.email:
                              admin_enum.UserListSortBy.USER_LIST_SORT_BY_EMAIL,
                          context.l10n.status: admin_enum
                              .UserListSortBy
                              .USER_LIST_SORT_BY_STATUS,
                          context.l10n.role:
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
                        tooltip:
                            _sortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? context.l10n.descending
                            : context.l10n.ascending,
                        icon:
                            _sortDirection ==
                                admin_enum.SortDirection.SORT_DIRECTION_DESC
                            ? Icons.south_rounded
                            : Icons.north_rounded,
                        onPressed: () {
                          setState(() {
                            _sortDirection =
                                _sortDirection ==
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
                        options: {
                          context.l10n.itemsPerPage(20): 20,
                          context.l10n.itemsPerPage(50): 50,
                          context.l10n.itemsPerPage(100): 100,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    final isAdmin =
                        user.role ==
                            common_enum.UserRole.USER_ROLE_ADMIN.value ||
                        user.role == common_enum.UserRole.USER_ROLE_ROOT.value;
                    final isBanned =
                        user.status ==
                        common_enum.UserStatus.USER_STATUS_BANNED.value;

                    return _AdminPanelCard(
                      isDark: isDark,
                      child: AppTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        prefix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppCheckbox(
                              value: _selectedUserIds.contains(user.id),
                              semanticsLabel: context.l10n.selectUser,
                              onChanged: (value) =>
                                  _toggleUserSelection(user.id, value),
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
                        title: Text(
                          user.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            context.l10n.userListSummary(
                              user.id,
                              _systemRoleText(context, user.role),
                              _userStatusText(context, user.status),
                              user.connectionCount > 0
                                  ? context.l10n.connectionCount(
                                      user.connectionCount,
                                    )
                                  : context.l10n.offline,
                            ),
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.hintColor,
                            ),
                          ),
                        ),
                        suffix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isBanned) ...[
                              AppIconButton(
                                icon: Icons.check_circle_outline,
                                iconSize: 24,
                                tooltip: context.l10n.unban,
                                onPressed: () => _banUser(user, false),
                              ),
                            ] else ...[
                              AppIconButton(
                                icon: Icons.info_outline,
                                iconSize: 22,
                                tooltip: context.l10n.details,
                                onPressed: () => _showUserDetails(user),
                              ),
                              AppIconButton(
                                icon: Icons.report_gmailerrorred_outlined,
                                iconSize: 22,
                                tooltip: context.l10n.viewReports,
                                onPressed: () => _openContentReportsViewer(
                                  context,
                                  title: context.l10n.userReports(
                                    user.username,
                                  ),
                                  targetType: 2,
                                  targetUserId: user.id,
                                  scope: admin_enum
                                      .ContentReportScope
                                      .CONTENT_REPORT_SCOPE_TARGET_USER
                                      .value,
                                ),
                              ),
                              AppIconButton(
                                icon: Icons.edit_outlined,
                                iconSize: 22,
                                tooltip: context.l10n.rename,
                                onPressed: () => _renameUser(user),
                              ),
                              AppIconButton(
                                icon: Icons.lock_reset_rounded,
                                iconSize: 22,
                                tooltip: context.l10n.resetPassword,
                                onPressed: () => _resetPassword(user),
                              ),
                              AppIconButton(
                                icon: Icons.block,
                                iconSize: 22,
                                style: AppIconButtonStyle.destructive,
                                tooltip: context.l10n.ban,
                                onPressed: () => _banUser(user, true),
                              ),
                              AppIconButton(
                                icon: isAdmin
                                    ? Icons.admin_panel_settings
                                    : Icons.admin_panel_settings_outlined,
                                iconSize: 22,
                                tooltip: isAdmin
                                    ? context.l10n.removeAdministratorRole
                                    : context.l10n.makeAdministrator,
                                onPressed: () => _toggleAdmin(user),
                              ),
                            ],
                            AppIconButton(
                              icon: Icons.delete_outline,
                              iconSize: 22,
                              style: AppIconButtonStyle.destructive,
                              tooltip: context.l10n.deleteUser,
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
      border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
      child: Row(
        children: [
          Icon(Icons.checklist_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(context.l10n.usersSelected(_selectedUserIds.length)),
          ),
          AppActionButton(
            onPressed: () => setState(_selectedUserIds.clear),
            label: context.l10n.clear,
            style: AppActionButtonStyle.text,
          ),
          const SizedBox(width: 4),
          AppActionButton(
            onPressed: _batchBanUsers,
            icon: Icons.block_rounded,
            label: context.l10n.ban,
            style: AppActionButtonStyle.tonal,
          ),
          const SizedBox(width: 8),
          AppActionButton(
            onPressed: _batchDeleteUsers,
            icon: Icons.delete_outline_rounded,
            label: context.l10n.delete,
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
      MessageUtils.showError(context, context.l10n.loadReviewsFailed('$e'));
    }
  }

  Future<void> _approve(AdminReviewItem review) async {
    try {
      await SyncTvService.adminApproveReview(_kind, review.id);
      if (!mounted) return;
      MessageUtils.showSuccess(context, context.l10n.reviewApproved);
      _loadReviews(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, context.l10n.operationFailed('$e'));
    }
  }

  Future<void> _reject(AdminReviewItem review) async {
    final l10n = context.l10n;
    final controller = TextEditingController();
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: l10n.rejectReview,
      icon: const Icon(Icons.cancel_outlined, color: Colors.red),
      content: ChatUtils.createFormField(
        context: context,
        label: l10n.reason,
        controller: controller,
        hintText: l10n.rejectionReasonHint,
        prefixIcon: Icons.edit_note_rounded,
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: l10n.reject,
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
      MessageUtils.showSuccess(context, l10n.reviewRejected);
      _loadReviews(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, l10n.operationFailed('$e'));
    }
  }

  void _applySearch(String value) {
    final normalized = value.trim();
    setState(() {
      _search = normalized;
      _requestedBy = _kind == 'room' && normalized.startsWith('usr_')
          ? normalized
          : '';
      _roomId = _kind == 'join' && normalized.startsWith('room_')
          ? normalized
          : '';
      _userId = _kind == 'join' && normalized.startsWith('usr_')
          ? normalized
          : '';
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
                segments: [
                  ButtonSegment(
                    value: 'user',
                    label: Text(context.l10n.registration),
                  ),
                  ButtonSegment(
                    value: 'room',
                    label: Text(context.l10n.roomCreation),
                  ),
                  ButtonSegment(
                    value: 'join',
                    label: Text(context.l10n.joinRequest),
                  ),
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
                  context.l10n.pendingReview:
                      common_enum.ReviewStatus.REVIEW_STATUS_PENDING.value,
                  context.l10n.approved:
                      common_enum.ReviewStatus.REVIEW_STATUS_APPROVED.value,
                  context.l10n.rejected:
                      common_enum.ReviewStatus.REVIEW_STATUS_REJECTED.value,
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
                options: {
                  context.l10n.itemsPerPage(20): 20,
                  context.l10n.itemsPerPage(50): 50,
                  context.l10n.itemsPerPage(100): 100,
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
                  hintText: context.l10n.searchReviewHint,
                  onChanged: (value) {
                    if (value.isEmpty && _search.isNotEmpty) _applySearch('');
                  },
                  onSubmitted: _applySearch,
                ),
              ),
              AppIconButton(
                tooltip: context.l10n.refresh,
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
                  child: Text(
                    context.l10n.noReviewRecords,
                    style: TextStyle(color: theme.hintColor),
                  ),
                )
              : AppListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: _reviews.length,
                  itemBuilder: (context, index) {
                    final review = _reviews[index];
                    final pending =
                        review.status ==
                        common_enum.ReviewStatus.REVIEW_STATUS_PENDING.value;
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
                            Expanded(child: _buildReviewSummary(review, theme)),
                            const SizedBox(width: 8),
                            pending
                                ? Wrap(
                                    spacing: 4,
                                    children: [
                                      AppIconButton(
                                        tooltip: context.l10n.approve,
                                        icon: Icons.check_circle_outline,
                                        onPressed: () => _approve(review),
                                      ),
                                      AppIconButton(
                                        tooltip: context.l10n.reject,
                                        icon: Icons.cancel_outlined,
                                        style: AppIconButtonStyle.destructive,
                                        onPressed: () => _reject(review),
                                      ),
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      _reviewStatusText(context, review.status),
                                    ),
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
      if (review.reviewedBy.isNotEmpty)
        context.l10n.reviewedBy(review.reviewedBy),
      if (review.reviewedAt > 0)
        context.l10n.reviewedAt(_formatTimestamp(review.reviewedAt)),
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
      backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.7,
      ),
      color: theme.colorScheme.onSurface,
      borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.08)),
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
              Icon(
                Icons.category_outlined,
                size: 18,
                color: hasError
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.providerTypes,
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
                  context.l10n.noProviderTypes,
                  style: TextStyle(color: theme.hintColor),
                ),
            ],
          ),
          if (hasError) ...[
            const SizedBox(height: 8),
            Text(
              context.l10n.selectAtLeastOneProviderType,
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
    'directUrl' => Icons.link_rounded,
    'alist' => Icons.folder_copy_outlined,
    'emby' => Icons.movie_filter_outlined,
    'bilibili' => Icons.live_tv_outlined,
    'rtmp' => Icons.podcasts_outlined,
    'cloudreve' => Icons.cloud_outlined,
    'twitch' => Icons.live_tv_rounded,
    'youtube' => Icons.smart_display_rounded,
    'douyin' => Icons.music_video_rounded,
    'tiktok' => Icons.music_video_rounded,
    'huya' => Icons.sports_esports_rounded,
    'douyu' => Icons.live_tv_rounded,
    'acfun' => Icons.ondemand_video_rounded,
    'cctv' => Icons.tv_rounded,
    'liveProxy' => Icons.route_rounded,
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
      .ProviderInstanceListSortBy
      .PROVIDER_INSTANCE_LIST_SORT_BY_NAME;
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
      MessageUtils.showError(
        context,
        context.l10n.loadProviderInstancesFailed('$e'),
      );
    }
  }

  Future<void> _editInstance([AdminProviderInstance? instance]) async {
    final l10n = context.l10n;
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
      MessageUtils.showSuccess(
        context,
        editing ? l10n.providerInstanceUpdated : l10n.providerInstanceCreated,
      );
      _loadInstances(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, l10n.saveProviderInstanceFailed('$e'));
    }
  }

  Future<void> _deleteInstance(AdminProviderInstance instance) async {
    final l10n = context.l10n;
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: l10n.deleteProvider,
      icon: const Icon(Icons.delete_forever, color: Colors.red),
      content: Text(l10n.confirmDeleteProvider(instance.name)),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: l10n.delete,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      await SyncTvService.adminDeleteProviderInstance(instance.name);
      if (!mounted) return;
      MessageUtils.showSuccess(context, l10n.providerInstanceDeleted);
      _loadInstances(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, l10n.deleteProviderFailed('$e'));
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
      MessageUtils.showError(context, context.l10n.operationFailed('$e'));
    }
  }

  Future<void> _reconnect(AdminProviderInstance instance) async {
    try {
      await SyncTvService.adminReconnectProviderInstance(instance.name);
      if (!mounted) return;
      MessageUtils.showSuccess(context, context.l10n.reconnectStarted);
      _loadInstances(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, context.l10n.reconnectFailed('$e'));
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
                      hintText: context.l10n.searchProviderInstances,
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
                      tooltip: context.l10n.add,
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
                        options: {
                          context.l10n.allStatuses: null,
                          context.l10n.enabled: true,
                          context.l10n.disabled: false,
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
                        options: {
                          context.l10n.allTlsStates: null,
                          context.l10n.tlsEnabled: true,
                          context.l10n.tlsDisabled: false,
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
                        options: {
                          context.l10n.allTypes: '',
                          'Direct URL': 'directUrl',
                          'AList': 'alist',
                          'Emby': 'emby',
                          'Bilibili': 'bilibili',
                          'RTMP': 'rtmp',
                          'Cloudreve': 'cloudreve',
                          'Twitch': 'twitch',
                          'YouTube': 'youtube',
                          'Douyin': 'douyin',
                          'TikTok': 'tiktok',
                          'Huya': 'huya',
                          'Douyu': 'douyu',
                          'AcFun': 'acfun',
                          'CCTV': 'cctv',
                          'FNOS': 'fnos',
                          'QNAP': 'qnap',
                          'Live Proxy': 'liveProxy',
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
                      child:
                          AppSelect<
                            provider_common_enum.ProviderInstanceListSortBy
                          >(
                            value: _sortBy,
                            options: {
                              context.l10n.sortByName: provider_common_enum
                                  .ProviderInstanceListSortBy
                                  .PROVIDER_INSTANCE_LIST_SORT_BY_NAME,
                              context.l10n.sortByEndpoint: provider_common_enum
                                  .ProviderInstanceListSortBy
                                  .PROVIDER_INSTANCE_LIST_SORT_BY_ENDPOINT,
                              context.l10n.sortByCreatedAt: provider_common_enum
                                  .ProviderInstanceListSortBy
                                  .PROVIDER_INSTANCE_LIST_SORT_BY_CREATED_AT,
                              context.l10n.sortByUpdatedAt: provider_common_enum
                                  .ProviderInstanceListSortBy
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
                        tooltip:
                            _sortDirection ==
                                provider_common_enum
                                    .SortDirection
                                    .SORT_DIRECTION_DESC
                            ? context.l10n.descending
                            : context.l10n.ascending,
                        icon:
                            _sortDirection ==
                                provider_common_enum
                                    .SortDirection
                                    .SORT_DIRECTION_DESC
                            ? Icons.south_rounded
                            : Icons.north_rounded,
                        onPressed: () {
                          setState(() {
                            _sortDirection =
                                _sortDirection ==
                                    provider_common_enum
                                        .SortDirection
                                        .SORT_DIRECTION_DESC
                                ? provider_common_enum
                                      .SortDirection
                                      .SORT_DIRECTION_ASC
                                : provider_common_enum
                                      .SortDirection
                                      .SORT_DIRECTION_DESC;
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
                        options: {
                          context.l10n.itemsPerPage(20): 20,
                          context.l10n.itemsPerPage(50): 50,
                          context.l10n.itemsPerPage(100): 100,
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
                  child: Text(
                    context.l10n.noProviderInstances,
                    style: TextStyle(color: theme.hintColor),
                  ),
                )
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
      border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.dns_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: _backends.isEmpty
                ? Text(
                    context.l10n.noAvailableBackends,
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
                            MessageUtils.showSuccess(
                              context,
                              context.l10n.backendCopied,
                            );
                          },
                        ),
                    ],
                  ),
          ),
          AppIconButton(
            tooltip: context.l10n.refreshBackends,
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
    final statusText = _providerStatusText(context, instance.status);
    final tlsText = !instance.tls
        ? context.l10n.tlsDisabled
        : instance.insecureTls
        ? context.l10n.tlsUnverified
        : context.l10n.tlsVerified;
    final timeText = context.l10n.providerInstanceTimes(
      _formatTimestamp(instance.createdAt),
      _formatTimestamp(instance.updatedAt),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSwitch(
            value: instance.enabled,
            semanticsLabel: context.l10n.enableProviderInstance,
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
                      label: instance.enabled
                          ? context.l10n.enabled
                          : context.l10n.disabled,
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
                tooltip: context.l10n.edit,
                icon: Icons.edit_outlined,
                onPressed: onEdit,
              ),
              AppIconButton(
                tooltip: context.l10n.reconnect,
                icon: Icons.sync_rounded,
                onPressed: onReconnect,
              ),
              AppIconButton(
                tooltip: context.l10n.delete,
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
    final title = _editing
        ? context.l10n.editProviderInstance
        : context.l10n.addProviderInstance;
    return AppDialogFrame(
      maxWidth: 860,
      maxHeight: 760,
      child: Column(
        children: [
          _ProviderEditorHeader(
            title: title,
            subtitle: _editing
                ? widget.instance!.name
                : context.l10n.configureProviderNode,
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
                  ? Column(children: _editorSections(theme, compact: true))
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Column(children: _primarySections(theme)),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          flex: 5,
                          child: Column(children: _secondarySections(theme)),
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
      title: context.l10n.basicInformation,
      children: [
        AppTextField(
          controller: _nameController,
          label: context.l10n.instanceName,
          hintText: 'provider_main',
          prefixIcon: Icons.badge_outlined,
          enabled: !_editing,
          errorText:
              _submitted && !_editing && _nameController.text.trim().isEmpty
              ? context.l10n.instanceNameRequired
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
              ? context.l10n.endpointRequired
              : null,
          autocorrect: false,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _timeoutController,
          label: context.l10n.requestTimeout,
          prefixIcon: Icons.timer_outlined,
          suffix: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              widthFactor: 1,
              child: Text(context.l10n.secondsShort),
            ),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          errorText:
              _submitted &&
                  ((int.tryParse(_timeoutController.text.trim()) ?? 0) <= 0)
              ? context.l10n.positiveIntegerRequired
              : null,
        ),
      ],
    ),
    const SizedBox(height: 16),
    _ProviderEditorSection(
      icon: Icons.category_outlined,
      title: context.l10n.capabilityTypes,
      description: context.l10n.capabilityTypesDescription,
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
      title: context.l10n.connectionSecurity,
      description: context.l10n.connectionSecurityDescription,
      children: [
        _ProviderOptionSwitch(
          icon: Icons.verified_user_outlined,
          title: context.l10n.enableTls,
          subtitle: _tls
              ? context.l10n.providerTlsConnection
              : context.l10n.providerPlainConnection,
          value: _tls,
          onChanged: (value) => setState(() {
            _tls = value;
            if (!_tls) _insecureTls = false;
          }),
        ),
        const SizedBox(height: 10),
        _ProviderOptionSwitch(
          icon: Icons.warning_amber_rounded,
          title: context.l10n.allowInsecureTls,
          subtitle: context.l10n.allowInsecureTlsDescription,
          value: _insecureTls,
          enabled: _tls,
          danger: true,
          onChanged: (value) => setState(() => _insecureTls = value),
        ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _jwtSecretController,
          label: 'JWT Secret',
          hintText: _editing
              ? context.l10n.emptyKeepsCurrentValue
              : context.l10n.optional,
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
            title: Text(context.l10n.clearJwtSecret),
          ),
        const SizedBox(height: 12),
        AppTextField(
          controller: _customCaController,
          label: 'Custom CA',
          hintText: _editing
              ? context.l10n.pemEmptyKeepsCurrent
              : context.l10n.pemOptional,
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
            title: Text(context.l10n.clearCustomCa),
          ),
      ],
    ),
    const SizedBox(height: 16),
    _ProviderEditorSection(
      icon: Icons.notes_rounded,
      title: context.l10n.notes,
      children: [
        AppTextField(
          controller: _commentController,
          label: context.l10n.notes,
          hintText: context.l10n.providerNotesHint,
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
            title: Text(context.l10n.clearNotes),
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
            label: editing ? context.l10n.edit : context.l10n.add,
            icon: editing ? Icons.edit_outlined : Icons.add_rounded,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          AppIconButton(
            tooltip: context.l10n.close,
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
      border: Border.all(color: color.withValues(alpha: 0.14)),
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
              editing
                  ? context.l10n.providerEditFooterHint
                  : context.l10n.providerCreateFooterHint,
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
            label: context.l10n.cancel,
            style: AppActionButtonStyle.outlined,
          ),
          const SizedBox(width: 10),
          AppActionButton(
            onPressed: onSubmit,
            icon: editing ? Icons.save_outlined : Icons.add_rounded,
            label: editing ? context.l10n.save : context.l10n.create,
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
      MessageUtils.showError(
        context,
        context.l10n.loadActiveStreamsFailed('$e'),
      );
    }
  }

  Future<void> _kick(AdminActiveStream stream) async {
    try {
      await SyncTvService.adminKickStream(stream);
      if (!mounted) return;
      MessageUtils.showSuccess(context, context.l10n.streamDisconnected);
      _loadStreams(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, context.l10n.operationFailed('$e'));
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
                  hintText: context.l10n.searchStreamsHint,
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
                options: {
                  context.l10n.itemsPerPage(20): 20,
                  context.l10n.itemsPerPage(50): 50,
                  context.l10n.itemsPerPage(100): 100,
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
                options: {
                  context.l10n.startedAt: admin_enum
                      .ActiveStreamListSortBy
                      .ACTIVE_STREAM_LIST_SORT_BY_STARTED_AT,
                  context.l10n.rooms: admin_enum
                      .ActiveStreamListSortBy
                      .ACTIVE_STREAM_LIST_SORT_BY_ROOM_ID,
                  context.l10n.media: admin_enum
                      .ActiveStreamListSortBy
                      .ACTIVE_STREAM_LIST_SORT_BY_MEDIA_ID,
                  context.l10n.users: admin_enum
                      .ActiveStreamListSortBy
                      .ACTIVE_STREAM_LIST_SORT_BY_USER_ID,
                  context.l10n.node: admin_enum
                      .ActiveStreamListSortBy
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
                tooltip:
                    _sortDirection ==
                        admin_enum.SortDirection.SORT_DIRECTION_DESC
                    ? context.l10n.descending
                    : context.l10n.ascending,
                icon:
                    _sortDirection ==
                        admin_enum.SortDirection.SORT_DIRECTION_DESC
                    ? Icons.south_rounded
                    : Icons.north_rounded,
                onPressed: () {
                  setState(() {
                    _sortDirection =
                        _sortDirection ==
                            admin_enum.SortDirection.SORT_DIRECTION_DESC
                        ? admin_enum.SortDirection.SORT_DIRECTION_ASC
                        : admin_enum.SortDirection.SORT_DIRECTION_DESC;
                    _page = 1;
                  });
                  _loadStreams();
                },
              ),
              AppIconButton(
                tooltip: context.l10n.refresh,
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
                  child: Text(
                    context.l10n.noActiveStreams,
                    style: TextStyle(color: theme.hintColor),
                  ),
                )
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
                          tooltip: context.l10n.disconnectStream,
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
      MessageUtils.showError(context, context.l10n.loadBanRecordsFailed('$e'));
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
      MessageUtils.showWarning(context, context.l10n.banRecordMissingTargetId);
      return;
    }

    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: isUserBan ? context.l10n.unbanUser : context.l10n.unbanRoom,
      icon: const Icon(Icons.lock_open_rounded, color: Colors.green),
      content: Text(context.l10n.confirmUnban(targetName)),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.unban,
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
      MessageUtils.showSuccess(context, context.l10n.unbanned);
      _loadRecords(silent: true);
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, context.l10n.unbanFailed('$e'));
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
                options: {
                  context.l10n.allTargets: 0,
                  context.l10n.users: 1,
                  context.l10n.rooms: 2,
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
                options: {
                  context.l10n.allStatuses: null,
                  context.l10n.active: true,
                  context.l10n.revokedOrExpired: false,
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
                options: {
                  context.l10n.itemsPerPage(20): 20,
                  context.l10n.itemsPerPage(50): 50,
                  context.l10n.itemsPerPage(100): 100,
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
                  hintText: context.l10n.userOrRoomIdHint,
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
                tooltip: context.l10n.refresh,
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
                  child: Text(
                    context.l10n.noBanRecords,
                    style: TextStyle(color: theme.hintColor),
                  ),
                )
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
                          color: record.isActive ? Colors.red : Colors.green,
                        ),
                        title: Text(target),
                        subtitle: Text(
                          context.l10n.banRecordSummary(
                            record.reason.isEmpty
                                ? context.l10n.noReason
                                : record.reason,
                            record.bannedByUsername,
                            _formatTimestamp(record.startsAt),
                          ),
                        ),
                        suffix: record.isActive
                            ? AppIconButton(
                                tooltip: context.l10n.unban,
                                icon: Icons.lock_open_rounded,
                                onPressed: () => _unbanRecord(record),
                              )
                            : Text(context.l10n.ended),
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
  final String? title;
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
    this.title,
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
    _ReportTargetTypeTab(0),
    _ReportTargetTypeTab(1),
    _ReportTargetTypeTab(2),
    _ReportTargetTypeTab(3),
    _ReportTargetTypeTab(4),
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
      MessageUtils.showError(context, context.l10n.loadReportsFailed('$e'));
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
      title: context.l10n.reportDetails,
      icon: const Icon(Icons.report_gmailerrorred_rounded, color: Colors.red),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: AppSingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ReportDetailRow(
                label: context.l10n.status,
                value: _reportStatusText(context, detail.status),
              ),
              _ReportDetailRow(
                label: context.l10n.target,
                value: _reportTargetText(context, detail),
              ),
              _ReportDetailRow(
                label: context.l10n.reporter,
                value: _reporterText(detail),
              ),
              _ReportDetailRow(
                label: context.l10n.reason,
                value: _reportReasonText(detail),
              ),
              if (detail.targetChatMessagePreview.isNotEmpty)
                _ReportDetailRow(
                  label: context.l10n.messageContent,
                  value: detail.targetChatMessagePreview,
                ),
              _ReportDetailRow(
                label: context.l10n.createdAt,
                value: _formatTimestamp(detail.createdAt),
              ),
              if (detail.reviewedByUsername.isNotEmpty ||
                  detail.reviewedBy.isNotEmpty)
                _ReportDetailRow(
                  label: context.l10n.reviewedByLabel,
                  value: detail.reviewedByUsername.isEmpty
                      ? detail.reviewedBy
                      : detail.reviewedByUsername,
                ),
              if (detail.reviewedAt > 0)
                _ReportDetailRow(
                  label: context.l10n.reviewedAtLabel,
                  value: _formatTimestamp(detail.reviewedAt),
                ),
              if (detail.resolutionNote.isNotEmpty)
                _ReportDetailRow(
                  label: context.l10n.resolutionNote,
                  value: detail.resolutionNote,
                ),
              if (detail.metadata.isNotEmpty)
                _ReportDetailRow(
                  label: context.l10n.metadata,
                  value: const JsonEncoder.withIndent(
                    '  ',
                  ).convert(detail.metadata),
                ),
            ],
          ),
        ),
      ),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(context, () {
          Navigator.pop(context);
          _openDisposition(detail);
        }, text: context.l10n.resolve),
      ],
    );
  }

  Future<void> _openDisposition(AdminContentReport report) async {
    int nextStatus =
        report.status ==
            admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_OPEN.value
        ? admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_REVIEWING.value
        : report.status;
    final noteController = TextEditingController(text: report.resolutionNote);
    final updated = await ChatUtils.showStyledDialog<AdminContentReport>(
      context: context,
      title: context.l10n.resolveReport,
      icon: const Icon(Icons.rule_rounded, color: Colors.orange),
      content: StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_reportTargetText(context, report)),
                const SizedBox(height: 12),
                AppSelect<int>(
                  value: nextStatus,
                  options: {
                    context.l10n.reviewing: 2,
                    context.l10n.resolved: 3,
                    context.l10n.dismissed: 4,
                    context.l10n.reportOpenStatus: 1,
                  },
                  onChanged: (value) {
                    if (value == null) return;
                    setDialogState(() => nextStatus = value);
                  },
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: noteController,
                  label: context.l10n.resolutionNote,
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
        ChatUtils.createConfirmButton(context, () async {
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
            MessageUtils.showError(
              context,
              context.l10n.resolveReportFailed('$e'),
            );
          }
        }, text: context.l10n.save),
      ],
    );
    noteController.dispose();
    if (updated == null || !mounted) return;
    setState(() {
      _reports = [
        for (final item in _reports) item.id == updated.id ? updated : item,
      ];
    });
    MessageUtils.showSuccess(context, context.l10n.reportStatusUpdated);
  }

  int get _pageCount {
    if (_total <= 0) return 1;
    return ((_total + _pageSize - 1) ~/ _pageSize).clamp(1, 1 << 31);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final title = widget.title ?? context.l10n.reports;
    return Column(
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              children: [
                Icon(
                  Icons.report_gmailerrorred_rounded,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
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
                child: AppTabBar(
                  controller: _targetTypeTabController!,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  dividerColor: Colors.transparent,
                  tabs: [
                    for (final tab in _visibleTargetTypeTabs)
                      Tab(
                        text: _reportTargetTypeLabel(context, tab.targetType),
                      ),
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
                options: {
                  context.l10n.allStatuses: 0,
                  context.l10n.reportOpenStatus: 1,
                  context.l10n.reviewing: 2,
                  context.l10n.resolved: 3,
                  context.l10n.dismissed: 4,
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
                      ? {context.l10n.members: 3, context.l10n.messages: 4}
                      : {
                          context.l10n.allTargets: 0,
                          context.l10n.rooms: 1,
                          context.l10n.users: 2,
                          context.l10n.members: 3,
                          context.l10n.messages: 4,
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
                options: {
                  context.l10n.itemsPerPage(20): 20,
                  context.l10n.itemsPerPage(50): 50,
                  context.l10n.itemsPerPage(100): 100,
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
                  hintText: context.l10n.searchReportsHint,
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
                tooltip: context.l10n.refresh,
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
                  child: Text(
                    context.l10n.noReportRecords,
                    style: TextStyle(color: theme.hintColor),
                  ),
                )
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
                        title: Text(_reportTargetText(context, report)),
                        subtitle: Text(
                          context.l10n.reportListSummary(
                            _reportReasonText(report),
                            _reporterText(report),
                            _formatTimestamp(report.createdAt),
                          ),
                        ),
                        suffix: AppIconButton(
                          tooltip: context.l10n.resolve,
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
      addChip(
        context.l10n.reporterFilter(_reporterUserId),
        () => _reporterUserId = '',
      );
    }
    if (!_isRoomScoped && _roomId.isNotEmpty) {
      addChip(context.l10n.contextRoomFilter(_roomId), () => _roomId = '');
    }
    if (_targetRoomId.isNotEmpty) {
      addChip(
        context.l10n.reportedRoomFilter(_targetRoomId),
        () => _targetRoomId = '',
      );
    }
    if (_targetUserId.isNotEmpty) {
      addChip(
        context.l10n.reportedUserFilter(_targetUserId),
        () => _targetUserId = '',
      );
    }
    if (_targetMemberRoomId.isNotEmpty) {
      addChip(
        context.l10n.memberRoomFilter(_targetMemberRoomId),
        () => _targetMemberRoomId = '',
      );
    }
    if (_targetMemberUserId.isNotEmpty) {
      addChip(
        context.l10n.reportedMemberFilter(_targetMemberUserId),
        () => _targetMemberUserId = '',
      );
    }
    if (_targetChatMessageId > 0) {
      addChip(
        context.l10n.messageFilter(_targetChatMessageId),
        () => _targetChatMessageId = 0,
      );
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
  final int targetType;

  const _ReportTargetTypeTab(this.targetType);
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

String _reportTargetTypeLabel(BuildContext context, int targetType) {
  return switch (targetType) {
    0 => context.l10n.allTargets,
    1 => context.l10n.rooms,
    2 => context.l10n.users,
    3 => context.l10n.members,
    4 => context.l10n.messages,
    _ => context.l10n.unknown,
  };
}

String _reportTargetText(BuildContext context, AdminContentReport report) {
  switch (report.targetType) {
    case 1:
      return context.l10n.roomTarget(
        _nameOrId(report.targetRoomName, report.targetRoomId),
      );
    case 2:
      return context.l10n.userTarget(
        _nameOrId(report.targetUsername, report.targetUserId),
      );
    case 3:
      final room = _nameOrId(
        report.targetMemberRoomName,
        report.targetMemberRoomId,
      );
      final user = _nameOrId(
        report.targetMemberUsername,
        report.targetMemberUserId,
      );
      return context.l10n.memberTarget(user, room);
    case 4:
      final room = _nameOrId(report.roomName, report.roomId);
      return context.l10n.chatMessageTarget(report.targetChatMessageId, room);
    default:
      return context.l10n.unknownTarget(report.id);
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

String _reportStatusText(BuildContext context, int status) {
  switch (status) {
    case 1:
      return context.l10n.reportOpenStatus;
    case 2:
      return context.l10n.reviewing;
    case 3:
      return context.l10n.resolved;
    case 4:
      return context.l10n.dismissed;
    default:
      return context.l10n.unknown;
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

class RuntimeSettingsSectionsTab extends StatefulWidget {
  const RuntimeSettingsSectionsTab({super.key});

  @override
  State<RuntimeSettingsSectionsTab> createState() =>
      _RuntimeSettingsSectionsTabState();
}

class _RuntimeSettingsSectionsTabState
    extends State<RuntimeSettingsSectionsTab> {
  bool _isLoading = true;
  bool _isLoadingSection = false;
  RuntimeSettingsModel? _settings;
  String? _selectedSection;
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
      final settings = await SyncTvService.runtimeGetSettings(refresh: refresh);
      if (!mounted) return;
      setState(() {
        _settings = settings;
        _selectedSection =
            _selectedSection ??
            (settings.sections.isEmpty ? null : settings.sections.first.name);
        _isLoading = false;
        _isLoadingSection = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      MessageUtils.showError(context, context.l10n.loadSettingsFailed('$e'));
    }
  }

  Future<void> _selectSection(String? sectionName) async {
    if (sectionName == null || sectionName == _selectedSection) return;
    setState(() {
      _selectedSection = sectionName;
    });
  }

  Future<void> _refreshSelectedSection({
    bool silent = false,
    bool refresh = true,
  }) async {
    final l10n = context.l10n;
    final sectionName = _selectedSection;
    if (sectionName == null) return;
    if (!silent) setState(() => _isLoadingSection = true);
    try {
      final settings = await SyncTvService.runtimeGetSettings(refresh: refresh);
      if (!mounted) return;
      setState(() {
        _settings = settings;
        _isLoadingSection = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingSection = false);
      MessageUtils.showError(context, l10n.refreshSettingsFailed('$e'));
    }
  }

  Future<void> _updateSetting(
    RuntimeSettingsSection section,
    String key,
    dynamic nextValue,
  ) async {
    final l10n = context.l10n;
    final settingId = '${section.name}.$key';
    setState(() => _savingSettings.add(settingId));

    try {
      final current = _settings;
      if (current == null) throw StateError('settings are not loaded');
      final updated = await SyncTvService.runtimeUpdateSettingInSection(
        section.name,
        key,
        identical(nextValue, _clearRuntimeSettingValue) ? null : nextValue,
      );
      if (!mounted) return;
      setState(() {
        _settings = current.replaceSection(updated);
        _savingSettings.remove(settingId);
      });
      MessageUtils.showSuccess(context, l10n.settingsUpdated);
    } catch (e) {
      if (!mounted) return;
      setState(() => _savingSettings.remove(settingId));
      MessageUtils.showError(context, l10n.updateSettingsFailed('$e'));
    }
  }

  Future<void> _editSetting(
    RuntimeSettingsSection section,
    String key,
    dynamic value,
  ) async {
    final descriptor = _settingDescriptor(
      context.l10n,
      section.name,
      key,
      value,
    );
    final normalizedValue = _normalizedSettingValue(section.name, key, value);

    if (normalizedValue is bool) {
      final confirmed = await _confirmRiskIfNeeded(descriptor);
      if (!confirmed) return;
      await _updateSetting(section, key, !normalizedValue);
      return;
    }

    final nextValue = await showAppDialog<dynamic>(
      context: context,
      builder: (context) => _SettingEditorSheet(
        descriptor: descriptor,
        sectionName: section.name,
        settingKey: key,
        value: normalizedValue,
      ),
    );
    if (nextValue == null) return;

    final confirmed = await _confirmRiskIfNeeded(descriptor);
    if (!confirmed) return;
    await _updateSetting(section, key, nextValue);
  }

  Future<void> _editOAuth2Provider(
    RuntimeSettingsSection section,
    Map<String, dynamic> providers,
    String? name,
  ) async {
    final l10n = context.l10n;
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

    final descriptor = _settingDescriptor(
      l10n,
      'oauth2',
      'providers',
      providers,
    );
    final confirmed = await _confirmRiskIfNeeded(descriptor);
    if (!confirmed) return;

    final next = Map<String, dynamic>.from(providers);
    if (name != null && name != result.name) next.remove(name);
    next[result.name] = result.value;
    await _updateSetting(
      section,
      'providers',
      _oauth2ProvidersToProtoList(next),
    );
  }

  Future<void> _deleteOAuth2Provider(
    RuntimeSettingsSection section,
    Map<String, dynamic> providers,
    String name,
  ) async {
    final l10n = context.l10n;
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: l10n.deleteLoginProvider,
      icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFE5484D)),
      content: Text(l10n.confirmDeleteLoginProvider(name)),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: l10n.delete,
        ),
      ],
    );
    if (confirmed != true) return;
    final next = Map<String, dynamic>.from(providers)..remove(name);
    await _updateSetting(
      section,
      'providers',
      _oauth2ProvidersToProtoList(next),
    );
  }

  Future<bool> _confirmRiskIfNeeded(_SettingDescriptor descriptor) async {
    final warning = descriptor.warning;
    if (warning == null || warning.isEmpty) return true;
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: context.l10n.confirmChanges,
      icon: const Icon(Icons.warning_amber_rounded, color: Color(0xFFE09F3E)),
      content: Text(warning),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.confirmChanges,
        ),
      ],
    );
    return confirmed == true;
  }

  Future<void> _sendTestEmail() async {
    final l10n = context.l10n;
    final controller = TextEditingController();
    final email = await ChatUtils.showStyledDialog<String>(
      context: context,
      title: l10n.sendTestEmail,
      icon: const Icon(Icons.outgoing_mail, color: Color(0xFF5D5FEF)),
      content: ChatUtils.createFormField(
        context: context,
        label: l10n.recipient,
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
          text: l10n.send,
        ),
      ],
    );
    if (email == null || email.isEmpty) return;
    try {
      final message = await SyncTvService.adminSendTestEmail(email);
      if (!mounted) return;
      MessageUtils.showSuccess(
        context,
        message.isEmpty ? l10n.testEmailSent : message,
      );
    } catch (e) {
      if (!mounted) return;
      MessageUtils.showError(context, l10n.sendTestEmailFailed('$e'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    if (_isLoading) return const AppLoadingIndicator();

    final sections = _settings?.sections ?? const <RuntimeSettingsSection>[];
    final selected = sections
        .where((section) => section.name == _selectedSection)
        .firstOrNull;
    final entries = selected == null
        ? <MapEntry<String, dynamic>>[]
        : (selected.settings.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key)));
    final useTwoPane =
        AppBreakpoints.widthOf(context) >= AppBreakpoints.expandedStart;

    final isOAuth2Section =
        selected?.name == 'oauth2' &&
        selected!.settings.containsKey('providers');
    final oauth2Providers = isOAuth2Section
        ? _oauth2ProvidersFromValue(
            _normalizedSettingValue(
              selected.name,
              'providers',
              selected.settings['providers'],
            ),
          )
        : <String, dynamic>{};

    final settingsList = selected == null || entries.isEmpty
        ? AppEmptyMessage(message: context.l10n.noSettings)
        : isOAuth2Section
        ? AppListView(
            padding: EdgeInsets.fromLTRB(useTwoPane ? 8 : 16, 0, 16, 24),
            children: [
              _SettingsSectionHeader(
                sectionName: selected.name,
                entryCount: oauth2Providers.length,
                isLoading: _isLoadingSection,
                action: AppActionButton(
                  icon: Icons.add_rounded,
                  label: context.l10n.addLoginProvider,
                  onPressed: _savingSettings.contains('oauth2.providers')
                      ? null
                      : () => _editOAuth2Provider(
                          selected,
                          oauth2Providers,
                          null,
                        ),
                ),
                onRefresh: _isLoadingSection
                    ? null
                    : () => _refreshSelectedSection(refresh: true),
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
                return _SettingsSectionHeader(
                  sectionName: selected.name,
                  entryCount: entries.length,
                  isLoading: _isLoadingSection,
                  action: selected.name == 'email'
                      ? AppActionButton(
                          icon: Icons.outgoing_mail,
                          label: context.l10n.sendTestEmail,
                          onPressed: _sendTestEmail,
                          style: AppActionButtonStyle.tonal,
                        )
                      : null,
                  onRefresh: _isLoadingSection
                      ? null
                      : () => _refreshSelectedSection(refresh: true),
                );
              }
              final entry = entries[index - 1];
              final normalized = _normalizedSettingValue(
                selected.name,
                entry.key,
                entry.value,
              );
              final descriptor = _settingDescriptor(
                context.l10n,
                selected.name,
                entry.key,
                normalized,
              );
              final settingId = '${selected.name}.${entry.key}';
              return _AdminPanelCard(
                isDark: isDark,
                child: _SettingTile(
                  descriptor: descriptor,
                  value: normalized,
                  saving: _savingSettings.contains(settingId),
                  onEdit: () => _editSetting(selected, entry.key, normalized),
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
                        context.l10n.runtimeSettings,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : _SettingsSectionDropdown(
                        sections: sections,
                        selectedSection: _selectedSection,
                        enabled: !_isLoadingSection,
                        onChanged: _selectSection,
                      ),
              ),
              const SizedBox(width: 12),
              AppIconButton(
                tooltip: context.l10n.refreshAll,
                icon: Icons.sync_rounded,
                style: AppIconButtonStyle.tonal,
                onPressed: _isLoadingSection
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
                          for (final section in sections)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _SettingsSectionButton(
                                sectionName: section.name,
                                selected: section.name == _selectedSection,
                                count: section.settings.length,
                                onTap: _isLoadingSection
                                    ? null
                                    : () => _selectSection(section.name),
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
    final descriptor = _settingDescriptor(context.l10n, group, key, value);
    if (value is String) {
      switch (descriptor.kind) {
        case _SettingEditorKind.oauth2Providers:
        case _SettingEditorKind.iceServers:
        case _SettingEditorKind.stringList:
        case _SettingEditorKind.permissionList:
        case _SettingEditorKind.smtpCredentials:
        case _SettingEditorKind.smtpProxy:
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
        case _SettingEditorKind.optionalText:
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
  optionalText,
  enumChoice,
  stringList,
  permissionList,
  oauth2Providers,
  iceServers,
  smtpCredentials,
  smtpProxy,
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

List<_SettingChoice> _roomPasswordChoices(AppLocalizations l10n) => [
  _SettingChoice(
    'optional',
    l10n.optional,
    l10n.roomPasswordOptionalDescription,
  ),
  _SettingChoice(
    'required',
    l10n.required,
    l10n.roomPasswordRequiredDescription,
  ),
  _SettingChoice(
    'forbidden',
    l10n.disabled,
    l10n.roomPasswordDisabledDescription,
  ),
];

const List<String> _oauth2ProviderTypes = [
  'github',
  'google',
  'logto',
  'oidc',
  'casdoor',
];

const Map<String, String> _oauth2ProviderTypeLabels = {
  'github': 'GitHub',
  'google': 'Google',
  'logto': 'Logto',
  'oidc': 'OIDC',
  'casdoor': 'Casdoor',
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

String _permissionLabel(AppLocalizations l10n, String permission) =>
    switch (permission) {
      'chat' => l10n.sendChat,
      'create_media_resource' => l10n.addMedia,
      'view_media_resources' => l10n.viewMedia,
      'view_member_list' => l10n.viewMembers,
      'view_chat_history' => l10n.viewChatHistory,
      'use_webrtc' => l10n.useWebRtc,
      'delete_media_resource_any' => l10n.deleteAnyMedia,
      'reorder_media_resources' => l10n.reorderPlaylist,
      'clear_media_resources' => l10n.clearPlaylist,
      'live_control' => l10n.liveControl,
      'play_control' => l10n.playbackControl,
      'change_current_media' => l10n.changeCurrentMedia,
      'change_playback_rate' => l10n.changePlaybackRate,
      'approve_member' => l10n.approveMember,
      'kick_member' => l10n.kickMember,
      'set_member_permissions' => l10n.setMemberPermissions,
      'add_member' => l10n.addMember,
      'set_room_settings' => l10n.changeRoomSettings,
      'delete_chat' => l10n.deleteChat,
      'delete_room' => l10n.deleteRoom,
      _ => permission,
    };

const Map<String, int> _runtimePermissionBits = {
  'chat': 1 << 0,
  'create_media_resource': 1 << 1,
  'view_media_resources': 1 << 2,
  'view_member_list': 1 << 3,
  'view_chat_history': 1 << 4,
  'use_webrtc': 1 << 5,
  'delete_media_resource_any': 1 << 6,
  'reorder_media_resources': 1 << 7,
  'clear_media_resources': 1 << 8,
  'live_control': 1 << 9,
  'play_control': 1 << 10,
  'change_current_media': 1 << 11,
  'change_playback_rate': 1 << 12,
  'approve_member': 1 << 13,
  'kick_member': 1 << 14,
  'set_member_permissions': 1 << 15,
  'add_member': 1 << 16,
  'set_room_settings': 1 << 17,
  'delete_chat': 1 << 18,
  'delete_room': 1 << 19,
};

_SettingDescriptor _settingDescriptor(
  AppLocalizations l10n,
  String section,
  String key,
  dynamic value,
) {
  final id = '$section.$key';
  final known = <String, _SettingDescriptor>{
    'roomDefaults.defaultMaxMembers': _SettingDescriptor(
      group: 'roomDefaults',
      key: 'defaultMaxMembers',
      title: l10n.defaultRoomMemberLimit,
      description: l10n.defaultRoomMemberLimitDescription,
      icon: Icons.groups_2_outlined,
      kind: _SettingEditorKind.number,
    ),
    'roomDefaults.defaultMaxChatMessages': _SettingDescriptor(
      group: 'roomDefaults',
      key: 'defaultMaxChatMessages',
      title: l10n.roomChatSnapshotLimit,
      description: l10n.roomChatSnapshotLimitDescription,
      icon: Icons.forum_outlined,
      kind: _SettingEditorKind.number,
    ),
    'roomCreation.enabled': _SettingDescriptor(
      group: 'roomCreation',
      key: 'enabled',
      title: l10n.allowRoomCreation,
      description: l10n.allowRoomCreationDescription,
      icon: Icons.add_home_work_outlined,
      kind: _SettingEditorKind.boolean,
    ),
    'roomCreation.approvalRequired': _SettingDescriptor(
      group: 'roomCreation',
      key: 'approvalRequired',
      title: l10n.roomCreationRequiresReview,
      description: l10n.roomCreationRequiresReviewDescription,
      icon: Icons.fact_check_outlined,
      kind: _SettingEditorKind.boolean,
    ),
    'roomCreation.passwordPolicy': _SettingDescriptor(
      group: 'roomCreation',
      key: 'passwordPolicy',
      title: l10n.roomPasswordPolicy,
      description: l10n.roomPasswordPolicyDescription,
      icon: Icons.password_rounded,
      kind: _SettingEditorKind.enumChoice,
      choices: _roomPasswordChoices(l10n),
    ),
    'roomCreation.maxRoomsPerUser': _SettingDescriptor(
      group: 'roomCreation',
      key: 'maxRoomsPerUser',
      title: l10n.maximumRoomsPerUser,
      description: l10n.maximumRoomsPerUserDescription,
      icon: Icons.meeting_room_outlined,
      kind: _SettingEditorKind.number,
    ),
    'user.enablePasswordSignup': _SettingDescriptor(
      group: 'user',
      key: 'enablePasswordSignup',
      title: l10n.allowPasswordSignup,
      description: l10n.allowPasswordSignupDescription,
      icon: Icons.person_add_alt_1_outlined,
      kind: _SettingEditorKind.boolean,
    ),
    'user.passwordSignupNeedReview': _SettingDescriptor(
      group: 'user',
      key: 'passwordSignupNeedReview',
      title: l10n.passwordSignupRequiresReview,
      description: l10n.passwordSignupRequiresReviewDescription,
      icon: Icons.how_to_reg_outlined,
      kind: _SettingEditorKind.boolean,
    ),
    'user.enableEmailSignup': _SettingDescriptor(
      group: 'user',
      key: 'enableEmailSignup',
      title: l10n.allowEmailSignup,
      description: l10n.allowEmailSignupDescription,
      icon: Icons.alternate_email_rounded,
      kind: _SettingEditorKind.boolean,
    ),
    'user.emailSignupNeedReview': _SettingDescriptor(
      group: 'user',
      key: 'emailSignupNeedReview',
      title: l10n.emailSignupRequiresReview,
      description: l10n.emailSignupRequiresReviewDescription,
      icon: Icons.mark_email_read_outlined,
      kind: _SettingEditorKind.boolean,
    ),
    'user.enableWebauthnSignup': _SettingDescriptor(
      group: 'user',
      key: 'enableWebauthnSignup',
      title: l10n.allowPasskeySignup,
      description: l10n.allowPasskeySignupDescription,
      icon: Icons.fingerprint_rounded,
      kind: _SettingEditorKind.boolean,
    ),
    'user.webauthnSignupNeedReview': _SettingDescriptor(
      group: 'user',
      key: 'webauthnSignupNeedReview',
      title: l10n.passkeySignupRequiresReview,
      description: l10n.passkeySignupRequiresReviewDescription,
      icon: Icons.verified_user_outlined,
      kind: _SettingEditorKind.boolean,
    ),
    'user.enableGuest': _SettingDescriptor(
      group: 'user',
      key: 'enableGuest',
      title: l10n.allowGuests,
      description: l10n.allowGuestsDescription,
      icon: Icons.person_outline_rounded,
      kind: _SettingEditorKind.boolean,
      warning: l10n.allowGuestsWarning,
    ),
    'oauth2.providers': _SettingDescriptor(
      group: 'oauth2',
      key: 'providers',
      title: l10n.externalLogin,
      description: l10n.externalLoginDescription,
      icon: Icons.account_tree_outlined,
      kind: _SettingEditorKind.oauth2Providers,
      warning: l10n.externalLoginWarning,
    ),
    'proxy.entryProxy': _SettingDescriptor(
      group: 'proxy',
      key: 'movieProxy',
      title: l10n.movieProxy,
      description: l10n.movieProxyDescription,
      icon: Icons.movie_filter_outlined,
      kind: _SettingEditorKind.boolean,
      warning: l10n.movieProxyWarning,
    ),
    'proxy.liveProxy': _SettingDescriptor(
      group: 'proxy',
      key: 'liveProxy',
      title: l10n.liveProxy,
      description: l10n.liveProxyDescription,
      icon: Icons.live_tv_outlined,
      kind: _SettingEditorKind.boolean,
      warning: l10n.liveProxyWarning,
    ),
    'rtmp.customPublishHost': _SettingDescriptor(
      group: 'rtmp',
      key: 'customPublishHost',
      title: l10n.rtmpPublishAddress,
      description: l10n.rtmpPublishAddressDescription,
      icon: Icons.podcasts_outlined,
      kind: _SettingEditorKind.optionalText,
    ),
    'rtmp.tsDisguisedAsPng': _SettingDescriptor(
      group: 'rtmp',
      key: 'tsDisguisedAsPng',
      title: l10n.tsSegmentsAsPng,
      description: l10n.tsSegmentsAsPngDescription,
      icon: Icons.image_outlined,
      kind: _SettingEditorKind.boolean,
    ),
    'email.enabled': _SettingDescriptor(
      group: 'email',
      key: 'enabled',
      title: l10n.enableEmailService,
      description: l10n.enableEmailServiceDescription,
      icon: Icons.outgoing_mail,
      kind: _SettingEditorKind.boolean,
      warning: l10n.enableEmailServiceWarning,
    ),
    'email.smtpHost': _SettingDescriptor(
      group: 'email',
      key: 'smtpHost',
      title: l10n.smtpHost,
      description: l10n.smtpHostDescription,
      icon: Icons.dns_outlined,
      kind: _SettingEditorKind.optionalText,
    ),
    'email.smtpPort': _SettingDescriptor(
      group: 'email',
      key: 'smtpPort',
      title: l10n.smtpPort,
      description: l10n.smtpPortDescription,
      icon: Icons.numbers_rounded,
      kind: _SettingEditorKind.number,
    ),
    'email.smtpCredentials': _SettingDescriptor(
      group: 'email',
      key: 'smtpCredentials',
      title: l10n.smtpAuthentication,
      description: l10n.smtpAuthenticationDescription,
      icon: Icons.password_rounded,
      kind: _SettingEditorKind.smtpCredentials,
      warning: l10n.smtpAuthenticationWarning,
    ),
    'email.smtpProxy': _SettingDescriptor(
      group: 'email',
      key: 'smtpProxy',
      title: l10n.smtpProxy,
      description: l10n.smtpProxyDescription,
      icon: Icons.route_outlined,
      kind: _SettingEditorKind.smtpProxy,
      warning: l10n.smtpProxyWarning,
    ),
    'email.useTls': _SettingDescriptor(
      group: 'email',
      key: 'useTls',
      title: l10n.useTls,
      description: l10n.useTlsDescription,
      icon: Icons.enhanced_encryption_outlined,
      kind: _SettingEditorKind.boolean,
      warning: l10n.useTlsWarning,
    ),
    'email.fromEmail': _SettingDescriptor(
      group: 'email',
      key: 'fromEmail',
      title: l10n.senderEmail,
      description: l10n.senderEmailDescription,
      icon: Icons.alternate_email_rounded,
      kind: _SettingEditorKind.optionalText,
    ),
    'email.fromName': _SettingDescriptor(
      group: 'email',
      key: 'fromName',
      title: l10n.senderDisplayName,
      description: l10n.senderDisplayNameDescription,
      icon: Icons.badge_outlined,
      kind: _SettingEditorKind.text,
    ),
    'email.whitelistEnabled': _SettingDescriptor(
      group: 'email',
      key: 'whitelistEnabled',
      title: l10n.enableEmailWhitelist,
      description: l10n.enableEmailWhitelistDescription,
      icon: Icons.mark_email_unread_outlined,
      kind: _SettingEditorKind.boolean,
    ),
    'email.whitelistDomains': _SettingDescriptor(
      group: 'email',
      key: 'whitelistDomains',
      title: l10n.emailWhitelist,
      description: l10n.emailWhitelistDescription,
      icon: Icons.playlist_add_check_rounded,
      kind: _SettingEditorKind.stringList,
    ),
    'webrtc.externalIceServers': _SettingDescriptor(
      group: 'webrtc',
      key: 'externalIceServers',
      title: l10n.externalIceServers,
      description: l10n.externalIceServersDescription,
      icon: Icons.settings_input_antenna_rounded,
      kind: _SettingEditorKind.iceServers,
      warning: l10n.externalIceServersWarning,
    ),
    'chat.maxMessagesPerRoom': _SettingDescriptor(
      group: 'chat',
      key: 'maxMessagesPerRoom',
      title: l10n.chatMessagesPerRoom,
      description: l10n.chatMessagesPerRoomDescription,
      icon: Icons.chat_bubble_outline_rounded,
      kind: _SettingEditorKind.number,
    ),
    'chat.messageRetentionDays': _SettingDescriptor(
      group: 'chat',
      key: 'messageRetentionDays',
      title: l10n.chatRetentionDays,
      description: l10n.chatRetentionDaysDescription,
      icon: Icons.history_toggle_off_rounded,
      kind: _SettingEditorKind.number,
    ),
    'cors.allowedOrigins': _SettingDescriptor(
      group: 'cors',
      key: 'allowedOrigins',
      title: l10n.allowedCorsOrigins,
      description: l10n.allowedCorsOriginsDescription,
      icon: Icons.public_rounded,
      kind: _SettingEditorKind.stringList,
      warning: l10n.allowedCorsOriginsWarning,
    ),
    'permissions.adminDefaultPermissions': _SettingDescriptor(
      group: 'permissions',
      key: 'adminDefaultPermissions',
      title: l10n.adminDefaultPermissions,
      description: l10n.adminDefaultPermissionsDescription,
      icon: Icons.admin_panel_settings_outlined,
      kind: _SettingEditorKind.permissionList,
    ),
    'permissions.memberDefaultPermissions': _SettingDescriptor(
      group: 'permissions',
      key: 'memberDefaultPermissions',
      title: l10n.memberDefaultPermissions,
      description: l10n.memberDefaultPermissionsDescription,
      icon: Icons.group_outlined,
      kind: _SettingEditorKind.permissionList,
    ),
    'permissions.guestDefaultPermissions': _SettingDescriptor(
      group: 'permissions',
      key: 'guestDefaultPermissions',
      title: l10n.guestDefaultPermissions,
      description: l10n.guestDefaultPermissionsDescription,
      icon: Icons.person_pin_circle_outlined,
      kind: _SettingEditorKind.permissionList,
      permissions: _guestPermissions,
      warning: l10n.guestDefaultPermissionsWarning,
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
    group: section,
    key: key,
    title: _humanizeSettingKey(key),
    description: l10n.runtimeSectionDescription(
      _settingsSectionLabel(l10n, section),
    ),
    icon: Icons.tune_rounded,
    kind: kind,
    secret: _isSecretKey(key),
  );
}

String _settingsSectionLabel(AppLocalizations l10n, String section) =>
    switch (section) {
      'server' => l10n.server,
      'room' => l10n.rooms,
      'user' => l10n.users,
      'oauth2' => 'OAuth2',
      'proxy' => l10n.proxy,
      'rtmp' => l10n.streaming,
      'email' => l10n.email,
      'webrtc' => 'WebRTC',
      'chat' => l10n.chat,
      'cors' => l10n.cors,
      'permissions' => l10n.permissions,
      _ => section,
    };

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

String _settingSummary(
  AppLocalizations l10n,
  dynamic value,
  _SettingDescriptor descriptor,
) {
  if (value == null) return l10n.notConfigured;
  switch (descriptor.kind) {
    case _SettingEditorKind.boolean:
      return value == true ? l10n.enabled : l10n.disabled;
    case _SettingEditorKind.oauth2Providers:
      final map = value is Map
          ? Map<String, dynamic>.from(value)
          : const <String, dynamic>{};
      if (map.isEmpty) return l10n.noExternalLoginConfigured;
      final enabled = map.values.where((entry) {
        if (entry is! Map) return false;
        final config = _oauth2ProviderConfig(Map<String, dynamic>.from(entry));
        return (config['clientId'] ?? '').toString().isNotEmpty;
      }).length;
      return l10n.oauthProviderSummary(map.length, enabled);
    case _SettingEditorKind.iceServers:
      final list = value is List ? value : const [];
      return list.isEmpty
          ? l10n.noIceServersConfigured
          : l10n.iceServerCount(list.length);
    case _SettingEditorKind.smtpCredentials:
      final credentials = value is Map
          ? Map<String, dynamic>.from(value)
          : const <String, dynamic>{};
      final username = (credentials['username'] ?? '').toString();
      return username.isEmpty
          ? l10n.authenticationDisabled
          : l10n.configuredUser(username);
    case _SettingEditorKind.smtpProxy:
      final proxy = value is Map
          ? Map<String, dynamic>.from(value)
          : const <String, dynamic>{};
      final url = (proxy['url'] ?? '').toString();
      return url.isEmpty ? l10n.directConnection : url;
    case _SettingEditorKind.optionalText:
      return value.toString();
    case _SettingEditorKind.stringList:
    case _SettingEditorKind.list:
      final list = _valueAsStringList(value);
      return list.isEmpty ? l10n.emptyList : list.join(', ');
    case _SettingEditorKind.permissionList:
      final permissions = _permissionsFromValue(value).toList()..sort();
      if (permissions.isEmpty) return l10n.noPermissions;
      return permissions
          .map((permission) => _permissionLabel(l10n, permission))
          .join(', ');
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
      return map.isEmpty
          ? l10n.emptyObject
          : l10n.configurationCount(map.length);
    case _SettingEditorKind.number:
    case _SettingEditorKind.text:
      if (descriptor.secret && value.toString().isNotEmpty) {
        return l10n.configured;
      }
      return value.toString().isEmpty ? l10n.notConfigured : value.toString();
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

Set<String> _permissionsFromValue(dynamic value) {
  if (value is List || value is String && value.trim().startsWith('[')) {
    return _valueAsStringList(value).toSet();
  }
  final bits = value is num
      ? value.toInt()
      : int.tryParse(value?.toString() ?? '') ?? 0;
  return {
    for (final entry in _runtimePermissionBits.entries)
      if ((bits & entry.value) != 0) entry.key,
  };
}

int _permissionsToBits(dynamic value) {
  final names = value is Set<String>
      ? value
      : value is Iterable
      ? value.map((item) => item.toString()).toSet()
      : _permissionsFromValue(value);
  var bits = 0;
  for (final name in names) {
    bits |= _runtimePermissionBits[name] ?? 0;
  }
  return bits;
}

class _SettingsSectionDropdown extends StatelessWidget {
  final List<RuntimeSettingsSection> sections;
  final String? selectedSection;
  final bool enabled;
  final ValueChanged<String?> onChanged;

  const _SettingsSectionDropdown({
    required this.sections,
    required this.selectedSection,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppSelect<String>(
      value: selectedSection,
      label: context.l10n.settings,
      prefixIcon: Icons.folder_outlined,
      options: {
        for (final section in sections)
          _settingsSectionLabel(context.l10n, section.name): section.name,
      },
      enabled: enabled,
      onChanged: enabled ? onChanged : null,
    );
  }
}

class _SettingsSectionButton extends StatelessWidget {
  final String sectionName;
  final bool selected;
  final int count;
  final VoidCallback? onTap;

  const _SettingsSectionButton({
    required this.sectionName,
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
              _settingsSectionLabel(context.l10n, sectionName),
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

class _SettingsSectionHeader extends StatelessWidget {
  final String sectionName;
  final int entryCount;
  final bool isLoading;
  final Widget? action;
  final VoidCallback? onRefresh;

  const _SettingsSectionHeader({
    required this.sectionName,
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
                  _settingsSectionLabel(context.l10n, sectionName),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  context.l10n.configurableSettingsCount(entryCount),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (action != null) ...[const SizedBox(width: 12), action!],
          const SizedBox(width: 8),
          AppIconButton(
            tooltip: context.l10n.refreshCurrentSection,
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
            backgroundColor: theme.colorScheme.primaryContainer.withValues(
              alpha: 0.65,
            ),
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
                  _settingSummary(context.l10n, value, descriptor),
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
              child: AppLoadingIndicator(
                size: AppLoadingSize.sm,
                centered: false,
              ),
            )
          else if (isBool)
            AppSwitch(
              value: value == true,
              semanticsLabel: descriptor.title,
              onChanged: (_) => onEdit(),
            )
          else
            AppIconButton(
              tooltip: context.l10n.edit,
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
        style: theme.textTheme.bodySmall?.copyWith(
          color: const Color(0xFF6B4E00),
        ),
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
            backgroundColor: theme.colorScheme.primaryContainer.withValues(
              alpha: 0.78,
            ),
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
            tooltip: context.l10n.close,
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
                label: context.l10n.cancel,
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
  final String sectionName;
  final String settingKey;
  final dynamic value;

  const _SettingEditorSheet({
    required this.descriptor,
    required this.sectionName,
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
  bool _optionalConfigEnabled = false;
  bool _nestedCredentialsEnabled = false;

  @override
  void initState() {
    super.initState();
    _value = _deepCopySettingValue(widget.value);
    _optionalConfigEnabled =
        widget.descriptor.kind == _SettingEditorKind.optionalText
        ? _value != null
        : _value is Map;
    if (widget.descriptor.kind == _SettingEditorKind.smtpProxy &&
        _value is Map) {
      _nestedCredentialsEnabled = (_value as Map)['credentials'] is Map;
    }
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
      id,
      () => TextEditingController(text: initial),
    );
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
                confirmLabel: context.l10n.save,
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
      case _SettingEditorKind.optionalText:
        return _buildOptionalTextEditor();
      case _SettingEditorKind.enumChoice:
        return _EnumSettingEditor(
          choices: widget.descriptor.choices,
          value: _value?.toString() ?? '',
          onChanged: (value) => setState(() => _value = value),
        );
      case _SettingEditorKind.stringList:
        return _StringListSettingEditor(
          values: _valueAsStringList(_value),
          label: context.l10n.entry,
          hintText: _stringListHint(widget.sectionName, widget.settingKey),
          onChanged: (values) => setState(() => _value = values),
        );
      case _SettingEditorKind.permissionList:
        return _PermissionListSettingEditor(
          values: _permissionsFromValue(_value),
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
      case _SettingEditorKind.smtpCredentials:
        return _buildSmtpCredentialsEditor();
      case _SettingEditorKind.smtpProxy:
        return _buildSmtpProxyEditor();
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
          label: context.l10n.entry,
          hintText: context.l10n.enterEntry,
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
      case _SettingEditorKind.optionalText:
        result = _optionalTextUpdateValue();
        break;
      case _SettingEditorKind.stringList:
        result = _valueAsStringList(_value);
        break;
      case _SettingEditorKind.oauth2Providers:
      case _SettingEditorKind.iceServers:
        result = _value;
        break;
      case _SettingEditorKind.permissionList:
        result = _permissionsToBits(_value);
        break;
      case _SettingEditorKind.smtpCredentials:
        result = _smtpCredentialsUpdateValue();
        break;
      case _SettingEditorKind.smtpProxy:
        result = _smtpProxyUpdateValue();
        break;
      case _SettingEditorKind.map:
      case _SettingEditorKind.list:
      case _SettingEditorKind.enumChoice:
      case _SettingEditorKind.boolean:
        result = _value;
        break;
    }
    Navigator.pop(context, result);
  }

  Widget _buildOptionalTextEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSwitchTile(
          value: _optionalConfigEnabled,
          onChanged: (value) => setState(() => _optionalConfigEnabled = value),
          title: Text(widget.descriptor.title),
          subtitle: Text(widget.descriptor.description),
        ),
        if (_optionalConfigEnabled) ...[
          const SizedBox(height: 16),
          AppTextField(
            controller: _controller('optionalText', _value?.toString() ?? ''),
            label: context.l10n.content,
            prefixIcon: Icons.edit_outlined,
            autocorrect: false,
            validator: (value) => value == null || value.trim().isEmpty
                ? context.l10n.enterSettingValue(widget.descriptor.title)
                : null,
          ),
        ],
      ],
    );
  }

  dynamic _optionalTextUpdateValue() {
    if (!_optionalConfigEnabled) return _clearRuntimeSettingValue;
    return _controller('optionalText').text.trim();
  }

  Widget _buildSmtpCredentialsEditor() {
    final current = _value is Map
        ? Map<String, dynamic>.from(_value as Map)
        : const <String, dynamic>{};
    final currentUsername = (current['username'] ?? '').toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSwitchTile(
          value: _optionalConfigEnabled,
          onChanged: (value) => setState(() => _optionalConfigEnabled = value),
          title: Text(context.l10n.enableSmtpAuthentication),
          subtitle: Text(context.l10n.enableSmtpAuthenticationDescription),
        ),
        if (_optionalConfigEnabled) ...[
          const SizedBox(height: 16),
          AppTextField(
            controller: _controller('credentialsUsername', currentUsername),
            label: context.l10n.username,
            prefixIcon: Icons.person_outline_rounded,
            validator: (value) => value == null || value.trim().isEmpty
                ? context.l10n.smtpUsernameRequired
                : null,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _controller('credentialsPassword'),
            label: context.l10n.password,
            hintText: currentUsername.isEmpty
                ? context.l10n.passwordRequired
                : context.l10n.emptyKeepsCurrentPassword,
            prefixIcon: Icons.password_rounded,
            obscureText: true,
            autocorrect: false,
            validator: (value) {
              final username = _controller('credentialsUsername').text.trim();
              final usernameChanged = username != currentUsername;
              if ((currentUsername.isEmpty || usernameChanged) &&
                  (value == null || value.isEmpty)) {
                return context.l10n.passwordRequiredForNewCredentials;
              }
              return null;
            },
          ),
        ],
      ],
    );
  }

  Widget _buildSmtpProxyEditor() {
    final current = _value is Map
        ? Map<String, dynamic>.from(_value as Map)
        : const <String, dynamic>{};
    final credentials = current['credentials'] is Map
        ? Map<String, dynamic>.from(current['credentials'] as Map)
        : const <String, dynamic>{};
    final currentUsername = (credentials['username'] ?? '').toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSwitchTile(
          value: _optionalConfigEnabled,
          onChanged: (value) => setState(() => _optionalConfigEnabled = value),
          title: Text(context.l10n.enableSmtpProxy),
          subtitle: Text(context.l10n.enableSmtpProxyDescription),
        ),
        if (_optionalConfigEnabled) ...[
          const SizedBox(height: 16),
          AppTextField(
            controller: _controller(
              'proxyUrl',
              (current['url'] ?? '').toString(),
            ),
            label: context.l10n.socks5ProxyAddress,
            hintText: 'socks5://proxy.example.com:1080',
            prefixIcon: Icons.route_outlined,
            keyboardType: TextInputType.url,
            autocorrect: false,
            validator: (value) {
              final url = value?.trim() ?? '';
              return url.startsWith('socks5://')
                  ? null
                  : context.l10n.socks5ProxyAddressRequired;
            },
          ),
          const SizedBox(height: 12),
          AppSwitchTile(
            value: _nestedCredentialsEnabled,
            onChanged: (value) =>
                setState(() => _nestedCredentialsEnabled = value),
            title: Text(context.l10n.proxyRequiresAuthentication),
            subtitle: Text(context.l10n.proxyAuthenticationDescription),
          ),
          if (_nestedCredentialsEnabled) ...[
            const SizedBox(height: 12),
            AppTextField(
              controller: _controller('proxyUsername', currentUsername),
              label: context.l10n.proxyUsername,
              prefixIcon: Icons.manage_accounts_outlined,
              validator: (value) => value == null || value.trim().isEmpty
                  ? context.l10n.proxyUsernameRequired
                  : null,
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _controller('proxyPassword'),
              label: context.l10n.proxyPassword,
              hintText: currentUsername.isEmpty
                  ? context.l10n.passwordRequired
                  : context.l10n.emptyKeepsCurrentPassword,
              prefixIcon: Icons.key_outlined,
              obscureText: true,
              autocorrect: false,
              validator: (value) {
                final username = _controller('proxyUsername').text.trim();
                final usernameChanged = username != currentUsername;
                if ((currentUsername.isEmpty || usernameChanged) &&
                    (value == null || value.isEmpty)) {
                  return context.l10n.passwordRequiredForNewCredentials;
                }
                return null;
              },
            ),
          ],
        ],
      ],
    );
  }

  dynamic _smtpCredentialsUpdateValue() {
    if (!_optionalConfigEnabled) return _clearRuntimeSettingValue;
    final password = _controller('credentialsPassword').text;
    return {
      'username': _controller('credentialsUsername').text.trim(),
      if (password.isNotEmpty) 'password': password,
    };
  }

  dynamic _smtpProxyUpdateValue() {
    if (!_optionalConfigEnabled) return _clearRuntimeSettingValue;
    final password = _controller('proxyPassword').text;
    return {
      'url': _controller('proxyUrl').text.trim(),
      if (_nestedCredentialsEnabled)
        'credentials': {
          'username': _controller('proxyUsername').text.trim(),
          if (password.isNotEmpty) 'password': password,
        },
    };
  }

  String _stringListHint(String group, String key) {
    if (group == 'cors') return 'https://app.example.com';
    if (group == 'email') return '@example.com';
    return context.l10n.enterEntry;
  }
}

final class _ClearRuntimeSettingValue {
  const _ClearRuntimeSettingValue();
}

const _clearRuntimeSettingValue = _ClearRuntimeSettingValue();

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
      label: context.l10n.value,
      prefixIcon: Icons.pin_outlined,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return context.l10n.valueRequired;
        }
        return num.tryParse(value.trim()) == null
            ? context.l10n.validNumberRequired
            : null;
      },
    );
  }
}

class _TextSettingEditor extends StatefulWidget {
  final TextEditingController controller;
  final bool secret;

  const _TextSettingEditor({required this.controller, required this.secret});

  @override
  State<_TextSettingEditor> createState() => _TextSettingEditorState();
}

class _TextSettingEditorState extends State<_TextSettingEditor> {
  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      label: context.l10n.content,
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
                  tooltip: context.l10n.delete,
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
            label: context.l10n.add,
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
            label: Text(_permissionLabel(context.l10n, permission)),
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
  List<dynamic> list;
  if (value is Map) {
    final providers = value['providers'];
    if (providers is List) return _oauth2ProvidersFromList(providers);
    return Map<String, dynamic>.from(value);
  }
  if (value is String && value.trim().isNotEmpty) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map) return _oauth2ProvidersFromValue(decoded);
      if (decoded is List) {
        list = decoded;
        return _oauth2ProvidersFromList(list);
      }
    } catch (_) {}
  }
  if (value is List) return _oauth2ProvidersFromList(value);
  return <String, dynamic>{};
}

Map<String, dynamic> _oauth2ProvidersFromList(List<dynamic> providers) {
  return {
    for (final provider in providers)
      if (provider is Map)
        (provider['name'] ?? '').toString(): Map<String, dynamic>.from(
          provider,
        ),
  }..remove('');
}

Map<String, dynamic> _oauth2ProviderConfig(Map<String, dynamic> value) {
  final type = _oauth2ProviderType(value);
  final preferred = value[_oauth2ProviderConfigField(type)];
  if (preferred is Map) return Map<String, dynamic>.from(preferred);
  return <String, dynamic>{};
}

String _oauth2ProviderType(Map<String, dynamic> value) {
  for (final type in _oauth2ProviderTypes) {
    if (value[type] is Map) return type;
  }
  return 'oidc';
}

String _oauth2ProviderConfigField(String type) {
  return _oauth2ProviderTypes.contains(type) ? type : 'oidc';
}

List<Map<String, dynamic>> _oauth2ProvidersToProtoList(
  Map<String, dynamic> providers,
) {
  return providers.entries
      .map((entry) {
        final value = entry.value is Map
            ? Map<String, dynamic>.from(entry.value)
            : <String, dynamic>{};
        final type = _oauth2ProviderType(value);
        final config = _oauth2ProviderConfig(value);
        return <String, dynamic>{
          'name': entry.key,
          'enableSignup': value['enableSignup'] == true,
          'signupNeedReview': value['signupNeedReview'] == true,
          _oauth2ProviderConfigField(type): config,
        };
      })
      .toList(growable: false);
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
          _EmptySettingsNotice(
            icon: Icons.account_tree_outlined,
            title: context.l10n.noLoginProviders,
            message: context.l10n.noLoginProvidersDescription,
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
            label: context.l10n.addLoginProvider,
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
          _EmptySettingsNotice(
            icon: Icons.account_tree_outlined,
            title: context.l10n.noLoginProviders,
            message: context.l10n.addLoginProviderHint,
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
    final providerType = _oauth2ProviderType(value);
    final config = _oauth2ProviderConfig(value);
    final hasClientId = (config['clientId'] ?? '').toString().isNotEmpty;
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
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    context.l10n.loginProviderSummary(
                      _oauth2ProviderTypeLabels[providerType] ?? providerType,
                      hasClientId
                          ? context.l10n.clientConfigured
                          : context.l10n.clientIdMissing,
                    ),
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
                        label: value['enableSignup'] == true
                            ? context.l10n.signupAllowed
                            : context.l10n.loginBindingOnly,
                        icon: value['enableSignup'] == true
                            ? Icons.person_add_alt_1_outlined
                            : Icons.login_rounded,
                      ),
                      if (value['signupNeedReview'] == true)
                        _StatusChip(
                          label: context.l10n.signupRequiresReview,
                          icon: Icons.fact_check_outlined,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            AppIconButton(
              tooltip: context.l10n.edit,
              icon: Icons.edit_outlined,
              onPressed: onEdit,
            ),
            AppIconButton(
              tooltip: context.l10n.delete,
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
      backgroundColor: theme.colorScheme.secondaryContainer.withValues(
        alpha: 0.7,
      ),
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
    final config = _oauth2ProviderConfig(widget.initialValue);
    _type = _oauth2ProviderType(widget.initialValue);
    if (!_oauth2ProviderTypes.contains(_type)) _type = 'oidc';
    _enableSignup = widget.initialValue['enableSignup'] == true;
    _signupNeedReview = widget.initialValue['signupNeedReview'] == true;
    _name = TextEditingController(text: widget.initialName ?? _type);
    _clientId = TextEditingController(
      text: (config['clientId'] ?? '').toString(),
    );
    _clientSecret = TextEditingController(
      text: (config['clientSecret'] ?? '').toString(),
    );
    _redirectUrl = TextEditingController(
      text: (config['redirectUrl'] ?? '').toString(),
    );
    _endpoint = TextEditingController(
      text: (config['endpoint'] ?? '').toString(),
    );
    _issuer = TextEditingController(text: (config['issuer'] ?? '').toString());
    _authUrl = TextEditingController(
      text: (config['authUrl'] ?? '').toString(),
    );
    _tokenUrl = TextEditingController(
      text: (config['tokenUrl'] ?? '').toString(),
    );
    _userinfoUrl = TextEditingController(
      text: (config['userinfoUrl'] ?? '').toString(),
    );
    _jwksUrl = TextEditingController(
      text: (config['jwksUrl'] ?? '').toString(),
    );
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
                title: widget.initialName == null
                    ? context.l10n.addExternalLogin
                    : context.l10n.editExternalLogin,
                subtitle: context.l10n.externalLoginEditorDescription,
                onClose: () => Navigator.pop(context),
              ),
              Flexible(
                child: AppSingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _name,
                        label: context.l10n.instanceName,
                        helperText: context.l10n.instanceNameFormatHint,
                        prefixIcon: Icons.badge_outlined,
                        validator: _validateProviderName,
                        autocorrect: false,
                        smartDashesType: SmartDashesType.disabled,
                        smartQuotesType: SmartQuotesType.disabled,
                      ),
                      const SizedBox(height: 12),
                      AppSelect<String>(
                        value: _type,
                        label: context.l10n.providerType,
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
                                    _oauth2ProviderTypes.contains(
                                      _name.text.trim(),
                                    ))) {
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
                            ? context.l10n.clientSecretRequired
                            : null,
                        autocorrect: false,
                        smartDashesType: SmartDashesType.disabled,
                        smartQuotesType: SmartQuotesType.disabled,
                      ),
                      const SizedBox(height: 12),
                      _oauthTextField(
                        _redirectUrl,
                        context.l10n.callbackUrl,
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
                      if (_type == 'oidc' || _type == 'casdoor') ...[
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
                          context.l10n.authorizationEndpoint,
                          Icons.open_in_browser_rounded,
                          hintText: context.l10n.emptyUsesOidcDiscovery,
                          validator: _validateOptionalHttpUrl,
                        ),
                        const SizedBox(height: 12),
                        _oauthTextField(
                          _tokenUrl,
                          context.l10n.tokenEndpoint,
                          Icons.token_outlined,
                          hintText: context.l10n.emptyUsesOidcDiscovery,
                          validator: _validateOptionalHttpUrl,
                        ),
                        const SizedBox(height: 12),
                        _oauthTextField(
                          _userinfoUrl,
                          context.l10n.userInfoEndpoint,
                          Icons.person_search_outlined,
                          hintText: context.l10n.emptyUsesOidcDiscovery,
                          validator: _validateOptionalHttpUrl,
                        ),
                        const SizedBox(height: 12),
                        _oauthTextField(
                          _jwksUrl,
                          context.l10n.jwksEndpoint,
                          Icons.security_rounded,
                          hintText: context.l10n.emptyUsesOidcDiscovery,
                          validator: _validateOptionalHttpUrl,
                        ),
                      ],
                      const SizedBox(height: 8),
                      AppSwitchTile(
                        value: _enableSignup,
                        onChanged: (value) =>
                            setState(() => _enableSignup = value),
                        title: Text(context.l10n.allowProviderSignup),
                        subtitle: Text(
                          context.l10n.allowProviderSignupDescription,
                        ),
                      ),
                      AppSwitchTile(
                        value: _signupNeedReview,
                        onChanged: _enableSignup
                            ? (value) =>
                                  setState(() => _signupNeedReview = value)
                            : null,
                        title: Text(context.l10n.signupRequiresReview),
                      ),
                    ],
                  ),
                ),
              ),
              _SettingsDialogActions(
                confirmLabel: context.l10n.saveInstance,
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
      validator:
          validator ??
          (required
              ? (value) => (value == null || value.trim().isEmpty)
                    ? context.l10n.fieldRequired(label)
                    : null
              : null),
      autocorrect: false,
      smartDashesType: SmartDashesType.disabled,
      smartQuotesType: SmartQuotesType.disabled,
    );
  }

  String? _validateProviderName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return context.l10n.instanceNameRequired;
    if (name.length > 64) return context.l10n.instanceNameTooLong(64);
    if (!RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(name)) {
      return context.l10n.instanceNameFormatHint;
    }
    if (name != widget.initialName && widget.existingNames.contains(name)) {
      return context.l10n.instanceNameExists;
    }
    return null;
  }

  String? _validateHttpUrl(String? value) {
    final raw = value?.trim() ?? '';
    if (raw.isEmpty) return context.l10n.urlRequired;
    final uri = Uri.tryParse(raw);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return context.l10n.validUrlRequired;
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return context.l10n.httpUrlRequired;
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
      'clientId': _clientId.text.trim(),
      'clientSecret': _clientSecret.text,
      'redirectUrl': _redirectUrl.text.trim(),
    };
    if (_type == 'logto') {
      config['endpoint'] = _endpoint.text.trim();
    }
    if (_type == 'oidc' || _type == 'casdoor') {
      config['issuer'] = _issuer.text.trim();
      for (final entry in {
        'authUrl': _authUrl.text.trim(),
        'tokenUrl': _tokenUrl.text.trim(),
        'userinfoUrl': _userinfoUrl.text.trim(),
        'jwksUrl': _jwksUrl.text.trim(),
      }.entries) {
        if (entry.value.isNotEmpty) config[entry.key] = entry.value;
      }
    }
    Navigator.pop(
      context,
      _OAuth2ProviderEditResult(_name.text.trim(), {
        'enableSignup': _enableSignup,
        'signupNeedReview': _enableSignup && _signupNeedReview,
        _oauth2ProviderConfigField(_type): config,
      }),
    );
  }
}

class _IceServersEditor extends StatelessWidget {
  final List<Map<String, dynamic>> servers;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;

  const _IceServersEditor({required this.servers, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (servers.isEmpty)
          _EmptySettingsNotice(
            icon: Icons.settings_input_antenna_rounded,
            title: context.l10n.noIceServersConfigured,
            message: context.l10n.noIceServersDescription,
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
            label: context.l10n.addIceServer,
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
      text: (widget.value['username'] ?? '').toString(),
    );
    _credential = TextEditingController(
      text: (widget.value['credential'] ?? '').toString(),
    );
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
                    context.l10n.iceServerNumber(widget.index + 1),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                AppIconButton(
                  tooltip: context.l10n.delete,
                  icon: Icons.delete_outline_rounded,
                  style: AppIconButtonStyle.destructive,
                  onPressed: widget.onDelete,
                ),
              ],
            ),
            AppTextField(
              controller: _urls,
              label: 'URL',
              helperText: context.l10n.iceServerUrlsHint,
              prefixIcon: Icons.link_rounded,
              minLines: 1,
              maxLines: 4,
              onChanged: (_) => _emit(),
              autocorrect: false,
              smartDashesType: SmartDashesType.disabled,
              smartQuotesType: SmartQuotesType.disabled,
              validator: (value) {
                final urls =
                    value
                        ?.split(RegExp(r'[\n,]'))
                        .map((url) => url.trim())
                        .where((url) => url.isNotEmpty)
                        .toList() ??
                    const [];
                if (urls.isEmpty) return context.l10n.atLeastOneUrlRequired;
                final invalid = urls.where(
                  (url) =>
                      !(url.startsWith('stun:') ||
                          url.startsWith('turn:') ||
                          url.startsWith('turns:')),
                );
                return invalid.isNotEmpty
                    ? context.l10n.iceServerUrlSchemeRequired
                    : null;
              },
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _username,
              label: context.l10n.username,
              prefixIcon: Icons.person_outline_rounded,
              onChanged: (_) => _emit(),
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _credential,
              label: context.l10n.credential,
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

  const _StructuredValueEditor({required this.value, required this.onChanged});

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

  const _AdminPanelCard({required this.isDark, required this.child});

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
        ? context.l10n.pageSizeSummary(page, pageSize)
        : context.l10n.pageSizeTotalSummary(page, pageSize, total);
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
      MessageUtils.showError(context, context.l10n.loadChatHistoryFailed('$e'));
    }
  }

  Future<void> _copyMessage(RoomChatMessageInfo message) async {
    final text = _messagePreview(context, message).trim();
    if (text.isEmpty) {
      MessageUtils.showInfo(context, context.l10n.messageHasNoCopyableContent);
      return;
    }
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) MessageUtils.showSuccess(context, context.l10n.messageCopied);
  }

  Future<void> _deleteMessage(RoomChatMessageInfo message) async {
    if (message.id.isEmpty) return;
    final confirmed = await showAppDialog<bool>(
      context: context,
      builder: (context) => AppConfirmDialog(
        title: context.l10n.deleteMessage,
        icon: const Icon(Icons.delete_outline_rounded),
        content: Text(context.l10n.confirmDeleteUserMessage(message.username)),
        confirmLabel: context.l10n.delete,
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
      MessageUtils.showSuccess(context, context.l10n.messageDeleted);
    } catch (e) {
      if (mounted) {
        MessageUtils.showError(context, context.l10n.deleteMessageFailed('$e'));
      }
    }
  }

  Future<void> _reportMessage(RoomChatMessageInfo message) async {
    if (message.id.isEmpty) return;
    final reasons = <String, String>{
      'spam': context.l10n.reportReasonSpam,
      'abuse': context.l10n.reportReasonAbuse,
      'illegal': context.l10n.reportReasonIllegal,
      'sexual': context.l10n.reportReasonSexual,
      'other': context.l10n.reportReasonOther,
    };
    var selectedReason = 'spam';
    final detailController = TextEditingController();
    final submitted = await showAppDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AppDialog(
              title: Text(context.l10n.reportMessage),
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
                      label: context.l10n.additionalDetails,
                      hintText: context.l10n.describeIssue,
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
                  label: context.l10n.submit,
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
      if (mounted) {
        MessageUtils.showSuccess(context, context.l10n.reportSubmitted);
      }
    } catch (e) {
      if (mounted) {
        MessageUtils.showError(context, context.l10n.reportFailed('$e'));
      }
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
      if (mounted) {
        MessageUtils.showError(
          context,
          context.l10n.loadMessageContextFailed('$e'),
        );
      }
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
                  Text(context.l10n.chatHistory),
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
                    label: Text(context.l10n.messagesLoaded(_messages.length)),
                  ),
                  const SizedBox(width: 8),
                  if (_nextCursor.isNotEmpty)
                    AppBadge(
                      icon: Icons.more_horiz_rounded,
                      label: Text(context.l10n.olderMessagesAvailable),
                    ),
                  const Spacer(),
                  AppIconButton(
                    tooltip: context.l10n.refresh,
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
                    ? AppEmptyMessage(message: context.l10n.noChatMessages)
                    : AppListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                        itemCount:
                            _messages.length + (_nextCursor.isEmpty ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index >= _messages.length) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: AppActionButton(
                                  onPressed: _loadingMore ? null : _loadMore,
                                  icon: Icons.history_rounded,
                                  label: _loadingMore
                                      ? context.l10n.loading
                                      : context.l10n.loadOlderMessages,
                                  style: AppActionButtonStyle.outlined,
                                ),
                              ),
                            );
                          }
                          final message = _messages[index];
                          return _AdminChatMessageCard(
                            message: message,
                            quoted: _messageIndex[message.replyToMessageId],
                            highlighted: _highlightedMessageId == message.id,
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
                  Text(context.l10n.messageContext),
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
                        message.username.isEmpty
                            ? context.l10n.deletedUser
                            : message.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        context.l10n.messageAuthorTime(
                          message.userId.isEmpty
                              ? context.l10n.anonymous
                              : message.userId,
                          _formatTimestamp(message.timestamp),
                        ),
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
                  AppBadge(
                    icon: Icons.edit_outlined,
                    label: Text(context.l10n.edited),
                  ),
                if (isDeleted)
                  AppBadge(
                    icon: Icons.delete_outline_rounded,
                    label: Text(context.l10n.deleted),
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
                isDeleted
                    ? context.l10n.messageDeletedContent
                    : message.content,
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
                  label: context.l10n.copy,
                  size: AppActionButtonSize.sm,
                  style: AppActionButtonStyle.text,
                ),
                if (onContext != null)
                  AppActionButton(
                    onPressed: onContext,
                    icon: Icons.manage_search_rounded,
                    label: context.l10n.context,
                    size: AppActionButtonSize.sm,
                    style: AppActionButtonStyle.text,
                  ),
                AppActionButton(
                  onPressed: onReport,
                  icon: Icons.flag_outlined,
                  label: context.l10n.report,
                  size: AppActionButtonSize.sm,
                  style: AppActionButtonStyle.text,
                ),
                AppActionButton(
                  onPressed: isDeleted ? null : onDelete,
                  icon: Icons.delete_outline_rounded,
                  label: context.l10n.delete,
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
    final title = quoted?.username.trim().isNotEmpty == true
        ? quoted!.username
        : context.l10n.quotedMessage;
    final preview = quoted == null
        ? context.l10n.tapToViewContext
        : _messagePreview(context, quoted!);
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
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
            child: const Icon(Icons.broken_image_outlined),
          ),
        );
      }).toList(),
    );
  }
}

String _messagePreview(BuildContext context, RoomChatMessageInfo message) {
  final parts = <String>[];
  if (message.content.trim().isNotEmpty) parts.add(message.content.trim());
  if (message.images.isNotEmpty) {
    parts.add(context.l10n.imageCount(message.images.length));
  }
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

  const _StatTile(this.label, this.value, this.icon, this.color, this.isDark);

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

String _reviewStatusText(BuildContext context, int status) {
  return switch (status) {
    1 => context.l10n.pendingReview,
    2 => context.l10n.approved,
    3 => context.l10n.rejected,
    _ => context.l10n.unknown,
  };
}

String _providerStatusText(BuildContext context, int status) {
  return switch (status) {
    1 => context.l10n.connected,
    2 => context.l10n.disconnected,
    3 => context.l10n.error,
    _ => context.l10n.unknown,
  };
}

String _systemRoleText(BuildContext context, int role) {
  return switch (role) {
    1 => 'Root',
    2 => context.l10n.administrator,
    3 => context.l10n.user,
    _ => context.l10n.unknown,
  };
}

String _userStatusText(BuildContext context, int status) {
  return switch (status) {
    1 => context.l10n.active,
    2 => context.l10n.banned,
    _ => context.l10n.unknown,
  };
}

String _roomStatusText(BuildContext context, int status) {
  return switch (status) {
    1 => context.l10n.active,
    2 => context.l10n.closed,
    _ => context.l10n.unknown,
  };
}

String _resourceAvailabilityText(BuildContext context, int availability) {
  return switch (availability) {
    1 => context.l10n.available,
    2 => context.l10n.creatorUnavailable,
    _ => context.l10n.unknown,
  };
}

Color _roomStatusColor(int status) {
  return switch (status) {
    1 => Colors.green,
    2 => Colors.grey,
    _ => Colors.grey,
  };
}

String _roomMemberRoleText(BuildContext context, int role) {
  return switch (role) {
    1 => context.l10n.creator,
    2 => context.l10n.administrator,
    3 => context.l10n.member,
    4 => context.l10n.guest,
    _ => context.l10n.unknown,
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
    label: context.l10n.close,
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
