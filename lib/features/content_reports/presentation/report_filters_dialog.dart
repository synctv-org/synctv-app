import 'package:flutter/material.dart';
import 'package:synctv_app/core/identifiers/decimal_int64.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';

class ContentReportFilters {
  const ContentReportFilters({
    this.reporterUserId = '',
    this.roomId = '',
    this.targetRoomId = '',
    this.targetUserId = '',
    this.targetMemberRoomId = '',
    this.targetMemberUserId = '',
    this.targetChatMessageId = '0',
  });

  final String reporterUserId;
  final String roomId;
  final String targetRoomId;
  final String targetUserId;
  final String targetMemberRoomId;
  final String targetMemberUserId;
  final String targetChatMessageId;
}

enum _FilterField {
  reporter,
  room,
  targetRoom,
  targetUser,
  memberRoom,
  member,
  message,
}

class ReportFiltersDialog extends StatefulWidget {
  const ReportFiltersDialog({
    super.key,
    required this.initialFilters,
    this.roomScoped = false,
    this.isSourceCurrent,
  });

  final ContentReportFilters initialFilters;
  final bool roomScoped;
  final bool Function()? isSourceCurrent;

  @override
  State<ReportFiltersDialog> createState() => _ReportFiltersDialogState();
}

class _ReportFiltersDialogState extends State<ReportFiltersDialog> {
  final _form = GlobalKey<FormState>();
  late final Map<_FilterField, TextEditingController> _controllers;
  bool _closing = false;

  bool get _active =>
      mounted &&
      !_closing &&
      (widget.isSourceCurrent?.call() ?? true) &&
      ModalRoute.of(context)?.isCurrent == true;

  List<_FilterField> get _fields => widget.roomScoped
      ? const [_FilterField.member, _FilterField.message]
      : _FilterField.values;

  @override
  void initState() {
    super.initState();
    final filters = widget.initialFilters;
    _controllers = {
      for (final entry in {
        _FilterField.reporter: filters.reporterUserId,
        _FilterField.room: filters.roomId,
        _FilterField.targetRoom: filters.targetRoomId,
        _FilterField.targetUser: filters.targetUserId,
        _FilterField.memberRoom: filters.targetMemberRoomId,
        _FilterField.member: filters.targetMemberUserId,
        _FilterField.message: filters.targetChatMessageId != '0'
            ? filters.targetChatMessageId
            : '',
      }.entries)
        entry.key: TextEditingController(text: entry.value),
    };
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _finish([ContentReportFilters? filters]) {
    if (!_active) return;
    _closing = true;
    Navigator.of(context).pop(filters);
  }

  void _apply() {
    if (!_active || !_form.currentState!.validate()) return;
    String text(_FilterField field) => _controllers[field]!.text.trim();
    _finish(
      ContentReportFilters(
        reporterUserId: text(_FilterField.reporter),
        roomId: text(_FilterField.room),
        targetRoomId: text(_FilterField.targetRoom),
        targetUserId: text(_FilterField.targetUser),
        targetMemberRoomId: text(_FilterField.memberRoom),
        targetMemberUserId: text(_FilterField.member),
        targetChatMessageId:
            normalizeInt64Decimal(text(_FilterField.message)) ?? '0',
      ),
    );
  }

  void _reset() {
    if (!_active) return;
    for (final field in _fields) {
      _controllers[field]!.clear();
    }
    _form.currentState!.validate();
  }

  String _label(_FilterField field) {
    final l10n = context.l10n;
    return switch (field) {
      _FilterField.reporter => l10n.reportFilterReporterId,
      _FilterField.room => l10n.reportFilterRoomId,
      _FilterField.targetRoom => l10n.reportFilterTargetRoomId,
      _FilterField.targetUser => l10n.reportFilterTargetUserId,
      _FilterField.memberRoom => l10n.reportFilterMemberRoomId,
      _FilterField.member => l10n.reportFilterMemberId,
      _FilterField.message => l10n.reportFilterMessageId,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppDialog(
      title: Row(
        children: [
          Expanded(child: Text(l10n.reportFilters)),
          AppIconButton(
            tooltip: l10n.close,
            icon: Icons.close_rounded,
            onPressed: _finish,
          ),
        ],
      ),
      icon: const Icon(Icons.filter_list_rounded),
      body: SizedBox(
        width: 520,
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final field in _fields)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppTextField(
                    controller: _controllers[field]!,
                    label: _label(field),
                    labelAbove: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    keyboardType: field == _FilterField.message
                        ? TextInputType.number
                        : TextInputType.text,
                    validator: field == _FilterField.message
                        ? (value) {
                            final text = value?.trim() ?? '';
                            if (text.isEmpty) return null;
                            return normalizeInt64Decimal(text) != null
                                ? null
                                : l10n.validMessageIdRequired;
                          }
                        : null,
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        AppActionButton(
          label: l10n.reset,
          wrapLabel: true,
          style: AppActionButtonStyle.text,
          onPressed: _reset,
        ),
        AppActionButton(
          label: l10n.cancel,
          wrapLabel: true,
          style: AppActionButtonStyle.outlined,
          onPressed: _finish,
        ),
        AppActionButton(label: l10n.apply, wrapLabel: true, onPressed: _apply),
      ],
    );
  }
}
