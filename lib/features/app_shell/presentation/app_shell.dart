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
import 'package:synctv_app/features/home/presentation/room_label_filter_dialog.dart';
import 'package:synctv_app/features/home/presentation/room_delete_confirmation_dialog.dart';
import 'package:synctv_app/features/room/presentation/create_room_dialog.dart';
import 'package:synctv_app/features/room/presentation/join_room_dialog.dart';
import 'package:synctv_app/core/localization/presentation/language_selector_dialog.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room_invite/presentation/room_invite_flow.dart';
import 'package:synctv_app/features/room_invite/domain/room_invite.dart';
import 'package:synctv_app/features/server_settings/presentation/server_settings_dialog.dart';
import 'package:synctv_app/features/providers/presentation/binding/platform_binding_dialog.dart';
import 'package:synctv_app/features/room/domain/realtime_event_log.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

import 'package:synctv_app/features/auth/presentation/auth_panel.dart';
import 'package:synctv_app/features/app_shell/presentation/app_shell_dependencies.dart';
import 'package:synctv_app/features/home/presentation/home_view.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.dependencies, this.initialInvite});

  final AppShellDependencies dependencies;
  final String? initialInvite;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const String _startRoomId = String.fromEnvironment(
    'SYNCTV_START_ROOM_ID',
    defaultValue: '',
  );

  bool _isLoading = true;
  String? _roomLoadError;
  bool _isLoadingTaxonomy = false;
  bool _taxonomyLoaded = false;
  String? _taxonomyError;
  final _taxonomyOperations = LatestAsyncOperationCoordinator();
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
  final Map<String, Object> _deletingRoomOperations = <String, Object>{};
  final Set<String> _favoriteRoomIdsInFlight = <String>{};
  final _favoriteOverrides = <String, ({bool value, int revision})>{};
  int _favoriteRevision = 0;
  final Set<String> _selectedRoomLabelIds = <String>{};
  final TextEditingController _roomSearchController = TextEditingController();
  String _selectedRoomCategoryId = '';
  int _roomLoadGeneration = 0;
  final AsyncStateEpoch _homeStateEpoch = AsyncStateEpoch();
  bool _modalOpen = false;
  Object? _labelFilterOperation;
  bool _loginOpen = false;
  bool _handlingAuthError = false;
  bool _logoutInProgress = false;
  bool _startRoomHandled = false;

  HomeGateway get _gateway => widget.dependencies.homeGateway;

  @override
  void initState() {
    super.initState();
    _authErrorSubscription = _gateway.authErrors.listen((_) {
      unawaited(_handleAuthError());
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
    _taxonomyOperations.invalidate();
    _authErrorSubscription?.cancel();
    _roomSearchController.dispose();
    super.dispose();
  }

  SyncTvSessionIdentity get _sessionIdentity => _gateway.sessionIdentity;

  bool get _isGuestSession => _sessionIdentity is GuestSessionIdentity;
  bool get _isAccountSession => _sessionIdentity is AccountSessionIdentity;

  Future<void> _handleAuthError() async {
    if (!mounted || _handlingAuthError) return;
    _handlingAuthError = true;
    try {
      setState(_clearRoomSessionState);
      final epoch = _homeStateEpoch.capture();
      unawaited(_loadRooms());
      if (_loginOpen) return;
      final shellRoute = ModalRoute.of(context);
      Navigator.of(context)
          .popUntil((route) => route == shellRoute || route.isFirst);
      // Let dismissed modal owners release their guards before opening login.
      await Future<void>.value();
      if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
      await _showLoginDialog();
    } finally {
      _handlingAuthError = false;
    }
  }

  void _clearRoomSessionState({bool clearTaxonomy = false}) {
    if (_labelFilterOperation != null) {
      _labelFilterOperation = null;
      _modalOpen = false;
    }
    _homeStateEpoch.advance();
    _roomLoadGeneration += 1;
    _currentUser = null;
    _rooms = const [];
    _featuredRooms = const [];
    _joinedRooms = const [];
    _roomsTotal = 0;
    _roomLoadError = null;
    _roomPage = 1;
    _isLoadingTaxonomy = false;
    _taxonomyLoaded = false;
    _taxonomyError = null;
    _taxonomyOperations.invalidate();
    _joiningRoomOperations.clear();
    _deletingRoomOperations.clear();
    _favoriteRoomIdsInFlight.clear();
    _favoriteOverrides.clear();
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
    unawaited(_loadRooms());
    if (_isAccountSession) {
      unawaited(_fetchUserInfo());
    }
    _openStartRoomIfRequested();
  }

  Future<void> _loadRoomTaxonomy({bool refresh = false}) {
    if (!_gateway.hasServer) return Future.value();
    return _taxonomyOperations.run(
      'taxonomy',
      (_) => _fetchRoomTaxonomy(refresh: refresh),
    );
  }

  Future<void> _fetchRoomTaxonomy({required bool refresh}) async {
    final epoch = _homeStateEpoch.capture();
    setState(() {
      _isLoadingTaxonomy = true;
      _taxonomyError = null;
    });
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
      final previousCategoryId = _selectedRoomCategoryId;
      final previousLabelCount = _selectedRoomLabelIds.length;
      setState(() {
        _roomCategories = categories;
        _roomLabels = labels;
        if (_selectedRoomCategoryId.isNotEmpty &&
            !categories.any(
              (category) => category.id == _selectedRoomCategoryId,
            )) {
          _selectedRoomCategoryId = '';
        }
        final availableIds = _availableRoomLabels
            .map((label) => label.id)
            .toSet();
        _selectedRoomLabelIds.removeWhere((id) => !availableIds.contains(id));
        _isLoadingTaxonomy = false;
        _taxonomyLoaded = true;
      });
      if (previousCategoryId != _selectedRoomCategoryId ||
          previousLabelCount != _selectedRoomLabelIds.length) {
        setState(() => _roomPage = 1);
        await _loadRooms();
      }
    } catch (e) {
      if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
      setState(() {
        _isLoadingTaxonomy = false;
        _taxonomyError = e.toString();
      });
    }
  }

  void _openStartRoomIfRequested() {
    final value = widget.initialInvite ?? _startRoomId.trim();
    if (_startRoomHandled || value.isEmpty) return;
    _startRoomHandled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final epoch = _homeStateEpoch.capture();
      try {
        final roomId = RoomInviteService.parse(value).roomId;
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

  Future<void> _loadRooms() async {
    final epoch = _homeStateEpoch.capture();
    final loadGeneration = ++_roomLoadGeneration;
    final favoriteRevision = _favoriteRevision;
    final pendingFavorites = Set<String>.of(_favoriteRoomIdsInFlight);
    final requestedPage = _roomPage;
    if (!_gateway.hasServer) {
      if (mounted) {
        setState(() {
          _rooms = const [];
          _featuredRooms = const [];
          _joinedRooms = const [];
          _roomsTotal = 0;
          _isLoading = false;
          _roomLoadError = null;
        });
      }
      return;
    }
    setState(() => _isLoading = true);
    try {
      if (!_taxonomyLoaded) {
        unawaited(_loadRoomTaxonomy(refresh: true));
      }
      final search = _roomSearchController.text.trim();
      final showHomeSections =
          requestedPage == 1 &&
          search.isEmpty &&
          _selectedRoomCategoryId.isEmpty &&
          _selectedRoomLabelIds.isEmpty;
      final discoveryFuture = _gateway.discoverRooms(
        page: requestedPage,
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
        final lastPage = discovery.total <= 0
            ? 1
            : ((discovery.total - 1) ~/ _roomPageSize) + 1;
        if (requestedPage > lastPage) {
          setState(() {
            _roomPage = lastPage;
            _roomsTotal = discovery.total;
          });
          await _loadRooms();
          return;
        }
        setState(() {
          // Reads overlapping a mutation cannot replace its latest local result.
          _favoriteOverrides.removeWhere(
            (id, override) =>
                override.revision <= favoriteRevision &&
                !pendingFavorites.contains(id) &&
                !_favoriteRoomIdsInFlight.contains(id),
          );
          List<SyncTvRoom> reconcile(List<SyncTvRoom> rooms) => rooms
              .map((room) {
                final override = _favoriteOverrides[room.roomId];
                return override == null
                    ? room
                    : room.copyWith(isFavorite: override.value);
              })
              .toList(growable: false);
          _rooms = reconcile(discovery.rooms);
          _featuredRooms = reconcile(discovery.featuredRooms);
          _joinedRooms = reconcile(joined.rooms);
          _roomsTotal = discovery.total;
          _roomLoadError = null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted &&
          _homeStateEpoch.isCurrent(epoch) &&
          loadGeneration == _roomLoadGeneration) {
        setState(() {
          _isLoading = false;
          _roomLoadError = e.toString();
        });
      }
    }
  }

  int get _roomPageCount =>
      _roomsTotal <= 0 ? 1 : ((_roomsTotal - 1) ~/ _roomPageSize) + 1;

  void _applyRoomSearch(String value) {
    setState(() => _roomPage = 1);
    _loadRooms();
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
    if (load) _loadRooms();
  }

  Future<void> _showRoomLabelFilter() async {
    if (_modalOpen) return;
    final operation = Object();
    _labelFilterOperation = operation;
    final epoch = _homeStateEpoch.capture();
    _modalOpen = true;
    try {
      if (_isLoadingTaxonomy || _roomLabels.isEmpty || _taxonomyError != null) {
        await _loadRoomTaxonomy(refresh: true);
      }
      if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
      if (_taxonomyError case final error?) {
        AppNotifications.showError(
          context,
          context.l10n.loadCategoriesLabelsFailed(error),
        );
        return;
      }
      final categoryId = _selectedRoomCategoryId;
      final selectedIds = await showRoomLabelFilterDialog(
        context: context,
        labels: _availableRoomLabels,
        categories: _roomCategories,
        selectedIds: _selectedRoomLabelIds,
        hasCategory: categoryId.isNotEmpty,
      );
      if (!mounted ||
          !_homeStateEpoch.isCurrent(epoch) ||
          categoryId != _selectedRoomCategoryId ||
          selectedIds == null) {
        return;
      }
      final availableIds = _availableRoomLabels
          .map((label) => label.id)
          .toSet();
      setState(() {
        _selectedRoomLabelIds
          ..clear()
          ..addAll(selectedIds.intersection(availableIds));
        _roomPage = 1;
      });
      await _loadRooms();
    } finally {
      if (identical(_labelFilterOperation, operation)) {
        _labelFilterOperation = null;
        _modalOpen = false;
      }
    }
  }

  void _goRoomPage(int page) {
    final next = page.clamp(1, _roomPageCount);
    if (next == _roomPage) return;
    setState(() => _roomPage = next);
    _loadRooms();
  }

  Future<bool> _showLoginDialog({
    String? guestRoomId,
    bool startWithGuest = false,
  }) async {
    if (_modalOpen) return false;
    _modalOpen = true;
    _loginOpen = true;
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
      _loginOpen = false;
      _modalOpen = false;
    }
    if (result == true) {
      if (mounted) {
        setState(() {
          _clearRoomSessionState();
          _isLoading = true;
        });
        unawaited(_loadRooms());
        if (_isAccountSession) unawaited(_fetchUserInfo());
      }
      return true;
    }
    if (mounted) setState(() => _isLoading = false);
    return false;
  }

  void _showCreateRoomDialog() {
    if (_modalOpen) return;
    final epoch = _homeStateEpoch.capture();
    _modalOpen = true;
    () async {
      try {
        await showCreateRoomDialog(
          context: context,
          width: 300,
          onCreated: (room) async {
            if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
            if (room.isActive) {
              await _navigateToRoom(room);
            } else {
              await _loadRooms();
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

  Future<void> _joinRoomById(BuildContext dialogContext, String value) async {
    if (value.trim().isEmpty) {
      AppNotifications.showWarning(context, context.l10n.roomIdRequired);
      return;
    }
    final epoch = _homeStateEpoch.capture();
    bool isCurrent() =>
        mounted &&
        _homeStateEpoch.isCurrent(epoch) &&
        dialogContext.mounted &&
        ModalRoute.of(dialogContext)?.isCurrent == true;
    try {
      final id = await parseInviteOrShowError(
        context: dialogContext,
        value: value,
      );
      if (!isCurrent() || id == null || id.isEmpty) return;
      final room = await _gateway.getRoom(id);
      if (!isCurrent()) return;
      if (!dialogContext.mounted) return;
      Navigator.pop(dialogContext);
      await _handleJoinRoom(room);
    } catch (e) {
      if (mounted && isCurrent()) {
        AppNotifications.showError(
          context,
          context.l10n.findRoomFailed(e.toString()),
        );
      }
    }
  }

  void _showAdminSettingsPage() {
    final epoch = _homeStateEpoch.capture();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminSettingsPage()),
    ).then((_) {
      if (mounted && _homeStateEpoch.isCurrent(epoch)) _loadRooms();
    });
  }

  void _showAccountCenter() {
    final user = _currentUser;
    if (user == null) return;
    final epoch = _homeStateEpoch.capture();
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
      if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
      if (accountClosed == true) {
        setState(() {
          _clearRoomSessionState();
        });
        unawaited(_loadRooms());
      } else {
        unawaited(_fetchUserInfo());
        unawaited(_loadRooms());
      }
    });
  }

  Future<void> _openAccountRoom(SyncTvRoom room) async {
    final epoch = _homeStateEpoch.capture();
    final latest = await _gateway.getRoom(room.roomId);
    if (mounted && _homeStateEpoch.isCurrent(epoch)) {
      await _navigateToRoom(latest);
    }
  }

  Future<void> _createAccountRoom() {
    final epoch = _homeStateEpoch.capture();
    return showCreateRoomDialog(
      context: context,
      onCreated: (room) async {
        if (room.isActive && mounted && _homeStateEpoch.isCurrent(epoch)) {
          await _navigateToRoom(room);
        }
      },
    );
  }

  Future<void> _manageAccountRoom(SyncTvRoom room) async {
    final user = _currentUser;
    if (user == null) return;
    final epoch = _homeStateEpoch.capture();
    final settings = await widget.dependencies.roomManagementGateway
        .getRoomSettings(room.roomId);
    if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
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
    unawaited(_loadRooms());
    if (_isAccountSession) unawaited(_fetchUserInfo());
  }

  Future<void> _handleLogout() async {
    if (_logoutInProgress) return;
    _logoutInProgress = true;
    final epoch = _homeStateEpoch.capture();
    var confirmationClosed = false;
    void closeConfirmation(bool result) {
      if (!mounted || confirmationClosed || !_homeStateEpoch.isCurrent(epoch)) {
        return;
      }
      confirmationClosed = true;
      Navigator.pop(context, result);
    }

    try {
      final confirm = await AppDialogs.showStyledDialog<bool>(
        context: context,
        title: context.l10n.logout,
        icon: const Icon(Icons.logout, color: Colors.red),
        content: Text(context.l10n.logoutConfirmMessage),
        actions: [
          AppActionButton(
            label: context.l10n.cancel,
            style: AppActionButtonStyle.outlined,
            onPressed: () => closeConfirmation(false),
          ),
          const SizedBox(width: 8),
          AppDialogs.createConfirmButton(
            context,
            () => closeConfirmation(true),
            text: context.l10n.logoutAction,
          ),
        ],
      );

      confirmationClosed = true;
      if (confirm != true || !mounted || !_homeStateEpoch.isCurrent(epoch)) {
        return;
      }
      await _gateway.logout();
      if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
      _clearLoggedOutPages();
      AppNotifications.showSuccess(context, context.l10n.loggedOut);
    } catch (error) {
      if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
      if (_sessionIdentity is AnonymousSessionIdentity) {
        _clearLoggedOutPages();
      }
      AppNotifications.showError(
        context,
        context.l10n.actionFailed(context.l10n.logout, error.toString()),
      );
    } finally {
      _logoutInProgress = false;
    }
  }

  void _clearLoggedOutPages() {
    setState(_clearRoomSessionState);
    final shellRoute = ModalRoute.of(context);
    Navigator.of(context)
        .popUntil((route) => route == shellRoute || route.isFirst);
    unawaited(_loadRooms());
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
          await _loadRooms();
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
    final epoch = _homeStateEpoch.capture();
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
    if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
    if (deleted == true) {
      setState(() {
        _rooms = _rooms.where((item) => item.roomId != room.roomId).toList();
        if (_roomsTotal > 0) _roomsTotal -= 1;
      });
    }
    await _loadRooms();
  }

  Future<void> _handleDeleteRoom(SyncTvRoom room) async {
    if (!mounted) return;
    final operation = Object();
    if (_deletingRoomOperations.putIfAbsent(room.roomId, () => operation) !=
        operation) {
      return;
    }
    final epoch = _homeStateEpoch.capture();
    try {
      final confirm = await showRoomDeleteConfirmationDialog(
        context: context,
        roomName: room.roomName,
      );
      if (confirm != true || !mounted || !_homeStateEpoch.isCurrent(epoch)) {
        return;
      }
      await _gateway.deleteRoom(room.roomId);
      if (!mounted || !_homeStateEpoch.isCurrent(epoch)) return;
      AppNotifications.showSuccess(context, context.l10n.roomDeleted);
      await _loadRooms();
    } catch (e) {
      if (mounted && _homeStateEpoch.isCurrent(epoch)) {
        AppNotifications.showError(
          context,
          context.l10n.deleteFailed(e.toString()),
        );
      }
    } finally {
      if (identical(_deletingRoomOperations[room.roomId], operation)) {
        _deletingRoomOperations.remove(room.roomId);
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
      _favoriteOverrides[room.roomId] = (
        value: isFavorite,
        revision: ++_favoriteRevision,
      );
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
        loadError: _roomLoadError,
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
        refresh: () async {
          await Future.wait([_loadRoomTaxonomy(refresh: true), _loadRooms()]);
        },
        search: _applyRoomSearch,
        selectCategory: (categoryId) {
          setState(() {
            _selectedRoomCategoryId = categoryId;
            _selectedRoomLabelIds.removeWhere(
              (id) => !_availableRoomLabels.any((label) => label.id == id),
            );
            _roomPage = 1;
          });
          _loadRooms();
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
