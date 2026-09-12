part of 'platform_binding_dialog.dart';

class _ProviderAccountInfoDialog extends StatefulWidget {
  final String title;
  final Future<List<(String, String)>> Function() loadRows;

  const _ProviderAccountInfoDialog({
    required this.title,
    required this.loadRows,
  });

  @override
  State<_ProviderAccountInfoDialog> createState() =>
      _ProviderAccountInfoDialogState();
}

class _ProviderAccountInfoDialogState
    extends State<_ProviderAccountInfoDialog> {
  late Future<List<(String, String)>> _rows;

  bool get _isCurrent => mounted && ModalRoute.of(context)?.isCurrent == true;

  @override
  void initState() {
    super.initState();
    _rows = Future.sync(widget.loadRows);
  }

  void _retry(Future<List<(String, String)>> failedRequest) {
    if (!_isCurrent || _rows != failedRequest) return;
    setState(() {
      _rows = Future.sync(widget.loadRows);
    });
  }

  void _close() {
    if (_isCurrent) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final request = _rows;
    return FutureBuilder<List<(String, String)>>(
      future: request,
      builder: (context, snapshot) {
        final loading = snapshot.connectionState != ConnectionState.done;
        return AppDialog(
          constraints: const BoxConstraints(maxWidth: 520),
          title: Text(
            widget.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          body: SizedBox(
            width: 520,
            child: loading
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppLoadingIndicator(),
                      const SizedBox(height: 12),
                      Text(context.l10n.loading),
                    ],
                  )
                : snapshot.hasError
                ? Text(context.l10n.loadDetailsFailed('${snapshot.error}'))
                : _AccountInfoView(rows: snapshot.data ?? const []),
          ),
          actions: [
            AppActionButton(
              onPressed: _close,
              label: context.l10n.close,
              wrapLabel: true,
              style: AppActionButtonStyle.outlined,
            ),
            if (!loading && snapshot.hasError)
              AppActionButton(
                onPressed: () => _retry(request),
                icon: Icons.refresh_rounded,
                label: context.l10n.retry,
                wrapLabel: true,
              ),
          ],
        );
      },
    );
  }
}

class _AccountInfoView extends StatelessWidget {
  final List<(String, String)> rows;

  const _AccountInfoView({required this.rows});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < rows.length; index++) ...[
          if (index > 0) const SizedBox(height: 16),
          Text(
            rows[index].$1,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          AppSelectableText(
            rows[index].$2.isEmpty ? '-' : rows[index].$2,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

Future<List<(String, String)>> _loadProviderAccountRows(
  ProviderGateway providerGateway,
  AppLocalizations l10n,
  _ProviderKind kind,
  _ProviderBindItem item,
) async {
  switch (kind) {
    case _ProviderKind.alist:
      final info = await providerGateway.getAlistAccount(
        item.serverId,
        instanceName: item.instanceName,
      );
      return [
        (l10n.username, info.username),
        (l10n.rootDirectory, info.basePath),
        (l10n.server, item.serverId),
        (
          l10n.instance,
          _providerInstanceLabel(item.instanceName, l10n.localInstance),
        ),
      ];
    case _ProviderKind.emby:
      final info = await providerGateway.getEmbyAccount(
        item.serverId,
        instanceName: item.instanceName,
      );
      return [
        (l10n.username, info.name),
        (l10n.userId, info.id),
        (l10n.server, item.serverId),
        (
          l10n.instance,
          _providerInstanceLabel(item.instanceName, l10n.localInstance),
        ),
      ];
    case _ProviderKind.cloudreve:
      final info = await providerGateway.getCloudreveAccount(
        item.serverId,
        instanceName: item.instanceName,
      );
      return [
        (l10n.username, info.nickname),
        ('Email', info.email),
        (l10n.userId, info.id),
        (l10n.server, item.serverId),
        (
          l10n.instance,
          _providerInstanceLabel(item.instanceName, l10n.localInstance),
        ),
      ];
    case _ProviderKind.bilibili:
      final info = await providerGateway.getBilibiliAccount(
        instanceName: item.instanceName,
      );
      return [
        (l10n.loginStatus, info.isLogin ? l10n.loggedIn : l10n.loggedOutStatus),
        (l10n.username, info.username),
        (l10n.bilibiliVip, info.isVip ? l10n.yes : l10n.no),
        (l10n.server, item.serverId),
        (
          l10n.instance,
          _providerInstanceLabel(item.instanceName, l10n.localInstance),
        ),
      ];
    case _ProviderKind.twitch:
      return [
        (l10n.username, item.title),
        (l10n.userId, item.subtitle),
        (l10n.server, item.serverId),
        (
          l10n.instance,
          _providerInstanceLabel(item.instanceName, l10n.localInstance),
        ),
      ];
    case _ProviderKind.fnos:
      return [
        (l10n.server, item.title),
        (l10n.username, item.subtitle),
        (
          l10n.instance,
          _providerInstanceLabel(item.instanceName, l10n.localInstance),
        ),
      ];
    case _ProviderKind.qnap:
      final capabilities = await providerGateway.getQnapCapabilities(
        item.serverId,
        instanceName: item.instanceName,
      );
      return [
        (l10n.server, item.title),
        (l10n.username, item.subtitle),
        ('Real-time transcoding', capabilities.supportRtt ? l10n.yes : l10n.no),
        (
          'Hardware transcoding',
          capabilities.hardwareTranscode ? l10n.yes : l10n.no,
        ),
        ('QTranscode', capabilities.qtranscode ? l10n.yes : l10n.no),
        ('Multimedia Codec', capabilities.multimediaCodec ? l10n.yes : l10n.no),
        ('HD Station', capabilities.hdStationSupport ? l10n.yes : l10n.no),
        (
          l10n.instance,
          _providerInstanceLabel(item.instanceName, l10n.localInstance),
        ),
      ];
    case _ProviderKind.synology:
      return [
        (l10n.server, item.title),
        (l10n.username, item.subtitle),
        (
          l10n.instance,
          _providerInstanceLabel(item.instanceName, l10n.localInstance),
        ),
      ];
    case _ProviderKind.nextcloud:
      final binds = await providerGateway.getAllNextcloudBindInfos();
      final bind = binds.firstWhere(
        (candidate) =>
            candidate.serverId == item.serverId &&
            candidate.providerInstanceName == item.instanceName,
      );
      return [
        (l10n.server, bind.endpoint),
        (l10n.username, bind.username),
        if (bind.userId.isNotEmpty) (l10n.userId, bind.userId),
        if (bind.version.isNotEmpty) ('Version', bind.version),
        if (bind.edition.isNotEmpty) ('Edition', bind.edition),
        (
          l10n.instance,
          _providerInstanceLabel(item.instanceName, l10n.localInstance),
        ),
      ];
    case _ProviderKind.seafile:
      final binds = await providerGateway.getAllSeafileBindInfos();
      final bind = binds.firstWhere(
        (candidate) =>
            candidate.serverId == item.serverId &&
            candidate.providerInstanceName == item.instanceName,
      );
      return [
        (l10n.server, bind.endpoint),
        (l10n.username, bind.username),
        if (bind.version.isNotEmpty) ('Version', bind.version),
        if (bind.features.isNotEmpty) ('Features', bind.features.join(', ')),
        (
          l10n.instance,
          _providerInstanceLabel(item.instanceName, l10n.localInstance),
        ),
      ];
    case _ProviderKind.truenas:
      final binds = await providerGateway.getAllTrueNasBindInfos();
      final bind = binds.firstWhere(
        (candidate) =>
            candidate.serverId == item.serverId &&
            candidate.providerInstanceName == item.instanceName,
      );
      return [
        (l10n.server, bind.endpoint),
        ('Hostname', bind.hostname),
        if (bind.version.isNotEmpty) ('Version', bind.version),
        if (bind.systemProduct.isNotEmpty) ('System', bind.systemProduct),
        (
          l10n.instance,
          _providerInstanceLabel(item.instanceName, l10n.localInstance),
        ),
      ];
    case _ProviderKind.youtube:
      final binds = await providerGateway.getAllYoutubeBindInfos();
      final bind = binds.firstWhere(
        (candidate) =>
            candidate.serverId == item.serverId &&
            candidate.providerInstanceName == item.instanceName,
      );
      return [
        ('Label', bind.label),
        ('Visitor Data', bind.hasVisitorData ? 'Configured' : 'Empty'),
        ('PO Token', bind.hasPoToken ? 'Configured' : 'Empty'),
        ('Cookie', bind.hasCookie ? 'Configured' : 'Empty'),
        (
          l10n.instance,
          _providerInstanceLabel(item.instanceName, l10n.localInstance),
        ),
      ];
    case _ProviderKind.douyin:
      final binds = await providerGateway.getAllDouyinBindInfos();
      final bind = binds.firstWhere(
        (candidate) =>
            candidate.serverId == item.serverId &&
            candidate.providerInstanceName == item.instanceName,
      );
      return [
        ('Label', bind.label),
        ('Cookie', bind.hasCookie ? 'Configured' : 'Empty'),
        (
          l10n.instance,
          _providerInstanceLabel(item.instanceName, l10n.localInstance),
        ),
      ];
    case _ProviderKind.tiktok:
      final binds = await providerGateway.getAllTikTokBindInfos();
      final bind = binds.firstWhere(
        (candidate) =>
            candidate.serverId == item.serverId &&
            candidate.providerInstanceName == item.instanceName,
      );
      return [
        ('Label', bind.label),
        ('Cookie', bind.hasCookie ? 'Configured' : 'Empty'),
        (
          l10n.instance,
          _providerInstanceLabel(item.instanceName, l10n.localInstance),
        ),
      ];
  }
}
