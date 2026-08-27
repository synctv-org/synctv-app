import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;

class RtmpPublishKeyOptions {
  const RtmpPublishKeyOptions({required this.keyType, this.expiresAt});

  final client_enum.PublishKeyType keyType;
  final int? expiresAt;
}

class RtmpPublishKeyOptionsController
    extends ValueNotifier<RtmpPublishKeyOptionsDraft> {
  RtmpPublishKeyOptionsController(DateTime now)
    : super(
        RtmpPublishKeyOptionsDraft(
          keyType: client_enum.PublishKeyType.PUBLISH_KEY_TYPE_SINGLE_USE,
          expiresAt: now.add(const Duration(hours: 1)),
        ),
      );

  void setKeyType(client_enum.PublishKeyType keyType) {
    value = value.copyWith(keyType: keyType);
  }

  void setExpiresAt(DateTime expiresAt) {
    value = value.copyWith(expiresAt: expiresAt);
  }
}

class RtmpPublishKeyOptionsDraft {
  const RtmpPublishKeyOptionsDraft({
    required this.keyType,
    required this.expiresAt,
  });

  final client_enum.PublishKeyType keyType;
  final DateTime expiresAt;

  RtmpPublishKeyOptionsDraft copyWith({
    client_enum.PublishKeyType? keyType,
    DateTime? expiresAt,
  }) => RtmpPublishKeyOptionsDraft(
    keyType: keyType ?? this.keyType,
    expiresAt: expiresAt ?? this.expiresAt,
  );
}

Future<RtmpPublishKeyOptions?> showRtmpPublishKeyOptionsDialog(
  BuildContext context, {
  DateTime Function()? now,
}) async {
  final currentTime = now ?? DateTime.now;
  final controller = RtmpPublishKeyOptionsController(currentTime());
  try {
    return await AppDialogs.showStyledDialog<RtmpPublishKeyOptions>(
      context: context,
      title: context.l10n.generatePublishKey,
      icon: const Icon(Icons.key_rounded),
      content: RtmpPublishKeyOptionsForm(
        controller: controller,
        now: currentTime,
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, draft, _) =>
              AppDialogs.createConfirmButton(context, () {
                final permanent =
                    draft.keyType ==
                    client_enum.PublishKeyType.PUBLISH_KEY_TYPE_PERMANENT;
                if (!permanent && !draft.expiresAt.isAfter(currentTime())) {
                  AppNotifications.showWarning(
                    context,
                    context.l10n.publishKeyExpirationMustBeFuture,
                  );
                  return;
                }
                Navigator.pop(
                  context,
                  RtmpPublishKeyOptions(
                    keyType: draft.keyType,
                    expiresAt: permanent
                        ? null
                        : draft.expiresAt.millisecondsSinceEpoch ~/ 1000,
                  ),
                );
              }, text: context.l10n.generatePublishKey),
        ),
      ],
    );
  } finally {
    controller.dispose();
  }
}

class RtmpPublishKeyOptionsForm extends StatelessWidget {
  const RtmpPublishKeyOptionsForm({
    super.key,
    required this.controller,
    required this.now,
  });

  final RtmpPublishKeyOptionsController controller;
  final DateTime Function() now;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, draft, _) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSelect<client_enum.PublishKeyType>(
            key: const Key('rtmp-key-options-type'),
            value: draft.keyType,
            label: context.l10n.publishKeyType,
            prefixIcon: Icons.key_rounded,
            options: {
              context.l10n.singleUsePublishKey:
                  client_enum.PublishKeyType.PUBLISH_KEY_TYPE_SINGLE_USE,
              context.l10n.expiringPublishKey:
                  client_enum.PublishKeyType.PUBLISH_KEY_TYPE_EXPIRING,
              context.l10n.permanentPublishKey:
                  client_enum.PublishKeyType.PUBLISH_KEY_TYPE_PERMANENT,
            },
            onChanged: (value) {
              if (value != null) controller.setKeyType(value);
            },
          ),
          const SizedBox(height: 14),
          if (draft.keyType ==
              client_enum.PublishKeyType.PUBLISH_KEY_TYPE_PERMANENT)
            AppPanelSurface(
              padding: const EdgeInsets.all(12),
              color: Theme.of(
                context,
              ).colorScheme.errorContainer.withValues(alpha: 0.35),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      context.l10n.permanentPublishKeyDescription,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            )
          else
            OutlinedButton.icon(
              key: const Key('rtmp-key-options-expiration'),
              onPressed: () => _selectExpiration(context, draft.expiresAt),
              icon: const Icon(Icons.schedule_rounded),
              label: Text(
                '${context.l10n.expirationTime}: '
                '${formatRtmpPublishTimestamp(draft.expiresAt.millisecondsSinceEpoch ~/ 1000)}',
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _selectExpiration(BuildContext context, DateTime current) async {
    final currentTime = now();
    final initial = current.isAfter(currentTime)
        ? current
        : currentTime.add(const Duration(hours: 1));
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: currentTime,
      lastDate: currentTime.add(const Duration(days: 3650)),
    );
    if (!context.mounted || date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (!context.mounted || time == null) return;

    final expiresAt = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    if (!expiresAt.isAfter(now())) {
      AppNotifications.showWarning(
        context,
        context.l10n.publishKeyExpirationMustBeFuture,
      );
      return;
    }
    controller.setExpiresAt(expiresAt);
  }
}

Future<void> showRtmpPublishCredentialsDialog(
  BuildContext context, {
  required RtmpPublishKeyInfo publish,
  RoomStreamEntryInfo? streamInfo,
}) => AppDialogs.showStyledDialog<void>(
  context: context,
  title: context.l10n.rtmpPublishing,
  icon: const Icon(Icons.live_tv_rounded),
  content: SizedBox(
    width: 420,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _RtmpInfoRow(
          label: context.l10n.publishingAddress,
          value: publish.rtmpUrl,
          copyable: true,
        ),
        _RtmpInfoRow(
          label: context.l10n.streamKey,
          value: publish.streamKey,
          copyable: true,
        ),
        _RtmpInfoRow(
          label: context.l10n.publishKey,
          value: publish.publishKey,
          copyable: true,
        ),
        if (publish.whipUrl.isNotEmpty)
          _RtmpInfoRow(
            label: context.l10n.whipUrl,
            value: publish.whipUrl,
            copyable: true,
          ),
        _RtmpInfoRow(
          label: context.l10n.publishKeyType,
          value: rtmpPublishKeyTypeLabel(context, publish.keyType),
        ),
        _RtmpInfoRow(
          label: context.l10n.expirationTime,
          value: publish.expiresAt == null
              ? context.l10n.noExpiration
              : formatRtmpPublishTimestamp(publish.expiresAt!),
        ),
        if (streamInfo != null)
          _RtmpInfoRow(
            label: context.l10n.currentStatus,
            value: streamInfo.active
                ? context.l10n.active
                : context.l10n.inactive,
          ),
      ],
    ),
  ),
  actions: [
    AppDialogs.createConfirmButton(
      context,
      () => Navigator.pop(context),
      text: context.l10n.done,
    ),
  ],
);

String rtmpPublishKeyTypeLabel(
  BuildContext context,
  client_enum.PublishKeyType value,
) => switch (value) {
  client_enum.PublishKeyType.PUBLISH_KEY_TYPE_SINGLE_USE =>
    context.l10n.singleUsePublishKey,
  client_enum.PublishKeyType.PUBLISH_KEY_TYPE_EXPIRING =>
    context.l10n.expiringPublishKey,
  client_enum.PublishKeyType.PUBLISH_KEY_TYPE_PERMANENT =>
    context.l10n.permanentPublishKey,
  _ => context.l10n.publishKeyType,
};

String formatRtmpPublishTimestamp(int timestamp) {
  if (timestamp <= 0) return '-';
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')} '
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
}

class _RtmpInfoRow extends StatelessWidget {
  const _RtmpInfoRow({
    required this.label,
    required this.value,
    this.copyable = false,
  });

  final String label;
  final String value;
  final bool copyable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
          Expanded(child: AppSelectableText(value)),
          if (copyable)
            AppIconButton(
              icon: Icons.copy_rounded,
              iconSize: 18,
              size: AppIconButtonSize.sm,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                AppNotifications.showSuccess(context, context.l10n.copied);
              },
              tooltip: context.l10n.copy,
            ),
        ],
      ),
    );
  }
}
