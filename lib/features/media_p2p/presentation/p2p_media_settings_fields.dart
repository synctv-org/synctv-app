import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/media_p2p/application/p2p_media_preferences_controller.dart';
import 'package:synctv_app/features/media_p2p/domain/p2p_media_preferences.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class P2pMediaSettingsFields extends StatelessWidget {
  const P2pMediaSettingsFields({super.key, required this.preferences});

  final P2pMediaPreferencesController preferences;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: preferences,
      builder: (context, _) {
        final enabled = preferences.enabled;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSwitchTile(
              title: Text(context.l10n.p2pMedia),
              subtitle: Text(context.l10n.p2pMediaDescription),
              value: enabled,
              onChanged: (value) {
                unawaited(preferences.setEnabled(value));
              },
            ),
            if (enabled)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: AppSelect<int>(
                  value: preferences.cacheSizeMiB,
                  label: context.l10n.p2pCacheSize,
                  description: context.l10n.p2pCacheSizeDescription,
                  prefixIcon: Icons.storage_outlined,
                  options: {
                    for (final size
                        in P2pMediaPreferenceValues.cacheSizeOptionsMiB)
                      '$size MiB': size,
                  },
                  onChanged: (value) {
                    if (value != null) {
                      unawaited(preferences.setCacheSizeMiB(value));
                    }
                  },
                ),
              ),
            if (enabled)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: AppSelect<P2pMediaSecurityMode>(
                  value: preferences.securityMode,
                  label: context.l10n.p2pSecurityMode,
                  description:
                      preferences.securityMode ==
                          P2pMediaSecurityMode.sampledOrigin
                      ? context.l10n.p2pSecuritySampledDescription
                      : context.l10n.p2pSecurityStandardDescription,
                  prefixIcon: Icons.verified_user_outlined,
                  options: {
                    context.l10n.p2pSecurityStandard:
                        P2pMediaSecurityMode.standard,
                    context.l10n.p2pSecuritySampled:
                        P2pMediaSecurityMode.sampledOrigin,
                  },
                  onChanged: (value) {
                    if (value != null) {
                      unawaited(preferences.setSecurityMode(value));
                    }
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
