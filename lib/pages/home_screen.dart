import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/models/synctv_models.dart';
import 'package:synctv_app/models/public_models.dart';
import 'package:synctv_app/models/latest_async_operation_coordinator.dart';
import 'package:synctv_app/models/home_room_access.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/pages/room_screen.dart';
//import 'package:synctv_app/widgets/synctv_admin_settings.dart';
import 'package:synctv_app/pages/mobile/admin_settings_page.dart';
import 'package:synctv_app/pages/account_center_page.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/utils/room_taxonomy.dart';
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/widgets/cinema_room_card.dart';
import 'package:synctv_app/widgets/synctv_brand_mark.dart';
import 'package:synctv_app/widgets/create_room_dialog.dart';
import 'package:synctv_app/widgets/join_room_dialog.dart';
import 'package:synctv_app/widgets/language_selector_dialog.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';
import 'package:synctv_app/widgets/room_invite_flow.dart';
import 'package:synctv_app/widgets/server_settings_dialog.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;

import 'package:synctv_app/widgets/auth_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _startRoomId = String.fromEnvironment(
    'SYNCTV_START_ROOM_ID',
    defaultValue: '',
  );

  bool _isLoading = true;
  bool _isLoadingTaxonomy = false;
  List<SyncTvRoom> _rooms = [];
  List<SyncTvRoom> _featuredRooms = [];
  List<SyncTvRoom> _joinedRooms = [];
  List<RoomCategoryInfo> _roomCategories = const [];
  List<RoomLabelInfo> _roomLabels = const [];
  int _roomsTotal = 0;
  int _roomPage = 1;
  static const int _roomPageSize = 24;
  SyncTvUser? _currentUser;
  StreamSubscription? _authErrorSubscription;
  final Map<String, Object> _joiningRoomOperations = <String, Object>{};
  final Set<String> _favoriteRoomIdsInFlight = <String>{};
  final Set<String> _selectedRoomLabelIds = <String>{};
  final TextEditingController _roomSearchController = TextEditingController();
  String _selectedRoomCategoryId = '';
  int _roomLoadGeneration = 0;
  final AsyncStateEpoch _homeStateEpoch = AsyncStateEpoch();
  bool _modalOpen = false;
  bool _startRoomHandled = false;

  @override
  void initState() {
    super.initState();
    _authErrorSubscription = SyncTvService.onAuthError.listen((_) {
      if (mounted) {
        setState(() {
          _clearRoomSessionState();
        });
        unawaited(_loadRooms(silent: false));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showLoginDialog();
        });
      }
    });
    _checkLoginAndLoadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && SyncTvService.activeServer == null) {
        _showServerSettingsDialog(requireServer: true);
      }
    });
  }

  @override
  void dispose() {
    _authErrorSubscription?.cancel();
    _roomSearchController.dispose();
    super.dispose();
  }

  HomeIdentityKind get _identityKind {
    if (!SyncTvService.hasRecoverableSession) {
      return HomeIdentityKind.anonymous;
    }
    return SyncTvService.isGuestSession
        ? HomeIdentityKind.guest
        : HomeIdentityKind.account;
  }

  bool get _isGuestSession => _identityKind == HomeIdentityKind.guest;
  bool get _isAccountSession => _identityKind == HomeIdentityKind.account;

  void _clearRoomSessionState({bool clearTaxonomy = false}) {
    _homeStateEpoch.advance();
    _roomLoadGeneration += 1;
    _currentUser = null;
    _rooms = const [];
    _featuredRooms = const [];
    _joinedRooms = const [];
    _roomsTotal = 0;
    _roomPage = 1;
    _isLoadingTaxonomy = false;
    _joiningRoomOperations.clear();
    _favoriteRoomIdsInFlight.clear();
    if (clearTaxonomy) {
      _roomCategories = const [];
      _roomLabels = const [];
      _selectedRoomCategoryId = '';
      _selectedRoomLabelIds.clear();
    }
  }

  Future<void> _fetchUserInfo() async {
    if (!_isAccountSession) return;
    final epoch = _homeStateEpoch.capture();
    try {
      final user = await SyncTvService.getMe();
      if (mounted && _homeStateEpoch.isCurrent(epoch) && _isAccountSession) {
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      // Ignore
    }
  }

  Future<void> _checkLoginAndLoadData() async {
    unawaited(_loadRooms(silent: false));
    if (_isAccountSession) {
      await _fetchUserInfo();
    }
    _openStartRoomIfRequested();
  }

  Future<void> _loadRoomTaxonomy({bool refresh = false}) async {
    if (SyncTvService.activeServer == null || _isLoadingTaxonomy) return;
    final epoch = _homeStateEpoch.capture();
    setState(() => _isLoadingTaxonomy = true);
    try {
      final results = await Future.wait([
        SyncTvService.listRoomCategories(refresh: refresh),
        SyncTvService.listRoomLabels(refresh: refresh),
      ]);
      final categories =
          results[0]
              .cast<RoomCategoryInfo>()
              .where((category) => category.isEnabled)
              .toList()
            ..sort((a, b) {
              final order = a.sortOrder.compareTo(b.sortOrder);
              if (order != 0) return order;
              return _roomCategoryName(a).compareTo(_roomCategoryName(b));
            });
      final labels =
          results[1]
              .cast<RoomLabelInfo>()
              .where((label) => label.isEnabled)
              .toList()
            ..sort((a, b) {
              final order = a.sortOrder.compareTo(b.sortOrder);
              if (order != 0) return order;
              return _roomLabelName(a).compareTo(_roomLabelName(b));
            });
      if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
      setState(() {
        _roomCategories = categories;
        _roomLabels = labels;
        _selectedRoomLabelIds.removeWhere(
          (id) => !_availableRoomLabels.any((label) => label.id == id),
        );
        _isLoadingTaxonomy = false;
      });
    } catch (e) {
      debugPrint('Failed to load room taxonomy filters: $e');
      if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
      setState(() => _isLoadingTaxonomy = false);
    }
  }

  void _openStartRoomIfRequested() {
    final roomId = _startRoomId.trim();
    if (_startRoomHandled || roomId.isEmpty) return;
    _startRoomHandled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final epoch = _homeStateEpoch.capture();
      try {
        final room = await SyncTvService.getRoomDiscovery(roomId);
        if (mounted && _homeStateEpoch.isCurrent(epoch)) {
          await _handleJoinRoom(room);
        }
      } catch (e) {
        if (mounted && _homeStateEpoch.isCurrent(epoch)) {
          MessageUtils.showError(
            context,
            context.l10n.openRoomFailed(e.toString()),
          );
        }
      }
    });
  }

  Future<void> _loadRooms({bool silent = false}) async {
    final epoch = _homeStateEpoch.capture();
    final loadGeneration = ++_roomLoadGeneration;
    if (SyncTvService.activeServer == null) {
      if (mounted) {
        setState(() {
          _rooms = const [];
          _featuredRooms = const [];
          _joinedRooms = const [];
          _roomsTotal = 0;
          _isLoading = false;
        });
      }
      return;
    }
    if (!silent) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      if (_roomCategories.isEmpty) {
        unawaited(_loadRoomTaxonomy(refresh: true));
      }
      final search = _roomSearchController.text.trim();
      final showHomeSections =
          _roomPage == 1 &&
          search.isEmpty &&
          _selectedRoomCategoryId.isEmpty &&
          _selectedRoomLabelIds.isEmpty;
      final discoveryFuture = SyncTvService.discoverRooms(
        page: _roomPage,
        pageSize: _roomPageSize,
        search: search.isEmpty ? null : search,
        categoryId: _selectedRoomCategoryId,
        labelIds: _selectedRoomLabelIds.toList(growable: false),
      );
      final joinedFuture = _isAccountSession && showHomeSections
          ? SyncTvService.getMyRoomsPage(page: 1, pageSize: 12)
          : Future.value(
              const RoomsPage(
                rooms: <SyncTvRoom>[],
                total: 0,
                page: 1,
                pageSize: 12,
              ),
            );
      final results = await Future.wait<Object>([
        discoveryFuture,
        joinedFuture,
      ]);
      final discovery = results[0] as RoomDiscoveryPage;
      final joined = results[1] as RoomsPage;

      if (mounted &&
          _homeStateEpoch.isCurrent(epoch) &&
          loadGeneration == _roomLoadGeneration) {
        setState(() {
          _rooms = discovery.rooms;
          _featuredRooms = discovery.featuredRooms;
          _joinedRooms = joined.rooms;
          _roomsTotal = discovery.total;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted &&
          _homeStateEpoch.isCurrent(epoch) &&
          loadGeneration == _roomLoadGeneration) {
        setState(() {
          _isLoading = false;
        });
        MessageUtils.showError(
          context,
          context.l10n.loadRoomsFailed(e.toString()),
        );
      }
    }
  }

  int get _roomPageCount =>
      _roomsTotal <= 0 ? 1 : ((_roomsTotal - 1) ~/ _roomPageSize) + 1;

  void _applyRoomSearch(String value) {
    setState(() => _roomPage = 1);
    _loadRooms(silent: false);
  }

  List<RoomLabelInfo> get _availableRoomLabels {
    if (_selectedRoomCategoryId.isEmpty) return _roomLabels;
    return _roomLabels
        .where((label) => label.categoryId == _selectedRoomCategoryId)
        .toList(growable: false);
  }

  String _roomCategoryName(RoomCategoryInfo category) {
    final name = category.name.trim();
    return name.isEmpty ? category.key : name;
  }

  String _roomLabelName(RoomLabelInfo label) {
    final name = label.name.trim();
    return name.isEmpty ? label.key : name;
  }

  void _clearRoomTaxonomyFilters({bool load = true}) {
    setState(() {
      _selectedRoomCategoryId = '';
      _selectedRoomLabelIds.clear();
      _roomPage = 1;
    });
    if (load) _loadRooms(silent: false);
  }

  Future<void> _showRoomLabelFilter() async {
    if (_roomLabels.isEmpty) {
      await _loadRoomTaxonomy(refresh: true);
    }
    if (!mounted) return;
    final selectedIds = Set<String>.from(_selectedRoomLabelIds);
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: context.l10n.filterLabels,
      icon: const Icon(Icons.sell_outlined, color: Color(0xFF5D5FEF)),
      content: StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          final theme = Theme.of(dialogContext);
          final labels = _availableRoomLabels;
          return SizedBox(
            width: 520,
            child: AppSingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (labels.isEmpty)
                    Text(
                      _selectedRoomCategoryId.isEmpty
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
                                  Text(_roomLabelName(label)),
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
      _selectedRoomLabelIds
        ..clear()
        ..addAll(confirmed ? selectedIds : const <String>{});
      _roomPage = 1;
    });
    _loadRooms(silent: false);
  }

  void _goRoomPage(int page) {
    final next = page.clamp(1, _roomPageCount);
    if (next == _roomPage) return;
    setState(() => _roomPage = next);
    _loadRooms(silent: false);
  }

  Future<bool> _showLoginDialog({
    String? guestRoomId,
    bool startWithGuest = false,
  }) async {
    if (_modalOpen) return false;
    _modalOpen = true;
    final bool? result;
    try {
      result = await showAppBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: false,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withValues(alpha: 0.48),
        builder: (context) => AuthPanel(
          initialGuestRoomId: guestRoomId,
          startWithGuest: startWithGuest,
        ),
      );
    } finally {
      _modalOpen = false;
    }
    if (result == true) {
      if (mounted) {
        setState(() {
          _clearRoomSessionState();
          _isLoading = true;
        });
        unawaited(_loadRooms(silent: false));
        if (_isAccountSession) unawaited(_fetchUserInfo());
      }
      return true;
    }
    if (mounted) setState(() => _isLoading = false);
    return false;
  }

  void _showCreateRoomDialog() {
    if (_modalOpen) return;
    _modalOpen = true;
    () async {
      try {
        await showCreateRoomDialog(
          context: context,
          width: 300,
          onCreated: (room) async {
            if (!mounted) return;
            if (room.isActive) {
              await _navigateToRoom(room);
            } else {
              await _loadRooms(silent: true);
            }
          },
        );
      } finally {
        _modalOpen = false;
      }
    }();
  }

  void _showJoinRoomDialog() {
    if (_modalOpen) return;
    _modalOpen = true;
    () async {
      try {
        await showJoinRoomDialog(context: context, onSubmitted: _joinRoomById);
      } finally {
        _modalOpen = false;
      }
    }();
  }

  Future<void> _joinRoomById(String value) async {
    if (value.trim().isEmpty) {
      MessageUtils.showWarning(context, context.l10n.roomIdRequired);
      return;
    }
    final epoch = _homeStateEpoch.capture();
    try {
      final id = await parseInviteOrShowError(context: context, value: value);
      if (id == null || id.isEmpty) return;
      final room = await SyncTvService.getRoomDiscovery(id);
      if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
      Navigator.pop(context);
      await _handleJoinRoom(room);
    } catch (e) {
      if (mounted && _homeStateEpoch.isCurrent(epoch)) {
        MessageUtils.showError(
          context,
          context.l10n.findRoomFailed(e.toString()),
        );
      }
    }
  }

  void _showAdminSettingsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminSettingsPage()),
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
      if (!mounted) return;
      if (accountClosed == true) {
        setState(() {
          _clearRoomSessionState();
        });
        unawaited(_loadRooms(silent: false));
      } else {
        _fetchUserInfo();
      }
    });
  }

  void _showServerSettingsDialog({bool requireServer = false}) {
    if (_modalOpen) return;
    _modalOpen = true;
    () async {
      try {
        final changed = await showServerSettingsDialog(
          context: context,
          requireServer: requireServer,
        );
        if (!mounted || changed != true) return;
        setState(() {
          _clearRoomSessionState(clearTaxonomy: true);
          _isLoading = true;
        });
        unawaited(_loadRooms(silent: false));
        if (_isAccountSession) unawaited(_fetchUserInfo());
      } finally {
        _modalOpen = false;
      }
    }();
  }

  Future<void> _handleLogout() async {
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: context.l10n.logout,
      icon: const Icon(Icons.logout, color: Colors.red),
      content: Text(context.l10n.logoutConfirmMessage),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.logoutAction,
        ),
      ],
    );

    if (confirm == true) {
      await SyncTvService.logout();
      if (mounted) {
        setState(() {
          _clearRoomSessionState();
        });
        MessageUtils.showSuccess(context, context.l10n.loggedOut);
        _loadRooms(silent: false);
      }
    }
  }

  Future<void> _handleJoinRoom(SyncTvRoom room) async {
    final operation = Object();
    if (_joiningRoomOperations.putIfAbsent(room.roomId, () => operation) !=
        operation) {
      return;
    }
    var epoch = _homeStateEpoch.capture();
    var targetRoom = room;
    String password = '';

    try {
      final guestAccess =
          room.discoveryAccess ==
          client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_GUEST.value;
      final authenticationMode = roomAuthenticationMode(
        identity: _identityKind,
        guestAccess: guestAccess,
        guestBoundToRoom: SyncTvService.guestRoomId == room.roomId,
      );
      if (authenticationMode != RoomAuthenticationMode.none) {
        final authenticated = await _showLoginDialog(
          guestRoomId: room.roomId,
          startWithGuest: authenticationMode == RoomAuthenticationMode.guest,
        );
        if (!authenticated || !mounted) return;
        epoch = _homeStateEpoch.capture();
        _joiningRoomOperations[room.roomId] = operation;
        if (_isAccountSession) {
          targetRoom = await SyncTvService.getRoomDiscovery(room.roomId);
        }
        if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
      }

      if (_isGuestSession && !guestAccess) {
        MessageUtils.showWarning(context, context.l10n.roomUnavailable);
        return;
      }

      if (targetRoom.joined) {
        if (mounted) await _navigateToRoom(targetRoom);
        return;
      }
      if (!targetRoom.canJoin && !_isGuestSession) {
        if (mounted) {
          MessageUtils.showWarning(context, context.l10n.roomUnavailable);
        }
        return;
      }

      if (targetRoom.discoveryAccess ==
          client_enum
              .RoomDiscoveryAccess
              .ROOM_DISCOVERY_ACCESS_PASSWORD
              .value) {
        final result = await showRoomPasswordDialog(
          context: context,
          roomName: targetRoom.roomName,
        );

        if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
        if (result == null) return;
        if (result.isEmpty) {
          if (mounted) {
            MessageUtils.showWarning(context, context.l10n.passwordRequired);
          }
          return;
        }
        password = result;
      }

      final result = await SyncTvService.joinRoom(targetRoom.roomId, password);
      if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
      if (result.requiresApproval) {
        if (mounted) {
          MessageUtils.showSuccess(
            context,
            context.l10n.roomJoinRequestSubmitted,
          );
          await _loadRooms(silent: true);
        }
        return;
      }
      if (mounted) {
        await _navigateToRoom(
          targetRoom.copyWith(
            joined: true,
            canJoin: false,
            discoveryAccess: client_enum
                .RoomDiscoveryAccess
                .ROOM_DISCOVERY_ACCESS_ENTER
                .value,
          ),
        );
      }
    } catch (e) {
      if (mounted && _homeStateEpoch.isCurrent(epoch)) {
        MessageUtils.showError(
          context,
          context.l10n.joinRoomFailed(e.toString()),
        );
      }
    } finally {
      if (identical(_joiningRoomOperations[room.roomId], operation)) {
        _joiningRoomOperations.remove(room.roomId);
      }
    }
  }

  Future<void> _navigateToRoom(SyncTvRoom room) async {
    final deleted = await Navigator.push<bool>(
      context,
      PageRouteBuilder(
        opaque: true,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) =>
            RoomScreen(room: room),
      ),
    );
    if (!mounted) return;
    if (deleted == true) {
      setState(() {
        _rooms = _rooms.where((item) => item.roomId != room.roomId).toList();
        if (_roomsTotal > 0) _roomsTotal -= 1;
      });
    }
    await _loadRooms(silent: true);
  }

  Future<void> _handleDeleteRoom(SyncTvRoom room) async {
    final confirm = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: context.l10n.deleteRoom,
      icon: const Icon(Icons.delete_outline, color: Colors.red),
      content: Text(context.l10n.deleteRoomConfirm(room.roomName)),
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
      final epoch = _homeStateEpoch.capture();
      try {
        await SyncTvService.deleteRoom(room.roomId);
        if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
        MessageUtils.showSuccess(context, context.l10n.roomDeleted);
        _loadRooms(silent: true);
      } catch (e) {
        if (mounted && _homeStateEpoch.isCurrent(epoch)) {
          MessageUtils.showError(
            context,
            context.l10n.deleteFailed(e.toString()),
          );
        }
      }
    }
  }

  Future<void> _toggleRoomFavorite(SyncTvRoom room) async {
    if (!_isAccountSession) {
      await _showLoginDialog();
      return;
    }
    if (!room.joined) return;
    if (!_favoriteRoomIdsInFlight.add(room.roomId)) return;
    final epoch = _homeStateEpoch.capture();
    final wasFavorite = room.isFavorite;
    void updateFavorite(bool isFavorite) {
      SyncTvRoom updateItem(SyncTvRoom item) => item.roomId == room.roomId
          ? item.copyWith(isFavorite: isFavorite)
          : item;
      _rooms = _rooms.map(updateItem).toList(growable: false);
      _featuredRooms = _featuredRooms.map(updateItem).toList(growable: false);
      _joinedRooms = _joinedRooms.map(updateItem).toList(growable: false);
    }

    setState(() {
      updateFavorite(!wasFavorite);
    });
    try {
      final SyncTvRoom updatedRoom;
      if (wasFavorite) {
        updatedRoom = await SyncTvService.unfavoriteRoom(room.roomId);
      } else {
        updatedRoom = await SyncTvService.favoriteRoom(room.roomId);
      }
      if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
      setState(() {
        updateFavorite(updatedRoom.isFavorite);
      });
    } catch (e) {
      if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
      setState(() {
        updateFavorite(wasFavorite);
      });
      MessageUtils.showError(
        context,
        context.l10n.updateFavoriteFailed(e.toString()),
      );
    } finally {
      if (mounted && _homeStateEpoch.isCurrent(epoch)) {
        setState(() {
          _favoriteRoomIdsInFlight.remove(room.roomId);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isAdmin =
        _currentUser?.role == common_enum.UserRole.USER_ROLE_ROOT.value ||
        _currentUser?.role == common_enum.UserRole.USER_ROLE_ADMIN.value;

    return AppScaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: AppInkSurface(
          color: theme.appBarTheme.backgroundColor,
          elevation: 0,
          clipBehavior: Clip.none,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 760;
              final extraCompact = constraints.maxWidth < 560;
              final horizontalPadding = compact ? 16.0 : 28.0;
              return Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Row(
                        children: [
                          AppInkSurface(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            onLongPress: _showServerSettingsDialog,
                            semanticLabel: l10n.openServerSettings,
                            child: Row(
                              children: [
                                SyncTvBrandMark(
                                  semanticLabel: l10n.appTitle,
                                  size: 36,
                                ),
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
                          if (!_isAccountSession && compact)
                            AppActionButton(
                              onPressed: _showServerSettingsDialog,
                              icon: Icons.dns_rounded,
                              label: l10n.server,
                              style: AppActionButtonStyle.tonal,
                            )
                          else
                            AppIconButton(
                              tooltip: l10n.serverSettings,
                              onPressed: _showServerSettingsDialog,
                              icon: Icons.dns_rounded,
                              style: AppIconButtonStyle.tonal,
                            ),
                          SizedBox(width: compact ? 8 : 12),
                          if (!_isAccountSession) ...[
                            AppIconButton(
                              tooltip: l10n.language,
                              onPressed: () =>
                                  showLanguageSelectorDialog(context),
                              icon: Icons.language_rounded,
                              style: AppIconButtonStyle.tonal,
                            ),
                            SizedBox(width: compact ? 8 : 12),
                          ],
                          if (_isAccountSession) ...[
                            if (compact)
                              AppIconButton(
                                tooltip: l10n.joinRoom,
                                onPressed: _showJoinRoomDialog,
                                icon: Icons.login_rounded,
                                style: AppIconButtonStyle.tonal,
                              )
                            else
                              AppActionButton(
                                onPressed: _showJoinRoomDialog,
                                icon: Icons.login_rounded,
                                label: l10n.joinRoom,
                                style: AppActionButtonStyle.outlined,
                              ),
                            SizedBox(width: compact ? 8 : 10),
                            if (compact)
                              AppIconButton(
                                tooltip: l10n.createRoom,
                                onPressed: _showCreateRoomDialog,
                                icon: Icons.add_rounded,
                                style: AppIconButtonStyle.filled,
                              )
                            else
                              AppActionButton(
                                onPressed: _showCreateRoomDialog,
                                icon: Icons.add_rounded,
                                label: l10n.createRoom,
                              ),
                            SizedBox(width: compact ? 8 : 12),
                            compact
                                ? _buildCompactAccountMenu(theme, isAdmin)
                                : _buildAccountMenu(theme, isAdmin, isDark),
                          ] else if (compact)
                            AppActionButton(
                              onPressed: _showLoginDialog,
                              icon: Icons.login_rounded,
                              label: l10n.login,
                            )
                          else
                            AppActionButton(
                              onPressed: _showLoginDialog,
                              icon: Icons.login_rounded,
                              label: l10n.login,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      body: _isLoading
          ? const AppLoadingIndicator()
          : _buildDiscoveryBody(theme),
    );
  }

  Widget _buildDiscoveryBody(ThemeData theme) {
    return AppRefreshIndicator(
      onRefresh: () => _loadRooms(silent: true),
      child: AppSingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppMetrics.pagePadding(context),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_roomPage == 1 && _featuredRooms.isNotEmpty) ...[
                  _buildSectionHeading(
                    context.l10n.featuredRooms,
                    context.l10n.featuredRoomsDescription,
                    Icons.auto_awesome_rounded,
                  ),
                  const SizedBox(height: 12),
                  _buildFeaturedRooms(),
                  const SizedBox(height: 24),
                ],
                if (_isAccountSession && _joinedRooms.isNotEmpty) ...[
                  _buildSectionHeading(
                    context.l10n.continueWatchingRooms,
                    context.l10n.continueWatchingRoomsDescription,
                    Icons.play_circle_outline_rounded,
                  ),
                  const SizedBox(height: 12),
                  _buildJoinedRooms(),
                  const SizedBox(height: 24),
                ],
                if (_roomCategories.isNotEmpty) ...[
                  _buildCategoryStrip(theme),
                  const SizedBox(height: 18),
                ],
                _buildRoomControls(theme),
                const SizedBox(height: 22),
                _buildSectionHeading(
                  context.l10n.popularRooms,
                  context.l10n.popularRoomsDescription,
                  Icons.local_fire_department_rounded,
                ),
                const SizedBox(height: 12),
                _buildRoomGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeading(String title, String subtitle, IconData icon) {
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

  Widget _buildFeaturedRooms() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 860) {
          return _HorizontalRoomRail(
            height: 224,
            itemCount: _featuredRooms.length,
            itemWidth: (availableWidth) => availableWidth < 520
                ? (availableWidth * 0.86).clamp(248, 316)
                : 292,
            previousTooltip: context.l10n.previousRooms,
            nextTooltip: context.l10n.nextRooms,
            itemBuilder: (context, index) =>
                _buildRoomCard(_featuredRooms[index], index),
          );
        }
        if (_featuredRooms.length <= 3) {
          final itemCount = _featuredRooms.length;
          final railHeight = itemCount == 3 ? 300.0 : 390.0;
          return _HorizontalRoomRail(
            height: railHeight,
            itemCount: itemCount,
            itemWidth: (availableWidth) => switch (itemCount) {
              1 => availableWidth.clamp(0, 680),
              2 => ((availableWidth - 12) / 2).clamp(0, 560),
              _ => ((availableWidth - 24) / 3).clamp(0, 440),
            },
            previousTooltip: context.l10n.previousRooms,
            nextTooltip: context.l10n.nextRooms,
            itemBuilder: (context, index) =>
                _buildRoomCard(_featuredRooms[index], index),
          );
        }
        final primary = _featuredRooms.first;
        final secondary = _featuredRooms.skip(1).take(4).toList();
        return SizedBox(
          height: 390,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 5, child: _buildRoomCard(primary, 0)),
              if (secondary.isNotEmpty) ...[
                const SizedBox(width: 14),
                Expanded(
                  flex: 6,
                  child: AppGridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          mainAxisExtent: 188,
                        ),
                    itemCount: secondary.length,
                    itemBuilder: (context, index) =>
                        _buildRoomCard(secondary[index], index + 1),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildJoinedRooms() {
    return _HorizontalRoomRail(
      height: 196,
      itemCount: _joinedRooms.length,
      itemWidth: (availableWidth) =>
          availableWidth < 520 ? (availableWidth * 0.80).clamp(236, 292) : 264,
      previousTooltip: context.l10n.previousRooms,
      nextTooltip: context.l10n.nextRooms,
      itemBuilder: (context, index) =>
          _buildRoomCard(_joinedRooms[index], index),
    );
  }

  Widget _buildCategoryStrip(ThemeData theme) {
    return SizedBox(
      height: 44,
      child: AppListView(
        scrollDirection: Axis.horizontal,
        children: [
          AppChip(
            label: Text(context.l10n.allCategories),
            selected: _selectedRoomCategoryId.isEmpty,
            onSelected: (_) {
              setState(() {
                _selectedRoomCategoryId = '';
                _selectedRoomLabelIds.clear();
                _roomPage = 1;
              });
              _loadRooms(silent: false);
            },
          ),
          const SizedBox(width: 8),
          for (final category in _roomCategories) ...[
            AppChip(
              label: Text(_roomCategoryName(category)),
              selected: _selectedRoomCategoryId == category.id,
              onSelected: (_) {
                setState(() {
                  _selectedRoomCategoryId = category.id;
                  _selectedRoomLabelIds.removeWhere(
                    (id) =>
                        !_availableRoomLabels.any((label) => label.id == id),
                  );
                  _roomPage = 1;
                });
                _loadRooms(silent: false);
              },
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildCompactAccountMenu(ThemeData theme, bool isAdmin) {
    final l10n = context.l10n;
    return AppPopupMenuButton<String>(
      offset: const Offset(0, 46),
      tooltip: l10n.accountMenu,
      child: AppAvatar(
        name: _currentUser?.username,
        radius: 18,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        textStyle: const TextStyle(fontSize: 13),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'account',
          child: Row(
            children: [
              const Icon(Icons.account_circle_rounded, size: 18),
              const SizedBox(width: 8),
              Text(l10n.accountCenter),
            ],
          ),
        ),
        if (isAdmin)
          PopupMenuItem(
            value: 'admin',
            child: Row(
              children: [
                const Icon(Icons.admin_panel_settings_rounded, size: 18),
                const SizedBox(width: 8),
                Text(l10n.adminSettings),
              ],
            ),
          ),
        PopupMenuItem(
          value: 'server',
          child: Row(
            children: [
              const Icon(Icons.dns_rounded, size: 18),
              const SizedBox(width: 8),
              Text(l10n.serverSettings),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'language',
          child: Row(
            children: [
              const Icon(Icons.language_rounded, size: 18),
              const SizedBox(width: 8),
              Text(l10n.language),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout_rounded, color: Colors.red, size: 18),
              const SizedBox(width: 8),
              Text(l10n.logout, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'account':
            _showAccountCenter();
            break;
          case 'admin':
            _showAdminSettingsPage();
            break;
          case 'server':
            _showServerSettingsDialog();
            break;
          case 'language':
            showLanguageSelectorDialog(context);
            break;
          case 'logout':
            _handleLogout();
            break;
        }
      },
    );
  }

  Widget _buildAccountMenu(ThemeData theme, bool isAdmin, bool isDark) {
    final l10n = context.l10n;
    return AppPopupMenuButton<String>(
      offset: const Offset(0, 46),
      tooltip: l10n.accountMenu,
      child: AppInkSurface(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.7),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            children: [
              AppAvatar(
                name: _currentUser?.username,
                radius: 15,
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                textStyle: const TextStyle(fontSize: 13),
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 140),
                child: Text(
                  _currentUser?.username ?? 'User',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.expand_more_rounded, size: 18),
            ],
          ),
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'account',
          child: Row(
            children: [
              const Icon(Icons.account_circle_rounded, size: 18),
              const SizedBox(width: 8),
              Text(l10n.accountCenter),
            ],
          ),
        ),
        if (isAdmin)
          PopupMenuItem(
            value: 'admin',
            child: Row(
              children: [
                const Icon(Icons.admin_panel_settings_rounded, size: 18),
                const SizedBox(width: 8),
                Text(l10n.adminSettings),
              ],
            ),
          ),
        PopupMenuItem(
          value: 'server',
          child: Row(
            children: [
              const Icon(Icons.dns_rounded, size: 18),
              const SizedBox(width: 8),
              Text(l10n.serverSettings),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'language',
          child: Row(
            children: [
              const Icon(Icons.language_rounded, size: 18),
              const SizedBox(width: 8),
              Text(l10n.language),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              const Icon(Icons.logout_rounded, color: Colors.red, size: 18),
              const SizedBox(width: 8),
              Text(l10n.logout, style: const TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'account':
            _showAccountCenter();
            break;
          case 'admin':
            _showAdminSettingsPage();
            break;
          case 'server':
            _showServerSettingsDialog();
            break;
          case 'language':
            showLanguageSelectorDialog(context);
            break;
          case 'logout':
            _handleLogout();
            break;
        }
      },
    );
  }

  Widget _buildRoomControls(ThemeData theme) {
    final summary = context.l10n.roomsPageSummary(
      _roomsTotal,
      _roomPage,
      _roomPageCount,
    );
    final compact = AppBreakpoints.widthOf(context) < 1080;

    return AppInkSurface(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.7)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: compact
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildRoomFilterControls(),
                  const SizedBox(height: 12),
                  _buildRoomControlActions(theme, summary),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _buildRoomFilterControls()),
                  const SizedBox(width: 12),
                  _buildRoomControlActions(theme, summary),
                ],
              ),
      ),
    );
  }

  Widget _buildRoomFilterControls() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final l10n = context.l10n;
        final compact = constraints.maxWidth < 520;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            AppSearchField(
              controller: _roomSearchController,
              width: compact ? constraints.maxWidth : 320,
              hintText: l10n.searchRooms,
              onChanged: (value) {
                if (value.isEmpty) _applyRoomSearch('');
              },
              onSubmitted: _applyRoomSearch,
            ),
            AppSelect<String?>(
              value: _selectedRoomCategoryId.isEmpty
                  ? null
                  : _selectedRoomCategoryId,
              width: compact ? constraints.maxWidth : 180,
              hintText: l10n.allCategories,
              prefixIcon: Icons.category_outlined,
              clearable: true,
              enabled: !_isLoadingTaxonomy && _roomCategories.isNotEmpty,
              options: {
                l10n.allCategories: null,
                for (final category in _roomCategories)
                  _roomCategoryName(category): category.id,
              },
              onChanged: (value) {
                setState(() {
                  _selectedRoomCategoryId = value ?? '';
                  _selectedRoomLabelIds.removeWhere(
                    (id) =>
                        !_availableRoomLabels.any((label) => label.id == id),
                  );
                  _roomPage = 1;
                });
                _loadRooms(silent: false);
              },
            ),
            AppActionButton(
              onPressed: _isLoadingTaxonomy ? null : _showRoomLabelFilter,
              icon: Icons.sell_outlined,
              label: _selectedRoomLabelIds.isEmpty
                  ? l10n.labels
                  : l10n.selectedLabels(_selectedRoomLabelIds.length),
              style: _selectedRoomLabelIds.isEmpty
                  ? AppActionButtonStyle.outlined
                  : AppActionButtonStyle.tonal,
            ),
            if (_selectedRoomCategoryId.isNotEmpty ||
                _selectedRoomLabelIds.isNotEmpty)
              AppIconButton(
                tooltip: l10n.clearRoomTaxonomyFilters,
                icon: Icons.filter_alt_off_rounded,
                onPressed: _clearRoomTaxonomyFilters,
                style: AppIconButtonStyle.tonal,
              ),
          ],
        );
      },
    );
  }

  Widget _buildRoomControlActions(ThemeData theme, String summary) {
    final summaryStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.68),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: AppBreakpoints.widthOf(context) < 1080
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.end,
      children: [
        Flexible(
          child: AppPaginationBar(
            padding: EdgeInsets.zero,
            label: summary,
            labelStyle: summaryStyle,
            onPrevious: _roomPage <= 1
                ? null
                : () => _goRoomPage(_roomPage - 1),
            onNext: _roomPage >= _roomPageCount
                ? null
                : () => _goRoomPage(_roomPage + 1),
          ),
        ),
        const SizedBox(width: 8),
        AppIconButton(
          tooltip: context.l10n.refresh,
          onPressed: () => _loadRooms(silent: false),
          icon: Icons.refresh_rounded,
          style: AppIconButtonStyle.tonal,
        ),
      ],
    );
  }

  Widget _buildRoomGrid() {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final hasServer = SyncTvService.activeServer != null;
    final emptyIcon = !hasServer
        ? Icons.dns_rounded
        : Icons.meeting_room_outlined;
    final emptyTitle = !hasServer ? l10n.addServerToStart : l10n.noRooms;
    final emptyDescription = !hasServer
        ? l10n.addServerDescription
        : l10n.filteredRoomsEmptyDescription;
    if (_rooms.isEmpty) {
      return SizedBox(
        height: 280,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                emptyIcon,
                size: 56,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
              ),
              const SizedBox(height: 14),
              Text(
                emptyTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                emptyDescription,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
                ),
              ),
              const SizedBox(height: 20),
              AppActionButton(
                onPressed: hasServer
                    ? () => _loadRooms(silent: false)
                    : _showServerSettingsDialog,
                icon: hasServer ? Icons.refresh_rounded : Icons.add_link,
                label: hasServer ? l10n.refresh : l10n.addServer,
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
      itemCount: _rooms.length,
      itemBuilder: (context, index) => _buildRoomCard(_rooms[index], index),
    );
  }

  Widget _buildRoomCard(SyncTvRoom room, int index) {
    final unavailable =
        room.isBanned ||
        room.availability == 2 ||
        room.discoveryAccess ==
            client_enum
                .RoomDiscoveryAccess
                .ROOM_DISCOVERY_ACCESS_UNAVAILABLE
                .value;
    final canOpen =
        !unavailable &&
        (room.joined ||
            room.canJoin ||
            room.discoveryAccess ==
                client_enum
                    .RoomDiscoveryAccess
                    .ROOM_DISCOVERY_ACCESS_SIGN_IN
                    .value);
    return CinemaRoomCard(
      roomName: room.roomName,
      description: room.description,
      coverUrl: room.coverUrl,
      viewerCount: room.viewerCount,
      memberCount: room.memberCount,
      creatorName: room.creator,
      creatorAvatarUrl: room.creatorAvatarUrl,
      availability: room.availability,
      isBanned: room.isBanned,
      joined: room.joined,
      canJoin: room.canJoin,
      discoveryAccess: room.discoveryAccess,
      onTap: canOpen ? () => _handleJoinRoom(room) : null,
      onFavoritePressed: room.joined ? () => _toggleRoomFavorite(room) : null,
      isFavorite: room.isFavorite,
      favoriteLoading: _favoriteRoomIdsInFlight.contains(room.roomId),
      onLongPress: _currentUser != null && _currentUser!.id == room.creatorId
          ? () => _handleDeleteRoom(room)
          : null,
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
    final canScrollBackward = position.pixels > position.minScrollExtent + 1;
    final canScrollForward = position.pixels < position.maxScrollExtent - 1;
    if (_canScrollBackward == canScrollBackward &&
        _canScrollForward == canScrollForward) {
      return;
    }
    setState(() {
      _canScrollBackward = canScrollBackward;
      _canScrollForward = canScrollForward;
    });
  }

  void _moveBy(double delta, {bool animate = true}) {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    final target = (_controller.offset + delta).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if (animate) {
      _controller.animateTo(
        target,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    } else {
      _controller.jumpTo(target);
    }
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || !_controller.hasClients) return;
    final horizontalDelta = event.scrollDelta.dx;
    final delta = horizontalDelta.abs() > event.scrollDelta.dy.abs()
        ? horizontalDelta
        : event.scrollDelta.dy;
    if (delta == 0) return;
    final position = _controller.position;
    final target = (_controller.offset + delta).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if ((target - _controller.offset).abs() < 0.5) return;
    GestureBinding.instance.pointerSignalResolver.register(event, (_) {
      _moveBy(delta, animate: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = widget.itemWidth(constraints.maxWidth);
        final scrollBehavior = ScrollConfiguration.of(context).copyWith(
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
                  behavior: scrollBehavior,
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
                  child: _RailNavigationButton(
                    icon: Icons.chevron_left_rounded,
                    tooltip: widget.previousTooltip,
                    onPressed: () =>
                        _moveBy(-_controller.position.viewportDimension * 0.82),
                  ),
                ),
              if (_canScrollForward)
                Positioned(
                  right: 8,
                  child: _RailNavigationButton(
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
}

class _RailNavigationButton extends StatelessWidget {
  const _RailNavigationButton({
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
