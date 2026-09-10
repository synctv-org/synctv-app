import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/admin_models.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/content_reports/application/content_reports_gateway.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/admin.pbenum.dart' as admin_enum;

class ReportDispositionDialog extends StatefulWidget {
  const ReportDispositionDialog({
    super.key,
    required this.gateway,
    required this.report,
    required this.targetText,
    required this.roomScopeId,
    this.isSourceCurrent,
  });

  final ContentReportsGateway gateway;
  final AdminContentReport report;
  final String targetText;
  final String roomScopeId;
  final bool Function()? isSourceCurrent;

  @override
  State<ReportDispositionDialog> createState() =>
      _ReportDispositionDialogState();
}

class _ReportDispositionDialogState extends State<ReportDispositionDialog> {
  late final _note = TextEditingController(text: widget.report.resolutionNote);
  late var _status =
      widget.report.status ==
          admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_OPEN
      ? admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_REVIEWING
      : widget.report.status;
  bool _saving = false;
  bool _closing = false;

  bool get _active =>
      mounted &&
      !_closing &&
      (widget.isSourceCurrent?.call() ?? true) &&
      ModalRoute.of(context)?.isCurrent == true;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  void _finish([AdminContentReport? result]) {
    if (!_active) return;
    _closing = true;
    Navigator.of(context).pop(result);
  }

  Future<void> _save() async {
    if (!_active || _saving) return;
    setState(() => _saving = true);
    try {
      final result = await widget.gateway.updateStatus(
        reportId: widget.report.id,
        status: _status,
        resolutionNote: _note.text,
        roomScopeId: widget.roomScopeId,
      );
      _finish(result);
    } catch (error) {
      if (mounted && _active) {
        AppNotifications.showError(
          context,
          context.l10n.resolveReportFailed('$error'),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppDialog(
      title: Row(
        children: [
          Expanded(child: Text(l10n.resolveReport)),
          AppIconButton(
            tooltip: l10n.close,
            icon: Icons.close_rounded,
            onPressed: _finish,
          ),
        ],
      ),
      icon: const Icon(Icons.rule_rounded),
      body: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.targetText),
            const SizedBox(height: 12),
            AppSelect<admin_enum.ContentReportStatus>(
              value: _status,
              wrapText: true,
              options: {
                l10n.reviewing: admin_enum
                    .ContentReportStatus
                    .CONTENT_REPORT_STATUS_REVIEWING,
                l10n.resolved: admin_enum
                    .ContentReportStatus
                    .CONTENT_REPORT_STATUS_RESOLVED,
                l10n.dismissed: admin_enum
                    .ContentReportStatus
                    .CONTENT_REPORT_STATUS_DISMISSED,
                l10n.reportOpenStatus:
                    admin_enum.ContentReportStatus.CONTENT_REPORT_STATUS_OPEN,
              },
              onChanged: _saving
                  ? null
                  : (value) {
                      if (value != null) setState(() => _status = value);
                    },
            ),
            const SizedBox(height: 12),
            AppTextField(
              controller: _note,
              label: l10n.resolutionNote,
              labelAbove: true,
              enabled: !_saving,
              maxLines: 4,
            ),
          ],
        ),
      ),
      actions: [
        AppActionButton(
          label: l10n.cancel,
          wrapLabel: true,
          style: AppActionButtonStyle.outlined,
          onPressed: _finish,
        ),
        AppActionButton(
          label: l10n.save,
          wrapLabel: true,
          loading: _saving,
          onPressed: _saving ? null : _save,
        ),
      ],
    );
  }
}
