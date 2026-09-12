import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/presentation/admin_gateway_scope.dart';
import 'package:synctv_app/l10n/l10n.dart';

class SendTestEmailDialog extends StatefulWidget {
  const SendTestEmailDialog({super.key});

  @override
  State<SendTestEmailDialog> createState() => _SendTestEmailDialogState();
}

class _SendTestEmailDialogState extends State<SendTestEmailDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _sending = false;
  var _closing = false;

  bool get _active =>
      mounted && !_closing && ModalRoute.of(context)?.isCurrent == true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish(String? message, {bool allowCovered = false}) {
    if (!mounted || _closing) return;
    final route = ModalRoute.of(context);
    if (route == null ||
        !route.isActive ||
        (!allowCovered && !route.isCurrent)) {
      return;
    }
    _closing = true;
    final navigator = Navigator.of(context);
    if (route.isCurrent) {
      navigator.pop(message);
    } else {
      navigator.removeRoute(route, message);
    }
  }

  Future<void> _submit() async {
    if (!_active || _sending || !_formKey.currentState!.validate()) return;
    final recipient = _controller.text.trim();
    setState(() => _sending = true);
    try {
      final message = await context.adminGateway.adminSendTestEmail(recipient);
      _finish(message, allowCovered: true);
    } catch (e) {
      if (!mounted || !_active) return;
      AppNotifications.showError(
        context,
        context.l10n.sendTestEmailFailed('$e'),
      );
    } finally {
      if (mounted && !_closing && ModalRoute.of(context)?.isActive == true) {
        setState(() => _sending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => AppDialog(
    title: Text(context.l10n.sendTestEmail),
    icon: const Icon(Icons.outgoing_mail),
    body: Form(
      key: _formKey,
      child: SizedBox(
        width: 360,
        child: AppTextField(
          controller: _controller,
          label: context.l10n.recipient,
          hintText: 'name@example.com',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.send,
          autofillHints: const [AutofillHints.email],
          autofocus: true,
          autocorrect: false,
          enabled: !_sending,
          validator: (value) => value == null || value.trim().isEmpty
              ? context.l10n.emailRequired
              : null,
          onSubmitted: (_) => _submit(),
        ),
      ),
    ),
    actions: [
      AppActionButton(
        label: context.l10n.cancel,
        style: AppActionButtonStyle.text,
        onPressed: () => _finish(null),
      ),
      AppActionButton(
        label: context.l10n.send,
        loading: _sending,
        onPressed: _sending ? null : _submit,
      ),
    ],
  );
}
