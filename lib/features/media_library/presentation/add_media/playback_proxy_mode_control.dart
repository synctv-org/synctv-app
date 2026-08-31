import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';
import 'package:synctv_app/features/providers/application/provider_gateway.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;
import 'package:synctv_app/src/generated/proto/providers/common.pbenum.dart'
    as provider_common_enum;
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;

class PlaybackProxyModeControl extends StatefulWidget {
  const PlaybackProxyModeControl({
    super.key,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.policy,
    this.source,
  });

  final source_enum.PlaybackProxyMode value;
  final ValueChanged<source_enum.PlaybackProxyMode> onChanged;
  final bool enabled;
  final provider_common.PlaybackProxyPolicy? policy;
  final provider_common.DiscoveredSource? source;

  @override
  State<PlaybackProxyModeControl> createState() =>
      _PlaybackProxyModeControlState();
}

class _PlaybackProxyModeControlState extends State<PlaybackProxyModeControl> {
  Future<provider_common.PlaybackProxyPolicy>? _policyFuture;
  provider_common.PlaybackProxyPolicy? _activePolicy;
  source_enum.PlaybackProxyMode? _pendingNormalizedValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _refreshPolicy();
  }

  @override
  void didUpdateWidget(covariant PlaybackProxyModeControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.policy != oldWidget.policy ||
        widget.source != oldWidget.source) {
      _refreshPolicy();
    }
  }

  void _refreshPolicy() {
    _activePolicy = null;
    _pendingNormalizedValue = null;
    if (widget.policy != null || widget.source == null) {
      _policyFuture = null;
      return;
    }
    final gateway = DependencyScope.maybeRead<ProviderGateway>(context);
    try {
      _policyFuture = gateway?.resolvePlaybackProxyPolicy(widget.source!);
    } on Object {
      _policyFuture = null;
    }
  }

  void _normalizeValue(provider_common.PlaybackProxyPolicy? policy) {
    _activePolicy = policy;
    if (policy == null || policy.supportedModes.isEmpty) return;
    final supportedModes = policy.supportedModes;
    if (supportedModes.contains(widget.value)) {
      _pendingNormalizedValue = null;
      return;
    }
    final fallback =
        supportedModes.contains(
          source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
        )
        ? source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO
        : supportedModes.firstOrNull;
    if (fallback == null || _pendingNormalizedValue == fallback) return;
    _pendingNormalizedValue = fallback;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !identical(_activePolicy, policy)) return;
      final normalizedValue = _pendingNormalizedValue;
      _pendingNormalizedValue = null;
      if (normalizedValue != null && widget.value != normalizedValue) {
        widget.onChanged(normalizedValue);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final policy = widget.policy;
    if (policy != null) {
      _normalizeValue(policy);
      return _PlaybackProxyModeView(
        value: widget.value,
        onChanged: widget.onChanged,
        enabled: widget.enabled,
        policy: policy,
      );
    }
    if (widget.source == null) return const SizedBox.shrink();
    if (_policyFuture == null) {
      return _PlaybackProxyPolicyUnavailable(
        error: context.l10n.playbackProxyPolicyUnavailable(''),
      );
    }
    return FutureBuilder<provider_common.PlaybackProxyPolicy>(
      future: _policyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 40,
            child: Center(child: CircularProgressIndicator.adaptive()),
          );
        }
        final resolvedPolicy = snapshot.data;
        if (resolvedPolicy == null || resolvedPolicy.supportedModes.isEmpty) {
          return _PlaybackProxyPolicyUnavailable(
            error: context.l10n.playbackProxyPolicyUnavailable(
              snapshot.error?.toString() ?? '',
            ),
          );
        }
        _normalizeValue(resolvedPolicy);
        return _PlaybackProxyModeView(
          value: widget.value,
          onChanged: widget.onChanged,
          enabled: widget.enabled,
          policy: resolvedPolicy,
        );
      },
    );
  }
}

class _PlaybackProxyPolicyUnavailable extends StatelessWidget {
  const _PlaybackProxyPolicyUnavailable({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Text(
      error,
      style: Theme.of(context).textTheme.bodySmall
          ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
  }
}

class _PlaybackProxyModeView extends StatelessWidget {
  const _PlaybackProxyModeView({
    required this.value,
    required this.onChanged,
    required this.enabled,
    required this.policy,
  });

  final source_enum.PlaybackProxyMode value;
  final ValueChanged<source_enum.PlaybackProxyMode> onChanged;
  final bool enabled;
  final provider_common.PlaybackProxyPolicy? policy;

  static const _segmentedMinimumWidth = 640.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final options = _options(context);
    if (options.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.route_rounded,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                context.l10n.playbackProxyMode,
                style: theme.textTheme.labelLarge,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            key: const Key('playback-proxy-mode-unavailable'),
            context.l10n.playbackProxyNoCompatibleMode,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }
    final selectedValue = options.any((option) => option.value == value)
        ? value
        : options.first.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              Icons.route_rounded,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              context.l10n.playbackProxyMode,
              style: theme.textTheme.labelLarge,
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < _segmentedMinimumWidth) {
              return DropdownButtonFormField<source_enum.PlaybackProxyMode>(
                key: const Key('playback-proxy-mode-dropdown'),
                initialValue: selectedValue,
                isExpanded: true,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                items: [
                  for (final option in options)
                    DropdownMenuItem(
                      value: option.value,
                      child: _optionLabel(option),
                    ),
                ],
                onChanged: enabled
                    ? (selection) {
                        if (selection != null) onChanged(selection);
                      }
                    : null,
              );
            }
            return SegmentedButton<source_enum.PlaybackProxyMode>(
              key: const Key('playback-proxy-mode'),
              showSelectedIcon: false,
              style: const ButtonStyle(
                minimumSize: WidgetStatePropertyAll(Size(0, 40)),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                textStyle: WidgetStatePropertyAll(
                  TextStyle(fontSize: 13, letterSpacing: 0),
                ),
              ),
              segments: [
                for (final option in options)
                  ButtonSegment(
                    value: option.value,
                    icon: Icon(option.icon, size: 17),
                    label: Text(option.label),
                  ),
              ],
              selected: {selectedValue},
              onSelectionChanged: enabled
                  ? (selection) => onChanged(selection.single)
                  : null,
            );
          },
        ),
        const SizedBox(height: 6),
        Text(
          _description(context, selectedValue),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (_autoPolicyDescription(context, selectedValue)
            case final autoDescription?) ...[
          const SizedBox(height: 4),
          Text(
            autoDescription,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ],
        if (_showsDirectPlaybackRisk(selectedValue)) ...[
          const SizedBox(height: 8),
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 18,
                    color: theme.colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.l10n.playbackProxyDirectRisk,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _description(
    BuildContext context,
    source_enum.PlaybackProxyMode selectedValue,
  ) => switch (selectedValue) {
    source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER =>
      context.l10n.playbackProxyPreferDescription,
    source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY =>
      context.l10n.playbackProxyOnlyDescription,
    source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_PREFER =>
      context.l10n.playbackProxyDirectPreferDescription,
    source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY =>
      context.l10n.playbackProxyDirectOnlyDescription,
    _ => context.l10n.playbackProxyAutoDescription,
  };

  String? _autoPolicyDescription(
    BuildContext context,
    source_enum.PlaybackProxyMode selectedValue,
  ) {
    if (selectedValue !=
            source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO ||
        policy == null ||
        policy!.autoPolicies.isEmpty) {
      return null;
    }
    final policies = policy!.autoPolicies
        .map((entry) {
          final variant = entry.variant.trim();
          final mode = _labelForMode(context, entry.mode);
          final reason = _reasonLabel(context, entry.reason);
          return context.l10n.playbackProxyAutoEffective(
            mode,
            reason,
            variant.isEmpty ? context.l10n.mediaSource : variant,
          );
        })
        .join(' · ');
    return policies;
  }

  String _labelForMode(
    BuildContext context,
    source_enum.PlaybackProxyMode mode,
  ) => switch (mode) {
    source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER =>
      context.l10n.playbackProxyPrefer,
    source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY =>
      context.l10n.playbackProxyOnly,
    source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_PREFER =>
      context.l10n.playbackProxyDirectPrefer,
    source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY =>
      context.l10n.playbackProxyDirectOnly,
    _ => context.l10n.playbackProxyAuto,
  };

  String _reasonLabel(
    BuildContext context,
    provider_common_enum.PlaybackProxyAutoReason reason,
  ) => switch (reason) {
    provider_common_enum
        .PlaybackProxyAutoReason
        .PLAYBACK_PROXY_AUTO_REASON_PUBLIC_RESOURCE =>
      context.l10n.playbackProxyReasonPublicResource,
    provider_common_enum
        .PlaybackProxyAutoReason
        .PLAYBACK_PROXY_AUTO_REASON_REQUEST_CREDENTIALS =>
      context.l10n.playbackProxyReasonRequestCredentials,
    provider_common_enum
        .PlaybackProxyAutoReason
        .PLAYBACK_PROXY_AUTO_REASON_SIGNED_RESOURCE =>
      context.l10n.playbackProxyReasonSignedResource,
    provider_common_enum
        .PlaybackProxyAutoReason
        .PLAYBACK_PROXY_AUTO_REASON_PROVIDER_SESSION =>
      context.l10n.playbackProxyReasonProviderSession,
    provider_common_enum
        .PlaybackProxyAutoReason
        .PLAYBACK_PROXY_AUTO_REASON_SERVER_TRANSPORT =>
      context.l10n.playbackProxyReasonServerTransport,
    _ => context.l10n.playbackProxyReasonProviderSession,
  };

  List<_PlaybackProxyModeOption> _options(BuildContext context) {
    final supported = policy!.supportedModes.toSet();
    final options = [
      _PlaybackProxyModeOption(
        value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
        icon: Icons.auto_awesome_outlined,
        label: context.l10n.playbackProxyAuto,
      ),
      _PlaybackProxyModeOption(
        value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER,
        icon: Icons.speed_rounded,
        label: context.l10n.playbackProxyPrefer,
      ),
      _PlaybackProxyModeOption(
        value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_ONLY,
        icon: Icons.lock_outline_rounded,
        label: context.l10n.playbackProxyOnly,
      ),
      _PlaybackProxyModeOption(
        value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_PREFER,
        icon: Icons.lan_rounded,
        label: context.l10n.playbackProxyDirectPrefer,
      ),
      _PlaybackProxyModeOption(
        value: source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY,
        icon: Icons.link_rounded,
        label: context.l10n.playbackProxyDirectOnly,
      ),
    ];
    return options
        .where((option) => supported.contains(option.value))
        .toList(growable: false);
  }

  Widget _optionLabel(_PlaybackProxyModeOption option) => Row(
    children: [
      Icon(option.icon, size: 17),
      const SizedBox(width: 8),
      Expanded(child: Text(option.label)),
    ],
  );

  bool _showsDirectPlaybackRisk(source_enum.PlaybackProxyMode mode) =>
      mode == source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_PREFER ||
      mode == source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_PREFER ||
      mode == source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_DIRECT_ONLY;
}

class _PlaybackProxyModeOption {
  const _PlaybackProxyModeOption({
    required this.value,
    required this.icon,
    required this.label,
  });

  final source_enum.PlaybackProxyMode value;
  final IconData icon;
  final String label;
}
