import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/core/network/server_endpoint_identity.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room_invite/domain/room_invite.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showWebRoomInviteDialog({
  required BuildContext context,
  required RoomInvite invite,
}) {
  final endpoint = ServerEndpointIdentity.normalize(invite.serverEndpoint!);
  return showAppDialog<void>(
    context: context,
    builder: (_) => _WebRoomInviteDialog(
      endpoint: Uri.parse(endpoint),
      roomId: invite.roomId,
    ),
  );
}

class _WebRoomInviteDialog extends StatefulWidget {
  const _WebRoomInviteDialog({required this.endpoint, required this.roomId});

  final Uri endpoint;
  final String roomId;

  @override
  State<_WebRoomInviteDialog> createState() => _WebRoomInviteDialogState();
}

class _WebRoomInviteDialogState extends State<_WebRoomInviteDialog> {
  var _busy = false;

  bool get _current => mounted && ModalRoute.of(context)?.isCurrent == true;

  Future<void> _copyRoomId() async {
    if (!_current || _busy) return;
    setState(() => _busy = true);
    try {
      await Clipboard.setData(ClipboardData(text: widget.roomId));
      if (mounted && _current) {
        AppNotifications.showInfo(context, context.l10n.copied);
      }
    } catch (_) {
      if (mounted && _current) {
        AppNotifications.showError(context, context.l10n.copyRoomIdFailed);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openServer() async {
    if (!_current || _busy) return;
    setState(() => _busy = true);
    try {
      // Launch directly from the gesture, before any other awaited operation.
      final opened = await launchUrl(
        widget.endpoint,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
      if (!opened && mounted && _current) {
        AppNotifications.showError(
          context,
          context.l10n.openInviteServerFailed,
        );
      }
    } catch (_) {
      if (mounted && _current) {
        AppNotifications.showError(
          context,
          context.l10n.openInviteServerFailed,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => AppDialog(
    constraints: const BoxConstraints(maxWidth: 520),
    icon: const Icon(Icons.travel_explore_rounded),
    title: Text(
      context.l10n.inviteOnAnotherServer,
      style: Theme.of(context).textTheme.titleMedium,
    ),
    body: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(context.l10n.webInviteServerDescription),
        const SizedBox(height: 16),
        AppReadOnlyField(
          label: context.l10n.server,
          value: widget.endpoint.toString(),
          labelAbove: true,
          maxLines: null,
        ),
        const SizedBox(height: 12),
        AppReadOnlyField(
          label: context.l10n.roomId,
          value: widget.roomId,
          labelAbove: true,
          maxLines: null,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: AppIconButton(
            tooltip: context.l10n.copyRoomId,
            icon: Icons.copy_rounded,
            onPressed: _busy ? null : _copyRoomId,
          ),
        ),
      ],
    ),
    actions: [
      AppActionButton(
        label: context.l10n.close,
        wrapLabel: true,
        style: AppActionButtonStyle.outlined,
        onPressed: () {
          if (_current) Navigator.of(context).pop();
        },
      ),
      AppActionButton(
        label: context.l10n.openInviteServer,
        icon: Icons.open_in_new_rounded,
        wrapLabel: true,
        onPressed: _busy ? null : _openServer,
      ),
    ],
  );
}
