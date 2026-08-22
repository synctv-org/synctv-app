import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:synctv_app/features/home/presentation/home_view.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/theme/app_theme.dart';

const _categories = [
  RoomCategoryInfo(
    id: 'movies',
    key: 'movies',
    name: 'Movies',
    description: 'Feature films and cinema',
    sortOrder: 10,
    isEnabled: true,
  ),
  RoomCategoryInfo(
    id: 'animation',
    key: 'animation',
    name: 'Animation',
    description: 'Animation and anime',
    sortOrder: 20,
    isEnabled: true,
  ),
  RoomCategoryInfo(
    id: 'documentary',
    key: 'documentary',
    name: 'Documentary',
    description: 'Documentary screenings',
    sortOrder: 30,
    isEnabled: true,
  ),
  RoomCategoryInfo(
    id: 'live',
    key: 'live',
    name: 'Live',
    description: 'Live events',
    sortOrder: 40,
    isEnabled: true,
  ),
];

SyncTvRoom _room({
  required String id,
  required String name,
  required String description,
  required String creator,
  required int onlineMembers,
  required int onlineGuests,
  required int members,
  bool joined = false,
  bool favorite = false,
  client_enum.RoomDiscoveryAccess discoveryAccess =
      client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_UNSPECIFIED,
}) => SyncTvRoom(
  roomId: id,
  roomName: name,
  description: description,
  creator: creator,
  creatorId: 'user-$creator',
  onlineMemberCount: onlineMembers,
  onlineGuestCount: onlineGuests,
  memberCount: members,
  joined: joined,
  isFavorite: favorite,
  canJoin: true,
  discoveryAccess: discoveryAccess,
);

final homeShowcaseRooms = <SyncTvRoom>[
  _room(
    id: 'friday-cinema',
    name: 'Friday Cinema Club',
    description: 'A weekly pick for people who love great films.',
    creator: 'Evelyn',
    onlineMembers: 96,
    onlineGuests: 32,
    members: 842,
    joined: true,
    favorite: true,
  ),
  _room(
    id: 'animation-after-hours',
    name: 'Animation After Hours',
    description: 'New releases, classics, and community favorites.',
    creator: 'Mika',
    onlineMembers: 71,
    onlineGuests: 23,
    members: 531,
    joined: true,
  ),
  _room(
    id: 'documentary-society',
    name: 'Documentary Society',
    description: 'Stories from science, nature, and contemporary life.',
    creator: 'Noah',
    onlineMembers: 54,
    onlineGuests: 13,
    members: 389,
  ),
  _room(
    id: 'late-night-live',
    name: 'Late Night Live',
    description: 'Live sessions and performances from independent artists.',
    creator: 'Sofia',
    onlineMembers: 127,
    onlineGuests: 88,
    members: 1204,
    discoveryAccess:
        client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_GUEST,
  ),
  _room(
    id: 'classic-film-archive',
    name: 'Classic Film Archive',
    description: 'Restored cinema and thoughtful post-film discussion.',
    creator: 'Arthur',
    onlineMembers: 46,
    onlineGuests: 6,
    members: 677,
  ),
  _room(
    id: 'weekend-watch-party',
    name: 'Weekend Watch Party',
    description: 'A relaxed room for series premieres and finales.',
    creator: 'Chloe',
    onlineMembers: 68,
    onlineGuests: 15,
    members: 461,
  ),
];

HomeViewState homeShowcaseState({
  List<SyncTvRoom>? rooms,
  List<SyncTvRoom>? featuredRooms,
  String selectedCategoryId = '',
  bool isLoading = false,
}) => HomeViewState(
  identity: const AccountSessionIdentity(),
  hasServer: true,
  isLoading: isLoading,
  isLoadingTaxonomy: false,
  rooms: rooms ?? homeShowcaseRooms,
  featuredRooms:
      featuredRooms ?? homeShowcaseRooms.take(5).toList(growable: false),
  joinedRooms: homeShowcaseRooms
      .where((room) => room.joined)
      .toList(growable: false),
  categories: _categories,
  totalRooms: rooms?.length ?? homeShowcaseRooms.length,
  page: 1,
  pageCount: 1,
  selectedCategoryId: selectedCategoryId,
  selectedLabelCount: 0,
  favoriteRoomIdsInFlight: const {},
  currentUser: SyncTvUser(
    id: 'showcase-user',
    username: 'Alex Morgan',
    email: 'alex@example.com',
    role: const AccountUserRole(common_enum.UserRole.USER_ROLE_USER),
  ),
);

HomeViewCallbacks homeShowcaseCallbacks({
  VoidCallback? onOpenServerSettings,
  ValueChanged<SyncTvRoom>? onOpenRoom,
  ValueChanged<SyncTvRoom>? onToggleFavorite,
  ValueChanged<String>? onSearch,
  ValueChanged<String>? onSelectCategory,
}) => HomeViewCallbacks(
  openServerSettings: onOpenServerSettings ?? () {},
  openLanguageSelector: () {},
  openLogin: () {},
  openJoinRoom: () {},
  openCreateRoom: () {},
  openAccountCenter: () {},
  openAdminSettings: () {},
  logout: () {},
  refresh: () async {},
  search: onSearch ?? (_) {},
  selectCategory: onSelectCategory ?? (_) {},
  openLabelFilter: () {},
  clearFilters: () {},
  openRoom: onOpenRoom ?? (_) {},
  toggleFavorite: onToggleFavorite ?? (_) {},
  deleteRoom: (_) {},
  goToPage: (_) {},
);

class HomeShowcaseApp extends StatefulWidget {
  const HomeShowcaseApp({super.key, this.state, this.callbacks});

  final HomeViewState? state;
  final HomeViewCallbacks? callbacks;

  @override
  State<HomeShowcaseApp> createState() => _HomeShowcaseAppState();
}

class _HomeShowcaseAppState extends State<HomeShowcaseApp> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    themeMode: ThemeMode.light,
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: const [...AppLocalizations.localizationsDelegates],
    builder: (context, child) {
      final app = ResponsiveBreakpoints.builder(
        breakpoints: AppBreakpoints.values,
        child: child!,
      );
      return app;
    },
    home: HomeView(
      state: widget.state ?? homeShowcaseState(),
      callbacks: widget.callbacks ?? homeShowcaseCallbacks(),
      searchController: _searchController,
    ),
  );
}
