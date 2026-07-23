import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/services/p2p_media_preferences.dart';
import 'package:synctv_app/widgets/app_form_controls.dart';

class P2pMediaSettingsFields extends StatelessWidget {
  const P2pMediaSettingsFields({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: P2pMediaPreferences.enabled,
      builder: (context, enabled, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppSwitchTile(
              title: Text(context.l10n.p2pMedia),
              subtitle: Text(context.l10n.p2pMediaDescription),
              value: enabled,
              onChanged: (value) {
                unawaited(P2pMediaPreferences.setEnabled(value));
              },
            ),
            if (enabled)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: ValueListenableBuilder<int>(
                  valueListenable: P2pMediaPreferences.cacheSizeMiB,
                  builder: (context, cacheSizeMiB, _) {
                    return AppSelect<int>(
                      value: cacheSizeMiB,
                      label: context.l10n.p2pCacheSize,
                      description: context.l10n.p2pCacheSizeDescription,
                      prefixIcon: Icons.storage_outlined,
                      options: {
                        for (final size
                            in P2pMediaPreferences.cacheSizeOptionsMiB)
                          '$size MiB': size,
                      },
                      onChanged: (value) {
                        if (value != null) {
                          unawaited(P2pMediaPreferences.setCacheSizeMiB(value));
                        }
                      },
                    );
                  },
                ),
              ),
            if (enabled)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: ValueListenableBuilder<P2pMediaSecurityMode>(
                  valueListenable: P2pMediaPreferences.securityMode,
                  builder: (context, mode, _) {
                    return AppSelect<P2pMediaSecurityMode>(
                      value: mode,
                      label: context.l10n.p2pSecurityMode,
                      description: mode == P2pMediaSecurityMode.sampledOrigin
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
                          unawaited(P2pMediaPreferences.setSecurityMode(value));
                        }
                      },
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
