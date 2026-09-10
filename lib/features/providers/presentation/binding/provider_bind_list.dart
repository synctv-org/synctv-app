part of 'platform_binding_dialog.dart';

class _ProviderBindList extends StatelessWidget {
  final _ProviderSpec provider;
  final List<_ProviderBindItem> items;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;
  final VoidCallback onRetry;
  final bool isUnbinding;
  final bool isSubmitting;
  final ValueChanged<_ProviderBindItem> onUnbind;
  final ValueChanged<_ProviderBindItem> onInfo;
  final VoidCallback onAdd;

  const _ProviderBindList({
    required this.provider,
    required this.items,
    required this.isLoading,
    required this.isRefreshing,
    required this.error,
    required this.onRetry,
    required this.isUnbinding,
    required this.isSubmitting,
    required this.onUnbind,
    required this.onInfo,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const AppLoadingIndicator();
    if (error != null) {
      return Center(
        child: AppSingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 12),
                Semantics(
                  liveRegion: true,
                  child: Text(
                    context.l10n.loadProviderBindingsFailed(
                      provider.label,
                      error!,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                AppActionButton(
                  onPressed: onRetry,
                  icon: Icons.refresh_rounded,
                  label: context.l10n.retry,
                  wrapLabel: true,
                ),
              ],
            ),
          ),
        ),
      );
    }
    final busy = isUnbinding || isRefreshing;
    if (provider.kind == _ProviderKind.bilibili) {
      final item = items.firstOrNull;
      return _BilibiliSingleBindView(
        provider: provider,
        item: item,
        onBind: busy ? null : onAdd,
        onInfo: item == null || busy ? null : () => onInfo(item),
        onUnbind: item == null || busy ? null : () => onUnbind(item),
        isUnbinding: isSubmitting,
        isRefreshing: isRefreshing,
      );
    }

    return Column(
      children: [
        if (isSubmitting || isRefreshing) const AppLinearProgress(),
        Expanded(
          child: items.isEmpty
              ? Center(
                  child: AppSingleChildScrollView(
                    child: AppEmptyMessage(
                      icon: provider.emptyIcon,
                      message: context.l10n.noBoundProviderAccounts(
                        provider.label,
                      ),
                    ),
                  ),
                )
              : AppListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _ProviderBindingCard(
                      provider: provider,
                      item: item,
                      onInfo: busy ? null : () => onInfo(item),
                      onUnbind: busy ? null : () => onUnbind(item),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: SizedBox(
            width: double.infinity,
            child: AppActionButton(
              wrapLabel: true,
              onPressed: busy ? null : onAdd,
              icon: Icons.add_rounded,
              label: items.isEmpty
                  ? context.l10n.bindProvider(provider.label)
                  : context.l10n.rebindProvider(provider.label),
              style: AppActionButtonStyle.tonal,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProviderBindingCard extends StatelessWidget {
  final _ProviderSpec provider;
  final _ProviderBindItem item;
  final VoidCallback? onInfo;
  final VoidCallback? onUnbind;

  const _ProviderBindingCard({
    required this.provider,
    required this.item,
    required this.onInfo,
    required this.onUnbind,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final serverId = item.serverId.isNotEmpty ? item.serverId : item.id;
    final title = item.title.isNotEmpty
        ? item.title
        : item.subtitle.isNotEmpty
        ? item.subtitle
        : context.l10n.providerAccount(provider.label, serverId);
    final information = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        if (item.subtitle.isNotEmpty && item.subtitle != title) ...[
          const SizedBox(height: 5),
          Text(
            item.subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            AppBadge(
              icon: Icons.account_tree_rounded,
              color: theme.colorScheme.onSurface,
              backgroundColor: provider.color.withValues(alpha: 0.1),
              label: Text(
                _providerInstanceLabel(
                  item.instanceName,
                  context.l10n.localInstance,
                ),
              ),
            ),
            AppBadge(
              icon: Icons.tag_rounded,
              color: theme.colorScheme.onSurface,
              backgroundColor: theme.colorScheme.secondaryContainer,
              label: Text(serverId),
            ),
          ],
        ),
      ],
    );
    final icon = AppIconBadge(
      icon: provider.icon,
      color: provider.color,
      size: 42,
      backgroundAlpha: 0.12,
    );
    final actions = Wrap(
      spacing: 4,
      children: [
        AppIconButton(
          icon: Icons.info_outline,
          onPressed: onInfo,
          tooltip: context.l10n.details,
          style: AppIconButtonStyle.tonal,
        ),
        AppIconButton(
          icon: Icons.link_off_rounded,
          onPressed: onUnbind,
          tooltip: context.l10n.unbind,
          style: AppIconButtonStyle.destructive,
        ),
      ],
    );
    return AppPanelSurface(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.72),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth <
              MediaQuery.textScalerOf(context).scale(14) * 32) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                icon,
                const SizedBox(height: 12),
                information,
                const SizedBox(height: 12),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: actions,
                ),
              ],
            );
          }
          return Row(
            children: [
              icon,
              const SizedBox(width: 12),
              Expanded(child: information),
              const SizedBox(width: 12),
              actions,
            ],
          );
        },
      ),
    );
  }
}
