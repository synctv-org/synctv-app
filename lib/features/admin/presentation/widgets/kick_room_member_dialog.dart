import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';

class KickRoomMemberDialog extends StatefulWidget {
  const KickRoomMemberDialog({super.key});

  @override
  State<KickRoomMemberDialog> createState() => _KickRoomMemberDialogState();
}

class _KickRoomMemberDialogState extends State<KickRoomMemberDialog> {
  final _controller = TextEditingController(text: '60');
  final _formKey = GlobalKey<FormState>();
  var _closing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish(int? value) {
    if (_closing) return;
    _closing = true;
    Navigator.pop(context, value);
  }

  void _submit() {
    if (_closing || !_formKey.currentState!.validate()) return;
    _finish(int.parse(_controller.text.trim()));
  }

  @override
  Widget build(BuildContext context) => AppDialog(
    title: Text(context.l10n.kickMember),
    icon: Icon(
      Icons.logout_rounded,
      color: Theme.of(context).colorScheme.error,
    ),
    body: Form(
      key: _formKey,
      child: SizedBox(
        width: 360,
        child: AppTextField(
          controller: _controller,
          label: context.l10n.cooldownSeconds,
          prefixIcon: Icons.timer_outlined,
          keyboardType: TextInputType.number,
          onSubmitted: (_) => _submit(),
          validator: (value) {
            final seconds = int.tryParse(value?.trim() ?? '');
            return seconds == null || seconds < 1 || seconds > 2592000
                ? context.l10n.cooldownSecondsRange
                : null;
          },
        ),
      ),
    ),
    actions: [
      AppActionButton(
        onPressed: () => _finish(null),
        label: context.l10n.cancel,
        style: AppActionButtonStyle.text,
      ),
      AppActionButton(
        onPressed: _submit,
        label: context.l10n.kick,
        style: AppActionButtonStyle.destructive,
      ),
    ],
  );
}
