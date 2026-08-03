part of '../admin_settings_page.dart';

enum _SliceCacheOperationKind { evictExpired, purge }

class _SliceCacheTarget {
  const _SliceCacheTarget({required this.nodeId, required this.allNodes});

  final String nodeId;
  final bool allNodes;

  @override
  bool operator ==(Object other) =>
      other is _SliceCacheTarget &&
      other.nodeId == nodeId &&
      other.allNodes == allNodes;

  @override
  int get hashCode => Object.hash(nodeId, allNodes);
}

class _SliceCacheOperationReport {
  const _SliceCacheOperationReport({
    required this.kind,
    required this.target,
    required this.result,
  });

  final _SliceCacheOperationKind kind;
  final _SliceCacheTarget target;
  final AdminSliceCacheOperationResult result;
}

class AdminSliceCacheTab extends StatefulWidget {
  const AdminSliceCacheTab({super.key});

  @override
  State<AdminSliceCacheTab> createState() => _AdminSliceCacheTabState();
}

class _AdminSliceCacheTabState extends State<AdminSliceCacheTab> {
  final TextEditingController _nodeIdController = TextEditingController();
  AdminSliceCacheStats? _stats;
  _SliceCacheTarget? _statsTarget;
  _SliceCacheOperationReport? _lastOperation;
  bool _allNodes = false;
  bool _isLoading = true;
  bool _isOperating = false;
  bool _initialized = false;
  int _loadVersion = 0;

  _SliceCacheTarget get _currentTarget => _SliceCacheTarget(
    nodeId: _allNodes ? '' : _nodeIdController.text.trim(),
    allNodes: _allNodes,
  );

  bool get _canMaintainCurrentTarget =>
      !_isLoading &&
      !_isOperating &&
      _stats != null &&
      _statsTarget == _currentTarget;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _load();
    });
  }

  @override
  void dispose() {
    _nodeIdController.dispose();
    super.dispose();
  }

  void _invalidateTargetState() {
    _loadVersion += 1;
    setState(() {
      _stats = null;
      _statsTarget = null;
      _lastOperation = null;
      _isLoading = false;
    });
  }

  Future<void> _load({_SliceCacheTarget? target}) async {
    final queryTarget = target ?? _currentTarget;
    if (queryTarget != _currentTarget) return;
    final version = ++_loadVersion;
    setState(() {
      _isLoading = true;
      if (_statsTarget != queryTarget) {
        _stats = null;
        _statsTarget = null;
        _lastOperation = null;
      }
    });
    try {
      final stats = await adminGateway.adminGetSliceCacheStats(
        nodeId: queryTarget.nodeId,
        allNodes: queryTarget.allNodes,
      );
      if (!mounted ||
          version != _loadVersion ||
          queryTarget != _currentTarget) {
        return;
      }
      setState(() {
        _stats = stats;
        _statsTarget = queryTarget;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted ||
          version != _loadVersion ||
          queryTarget != _currentTarget) {
        return;
      }
      setState(() {
        _stats = null;
        _statsTarget = null;
        _isLoading = false;
      });
      AppNotifications.showError(
        context,
        context.l10n.loadSliceCacheFailed('$error'),
      );
    }
  }

  Future<void> _evictExpired() async {
    final target = _currentTarget;
    await _runOperation(
      target: target,
      kind: _SliceCacheOperationKind.evictExpired,
      operation: () => adminGateway.adminEvictExpiredSliceCache(
        nodeId: target.nodeId,
        allNodes: target.allNodes,
      ),
      messageFor: (result) =>
          context.l10n.sliceCacheEvictionCompleted(result.removedEntries),
    );
  }

  Future<void> _confirmPurge() async {
    final target = _currentTarget;
    final confirmed = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.purgeSliceCache,
      icon: const Icon(Icons.delete_sweep_rounded, color: Colors.red),
      iconColor: Colors.red,
      content: Text(context.l10n.confirmPurgeSliceCache),
      actions: [
        AppDialogs.createCancelButton(context),
        AppActionButton(
          onPressed: () => Navigator.pop(context, true),
          icon: Icons.delete_sweep_rounded,
          label: context.l10n.purgeSliceCache,
          style: AppActionButtonStyle.destructive,
        ),
      ],
    );
    if (confirmed != true || !mounted) return;
    await _runOperation(
      target: target,
      kind: _SliceCacheOperationKind.purge,
      operation: () => adminGateway.adminPurgeSliceCache(
        nodeId: target.nodeId,
        allNodes: target.allNodes,
      ),
      messageFor: (result) => context.l10n.sliceCachePurgeCompleted(
        result.removedEntries,
        _formatBytes(result.freedBytes),
      ),
    );
  }

  Future<void> _runOperation({
    required _SliceCacheTarget target,
    required _SliceCacheOperationKind kind,
    required Future<AdminSliceCacheOperationResult> Function() operation,
    required String Function(AdminSliceCacheOperationResult result) messageFor,
  }) async {
    if (_isOperating) return;
    setState(() {
      _isOperating = true;
      _lastOperation = null;
    });
    try {
      final result = await operation();
      if (!mounted) return;
      if (target == _currentTarget) {
        setState(() {
          _lastOperation = _SliceCacheOperationReport(
            kind: kind,
            target: target,
            result: result,
          );
        });
      }
      final message = messageFor(result);
      if (result.success && result.failures.isEmpty) {
        AppNotifications.showSuccess(context, message);
      } else {
        AppNotifications.showWarning(context, message);
      }
      await _load(target: target);
    } catch (error) {
      if (!mounted) return;
      AppNotifications.showError(
        context,
        context.l10n.operationFailed('$error'),
      );
    } finally {
      if (mounted) setState(() => _isOperating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = _stats;
    final operation = _lastOperation;
    final controlsBusy = _isLoading || _isOperating;
    final maintenanceEnabled = _canMaintainCurrentTarget;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 260,
                child: AppTextField(
                  controller: _nodeIdController,
                  label: context.l10n.nodeId,
                  hintText: context.l10n.currentNode,
                  prefixIcon: Icons.dns_outlined,
                  enabled: !_allNodes && !controlsBusy,
                  onChanged: (_) => _invalidateTargetState(),
                  onSubmitted: (_) => _load(),
                ),
              ),
              SizedBox(
                width: 160,
                child: AppSwitch(
                  value: _allNodes,
                  label: context.l10n.allNodes,
                  enabled: !controlsBusy,
                  onChanged: (value) {
                    _loadVersion += 1;
                    setState(() {
                      _allNodes = value;
                      _stats = null;
                      _statsTarget = null;
                      _lastOperation = null;
                      _isLoading = false;
                    });
                    _load();
                  },
                ),
              ),
              AppIconButton(
                tooltip: context.l10n.refresh,
                icon: Icons.refresh_rounded,
                onPressed: controlsBusy ? null : () => _load(),
              ),
              AppActionButton(
                onPressed: maintenanceEnabled ? _evictExpired : null,
                icon: Icons.auto_delete_outlined,
                label: context.l10n.evictExpiredSliceCache,
                loading: _isOperating,
                style: AppActionButtonStyle.tonal,
              ),
              AppActionButton(
                onPressed: maintenanceEnabled ? _confirmPurge : null,
                icon: Icons.delete_sweep_rounded,
                label: context.l10n.purgeSliceCache,
                style: AppActionButtonStyle.destructive,
              ),
            ],
          ),
        ),
        AppDivider(
          height: 1,
          color: theme.dividerColor.withValues(alpha: 0.55),
        ),
        Expanded(
          child: _isLoading
              ? const AppLoadingIndicator()
              : AppRefreshIndicator(
                  onRefresh: _load,
                  child: AppListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (operation != null &&
                          operation.target == _currentTarget)
                        ..._buildOperationResultBanners(
                          context,
                          theme,
                          operation,
                        ),
                      for (final failure in stats?.failures ?? const [])
                        AppInfoBanner(
                          margin: const EdgeInsets.only(bottom: 12),
                          icon: Icons.cloud_off_rounded,
                          color: theme.colorScheme.error,
                          title: Text(
                            failure.nodeId.isEmpty
                                ? context.l10n.nodeUnavailable
                                : failure.nodeId,
                          ),
                          message: Text(failure.error),
                        ),
                      if (stats == null || stats.nodes.isEmpty)
                        AppEmptyMessage(
                          message: context.l10n.noSliceCacheStats,
                          icon: Icons.storage_rounded,
                        )
                      else
                        for (final node in stats.nodes)
                          _SliceCacheNodeCard(node: node),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  List<Widget> _buildOperationResultBanners(
    BuildContext context,
    ThemeData theme,
    _SliceCacheOperationReport report,
  ) {
    final result = report.result;
    String successMessage(AdminSliceCacheOperationNode node) {
      return switch (report.kind) {
        _SliceCacheOperationKind.evictExpired =>
          context.l10n.sliceCacheEvictionCompleted(node.removedEntries),
        _SliceCacheOperationKind.purge => context.l10n.sliceCachePurgeCompleted(
          node.removedEntries,
          _formatBytes(node.freedBytes),
        ),
      };
    }

    return [
      for (final node in result.nodes)
        AppInfoBanner(
          key: ValueKey('slice-cache-operation-node-${node.nodeId}'),
          margin: const EdgeInsets.only(bottom: 12),
          icon: node.success
              ? Icons.check_circle_outline_rounded
              : Icons.error_outline_rounded,
          color: node.success ? Colors.green.shade600 : theme.colorScheme.error,
          title: Text(
            node.nodeId.isEmpty ? context.l10n.nodeUnavailable : node.nodeId,
          ),
          message: Text(
            node.success
                ? successMessage(node)
                : context.l10n.sliceCacheNodeOperationFailed,
          ),
        ),
      for (final failure in result.failures)
        AppInfoBanner(
          key: ValueKey('slice-cache-operation-failure-${failure.nodeId}'),
          margin: const EdgeInsets.only(bottom: 12),
          icon: Icons.cloud_off_rounded,
          color: theme.colorScheme.error,
          title: Text(
            failure.nodeId.isEmpty
                ? context.l10n.nodeUnavailable
                : failure.nodeId,
          ),
          message: Text(failure.error),
        ),
    ];
  }
}

class _SliceCacheNodeCard extends StatelessWidget {
  const _SliceCacheNodeCard({required this.node});

  final AdminSliceCacheNodeStats node;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = node.config;
    final usage = node.usageRatio.clamp(0.0, 1.0).toDouble();
    final statusColor = config.engineEnabled
        ? Colors.green.shade600
        : theme.colorScheme.outline;

    return AppPanelSurface(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: theme.dividerColor.withValues(alpha: 0.55)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppIconBadge(
                icon: Icons.dns_rounded,
                color: statusColor,
                size: 36,
                iconSize: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  node.nodeId,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                config.engineEnabled
                    ? context.l10n.enabled
                    : context.l10n.disabled,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppPanelSurface(
            height: 8,
            borderRadius: BorderRadius.circular(4),
            child: AppLinearProgress(
              value: usage,
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 24,
            runSpacing: 12,
            children: [
              _SliceCacheMetric(
                label: context.l10n.sliceCacheUsage,
                value: '${(node.usageRatio * 100).toStringAsFixed(1)}%',
              ),
              _SliceCacheMetric(
                label: context.l10n.sliceCacheSize,
                value: _formatBytes(node.currentSizeBytes),
              ),
              _SliceCacheMetric(
                label: context.l10n.sliceCacheEntries,
                value: '${node.entryCount}',
              ),
              _SliceCacheMetric(
                label: context.l10n.metadata,
                value: '${node.metadataEntries}',
              ),
              _SliceCacheMetric(
                label: context.l10n.sliceCacheUpdating,
                value: '${node.updatingEntries}',
              ),
              _SliceCacheMetric(
                label: context.l10n.sliceCacheLocks,
                value: '${node.lockCount}',
              ),
            ],
          ),
          const SizedBox(height: 12),
          AppDivider(color: theme.dividerColor.withValues(alpha: 0.45)),
          _InfoLine(context.l10n.sliceCacheBackend, config.backend),
          if (config.fileCacheDir.isNotEmpty)
            _InfoLine(context.l10n.sliceCacheDirectory, config.fileCacheDir),
          _InfoLine(
            context.l10n.sliceCacheCapacity,
            _formatBytes(config.maxCacheSize),
          ),
          _InfoLine(
            context.l10n.sliceCacheSliceSize,
            _formatBytes(config.sliceSize),
          ),
          _InfoLine(
            context.l10n.sliceCacheSegmentTtl,
            context.l10n.secondsValue('${config.segmentTtlSeconds}'),
          ),
          _InfoLine(
            context.l10n.sliceCacheStaleMaxAge,
            context.l10n.secondsValue('${config.staleMaxAgeSeconds}'),
          ),
          _InfoLine(
            context.l10n.sliceCacheEvictionInterval,
            context.l10n.secondsValue('${config.evictionIntervalSeconds}'),
          ),
          _InfoLine(
            context.l10n.staleWhileRevalidate,
            config.staleWhileRevalidate
                ? context.l10n.enabled
                : context.l10n.disabled,
          ),
        ],
      ),
    );
  }
}

class _SliceCacheMetric extends StatelessWidget {
  const _SliceCacheMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 132,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KiB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MiB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GiB';
}
