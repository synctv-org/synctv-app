import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';

class ChatMessageEditForm extends StatefulWidget {
  const ChatMessageEditForm({
    super.key,
    required this.initialContent,
    this.onSave,
  });

  final String initialContent;
  final Future<void> Function(String content)? onSave;

  @override
  State<ChatMessageEditForm> createState() => _ChatMessageEditFormState();
}

class _ChatMessageEditFormState extends State<ChatMessageEditForm> {
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  bool _closing = false;

  bool get _active =>
      mounted && !_closing && ModalRoute.of(context)?.isCurrent == true;
  late final _controller = TextEditingController(text: widget.initialContent);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_active || _saving || _formKey.currentState?.validate() != true) {
      return;
    }
    final content = _controller.text.trim();
    setState(() => _saving = true);
    try {
      if (content != widget.initialContent) await widget.onSave?.call(content);
      if (!mounted || !_active) return;
      _closing = true;
      Navigator.pop(context, content);
    } catch (error) {
      if (mounted && _active) {
        AppNotifications.showError(
          context,
          context.l10n.editMessageFailed('$error'),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: _controller,
            enabled: !_saving,
            label: context.l10n.messageContent,
            autofocus: true,
            minLines: 2,
            maxLines: 5,
            validator: (value) => value == null || value.trim().isEmpty
                ? context.l10n.messageContentRequired
                : null,
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppDialogs.createCancelButton(context),
              const SizedBox(width: 8),
              AppActionButton(
                onPressed: _saving ? null : _submit,
                loading: _saving,
                label: context.l10n.save,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
