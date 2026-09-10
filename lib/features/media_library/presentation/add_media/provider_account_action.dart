import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/media_provider_brand.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/l10n/l10n.dart';

/// Account entry point shared by provider add-media forms.
class ProviderAccountAction extends StatelessWidget {
  const ProviderAccountAction({
    super.key,
    required this.providerType,
    required this.onPressed,
  });

  final String providerType;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final brand = mediaProviderBrand(providerType);
    return AppActionButton(
      onPressed: onPressed,
      icon: brand.icon,
      label: context.l10n.bindProviderNow(brand.label),
      style: AppActionButtonStyle.tonal,
      size: AppActionButtonSize.md,
    );
  }
}

/// Selects the credential-backed media source used while discovering content.
/// The default option represents the provider's public/default instance.
class ProviderAccountSelector<T> extends StatelessWidget {
  const ProviderAccountSelector({
    super.key,
    required this.accounts,
    required this.selectedId,
    required this.idOf,
    required this.labelOf,
    required this.onChanged,
    this.includeDefault = false,
    this.enabled = true,
    this.defaultLabel,
    this.label,
    this.prefixIcon = Icons.account_circle_outlined,
  });

  final List<T> accounts;
  final String? selectedId;
  final String Function(T account) idOf;
  final String Function(T account) labelOf;
  final ValueChanged<T?> onChanged;
  final bool includeDefault;
  final bool enabled;
  final String? defaultLabel;
  final String? label;
  final IconData prefixIcon;

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty && !includeDefault) return const SizedBox.shrink();

    final accountsById = <String, T>{};
    for (final account in accounts) {
      final id = idOf(account);
      if (id.isNotEmpty) accountsById.putIfAbsent(id, () => account);
    }
    final labels = accountsById.map(
      (id, account) => MapEntry(id, labelOf(account)),
    );
    final labelCounts = <String, int>{};
    for (final label in labels.values) {
      labelCounts.update(label, (count) => count + 1, ifAbsent: () => 1);
    }
    final options = <String, String?>{
      if (includeDefault) defaultLabel ?? context.l10n.defaultMediaSource: null,
    };
    for (final entry in labels.entries) {
      final base =
          labelCounts[entry.value]! > 1 || options.containsKey(entry.value)
          ? '${entry.value} (${entry.key})'
          : entry.value;
      var label = base;
      var suffix = 2;
      // Account labels can also match another account's disambiguated label.
      while (options.containsKey(label) ||
          (label != entry.value && labelCounts.containsKey(label))) {
        label = '$base ${suffix++}';
      }
      options[label] = entry.key;
    }
    final selected = accountsById.containsKey(selectedId)
        ? selectedId
        : includeDefault
        ? null
        : accountsById.keys.firstOrNull;
    return AppSelect<String?>(
      value: selected,
      label: label ?? context.l10n.mediaSourceAccount,
      labelAbove: true,
      wrapText: true,
      useAnchoredMenu: true,
      prefixIcon: prefixIcon,
      options: options,
      enabled: enabled,
      onChanged: (id) => onChanged(id == null ? null : accountsById[id]),
    );
  }
}
