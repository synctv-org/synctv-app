import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

Future<void> showJoinRoomDialog({
  required BuildContext context,
  required Future<void> Function(String value) onSubmitted,
}) {
  return showAppDialog<void>(
    context: context,
    builder: (_) => _JoinRoomDialog(onSubmitted: onSubmitted),
  );
}

Future<JoinRoomResult?> showRoomPasswordDialog({
  required BuildContext context,
  required String roomName,
  required Future<JoinRoomResult> Function(String password) onSubmitted,
}) {
  return showAppDialog<JoinRoomResult>(
    context: context,
    builder: (_) =>
        _RoomPasswordDialog(roomName: roomName, onSubmitted: onSubmitted),
  );
}

class _JoinRoomDialog extends StatefulWidget {
  final Future<void> Function(String value) onSubmitted;

  const _JoinRoomDialog({required this.onSubmitted});

  @override
  State<_JoinRoomDialog> createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends State<_JoinRoomDialog> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _joining = false;
  bool _hasInput = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_joining) return;
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    setState(() => _joining = true);
    try {
      await widget.onSubmitted(value);
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppDialogFrame(
      maxWidth: 560,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Shortcuts(
          shortcuts: const {
            SingleActivator(LogicalKeyboardKey.enter, meta: true):
                _SubmitIntent(),
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
                _DialogHeader(
                  icon: Icons.login_rounded,
                  title: context.l10n.joinRoom,
                  subtitle: context.l10n.joinRoomSubtitle,
                  onClose: _joining ? null : () => Navigator.pop(context),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppPanelSurface(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.58),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant.withValues(
                            alpha: 0.7,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.dns_rounded,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                context.l10n.inviteLinkServerHint,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        label: context.l10n.roomIdOrInviteLink,
                        hintText: context.l10n.roomIdOrInviteLinkHint,
                        prefixIcon: Icons.meeting_room_outlined,
                        enabled: !_joining,
                        textInputAction: TextInputAction.done,
                        minLines: 1,
                        maxLines: 3,
                        keyboardType: TextInputType.url,
                        autocorrect: false,
                        smartDashesType: SmartDashesType.disabled,
                        smartQuotesType: SmartQuotesType.disabled,
                        onChanged: (value) =>
                            setState(() => _hasInput = value.trim().isNotEmpty),
                        onSubmitted: (_) => _submit(),
                      ),
                    ],
                  ),
                ),
                _DialogActions(
                  primaryLabel: _joining
                      ? context.l10n.searching
                      : context.l10n.continueAction,
                  primaryIcon: Icons.arrow_forward_rounded,
                  primaryLoading: _joining,
                  primaryEnabled: !_joining && _hasInput,
                  onCancel: () => Navigator.pop(context),
                  onPrimary: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoomPasswordDialog extends StatefulWidget {
  final String roomName;
  final Future<JoinRoomResult> Function(String password) onSubmitted;

  const _RoomPasswordDialog({
    required this.roomName,
    required this.onSubmitted,
  });

  @override
  State<_RoomPasswordDialog> createState() => _RoomPasswordDialogState();
}

class _RoomPasswordDialogState extends State<_RoomPasswordDialog> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _joining = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_joining) return;
    final password = _controller.text;
    if (password.isEmpty) {
      setState(() => _errorText = context.l10n.passwordRequired);
      return;
    }
    setState(() {
      _joining = true;
      _errorText = null;
    });
    try {
      final result = await widget.onSubmitted(password);
      if (mounted) Navigator.pop(context, result);
    } on RoomPasswordRejectedException {
      if (mounted) {
        setState(() => _errorText = context.l10n.incorrectRoomPassword);
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
        _focusNode.requestFocus();
      }
    } catch (error) {
      if (mounted) {
        setState(
          () => _errorText = context.l10n.joinRoomFailed(error.toString()),
        );
      }
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogFrame(
      maxWidth: 500,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogHeader(
              icon: Icons.lock_outline_rounded,
              title: context.l10n.enterRoomPassword,
              subtitle: widget.roomName,
              onClose: _joining ? null : () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
              child: AppTextField(
                controller: _controller,
                focusNode: _focusNode,
                label: context.l10n.roomPassword,
                hintText: context.l10n.roomPasswordJoinHint,
                prefixIcon: Icons.key_rounded,
                obscureText: true,
                enabled: !_joining,
                errorText: _errorText,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
            ),
            _DialogActions(
              primaryLabel: _joining
                  ? context.l10n.searching
                  : context.l10n.joinRoom,
              primaryIcon: Icons.login_rounded,
              primaryLoading: _joining,
              primaryEnabled: !_joining,
              onCancel: () {
                if (!_joining) Navigator.pop(context);
              },
              onPrimary: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onClose;

  const _DialogHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
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
      child: Row(
        children: [
          AppIconBadge(
            icon: icon,
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
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
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
    );
  }
}

class _DialogActions extends StatelessWidget {
  final String primaryLabel;
  final IconData primaryIcon;
  final bool primaryLoading;
  final bool primaryEnabled;
  final VoidCallback onCancel;
  final VoidCallback onPrimary;

  const _DialogActions({
    required this.primaryLabel,
    required this.primaryIcon,
    this.primaryLoading = false,
    required this.primaryEnabled,
    required this.onCancel,
    required this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
      borderRadius: BorderRadius.zero,
      clipBehavior: Clip.none,
      border: Border(
        top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.55)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppActionButton(
            onPressed: onCancel,
            label: context.l10n.cancel,
            style: AppActionButtonStyle.outlined,
          ),
          const SizedBox(width: 10),
          AppActionButton(
            onPressed: primaryEnabled ? onPrimary : null,
            icon: primaryIcon,
            label: primaryLabel,
            loading: primaryLoading,
          ),
        ],
      ),
    );
  }
}

class _SubmitIntent extends Intent {
  const _SubmitIntent();
}
