part of 'platform_binding_dialog.dart';

enum _ProviderUnbindPhase { confirming, submitting }

Future<bool?> _confirmProviderUnbind(
  BuildContext context,
  String providerLabel,
  _ProviderBindItem item,
) {
  var completed = false;
  return showAppDialog<bool>(
    context: context,
    builder: (dialogContext) {
      void finish(bool result) {
        if (completed ||
            !dialogContext.mounted ||
            ModalRoute.of(dialogContext)?.isCurrent != true) {
          return;
        }
        completed = true;
        Navigator.of(dialogContext).pop(result);
      }

      return AppDialog(
        constraints: const BoxConstraints(maxWidth: 520),
        title: Text(
          dialogContext.l10n.confirmUnbind,
          style: Theme.of(dialogContext).textTheme.titleMedium,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(dialogContext.l10n.confirmUnbindProvider(providerLabel)),
            const SizedBox(height: 16),
            _AccountInfoView(
              rows: [
                if (item.title.isNotEmpty || item.subtitle.isNotEmpty)
                  (
                    dialogContext.l10n.accountInformation,
                    {
                      if (item.title.isNotEmpty) item.title,
                      if (item.subtitle.isNotEmpty) item.subtitle,
                    }.join('\n'),
                  ),
                (
                  dialogContext.l10n.server,
                  item.serverId.isNotEmpty ? item.serverId : item.id,
                ),
                (
                  dialogContext.l10n.instance,
                  _providerInstanceLabel(
                    item.instanceName,
                    dialogContext.l10n.localInstance,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          AppActionButton(
            onPressed: () => finish(false),
            label: dialogContext.l10n.cancel,
            wrapLabel: true,
            style: AppActionButtonStyle.outlined,
          ),
          AppActionButton(
            onPressed: () => finish(true),
            label: dialogContext.l10n.unbind,
            icon: Icons.link_off_rounded,
            wrapLabel: true,
            style: AppActionButtonStyle.destructive,
          ),
        ],
      );
    },
  );
}

Future<void> _unbindProviderAccount(
  ProviderGateway providerGateway,
  _ProviderKind kind,
  _ProviderBindItem item,
) async {
  switch (kind) {
    case _ProviderKind.alist:
      await providerGateway.logoutAList(item.serverId);
    case _ProviderKind.emby:
      await providerGateway.logoutEmby(item.serverId);
    case _ProviderKind.cloudreve:
      await providerGateway.logoutCloudreve(item.serverId);
    case _ProviderKind.bilibili:
      await providerGateway.logoutBilibili();
    case _ProviderKind.twitch:
      await providerGateway.unbindTwitch(item.serverId);
    case _ProviderKind.fnos:
      await providerGateway.logoutFnos(item.serverId);
    case _ProviderKind.qnap:
      await providerGateway.logoutQnap(item.serverId);
    case _ProviderKind.synology:
      await providerGateway.logoutSynology(item.serverId);
    case _ProviderKind.nextcloud:
      await providerGateway.logoutNextcloud(item.serverId);
    case _ProviderKind.seafile:
      await providerGateway.logoutSeafile(item.serverId);
    case _ProviderKind.truenas:
      await providerGateway.logoutTrueNas(item.serverId);
    case _ProviderKind.youtube:
      await providerGateway.unbindYoutube(item.serverId);
    case _ProviderKind.douyin:
      await providerGateway.unbindDouyin(item.serverId);
    case _ProviderKind.tiktok:
      await providerGateway.unbindTikTok(item.serverId);
  }
}
