import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';

Future<bool?> showRoomDeleteConfirmationDialog({
  required BuildContext context,
  required String roomName,
}) {
  var completed = false;
  return showAppDialog<bool>(
    context: context,
    builder: (dialogContext) {
      void finish(bool result) {
        if (completed ||
            !dialogContext.mounted ||
            ModalRoute.of(dialogContext)?.isCurrent != true) {
          return;
        }
        completed = true;
        Navigator.of(dialogContext).pop(result);
      }

      return AppDialog(
        constraints: const BoxConstraints(maxWidth: 520),
        title: Text(
          dialogContext.l10n.deleteRoom,
          style: Theme.of(dialogContext).textTheme.titleMedium,
        ),
        icon: Icon(
          Icons.delete_outline,
          color: Theme.of(dialogContext).colorScheme.error,
        ),
        body: Text(dialogContext.l10n.deleteRoomConfirm(roomName)),
        actions: [
          AppActionButton(
            label: dialogContext.l10n.cancel,
            wrapLabel: true,
            style: AppActionButtonStyle.outlined,
            onPressed: () => finish(false),
          ),
          AppActionButton(
            label: dialogContext.l10n.delete,
            style: AppActionButtonStyle.destructive,
            wrapLabel: true,
            icon: Icons.delete_outline,
            onPressed: () => finish(true),
          ),
        ],
      );
    },
  );
}
