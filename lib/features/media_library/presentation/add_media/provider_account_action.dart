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
  });

  static const defaultValue = '__default_media_source__';

  final List<T> accounts;
  final String? selectedId;
  final String Function(T account) idOf;
  final String Function(T account) labelOf;
  final ValueChanged<T?> onChanged;
  final bool includeDefault;
  final bool enabled;
  final String? defaultLabel;

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty && !includeDefault) return const SizedBox.shrink();

    final accountIds = <String>{};
    final items = <DropdownMenuItem<String>>[];
    if (includeDefault) {
      items.add(
        DropdownMenuItem(
          value: defaultValue,
          child: Text(defaultLabel ?? context.l10n.defaultMediaSource),
        ),
      );
    }
    for (final account in accounts) {
      final id = idOf(account);
      if (id.isEmpty || !accountIds.add(id)) continue;
      items.add(
        DropdownMenuItem(
          value: id,
          child: Text(labelOf(account), overflow: TextOverflow.ellipsis),
        ),
      );
    }

    final selected =
        selectedId != null &&
            selectedId!.isNotEmpty &&
            accountIds.contains(selectedId)
        ? selectedId
        : includeDefault
        ? defaultValue
        : items.firstOrNull?.value;
    return DropdownButtonFormField<String>(
      initialValue: selected,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: context.l10n.mediaSourceAccount,
        prefixIcon: const Icon(Icons.account_circle_outlined),
      ),
      items: items,
      onChanged: !enabled
          ? null
          : (value) {
              if (value == defaultValue || value == null) {
                onChanged(null);
                return;
              }
              onChanged(
                accounts.firstWhere((account) => idOf(account) == value),
              );
            },
    );
  }
}
