import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/contracts/public_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/room/application/room_creation_gateway.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/features/room/presentation/room_taxonomy.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

Future<void> showCreateRoomDialog({
  required BuildContext context,
  required Future<void> Function(SyncTvRoom room) onCreated,
  double width = 520,
  String? successMessage,
}) {
  return showAppDialog<void>(
    context: context,
    builder: (_) => AppDialogFrame(
      maxWidth: width.clamp(520, 680),
      child: _CreateRoomDialogBody(
        pageContext: context,
        onCreated: onCreated,
        successMessage: successMessage ?? context.l10n.roomCreated,
      ),
    ),
  );
}

enum _RoomPasswordMode { none, password }

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
  RoomCreationGateway get _gateway =>
      DependencyScope.read<RoomCreationGateway>(context);

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
  _RoomPasswordMode _passwordMode = _RoomPasswordMode.none;
  bool _isPublic = true;
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
      final settings = await _gateway.getPublicSettings(refresh: true);
      if (!mounted) return;
      setState(() {
        _settings = settings;
        _loadingSettings = false;
        if (_passwordRequired) {
          _passwordMode = _RoomPasswordMode.password;
        }
        if (_passwordForbidden) {
          _passwordMode = _RoomPasswordMode.none;
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
        _gateway.listCategories(refresh: true),
        _gateway.listLabels(refresh: true),
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
    return settings != null && !settings.roomCreationEnabled;
  }

  bool get _passwordRequired =>
      _settings?.roomPasswordPolicy ==
      common.RoomPasswordPolicy.ROOM_PASSWORD_POLICY_REQUIRED;

  bool get _passwordForbidden =>
      _settings?.roomPasswordPolicy ==
      common.RoomPasswordPolicy.ROOM_PASSWORD_POLICY_FORBIDDEN;

  bool get _needPassword => _passwordMode == _RoomPasswordMode.password;

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
        AppNotifications.showWarning(
          context,
          context.l10n.roomCreationDisabled,
        );
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
      final room = await _gateway.createRoom(
        _nameController.text.trim(),
        password: _needPassword ? _passwordController.text : null,
        description: _descriptionController.text,
        categoryId: _selectedCategoryId,
        labelIds: _selectedLabelIdList,
        isPublic: _isPublic,
      );
      if (!mounted) return;
      final pendingReview = !room.isActive;
      Navigator.pop(context);
      if (!widget.pageContext.mounted) return;
      AppNotifications.showSuccess(
        widget.pageContext,
        pendingReview
            ? widget.pageContext.l10n.roomSubmittedForReview
            : widget.successMessage,
      );
      try {
        await widget.onCreated(room);
      } catch (error) {
        debugPrint('Post-create room action failed: $error');
      }
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.createRoomFailed(error.toString()),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _creating = false);
      }
    }
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return context.l10n.roomNameRequired;
    if (name.length > 64) return context.l10n.roomNameTooLong(64);
    return null;
  }

  String? _validatePassword(String? value) {
    if (_needPassword && (value == null || value.isEmpty)) {
      return context.l10n.roomPasswordRequired;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
                        _CreateRoomPolicyBanner(
                          icon: Icons.cloud_off_outlined,
                          text: l10n.createPolicyLoadFailed,
                          tone: _PolicyTone.warning,
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (_creationDisabled) ...[
                        _CreateRoomPolicyBanner(
                          icon: Icons.block_outlined,
                          text: l10n.roomCreationDisabledBanner,
                          tone: _PolicyTone.danger,
                        ),
                        const SizedBox(height: 16),
                      ] else if (_settings?.roomCreationApprovalRequired ==
                          true) ...[
                        _CreateRoomPolicyBanner(
                          icon: Icons.fact_check_outlined,
                          text: l10n.roomReviewRequiredBanner,
                          tone: _PolicyTone.info,
                        ),
                        const SizedBox(height: 16),
                      ],
                      Text(
                        l10n.basicInformation,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      AppTextField(
                        controller: _nameController,
                        focusNode: _nameFocus,
                        label: l10n.roomName,
                        hintText: l10n.roomNameHint,
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
                        label: l10n.roomDescription,
                        hintText: l10n.roomDescriptionHint,
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
                      _buildAccessSection(theme),
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
                    label: l10n.cancel,
                    style: AppActionButtonStyle.outlined,
                  ),
                  const SizedBox(width: 10),
                  AppActionButton(
                    onPressed: _canSubmit ? _submit : null,
                    icon: Icons.add_rounded,
                    label: _creating ? l10n.creating : l10n.createRoom,
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

  Widget _buildAccessSection(ThemeData theme) {
    final l10n = context.l10n;
    final enabled = !_creating && !_creationDisabled && _settingsError == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.roomVisibility,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        AppSwitchTile(
          key: const ValueKey('create-room-public-visibility'),
          value: _isPublic,
          title: Text(l10n.publicRoom),
          subtitle: Text(
            _isPublic
                ? l10n.publicRoomVisibilityDescription
                : l10n.privateRoomVisibilityDescription,
          ),
          prefix: Icon(
            _isPublic ? Icons.public_rounded : Icons.lock_outline_rounded,
          ),
          enabled: enabled,
          onChanged: (value) => setState(() => _isPublic = value),
        ),
        if (!_passwordForbidden) ...[
          const SizedBox(height: 18),
          Text(
            l10n.passwordProtection,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          if (_passwordRequired)
            _buildPasswordField()
          else ...[
            _PasswordModeSelector(
              value: _passwordMode,
              enabled: enabled,
              onChanged: (value) {
                setState(() {
                  _passwordMode = value;
                  if (value == _RoomPasswordMode.none) {
                    _passwordController.clear();
                  }
                });
              },
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: _needPassword
                  ? Padding(
                      key: const ValueKey('password'),
                      padding: const EdgeInsets.only(top: 12),
                      child: _buildPasswordField(),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildPasswordField() {
    final l10n = context.l10n;
    return AppTextField(
      key: const ValueKey('create-room-password'),
      controller: _passwordController,
      label: l10n.roomPassword,
      hintText: _passwordRequired
          ? l10n.serverRequiresPassword
          : l10n.membersEnterPassword,
      errorText: _submitted && _passwordError.isNotEmpty
          ? _passwordError
          : null,
      prefixIcon: Icons.lock_outline_rounded,
      enabled: !_creating && !_creationDisabled && _settingsError == null,
      obscureText: true,
      onChanged: (value) {
        if (!_submitted) return;
        setState(() => _passwordError = _validatePassword(value) ?? '');
      },
    );
  }

  Widget _buildTaxonomySection(ThemeData theme) {
    final l10n = context.l10n;
    final enabled = !_creating && !_creationDisabled && _settingsError == null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.roomCategory,
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
              l10n.taxonomyLoadFailedCreateAllowed,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
          ],
          AppSelect<String?>(
            value: _selectedCategoryId.isEmpty ? null : _selectedCategoryId,
            label: l10n.roomCategory,
            hintText: l10n.noCategory,
            prefixIcon: Icons.category_outlined,
            clearable: true,
            enabled: enabled && _categories.isNotEmpty,
            options: {
              l10n.noCategory: null,
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
            l10n.roomLabels,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          if (_availableLabels.isEmpty)
            Text(
              _selectedCategoryId.isEmpty
                  ? l10n.noLabelsAvailable
                  : l10n.noLabelsForCategory,
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
    final l10n = context.l10n;
    if (_loadingSettings) return l10n.loadingCreationPolicy;
    if (_settingsError != null) return l10n.creationPolicyUnavailable;
    if (_creationDisabled) return l10n.serverDisallowsNewRooms;
    if (_settings?.roomCreationApprovalRequired == true) {
      return l10n.roomWillBeReviewed;
    }
    if (!_isPublic) return l10n.privateRoomAccessHint;
    return _needPassword
        ? l10n.passwordRoomAccessHint
        : l10n.publicRoomAccessHint;
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
                      context.l10n.createRoom,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.createRoomSubtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              AppIconButton(
                tooltip: context.l10n.close,
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

class _PasswordModeSelector extends StatelessWidget {
  final _RoomPasswordMode value;
  final bool enabled;
  final ValueChanged<_RoomPasswordMode> onChanged;

  const _PasswordModeSelector({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 520;
        final noPasswordCard = _AccessModeCard(
          selected: value == _RoomPasswordMode.none,
          enabled: enabled,
          icon: Icons.lock_open_rounded,
          title: context.l10n.noRoomPassword,
          subtitle: context.l10n.noRoomPasswordJoinHint,
          onTap: () => onChanged(_RoomPasswordMode.none),
        );
        final passwordCard = _AccessModeCard(
          selected: value == _RoomPasswordMode.password,
          enabled: enabled,
          icon: Icons.lock_outline_rounded,
          title: context.l10n.passwordRoom,
          subtitle: context.l10n.passwordRoomJoinHint,
          onTap: () => onChanged(_RoomPasswordMode.password),
        );

        if (stacked) {
          return Column(
            children: [
              noPasswordCard,
              const SizedBox(height: 12),
              passwordCard,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: noPasswordCard),
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
