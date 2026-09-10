import 'package:flutter/material.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_account_action.dart';
import 'package:synctv_app/l10n/l10n.dart';

class ProviderInstanceSelector extends StatelessWidget {
  const ProviderInstanceSelector({
    super.key,
    required this.instances,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final List<String> instances;
  final String value;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) => ProviderAccountSelector<String>(
    accounts: instances,
    selectedId: value,
    idOf: (instance) => instance,
    labelOf: (instance) => instance,
    includeDefault: true,
    enabled: enabled,
    label: context.l10n.providerInstance,
    defaultLabel: context.l10n.defaultProviderInstance,
    prefixIcon: Icons.dns_outlined,
    onChanged: (instance) => onChanged(instance ?? ''),
  );
}
