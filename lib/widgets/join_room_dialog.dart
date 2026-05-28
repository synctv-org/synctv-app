import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> showJoinRoomDialog({
  required BuildContext context,
  required Future<void> Function(String value) onSubmitted,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => _JoinRoomDialog(onSubmitted: onSubmitted),
  );
}

Future<String?> showRoomPasswordDialog({
  required BuildContext context,
  required String roomName,
}) {
  return showDialog<String>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (_) => _RoomPasswordDialog(roomName: roomName),
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
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim();
    if (text == null || text.isEmpty) return;
    _controller.text = text;
    _controller.selection = TextSelection.collapsed(offset: text.length);
    setState(() => _hasInput = true);
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
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              _SubmitIntent: CallbackAction<_SubmitIntent>(onInvoke: (_) {
                _submit();
                return null;
              }),
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DialogHeader(
                  icon: Icons.login_rounded,
                  title: '加入房间',
                  subtitle: '输入房间 ID，或粘贴邀请链接',
                  onClose: _joining ? null : () => Navigator.pop(context),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.58),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant
                                .withValues(alpha: 0.7),
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
                                '邀请链接会自动识别服务器；如果本地已有多个匹配地址，会在下一步让你选择。',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        enabled: !_joining,
                        textInputAction: TextInputAction.done,
                        minLines: 1,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: '房间 ID 或邀请链接',
                          hintText: 'room_xxx 或 https://...',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.meeting_room_outlined),
                          suffixIcon: _hasInput
                              ? IconButton(
                                  tooltip: '清空',
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: _joining
                                      ? null
                                      : () {
                                          _controller.clear();
                                          setState(() => _hasInput = false);
                                          _focusNode.requestFocus();
                                        },
                                )
                              : null,
                        ),
                        onChanged: (value) =>
                            setState(() => _hasInput = value.trim().isNotEmpty),
                        onSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _joining ? null : _pasteFromClipboard,
                            icon: const Icon(Icons.content_paste_rounded),
                            label: const Text('粘贴邀请'),
                          ),
                          OutlinedButton.icon(
                            onPressed: _joining
                                ? null
                                : () {
                                    _controller.clear();
                                    setState(() => _hasInput = false);
                                    _focusNode.requestFocus();
                                  },
                            icon: const Icon(Icons.backspace_outlined),
                            label: const Text('清空'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                _DialogActions(
                  primaryLabel: _joining ? '查找中' : '继续',
                  primaryIcon: _joining
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.arrow_forward_rounded),
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

  const _RoomPasswordDialog({required this.roomName});

  @override
  State<_RoomPasswordDialog> createState() => _RoomPasswordDialogState();
}

class _RoomPasswordDialogState extends State<_RoomPasswordDialog> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.pop(context, _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogHeader(
              icon: Icons.lock_outline_rounded,
              title: '输入房间密码',
              subtitle: widget.roomName,
              onClose: () => Navigator.pop(context),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: '房间密码',
                  hintText: '输入后加入房间',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.key_rounded),
                  suffixIcon: IconButton(
                    tooltip: _obscure ? '显示密码' : '隐藏密码',
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                onSubmitted: (_) => _submit(),
              ),
            ),
            _DialogActions(
              primaryLabel: '加入房间',
              primaryIcon: const Icon(Icons.login_rounded),
              primaryEnabled: true,
              onCancel: () => Navigator.pop(context),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 22, 16, 18),
      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.colorScheme.onPrimary),
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
          IconButton(
            tooltip: '关闭',
            icon: const Icon(Icons.close_rounded),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _DialogActions extends StatelessWidget {
  final String primaryLabel;
  final Widget primaryIcon;
  final bool primaryEnabled;
  final VoidCallback onCancel;
  final VoidCallback onPrimary;

  const _DialogActions({
    required this.primaryLabel,
    required this.primaryIcon,
    required this.primaryEnabled,
    required this.onCancel,
    required this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: theme.dividerColor.withValues(alpha: 0.55)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: onCancel,
            child: const Text('取消'),
          ),
          const SizedBox(width: 10),
          FilledButton.icon(
            onPressed: primaryEnabled ? onPrimary : null,
            icon: primaryIcon,
            label: Text(primaryLabel),
          ),
        ],
      ),
    );
  }
}

class _SubmitIntent extends Intent {
  const _SubmitIntent();
}
