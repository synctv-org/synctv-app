import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:synctv_app/models/direct_url_source_config.dart';
import 'package:synctv_app/models/room_management_models.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/models/room_realtime_codec.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/services/room_realtime_connection.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/utils/chat_utils.dart';
import 'package:synctv_app/pages/mobile/room_settings_page.dart';
import 'package:synctv_app/widgets/add_movie_dialog.dart';
import 'package:synctv_app/widgets/custom_video_player.dart';
import 'package:synctv_app/widgets/room_invite_actions.dart';
import 'package:synctv_app/widgets/chat_input_area.dart';
import 'package:synctv_app/managers/webrtc_manager.dart';
import 'package:synctv_app/models/danmaku_model.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;

class DesktopRoomScreen extends StatefulWidget {
  final WRoom room;

  const DesktopRoomScreen({super.key, required this.room});

  @override
  State<DesktopRoomScreen> createState() => _DesktopRoomScreenState();
}

class _DesktopRoomScreenState extends State<DesktopRoomScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  VideoPlayerController? _videoPlayerController;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final List<RoomRealtimeChatEntry> _messages = [];
  Timer? _syncTimer;
  WPlaybackStatus? _currentStatus;
  RoomRealtimeConnection? _channel;
  List<WUser> _members = [];
  List<WMovie> _movies = [];
  bool _isLoadingMovies = true;
  bool _isVideoLoading = false;
  String? _videoError;

  // Pagination
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMoreMovies = true;
  bool _isLoadingMoreMovies = false;
  final ScrollController _movieScrollController = ScrollController();

  // Folder navigation
  final List<WMovie> _folderStack = [];
  final List<String> _folderNameStack = ['根目录'];

  WUser? _currentUser;

  // Sync state
  bool _isSyncing = false;
  Timer? _updateDebounce;
  bool _lastPlaying = false;
  double _lastRate = 1.0;
  double _lastPosition = 0.0;
  DateTime? _lastPlaybackSampleAt;
  DateTime? _lastProgressReportAt;
  final Set<String> _warnedPlaybackCredentialHeaderKeys = {};

  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;

  StreamSubscription? _realtimeSubscription;
  StreamSubscription? _authErrorSubscription;

  WebRTCManager? _webrtcManager;

  // Danmaku Stream
  final DanmakuController _danmakuController = DanmakuController();

  bool _isSelectionMode = false;
  final Set<String> _selectedMovieIds = {};

  bool get _isHarmony => Platform.operatingSystem.toLowerCase() == 'ohos';
  bool get _canManageRoom {
    final user = _currentUser;
    if (user == null) return false;
    if (user.id.isNotEmpty && user.id == widget.room.creatorId) return true;
    final isSystemAdmin =
        user.role == common_enum.UserRole.USER_ROLE_ROOT.value ||
            user.role == common_enum.UserRole.USER_ROLE_ADMIN.value;
    if (isSystemAdmin) return true;
    return _members.any((member) =>
        member.id == user.id &&
        member.role == common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value);
  }

  @override
  void initState() {
    super.initState();
    _authErrorSubscription = WatchTogetherService.onAuthError.listen((_) {
      if (mounted) {
        _disposeVideoController();
        _channel?.sink.close();
        _reconnectTimer?.cancel();
        _webrtcManager?.leave();

        Navigator.of(context).pop();
      }
    });
    _tabController = TabController(length: _isHarmony ? 2 : 3, vsync: this);

    // Initialize WebRTC Manager
    _webrtcManager = WebRTCManager(
      loadIceServers: () => _loadWebRtcIceServers(),
      onSignalingMessage: (type, data) {
        if (_channel != null) {
          try {
            final bytes = RoomRealtimeCodec.encodeWebRtcSignal(type, data);
            if (bytes.isNotEmpty) _channel!.sink.add(bytes);
          } catch (e) {
            debugPrint('WebRTC encode error: $e');
          }
        }
      },
      onStateChange: () {
        if (mounted) setState(() {});
      },
    );

    _movieScrollController.addListener(_onMovieScroll);
    _joinRoom();
  }

  Future<void> _joinRoom() async {
    _connectRealtime();

    Future.wait([
      _fetchCurrentUser(),
      _loadChatHistory(),
    ]).catchError((e) {
      debugPrint('Background data fetch error: $e');
      return <void>[];
    });
  }

  Future<void> _fetchCurrentUser() async {
    try {
      final user = await WatchTogetherService.getMe();
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
      final page = await WatchTogetherService.getChatHistory(
        widget.room.roomId,
        limit: 100,
      );
      final history = page.messages
          .map(RoomRealtimeChatEntry.fromHistory)
          .toList()
          .reversed;
      if (mounted) {
        setState(() {
          _messages.prependUnique(history, maxEntries: 100);
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint('Fetch chat history error: $e');
    }
  }

  void _sortMembers(List<WUser> members) {
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
    return WatchTogetherService.getIceServers(widget.room.roomId);
  }

  void _onMovieScroll() {
    if (_movieScrollController.position.pixels >=
        _movieScrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMoreMovies && _hasMoreMovies) {
        _loadMoreMovies();
      }
    }
  }

  Future<void> _loadMoreMovies() async {
    if (_isLoadingMoreMovies) return;

    setState(() {
      _isLoadingMoreMovies = true;
    });

    try {
      final parentFolder = _folderStack.isNotEmpty ? _folderStack.last : null;
      final result = await WatchTogetherService.listMediaLibrary(
          widget.room.roomId,
          playlistId: parentFolder?.playbackWatchPlaylistId ?? '',
          target: parentFolder?.playbackWatchTarget,
          page: _currentPage + 1,
          pageSize: _pageSize);

      final movies = result.entries;
      final total = result.total;

      if (mounted) {
        setState(() {
          if (movies.isNotEmpty) {
            _movies.addAll(movies);
            _currentPage++;
            _hasMoreMovies = _movies.length < total;
          } else {
            _hasMoreMovies = false;
          }
          _isLoadingMoreMovies = false;
        });
      }
    } catch (e) {
      debugPrint('Load more movies error: $e');
      if (mounted) {
        setState(() {
          _isLoadingMoreMovies = false;
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
      _channel = RoomRealtimeConnection.connect(
        widget.room.roomId,
        initialMessages: RoomRealtimeCodec.encodeInitialObservations(),
      );

      _realtimeSubscription = _channel!.stream.listen(
        (data) {
          _reconnectAttempts = 0;
          try {
            final message = RoomRealtimeCodec.decode(data);
            _handleRealtimeMessage(message);
          } catch (e) {
            debugPrint('Proto decode error: $e');
          }
        },
        onError: (error) {
          debugPrint('Realtime stream error: $error');
          _scheduleReconnect();
        },
        onDone: () {
          debugPrint('Realtime stream closed');
          _scheduleReconnect();
        },
      );
    } catch (e) {
      debugPrint('Realtime stream connection error: $e');
      _scheduleReconnect();
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
        'Scheduling reconnect attempt $_reconnectAttempts in ${delay.inSeconds}s');

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
      final username =
          message.senderUsername.isEmpty ? 'Unknown' : message.senderUsername;

      if (_videoPlayerController != null &&
          _videoPlayerController!.value.isInitialized) {
        final currentPos = _videoPlayerController!.value.position;
        final danmaku = DanmakuItem(
          text: '$username: $content',
          startTime: currentPos,
          endTime: currentPos + const Duration(seconds: 8),
          color: Colors.white,
          type: DanmakuType.floating,
        );
        _danmakuController.add(danmaku);
      }

      if (mounted) {
        setState(() {
          _messages.appendUnique(
            RoomRealtimeChatEntry.fromMessage(message),
            maxEntries: 100,
          );
        });
        _scrollToBottom();
      }
    } else if (type == RoomRealtimeMessageKind.sync ||
        type == RoomRealtimeMessageKind.status ||
        type == RoomRealtimeMessageKind.checkStatus) {
      final playbackStatus = message.playbackStatus;
      if (playbackStatus != null) {
        _applyPlaybackStatus(
          _mergePlaybackStatus(playbackStatus, incomingHasTiming: true),
        );
      } else if (message.status != null) {
        final status = message.status!;
        _applyPlaybackStatus(
          WPlaybackStatus(
            movie: _currentStatus?.movie,
            isPlaying: status.isPlaying,
            currentTime: status.currentTime,
            playbackRate: status.playbackRate,
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
      return;
    } else if (type == RoomRealtimeMessageKind.memberEvent) {
      return;
    } else if (type == RoomRealtimeMessageKind.movies) {
      final mediaLibrary = message.mediaLibrary;
      if (mediaLibrary == null) {
        _reportInvalidRealtimePayload('播放列表');
      } else {
        _applyMediaLibrary(mediaLibrary);
      }
    } else if (type == RoomRealtimeMessageKind.viewerCount) {
      final members = message.members;
      if (members == null) {
        _reportInvalidRealtimePayload('成员列表');
      } else {
        _applyMembers(members);
      }
    } else if (type == RoomRealtimeMessageKind.error) {
      final errorMsg = message.error?.message ?? '';
      if (errorMsg.isNotEmpty && mounted) {
        MessageUtils.showError(context, '错误: $errorMsg');
      }
    } else if (type == RoomRealtimeMessageKind.expired) {
      if (mounted) {
        MessageUtils.showError(context, '登录已过期，请重新登录');
        Navigator.of(context).pop();
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

  WPlaybackStatus _mergePlaybackStatus(
    WPlaybackStatus incoming, {
    required bool incomingHasTiming,
  }) {
    final current = _currentStatus;
    final incomingMovie = incoming.movie;
    final currentMovie = current?.movie;
    final hasSameMovie = currentMovie != null &&
        incomingMovie != null &&
        currentMovie.hasSamePlaybackIdentity(incomingMovie);
    final mergedMovie = incomingMovie == null
        ? incomingHasTiming
            ? null
            : currentMovie
        : incomingMovie.url.isEmpty &&
                currentMovie != null &&
                currentMovie.url.isNotEmpty &&
                hasSameMovie
            ? currentMovie
            : hasSameMovie
                ? incomingMovie.url.isEmpty
                    ? currentMovie
                    : incomingMovie.withPlaybackIdentityFrom(currentMovie)
                : incomingMovie;
    return WPlaybackStatus(
      movie: mergedMovie,
      isPlaying: incomingHasTiming
          ? incoming.isPlaying
          : current?.isPlaying ?? incoming.isPlaying,
      currentTime: incomingHasTiming
          ? incoming.currentTime
          : current?.currentTime ?? incoming.currentTime,
      playbackRate: incomingHasTiming
          ? incoming.playbackRate
          : current?.playbackRate ?? incoming.playbackRate,
    );
  }

  void _applyMediaLibrary(RoomMediaLibraryPage mediaLibrary) {
    if (!mounted) return;
    setState(() {
      _movies = mediaLibrary.entries;
      _currentPage = 1;
      _hasMoreMovies = mediaLibrary.total > _movies.length;
      _isLoadingMovies = false;
      _selectedMovieIds.removeWhere(
        (id) => !_movies.any((movie) => movie.id == id),
      );
      if (_selectedMovieIds.isEmpty) _isSelectionMode = false;
    });
  }

  void _applyMembers(List<WUser> members) {
    if (!mounted) return;
    _sortMembers(members);
    setState(() => _members = members);
  }

  void _reportInvalidRealtimePayload(String resourceName) {
    final message = '服务端未推送$resourceName快照';
    debugPrint(message);
    if (mounted) MessageUtils.showError(context, message);
  }

  Future<void> _performSync(
      bool isPlaying, double currentTime, double playbackRate) async {
    if (_videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) {
      return;
    }

    _isSyncing = true;

    try {
      if ((_videoPlayerController!.value.playbackSpeed - playbackRate).abs() >
          0.1) {
        await _videoPlayerController!.setPlaybackSpeed(playbackRate);
        _lastRate = playbackRate;
      }

      final currentPos =
          _videoPlayerController!.value.position.inMilliseconds / 1000.0;
      final targetTime = _boundedPlaybackTime(currentTime);
      final shouldStopAtEnd = _isPlaybackTimePastDuration(currentTime);
      final targetIsPlaying = shouldStopAtEnd ? false : isPlaying;
      if (!targetIsPlaying && _videoPlayerController!.value.isPlaying) {
        await _videoPlayerController!.pause();
        _lastPlaying = false;
      }
      if ((currentPos - targetTime).abs() > 1.0) {
        await _videoPlayerController!
            .seekTo(Duration(milliseconds: (targetTime * 1000).toInt()));
        _lastPosition = targetTime;
      }

      if (targetIsPlaying && !_videoPlayerController!.value.isPlaying) {
        await _videoPlayerController!.play();
        _lastPlaying = true;
      }
    } catch (e) {
      debugPrint('Sync execution error: $e');
    } finally {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) _isSyncing = false;
      });
    }
  }

  double _boundedPlaybackTime(double currentTime) {
    if (!currentTime.isFinite || currentTime < 0) return 0;
    final duration = _videoPlayerController?.value.duration;
    if (duration == null || duration <= Duration.zero) return currentTime;
    final durationSeconds = duration.inMilliseconds / 1000.0;
    if (durationSeconds <= 0) return currentTime;
    final maxPlayable = durationSeconds > 0.25 ? durationSeconds - 0.25 : 0.0;
    return currentTime.clamp(0.0, maxPlayable).toDouble();
  }

  bool _isPlaybackTimePastDuration(double sourceTime) {
    final duration = _videoPlayerController?.value.duration;
    if (duration == null || duration <= Duration.zero) return false;
    final durationSeconds = duration.inMilliseconds / 1000.0;
    return durationSeconds > 0 && sourceTime > durationSeconds;
  }

  void _videoListener() {
    if (_isSyncing ||
        _videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) {
      return;
    }

    final value = _videoPlayerController!.value;
    final isPlaying = value.isPlaying;
    final position =
        _boundedPlaybackTime(value.position.inMilliseconds / 1000.0);
    final rate = value.playbackSpeed;
    final now = DateTime.now();
    final previousSampleAt = _lastPlaybackSampleAt;
    final previousPlaying = _lastPlaying;
    final previousRate = _lastRate;
    final previousPosition = _lastPosition;

    final isPlayPauseChanged = isPlaying != previousPlaying;
    final isRateChanged = rate != previousRate;
    var isSeekChanged = false;

    if (previousSampleAt != null) {
      final elapsedSeconds =
          now.difference(previousSampleAt).inMilliseconds / 1000.0;
      final expectedDelta =
          previousPlaying ? elapsedSeconds * previousRate : 0.0;
      final actualDelta = position - previousPosition;
      isSeekChanged = (actualDelta - expectedDelta).abs() > 2.0;
    } else if (position > 2.0) {
      isSeekChanged = true;
    }

    _lastPlaying = isPlaying;
    _lastRate = rate;
    _lastPosition = position;
    _lastPlaybackSampleAt = now;

    if (isPlayPauseChanged || isRateChanged || isSeekChanged) {
      if (_updateDebounce?.isActive ?? false) _updateDebounce!.cancel();
      if (isPlayPauseChanged && mounted && !_isSyncing) {
        _sendPlaybackUpdate(
          isPlaying ? PlaybackControlAction.play : PlaybackControlAction.pause,
          isPlaying,
          position,
          rate,
        );
        return;
      }

      if (isRateChanged && mounted && !_isSyncing) {
        _sendPlaybackUpdate(
          PlaybackControlAction.speed,
          isPlaying,
          position,
          rate,
        );
        return;
      }

      _updateDebounce = Timer(const Duration(milliseconds: 500), () {
        if (mounted && !_isSyncing) {
          final currentValue = _videoPlayerController!.value;
          _sendPlaybackUpdate(
              PlaybackControlAction.seek,
              currentValue.isPlaying,
              _boundedPlaybackTime(
                  currentValue.position.inMilliseconds / 1000.0),
              currentValue.playbackSpeed);
        }
      });
      return;
    }

    if (isPlaying &&
        (_lastProgressReportAt == null ||
            now.difference(_lastProgressReportAt!).inSeconds >= 5)) {
      _lastProgressReportAt = now;
      _sendPlaybackProgress(isPlaying, position);
    }
  }

  void _sendPlaybackUpdate(
    PlaybackControlAction action,
    bool isPlaying,
    double position,
    double rate,
  ) {
    try {
      final safePosition = _boundedPlaybackTime(position);
      _channel?.sink.add(
        RoomRealtimeCodec.encodePlaybackUpdate(
          action,
          isPlaying: isPlaying,
          position: safePosition,
          playbackRate: rate,
        ),
      );
    } catch (e) {
      debugPrint('Realtime playback update error: $e');
      if (mounted) MessageUtils.showError(context, '播放状态更新失败');
    }
  }

  void _sendPlaybackProgress(bool isPlaying, double position) {
    if (_channel != null) {
      try {
        final bytes = RoomRealtimeCodec.encodePlaybackProgress(
            isPlaying, _boundedPlaybackTime(position));
        _channel!.sink.add(bytes);
      } catch (e) {
        debugPrint('Send playback progress error: $e');
      }
    }
  }

  void _requestPlaybackSnapshot() {
    try {
      for (final bytes in RoomRealtimeCodec.encodePlaybackObservations()) {
        _channel?.sink.add(bytes);
      }
    } catch (e) {
      debugPrint('Request playback snapshot error: $e');
    }
  }

  Future<void> _applyPlaybackStatus(WPlaybackStatus status) async {
    if (!mounted) return;
    final oldMovieId = _currentStatus?.movie?.id;
    final nextMovieId = status.movie?.id;
    if (oldMovieId != nextMovieId) {
      _danmakuController.clear();
    }

    setState(() {
      _currentStatus = status;
      if (status.movie == null || status.movie!.url.isEmpty) {
        _isVideoLoading = false;
        _videoError = null;
      }
    });

    if (status.movie != null && status.movie!.url.isNotEmpty) {
      final newUrl = WatchTogetherService.resolveResourceUrl(status.movie!.url);

      if (_videoPlayerController == null ||
          _videoPlayerController!.dataSource != newUrl) {
        await _initVideo(newUrl, headers: status.movie!.headers);
        if (mounted &&
            _videoPlayerController != null &&
            _videoPlayerController!.value.isInitialized) {
          _performSync(
            status.isPlaying,
            status.currentTime,
            status.playbackRate,
          );
        }
      } else {
        _performSync(
          status.isPlaying,
          status.currentTime,
          status.playbackRate,
        );
      }

      final streamUrl = status.movie!.streamDanmu == null
          ? null
          : WatchTogetherService.resolveResourceUrl(status.movie!.streamDanmu!);
      final danmuUrl = status.movie!.danmu == null
          ? null
          : WatchTogetherService.resolveResourceUrl(status.movie!.danmu!);

      _danmakuController.updateConfig(
        danmakuUrl: danmuUrl,
        streamDanmakuUrl: streamUrl,
        controller: _videoPlayerController,
      );
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

      if (!mounted) {
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
      if (mounted) {
        setState(() {
          _isVideoLoading = false;
          _videoError = '视频加载失败';
        });
        MessageUtils.showError(context, '视频加载失败');
      }
    }
  }

  Widget _buildVideoPlaceholder() {
    final hasPlayback = _currentStatus?.movie?.url.isNotEmpty == true;
    final icon = _videoError != null
        ? Icons.error_outline_rounded
        : hasPlayback
            ? Icons.hourglass_top_rounded
            : Icons.ondemand_video_rounded;
    final message =
        _videoError ?? (_isVideoLoading || hasPlayback ? '正在加载视频' : '等待播放');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white54, size: 64),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(color: Colors.white54, fontSize: 18),
        ),
      ],
    );
  }

  void _warnPlaybackCredentialHeaders(Map<String, String> headers) {
    final key = DirectUrlSourceConfig.credentialHeaderRiskKey(headers);
    if (key.isEmpty || !_warnedPlaybackCredentialHeaderKeys.add(key)) return;
    final names =
        DirectUrlSourceConfig.credentialHeaderNames(headers).join('、');
    MessageUtils.showWarning(
      context,
      '当前播放地址携带 $names。此类凭据来自播放信息，房间成员可能获取并用于请求媒体资源。',
    );
  }

  void _disposeVideoController() {
    _videoPlayerController?.removeListener(_videoListener);
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
    _updateDebounce?.cancel();
  }

  @override
  void dispose() {
    _authErrorSubscription?.cancel();
    _realtimeSubscription?.cancel();
    _tabController.dispose();
    _disposeVideoController();
    _syncTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _messageController.dispose();
    _chatScrollController.dispose();
    _movieScrollController.dispose();
    _webrtcManager?.dispose();
    _danmakuController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final sidebarWidth = media.size.width >= 1440 ? 420.0 : 360.0;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.room.roomName),
        backgroundColor: theme.appBarTheme.backgroundColor,
        actions: [
          if (_currentStatus?.movie != null)
            IconButton(
              onPressed: _stopPlayback,
              icon: const Icon(Icons.stop_circle_outlined, color: Colors.red),
              tooltip: '停止播放',
            ),
          if (_currentUser != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilledButton.tonalIcon(
                onPressed: _openRoomSettings,
                icon: Icon(
                  _canManageRoom
                      ? Icons.tune_rounded
                      : Icons.lock_outline_rounded,
                  size: 18,
                ),
                label: const Text('房间管理'),
              ),
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: DecoratedBox(
                        decoration: const BoxDecoration(color: Colors.black),
                        child: Center(
                          child: _videoPlayerController != null &&
                                  _videoPlayerController!.value.isInitialized
                              ? CustomVideoPlayer(
                                  controller: _videoPlayerController!,
                                  title: _currentStatus?.movie?.name ?? '未知影片',
                                  danmakuController: _danmakuController,
                                  subtitles: _currentStatus?.movie?.subtitles,
                                  onToggleFullScreen: _toggleFullScreen,
                                  onSync: _handleSync,
                                  interactionMode:
                                      VideoPlayerInteractionMode.desktop,
                                )
                              : _buildVideoPlaceholder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: sidebarWidth,
              child: _buildRoomSidePanel(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomSidePanel(ThemeData theme) {
    return Material(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.7)),
      ),
      clipBehavior: Clip.antiAlias,
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
                  '${_members.length} 人',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => copyRoomInviteLink(context, widget.room),
                  icon: const Icon(Icons.ios_share_rounded),
                  tooltip: '复制邀请链接',
                ),
              ],
            ),
          ),
          _buildTabBar(theme),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _isHarmony
                  ? [
                      _buildPlaylistTab(),
                      _buildMembersTab(),
                    ]
                  : [
                      _buildChatTab(),
                      _buildPlaylistTab(),
                      _buildMembersTab(),
                    ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleSync() {
    if (_channel == null) return;
    _requestPlaybackSnapshot();
    if (mounted) {
      MessageUtils.showInfo(
        context,
        '已请求同步',
        duration: const Duration(seconds: 1),
      );
    }
  }

  void _observeRoomMembers() {
    try {
      _channel?.sink.add(RoomRealtimeCodec.encodeRoomMembersObservation());
    } catch (e) {
      debugPrint('Observe room members error: $e');
      if (mounted) {
        MessageUtils.showError(context, '成员列表订阅失败');
      }
    }
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
          title: _currentStatus?.movie?.name ?? '未知影片',
          danmakuController: _danmakuController,
          subtitles: _currentStatus?.movie?.subtitles,
          onToggleFullScreen: () => Navigator.of(context).pop(),
          onSync: _handleSync,
          onSendDanmaku: _sendDanmaku,
          isFullScreen: true,
          interactionMode: VideoPlayerInteractionMode.desktop,
        ),
      ),
    );
  }

  void _sendDanmaku(String text) {
    if (text.trim().isEmpty) return;
    if (_channel != null) {
      try {
        final bytes = RoomRealtimeCodec.encodeChat(text);
        _channel!.sink.add(bytes);
      } catch (e) {
        debugPrint('Send danmaku error: $e');
        if (mounted) MessageUtils.showError(context, '弹幕发送失败: $e');
      }
    }
  }

  Widget _buildTabBar(ThemeData theme) {
    return Material(
      color: theme.colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.hintColor,
        indicatorColor: theme.colorScheme.primary,
        dividerColor: theme.dividerColor.withValues(alpha: 0.6),
        tabs: _isHarmony
            ? const [
                Tab(text: '列表'),
                Tab(text: '成员'),
              ]
            : const [
                Tab(text: '聊天'),
                Tab(text: '列表'),
                Tab(text: '成员'),
              ],
      ),
    );
  }

  Widget _buildChatTab() {
    final theme = Theme.of(context);
    return Column(
      children: [
        _buildVoiceControl(theme),
        Expanded(
          child: ListView.builder(
            controller: _chatScrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              final name = msg.username;
              final content = msg.content;
              final timeStr = msg.timeLabel;

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: theme.primaryColor)),
                        const SizedBox(width: 8),
                        Text(timeStr,
                            style: TextStyle(
                                fontSize: 10, color: theme.disabledColor)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(content),
                  ],
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
            top: 8.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 8.0,
          ),
          child: ChatInputArea(
            textController: _messageController,
            isVoiceInputMode: false,
            isLoading: false,
            conversationType: 'watch_together',
            onSendMessage: () => _sendMessage(_messageController.text),
            onSwitchToVoiceMode: () {},
            onShowImagePicker: () {},
            onStartRecording: () {},
            onStopRecording: () {},
            onCancelRecording: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceControl(ThemeData theme) {
    if (_webrtcManager == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
            bottom:
                BorderSide(color: theme.dividerColor.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          Icon(
            _webrtcManager!.isConnected
                ? Icons.mic_rounded
                : Icons.mic_off_rounded,
            color: _webrtcManager!.isConnected
                ? (_webrtcManager!.isMuted ? Colors.red : Colors.green)
                : theme.disabledColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
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
          const Spacer(),
          if (_webrtcManager!.isConnected) ...[
            IconButton(
              icon: Icon(
                _webrtcManager!.isMuted
                    ? Icons.mic_off_rounded
                    : Icons.mic_rounded,
                color:
                    _webrtcManager!.isMuted ? Colors.red : theme.primaryColor,
              ),
              onPressed: () => _webrtcManager!.toggleMute(),
              tooltip: _webrtcManager!.isMuted ? '取消静音' : '静音',
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(8),
            ),
            IconButton(
              icon: const Icon(Icons.call_end_rounded, color: Colors.red),
              onPressed: () => _webrtcManager!.leave(),
              tooltip: '退出语音',
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(8),
            ),
          ] else
            SizedBox(
              height: 32,
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await _webrtcManager!.join();
                  } catch (e) {
                    if (mounted) {
                      MessageUtils.showError(context, '加入语音失败: $e');
                    }
                  }
                },
                icon: const Icon(Icons.call_rounded, size: 14),
                label: const Text('加入'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.cardColor,
                  foregroundColor: theme.textTheme.bodyMedium?.color,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  textStyle: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                        color: theme.dividerColor.withValues(alpha: 0.1)),
                  ),
                  elevation: 0,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaylistTab() {
    const primaryColor = Color(0xFF5D5FEF);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (_folderStack.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.arrow_back),
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
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _showAddMovieDialog,
                tooltip: '添加影片',
              ),
              IconButton(
                icon: Icon(_isSelectionMode ? Icons.close : Icons.checklist),
                onPressed: () {
                  setState(() {
                    _isSelectionMode = !_isSelectionMode;
                    _selectedMovieIds.clear();
                  });
                },
                tooltip: _isSelectionMode ? '取消选择' : '批量管理',
              ),
            ],
          ),
        ),
        if (_isSelectionMode)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                TextButton(onPressed: _selectAll, child: const Text('全选')),
                const Spacer(),
                ElevatedButton(
                  onPressed:
                      _selectedMovieIds.isEmpty ? null : _deleteSelectedMovies,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white),
                  child: const Text('删除'),
                ),
              ],
            ),
          ),
        Expanded(
          child: _isLoadingMovies
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  controller: _movieScrollController,
                  itemCount: _movies.length + (_hasMoreMovies ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _movies.length) {
                      return const Center(
                          child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator()));
                    }
                    final movie = _movies[index];
                    final isCurrent = _currentStatus?.movie?.id == movie.id;
                    final isFolder = movie.isFolder;
                    final isSelected = _selectedMovieIds.contains(movie.id);

                    return ListTile(
                      selected: isSelected,
                      selectedTileColor: primaryColor.withValues(alpha: 0.1),
                      leading: Icon(
                        isFolder ? Icons.folder : Icons.movie,
                        color: isFolder
                            ? Colors.amber
                            : (isCurrent ? primaryColor : null),
                      ),
                      title: Text(
                        movie.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isCurrent ? primaryColor : null,
                          fontWeight: isCurrent ? FontWeight.bold : null,
                        ),
                      ),
                      trailing: _isSelectionMode
                          ? Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: isSelected ? primaryColor : Colors.grey)
                          : null,
                      onTap: () {
                        if (_isSelectionMode) {
                          _toggleSelection(movie);
                        } else if (isFolder) {
                          _enterFolder(movie);
                        } else {
                          _switchMovie(movie);
                        }
                      },
                      onLongPress: () {
                        if (!_isSelectionMode &&
                            _isPersistedLibraryEntry(movie)) {
                          _enterSelectionMode(movie);
                        }
                      },
                    );
                  },
                ),
        ),
      ],
    );
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
              Text('在线成员 (${_members.length})',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: Colors.green),
                    SizedBox(width: 6),
                    Text('Live',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => _observeRoomMembers(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _members.length,
              itemBuilder: (context, index) {
                final member = _members[index];

                final myMemberInfo =
                    _members.where((m) => m.id == _currentUser?.id).firstOrNull;

                final viewerIsCreator =
                    _currentUser?.username == widget.room.creator;
                final viewerIsRoomAdmin = myMemberInfo?.role ==
                    common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value;
                final viewerIsSysAdmin = _currentUser?.role ==
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

                final isTargetCreator = member.role ==
                        common_enum
                            .RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR.value ||
                    member.username == widget.room.creator;
                final isTargetAdmin = member.role ==
                    common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value;
                final isMe = _currentUser?.id == member.id;
                final targetLevel =
                    isTargetCreator ? 3 : (isTargetAdmin ? 2 : 1);
                final canKick = viewerLevel > targetLevel;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: theme.dividerColor.withValues(alpha: 0.1)),
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: isTargetCreator
                                    ? primaryColor
                                    : Colors.transparent,
                                width: 2),
                          ),
                          child: CircleAvatar(
                            backgroundColor:
                                primaryColor.withValues(alpha: 0.1),
                            child: Text(
                                member.username.isNotEmpty
                                    ? member.username[0].toUpperCase()
                                    : '?',
                                style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        if (isTargetCreator)
                          const Positioned(
                            right: 0,
                            bottom: 0,
                            child:
                                Icon(Icons.star, size: 14, color: Colors.amber),
                          ),
                      ],
                    ),
                    title: Row(
                      children: [
                        Text(member.username,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        if (isMe)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text('我',
                                style: TextStyle(
                                    fontSize: 10, color: theme.primaryColor)),
                          ),
                        if (isTargetAdmin) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: Colors.blue.withValues(alpha: 0.5)),
                            ),
                            child: const Text('管理员',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.blue)),
                          ),
                        ],
                      ],
                    ),
                    subtitle: member.onlineCount > 0
                        ? Text('在线 (${member.onlineCount})',
                            style: const TextStyle(
                                color: Colors.green, fontSize: 12))
                        : Text(
                            '离线 · 加入于 ${DateTime.fromMillisecondsSinceEpoch(member.createdAt * 1000).toString().substring(0, 10)}',
                            style: TextStyle(
                                color: theme.disabledColor, fontSize: 12)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isMe && !isTargetCreator) ...[
                          if ((viewerIsCreator || viewerIsRoomAdmin) &&
                              member.role ==
                                  common_enum.RoomMemberRole
                                      .ROOM_MEMBER_ROLE_MEMBER.value)
                            IconButton(
                              icon: const Icon(
                                  Icons.admin_panel_settings_outlined,
                                  color: Colors.blue),
                              tooltip: '设为管理',
                              onPressed: () => _setRoomAdmin(member),
                            ),
                          if (viewerIsCreator && isTargetAdmin)
                            IconButton(
                              icon: const Icon(Icons.remove_moderator_outlined,
                                  color: Colors.orange),
                              tooltip: '取消管理',
                              onPressed: () => _removeRoomAdmin(member),
                            ),
                          if (canKick)
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline,
                                  color: Colors.redAccent),
                              tooltip: '移除成员',
                              onPressed: () => _kickMember(member),
                            ),
                        ],
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

  void _enterFolder(WMovie folder) {
    setState(() {
      _folderStack.add(folder);
      _folderNameStack.add(folder.name);
      _isLoadingMovies = true;
    });
    _observeCurrentPlaylist();
  }

  void _exitFolder() {
    if (_folderStack.isEmpty) return;
    setState(() {
      _folderStack.removeLast();
      _folderNameStack.removeLast();
      _isLoadingMovies = true;
    });
    _observeCurrentPlaylist();
  }

  void _observeCurrentPlaylist() {
    final parentFolder = _folderStack.isNotEmpty ? _folderStack.last : null;
    try {
      _channel?.sink.add(
        RoomRealtimeCodec.encodePlaylistObservation(
          playlistId: parentFolder?.playbackWatchPlaylistId ?? '',
          target: parentFolder?.playbackWatchTarget,
          page: 1,
          pageSize: _pageSize,
        ),
      );
    } catch (e) {
      debugPrint('Observe playlist error: $e');
      if (mounted) MessageUtils.showError(context, '播放列表订阅失败');
    }
  }

  Future<void> _switchMovie(WMovie movie) async {
    try {
      final switched = await WatchTogetherService.switchMovie(
          widget.room.roomId, movie.id,
          subPath: movie.subPath, playlistId: movie.parentId);
      _sendPlaybackUpdate(PlaybackControlAction.play, true, 0, 1);
      if (switched.movie != null) {
        await _applyPlaybackStatus(
          WPlaybackStatus(
            movie: movie.hasSamePlaybackIdentity(switched.movie!)
                ? movie
                : switched.movie,
            isPlaying: true,
            currentTime: 0,
            playbackRate: 1,
          ),
        );
      }
      _requestPlaybackSnapshot();
      if (mounted) MessageUtils.showSuccess(context, '已切换影片');
    } catch (e) {
      if (mounted) MessageUtils.showError(context, '切换失败: $e');
    }
  }

  void _enterSelectionMode(WMovie movie) {
    setState(() {
      _isSelectionMode = true;
      _selectedMovieIds.clear();
      _selectedMovieIds.add(movie.id);
    });
  }

  void _toggleSelection(WMovie movie) {
    if (!_isPersistedLibraryEntry(movie)) return;
    setState(() {
      if (_selectedMovieIds.contains(movie.id)) {
        _selectedMovieIds.remove(movie.id);
        if (_selectedMovieIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedMovieIds.add(movie.id);
      }
    });
  }

  void _selectAll() {
    setState(() {
      final selectable =
          _movies.where(_isPersistedLibraryEntry).map((m) => m.id).toList();
      if (_selectedMovieIds.length == selectable.length) {
        _selectedMovieIds.clear();
      } else {
        _selectedMovieIds.clear();
        _selectedMovieIds.addAll(selectable);
      }
    });
  }

  bool _isPersistedLibraryEntry(WMovie movie) {
    return movie.id.startsWith('med_') || movie.id.startsWith('pl_');
  }

  Future<void> _deleteSelectedMovies() async {
    if (_selectedMovieIds.isEmpty) return;

    final confirmed = await ChatUtils.showStyledDialog<bool>(
        context: context,
        title: '删除影片',
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        content: Text('确定要删除选中的 ${_selectedMovieIds.length} 个影片吗？'),
        actions: [
          ChatUtils.createCancelButton(context),
          const SizedBox(width: 8),
          ChatUtils.createConfirmButton(
            context,
            () => Navigator.pop(context, true),
            text: '删除',
          ),
        ]);

    if (confirmed == true) {
      try {
        final parentFolder = _folderStack.isNotEmpty ? _folderStack.last : null;
        final canClearScope =
            parentFolder == null || parentFolder.id.startsWith('pl_');
        final selectableCount = _movies.where(_isPersistedLibraryEntry).length;
        final isAllLoadedSelected = _selectedMovieIds.length == selectableCount;
        final mediaIds =
            _selectedMovieIds.where((id) => id.startsWith('med_')).toList();
        final playlistIds =
            _selectedMovieIds.where((id) => id.startsWith('pl_')).toList();
        if (mediaIds.isEmpty && playlistIds.isEmpty) {
          if (mounted) MessageUtils.showInfo(context, '动态目录内容不能在房间内删除');
          return;
        }
        if (isAllLoadedSelected && !_hasMoreMovies && canClearScope) {
          await WatchTogetherService.clearMovies(widget.room.roomId,
              parentId: parentFolder?.id.startsWith('pl_') == true
                  ? parentFolder!.id
                  : null);
        } else {
          await WatchTogetherService.deleteMediaLibraryEntries(
            widget.room.roomId,
            mediaIds: mediaIds,
            playlistIds: playlistIds,
          );
        }

        setState(() {
          _isSelectionMode = false;
          _selectedMovieIds.clear();
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
      await WatchTogetherService.switchMovie(widget.room.roomId, '',
          subPath: '');
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final settings =
          await WatchTogetherService.getRoomSettings(widget.room.roomId);

      if (mounted) {
        Navigator.pop(context);

        // For PC, navigate to the same RoomSettingsPage used in mobile
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoomSettingsPage(
              roomId: widget.room.roomId,
              roomName: widget.room.roomName,
              creatorId: widget.room.creatorId,
              currentUserId: _currentUser?.id ?? '',
              currentSettings: settings,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        MessageUtils.showError(context, '获取设置失败: $e');
      }
    }
  }

  void _showAddMovieDialog() {
    AddMovieDialog.show(context, widget.room.roomId);
  }

  Future<void> _setRoomAdmin(WUser member) async {
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '设为管理员',
      icon: const Icon(Icons.admin_panel_settings_rounded, color: Colors.blue),
      content: Text('确定要将 ${member.username} 设为管理员吗？\n管理员拥有踢人、管理成员等权限。'),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
            context, () => Navigator.pop(context, true),
            text: '确定'),
      ],
    );

    if (confirmed == true) {
      try {
        await WatchTogetherService.setRoomAdmin(widget.room.roomId, member.id);
        _observeRoomMembers();
        if (mounted) {
          MessageUtils.showSuccess(context, '已将 ${member.username} 设为管理员');
        }
      } catch (e) {
        if (mounted) MessageUtils.showError(context, '设置失败: $e');
      }
    }
  }

  Future<void> _removeRoomAdmin(WUser member) async {
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '取消管理员',
      icon: const Icon(Icons.remove_moderator_rounded, color: Colors.orange),
      content: Text('确定要取消 ${member.username} 的管理员权限吗？'),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
            context, () => Navigator.pop(context, true),
            text: '确定'),
      ],
    );

    if (confirmed == true) {
      try {
        await WatchTogetherService.removeRoomAdmin(
            widget.room.roomId, member.id);
        _observeRoomMembers();
        if (mounted) {
          MessageUtils.showSuccess(context, '已取消 ${member.username} 的管理员权限');
        }
      } catch (e) {
        if (mounted) MessageUtils.showError(context, '取消失败: $e');
      }
    }
  }

  Future<void> _kickMember(WUser member) async {
    final confirmed = await ChatUtils.showStyledDialog<bool>(
      context: context,
      title: '踢出成员',
      icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
      content: Text('确定要踢出 ${member.username} 吗？'),
      actions: [
        ChatUtils.createCancelButton(context),
        const SizedBox(width: 8),
        ChatUtils.createConfirmButton(
            context, () => Navigator.pop(context, true),
            text: '确定'),
      ],
    );

    if (confirmed == true) {
      try {
        await WatchTogetherService.kickMember(widget.room.roomId, member.id);
        _observeRoomMembers();
        if (mounted) MessageUtils.showSuccess(context, '已踢出成员');
      } catch (e) {
        if (mounted) MessageUtils.showError(context, '踢出失败: $e');
      }
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    if (_channel != null) {
      try {
        final bytes = RoomRealtimeCodec.encodeChat(text);
        _channel!.sink.add(bytes);
      } catch (e) {
        debugPrint('Send message error: $e');
        if (mounted) MessageUtils.showError(context, '发送失败: $e');
      }
    }
    _messageController.clear();
  }
}
