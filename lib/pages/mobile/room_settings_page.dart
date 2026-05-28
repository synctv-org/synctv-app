import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/models/room_management_models.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/widgets/ios_style_switch.dart';

const Map<String, String> _mediaSourceLabels = {
  '': '全部来源',
  'direct_url': '直链',
  'bilibili': 'Bilibili',
  'alist': 'Alist',
  'emby': 'Emby',
  'rtmp': 'RTMP',
};

const Set<String> _mediaSourcesWithProviderInstances = {
  'alist',
  'emby',
  'bilibili',
};

String _providerInstanceLabel(String instanceName) {
  return instanceName.isEmpty ? '本地实例' : instanceName;
}

class _RoomSettingsSection {
  final String label;
  final IconData icon;
  final Widget Function(ThemeData theme, bool isDark) builder;

  const _RoomSettingsSection({
    required this.label,
    required this.icon,
    required this.builder,
  });
}

class RoomSettingsPage extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String creatorId;
  final String currentUserId;
  final WRoomSettings currentSettings;

  const RoomSettingsPage({
    super.key,
    required this.roomId,
    required this.roomName,
    this.creatorId = '',
    this.currentUserId = '',
    required this.currentSettings,
  });

  @override
  State<RoomSettingsPage> createState() => _RoomSettingsPageState();
}

class _RoomSettingsPageState extends State<RoomSettingsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _passwordController;
  late final TextEditingController _maxMembersController;
  late final TextEditingController _streamSearchController;
  late final TextEditingController _memberSearchController;
  late final TextEditingController _reviewUserController;
  late final TextEditingController _mediaSearchController;
  late WRoomSettings _settings;

  final List<RoomStreamEntryInfo> _streams = [];
  final List<RoomJoinReviewInfo> _reviews = [];
  final List<AdminRoomMember> _members = [];
  final List<RoomChatMessageInfo> _chatMessages = [];
  final List<IceServerInfo> _iceServers = [];
  final List<String> _mediaPlaylistStack = [];
  final List<String> _mediaTargetStack = [];
  StreamSubscription<RoomResourceWatchEvent<WRoomSettings>>?
      _settingsWatchSubscription;
  StreamSubscription<RoomResourceWatchEvent<List<AdminRoomMember>>>?
      _membersWatchSubscription;
  StreamSubscription<RoomResourceWatchEvent<RoomMediaLibraryPage>>?
      _mediaWatchSubscription;
  RoomMediaLibraryPage? _mediaPage;
  String _chatCursor = '';
  String _settingsWatchVersion = '';
  String _membersWatchVersion = '';
  String _mediaWatchVersion = '';
  client_enum.MediaListSortBy _mediaSortBy =
      client_enum.MediaListSortBy.MEDIA_LIST_SORT_BY_POSITION;
  client_enum.SortDirection _mediaSortDirection =
      client_enum.SortDirection.SORT_DIRECTION_ASC;
  client_enum.ResourceAvailabilityFilter _mediaAvailability =
      client_enum.ResourceAvailabilityFilter.RESOURCE_AVAILABILITY_FILTER_ALL;
  String _mediaSourceProvider = '';
  String _mediaProviderInstanceName = '';
  List<String> _mediaProviderInstances = const [''];
  client_enum.SortDirection _streamSortDirection =
      client_enum.SortDirection.SORT_DIRECTION_ASC;
  int _streamsPage = 1;
  final int _streamsPageSize = 50;
  int _streamsTotal = 0;
  int _reviewsPage = 1;
  final int _reviewsPageSize = 50;
  int _reviewsTotal = 0;
  int _membersPage = 1;
  final int _membersPageSize = 50;
  int _membersTotal = 0;
  common_enum.RoomMemberRole? _memberRoleFilter;
  client_enum.RoomMemberListSortBy _memberSortBy =
      client_enum.RoomMemberListSortBy.ROOM_MEMBER_LIST_SORT_BY_JOINED_AT;
  client_enum.SortDirection _memberSortDirection =
      client_enum.SortDirection.SORT_DIRECTION_DESC;
  common_enum.ReviewStatus _reviewStatusFilter =
      common_enum.ReviewStatus.REVIEW_STATUS_PENDING;

  bool _updatePassword = false;
  bool _allowGuestJoin = false;
  bool _requireApproval = false;
  bool _allowAutoJoin = true;
  bool _chatEnabled = true;
  bool _danmakuEnabled = true;
  int _memberPermissions = RoomMemberPermissions.all;
  int _guestPermissions = 0;
  bool _isSaving = false;
  bool _streamsLoading = false;
  bool _reviewsLoading = false;
  bool _membersLoading = false;
  bool _mediaLoading = false;
  bool _mediaProviderInstancesLoading = false;
  bool _chatLoading = false;
  bool _iceLoading = false;
  late String _currentUserId;

  bool get _canLeaveRoom =>
      _currentUserId.isNotEmpty &&
      (widget.creatorId.isEmpty || _currentUserId != widget.creatorId);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this);
    _settings = widget.currentSettings;
    _currentUserId = widget.currentUserId;
    _passwordController = TextEditingController();
    _maxMembersController = TextEditingController();
    _streamSearchController = TextEditingController();
    _memberSearchController = TextEditingController();
    _reviewUserController = TextEditingController();
    _mediaSearchController = TextEditingController();
    _applySettings(_settings);
    _loadStreams();
    _loadReviews();
    _loadMembers();
    _loadMediaProviderInstances();
    _loadMediaLibrary();
    _loadChatHistory();
    _loadIceServers();
    _loadCurrentUserIfNeeded();
    _startResourceWatches();
  }

  @override
  void dispose() {
    _settingsWatchSubscription?.cancel();
    _membersWatchSubscription?.cancel();
    _mediaWatchSubscription?.cancel();
    _tabController.dispose();
    _passwordController.dispose();
    _maxMembersController.dispose();
    _streamSearchController.dispose();
    _memberSearchController.dispose();
    _reviewUserController.dispose();
    _mediaSearchController.dispose();
    super.dispose();
  }

  void _applySettings(WRoomSettings settings) {
    _allowGuestJoin = settings.allowGuestJoin;
    _requireApproval = settings.requireApproval;
    _allowAutoJoin = settings.allowAutoJoin;
    _chatEnabled = settings.chatEnabled;
    _danmakuEnabled = settings.danmakuEnabled;
    _memberPermissions = settings.effectiveMemberPermissions;
    _guestPermissions = settings.effectiveGuestPermissions;
    _maxMembersController.text = settings.maxMembers.toString();
  }

  void _startResourceWatches() {
    _startSettingsWatch();
    _startMembersWatch();
    _startMediaWatch();
  }

  Future<void> _loadCurrentUserIfNeeded() async {
    if (_currentUserId.isNotEmpty) return;
    try {
      final user = await WatchTogetherService.getMe();
      if (!mounted) return;
      setState(() => _currentUserId = user.id);
    } catch (e) {
      debugPrint('Load room settings current user failed: $e');
    }
  }

  void _startSettingsWatch() {
    _settingsWatchSubscription?.cancel();
    _settingsWatchSubscription = WatchTogetherService.watchRoomSettings(
      widget.roomId,
      version: _settingsWatchVersion,
    ).listen(
      _handleSettingsWatchEvent,
      onError: (error) => _scheduleWatchReconnect(error, _startSettingsWatch),
      cancelOnError: true,
    );
  }

  void _startMembersWatch() {
    _membersWatchSubscription?.cancel();
    _membersWatchSubscription = WatchTogetherService.watchRoomMembers(
      widget.roomId,
      version: _membersWatchVersion,
    ).listen(
      _handleMembersWatchEvent,
      onError: (error) => _scheduleWatchReconnect(error, _startMembersWatch),
      cancelOnError: true,
    );
  }

  void _startMediaWatch() {
    _mediaWatchSubscription?.cancel();
    _mediaWatchSubscription = WatchTogetherService.watchPlaylistItems(
      widget.roomId,
      version: _mediaWatchVersion,
      playlistId: _currentPlaylistId,
      target: _mediaTarget,
      search: _mediaSearchController.text.trim(),
      sourceProvider: _mediaSourceProvider,
      providerInstanceName: _mediaProviderInstanceName,
      sortBy: _mediaSortBy,
      sortDirection: _mediaSortDirection,
      availability: _mediaAvailability,
    ).listen(
      _handleMediaWatchEvent,
      onError: (error) => _scheduleWatchReconnect(error, _startMediaWatch),
      cancelOnError: true,
    );
  }

  void _scheduleWatchReconnect(Object error, VoidCallback reconnect) {
    final delay = WatchTogetherService.resourceWatchReconnectDelay(error);
    if (delay == null) {
      debugPrint(
          'Room settings watch stopped after non-retryable error: $error');
      return;
    }
    Future.delayed(delay, () {
      if (!mounted) return;
      reconnect();
    });
  }

  void _handleSettingsWatchEvent(
    RoomResourceWatchEvent<WRoomSettings> event,
  ) {
    if (!mounted) return;
    if (event.version.isNotEmpty) _settingsWatchVersion = event.version;
    switch (event.kind) {
      case RoomResourceWatchKind.observed:
        if (event.changed) _refreshSettingsFromServer();
        break;
      case RoomResourceWatchKind.changed:
        final snapshot = event.snapshot;
        if (snapshot == null) {
          _refreshSettingsFromServer();
          return;
        }
        setState(() {
          _settings = snapshot;
          _applySettings(snapshot);
        });
        break;
      case RoomResourceWatchKind.error:
        MessageUtils.showError(
          context,
          event.errorMessage.isEmpty ? '房间设置监听失败' : event.errorMessage,
        );
        break;
    }
  }

  void _handleMembersWatchEvent(
    RoomResourceWatchEvent<List<AdminRoomMember>> event,
  ) {
    if (!mounted) return;
    if (event.version.isNotEmpty) _membersWatchVersion = event.version;
    switch (event.kind) {
      case RoomResourceWatchKind.observed:
        if (event.changed) _loadMembers();
        break;
      case RoomResourceWatchKind.changed:
        final snapshot = event.snapshot;
        if (snapshot == null) {
          _loadMembers();
          return;
        }
        setState(() {
          _members
            ..clear()
            ..addAll(snapshot);
        });
        break;
      case RoomResourceWatchKind.error:
        MessageUtils.showError(
          context,
          event.errorMessage.isEmpty ? '成员监听失败' : event.errorMessage,
        );
        break;
    }
  }

  void _handleMediaWatchEvent(
    RoomResourceWatchEvent<RoomMediaLibraryPage> event,
  ) {
    if (!mounted) return;
    if (event.version.isNotEmpty) _mediaWatchVersion = event.version;
    switch (event.kind) {
      case RoomResourceWatchKind.observed:
        if (event.changed) _loadMediaLibrary();
        break;
      case RoomResourceWatchKind.changed:
        final snapshot = event.snapshot;
        if (snapshot == null) {
          _loadMediaLibrary();
          return;
        }
        setState(() => _mediaPage = snapshot);
        break;
      case RoomResourceWatchKind.error:
        MessageUtils.showError(
          context,
          event.errorMessage.isEmpty ? '媒体库监听失败' : event.errorMessage,
        );
        break;
    }
  }

  Future<void> _refreshSettingsFromServer() async {
    try {
      final settings = await WatchTogetherService.getRoomSettings(
        widget.roomId,
      );
      if (!mounted) return;
      setState(() {
        _settings = settings;
        _applySettings(settings);
      });
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '刷新房间设置失败: $e');
    }
  }

  bool _hasPermission(int permissions, int flag) => (permissions & flag) != 0;

  void _setMemberPermission(int flag, bool enabled) {
    setState(() {
      _memberPermissions =
          enabled ? (_memberPermissions | flag) : (_memberPermissions & ~flag);
    });
  }

  void _setGuestPermission(int flag, bool enabled) {
    setState(() {
      _guestPermissions =
          enabled ? (_guestPermissions | flag) : (_guestPermissions & ~flag);
    });
  }

  int _memberRemovedPermissions() =>
      RoomMemberPermissions.all & ~_memberPermissions;

  int _guestRemovedPermissions() =>
      RoomGuestPermissions.all & ~_guestPermissions;

  Future<void> _saveSettings() async {
    final maxMembers = int.tryParse(_maxMembersController.text.trim());
    if (maxMembers == null || maxMembers < 0 || maxMembers > 10000) {
      MessageUtils.showError(context, '最大成员数必须在 0 到 10000 之间');
      return;
    }

    setState(() => _isSaving = true);
    try {
      if (_updatePassword) {
        await WatchTogetherService.updateRoomPassword(
          widget.roomId,
          _passwordController.text,
        );
      }

      final settings = WRoomSettings(
        requirePassword: _updatePassword
            ? _passwordController.text.isNotEmpty
            : _settings.requirePassword,
        allowGuestJoin: _allowGuestJoin,
        requireApproval: _requireApproval,
        allowAutoJoin: _allowAutoJoin,
        maxMembers: maxMembers,
        chatEnabled: _chatEnabled,
        danmakuEnabled: _danmakuEnabled,
        memberAddedPermissions: 0,
        memberRemovedPermissions: _memberRemovedPermissions(),
        guestAddedPermissions: _guestPermissions,
        guestRemovedPermissions: _guestRemovedPermissions(),
      );

      await WatchTogetherService.updateRoomSettings(
        widget.roomId,
        settings,
      );
      final freshSettings =
          await WatchTogetherService.getRoomSettings(widget.roomId);
      if (!mounted) return;
      setState(() {
        _settings = freshSettings;
        _updatePassword = false;
        _passwordController.clear();
        _applySettings(freshSettings);
      });
      MessageUtils.showSuccess(context, '设置已更新');
    } catch (e) {
      if (mounted) {
        MessageUtils.showError(context, '更新失败: $e');
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _loadStreams() async {
    if (!mounted) return;
    setState(() => _streamsLoading = true);
    try {
      final page = await WatchTogetherService.listRoomStreamsPage(
        widget.roomId,
        page: _streamsPage,
        pageSize: _streamsPageSize,
        search: _streamSearchController.text.trim(),
        sortDirection: _streamSortDirection,
      );
      if (!mounted) return;
      setState(() {
        _streams
          ..clear()
          ..addAll(page.streams);
        _streamsTotal = page.total;
      });
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载活跃流失败: $e');
    } finally {
      if (mounted) setState(() => _streamsLoading = false);
    }
  }

  Future<void> _loadReviews() async {
    if (!mounted) return;
    setState(() => _reviewsLoading = true);
    try {
      final page = await WatchTogetherService.listRoomJoinReviewsPage(
        widget.roomId,
        page: _reviewsPage,
        pageSize: _reviewsPageSize,
        status: _reviewStatusFilter,
        userId: _reviewUserController.text.trim(),
      );
      if (!mounted) return;
      setState(() {
        _reviews
          ..clear()
          ..addAll(page.reviews);
        _reviewsTotal = page.total;
      });
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载加入审核失败: $e');
    } finally {
      if (mounted) setState(() => _reviewsLoading = false);
    }
  }

  Future<void> _loadMembers() async {
    if (!mounted) return;
    setState(() => _membersLoading = true);
    try {
      final page = await WatchTogetherService.getRoomMemberDetailsPage(
        widget.roomId,
        page: _membersPage,
        pageSize: _membersPageSize,
        search: _memberSearchController.text.trim(),
        role: _memberRoleFilter,
        sortBy: _memberSortBy,
        sortDirection: _memberSortDirection,
      );
      if (!mounted) return;
      setState(() {
        _members
          ..clear()
          ..addAll(page.members);
        _membersTotal = page.total;
        _membersWatchVersion = page.version;
      });
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载成员失败: $e');
    } finally {
      if (mounted) setState(() => _membersLoading = false);
    }
  }

  Future<void> _loadMediaLibrary({bool refresh = false}) async {
    if (!mounted) return;
    setState(() => _mediaLoading = true);
    try {
      final page = await WatchTogetherService.listMediaLibrary(
        widget.roomId,
        playlistId: _currentPlaylistId,
        target: _mediaTarget,
        search: _mediaSearchController.text.trim(),
        sourceProvider: _mediaSourceProvider,
        providerInstanceName: _mediaProviderInstanceName,
        sortBy: _mediaSortBy,
        sortDirection: _mediaSortDirection,
        availability: _mediaAvailability,
        refresh: refresh,
      );
      if (!mounted) return;
      setState(() {
        _mediaPage = page;
        _mediaWatchVersion = page.version;
      });
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载媒体库失败: $e');
    } finally {
      if (mounted) setState(() => _mediaLoading = false);
    }
  }

  Future<void> _reloadMediaLibrary({bool refresh = false}) async {
    _mediaWatchVersion = '';
    _startMediaWatch();
    await _loadMediaLibrary(refresh: refresh);
  }

  Future<void> _loadMediaProviderInstances() async {
    if (!mounted) return;
    final provider = _mediaSourceProvider;
    if (!_mediaSourcesWithProviderInstances.contains(provider)) {
      setState(() {
        _mediaProviderInstanceName = '';
        _mediaProviderInstances = const [''];
        _mediaProviderInstancesLoading = false;
      });
      return;
    }

    setState(() => _mediaProviderInstancesLoading = true);
    try {
      final instances =
          await WatchTogetherService.listAvailableProviderInstances(
        providerType: provider,
      );
      if (!mounted || provider != _mediaSourceProvider) return;
      final normalized = _mergeMediaProviderInstances(instances);
      setState(() {
        _mediaProviderInstances = normalized;
        if (!_mediaProviderInstances.contains(_mediaProviderInstanceName)) {
          _mediaProviderInstanceName = '';
        }
      });
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载媒体来源实例失败: $e');
    } finally {
      if (mounted && provider == _mediaSourceProvider) {
        setState(() => _mediaProviderInstancesLoading = false);
      }
    }
  }

  List<String> _mergeMediaProviderInstances(List<String> remoteInstances) {
    final names = <String>[''];
    for (final instance in remoteInstances) {
      final trimmed = instance.trim();
      if (trimmed.isNotEmpty && !names.contains(trimmed)) {
        names.add(trimmed);
      }
    }
    return names;
  }

  Future<void> _selectMediaSourceProvider(String provider) async {
    if (provider == _mediaSourceProvider) return;
    setState(() {
      _mediaSourceProvider = provider;
      _mediaProviderInstanceName = '';
      _mediaProviderInstances = const [''];
      _mediaWatchVersion = '';
    });
    await _loadMediaProviderInstances();
    await _reloadMediaLibrary();
  }

  Future<void> _selectMediaProviderInstance(String instanceName) async {
    if (instanceName == _mediaProviderInstanceName) return;
    setState(() {
      _mediaProviderInstanceName = instanceName;
      _mediaWatchVersion = '';
    });
    await _reloadMediaLibrary();
  }

  Future<void> _loadChatHistory({bool loadMore = false}) async {
    if (!mounted) return;
    if (loadMore && _chatCursor.isEmpty) return;
    setState(() => _chatLoading = true);
    try {
      final page = await WatchTogetherService.getChatHistory(
        widget.roomId,
        cursor: loadMore ? _chatCursor : '',
      );
      if (!mounted) return;
      setState(() {
        if (!loadMore) _chatMessages.clear();
        _chatMessages.addAll(page.messages);
        _chatCursor = page.nextCursor;
      });
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载聊天历史失败: $e');
    } finally {
      if (mounted) setState(() => _chatLoading = false);
    }
  }

  Future<void> _loadIceServers() async {
    if (!mounted) return;
    setState(() => _iceLoading = true);
    try {
      final servers = await WatchTogetherService.getIceServers(widget.roomId);
      if (!mounted) return;
      setState(() {
        _iceServers
          ..clear()
          ..addAll(servers);
      });
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载 ICE 配置失败: $e');
    } finally {
      if (mounted) setState(() => _iceLoading = false);
    }
  }

  int get _streamPageCount {
    if (_streamsTotal <= 0) return 1;
    return ((_streamsTotal + _streamsPageSize - 1) ~/ _streamsPageSize)
        .clamp(1, 1 << 31);
  }

  int get _reviewPageCount {
    if (_reviewsTotal <= 0) return 1;
    return ((_reviewsTotal + _reviewsPageSize - 1) ~/ _reviewsPageSize)
        .clamp(1, 1 << 31);
  }

  int get _memberPageCount {
    if (_membersTotal <= 0) return 1;
    return ((_membersTotal + _membersPageSize - 1) ~/ _membersPageSize)
        .clamp(1, 1 << 31);
  }

  List<_RoomSettingsSection> get _sections => [
        _RoomSettingsSection(
          label: '设置',
          icon: Icons.tune_rounded,
          builder: _buildSettingsTab,
        ),
        _RoomSettingsSection(
          label: '成员',
          icon: Icons.group_rounded,
          builder: _buildMembersTab,
        ),
        _RoomSettingsSection(
          label: '媒体',
          icon: Icons.video_library_rounded,
          builder: _buildMediaTab,
        ),
        _RoomSettingsSection(
          label: '实时',
          icon: Icons.sensors_rounded,
          builder: _buildRealtimeTab,
        ),
        _RoomSettingsSection(
          label: '聊天',
          icon: Icons.forum_rounded,
          builder: _buildChatHistoryTab,
        ),
        _RoomSettingsSection(
          label: '网络',
          icon: Icons.hub_rounded,
          builder: _buildNetworkTab,
        ),
        _RoomSettingsSection(
          label: '推流',
          icon: Icons.podcasts_rounded,
          builder: _buildStreamsTab,
        ),
        _RoomSettingsSection(
          label: '审核',
          icon: Icons.fact_check_rounded,
          builder: _buildReviewsTab,
        ),
      ];

  String get _currentPlaylistId =>
      _mediaPlaylistStack.isEmpty ? '' : _mediaPlaylistStack.last;

  String get _mediaTarget =>
      _mediaTargetStack.isEmpty ? '' : _mediaTargetStack.last;

  Future<void> _openMediaEntry(WMovie entry) async {
    if (!entry.isFolder) return;
    final isPersistedPlaylist = entry.id.startsWith('pl_');
    final target = isPersistedPlaylist ? '' : entry.playbackWatchTarget ?? '';
    if (!isPersistedPlaylist && target.isEmpty) return;
    setState(() {
      if (isPersistedPlaylist) {
        _mediaPlaylistStack.add(entry.id);
        _mediaTargetStack.clear();
      } else {
        _mediaTargetStack.add(target);
      }
      _mediaWatchVersion = '';
    });
    _startMediaWatch();
    await _loadMediaLibrary();
  }

  Future<bool> _handleMediaBack() async {
    if (_mediaTargetStack.isNotEmpty) {
      setState(() {
        _mediaTargetStack.removeLast();
        _mediaWatchVersion = '';
      });
      _startMediaWatch();
      await _loadMediaLibrary();
      return true;
    }
    if (_mediaPlaylistStack.isNotEmpty) {
      setState(() {
        _mediaPlaylistStack.removeLast();
        _mediaWatchVersion = '';
      });
      _startMediaWatch();
      await _loadMediaLibrary();
      return true;
    }
    return false;
  }

  Future<void> _kickStream(RoomStreamEntryInfo stream) async {
    try {
      await WatchTogetherService.kickRoomStream(
        widget.roomId,
        stream.mediaId,
        reason: 'Kicked from room settings',
      );
      await _loadStreams();
      if (mounted) MessageUtils.showSuccess(context, '已断开推流');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '断开推流失败: $e');
    }
  }

  Future<void> _showStreamInfo(RoomStreamEntryInfo stream) async {
    try {
      final detail = await WatchTogetherService.getRoomStreamInfo(
        widget.roomId,
        stream.mediaId,
      );
      if (!mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (context) {
          final theme = Theme.of(context);
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        detail.active ? Icons.sensors : Icons.sensors_off,
                        color:
                            detail.active ? Colors.green : theme.disabledColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          detail.mediaId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDetailLine('状态', detail.active ? '活跃' : '未活跃'),
                  _buildDetailLine(
                    '发布者',
                    detail.publisherUserId.isEmpty
                        ? '未知发布者'
                        : detail.publisherUserId,
                  ),
                  _buildDetailLine(
                    '开始时间',
                    detail.startedAt <= 0
                        ? '-'
                        : _formatTimestamp(detail.startedAt),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: detail.mediaId),
                          );
                          Navigator.pop(context);
                          MessageUtils.showSuccess(context, '媒体 ID 已复制');
                        },
                        icon: const Icon(Icons.copy_rounded),
                        label: const Text('复制 ID'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.tonalIcon(
                        onPressed: detail.active
                            ? () {
                                Navigator.pop(context);
                                _kickStream(detail);
                              }
                            : null,
                        icon: const Icon(Icons.link_off),
                        label: const Text('断开推流'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载推流详情失败: $e');
    }
  }

  Future<void> _approveReview(RoomJoinReviewInfo review) async {
    try {
      await WatchTogetherService.approveRoomJoinReview(
          widget.roomId, review.id);
      await _loadReviews();
      if (mounted) MessageUtils.showSuccess(context, '已通过申请');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '审核失败: $e');
    }
  }

  Future<void> _rejectReview(RoomJoinReviewInfo review) async {
    final reason = await _showRejectReasonDialog();
    if (reason == null) return;
    try {
      await WatchTogetherService.rejectRoomJoinReview(
        widget.roomId,
        review.id,
        reason: reason,
      );
      await _loadReviews();
      if (mounted) MessageUtils.showSuccess(context, '已拒绝申请');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '审核失败: $e');
    }
  }

  Future<void> _addMember() async {
    final result = await _showMemberEditDialog();
    if (result == null) return;
    try {
      await WatchTogetherService.addRoomMember(
        widget.roomId,
        result.userId,
        role: result.role,
        notify: result.notify,
      );
      await _loadMembers();
      if (mounted) MessageUtils.showSuccess(context, '成员已添加');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '添加成员失败: $e');
    }
  }

  Future<void> _setMemberRole(AdminRoomMember member) async {
    final result = await _showMemberRoleDialog(member.role);
    if (result == null || result == member.role) return;
    try {
      await WatchTogetherService.setRoomMemberRole(
        widget.roomId,
        member.userId,
        result,
      );
      await _loadMembers();
      if (mounted) MessageUtils.showSuccess(context, '成员角色已更新');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '更新角色失败: $e');
    }
  }

  Future<void> _editMemberPermissionOverrides(AdminRoomMember member) async {
    final result = await _showMemberPermissionOverrideDialog(member);
    if (result == null) return;
    try {
      await WatchTogetherService.updateRoomMemberPermissionOverrides(
        widget.roomId,
        member.userId,
        addedPermissions: result.addedPermissions,
        removedPermissions: result.removedPermissions,
        adminAddedPermissions: result.adminAddedPermissions,
        adminRemovedPermissions: result.adminRemovedPermissions,
      );
      await _loadMembers();
      if (mounted) MessageUtils.showSuccess(context, '成员权限已更新');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '更新权限失败: $e');
    }
  }

  Future<void> _transferOwnership(AdminRoomMember member) async {
    final confirmed = await _confirm(
      title: '转让房主',
      content: '确认将房间所有权转让给 ${member.username}？',
      action: '转让',
    );
    if (!confirmed) return;
    try {
      await WatchTogetherService.transferRoomOwnership(
        widget.roomId,
        member.userId,
      );
      await _loadMembers();
      if (mounted) MessageUtils.showSuccess(context, '房主已转让');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '转让失败: $e');
    }
  }

  Future<void> _kickMember(AdminRoomMember member) async {
    final confirmed = await _confirm(
      title: '移出成员',
      content: '确认将 ${member.username} 移出房间？',
      action: '移出',
    );
    if (!confirmed) return;
    try {
      await WatchTogetherService.kickMember(widget.roomId, member.userId);
      await _loadMembers();
      if (mounted) MessageUtils.showSuccess(context, '成员已移出');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '移出成员失败: $e');
    }
  }

  Future<void> _resetSettings() async {
    final confirmed = await _confirm(
      title: '重置设置',
      content: '确认恢复房间默认设置？',
      action: '重置',
    );
    if (!confirmed) return;
    try {
      await WatchTogetherService.resetRoomSettings(widget.roomId);
      final settings =
          await WatchTogetherService.getRoomSettings(widget.roomId);
      if (!mounted) return;
      setState(() {
        _settings = settings;
        _updatePassword = false;
        _passwordController.clear();
        _applySettings(settings);
      });
      MessageUtils.showSuccess(context, '设置已重置');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '重置失败: $e');
    }
  }

  Future<void> _leaveRoom() async {
    final confirmed = await _confirm(
      title: '退出房间',
      content: '确认退出 ${widget.roomName}？',
      action: '退出',
    );
    if (!confirmed) return;
    try {
      await WatchTogetherService.leaveRoom(widget.roomId);
      if (!mounted) return;
      Navigator.pop(context);
      MessageUtils.showSuccess(context, '已退出房间');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '退出房间失败: $e');
    }
  }

  Future<void> _deleteRoom() async {
    final confirmed = await _confirm(
      title: '删除房间',
      content: '确认永久删除 ${widget.roomName}？此操作会移除房间、播放列表和相关房间数据。',
      action: '删除',
    );
    if (!confirmed) return;
    try {
      await WatchTogetherService.deleteRoom(widget.roomId);
      if (!mounted) return;
      Navigator.pop(context, true);
      MessageUtils.showSuccess(context, '房间已删除');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '删除房间失败: $e');
    }
  }

  Future<void> _createPlaylist() async {
    if (_mediaTarget.isNotEmpty) {
      MessageUtils.showInfo(context, '动态目录中不能创建本地播放列表');
      return;
    }
    final name = await _showNameDialog(title: '新建播放列表', label: '名称');
    if (name == null || name.isEmpty) return;
    try {
      await WatchTogetherService.createPlaylist(
        widget.roomId,
        name: name,
        parentId: _currentPlaylistId,
      );
      await _loadMediaLibrary();
      if (mounted) MessageUtils.showSuccess(context, '播放列表已创建');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '创建播放列表失败: $e');
    }
  }

  Future<void> _clearCurrentMediaScope() async {
    if (_mediaTarget.isNotEmpty) {
      MessageUtils.showInfo(context, '动态目录内容不能在房间内清空');
      return;
    }
    final playlistId = _currentPlaylistId;
    final confirmed = await _confirm(
      title: playlistId.isEmpty ? '清空媒体库' : '清空播放列表',
      content: playlistId.isEmpty
          ? '确认清空根目录下的媒体和播放列表？'
          : '确认清空当前播放列表下的媒体和子播放列表？播放列表本身会保留。',
      action: '清空',
    );
    if (!confirmed) return;

    try {
      await WatchTogetherService.clearMovies(
        widget.roomId,
        parentId: playlistId.isEmpty ? null : playlistId,
      );
      await _loadMediaLibrary();
      if (mounted) MessageUtils.showSuccess(context, '媒体库已清空');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '清空失败: $e');
    }
  }

  Future<void> _renameEntry(WMovie entry) async {
    final name = await _showNameDialog(
      title: entry.isFolder ? '重命名播放列表' : '重命名媒体',
      label: '名称',
      initialValue: entry.name,
    );
    if (name == null || name.isEmpty || name == entry.name) return;
    try {
      if (entry.id.startsWith('pl_')) {
        await WatchTogetherService.updatePlaylist(
          widget.roomId,
          entry.id,
          name: name,
        );
      } else if (entry.id.startsWith('med_')) {
        await WatchTogetherService.editMedia(
          widget.roomId,
          entry.id,
          name: name,
        );
      }
      await _loadMediaLibrary();
      if (mounted) MessageUtils.showSuccess(context, '名称已更新');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '重命名失败: $e');
    }
  }

  Future<void> _deleteEntry(WMovie entry) async {
    final confirmed = await _confirm(
      title: '删除条目',
      content: '确认删除 ${entry.name}？',
      action: '删除',
    );
    if (!confirmed) return;
    try {
      if (entry.id.startsWith('pl_')) {
        await WatchTogetherService.deletePlaylist(
          widget.roomId,
          entry.id,
          force: true,
        );
      } else if (entry.id.startsWith('med_')) {
        await WatchTogetherService.deleteMovie(widget.roomId, entry.id);
      }
      await _loadMediaLibrary();
      if (mounted) MessageUtils.showSuccess(context, '条目已删除');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '删除失败: $e');
    }
  }

  Future<void> _showMediaEntryDetails(WMovie entry) async {
    try {
      var detail = entry;
      PlaylistDetailInfo? playlistDetail;
      if (entry.id.startsWith('pl_')) {
        playlistDetail = await WatchTogetherService.getPlaylist(
          widget.roomId,
          entry.id,
        );
        detail = playlistDetail.playlist;
      } else if (entry.id.startsWith('med_')) {
        detail = await WatchTogetherService.getMedia(widget.roomId, entry.id);
      }
      if (!mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (context) {
          final theme = Theme.of(context);
          final isPlaylist = detail.id.startsWith('pl_');
          final isPersisted =
              detail.id.startsWith('pl_') || detail.id.startsWith('med_');
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isPlaylist
                              ? Icons.folder
                              : detail.live
                                  ? Icons.live_tv
                                  : Icons.movie,
                          color: isPlaylist
                              ? Colors.amber.shade700
                              : theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            detail.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDetailLine('ID', detail.id),
                    _buildDetailLine(
                      '类型',
                      isPlaylist
                          ? detail.metadata['is_dynamic'] == true
                              ? '动态播放列表'
                              : '播放列表'
                          : detail.isFolder
                              ? '动态目录'
                              : detail.live
                                  ? '直播媒体'
                                  : '媒体',
                    ),
                    _buildDetailLine(
                      'Provider',
                      detail.sourceProvider.isEmpty
                          ? '-'
                          : detail.sourceProvider,
                    ),
                    _buildDetailLine(
                      '实例',
                      detail.providerInstanceName.isEmpty
                          ? '-'
                          : detail.providerInstanceName,
                    ),
                    if (detail.parentId?.isNotEmpty == true)
                      _buildDetailLine('父级', detail.parentId!),
                    if (detail.url.isNotEmpty)
                      _buildDetailLine('URL', detail.url),
                    if (detail.subPath?.isNotEmpty == true)
                      _buildDetailLine('Sub path', detail.subPath!),
                    if (playlistDetail != null) ...[
                      _buildDetailLine(
                        '子播放列表',
                        playlistDetail.childFolderCount.toString(),
                      ),
                      _buildDetailLine(
                        '媒体数量',
                        playlistDetail.mediaCount.toString(),
                      ),
                    ],
                    if (detail.metadata.isNotEmpty)
                      _buildDetailLine('元数据', _compactMap(detail.metadata)),
                    if (detail.sourceConfig.isNotEmpty)
                      _buildDetailLine(
                        '来源配置',
                        _compactMap(detail.sourceConfig),
                      ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: detail.id));
                            Navigator.pop(context);
                            MessageUtils.showSuccess(context, 'ID 已复制');
                          },
                          icon: const Icon(Icons.copy_rounded),
                          label: const Text('复制 ID'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.tonalIcon(
                          onPressed: isPersisted
                              ? () {
                                  Navigator.pop(context);
                                  _renameEntry(detail);
                                }
                              : null,
                          icon: const Icon(Icons.edit_outlined),
                          label: const Text('重命名'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载条目详情失败: $e');
    }
  }

  Future<void> _moveMedia(WMovie entry) async {
    if (!entry.id.startsWith('med_')) return;
    final target = await _showMoveMediaTargetDialog(entry);
    if (target == null) return;
    final targetPlaylistId = target.playlistId;
    final sourcePlaylistId =
        _currentPlaylistId.isEmpty ? null : _currentPlaylistId;
    if ((sourcePlaylistId ?? '') == targetPlaylistId) return;
    try {
      final count = await WatchTogetherService.moveMedia(
        widget.roomId,
        mediaIds: [entry.id],
        sourcePlaylistId: sourcePlaylistId,
        targetPlaylistId: targetPlaylistId.isEmpty ? null : targetPlaylistId,
      );
      await _loadMediaLibrary();
      if (mounted) MessageUtils.showSuccess(context, '已移动 $count 个媒体');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '移动失败: $e');
    }
  }

  Future<void> _movePlaylistRelative(WMovie entry, int direction) async {
    if (!entry.id.startsWith('pl_')) return;
    final playlists = _mediaPage?.playlists ?? const <WMovie>[];
    final index = playlists.indexWhere((item) => item.id == entry.id);
    if (index < 0) return;
    final isUp = direction < 0;
    if (isUp && index == 0) return;
    if (!isUp && index >= playlists.length - 1) return;

    try {
      if (isUp) {
        await WatchTogetherService.movePlaylist(
          widget.roomId,
          entry.id,
          beforePlaylistId: playlists[index - 1].id,
        );
      } else {
        await WatchTogetherService.movePlaylist(
          widget.roomId,
          entry.id,
          afterPlaylistId: playlists[index + 1].id,
        );
      }
      await _loadMediaLibrary();
      if (mounted) MessageUtils.showSuccess(context, '播放列表顺序已更新');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '调整顺序失败: $e');
    }
  }

  Future<_MediaMoveTarget?> _showMoveMediaTargetDialog(WMovie entry) async {
    var loading = true;
    var error = '';
    var playlists = <WMovie>[];

    Future<void> loadPlaylists(StateSetter setDialogState) async {
      setDialogState(() {
        loading = true;
        error = '';
      });
      try {
        final page = await WatchTogetherService.listPlaylistsPage(
          widget.roomId,
          pageSize: 100,
          dynamicOnly: false,
        );
        if (!mounted) return;
        setDialogState(() {
          playlists = page.playlists
              .where((item) => item.id != _currentPlaylistId)
              .toList();
          loading = false;
        });
      } catch (e) {
        if (!mounted) return;
        setDialogState(() {
          error = e.toString();
          loading = false;
        });
      }
    }

    return showDialog<_MediaMoveTarget>(
      context: context,
      builder: (context) {
        var started = false;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            if (!started) {
              started = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) loadPlaylists(setDialogState);
              });
            }

            return AlertDialog(
              title: const Text('移动媒体'),
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        entry.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      leading: const Icon(Icons.home_outlined),
                      title: const Text('根目录'),
                      enabled: _currentPlaylistId.isNotEmpty,
                      onTap: _currentPlaylistId.isEmpty
                          ? null
                          : () => Navigator.pop(
                                context,
                                const _MediaMoveTarget('', '根目录'),
                              ),
                    ),
                    if (loading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: CircularProgressIndicator(),
                      )
                    else if (error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          error,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      )
                    else
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: playlists.length,
                          itemBuilder: (context, index) {
                            final playlist = playlists[index];
                            return ListTile(
                              leading: const Icon(Icons.folder_outlined),
                              title: Text(
                                playlist.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: playlist.parentId == null
                                  ? null
                                  : Text('上级 ${playlist.parentId}'),
                              onTap: () => Navigator.pop(
                                context,
                                _MediaMoveTarget(playlist.id, playlist.name),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                TextButton.icon(
                  onPressed:
                      loading ? null : () => loadPlaylists(setDialogState),
                  icon: const Icon(Icons.refresh),
                  label: const Text('刷新'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<String?> _showRejectReasonDialog() {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('拒绝申请'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: '原因',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('拒绝'),
            ),
          ],
        );
      },
    ).whenComplete(controller.dispose);
  }

  Future<String?> _showNameDialog({
    required String title,
    required String label,
    String initialValue = '',
  }) {
    final controller = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('保存'),
            ),
          ],
        );
      },
    ).whenComplete(controller.dispose);
  }

  Future<_MemberEditResult?> _showMemberEditDialog() {
    final userIdController = TextEditingController();
    var role = 3;
    var notify = true;
    return showDialog<_MemberEditResult>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('添加成员'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: userIdController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: '用户 ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    initialValue: role,
                    decoration: const InputDecoration(
                      labelText: '角色',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 2, child: Text('管理员')),
                      DropdownMenuItem(value: 3, child: Text('成员')),
                      DropdownMenuItem(value: 4, child: Text('访客')),
                    ],
                    onChanged: (value) {
                      if (value != null) setDialogState(() => role = value);
                    },
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('发送通知'),
                    value: notify,
                    onChanged: (value) => setDialogState(() => notify = value),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                FilledButton(
                  onPressed: () {
                    final userId = userIdController.text.trim();
                    if (userId.isEmpty) return;
                    Navigator.pop(
                      context,
                      _MemberEditResult(userId, role, notify),
                    );
                  },
                  child: const Text('添加'),
                ),
              ],
            );
          },
        );
      },
    ).whenComplete(userIdController.dispose);
  }

  Future<int?> _showMemberRoleDialog(int currentRole) {
    var role = currentRole == 1 ? 3 : currentRole;
    return showDialog<int>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('修改角色'),
              content: DropdownButtonFormField<int>(
                initialValue: role,
                decoration: const InputDecoration(
                  labelText: '角色',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 2, child: Text('管理员')),
                  DropdownMenuItem(value: 3, child: Text('成员')),
                  DropdownMenuItem(value: 4, child: Text('访客')),
                ],
                onChanged: (value) {
                  if (value != null) setDialogState(() => role = value);
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(context, role),
                  child: const Text('保存'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<_MemberPermissionOverrideResult?> _showMemberPermissionOverrideDialog(
    AdminRoomMember member,
  ) {
    final isAdmin =
        member.role == common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value;
    var added =
        isAdmin ? member.adminAddedPermissions : member.addedPermissions;
    var removed =
        isAdmin ? member.adminRemovedPermissions : member.removedPermissions;

    return showDialog<_MemberPermissionOverrideResult>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
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

            return AlertDialog(
              title: const Text('权限覆盖'),
              content: SizedBox(
                width: 440,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: RoomMemberPermissions.descriptions.entries
                      .map(
                        (entry) => _buildPermissionOverrideRow(
                          entry.value,
                          entry.key,
                          added,
                          removed,
                          setOverride,
                        ),
                      )
                      .toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      added = 0;
                      removed = 0;
                    });
                  },
                  child: const Text('清除覆盖'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      _MemberPermissionOverrideResult(
                        addedPermissions: isAdmin ? 0 : added,
                        removedPermissions: isAdmin ? 0 : removed,
                        adminAddedPermissions: isAdmin ? added : 0,
                        adminRemovedPermissions: isAdmin ? removed : 0,
                      ),
                    );
                  },
                  child: const Text('保存'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildPermissionOverrideRow(
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
          SegmentedButton<_PermissionOverrideMode>(
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
            selected: {mode},
            onSelectionChanged: (selection) {
              onChanged(flag, selection.single);
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _confirm({
    required String title,
    required String content,
    required String action,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(action),
            ),
          ],
        );
      },
    );
    return confirmed == true;
  }

  Widget _buildSwitchItem(
    String title,
    String? subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    ThemeData theme,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: theme.hintColor, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          IOSStyleSwitch(value: value, onChanged: onChanged, isDark: isDark),
        ],
      ),
    );
  }

  Widget _buildPermissionSwitch(
    String title,
    int permissions,
    int flag,
    ValueChanged<bool> onChanged,
    ThemeData theme,
    bool isDark,
  ) {
    return _buildSwitchItem(
      title,
      null,
      _hasPermission(permissions, flag),
      onChanged,
      theme,
      isDark,
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 20),
      child: Text(
        title,
        style: TextStyle(
          color: theme.hintColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSurface({
    required List<Widget> children,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: theme.dividerColor.withValues(alpha: 0.12),
    );
  }

  Widget _buildMaxMembersField(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: _maxMembersController,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          labelText: '最大成员数',
          helperText: '0 表示不限制',
          labelStyle: TextStyle(color: theme.hintColor),
          helperStyle: TextStyle(color: theme.hintColor, fontSize: 11),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSettingsTab(ThemeData theme, bool isDark) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 32, top: 8),
      children: [
        _buildSectionHeader('访问控制', theme),
        _buildSurface(
          isDark: isDark,
          children: [
            InkWell(
              onTap: () => setState(() => _updatePassword = !_updatePassword),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '修改房间密码',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Checkbox(
                      value: _updatePassword,
                      onChanged: (v) =>
                          setState(() => _updatePassword = v ?? false),
                      activeColor: theme.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            if (_updatePassword) ...[
              _buildDivider(theme),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: '新密码',
                    helperText: '留空保存会移除房间密码',
                    labelStyle: TextStyle(color: theme.hintColor),
                    helperStyle:
                        TextStyle(color: theme.hintColor, fontSize: 11),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: _passwordController.clear,
                    ),
                  ),
                ),
              ),
            ],
            _buildDivider(theme),
            _buildSwitchItem(
              '允许访客加入',
              '访客 token 只能访问当前房间',
              _allowGuestJoin,
              (v) => setState(() => _allowGuestJoin = v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildSwitchItem(
              '加入需要审核',
              '新成员申请需管理员批准',
              _requireApproval,
              (v) => setState(() => _requireApproval = v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildSwitchItem(
              '允许自动加入',
              '关闭后只能通过邀请或管理员添加成员',
              _allowAutoJoin,
              (v) => setState(() => _allowAutoJoin = v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildMaxMembersField(theme),
          ],
        ),
        _buildSectionHeader('消息', theme),
        _buildSurface(
          isDark: isDark,
          children: [
            _buildSwitchItem(
              '聊天',
              null,
              _chatEnabled,
              (v) => setState(() => _chatEnabled = v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildSwitchItem(
              '弹幕',
              null,
              _danmakuEnabled,
              (v) => setState(() => _danmakuEnabled = v),
              theme,
              isDark,
            ),
          ],
        ),
        _buildSectionHeader('普通成员权限', theme),
        _buildSurface(
          isDark: isDark,
          children: [
            _buildPermissionSwitch(
              '发送聊天/弹幕',
              _memberPermissions,
              RoomMemberPermissions.chat,
              (v) => _setMemberPermission(RoomMemberPermissions.chat, v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              '添加媒体',
              _memberPermissions,
              RoomMemberPermissions.createMediaResource,
              (v) => _setMemberPermission(
                RoomMemberPermissions.createMediaResource,
                v,
              ),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              '查看媒体列表',
              _memberPermissions,
              RoomMemberPermissions.viewMediaResources,
              (v) => _setMemberPermission(
                RoomMemberPermissions.viewMediaResources,
                v,
              ),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              '查看成员列表',
              _memberPermissions,
              RoomMemberPermissions.viewMemberList,
              (v) => _setMemberPermission(
                RoomMemberPermissions.viewMemberList,
                v,
              ),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              '查看聊天历史',
              _memberPermissions,
              RoomMemberPermissions.viewChatHistory,
              (v) => _setMemberPermission(
                RoomMemberPermissions.viewChatHistory,
                v,
              ),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              'WebRTC 通话',
              _memberPermissions,
              RoomMemberPermissions.useWebRTC,
              (v) => _setMemberPermission(RoomMemberPermissions.useWebRTC, v),
              theme,
              isDark,
            ),
          ],
        ),
        _buildSectionHeader('访客权限', theme),
        _buildSurface(
          isDark: isDark,
          children: [
            _buildPermissionSwitch(
              '查看成员列表',
              _guestPermissions,
              RoomGuestPermissions.viewMemberList,
              (v) =>
                  _setGuestPermission(RoomGuestPermissions.viewMemberList, v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              '查看聊天历史',
              _guestPermissions,
              RoomGuestPermissions.viewChatHistory,
              (v) =>
                  _setGuestPermission(RoomGuestPermissions.viewChatHistory, v),
              theme,
              isDark,
            ),
            _buildDivider(theme),
            _buildPermissionSwitch(
              'WebRTC 通话',
              _guestPermissions,
              RoomGuestPermissions.useWebRTC,
              (v) => _setGuestPermission(RoomGuestPermissions.useWebRTC, v),
              theme,
              isDark,
            ),
          ],
        ),
        _buildSectionHeader('房间操作', theme),
        _buildRoomActions(theme, isDark),
      ],
    );
  }

  Widget _buildStreamsTab(ThemeData theme, bool isDark) {
    if (_streamsLoading && _streams.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: _loadStreams,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32, top: 12),
        children: [
          _buildToolbar(
            title: '活跃推流',
            count: _streams.length,
            loading: _streamsLoading,
            onRefresh: _loadStreams,
            theme: theme,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _streamSearchController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _streamSearchController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _streamSearchController.clear();
                                setState(() => _streamsPage = 1);
                                _loadStreams();
                              },
                              icon: const Icon(Icons.close_rounded),
                              tooltip: '清除搜索',
                            ),
                      labelText: '媒体 ID',
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) {
                      setState(() => _streamsPage = 1);
                      _loadStreams();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.outlined(
                  onPressed: () {
                    setState(() {
                      _streamSortDirection = _streamSortDirection ==
                              client_enum.SortDirection.SORT_DIRECTION_ASC
                          ? client_enum.SortDirection.SORT_DIRECTION_DESC
                          : client_enum.SortDirection.SORT_DIRECTION_ASC;
                      _streamsPage = 1;
                    });
                    _loadStreams();
                  },
                  icon: Icon(
                    _streamSortDirection ==
                            client_enum.SortDirection.SORT_DIRECTION_ASC
                        ? Icons.north_rounded
                        : Icons.south_rounded,
                  ),
                  tooltip: _streamSortDirection ==
                          client_enum.SortDirection.SORT_DIRECTION_ASC
                      ? '媒体 ID 升序'
                      : '媒体 ID 降序',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Text(
                  '第 $_streamsPage 页 · 每页 $_streamsPageSize · 共 $_streamsTotal 条',
                  style: TextStyle(color: theme.hintColor, fontSize: 12),
                ),
                const Spacer(),
                IconButton(
                  tooltip: '上一页',
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: _streamsPage <= 1
                      ? null
                      : () {
                          setState(() => _streamsPage -= 1);
                          _loadStreams();
                        },
                ),
                IconButton(
                  tooltip: '下一页',
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: _streamsPage >= _streamPageCount
                      ? null
                      : () {
                          setState(() => _streamsPage += 1);
                          _loadStreams();
                        },
                ),
              ],
            ),
          ),
          if (_streams.isEmpty)
            _buildEmptyState('当前没有活跃推流', theme)
          else
            ..._streams.map(
              (stream) => _buildStreamTile(stream, theme, isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(ThemeData theme, bool isDark) {
    if (_reviewsLoading && _reviews.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: _loadReviews,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32, top: 12),
        children: [
          _buildToolbar(
            title: '加入申请',
            count: _reviewsTotal,
            loading: _reviewsLoading,
            onRefresh: _loadReviews,
            theme: theme,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _reviewUserController,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: _reviewUserController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _reviewUserController.clear();
                                setState(() => _reviewsPage = 1);
                                _loadReviews();
                              },
                              icon: const Icon(Icons.close_rounded),
                              tooltip: '清除用户过滤',
                            ),
                      labelText: '用户 ID',
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) {
                      setState(() => _reviewsPage = 1);
                      _loadReviews();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 150,
                  child: DropdownButtonFormField<common_enum.ReviewStatus>(
                    initialValue: _reviewStatusFilter,
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: '状态',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: common_enum.ReviewStatus.REVIEW_STATUS_PENDING,
                        child: Text('待审核'),
                      ),
                      DropdownMenuItem(
                        value: common_enum.ReviewStatus.REVIEW_STATUS_APPROVED,
                        child: Text('已通过'),
                      ),
                      DropdownMenuItem(
                        value: common_enum.ReviewStatus.REVIEW_STATUS_REJECTED,
                        child: Text('已拒绝'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _reviewStatusFilter = value;
                        _reviewsPage = 1;
                      });
                      _loadReviews();
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '第 $_reviewsPage 页 · 每页 $_reviewsPageSize · 共 $_reviewsTotal 条',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.hintColor),
                  ),
                ),
                IconButton(
                  tooltip: '上一页',
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: _reviewsPage <= 1
                      ? null
                      : () {
                          setState(() => _reviewsPage -= 1);
                          _loadReviews();
                        },
                ),
                IconButton(
                  tooltip: '下一页',
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: _reviewsPage >= _reviewPageCount
                      ? null
                      : () {
                          setState(() => _reviewsPage += 1);
                          _loadReviews();
                        },
                ),
              ],
            ),
          ),
          if (_reviews.isEmpty)
            _buildEmptyState('当前没有加入申请', theme)
          else
            ..._reviews.map(
              (review) => _buildReviewTile(review, theme, isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildMediaTab(ThemeData theme, bool isDark) {
    final page = _mediaPage;
    if (_mediaLoading && page == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final entries = page?.entries ?? const <WMovie>[];
    return RefreshIndicator(
      onRefresh: _loadMediaLibrary,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32, top: 12),
        children: [
          _buildToolbar(
            title: '媒体库',
            count: entries.length,
            loading: _mediaLoading,
            onRefresh: _loadMediaLibrary,
            theme: theme,
            action: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: '返回上级',
                  onPressed:
                      _mediaTarget.isNotEmpty || _mediaPlaylistStack.isNotEmpty
                          ? _handleMediaBack
                          : null,
                  icon: const Icon(Icons.arrow_upward),
                ),
                IconButton(
                  tooltip: '新建播放列表',
                  onPressed: _mediaTarget.isEmpty ? _createPlaylist : null,
                  icon: const Icon(Icons.create_new_folder),
                ),
                IconButton(
                  tooltip: '清空当前目录',
                  onPressed: _mediaTarget.isEmpty && !_mediaLoading
                      ? _clearCurrentMediaScope
                      : null,
                  icon: const Icon(Icons.delete_sweep_rounded),
                ),
                IconButton(
                  tooltip: '刷新动态列表',
                  onPressed: () => _reloadMediaLibrary(refresh: true),
                  icon: const Icon(Icons.sync),
                ),
              ],
            ),
          ),
          _buildMediaScope(page, theme, isDark),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: [
                TextField(
                  controller: _mediaSearchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _mediaSearchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _mediaSearchController.clear();
                              _reloadMediaLibrary();
                            },
                            icon: const Icon(Icons.close_rounded),
                            tooltip: '清除搜索',
                          ),
                    labelText: '搜索媒体或目录',
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _reloadMediaLibrary(),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        key: ValueKey('media-source-$_mediaSourceProvider'),
                        initialValue: _mediaSourceProvider,
                        decoration: const InputDecoration(
                          isDense: true,
                          labelText: '来源',
                          border: OutlineInputBorder(),
                        ),
                        items: _mediaSourceLabels.entries
                            .map(
                              (entry) => DropdownMenuItem<String>(
                                value: entry.key,
                                child: Text(entry.value),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: (value) {
                          if (value == null) return;
                          _selectMediaSourceProvider(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        key: ValueKey(
                          'media-instance-$_mediaSourceProvider-'
                          '$_mediaProviderInstanceName-'
                          '${_mediaProviderInstances.join('|')}',
                        ),
                        initialValue: _mediaProviderInstances
                                .contains(_mediaProviderInstanceName)
                            ? _mediaProviderInstanceName
                            : '',
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: '实例',
                          border: const OutlineInputBorder(),
                          suffixIcon: _mediaProviderInstancesLoading
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: SizedBox.square(
                                    dimension: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        items: _mediaProviderInstances
                            .map(
                              (instance) => DropdownMenuItem<String>(
                                value: instance,
                                child: Text(_providerInstanceLabel(instance)),
                              ),
                            )
                            .toList(growable: false),
                        onChanged: _mediaSourcesWithProviderInstances.contains(
                                  _mediaSourceProvider,
                                ) &&
                                !_mediaProviderInstancesLoading
                            ? (value) {
                                if (value == null) return;
                                _selectMediaProviderInstance(value);
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<
                          client_enum.ResourceAvailabilityFilter>(
                        initialValue: _mediaAvailability,
                        decoration: const InputDecoration(
                          isDense: true,
                          labelText: '可用性',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: client_enum.ResourceAvailabilityFilter
                                .RESOURCE_AVAILABILITY_FILTER_ALL,
                            child: Text('全部'),
                          ),
                          DropdownMenuItem(
                            value: client_enum.ResourceAvailabilityFilter
                                .RESOURCE_AVAILABILITY_FILTER_AVAILABLE,
                            child: Text('可用'),
                          ),
                          DropdownMenuItem(
                            value: client_enum.ResourceAvailabilityFilter
                                .RESOURCE_AVAILABILITY_FILTER_UNAVAILABLE,
                            child: Text('不可用'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _mediaAvailability = value);
                          _reloadMediaLibrary();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child:
                          DropdownButtonFormField<client_enum.MediaListSortBy>(
                        initialValue: _mediaSortBy,
                        decoration: const InputDecoration(
                          isDense: true,
                          labelText: '排序',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: client_enum
                                .MediaListSortBy.MEDIA_LIST_SORT_BY_POSITION,
                            child: Text('位置'),
                          ),
                          DropdownMenuItem(
                            value: client_enum
                                .MediaListSortBy.MEDIA_LIST_SORT_BY_NAME,
                            child: Text('名称'),
                          ),
                          DropdownMenuItem(
                            value: client_enum
                                .MediaListSortBy.MEDIA_LIST_SORT_BY_ADDED_AT,
                            child: Text('添加时间'),
                          ),
                          DropdownMenuItem(
                            value: client_enum
                                .MediaListSortBy.MEDIA_LIST_SORT_BY_UPDATED_AT,
                            child: Text('更新时间'),
                          ),
                          DropdownMenuItem(
                            value: client_enum.MediaListSortBy
                                .MEDIA_LIST_SORT_BY_SOURCE_PROVIDER,
                            child: Text('来源'),
                          ),
                          DropdownMenuItem(
                            value: client_enum.MediaListSortBy
                                .MEDIA_LIST_SORT_BY_PROVIDER_INSTANCE_NAME,
                            child: Text('实例'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() => _mediaSortBy = value);
                          _reloadMediaLibrary();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.outlined(
                      onPressed: () {
                        setState(() {
                          _mediaSortDirection = _mediaSortDirection ==
                                  client_enum.SortDirection.SORT_DIRECTION_ASC
                              ? client_enum.SortDirection.SORT_DIRECTION_DESC
                              : client_enum.SortDirection.SORT_DIRECTION_ASC;
                        });
                        _reloadMediaLibrary();
                      },
                      icon: Icon(
                        _mediaSortDirection ==
                                client_enum.SortDirection.SORT_DIRECTION_ASC
                            ? Icons.north_rounded
                            : Icons.south_rounded,
                      ),
                      tooltip: _mediaSortDirection ==
                              client_enum.SortDirection.SORT_DIRECTION_ASC
                          ? '升序'
                          : '降序',
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (entries.isEmpty)
            _buildEmptyState('当前目录没有媒体条目', theme)
          else
            ...entries.map((entry) => _buildMediaTile(entry, theme, isDark)),
        ],
      ),
    );
  }

  Widget _buildRealtimeTab(ThemeData theme, bool isDark) {
    return RefreshIndicator(
      onRefresh: () async {
        _settingsWatchVersion = '';
        _membersWatchVersion = '';
        _mediaWatchVersion = '';
        _startResourceWatches();
        await Future.wait([
          _refreshSettingsFromServer(),
          _loadMembers(),
          _loadMediaLibrary(),
        ]);
      },
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32, top: 12),
        children: [
          _buildToolbar(
            title: '实时同步',
            count: 3,
            loading: _membersLoading || _mediaLoading || _isSaving,
            onRefresh: () {
              _settingsWatchVersion = '';
              _membersWatchVersion = '';
              _mediaWatchVersion = '';
              _startResourceWatches();
            },
            theme: theme,
          ),
          _buildRealtimeStatusTile(
            theme,
            isDark,
            icon: Icons.tune_rounded,
            title: '房间设置',
            version: _settingsWatchVersion,
            subtitle: _isSaving ? '正在保存设置' : '监听设置变更',
          ),
          _buildRealtimeStatusTile(
            theme,
            isDark,
            icon: Icons.group_rounded,
            title: '成员列表',
            version: _membersWatchVersion,
            subtitle: _membersLoading ? '正在刷新成员' : '监听成员变更',
          ),
          _buildRealtimeStatusTile(
            theme,
            isDark,
            icon: Icons.video_library_rounded,
            title: '媒体列表',
            version: _mediaWatchVersion,
            subtitle: _mediaLoading ? '正在刷新媒体' : '监听媒体变更',
          ),
        ],
      ),
    );
  }

  Widget _buildChatHistoryTab(ThemeData theme, bool isDark) {
    return RefreshIndicator(
      onRefresh: _loadChatHistory,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32, top: 12),
        children: [
          _buildToolbar(
            title: '聊天历史',
            count: _chatMessages.length,
            loading: _chatLoading,
            onRefresh: _loadChatHistory,
            theme: theme,
            action: _chatCursor.isEmpty
                ? null
                : IconButton(
                    tooltip: '加载更多',
                    onPressed: _chatLoading
                        ? null
                        : () => _loadChatHistory(loadMore: true),
                    icon: const Icon(Icons.more_horiz),
                  ),
          ),
          if (_chatMessages.isEmpty)
            _buildEmptyState('当前没有聊天历史', theme)
          else
            ..._chatMessages.map(
              (message) => _buildChatMessageTile(message, theme, isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildNetworkTab(ThemeData theme, bool isDark) {
    return RefreshIndicator(
      onRefresh: _loadIceServers,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32, top: 12),
        children: [
          _buildToolbar(
            title: 'ICE 服务器',
            count: _iceServers.length,
            loading: _iceLoading,
            onRefresh: _loadIceServers,
            theme: theme,
          ),
          if (_iceServers.isEmpty)
            _buildEmptyState('当前没有 ICE 服务器配置', theme)
          else
            ..._iceServers.map(
              (server) => _buildIceServerTile(server, theme, isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildMediaScope(
    RoomMediaLibraryPage? page,
    ThemeData theme,
    bool isDark,
  ) {
    final label = _mediaScopeLabel(page);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.folder_open, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (page != null)
            Text(
              '${page.folderCount} 目录 / ${page.fileCount} 媒体',
              style: TextStyle(color: theme.hintColor, fontSize: 12),
            ),
        ],
      ),
    );
  }

  Widget _buildMembersTab(ThemeData theme, bool isDark) {
    if (_membersLoading && _members.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: _loadMembers,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 32, top: 12),
        children: [
          _buildToolbar(
            title: '房间成员',
            count: _membersTotal,
            loading: _membersLoading,
            onRefresh: _loadMembers,
            theme: theme,
            action: IconButton(
              tooltip: '添加成员',
              onPressed: _addMember,
              icon: const Icon(Icons.person_add_alt_1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: [
                TextField(
                  controller: _memberSearchController,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _memberSearchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _memberSearchController.clear();
                              setState(() => _membersPage = 1);
                              _loadMembers();
                            },
                            icon: const Icon(Icons.close_rounded),
                            tooltip: '清除搜索',
                          ),
                    labelText: '用户名或用户 ID',
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (_) {
                    setState(() => _membersPage = 1);
                    _loadMembers();
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child:
                          DropdownButtonFormField<common_enum.RoomMemberRole?>(
                        initialValue: _memberRoleFilter,
                        decoration: const InputDecoration(
                          isDense: true,
                          labelText: '角色',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: null,
                            child: Text('全部角色'),
                          ),
                          DropdownMenuItem(
                            value: common_enum
                                .RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR,
                            child: Text('房主'),
                          ),
                          DropdownMenuItem(
                            value: common_enum
                                .RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
                            child: Text('管理员'),
                          ),
                          DropdownMenuItem(
                            value: common_enum
                                .RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
                            child: Text('成员'),
                          ),
                          DropdownMenuItem(
                            value: common_enum
                                .RoomMemberRole.ROOM_MEMBER_ROLE_GUEST,
                            child: Text('访客'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _memberRoleFilter = value;
                            _membersPage = 1;
                          });
                          _loadMembers();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonFormField<
                          client_enum.RoomMemberListSortBy>(
                        initialValue: _memberSortBy,
                        decoration: const InputDecoration(
                          isDense: true,
                          labelText: '排序',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: client_enum.RoomMemberListSortBy
                                .ROOM_MEMBER_LIST_SORT_BY_JOINED_AT,
                            child: Text('加入时间'),
                          ),
                          DropdownMenuItem(
                            value: client_enum.RoomMemberListSortBy
                                .ROOM_MEMBER_LIST_SORT_BY_USERNAME,
                            child: Text('用户名'),
                          ),
                          DropdownMenuItem(
                            value: client_enum.RoomMemberListSortBy
                                .ROOM_MEMBER_LIST_SORT_BY_ROLE,
                            child: Text('角色'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _memberSortBy = value;
                            _membersPage = 1;
                          });
                          _loadMembers();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.outlined(
                      onPressed: () {
                        setState(() {
                          _memberSortDirection = _memberSortDirection ==
                                  client_enum.SortDirection.SORT_DIRECTION_ASC
                              ? client_enum.SortDirection.SORT_DIRECTION_DESC
                              : client_enum.SortDirection.SORT_DIRECTION_ASC;
                          _membersPage = 1;
                        });
                        _loadMembers();
                      },
                      icon: Icon(
                        _memberSortDirection ==
                                client_enum.SortDirection.SORT_DIRECTION_ASC
                            ? Icons.north_rounded
                            : Icons.south_rounded,
                      ),
                      tooltip: _memberSortDirection ==
                              client_enum.SortDirection.SORT_DIRECTION_ASC
                          ? '升序'
                          : '降序',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '第 $_membersPage 页 · 每页 $_membersPageSize · 共 $_membersTotal 条',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: '上一页',
                  icon: const Icon(Icons.chevron_left_rounded),
                  onPressed: _membersPage <= 1
                      ? null
                      : () {
                          setState(() => _membersPage -= 1);
                          _loadMembers();
                        },
                ),
                IconButton(
                  tooltip: '下一页',
                  icon: const Icon(Icons.chevron_right_rounded),
                  onPressed: _membersPage >= _memberPageCount
                      ? null
                      : () {
                          setState(() => _membersPage += 1);
                          _loadMembers();
                        },
                ),
              ],
            ),
          ),
          if (_members.isEmpty)
            _buildEmptyState('当前没有成员', theme)
          else
            ..._members.map(
              (member) => _buildMemberTile(member, theme, isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildToolbar({
    required String title,
    required int count,
    required bool loading,
    required VoidCallback onRefresh,
    required ThemeData theme,
    Widget? action,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 8, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$title · $count',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          if (action != null) action,
          IconButton(
            tooltip: '刷新',
            onPressed: loading ? null : onRefresh,
            icon: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String text, ThemeData theme) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Text(text, style: TextStyle(color: theme.hintColor)),
      ),
    );
  }

  Widget _buildDetailLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Text(
              label,
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamTile(
    RoomStreamEntryInfo stream,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      child: Row(
        children: [
          Icon(
            stream.active ? Icons.sensors : Icons.sensors_off,
            color: stream.active ? Colors.green : theme.disabledColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: () => _showStreamInfo(stream),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stream.mediaId,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _streamSubtitle(stream),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.hintColor, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            tooltip: '查看详情',
            onPressed: () => _showStreamInfo(stream),
            icon: const Icon(Icons.info_outline_rounded),
          ),
          IconButton(
            tooltip: '断开推流',
            onPressed: stream.active ? () => _kickStream(stream) : null,
            icon: const Icon(Icons.link_off),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewTile(
    RoomJoinReviewInfo review,
    ThemeData theme,
    bool isDark,
  ) {
    final isPending =
        review.status == common_enum.ReviewStatus.REVIEW_STATUS_PENDING.value;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  review.username.isEmpty ? review.userId : review.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                _roleLabel(review.requestedRole),
                style: TextStyle(color: theme.hintColor, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${review.userId} · ${_formatTimestamp(review.requestedAt)} · ${_reviewStatusLabel(review.status)}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: theme.hintColor, fontSize: 12),
          ),
          if (review.rejectionReason.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              review.rejectionReason,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
            ),
          ],
          if (isPending) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _rejectReview(review),
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('拒绝'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () => _approveReview(review),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('通过'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMediaTile(WMovie entry, ThemeData theme, bool isDark) {
    final isPersisted =
        entry.id.startsWith('pl_') || entry.id.startsWith('med_');
    final isDynamic = !isPersisted;
    final playlistIndex = entry.id.startsWith('pl_')
        ? _mediaPage?.playlists.indexWhere((item) => item.id == entry.id) ?? -1
        : -1;
    final playlistCount = _mediaPage?.playlists.length ?? 0;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      child: Row(
        children: [
          Icon(
            entry.isFolder
                ? Icons.folder
                : entry.live
                    ? Icons.live_tv
                    : Icons.movie,
            color: entry.isFolder ? Colors.amber.shade700 : theme.primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: InkWell(
              onTap: entry.isFolder ? () => _openMediaEntry(entry) : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _mediaSubtitle(entry),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.hintColor, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          PopupMenuButton<_MediaAction>(
            tooltip: '媒体操作',
            onSelected: (action) {
              switch (action) {
                case _MediaAction.details:
                  _showMediaEntryDetails(entry);
                case _MediaAction.open:
                  _openMediaEntry(entry);
                case _MediaAction.rename:
                  _renameEntry(entry);
                case _MediaAction.moveUp:
                  _movePlaylistRelative(entry, -1);
                case _MediaAction.moveDown:
                  _movePlaylistRelative(entry, 1);
                case _MediaAction.move:
                  _moveMedia(entry);
                case _MediaAction.delete:
                  _deleteEntry(entry);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: _MediaAction.details,
                child: Text('详情'),
              ),
              PopupMenuItem(
                value: _MediaAction.open,
                enabled: entry.isFolder,
                child: const Text('打开'),
              ),
              PopupMenuItem(
                value: _MediaAction.rename,
                enabled: isPersisted,
                child: const Text('重命名'),
              ),
              PopupMenuItem(
                value: _MediaAction.moveUp,
                enabled: playlistIndex > 0,
                child: const Text('上移'),
              ),
              PopupMenuItem(
                value: _MediaAction.moveDown,
                enabled:
                    playlistIndex >= 0 && playlistIndex < playlistCount - 1,
                child: const Text('下移'),
              ),
              PopupMenuItem(
                value: _MediaAction.move,
                enabled: entry.id.startsWith('med_'),
                child: const Text('移动到...'),
              ),
              PopupMenuItem(
                value: _MediaAction.delete,
                enabled: isPersisted && !isDynamic,
                child: const Text('删除'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessageTile(
    RoomChatMessageInfo message,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  message.username.isEmpty ? message.userId : message.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                _formatTimestamp(message.timestamp),
                style: TextStyle(color: theme.hintColor, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(message.content),
          if (message.position != null || message.color != null) ...[
            const SizedBox(height: 6),
            Text(
              [
                if (message.position != null)
                  '${message.position!.toStringAsFixed(1)}s',
                if (message.color != null && message.color!.isNotEmpty)
                  message.color!,
              ].join(' · '),
              style: TextStyle(color: theme.hintColor, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildIceServerTile(
    IceServerInfo server,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.hub),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  server.urls.join(', '),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  server.username.isEmpty ? '匿名' : server.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: theme.hintColor, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealtimeStatusTile(
    ThemeData theme,
    bool isDark, {
    required IconData icon,
    required String title,
    required String version,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  version.isEmpty
                      ? '$subtitle · 尚未收到版本'
                      : '$subtitle · v$version',
                  style: TextStyle(color: theme.hintColor, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(
            version.isEmpty
                ? Icons.sync_problem_rounded
                : Icons.check_circle_rounded,
            color: version.isEmpty ? Colors.orange : Colors.green,
          ),
        ],
      ),
    );
  }

  String _mediaSubtitle(WMovie entry) {
    if (entry.id.startsWith('pl_')) {
      final mode = entry.metadata['is_dynamic'] == true ? '动态播放列表' : '播放列表';
      return '$mode · ${entry.sourceProvider.isEmpty ? 'static' : entry.sourceProvider}';
    }
    if (entry.id.startsWith('med_')) {
      return '${entry.sourceProvider} · ${entry.providerInstanceName.isEmpty ? 'default' : entry.providerInstanceName}';
    }
    final size = entry.metadata['size'];
    return entry.isFolder
        ? '动态目录'
        : '动态媒体${size is int && size > 0 ? ' · $size bytes' : ''}';
  }

  String _compactMap(Map<String, dynamic> value) {
    final entries = value.entries
        .where(
            (entry) => entry.value != null && entry.value.toString().isNotEmpty)
        .take(6)
        .map((entry) => '${entry.key}: ${entry.value}')
        .join('\n');
    if (entries.isEmpty) return '-';
    return value.length > 6 ? '$entries\n…' : entries;
  }

  String _mediaScopeLabel(RoomMediaLibraryPage? page) {
    if (_mediaTarget.isNotEmpty) {
      final path = page?.currentPath.map((node) => node.name).join(' / ') ?? '';
      return path.isEmpty ? '动态目录' : path;
    }
    if (_mediaPlaylistStack.isEmpty) return '根目录';
    final path = page?.currentPath.map((node) => node.name).join(' / ') ?? '';
    return path.isEmpty ? _currentPlaylistId : path;
  }

  Widget _buildMemberTile(
    AdminRoomMember member,
    ThemeData theme,
    bool isDark,
  ) {
    final isCreator = member.role ==
        common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR.value;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            child: Text(
              _memberInitial(member),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.username.isEmpty ? member.userId : member.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_roleLabel(member.role)} · ${member.isOnline ? '在线' : '离线'} · ${_formatTimestamp(member.joinedAt)}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: theme.hintColor, fontSize: 12),
                ),
              ],
            ),
          ),
          PopupMenuButton<_MemberAction>(
            tooltip: '成员操作',
            onSelected: (action) {
              switch (action) {
                case _MemberAction.role:
                  _setMemberRole(member);
                case _MemberAction.permissions:
                  _editMemberPermissionOverrides(member);
                case _MemberAction.transfer:
                  _transferOwnership(member);
                case _MemberAction.kick:
                  _kickMember(member);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _MemberAction.role,
                enabled: !isCreator,
                child: const Text('修改角色'),
              ),
              PopupMenuItem(
                value: _MemberAction.permissions,
                enabled: !isCreator,
                child: const Text('权限覆盖'),
              ),
              PopupMenuItem(
                value: _MemberAction.transfer,
                enabled: !isCreator,
                child: const Text('转让房主'),
              ),
              PopupMenuItem(
                value: _MemberAction.kick,
                enabled: !isCreator,
                child: const Text('移出房间'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoomActions(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Material(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.restart_alt),
              title: const Text('重置房间设置'),
              subtitle: const Text('恢复服务端默认房间策略'),
              onTap: _resetSettings,
            ),
            if (_canLeaveRoom) ...[
              _buildDivider(theme),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('退出房间'),
                subtitle: const Text('退出后需要重新加入才能访问成员内容'),
                onTap: _leaveRoom,
              ),
            ],
            _buildDivider(theme),
            ListTile(
              leading: Icon(Icons.delete_forever_rounded,
                  color: theme.colorScheme.error),
              title: Text(
                '删除房间',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              onTap: _deleteRoom,
            ),
          ],
        ),
      ),
    );
  }

  String _streamSubtitle(RoomStreamEntryInfo stream) {
    if (!stream.active) return '未活跃';
    final publisher =
        stream.publisherUserId.isEmpty ? '未知发布者' : stream.publisherUserId;
    return '$publisher · ${_formatTimestamp(stream.startedAt)}';
  }

  String _roleLabel(int role) {
    return switch (role) {
      1 => '创建者',
      2 => '管理员',
      3 => '成员',
      4 => '访客',
      _ => '未指定',
    };
  }

  String _reviewStatusLabel(int status) {
    return switch (status) {
      1 => '待审核',
      2 => '已通过',
      3 => '已拒绝',
      _ => '未指定',
    };
  }

  String _memberInitial(AdminRoomMember member) {
    final source = member.username.isNotEmpty ? member.username : member.userId;
    return source.isEmpty ? '?' : source.characters.first.toUpperCase();
  }

  String _formatTimestamp(int timestamp) {
    if (timestamp <= 0) return '时间未知';
    final normalized =
        timestamp > 100000000000 ? (timestamp / 1000).round() : timestamp;
    final time = DateTime.fromMillisecondsSinceEpoch(normalized * 1000);
    return '${time.year.toString().padLeft(4, '0')}-'
        '${time.month.toString().padLeft(2, '0')}-'
        '${time.day.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final systemUiOverlayStyle =
        isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF121214) : const Color(0xFFF6F7FB),
        appBar: AppBar(
          title: Text(
            widget.roomName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor:
              isDark ? const Color(0xFF121214) : const Color(0xFFF6F7FB),
          centerTitle: true,
          systemOverlayStyle: systemUiOverlayStyle,
          actions: [
            if (_isSaving)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else
              TextButton(
                onPressed: _saveSettings,
                child: Text(
                  '保存',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final useRail = constraints.maxWidth >= 900;
            if (!useRail) {
              return Column(
                children: [
                  _buildTopTabs(theme),
                  Expanded(child: _buildTabView(theme, isDark)),
                ],
              );
            }

            return Row(
              children: [
                _buildSideNavigation(theme, isDark),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: theme.dividerColor.withValues(alpha: 0.55),
                ),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF151518)
                          : const Color(0xFFF3F5F8),
                    ),
                    child: _buildTabView(theme, isDark),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabView(ThemeData theme, bool isDark) {
    return TabBarView(
      controller: _tabController,
      children: _sections
          .map((section) => section.builder(theme, isDark))
          .toList(growable: false),
    );
  }

  Widget _buildTopTabs(ThemeData theme) {
    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.92),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        indicatorSize: TabBarIndicatorSize.label,
        tabs: _sections
            .map((section) => Tab(
                  icon: Icon(section.icon),
                  text: section.label,
                ))
            .toList(growable: false),
      ),
    );
  }

  Widget _buildSideNavigation(ThemeData theme, bool isDark) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        return SizedBox(
          width: 224,
          child: Material(
            color: isDark ? const Color(0xFF101012) : Colors.white,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 14),
                      child: Text(
                        '房间管理',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.68),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: _sections.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 4),
                        itemBuilder: (context, index) {
                          final section = _sections[index];
                          return _RoomSettingsNavTile(
                            icon: section.icon,
                            label: section.label,
                            selected: _tabController.index == index,
                            onTap: () => setState(() {
                              _tabController.animateTo(index);
                            }),
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
}

enum _MemberAction { role, permissions, transfer, kick }

class _RoomSettingsNavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RoomSettingsNavTile({
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
    return Material(
      color: selected
          ? theme.colorScheme.primary.withValues(alpha: 0.10)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
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
        ),
      ),
    );
  }
}

enum _PermissionOverrideMode { inherit, allow, deny }

class _MemberPermissionOverrideResult {
  final int addedPermissions;
  final int removedPermissions;
  final int adminAddedPermissions;
  final int adminRemovedPermissions;

  const _MemberPermissionOverrideResult({
    required this.addedPermissions,
    required this.removedPermissions,
    required this.adminAddedPermissions,
    required this.adminRemovedPermissions,
  });
}

enum _MediaAction { details, open, rename, moveUp, moveDown, move, delete }

class _MediaMoveTarget {
  final String playlistId;
  final String name;

  const _MediaMoveTarget(this.playlistId, this.name);
}

class _MemberEditResult {
  final String userId;
  final int role;
  final bool notify;

  const _MemberEditResult(this.userId, this.role, this.notify);
}
