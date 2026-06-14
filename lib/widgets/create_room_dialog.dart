import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/models/public_models.dart';
import 'package:synctv_app/models/watch_together_models.dart';
import 'package:synctv_app/services/watch_together_service.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';

Future<void> showCreateRoomDialog({
  required BuildContext context,
  required Future<void> Function(WRoom room) onCreated,
  double width = 520,
  String successMessage = '房间创建成功',
}) {
  return showAppDialog<void>(
    context: context,
    builder: (_) => AppDialogFrame(
      maxWidth: width.clamp(520, 680),
      child: _CreateRoomDialogBody(
        pageContext: context,
        onCreated: onCreated,
        successMessage: successMessage,
      ),
    ),
  );
}

enum _RoomAccessMode { public, password }

class _CreateRoomDialogBody extends StatefulWidget {
  final BuildContext pageContext;
  final Future<void> Function(WRoom room) onCreated;
  final String successMessage;

  const _CreateRoomDialogBody({
    required this.pageContext,
    required this.onCreated,
    required this.successMessage,
  });

  @override
  State<_CreateRoomDialogBody> createState() => _CreateRoomDialogBodyState();
}

class _CreateRoomDialogBodyState extends State<_CreateRoomDialogBody> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameFocus = FocusNode();

  PublicSettingsInfo? _settings;
  Object? _settingsError;
  bool _loadingSettings = true;
  bool _creating = false;
  _RoomAccessMode _accessMode = _RoomAccessMode.public;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _nameFocus.requestFocus());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await WatchTogetherService.getPublicSettings(
        refresh: true,
      );
      if (!mounted) return;
      setState(() {
        _settings = settings;
        _loadingSettings = false;
        if (_passwordRequired) {
          _accessMode = _RoomAccessMode.password;
        }
        if (_passwordForbidden) {
          _accessMode = _RoomAccessMode.public;
          _passwordController.clear();
        }
      });
    } catch (error) {
      debugPrint('Failed to load create room policy: $error');
      if (!mounted) return;
      setState(() {
        _settingsError = error;
        _loadingSettings = false;
      });
    }
  }

  bool get _creationDisabled {
    final settings = _settings;
    return settings != null &&
        (settings.disableCreateRoom || !settings.allowRoomCreation);
  }

  String get _passwordPolicy =>
      _settings?.roomPasswordPolicy.toLowerCase() ?? '';

  bool get _passwordRequired => _passwordPolicy == 'required';

  bool get _passwordForbidden => _passwordPolicy == 'forbidden';

  bool get _needPassword => _accessMode == _RoomAccessMode.password;

  bool get _canSubmit =>
      !_creating &&
      !_loadingSettings &&
      _settingsError == null &&
      !_creationDisabled;

  Future<void> _submit() async {
    if (!_canSubmit) {
      if (_creationDisabled) {
        MessageUtils.showWarning(context, '服务器当前已关闭房间创建');
      }
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _creating = true);
    try {
      final room = await WatchTogetherService.createRoom(
        _nameController.text.trim(),
        password: _needPassword ? _passwordController.text : null,
        description: _descriptionController.text,
      );
      if (!mounted) return;
      Navigator.pop(context);
      await widget.onCreated(room);
      final pendingReview = _settings?.createRoomNeedReview == true ||
          room.status != common_enum.RoomStatus.ROOM_STATUS_ACTIVE.value;
      if (!widget.pageContext.mounted) return;
      MessageUtils.showSuccess(
        widget.pageContext,
        pendingReview ? '房间已提交审核' : widget.successMessage,
      );
    } catch (error) {
      if (mounted) {
        MessageUtils.showError(context, '创建房间失败: $error');
      }
    } finally {
      if (mounted) {
        setState(() => _creating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompact = AppBreakpoints.isCompact(context);
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.enter, meta: true): _SubmitIntent(),
        SingleActivator(LogicalKeyboardKey.enter, control: true):
            _SubmitIntent(),
      },
      child: Actions(
        actions: {
          _SubmitIntent: CallbackAction<_SubmitIntent>(onInvoke: (_) {
            _submit();
            return null;
          }),
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CreateRoomHeader(
              loading: _loadingSettings,
              onClose: _creating ? null : () => Navigator.pop(context),
            ),
            Flexible(
              child: AppSingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  isCompact ? 18 : 24,
                  18,
                  isCompact ? 18 : 24,
                  20,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_settingsError != null) ...[
                        const _CreateRoomPolicyBanner(
                          icon: Icons.cloud_off_outlined,
                          text: '无法读取服务器创建策略，请稍后重试。',
                          tone: _PolicyTone.warning,
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (_creationDisabled) ...[
                        const _CreateRoomPolicyBanner(
                          icon: Icons.block_outlined,
                          text: '服务器当前已关闭房间创建。',
                          tone: _PolicyTone.danger,
                        ),
                        const SizedBox(height: 16),
                      ] else if (_settings?.createRoomNeedReview == true) ...[
                        const _CreateRoomPolicyBanner(
                          icon: Icons.fact_check_outlined,
                          text: '新房间需要审核。通过前只有管理员可以处理，普通用户暂时不可访问。',
                          tone: _PolicyTone.info,
                        ),
                        const SizedBox(height: 16),
                      ],
                      Text(
                        '基础信息',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        label: '房间名称',
                        hintText: '例如 周末电影夜',
                        prefixIcon: Icons.meeting_room_outlined,
                        enabled: !_creating &&
                            !_creationDisabled &&
                            _settingsError == null,
                        textInputAction: TextInputAction.next,
                        maxLength: 64,
                        counterText: '',
                        validator: (value) {
                          final name = value?.trim() ?? '';
                          if (name.isEmpty) return '请输入房间名称';
                          if (name.length > 64) {
                            return '房间名称不能超过 64 个字符';
                          }
                          return null;
                        },
                        onChanged: (_) => _formKey.currentState?.validate(),
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _descriptionController,
                        label: '房间简介',
                        hintText: '可选，帮助成员理解这个房间的用途',
                        prefixIcon: Icons.notes_outlined,
                        enabled: !_creating &&
                            !_creationDisabled &&
                            _settingsError == null,
                        minLines: 2,
                        maxLines: 4,
                        maxLength: 200,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        '访问方式',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _AccessModeSelector(
                        value: _accessMode,
                        passwordRequired: _passwordRequired,
                        passwordForbidden: _passwordForbidden,
                        enabled: !_creating &&
                            !_creationDisabled &&
                            _settingsError == null,
                        onChanged: (value) {
                          setState(() {
                            _accessMode = value;
                            if (value == _RoomAccessMode.public) {
                              _passwordController.clear();
                            }
                          });
                        },
                      ),
                      if (!_passwordForbidden) ...[
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: _needPassword
                              ? Padding(
                                  key: const ValueKey('password'),
                                  padding: const EdgeInsets.only(top: 12),
                                  child: AppTextField(
                                    controller: _passwordController,
                                    label: '房间密码',
                                    hintText: _passwordRequired
                                        ? '服务器要求设置密码'
                                        : '成员加入时需要输入',
                                    prefixIcon: Icons.lock_outline_rounded,
                                    enabled: !_creating &&
                                        !_creationDisabled &&
                                        _settingsError == null,
                                    obscureText: true,
                                    validator: (value) {
                                      if (_needPassword &&
                                          (value == null || value.isEmpty)) {
                                        return '请输入房间密码';
                                      }
                                      return null;
                                    },
                                    onChanged: (_) =>
                                        _formKey.currentState?.validate(),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            AppPanelSurface(
              padding: EdgeInsets.fromLTRB(
                isCompact ? 18 : 24,
                14,
                isCompact ? 18 : 24,
                18,
              ),
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.zero,
              clipBehavior: Clip.none,
              border: Border(
                top: BorderSide(
                  color: theme.dividerColor.withValues(alpha: 0.55),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _footerText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  AppActionButton(
                    onPressed: _creating ? null : () => Navigator.pop(context),
                    icon: Icons.close_rounded,
                    label: '取消',
                    style: AppActionButtonStyle.outlined,
                  ),
                  const SizedBox(width: 10),
                  AppActionButton(
                    onPressed: _canSubmit ? _submit : null,
                    icon: Icons.add_rounded,
                    label: _creating ? '创建中' : '创建房间',
                    loading: _creating,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _footerText {
    if (_loadingSettings) return '正在读取服务器创建策略';
    if (_settingsError != null) return '创建策略不可用';
    if (_creationDisabled) return '当前服务器不允许创建新房间';
    if (_settings?.createRoomNeedReview == true) return '创建后将提交审核';
    return _needPassword ? '密码房间只允许知道密码的成员加入' : '公开房间可被允许访问的成员加入';
  }
}

class _SubmitIntent extends Intent {
  const _SubmitIntent();
}

class _CreateRoomHeader extends StatelessWidget {
  final bool loading;
  final VoidCallback? onClose;

  const _CreateRoomHeader({
    required this.loading,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      padding: const EdgeInsets.fromLTRB(24, 22, 16, 18),
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
      borderRadius: BorderRadius.zero,
      clipBehavior: Clip.none,
      child: Column(
        children: [
          Row(
            children: [
              AppIconBadge(
                icon: Icons.video_call_outlined,
                color: theme.colorScheme.primary,
                iconColor: theme.colorScheme.onPrimary,
                backgroundColor: theme.colorScheme.primary,
                size: 44,
                borderRadius: BorderRadius.circular(12),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '创建房间',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '设置房间名称、简介和访问方式',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              AppIconButton(
                tooltip: '关闭',
                icon: Icons.close_rounded,
                onPressed: onClose,
              ),
            ],
          ),
          if (loading) ...[
            const SizedBox(height: 16),
            const AppLinearProgress(minHeight: 2),
          ],
        ],
      ),
    );
  }
}

class _AccessModeSelector extends StatelessWidget {
  final _RoomAccessMode value;
  final bool passwordRequired;
  final bool passwordForbidden;
  final bool enabled;
  final ValueChanged<_RoomAccessMode> onChanged;

  const _AccessModeSelector({
    required this.value,
    required this.passwordRequired,
    required this.passwordForbidden,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final canUsePublic = enabled && !passwordRequired;
    final canUsePassword = enabled && !passwordForbidden;
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 520;
        final publicCard = _AccessModeCard(
          selected: value == _RoomAccessMode.public,
          enabled: canUsePublic,
          icon: Icons.public_rounded,
          title: '公开房间',
          subtitle: passwordRequired ? '服务器要求设置密码' : '成员可直接申请或加入',
          onTap: () => onChanged(_RoomAccessMode.public),
        );
        final passwordCard = _AccessModeCard(
          selected: value == _RoomAccessMode.password,
          enabled: canUsePassword,
          icon: Icons.lock_outline_rounded,
          title: '密码房间',
          subtitle: passwordForbidden ? '服务器禁止设置密码' : '成员需要密码才能进入',
          onTap: () => onChanged(_RoomAccessMode.password),
        );

        if (stacked) {
          return Column(
            children: [
              publicCard,
              const SizedBox(height: 12),
              passwordCard,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: publicCard),
            const SizedBox(width: 12),
            Expanded(child: passwordCard),
          ],
        );
      },
    );
  }
}

class _AccessModeCard extends StatelessWidget {
  final bool selected;
  final bool enabled;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AccessModeCard({
    required this.selected,
    required this.enabled,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = selected
        ? theme.colorScheme.primary
        : theme.dividerColor.withValues(alpha: 0.6);
    return AppInkSurface(
      color: selected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.55)
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      onTap: enabled ? onTap : null,
      child: AppPanelSurface(
        padding: const EdgeInsets.all(14),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: selected ? 1.6 : 1),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: enabled ? theme.colorScheme.primary : theme.disabledColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: enabled ? null : theme.disabledColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: enabled
                          ? theme.colorScheme.onSurfaceVariant
                          : theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: enabled ? theme.colorScheme.primary : theme.disabledColor,
            ),
          ],
        ),
      ),
    );
  }
}

enum _PolicyTone { info, warning, danger }

class _CreateRoomPolicyBanner extends StatelessWidget {
  final IconData icon;
  final String text;
  final _PolicyTone tone;

  const _CreateRoomPolicyBanner({
    required this.icon,
    required this.text,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (tone) {
      _PolicyTone.info => theme.colorScheme.primary,
      _PolicyTone.warning => const Color(0xFFE09F3E),
      _PolicyTone.danger => theme.colorScheme.error,
    };
    return AppInfoBanner(
      icon: icon,
      color: color,
      backgroundColor: color.withValues(alpha: 0.1),
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.3)),
      crossAxisAlignment: CrossAxisAlignment.start,
      iconSize: 18,
      title: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          height: 1.35,
          color: color,
        ),
      ),
    );
  }
}
