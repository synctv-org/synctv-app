part of '../admin_settings_page.dart';

class AdminRoomTaxonomyTab extends StatefulWidget {
  const AdminRoomTaxonomyTab({super.key});

  @override
  State<AdminRoomTaxonomyTab> createState() => _AdminRoomTaxonomyTabState();
}

class _AdminRoomTaxonomyTabState extends State<AdminRoomTaxonomyTab> {
  bool _isLoading = true;
  List<RoomCategoryInfo> _categories = const [];
  List<RoomLabelInfo> _labels = const [];

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _load();
    });
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        adminGateway.adminListRoomCategories(
          includeDisabled: true,
          refresh: true,
        ),
        adminGateway.adminListRoomLabels(includeDisabled: true, refresh: true),
      ]);
      if (!mounted) return;
      final categories = results[0].cast<RoomCategoryInfo>().toList()
        ..sort(_compareCategories);
      final labels = results[1].cast<RoomLabelInfo>().toList()
        ..sort(_compareLabels);
      setState(() {
        _categories = categories;
        _labels = labels;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      AppNotifications.showError(
        context,
        context.l10n.loadCategoriesLabelsFailed('$e'),
      );
    }
  }

  int _compareCategories(RoomCategoryInfo a, RoomCategoryInfo b) {
    final order = a.sortOrder.compareTo(b.sortOrder);
    if (order != 0) return order;
    return _categoryDisplay(a).compareTo(_categoryDisplay(b));
  }

  int _compareLabels(RoomLabelInfo a, RoomLabelInfo b) {
    final category = _categoryDisplayById(a.categoryId)
        .compareTo(_categoryDisplayById(b.categoryId));
    if (category != 0) return category;
    final order = a.sortOrder.compareTo(b.sortOrder);
    if (order != 0) return order;
    return _labelDisplay(a).compareTo(_labelDisplay(b));
  }

  String _categoryDisplay(RoomCategoryInfo category) {
    final name = category.name.trim();
    return name.isEmpty ? category.key : name;
  }

  String _labelDisplay(RoomLabelInfo label) {
    final name = label.name.trim();
    return name.isEmpty ? label.key : name;
  }

  String _categoryDisplayById(String categoryId) {
    if (categoryId.isEmpty) return context.l10n.categoryNotBound;
    for (final category in _categories) {
      if (category.id == categoryId) return _categoryDisplay(category);
    }
    return context.l10n.unknownCategory;
  }

  String _normalizeColor(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '';
    var hex = trimmed.startsWith('#') ? trimmed.substring(1) : trimmed;
    hex = hex.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');
    if (hex.length == 3) {
      hex = hex.split('').map((part) => '$part$part').join();
    }
    if (hex.length != 6) return trimmed;
    return '#${hex.toUpperCase()}';
  }

  Future<void> _editCategory([RoomCategoryInfo? category]) async {
    final keyController = TextEditingController(text: category?.key ?? '');
    final nameController = TextEditingController(text: category?.name ?? '');
    final descriptionController = TextEditingController(
      text: category?.description ?? '',
    );
    final sortController = TextEditingController(
      text: '${category?.sortOrder ?? 0}',
    );
    var enabled = category?.isEnabled ?? true;
    var disposeScheduled = false;
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: category == null
          ? context.l10n.addCategory
          : context.l10n.editCategory,
      icon: const Icon(Icons.category_rounded, color: Color(0xFF5D5FEF)),
      content: StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          if (!disposeScheduled) {
            disposeScheduled = true;
            _disposeControllersAfterRouteClose(dialogContext, [
              keyController,
              nameController,
              descriptionController,
              sortController,
            ]);
          }
          return SizedBox(
            width: 520,
            child: AppSingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppDialogs.createFormField(
                    context: dialogContext,
                    label: context.l10n.identifier,
                    controller: keyController,
                    hintText: context.l10n.categoryIdentifierExample,
                    prefixIcon: Icons.key_rounded,
                  ),
                  const SizedBox(height: 12),
                  AppDialogs.createFormField(
                    context: dialogContext,
                    label: context.l10n.name,
                    controller: nameController,
                    hintText: context.l10n.categoryNameExample,
                    prefixIcon: Icons.drive_file_rename_outline_rounded,
                  ),
                  const SizedBox(height: 12),
                  AppDialogs.createFormField(
                    context: dialogContext,
                    label: context.l10n.description,
                    controller: descriptionController,
                    hintText: context.l10n.optional,
                    prefixIcon: Icons.notes_rounded,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  AppDialogs.createFormField(
                    context: dialogContext,
                    label: context.l10n.sort,
                    controller: sortController,
                    hintText: context.l10n.lowerNumberFirst,
                    prefixIcon: Icons.sort_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  AppSwitchTile(
                    value: enabled,
                    onChanged: (value) => setDialogState(() => enabled = value),
                    title: Text(context.l10n.enableCategory),
                    prefix: const Icon(Icons.toggle_on_outlined),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.save,
        ),
      ],
    );
    if (confirmed != true) return;

    final key = keyController.text.trim();
    final name = nameController.text.trim();
    final sortOrder = int.tryParse(sortController.text.trim());
    if (key.isEmpty || name.isEmpty) {
      if (!mounted) return;
      AppNotifications.showWarning(
        context,
        context.l10n.categoryIdAndNameRequired,
      );
      return;
    }
    if (sortOrder == null) {
      if (!mounted) return;
      AppNotifications.showWarning(context, context.l10n.sortMustBeInteger);
      return;
    }

    try {
      await adminGateway.adminUpsertRoomCategory(
        key: key,
        name: name,
        description: descriptionController.text.trim(),
        sortOrder: sortOrder,
        isEnabled: enabled,
      );
      if (!mounted) return;
      AppNotifications.showSuccess(context, context.l10n.categorySaved);
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(
        context,
        context.l10n.saveCategoryFailed('$e'),
      );
    }
  }

  Future<void> _deleteCategory(RoomCategoryInfo category) async {
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.deleteCategory,
      icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
      content: _destructiveDialogContent(
        context.l10n.permanentlyDeleteCategory(_categoryDisplay(category)),
        [context.l10n.roomsLoseCategory, context.l10n.categoryChangesImmediate],
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.delete,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      await adminGateway.adminDeleteRoomCategory(category.id);
      if (!mounted) return;
      AppNotifications.showSuccess(context, context.l10n.categoryDeleted);
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(
        context,
        context.l10n.deleteCategoryFailed('$e'),
      );
    }
  }

  Future<void> _editLabel([RoomLabelInfo? label]) async {
    final keyController = TextEditingController(text: label?.key ?? '');
    final nameController = TextEditingController(text: label?.name ?? '');
    final descriptionController = TextEditingController(
      text: label?.description ?? '',
    );
    final colorController = TextEditingController(
      text: _normalizeColor(label?.color ?? ''),
    );
    final sortController = TextEditingController(
      text: '${label?.sortOrder ?? 0}',
    );
    var categoryId = label?.categoryId ?? '';
    var enabled = label?.isEnabled ?? true;
    var disposeScheduled = false;
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: label == null ? context.l10n.addLabel : context.l10n.editLabel,
      icon: const Icon(Icons.sell_rounded, color: Color(0xFF5D5FEF)),
      content: StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          if (!disposeScheduled) {
            disposeScheduled = true;
            _disposeControllersAfterRouteClose(dialogContext, [
              keyController,
              nameController,
              descriptionController,
              colorController,
              sortController,
            ]);
          }
          final previewColor = parseRoomLabelColor(
            colorController.text,
            Theme.of(dialogContext).colorScheme.primary,
          );
          return SizedBox(
            width: 520,
            child: AppSingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppDialogs.createFormField(
                    context: dialogContext,
                    label: context.l10n.identifier,
                    controller: keyController,
                    hintText: context.l10n.labelIdentifierExample,
                    prefixIcon: Icons.key_rounded,
                  ),
                  const SizedBox(height: 12),
                  AppDialogs.createFormField(
                    context: dialogContext,
                    label: context.l10n.name,
                    controller: nameController,
                    hintText: context.l10n.labelNameExample,
                    prefixIcon: Icons.drive_file_rename_outline_rounded,
                  ),
                  const SizedBox(height: 12),
                  AppSelect<String?>(
                    value: categoryId.isEmpty ? null : categoryId,
                    label: context.l10n.parentCategory,
                    hintText: context.l10n.noCategoryBinding,
                    prefixIcon: Icons.category_outlined,
                    clearable: true,
                    options: {
                      context.l10n.noCategoryBinding: null,
                      for (final category in _categories)
                        _categoryDisplay(category): category.id,
                    },
                    onChanged: (value) =>
                        setDialogState(() => categoryId = value ?? ''),
                  ),
                  const SizedBox(height: 12),
                  AppDialogs.createFormField(
                    context: dialogContext,
                    label: context.l10n.color,
                    controller: colorController,
                    hintText: '#5D5FEF',
                    prefixIcon: Icons.palette_outlined,
                    suffix: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: previewColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppDialogs.createFormField(
                    context: dialogContext,
                    label: context.l10n.description,
                    controller: descriptionController,
                    hintText: context.l10n.optional,
                    prefixIcon: Icons.notes_rounded,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  AppDialogs.createFormField(
                    context: dialogContext,
                    label: context.l10n.sort,
                    controller: sortController,
                    hintText: context.l10n.lowerNumberFirst,
                    prefixIcon: Icons.sort_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 8),
                  AppSwitchTile(
                    value: enabled,
                    onChanged: (value) => setDialogState(() => enabled = value),
                    title: Text(context.l10n.enableLabel),
                    prefix: const Icon(Icons.toggle_on_outlined),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.save,
        ),
      ],
    );
    if (confirmed != true) return;

    final key = keyController.text.trim();
    final name = nameController.text.trim();
    final sortOrder = int.tryParse(sortController.text.trim());
    final color = _normalizeColor(colorController.text);
    if (key.isEmpty || name.isEmpty) {
      if (!mounted) return;
      AppNotifications.showWarning(
        context,
        context.l10n.labelIdAndNameRequired,
      );
      return;
    }
    if (sortOrder == null) {
      if (!mounted) return;
      AppNotifications.showWarning(context, context.l10n.sortMustBeInteger);
      return;
    }
    if (color.isNotEmpty &&
        !RegExp(r'^#[0-9A-F]{6}$').hasMatch(color.toUpperCase())) {
      if (!mounted) return;
      AppNotifications.showWarning(context, context.l10n.colorFormatExample);
      return;
    }

    try {
      await adminGateway.adminUpsertRoomLabel(
        key: key,
        name: name,
        description: descriptionController.text.trim(),
        color: color,
        categoryId: categoryId,
        sortOrder: sortOrder,
        isEnabled: enabled,
      );
      if (!mounted) return;
      AppNotifications.showSuccess(context, context.l10n.labelSaved);
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, context.l10n.saveLabelFailed('$e'));
    }
  }

  Future<void> _deleteLabel(RoomLabelInfo label) async {
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.deleteLabel,
      icon: const Icon(Icons.delete_forever_rounded, color: Colors.red),
      content: _destructiveDialogContent(
        context.l10n.permanentlyDeleteLabel(_labelDisplay(label)),
        [context.l10n.roomsLoseLabel, context.l10n.labelChangesImmediate],
      ),
      actions: [
        AppDialogs.createCancelButton(context),
        const SizedBox(width: 8),
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context, true),
          text: context.l10n.delete,
        ),
      ],
    );
    if (confirmed != true) return;
    try {
      await adminGateway.adminDeleteRoomLabel(label.id);
      if (!mounted) return;
      AppNotifications.showSuccess(context, context.l10n.labelDeleted);
      _load(silent: true);
    } catch (e) {
      if (!mounted) return;
      AppNotifications.showError(context, context.l10n.deleteLabelFailed('$e'));
    }
  }

  Widget _destructiveDialogContent(String title, List<String> impacts) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...impacts.map(
          (impact) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 16,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(impact)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppSingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AdminToolbarWrap(
            items: [
              _AdminToolbarItem(
                width: 150,
                child: AppActionButton(
                  onPressed: () => _editCategory(),
                  icon: Icons.add_rounded,
                  label: context.l10n.addCategory,
                ),
              ),
              _AdminToolbarItem(
                width: 150,
                child: AppActionButton(
                  onPressed: () => _editLabel(),
                  icon: Icons.add_rounded,
                  label: context.l10n.addLabel,
                  style: AppActionButtonStyle.tonal,
                ),
              ),
              _AdminToolbarItem(
                width: 112,
                child: AppActionButton(
                  onPressed: () => _load(),
                  icon: Icons.refresh_rounded,
                  label: context.l10n.refresh,
                  style: AppActionButtonStyle.outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const AppLoadingIndicator(padding: EdgeInsets.all(32))
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 900;
                final panels = [
                  _buildCategoryPanel(theme),
                  _buildLabelPanel(theme),
                ];
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: panels[0]),
                      const SizedBox(width: 16),
                      Expanded(child: panels[1]),
                    ],
                  );
                }
                return Column(
                  children: [panels[0], const SizedBox(height: 16), panels[1]],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryPanel(ThemeData theme) {
    return AppPanelSurface(
      padding: const EdgeInsets.all(16),
      border: Border.all(color: theme.colorScheme.outlineVariant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TaxonomyPanelHeader(
            icon: Icons.category_rounded,
            title: context.l10n.roomCategories,
            count: _categories.length,
          ),
          const SizedBox(height: 12),
          if (_categories.isEmpty)
            AppEmptyState(
              icon: Icons.category_outlined,
              title: context.l10n.noCategories,
              subtitle: context.l10n.addCategoriesDescription,
            )
          else
            ..._categories.map(
              (category) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _CategoryCard(
                  category: category,
                  onEdit: () => _editCategory(category),
                  onDelete: () => _deleteCategory(category),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLabelPanel(ThemeData theme) {
    return AppPanelSurface(
      padding: const EdgeInsets.all(16),
      border: Border.all(color: theme.colorScheme.outlineVariant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TaxonomyPanelHeader(
            icon: Icons.sell_rounded,
            title: context.l10n.roomLabels,
            count: _labels.length,
          ),
          const SizedBox(height: 12),
          if (_labels.isEmpty)
            AppEmptyState(
              icon: Icons.sell_outlined,
              title: context.l10n.noLabelsAvailable,
              subtitle: context.l10n.addLabelsDescription,
            )
          else
            ..._labels.map(
              (label) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _LabelCard(
                  label: label,
                  categoryName: _categoryDisplayById(label.categoryId),
                  onEdit: () => _editLabel(label),
                  onDelete: () => _deleteLabel(label),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TaxonomyPanelHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;

  const _TaxonomyPanelHeader({
    required this.icon,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        AppChip(label: Text('$count'), style: AppChipStyle.outlined),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final RoomCategoryInfo category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryCard({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  String get _displayName {
    final name = category.name.trim();
    return name.isEmpty ? category.key : name;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      padding: const EdgeInsets.all(12),
      color: theme.colorScheme.surfaceContainerLowest,
      border: Border.all(color: theme.colorScheme.outlineVariant),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            category.isEnabled
                ? Icons.category_rounded
                : Icons.category_outlined,
            color: category.isEnabled
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    AppChip(
                      label: Text(
                        category.isEnabled
                            ? context.l10n.enabled
                            : context.l10n.disabled,
                      ),
                      style: category.isEnabled
                          ? AppChipStyle.filled
                          : AppChipStyle.outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _TaxonomyMetaChip(
                      icon: Icons.key_rounded,
                      label: category.key,
                    ),
                    _TaxonomyMetaChip(
                      icon: Icons.sort_rounded,
                      label: '${category.sortOrder}',
                    ),
                  ],
                ),
                if (category.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    category.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIconButton(
                onPressed: onEdit,
                icon: Icons.edit_outlined,
                tooltip: context.l10n.editCategory,
                style: AppIconButtonStyle.tonal,
                size: AppIconButtonSize.sm,
              ),
              const SizedBox(height: 6),
              AppIconButton(
                onPressed: onDelete,
                icon: Icons.delete_outline_rounded,
                tooltip: context.l10n.deleteCategory,
                style: AppIconButtonStyle.destructive,
                size: AppIconButtonSize.sm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LabelCard extends StatelessWidget {
  final RoomLabelInfo label;
  final String categoryName;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _LabelCard({
    required this.label,
    required this.categoryName,
    required this.onEdit,
    required this.onDelete,
  });

  String get _displayName {
    final name = label.name.trim();
    return name.isEmpty ? label.key : name;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = parseRoomLabelColor(label.color, theme.colorScheme.primary);
    return AppPanelSurface(
      padding: const EdgeInsets.all(12),
      color: theme.colorScheme.surfaceContainerLowest,
      border: Border.all(color: theme.colorScheme.outlineVariant),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 18,
            height: 18,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    AppChip(
                      label: Text(
                        label.isEnabled
                            ? context.l10n.enabled
                            : context.l10n.disabled,
                      ),
                      style: label.isEnabled
                          ? AppChipStyle.filled
                          : AppChipStyle.outlined,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _TaxonomyMetaChip(
                      icon: Icons.key_rounded,
                      label: label.key,
                    ),
                    _TaxonomyMetaChip(
                      icon: Icons.category_outlined,
                      label: categoryName,
                    ),
                    _TaxonomyMetaChip(
                      icon: Icons.palette_outlined,
                      label: label.color.trim().isEmpty
                          ? context.l10n.defaultColor
                          : label.color.trim(),
                    ),
                    _TaxonomyMetaChip(
                      icon: Icons.sort_rounded,
                      label: '${label.sortOrder}',
                    ),
                  ],
                ),
                if (label.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    label.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIconButton(
                onPressed: onEdit,
                icon: Icons.edit_outlined,
                tooltip: context.l10n.editLabel,
                style: AppIconButtonStyle.tonal,
                size: AppIconButtonSize.sm,
              ),
              const SizedBox(height: 6),
              AppIconButton(
                onPressed: onDelete,
                icon: Icons.delete_outline_rounded,
                tooltip: context.l10n.deleteLabel,
                style: AppIconButtonStyle.destructive,
                size: AppIconButtonSize.sm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaxonomyMetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TaxonomyMetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppChip(
      style: AppChipStyle.outlined,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
