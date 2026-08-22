import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/home/presentation/widgets/cinema_room_card.dart';
import 'package:synctv_app/core/presentation/widgets/synctv_brand_mark.dart';

@immutable
class HomeViewState {
  const HomeViewState({
    required this.identity,
    required this.hasServer,
    required this.isLoading,
    required this.isLoadingTaxonomy,
    required this.rooms,
    required this.featuredRooms,
    required this.joinedRooms,
    required this.categories,
    required this.totalRooms,
    required this.page,
    required this.pageCount,
    required this.selectedCategoryId,
    required this.selectedLabelCount,
    required this.favoriteRoomIdsInFlight,
    this.currentUser,
    this.isAdmin = false,
  });

  final SyncTvSessionIdentity identity;
  final bool hasServer;
  final bool isLoading;
  final bool isLoadingTaxonomy;
  final List<SyncTvRoom> rooms;
  final List<SyncTvRoom> featuredRooms;
  final List<SyncTvRoom> joinedRooms;
  final List<RoomCategoryInfo> categories;
  final int totalRooms;
  final int page;
  final int pageCount;
  final String selectedCategoryId;
  final int selectedLabelCount;
  final Set<String> favoriteRoomIdsInFlight;
  final SyncTvUser? currentUser;
  final bool isAdmin;

  bool get isAccount => identity is AccountSessionIdentity;
}

@immutable
class HomeViewCallbacks {
  const HomeViewCallbacks({
    required this.openServerSettings,
    required this.openLanguageSelector,
    required this.openLogin,
    required this.openJoinRoom,
    required this.openCreateRoom,
    required this.openAccountCenter,
    required this.openAdminSettings,
    required this.logout,
    required this.refresh,
    required this.search,
    required this.selectCategory,
    required this.openLabelFilter,
    required this.clearFilters,
    required this.openRoom,
    required this.toggleFavorite,
    required this.deleteRoom,
    required this.goToPage,
  });

  final VoidCallback openServerSettings;
  final VoidCallback openLanguageSelector;
  final VoidCallback openLogin;
  final VoidCallback openJoinRoom;
  final VoidCallback openCreateRoom;
  final VoidCallback openAccountCenter;
  final VoidCallback openAdminSettings;
  final VoidCallback logout;
  final Future<void> Function() refresh;
  final ValueChanged<String> search;
  final ValueChanged<String> selectCategory;
  final VoidCallback openLabelFilter;
  final VoidCallback clearFilters;
  final ValueChanged<SyncTvRoom> openRoom;
  final ValueChanged<SyncTvRoom> toggleFavorite;
  final ValueChanged<SyncTvRoom> deleteRoom;
  final ValueChanged<int> goToPage;
}

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    required this.state,
    required this.callbacks,
    required this.searchController,
  });

  final HomeViewState state;
  final HomeViewCallbacks callbacks;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppPageBar(
        // Keep the discovery header compact while leaving the macOS title-bar
        // inset and 44px action targets intact.
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: _HomeHeader(state: state, callbacks: callbacks),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 2,
            child: state.isLoading
                ? const AppLinearProgress(minHeight: 2)
                : null,
          ),
          Expanded(
            child: _DiscoveryBody(
              state: state,
              callbacks: callbacks,
              searchController: searchController,
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.state, required this.callbacks});

  final HomeViewState state;
  final HomeViewCallbacks callbacks;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 1100;
        final extraCompact = constraints.maxWidth < 560;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: compact ? 0 : 12),
          child: Row(
            children: [
              AppInkSurface(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                onLongPress: callbacks.openServerSettings,
                semanticLabel: l10n.openServerSettings,
                child: Row(
                  children: [
                    SyncTvBrandMark(semanticLabel: l10n.appTitle, size: 36),
                    if (!extraCompact) ...[
                      const SizedBox(width: 12),
                      Text(
                        l10n.appTitle,
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
              if (!state.isAccount && compact)
                AppActionButton(
                  onPressed: callbacks.openServerSettings,
                  icon: Icons.dns_rounded,
                  label: l10n.server,
                  style: AppActionButtonStyle.tonal,
                )
              else
                AppIconButton(
                  tooltip: l10n.serverSettings,
                  onPressed: callbacks.openServerSettings,
                  icon: Icons.dns_rounded,
                  style: AppIconButtonStyle.tonal,
                ),
              SizedBox(width: compact ? 8 : 12),
              if (!state.isAccount) ...[
                AppIconButton(
                  tooltip: l10n.language,
                  onPressed: callbacks.openLanguageSelector,
                  icon: Icons.language_rounded,
                  style: AppIconButtonStyle.tonal,
                ),
                SizedBox(width: compact ? 8 : 12),
              ],
              if (state.isAccount) ...[
                if (compact)
                  AppIconButton(
                    tooltip: l10n.joinRoom,
                    onPressed: callbacks.openJoinRoom,
                    icon: Icons.login_rounded,
                    style: AppIconButtonStyle.tonal,
                  )
                else
                  AppActionButton(
                    onPressed: callbacks.openJoinRoom,
                    icon: Icons.login_rounded,
                    label: l10n.joinRoom,
                    style: AppActionButtonStyle.outlined,
                  ),
                SizedBox(width: compact ? 8 : 10),
                if (compact)
                  AppIconButton(
                    tooltip: l10n.createRoom,
                    onPressed: callbacks.openCreateRoom,
                    icon: Icons.add_rounded,
                    style: AppIconButtonStyle.filled,
                  )
                else
                  AppActionButton(
                    onPressed: callbacks.openCreateRoom,
                    icon: Icons.add_rounded,
                    label: l10n.createRoom,
                  ),
                SizedBox(width: compact ? 8 : 12),
                _AccountMenu(
                  state: state,
                  callbacks: callbacks,
                  compact: compact,
                ),
              ] else
                AppActionButton(
                  onPressed: callbacks.openLogin,
                  icon: Icons.login_rounded,
                  label: l10n.login,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _AccountMenu extends StatelessWidget {
  const _AccountMenu({
    required this.state,
    required this.callbacks,
    required this.compact,
  });

  final HomeViewState state;
  final HomeViewCallbacks callbacks;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final child = AppAvatar(
      name: state.currentUser?.username,
      radius: compact ? 18 : 15,
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      textStyle: const TextStyle(fontSize: 13),
    );
    return AppPopupMenuButton<String>(
      offset: const Offset(0, 46),
      tooltip: context.l10n.accountMenu,
      onSelected: (value) => switch (value) {
        'account' => callbacks.openAccountCenter(),
        'admin' => callbacks.openAdminSettings(),
        'server' => callbacks.openServerSettings(),
        'language' => callbacks.openLanguageSelector(),
        'logout' => callbacks.logout(),
        _ => null,
      },
      itemBuilder: (context) => [
        _menuItem(
          'account',
          Icons.account_circle_rounded,
          context.l10n.accountCenter,
          color: theme.colorScheme.onSurface,
        ),
        if (state.isAdmin)
          _menuItem(
            'admin',
            Icons.admin_panel_settings_rounded,
            context.l10n.adminSettings,
            color: theme.colorScheme.onSurface,
          ),
        _menuItem(
          'server',
          Icons.dns_rounded,
          context.l10n.serverSettings,
          color: theme.colorScheme.onSurface,
        ),
        _menuItem(
          'language',
          Icons.language_rounded,
          context.l10n.language,
          color: theme.colorScheme.onSurface,
        ),
        const PopupMenuDivider(),
        _menuItem(
          'logout',
          Icons.logout_rounded,
          context.l10n.logout,
          color: Colors.red,
        ),
      ],
      child: compact
          ? child
          : AppInkSurface(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.dividerColor.withValues(alpha: 0.7),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                child: Row(
                  children: [
                    child,
                    const SizedBox(width: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 140),
                      child: Text(
                        state.currentUser?.username ?? 'User',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.expand_more_rounded, size: 18),
                  ],
                ),
              ),
            ),
    );
  }

  PopupMenuItem<String> _menuItem(
    String value,
    IconData icon,
    String label, {
    Color? color,
  }) => PopupMenuItem(
    value: value,
    child: Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: color)),
      ],
    ),
  );
}

class _DiscoveryBody extends StatelessWidget {
  const _DiscoveryBody({
    required this.state,
    required this.callbacks,
    required this.searchController,
  });

  final HomeViewState state;
  final HomeViewCallbacks callbacks;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return AppRefreshIndicator(
      onRefresh: callbacks.refresh,
      child: AppSingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppMetrics.pagePadding(context),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.page == 1 && state.featuredRooms.isNotEmpty) ...[
                  _SectionHeading(
                    title: context.l10n.featuredRooms,
                    subtitle: context.l10n.featuredRoomsDescription,
                    icon: Icons.auto_awesome_rounded,
                  ),
                  const SizedBox(height: 12),
                  _FeaturedRooms(state: state, callbacks: callbacks),
                  const SizedBox(height: 24),
                ],
                if (state.isAccount && state.joinedRooms.isNotEmpty) ...[
                  _SectionHeading(
                    title: context.l10n.continueWatchingRooms,
                    subtitle: context.l10n.continueWatchingRoomsDescription,
                    icon: Icons.play_circle_outline_rounded,
                  ),
                  const SizedBox(height: 12),
                  _HorizontalRoomRail(
                    height: 196,
                    itemCount: state.joinedRooms.length,
                    itemWidth: (width) =>
                        width < 520 ? (width * 0.80).clamp(236, 292) : 264,
                    previousTooltip: context.l10n.previousRooms,
                    nextTooltip: context.l10n.nextRooms,
                    itemBuilder: (_, index) => _RoomCard(
                      room: state.joinedRooms[index],
                      state: state,
                      callbacks: callbacks,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                if (state.categories.isNotEmpty) ...[
                  _CategoryStrip(state: state, callbacks: callbacks),
                  const SizedBox(height: 18),
                ],
                _RoomControls(
                  state: state,
                  callbacks: callbacks,
                  searchController: searchController,
                ),
                const SizedBox(height: 22),
                if (state.rooms.isNotEmpty || state.featuredRooms.isEmpty) ...[
                  _SectionHeading(
                    title: context.l10n.popularRooms,
                    subtitle: context.l10n.popularRoomsDescription,
                    icon: Icons.local_fire_department_rounded,
                  ),
                  const SizedBox(height: 12),
                  _RoomGrid(state: state, callbacks: callbacks),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppIconBadge(
          icon: icon,
          color: theme.colorScheme.primary,
          size: 34,
          iconSize: 19,
          backgroundAlpha: 0.11,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeaturedRooms extends StatelessWidget {
  const _FeaturedRooms({required this.state, required this.callbacks});
  final HomeViewState state;
  final HomeViewCallbacks callbacks;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      Widget card(int index) => _RoomCard(
        room: state.featuredRooms[index],
        state: state,
        callbacks: callbacks,
      );
      if (constraints.maxWidth < 1100) {
        return _HorizontalRoomRail(
          height: 224,
          itemCount: state.featuredRooms.length,
          itemWidth: (width) =>
              width < 520 ? (width * 0.86).clamp(248, 316) : 292,
          previousTooltip: context.l10n.previousRooms,
          nextTooltip: context.l10n.nextRooms,
          itemBuilder: (_, index) => card(index),
        );
      }
      if (state.featuredRooms.length <= 3) {
        final count = state.featuredRooms.length;
        return _HorizontalRoomRail(
          height: count == 3 ? 300 : 390,
          itemCount: count,
          itemWidth: (width) => switch (count) {
            1 => width.clamp(0, 680),
            2 => ((width - 12) / 2).clamp(0, 560),
            _ => ((width - 24) / 3).clamp(0, 440),
          },
          previousTooltip: context.l10n.previousRooms,
          nextTooltip: context.l10n.nextRooms,
          itemBuilder: (_, index) => card(index),
        );
      }
      return SizedBox(
        height: 390,
        child: Row(
          children: [
            Expanded(flex: 5, child: card(0)),
            const SizedBox(width: 14),
            Expanded(
              flex: 6,
              child: AppGridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 188,
                ),
                itemCount: state.featuredRooms.skip(1).take(4).length,
                itemBuilder: (_, index) => card(index + 1),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _CategoryStrip extends StatelessWidget {
  const _CategoryStrip({required this.state, required this.callbacks});
  final HomeViewState state;
  final HomeViewCallbacks callbacks;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    child: AppListView(
      scrollDirection: Axis.horizontal,
      children: [
        AppChip(
          label: Text(context.l10n.allCategories),
          selected: state.selectedCategoryId.isEmpty,
          onSelected: (_) => callbacks.selectCategory(''),
        ),
        const SizedBox(width: 8),
        for (final category in state.categories) ...[
          AppChip(
            label: Text(
              category.name.trim().isEmpty ? category.key : category.name,
            ),
            selected: state.selectedCategoryId == category.id,
            onSelected: (_) => callbacks.selectCategory(category.id),
          ),
          const SizedBox(width: 8),
        ],
      ],
    ),
  );
}

class _RoomControls extends StatelessWidget {
  const _RoomControls({
    required this.state,
    required this.callbacks,
    required this.searchController,
  });
  final HomeViewState state;
  final HomeViewCallbacks callbacks;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compact = AppBreakpoints.widthOf(context) < 1080;
    final filters = LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 520;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppSearchField(
              controller: searchController,
              width: narrow ? constraints.maxWidth : 320,
              hintText: context.l10n.searchRooms,
              onChanged: (value) {
                if (value.isEmpty) callbacks.search('');
              },
              onSubmitted: callbacks.search,
            ),
            AppSelect<String?>(
              value: state.selectedCategoryId.isEmpty
                  ? null
                  : state.selectedCategoryId,
              width: narrow ? constraints.maxWidth : 180,
              hintText: context.l10n.allCategories,
              prefixIcon: Icons.category_outlined,
              clearable: true,
              enabled: !state.isLoadingTaxonomy && state.categories.isNotEmpty,
              options: {
                context.l10n.allCategories: null,
                for (final category in state.categories)
                  (category.name.trim().isEmpty ? category.key : category.name):
                      category.id,
              },
              onChanged: (value) => callbacks.selectCategory(value ?? ''),
            ),
            AppActionButton(
              onPressed: state.isLoadingTaxonomy
                  ? null
                  : callbacks.openLabelFilter,
              icon: Icons.sell_outlined,
              label: state.selectedLabelCount == 0
                  ? context.l10n.labels
                  : context.l10n.selectedLabels(state.selectedLabelCount),
              style: state.selectedLabelCount == 0
                  ? AppActionButtonStyle.outlined
                  : AppActionButtonStyle.tonal,
            ),
            if (state.selectedCategoryId.isNotEmpty ||
                state.selectedLabelCount > 0)
              AppIconButton(
                tooltip: context.l10n.clearRoomTaxonomyFilters,
                icon: Icons.filter_alt_off_rounded,
                onPressed: callbacks.clearFilters,
                style: AppIconButtonStyle.tonal,
              ),
          ],
        );
      },
    );
    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: compact
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.end,
      children: [
        Flexible(
          child: AppPaginationBar(
            padding: EdgeInsets.zero,
            label: context.l10n.roomsPageSummary(
              state.totalRooms,
              state.page,
              state.pageCount,
            ),
            onPrevious: state.page <= 1
                ? null
                : () => callbacks.goToPage(state.page - 1),
            onNext: state.page >= state.pageCount
                ? null
                : () => callbacks.goToPage(state.page + 1),
          ),
        ),
        const SizedBox(width: 8),
        AppIconButton(
          tooltip: context.l10n.refresh,
          onPressed: () => callbacks.refresh(),
          icon: Icons.refresh_rounded,
          style: AppIconButtonStyle.tonal,
        ),
      ],
    );
    return AppInkSurface(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.7)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: compact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [filters, const SizedBox(height: 12), actions],
              )
            : Row(
                children: [
                  Expanded(child: filters),
                  const SizedBox(width: 12),
                  actions,
                ],
              ),
      ),
    );
  }
}

class _RoomGrid extends StatelessWidget {
  const _RoomGrid({required this.state, required this.callbacks});
  final HomeViewState state;
  final HomeViewCallbacks callbacks;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (state.isLoading && state.rooms.isEmpty) {
      return SizedBox(
        height: 280,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLoadingIndicator(),
              const SizedBox(height: 20),
              AppActionButton(
                onPressed: callbacks.openServerSettings,
                icon: Icons.dns_rounded,
                label: context.l10n.server,
                style: AppActionButtonStyle.tonal,
              ),
            ],
          ),
        ),
      );
    }
    if (state.rooms.isEmpty) {
      return SizedBox(
        height: 280,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                state.hasServer
                    ? Icons.meeting_room_outlined
                    : Icons.dns_rounded,
                size: 56,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
              ),
              const SizedBox(height: 14),
              Text(
                state.hasServer
                    ? context.l10n.noRooms
                    : context.l10n.addServerToStart,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.hasServer
                    ? context.l10n.filteredRoomsEmptyDescription
                    : context.l10n.addServerDescription,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
                ),
              ),
              const SizedBox(height: 20),
              AppActionButton(
                onPressed: state.hasServer
                    ? () => callbacks.refresh()
                    : callbacks.openServerSettings,
                icon: state.hasServer ? Icons.refresh_rounded : Icons.add_link,
                label: state.hasServer
                    ? context.l10n.refresh
                    : context.l10n.addServer,
                style: AppActionButtonStyle.tonal,
              ),
            ],
          ),
        ),
      );
    }
    return AppGridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 360,
        mainAxisExtent: 318,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: state.rooms.length,
      itemBuilder: (_, index) => _RoomCard(
        room: state.rooms[index],
        state: state,
        callbacks: callbacks,
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({
    required this.room,
    required this.state,
    required this.callbacks,
  });
  final SyncTvRoom room;
  final HomeViewState state;
  final HomeViewCallbacks callbacks;

  @override
  Widget build(BuildContext context) {
    final isOwner =
        room.myRelation ==
            client_enum.MyRoomRelation.MY_ROOM_RELATION_CREATED ||
        state.currentUser?.id == room.creatorId;
    final unavailable =
        room.isBanned ||
        room.availability ==
            client_enum
                .ResourceAvailability
                .RESOURCE_AVAILABILITY_CREATOR_INACTIVE ||
        room.discoveryAccess ==
            client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_UNAVAILABLE;
    final canOpen =
        !unavailable &&
        (room.joined ||
            room.canJoin ||
            room.discoveryAccess ==
                client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_SIGN_IN);
    return CinemaRoomCard(
      roomName: room.roomName,
      description: room.description,
      coverUrl: room.coverUrl,
      onlineMemberCount: room.onlineMemberCount,
      onlineGuestCount: room.onlineGuestCount,
      creatorName: room.creator,
      creatorAvatarUrl: room.creatorAvatarUrl,
      creatorBlocked: room.creatorBlocked,
      availability: room.availability,
      isBanned: room.isBanned,
      isOwner: isOwner,
      joined: room.joined,
      canJoin: room.canJoin,
      discoveryAccess: room.discoveryAccess,
      onTap: canOpen ? () => callbacks.openRoom(room) : null,
      onFavoritePressed: room.joined
          ? () => callbacks.toggleFavorite(room)
          : null,
      isFavorite: room.isFavorite,
      favoriteLoading: state.favoriteRoomIdsInFlight.contains(room.roomId),
      onLongPress: isOwner ? () => callbacks.deleteRoom(room) : null,
    );
  }
}

class _HorizontalRoomRail extends StatefulWidget {
  const _HorizontalRoomRail({
    required this.height,
    required this.itemCount,
    required this.itemWidth,
    required this.itemBuilder,
    required this.previousTooltip,
    required this.nextTooltip,
  });
  final double height;
  final int itemCount;
  final double Function(double availableWidth) itemWidth;
  final IndexedWidgetBuilder itemBuilder;
  final String previousTooltip;
  final String nextTooltip;

  @override
  State<_HorizontalRoomRail> createState() => _HorizontalRoomRailState();
}

class _HorizontalRoomRailState extends State<_HorizontalRoomRail> {
  final ScrollController _controller = ScrollController();
  bool _canScrollBackward = false;
  bool _canScrollForward = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateScrollActions);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollActions());
  }

  @override
  void didUpdateWidget(covariant _HorizontalRoomRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateScrollActions());
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_updateScrollActions)
      ..dispose();
    super.dispose();
  }

  void _updateScrollActions() {
    if (!mounted || !_controller.hasClients) return;
    final position = _controller.position;
    final backward = position.pixels > position.minScrollExtent + 1;
    final forward = position.pixels < position.maxScrollExtent - 1;
    if (backward == _canScrollBackward && forward == _canScrollForward) return;
    setState(() {
      _canScrollBackward = backward;
      _canScrollForward = forward;
    });
  }

  void _moveBy(double delta, {bool animate = true}) {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    final target = (_controller.offset + delta).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    animate
        ? _controller.animateTo(
            target,
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
          )
        : _controller.jumpTo(target);
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || !_controller.hasClients) return;
    final delta = event.scrollDelta.dx.abs() > event.scrollDelta.dy.abs()
        ? event.scrollDelta.dx
        : event.scrollDelta.dy;
    if (delta == 0) return;
    final position = _controller.position;
    final target = (_controller.offset + delta).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if ((target - _controller.offset).abs() < 0.5) return;
    GestureBinding.instance.pointerSignalResolver.register(
      event,
      (_) => _moveBy(delta, animate: false),
    );
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = widget.itemWidth(constraints.maxWidth);
      final behavior = ScrollConfiguration.of(context).copyWith(
        dragDevices: const {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.invertedStylus,
          PointerDeviceKind.trackpad,
        },
        scrollbars: false,
      );
      return SizedBox(
        height: widget.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Listener(
              onPointerSignal: _handlePointerSignal,
              child: ScrollConfiguration(
                behavior: behavior,
                child: Scrollbar(
                  controller: _controller,
                  thickness: 3,
                  radius: const Radius.circular(3),
                  child: AppListView.separated(
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    padding: const EdgeInsets.only(bottom: 7),
                    itemCount: widget.itemCount,
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
                    itemBuilder: (context, index) => SizedBox(
                      width: width,
                      child: widget.itemBuilder(context, index),
                    ),
                  ),
                ),
              ),
            ),
            if (_canScrollBackward)
              Positioned(
                left: 8,
                child: _RailButton(
                  icon: Icons.chevron_left_rounded,
                  tooltip: widget.previousTooltip,
                  onPressed: () =>
                      _moveBy(-_controller.position.viewportDimension * 0.82),
                ),
              ),
            if (_canScrollForward)
              Positioned(
                right: 8,
                child: _RailButton(
                  icon: Icons.chevron_right_rounded,
                  tooltip: widget.nextTooltip,
                  onPressed: () =>
                      _moveBy(_controller.position.viewportDimension * 0.82),
                ),
              ),
          ],
        ),
      );
    },
  );
}

class _RailButton extends StatelessWidget {
  const _RailButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.94),
        shape: BoxShape.circle,
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AppIconButton(
        onPressed: onPressed,
        icon: icon,
        tooltip: tooltip,
        style: AppIconButtonStyle.ghost,
        constraints: const BoxConstraints.tightFor(width: 42, height: 42),
      ),
    );
  }
}
