import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/models/public_models.dart';
import 'package:synctv_app/models/synctv_models.dart';
import 'package:synctv_app/services/synctv_service.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/utils/message_utils.dart';
import 'package:synctv_app/utils/room_taxonomy.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';

Future<void> showCreateRoomDialog({
  required BuildContext context,
  required Future<void> Function(SyncTvRoom room) onCreated,
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
  final Future<void> Function(SyncTvRoom room) onCreated;
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
  List<RoomCategoryInfo> _categories = const [];
  List<RoomLabelInfo> _labels = const [];
  Object? _settingsError;
  Object? _taxonomyError;
  bool _loadingSettings = true;
  bool _loadingTaxonomy = true;
  bool _creating = false;
  bool _submitted = false;
  String _nameError = '';
  String _passwordError = '';
  _RoomAccessMode _accessMode = _RoomAccessMode.public;
  String _selectedCategoryId = '';
  final Set<String> _selectedLabelIds = <String>{};

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadTaxonomy();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _nameFocus.requestFocus(),
    );
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
      final settings = await SyncTvService.getPublicSettings(refresh: true);
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

  Future<void> _loadTaxonomy() async {
    try {
      final results = await Future.wait([
        SyncTvService.listRoomCategories(refresh: true),
        SyncTvService.listRoomLabels(refresh: true),
      ]);
      final categories =
          results[0]
              .cast<RoomCategoryInfo>()
              .where((category) => category.isEnabled)
              .toList()
            ..sort((a, b) {
              final order = a.sortOrder.compareTo(b.sortOrder);
              if (order != 0) return order;
              return _categoryName(a).compareTo(_categoryName(b));
            });
      final labels =
          results[1]
              .cast<RoomLabelInfo>()
              .where((label) => label.isEnabled)
              .toList()
            ..sort((a, b) {
              final order = a.sortOrder.compareTo(b.sortOrder);
              if (order != 0) return order;
              return _labelName(a).compareTo(_labelName(b));
            });
      if (!mounted) return;
      setState(() {
        _categories = categories;
        _labels = labels;
        _loadingTaxonomy = false;
        _selectedLabelIds.removeWhere(
          (id) => !_availableLabels.any((label) => label.id == id),
        );
      });
    } catch (error) {
      debugPrint('Failed to load room taxonomy: $error');
      if (!mounted) return;
      setState(() {
        _taxonomyError = error;
        _loadingTaxonomy = false;
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

  List<RoomLabelInfo> get _availableLabels {
    if (_selectedCategoryId.isEmpty) return _labels;
    return _labels
        .where((label) => label.categoryId == _selectedCategoryId)
        .toList(growable: false);
  }

  String _categoryName(RoomCategoryInfo category) {
    final name = category.name.trim();
    return name.isEmpty ? category.key : name;
  }

  String _labelName(RoomLabelInfo label) {
    final name = label.name.trim();
    return name.isEmpty ? label.key : name;
  }

  List<String> get _selectedLabelIdList {
    if (_selectedLabelIds.isEmpty) return const [];
    return _availableLabels
        .where((label) => _selectedLabelIds.contains(label.id))
        .map((label) => label.id)
        .toList(growable: false);
  }

  Future<void> _submit() async {
    if (!_canSubmit) {
      if (_creationDisabled) {
        MessageUtils.showWarning(context, '服务器当前已关闭房间创建');
      }
      return;
    }
    final nameError = _validateName(_nameController.text);
    final passwordError = _validatePassword(_passwordController.text);
    setState(() {
      _submitted = true;
      _nameError = nameError ?? '';
      _passwordError = passwordError ?? '';
    });
    if (nameError != null || passwordError != null) return;

    setState(() => _creating = true);
    try {
      final room = await SyncTvService.createRoom(
        _nameController.text.trim(),
        password: _needPassword ? _passwordController.text : null,
        description: _descriptionController.text,
        categoryId: _selectedCategoryId,
        labelIds: _selectedLabelIdList,
      );
      if (!mounted) return;
      Navigator.pop(context);
      await widget.onCreated(room);
      final pendingReview =
          _settings?.createRoomNeedReview == true ||
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

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return '请输入房间名称';
    if (name.length > 64) return '房间名称不能超过 64 个字符';
    return null;
  }

  String? _validatePassword(String? value) {
    if (_needPassword && (value == null || value.isEmpty)) {
      return '请输入房间密码';
    }
    return null;
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
          _SubmitIntent: CallbackAction<_SubmitIntent>(
            onInvoke: (_) {
              _submit();
              return null;
            },
          ),
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
                        errorText: _submitted && _nameError.isNotEmpty
                            ? _nameError
                            : null,
                        prefixIcon: Icons.meeting_room_outlined,
                        enabled:
                            !_creating &&
                            !_creationDisabled &&
                            _settingsError == null,
                        textInputAction: TextInputAction.next,
                        maxLength: 64,
                        counterText: '',
                        onChanged: (value) {
                          if (!_submitted) return;
                          setState(
                            () => _nameError = _validateName(value) ?? '',
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _descriptionController,
                        label: '房间简介',
                        hintText: '可选，帮助成员理解这个房间的用途',
                        prefixIcon: Icons.notes_outlined,
                        enabled:
                            !_creating &&
                            !_creationDisabled &&
                            _settingsError == null,
                        minLines: 2,
                        maxLines: 4,
                        maxLength: 200,
                      ),
                      const SizedBox(height: 18),
                      _buildTaxonomySection(theme),
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
                        enabled:
                            !_creating &&
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
                                    errorText:
                                        _submitted && _passwordError.isNotEmpty
                                        ? _passwordError
                                        : null,
                                    prefixIcon: Icons.lock_outline_rounded,
                                    enabled:
                                        !_creating &&
                                        !_creationDisabled &&
                                        _settingsError == null,
                                    obscureText: true,
                                    onChanged: (value) {
                                      if (!_submitted) return;
                                      setState(
                                        () => _passwordError =
                                            _validatePassword(value) ?? '',
                                      );
                                    },
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

  Widget _buildTaxonomySection(ThemeData theme) {
    final enabled = !_creating && !_creationDisabled && _settingsError == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '房间分类',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        if (_loadingTaxonomy)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              width: 18,
              height: 18,
              child: AppLoadingIndicator(
                size: AppLoadingSize.sm,
                centered: false,
              ),
            ),
          )
        else ...[
          if (_taxonomyError != null) ...[
            Text(
              '分类信息读取失败，仍可继续创建房间。',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
          ],
          AppSelect<String?>(
            value: _selectedCategoryId.isEmpty ? null : _selectedCategoryId,
            label: '房间分类',
            hintText: '不设置分类',
            prefixIcon: Icons.category_outlined,
            clearable: true,
            enabled: enabled && _categories.isNotEmpty,
            options: {
              '不设置分类': null,
              for (final category in _categories)
                _categoryName(category): category.id,
            },
            onChanged: (value) {
              setState(() {
                _selectedCategoryId = value ?? '';
                _selectedLabelIds.removeWhere(
                  (id) => !_availableLabels.any((label) => label.id == id),
                );
              });
            },
          ),
          const SizedBox(height: 14),
          Text(
            '房间标签',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          if (_availableLabels.isEmpty)
            Text(
              _selectedCategoryId.isEmpty ? '暂无可用标签' : '当前分类下暂无标签',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableLabels
                  .map((label) {
                    final selected = _selectedLabelIds.contains(label.id);
                    final color = parseRoomLabelColor(
                      label.color,
                      theme.colorScheme.primary,
                    );
                    return AppChip(
                      selected: selected,
                      enabled: enabled,
                      onSelected: (value) {
                        setState(() {
                          if (value) {
                            _selectedLabelIds.add(label.id);
                          } else {
                            _selectedLabelIds.remove(label.id);
                          }
                        });
                      },
                      style: selected
                          ? AppChipStyle.filled
                          : AppChipStyle.outlined,
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
                          Text(_labelName(label)),
                        ],
                      ),
                    );
                  })
                  .toList(growable: false),
            ),
        ],
      ],
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

  const _CreateRoomHeader({required this.loading, required this.onClose});

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
            children: [publicCard, const SizedBox(height: 12), passwordCard],
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
        style: theme.textTheme.bodySmall?.copyWith(height: 1.35, color: color),
      ),
    );
  }
}
