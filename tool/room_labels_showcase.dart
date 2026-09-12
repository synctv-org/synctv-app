import 'package:flutter/material.dart';
import 'package:synctv_app/app/app_viewport.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/home/presentation/room_label_filter_dialog.dart';
import 'package:synctv_app/features/home/presentation/room_delete_confirmation_dialog.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() => runApp(
  MaterialApp(
    theme: AppTheme.light,
    locale: Locale(Uri.base.queryParameters['locale'] == 'zh' ? 'zh' : 'en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(3)),
      child: AppViewport(child: child!),
    ),
    home: const _LabelsPreview(),
  ),
);

class _LabelsPreview extends StatefulWidget {
  const _LabelsPreview();

  @override
  State<_LabelsPreview> createState() => _LabelsPreviewState();
}

class _LabelsPreviewState extends State<_LabelsPreview> {
  Set<String> _selected = {'one'};
  bool _deleted = false;
  bool get _deleteMode => Uri.base.queryParameters['mode'] == 'delete';

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: AppActionButton(
        label: _deleteMode
            ? (_deleted ? context.l10n.roomDeleted : context.l10n.deleteRoom)
            : '${context.l10n.filterLabels} (${_selected.length})',
        icon: _deleteMode ? Icons.delete_outline : Icons.sell_outlined,
        wrapLabel: true,
        onPressed: () async {
          if (_deleteMode) {
            final confirmed = await showRoomDeleteConfirmationDialog(
              context: context,
              roomName:
                  'International cinema and documentary discussion screenings',
            );
            if (mounted && confirmed == true) setState(() => _deleted = true);
            return;
          }
          final result = await showRoomLabelFilterDialog(
            context: context,
            categories: const [
              RoomCategoryInfo(
                id: 'film',
                key: 'film',
                name: 'Film & TV',
                description: '',
                sortOrder: 0,
                isEnabled: true,
              ),
              RoomCategoryInfo(
                id: 'music',
                key: 'music',
                name: 'Music & Live',
                description: '',
                sortOrder: 1,
                isEnabled: true,
              ),
            ],
            labels: const [
              RoomLabelInfo(
                id: 'one',
                key: 'weekend',
                name: 'Weekend',
                description: '',
                color: '#26795e',
                categoryId: 'film',
                sortOrder: 0,
                isEnabled: true,
              ),
              RoomLabelInfo(
                id: 'two',
                key: 'international',
                name: 'International screenings and discussions with a very long film label',
                description: '',
                color: '#c14666',
                categoryId: 'film',
                sortOrder: 1,
                isEnabled: true,
              ),
              RoomLabelInfo(
                id: 'three',
                key: 'weekend-music',
                name: 'Weekend',
                description: '',
                color: '#26795e',
                categoryId: 'music',
                sortOrder: 2,
                isEnabled: true,
              ),
            ],
            selectedIds: _selected,
            hasCategory: false,
          );
          if (mounted && result != null) setState(() => _selected = result);
        },
      ),
    ),
  );
}
