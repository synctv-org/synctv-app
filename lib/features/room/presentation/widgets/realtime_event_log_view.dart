import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/room/domain/realtime_event_log.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/room/application/realtime_event_log_preferences_controller.dart';
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

enum _RealtimeEventLogMenuAction { toggleGrouping, copy, clear }

class RealtimeEventLogView extends StatefulWidget {
  final List<RealtimeEventLogEntry> events;
  final VoidCallback? onClear;
  final EdgeInsetsGeometry padding;
  final String? emptyText;
  final ValueChanged<int>? onMaxEntriesChanged;

  const RealtimeEventLogView({
    super.key,
    required this.events,
    this.onClear,
    this.padding = const EdgeInsets.all(12),
    this.emptyText,
    this.onMaxEntriesChanged,
  });

  @override
  State<RealtimeEventLogView> createState() => _RealtimeEventLogViewState();
}

class _RealtimeEventLogViewState extends State<RealtimeEventLogView> {
  final Set<String> _hiddenGroupKeys = {};
  RealtimeEventLogPreferencesController get _preferences =>
      DependencyScope.read<RealtimeEventLogPreferencesController>(context);

  List<RealtimeEventLogEntry> get events => widget.events;
  VoidCallback? get onClear => widget.onClear;
  EdgeInsetsGeometry get padding => widget.padding;
  String get emptyText => widget.emptyText ?? context.l10n.noRealtimeEvents;
  ValueChanged<int>? get onMaxEntriesChanged => widget.onMaxEntriesChanged;

  @override
  void didUpdateWidget(covariant RealtimeEventLogView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final availableKeys = widget.events.map((event) => event.groupKey).toSet();
    _hiddenGroupKeys.removeWhere((key) => !availableKeys.contains(key));
  }

  Future<void> _copy(BuildContext context) async {
    final text = const JsonEncoder.withIndent('  ')
        .convert(events.map((event) => event.toJson()).toList(growable: false));
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      AppNotifications.showSuccess(context, context.l10n.realtimeEventsCopied);
    }
  }

  Future<void> _changeMaxEntries(BuildContext context, int value) async {
    var nextValue = value;
    if (value == -1) {
      final controller = TextEditingController(
        text: _preferences.maxEntries.value.toString(),
      );
      nextValue =
          await showAppDialog<int>(
            context: context,
            builder: (dialogContext) {
              return AppDialog(
                title: Text(context.l10n.retentionCount),
                body: AppTextField(
                  controller: controller,
                  label: context.l10n.recentEventCount,
                  helperText: context.l10n.eventCountRange,
                  prefixIcon: Icons.format_list_numbered_rounded,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    final parsed = int.tryParse(controller.text.trim());
                    if (parsed == null) return;
                    Navigator.pop(dialogContext, parsed);
                  },
                ),
                actions: [
                  AppActionButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    label: context.l10n.cancel,
                    style: AppActionButtonStyle.outlined,
                  ),
                  AppActionButton(
                    onPressed: () {
                      final parsed = int.tryParse(controller.text.trim());
                      if (parsed == null) return;
                      Navigator.pop(dialogContext, parsed);
                    },
                    label: context.l10n.save,
                  ),
                ],
              );
            },
          ) ??
          _preferences.maxEntries.value;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.dispose();
      });
    }

    await _preferences.setMaxEntries(nextValue);
    onMaxEntriesChanged?.call(nextValue);
  }

  Future<void> _handleOverflowAction(
    BuildContext context,
    _RealtimeEventLogMenuAction action,
    bool grouped,
  ) async {
    switch (action) {
      case _RealtimeEventLogMenuAction.toggleGrouping:
        await _preferences.setGrouped(!grouped);
      case _RealtimeEventLogMenuAction.copy:
        await _copy(context);
      case _RealtimeEventLogMenuAction.clear:
        onClear?.call();
    }
  }

  AppPopupMenuButton<int> _buildMaxEntriesMenu(
    BuildContext context,
    int maxEntries, {
    bool showLabel = false,
  }) {
    return AppPopupMenuButton<int>(
      tooltip: context.l10n.retentionCount,
      icon: showLabel ? null : const Icon(Icons.storage_rounded),
      initialValue: maxEntries,
      onSelected: (value) => _changeMaxEntries(context, value),
      itemBuilder: (context) => [
        PopupMenuItem(value: 50, child: Text(context.l10n.retainEvents(50))),
        PopupMenuItem(value: 100, child: Text(context.l10n.retainEvents(100))),
        PopupMenuItem(value: 200, child: Text(context.l10n.retainEvents(200))),
        PopupMenuItem(value: 500, child: Text(context.l10n.retainEvents(500))),
        PopupMenuItem(
          value: 1000,
          child: Text(context.l10n.retainEvents(1000)),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(value: -1, child: Text(context.l10n.customValue)),
      ],
      child: showLabel
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.storage_rounded, size: 18),
                  const SizedBox(width: 6),
                  Text(context.l10n.retainEvents(maxEntries)),
                  const SizedBox(width: 2),
                  const Icon(Icons.arrow_drop_down_rounded, size: 18),
                ],
              ),
            )
          : null,
    );
  }

  AppIconButton _buildGroupingButton(bool grouped) {
    return AppIconButton(
      tooltip: grouped
          ? context.l10n.viewChronologically
          : context.l10n.groupByType,
      selectedIcon: Icons.view_agenda_rounded,
      selected: grouped,
      onPressed: () => _preferences.setGrouped(!grouped),
      icon: Icons.account_tree_rounded,
    );
  }

  Widget _buildOverflowMenu(
    BuildContext context,
    bool grouped, {
    required bool includeGrouping,
    required bool includeLimit,
    required bool includeCopy,
    required bool includeClear,
  }) {
    return AppMenuAnchor(
      menuChildren: [
        if (includeGrouping)
          MenuItemButton(
            onPressed: () {
              _handleOverflowAction(
                context,
                _RealtimeEventLogMenuAction.toggleGrouping,
                grouped,
              );
            },
            child: Text(
              grouped
                  ? context.l10n.viewChronologically
                  : context.l10n.groupByType,
            ),
          ),
        if (includeLimit)
          SubmenuButton(
            menuChildren: [
              MenuItemButton(
                onPressed: () => _changeMaxEntries(context, 50),
                child: Text(context.l10n.eventCount(50)),
              ),
              MenuItemButton(
                onPressed: () => _changeMaxEntries(context, 100),
                child: Text(context.l10n.eventCount(100)),
              ),
              MenuItemButton(
                onPressed: () => _changeMaxEntries(context, 200),
                child: Text(context.l10n.eventCount(200)),
              ),
              MenuItemButton(
                onPressed: () => _changeMaxEntries(context, 500),
                child: Text(context.l10n.eventCount(500)),
              ),
              MenuItemButton(
                onPressed: () => _changeMaxEntries(context, 1000),
                child: Text(context.l10n.eventCount(1000)),
              ),
              MenuItemButton(
                onPressed: () => _changeMaxEntries(context, -1),
                child: Text(context.l10n.customValue),
              ),
            ],
            child: Text(context.l10n.retentionCount),
          ),
        if (includeCopy)
          MenuItemButton(
            onPressed: events.isEmpty
                ? null
                : () {
                    _handleOverflowAction(
                      context,
                      _RealtimeEventLogMenuAction.copy,
                      grouped,
                    );
                  },
            child: Text(context.l10n.copyEvents),
          ),
        if (includeClear)
          MenuItemButton(
            onPressed: events.isEmpty || onClear == null
                ? null
                : () {
                    _handleOverflowAction(
                      context,
                      _RealtimeEventLogMenuAction.clear,
                      grouped,
                    );
                  },
            child: Text(context.l10n.clearEvents),
          ),
      ],
      builder: (context, controller, child) {
        return AppIconButton(
          tooltip: context.l10n.moreActions,
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: Icons.more_horiz_rounded,
        );
      },
    );
  }

  List<RealtimeEventLogEntry> _filteredEvents() {
    if (_hiddenGroupKeys.isEmpty) return events;
    return events
        .where((event) => !_hiddenGroupKeys.contains(event.groupKey))
        .toList(growable: false);
  }

  List<_RealtimeEventFilterOption> _buildFilterOptions() {
    final options = <String, _RealtimeEventFilterOption>{};
    for (final event in events) {
      final existing = options[event.groupKey];
      if (existing == null) {
        options[event.groupKey] = _RealtimeEventFilterOption(
          key: event.groupKey,
          direction: event.direction,
          label: event.label,
          count: 1,
          latest: event.timestamp,
        );
      } else {
        existing.count += 1;
        if (event.timestamp.isAfter(existing.latest)) {
          existing.latest = event.timestamp;
        }
      }
    }
    return options.values.toList(growable: false)..sort((a, b) {
      final labelCompare = a.label.compareTo(b.label);
      if (labelCompare != 0) return labelCompare;
      return a.direction.compareTo(b.direction);
    });
  }

  AppIconButton _buildFilterButton(
    BuildContext context,
    List<_RealtimeEventFilterOption> options,
  ) {
    final active = _hiddenGroupKeys.isNotEmpty;
    return AppIconButton(
      tooltip: context.l10n.filterEventTypes,
      selected: active,
      selectedIcon: Icons.filter_alt_rounded,
      icon: Icons.filter_alt_outlined,
      style: active ? AppIconButtonStyle.tonal : AppIconButtonStyle.ghost,
      onPressed: options.isEmpty
          ? null
          : () => _showFilterSheet(context, options),
    );
  }

  Future<void> _showFilterSheet(
    BuildContext context,
    List<_RealtimeEventFilterOption> options,
  ) async {
    final optionKeys = options.map((option) => option.key).toSet();
    var draftHidden = _hiddenGroupKeys
        .where((key) => optionKeys.contains(key))
        .toSet();
    final nextHidden = await showAppBottomSheet<Set<String>>(
      context: context,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final selectedCount = options.length - draftHidden.length;
            final allSelected = draftHidden.isEmpty;
            return AppBottomSheetFrame(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: AppMetrics.dialogMaxHeight(context, null),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 12, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  context.l10n.eventTypeFilter,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  context.l10n.selectionCount(
                                    selectedCount,
                                    options.length,
                                  ),
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AppActionButton(
                            onPressed: () => setSheetState(() {
                              draftHidden = <String>{};
                            }),
                            label: context.l10n.selectAll,
                            style: AppActionButtonStyle.text,
                          ),
                        ],
                      ),
                    ),
                    AppCheckboxTile(
                      value: allSelected,
                      onChanged: (value) => setSheetState(() {
                        draftHidden = value ? <String>{} : Set.of(optionKeys);
                      }),
                      title: Text(context.l10n.allTypes),
                      subtitle: Text(context.l10n.eventCount(events.length)),
                    ),
                    const AppDivider(height: 1),
                    Flexible(
                      child: AppListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options[index];
                          final selected = !draftHidden.contains(option.key);
                          return AppCheckboxTile(
                            value: selected,
                            onChanged: (value) => setSheetState(() {
                              if (value) {
                                draftHidden.remove(option.key);
                              } else {
                                draftHidden.add(option.key);
                              }
                            }),
                            suffix: _DirectionPill(direction: option.direction),
                            title: Text(
                              option.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              context.l10n.itemCount(option.count),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AppActionButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            label: context.l10n.cancel,
                            style: AppActionButtonStyle.text,
                          ),
                          const SizedBox(width: 8),
                          AppActionButton(
                            onPressed: () =>
                                Navigator.pop(sheetContext, draftHidden),
                            label: context.l10n.apply,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    if (nextHidden == null || !mounted) return;
    setState(() {
      _hiddenGroupKeys
        ..clear()
        ..addAll(nextHidden);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filterOptions = _buildFilterOptions();
    final filteredEvents = _filteredEvents();
    final isFiltering = _hiddenGroupKeys.isNotEmpty;
    return Column(
      children: [
        Padding(
          padding: padding,
          child: ValueListenableBuilder<bool>(
            valueListenable: _preferences.grouped,
            builder: (context, grouped, _) {
              final groupCount = grouped
                  ? _buildGroups(filteredEvents).length
                  : 0;
              return ValueListenableBuilder<int>(
                valueListenable: _preferences.maxEntries,
                builder: (context, maxEntries, _) {
                  final eventCountLabel = isFiltering
                      ? context.l10n.filteredEventCount(
                          filteredEvents.length,
                          events.length,
                        )
                      : context.l10n.eventCount(events.length);
                  final titleChildren = [
                    Flexible(
                      child: Text(
                        context.l10n.realtimeEvents,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppBadge(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      borderRadius: BorderRadius.circular(999),
                      color: theme.colorScheme.primary,
                      backgroundColor: theme.colorScheme.primary.withValues(
                        alpha: 0.10,
                      ),
                      textStyle: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      label: Text(
                        grouped
                            ? context.l10n.groupedEventCount(
                                groupCount,
                                eventCountLabel,
                              )
                            : eventCountLabel,
                      ),
                    ),
                  ];

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxWidth < 420;
                      final medium = constraints.maxWidth < 640;
                      if (compact) {
                        return Row(
                          children: [
                            Expanded(child: Row(children: titleChildren)),
                            _buildFilterButton(context, filterOptions),
                            _buildOverflowMenu(
                              context,
                              grouped,
                              includeGrouping: true,
                              includeLimit: true,
                              includeCopy: true,
                              includeClear: true,
                            ),
                          ],
                        );
                      }

                      if (medium) {
                        return Row(
                          children: [
                            Expanded(child: Row(children: titleChildren)),
                            _buildFilterButton(context, filterOptions),
                            _buildGroupingButton(grouped),
                            _buildOverflowMenu(
                              context,
                              grouped,
                              includeGrouping: false,
                              includeLimit: true,
                              includeCopy: true,
                              includeClear: true,
                            ),
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Expanded(child: Row(children: titleChildren)),
                          _buildMaxEntriesMenu(
                            context,
                            maxEntries,
                            showLabel: constraints.maxWidth >= 760,
                          ),
                          _buildFilterButton(context, filterOptions),
                          _buildGroupingButton(grouped),
                          AppIconButton(
                            tooltip: context.l10n.copy,
                            onPressed: events.isEmpty
                                ? null
                                : () => _copy(context),
                            icon: Icons.copy_all_rounded,
                          ),
                          AppIconButton(
                            tooltip: context.l10n.clear,
                            onPressed: events.isEmpty ? null : onClear,
                            icon: Icons.delete_sweep_rounded,
                            style: AppIconButtonStyle.destructive,
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        Expanded(
          child: events.isEmpty
              ? Center(
                  child: AppEmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: emptyText,
                  ),
                )
              : filteredEvents.isEmpty
              ? Center(
                  child: AppEmptyState(
                    icon: Icons.filter_alt_off_outlined,
                    title: context.l10n.noFilteredRealtimeEvents,
                  ),
                )
              : ValueListenableBuilder<bool>(
                  valueListenable: _preferences.grouped,
                  builder: (context, grouped, _) {
                    if (grouped) {
                      final groups = _buildGroups(filteredEvents).reversed
                          .toList();
                      return AppListView.separated(
                        padding: padding,
                        itemCount: groups.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          return _RealtimeEventGroupTile(
                            group: groups[index],
                            isDark: isDark,
                          );
                        },
                      );
                    }
                    return AppListView.separated(
                      padding: padding,
                      reverse: true,
                      itemCount: filteredEvents.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final event =
                            filteredEvents[filteredEvents.length - 1 - index];
                        return _RealtimeEventTile(event: event, isDark: isDark);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  List<_RealtimeEventGroup> _buildGroups(
    List<RealtimeEventLogEntry> sourceEvents,
  ) {
    final groups = <String, _RealtimeEventGroup>{};
    for (final event in sourceEvents) {
      groups
          .putIfAbsent(event.groupKey, () => _RealtimeEventGroup(event))
          .add(event);
    }
    return groups.values.toList(growable: false)
      ..sort((a, b) => a.latest.timestamp.compareTo(b.latest.timestamp));
  }
}

class _RealtimeEventGroup {
  RealtimeEventLogEntry latest;
  final List<RealtimeEventLogEntry> events = [];
  int totalBytes = 0;

  _RealtimeEventGroup(this.latest);

  int get count => events.length;

  void add(RealtimeEventLogEntry event) {
    latest = event;
    events.add(event);
    totalBytes += event.byteLength;
  }
}

class _RealtimeEventFilterOption {
  final String key;
  final String direction;
  final String label;
  int count;
  DateTime latest;

  _RealtimeEventFilterOption({
    required this.key,
    required this.direction,
    required this.label,
    required this.count,
    required this.latest,
  });
}

class _DirectionPill extends StatelessWidget {
  final String direction;

  const _DirectionPill({required this.direction});

  @override
  Widget build(BuildContext context) {
    final outgoing = direction == 'out';
    final tone = outgoing ? Colors.blueAccent : Colors.green;
    return AppBadge(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      borderRadius: BorderRadius.circular(999),
      color: tone,
      backgroundColor: tone.withValues(alpha: 0.12),
      textStyle: TextStyle(
        color: tone,
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
      label: Text(outgoing ? context.l10n.sent : context.l10n.received),
    );
  }
}

class _RealtimeEventGroupTile extends StatelessWidget {
  final _RealtimeEventGroup group;
  final bool isDark;

  const _RealtimeEventGroupTile({required this.group, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final event = group.latest;
    return AppCard(
      padding: EdgeInsets.zero,
      child: AppAccordionItem(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _DirectionPill(direction: event.direction),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    event.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _GroupMeta(label: context.l10n.itemCount(group.count)),
                _GroupMeta(label: context.l10n.latestAt(event.timeLabel)),
                if (group.totalBytes > 0)
                  _GroupMeta(label: context.l10n.byteCount(group.totalBytes)),
              ],
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
          child: Column(
            children: [
              for (final item in group.events.reversed)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _RealtimeEventGroupEntryTile(
                    event: item,
                    isDark: isDark,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RealtimeEventGroupEntryTile extends StatelessWidget {
  final RealtimeEventLogEntry event;
  final bool isDark;

  const _RealtimeEventGroupEntryTile({
    required this.event,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final preview = event.payload == null ? '' : event.payloadPreview();
    return AppPanelSurface(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      color: isDark
          ? Colors.white.withValues(alpha: 0.04)
          : Colors.black.withValues(alpha: 0.025),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _GroupMeta(label: event.timeLabel),
              if (event.byteLength > 0)
                _GroupMeta(label: context.l10n.byteCount(event.byteLength)),
            ],
          ),
          if (event.detail.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              event.detail,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: theme.hintColor, fontSize: 12),
            ),
          ],
          if (preview.isNotEmpty) ...[
            const SizedBox(height: 8),
            AppSelectableText(
              preview,
              style: TextStyle(
                fontSize: 11,
                height: 1.25,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
                fontFamily: 'monospace',
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _GroupMeta extends StatelessWidget {
  final String label;

  const _GroupMeta({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(label, style: TextStyle(color: theme.hintColor, fontSize: 12));
  }
}

class _RealtimeEventTile extends StatelessWidget {
  final RealtimeEventLogEntry event;
  final bool isDark;

  const _RealtimeEventTile({required this.event, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final preview = event.payload == null ? '' : event.payloadPreview();
    return AppPanelSurface(
      padding: const EdgeInsets.all(12),
      color: isDark ? const Color(0xFF1E1E24) : Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _DirectionPill(direction: event.direction),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  event.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                event.timeLabel,
                style: TextStyle(color: theme.hintColor, fontSize: 12),
              ),
            ],
          ),
          if (event.detail.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              event.detail,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: theme.hintColor, fontSize: 12),
            ),
          ],
          if (preview.isNotEmpty) ...[
            const SizedBox(height: 8),
            AppSelectableText(
              preview,
              style: TextStyle(
                fontSize: 11,
                height: 1.25,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.78),
                fontFamily: 'monospace',
              ),
            ),
          ],
          if (event.byteLength > 0) ...[
            const SizedBox(height: 6),
            Text(
              context.l10n.byteCount(event.byteLength),
              style: TextStyle(color: theme.hintColor, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}
