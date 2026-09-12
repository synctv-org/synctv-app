part of 'platform_binding_dialog.dart';

class _BilibiliSingleBindView extends StatelessWidget {
  final _ProviderSpec provider;
  final _ProviderBindItem? item;
  final VoidCallback? onBind;
  final bool isUnbinding;
  final bool isRefreshing;
  final VoidCallback? onInfo;
  final VoidCallback? onUnbind;

  const _BilibiliSingleBindView({
    required this.provider,
    required this.item,
    required this.onBind,
    required this.onInfo,
    required this.onUnbind,
    required this.isUnbinding,
    required this.isRefreshing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bound = item != null;
    final textScaler = MediaQuery.textScalerOf(context);
    final content = AppSingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppPanelSurface(
            padding: const EdgeInsets.all(18),
            color: provider.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: provider.color.withValues(alpha: 0.2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final icon = AppIconBadge(
                      icon: provider.icon,
                      color: provider.color,
                      size: 46,
                      backgroundAlpha: 0.14,
                    );
                    final description = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bound
                              ? context.l10n.bilibiliBound
                              : context.l10n.bindProvider('Bilibili'),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bound
                              ? context.l10n.bilibiliBoundDescription
                              : context.l10n.bilibiliBindingDescription,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.35,
                          ),
                        ),
                      ],
                    );
                    if (constraints.maxWidth < textScaler.scale(14) * 24) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          icon,
                          const SizedBox(height: 12),
                          description,
                        ],
                      );
                    }
                    return Row(
                      children: [
                        icon,
                        const SizedBox(width: 14),
                        Expanded(child: description),
                      ],
                    );
                  },
                ),
                if (bound) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      AppBadge(
                        icon: Icons.account_tree_rounded,
                        color: theme.colorScheme.onSurface,
                        backgroundColor: provider.color.withValues(alpha: 0.1),
                        label: Text(
                          _providerInstanceLabel(
                            item!.instanceName,
                            context.l10n.localInstance,
                          ),
                        ),
                      ),
                      if (item!.serverId.isNotEmpty)
                        AppBadge(
                          icon: Icons.tag_rounded,
                          color: theme.colorScheme.onSurface,
                          backgroundColor: theme.colorScheme.secondaryContainer,
                          label: Text(item!.serverId),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppResponsiveWrap(
            minItemWidth: 160 * textScaler.scale(14) / 14,
            maxColumns: bound ? 3 : 1,
            children: [
              if (bound)
                AppActionButton(
                  onPressed: onInfo,
                  icon: Icons.info_outline_rounded,
                  label: context.l10n.viewStatus,
                  wrapLabel: true,
                  style: AppActionButtonStyle.outlined,
                ),
              AppActionButton(
                onPressed: onBind,
                icon: bound ? Icons.sync_rounded : Icons.link_rounded,
                label: bound
                    ? context.l10n.rebind
                    : context.l10n.bindProvider('Bilibili'),
                wrapLabel: true,
              ),
              if (bound)
                AppActionButton(
                  onPressed: onUnbind,
                  loading: isUnbinding,
                  icon: Icons.link_off_rounded,
                  label: context.l10n.unbind,
                  wrapLabel: true,
                  style: AppActionButtonStyle.tonal,
                ),
            ],
          ),
        ],
      ),
    );
    return Column(
      children: [
        if (isRefreshing) const AppLinearProgress(),
        Expanded(child: content),
      ],
    );
  }
}
