import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/admin/presentation/admin_gateway_scope.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as common;

class AddRoomMemberDialog extends StatefulWidget {
  const AddRoomMemberDialog({super.key, required this.roomId});

  final String roomId;

  @override
  State<AddRoomMemberDialog> createState() => _AddRoomMemberDialogState();
}

class _AddRoomMemberDialogState extends State<AddRoomMemberDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _role = common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER;
  var _notify = true;
  var _saving = false;
  var _closing = false;

  bool get _active =>
      mounted && !_closing && ModalRoute.of(context)?.isCurrent == true;

  @override
  void dispose() {
    _controller.dispose();
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
    final userId = _controller.text.trim();
    setState(() => _saving = true);
    try {
      await context.adminGateway.adminAddRoomMember(
        widget.roomId,
        userId,
        role: _role,
        notify: _notify,
      );
      _finish(true, allowCovered: true);
    } catch (e) {
      if (!mounted || !_active) return;
      AppNotifications.showError(context, context.l10n.addMemberFailed('$e'));
    } finally {
      if (mounted && !_closing && ModalRoute.of(context)?.isActive == true) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => AppDialog(
    title: Text(context.l10n.addMember),
    icon: const Icon(Icons.person_add_alt_rounded),
    body: Form(
      key: _formKey,
      child: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              controller: _controller,
              label: context.l10n.userId,
              prefixIcon: Icons.person_outline,
              enabled: !_saving,
              autofocus: true,
              autocorrect: false,
              validator: (value) => value == null || value.trim().isEmpty
                  ? context.l10n.userIdRequired
                  : null,
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 12),
            AppSelect<common.RoomMemberRole>(
              value: _role,
              label: context.l10n.roomRole,
              options: {
                context.l10n.member:
                    common.RoomMemberRole.ROOM_MEMBER_ROLE_MEMBER,
                context.l10n.administrator:
                    common.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN,
              },
              onChanged: _saving
                  ? null
                  : (value) => setState(() => _role = value ?? _role),
            ),
            const SizedBox(height: 12),
            AppSwitchTile(
              title: Text(context.l10n.notifyMember),
              value: _notify,
              onChanged: _saving
                  ? null
                  : (value) => setState(() => _notify = value),
            ),
          ],
        ),
      ),
    ),
    actions: [
      AppActionButton(
        onPressed: () => _finish(false),
        label: context.l10n.cancel,
        style: AppActionButtonStyle.text,
      ),
      AppActionButton(
        onPressed: _saving ? null : _submit,
        loading: _saving,
        label: context.l10n.add,
      ),
    ],
  );
}
