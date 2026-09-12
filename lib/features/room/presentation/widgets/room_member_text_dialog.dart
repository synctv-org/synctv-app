import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';

class RoomMemberTextDialog extends StatefulWidget {
  const RoomMemberTextDialog({
    super.key,
    required this.title,
    required this.label,
    required this.initialValue,
    required this.icon,
  });

  final String title;
  final String label;
  final String initialValue;
  final IconData icon;

  @override
  State<RoomMemberTextDialog> createState() => _RoomMemberTextDialogState();
}

class _RoomMemberTextDialogState extends State<RoomMemberTextDialog> {
  late final _controller = TextEditingController(text: widget.initialValue);
  var _closing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish(String? value) {
    if (!mounted || _closing || ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    _closing = true;
    Navigator.pop(context, value);
  }

  void _submit() {
    if (!mounted || _closing) return;
    _finish(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) => AppDialog(
    title: Text(widget.title),
    icon: Icon(widget.icon),
    body: SizedBox(
      width: 360,
      child: AppTextField(
        controller: _controller,
        label: widget.label,
        autofocus: true,
        maxLength: 64,
        onSubmitted: (_) => _submit(),
      ),
    ),
    actions: [
      AppActionButton(
        onPressed: () => _finish(null),
        label: context.l10n.cancel,
        style: AppActionButtonStyle.text,
      ),
      AppActionButton(onPressed: _submit, label: context.l10n.save),
    ],
  );
}
