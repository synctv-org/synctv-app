import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:synctv_app/core/config/distribution_profile.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/features/admin/presentation/admin_gateway_scope.dart';
import 'package:synctv_app/features/admin/presentation/admin_chat_moderation_optimism.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/content_reports/presentation/content_reports_view.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/src/generated/proto/providers/common.pbenum.dart'
    as provider_common_enum;
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/features/room/domain/chat_reactions.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/features/room/presentation/room_taxonomy.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/core/presentation/media_provider_brand.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

part 'admin_shared_widgets.dart';
part 'tabs/administrators_tab.dart';
part 'tabs/ban_records_tab.dart';
part 'tabs/cache_tab.dart';
part 'tabs/providers_tab.dart';
part 'tabs/reviews_tab.dart';
part 'tabs/rooms_tab.dart';
part 'tabs/runtime_settings_tab.dart';
part 'tabs/streams_tab.dart';
part 'tabs/taxonomy_tab.dart';
part 'tabs/users_tab.dart';

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
  admin_enum.ContentReportTargetType targetType =
      admin_enum.ContentReportTargetType.CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED,
  String reporterUserId = '',
  String roomId = '',
  String targetRoomId = '',
  String targetUserId = '',
  String targetMemberRoomId = '',
  String targetMemberUserId = '',
  int targetChatMessageId = 0,
  admin_enum.ContentReportScope scope =
      admin_enum.ContentReportScope.CONTENT_REPORT_SCOPE_UNSPECIFIED,
  String search = '',
}) {
  return AppDialogs.showStyledDialog<void>(
    context: context,
    title: title,
    icon: const Icon(Icons.report_gmailerrorred_rounded, color: Colors.red),
    content: SizedBox(
      width: 900,
      height: 620,
      child: ContentReportsView(
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
        showTargetTypeTabs:
            targetType ==
            admin_enum
                .ContentReportTargetType
                .CONTENT_REPORT_TARGET_TYPE_UNSPECIFIED,
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
  'synology': 'Synology DSM',
  'nextcloud': 'Nextcloud',
  'seafile': 'Seafile',
  'truenas': 'TrueNAS',
  'liveProxy': 'Live Proxy',
};

String _providerTypeLabel(String provider) {
  return mediaProviderBrand(provider).label;
}

List<String> _providerTypeOptions({
  String selectedFilter = '',
  Iterable<String> selectedProviders = const [],
}) {
  final values = <String>{
    ..._providerTypeLabels.keys.where(
      ProviderDistributionPolicy.current.allowsProvider,
    ),
    ...selectedProviders.where(
      (value) =>
          value.isNotEmpty &&
          ProviderDistributionPolicy.current.allowsProvider(value),
    ),
  };
  if (selectedFilter.isNotEmpty &&
      ProviderDistributionPolicy.current.allowsProvider(selectedFilter)) {
    values.add(selectedFilter);
  }
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
  static const int _sectionCount = 12;

  List<_AdminSection> get _sections => [
    _AdminSection(
      label: context.l10n.overview,
      icon: Icons.dashboard_rounded,
      page: const AdminOverviewTab(),
    ),
    _AdminSection(
      label: context.l10n.administrators,
      icon: Icons.admin_panel_settings_rounded,
      page: const AdministratorsTab(),
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
      page: const ContentReportsView(),
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
      label: context.l10n.sliceCache,
      icon: Icons.storage_rounded,
      page: const AdminSliceCacheTab(),
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
        appBar: AppPageBar(
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
      final stats = await adminGateway.adminGetServiceState();
      if (!mounted) return;
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      AppNotifications.showError(
        context,
        context.l10n.loadOverviewFailed('$e'),
      );
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
                  context.l10n.onlineMembersLabel,
                  stats.onlineMembers,
                  Icons.online_prediction_rounded,
                  Colors.lightGreen,
                  isDark,
                ),
                _StatTile(
                  context.l10n.onlineGuestsLabel,
                  stats.onlineGuests,
                  Icons.person_outline_rounded,
                  Colors.teal,
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
