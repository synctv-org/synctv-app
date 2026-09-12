import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room/presentation/room_taxonomy.dart';
import 'package:synctv_app/l10n/l10n.dart';

Future<Set<String>?> showRoomLabelFilterDialog({
  required BuildContext context,
  required List<RoomLabelInfo> labels,
  required List<RoomCategoryInfo> categories,
  required Set<String> selectedIds,
  required bool hasCategory,
}) => showAppDialog<Set<String>>(
  context: context,
  builder: (_) => _RoomLabelFilterDialog(
    labels: labels,
    categories: categories,
    selectedIds: selectedIds,
    hasCategory: hasCategory,
  ),
);

class _RoomLabelFilterDialog extends StatefulWidget {
  const _RoomLabelFilterDialog({
    required this.labels,
    required this.categories,
    required this.selectedIds,
    required this.hasCategory,
  });

  final List<RoomLabelInfo> labels;
  final List<RoomCategoryInfo> categories;
  final Set<String> selectedIds;
  final bool hasCategory;

  @override
  State<_RoomLabelFilterDialog> createState() => _RoomLabelFilterDialogState();
}

class _RoomLabelFilterDialogState extends State<_RoomLabelFilterDialog> {
  late final Set<String> _selectedIds = widget.selectedIds.intersection(
    widget.labels.map((label) => label.id).toSet(),
  );
  bool _completed = false;
  late final _categoryNames = {
    for (final category in widget.categories)
      category.id: category.name.trim().isEmpty
          ? category.key
          : category.name.trim(),
  };

  bool get _current =>
      mounted && !_completed && ModalRoute.of(context)?.isCurrent == true;

  void _finish(Set<String>? result) {
    if (!_current) return;
    _completed = true;
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) => AppDialog(
    constraints: const BoxConstraints(maxWidth: 520),
    title: Text(
      context.l10n.filterLabels,
      style: Theme.of(context).textTheme.titleMedium,
    ),
    icon: const Icon(Icons.sell_outlined),
    body: widget.labels.isEmpty
        ? Text(
            widget.hasCategory
                ? context.l10n.noLabelsForCategory
                : context.l10n.noLabelsAvailable,
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final label in widget.labels)
                AppCheckboxTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  value: _selectedIds.contains(label.id),
                  title: Text(
                    label.name.trim().isEmpty ? label.key : label.name.trim(),
                  ),
                  subtitle: widget.hasCategory
                      ? null
                      : Text(
                          _categoryNames[label.categoryId] ??
                              (label.categoryId.isEmpty
                                  ? context.l10n.noCategory
                                  : context.l10n.unknownCategory),
                        ),
                  prefix: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: parseRoomLabelColor(
                        label.color,
                        Theme.of(context).colorScheme.primary,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  onChanged: (selected) {
                    if (!_current) return;
                    setState(() {
                      if (selected) {
                        _selectedIds.add(label.id);
                      } else {
                        _selectedIds.remove(label.id);
                      }
                    });
                  },
                ),
            ],
          ),
    actions: [
      AppActionButton(
        label: context.l10n.cancel,
        wrapLabel: true,
        style: AppActionButtonStyle.outlined,
        onPressed: () => _finish(null),
      ),
      AppActionButton(
        label: context.l10n.clear,
        wrapLabel: true,
        icon: Icons.filter_alt_off_rounded,
        style: AppActionButtonStyle.tonal,
        onPressed: () => _finish(<String>{}),
      ),
      AppActionButton(
        label: context.l10n.apply,
        wrapLabel: true,
        onPressed: () => _finish(Set<String>.of(_selectedIds)),
      ),
    ],
  );
}
