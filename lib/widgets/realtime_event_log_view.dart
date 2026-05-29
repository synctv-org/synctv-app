import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:synctv_app/models/realtime_event_log.dart';
import 'package:synctv_app/services/realtime_event_log_preferences.dart';
import 'package:synctv_app/utils/message_utils.dart';

enum _RealtimeEventLogMenuAction {
  toggleGrouping,
  copy,
  clear,
}

class RealtimeEventLogView extends StatefulWidget {
  final List<RealtimeEventLogEntry> events;
  final VoidCallback? onClear;
  final EdgeInsetsGeometry padding;
  final String emptyText;
  final ValueChanged<int>? onMaxEntriesChanged;

  const RealtimeEventLogView({
    super.key,
    required this.events,
    this.onClear,
    this.padding = const EdgeInsets.all(12),
    this.emptyText = '暂无实时事件',
    this.onMaxEntriesChanged,
  });

  @override
  State<RealtimeEventLogView> createState() => _RealtimeEventLogViewState();
}

class _RealtimeEventLogViewState extends State<RealtimeEventLogView> {
  final Set<String> _hiddenGroupKeys = {};

  List<RealtimeEventLogEntry> get events => widget.events;
  VoidCallback? get onClear => widget.onClear;
  EdgeInsetsGeometry get padding => widget.padding;
  String get emptyText => widget.emptyText;
  ValueChanged<int>? get onMaxEntriesChanged => widget.onMaxEntriesChanged;

  @override
  void didUpdateWidget(covariant RealtimeEventLogView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final availableKeys = widget.events.map((event) => event.groupKey).toSet();
    _hiddenGroupKeys.removeWhere((key) => !availableKeys.contains(key));
  }

  Future<void> _copy(BuildContext context) async {
    final text = const JsonEncoder.withIndent('  ').convert(
      events.map((event) => event.toJson()).toList(growable: false),
    );
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) MessageUtils.showSuccess(context, '实时事件已复制');
  }

  Future<void> _changeMaxEntries(BuildContext context, int value) async {
    var nextValue = value;
    if (value == -1) {
      final controller = TextEditingController(
        text: RealtimeEventLogPreferences.maxEntries.value.toString(),
      );
      nextValue = await showDialog<int>(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: const Text('保留条数'),
                content: TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: '最近事件数量',
                    helperText: '范围 20-2000',
                    border: OutlineInputBorder(),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('取消'),
                  ),
                  FilledButton(
                    onPressed: () {
                      final parsed = int.tryParse(controller.text.trim());
                      if (parsed == null) return;
                      Navigator.pop(dialogContext, parsed);
                    },
                    child: const Text('保存'),
                  ),
                ],
              );
            },
          ) ??
          RealtimeEventLogPreferences.maxEntries.value;
      controller.dispose();
    }

    await RealtimeEventLogPreferences.setMaxEntries(nextValue);
    onMaxEntriesChanged?.call(nextValue);
  }

  Future<void> _handleOverflowAction(
    BuildContext context,
    _RealtimeEventLogMenuAction action,
    bool grouped,
  ) async {
    switch (action) {
      case _RealtimeEventLogMenuAction.toggleGrouping:
        await RealtimeEventLogPreferences.setGrouped(!grouped);
      case _RealtimeEventLogMenuAction.copy:
        await _copy(context);
      case _RealtimeEventLogMenuAction.clear:
        onClear?.call();
    }
  }

  PopupMenuButton<int> _buildMaxEntriesMenu(
    BuildContext context,
    int maxEntries, {
    bool showLabel = false,
  }) {
    return PopupMenuButton<int>(
      tooltip: '保留条数',
      icon: showLabel ? null : const Icon(Icons.storage_rounded),
      initialValue: maxEntries,
      onSelected: (value) => _changeMaxEntries(context, value),
      itemBuilder: (context) => const [
        PopupMenuItem(value: 50, child: Text('保留 50 条')),
        PopupMenuItem(value: 100, child: Text('保留 100 条')),
        PopupMenuItem(value: 200, child: Text('保留 200 条')),
        PopupMenuItem(value: 500, child: Text('保留 500 条')),
        PopupMenuItem(value: 1000, child: Text('保留 1000 条')),
        PopupMenuDivider(),
        PopupMenuItem(value: -1, child: Text('自定义...')),
      ],
      child: showLabel
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.storage_rounded, size: 18),
                  const SizedBox(width: 6),
                  Text('保留 $maxEntries'),
                  const SizedBox(width: 2),
                  const Icon(Icons.arrow_drop_down_rounded, size: 18),
                ],
              ),
            )
          : null,
    );
  }

  IconButton _buildGroupingButton(bool grouped) {
    return IconButton(
      tooltip: grouped ? '按时间查看' : '按类型分组',
      selectedIcon: const Icon(Icons.view_agenda_rounded),
      isSelected: grouped,
      onPressed: () => RealtimeEventLogPreferences.setGrouped(!grouped),
      icon: const Icon(Icons.account_tree_rounded),
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
    return MenuAnchor(
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
            child: Text(grouped ? '按时间查看' : '按类型分组'),
          ),
        if (includeLimit)
          SubmenuButton(
            menuChildren: [
              MenuItemButton(
                onPressed: () => _changeMaxEntries(context, 50),
                child: const Text('50 条'),
              ),
              MenuItemButton(
                onPressed: () => _changeMaxEntries(context, 100),
                child: const Text('100 条'),
              ),
              MenuItemButton(
                onPressed: () => _changeMaxEntries(context, 200),
                child: const Text('200 条'),
              ),
              MenuItemButton(
                onPressed: () => _changeMaxEntries(context, 500),
                child: const Text('500 条'),
              ),
              MenuItemButton(
                onPressed: () => _changeMaxEntries(context, 1000),
                child: const Text('1000 条'),
              ),
              MenuItemButton(
                onPressed: () => _changeMaxEntries(context, -1),
                child: const Text('自定义...'),
              ),
            ],
            child: const Text('保留条数'),
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
            child: const Text('复制事件'),
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
            child: const Text('清空事件'),
          ),
      ],
      builder: (context, controller, child) {
        return IconButton(
          tooltip: '更多操作',
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(Icons.more_horiz_rounded),
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
    return options.values.toList(growable: false)
      ..sort((a, b) {
        final labelCompare = a.label.compareTo(b.label);
        if (labelCompare != 0) return labelCompare;
        return a.direction.compareTo(b.direction);
      });
  }

  IconButton _buildFilterButton(
    BuildContext context,
    List<_RealtimeEventFilterOption> options,
  ) {
    final active = _hiddenGroupKeys.isNotEmpty;
    return IconButton(
      tooltip: '筛选事件类型',
      isSelected: active,
      selectedIcon: const Icon(Icons.filter_alt_rounded),
      icon: const Icon(Icons.filter_alt_outlined),
      color: active ? Theme.of(context).colorScheme.primary : null,
      onPressed:
          options.isEmpty ? null : () => _showFilterSheet(context, options),
    );
  }

  Future<void> _showFilterSheet(
    BuildContext context,
    List<_RealtimeEventFilterOption> options,
  ) async {
    final optionKeys = options.map((option) => option.key).toSet();
    var draftHidden =
        _hiddenGroupKeys.where((key) => optionKeys.contains(key)).toSet();
    final nextHidden = await showModalBottomSheet<Set<String>>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final selectedCount = options.length - draftHidden.length;
            final allSelected = draftHidden.isEmpty;
            return SafeArea(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.82,
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
                                  '事件类型过滤',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '已选择 $selectedCount / ${options.length}',
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => setSheetState(() {
                              draftHidden = <String>{};
                            }),
                            child: const Text('全选'),
                          ),
                        ],
                      ),
                    ),
                    CheckboxListTile(
                      value: draftHidden.isNotEmpty &&
                              draftHidden.length < options.length
                          ? null
                          : allSelected,
                      tristate: draftHidden.isNotEmpty &&
                          draftHidden.length < options.length,
                      onChanged: (value) => setSheetState(() {
                        draftHidden =
                            value == true ? <String>{} : Set.of(optionKeys);
                      }),
                      title: const Text('全部类型'),
                      subtitle: Text('${events.length} 条事件'),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    const Divider(height: 1),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options[index];
                          final selected = !draftHidden.contains(option.key);
                          return CheckboxListTile(
                            value: selected,
                            onChanged: (value) => setSheetState(() {
                              if (value == true) {
                                draftHidden.remove(option.key);
                              } else {
                                draftHidden.add(option.key);
                              }
                            }),
                            controlAffinity: ListTileControlAffinity.leading,
                            secondary: _DirectionPill(
                              direction: option.direction,
                            ),
                            title: Text(
                              option.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text('${option.count} 条'),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(sheetContext),
                            child: const Text('取消'),
                          ),
                          const SizedBox(width: 8),
                          FilledButton(
                            onPressed: () =>
                                Navigator.pop(sheetContext, draftHidden),
                            child: const Text('应用'),
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
            valueListenable: RealtimeEventLogPreferences.grouped,
            builder: (context, grouped, _) {
              final groupCount =
                  grouped ? _buildGroups(filteredEvents).length : 0;
              return ValueListenableBuilder<int>(
                valueListenable: RealtimeEventLogPreferences.maxEntries,
                builder: (context, maxEntries, _) {
                  final eventCountLabel = isFiltering
                      ? '${filteredEvents.length}/${events.length} 条'
                      : '${events.length} 条';
                  final titleChildren = [
                    Flexible(
                      child: Text(
                        '实时事件',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.primary.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        grouped
                            ? '$groupCount 组 / $eventCountLabel'
                            : eventCountLabel,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
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
                          IconButton(
                            tooltip: '复制',
                            onPressed:
                                events.isEmpty ? null : () => _copy(context),
                            icon: const Icon(Icons.copy_all_rounded),
                          ),
                          IconButton(
                            tooltip: '清空',
                            onPressed: events.isEmpty ? null : onClear,
                            icon: const Icon(Icons.delete_sweep_rounded),
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
                  child:
                      Text(emptyText, style: TextStyle(color: theme.hintColor)),
                )
              : filteredEvents.isEmpty
                  ? Center(
                      child: Text(
                        '当前过滤条件下暂无实时事件',
                        style: TextStyle(color: theme.hintColor),
                      ),
                    )
                  : ValueListenableBuilder<bool>(
                      valueListenable: RealtimeEventLogPreferences.grouped,
                      builder: (context, grouped, _) {
                        if (grouped) {
                          final groups =
                              _buildGroups(filteredEvents).reversed.toList();
                          return ListView.separated(
                            padding: padding,
                            itemCount: groups.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              return _RealtimeEventGroupTile(
                                group: groups[index],
                                isDark: isDark,
                              );
                            },
                          );
                        }
                        return ListView.separated(
                          padding: padding,
                          reverse: true,
                          itemCount: filteredEvents.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final event = filteredEvents[
                                filteredEvents.length - 1 - index];
                            return _RealtimeEventTile(
                                event: event, isDark: isDark);
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        outgoing ? '发出' : '收到',
        style: TextStyle(
          color: tone,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _RealtimeEventGroupTile extends StatelessWidget {
  final _RealtimeEventGroup group;
  final bool isDark;

  const _RealtimeEventGroupTile({
    required this.group,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final event = group.latest;
    final outgoing = event.direction == 'out';
    final tone = outgoing ? Colors.blueAccent : Colors.green;
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 12),
      childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      backgroundColor: isDark ? const Color(0xFF1E1E24) : Colors.white,
      collapsedBackgroundColor: isDark ? const Color(0xFF1E1E24) : Colors.white,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: tone.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              outgoing ? '发出' : '收到',
              style: TextStyle(
                color: tone,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
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
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            _GroupMeta(label: '${group.count} 条'),
            _GroupMeta(label: '最新 ${event.timeLabel}'),
            if (group.totalBytes > 0)
              _GroupMeta(label: '${group.totalBytes} bytes'),
          ],
        ),
      ),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.black.withValues(alpha: 0.025),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
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
                _GroupMeta(label: '${event.byteLength} bytes'),
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
            SelectableText(
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
    return Text(
      label,
      style: TextStyle(color: theme.hintColor, fontSize: 12),
    );
  }
}

class _RealtimeEventTile extends StatelessWidget {
  final RealtimeEventLogEntry event;
  final bool isDark;

  const _RealtimeEventTile({
    required this.event,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outgoing = event.direction == 'out';
    final tone = outgoing ? Colors.blueAccent : Colors.green;
    final preview = event.payload == null ? '' : event.payloadPreview();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE6E7EE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tone.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  outgoing ? '发出' : '收到',
                  style: TextStyle(
                    color: tone,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
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
            SelectableText(
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
              '${event.byteLength} bytes',
              style: TextStyle(color: theme.hintColor, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}
