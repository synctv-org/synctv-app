import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:math';
import 'dart:async';

import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

/// 聊天输入区域组件
class ChatInputArea extends StatefulWidget {
  final TextEditingController textController;
  final bool isVoiceInputMode;
  final bool isLoading;
  final String conversationType;
  final FutureOr<void> Function() onSendMessage;
  final VoidCallback onSwitchToVoiceMode;
  final VoidCallback onShowImagePicker;
  final Function onStartRecording;
  final Function onStopRecording;
  final Function onCancelRecording;
  final Uint8List? selectedImageBytes;
  final VoidCallback? onCancelSelectedImage;
  final VoidCallback? onInputFocused;
  final ValueChanged<String>? onMentionQueryChanged;
  final VoidCallback? onMentionLoadMore;
  final bool showAsBackButton;
  final VoidCallback? onBackToBottom;
  final bool mentionCandidatesLoading;
  final bool mentionCandidatesHasMore;
  final List<SyncTvUser> mentionCandidates;
  final ValueChanged<List<ChatMentionInfo>>? onMentionsChanged;

  const ChatInputArea({
    super.key,
    required this.textController,
    required this.isVoiceInputMode,
    required this.isLoading,
    required this.conversationType,
    required this.onSendMessage,
    required this.onSwitchToVoiceMode,
    required this.onShowImagePicker,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onCancelRecording,
    this.selectedImageBytes,
    this.onCancelSelectedImage,
    this.onInputFocused,
    this.onMentionQueryChanged,
    this.onMentionLoadMore,
    this.showAsBackButton = false,
    this.onBackToBottom,
    this.mentionCandidatesLoading = false,
    this.mentionCandidatesHasMore = false,
    this.mentionCandidates = const [],
    this.onMentionsChanged,
  });

  @override
  State<ChatInputArea> createState() => _ChatInputAreaState();
}

class _ChatInputAreaState extends State<ChatInputArea>
    with TickerProviderStateMixin {
  late AnimationController _switchAnimationController;
  late AnimationController _modeTransitionController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _switchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _modeTransitionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _switchAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _switchAnimationController,
            curve: Curves.elasticOut,
          ),
        );

    _switchAnimationController.forward();

    if (widget.showAsBackButton) {
      _modeTransitionController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _switchAnimationController.dispose();
    _modeTransitionController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ChatInputArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isVoiceInputMode != widget.isVoiceInputMode) {
      _switchAnimationController.reset();
      _switchAnimationController.forward();
    }

    if (oldWidget.showAsBackButton != widget.showAsBackButton) {
      if (widget.showAsBackButton) {
        _modeTransitionController.forward();
      } else {
        _modeTransitionController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasText = widget.textController.text.trim().isNotEmpty;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: AnimatedBuilder(
          animation: _modeTransitionController,
          builder: (context, child) {
            if (_modeTransitionController.value > 0.5) {
              return _buildBackToBottomButton();
            }

            return widget.isVoiceInputMode &&
                    widget.conversationType == 'xiaozhi'
                ? VoiceInputArea(
                    onStartRecording: widget.onStartRecording,
                    onStopRecording: widget.onStopRecording,
                    onCancelRecording: widget.onCancelRecording,
                    onSwitchToTextMode: () {
                      HapticFeedback.mediumImpact();
                      widget.onSwitchToVoiceMode();
                    },
                    animationValue: 1.0 - _modeTransitionController.value,
                  )
                : TextInputArea(
                    textController: widget.textController,
                    hasText: hasText,
                    conversationType: widget.conversationType,
                    isLoading: widget.isLoading,
                    onSendMessage: widget.onSendMessage,
                    onShowImagePicker: widget.onShowImagePicker,
                    onSwitchToVoiceMode: widget.conversationType == 'xiaozhi'
                        ? () {
                            HapticFeedback.mediumImpact();
                            widget.onSwitchToVoiceMode();
                          }
                        : null,
                    selectedImageBytes: widget.selectedImageBytes,
                    onCancelSelectedImage: widget.onCancelSelectedImage,
                    onInputFocused: widget.onInputFocused,
                    onMentionQueryChanged: widget.onMentionQueryChanged,
                    onMentionLoadMore: widget.onMentionLoadMore,
                    mentionCandidatesLoading: widget.mentionCandidatesLoading,
                    mentionCandidatesHasMore: widget.mentionCandidatesHasMore,
                    mentionCandidates: widget.mentionCandidates,
                    onMentionsChanged: widget.onMentionsChanged,
                    animationValue: 1.0 - _modeTransitionController.value,
                  );
          },
        ),
      ),
    );
  }

  Widget _buildBackToBottomButton() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const double buttonSize = 48.0;

    return AnimatedBuilder(
      animation: _modeTransitionController,
      builder: (context, child) {
        double widthProgress = 0.0;
        if (_modeTransitionController.value > 0.3) {
          widthProgress = (_modeTransitionController.value - 0.3) / 0.7;
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = (constraints.maxWidth - 32).clamp(
              buttonSize,
              640.0,
            );
            final currentWidth =
                availableWidth * (1 - widthProgress) +
                buttonSize * widthProgress;
            final finalWidth = currentWidth.clamp(buttonSize, availableWidth);

            return Center(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onBackToBottom?.call();
                },
                child: AppBlurSurface(
                  width: finalWidth,
                  height: buttonSize,
                  borderRadius: BorderRadius.circular(finalWidth / 2),
                  color: isDark
                      ? Colors.grey.shade800.withValues(alpha: 0.6)
                      : Colors.grey.shade100.withValues(alpha: 0.9),
                  child: Center(
                    child: AnimatedScale(
                      scale: 0.8 + 0.2 * widthProgress,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.9)
                            : Colors.black.withValues(alpha: 0.8),
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// 文本输入区域
class TextInputArea extends StatefulWidget {
  final TextEditingController textController;
  final bool hasText;
  final bool isLoading;
  final String conversationType;
  final FutureOr<void> Function() onSendMessage;
  final VoidCallback onShowImagePicker;
  final VoidCallback? onSwitchToVoiceMode;
  final Uint8List? selectedImageBytes;
  final VoidCallback? onCancelSelectedImage;
  final VoidCallback? onInputFocused;
  final ValueChanged<String>? onMentionQueryChanged;
  final VoidCallback? onMentionLoadMore;
  final bool mentionCandidatesLoading;
  final bool mentionCandidatesHasMore;
  final double animationValue;
  final List<SyncTvUser> mentionCandidates;
  final ValueChanged<List<ChatMentionInfo>>? onMentionsChanged;

  const TextInputArea({
    super.key,
    required this.textController,
    required this.hasText,
    required this.isLoading,
    required this.conversationType,
    required this.onSendMessage,
    required this.onShowImagePicker,
    this.onSwitchToVoiceMode,
    this.selectedImageBytes,
    this.onCancelSelectedImage,
    this.onInputFocused,
    this.onMentionQueryChanged,
    this.onMentionLoadMore,
    this.mentionCandidatesLoading = false,
    this.mentionCandidatesHasMore = false,
    this.mentionCandidates = const [],
    this.onMentionsChanged,
    this.animationValue = 1.0,
  });

  @override
  State<TextInputArea> createState() => _TextInputAreaState();
}

class _TextInputAreaState extends State<TextInputArea> {
  bool _hasText = false;
  late final FocusNode _focusNode;
  final List<ChatMentionInfo> _mentions = <ChatMentionInfo>[];
  String _mentionQuery = '';
  int _mentionTokenStart = -1;
  String _lastNotifiedMentionQuery = '';

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _hasText = widget.textController.text.trim().isNotEmpty;
    widget.textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.textController.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _refreshInputState();
  }

  void _refreshInputState() {
    final hasText = widget.textController.text.trim().isNotEmpty;
    _syncMentionsWithText();
    _updateMentionQuery();
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    } else {
      setState(() {});
    }
  }

  void _syncMentionsWithText() {
    final text = widget.textController.text;
    _mentions.removeWhere((mention) {
      final startCodeUnit = _codeUnitOffsetForRuneOffset(text, mention.start);
      final endCodeUnit = _codeUnitOffsetForRuneOffset(
        text,
        mention.start + mention.length,
      );
      if (startCodeUnit < 0 ||
          endCodeUnit > text.length ||
          endCodeUnit <= startCodeUnit) {
        return true;
      }
      final token = text.substring(startCodeUnit, endCodeUnit);
      return !token.startsWith('@') || token.contains(RegExp(r'\s'));
    });
    widget.onMentionsChanged?.call(List.unmodifiable(_mentions));
  }

  void _updateMentionQuery() {
    final selection = widget.textController.selection;
    if (!selection.isValid || !selection.isCollapsed) {
      _mentionTokenStart = -1;
      _mentionQuery = '';
      return;
    }
    final text = widget.textController.text;
    final caret = selection.baseOffset.clamp(0, text.length);
    var start = caret - 1;
    while (start >= 0) {
      final ch = text.substring(start, start + 1);
      if (ch == '@') break;
      if (RegExp(r'\s').hasMatch(ch)) {
        start = -1;
        break;
      }
      start -= 1;
    }
    if (start < 0 || start >= text.length || text[start] != '@') {
      _mentionTokenStart = -1;
      _mentionQuery = '';
      _notifyMentionQueryChanged();
      return;
    }
    _mentionTokenStart = start;
    _mentionQuery = text.substring(start + 1, caret).toLowerCase();
    _notifyMentionQueryChanged();
  }

  void _notifyMentionQueryChanged() {
    final nextQuery = _mentionTokenStart < 0 ? '' : _mentionQuery.trim();
    if (nextQuery == _lastNotifiedMentionQuery) return;
    _lastNotifiedMentionQuery = nextQuery;
    widget.onMentionQueryChanged?.call(nextQuery);
  }

  bool get _hasMentionToken => _mentionTokenStart >= 0;

  List<SyncTvUser> get _filteredMentionCandidates {
    if (!_hasMentionToken || widget.mentionCandidates.isEmpty) {
      return const [];
    }
    final query = _mentionQuery.trim();
    return widget.mentionCandidates
        .where((user) {
          if (user.id.isEmpty || user.username.trim().isEmpty) return false;
          if (query.isEmpty) return true;
          return user.username.toLowerCase().contains(query);
        })
        .take(8)
        .toList();
  }

  void _selectMention(SyncTvUser user) {
    final selection = widget.textController.selection;
    if (_mentionTokenStart < 0 || !selection.isValid) return;
    final text = widget.textController.text;
    final caret = selection.baseOffset.clamp(0, text.length);
    final replacement = '@${user.username} ';
    final nextText = text.replaceRange(_mentionTokenStart, caret, replacement);
    final startRune = _runeOffsetForCodeUnitOffset(text, _mentionTokenStart);
    final lengthRune = replacement.trimRight().runes.length;
    widget.textController.value = TextEditingValue(
      text: nextText,
      selection: TextSelection.collapsed(
        offset: _mentionTokenStart + replacement.length,
      ),
    );
    _mentions.removeWhere(
      (mention) => mention.start == startRune || mention.userId == user.id,
    );
    _mentions.add(
      ChatMentionInfo(
        userId: user.id,
        username: user.username,
        start: startRune,
        length: lengthRune,
      ),
    );
    _mentions.sort((a, b) => a.start.compareTo(b.start));
    widget.onMentionsChanged?.call(List.unmodifiable(_mentions));
    _mentionTokenStart = -1;
    _mentionQuery = '';
    setState(() {});
  }

  int _runeOffsetForCodeUnitOffset(String text, int codeUnitOffset) {
    var runeOffset = 0;
    var currentCodeUnit = 0;
    for (final rune in text.runes) {
      if (currentCodeUnit >= codeUnitOffset) break;
      currentCodeUnit += String.fromCharCodes([rune]).length;
      runeOffset += 1;
    }
    return runeOffset;
  }

  int _codeUnitOffsetForRuneOffset(String text, int runeOffset) {
    if (runeOffset < 0) return -1;
    var currentRune = 0;
    var codeUnitOffset = 0;
    for (final rune in text.runes) {
      if (currentRune >= runeOffset) break;
      codeUnitOffset += String.fromCharCodes([rune]).length;
      currentRune += 1;
    }
    return codeUnitOffset;
  }

  Future<void> _sendMessage() async {
    try {
      await widget.onSendMessage();
    } finally {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _focusNode.requestFocus();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool hasSelectedImage = widget.selectedImageBytes != null;
    final canSend = (_hasText || hasSelectedImage) && !widget.isLoading;
    final fieldFill = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.04);
    final fieldBorder = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.black.withValues(alpha: 0.10);

    return Opacity(
      opacity: widget.animationValue,
      child: Transform.scale(
        scale: 0.95 + 0.05 * widget.animationValue,
        child: AppInkSurface(
          color: Colors.transparent,
          clipBehavior: Clip.none,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_hasMentionToken &&
                  (widget.mentionCandidatesLoading ||
                      _filteredMentionCandidates.isNotEmpty))
                _MentionSuggestions(
                  users: _filteredMentionCandidates,
                  loading: widget.mentionCandidatesLoading,
                  hasMore: widget.mentionCandidatesHasMore,
                  onLoadMore: widget.onMentionLoadMore,
                  onSelected: _selectMention,
                ),
              if (hasSelectedImage)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AppBlurSurface(
                    borderRadius: BorderRadius.circular(8),
                    color: isDark
                        ? Colors.grey.shade800.withValues(alpha: 0.5)
                        : Colors.grey.shade100.withValues(alpha: 0.8),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        AppImageThumbnail.memory(
                          bytes: widget.selectedImageBytes!,
                          width: 60,
                          height: 60,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            context.l10n.imageSelectedDescription,
                            style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        AppGlassIconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.red.shade400,
                            size: 18,
                          ),
                          tooltip: context.l10n.cancelImage,
                          onPressed: widget.onCancelSelectedImage,
                          isDark: isDark,
                          size: 36,
                          pressedScale: 0.9,
                        ),
                      ],
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: AppTextField(
                      focusNode: _focusNode,
                      controller: widget.textController,
                      label: context.l10n.message,
                      showLabel: false,
                      hintText: hasSelectedImage
                          ? context.l10n.describeImage
                          : context.l10n.enterMessage,
                      prefixIcon: Icons.chat_bubble_outline,
                      filled: true,
                      fillColor: fieldFill,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      enabledBorderSide: BorderSide(color: fieldBorder),
                      focusedBorderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.4,
                      ),
                      disabledBorderSide: BorderSide(color: fieldBorder),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 4,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.send,
                      showClearButton: false,
                      onSubmitted: canSend ? (_) => _sendMessage() : null,
                      onChanged: (_) => _refreshInputState(),
                      onTap: widget.onInputFocused,
                      enabled: !widget.isLoading,
                    ),
                  ),
                  if ((widget.conversationType == 'dify' ||
                          widget.conversationType == 'openai' ||
                          widget.conversationType == 'synctv') &&
                      !hasSelectedImage) ...[
                    const SizedBox(width: 10),
                    AppGlassIconButton(
                      icon: Icon(
                        Icons.add_photo_alternate_outlined,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.8)
                            : Colors.black.withValues(alpha: 0.7),
                        size: 22,
                      ),
                      tooltip: context.l10n.chooseImage,
                      onPressed: widget.onShowImagePicker,
                      isDark: isDark,
                      size: 44,
                      pressedScale: 0.9,
                    ),
                  ],
                  const SizedBox(width: 10),
                  SizedBox.square(
                    dimension: 44,
                    child: AppIconButton(
                      onPressed: canSend ? _sendMessage : null,
                      icon: Icons.send_rounded,
                      tooltip: context.l10n.send,
                      loading: widget.isLoading,
                      style: AppIconButtonStyle.filled,
                      iconSize: 20,
                    ),
                  ),
                  if (widget.conversationType == 'xiaozhi' &&
                      widget.onSwitchToVoiceMode != null) ...[
                    const SizedBox(width: 12),
                    AppGlassIconButton(
                      icon: Icon(
                        Icons.mic,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.8)
                            : Colors.black.withValues(alpha: 0.7),
                        size: 20,
                      ),
                      tooltip: context.l10n.switchToVoice,
                      onPressed: widget.onSwitchToVoiceMode,
                      isDark: isDark,
                      rotateOnPressed: true,
                      hapticFeedback: HapticFeedbackType.medium,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MentionSuggestions extends StatelessWidget {
  const _MentionSuggestions({
    required this.users,
    required this.loading,
    required this.hasMore,
    required this.onLoadMore,
    required this.onSelected,
  });

  final List<SyncTvUser> users;
  final bool loading;
  final bool hasMore;
  final VoidCallback? onLoadMore;
  final ValueChanged<SyncTvUser> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppBlurSurface(
        borderRadius: BorderRadius.circular(8),
        color: isDark
            ? Colors.grey.shade900.withValues(alpha: 0.82)
            : Colors.white.withValues(alpha: 0.92),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: SizedBox(
          height: 38,
          child: loading && users.isEmpty
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: AppLoadingIndicator(
                      size: AppLoadingSize.sm,
                      centered: false,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                )
              : NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.axis != Axis.horizontal) {
                      return false;
                    }
                    if (!loading &&
                        hasMore &&
                        notification.metrics.extentAfter < 96) {
                      onLoadMore?.call();
                    }
                    return false;
                  },
                  child: AppListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: users.length + (loading || hasMore ? 1 : 0),
                    separatorBuilder: (_, _) => const SizedBox(width: 6),
                    itemBuilder: (context, index) {
                      if (index >= users.length) {
                        if (loading) {
                          return const SizedBox(
                            width: 32,
                            child: Center(
                              child: SizedBox.square(
                                dimension: 16,
                                child: AppLoadingIndicator(
                                  size: AppLoadingSize.sm,
                                  centered: false,
                                ),
                              ),
                            ),
                          );
                        }
                        return SizedBox(
                          width: 32,
                          child: AppIconButton(
                            onPressed: onLoadMore,
                            icon: Icons.more_horiz_rounded,
                            tooltip: context.l10n.loadMore,
                            iconSize: 18,
                          ),
                        );
                      }
                      final user = users[index];
                      return InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => onSelected(user),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.dividerColor.withValues(alpha: 0.45),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: theme.colorScheme.primary
                                    .withValues(alpha: 0.12),
                                child: Text(
                                  user.username.isEmpty
                                      ? '?'
                                      : String.fromCharCodes(
                                          user.username.runes.take(1),
                                        ),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                user.username,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
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
      ),
    );
  }
}

/// 语音输入区域
class VoiceInputArea extends StatefulWidget {
  final Function onStartRecording;
  final Function onStopRecording;
  final Function onCancelRecording;
  final VoidCallback onSwitchToTextMode;
  final double animationValue;

  const VoiceInputArea({
    super.key,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onCancelRecording,
    required this.onSwitchToTextMode,
    this.animationValue = 1.0,
  });

  @override
  State<VoiceInputArea> createState() => _VoiceInputAreaState();
}

class _VoiceInputAreaState extends State<VoiceInputArea> {
  bool _isRecording = false;
  bool _isCancelling = false;
  double _startDragY = 0.0;
  final double _cancelThreshold = 50.0;
  Timer? _waveAnimationTimer;
  final List<double> _waveHeights = List.filled(20, 0.0);
  final Random _random = Random();

  @override
  void dispose() {
    _stopWaveAnimation();
    super.dispose();
  }

  void _startWaveAnimation() {
    _waveAnimationTimer?.cancel();
    _waveAnimationTimer = Timer.periodic(const Duration(milliseconds: 100), (
      timer,
    ) {
      if (_isRecording && !_isCancelling && mounted) {
        setState(() {
          for (int i = 0; i < _waveHeights.length; i++) {
            _waveHeights[i] = 0.5 + _random.nextDouble() * 0.5;
          }
        });
      }
    });
  }

  void _stopWaveAnimation() {
    _waveAnimationTimer?.cancel();
    _waveAnimationTimer = null;
  }

  Widget _buildWaveAnimationIndicator() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          16,
          (index) => AppAnimatedPanelSurface(
            duration: const Duration(milliseconds: 100),
            width: 3,
            height: 20 * _waveHeights[index % _waveHeights.length],
            color: isDark
                ? Colors.grey.shade800.withValues(alpha: 0.5)
                : Colors.grey.shade100.withValues(alpha: 0.8),
            borderRadius: const BorderRadius.all(Radius.circular(1.5)),
            boxShadow: [
              BoxShadow(
                color: (isDark ? Colors.white : Colors.blue).withValues(
                  alpha: 0.3,
                ),
                blurRadius: 2,
                spreadRadius: 0,
              ),
            ],
            curve: Curves.easeInOut,
            child: const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Opacity(
      opacity: widget.animationValue,
      child: Transform.scale(
        scale: 0.95 + 0.05 * widget.animationValue,
        child: AppPanelSurface(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onLongPressStart: (details) {
                    setState(() {
                      _isRecording = true;
                      _isCancelling = false;
                      _startDragY = details.globalPosition.dy;
                    });
                    widget.onStartRecording();
                    _startWaveAnimation();
                  },
                  onLongPressMoveUpdate: (details) {
                    final double dragDistance =
                        _startDragY - details.globalPosition.dy;

                    if (dragDistance > _cancelThreshold && !_isCancelling) {
                      setState(() {
                        _isCancelling = true;
                      });
                      HapticFeedback.mediumImpact();
                    } else if (dragDistance <= _cancelThreshold &&
                        _isCancelling) {
                      setState(() {
                        _isCancelling = false;
                      });
                      HapticFeedback.lightImpact();
                    }
                  },
                  onLongPressEnd: (details) {
                    final wasRecording = _isRecording;
                    final wasCancelling = _isCancelling;

                    setState(() {
                      _isRecording = false;
                    });

                    _stopWaveAnimation();

                    if (wasRecording) {
                      if (wasCancelling) {
                        widget.onCancelRecording();
                      } else {
                        widget.onStopRecording();
                      }
                    }
                  },
                  child: AppBlurSurface(
                    borderRadius: BorderRadius.circular(8),
                    height: 48,
                    color: isDark
                        ? Colors.grey.shade800.withValues(alpha: 0.5)
                        : Colors.grey.shade100.withValues(alpha: 0.8),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_isRecording && !_isCancelling)
                          _buildWaveAnimationIndicator(),
                        Center(
                          child: Text(
                            _isRecording
                                ? _isCancelling
                                      ? context.l10n.releaseToCancel
                                      : context.l10n.releaseToSendSwipeToCancel
                                : context.l10n.holdToTalk,
                            style: TextStyle(
                              color: _isRecording
                                  ? _isCancelling
                                        ? Colors.red.shade300
                                        : (isDark
                                              ? Colors.blue.shade300
                                              : Colors.blue.shade700)
                                  : (isDark
                                        ? Colors.white.withValues(alpha: 0.9)
                                        : Colors.black.withValues(alpha: 0.9)),
                              fontSize: 16,
                              fontWeight: _isRecording
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              AppGlassIconButton(
                icon: Icon(
                  Icons.keyboard,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.8)
                      : Colors.black.withValues(alpha: 0.7),
                  size: 20,
                ),
                tooltip: context.l10n.switchToText,
                onPressed: () {
                  if (_isRecording) {
                    widget.onCancelRecording();
                    _stopWaveAnimation();
                  }
                  widget.onSwitchToTextMode();
                },
                isDark: isDark,
                rotateOnPressed: true,
                hapticFeedback: HapticFeedbackType.medium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
