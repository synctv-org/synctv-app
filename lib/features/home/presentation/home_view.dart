import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
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
    this.loadError,
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
  final String? loadError;

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
        final textScale = MediaQuery.textScalerOf(context).scale(16) / 16;
        final availableWidth = constraints.maxWidth / textScale;
        final compact = availableWidth < 1100;
        final extraCompact = availableWidth < 560;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: compact ? 0 : 12),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: AppInkSurface(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      onLongPress: callbacks.openServerSettings,
                      semanticLabel: l10n.openServerSettings,
                      child: Row(
                        children: [
                          SyncTvBrandMark(
                            semanticLabel: l10n.appTitle,
                            size: 36,
                          ),
                          ...[
                            const SizedBox(width: 8),
                            Text(
                              l10n.appTitle,
                              style: TextStyle(
                                fontSize: extraCompact ? 20 : 22,
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
                  ),
                ),
              ),
              if (!state.isAccount || !extraCompact) ...[
                AppIconButton(
                  tooltip: l10n.serverSettings,
                  onPressed: callbacks.openServerSettings,
                  icon: kIsWeb ? Icons.info_outline_rounded : Icons.dns_rounded,
                  style: AppIconButtonStyle.tonal,
                ),
                SizedBox(width: compact ? 4 : 12),
              ],
              if (!state.isAccount) ...[
                AppIconButton(
                  tooltip: l10n.language,
                  onPressed: callbacks.openLanguageSelector,
                  icon: Icons.language_rounded,
                  style: AppIconButtonStyle.tonal,
                ),
                SizedBox(width: compact ? 4 : 12),
              ],
              if (state.isAccount) ...[
                if (compact && !extraCompact)
                  AppIconButton(
                    tooltip: l10n.joinRoom,
                    onPressed: callbacks.openJoinRoom,
                    icon: Icons.login_rounded,
                    style: AppIconButtonStyle.tonal,
                  )
                else if (!compact)
                  AppActionButton(
                    onPressed: callbacks.openJoinRoom,
                    icon: Icons.login_rounded,
                    label: l10n.joinRoom,
                    style: AppActionButtonStyle.outlined,
                  ),
                if (!extraCompact) SizedBox(width: compact ? 8 : 10),
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
              ] else if (availableWidth < 340)
                AppIconButton(
                  tooltip: l10n.login,
                  onPressed: callbacks.openLogin,
                  icon: Icons.login_rounded,
                  style: AppIconButtonStyle.filled,
                )
              else
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
        'join' => callbacks.openJoinRoom(),
        'admin' => callbacks.openAdminSettings(),
        'server' => callbacks.openServerSettings(),
        'language' => callbacks.openLanguageSelector(),
        'logout' => callbacks.logout(),
        _ => null,
      },
      itemBuilder: (context) => [
        if (compact)
          _menuItem(
            'join',
            Icons.login_rounded,
            context.l10n.joinRoom,
            color: theme.colorScheme.onSurface,
          ),
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
          ? SizedBox(width: 44, height: 44, child: Center(child: child))
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
        Flexible(
          child: Text(label, style: TextStyle(color: color)),
        ),
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
    final hasFilters =
        state.selectedCategoryId.isNotEmpty ||
        state.selectedLabelCount > 0 ||
        searchController.text.trim().isNotEmpty;
    final pagePadding = AppMetrics.pagePadding(context);
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = ((width - 1480) / 2).clamp(
      pagePadding.left,
      double.infinity,
    );
    final showResults =
        state.rooms.isNotEmpty ||
        state.featuredRooms.isEmpty ||
        hasFilters ||
        state.loadError != null;
    return AppRefreshIndicator(
      onRefresh: callbacks.refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              12,
              horizontalPadding,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _RoomControls(
                    state: state,
                    callbacks: callbacks,
                    searchController: searchController,
                  ),
                  if (state.categories.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _CategoryStrip(state: state, callbacks: callbacks),
                  ],
                  const SizedBox(height: 24),
                  if (state.loadError != null) ...[
                    _DiscoveryError(state: state, onRetry: callbacks.refresh),
                    const SizedBox(height: 20),
                  ],
                  if (state.page == 1 &&
                      !hasFilters &&
                      state.featuredRooms.isNotEmpty) ...[
                    _SectionHeading(
                      title: context.l10n.featuredRooms,
                      icon: Icons.auto_awesome_rounded,
                    ),
                    const SizedBox(height: 12),
                    _FeaturedRooms(state: state, callbacks: callbacks),
                    const SizedBox(height: 24),
                  ],
                  if (!hasFilters &&
                      state.isAccount &&
                      state.joinedRooms.isNotEmpty) ...[
                    _SectionHeading(
                      title: context.l10n.continueWatchingRooms,
                      icon: Icons.play_circle_outline_rounded,
                    ),
                    const SizedBox(height: 12),
                    _HorizontalRoomRail(
                      height: _scaledRoomHeight(context, 196),
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
                  if (showResults && state.loadError == null)
                    _SectionHeading(
                      title: context.l10n.popularRooms,
                      icon: Icons.local_fire_department_rounded,
                    ),
                ],
              ),
            ),
          ),
          if (state.rooms.isNotEmpty)
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                12,
                horizontalPadding,
                pagePadding.bottom,
              ),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final columns = ((constraints.crossAxisExtent + 16) / 288)
                      .floor()
                      .clamp(1, 5);
                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _RoomCard(
                        room: state.rooms[index],
                        state: state,
                        callbacks: callbacks,
                      ),
                      childCount: state.rooms.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      mainAxisExtent: _scaledRoomHeight(context, 318),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                  );
                },
              ),
            )
          else if (showResults && state.loadError == null)
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                12,
                horizontalPadding,
                pagePadding.bottom,
              ),
              sliver: SliverToBoxAdapter(
                child: _RoomEmptyState(state: state, callbacks: callbacks),
              ),
            ),
        ],
      ),
    );
  }
}

class _DiscoveryError extends StatelessWidget {
  const _DiscoveryError({required this.state, required this.onRetry});

  final HomeViewState state;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(Icons.cloud_off_rounded, color: Theme.of(context).colorScheme.error),
      const SizedBox(width: 12),
      Expanded(child: Text(context.l10n.loadRoomsFailed(state.loadError!))),
      const SizedBox(width: 12),
      AppIconButton(
        tooltip: context.l10n.retry,
        icon: Icons.refresh_rounded,
        loading: state.isLoading,
        onPressed: () => onRetry(),
      ),
    ],
  );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 22),
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
            ],
          ),
        ),
      ],
    );
  }
}

double _scaledRoomHeight(BuildContext context, double baseHeight) {
  final scaler = MediaQuery.textScalerOf(context);
  return baseHeight +
      ((scaler.scale(14) / 14 - 1) * 88).clamp(0, double.infinity);
}

class _FeaturedRooms extends StatelessWidget {
  const _FeaturedRooms({required this.state, required this.callbacks});
  final HomeViewState state;
  final HomeViewCallbacks callbacks;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      return _HorizontalRoomRail(
        height: _scaledRoomHeight(context, 294),
        itemCount: state.featuredRooms.length,
        itemWidth: (width) => width < 520
            ? (width * 0.88).clamp(240, 340)
            : ((width - 36) / 4).clamp(280, 360),
        previousTooltip: context.l10n.previousRooms,
        nextTooltip: context.l10n.nextRooms,
        itemBuilder: (_, index) => _RoomCard(
          room: state.featuredRooms[index],
          state: state,
          callbacks: callbacks,
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
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      Widget categoryChip(String id, String name) => AppTooltip(
        message: name,
        excludeFromSemantics: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth.clamp(0, 360),
          ),
          child: AppChip(
            label: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
            selected: state.selectedCategoryId == id,
            onSelected: (_) => callbacks.selectCategory(id),
          ),
        ),
      );
      return SizedBox(
        height: (MediaQuery.textScalerOf(context).scale(14) + 28).clamp(
          44,
          double.infinity,
        ),
        child: AppListView(
          scrollDirection: Axis.horizontal,
          children: [
            categoryChip('', context.l10n.allCategories),
            const SizedBox(width: 8),
            for (final category in state.categories) ...[
              categoryChip(
                category.id,
                category.name.trim().isEmpty
                    ? category.key
                    : category.name.trim(),
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
      );
    },
  );
}

class _RoomControls extends StatefulWidget {
  const _RoomControls({
    required this.state,
    required this.callbacks,
    required this.searchController,
  });
  final HomeViewState state;
  final HomeViewCallbacks callbacks;
  final TextEditingController searchController;

  @override
  State<_RoomControls> createState() => _RoomControlsState();
}

class _RoomControlsState extends State<_RoomControls> {
  Timer? _searchDebounce;

  HomeViewState get state => widget.state;
  HomeViewCallbacks get callbacks => widget.callbacks;
  TextEditingController get searchController => widget.searchController;

  @override
  void didUpdateWidget(covariant _RoomControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchController != searchController ||
        oldWidget.state.identity != state.identity) {
      _searchDebounce?.cancel();
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _submitSearch(String value) {
    _searchDebounce?.cancel();
    callbacks.search(value);
  }

  void _scheduleSearch(String value) {
    _searchDebounce?.cancel();
    if (value.trim().isEmpty) {
      _submitSearch(value);
    } else {
      _searchDebounce = Timer(const Duration(milliseconds: 350), () {
        if (searchController.text == value &&
            searchController.value.composing.isCollapsed) {
          _submitSearch(value);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasTaxonomyFilters =
        state.selectedCategoryId.isNotEmpty || state.selectedLabelCount > 0;
    if (AppBreakpoints.widthOf(context) < 600) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AppSearchField(
                  controller: searchController,
                  hintText: context.l10n.searchRooms,
                  onChanged: _scheduleSearch,
                  onSubmitted: _submitSearch,
                ),
              ),
              const SizedBox(width: 8),
              AppIconButton(
                tooltip: state.selectedLabelCount == 0
                    ? context.l10n.labels
                    : context.l10n.selectedLabels(state.selectedLabelCount),
                icon: Icons.sell_outlined,
                selected: state.selectedLabelCount > 0,
                onPressed: state.isLoadingTaxonomy
                    ? null
                    : callbacks.openLabelFilter,
                style: AppIconButtonStyle.tonal,
              ),
              if (hasTaxonomyFilters) ...[
                const SizedBox(width: 4),
                AppIconButton(
                  tooltip: context.l10n.clearRoomTaxonomyFilters,
                  icon: Icons.filter_alt_off_rounded,
                  onPressed: callbacks.clearFilters,
                ),
              ],
              const SizedBox(width: 4),
              AppIconButton(
                tooltip: context.l10n.refresh,
                onPressed: state.isLoading ? null : () => callbacks.refresh(),
                icon: Icons.refresh_rounded,
              ),
            ],
          ),
          if (state.totalRooms > 0) ...[
            const SizedBox(height: 8),
            AppPaginationBar(
              padding: EdgeInsets.zero,
              label: context.l10n.roomsPageSummary(
                state.totalRooms,
                state.page,
                state.pageCount,
              ),
              onPrevious: state.isLoading || state.page <= 1
                  ? null
                  : () => callbacks.goToPage(state.page - 1),
              onNext: state.isLoading || state.page >= state.pageCount
                  ? null
                  : () => callbacks.goToPage(state.page + 1),
            ),
          ],
        ],
      );
    }
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
              onChanged: _scheduleSearch,
              onSubmitted: _submitSearch,
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
        if (state.totalRooms > 0 || state.featuredRooms.isEmpty)
          Flexible(
            child: AppPaginationBar(
              padding: EdgeInsets.zero,
              label: context.l10n.roomsPageSummary(
                state.totalRooms,
                state.page,
                state.pageCount,
              ),
              onPrevious: state.isLoading || state.page <= 1
                  ? null
                  : () => callbacks.goToPage(state.page - 1),
              onNext: state.isLoading || state.page >= state.pageCount
                  ? null
                  : () => callbacks.goToPage(state.page + 1),
            ),
          ),
        const SizedBox(width: 8),
        AppIconButton(
          tooltip: context.l10n.refresh,
          onPressed: state.isLoading ? null : () => callbacks.refresh(),
          icon: Icons.refresh_rounded,
          style: AppIconButtonStyle.tonal,
        ),
      ],
    );
    return compact
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
          );
  }
}

class _RoomEmptyState extends StatelessWidget {
  const _RoomEmptyState({required this.state, required this.callbacks});
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
    return const SizedBox.shrink();
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
    (animate && !MediaQuery.disableAnimationsOf(context))
        ? _controller.animateTo(
            target,
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
          )
        : _controller.jumpTo(target);
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || !_controller.hasClients) return;
    // Preserve vertical page scrolling when the pointer crosses a room rail.
    final delta = event.scrollDelta.dx;
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
