import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:synctv_app/models/direct_url_source_config.dart';
import 'package:synctv_app/models/room_management_models.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/models/room_realtime_codec.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/services/room_realtime_connection.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/widgets/add_movie_dialog.dart';
import 'package:synctv_app/widgets/custom_video_player.dart';
import 'package:synctv_app/managers/webrtc_manager.dart';
import 'package:synctv_app/models/danmaku_model.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;

class LargeScreenRoom extends StatefulWidget {
  final WRoom room;

  const LargeScreenRoom({super.key, required this.room});

  @override
  State<LargeScreenRoom> createState() => _LargeScreenRoomState();
}

class _LargeScreenRoomState extends State<LargeScreenRoom> {
  VideoPlayerController? _videoPlayerController;
  final ScrollController _chatScrollController = ScrollController();
  final ScrollController _movieScrollController = ScrollController();
  final List<RoomRealtimeChatEntry> _messages = [];
  Timer? _syncTimer;
  WPlaybackStatus? _currentStatus;
  RoomRealtimeConnection? _channel;
  List<WUser> _members = [];
  List<WMovie> _movies = [];
  bool _isLoadingMovies = true;

  // Pagination
  int _currentPage = 1;
  final int _pageSize = 20;
  bool _hasMoreMovies = true;
  bool _isLoadingMoreMovies = false;

  // Folder navigation
  final List<WMovie> _folderStack = [];
  final List<String> _folderNameStack = ['根目录'];

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

  // WebRTC
  WebRTCManager? _webrtcManager;
  bool _isVideoLoading = false;
  String? _videoError;

  // Danmaku Stream
  final DanmakuController _danmakuController = DanmakuController();

  // TV Focus Handling
  final FocusNode _videoFocus = FocusNode();
  final FocusNode _movieListFocus = FocusNode();

  // Side Panel State
  bool _showSidePanel = false;
  int _selectedTabIndex = 0; // 0: Movies, 1: Chat, 2: Members

  bool get _isHarmony => Platform.operatingSystem.toLowerCase() == 'ohos';

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

    // Initialize WebRTC Manager (simplified for TV - usually listen only or no mic)
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

    _joinRoom();
    _movieScrollController.addListener(_onMovieScroll);
  }

  Future<void> _joinRoom() async {
    _connectRealtime();

    Future.wait([
      _loadChatHistory(),
    ]).catchError((e) {
      debugPrint('Large screen background data fetch error: $e');
      return <void>[];
    });
  }

  Future<void> _loadChatHistory() async {
    try {
      final page = await WatchTogetherService.getChatHistory(
        widget.room.roomId,
        limit: 50,
      );
      final history = page.messages
          .map(RoomRealtimeChatEntry.fromHistory)
          .toList()
          .reversed;
      if (mounted) {
        setState(() {
          _messages.prependUnique(history, maxEntries: 50);
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
    setState(() => _isLoadingMoreMovies = true);

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
    } catch (_) {
      if (mounted) setState(() => _isLoadingMoreMovies = false);
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
      _realtimeSubscription = _channel!.stream.listen((data) {
        _reconnectAttempts = 0;
        try {
          final message = RoomRealtimeCodec.decode(data);
          _handleRealtimeMessage(message);
        } catch (e) {
          debugPrint('Proto decode error: $e');
        }
      }, onError: (_) => _scheduleReconnect(), onDone: _scheduleReconnect);
    } catch (e) {
      debugPrint('Realtime stream connection error: $e');
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) return;
    _reconnectAttempts++;
    _reconnectTimer = Timer(Duration(seconds: _reconnectAttempts * 2), () {
      if (mounted) _connectRealtime();
    });
  }

  void _handleRealtimeMessage(RoomRealtimeMessage message) {
    final type = message.kind;
    if (type == RoomRealtimeMessageKind.chat) {
      final content = message.chatContent;
      final username =
          message.senderUsername.isEmpty ? 'Unknown' : message.senderUsername;

      if (_videoPlayerController?.value.isInitialized == true) {
        final danmaku = DanmakuItem(
          text: '$username: $content',
          startTime: _videoPlayerController!.value.position,
          endTime: _videoPlayerController!.value.position +
              const Duration(seconds: 8),
          color: Colors.white,
          type: DanmakuType.floating,
          fontSize: 24,
        );
        _danmakuController.add(danmaku);
      }

      if (mounted) {
        setState(() {
          _messages.appendUnique(
            RoomRealtimeChatEntry.fromMessage(message),
            maxEntries: 50,
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
      if ((currentPos - targetTime).abs() > 2.0) {
        // Looser sync for TV
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
      Future.delayed(const Duration(milliseconds: 1000), () {
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
      _updateDebounce = Timer(const Duration(milliseconds: 1000), () {
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
        Icon(icon, color: Colors.white54, size: 80),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(color: Colors.white54, fontSize: 24),
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
    _disposeVideoController();
    _syncTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _chatScrollController.dispose();
    _movieScrollController.dispose();
    _webrtcManager?.dispose();
    _danmakuController.dispose();
    _videoFocus.dispose();
    _movieListFocus.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.jumpTo(
          _chatScrollController.position.maxScrollExtent,
        );
      }
    });
  }

  // TV Logic
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
    } catch (e) {
      debugPrint('Switch movie error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.contextMenu):
            const ActivateIntent(), // Map menu key
        LogicalKeySet(LogicalKeyboardKey.keyM):
            const ActivateIntent(), // M for Menu
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (ActivateIntent intent) {
              return null;
            },
          ),
        },
        child: Focus(
          autofocus: true,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent) {
              if (event.logicalKey == LogicalKeyboardKey.contextMenu ||
                  event.logicalKey == LogicalKeyboardKey.keyM) {
                setState(() => _showSidePanel = !_showSidePanel);
                return KeyEventResult.handled;
              }
              if (event.logicalKey == LogicalKeyboardKey.escape ||
                  event.logicalKey == LogicalKeyboardKey.goBack) {
                if (_showSidePanel) {
                  setState(() => _showSidePanel = false);
                  return KeyEventResult.handled;
                }
              }
            }
            return KeyEventResult.ignored;
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                // Main Video Area
                Positioned.fill(
                  child: Center(
                    child: _videoPlayerController != null &&
                            _videoPlayerController!.value.isInitialized
                        ? CustomVideoPlayer(
                            controller: _videoPlayerController!,
                            title: _currentStatus?.movie?.name ?? '未知影片',
                            danmakuController: _danmakuController,
                            subtitles: _currentStatus?.movie?.subtitles,
                            onSync: _handleSync,
                            onToggleFullScreen: null,
                            showCastButton: false, // Hide Cast button on TV
                            interactionMode: VideoPlayerInteractionMode.desktop,
                            extraBottomWidget: IconButton(
                              icon: const Icon(Icons.menu, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _showSidePanel = !_showSidePanel;
                                });
                              },
                              tooltip: '菜单',
                            ),
                          )
                        : _buildVideoPlaceholder(),
                  ),
                ),

                // Side Panel (Overlay)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  right: _showSidePanel ? 0 : -400,
                  top: 0,
                  bottom: 0,
                  width: MediaQuery.of(context).size.width * 0.35 < 300
                      ? 300
                      : (MediaQuery.of(context).size.width * 0.35 > 500
                          ? 500
                          : MediaQuery.of(context).size.width * 0.35),
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          theme.scaffoldBackgroundColor.withValues(alpha: 0.95),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 20,
                          offset: const Offset(-5, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Tab Header
                        SizedBox(
                          height: 60,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: _isHarmony
                                ? [
                                    _buildTabItem(0, Icons.movie, '影片'),
                                    _buildTabItem(1, Icons.people, '成员'),
                                    Container(
                                      width: 60,
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        icon: Icon(Icons.close,
                                            color: isDark
                                                ? Colors.white54
                                                : Colors.black54),
                                        onPressed: () => setState(
                                            () => _showSidePanel = false),
                                      ),
                                    ),
                                  ]
                                : [
                                    _buildTabItem(0, Icons.movie, '影片'),
                                    _buildTabItem(1, Icons.chat, '聊天'),
                                    _buildTabItem(2, Icons.people, '成员'),
                                    // Close Button
                                    Container(
                                      width: 60,
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        icon: Icon(Icons.close,
                                            color: isDark
                                                ? Colors.white54
                                                : Colors.black54),
                                        onPressed: () => setState(
                                            () => _showSidePanel = false),
                                      ),
                                    ),
                                  ],
                          ),
                        ),
                        Divider(height: 1, color: theme.dividerColor),

                        // Tab Content
                        Expanded(
                          child: IndexedStack(
                            index: _selectedTabIndex,
                            children: _isHarmony
                                ? [
                                    _buildMoviesTab(),
                                    _buildMembersTab(),
                                  ]
                                : [
                                    _buildMoviesTab(),
                                    _buildChatTab(),
                                    _buildMembersTab(),
                                  ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label) {
    final isSelected = _selectedTabIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedColor = isDark ? Colors.white54 : Colors.black54;

    return InkWell(
      onTap: () => setState(() => _selectedTabIndex = index),
      focusColor: const Color(0xFF5D5FEF).withValues(alpha: 0.3),
      child: Container(
        width: 133,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: isSelected
              ? const Border(
                  bottom: BorderSide(color: Color(0xFF5D5FEF), width: 4))
              : null,
        ),
        child: Column(
          children: [
            Icon(icon,
                color: isSelected ? const Color(0xFF5D5FEF) : unselectedColor),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF5D5FEF)
                        : unselectedColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildMoviesTab() {
    return Column(
      children: [
        if (_folderStack.isNotEmpty)
          ListTile(
            leading: const Icon(Icons.arrow_back, color: Colors.white),
            title: Text('返回: ${_folderNameStack.last}',
                style: const TextStyle(color: Colors.white)),
            onTap: _exitFolder,
            tileColor: Colors.white10,
          ),
        Expanded(
          child: _isLoadingMovies
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  controller: _movieScrollController,
                  itemCount: _movies.length + (_hasMoreMovies ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= _movies.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final movie = _movies[index];
                    final isCurrent = _currentStatus?.movie?.id == movie.id;
                    return ListTile(
                      autofocus: index == 0,
                      leading: Icon(
                        movie.isFolder ? Icons.folder : Icons.movie,
                        color: movie.isFolder
                            ? Colors.amber
                            : (isCurrent
                                ? const Color(0xFF5D5FEF)
                                : Colors.white54),
                      ),
                      title: Text(
                        movie.name,
                        style: TextStyle(
                          color: isCurrent
                              ? const Color(0xFF5D5FEF)
                              : Colors.white,
                          fontWeight:
                              isCurrent ? FontWeight.bold : FontWeight.normal,
                          fontSize: 18,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => movie.isFolder
                          ? _enterFolder(movie)
                          : _switchMovie(movie),
                      focusColor:
                          const Color(0xFF5D5FEF).withValues(alpha: 0.3),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('添加影片'),
            onPressed: () => AddMovieDialog.show(context, widget.room.roomId),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: const Color(0xFF5D5FEF),
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _chatScrollController,
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${msg.username}: ',
                        style: const TextStyle(
                            color: Color(0xFF5D5FEF),
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    Expanded(
                        child: Text(msg.content,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16))),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMembersTab() {
    return ListView.builder(
      itemCount: _members.length,
      itemBuilder: (context, index) {
        final member = _members[index];
        return ListTile(
          leading: CircleAvatar(child: Text(member.username[0].toUpperCase())),
          title: Text(member.username,
              style: const TextStyle(color: Colors.white, fontSize: 18)),
          subtitle: Text(
            member.role ==
                    common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_CREATOR.value
                ? '房主'
                : member.role ==
                        common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN.value
                    ? '管理员'
                    : member.role ==
                            common_enum
                                .RoomMemberRole.ROOM_MEMBER_ROLE_GUEST.value
                        ? '访客'
                        : '成员',
            style: const TextStyle(color: Colors.white54),
          ),
        );
      },
    );
  }
}
