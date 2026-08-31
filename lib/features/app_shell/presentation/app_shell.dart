import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/contracts/account_models.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/core/async/async_operation_coordinator.dart';
import 'package:synctv_app/features/home/domain/home_room_access.dart';
import 'package:synctv_app/features/home/application/home_gateway.dart';
import 'package:synctv_app/features/room/presentation/room_screen.dart';
import 'package:synctv_app/features/room/presentation/room_settings_page.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';
import 'package:synctv_app/features/admin/presentation/admin_settings_page.dart';
import 'package:synctv_app/features/account/presentation/account_center_page.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/features/room/presentation/room_taxonomy.dart';
import 'package:synctv_app/features/room/presentation/create_room_dialog.dart';
import 'package:synctv_app/features/room/presentation/join_room_dialog.dart';
import 'package:synctv_app/core/localization/presentation/language_selector_dialog.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room_invite/presentation/room_invite_flow.dart';
import 'package:synctv_app/features/server_settings/presentation/server_settings_dialog.dart';
import 'package:synctv_app/features/providers/presentation/binding/platform_binding_dialog.dart';
import 'package:synctv_app/features/room/domain/realtime_event_log.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

import 'package:synctv_app/features/auth/presentation/auth_panel.dart';
import 'package:synctv_app/features/app_shell/presentation/app_shell_dependencies.dart';
import 'package:synctv_app/features/home/presentation/home_view.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.dependencies});

  final AppShellDependencies dependencies;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
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

  HomeGateway get _gateway => widget.dependencies.homeGateway;

  @override
  void initState() {
    super.initState();
    _authErrorSubscription = _gateway.authErrors.listen((_) {
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
      if (mounted && !_gateway.hasServer) {
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

  SyncTvSessionIdentity get _sessionIdentity => _gateway.sessionIdentity;

  bool get _isGuestSession => _sessionIdentity is GuestSessionIdentity;
  bool get _isAccountSession => _sessionIdentity is AccountSessionIdentity;

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
      final user = await _gateway.getCurrentUser();
      if (mounted && _homeStateEpoch.isCurrent(epoch) && _isAccountSession) {
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      // Ignore
    }
  }

  void _checkLoginAndLoadData() {
    unawaited(_loadRooms(silent: false));
    if (_isAccountSession) {
      unawaited(_fetchUserInfo());
    }
    _openStartRoomIfRequested();
  }

  Future<void> _loadRoomTaxonomy({bool refresh = false}) async {
    if (!_gateway.hasServer || _isLoadingTaxonomy) return;
    final epoch = _homeStateEpoch.capture();
    setState(() => _isLoadingTaxonomy = true);
    try {
      final results = await Future.wait([
        _gateway.listRoomCategories(refresh: refresh),
        _gateway.listRoomLabels(refresh: refresh),
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
        final room = await _gateway.getRoom(roomId);
        if (mounted && _homeStateEpoch.isCurrent(epoch)) {
          await _handleJoinRoom(room);
        }
      } catch (e) {
        if (mounted && _homeStateEpoch.isCurrent(epoch)) {
          AppNotifications.showError(
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
    if (!_gateway.hasServer) {
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
      final discoveryFuture = _gateway.discoverRooms(
        page: _roomPage,
        pageSize: _roomPageSize,
        search: search.isEmpty ? null : search,
        categoryId: _selectedRoomCategoryId,
        labelIds: _selectedRoomLabelIds.toList(growable: false),
      );
      final joinedFuture = _isAccountSession && showHomeSections
          ? _gateway.getJoinedRooms(page: 1, pageSize: 12)
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
        AppNotifications.showError(
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
    final confirmed = await AppDialogs.showStyledDialog<bool>(
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
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppActionButton(
          onPressed: () => Navigator.pop(context, false),
          icon: Icons.filter_alt_off_rounded,
          label: context.l10n.clear,
          style: AppActionButtonStyle.tonal,
        ),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
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
          gateway: widget.dependencies.authGateway,
          passkeyClient: widget.dependencies.passkeyClient,
          opaqueAuthenticator: widget.dependencies.opaqueAuthenticator,
          oauth2Callbacks: widget.dependencies.oauth2Callbacks,
          nativeAppleSignIn: widget.dependencies.nativeAppleSignIn,
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
      AppNotifications.showWarning(context, context.l10n.roomIdRequired);
      return;
    }
    final epoch = _homeStateEpoch.capture();
    try {
      final id = await parseInviteOrShowError(context: context, value: value);
      if (id == null || id.isEmpty) return;
      final room = await _gateway.getRoom(id);
      if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
      Navigator.pop(context);
      await _handleJoinRoom(room);
    } catch (e) {
      if (mounted && _homeStateEpoch.isCurrent(epoch)) {
        AppNotifications.showError(
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
        builder: (context) => AccountCenterPage(
          initialUser: user,
          onOpenRoom: _openAccountRoom,
          onCreateRoom: _createAccountRoom,
          onManageRoom: _manageAccountRoom,
          onOpenProviderBinding: _openProviderBinding,
        ),
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

  Future<void> _openAccountRoom(SyncTvRoom room) async {
    final latest = await _gateway.getRoom(room.roomId);
    if (mounted) await _navigateToRoom(latest);
  }

  Future<void> _createAccountRoom() {
    return showCreateRoomDialog(
      context: context,
      onCreated: (room) async {
        if (room.isActive && mounted) await _navigateToRoom(room);
      },
    );
  }

  Future<void> _manageAccountRoom(SyncTvRoom room) async {
    final user = _currentUser;
    if (user == null) return;
    final settings = await widget.dependencies.roomManagementGateway
        .getRoomSettings(room.roomId);
    if (!mounted) return;
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => RoomSettingsPage(
          roomId: room.roomId,
          roomName: room.roomName,
          creatorId: room.creatorId,
          currentUserId: user.id,
          isPublic: room.isPublic,
          currentSettings: settings,
          realtime: RoomRealtimeSession(
            send: (_) {},
            messages: const Stream<RoomRealtimeMessage>.empty(),
            events: const Stream<RealtimeEventLogEntry>.empty(),
            reconnects: const Stream<void>.empty(),
          ),
          p2pMediaPreferences: widget.dependencies.p2pMediaPreferences,
          canViewPlaybackHistory: user.id == room.creatorId,
          canNavigatePlayback: user.id == room.creatorId,
          canManagePlaybackHistory: user.id == room.creatorId,
          canUseWebRtc: false,
        ),
      ),
    );
  }

  Future<void> _openProviderBinding(String providerType) =>
      PlatformBindingDialog.show(context, initialProviderType: providerType);

  void _showServerSettingsDialog({bool requireServer = false}) {
    if (_modalOpen) return;
    _modalOpen = true;
    () async {
      var refreshedDuringDialog = false;
      try {
        final changed = await showServerSettingsDialog(
          context: context,
          requireServer: requireServer,
          onServerChanged: () {
            refreshedDuringDialog = true;
            _refreshAfterServerChanged();
          },
        );
        if (!mounted || changed != true || refreshedDuringDialog) return;
        _refreshAfterServerChanged();
      } finally {
        _modalOpen = false;
      }
    }();
  }

  void _refreshAfterServerChanged() {
    if (!mounted) return;
    setState(() {
      _clearRoomSessionState(clearTaxonomy: true);
      _isLoading = true;
    });
    unawaited(_loadRooms(silent: false));
    if (_isAccountSession) unawaited(_fetchUserInfo());
  }

  Future<void> _handleLogout() async {
    final confirm = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.logout,
      icon: const Icon(Icons.logout, color: Colors.red),
      content: Text(context.l10n.logoutConfirmMessage),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.logoutAction,
        ),
      ],
    );

    if (confirm == true) {
      await _gateway.logout();
      if (mounted) {
        setState(() {
          _clearRoomSessionState();
        });
        AppNotifications.showSuccess(context, context.l10n.loggedOut);
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
    JoinRoomResult? completedJoin;

    try {
      final authenticationMode = roomAuthenticationMode(
        identity: _sessionIdentity,
        roomId: room.roomId,
        discoveryAccess: room.discoveryAccess,
      );
      if (authenticationMode != RoomAuthenticationMode.ready) {
        final authenticated = await _showLoginDialog(
          guestRoomId: room.roomId,
          startWithGuest: authenticationMode == RoomAuthenticationMode.guest,
        );
        if (!authenticated || !mounted) return;
        epoch = _homeStateEpoch.capture();
        _joiningRoomOperations[room.roomId] = operation;
        if (_isAccountSession) {
          targetRoom = await _gateway.getRoom(room.roomId);
        }
        if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
      }

      if (_isGuestSession &&
          room.discoveryAccess !=
              client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_GUEST) {
        AppNotifications.showWarning(context, context.l10n.roomUnavailable);
        return;
      }

      if (targetRoom.joined) {
        if (mounted) await _navigateToRoom(targetRoom);
        return;
      }
      if (!targetRoom.canJoin && !_isGuestSession) {
        if (mounted) {
          AppNotifications.showWarning(context, context.l10n.roomUnavailable);
        }
        return;
      }

      if (targetRoom.discoveryAccess ==
          client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_PASSWORD) {
        completedJoin = await showRoomPasswordDialog(
          context: context,
          roomName: targetRoom.roomName,
          onSubmitted: (password) =>
              _gateway.joinRoom(targetRoom.roomId, password),
        );

        if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
        if (completedJoin == null) return;
      }

      final result =
          completedJoin ?? await _gateway.joinRoom(targetRoom.roomId, '');
      if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
      switch (result) {
        case RoomJoinReviewPending():
          AppNotifications.showSuccess(
            context,
            context.l10n.roomJoinRequestSubmitted,
          );
          await _loadRooms(silent: true);
          return;
        case RoomJoined():
          break;
      }
      if (mounted) {
        await _navigateToRoom(
          targetRoom.copyWith(
            joined: true,
            canJoin: false,
            discoveryAccess:
                client_enum.RoomDiscoveryAccess.ROOM_DISCOVERY_ACCESS_ENTER,
          ),
        );
      }
    } catch (e) {
      if (mounted && _homeStateEpoch.isCurrent(epoch)) {
        AppNotifications.showError(
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
        pageBuilder: (context, animation, secondaryAnimation) => RoomScreen(
          room: room,
          p2pMediaPreferences: widget.dependencies.p2pMediaPreferences,
        ),
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
    final confirm = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.deleteRoom,
      icon: const Icon(Icons.delete_outline, color: Colors.red),
      content: Text(context.l10n.deleteRoomConfirm(room.roomName)),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.delete,
        ),
      ],
    );

    if (confirm == true) {
      final epoch = _homeStateEpoch.capture();
      try {
        await _gateway.deleteRoom(room.roomId);
        if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
        AppNotifications.showSuccess(context, context.l10n.roomDeleted);
        _loadRooms(silent: true);
      } catch (e) {
        if (mounted && _homeStateEpoch.isCurrent(epoch)) {
          AppNotifications.showError(
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
        updatedRoom = await _gateway.unfavoriteRoom(room.roomId);
      } else {
        updatedRoom = await _gateway.favoriteRoom(room.roomId);
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
      AppNotifications.showError(
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
    final isAdmin = _currentUser?.role.hasSystemAdminPrivileges ?? false;
    return HomeView(
      state: HomeViewState(
        identity: _sessionIdentity,
        hasServer: _gateway.hasServer,
        isLoading: _isLoading,
        isLoadingTaxonomy: _isLoadingTaxonomy,
        rooms: _rooms,
        featuredRooms: _featuredRooms,
        joinedRooms: _joinedRooms,
        categories: _roomCategories,
        totalRooms: _roomsTotal,
        page: _roomPage,
        pageCount: _roomPageCount,
        selectedCategoryId: _selectedRoomCategoryId,
        selectedLabelCount: _selectedRoomLabelIds.length,
        favoriteRoomIdsInFlight: _favoriteRoomIdsInFlight,
        currentUser: _currentUser,
        isAdmin: isAdmin,
      ),
      callbacks: HomeViewCallbacks(
        openServerSettings: _showServerSettingsDialog,
        openLanguageSelector: () => showLanguageSelectorDialog(context),
        openLogin: _showLoginDialog,
        openJoinRoom: _showJoinRoomDialog,
        openCreateRoom: _showCreateRoomDialog,
        openAccountCenter: _showAccountCenter,
        openAdminSettings: _showAdminSettingsPage,
        logout: _handleLogout,
        refresh: () => _loadRooms(silent: true),
        search: _applyRoomSearch,
        selectCategory: (categoryId) {
          setState(() {
            _selectedRoomCategoryId = categoryId;
            _selectedRoomLabelIds.removeWhere(
              (id) => !_availableRoomLabels.any((label) => label.id == id),
            );
            _roomPage = 1;
          });
          _loadRooms(silent: false);
        },
        openLabelFilter: _showRoomLabelFilter,
        clearFilters: _clearRoomTaxonomyFilters,
        openRoom: _handleJoinRoom,
        toggleFavorite: _toggleRoomFavorite,
        deleteRoom: _handleDeleteRoom,
        goToPage: _goRoomPage,
      ),
      searchController: _roomSearchController,
    );
  }
}
