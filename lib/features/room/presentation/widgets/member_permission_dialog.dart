import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart'
    as common_enum;

class MemberPermissionOverrideResult {
  const MemberPermissionOverrideResult({
    required this.addedPermissions,
    required this.removedPermissions,
    required this.adminAddedPermissions,
    required this.adminRemovedPermissions,
  });

  final int addedPermissions;
  final int removedPermissions;
  final int adminAddedPermissions;
  final int adminRemovedPermissions;
}

class MemberPermissionDialog extends StatefulWidget {
  const MemberPermissionDialog({super.key, required this.member});

  final AdminRoomMember member;

  @override
  State<MemberPermissionDialog> createState() => _MemberPermissionDialogState();
}

enum _Override { inherit, allow, deny }

class _MemberPermissionDialogState extends State<MemberPermissionDialog> {
  late int _added;
  late int _removed;

  bool get _isAdmin =>
      widget.member.role == common_enum.RoomMemberRole.ROOM_MEMBER_ROLE_ADMIN;

  @override
  void initState() {
    super.initState();
    _added = _isAdmin
        ? widget.member.adminAddedPermissions
        : widget.member.addedPermissions;
    _removed = _isAdmin
        ? widget.member.adminRemovedPermissions
        : widget.member.removedPermissions;
  }

  void _setOverride(int flag, _Override mode) {
    setState(() {
      _added &= ~flag;
      _removed &= ~flag;
      switch (mode) {
        case _Override.inherit:
          break;
        case _Override.allow:
          _added |= flag;
        case _Override.deny:
          _removed |= flag;
      }
    });
  }

  void _save() => Navigator.pop(
    context,
    MemberPermissionOverrideResult(
      addedPermissions: _isAdmin ? 0 : _added,
      removedPermissions: _isAdmin ? 0 : _removed,
      adminAddedPermissions: _isAdmin ? _added : 0,
      adminRemovedPermissions: _isAdmin ? _removed : 0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final permissions = _isAdmin
        ? RoomAdminPermissions.values
        : RoomMemberPermissions.values;
    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked =
            constraints.maxWidth < 640 ||
            MediaQuery.textScalerOf(context).scale(14) > 18;
        return AppDialog(
          title: Text(context.l10n.permissionOverrides),
          body: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final flag in permissions) _row(flag, stacked: stacked),
              ],
            ),
          ),
          actions: [
            AppActionButton(
              onPressed: () => Navigator.pop(context),
              label: context.l10n.cancel,
              style: AppActionButtonStyle.text,
            ),
            AppActionButton(
              onPressed: () => setState(() {
                _added = 0;
                _removed = 0;
              }),
              label: context.l10n.clearOverrides,
              style: AppActionButtonStyle.text,
            ),
            AppActionButton(onPressed: _save, label: context.l10n.save),
          ],
        );
      },
    );
  }

  Widget _row(int flag, {required bool stacked}) {
    final label = _isAdmin
        ? context.l10n.roomAdminPermissionLabel(flag)
        : context.l10n.roomMemberPermissionLabel(flag);
    final selected = (_added & flag) != 0
        ? _Override.allow
        : (_removed & flag) != 0
        ? _Override.deny
        : _Override.inherit;
    final control = AppSegmentedControl<_Override>(
      value: selected,
      style: const ButtonStyle(
        padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 8)),
      ),
      segments: [
        ButtonSegment(
          value: _Override.inherit,
          label: Text(context.l10n.inherit),
        ),
        ButtonSegment(value: _Override.allow, label: Text(context.l10n.allow)),
        ButtonSegment(value: _Override.deny, label: Text(context.l10n.deny)),
      ],
      onChanged: (mode) => _setOverride(flag, mode),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: stacked
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [Text(label), const SizedBox(height: 8), control],
            )
          : Row(
              children: [
                Expanded(child: Text(label)),
                const SizedBox(width: 12),
                control,
              ],
            ),
    );
  }
}
