import 'dart:async';
import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/models/synctv_models.dart';
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

enum _RoomFeed { public, mine, hot, favorites }

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
  List<RoomCategoryInfo> _roomCategories = const [];
  List<RoomLabelInfo> _roomLabels = const [];
  int _roomsTotal = 0;
  int _roomPage = 1;
  static const int _roomPageSize = 24;
  _RoomFeed _roomFeed = _RoomFeed.public;
  bool _isLoggedIn = false;
  SyncTvUser? _currentUser;
  StreamSubscription? _authErrorSubscription;
  final Set<String> _joiningRoomIds = <String>{};
  Set<String> _favoriteRoomIds = <String>{};
  final Set<String> _selectedRoomLabelIds = <String>{};
  final TextEditingController _roomSearchController = TextEditingController();
  String _selectedRoomCategoryId = '';
  bool _modalOpen = false;
  bool _startRoomHandled = false;

  @override
  void initState() {
    super.initState();
    _authErrorSubscription = SyncTvService.onAuthError.listen((_) {
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _currentUser = null;
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _showLoginDialog();
        });
      }
    });
    _checkLoginAndLoadData();
  }

  @override
  void dispose() {
    _authErrorSubscription?.cancel();
    _roomSearchController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final user = await SyncTvService.getMe();
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      // Ignore
    }
  }

  Future<void> _checkLoginAndLoadData() async {
    final hasSession = SyncTvService.hasRecoverableSession;
    if (!hasSession) {
      if (mounted) {
        setState(() {
          _isLoggedIn = false;
          _isLoading = false;
        });
        _loadRooms(silent: false);
      }
    } else {
      setState(() {
        _isLoggedIn = true;
      });
      _loadRooms(silent: false);
      await _fetchUserInfo();
      _openStartRoomIfRequested();
    }
  }

  Future<void> _loadRoomTaxonomy({bool refresh = false}) async {
    if (SyncTvService.activeServer == null || _isLoadingTaxonomy) return;
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
      if (!mounted) return;
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
      if (!mounted) return;
      setState(() => _isLoadingTaxonomy = false);
    }
  }

  void _openStartRoomIfRequested() {
    final roomId = _startRoomId.trim();
    if (_startRoomHandled || roomId.isEmpty) return;
    _startRoomHandled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final room = await SyncTvService.getRoomInfo(roomId);
        if (mounted) await _handleJoinRoom(room);
      } catch (e) {
        if (mounted) {
          MessageUtils.showError(
            context,
            context.l10n.openRoomFailed(e.toString()),
          );
        }
      }
    });
  }

  Future<void> _loadRooms({bool silent = false}) async {
    if (SyncTvService.activeServer == null) {
      if (mounted) {
        setState(() {
          _rooms = const [];
          _roomsTotal = 0;
          _isLoading = false;
        });
      }
      return;
    }
    if (!_isLoggedIn &&
        (_roomFeed == _RoomFeed.mine || _roomFeed == _RoomFeed.favorites)) {
      setState(() {
        _rooms = const [];
        _roomsTotal = 0;
        _isLoading = false;
      });
      return;
    }

    if (!silent) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      if (_roomFeed == _RoomFeed.public && _roomCategories.isEmpty) {
        unawaited(_loadRoomTaxonomy(refresh: true));
      }
      final search = _roomSearchController.text.trim();
      final List<SyncTvRoom> rooms;
      final int total;
      switch (_roomFeed) {
        case _RoomFeed.public:
          final page = await SyncTvService.getRoomsPage(
            page: _roomPage,
            pageSize: _roomPageSize,
            search: search.isEmpty ? null : search,
            categoryId: _selectedRoomCategoryId,
            labelIds: _selectedRoomLabelIds.toList(growable: false),
            sortBy:
                client_enum.RoomListSortBy.ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
            sortDirection: client_enum.SortDirection.SORT_DIRECTION_DESC,
          );
          rooms = page.rooms;
          total = page.total;
          break;
        case _RoomFeed.mine:
          final page = await SyncTvService.getMyRoomsPage(
            page: _roomPage,
            pageSize: _roomPageSize,
            search: search.isEmpty ? null : search,
            relation: client_enum.MyRoomRelation.MY_ROOM_RELATION_ALL,
            sortBy: client_enum
                .MyRoomListSortBy
                .MY_ROOM_LIST_SORT_BY_LAST_ACTIVITY_AT,
            sortDirection: client_enum.SortDirection.SORT_DIRECTION_DESC,
          );
          rooms = page.rooms;
          total = page.total;
          break;
        case _RoomFeed.hot:
          rooms = await SyncTvService.getHotRooms(limit: _roomPageSize);
          total = rooms.length;
          break;
        case _RoomFeed.favorites:
          final page = await SyncTvService.getFavoriteRoomsPage(
            page: _roomPage,
            pageSize: _roomPageSize,
            search: search.isEmpty ? null : search,
          );
          rooms = page.rooms;
          total = page.total;
          break;
      }

      if (mounted) {
        setState(() {
          _rooms = rooms;
          _roomsTotal = total;
          _favoriteRoomIds = rooms
              .where((room) => room.isFavorite)
              .map((room) => room.roomId)
              .toSet();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
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

  void _setRoomFeed(_RoomFeed feed) {
    if (!_isLoggedIn &&
        (feed == _RoomFeed.mine || feed == _RoomFeed.favorites)) {
      _showLoginDialog();
      return;
    }
    if (_roomFeed == feed) return;
    setState(() {
      _roomFeed = feed;
      _roomPage = 1;
    });
    if (feed != _RoomFeed.public) {
      _clearRoomTaxonomyFilters(load: false);
    }
    _loadRooms(silent: false);
  }

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

  Future<bool> _showLoginDialog({String? guestRoomId}) async {
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
        builder: (context) => AuthPanel(initialGuestRoomId: guestRoomId),
      );
    } finally {
      _modalOpen = false;
    }
    if (result == true) {
      if (mounted) {
        setState(() {
          _isLoggedIn = true;
        });
        _loadRooms(silent: false);
        _fetchUserInfo();
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
            if (mounted) {
              _handleJoinRoom(room);
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
    try {
      final id = await parseInviteOrShowError(context: context, value: value);
      if (id == null || id.isEmpty) return;
      final check = await SyncTvService.checkRoom(id);
      if (!check.exists) {
        if (mounted) {
          MessageUtils.showWarning(context, context.l10n.roomNotFound);
        }
        return;
      }
      if (!check.isAvailable) {
        if (mounted) {
          MessageUtils.showWarning(context, context.l10n.roomUnavailable);
        }
        return;
      }
      if (!_isLoggedIn) {
        final authenticated = await _showLoginDialog(guestRoomId: id);
        if (!authenticated || !mounted) return;
      }
      final room = await SyncTvService.getRoomInfo(id);
      if (!mounted) return;
      Navigator.pop(context);
      _handleJoinRoom(room);
    } catch (e) {
      if (mounted) {
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
      if (accountClosed == true) {
        setState(() {
          _isLoggedIn = false;
          _currentUser = null;
          _rooms = [];
          _roomsTotal = 0;
        });
      } else {
        _fetchUserInfo();
      }
    });
  }

  void _showServerSettingsDialog() {
    if (_modalOpen) return;
    _modalOpen = true;
    () async {
      try {
        final changed = await showServerSettingsDialog(context: context);
        if (!mounted || changed != true) return;
        final hasSession = SyncTvService.hasRecoverableSession;
        setState(() {
          _isLoggedIn = hasSession;
          if (!hasSession) _currentUser = null;
          _roomPage = 1;
        });
        _loadRooms(silent: false);
        if (hasSession) _fetchUserInfo();
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
          _isLoggedIn = false;
          _currentUser = null;
          _rooms = [];
          _roomsTotal = 0;
          _roomFeed = _RoomFeed.public;
          _roomPage = 1;
        });
        MessageUtils.showSuccess(context, context.l10n.loggedOut);
        _loadRooms(silent: false);
      }
    }
  }

  Future<void> _handleJoinRoom(SyncTvRoom room) async {
    if (_joiningRoomIds.contains(room.roomId)) return;
    _joiningRoomIds.add(room.roomId);
    String password = '';

    try {
      if (!_isLoggedIn) {
        final authenticated = await _showLoginDialog(guestRoomId: room.roomId);
        if (!authenticated || !mounted) return;
      }

      if (room.needPassword) {
        final result = await showRoomPasswordDialog(
          context: context,
          roomName: room.roomName,
        );

        if (result == null) return;
        if (result.isEmpty) {
          if (mounted) {
            MessageUtils.showWarning(context, context.l10n.passwordRequired);
          }
          return;
        }
        password = result;
      }

      await SyncTvService.joinRoom(room.roomId, password);
      if (mounted) {
        _navigateToRoom(room);
      }
    } catch (e) {
      if (mounted) {
        MessageUtils.showError(
          context,
          context.l10n.joinRoomFailed(e.toString()),
        );
      }
    } finally {
      _joiningRoomIds.remove(room.roomId);
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
      await _loadRooms(silent: true);
    }
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
      try {
        await SyncTvService.deleteRoom(room.roomId);
        if (!mounted) return;
        MessageUtils.showSuccess(context, context.l10n.roomDeleted);
        _loadRooms(silent: true);
      } catch (e) {
        if (mounted) {
          MessageUtils.showError(
            context,
            context.l10n.deleteFailed(e.toString()),
          );
        }
      }
    }
  }

  Future<void> _toggleRoomFavorite(SyncTvRoom room) async {
    if (!_isLoggedIn) {
      await _showLoginDialog();
      return;
    }
    final wasFavorite =
        room.isFavorite || _favoriteRoomIds.contains(room.roomId);
    setState(() {
      final next = Set<String>.from(_favoriteRoomIds);
      if (wasFavorite) {
        next.remove(room.roomId);
      } else {
        next.add(room.roomId);
      }
      _favoriteRoomIds = next;
    });
    try {
      final SyncTvRoom updatedRoom;
      if (wasFavorite) {
        updatedRoom = await SyncTvService.unfavoriteRoom(room.roomId);
      } else {
        updatedRoom = await SyncTvService.favoriteRoom(room.roomId);
      }
      if (!mounted) return;
      setState(() {
        _rooms = _rooms
            .map(
              (item) => item.roomId == updatedRoom.roomId ? updatedRoom : item,
            )
            .where(
              (item) =>
                  _roomFeed != _RoomFeed.favorites ||
                  _favoriteRoomIds.contains(item.roomId),
            )
            .toList(growable: false);
      });
      if (mounted && _roomFeed == _RoomFeed.favorites) {
        await _loadRooms(silent: true);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        final next = Set<String>.from(_favoriteRoomIds);
        if (wasFavorite) {
          next.add(room.roomId);
        } else {
          next.remove(room.roomId);
        }
        _favoriteRoomIds = next;
      });
      MessageUtils.showError(
        context,
        context.l10n.updateFavoriteFailed(e.toString()),
      );
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
                                AppIconBadge(
                                  icon: Icons.live_tv_rounded,
                                  color: theme.colorScheme.primary,
                                  size: 36,
                                  iconSize: 22,
                                  backgroundAlpha: 0.12,
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
                          if (!_isLoggedIn && compact)
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
                          if (!_isLoggedIn) ...[
                            AppIconButton(
                              tooltip: l10n.language,
                              onPressed: () =>
                                  showLanguageSelectorDialog(context),
                              icon: Icons.language_rounded,
                              style: AppIconButtonStyle.tonal,
                            ),
                            SizedBox(width: compact ? 8 : 12),
                          ],
                          if (_isLoggedIn) ...[
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
          : Padding(
              padding: AppMetrics.pagePadding(context),
              child: Column(
                children: [
                  _buildRoomControls(theme),
                  const SizedBox(height: 14),
                  Expanded(child: _buildRoomGrid()),
                ],
              ),
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
    final l10n = context.l10n;
    final supportsPaging = _roomFeed != _RoomFeed.hot;
    final summary = switch (_roomFeed) {
      _RoomFeed.hot => l10n.popularRoomsSummary(_rooms.length),
      _RoomFeed.favorites => l10n.favoriteRoomsPageSummary(
        _roomsTotal,
        _roomPage,
        _roomPageCount,
      ),
      _ => l10n.roomsPageSummary(_roomsTotal, _roomPage, _roomPageCount),
    };
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
                  _buildRoomControlActions(theme, supportsPaging, summary),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _buildRoomFilterControls()),
                  const SizedBox(width: 12),
                  _buildRoomControlActions(theme, supportsPaging, summary),
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
            AppSegmentedControl<_RoomFeed>(
              segments: [
                ButtonSegment(
                  value: _RoomFeed.public,
                  icon: const Icon(Icons.public_rounded),
                  label: Text(l10n.roomFeedPublic),
                ),
                ButtonSegment(
                  value: _RoomFeed.mine,
                  icon: const Icon(Icons.video_library_rounded),
                  label: Text(l10n.roomFeedMine),
                ),
                ButtonSegment(
                  value: _RoomFeed.hot,
                  icon: const Icon(Icons.local_fire_department_rounded),
                  label: Text(l10n.roomFeedPopular),
                ),
                ButtonSegment(
                  value: _RoomFeed.favorites,
                  icon: const Icon(Icons.bookmark_rounded),
                  label: Text(l10n.roomFeedFavorites),
                ),
              ],
              value: _roomFeed,
              onChanged: _setRoomFeed,
            ),
            AppSearchField(
              controller: _roomSearchController,
              width: compact ? constraints.maxWidth : 320,
              hintText: _roomFeed == _RoomFeed.hot
                  ? l10n.popularRoomsSearchDisabled
                  : l10n.searchRooms,
              enabled: _roomFeed != _RoomFeed.hot,
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
              hintText: _roomFeed == _RoomFeed.public
                  ? l10n.allCategories
                  : l10n.publicRoomsOnly,
              prefixIcon: Icons.category_outlined,
              clearable: true,
              enabled:
                  _roomFeed == _RoomFeed.public &&
                  !_isLoadingTaxonomy &&
                  _roomCategories.isNotEmpty,
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
              onPressed: _roomFeed != _RoomFeed.public || _isLoadingTaxonomy
                  ? null
                  : _showRoomLabelFilter,
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

  Widget _buildRoomControlActions(
    ThemeData theme,
    bool supportsPaging,
    String summary,
  ) {
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
          child: supportsPaging
              ? AppPaginationBar(
                  padding: EdgeInsets.zero,
                  label: summary,
                  labelStyle: summaryStyle,
                  onPrevious: _roomPage <= 1
                      ? null
                      : () => _goRoomPage(_roomPage - 1),
                  onNext: _roomPage >= _roomPageCount
                      ? null
                      : () => _goRoomPage(_roomPage + 1),
                )
              : Text(
                  summary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: summaryStyle,
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
        : (_roomFeed == _RoomFeed.favorites
              ? Icons.bookmark_border_rounded
              : Icons.meeting_room_outlined);
    final emptyTitle = !hasServer
        ? l10n.addServerToStart
        : (_roomFeed == _RoomFeed.favorites
              ? l10n.noFavoriteRooms
              : l10n.noRooms);
    final emptyDescription = !hasServer
        ? l10n.addServerDescription
        : switch (_roomFeed) {
            _RoomFeed.mine => l10n.myRoomsEmptyDescription,
            _RoomFeed.favorites => l10n.favoriteRoomsEmptyDescription,
            _ => l10n.filteredRoomsEmptyDescription,
          };
    return AppInkSurface(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.7)),
      child: _rooms.isEmpty
          ? Center(
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
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.58,
                      ),
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
            )
          : AppRefreshIndicator(
              onRefresh: () async => await _loadRooms(silent: true),
              child: AppGridView.builder(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 380,
                  childAspectRatio: 1.35,
                  mainAxisExtent: 390,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _rooms.length,
                itemBuilder: (context, index) =>
                    _buildRoomCard(_rooms[index], index),
              ),
            ),
    );
  }

  Widget _buildRoomCard(SyncTvRoom room, int index) {
    return CinemaRoomCard(
      roomId: room.roomId,
      roomName: room.roomName,
      description: room.description,
      coverUrl: room.coverUrl,
      viewerCount: room.viewerCount,
      connectionCount: room.connectionCount,
      memberCount: room.memberCount,
      creatorName: room.creator,
      creatorAvatarUrl: room.creatorAvatarUrl,
      availability: room.availability,
      isBanned: room.isBanned,
      needPassword: room.needPassword,
      hidden: room.hidden,
      createdAt: room.createdAt,
      categoryName: room.category?.name ?? '',
      labels: room.labels,
      onTap: () => _handleJoinRoom(room),
      onFavoritePressed: () => _toggleRoomFavorite(room),
      isFavorite: room.isFavorite || _favoriteRoomIds.contains(room.roomId),
      onLongPress: _currentUser != null && _currentUser!.id == room.creatorId
          ? () => _handleDeleteRoom(room)
          : null,
    );
  }
}
