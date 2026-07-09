import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:synctv_app/models/direct_url_source_config.dart';
import 'package:synctv_app/models/playback_control_reporter.dart';
import 'package:synctv_app/models/playback_sync_config.dart';
import 'package:synctv_app/models/playback_sync_target.dart';
import 'package:synctv_app/models/realtime_event_log.dart';
import 'package:synctv_app/models/room_management_models.dart';
import 'package:synctv_app/models/synctv_models.dart';
import 'package:synctv_app/models/room_realtime_codec.dart';
import 'package:synctv_app/services/realtime_event_log_preferences.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/services/room_realtime_connection.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/utils/local_image_picker.dart';
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/utils/chat_reactions.dart';
import 'package:synctv_app/utils/chat_playback_danmaku.dart';
import 'package:synctv_app/utils/playback_error_messages.dart';
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/pages/mobile/room_settings_page.dart';
import 'package:synctv_app/widgets/add_media_dialog.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';
import 'package:synctv_app/widgets/app_responsive_layout.dart';
import 'package:synctv_app/widgets/custom_video_player.dart';
import 'package:synctv_app/widgets/playback_empty_state.dart';
import 'package:synctv_app/widgets/playlist_empty_state.dart';
import 'package:synctv_app/widgets/room_invite_actions.dart';
import 'package:synctv_app/widgets/realtime_event_log_view.dart';
import 'package:synctv_app/widgets/chat_input_area.dart';
import 'package:synctv_app/widgets/chat_read_receipts_dialog.dart';
import 'package:synctv_app/widgets/chat_reaction_users_dialog.dart';
import 'package:synctv_app/managers/webrtc_manager.dart';
import 'package:synctv_app/models/danmaku_model.dart';
import 'package:synctv_app/src/generated/proto/client.pb.dart' as client;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;

class RoomScreen extends StatefulWidget {
  final SyncTvRoom room;

  const RoomScreen({super.key, required this.room});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

enum _PlaylistViewMode { compact, detailed, grid }

class _RoomScreenState extends State<RoomScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PlaybackSyncConfig _playbackSyncConfig;
  VideoPlayerController? _videoPlayerController;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final List<RoomRealtimeChatEntry> _messages = [];
  final List<RoomRealtimeChatEntry> _pinnedMessages = [];
  final Map<String, RoomRealtimeChatEntry> _chatMessageCache = {};
  final Map<String, GlobalKey> _chatMessageKeys = {};
  final Map<String, ChatMessageReadReceiptsInfo> _chatReceiptCache = {};
  final Set<String> _loadingReplyMessageIds = {};
  final Set<String> _chatReceiptLoadingIds = {};
  final List<RealtimeEventLogEntry> _realtimeEvents = [];
  PickedLocalImage? _selectedChatImage;
  RoomRealtimeChatEntry? _replyingToMessage;
  bool _sendingChatMessage = false;
  final StreamController<RoomRealtimeMessage> _realtimeMessageBus =
      StreamController<RoomRealtimeMessage>.broadcast();
  final StreamController<RealtimeEventLogEntry> _realtimeEventBus =
      StreamController<RealtimeEventLogEntry>.broadcast();
  final StreamController<void> _realtimeReconnectBus =
      StreamController<void>.broadcast();
  String _lastChatEventId = '';
  String? _hoveredChatMessageId;
  String? _activeChatMessageId;
  String? _expandedChatActionMessageId;
  String? _highlightedChatMessageId;
  Timer? _syncTimer;
  Timer? _diagnosticsTimer;
  Timer? _chatHighlightTimer;
  SyncTvPlaybackStatus? _currentStatus;
  RoomRealtimeConnection? _channel;
  List<SyncTvUser> _members = [];
  List<SyncTvUser> _mentionCandidates = [];
  List<ChatMentionInfo> _pendingChatMentions = [];
  AdminRoomMember? _selfMember;
  int _roomOnlineCount = 0;
  bool _membersLoading = false;
  bool _pinnedMessagesLoading = false;
  bool _memberEventsObserved = false;
  bool _mentionCandidatesLoading = false;
  String _mentionCandidateQuery = '';
  int _mentionCandidatePage = 0;
  bool _mentionCandidatesHasMore = true;
  List<RoomMediaEntry> _mediaEntries = [];
  bool _isLoadingMediaEntries = true;
  bool _isVideoLoading = false;
  String? _videoError;
  String? _roomSessionError;
  int _videoInitGeneration = 0;

  // Pagination
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMoreMediaEntries = true;
  bool _isLoadingMoreMediaEntries = false;
  final ScrollController _mediaEntryScrollController = ScrollController();

  // Folder navigation
  final List<RoomMediaEntry> _folderStack = [];
  final List<String> _folderNameStack = ['根目录'];

  SyncTvUser? _currentUser;
  bool _showChatScrollToBottom = false;

  // Sync state
  bool _isSyncing = false;
  bool _serverTimeSyncInFlight = false;
  bool _joiningVoice = false;
  final Set<String> _warnedPlaybackCredentialHeaderKeys = {};
  PlaybackDanmakuWindow? _playbackDanmakuWindow;
  bool _loadingPlaybackDanmaku = false;

  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;

  StreamSubscription? _realtimeSubscription;
  StreamSubscription? _authErrorSubscription;

  WebRTCManager? _webrtcManager;

  // Danmaku Stream
  final DanmakuController _danmakuController = DanmakuController();

  bool _isSelectionMode = false;
  final Set<String> _selectedMediaEntryIds = {};
  int _roomTabIndex = 0;
  _PlaylistViewMode _playlistViewMode = _PlaylistViewMode.compact;

  bool get _showRealtimeDebugTab => kDebugMode;
  int get _roomTabCount => 3 + (_showRealtimeDebugTab ? 1 : 0);
  bool get _canManageRoom {
    final user = _currentUser;
    if (user == null) return false;
    if (user.id.isNotEmpty && user.id == widget.room.creatorId) return true;
    final isSystemAdmin =
        user.role == common_enum.UserRole.USER_ROLE_ROOT.value ||
        user.role == common_enum.UserRole.USER_ROLE_ADMIN.value;
    if (isSystemAdmin) return true;
    final selfRole = _selfMember?.role;
    return selfRole ==
            common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR.value ||
        selfRole == common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value;
  }

  bool get _isCurrentPlaybackLive => _currentStatus?.entry?.live == true;

  @override
  void initState() {
    super.initState();
    _playbackSyncConfig = SyncTvService.playbackSyncConfig;
    _chatScrollController.addListener(_handleChatScroll);
    _authErrorSubscription = SyncTvService.onAuthError.listen((_) {
      if (mounted) {
        _handleRoomSessionClosed('登录已过期，请重新登录');
      }
    });
    _tabController = TabController(length: _roomTabCount, vsync: this);
    _tabController.addListener(_handleRoomTabChanged);
    RealtimeEventLogPreferences.maxEntries.addListener(
      _handleRealtimeLogMaxEntriesChanged,
    );
    RealtimeEventLogPreferences.load().then((_) {
      if (mounted) _handleRealtimeLogMaxEntriesChanged();
    });

    // Initialize WebRTC Manager
    _webrtcManager = WebRTCManager(
      loadIceServers: () => _loadWebRtcIceServers(),
      onSignalingMessage: (type, data) {
        if (_channel != null) {
          try {
            final bytes = RoomRealtimeCodec.encodeWebRtcSignal(type, data);
            _sendRealtimeMessage(bytes);
          } catch (e) {
            debugPrint('WebRTC encode error: $e');
          }
        }
      },
      onStateChange: () {
        if (mounted) setState(() {});
      },
    );

    _mediaEntryScrollController.addListener(_onMediaEntryScroll);
    _startDiagnosticsTimers();
    _joinRoom();
  }

  void _startDiagnosticsTimers() {
    unawaited(_syncRoomServerTime());
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      unawaited(_syncRoomServerTime());
    });
    _diagnosticsTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (!mounted) return;
      if (_currentStatus?.entry != null &&
          _videoPlayerController?.value.isInitialized == true) {
        setState(() {});
      }
    });
  }

  Future<void> _syncRoomServerTime() async {
    if (_serverTimeSyncInFlight) return;
    _serverTimeSyncInFlight = true;
    try {
      await SyncTvService.syncServerTime(refresh: true);
    } finally {
      _serverTimeSyncInFlight = false;
      if (mounted) setState(() {});
    }
  }

  Future<void> _joinRoom() async {
    _connectRealtime();

    Future.wait([
      _fetchCurrentUser(),
      _loadChatHistory(),
      _loadPinnedChatMessages(),
      _loadMentionCandidates(query: ''),
    ]).catchError((e) {
      debugPrint('Background data fetch error: $e');
      return <void>[];
    });
  }

  Future<void> _handleRoomSessionClosed(String message) async {
    _reconnectTimer?.cancel();
    _disposeVideoController();
    await _realtimeSubscription?.cancel();
    _realtimeSubscription = null;
    await _channel?.sink.close();
    _channel = null;
    _webrtcManager?.leave();
    if (!mounted) return;
    setState(() {
      _roomSessionError = message;
      _isVideoLoading = false;
      _isSyncing = false;
    });
    MessageUtils.showError(context, message);
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final user = await SyncTvService.getMe();
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    } catch (e) {
      debugPrint('Fetch user error: $e');
    }
  }

  Future<void> _loadChatHistory() async {
    try {
      final page = await SyncTvService.getChatHistory(
        widget.room.roomId,
        limit: 100,
      );
      final history = page.messages
          .map(RoomRealtimeChatEntry.fromHistory)
          .where((entry) => !entry.isDeleted)
          .toList()
          .reversed;
      if (mounted) {
        setState(() {
          _messages.prependUnique(history, maxEntries: 100);
          _indexChatMessages(history);
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('Fetch chat history error: $e');
    }
  }

  Future<void> _loadPinnedChatMessages() async {
    if (!mounted) return;
    setState(() => _pinnedMessagesLoading = true);
    try {
      final pinned = await SyncTvService.listPinnedChatMessages(
        widget.room.roomId,
        limit: 20,
      );
      final entries =
          pinned
              .map(
                (entry) => RoomRealtimeChatEntry.fromHistory(
                  entry.message.copyWith(pin: entry.pin),
                ),
              )
              .where((entry) => !entry.isDeleted && entry.isPinned)
              .toList()
            ..sort(_comparePinnedMessages);
      if (!mounted) return;
      setState(() {
        _pinnedMessages
          ..clear()
          ..addAll(entries);
        _indexChatMessages(entries);
      });
    } catch (e) {
      debugPrint('Fetch pinned chat messages error: $e');
    } finally {
      if (mounted) setState(() => _pinnedMessagesLoading = false);
    }
  }

  Future<void> _loadCurrentPlayback() async {
    try {
      final status = await SyncTvService.getCurrentMedia(widget.room.roomId);
      if (!mounted) return;
      await _applyPlaybackStatus(
        _mergePlaybackStatus(
          status,
          incomingHasTiming: status.entry?.url.isEmpty != true,
        ),
      );
    } catch (e) {
      debugPrint('Load current playback error: $e');
    }
  }

  void _sortMembers(List<SyncTvUser> members) {
    members.sort((a, b) {
      if (a.id == widget.room.creatorId) return -1;
      if (b.id == widget.room.creatorId) return 1;
      final aAdmin =
          a.role == common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value;
      final bAdmin =
          b.role == common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value;
      if (aAdmin && !bAdmin) return -1;
      if (!aAdmin && bAdmin) return 1;
      return 0;
    });
  }

  Future<List<IceServerInfo>> _loadWebRtcIceServers() {
    return SyncTvService.getIceServers(widget.room.roomId);
  }

  void _onMediaEntryScroll() {
    if (_mediaEntryScrollController.position.pixels >=
        _mediaEntryScrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMoreMediaEntries && _hasMoreMediaEntries) {
        _loadMoreMediaEntries();
      }
    }
  }

  Future<void> _loadMoreMediaEntries() async {
    if (_isLoadingMoreMediaEntries) return;

    setState(() {
      _isLoadingMoreMediaEntries = true;
    });

    try {
      final parentFolder = _folderStack.isNotEmpty ? _folderStack.last : null;
      final result = await SyncTvService.listMediaLibrary(
        widget.room.roomId,
        playlistId: parentFolder?.playbackPlaylistId ?? '',
        target: parentFolder?.playbackTarget,
        page: _currentPage + 1,
        pageSize: _pageSize,
      );

      final entries = result.entries;
      final total = result.total;

      if (mounted) {
        setState(() {
          if (entries.isNotEmpty) {
            _mediaEntries.addAll(entries);
            _currentPage++;
            _hasMoreMediaEntries = _mediaEntries.length < total;
          } else {
            _hasMoreMediaEntries = false;
          }
          _isLoadingMoreMediaEntries = false;
        });
      }
    } catch (e) {
      debugPrint('Load more media entries error: $e');
      if (mounted) {
        setState(() {
          _isLoadingMoreMediaEntries = false;
        });
      }
    }
  }

  Future<void> _connectRealtime() async {
    _reconnectTimer?.cancel();

    try {
      await _realtimeSubscription?.cancel();
      _realtimeSubscription = null;
      await _channel?.sink.close();
      _channel = null;
      _channel = RoomRealtimeConnection.connect(
        widget.room.roomId,
        initialMessages: RoomRealtimeCodec.encodeInitialObservations(
          afterChatEventId: _lastChatEventId,
        ),
        onOutgoing: _recordRealtimeOutgoing,
        onIncoming: _recordRealtimeIncoming,
      );
      if (!_realtimeReconnectBus.isClosed) {
        _realtimeReconnectBus.add(null);
      }
      _syncMemberTabObservation();
      unawaited(_loadCurrentPlayback());

      _realtimeSubscription = _channel!.stream.listen(
        (data) {
          _reconnectAttempts = 0;
          try {
            final message = RoomRealtimeCodec.decode(data);
            if (!_realtimeMessageBus.isClosed) {
              _realtimeMessageBus.add(message);
            }
            _handleRealtimeMessage(message);
          } catch (e) {
            debugPrint('Proto decode error: $e');
          }
        },
        onError: (error) {
          debugPrint('Realtime stream error: $error');
          _channel = null;
          _scheduleReconnect();
        },
        onDone: () {
          debugPrint('Realtime stream closed');
          _channel = null;
          _scheduleReconnect();
        },
      );
    } catch (e) {
      debugPrint('Realtime stream connection error: $e');
      _scheduleReconnect();
    }
  }

  void _recordRealtimeIncoming(Uint8List bytes) {
    final entry = RoomRealtimeCodec.describeIncoming(bytes);
    if (!_realtimeEventBus.isClosed) _realtimeEventBus.add(entry);
    if (!_showRealtimeDebugTab || !mounted) return;
    _appendRealtimeEvent(entry);
  }

  void _recordRealtimeOutgoing(
    List<int> bytes, [
    client.ClientMessage? message,
  ]) {
    final entry = message == null
        ? RoomRealtimeCodec.describeOutgoing(bytes)
        : RoomRealtimeCodec.describeOutgoingMessage(
            message,
            byteLength: bytes.length,
          );
    if (!_realtimeEventBus.isClosed) _realtimeEventBus.add(entry);
    if (!_showRealtimeDebugTab || !mounted) return;
    _appendRealtimeEvent(entry);
  }

  void _sendRealtimeMessage(List<int> bytes) {
    if (bytes.isEmpty) return;
    final channel = _channel;
    if (channel == null) {
      _scheduleReconnect();
      return;
    }
    try {
      channel.sink.add(bytes);
    } catch (e) {
      debugPrint('Realtime send error: $e');
      _channel = null;
      _scheduleReconnect();
    }
  }

  void _appendRealtimeEvent(RealtimeEventLogEntry entry) {
    setState(() {
      _realtimeEvents.add(entry);
      _trimRealtimeEvents();
    });
  }

  void _handleRealtimeLogMaxEntriesChanged() {
    if (!mounted) return;
    setState(_trimRealtimeEvents);
  }

  void _trimRealtimeEvents() {
    final maxEntries = RealtimeEventLogPreferences.maxEntries.value;
    if (_realtimeEvents.length > maxEntries) {
      _realtimeEvents.removeRange(0, _realtimeEvents.length - maxEntries);
    }
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      if (mounted) MessageUtils.showError(context, '连接断开，请退出重试');
      return;
    }

    _reconnectAttempts++;
    final delay = Duration(seconds: _reconnectAttempts * 2);
    debugPrint(
      'Scheduling reconnect attempt $_reconnectAttempts in ${delay.inSeconds}s',
    );

    _reconnectTimer = Timer(delay, () {
      if (mounted) {
        _connectRealtime();
      }
    });
  }

  void _handleRealtimeMessage(RoomRealtimeMessage message) {
    final type = message.kind;

    if (type == RoomRealtimeMessageKind.chat) {
      final content = message.chatContent;
      final chatEntry = _chatEntryFromRealtimeMessage(message);
      final username = chatEntry.username;
      if (message.chatEventId.isNotEmpty) {
        _lastChatEventId = message.chatEventId;
      }

      if (message.isChatCreated &&
          _videoPlayerController != null &&
          _videoPlayerController!.value.isInitialized) {
        final currentPos = _videoPlayerController!.value.position;
        final danmaku = DanmakuItem(
          text: chatTextWithReactionSummary(
            username: username,
            content: content,
            reactions: message.reactions,
          ),
          startTime: currentPos,
          endTime: currentPos + const Duration(seconds: 8),
          color: Colors.white,
          type: DanmakuType.floating,
        );
        _danmakuController.add(danmaku);
      }

      final shouldAutoScroll = _isChatNearBottom();
      if (mounted) {
        setState(() {
          _messages.applyRealtimeEvent(
            chatEntry,
            eventKind: message.chatEventKind,
            maxEntries: 100,
          );
          _indexChatMessage(chatEntry);
          if (chatEntry.isDeleted) {
            _chatReceiptCache.remove(chatEntry.id);
            _chatMessageKeys.remove(chatEntry.id);
            _pinnedMessages.removeWhere((entry) => entry.id == chatEntry.id);
            if (_replyingToMessage?.id == chatEntry.id) {
              _replyingToMessage = null;
            }
          } else {
            _syncPinnedChatEntryFromRealtime(chatEntry);
          }
        });
        if (shouldAutoScroll) {
          _scrollToBottom();
        } else if (!_showChatScrollToBottom) {
          setState(() => _showChatScrollToBottom = true);
        }
      }
    } else if (type == RoomRealtimeMessageKind.chatPin) {
      final event = message.chatPinEvent;
      if (event == null) return;
      if (mounted) {
        setState(() => _applyChatPinEvent(event));
      }
    } else if (type == RoomRealtimeMessageKind.sync ||
        type == RoomRealtimeMessageKind.status ||
        type == RoomRealtimeMessageKind.checkStatus) {
      final playbackStatus = message.playbackStatus;
      if (playbackStatus != null) {
        final shouldLoadSnapshot = _needsPlaybackResourceSnapshot(
          playbackStatus,
        );
        _applyPlaybackStatus(
          _mergePlaybackStatus(playbackStatus, incomingHasTiming: true),
        );
        if (shouldLoadSnapshot) {
          unawaited(_loadCurrentPlayback());
        }
      } else if (message.status != null) {
        final status = message.status!;
        _applyPlaybackStatus(
          SyncTvPlaybackStatus(
            entry: _currentStatus?.entry,
            isPlaying: status.isPlaying,
            currentTime: status.currentTime,
            playbackRate: status.playbackRate,
            generatedAtMillis: SyncTvService.serverNowMillis(),
          ),
        );
      }
    } else if (type == RoomRealtimeMessageKind.current) {
      final playbackStatus = message.playbackStatus;
      if (playbackStatus == null) {
        _reportInvalidRealtimePayload('播放资源');
      } else {
        _applyPlaybackStatus(
          _mergePlaybackStatus(playbackStatus, incomingHasTiming: false),
        );
      }
    } else if (type == RoomRealtimeMessageKind.roomSettings) {
      if (!_isPrimaryResourceMessage(message, 'room_settings')) return;
      return;
    } else if (type == RoomRealtimeMessageKind.myStatus) {
      if (!_isPrimaryResourceMessage(message, 'self_room_member')) return;
      if (mounted) {
        setState(() => _selfMember = message.selfMember);
      }
      return;
    } else if (type == RoomRealtimeMessageKind.memberEvent) {
      if (_isPrimaryResourceMessage(message, 'room_member_events')) {
        _observeRoomMembers();
      }
      return;
    } else if (type == RoomRealtimeMessageKind.mediaLibrary) {
      if (!_isPrimaryResourceMessage(message, 'playlist_items')) return;
      final mediaLibrary = message.mediaLibrary;
      if (mediaLibrary == null) {
        if (message.resourceObserveId.isEmpty) {
          _observeCurrentPlaylist();
        } else {
          _reportInvalidRealtimePayload('播放列表');
        }
      } else {
        _applyMediaLibrary(mediaLibrary);
      }
    } else if (type == RoomRealtimeMessageKind.viewerCount) {
      if (!_isPrimaryResourceMessage(message, 'online_count')) return;
      final members = message.members;
      if (members == null) {
        if (mounted) setState(() => _roomOnlineCount = message.resourceTotal);
      } else {
        _applyMembers(members);
      }
    } else if (type == RoomRealtimeMessageKind.error) {
      if (message.resourceObserveId.isNotEmpty &&
          !_isPrimaryObserveId(message.resourceObserveId)) {
        return;
      }
      final errorMsg = message.error?.message ?? '';
      if (errorMsg.isNotEmpty && mounted) {
        MessageUtils.showError(context, '错误: $errorMsg');
      }
    } else if (type == RoomRealtimeMessageKind.expired) {
      if (mounted) {
        _handleRoomSessionClosed('登录已过期，请重新登录');
      }
    } else if (type == RoomRealtimeMessageKind.webrtcOffer ||
        type == RoomRealtimeMessageKind.webrtcAnswer ||
        type == RoomRealtimeMessageKind.webrtcIceCandidate ||
        type == RoomRealtimeMessageKind.webrtcJoin ||
        type == RoomRealtimeMessageKind.webrtcLeave) {
      if (_webrtcManager != null) {
        final signal = message.webRtc;
        if (signal == null) return;

        try {
          final signalType = signal.signalType;
          if (signalType.isNotEmpty) {
            _webrtcManager!.handleSignalingMessage(
              signalType,
              signal.payload(),
            );
          }
        } catch (e) {
          debugPrint('WebRTC signaling processing error: $e');
        }
      }
    }
  }

  RoomRealtimeChatEntry _chatEntryFromRealtimeMessage(
    RoomRealtimeMessage message,
  ) {
    final currentUser = _currentUser;
    final isCurrentUserMessage =
        currentUser != null &&
        message.senderUserId.isNotEmpty &&
        message.senderUserId == currentUser.id;
    final username = message.senderUsername.isNotEmpty
        ? message.senderUsername
        : isCurrentUserMessage
        ? currentUser.username
        : 'Unknown';
    return RoomRealtimeChatEntry(
      id: message.chatId,
      userId: message.senderUserId,
      username: username,
      content: message.chatContent,
      images: message.images,
      reactions: message.reactions,
      reactionCount: message.reactionCount,
      mentions: message.mentions,
      pin: message.chatPinEvent?.pin,
      timestampMillis: message.timestampMillis == 0
          ? SyncTvService.serverNowMillis()
          : message.timestampMillis,
      isDeleted: message.isChatDeleted,
      isEdited: message.isChatEdited,
      replyToMessageId: message.chatReplyToMessageId,
    );
  }

  void _indexChatMessage(RoomRealtimeChatEntry message) {
    if (message.id.isEmpty) return;
    if (message.isDeleted) {
      _chatMessageCache.remove(message.id);
      _chatReceiptCache.remove(message.id);
      _chatMessageKeys.remove(message.id);
      return;
    }
    _chatMessageCache[message.id] = message;
  }

  void _indexChatMessages(Iterable<RoomRealtimeChatEntry> messages) {
    for (final message in messages) {
      _indexChatMessage(message);
    }
  }

  void _applyChatPinEvent(ChatPinEventInfo event) {
    final clearPin =
        event.kind ==
            client_enum.ChatPinEventKind.CHAT_PIN_EVENT_KIND_UNPINNED.value ||
        event.kind ==
            client_enum
                .ChatPinEventKind
                .CHAT_PIN_EVENT_KIND_MESSAGE_DELETED
                .value;
    final pin = clearPin ? null : event.pin;
    final eventEntry = RoomRealtimeChatEntry.fromHistory(
      event.message.copyWith(pin: pin, clearPin: clearPin),
    );
    final index = _messages.indexWhere((entry) => entry.id == event.message.id);
    if (index >= 0) {
      final updated = _messages[index].copyWith(pin: pin, clearPin: clearPin);
      _messages[index] = updated;
      _indexChatMessage(updated);
    } else {
      _indexChatMessage(eventEntry);
    }
    final cached = _chatMessageCache[event.message.id];
    if (cached != null) {
      _chatMessageCache[event.message.id] = cached.copyWith(
        pin: pin,
        clearPin: clearPin,
      );
    }
    _applyPinnedChatEntry(eventEntry, clearPin: clearPin);
  }

  void _applyPinnedChatEntry(
    RoomRealtimeChatEntry entry, {
    required bool clearPin,
  }) {
    if (entry.id.isEmpty) return;
    _pinnedMessages.removeWhere((message) => message.id == entry.id);
    if (!clearPin && entry.isPinned && !entry.isDeleted) {
      _pinnedMessages.add(entry);
      _pinnedMessages.sort(_comparePinnedMessages);
    }
  }

  void _syncPinnedChatEntryFromRealtime(RoomRealtimeChatEntry entry) {
    if (entry.id.isEmpty) return;
    final index = _pinnedMessages.indexWhere(
      (message) => message.id == entry.id,
    );
    if (index < 0) return;
    final pinned = _pinnedMessages[index];
    _pinnedMessages[index] = entry.copyWith(pin: pinned.pin);
    _pinnedMessages.sort(_comparePinnedMessages);
  }

  int _comparePinnedMessages(RoomRealtimeChatEntry a, RoomRealtimeChatEntry b) {
    final pinnedAtCompare =
        b.pin?.pinnedAt.compareTo(a.pin?.pinnedAt ?? 0) ?? 0;
    if (pinnedAtCompare != 0) return pinnedAtCompare;
    return b.timestampMillis.compareTo(a.timestampMillis);
  }

  RoomRealtimeChatEntry? _replyPreviewFor(RoomRealtimeChatEntry message) {
    final replyId = message.replyToMessageId;
    if (replyId.isEmpty) return null;
    final cached = _chatMessageCache[replyId];
    if (cached != null) return cached;
    _ensureReplyPreviewLoaded(replyId);
    return null;
  }

  void _ensureReplyPreviewLoaded(String messageId) {
    if (messageId.isEmpty ||
        _chatMessageCache.containsKey(messageId) ||
        _loadingReplyMessageIds.contains(messageId)) {
      return;
    }
    _loadingReplyMessageIds.add(messageId);
    unawaited(() async {
      try {
        final message = await SyncTvService.getChatMessage(
          widget.room.roomId,
          messageId,
          includeDeleted: true,
        );
        final entry = RoomRealtimeChatEntry.fromHistory(message);
        if (!mounted) return;
        setState(() => _indexChatMessage(entry));
      } catch (e) {
        debugPrint('Load reply preview error: $e');
      } finally {
        _loadingReplyMessageIds.remove(messageId);
      }
    }());
  }

  String _chatPreviewText(RoomRealtimeChatEntry message) {
    if (message.isDeleted) return '消息已删除';
    final text = message.content.trim();
    if (text.isNotEmpty) return text;
    if (message.images.isNotEmpty) return '[图片]';
    return '[消息]';
  }

  GlobalKey _chatMessageKey(String messageId) {
    return _chatMessageKeys.putIfAbsent(messageId, GlobalKey.new);
  }

  Future<void> _jumpToChatMessage(String messageId) async {
    if (messageId.isEmpty) return;
    var index = _messages.indexWhere((message) => message.id == messageId);
    if (index < 0) {
      await _loadChatMessageContext(messageId);
      if (!mounted) return;
      index = _messages.indexWhere((message) => message.id == messageId);
    }
    if (index < 0) {
      MessageUtils.showInfo(context, '引用消息不在当前可查看范围');
      return;
    }
    _highlightChatMessage(messageId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetContext = _chatMessageKeys[messageId]?.currentContext;
      if (targetContext != null) {
        Scrollable.ensureVisible(
          targetContext,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          alignment: 0.28,
        );
        return;
      }
      if (!_chatScrollController.hasClients || _messages.length <= 1) return;
      final maxScroll = _chatScrollController.position.maxScrollExtent;
      final offset = maxScroll * (index / (_messages.length - 1));
      _chatScrollController.animateTo(
        offset.clamp(0.0, maxScroll),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    });
  }

  Future<void> _loadChatMessageContext(String messageId) async {
    try {
      final contextInfo = await SyncTvService.getChatMessageContext(
        widget.room.roomId,
        messageId,
        beforeLimit: 30,
        afterLimit: 30,
        includeDeleted: true,
      );
      final entries =
          [...contextInfo.before, contextInfo.message, ...contextInfo.after]
              .map(RoomRealtimeChatEntry.fromHistory)
              .where((entry) => !entry.isDeleted);
      if (!mounted) return;
      setState(() {
        for (final entry in entries) {
          _messages.applyRealtimeEvent(
            entry,
            eventKind: RoomRealtimeChatEventKind.created,
            maxEntries: 160,
          );
          _indexChatMessage(entry);
        }
        _messages.sort(
          (a, b) => a.timestampMillis.compareTo(b.timestampMillis),
        );
      });
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '加载引用上下文失败: $e');
    }
  }

  void _highlightChatMessage(String messageId) {
    _chatHighlightTimer?.cancel();
    setState(() => _highlightedChatMessageId = messageId);
    _chatHighlightTimer = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted || _highlightedChatMessageId != messageId) return;
      setState(() => _highlightedChatMessageId = null);
    });
  }

  bool _isPrimaryResourceMessage(
    RoomRealtimeMessage message,
    String observeId,
  ) {
    return message.resourceObserveId.isEmpty ||
        message.resourceObserveId == observeId;
  }

  bool _isPrimaryObserveId(String observeId) {
    return observeId == 'room_settings' ||
        observeId == 'playlist_items' ||
        observeId == 'room_member_events' ||
        observeId == 'self_room_member' ||
        observeId == 'online_count' ||
        observeId == 'playback_state' ||
        observeId == 'playback';
  }

  SyncTvPlaybackStatus _mergePlaybackStatus(
    SyncTvPlaybackStatus incoming, {
    required bool incomingHasTiming,
  }) {
    final current = _currentStatus;
    final incomingEntry = incoming.entry;
    final currentEntry = current?.entry;
    final hasSameEntry =
        currentEntry != null &&
        incomingEntry != null &&
        currentEntry.hasSamePlaybackIdentity(incomingEntry);
    final mergedEntry = incomingEntry == null
        ? incomingHasTiming
              ? null
              : currentEntry
        : incomingEntry.url.isEmpty &&
              currentEntry != null &&
              currentEntry.url.isNotEmpty &&
              hasSameEntry
        ? currentEntry
        : hasSameEntry
        ? incomingEntry.url.isEmpty
              ? currentEntry
              : incomingEntry.withPlaybackIdentityFrom(currentEntry)
        : incomingEntry;
    return SyncTvPlaybackStatus(
      entry: mergedEntry,
      isPlaying: incomingHasTiming
          ? incoming.isPlaying
          : current?.isPlaying ?? incoming.isPlaying,
      currentTime: incomingHasTiming
          ? incoming.currentTime
          : current?.currentTime ?? incoming.currentTime,
      playbackRate: incomingHasTiming
          ? incoming.playbackRate
          : current?.playbackRate ?? incoming.playbackRate,
      generatedAtMillis: incomingHasTiming
          ? incoming.generatedAtMillis
          : current?.generatedAtMillis ?? incoming.generatedAtMillis,
      version: incoming.version ?? current?.version,
      playingMediaId: incoming.playingMediaId.isNotEmpty
          ? incoming.playingMediaId
          : current?.playingMediaId ?? incoming.playingMediaId,
      playingPlaylistId: incoming.playingPlaylistId.isNotEmpty
          ? incoming.playingPlaylistId
          : current?.playingPlaylistId ?? incoming.playingPlaylistId,
      targetHash: incoming.targetHash.isNotEmpty
          ? incoming.targetHash
          : current?.targetHash ?? incoming.targetHash,
    );
  }

  bool _needsPlaybackResourceSnapshot(SyncTvPlaybackStatus incoming) {
    if (incoming.entry != null && incoming.entry!.url.isNotEmpty) {
      return false;
    }
    final current = _currentStatus;
    final incomingHasTarget =
        incoming.playingMediaId.isNotEmpty ||
        incoming.playingPlaylistId.isNotEmpty ||
        incoming.targetHash.isNotEmpty;
    if (!incomingHasTarget) return false;
    if (current == null || current.entry == null) return true;
    return (incoming.playingMediaId.isNotEmpty &&
            incoming.playingMediaId != current.playingMediaId) ||
        (incoming.playingPlaylistId.isNotEmpty &&
            incoming.playingPlaylistId != current.playingPlaylistId) ||
        (incoming.targetHash.isNotEmpty &&
            incoming.targetHash != current.targetHash);
  }

  void _applyMediaLibrary(RoomMediaLibraryPage mediaLibrary) {
    if (!mounted) return;
    setState(() {
      _mediaEntries = mediaLibrary.entries;
      _currentPage = 1;
      _hasMoreMediaEntries = mediaLibrary.total > _mediaEntries.length;
      _isLoadingMediaEntries = false;
      _selectedMediaEntryIds.removeWhere(
        (id) => !_mediaEntries.any((entry) => entry.id == id),
      );
      if (_selectedMediaEntryIds.isEmpty) _isSelectionMode = false;
    });
  }

  void _applyMembers(List<SyncTvUser> members) {
    if (!mounted) return;
    _sortMembers(members);
    setState(() {
      _members = members;
    });
  }

  void _reportInvalidRealtimePayload(String resourceName) {
    final message = '服务端未推送$resourceName快照';
    debugPrint(message);
    if (mounted) MessageUtils.showError(context, message);
  }

  Future<void> _performSync(
    SyncTvPlaybackStatus status, {
    bool forceSeek = false,
  }) async {
    final controller = _videoPlayerController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    _isSyncing = true;

    try {
      if (controller.value.playbackSpeed != status.playbackRate) {
        await controller.setPlaybackSpeed(status.playbackRate);
        if (!mounted || !identical(_videoPlayerController, controller)) return;
        _refreshPlaybackUi(controller);
      }

      final isLive = status.entry?.live == true;
      final target = isLive ? null : _playbackSyncTarget(status, controller);
      final targetIsPlaying = target?.isAtEnd == true
          ? false
          : status.isPlaying;
      if (!targetIsPlaying && controller.value.isPlaying) {
        await controller.pause();
        if (!mounted || !identical(_videoPlayerController, controller)) return;
        _refreshPlaybackUi(controller);
      }
      if (target != null) {
        final currentPos = controller.value.position.inMilliseconds / 1000.0;
        final positionDrift = (currentPos - target.positionSeconds).abs();
        final shouldAutoSeek =
            _playbackSyncConfig.autoSyncEnabled &&
            positionDrift > _playbackSyncConfig.autoSeekDriftThresholdSeconds;
        final shouldManualSeek =
            forceSeek &&
            positionDrift >=
                _playbackSyncConfig.manualSeekDriftThresholdSeconds;
        if (target.isAtEnd || shouldManualSeek || shouldAutoSeek) {
          await controller.seekTo(
            Duration(milliseconds: (target.positionSeconds * 1000).toInt()),
          );
          if (!mounted || !identical(_videoPlayerController, controller)) {
            return;
          }
          _refreshPlaybackUi(controller);
        }
      }

      if (targetIsPlaying && controller.value.isPlaying == false) {
        await controller.play();
        if (!mounted || !identical(_videoPlayerController, controller)) return;
        _refreshPlaybackUi(controller);
      }
      _refreshPlaybackUi(controller);
    } catch (e) {
      if (!_isDisposedVideoControllerError(e)) {
        debugPrint('Sync execution error: $e');
      }
    } finally {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) _isSyncing = false;
      });
    }
  }

  PlaybackSyncTarget _playbackSyncTarget(
    SyncTvPlaybackStatus status,
    VideoPlayerController controller,
  ) {
    return resolvePlaybackSyncTarget(
      status: status,
      duration: controller.value.duration,
    );
  }

  double? _playbackDeviationSeconds() {
    final status = _currentStatus;
    final controller = _videoPlayerController;
    if (status == null ||
        status.entry == null ||
        status.entry!.live ||
        controller == null ||
        !controller.value.isInitialized) {
      return null;
    }
    final target = _playbackSyncTarget(status, controller);
    final actual = controller.value.position.inMilliseconds / 1000.0;
    final deviation = actual - target.positionSeconds;
    return deviation.isFinite ? deviation : null;
  }

  String _formatLatency(Duration? latency) {
    if (latency == null) return '--';
    final millis = latency.inMicroseconds / 1000.0;
    if (millis > 0 && millis < 1) return '<1ms';
    if (millis < 10) return '${millis.toStringAsFixed(1)}ms';
    if (millis < 1000) return '${millis.round()}ms';
    return '${(millis / 1000).toStringAsFixed(2)}s';
  }

  String _formatDeviation(double seconds) {
    final sign = seconds > 0
        ? '+'
        : seconds < 0
        ? '-'
        : '';
    final absolute = seconds.abs();
    final digits = absolute < 10 ? 2 : 1;
    return '$sign${absolute.toStringAsFixed(digits)}s';
  }

  Color _serverLatencyColor(Duration? latency, {required bool videoStyle}) {
    if (latency == null) {
      return videoStyle
          ? Colors.white70
          : Theme.of(context).colorScheme.onSurfaceVariant;
    }
    final millis = latency.inMicroseconds / 1000.0;
    if (millis <= 120) {
      return videoStyle ? const Color(0xFF7CFFB2) : Colors.green;
    }
    if (millis <= 350) {
      return videoStyle ? Colors.amberAccent : Colors.orange;
    }
    return videoStyle
        ? const Color(0xFFFF8A80)
        : Theme.of(context).colorScheme.error;
  }

  Color _playbackDeviationColor(double deviation, {required bool videoStyle}) {
    final absolute = deviation.abs();
    final warningThreshold = math.max(
      0.5,
      _playbackSyncConfig.autoSeekDriftThresholdSeconds,
    );
    if (absolute <= 0.5) {
      return videoStyle ? const Color(0xFF7CFFB2) : Colors.green;
    }
    if (absolute <= warningThreshold) {
      return videoStyle ? Colors.amberAccent : Colors.orange;
    }
    return videoStyle
        ? const Color(0xFFFF8A80)
        : Theme.of(context).colorScheme.error;
  }

  Widget _buildServerLatencyBadge({
    required bool compact,
    bool videoStyle = false,
  }) {
    final latency = SyncedClock.estimatedLatency;
    final color = _serverLatencyColor(latency, videoStyle: videoStyle);
    final background = videoStyle
        ? Colors.white.withValues(alpha: 0.12)
        : color.withValues(alpha: 0.10);
    final label = compact
        ? _formatLatency(latency)
        : '延迟 ${_formatLatency(latency)}';
    return Tooltip(
      message: '服务器延迟',
      child: AppBadge(
        constraints: const BoxConstraints(minHeight: 28, maxWidth: 128),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        borderRadius: BorderRadius.circular(16),
        borderSide: videoStyle ? const BorderSide(color: Colors.white24) : null,
        icon: Icons.network_ping_rounded,
        iconSize: 15,
        color: color,
        backgroundColor: background,
        textStyle: TextStyle(color: color, fontSize: 12),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Widget? _buildPlaybackDeviationBadge({
    required bool compact,
    bool videoStyle = false,
  }) {
    final deviation = _playbackDeviationSeconds();
    if (deviation == null) return null;
    final color = _playbackDeviationColor(deviation, videoStyle: videoStyle);
    final background = videoStyle
        ? Colors.white.withValues(alpha: 0.12)
        : color.withValues(alpha: 0.10);
    final label = compact
        ? _formatDeviation(deviation)
        : '偏差 ${_formatDeviation(deviation)}';
    return Tooltip(
      message: '播放偏差',
      child: AppBadge(
        constraints: const BoxConstraints(minHeight: 28, maxWidth: 128),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        borderRadius: BorderRadius.circular(16),
        borderSide: videoStyle ? const BorderSide(color: Colors.white24) : null,
        icon: Icons.speed_rounded,
        iconSize: 15,
        color: color,
        backgroundColor: background,
        textStyle: TextStyle(color: color, fontSize: 12),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Widget? _buildPlaybackDiagnosticsBadges({
    bool compact = false,
    bool includeLatency = false,
    bool videoStyle = false,
  }) {
    final badges = <Widget>[
      if (includeLatency)
        _buildServerLatencyBadge(compact: compact, videoStyle: videoStyle),
    ];
    final deviationBadge = _buildPlaybackDeviationBadge(
      compact: compact,
      videoStyle: videoStyle,
    );
    if (deviationBadge != null) badges.add(deviationBadge);
    if (badges.isEmpty) return null;
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: badges,
    );
  }

  void _refreshPlaybackUi(VideoPlayerController controller) {
    if (!mounted || !identical(_videoPlayerController, controller)) return;
    setState(() {});
  }

  bool _isDisposedVideoControllerError(Object error) {
    return error.toString().contains(
      'VideoPlayerController was used after being disposed',
    );
  }

  double _boundedPlaybackTime(double currentTime) {
    if (!currentTime.isFinite || currentTime < 0) return 0;
    final duration = _videoPlayerController?.value.duration;
    if (duration == null || duration <= Duration.zero) return currentTime;
    final durationSeconds = duration.inMilliseconds / 1000.0;
    if (durationSeconds <= 0) return currentTime;
    return currentTime.clamp(0.0, durationSeconds).toDouble();
  }

  void _videoListener() {
    if (_isSyncing ||
        _videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) {
      return;
    }

    final value = _videoPlayerController!.value;
    final position = _boundedPlaybackTime(
      value.position.inMilliseconds / 1000.0,
    );
    if (value.isPlaying && !_isCurrentPlaybackLive) {
      unawaited(_maybeFetchPlaybackDanmaku(position));
    }
  }

  void _handleUserPlaybackStateChanged(bool isPlaying) {
    final value = _videoPlayerController?.value;
    if (value == null) return;
    _sendPlaybackControlMessage(
      _playbackControlReporter().playbackStateChanged(
        value: value,
        isPlaying: isPlaying,
      ),
    );
  }

  void _handleUserSeek(Duration position) {
    if (_isCurrentPlaybackLive) return;
    final value = _videoPlayerController?.value;
    if (value == null) return;
    _sendPlaybackControlMessage(
      _playbackControlReporter().seek(value: value, position: position),
    );
  }

  void _handleUserPlaybackSpeedChanged(double speed) {
    final value = _videoPlayerController?.value;
    if (value == null) return;
    _sendPlaybackControlMessage(
      _playbackControlReporter().playbackSpeedChanged(
        value: value,
        speed: speed,
      ),
    );
  }

  PlaybackControlReporter _playbackControlReporter() {
    return PlaybackControlReporter(
      currentStatus: _currentStatus,
      isSyncing: _isSyncing,
      isLive: _isCurrentPlaybackLive,
      boundPosition: _boundedPlaybackTime,
    );
  }

  void _sendPlaybackControlMessage(client.ClientMessage? message) {
    if (message == null) return;
    try {
      _sendRealtimeMessage(message.writeToBuffer());
    } catch (e) {
      debugPrint('Realtime playback state update error: $e');
      if (mounted) MessageUtils.showError(context, '播放状态更新失败');
    }
  }

  void _requestPlaybackSnapshot() {
    try {
      for (final bytes in RoomRealtimeCodec.encodePlaybackObservations()) {
        _sendRealtimeMessage(bytes);
      }
    } catch (e) {
      debugPrint('Request playback snapshot error: $e');
    }
  }

  Future<void> _maybeFetchPlaybackDanmaku(
    double positionSeconds, {
    bool force = false,
  }) async {
    final entry = _currentStatus?.entry;
    final sourceKey = playbackDanmakuSourceKey(entry);
    if (sourceKey.isEmpty || _loadingPlaybackDanmaku) return;
    if (!force &&
        _playbackDanmakuWindow?.covers(sourceKey, positionSeconds, 20) ==
            true) {
      return;
    }

    _loadingPlaybackDanmaku = true;
    try {
      final result = await fetchPlaybackDanmakuWindow(
        roomId: widget.room.roomId,
        entry: entry,
        positionSeconds: positionSeconds,
      );
      if (!mounted || result == null) return;
      _playbackDanmakuWindow = result.window;
      _danmakuController.addUniqueItems(result.items);
    } catch (e) {
      debugPrint('Fetch playback danmaku error: $e');
    } finally {
      _loadingPlaybackDanmaku = false;
    }
  }

  Future<void> _applyPlaybackStatus(
    SyncTvPlaybackStatus status, {
    bool forceReloadVideo = false,
  }) async {
    if (!mounted) return;
    final oldMovieId = _currentStatus?.entry?.id;
    final nextMovieId = status.entry?.id;
    if (oldMovieId != nextMovieId) {
      _danmakuController.clear();
      _playbackDanmakuWindow = null;
    }

    setState(() {
      _currentStatus = status;
      if (status.entry == null || status.entry!.url.isEmpty) {
        _videoInitGeneration++;
        _isVideoLoading = false;
        _videoError = null;
      }
    });

    if (status.entry != null && status.entry!.url.isNotEmpty) {
      final newUrl = SyncTvService.resolveResourceUrl(status.entry!.url);

      if (_videoPlayerController == null ||
          forceReloadVideo ||
          _videoPlayerController!.dataSource != newUrl) {
        await _initVideo(newUrl, headers: status.entry!.headers);
        if (mounted &&
            _videoPlayerController != null &&
            _videoPlayerController!.value.isInitialized) {
          _performSync(status);
        }
      } else {
        _performSync(status);
      }

      final streamUrl = status.entry!.streamDanmu == null
          ? null
          : SyncTvService.resolveResourceUrl(status.entry!.streamDanmu!);
      final danmuUrl = status.entry!.danmu == null
          ? null
          : SyncTvService.resolveResourceUrl(status.entry!.danmu!);

      _danmakuController.updateConfig(
        danmakuUrl: danmuUrl,
        danmakuHeaders: status.entry!.danmuHeaders,
        streamDanmakuUrl: streamUrl,
        streamDanmakuHeaders: status.entry!.streamDanmuHeaders,
        controller: _videoPlayerController,
      );
      if (!status.entry!.live) {
        unawaited(_maybeFetchPlaybackDanmaku(status.currentTime));
      }
    } else {
      if (_videoPlayerController != null) {
        _disposeVideoController();
        if (mounted) setState(() {});
      }
    }
  }

  Future<void> _initVideo(String url, {Map<String, String>? headers}) async {
    if (url.isEmpty) return;
    _warnPlaybackCredentialHeaders(headers ?? const {});
    final generation = ++_videoInitGeneration;
    if (mounted) {
      setState(() {
        _isVideoLoading = true;
        _videoError = null;
      });
    }

    final newController = VideoPlayerController.networkUrl(
      Uri.parse(url),
      httpHeaders: headers ?? {},
    );

    try {
      await newController.initialize();

      if (!mounted || generation != _videoInitGeneration) {
        newController.dispose();
        return;
      }

      _disposeVideoController();

      _videoPlayerController = newController;
      _videoPlayerController!.addListener(_videoListener);

      if (mounted) {
        setState(() {
          _isVideoLoading = false;
          _videoError = null;
        });
      }
    } catch (e) {
      newController.dispose();
      if (mounted && generation == _videoInitGeneration) {
        final message = playbackLoadErrorMessage(e);
        setState(() {
          _isVideoLoading = false;
          _videoError = message;
        });
        MessageUtils.showError(context, message);
      }
    }
  }

  Future<void> _selectPlaybackOption(
    SyncTvPlaybackModeOption mode,
    int urlIndex,
  ) async {
    final status = _currentStatus;
    final entry = status?.entry;
    if (status == null || entry == null) return;
    final wasPlaying = _videoPlayerController?.value.isPlaying ?? false;
    final selected = entry.selectPlayback(
      modeKey: mode.key,
      urlIndex: urlIndex,
      resolveUrl: SyncTvService.resolveResourceUrl,
    );
    final position = selected.live
        ? 0.0
        : _videoPlayerController == null
        ? status.derivedCurrentTime()
        : _videoPlayerController!.value.position.inMilliseconds / 1000.0;
    setState(() {
      _currentStatus = SyncTvPlaybackStatus(
        entry: selected,
        isPlaying: wasPlaying || status.isPlaying,
        currentTime: position,
        playbackRate: status.playbackRate,
        generatedAtMillis: SyncTvService.serverNowMillis(),
        version: status.version,
        playingMediaId: status.playingMediaId,
        playingPlaylistId: status.playingPlaylistId,
        targetHash: status.targetHash,
      );
    });
    await _applyPlaybackStatus(_currentStatus!);
    if (mounted) {
      MessageUtils.showInfo(
        context,
        '已切换到 ${selected.playbackChoiceLabel}',
        duration: const Duration(seconds: 1),
      );
    }
  }

  Widget? _buildPlaybackOptionButton({bool compact = false}) {
    final entry = _currentStatus?.entry;
    if (entry == null || !entry.hasPlaybackChoices) return null;
    if (compact) {
      return AppPopupMenuButton<String>(
        tooltip: '播放线路',
        color: Colors.black87,
        onSelected: (value) {
          final parts = value.split('|');
          if (parts.length != 2) return;
          final mode = entry.playbackModes.firstWhere(
            (entry) => entry.key == parts[0],
            orElse: () => entry.playbackModes.first,
          );
          final index = int.tryParse(parts[1]) ?? mode.safeDefaultUrlIndex;
          _selectPlaybackOption(mode, index);
        },
        itemBuilder: (context) => _buildPlaybackOptionMenuItems(entry),
        child: Tooltip(
          message: entry.playbackChoiceLabel,
          child: AppPanelSurface(
            width: 32,
            height: 32,
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24),
            alignment: Alignment.center,
            child: const Icon(
              Icons.route_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
    final maxLabelWidth = compact ? 0.0 : 170.0;
    return AppPopupMenuButton<String>(
      tooltip: '播放线路',
      color: Colors.black87,
      onSelected: (value) {
        final parts = value.split('|');
        if (parts.length != 2) return;
        final mode = entry.playbackModes.firstWhere(
          (entry) => entry.key == parts[0],
          orElse: () => entry.playbackModes.first,
        );
        final index = int.tryParse(parts[1]) ?? mode.safeDefaultUrlIndex;
        _selectPlaybackOption(mode, index);
      },
      itemBuilder: (context) => _buildPlaybackOptionMenuItems(entry),
      child: Tooltip(
        message: entry.playbackChoiceLabel,
        child: AppBadge(
          constraints: BoxConstraints(minHeight: compact ? 28 : 32),
          padding: EdgeInsets.symmetric(horizontal: compact ? 8 : 10),
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.white24),
          icon: Icons.route_rounded,
          iconSize: 18,
          color: Colors.white,
          backgroundColor: Colors.white.withValues(alpha: 0.12),
          textStyle: const TextStyle(color: Colors.white, fontSize: 12),
          label: compact
              ? const SizedBox.shrink()
              : ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxLabelWidth),
                  child: Text(
                    entry.playbackChoiceLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
        ),
      ),
    );
  }

  List<PopupMenuEntry<String>> _buildPlaybackOptionMenuItems(
    RoomMediaEntry entry,
  ) {
    final items = <PopupMenuEntry<String>>[];
    for (final mode in entry.playbackModes) {
      if (items.isNotEmpty) items.add(const PopupMenuDivider(height: 8));
      items.add(
        PopupMenuItem<String>(
          enabled: false,
          height: 28,
          child: Text(
            mode.label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
      for (var i = 0; i < mode.urls.length; i++) {
        final selected =
            mode.key == entry.selectedPlaybackMode &&
            i == entry.selectedPlaybackUrlIndex;
        items.add(
          PopupMenuItem<String>(
            value: '${mode.key}|$i',
            height: 36,
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 18,
                  color: selected ? const Color(0xFF7CFFB2) : Colors.white70,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    mode.urls[i].label(i),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    return items;
  }

  Widget _buildVideoEmptyState() {
    final hasPlayback = _currentStatus?.entry?.url.isNotEmpty == true;
    return PlaybackEmptyState(
      error: _roomSessionError ?? _videoError,
      loading: _isVideoLoading,
      hasPlayback: hasPlayback,
    );
  }

  void _warnPlaybackCredentialHeaders(Map<String, String> headers) {
    final key = DirectUrlSourceConfig.credentialHeaderRiskKey(headers);
    if (key.isEmpty || !_warnedPlaybackCredentialHeaderKeys.add(key)) return;
    final names = DirectUrlSourceConfig.credentialHeaderNames(
      headers,
    ).join('、');
    MessageUtils.showWarning(
      context,
      '当前播放地址携带 $names。此类凭据来自播放信息，房间成员可能获取并用于请求媒体资源。',
    );
  }

  void _disposeVideoController() {
    _videoInitGeneration++;
    _videoPlayerController?.removeListener(_videoListener);
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
  }

  @override
  void dispose() {
    RealtimeEventLogPreferences.maxEntries.removeListener(
      _handleRealtimeLogMaxEntriesChanged,
    );
    _tabController.removeListener(_handleRoomTabChanged);
    _authErrorSubscription?.cancel();
    _realtimeSubscription?.cancel();
    _tabController.dispose();
    _disposeVideoController();
    _syncTimer?.cancel();
    _diagnosticsTimer?.cancel();
    _chatHighlightTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _messageController.dispose();
    _chatScrollController.dispose();
    _mediaEntryScrollController.dispose();
    _webrtcManager?.dispose();
    _danmakuController.dispose();
    _channel = null;
    _realtimeMessageBus.close();
    _realtimeEventBus.close();
    _realtimeReconnectBus.close();
    super.dispose();
  }

  void _handleRoomTabChanged() {
    if (mounted) {
      setState(() => _roomTabIndex = _tabController.index);
    }
    _syncMemberTabObservation();
  }

  void _selectRoomTab(int index) {
    if (index < 0 || index >= _roomTabCount) return;
    if (_roomTabIndex == index && _tabController.index == index) return;
    _tabController.index = index;
    if (mounted) {
      setState(() => _roomTabIndex = index);
    }
    _syncMemberTabObservation();
  }

  void _syncMemberTabObservation() {
    if (_roomTabIndex == 2) {
      unawaited(_observeRoomMembers());
      return;
    }
    if (_memberEventsObserved) {
      _sendRealtimeMessage(
        RoomRealtimeCodec.encodeUnobserveResource('room_member_events'),
      );
      _memberEventsObserved = false;
    }
  }

  void _handleChatScroll() {
    final show = !_isChatNearBottom();
    if (show != _showChatScrollToBottom && mounted) {
      setState(() => _showChatScrollToBottom = show);
    }
  }

  bool _isChatNearBottom() {
    if (!_chatScrollController.hasClients) return true;
    final position = _chatScrollController.position;
    return position.maxScrollExtent - position.pixels <= 96;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
        if (_showChatScrollToBottom) {
          setState(() => _showChatScrollToBottom = false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compactChrome = MediaQuery.sizeOf(context).width < 560;

    return AppScaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppAppBar(
        leading: AppIconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icons.arrow_back_rounded,
          tooltip: '返回',
        ),
        title: Text(widget.room.roomName),
        backgroundColor: theme.appBarTheme.backgroundColor,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildPlaybackDiagnosticsBadges(
              compact: compactChrome,
              includeLatency: true,
            )!,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: compactChrome
                ? AppIconButton(
                    onPressed: _openPlaybackSyncSettings,
                    icon: Icons.sync_alt_rounded,
                    tooltip: '同步设置',
                    style: AppIconButtonStyle.tonal,
                  )
                : AppActionButton(
                    onPressed: _openPlaybackSyncSettings,
                    icon: Icons.sync_alt_rounded,
                    label: '同步设置',
                    style: AppActionButtonStyle.tonal,
                  ),
          ),
          if (_currentStatus?.entry != null)
            AppActionButton(
              onPressed: _stopPlayback,
              icon: Icons.stop_circle_outlined,
              label: compactChrome ? '停止' : '停止播放',
              style: AppActionButtonStyle.destructive,
            ),
          if (_currentUser != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: compactChrome
                  ? AppIconButton(
                      onPressed: _openRoomSettings,
                      icon: _canManageRoom
                          ? Icons.tune_rounded
                          : Icons.lock_outline_rounded,
                      tooltip: '房间管理',
                      style: AppIconButtonStyle.tonal,
                    )
                  : AppActionButton(
                      onPressed: _openRoomSettings,
                      icon: _canManageRoom
                          ? Icons.tune_rounded
                          : Icons.lock_outline_rounded,
                      label: '房间管理',
                      style: AppActionButtonStyle.tonal,
                    ),
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: AppMetrics.pagePadding(context),
        child: AppAdaptiveSplitView(
          minPrimaryWidth: 520,
          minSecondaryWidth: 320,
          maxSecondaryWidth: 420,
          spacing: AppMetrics.usesDenseLayout(context) ? 12 : 14,
          primary: _buildVideoSurface(),
          secondary: _buildRoomSidePanel(theme),
          collapsedPrimaryAspectRatio: 16 / 9,
          collapsedSecondaryMinHeight: 520,
        ),
      ),
    );
  }

  Widget _buildVideoSurface() {
    return AppPanelSurface(
      color: Colors.black,
      borderRadius: BorderRadius.circular(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final playbackOptionButton = _buildPlaybackOptionButton(
            compact: true,
          );
          return Stack(
            children: [
              Center(
                child:
                    _videoPlayerController != null &&
                        _videoPlayerController!.value.isInitialized
                    ? CustomVideoPlayer(
                        controller: _videoPlayerController!,
                        title: _currentStatus?.entry?.name ?? '未知影片',
                        danmakuController: _danmakuController,
                        subtitles: _currentStatus?.entry?.subtitles,
                        isLive: _currentStatus?.entry?.live == true,
                        onToggleFullScreen: _toggleFullScreen,
                        onSync: _handleSync,
                        onUserPlaybackStateChanged:
                            _handleUserPlaybackStateChanged,
                        onUserSeek: _handleUserSeek,
                        onUserPlaybackSpeedChanged:
                            _handleUserPlaybackSpeedChanged,
                        interactionMode: VideoPlayerInteractionMode.desktop,
                        diagnosticsBuilder: (_) =>
                            _buildPlaybackDiagnosticsBadges(
                              compact: true,
                              videoStyle: true,
                            ),
                        extraBottomWidget: _buildPlaybackOptionButton(
                          compact: true,
                        ),
                      )
                    : _buildVideoEmptyState(),
              ),
              if (playbackOptionButton != null)
                Positioned(top: 12, right: 12, child: playbackOptionButton),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRoomSidePanel(ThemeData theme) {
    return AppInkSurface(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: theme.dividerColor.withValues(alpha: 0.7)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '房间协作',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '$_roomOnlineCount 人',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
                  ),
                ),
                const SizedBox(width: 8),
                AppIconButton(
                  onPressed: () => _selectRoomTab(1),
                  icon: Icons.playlist_play_rounded,
                  tooltip: '播放列表',
                ),
                const SizedBox(width: 4),
                AppIconButton(
                  onPressed: () => copyRoomInviteLink(context, widget.room),
                  icon: Icons.ios_share_rounded,
                  tooltip: '复制邀请链接',
                ),
              ],
            ),
          ),
          _buildTabBar(theme),
          Expanded(child: _buildRoomTabContent()),
        ],
      ),
    );
  }

  Widget _buildRoomTabContent() {
    final children = [
      _buildChatTab(),
      _buildPlaylistTab(),
      _buildMembersTab(),
      if (_showRealtimeDebugTab) _buildRealtimeEventsTab(),
    ];
    final index = _roomTabIndex.clamp(0, children.length - 1);
    return IndexedStack(index: index, children: children);
  }

  void _handleSync() {
    final status = _currentStatus;
    if (status == null) return;
    if (status.entry?.live == true) {
      unawaited(_reloadCurrentPlaybackUrl());
      return;
    }
    unawaited(_performSync(status, forceSeek: true));
    if (mounted) {
      MessageUtils.showInfo(
        context,
        '已同步到最新进度',
        duration: const Duration(seconds: 1),
      );
    }
  }

  Future<void> _reloadCurrentPlaybackUrl() async {
    try {
      final status = await SyncTvService.getCurrentMedia(widget.room.roomId);
      if (!mounted) return;
      await _applyPlaybackStatus(
        _mergePlaybackStatus(
          status,
          incomingHasTiming: status.entry?.url.isEmpty != true,
        ),
        forceReloadVideo: true,
      );
      if (mounted) {
        MessageUtils.showInfo(
          context,
          '已重新加载播放地址',
          duration: const Duration(seconds: 1),
        );
      }
    } catch (e) {
      debugPrint('Reload playback URL error: $e');
      if (mounted) MessageUtils.showError(context, '重新加载播放地址失败');
    }
  }

  Future<void> _openPlaybackSyncSettings() async {
    final nextConfig = await showAppDialog<PlaybackSyncConfig>(
      context: context,
      builder: (dialogContext) {
        var draft = _playbackSyncConfig;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final autoThresholdLabel =
                '${draft.autoSeekDriftThresholdSeconds.toStringAsFixed(1)} 秒';
            final manualThresholdLabel =
                '${draft.manualSeekDriftThresholdSeconds.toStringAsFixed(1)} 秒';

            return AppDialog(
              title: const Text('同步设置'),
              icon: const Icon(Icons.sync_alt_rounded),
              body: SizedBox(
                width: 520,
                child: AppSingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSwitchTile(
                        value: draft.autoSyncEnabled,
                        onChanged: (value) {
                          setDialogState(() {
                            draft = draft.copyWith(autoSyncEnabled: value);
                          });
                        },
                        prefix: const Icon(Icons.auto_mode_rounded),
                        title: const Text('自动进度纠偏'),
                        subtitle: const Text('实时状态事件到达后，客户端按本地时钟计算目标进度并自动跳转'),
                      ),
                      const SizedBox(height: 18),
                      _PlaybackSyncSlider(
                        icon: Icons.linear_scale_rounded,
                        title: '自动纠偏阈值',
                        valueLabel: autoThresholdLabel,
                        value: draft.autoSeekDriftThresholdSeconds,
                        min: 0.1,
                        max: 10.0,
                        divisions: 99,
                        enabled: draft.autoSyncEnabled,
                        onChanged: (value) {
                          setDialogState(() {
                            draft = draft.copyWith(
                              autoSeekDriftThresholdSeconds: value,
                            );
                          });
                        },
                      ),
                      const SizedBox(height: 18),
                      _PlaybackSyncSlider(
                        icon: Icons.touch_app_rounded,
                        title: '手动同步最小误差',
                        valueLabel: manualThresholdLabel,
                        value: draft.manualSeekDriftThresholdSeconds,
                        min: 0.1,
                        max: 1.0,
                        divisions: 18,
                        enabled: true,
                        onChanged: (value) {
                          setDialogState(() {
                            draft = draft.copyWith(
                              manualSeekDriftThresholdSeconds: value,
                            );
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                AppActionButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  label: '取消',
                  style: AppActionButtonStyle.outlined,
                ),
                AppActionButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, PlaybackSyncConfig.defaults);
                  },
                  label: '恢复默认',
                  style: AppActionButtonStyle.tonal,
                ),
                AppActionButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, draft.normalized());
                  },
                  icon: Icons.check_rounded,
                  label: '保存',
                  style: AppActionButtonStyle.filled,
                ),
              ],
            );
          },
        );
      },
    );

    if (nextConfig == null) return;
    await SyncTvService.savePlaybackSyncConfig(nextConfig);
    if (!mounted) return;
    setState(() {
      _playbackSyncConfig = SyncTvService.playbackSyncConfig;
    });
    MessageUtils.showSuccess(context, '同步设置已保存');
  }

  Future<void> _observeRoomMembers() async {
    if (_membersLoading) return;
    if (mounted) setState(() => _membersLoading = true);
    try {
      final page = await SyncTvService.getRoomMemberDetailsPage(
        widget.room.roomId,
        page: 1,
        pageSize: 100,
      );
      final members = page.members.map(_roomMemberToUser).toList();
      if (mounted) {
        _sortMembers(members);
        setState(() {
          _members = members;
        });
      }
      if (!_memberEventsObserved) {
        _sendRealtimeMessage(RoomRealtimeCodec.encodeRoomMembersObservation());
        _memberEventsObserved = true;
      }
    } catch (e) {
      debugPrint('Observe room members error: $e');
      if (mounted) {
        MessageUtils.showError(context, '成员列表加载失败');
      }
    } finally {
      if (mounted) setState(() => _membersLoading = false);
    }
  }

  Future<void> _loadMentionCandidates({
    required String query,
    bool reset = false,
  }) async {
    final normalizedQuery = query.trim();
    final queryChanged = normalizedQuery != _mentionCandidateQuery;
    final shouldReset = reset || queryChanged;
    if (_mentionCandidatesLoading) return;
    if (!shouldReset && !_mentionCandidatesHasMore) return;
    final nextPage = shouldReset ? 1 : _mentionCandidatePage + 1;
    if (mounted) {
      setState(() {
        _mentionCandidatesLoading = true;
        if (shouldReset) {
          _mentionCandidateQuery = normalizedQuery;
          _mentionCandidatePage = 0;
          _mentionCandidatesHasMore = true;
          _mentionCandidates = [];
        }
      });
    } else {
      _mentionCandidatesLoading = true;
      if (shouldReset) {
        _mentionCandidateQuery = normalizedQuery;
        _mentionCandidatePage = 0;
        _mentionCandidatesHasMore = true;
        _mentionCandidates = [];
      }
    }
    try {
      final page = await SyncTvService.getRoomMemberDetailsPage(
        widget.room.roomId,
        page: nextPage,
        pageSize: 30,
        search: normalizedQuery,
      );
      final members = page.members.map(_roomMemberToUser).toList();
      _sortMembers(members);
      if (!mounted) return;
      setState(() {
        final merged = <String, SyncTvUser>{
          for (final member
              in shouldReset ? const <SyncTvUser>[] : _mentionCandidates)
            if (member.id.isNotEmpty) member.id: member,
        };
        for (final member in members) {
          if (member.id.isNotEmpty) merged[member.id] = member;
        }
        _mentionCandidates = merged.values.toList();
        _sortMembers(_mentionCandidates);
        _mentionCandidateQuery = normalizedQuery;
        _mentionCandidatePage = nextPage;
        _mentionCandidatesHasMore =
            page.total > _mentionCandidates.length && members.isNotEmpty;
      });
    } catch (e) {
      debugPrint('Load mention candidates error: $e');
    } finally {
      _mentionCandidatesLoading = false;
      if (mounted) setState(() {});
    }
  }

  void _handleMentionQueryChanged(String query) {
    unawaited(_loadMentionCandidates(query: query, reset: true));
  }

  void _loadMoreMentionCandidates() {
    unawaited(_loadMentionCandidates(query: _mentionCandidateQuery));
  }

  SyncTvUser _roomMemberToUser(AdminRoomMember member) {
    return SyncTvUser(
      id: member.userId,
      username: member.username,
      role: member.role,
      createdAt: member.joinedAt,
      status: common_enum.MemberStatus.MEMBER_STATUS_ACTIVE.value,
      onlineCount: member.isOnline ? 1 : 0,
      connectionCount: member.connectionCount,
    );
  }

  void _toggleFullScreen() {
    if (_videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) {
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CustomVideoPlayer(
          controller: _videoPlayerController!,
          title: _currentStatus?.entry?.name ?? '未知影片',
          danmakuController: _danmakuController,
          subtitles: _currentStatus?.entry?.subtitles,
          isLive: _currentStatus?.entry?.live == true,
          onToggleFullScreen: () => Navigator.of(context).pop(),
          onSync: _handleSync,
          onUserPlaybackStateChanged: _handleUserPlaybackStateChanged,
          onUserSeek: _handleUserSeek,
          onUserPlaybackSpeedChanged: _handleUserPlaybackSpeedChanged,
          onSendDanmaku: _sendDanmaku,
          isFullScreen: true,
          interactionMode: VideoPlayerInteractionMode.desktop,
          diagnosticsBuilder: (_) => _buildPlaybackDiagnosticsBadges(
            compact: true,
            includeLatency: true,
            videoStyle: true,
          ),
          extraBottomWidget: _buildPlaybackOptionButton(compact: true),
        ),
      ),
    );
  }

  void _sendDanmaku(String text) {
    if (text.trim().isEmpty) return;
    if (_channel != null) {
      try {
        final bytes = RoomRealtimeCodec.encodeChat(
          text,
          displayPosition: 'scroll',
          displayColor: '#ffffff',
        );
        _sendRealtimeMessage(bytes);
      } catch (e) {
        debugPrint('Send danmaku error: $e');
        if (mounted) MessageUtils.showError(context, '弹幕发送失败: $e');
      }
    }
  }

  Widget _buildTabBar(ThemeData theme) {
    final labels = ['聊天', '列表', '成员', if (_showRealtimeDebugTab) '实时'];
    final icons = [
      Icons.chat_bubble_rounded,
      Icons.playlist_play_rounded,
      Icons.group_rounded,
      if (_showRealtimeDebugTab) Icons.bolt_rounded,
    ];

    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        return AppPanelSurface(
          height: 56,
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.zero,
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.6),
            ),
          ),
          child: Row(
            children: [
              for (var i = 0; i < labels.length; i++)
                Expanded(
                  child: _buildRoomTabIconButton(
                    theme: theme,
                    label: labels[i],
                    icon: icons[i],
                    index: i,
                    selected: _roomTabIndex == i,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoomTabIconButton({
    required ThemeData theme,
    required String label,
    required IconData icon,
    required int index,
    required bool selected,
  }) {
    return AppPanelSurface(
      color: selected
          ? theme.colorScheme.primary.withValues(alpha: 0.10)
          : Colors.transparent,
      borderRadius: BorderRadius.zero,
      child: Stack(
        children: [
          Center(
            child: AppIconButton(
              onPressed: () => _selectRoomTab(index),
              icon: icon,
              tooltip: label,
              iconSize: 22,
              selected: selected,
              style: selected
                  ? AppIconButtonStyle.tonal
                  : AppIconButtonStyle.ghost,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppAnimatedPanelSurface(
              duration: const Duration(milliseconds: 160),
              height: selected ? 2 : 0,
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.zero,
              child: const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealtimeEventsTab() {
    return RealtimeEventLogView(
      events: _realtimeEvents,
      onClear: () => setState(_realtimeEvents.clear),
      onMaxEntriesChanged: (_) => setState(_trimRealtimeEvents),
      emptyText: '实时事件会在收发 WebSocket 消息后显示',
    );
  }

  Widget _buildChatTab() {
    final theme = Theme.of(context);
    return Column(
      children: [
        _buildVoiceControl(theme),
        if (_pinnedMessages.isNotEmpty || _pinnedMessagesLoading)
          _buildPinnedChatMessagesBar(theme),
        Expanded(
          child: Stack(
            children: [
              AppListView.builder(
                controller: _chatScrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildChatMessageItem(msg);
                },
              ),
              if (_showChatScrollToBottom)
                Positioned(
                  right: 16,
                  bottom: 12,
                  child: AppFloatingActionButton(
                    heroTag: 'desktop_chat_scroll_to_bottom',
                    onPressed: _scrollToBottom,
                    tooltip: '滚动到底部',
                    icon: Icons.keyboard_arrow_down_rounded,
                    small: true,
                  ),
                ),
            ],
          ),
        ),
        const AppDivider(height: 1),
        Padding(
          padding: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            top: 8.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 8.0,
          ),
          child: _buildChatInputArea(),
        ),
      ],
    );
  }

  Widget _buildPinnedChatMessagesBar(ThemeData theme) {
    final scheme = theme.colorScheme;
    return AppPanelSurface(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.52),
      borderRadius: BorderRadius.zero,
      border: Border(
        bottom: BorderSide(
          color: scheme.outlineVariant.withValues(alpha: 0.62),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Row(
        children: [
          Icon(Icons.push_pin_rounded, size: 18, color: scheme.primary),
          const SizedBox(width: 8),
          Text(
            '置顶',
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _pinnedMessagesLoading && _pinnedMessages.isEmpty
                ? const Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: AppLoadingIndicator(
                        size: AppLoadingSize.sm,
                        centered: false,
                      ),
                    ),
                  )
                : AppSingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final message in _pinnedMessages)
                          Padding(
                            padding: const EdgeInsetsDirectional.only(end: 8),
                            child: _buildPinnedChatMessageChip(message, theme),
                          ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(width: 6),
          AppIconButton(
            tooltip: '刷新置顶消息',
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
            padding: EdgeInsets.zero,
            iconSize: 17,
            size: AppIconButtonSize.sm,
            onPressed: _pinnedMessagesLoading ? null : _loadPinnedChatMessages,
            icon: Icons.refresh_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildPinnedChatMessageChip(
    RoomRealtimeChatEntry message,
    ThemeData theme,
  ) {
    final scheme = theme.colorScheme;
    final note = message.pin?.note.trim() ?? '';
    final preview = _chatPreviewText(message);
    final title = note.isEmpty ? message.username : note;
    final subtitle = note.isEmpty ? preview : '${message.username}: $preview';
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _jumpToChatMessage(message.id),
        child: AppPanelSurface(
          color: scheme.surface.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: scheme.primary.withValues(alpha: 0.22)),
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: scheme.onSurface,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              AppIconButton(
                tooltip: '取消置顶',
                constraints: const BoxConstraints.tightFor(
                  width: 28,
                  height: 28,
                ),
                padding: EdgeInsets.zero,
                iconSize: 15,
                size: AppIconButtonSize.sm,
                style: AppIconButtonStyle.ghost,
                onPressed: () => _toggleChatPin(message),
                icon: Icons.close_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatInputArea() {
    final mentionCandidates = <String, SyncTvUser>{};
    for (final member in _mentionCandidates) {
      if (member.id.isNotEmpty) mentionCandidates[member.id] = member;
    }
    for (final member in _members) {
      if (member.id.isNotEmpty) {
        mentionCandidates.putIfAbsent(member.id, () => member);
      }
    }
    final currentUser = _currentUser;
    if (currentUser != null && currentUser.id.isNotEmpty) {
      mentionCandidates[currentUser.id] = currentUser;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_replyingToMessage != null) ...[
          _buildReplyComposerPreview(_replyingToMessage!),
          const SizedBox(height: 8),
        ],
        ChatInputArea(
          textController: _messageController,
          isVoiceInputMode: false,
          isLoading: _sendingChatMessage,
          conversationType: 'synctv',
          onSendMessage: () => _sendMessage(_messageController.text),
          mentionCandidates: mentionCandidates.values.toList(),
          mentionCandidatesLoading: _mentionCandidatesLoading,
          mentionCandidatesHasMore: _mentionCandidatesHasMore,
          onMentionsChanged: (mentions) {
            _pendingChatMentions = mentions;
          },
          onMentionQueryChanged: _handleMentionQueryChanged,
          onMentionLoadMore: _loadMoreMentionCandidates,
          onSwitchToVoiceMode: () {},
          onShowImagePicker: _pickChatImage,
          onStartRecording: () {},
          onStopRecording: () {},
          onCancelRecording: () {},
          selectedImageBytes: _selectedChatImage?.previewBytes,
          selectedImageFile: _selectedChatImage?.previewFile,
          onCancelSelectedImage: () {
            setState(() => _selectedChatImage = null);
          },
        ),
      ],
    );
  }

  Widget _buildReplyComposerPreview(RoomRealtimeChatEntry message) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AppPanelSurface(
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.72),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: scheme.primary.withValues(alpha: 0.22)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '回复 ${message.username}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _chatPreviewText(message),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          AppIconButton(
            tooltip: '取消回复',
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
            padding: EdgeInsets.zero,
            iconSize: 17,
            size: AppIconButtonSize.sm,
            onPressed: () => setState(() => _replyingToMessage = null),
            icon: Icons.close_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildChatImageGrid(List<StoredImageInfo> images) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: images.map((image) => _buildChatImageThumb(image)).toList(),
    );
  }

  Widget _buildChatMessageItem(RoomRealtimeChatEntry message) {
    if (message.isDeleted) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isMine =
        _currentUser != null &&
        message.userId.isNotEmpty &&
        message.userId == _currentUser!.id;
    final alignment = isMine ? Alignment.centerRight : Alignment.centerLeft;
    final messageKey = message.dedupeKey;
    final actionsVisible =
        message.id.isNotEmpty &&
        (_hoveredChatMessageId == messageKey ||
            _activeChatMessageId == messageKey);
    final reactionsVisible =
        message.id.isNotEmpty && _expandedChatActionMessageId == messageKey;
    final bubbleColor = isMine
        ? scheme.primary.withValues(alpha: 0.12)
        : scheme.surfaceContainerHighest.withValues(alpha: 0.72);
    final borderColor = isMine
        ? scheme.primary.withValues(alpha: 0.22)
        : scheme.outlineVariant.withValues(alpha: 0.55);
    final textColor = isMine ? scheme.onPrimaryContainer : scheme.onSurface;
    final authorColor = isMine
        ? scheme.primary
        : scheme.onSurfaceVariant.withValues(alpha: 0.92);
    final replyPreview = _replyPreviewFor(message);
    final highlighted =
        message.id.isNotEmpty && _highlightedChatMessageId == message.id;
    final itemKey = message.id.isEmpty ? null : _chatMessageKey(message.id);

    return MouseRegion(
      key: itemKey,
      onEnter: (_) => setState(() => _hoveredChatMessageId = messageKey),
      onExit: (_) {
        if (_activeChatMessageId != messageKey &&
            _expandedChatActionMessageId != messageKey) {
          setState(() => _hoveredChatMessageId = null);
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onSecondaryTapDown: (details) {
          setState(() {
            _activeChatMessageId = messageKey;
            _hoveredChatMessageId = messageKey;
          });
          _showChatMessageContextMenu(message, details.globalPosition);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          decoration: BoxDecoration(
            color: highlighted
                ? scheme.primary.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Align(
            alignment: alignment,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isMine && actionsVisible) ...[
                    _buildChatMessageActionBar(
                      message,
                      isMine,
                      showReactions: reactionsVisible,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Flexible(
                    child: Column(
                      crossAxisAlignment: isMine
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        AppPanelSurface(
                          color: bubbleColor,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(8),
                            topRight: const Radius.circular(8),
                            bottomLeft: Radius.circular(isMine ? 8 : 3),
                            bottomRight: Radius.circular(isMine ? 3 : 8),
                          ),
                          border: Border.all(color: borderColor),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      message.username,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.labelMedium
                                          ?.copyWith(
                                            color: authorColor,
                                            fontWeight: FontWeight.w700,
                                            height: 1.15,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    message.timeLabel,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: scheme.onSurfaceVariant.withValues(
                                        alpha: 0.68,
                                      ),
                                      height: 1.15,
                                    ),
                                  ),
                                  if (message.isEdited) ...[
                                    const SizedBox(width: 6),
                                    Text(
                                      '已编辑',
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: scheme.onSurfaceVariant
                                                .withValues(alpha: 0.62),
                                            height: 1.15,
                                          ),
                                    ),
                                  ],
                                ],
                              ),
                              if (message.replyToMessageId.isNotEmpty) ...[
                                const SizedBox(height: 7),
                                _buildQuotedChatMessage(
                                  replyPreview,
                                  messageId: message.replyToMessageId,
                                  isMine: isMine,
                                ),
                              ],
                              if (message.content.isNotEmpty) ...[
                                const SizedBox(height: 5),
                                Text(
                                  message.content,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: textColor,
                                    height: 1.32,
                                  ),
                                ),
                              ],
                              if (message.images.isNotEmpty) ...[
                                if (message.content.isNotEmpty)
                                  const SizedBox(height: 8),
                                _buildChatImageGrid(message.images),
                              ],
                            ],
                          ),
                        ),
                        if (message.id.isNotEmpty &&
                            (message.reactions.isNotEmpty || isMine)) ...[
                          const SizedBox(height: 5),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: isMine
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              if (message.reactions.isNotEmpty)
                                Flexible(child: _buildChatReactionBar(message)),
                              if (isMine) ...[
                                if (message.reactions.isNotEmpty)
                                  const SizedBox(width: 6),
                                _buildChatReadReceiptButton(message),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!isMine && actionsVisible) ...[
                    const SizedBox(width: 6),
                    _buildChatMessageActionBar(
                      message,
                      isMine,
                      showReactions: reactionsVisible,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatReactionBar(RoomRealtimeChatEntry message) {
    return AppSingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: message.userId == _currentUser?.id,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: message.reactions
            .map(
              (reaction) => Padding(
                padding: const EdgeInsetsDirectional.only(end: 5),
                child: _buildChatReactionChip(message, reaction),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildChatReadReceiptButton(RoomRealtimeChatEntry message) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final receipt = _chatReceiptCache[message.id];
    final loading = _chatReceiptLoadingIds.contains(message.id);
    final mentionReceipt = receipt == null
        ? null
        : _mentionReadReceiptSummary(message, receipt);
    final hasMentions = _mentionedUsersForMessage(message, receipt).isNotEmpty;
    final text =
        mentionReceipt ??
        (receipt == null
            ? (hasMentions ? '@ 已读' : '已读')
            : '${receipt.readerTotal} 已读 · ${receipt.unreadTotal} 未读');
    final isMentionReceipt = mentionReceipt != null || hasMentions;
    final label = isMentionReceipt ? '查看 @ 已读详情' : '查看阅读详情';
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        enabled: !loading,
        label: label,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: loading ? null : () => _showChatReadReceipts(message),
          child: AppPanelSurface(
            height: 32,
            color: isMentionReceipt
                ? scheme.primary.withValues(alpha: 0.11)
                : scheme.surfaceContainerHighest.withValues(alpha: 0.62),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isMentionReceipt
                  ? scheme.primary.withValues(alpha: 0.28)
                  : scheme.outlineVariant.withValues(alpha: 0.58),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (loading)
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: AppLoadingIndicator(
                      size: AppLoadingSize.sm,
                      centered: false,
                    ),
                  )
                else
                  Icon(
                    isMentionReceipt
                        ? Icons.alternate_email_rounded
                        : Icons.visibility_outlined,
                    size: 13,
                    color: isMentionReceipt
                        ? scheme.primary
                        : scheme.onSurfaceVariant,
                  ),
                const SizedBox(width: 4),
                Text(
                  text,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isMentionReceipt
                        ? scheme.primary
                        : scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _mentionReadReceiptSummary(
    RoomRealtimeChatEntry message,
    ChatMessageReadReceiptsInfo receipt,
  ) {
    final mentionedUsers = _mentionedUsersForMessage(message, receipt);
    if (mentionedUsers.isEmpty) return null;
    final mentionedIds = mentionedUsers.map((user) => user.id).toSet();
    final readCount = receipt.readers
        .where((reader) => mentionedIds.contains(reader.user.id))
        .length;
    final unreadCount = receipt.unreadMembers
        .where((user) => mentionedIds.contains(user.id))
        .length;
    if (readCount == 0 && unreadCount == 0) {
      return '@ 已读';
    }
    if (mentionedUsers.length == 1) {
      return unreadCount == 0 ? '@ 已读' : '@ 未读';
    }
    return '@ $readCount 已读 · $unreadCount 未读';
  }

  List<SyncTvUser> _mentionedUsersForMessage(
    RoomRealtimeChatEntry message,
    ChatMessageReadReceiptsInfo? receipt,
  ) {
    if (message.mentions.isEmpty) return const [];
    final mentionedIds = message.mentions
        .map((mention) => mention.userId)
        .toSet();
    final users = <String, SyncTvUser>{};
    for (final mention in message.mentions) {
      if (mention.userId.isEmpty || mention.username.trim().isEmpty) continue;
      users[mention.userId] = SyncTvUser(
        id: mention.userId,
        username: mention.username,
        role: 0,
      );
    }
    if (receipt != null) {
      for (final reader in receipt.readers) {
        users[reader.user.id] = reader.user;
      }
      for (final user in receipt.unreadMembers) {
        users[user.id] = user;
      }
    } else {
      for (final user in _members) {
        users[user.id] = user;
      }
      final currentUser = _currentUser;
      if (currentUser != null) users[currentUser.id] = currentUser;
    }
    return mentionedIds
        .map((id) => users[id])
        .whereType<SyncTvUser>()
        .where((user) => user.username.trim().isNotEmpty)
        .toList();
  }

  Future<void> _showChatReadReceipts(RoomRealtimeChatEntry message) async {
    if (message.id.isEmpty) return;
    ChatMessageReadReceiptsInfo? receipt = _chatReceiptCache[message.id];
    if (receipt == null) {
      setState(() => _chatReceiptLoadingIds.add(message.id));
      try {
        final loaded = await SyncTvService.getChatMessageReadReceipts(
          widget.room.roomId,
          message.id,
        );
        if (!mounted) return;
        setState(() {
          _chatReceiptCache[message.id] = loaded;
        });
        receipt = loaded;
      } catch (e) {
        if (mounted) MessageUtils.showError(context, '加载已读详情失败: $e');
        return;
      } finally {
        if (mounted) {
          setState(() => _chatReceiptLoadingIds.remove(message.id));
        }
      }
    }
    final visibleReceipt = receipt;
    if (!mounted) return;
    await showAppDialog<void>(
      context: context,
      builder: (context) => ChatReadReceiptsDialog(receipts: visibleReceipt),
    );
  }

  Future<void> _showChatReactionUsers(
    RoomRealtimeChatEntry message,
    ChatReactionSummaryInfo reaction,
  ) async {
    if (message.id.isEmpty) return;
    await showAppDialog<void>(
      context: context,
      builder: (context) => ChatReactionUsersDialog(
        roomId: widget.room.roomId,
        messageId: message.id,
        reactionKey: reaction.key,
      ),
    );
  }

  Widget _buildQuotedChatMessage(
    RoomRealtimeChatEntry? quote, {
    required String messageId,
    required bool isMine,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = isMine ? scheme.primary : scheme.secondary;
    final author = quote?.username.trim();
    final title = author == null || author.isEmpty ? '引用消息' : author;
    final preview = quote == null ? '正在加载引用消息...' : _chatPreviewText(quote);
    return Tooltip(
      message: '跳转到引用消息',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(7),
          onTap: () => _jumpToChatMessage(messageId),
          child: AppPanelSurface(
            color: scheme.surface.withValues(alpha: isMine ? 0.5 : 0.62),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: accent.withValues(alpha: 0.22)),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 3,
                  height: 31,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        preview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                          height: 1.18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatReactionChip(
    RoomRealtimeChatEntry message,
    ChatReactionSummaryInfo reaction,
  ) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final selected = reaction.reactedByMe;
    final background = selected
        ? scheme.primary.withValues(alpha: 0.14)
        : scheme.surfaceContainerHighest.withValues(alpha: 0.7);
    final borderColor = selected
        ? scheme.primary.withValues(alpha: 0.42)
        : scheme.outlineVariant.withValues(alpha: 0.68);

    return Tooltip(
      message: selected ? '点击取消回应，长按查看成员' : '点击添加回应，长按查看成员',
      child: InkWell(
        onTap: () => _toggleChatReaction(message, reaction),
        onLongPress: () => _showChatReactionUsers(message, reaction),
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          height: 28,
          child: AppPanelSurface(
            color: background,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: borderColor),
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(reaction.key, style: const TextStyle(fontSize: 13)),
                const SizedBox(width: 3),
                Text(
                  '${reaction.count}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: selected ? scheme.primary : scheme.onSurfaceVariant,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatMessageActionBar(
    RoomRealtimeChatEntry message,
    bool isMine, {
    bool showReactions = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final messageKey = message.dedupeKey;
    return MouseRegion(
      onEnter: (_) => setState(() {
        _hoveredChatMessageId = messageKey;
      }),
      onExit: (_) => setState(() => _expandedChatActionMessageId = null),
      child: Material(
        elevation: 2,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        child: Column(
          crossAxisAlignment: isMine
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppPanelSurface(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                color: scheme.outlineVariant.withValues(alpha: 0.7),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: _chatMessageToolButtons(message, isMine),
              ),
            ),
            if (showReactions) ...[
              const SizedBox(height: 4),
              _buildChatReactionPicker(message),
            ],
          ],
        ),
      ),
    );
  }

  List<Widget> _chatMessageToolButtons(
    RoomRealtimeChatEntry message,
    bool isMine,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return [
      _buildChatActionIcon(
        tooltip: '表情回应',
        icon: Icons.add_reaction_outlined,
        keepExpanded: true,
        onPressed: () => setState(() {
          final key = message.dedupeKey;
          _expandedChatActionMessageId = _expandedChatActionMessageId == key
              ? null
              : key;
          _hoveredChatMessageId = key;
        }),
      ),
      _buildChatActionIcon(
        tooltip: '回复',
        icon: Icons.reply_rounded,
        onPressed: () => _replyToChatMessage(message),
      ),
      _buildChatActionIcon(
        tooltip: '复制',
        icon: Icons.copy_rounded,
        onPressed: () => _copyChatMessageText(message),
      ),
      _buildChatActionIcon(
        tooltip: message.isPinned ? '取消置顶' : '置顶',
        icon: message.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
        onPressed: () => _toggleChatPin(message),
      ),
      if (isMine || _canManageRoom)
        _buildChatActionIcon(
          tooltip: '删除',
          icon: Icons.delete_outline_rounded,
          color: scheme.error,
          onPressed: () => _deleteChatMessage(message),
        ),
      _buildChatActionIcon(
        tooltip: '举报',
        icon: Icons.flag_outlined,
        onPressed: () => _showReportChatMessageDialog(message),
      ),
    ];
  }

  Widget _buildChatReactionPicker(RoomRealtimeChatEntry message) {
    final scheme = Theme.of(context).colorScheme;
    final messageKey = message.dedupeKey;
    return MouseRegion(
      onEnter: (_) => setState(() {
        _hoveredChatMessageId = messageKey;
        _expandedChatActionMessageId = messageKey;
      }),
      onExit: (_) => setState(() => _expandedChatActionMessageId = null),
      child: Material(
        elevation: 3,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        child: AppPanelSurface(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.98),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.7),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: commonChatReactionKeys
                .map((key) => _buildQuickReactionButton(message, key))
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickReactionButton(RoomRealtimeChatEntry message, String key) {
    final reactedByMe = _chatReactionReactedByMe(message, key);
    return Tooltip(
      message: reactedByMe ? '取消回应 $key' : '回应 $key',
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          setState(() => _expandedChatActionMessageId = null);
          _setChatReaction(message, key, enabled: !reactedByMe);
        },
        child: SizedBox(
          width: 28,
          height: 28,
          child: Center(child: Text(key, style: const TextStyle(fontSize: 16))),
        ),
      ),
    );
  }

  Widget _buildQuickReactionButtonWithClose(
    RoomRealtimeChatEntry message,
    String key,
    VoidCallback onClose,
  ) {
    final reactedByMe = _chatReactionReactedByMe(message, key);
    return Tooltip(
      message: reactedByMe ? '取消回应 $key' : '回应 $key',
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          onClose();
          _setChatReaction(message, key, enabled: !reactedByMe);
        },
        child: SizedBox(
          width: 28,
          height: 28,
          child: Center(child: Text(key, style: const TextStyle(fontSize: 17))),
        ),
      ),
    );
  }

  bool _chatReactionReactedByMe(RoomRealtimeChatEntry message, String key) {
    for (final reaction in message.reactions) {
      if (reaction.key == key) return reaction.reactedByMe;
    }
    return false;
  }

  Widget _buildChatActionIcon({
    required String tooltip,
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
    bool keepExpanded = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: AppIconButton(
        tooltip: tooltip,
        constraints: const BoxConstraints.tightFor(width: 28, height: 28),
        padding: EdgeInsets.zero,
        iconSize: 15,
        size: AppIconButtonSize.sm,
        style: color == null
            ? AppIconButtonStyle.ghost
            : AppIconButtonStyle.destructive,
        onPressed: () {
          if (!keepExpanded) {
            setState(() => _expandedChatActionMessageId = null);
          }
          onPressed();
        },
        icon: icon,
      ),
    );
  }

  Widget _buildContextActionIcon({
    required String tooltip,
    required IconData icon,
    required VoidCallback onClose,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Tooltip(
      message: tooltip,
      child: AppIconButton(
        tooltip: tooltip,
        constraints: const BoxConstraints.tightFor(width: 28, height: 28),
        padding: EdgeInsets.zero,
        iconSize: 15,
        size: AppIconButtonSize.sm,
        style: color == null
            ? AppIconButtonStyle.ghost
            : AppIconButtonStyle.destructive,
        onPressed: () {
          onClose();
          onPressed();
        },
        icon: icon,
      ),
    );
  }

  Future<void> _showChatMessageContextMenu(
    RoomRealtimeChatEntry message,
    Offset position,
  ) async {
    final isMine = _currentUser != null && message.userId == _currentUser!.id;
    final screen = MediaQuery.sizeOf(context);
    final panelWidth = math.min(260.0, math.max(180.0, screen.width - 24));
    final panelHeight = isMine || _canManageRoom ? 122.0 : 92.0;
    final maxLeft = math.max(12.0, screen.width - panelWidth - 12);
    final maxTop = math.max(12.0, screen.height - panelHeight - 12);
    final left = math.min(
      math.max(12.0, position.dx - panelWidth / 2),
      maxLeft,
    );
    final top = math.min(math.max(12.0, position.dy - 10), maxTop);
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: '关闭消息操作',
      barrierColor: Colors.transparent,
      pageBuilder: (dialogContext, _, __) {
        return Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              child: Material(
                color: Colors.transparent,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: panelWidth),
                  child: _buildChatContextActionPanel(
                    message,
                    isMine,
                    onClose: () => Navigator.pop(dialogContext),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    if (!mounted) return;
    setState(() {
      _activeChatMessageId = null;
      _expandedChatActionMessageId = null;
    });
  }

  Widget _buildChatContextActionPanel(
    RoomRealtimeChatEntry message,
    bool isMine, {
    required VoidCallback onClose,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      elevation: 8,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: AppPanelSurface(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.98),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.7)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 3,
              runSpacing: 3,
              children: commonChatReactionKeys
                  .map(
                    (key) => _buildQuickReactionButtonWithClose(
                      message,
                      key,
                      onClose,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 7),
            AppDivider(
              height: 1,
              color: scheme.outlineVariant.withValues(alpha: 0.45),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildContextActionIcon(
                  tooltip: '回复',
                  icon: Icons.reply_rounded,
                  onClose: onClose,
                  onPressed: () => _replyToChatMessage(message),
                ),
                _buildContextActionIcon(
                  tooltip: '复制',
                  icon: Icons.copy_rounded,
                  onClose: onClose,
                  onPressed: () => _copyChatMessageText(message),
                ),
                _buildContextActionIcon(
                  tooltip: message.isPinned ? '取消置顶' : '置顶',
                  icon: message.isPinned
                      ? Icons.push_pin
                      : Icons.push_pin_outlined,
                  onClose: onClose,
                  onPressed: () => _toggleChatPin(message),
                ),
                if (isMine || _canManageRoom)
                  _buildContextActionIcon(
                    tooltip: '删除',
                    icon: Icons.delete_outline_rounded,
                    color: scheme.error,
                    onClose: onClose,
                    onPressed: () => _deleteChatMessage(message),
                  ),
                _buildContextActionIcon(
                  tooltip: '举报',
                  icon: Icons.flag_outlined,
                  onClose: onClose,
                  onPressed: () => _showReportChatMessageDialog(message),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleChatReaction(
    RoomRealtimeChatEntry message,
    ChatReactionSummaryInfo reaction,
  ) async {
    if (message.id.isEmpty) return;
    await _setChatReaction(
      message,
      reaction.key,
      enabled: !reaction.reactedByMe,
    );
  }

  Future<void> _setChatReaction(
    RoomRealtimeChatEntry message,
    String reactionKey, {
    required bool enabled,
  }) async {
    if (message.id.isEmpty) return;
    try {
      final updated = await SyncTvService.setChatReaction(
        widget.room.roomId,
        message.id,
        reactionKey,
        enabled: enabled,
      );
      if (!mounted) return;
      final entry = RoomRealtimeChatEntry.fromHistory(updated);
      setState(() {
        _messages.applyRealtimeEvent(
          entry,
          eventKind: RoomRealtimeChatEventKind.reactionsChanged,
          maxEntries: 100,
        );
        _indexChatMessage(entry);
      });
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '表情回应失败: $e');
    }
  }

  void _replyToChatMessage(RoomRealtimeChatEntry message) {
    setState(() {
      _replyingToMessage = message;
      _hoveredChatMessageId = null;
      _activeChatMessageId = null;
      _expandedChatActionMessageId = null;
    });
  }

  Future<void> _copyChatMessageText(RoomRealtimeChatEntry message) async {
    final text = message.content.trim();
    if (text.isEmpty) {
      MessageUtils.showInfo(context, '这条消息没有可复制文本');
      return;
    }
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) MessageUtils.showSuccess(context, '消息已复制');
  }

  Future<void> _toggleChatPin(RoomRealtimeChatEntry message) async {
    if (message.id.isEmpty || message.isDeleted) return;
    try {
      final event = message.isPinned
          ? await SyncTvService.unpinChatMessage(widget.room.roomId, message.id)
          : await SyncTvService.pinChatMessage(widget.room.roomId, message.id);
      if (!mounted) return;
      setState(() => _applyChatPinEvent(event));
      MessageUtils.showSuccess(context, message.isPinned ? '已取消置顶' : '消息已置顶');
    } catch (e) {
      if (mounted) {
        MessageUtils.showError(
          context,
          message.isPinned ? '取消置顶失败: $e' : '置顶消息失败: $e',
        );
      }
    }
  }

  Future<void> _deleteChatMessage(RoomRealtimeChatEntry message) async {
    if (message.id.isEmpty) return;
    try {
      await SyncTvService.deleteChatMessage(
        widget.room.roomId,
        message.id,
        expectedVersion: message.version,
        reason: 'user_deleted',
      );
      if (!mounted) return;
      setState(() {
        _messages.removeWhere((entry) => entry.dedupeKey == message.dedupeKey);
        _chatMessageCache.remove(message.id);
        _chatReceiptCache.remove(message.id);
        _chatMessageKeys.remove(message.id);
        if (_replyingToMessage?.id == message.id) {
          _replyingToMessage = null;
        }
      });
      MessageUtils.showSuccess(context, '消息已删除');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '删除消息失败: $e');
    }
  }

  Future<void> _showReportChatMessageDialog(
    RoomRealtimeChatEntry message,
  ) async {
    if (message.id.isEmpty) return;
    await _showReportContentDialog(
      title: '举报消息',
      submit: (reasonCode, reason) => SyncTvService.reportChatMessage(
        widget.room.roomId,
        message.id,
        reasonCode: reasonCode,
        reason: reason,
      ),
    );
  }

  Future<void> _showReportRoomMemberDialog(SyncTvUser member) async {
    if (member.id.isEmpty) return;
    await _showReportContentDialog(
      title: '举报成员',
      targetLabel: member.username.isEmpty ? member.id : member.username,
      submit: (reasonCode, reason) => SyncTvService.reportRoomMember(
        widget.room.roomId,
        member.id,
        reasonCode: reasonCode,
        reason: reason,
      ),
    );
  }

  Future<void> _showReportUserDialog(SyncTvUser member) async {
    if (member.id.isEmpty) return;
    await _showReportContentDialog(
      title: '举报用户',
      targetLabel: member.username.isEmpty ? member.id : member.username,
      submit: (reasonCode, reason) => SyncTvService.reportUser(
        widget.room.roomId,
        member.id,
        reasonCode: reasonCode,
        reason: reason,
      ),
    );
  }

  Future<void> _showReportContentDialog({
    required String title,
    String targetLabel = '',
    required Future<String> Function(String reasonCode, String reason) submit,
  }) async {
    const reasons = <String, String>{
      'spam': '垃圾广告',
      'abuse': '辱骂骚扰',
      'illegal': '违法违规',
      'sexual': '低俗色情',
      'other': '其他问题',
    };
    var selectedReason = 'spam';
    final detailController = TextEditingController();
    final submitted = await showAppDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AppDialog(
              title: const Text('举报消息'),
              icon: const Icon(Icons.flag_outlined),
              body: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (targetLabel.isNotEmpty) ...[
                      Text(
                        targetLabel,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                    ],
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: reasons.entries
                          .map(
                            (entry) => AppChip(
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
                      label: '补充说明',
                      hintText: '描述具体问题',
                      minLines: 3,
                      maxLines: 5,
                      maxLength: 2000,
                    ),
                  ],
                ),
              ),
              actions: [
                AppActionButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  label: '取消',
                  style: AppActionButtonStyle.text,
                ),
                AppActionButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  label: '提交',
                  icon: Icons.flag_outlined,
                ),
              ],
            );
          },
        );
      },
    );
    try {
      if (submitted != true) return;
      await submit(selectedReason, detailController.text);
      if (mounted) MessageUtils.showSuccess(context, '举报已提交');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '举报失败: $e');
    } finally {
      detailController.dispose();
    }
  }

  Widget _buildChatImageThumb(StoredImageInfo image) {
    final url = SyncTvService.resolveResourceUrl(image.url);
    return AppImageThumbnail(
      url: url,
      width: 180,
      height: 120,
      borderRadius: BorderRadius.circular(8),
    );
  }

  Widget _buildVoiceControl(ThemeData theme) {
    if (_webrtcManager == null) return const SizedBox.shrink();

    return AppInfoBanner(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: _webrtcManager!.isConnected
          ? (_webrtcManager!.isMuted ? Colors.red : Colors.green)
          : theme.disabledColor,
      backgroundColor: theme.cardColor,
      borderRadius: BorderRadius.zero,
      border: Border(
        bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      icon: _webrtcManager!.isConnected
          ? Icons.mic_rounded
          : Icons.mic_off_rounded,
      title: Text(
        _webrtcManager!.isConnected
            ? (_webrtcManager!.hasPeersConnected
                  ? (_webrtcManager!.isMuted
                        ? '语音已连接 (${_webrtcManager!.participantCount}人) (静音)'
                        : '语音已连接 (${_webrtcManager!.participantCount}人)')
                  : (_webrtcManager!.isMuted
                        ? '等待加入... (1人) (静音)'
                        : '等待加入... (1人)'))
            : '语音聊天',
        style: TextStyle(
          color: theme.textTheme.bodyMedium?.color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
      trailing: _webrtcManager!.isConnected
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIconButton(
                  icon: _webrtcManager!.isMuted
                      ? Icons.mic_off_rounded
                      : Icons.mic_rounded,
                  onPressed: () => _webrtcManager!.toggleMute(),
                  tooltip: _webrtcManager!.isMuted ? '取消静音' : '静音',
                  size: AppIconButtonSize.sm,
                  style: _webrtcManager!.isMuted
                      ? AppIconButtonStyle.destructive
                      : AppIconButtonStyle.tonal,
                ),
                AppIconButton(
                  icon: Icons.call_end_rounded,
                  onPressed: () => _webrtcManager!.leave(),
                  tooltip: '退出语音',
                  size: AppIconButtonSize.sm,
                  style: AppIconButtonStyle.destructive,
                ),
              ],
            )
          : SizedBox(
              height: 32,
              child: AppActionButton(
                onPressed: _joinVoice,
                loading: _joiningVoice,
                icon: Icons.call_rounded,
                label: _joiningVoice ? '加入中' : '加入',
                style: AppActionButtonStyle.tonal,
              ),
            ),
    );
  }

  Future<void> _joinVoice() async {
    final manager = _webrtcManager;
    if (manager == null || _joiningVoice) return;
    setState(() {
      _joiningVoice = true;
    });
    try {
      await manager.join().timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('加入语音超时，请检查麦克风权限'),
      );
    } catch (e, stackTrace) {
      debugPrint('WebRTC voice join failed: $e');
      debugPrint('$stackTrace');
      if (mounted) {
        MessageUtils.showError(context, '加入语音失败: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _joiningVoice = false;
        });
      }
    }
  }

  Widget _buildPlaylistTab() {
    const primaryColor = Color(0xFF5D5FEF);
    final canMutatePlaylist = _canMutateCurrentPlaylist;
    final selectionMode = _isSelectionMode && canMutatePlaylist;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (_folderStack.isNotEmpty)
                AppIconButton(
                  icon: Icons.arrow_back,
                  onPressed: _exitFolder,
                  tooltip: '返回上一级',
                ),
              Expanded(
                child: Text(
                  _folderStack.isNotEmpty ? _folderNameStack.last : '播放列表',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (canMutatePlaylist) ...[
                AppActionButton(
                  icon: Icons.add,
                  label: '添加',
                  onPressed: _showAddMediaDialog,
                  style: AppActionButtonStyle.text,
                ),
                AppIconButton(
                  icon: selectionMode ? Icons.close : Icons.checklist,
                  onPressed: () {
                    setState(() {
                      _isSelectionMode = !_isSelectionMode;
                      _selectedMediaEntryIds.clear();
                    });
                  },
                  tooltip: selectionMode ? '取消选择' : '批量管理',
                  style: selectionMode
                      ? AppIconButtonStyle.tonal
                      : AppIconButtonStyle.ghost,
                ),
              ],
              _buildPlaylistViewModeButton(_PlaylistViewMode.compact),
              _buildPlaylistViewModeButton(_PlaylistViewMode.detailed),
              _buildPlaylistViewModeButton(_PlaylistViewMode.grid),
            ],
          ),
        ),
        if (selectionMode)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                AppActionButton(
                  onPressed: _selectAll,
                  label: '全选',
                  style: AppActionButtonStyle.text,
                ),
                const Spacer(),
                AppActionButton(
                  onPressed: _selectedMediaEntryIds.isEmpty
                      ? null
                      : _deleteSelectedMediaEntries,
                  label: '删除',
                  style: AppActionButtonStyle.tonal,
                ),
              ],
            ),
          ),
        Expanded(
          child: _isLoadingMediaEntries
              ? const AppLoadingIndicator()
              : _mediaEntries.isEmpty
              ? PlaylistEmptyState(
                  onAdd: canMutatePlaylist ? _showAddMediaDialog : null,
                  compact: true,
                )
              : _buildPlaylistEntries(primaryColor, selectionMode),
        ),
      ],
    );
  }

  Widget _buildPlaylistEntries(Color primaryColor, bool selectionMode) {
    return switch (_playlistViewMode) {
      _PlaylistViewMode.compact => AppListView.builder(
        controller: _mediaEntryScrollController,
        itemCount: _mediaEntries.length + (_hasMoreMediaEntries ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _mediaEntries.length) return _buildPlaylistLoadingRow();
          return _buildCompactPlaylistEntry(
            _mediaEntries[index],
            primaryColor,
            selectionMode,
          );
        },
      ),
      _PlaylistViewMode.detailed => AppListView.builder(
        controller: _mediaEntryScrollController,
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        itemCount: _mediaEntries.length + (_hasMoreMediaEntries ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _mediaEntries.length) return _buildPlaylistLoadingRow();
          return _buildDetailedPlaylistEntry(
            _mediaEntries[index],
            primaryColor,
            selectionMode,
          );
        },
      ),
      _PlaylistViewMode.grid => AppGridView.builder(
        controller: _mediaEntryScrollController,
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          mainAxisExtent: 164,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: _mediaEntries.length + (_hasMoreMediaEntries ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _mediaEntries.length) return _buildPlaylistLoadingCard();
          return _buildGridPlaylistEntry(
            _mediaEntries[index],
            primaryColor,
            selectionMode,
          );
        },
      ),
    };
  }

  AppIconButton _buildPlaylistViewModeButton(_PlaylistViewMode mode) {
    final selected = _playlistViewMode == mode;
    final (icon, tooltip) = switch (mode) {
      _PlaylistViewMode.compact => (Icons.view_headline_rounded, '紧凑列表'),
      _PlaylistViewMode.detailed => (Icons.view_agenda_rounded, '详细列表'),
      _PlaylistViewMode.grid => (Icons.grid_view_rounded, '网格'),
    };
    return AppIconButton(
      icon: icon,
      tooltip: tooltip,
      selected: selected,
      style: selected ? AppIconButtonStyle.tonal : AppIconButtonStyle.ghost,
      onPressed: selected
          ? null
          : () => setState(() {
              _playlistViewMode = mode;
            }),
    );
  }

  Widget _buildPlaylistLoadingRow() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: AppLoadingIndicator(centered: false),
      ),
    );
  }

  Widget _buildPlaylistLoadingCard() {
    return const AppPanelSurface(
      padding: EdgeInsets.all(12),
      child: Center(child: AppLoadingIndicator(centered: false)),
    );
  }

  Widget _buildCompactPlaylistEntry(
    RoomMediaEntry entry,
    Color primaryColor,
    bool selectionMode,
  ) {
    final isCurrent = _currentStatus?.entry?.id == entry.id;
    final isSelected = _selectedMediaEntryIds.contains(entry.id);

    return AppTile(
      selected: isSelected,
      prefix: Icon(
        _playlistEntryIcon(entry),
        color: _playlistEntryAccent(entry, isCurrent, primaryColor),
      ),
      title: Text(
        entry.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isCurrent ? primaryColor : null,
          fontWeight: isCurrent ? FontWeight.bold : null,
        ),
      ),
      suffix: _buildPlaylistSelectionIcon(
        isSelected,
        selectionMode,
        primaryColor,
      ),
      onPressed: () => _handlePlaylistEntryPressed(entry, selectionMode),
      onLongPress: () => _handlePlaylistEntryLongPressed(entry, selectionMode),
    );
  }

  Widget _buildDetailedPlaylistEntry(
    RoomMediaEntry entry,
    Color primaryColor,
    bool selectionMode,
  ) {
    final theme = Theme.of(context);
    final isCurrent = _currentStatus?.entry?.id == entry.id;
    final isSelected = _selectedMediaEntryIds.contains(entry.id);

    return AppPanelSurface(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.34)
          : theme.colorScheme.surface,
      border: Border.all(
        color: isCurrent
            ? primaryColor.withValues(alpha: 0.58)
            : theme.dividerColor.withValues(alpha: 0.12),
      ),
      child: InkWell(
        onTap: () => _handlePlaylistEntryPressed(entry, selectionMode),
        onLongPress: () =>
            _handlePlaylistEntryLongPressed(entry, selectionMode),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPlaylistArtwork(entry, isCurrent, primaryColor, size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: isCurrent ? primaryColor : null,
                              fontWeight: isCurrent
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (isCurrent)
                          Icon(
                            Icons.graphic_eq_rounded,
                            size: 18,
                            color: primaryColor,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _playlistEntrySummary(entry),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _playlistEntryChips(entry)
                          .map((label) => _buildPlaylistMetaChip(label))
                          .toList(growable: false),
                    ),
                  ],
                ),
              ),
              if (selectionMode) ...[
                const SizedBox(width: 8),
                _buildPlaylistSelectionIcon(
                  isSelected,
                  selectionMode,
                  primaryColor,
                )!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridPlaylistEntry(
    RoomMediaEntry entry,
    Color primaryColor,
    bool selectionMode,
  ) {
    final theme = Theme.of(context);
    final isCurrent = _currentStatus?.entry?.id == entry.id;
    final isSelected = _selectedMediaEntryIds.contains(entry.id);

    return AppPanelSurface(
      color: isSelected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.38)
          : theme.colorScheme.surface,
      border: Border.all(
        color: isCurrent
            ? primaryColor.withValues(alpha: 0.64)
            : theme.dividerColor.withValues(alpha: 0.12),
      ),
      child: InkWell(
        onTap: () => _handlePlaylistEntryPressed(entry, selectionMode),
        onLongPress: () =>
            _handlePlaylistEntryLongPressed(entry, selectionMode),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _buildPlaylistArtwork(
                      entry,
                      isCurrent,
                      primaryColor,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: _buildPlaylistMetaChip(
                      _playlistEntryTypeLabel(entry),
                    ),
                  ),
                  if (selectionMode)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: _buildPlaylistSelectionIcon(
                        isSelected,
                        selectionMode,
                        primaryColor,
                      )!,
                    ),
                  if (isCurrent)
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Icon(
                        Icons.graphic_eq_rounded,
                        size: 20,
                        color: primaryColor,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isCurrent ? primaryColor : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _playlistEntryShortMeta(entry),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
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

  Widget _buildPlaylistArtwork(
    RoomMediaEntry entry,
    bool isCurrent,
    Color primaryColor, {
    double? size,
    BoxFit fit = BoxFit.cover,
  }) {
    final theme = Theme.of(context);
    final imageUrl = entry.coverUrl.isNotEmpty
        ? entry.coverUrl
        : entry.thumbnailUrl;
    final icon = Icon(
      _playlistEntryIcon(entry),
      size: size == null ? 38 : 24,
      color: _playlistEntryAccent(entry, isCurrent, primaryColor),
    );
    final placeholder = AppPanelSurface(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.78),
      borderRadius: BorderRadius.circular(size == null ? 0 : 8),
      child: Center(child: icon),
    );
    if (size != null) {
      if (imageUrl.isEmpty) {
        return SizedBox(width: size, height: size, child: placeholder);
      }
      return AppImageThumbnail(
        url: imageUrl,
        width: size,
        height: size,
        fit: fit,
        errorChild: placeholder,
        borderRadius: BorderRadius.circular(8),
        semanticLabel: entry.name,
      );
    }
    if (imageUrl.isEmpty) return placeholder;
    return LayoutBuilder(
      builder: (context, constraints) {
        return AppImageThumbnail(
          url: imageUrl,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          fit: fit,
          errorChild: placeholder,
          borderRadius: BorderRadius.zero,
          semanticLabel: entry.name,
        );
      },
    );
  }

  Widget _buildPlaylistMetaChip(String label) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.82,
        ),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelSmall,
      ),
    );
  }

  Widget? _buildPlaylistSelectionIcon(
    bool isSelected,
    bool selectionMode,
    Color primaryColor,
  ) {
    if (!selectionMode) return null;
    return Icon(
      isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
      color: isSelected ? primaryColor : Colors.grey,
    );
  }

  void _handlePlaylistEntryPressed(RoomMediaEntry entry, bool selectionMode) {
    if (selectionMode) {
      _toggleSelection(entry);
    } else if (entry.isFolder) {
      _enterFolder(entry);
    } else {
      _switchMedia(entry);
    }
  }

  void _handlePlaylistEntryLongPressed(
    RoomMediaEntry entry,
    bool selectionMode,
  ) {
    if (_canMutateCurrentPlaylist &&
        !selectionMode &&
        _isPersistedLibraryEntry(entry)) {
      _enterSelectionMode(entry);
    }
  }

  IconData _playlistEntryIcon(RoomMediaEntry entry) {
    if (entry.isFolder) {
      return entry.isDynamicPlaylist || entry.isProviderDynamicItem
          ? Icons.folder_special_rounded
          : Icons.folder_rounded;
    }
    if (entry.live) return Icons.sensors_rounded;
    if (entry.type.toLowerCase().contains('audio')) {
      return Icons.music_note_rounded;
    }
    return Icons.movie_rounded;
  }

  Color _playlistEntryAccent(
    RoomMediaEntry entry,
    bool isCurrent,
    Color primaryColor,
  ) {
    if (isCurrent) return primaryColor;
    if (entry.isFolder) return Colors.amber;
    if (entry.live) return Colors.redAccent;
    return Theme.of(context).colorScheme.onSurfaceVariant;
  }

  String _playlistEntrySummary(RoomMediaEntry entry) {
    final description = entry.description.trim();
    if (description.isNotEmpty) return description;
    return _playlistEntryShortMeta(entry);
  }

  String _playlistEntryShortMeta(RoomMediaEntry entry) {
    final parts = <String>[_playlistEntryTypeLabel(entry)];
    if (entry.isFolder && entry.itemCount > 0) {
      parts.add('${entry.itemCount} 项');
    }
    final provider = _playlistProviderLabel(entry);
    if (provider.isNotEmpty) parts.add(provider);
    if (!entry.isFolder && entry.hasPlaybackChoices) parts.add('多线路');
    if (entry.proxy) parts.add('代理');
    return parts.join(' · ');
  }

  List<String> _playlistEntryChips(RoomMediaEntry entry) {
    final chips = <String>[_playlistEntryTypeLabel(entry)];
    if (entry.isFolder) {
      chips.add(entry.itemCount > 0 ? '${entry.itemCount} 项' : '可进入');
    }
    final provider = _playlistProviderLabel(entry);
    if (provider.isNotEmpty) chips.add(provider);
    if (entry.live) chips.add('直播');
    if (entry.proxy) chips.add('代理');
    if (!entry.isFolder && entry.hasPlaybackChoices) chips.add('多线路');
    if (entry.version > 0) chips.add('v${entry.version}');
    return chips;
  }

  String _playlistEntryTypeLabel(RoomMediaEntry entry) {
    if (entry.isDynamicPlaylist) return '动态播放列表';
    if (entry.isProviderDynamicItem && entry.isFolder) return '动态目录';
    if (entry.isProviderDynamicItem) return '动态媒体';
    if (entry.isPlaylist) return '播放列表';
    if (entry.live) return '直播';
    final type = entry.type.trim();
    if (type.isEmpty) return '媒体';
    return type.toUpperCase();
  }

  String _playlistProviderLabel(RoomMediaEntry entry) {
    final provider = entry.sourceProvider.trim().isNotEmpty
        ? entry.sourceProvider.trim()
        : entry.providerInstanceName.trim();
    return switch (provider.toLowerCase()) {
      'alist' => 'AList',
      'emby' => 'Emby',
      'bilibili' => 'Bilibili',
      'direct_url' || 'direct' => '直链',
      '' => '',
      _ => provider,
    };
  }

  Widget _buildMembersTab() {
    final theme = Theme.of(context);
    final primaryColor = Theme.of(context).primaryColor;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                '在线成员 ($_roomOnlineCount)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              AppBadge(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                borderRadius: BorderRadius.circular(20),
                icon: Icons.circle,
                iconSize: 8,
                color: Colors.green,
                backgroundColor: Colors.green.withValues(alpha: 0.1),
                textStyle: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                label: const Text('Live'),
              ),
            ],
          ),
        ),
        Expanded(
          child: AppRefreshIndicator(
            onRefresh: () async => _observeRoomMembers(),
            child: AppListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final member = _members[index];

                final myMemberInfo = _members
                    .where((m) => m.id == _currentUser?.id)
                    .firstOrNull;

                final viewerIsCreator =
                    _currentUser?.username == widget.room.creator;
                final viewerIsRoomAdmin =
                    myMemberInfo?.role ==
                    common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value;
                final viewerIsSysAdmin =
                    _currentUser?.role ==
                        common_enum.UserRole.USER_ROLE_ROOT.value ||
                    _currentUser?.role ==
                        common_enum.UserRole.USER_ROLE_ADMIN.value;
                int viewerLevel = 1;
                if (viewerIsCreator) {
                  viewerLevel = 3;
                } else if (viewerIsRoomAdmin) {
                  viewerLevel = 2;
                }
                if (viewerIsSysAdmin) {
                  viewerLevel = 4;
                }

                final isTargetCreator =
                    member.role ==
                        common_enum
                            .RoomMemberRole
                            .ROOM_MEMBER_ROLE_CREATOR
                            .value ||
                    member.username == widget.room.creator;
                final isTargetAdmin =
                    member.role ==
                    common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value;
                final isMe = _currentUser?.id == member.id;
                final targetLevel = isTargetCreator
                    ? 3
                    : (isTargetAdmin ? 2 : 1);
                final canKick = viewerLevel > targetLevel;

                final memberActions = <Widget>[
                  if (!isMe && !isTargetCreator) ...[
                    if ((viewerIsCreator || viewerIsRoomAdmin) &&
                        member.role ==
                            common_enum
                                .RoomMemberRole
                                .ROOM_MEMBER_ROLE_MEMBER
                                .value)
                      AppIconButton(
                        icon: Icons.admin_panel_settings_outlined,
                        tooltip: '设为管理',
                        onPressed: () => _setRoomAdmin(member),
                        size: AppIconButtonSize.sm,
                        iconSize: 18,
                        style: AppIconButtonStyle.tonal,
                      ),
                    if (viewerIsCreator && isTargetAdmin)
                      AppIconButton(
                        icon: Icons.remove_moderator_outlined,
                        tooltip: '取消管理',
                        onPressed: () => _removeRoomAdmin(member),
                        size: AppIconButtonSize.sm,
                        iconSize: 18,
                        style: AppIconButtonStyle.outlined,
                      ),
                    if (canKick)
                      AppIconButton(
                        icon: Icons.remove_circle_outline,
                        tooltip: '移除成员',
                        onPressed: () => _kickMember(member),
                        size: AppIconButtonSize.sm,
                        iconSize: 18,
                        style: AppIconButtonStyle.destructive,
                      ),
                    AppIconButton(
                      icon: Icons.flag_outlined,
                      tooltip: '举报成员',
                      onPressed: () => _showReportRoomMemberDialog(member),
                      size: AppIconButtonSize.sm,
                      iconSize: 18,
                      style: AppIconButtonStyle.outlined,
                    ),
                    AppIconButton(
                      icon: Icons.person_off_outlined,
                      tooltip: '举报用户',
                      onPressed: () => _showReportUserDialog(member),
                      size: AppIconButtonSize.sm,
                      iconSize: 18,
                      style: AppIconButtonStyle.outlined,
                    ),
                  ],
                ];

                return AppPanelSurface(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            _RoomAvatarFrame(
                              highlighted: isTargetCreator,
                              color: primaryColor,
                              child: AppAvatar(
                                name: member.username,
                                backgroundColor: primaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                foregroundColor: primaryColor,
                              ),
                            ),
                            if (isTargetCreator)
                              const Positioned(
                                right: 0,
                                bottom: 0,
                                child: Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.amber,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 132,
                                    ),
                                    child: Text(
                                      member.username,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (isMe)
                                    _RoomMiniBadge(
                                      label: '我',
                                      color: theme.primaryColor,
                                    ),
                                  if (isTargetAdmin) ...[
                                    _RoomMiniBadge(
                                      label: '管理员',
                                      color: Colors.blue,
                                      borderSide: BorderSide(
                                        color: Colors.blue.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                member.onlineCount > 0
                                    ? '在线 · ${member.connectionCount} 连接'
                                    : '离线 · 加入于 ${DateTime.fromMillisecondsSinceEpoch(member.createdAt * 1000).toString().substring(0, 10)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: member.onlineCount > 0
                                      ? Colors.green
                                      : theme.disabledColor,
                                  fontSize: 12,
                                ),
                              ),
                              if (memberActions.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Wrap(
                                    alignment: WrapAlignment.end,
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: memberActions,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _enterFolder(RoomMediaEntry folder) {
    setState(() {
      _folderStack.add(folder);
      _folderNameStack.add(folder.name);
      _isLoadingMediaEntries = true;
    });
    _observeCurrentPlaylist();
  }

  void _exitFolder() {
    if (_folderStack.isEmpty) return;
    setState(() {
      _folderStack.removeLast();
      _folderNameStack.removeLast();
      _isLoadingMediaEntries = true;
    });
    _observeCurrentPlaylist();
  }

  void _observeCurrentPlaylist() {
    final parentFolder = _folderStack.isNotEmpty ? _folderStack.last : null;
    try {
      _sendRealtimeMessage(
        RoomRealtimeCodec.encodePlaylistObservation(
          playlistId: parentFolder?.playbackPlaylistId ?? '',
          target: parentFolder?.playbackTarget,
          page: 1,
          pageSize: _pageSize,
        ),
      );
    } catch (e) {
      debugPrint('Observe playlist error: $e');
      if (mounted) MessageUtils.showError(context, '播放列表订阅失败');
    }
  }

  Future<void> _switchMedia(RoomMediaEntry entry) async {
    try {
      final playback = await SyncTvService.switchMediaAndPlay(
        widget.room.roomId,
        entry.id,
        subPath: entry.subPath,
        playlistId: entry.parentId,
      );
      await _applyPlaybackStatus(playback);
      _requestPlaybackSnapshot();
      if (mounted) MessageUtils.showSuccess(context, '已切换并播放');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '切换失败: $e');
    }
  }

  void _enterSelectionMode(RoomMediaEntry entry) {
    if (!_canMutateCurrentPlaylist) return;
    setState(() {
      _isSelectionMode = true;
      _selectedMediaEntryIds.clear();
      _selectedMediaEntryIds.add(entry.id);
    });
  }

  void _toggleSelection(RoomMediaEntry entry) {
    if (!_canMutateCurrentPlaylist) return;
    if (!_isPersistedLibraryEntry(entry)) return;
    setState(() {
      if (_selectedMediaEntryIds.contains(entry.id)) {
        _selectedMediaEntryIds.remove(entry.id);
        if (_selectedMediaEntryIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedMediaEntryIds.add(entry.id);
      }
    });
  }

  void _selectAll() {
    if (!_canMutateCurrentPlaylist) return;
    setState(() {
      final selectable = _mediaEntries
          .where(_isPersistedLibraryEntry)
          .map((entry) => entry.id)
          .toList();
      if (_selectedMediaEntryIds.length == selectable.length) {
        _selectedMediaEntryIds.clear();
      } else {
        _selectedMediaEntryIds.clear();
        _selectedMediaEntryIds.addAll(selectable);
      }
    });
  }

  bool _isPersistedLibraryEntry(RoomMediaEntry entry) {
    return !entry.isProviderDynamicEntry &&
        (entry.id.startsWith('med_') || entry.id.startsWith('pl_'));
  }

  bool get _isInsideProviderTargetScope {
    return _folderStack.any(
      (folder) =>
          folder.isDynamicPlaylist || (folder.playbackTarget ?? '').isNotEmpty,
    );
  }

  String get _currentPersistedPlaylistId {
    if (_folderStack.isEmpty || _isInsideProviderTargetScope) return '';
    final folder = _folderStack.last;
    return folder.id.startsWith('pl_') ? folder.id : '';
  }

  bool get _canMutateCurrentPlaylist => !_isInsideProviderTargetScope;

  Future<void> _deleteSelectedMediaEntries() async {
    if (!_canMutateCurrentPlaylist) return;
    if (_selectedMediaEntryIds.isEmpty) return;

    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '删除条目',
      icon: const Icon(Icons.delete_outline, color: Colors.red),
      content: Text('确定要删除选中的 ${_selectedMediaEntryIds.length} 个媒体条目吗？'),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: '删除',
        ),
      ],
    );

    if (confirmed == true) {
      try {
        final canClearScope = _canMutateCurrentPlaylist;
        final selectableCount = _mediaEntries
            .where(_isPersistedLibraryEntry)
            .length;
        final isAllLoadedSelected =
            _selectedMediaEntryIds.length == selectableCount;
        final mediaIds = _selectedMediaEntryIds
            .where((id) => id.startsWith('med_'))
            .toList();
        final playlistIds = _selectedMediaEntryIds
            .where((id) => id.startsWith('pl_'))
            .toList();
        if (mediaIds.isEmpty && playlistIds.isEmpty) {
          if (mounted) MessageUtils.showInfo(context, '动态目录内容不能在房间内删除');
          return;
        }
        if (isAllLoadedSelected && !_hasMoreMediaEntries && canClearScope) {
          await SyncTvService.clearMediaLibrary(
            widget.room.roomId,
            parentId: _currentPersistedPlaylistId.isEmpty
                ? null
                : _currentPersistedPlaylistId,
          );
        } else {
          await SyncTvService.deleteMediaLibraryEntries(
            widget.room.roomId,
            mediaIds: mediaIds,
            playlistIds: playlistIds,
          );
        }

        setState(() {
          _isSelectionMode = false;
          _selectedMediaEntryIds.clear();
        });
        _observeCurrentPlaylist();
        if (mounted) MessageUtils.showInfo(context, '已删除');
      } catch (e) {
        if (mounted) MessageUtils.showError(context, '删除失败: $e');
      }
    }
  }

  Future<void> _stopPlayback() async {
    try {
      await SyncTvService.switchMedia(widget.room.roomId, '', subPath: '');
      if (mounted) {
        MessageUtils.showSuccess(context, '已停止播放');
        _disposeVideoController();
        setState(() {
          _currentStatus = null;
        });
      }
    } catch (e) {
      if (mounted) {
        MessageUtils.showError(context, '停止播放失败: $e');
      }
    }
  }

  Future<void> _openRoomSettings() async {
    if (!_canManageRoom) {
      MessageUtils.showWarning(context, '仅房主和管理员可管理房间');
      return;
    }
    showAppDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AppLoadingIndicator(),
    );

    try {
      final settings = await SyncTvService.getRoomSettings(widget.room.roomId);

      if (mounted) {
        Navigator.pop(context);

        final deleted = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => RoomSettingsPage(
              roomId: widget.room.roomId,
              roomName: widget.room.roomName,
              creatorId: widget.room.creatorId,
              currentUserId: _currentUser?.id ?? '',
              currentSettings: settings,
              realtime: RoomRealtimeSession(
                send: _sendRealtimeMessage,
                messages: _realtimeMessageBus.stream,
                events: _realtimeEventBus.stream,
                reconnects: _realtimeReconnectBus.stream,
              ),
            ),
          ),
        );
        if (!mounted) return;
        if (deleted == true) {
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        MessageUtils.showError(context, '获取设置失败: $e');
      }
    }
  }

  Future<void> _showAddMediaDialog() async {
    if (!_canMutateCurrentPlaylist) return;
    await AddMediaDialog.show(
      context,
      widget.room.roomId,
      parentId: _currentPersistedPlaylistId.isEmpty
          ? null
          : _currentPersistedPlaylistId,
    );
    _observeCurrentPlaylist();
  }

  Future<void> _setRoomAdmin(SyncTvUser member) async {
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '设为管理员',
      icon: const Icon(Icons.admin_panel_settings_rounded, color: Colors.blue),
      content: Text('确定要将 ${member.username} 设为管理员吗？\n管理员拥有踢人、管理成员等权限。'),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: '确定',
        ),
      ],
    );

    if (confirmed == true) {
      try {
        await SyncTvService.setRoomAdmin(widget.room.roomId, member.id);
        _observeRoomMembers();
        if (mounted) {
          MessageUtils.showSuccess(context, '已将 ${member.username} 设为管理员');
        }
      } catch (e) {
        if (mounted) MessageUtils.showError(context, '设置失败: $e');
      }
    }
  }

  Future<void> _removeRoomAdmin(SyncTvUser member) async {
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '取消管理员',
      icon: const Icon(Icons.remove_moderator_rounded, color: Colors.orange),
      content: Text('确定要取消 ${member.username} 的管理员权限吗？'),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: '确定',
        ),
      ],
    );

    if (confirmed == true) {
      try {
        await SyncTvService.removeRoomAdmin(widget.room.roomId, member.id);
        _observeRoomMembers();
        if (mounted) {
          MessageUtils.showSuccess(context, '已取消 ${member.username} 的管理员权限');
        }
      } catch (e) {
        if (mounted) MessageUtils.showError(context, '取消失败: $e');
      }
    }
  }

  Future<void> _kickMember(SyncTvUser member) async {
    final cooldown = await _askKickCooldownSeconds(member.username);
    if (cooldown == null) return;
    try {
      await SyncTvService.kickMember(
        widget.room.roomId,
        member.id,
        kickCooldownSeconds: cooldown,
      );
      _observeRoomMembers();
      if (mounted) MessageUtils.showSuccess(context, '已踢出成员');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '踢出失败: $e');
    }
  }

  Future<int?> _askKickCooldownSeconds(String username) async {
    final controller = TextEditingController(text: '60');
    final value = await showAppDialog<int>(
      context: context,
      builder: (dialogContext) => AppDialog(
        title: const Text('踢出成员'),
        icon: const Icon(Icons.remove_circle_outline),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('确定要踢出 $username，并设置重新加入冷却时间。'),
            const SizedBox(height: 12),
            AppTextField(
              controller: controller,
              label: '冷却秒数',
              hintText: '1 - 2592000',
              prefixIcon: Icons.timer_outlined,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          AppActionButton(
            onPressed: () => Navigator.pop(dialogContext),
            label: '取消',
            style: AppActionButtonStyle.text,
          ),
          AppActionButton(
            onPressed: () {
              final seconds = int.tryParse(controller.text.trim());
              if (seconds == null || seconds < 1 || seconds > 2592000) {
                MessageUtils.showWarning(context, '请输入 1 到 2592000 之间的秒数');
                return;
              }
              Navigator.pop(dialogContext, seconds);
            },
            icon: Icons.logout_rounded,
            label: '踢出',
            style: AppActionButtonStyle.destructive,
          ),
        ],
      ),
    );
    controller.dispose();
    return value;
  }

  Future<void> _pickChatImage() async {
    try {
      final image = await pickLocalImageUpload(context);
      if (image == null || !mounted) return;
      setState(() => _selectedChatImage = image);
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '选择图片失败: $e');
    }
  }

  Future<void> _sendMessage(String text) async {
    final content = text.trim();
    final selectedImage = _selectedChatImage;
    if (content.isEmpty && selectedImage == null) return;
    if (_sendingChatMessage) return;

    setState(() => _sendingChatMessage = true);
    try {
      final images = <StoredImageInfo>[];
      final replyToMessageId = _replyingToMessage?.id ?? '';
      if (selectedImage != null) {
        images.add(
          await SyncTvService.uploadChatImage(
            widget.room.roomId,
            selectedImage.upload,
          ),
        );
      }
      final message = await SyncTvService.sendChatMessage(
        widget.room.roomId,
        content: content,
        images: images,
        replyToMessageId: replyToMessageId,
        mentions: _pendingChatMentions,
      );
      final entry = RoomRealtimeChatEntry.fromHistory(message);
      _messageController.clear();
      if (mounted) {
        setState(() {
          _messages.applyRealtimeEvent(
            entry,
            eventKind: RoomRealtimeChatEventKind.created,
            maxEntries: 100,
          );
          _indexChatMessage(entry);
          _selectedChatImage = null;
          _replyingToMessage = null;
          _pendingChatMentions = [];
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('Send message error: $e');
      if (mounted) MessageUtils.showError(context, '发送失败: $e');
    } finally {
      if (mounted) setState(() => _sendingChatMessage = false);
    }
  }
}

class _RoomMiniBadge extends StatelessWidget {
  final String label;
  final Color color;
  final BorderSide? borderSide;

  const _RoomMiniBadge({
    required this.label,
    required this.color,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    return AppBadge(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      borderRadius: BorderRadius.circular(4),
      color: color,
      backgroundColor: color.withValues(alpha: 0.1),
      borderSide: borderSide,
      textStyle: TextStyle(fontSize: 10, color: color),
      label: Text(label),
    );
  }
}

class _PlaybackSyncSlider extends StatelessWidget {
  final IconData icon;
  final String title;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final bool enabled;
  final ValueChanged<double> onChanged;

  const _PlaybackSyncSlider({
    required this.icon,
    required this.title,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = enabled
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: 0.38);
    return AppPanelSurface(
      padding: const EdgeInsets.all(14),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                valueLabel,
                style: theme.textTheme.labelLarge?.copyWith(color: color),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Material(
            type: MaterialType.transparency,
            child: AppSlider(
              value: value.clamp(min, max).toDouble(),
              min: min,
              max: max,
              divisions: divisions,
              label: valueLabel,
              onChanged: enabled ? onChanged : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoomAvatarFrame extends StatelessWidget {
  final Widget child;
  final bool highlighted;
  final Color color;

  const _RoomAvatarFrame({
    required this.child,
    required this.highlighted,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppPanelSurface(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(2),
      color: color.withValues(alpha: 0.1),
      shape: BoxShape.circle,
      border: Border.all(
        color: highlighted ? color : Colors.transparent,
        width: 2,
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
