import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

Future<void> showJoinRoomDialog({
  required BuildContext context,
  required Future<void> Function(BuildContext dialogContext, String value)
  onSubmitted,
}) => showAppDialog<void>(
  context: context,
  builder: (_) => _JoinRoomDialog(onSubmitted: onSubmitted),
);

Future<JoinRoomResult?> showRoomPasswordDialog({
  required BuildContext context,
  required String roomName,
  required Future<JoinRoomResult> Function(String password) onSubmitted,
}) => showAppDialog<JoinRoomResult>(
  context: context,
  builder: (_) =>
      _RoomPasswordDialog(roomName: roomName, onSubmitted: onSubmitted),
);

class _JoinRoomDialog extends StatefulWidget {
  const _JoinRoomDialog({required this.onSubmitted});

  final Future<void> Function(BuildContext dialogContext, String value)
  onSubmitted;

  @override
  State<_JoinRoomDialog> createState() => _JoinRoomDialogState();
}

class _JoinRoomDialogState extends State<_JoinRoomDialog> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  var _joining = false;
  var _hasInput = false;
  String? _errorText;

  bool get _current => mounted && ModalRoute.of(context)?.isCurrent == true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_current || _joining) return;
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    setState(() {
      _joining = true;
      _errorText = null;
    });
    try {
      await widget.onSubmitted(context, value);
    } catch (error) {
      if (mounted && _current) {
        setState(
          () => _errorText = context.l10n.findRoomFailed(error.toString()),
        );
      }
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  @override
  Widget build(BuildContext context) => Shortcuts(
    shortcuts: const {
      SingleActivator(LogicalKeyboardKey.enter, meta: true): _SubmitIntent(),
      SingleActivator(LogicalKeyboardKey.enter, control: true): _SubmitIntent(),
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
      child: AppDialog(
        constraints: const BoxConstraints(maxWidth: 560),
        icon: const Icon(Icons.login_rounded),
        title: Text(
          context.l10n.joinRoom,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        body: AppTextField(
          controller: _controller,
          focusNode: _focusNode,
          label: context.l10n.roomIdOrInviteLink,
          labelAbove: true,
          hintText: context.l10n.roomIdOrInviteLinkHint,
          enabled: !_joining,
          errorText: _errorText,
          textInputAction: TextInputAction.done,
          minLines: 1,
          maxLines: 3,
          keyboardType: TextInputType.url,
          autocorrect: false,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
          onChanged: (value) => setState(() {
            _hasInput = value.trim().isNotEmpty;
            _errorText = null;
          }),
          onSubmitted: (_) => _submit(),
        ),
        actions: [
          AppActionButton(
            label: context.l10n.cancel,
            wrapLabel: true,
            style: AppActionButtonStyle.outlined,
            onPressed: () {
              if (_current) Navigator.of(context).pop();
            },
          ),
          AppActionButton(
            label: _joining
                ? context.l10n.searching
                : context.l10n.continueAction,
            icon: Icons.arrow_forward_rounded,
            wrapLabel: true,
            loading: _joining,
            onPressed: _hasInput && !_joining ? _submit : null,
          ),
        ],
      ),
    ),
  );
}

class _RoomPasswordDialog extends StatefulWidget {
  const _RoomPasswordDialog({
    required this.roomName,
    required this.onSubmitted,
  });

  final String roomName;
  final Future<JoinRoomResult> Function(String password) onSubmitted;

  @override
  State<_RoomPasswordDialog> createState() => _RoomPasswordDialogState();
}

class _RoomPasswordDialogState extends State<_RoomPasswordDialog> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  var _joining = false;
  String? _errorText;

  bool get _current => mounted && ModalRoute.of(context)?.isCurrent == true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_current || _joining) return;
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
      if (mounted && _current) Navigator.of(context).pop(result);
    } on RoomPasswordRejectedException {
      if (mounted && _current) {
        setState(() => _errorText = context.l10n.incorrectRoomPassword);
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
        _focusNode.requestFocus();
      }
    } catch (error) {
      if (mounted && _current) {
        setState(
          () => _errorText = context.l10n.joinRoomFailed(error.toString()),
        );
      }
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }

  @override
  Widget build(BuildContext context) => AppDialog(
    constraints: const BoxConstraints(maxWidth: 500),
    icon: const Icon(Icons.lock_outline_rounded),
    title: Text(
      context.l10n.enterRoomPassword,
      style: Theme.of(context).textTheme.titleMedium,
    ),
    body: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.roomName, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
        AppTextField(
          controller: _controller,
          focusNode: _focusNode,
          label: context.l10n.roomPassword,
          labelAbove: true,
          hintText: context.l10n.roomPasswordJoinHint,
          obscureText: true,
          enabled: !_joining,
          errorText: _errorText,
          textInputAction: TextInputAction.done,
          onChanged: (_) {
            if (_errorText != null) setState(() => _errorText = null);
          },
          onSubmitted: (_) => _submit(),
        ),
      ],
    ),
    actions: [
      AppActionButton(
        label: context.l10n.cancel,
        wrapLabel: true,
        style: AppActionButtonStyle.outlined,
        onPressed: _joining
            ? null
            : () {
                if (_current) Navigator.of(context).pop();
              },
      ),
      AppActionButton(
        label: _joining ? context.l10n.searching : context.l10n.joinRoom,
        icon: Icons.login_rounded,
        wrapLabel: true,
        loading: _joining,
        onPressed: _joining ? null : _submit,
      ),
    ],
  );
}

class _SubmitIntent extends Intent {
  const _SubmitIntent();
}
