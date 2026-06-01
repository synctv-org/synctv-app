import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'dart:ui';

/// 聊天输入区域组件
class ChatInputArea extends StatefulWidget {
  final TextEditingController textController;
  final bool isVoiceInputMode;
  final bool isLoading;
  final String conversationType;
  final VoidCallback onSendMessage;
  final VoidCallback onSwitchToVoiceMode;
  final VoidCallback onShowImagePicker;
  final Function onStartRecording;
  final Function onStopRecording;
  final Function onCancelRecording;
  final File? selectedImageFile;
  final Uint8List? selectedImageBytes;
  final VoidCallback? onCancelSelectedImage;
  final VoidCallback? onInputFocused;
  final bool showAsBackButton;
  final VoidCallback? onBackToBottom;

  const ChatInputArea({
    Key? key,
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
    this.selectedImageFile,
    this.selectedImageBytes,
    this.onCancelSelectedImage,
    this.onInputFocused,
    this.showAsBackButton = false,
    this.onBackToBottom,
  }) : super(key: key);

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

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _switchAnimationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _switchAnimationController,
      curve: Curves.elasticOut,
    ));

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
                    selectedImageFile: widget.selectedImageFile,
                    selectedImageBytes: widget.selectedImageBytes,
                    onCancelSelectedImage: widget.onCancelSelectedImage,
                    onInputFocused: widget.onInputFocused,
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

        final screenWidth = MediaQuery.of(context).size.width - 32;
        final currentWidth =
            screenWidth * (1 - widthProgress) + buttonSize * widthProgress;

        final finalWidth = currentWidth.clamp(buttonSize, screenWidth);

        return Center(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onBackToBottom?.call();
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(finalWidth / 2),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: finalWidth,
                  height: buttonSize,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.grey.shade800.withValues(alpha: 0.6)
                        : Colors.grey.shade100.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(finalWidth / 2),
                  ),
                  child: Center(
                    child: AnimatedScale(
                      scale: 0.8 + 0.2 * widthProgress,
                      duration: const Duration(milliseconds: 150),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.9)
                            : Colors.black.withValues(alpha: 0.8),
                        size: 24, // 稍微减小图标大小以适配48px的按钮
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
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
  final VoidCallback onSendMessage;
  final VoidCallback onShowImagePicker;
  final VoidCallback? onSwitchToVoiceMode;
  final File? selectedImageFile;
  final Uint8List? selectedImageBytes;
  final VoidCallback? onCancelSelectedImage;
  final VoidCallback? onInputFocused;
  final double animationValue;

  const TextInputArea({
    Key? key,
    required this.textController,
    required this.hasText,
    required this.isLoading,
    required this.conversationType,
    required this.onSendMessage,
    required this.onShowImagePicker,
    this.onSwitchToVoiceMode,
    this.selectedImageFile,
    this.selectedImageBytes,
    this.onCancelSelectedImage,
    this.onInputFocused,
    this.animationValue = 1.0,
  }) : super(key: key);

  @override
  State<TextInputArea> createState() => _TextInputAreaState();
}

class _TextInputAreaState extends State<TextInputArea> {
  bool _hasText = false;
  late final FocusNode _focusNode;

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
    final hasText = widget.textController.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool hasSelectedImage =
        widget.selectedImageBytes != null || widget.selectedImageFile != null;
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
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasSelectedImage)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.shade800.withValues(alpha: 0.5)
                              : Colors.grey.shade100.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: widget.selectedImageBytes != null
                                  ? Image.memory(
                                      widget.selectedImageBytes!,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      widget.selectedImageFile!,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(width: 10), // 从12减小到10
                            Expanded(
                              child: Text(
                                '已选择图片，输入描述后发送',
                                style: TextStyle(
                                  color: theme.textTheme.bodyMedium?.color,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            GlassIconButton(
                              icon: Icons.cancel,
                              color: Colors.red.shade400,
                              onTap: widget.onCancelSelectedImage,
                              isDark: isDark,
                              size: 36,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _focusNode,
                      controller: widget.textController,
                      decoration: InputDecoration(
                        hintText: hasSelectedImage ? '请描述图片...' : '输入消息...',
                        prefixIcon: const Icon(Icons.chat_bubble_outline),
                        filled: true,
                        fillColor: fieldFill,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: fieldBorder),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: fieldBorder),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                            width: 1.4,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: fieldBorder),
                        ),
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 4,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.send,
                      onSubmitted:
                          canSend ? (_) => widget.onSendMessage() : null,
                      onTap: widget.onInputFocused,
                      enabled: !widget.isLoading,
                    ),
                  ),
                  if ((widget.conversationType == 'dify' ||
                          widget.conversationType == 'openai' ||
                          widget.conversationType == 'watch_together') &&
                      !hasSelectedImage) ...[
                    const SizedBox(width: 10),
                    GlassIconButton(
                      icon: Icons.add_photo_alternate_outlined,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.8)
                          : Colors.black.withValues(alpha: 0.7),
                      onTap: widget.onShowImagePicker,
                      isDark: isDark,
                      size: 44,
                    ),
                  ],
                  const SizedBox(width: 10),
                  SizedBox.square(
                    dimension: 44,
                    child: FilledButton(
                      onPressed: canSend ? widget.onSendMessage : null,
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: widget.isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send_rounded, size: 20),
                    ),
                  ),
                  if (widget.conversationType == 'xiaozhi' &&
                      widget.onSwitchToVoiceMode != null) ...[
                    const SizedBox(width: 12),
                    AnimatedGlassButton(
                      icon: Icons.mic,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.8)
                          : Colors.black.withValues(alpha: 0.7),
                      onTap: widget.onSwitchToVoiceMode,
                      isDark: isDark,
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

/// 高斯模糊按钮组件
class GlassButton extends StatefulWidget {
  final Widget icon;
  final VoidCallback? onTap;
  final bool isDark;

  const GlassButton({
    Key? key,
    required this.icon,
    this.onTap,
    required this.isDark,
  }) : super(key: key);

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap?.call();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: 48, // 从54缩小到48
                  width: 48, // 从54缩小到48
                  decoration: BoxDecoration(
                    color: widget.isDark
                        ? Colors.grey.shade800.withValues(alpha: 0.5)
                        : Colors.grey.shade100.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: widget.icon),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 带动画的高斯模糊按钮组件
class AnimatedGlassButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isDark;

  const AnimatedGlassButton({
    Key? key,
    required this.icon,
    required this.color,
    this.onTap,
    required this.isDark,
  }) : super(key: key);

  @override
  State<AnimatedGlassButton> createState() => _AnimatedGlassButtonState();
}

class _AnimatedGlassButtonState extends State<AnimatedGlassButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _handleTapCancel() {
    _scaleController.reverse();
  }

  void _handleTap() {
    _rotationController.reset();
    _rotationController.forward();

    HapticFeedback.mediumImpact();

    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _rotationAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: 48, // 从54缩小到48
                  width: 48, // 从54缩小到48
                  decoration: BoxDecoration(
                    color: widget.isDark
                        ? Colors.grey.shade800.withValues(alpha: 0.5)
                        : Colors.grey.shade100.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Transform.rotate(
                      angle: _rotationAnimation.value * 2 * 3.14159,
                      child: Icon(
                        widget.icon,
                        color: widget.color,
                        size: 20, // 稍微缩小图标尺寸
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 小的高斯模糊图标按钮
class GlassIconButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isDark;
  final double size;

  const GlassIconButton({
    Key? key,
    required this.icon,
    required this.color,
    this.onTap,
    required this.isDark,
    this.size = 40,
  }) : super(key: key);

  @override
  State<GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<GlassIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap?.call();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  height: widget.size,
                  width: widget.size,
                  decoration: BoxDecoration(
                    color: widget.isDark
                        ? Colors.grey.shade800.withValues(alpha: 0.5)
                        : Colors.grey.shade100.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      widget.icon,
                      color: widget.color,
                      size: widget.size * 0.5,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
    Key? key,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.onCancelRecording,
    required this.onSwitchToTextMode,
    this.animationValue = 1.0,
  }) : super(key: key);

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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          16,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 3,
            height: 20 * _waveHeights[index % _waveHeights.length],
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.grey.shade800.withValues(alpha: 0.5)
                  : Colors.grey.shade100.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(1.5),
              boxShadow: [
                BoxShadow(
                  color: (isDark ? Colors.white : Colors.blue)
                      .withValues(alpha: 0.3),
                  blurRadius: 2,
                  spreadRadius: 0,
                ),
              ],
            ),
            curve: Curves.easeInOut,
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
        child: Container(
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.grey.shade800.withValues(alpha: 0.5)
                              : Colors.grey.shade100.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        height: 48, // 从54缩小到48
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (_isRecording && !_isCancelling)
                              _buildWaveAnimationIndicator(),
                            Center(
                              child: Text(
                                _isRecording
                                    ? _isCancelling
                                        ? "松开手指，取消发送"
                                        : "松开发送，上滑取消"
                                    : "按住说话",
                                style: TextStyle(
                                  color: _isRecording
                                      ? _isCancelling
                                          ? Colors.red.shade300
                                          : (isDark
                                              ? Colors.blue.shade300
                                              : Colors.blue.shade700)
                                      : (isDark
                                          ? Colors.white.withValues(alpha: 0.9)
                                          : Colors.black
                                              .withValues(alpha: 0.9)),
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
                ),
              ),
              const SizedBox(width: 12),
              AnimatedGlassButton(
                icon: Icons.keyboard,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.8)
                    : Colors.black.withValues(alpha: 0.7),
                onTap: () {
                  if (_isRecording) {
                    widget.onCancelRecording();
                    _stopWaveAnimation();
                  }
                  widget.onSwitchToTextMode();
                },
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
