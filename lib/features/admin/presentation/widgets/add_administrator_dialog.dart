import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/presentation/admin_gateway_scope.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;

class AddAdministratorDialog extends StatefulWidget {
  const AddAdministratorDialog({super.key, required this.promoteExisting});

  final bool promoteExisting;

  @override
  State<AddAdministratorDialog> createState() => _AddAdministratorDialogState();
}

class _AddAdministratorDialogState extends State<AddAdministratorDialog> {
  final _identity = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _saving = false;
  var _closing = false;

  bool get _active =>
      mounted && !_closing && ModalRoute.of(context)?.isCurrent == true;

  @override
  void dispose() {
    _identity.dispose();
    _password.dispose();
    super.dispose();
  }

  void _finish(bool added, {bool allowCovered = false}) {
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
      navigator.pop(added);
    } else {
      navigator.removeRoute(route, added);
    }
  }

  Future<void> _submit() async {
    if (!_active || _saving || !_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      if (widget.promoteExisting) {
        await context.adminGateway.adminAddAdmin(_identity.text.trim());
      } else {
        await context.adminGateway.adminAddUser(
          _identity.text.trim(),
          _password.text,
          common.UserRole.USER_ROLE_ADMIN,
        );
      }
      _finish(true, allowCovered: true);
    } catch (error) {
      if (mounted && _active) {
        AppNotifications.showError(context, context.l10n.addFailed('$error'));
      }
    } finally {
      if (mounted && !_closing && ModalRoute.of(context)?.isActive == true) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppDialog(
      title: Text(
        widget.promoteExisting
            ? l10n.promoteExistingUser
            : l10n.addAdministrator,
      ),
      icon: Icon(
        widget.promoteExisting
            ? Icons.person_search_rounded
            : Icons.admin_panel_settings_rounded,
      ),
      body: Form(
        key: _formKey,
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: _identity,
                label: widget.promoteExisting ? l10n.userId : l10n.username,
                labelAbove: true,
                prefixIcon: widget.promoteExisting
                    ? Icons.badge_outlined
                    : Icons.person_outline,
                enabled: !_saving,
                autocorrect: false,
                validator: (value) => value == null || value.trim().isEmpty
                    ? (widget.promoteExisting
                          ? l10n.userIdRequired
                          : l10n.usernameRequired)
                    : null,
                onSubmitted: (_) => _submit(),
              ),
              if (!widget.promoteExisting) ...[
                const SizedBox(height: 12),
                AppTextField(
                  controller: _password,
                  label: l10n.password,
                  labelAbove: true,
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                  enabled: !_saving,
                  validator: (value) => value == null || value.isEmpty
                      ? l10n.passwordRequired
                      : null,
                  onSubmitted: (_) => _submit(),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        AppActionButton(
          onPressed: () => _finish(false),
          label: l10n.cancel,
          style: AppActionButtonStyle.outlined,
        ),
        AppActionButton(
          onPressed: _saving ? null : _submit,
          loading: _saving,
          label: widget.promoteExisting ? l10n.promote : l10n.add,
        ),
      ],
    );
  }
}
