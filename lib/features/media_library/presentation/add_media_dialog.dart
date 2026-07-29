import 'dart:async';

import 'package:flutter/services.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/core/config/distribution_profile.dart';
import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/acfun_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/bilibili_playlist_preview.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/bilibili_playlist_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/cctv_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/douyin_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/douyu_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/emby_playlist_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/fnos_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/huya_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/nextcloud_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/qnap_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/seafile_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/tiktok_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/twitch_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/truenas_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/youtube_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/synology_add_media_form.dart';
import 'package:synctv_app/features/providers/presentation/binding/platform_binding_dialog.dart';

class AddMediaDialog extends StatefulWidget {
  final String roomId;
  final String? parentId;
  final ProviderDistributionPolicy distributionPolicy;

  const AddMediaDialog({
    super.key,
    required this.roomId,
    this.parentId,
    this.distributionPolicy = ProviderDistributionPolicy.current,
  });

  static Future<void> show(
    BuildContext context,
    String roomId, {
    String? parentId,
  }) {
    final dialogKey = GlobalKey<_AddMediaDialogState>();
    return showAppDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AppDialogFrame(
          maxWidth: 920,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AddMediaDialogHeader(
                onClose: () => dialogKey.currentState?._requestClose(),
              ),
              Flexible(
                child: AddMediaDialog(
                  key: dialogKey,
                  roomId: roomId,
                  parentId: parentId,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  State<AddMediaDialog> createState() => _AddMediaDialogState();
}

class _AddMediaDialogHeader extends StatelessWidget {
  const _AddMediaDialogHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppPanelSurface(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.94),
      borderRadius: BorderRadius.zero,
      border: Border(
        bottom: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        children: [
          AppIconBadge(
            icon: Icons.add_to_queue_rounded,
            color: theme.colorScheme.primary,
            iconColor: theme.colorScheme.onPrimaryContainer,
            backgroundColor: theme.colorScheme.primaryContainer,
            size: 36,
            borderRadius: BorderRadius.circular(8),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.addMedia,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          AppIconButton(
            onPressed: onClose,
            icon: Icons.close_rounded,
            tooltip: context.l10n.close,
          ),
        ],
      ),
    );
  }
}

class _MediaSourceSpec {
  const _MediaSourceSpec({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final int index;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

class _DirectHeaderDraft {
  _DirectHeaderDraft({String name = '', String value = ''})
    : key = UniqueKey(),
      nameController = TextEditingController(text: name),
      valueController = TextEditingController(text: value);

  final Key key;
  final TextEditingController nameController;
  final TextEditingController valueController;

  void dispose() {
    nameController.dispose();
    valueController.dispose();
  }
}

class _AddMediaDialogState extends State<AddMediaDialog> {
  int _selectedIndex = 0;

  final _urlController = TextEditingController();
  final _urlFocusNode = FocusNode();
  final _nameController = TextEditingController();
  final _liveProxyUrlController = TextEditingController();
  final _liveProxyNameController = TextEditingController();
  final _biliUrlController = TextEditingController();
  final _alistSearchController = TextEditingController();
  final _alistPasswordController = TextEditingController();
  final _embySearchController = TextEditingController();
  final _cloudreveSearchController = TextEditingController();

  bool _preferProxy = false;
  bool _proxyOnly = false;
  bool _isLoading = false;
  String _directHeaderError = '';

  BilibiliParseInfo? _biliInfo;
  int _biliSelectedIndex = 0;
  bool _bilibiliShared = false;
  RoomMediaLibraryPage? _biliPreview;

  String _alistPath = '/';
  List<AlistItemInfo> _alistFiles = [];
  bool _alistLoading = false;
  int _alistPage = 1;
  bool _alistHasMore = true;
  String _alistServerId = '';
  String _alistInstanceName = '';
  String _alistKeyword = '';
  String _alistPassword = '';
  List<AlistBindInfo> _alistBinds = [];
  static const int _pageSize = 20;
  final Map<String, AlistItemInfo> _selectedAlistItems = {};
  final List<_DirectHeaderDraft> _directHeaders = [];

  String _embyPath = '';
  List<EmbyItemInfo> _embyFiles = [];
  bool _embyLoading = false;
  int _embyPage = 1;
  bool _embyHasMore = true;
  String _embyServerId = '';
  String _embyInstanceName = '';
  String _embyKeyword = '';
  List<EmbyBindInfo> _embyBinds = [];
  bool _embyPlaylistMode = false;
  bool _embyPlaylistHasDraft = false;

  String _cloudrevePath = 'cloudreve://my/';
  List<CloudreveItemInfo> _cloudreveFiles = [];
  bool _cloudreveLoading = false;
  int _cloudrevePage = 1;
  bool _cloudreveUsesCursor = false;
  String _cloudreveNextCursor = '';
  bool _cloudreveHasMore = true;
  String _cloudreveServerId = '';
  String _cloudreveInstanceName = '';
  String _cloudreveKeyword = '';
  List<CloudreveBindInfo> _cloudreveBinds = [];

  List<TwitchBindInfo> _twitchBinds = [];
  bool _twitchHasDraft = false;
  List<FnosBindInfo> _fnosBinds = [];
  bool _fnosHasDraft = false;
  List<QnapBindInfo> _qnapBinds = [];
  bool _qnapHasDraft = false;
  List<SynologyBindInfo> _synologyBinds = [];
  bool _synologyHasDraft = false;
  List<NextcloudBindInfo> _nextcloudBinds = [];
  bool _nextcloudHasDraft = false;
  List<SeafileBindInfo> _seafileBinds = [];
  bool _seafileHasDraft = false;
  List<TrueNasBindInfo> _trueNasBinds = [];
  bool _trueNasHasDraft = false;
  List<YoutubeBindInfo> _youtubeBinds = [];
  bool _youtubeHasDraft = false;
  List<DouyinBindInfo> _douyinBinds = [];
  bool _douyinHasDraft = false;
  List<TikTokBindInfo> _tiktokBinds = [];
  bool _tiktokHasDraft = false;
  List<String> _huyaInstances = const [''];
  bool _huyaHasDraft = false;
  List<String> _douyuInstances = const [''];
  bool _douyuHasDraft = false;
  List<String> _acfunInstances = const [''];
  bool _acfunHasDraft = false;
  List<String> _cctvInstances = const [''];
  bool _cctvHasDraft = false;

  String _bilibiliInstanceName = '';
  List<BilibiliBindInfo> _bilibiliBinds = [];
  bool _bilibiliPlaylistMode = false;
  bool _bilibiliPlaylistHasDraft = false;

  List<String> _boundVendors = [];
  bool _checkingVendors = true;
  PublicSettingsInfo? _publicSettings;
  bool _dependenciesInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _selectedIndex == 0) {
        _urlFocusNode.requestFocus();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dependenciesInitialized) return;
    _dependenciesInitialized = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(_checkVendors());
    });
  }

  Future<void> _checkVendors() async {
    if (!widget.distributionPolicy.includesThirdPartyProviders) {
      await _checkUserOwnedVendors();
      return;
    }
    try {
      final results = await Future.wait([
        providerGateway.getAllAlistBindInfos(),
        providerGateway.getAllEmbyBindInfos(),
        providerGateway.getAllBilibiliBindInfos(),
        providerGateway.getAllCloudreveBindInfos(),
        providerGateway.getAllTwitchBindInfos(),
        providerGateway.getAllFnosBindInfos(),
        providerGateway.getAllQnapBindInfos(),
        providerGateway.listAvailableProviderInstances(providerType: 'huya'),
        providerGateway.listAvailableProviderInstances(providerType: 'douyu'),
        providerGateway.listAvailableProviderInstances(providerType: 'acfun'),
        providerGateway.listAvailableProviderInstances(providerType: 'cctv'),
        providerGateway.getPublicSettings(),
        providerGateway.getAllSynologyBindInfos(),
        providerGateway.getAllNextcloudBindInfos(),
        providerGateway.getAllSeafileBindInfos(),
        providerGateway.getAllTrueNasBindInfos(),
        providerGateway.getAllYoutubeBindInfos(),
        providerGateway.getAllDouyinBindInfos(),
        providerGateway.getAllTikTokBindInfos(),
      ]);
      final alistBinds = results[0] as List<AlistBindInfo>;
      final embyBinds = results[1] as List<EmbyBindInfo>;
      final bilibiliBinds = results[2] as List<BilibiliBindInfo>;
      final cloudreveBinds = results[3] as List<CloudreveBindInfo>;
      final twitchBinds = results[4] as List<TwitchBindInfo>;
      final fnosBinds = results[5] as List<FnosBindInfo>;
      final qnapBinds = results[6] as List<QnapBindInfo>;
      final huyaInstances = results[7] as List<String>;
      final douyuInstances = results[8] as List<String>;
      final acfunInstances = results[9] as List<String>;
      final cctvInstances = results[10] as List<String>;
      final publicSettings = results[11] as PublicSettingsInfo;
      final synologyBinds = results[12] as List<SynologyBindInfo>;
      final nextcloudBinds = results[13] as List<NextcloudBindInfo>;
      final seafileBinds = results[14] as List<SeafileBindInfo>;
      final trueNasBinds = results[15] as List<TrueNasBindInfo>;
      final youtubeBinds = results[16] as List<YoutubeBindInfo>;
      final douyinBinds = results[17] as List<DouyinBindInfo>;
      final tiktokBinds = results[18] as List<TikTokBindInfo>;
      if (!mounted) return;
      setState(() {
        _alistBinds = alistBinds;
        _embyBinds = embyBinds;
        _bilibiliBinds = bilibiliBinds;
        _cloudreveBinds = cloudreveBinds;
        _twitchBinds = twitchBinds;
        _fnosBinds = fnosBinds;
        _qnapBinds = qnapBinds;
        _synologyBinds = synologyBinds;
        _nextcloudBinds = nextcloudBinds;
        _seafileBinds = seafileBinds;
        _trueNasBinds = trueNasBinds;
        _youtubeBinds = youtubeBinds;
        _douyinBinds = douyinBinds;
        _tiktokBinds = tiktokBinds;
        _huyaInstances = {'', ...huyaInstances}.toList();
        _douyuInstances = {'', ...douyuInstances}.toList();
        _acfunInstances = {'', ...acfunInstances}.toList();
        _cctvInstances = {'', ...cctvInstances}.toList();
        _publicSettings = publicSettings;
        _boundVendors = [
          if (alistBinds.isNotEmpty) 'alist',
          if (embyBinds.isNotEmpty) 'emby',
          if (bilibiliBinds.isNotEmpty) 'bilibili',
          if (cloudreveBinds.isNotEmpty) 'cloudreve',
          if (twitchBinds.isNotEmpty) 'twitch',
          if (fnosBinds.isNotEmpty) 'fnos',
          if (qnapBinds.isNotEmpty) 'qnap',
          if (synologyBinds.isNotEmpty) 'synology',
          if (nextcloudBinds.isNotEmpty) 'nextcloud',
          if (seafileBinds.isNotEmpty) 'seafile',
          if (trueNasBinds.isNotEmpty) 'truenas',
          if (youtubeBinds.isNotEmpty) 'youtube',
          if (douyinBinds.isNotEmpty) 'douyin',
          if (tiktokBinds.isNotEmpty) 'tiktok',
        ];
        _applyDefaultProviderBindings();
        _checkingVendors = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _checkingVendors = false);
      AppNotifications.showError(
        context,
        context.l10n.loadMediaBindingsFailed('$e'),
      );
    }
  }

  Future<void> _checkUserOwnedVendors() async {
    try {
      final results = await Future.wait([
        providerGateway.getAllAlistBindInfos(),
        providerGateway.getAllEmbyBindInfos(),
        providerGateway.getAllCloudreveBindInfos(),
        providerGateway.getAllFnosBindInfos(),
        providerGateway.getAllQnapBindInfos(),
        providerGateway.getPublicSettings(),
        providerGateway.getAllSynologyBindInfos(),
        providerGateway.getAllNextcloudBindInfos(),
        providerGateway.getAllSeafileBindInfos(),
        providerGateway.getAllTrueNasBindInfos(),
      ]);
      final alistBinds = results[0] as List<AlistBindInfo>;
      final embyBinds = results[1] as List<EmbyBindInfo>;
      final cloudreveBinds = results[2] as List<CloudreveBindInfo>;
      final fnosBinds = results[3] as List<FnosBindInfo>;
      final qnapBinds = results[4] as List<QnapBindInfo>;
      final publicSettings = results[5] as PublicSettingsInfo;
      final synologyBinds = results[6] as List<SynologyBindInfo>;
      final nextcloudBinds = results[7] as List<NextcloudBindInfo>;
      final seafileBinds = results[8] as List<SeafileBindInfo>;
      final trueNasBinds = results[9] as List<TrueNasBindInfo>;
      if (!mounted) return;
      setState(() {
        _alistBinds = alistBinds;
        _embyBinds = embyBinds;
        _cloudreveBinds = cloudreveBinds;
        _fnosBinds = fnosBinds;
        _qnapBinds = qnapBinds;
        _synologyBinds = synologyBinds;
        _nextcloudBinds = nextcloudBinds;
        _seafileBinds = seafileBinds;
        _trueNasBinds = trueNasBinds;
        _publicSettings = publicSettings;
        _boundVendors = [
          if (alistBinds.isNotEmpty) 'alist',
          if (embyBinds.isNotEmpty) 'emby',
          if (cloudreveBinds.isNotEmpty) 'cloudreve',
          if (fnosBinds.isNotEmpty) 'fnos',
          if (qnapBinds.isNotEmpty) 'qnap',
          if (synologyBinds.isNotEmpty) 'synology',
          if (nextcloudBinds.isNotEmpty) 'nextcloud',
          if (seafileBinds.isNotEmpty) 'seafile',
          if (trueNasBinds.isNotEmpty) 'truenas',
        ];
        _applyDefaultProviderBindings();
        _checkingVendors = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _checkingVendors = false);
      AppNotifications.showError(
        context,
        context.l10n.loadMediaBindingsFailed('$e'),
      );
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _urlFocusNode.dispose();
    _nameController.dispose();
    _liveProxyUrlController.dispose();
    _liveProxyNameController.dispose();
    for (final header in _directHeaders) {
      header.dispose();
    }
    _biliUrlController.dispose();
    _alistSearchController.dispose();
    _alistPasswordController.dispose();
    _embySearchController.dispose();
    _cloudreveSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compact = AppBreakpoints.widthOf(context) < 720;
    final availableHeight = AppMetrics.dialogMaxHeight(context, null);
    final contentHeight = compact
        ? (availableHeight - 84).clamp(500.0, 660.0)
        : (availableHeight - 84).clamp(460.0, 660.0);

    return PopScope(
      canPop: !_hasUnsavedDraft,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (!context.mounted) return;
        final confirmed = await _confirmDiscardDraft();
        if (!mounted || !confirmed) return;
        Navigator.of(this.context).pop();
      },
      child: SizedBox(
        height: contentHeight,
        child: compact
            ? Column(
                children: [
                  _buildCompactSourceRail(theme),
                  Expanded(child: _buildSourcePanel(theme, compact: true)),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(width: 236, child: _buildSourceRail(theme)),
                  AppVerticalDivider(
                    width: 1,
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.7,
                    ),
                  ),
                  Expanded(child: _buildSourcePanel(theme)),
                ],
              ),
      ),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return context.l10n.directLink;
      case 1:
        return context.l10n.rtmpPublishing;
      case 2:
        return context.l10n.livePull;
      case 3:
        return 'Bilibili';
      case 4:
        return context.l10n.alistStorage;
      case 5:
        return context.l10n.embyLibrary;
      case 6:
        return 'Cloudreve';
      case 7:
        return 'Twitch';
      case 8:
        return 'Huya';
      case 9:
        return 'Douyu';
      case 10:
        return 'AcFun';
      case 11:
        return 'CCTV';
      case 12:
        return 'FNOS';
      case 13:
        return 'QNAP';
      case 14:
        return 'Synology DSM';
      case 15:
        return 'Nextcloud';
      case 16:
        return 'Seafile';
      case 17:
        return 'TrueNAS';
      case 18:
        return 'YouTube';
      case 19:
        return 'Douyin';
      case 20:
        return 'TikTok';
      default:
        return '';
    }
  }

  List<_MediaSourceSpec> get _sourceSpecs =>
      <_MediaSourceSpec>[
            _MediaSourceSpec(
              index: 0,
              title: context.l10n.directLink,
              subtitle: 'HTTP / HTTPS / HLS',
              icon: Icons.link_rounded,
              color: const Color(0xFF5D5FEF),
            ),
            _MediaSourceSpec(
              index: 1,
              title: context.l10n.rtmpPublishing,
              subtitle: context.l10n.generatePublishingAddress,
              icon: Icons.upload_rounded,
              color: Colors.deepOrange.shade600,
            ),
            _MediaSourceSpec(
              index: 2,
              title: context.l10n.livePull,
              subtitle: 'RTMP / HTTP-FLV',
              icon: Icons.sensors_rounded,
              color: Colors.teal.shade600,
            ),
            _MediaSourceSpec(
              index: 3,
              title: 'Bilibili',
              subtitle: context.l10n.bilibiliLinkParsing,
              icon: Icons.tv_rounded,
              color: const Color(0xFFFB7299),
            ),
            _MediaSourceSpec(
              index: 4,
              title: context.l10n.alistStorage,
              subtitle: context.l10n.mountedDirectoryResources,
              icon: Icons.cloud_circle_rounded,
              color: Colors.amber.shade700,
            ),
            _MediaSourceSpec(
              index: 5,
              title: context.l10n.embyLibrary,
              subtitle: context.l10n.personalMediaServer,
              icon: Icons.video_library_rounded,
              color: Colors.green.shade600,
            ),
            _MediaSourceSpec(
              index: 6,
              title: 'Cloudreve',
              subtitle: 'Cloudreve v4',
              icon: Icons.cloud_rounded,
              color: Colors.teal.shade600,
            ),
            const _MediaSourceSpec(
              index: 7,
              title: 'Twitch',
              subtitle: 'Live / VOD / Clip',
              icon: Icons.live_tv_rounded,
              color: Color(0xFF9146FF),
            ),
            const _MediaSourceSpec(
              index: 8,
              title: 'Huya',
              subtitle: 'Live / Video',
              icon: Icons.sports_esports_rounded,
              color: Color(0xFFFF7A00),
            ),
            const _MediaSourceSpec(
              index: 9,
              title: 'Douyu',
              subtitle: 'Live / HEVC / Audio',
              icon: Icons.live_tv_rounded,
              color: Color(0xFFFF5D23),
            ),
            const _MediaSourceSpec(
              index: 10,
              title: 'AcFun',
              subtitle: 'acfun.cn',
              icon: Icons.ondemand_video_rounded,
              color: Color(0xFFFD4C5B),
            ),
            const _MediaSourceSpec(
              index: 11,
              title: 'CCTV',
              subtitle: 'cctv.com / cntv.cn',
              icon: Icons.tv_rounded,
              color: Color(0xFFC62828),
            ),
            const _MediaSourceSpec(
              index: 12,
              title: 'FNOS',
              subtitle: 'Files / Media Library',
              icon: Icons.storage_rounded,
              color: Color(0xFF087F5B),
            ),
            const _MediaSourceSpec(
              index: 13,
              title: 'QNAP',
              subtitle: 'QTS / QuTS hero',
              icon: Icons.storage_rounded,
              color: Color(0xFF0076A8),
            ),
            const _MediaSourceSpec(
              index: 14,
              title: 'Synology DSM',
              subtitle: 'File Station / Video Station',
              icon: Icons.video_library_rounded,
              color: Color(0xFF1578D3),
            ),
            const _MediaSourceSpec(
              index: 15,
              title: 'Nextcloud',
              subtitle: 'Files / Favorites / Search',
              icon: Icons.cloud_outlined,
              color: Color(0xFF0082C9),
            ),
            const _MediaSourceSpec(
              index: 16,
              title: 'Seafile',
              subtitle: 'Libraries / Starred / Search',
              icon: Icons.cloud_queue_rounded,
              color: Color(0xFFED7109),
            ),
            const _MediaSourceSpec(
              index: 17,
              title: 'TrueNAS',
              subtitle: 'ZFS / Filesystem',
              icon: Icons.dns_rounded,
              color: Color(0xFF0095D5),
            ),
            const _MediaSourceSpec(
              index: 18,
              title: 'YouTube',
              subtitle: 'Video / Playlist / Channel / Search',
              icon: Icons.smart_display_rounded,
              color: Color(0xFFFF0033),
            ),
            const _MediaSourceSpec(
              index: 19,
              title: 'Douyin',
              subtitle: 'Video / Live / User Posts',
              icon: Icons.music_video_rounded,
              color: Color(0xFF00AFA7),
            ),
            const _MediaSourceSpec(
              index: 20,
              title: 'TikTok',
              subtitle: 'Video / Live / User Posts',
              icon: Icons.music_video_rounded,
              color: Color(0xFFFE2C55),
            ),
          ]
          .where((spec) {
            final providerType = _providerTypeForSourceIndex(spec.index);
            return providerType == null ||
                widget.distributionPolicy.allowsProvider(providerType);
          })
          .toList(growable: false);

  void _selectSource(int index) {
    final providerType = _providerTypeForSourceIndex(index);
    if (providerType != null &&
        !widget.distributionPolicy.allowsProvider(providerType)) {
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _urlFocusNode.requestFocus();
      });
    }
    if (index == 4 && _alistBinds.isNotEmpty && _alistFiles.isEmpty) {
      _loadAlist('/');
    }
    if (index == 5 && _embyBinds.isNotEmpty && _embyFiles.isEmpty) {
      _loadEmby('');
    }
    if (index == 6 && _cloudreveBinds.isNotEmpty && _cloudreveFiles.isEmpty) {
      _loadCloudreve(_cloudrevePath);
    }
  }

  Widget _buildSourceRail(ThemeData theme) {
    return AppPanelSurface(
      color: theme.colorScheme.surfaceContainerLow,
      padding: const EdgeInsets.all(12),
      borderRadius: BorderRadius.zero,
      clipBehavior: Clip.none,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.source,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: AppListView.separated(
              padding: EdgeInsets.zero,
              itemCount: _sourceSpecs.length,
              separatorBuilder: (_, _) => const SizedBox(height: 6),
              itemBuilder: (context, index) =>
                  _buildSourceTile(theme, _sourceSpecs[index]),
            ),
          ),
          const SizedBox(height: 8),
          if (_checkingVendors)
            const AppLinearProgress(minHeight: 2)
          else
            Text(
              context.l10n.connectedMediaSources(_boundVendors.length),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCompactSourceRail(ThemeData theme) {
    return AppPanelSurface(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.zero,
      border: Border(
        bottom: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      clipBehavior: Clip.none,
      child: DropdownButtonFormField<int>(
        key: ValueKey('add-media-source-selector-$_selectedIndex'),
        initialValue: _selectedIndex,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: context.l10n.source,
          prefixIcon: Icon(
            _sourceSpecs[_selectedIndex].icon,
            color: _sourceSpecs[_selectedIndex].color,
          ),
        ),
        menuMaxHeight: 420,
        items: [
          for (final spec in _sourceSpecs)
            DropdownMenuItem<int>(
              value: spec.index,
              child: Text(
                spec.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
        onChanged: (index) {
          if (index != null) _selectSource(index);
        },
      ),
    );
  }

  Widget _buildSourceTile(
    ThemeData theme,
    _MediaSourceSpec spec, {
    bool compact = false,
  }) {
    final selected = _selectedIndex == spec.index;
    return AppInkSurface(
      color: selected
          ? spec.color.withValues(alpha: 0.13)
          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.38),
      borderRadius: BorderRadius.circular(8),
      onTap: () => _selectSource(spec.index),
      child: AppPanelSurface(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 11,
          vertical: compact ? 8 : 10,
        ),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected
              ? spec.color.withValues(alpha: 0.55)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        clipBehavior: Clip.none,
        child: Row(
          children: [
            AppIconBadge(
              icon: spec.icon,
              color: spec.color,
              size: compact ? 30 : 32,
              iconSize: 20,
              backgroundAlpha: selected ? 0.18 : 0.12,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spec.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    spec.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourcePanel(ThemeData theme, {bool compact = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppPanelSurface(
          height: 52,
          padding: EdgeInsets.symmetric(horizontal: compact ? 16 : 22),
          color: Colors.transparent,
          borderRadius: BorderRadius.zero,
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _getTitle(_selectedIndex),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (_providerBindingType(_selectedIndex) != null)
                AppActionButton(
                  onPressed: () async {
                    await PlatformBindingDialog.show(
                      context,
                      initialProviderType: _providerBindingType(_selectedIndex),
                    );
                    await _checkVendors();
                    if (!mounted) return;
                    if (_selectedIndex == 4 && _alistBinds.isNotEmpty) {
                      _loadAlist(_alistPath);
                    }
                    if (_selectedIndex == 5 && _embyBinds.isNotEmpty) {
                      _loadEmby(_embyPath);
                    }
                    if (_selectedIndex == 6 && _cloudreveBinds.isNotEmpty) {
                      _loadCloudreve(_cloudrevePath);
                    }
                  },
                  icon: Icons.tune_rounded,
                  label: context.l10n.mediaSource,
                  style: AppActionButtonStyle.text,
                ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: compact
                ? const EdgeInsets.all(10)
                : const EdgeInsets.fromLTRB(18, 10, 18, 18),
            child: _buildContent(theme),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(ThemeData theme) {
    switch (_selectedIndex) {
      case 0:
        return _buildDirectLinkContent(theme);
      case 1:
        return _buildRtmpPublishContent(theme);
      case 2:
        return _buildLiveProxyContent(theme);
      case 3:
        return _buildBilibiliContent(theme);
      case 4:
        return _buildAlistContent(theme);
      case 5:
        return _buildEmbyContent(theme);
      case 6:
        return _buildCloudreveContent(theme);
      case 7:
        return TwitchAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          binds: _twitchBinds,
          onDraftChanged: (value) => _twitchHasDraft = value,
        );
      case 8:
        return HuyaAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          instances: _huyaInstances,
          onDraftChanged: (value) => _huyaHasDraft = value,
        );
      case 9:
        return DouyuAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          instances: _douyuInstances,
          onDraftChanged: (value) => _douyuHasDraft = value,
        );
      case 10:
        return AcFunAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          instances: _acfunInstances,
          onDraftChanged: (value) => _acfunHasDraft = value,
        );
      case 11:
        return CctvAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          instances: _cctvInstances,
          onDraftChanged: (value) => _cctvHasDraft = value,
        );
      case 12:
        return FnosAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          binds: _fnosBinds,
          onDraftChanged: (value) => _fnosHasDraft = value,
        );
      case 13:
        return QnapAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          binds: _qnapBinds,
          onDraftChanged: (value) => _qnapHasDraft = value,
        );
      case 14:
        return SynologyAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          binds: _synologyBinds,
          onDraftChanged: (value) => _synologyHasDraft = value,
        );
      case 15:
        return NextcloudAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          binds: _nextcloudBinds,
          onDraftChanged: (value) => _nextcloudHasDraft = value,
        );
      case 16:
        return SeafileAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          binds: _seafileBinds,
          onDraftChanged: (value) => _seafileHasDraft = value,
        );
      case 17:
        return TrueNasAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          binds: _trueNasBinds,
          onDraftChanged: (value) => _trueNasHasDraft = value,
        );
      case 18:
        return YoutubeAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          binds: _youtubeBinds,
          onDraftChanged: (value) => _youtubeHasDraft = value,
        );
      case 19:
        return DouyinAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          binds: _douyinBinds,
          onDraftChanged: (value) => _douyinHasDraft = value,
        );
      case 20:
        return TikTokAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          binds: _tiktokBinds,
          onDraftChanged: (value) => _tiktokHasDraft = value,
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildDirectLinkContent(ThemeData theme) {
    return AppSingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDirectTextField(
            controller: _urlController,
            focusNode: _urlFocusNode,
            label: context.l10n.videoLinks,
            hintText: context.l10n.videoLinksHint,
            prefixIcon: Icons.link_rounded,
            minLines: 1,
            maxLines: 2,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.newline,
            autocorrect: false,
            smartDashesType: SmartDashesType.disabled,
            smartQuotesType: SmartQuotesType.disabled,
            enabled: !_isLoading,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          _buildDirectTextField(
            controller: _nameController,
            label: context.l10n.optionalVideoName,
            hintText: context.l10n.defaultsToFileName,
            prefixIcon: Icons.title_rounded,
            textInputAction: TextInputAction.next,
            enabled: !_isLoading,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          _buildDirectHeadersEditor(theme),
          const SizedBox(height: 12),
          AppSwitchTile(
            value: _preferProxy,
            onChanged: _isLoading
                ? null
                : (val) => setState(() => _preferProxy = val),
            title: Text(context.l10n.preferProxyPlayback),
            subtitle: Text(context.l10n.proxyPlaybackDescription),
            prefix: const Icon(Icons.route_rounded),
            semanticsLabel: context.l10n.preferProxyPlayback,
          ),
          const SizedBox(height: 8),
          AppSwitchTile(
            value: _proxyOnly,
            onChanged: _isLoading
                ? null
                : (value) => setState(() => _proxyOnly = value),
            title: Text(context.l10n.proxyOnlyPlayback),
            subtitle: Text(context.l10n.proxyOnlyPlaybackDescription),
            prefix: const Icon(Icons.lock_outline_rounded),
            semanticsLabel: context.l10n.proxyOnlyPlayback,
          ),
          const SizedBox(height: 18),
          _buildActionButton(
            context.l10n.addToPlaylist,
            _addDirectLink,
            icon: Icons.playlist_add_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildDirectTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData prefixIcon,
    FocusNode? focusNode,
    int? minLines,
    int? maxLines,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    required bool enabled,
    ValueChanged<String>? onChanged,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      label: label,
      hintText: hintText,
      prefixIcon: prefixIcon,
      enabled: enabled,
      filled: true,
      fillColor: scheme.surfaceContainerHighest,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autocorrect: autocorrect,
      enableSuggestions: keyboardType != TextInputType.url,
      smartDashesType: smartDashesType,
      smartQuotesType: smartQuotesType,
      onChanged: onChanged,
      style: theme.textTheme.bodyMedium,
      borderRadius: BorderRadius.circular(8),
      enabledBorderSide: BorderSide(
        color: scheme.outlineVariant.withValues(alpha: 0.7),
      ),
      focusedBorderSide: BorderSide(color: scheme.primary, width: 1.4),
      disabledBorderSide: BorderSide(
        color: scheme.outlineVariant.withValues(alpha: 0.35),
      ),
    );
  }

  Widget _buildDirectHeadersEditor(ThemeData theme) {
    final borderColor = theme.colorScheme.outlineVariant.withValues(
      alpha: 0.45,
    );
    final validationMessage = _directHeaderError;
    return AppPanelSurface(
      padding: const EdgeInsets.all(12),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.25),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: borderColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.http_rounded,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.l10n.requestHeaders,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              AppActionButton(
                onPressed: _addDirectHeaderRow,
                icon: Icons.add_rounded,
                label: context.l10n.requestHeaders,
                style: AppActionButtonStyle.text,
              ),
            ],
          ),
          if (_directHeaders.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 2, 0, 4),
              child: Text(
                context.l10n.noExtraRequestHeaders,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else ...[
            const SizedBox(height: 8),
            for (var i = 0; i < _directHeaders.length; i++) ...[
              _buildDirectHeaderRow(theme, i),
              if (i != _directHeaders.length - 1) const SizedBox(height: 8),
            ],
            if (validationMessage.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildInlineValidationMessage(theme, validationMessage),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildInlineValidationMessage(ThemeData theme, String message) {
    final color = theme.colorScheme.error;
    return AppInfoBanner(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      icon: Icons.error_outline_rounded,
      iconSize: 18,
      color: color,
      backgroundColor: color.withValues(alpha: 0.08),
      border: Border.all(color: color.withValues(alpha: 0.25)),
      crossAxisAlignment: CrossAxisAlignment.start,
      title: Text(
        message,
        style: theme.textTheme.bodySmall?.copyWith(color: color, height: 1.35),
      ),
    );
  }

  Widget _buildDirectHeaderRow(ThemeData theme, int index) {
    final header = _directHeaders[index];
    return KeyedSubtree(
      key: header.key,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 520;
          final nameField = AppTextField(
            controller: header.nameController,
            label: context.l10n.name,
            hintText: 'Referer',
            textInputAction: TextInputAction.next,
            autocorrect: false,
            smartDashesType: SmartDashesType.disabled,
            smartQuotesType: SmartQuotesType.disabled,
            onChanged: (_) => _updateDirectHeaderValidation(),
          );
          final valueField = AppTextField(
            controller: header.valueController,
            label: context.l10n.value,
            hintText: 'https://example.com',
            textInputAction: TextInputAction.done,
            autocorrect: false,
            smartDashesType: SmartDashesType.disabled,
            smartQuotesType: SmartQuotesType.disabled,
            onChanged: (_) => _updateDirectHeaderValidation(),
          );
          final removeButton = SizedBox(
            width: 44,
            height: 44,
            child: AppIconButton(
              onPressed: () => _removeDirectHeaderRow(index),
              icon: Icons.close_rounded,
              tooltip: context.l10n.removeRequestHeader,
              style: AppIconButtonStyle.destructive,
            ),
          );

          if (compact) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 150, child: nameField),
                const SizedBox(width: 8),
                Expanded(child: valueField),
                removeButton,
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 180, child: nameField),
              const SizedBox(width: 8),
              Expanded(child: valueField),
              removeButton,
            ],
          );
        },
      ),
    );
  }

  Widget _buildRtmpPublishContent(ThemeData theme) {
    return AppSingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            theme,
            _nameController,
            context.l10n.liveName,
            context.l10n.liveNameHint,
            Icons.live_tv_rounded,
          ),
          const SizedBox(height: 18),
          if (_publicSettings != null) ...[
            _buildRtmpPublicSettingsPanel(theme, _publicSettings!),
            const SizedBox(height: 16),
          ],
          _buildInlineNotice(
            theme,
            icon: Icons.key_rounded,
            title: context.l10n.publishAddressGeneratedDescription,
            subtitle: context.l10n.copyToStreamingToolDescription,
            color: Colors.deepOrange.shade600,
          ),
          const SizedBox(height: 18),
          _buildActionButton(
            context.l10n.createPublishingEntry,
            _addRtmpPublish,
            color: Colors.deepOrange.shade600,
            icon: Icons.live_tv_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildLiveProxyContent(ThemeData theme) {
    return AppSingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _liveProxyUrlController,
            label: context.l10n.sourceAddress,
            hintText: context.l10n.liveSourceAddressHint,
            prefixIcon: Icons.sensors_rounded,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            smartDashesType: SmartDashesType.disabled,
            smartQuotesType: SmartQuotesType.disabled,
            enabled: !_isLoading,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          AppTextField(
            controller: _liveProxyNameController,
            label: context.l10n.optionalLiveName,
            hintText: context.l10n.optionalLiveNameHint,
            prefixIcon: Icons.title_rounded,
            textInputAction: TextInputAction.done,
            enabled: !_isLoading,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 18),
          _buildInlineNotice(
            theme,
            icon: Icons.route_rounded,
            title: context.l10n.serverPullsUpstreamLiveSource,
            subtitle: context.l10n.livePullSupportDescription,
            color: Colors.teal.shade600,
          ),
          const SizedBox(height: 18),
          _buildActionButton(
            context.l10n.addLivePull,
            _addLiveProxyMedia,
            color: Colors.teal.shade600,
            icon: Icons.playlist_add_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildBilibiliContent(ThemeData theme) {
    return Column(
      children: [
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(
              value: false,
              icon: Icon(Icons.play_circle_outline),
              label: Text('Media'),
            ),
            ButtonSegment(
              value: true,
              icon: Icon(Icons.playlist_play),
              label: Text('Dynamic playlist'),
            ),
          ],
          selected: {_bilibiliPlaylistMode},
          onSelectionChanged: _isLoading
              ? null
              : (values) =>
                    setState(() => _bilibiliPlaylistMode = values.first),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: _bilibiliPlaylistMode
              ? BilibiliPlaylistForm(
                  roomId: widget.roomId,
                  parentId: widget.parentId ?? '',
                  binds: _bilibiliBinds,
                  onDraftChanged: (value) => _bilibiliPlaylistHasDraft = value,
                )
              : _buildBilibiliMediaContent(theme),
        ),
      ],
    );
  }

  Widget _buildBilibiliMediaContent(ThemeData theme) {
    final candidates =
        _biliInfo?.candidates ?? const <BilibiliParseCandidateInfo>[];
    final selectedIndex = candidates.isEmpty
        ? -1
        : _biliSelectedIndex.clamp(0, candidates.length - 1).toInt();
    final selected = selectedIndex >= 0 ? candidates[selectedIndex] : null;
    final coverImage = selected?.cover ?? '';
    final title = selected?.title.isNotEmpty == true
        ? selected!.title
        : context.l10n.unknownTitle;
    final details = <String>[
      if (selected?.description.isNotEmpty == true) selected!.description,
      if (selected?.actors.isNotEmpty == true) selected!.actors.join(' / '),
      if (selected?.partNumber case final part?) 'P$part',
      if (selected?.durationSeconds case final duration?) '${duration}s',
      if (selected?.width case final width?)
        if (selected?.height case final height?) '${width}x$height',
    ];
    final previewItems =
        _biliPreview?.dynamicItems ?? const <RoomDynamicMediaEntry>[];

    return Column(
      children: [
        _buildProviderBindSelector<BilibiliBindInfo>(
          theme: theme,
          items: _bilibiliBinds,
          selectedKey: _bilibiliInstanceName,
          keyOf: (bind) => bind.providerInstanceName,
          labelOf: (bind) => _providerBindLabel(
            title: context.l10n.bilibiliAccount,
            instanceName: bind.providerInstanceName,
          ),
          onChanged: (bind) {
            setState(() {
              _bilibiliInstanceName = bind.providerInstanceName;
              _biliInfo = null;
              _biliSelectedIndex = 0;
              _biliPreview = null;
            });
          },
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Use room owner credential'),
          value: _bilibiliShared,
          onChanged: _isLoading
              ? null
              : (value) {
                  setState(() {
                    _bilibiliShared = value;
                    _biliPreview = null;
                  });
                },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 14),
          child: Row(
            children: [
              Expanded(
                child: _buildTextField(
                  theme,
                  _biliUrlController,
                  context.l10n.bilibiliVideoLink,
                  context.l10n.bilibiliVideoLinkHint,
                  Icons.search,
                  urlInput: true,
                ),
              ),
              const SizedBox(width: 12),
              SizedBox.square(
                dimension: 44,
                child: AppIconButton(
                  onPressed: _parseBilibili,
                  icon: Icons.arrow_forward_rounded,
                  tooltip: context.l10n.parseBilibiliLink,
                  loading: _isLoading,
                  style: AppIconButtonStyle.filled,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _biliInfo == null
              ? Center(
                  child: AppEmptyState(
                    icon: Icons.tv_rounded,
                    iconColor: const Color(0xFFFB7299),
                    iconSize: 58,
                    title: context.l10n.pasteBilibiliLink,
                    subtitle: context.l10n.bilibiliSupportedLinks,
                    maxWidth: 360,
                  ),
                )
              : AppSingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 18),
                  child: Column(
                    children: [
                      if (coverImage.isNotEmpty)
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: AppImageThumbnail(
                            url: coverImage,
                            width: double.infinity,
                            height: double.infinity,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (details.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          details.join(' · '),
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.hintColor,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ],
                      if (candidates.length > 1) ...[
                        const SizedBox(height: 16),
                        _buildBilibiliCandidateSelector(theme, candidates),
                      ],
                      const SizedBox(height: 16),
                      if (selected?.isMedia == true)
                        _buildActionButton(
                          context.l10n.addToPlaylist,
                          _addBilibiliCandidate,
                          color: const Color(0xFFFB7299),
                          icon: Icons.playlist_add_rounded,
                        )
                      else if (selected?.isPlaylist == true)
                        if (_biliPreview == null)
                          Align(
                            alignment: Alignment.centerRight,
                            child: OutlinedButton.icon(
                              key: const Key('bilibili-candidate-preview'),
                              onPressed: _isLoading
                                  ? null
                                  : _previewBilibiliCandidate,
                              icon: const Icon(Icons.preview_outlined),
                              label: const Text('Preview'),
                            ),
                          ),
                      if (_biliPreview != null) ...[
                        const SizedBox(height: 16),
                        BilibiliPlaylistPreview(
                          items: previewItems,
                          loading: _isLoading,
                          hasMore: _bilibiliPreviewHasMore,
                          onLoadMore: () =>
                              _previewBilibiliCandidate(loadMore: true),
                          onAddSelected: _addSelectedBilibiliPreviewItems,
                          onCreatePlaylist: _addBilibiliCandidate,
                        ),
                      ],
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildAlistContent(ThemeData theme) {
    if (_checkingVendors) {
      return const AppLoadingIndicator();
    }
    if (!_boundVendors.contains('alist')) {
      return _buildBindGuide('AList', theme);
    }

    return Column(
      children: [
        _buildProviderBindSelector<AlistBindInfo>(
          theme: theme,
          items: _alistBinds,
          selectedKey: _providerBindKey(_alistServerId, _alistInstanceName),
          keyOf: (bind) =>
              _providerBindKey(bind.serverId, bind.providerInstanceName),
          labelOf: (bind) => _providerBindLabel(
            title: bind.host.isNotEmpty ? bind.host : bind.username,
            instanceName: bind.providerInstanceName,
          ),
          onChanged: (bind) {
            setState(() {
              _alistServerId = bind.serverId;
              _alistInstanceName = bind.providerInstanceName;
              _alistPath = '/';
              _alistFiles = [];
              _alistPage = 1;
              _alistHasMore = true;
              _alistKeyword = '';
              _alistPassword = '';
              _alistSearchController.clear();
              _alistPasswordController.clear();
              _selectedAlistItems.clear();
            });
            _loadAlist('/');
          },
        ),
        _buildAlistSearchBar(theme),
        _buildAlistPasswordField(theme),
        _buildPathBar(theme, _alistPath, _goUpAlist),
        Expanded(
          child: !_alistLoading && _alistFiles.isEmpty
              ? Center(
                  child: AppEmptyState(
                    icon: Icons.cloud_queue_rounded,
                    iconColor: Colors.amber.shade700,
                    iconSize: 58,
                    title: context.l10n.noFiles,
                    subtitle: context.l10n.noMediaInDirectory,
                    maxWidth: 360,
                  ),
                )
              : _alistLoading && _alistFiles.isEmpty
              ? const AppLoadingIndicator()
              : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollInfo) {
                    if (!_alistLoading &&
                        _alistHasMore &&
                        scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200) {
                      _loadAlist(_alistPath, loadMore: true);
                    }
                    return false;
                  },
                  child: AppListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    itemCount: _alistFiles.length + (_alistHasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _alistFiles.length) {
                        return AppLoadMoreFooter(
                          loading: _alistLoading,
                          onPressed: () =>
                              _loadAlist(_alistPath, loadMore: true),
                        );
                      }

                      final file = _alistFiles[index];
                      final path = file.path;
                      final isSelected = _selectedAlistItems.containsKey(path);

                      return _buildFileItem(
                        theme,
                        file.name,
                        file.isDir,
                        () => file.isDir
                            ? _openAlistDirectory(file.path)
                            : _addAlistFile(file),
                        subtitle: file.isDir ? null : _formatSize(file.size),
                        isSelected: isSelected,
                        trailing: file.isDir
                            ? AppIconButton(
                                icon: Icons.playlist_add_rounded,
                                tooltip: context.l10n.addAsDynamicPlaylist,
                                onPressed: () =>
                                    _addAlistDirectoryPlaylist(file),
                              )
                            : null,
                        onSelectionChanged: (val) {
                          setState(() {
                            if (val == true) {
                              _selectedAlistItems[path] = file;
                            } else {
                              _selectedAlistItems.remove(path);
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
        ),
        if (_selectedAlistItems.isNotEmpty)
          AppPanelSurface(
            padding: const EdgeInsets.all(16),
            color: theme.cardColor,
            borderRadius: BorderRadius.zero,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
            child: _buildActionButton(
              context.l10n.addSelectedItems(_selectedAlistItems.length),
              _addSelectedAlistItems,
              icon: Icons.playlist_add_check_rounded,
            ),
          ),
      ],
    );
  }

  Widget _buildEmbyContent(ThemeData theme) {
    return Column(
      children: [
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(
              value: false,
              icon: Icon(Icons.folder_open_outlined),
              label: Text('Library'),
            ),
            ButtonSegment(
              value: true,
              icon: Icon(Icons.favorite_outline),
              label: Text('Favorites & people'),
            ),
          ],
          selected: {_embyPlaylistMode},
          onSelectionChanged: _isLoading
              ? null
              : (values) => setState(() => _embyPlaylistMode = values.first),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: _embyPlaylistMode
              ? EmbyPlaylistForm(
                  roomId: widget.roomId,
                  parentId: widget.parentId ?? '',
                  binds: _embyBinds,
                  onDraftChanged: (value) => _embyPlaylistHasDraft = value,
                )
              : _buildEmbyLibraryContent(theme),
        ),
      ],
    );
  }

  Widget _buildEmbyLibraryContent(ThemeData theme) {
    if (_checkingVendors) {
      return const AppLoadingIndicator();
    }
    if (!_boundVendors.contains('emby')) return _buildBindGuide('Emby', theme);

    return Column(
      children: [
        _buildProviderBindSelector<EmbyBindInfo>(
          theme: theme,
          items: _embyBinds,
          selectedKey: _providerBindKey(_embyServerId, _embyInstanceName),
          keyOf: (bind) =>
              _providerBindKey(bind.serverId, bind.providerInstanceName),
          labelOf: (bind) => _providerBindLabel(
            title: bind.host.isNotEmpty ? bind.host : bind.userId,
            instanceName: bind.providerInstanceName,
          ),
          onChanged: (bind) {
            setState(() {
              _embyServerId = bind.serverId;
              _embyInstanceName = bind.providerInstanceName;
              _embyPath = '';
              _embyFiles = [];
              _embyPage = 1;
              _embyHasMore = true;
              _embyKeyword = '';
              _embySearchController.clear();
            });
            _loadEmby('');
          },
        ),
        _buildEmbySearchBar(theme),
        _buildPathBar(theme, _embyPath, _goUpEmby),
        Expanded(
          child: !_embyLoading && _embyFiles.isEmpty
              ? Center(
                  child: AppEmptyState(
                    icon: Icons.video_library_rounded,
                    iconColor: Colors.green.shade600,
                    iconSize: 58,
                    title: context.l10n.noMedia,
                    subtitle: context.l10n.noMediaLibraryItems,
                    maxWidth: 360,
                  ),
                )
              : _embyLoading && _embyFiles.isEmpty
              ? const AppLoadingIndicator()
              : NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (!_embyLoading &&
                        _embyHasMore &&
                        scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200) {
                      _loadEmby(_embyPath, loadMore: true);
                    }
                    return false;
                  },
                  child: AppListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _embyFiles.length + (_embyHasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _embyFiles.length) {
                        return AppLoadMoreFooter(
                          loading: _embyLoading,
                          onPressed: () => _loadEmby(_embyPath, loadMore: true),
                        );
                      }
                      final file = _embyFiles[index];
                      return _buildFileItem(
                        theme,
                        file.name.isEmpty ? 'Unknown' : file.name,
                        file.isDir,
                        () => file.isDir
                            ? _enterEmbyDir(file.name, file.id)
                            : _addEmbyFile(file),
                        subtitle: file.isDir ? null : 'Emby Media',
                        thumbnailUrl: file.thumbnail,
                        iconColor: Colors.green,
                        trailing: file.isDir
                            ? AppIconButton(
                                icon: Icons.playlist_add_rounded,
                                tooltip: context.l10n.addAsDynamicPlaylist,
                                onPressed: () =>
                                    _addEmbyDirectoryPlaylist(file),
                              )
                            : null,
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildCloudreveContent(ThemeData theme) {
    if (_checkingVendors) return const AppLoadingIndicator();
    if (!_boundVendors.contains('cloudreve')) {
      return _buildBindGuide('Cloudreve', theme);
    }

    return Column(
      children: [
        _buildProviderBindSelector<CloudreveBindInfo>(
          theme: theme,
          items: _cloudreveBinds,
          selectedKey: _providerBindKey(
            _cloudreveServerId,
            _cloudreveInstanceName,
          ),
          keyOf: (bind) =>
              _providerBindKey(bind.serverId, bind.providerInstanceName),
          labelOf: (bind) => _providerBindLabel(
            title: bind.host.isNotEmpty ? bind.host : bind.email,
            instanceName: bind.providerInstanceName,
          ),
          onChanged: (bind) {
            setState(() {
              _cloudreveServerId = bind.serverId;
              _cloudreveInstanceName = bind.providerInstanceName;
              _cloudrevePath = 'cloudreve://my/';
              _cloudreveFiles = [];
              _cloudrevePage = 1;
              _cloudreveUsesCursor = false;
              _cloudreveNextCursor = '';
              _cloudreveHasMore = true;
              _cloudreveKeyword = '';
              _cloudreveSearchController.clear();
            });
            _loadCloudreve(_cloudrevePath);
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
          child: AppSearchField(
            controller: _cloudreveSearchController,
            hintText: context.l10n.searchMediaLibrary,
            onChanged: (value) {
              if (value.isEmpty && _cloudreveKeyword.isNotEmpty) {
                _clearCloudreveSearch();
              }
            },
            onSubmitted: (_) => _searchCloudreve(),
          ),
        ),
        _buildPathBar(theme, _cloudrevePath, _goUpCloudreve),
        Expanded(
          child: !_cloudreveLoading && _cloudreveFiles.isEmpty
              ? Center(
                  child: AppEmptyState(
                    icon: Icons.cloud_off_rounded,
                    iconColor: Colors.teal.shade600,
                    iconSize: 58,
                    title: context.l10n.noFiles,
                    subtitle: context.l10n.noMediaInDirectory,
                    maxWidth: 360,
                  ),
                )
              : _cloudreveLoading && _cloudreveFiles.isEmpty
              ? const AppLoadingIndicator()
              : NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (!_cloudreveLoading &&
                        _cloudreveHasMore &&
                        scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200) {
                      _loadCloudreve(_cloudrevePath, loadMore: true);
                    }
                    return false;
                  },
                  child: AppListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    itemCount:
                        _cloudreveFiles.length + (_cloudreveHasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _cloudreveFiles.length) {
                        return AppLoadMoreFooter(
                          loading: _cloudreveLoading,
                          onPressed: () =>
                              _loadCloudreve(_cloudrevePath, loadMore: true),
                        );
                      }
                      final file = _cloudreveFiles[index];
                      return _buildFileItem(
                        theme,
                        file.name,
                        file.isDir,
                        () => file.isDir
                            ? _openCloudreveDirectory(file.path)
                            : _addCloudreveFile(file),
                        subtitle: file.isDir ? null : _formatSize(file.size),
                        thumbnailUrl: file.thumbnail,
                        iconColor: Colors.teal,
                        trailing: file.isDir
                            ? AppIconButton(
                                icon: Icons.playlist_add_rounded,
                                tooltip: context.l10n.addAsDynamicPlaylist,
                                onPressed: () =>
                                    _addCloudreveDirectoryPlaylist(file),
                              )
                            : null,
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    ThemeData theme,
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    bool urlInput = false,
  }) {
    return AppTextField(
      controller: controller,
      label: label,
      hintText: hint,
      prefixIcon: icon,
      enabled: !_isLoading,
      keyboardType: urlInput ? TextInputType.url : null,
      autocorrect: false,
      smartDashesType: urlInput
          ? SmartDashesType.disabled
          : SmartDashesType.enabled,
      smartQuotesType: urlInput
          ? SmartQuotesType.disabled
          : SmartQuotesType.enabled,
    );
  }

  Widget _buildActionButton(
    String text,
    VoidCallback onPressed, {
    Color? color,
    IconData? icon,
  }) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 168, minHeight: 46),
        child: AppActionButton(
          onPressed: onPressed,
          loading: _isLoading,
          icon: icon ?? Icons.check_rounded,
          label: text,
        ),
      ),
    );
  }

  Widget _buildInlineNotice(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return AppInfoBanner(
      padding: const EdgeInsets.all(14),
      icon: icon,
      color: color,
      backgroundColor: color.withValues(alpha: 0.08),
      border: Border.all(color: color.withValues(alpha: 0.22)),
      boxedIcon: true,
      spacing: 12,
      title: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
      message: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildPathBar(ThemeData theme, String path, VoidCallback onUp) {
    final displayPath = path.isEmpty ? '/' : path;
    return AppPanelSurface(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
      child: Row(
        children: [
          AppIconButton(
            tooltip: context.l10n.parentDirectory,
            icon: Icons.arrow_upward_rounded,
            onPressed: path.isEmpty || path == '/' ? null : onUp,
            style: AppIconButtonStyle.ghost,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              displayPath,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderBindSelector<T>({
    required ThemeData theme,
    required List<T> items,
    required String selectedKey,
    required String Function(T item) keyOf,
    required String Function(T item) labelOf,
    required ValueChanged<T> onChanged,
  }) {
    if (items.length <= 1) return const SizedBox.shrink();
    final value = items.any((item) => keyOf(item) == selectedKey)
        ? selectedKey
        : keyOf(items.first);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: AppSelect<String>(
        value: value,
        label: context.l10n.mediaSourceAccount,
        prefixIcon: Icons.account_tree_rounded,
        options: {for (final item in items) labelOf(item): keyOf(item)},
        onChanged: (key) {
          if (key == null) return;
          onChanged(items.firstWhere((item) => keyOf(item) == key));
        },
      ),
    );
  }

  Widget _buildAlistSearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: AppSearchField(
        controller: _alistSearchController,
        hintText: context.l10n.searchCurrentDirectory,
        onChanged: (value) {
          if (value.isEmpty && _alistKeyword.isNotEmpty) _clearAlistSearch();
        },
        onSubmitted: (_) => _searchAlist(),
      ),
    );
  }

  Widget _buildAlistPasswordField(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: AppTextField(
        controller: _alistPasswordController,
        label: context.l10n.directoryPassword,
        prefixIcon: Icons.lock_outline_rounded,
        suffix: _alistPasswordController.text.isEmpty && _alistPassword.isEmpty
            ? null
            : AppIconButton(
                icon: Icons.backspace_outlined,
                tooltip: context.l10n.clearDirectoryPassword,
                onPressed: _clearAlistPassword,
                style: AppIconButtonStyle.destructive,
              ),
        obscureText: true,
        textInputAction: TextInputAction.done,
        onChanged: (_) => setState(() {}),
        onSubmitted: (_) => _applyAlistPassword(),
      ),
    );
  }

  Widget _buildEmbySearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: AppSearchField(
        controller: _embySearchController,
        hintText: context.l10n.searchMediaLibrary,
        onChanged: (value) {
          if (value.isEmpty && _embyKeyword.isNotEmpty) _clearEmbySearch();
        },
        onSubmitted: (_) => _searchEmby(),
      ),
    );
  }

  Widget _buildBilibiliCandidateSelector(
    ThemeData theme,
    List<BilibiliParseCandidateInfo> candidates,
  ) {
    final selectedIndex = _biliSelectedIndex
        .clamp(0, candidates.length - 1)
        .toInt();
    return AppPanelSurface(
      constraints: const BoxConstraints(maxHeight: 220),
      border: Border.all(color: theme.dividerColor.withValues(alpha: 0.15)),
      borderRadius: BorderRadius.circular(8),
      child: AppListView.separated(
        shrinkWrap: true,
        itemCount: candidates.length,
        separatorBuilder: (_, _) => AppDivider(
          height: 1,
          color: theme.dividerColor.withValues(alpha: 0.08),
        ),
        itemBuilder: (context, index) {
          final candidate = candidates[index];
          final selected = index == selectedIndex;
          final title = candidate.title.isEmpty
              ? context.l10n.videoNumber(index + 1)
              : candidate.title;
          final subtitle = [
            candidate.isPlaylist ? 'Dynamic playlist' : 'Media',
            if (candidate.partNumber case final part?) 'P$part',
            if (candidate.durationSeconds case final duration?) '${duration}s',
          ].join(' · ');
          return AppTile(
            selected: selected,
            prefix: Icon(
              candidate.isPlaylist
                  ? Icons.playlist_play
                  : selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? const Color(0xFFFB7299) : theme.hintColor,
            ),
            title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            onPressed: () => setState(() {
              _biliSelectedIndex = index;
              _biliPreview = null;
            }),
          );
        },
      ),
    );
  }

  Widget _buildFileItem(
    ThemeData theme,
    String name,
    bool isDir,
    VoidCallback onTap, {
    String? subtitle,
    String? thumbnailUrl,
    Color? iconColor,
    bool? isSelected,
    ValueChanged<bool?>? onSelectionChanged,
    Widget? trailing,
  }) {
    final hasThumbnail = thumbnailUrl != null && thumbnailUrl.isNotEmpty;
    return AppPanelSurface(
      margin: const EdgeInsets.only(bottom: 12),
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      child: AppTile(
        onPressed: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        prefix: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onSelectionChanged != null)
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: AppCheckbox(
                    value: isSelected ?? false,
                    semanticsLabel: context.l10n.selectMedia,
                    onChanged: onSelectionChanged,
                  ),
                ),
              ),
            hasThumbnail
                ? AppImageThumbnail(
                    url: thumbnailUrl,
                    width: 40,
                    height: 40,
                    errorIcon: isDir
                        ? Icons.folder_rounded
                        : Icons.movie_rounded,
                  )
                : _buildFileIcon(isDir, iconColor),
          ],
        ),
        title: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: theme.hintColor),
              )
            : null,
        suffix: trailing,
      ),
    );
  }

  Widget _buildFileIcon(bool isDir, Color? iconColor) {
    final color = isDir ? Colors.amber : (iconColor ?? Colors.blue);
    return AppIconBadge(
      icon: isDir ? Icons.folder_rounded : Icons.movie_rounded,
      color: color,
      size: 40,
    );
  }

  Widget _buildBindGuide(String name, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.link_off_rounded,
            size: 64,
            color: theme.disabledColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.providerNotBound(name),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.bindAccountToAccessResources,
            style: TextStyle(color: theme.hintColor),
          ),
          const SizedBox(height: 24),
          AppActionButton(
            onPressed: () async {
              await PlatformBindingDialog.show(
                context,
                initialProviderType: name.toLowerCase(),
              );
              _checkVendors();
            },
            icon: Icons.link_rounded,
            label: context.l10n.bindProviderNow(name),
          ),
        ],
      ),
    );
  }

  String? _providerBindingType(int selectedIndex) {
    return switch (selectedIndex) {
      3 => 'bilibili',
      4 => 'alist',
      5 => 'emby',
      6 => 'cloudreve',
      7 => 'twitch',
      12 => 'fnos',
      13 => 'qnap',
      14 => 'synology',
      15 => 'nextcloud',
      16 => 'seafile',
      17 => 'truenas',
      18 => 'youtube',
      19 => 'douyin',
      20 => 'tiktok',
      _ => null,
    };
  }

  String? _providerTypeForSourceIndex(int index) {
    return switch (index) {
      0 => 'directUrl',
      1 => 'rtmp',
      2 => 'liveProxy',
      3 => 'bilibili',
      4 => 'alist',
      5 => 'emby',
      6 => 'cloudreve',
      7 => 'twitch',
      8 => 'huya',
      9 => 'douyu',
      10 => 'acfun',
      11 => 'cctv',
      12 => 'fnos',
      13 => 'qnap',
      14 => 'synology',
      15 => 'nextcloud',
      16 => 'seafile',
      17 => 'truenas',
      18 => 'youtube',
      19 => 'douyin',
      20 => 'tiktok',
      _ => null,
    };
  }

  void _applyDefaultProviderBindings() {
    if (_alistBinds.isNotEmpty &&
        !_alistBinds.any(
          (bind) =>
              bind.serverId == _alistServerId &&
              bind.providerInstanceName == _alistInstanceName,
        )) {
      final bind = _alistBinds.first;
      _alistServerId = bind.serverId;
      _alistInstanceName = bind.providerInstanceName;
    }
    if (_embyBinds.isNotEmpty &&
        !_embyBinds.any(
          (bind) =>
              bind.serverId == _embyServerId &&
              bind.providerInstanceName == _embyInstanceName,
        )) {
      final bind = _embyBinds.first;
      _embyServerId = bind.serverId;
      _embyInstanceName = bind.providerInstanceName;
    }
    if (_cloudreveBinds.isNotEmpty &&
        !_cloudreveBinds.any(
          (bind) =>
              bind.serverId == _cloudreveServerId &&
              bind.providerInstanceName == _cloudreveInstanceName,
        )) {
      final bind = _cloudreveBinds.first;
      _cloudreveServerId = bind.serverId;
      _cloudreveInstanceName = bind.providerInstanceName;
    }
    if (_bilibiliBinds.isNotEmpty &&
        !_bilibiliBinds.any(
          (bind) => bind.providerInstanceName == _bilibiliInstanceName,
        )) {
      _bilibiliInstanceName = _bilibiliBinds.first.providerInstanceName;
    }
  }

  String _providerBindKey(String serverId, String instanceName) {
    return '$serverId@$instanceName';
  }

  String _providerBindLabel({
    required String title,
    required String instanceName,
  }) {
    final instanceLabel = instanceName.isEmpty
        ? context.l10n.localInstance
        : instanceName;
    return '$title · $instanceLabel';
  }

  String _formatSize(dynamic size) {
    if (size == null) return '';
    if (size is! num) return size.toString();
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024) {
      return '${(size / 1024 / 1024).toStringAsFixed(1)} MB';
    }
    return '${(size / 1024 / 1024 / 1024).toStringAsFixed(1)} GB';
  }

  String _directUrlDisplayName(String url) {
    final parsed = Uri.tryParse(url);
    final segments =
        parsed?.pathSegments
            .where((segment) => segment.trim().isNotEmpty)
            .toList(growable: false) ??
        const <String>[];
    final fileName = segments.isEmpty ? '' : Uri.decodeComponent(segments.last);
    if (fileName.isNotEmpty) return fileName;
    final host = parsed?.host ?? '';
    if (host.isNotEmpty) return host;
    return context.l10n.directLinkVideo;
  }

  void _addDirectHeaderRow() {
    final hasBlank = _directHeaders.any(
      (header) =>
          header.nameController.text.trim().isEmpty &&
          header.valueController.text.trim().isEmpty,
    );
    if (hasBlank) {
      setState(
        () => _directHeaderError = context.l10n.completeBlankRequestHeader,
      );
      return;
    }
    setState(() {
      _directHeaders.add(_DirectHeaderDraft());
      _directHeaderError = _currentDirectHeaderValidationMessage();
    });
  }

  void _removeDirectHeaderRow(int index) {
    if (index < 0 || index >= _directHeaders.length) return;
    final header = _directHeaders.removeAt(index);
    header.dispose();
    _updateDirectHeaderValidation();
  }

  void _updateDirectHeaderValidation() {
    final message = _currentDirectHeaderValidationMessage();
    if (!mounted || _directHeaderError == message) return;
    setState(() => _directHeaderError = message);
  }

  String _currentDirectHeaderValidationMessage() {
    try {
      _collectDirectHeaders(validateCompleteRows: false);
      return '';
    } on DirectUrlSourceConfigException catch (e) {
      return e.message;
    }
  }

  Map<String, String> _collectDirectHeaders({
    bool validateCompleteRows = true,
  }) {
    final headers = <String, String>{};
    final normalizedNames = <String>{};
    for (final draft in _directHeaders) {
      final name = draft.nameController.text.trim();
      final value = draft.valueController.text.trim();
      if (name.isEmpty && value.isEmpty) continue;
      if (validateCompleteRows && (name.isEmpty || value.isEmpty)) {
        throw DirectUrlSourceConfigException(
          context.l10n.completeRequestHeaderNameAndValue,
        );
      }
      if (name.isNotEmpty) {
        DirectUrlSourceConfig.validateHeaderName(name);
        final normalized = name.toLowerCase();
        if (!normalizedNames.add(normalized)) {
          throw DirectUrlSourceConfigException(
            context.l10n.duplicateRequestHeader(name),
          );
        }
      }
      if (validateCompleteRows) {
        headers[name] = value;
      } else if (name.isNotEmpty && value.isNotEmpty) {
        headers[name] = value;
      }
    }
    DirectUrlSourceConfig.validateHeaders(headers);
    return headers;
  }

  bool get _hasUnsavedDraft {
    if (_urlController.text.trim().isNotEmpty ||
        _nameController.text.trim().isNotEmpty ||
        _liveProxyUrlController.text.trim().isNotEmpty ||
        _liveProxyNameController.text.trim().isNotEmpty ||
        _biliUrlController.text.trim().isNotEmpty ||
        _bilibiliPlaylistHasDraft ||
        _alistSearchController.text.trim().isNotEmpty ||
        _embySearchController.text.trim().isNotEmpty ||
        _embyPlaylistHasDraft ||
        _cloudreveSearchController.text.trim().isNotEmpty ||
        _twitchHasDraft ||
        _huyaHasDraft ||
        _douyuHasDraft ||
        _acfunHasDraft ||
        _cctvHasDraft ||
        _fnosHasDraft ||
        _qnapHasDraft ||
        _synologyHasDraft ||
        _nextcloudHasDraft ||
        _seafileHasDraft ||
        _trueNasHasDraft ||
        _youtubeHasDraft ||
        _douyinHasDraft ||
        _tiktokHasDraft) {
      return true;
    }
    return _directHeaders.any(
      (header) =>
          header.nameController.text.trim().isNotEmpty ||
          header.valueController.text.trim().isNotEmpty,
    );
  }

  Future<bool> _confirmDiscardDraft() async {
    final result = await AppDialogs.showStyledDialog<bool>(
      context: context,
      title: context.l10n.discardCurrentEdits,
      icon: Icon(
        Icons.warning_amber_rounded,
        color: Theme.of(context).colorScheme.error,
      ),
      iconColor: Theme.of(context).colorScheme.error,
      content: Text(
        context.l10n.discardMediaDraftDescription,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        AppActionButton(
          onPressed: () => Navigator.pop(context, false),
          label: context.l10n.continueEditing,
          style: AppActionButtonStyle.outlined,
        ),
        AppActionButton(
          onPressed: () => Navigator.pop(context, true),
          label: context.l10n.discard,
          style: AppActionButtonStyle.tonal,
        ),
      ],
    );
    return result == true;
  }

  Future<void> _requestClose() async {
    if (!_hasUnsavedDraft) {
      Navigator.of(context).pop();
      return;
    }
    final confirmed = await _confirmDiscardDraft();
    if (!mounted || !confirmed) return;
    Navigator.of(context).pop();
  }

  Future<void> _addDirectLink() async {
    late final List<String> urls;
    late final Map<String, String> headers;
    try {
      urls = _parseDirectUrls(_urlController.text);
      headers = _collectDirectHeaders();
    } on DirectUrlSourceConfigException catch (e) {
      setState(() => _directHeaderError = e.message);
      AppNotifications.showWarning(context, e.message);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final name = _nameController.text.trim();
      if (urls.length == 1) {
        await providerGateway.addDirectUrlMedia(
          widget.roomId,
          playlistId: widget.parentId ?? '',
          url: urls.single,
          name: name.isEmpty ? _directUrlDisplayName(urls.single) : name,
          headers: headers,
          preferProxy: _preferProxy,
          proxyOnly: _proxyOnly,
        );
      } else {
        await providerGateway.addMediaBatch(
          widget.roomId,
          urls
              .map(
                (url) => {
                  'playlistId': widget.parentId ?? '',
                  'sourceProvider': DirectUrlSourceConfig.sourceProvider,
                  'sourceConfig': DirectUrlSourceConfig.fromUserInput(
                    url: url,
                    headers: headers,
                    preferProxy: _preferProxy,
                    proxyOnly: _proxyOnly,
                  ).toJson(),
                  'name': _directUrlDisplayName(url),
                },
              )
              .toList(growable: false),
        );
      }
      if (mounted) {
        Navigator.pop(context);
        AppNotifications.showSuccess(
          context,
          urls.length == 1
              ? context.l10n.addedSuccessfully
              : context.l10n.itemsAdded(urls.length),
        );
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.addFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<String> _parseDirectUrls(String input) {
    final urls = <String>[];
    for (final rawLine in input.split('\n')) {
      final url = DirectUrlSourceConfig.normalizeUrlInput(rawLine);
      if (url.isEmpty) continue;
      urls.add(DirectUrlSourceConfig.validateUrl(url));
    }
    if (urls.isEmpty) {
      throw DirectUrlSourceConfigException(context.l10n.enterHttpLinks);
    }
    return urls;
  }

  Future<void> _addRtmpPublish() async {
    setState(() => _isLoading = true);
    try {
      final name = _nameController.text.trim();
      final mediaId = await providerGateway.addRtmpMedia(
        widget.roomId,
        playlistId: widget.parentId ?? '',
        name: name.isEmpty ? context.l10n.rtmpLive : name,
      );
      final publish = await providerGateway.createRtmpPublishKeyInfo(
        widget.roomId,
        mediaId,
      );
      final streamInfo = await providerGateway.getRtmpStreamInfo(
        roomId: widget.roomId,
        mediaId: mediaId,
      );
      if (mounted) {
        Navigator.pop(context);
        await _showRtmpPublishDialog(publish: publish, streamInfo: streamInfo);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.createPublishingEntryFailed('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addLiveProxyMedia() async {
    late final String url;
    try {
      url = _validateLiveProxyUrl(_liveProxyUrlController.text.trim());
    } on FormatException catch (e) {
      AppNotifications.showWarning(context, e.message);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final name = _liveProxyNameController.text.trim();
      await providerGateway.addLiveProxyMedia(
        widget.roomId,
        playlistId: widget.parentId ?? '',
        url: url,
        name: name.isEmpty ? _liveProxyDisplayName(url) : name,
      );
      if (mounted) {
        Navigator.pop(context);
        AppNotifications.showSuccess(context, context.l10n.addedSuccessfully);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(
          context,
          context.l10n.addLivePullFailed('$e'),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _validateLiveProxyUrl(String rawUrl) {
    if (rawUrl.isEmpty) {
      throw FormatException(context.l10n.enterLiveSourceAddress);
    }
    final uri = Uri.tryParse(rawUrl);
    if (uri == null || uri.scheme.isEmpty || uri.host.isEmpty) {
      throw FormatException(context.l10n.enterValidLiveSourceAddress);
    }
    final scheme = uri.scheme.toLowerCase();
    final isRtmp = scheme == 'rtmp';
    final isFlv =
        (scheme == 'http' || scheme == 'https') &&
        uri.path.toLowerCase().endsWith('.flv');
    if (!isRtmp && !isFlv) {
      throw FormatException(context.l10n.livePullUrlSupport);
    }
    return rawUrl;
  }

  String _liveProxyDisplayName(String url) {
    final uri = Uri.tryParse(url);
    final segments =
        uri?.pathSegments
            .where((segment) => segment.trim().isNotEmpty)
            .toList(growable: false) ??
        const <String>[];
    final lastSegment = segments.isEmpty ? null : segments.last;
    if (lastSegment == null || lastSegment.isEmpty) {
      return context.l10n.livePull;
    }
    return Uri.decodeComponent(lastSegment);
  }

  Future<void> _showRtmpPublishDialog({
    required RtmpPublishKeyInfo publish,
    required RoomStreamEntryInfo streamInfo,
  }) {
    final publicSettings = _publicSettings;
    return AppDialogs.showStyledDialog<void>(
      context: context,
      title: context.l10n.rtmpPublishing,
      icon: const Icon(Icons.live_tv_rounded, color: Color(0xFF5D5FEF)),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRtmpInfoRow(
              context.l10n.publishingAddress,
              publish.rtmpUrl,
              copyable: true,
            ),
            _buildRtmpInfoRow('Stream Key', publish.streamKey, copyable: true),
            _buildRtmpInfoRow(
              'Publish Key',
              publish.publishKey,
              copyable: true,
            ),
            if (publicSettings?.customPublishHost?.isNotEmpty == true)
              _buildRtmpInfoRow(
                context.l10n.publishingHost,
                publicSettings!.customPublishHost!,
                copyable: true,
              ),
            if (publicSettings != null)
              _buildRtmpInfoRow(
                context.l10n.tsDisguise,
                publicSettings.tsDisguisedAsPng
                    ? context.l10n.pngDisguiseEnabled
                    : context.l10n.disabled,
              ),
            _buildRtmpInfoRow(
              context.l10n.expirationTime,
              _formatTimestamp(publish.expiresAt),
            ),
            _buildRtmpInfoRow(
              context.l10n.currentStatus,
              streamInfo.active ? context.l10n.active : context.l10n.inactive,
            ),
          ],
        ),
      ),
      actions: [
        AppDialogs.createConfirmButton(
          context,
          () => Navigator.pop(context),
          text: context.l10n.done,
        ),
      ],
    );
  }

  Widget _buildRtmpPublicSettingsPanel(
    ThemeData theme,
    PublicSettingsInfo settings,
  ) {
    final publishHost = settings.customPublishHost?.trim();
    return AppPanelSurface(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: theme.dividerColor.withValues(alpha: 0.12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            publishHost?.isNotEmpty == true
                ? publishHost!
                : context.l10n.useServerPublishingHost,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            settings.tsDisguisedAsPng
                ? context.l10n.liveSegmentsAsPng
                : context.l10n.liveSegmentsAsTs,
            style: TextStyle(fontSize: 12, color: theme.hintColor),
          ),
        ],
      ),
    );
  }

  Widget _buildRtmpInfoRow(
    String label,
    String value, {
    bool copyable = false,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(label, style: TextStyle(color: theme.hintColor)),
          ),
          Expanded(
            child: AppSelectableText(
              value.isEmpty ? '-' : value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (copyable) ...[
            const SizedBox(width: 8),
            AppIconButton(
              tooltip: context.l10n.copy,
              icon: Icons.copy_rounded,
              iconSize: 18,
              size: AppIconButtonSize.sm,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                AppNotifications.showSuccess(context, context.l10n.copied);
              },
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(int timestamp) {
    if (timestamp <= 0) return '-';
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _parseBilibili() async {
    final url = _biliUrlController.text.trim();
    if (url.isEmpty) return;
    setState(() {
      _isLoading = true;
      _biliInfo = null;
    });
    try {
      final info = await providerGateway.parseBilibiliInfo(
        url,
        instanceName: _bilibiliInstanceName,
      );
      if (mounted) {
        setState(() {
          _biliInfo = info;
          _biliSelectedIndex = 0;
          _biliPreview = null;
        });
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.parseFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  BilibiliParseCandidateInfo? get _selectedBilibiliCandidate {
    final candidates = _biliInfo?.candidates;
    if (candidates == null || candidates.isEmpty) return null;
    final index = _biliSelectedIndex.clamp(0, candidates.length - 1).toInt();
    return candidates[index];
  }

  bool get _bilibiliPreviewHasMore {
    final preview = _biliPreview;
    if (preview == null) return false;
    if (preview.usesCursor) return preview.nextCursor.isNotEmpty;
    if (preview.total case final total?) {
      return preview.dynamicItems.length < total;
    }
    return false;
  }

  Future<void> _previewBilibiliCandidate({bool loadMore = false}) async {
    final candidate = _selectedBilibiliCandidate;
    final sourceConfig = candidate?.playlistSourceConfig;
    if (sourceConfig == null) return;
    final current = _biliPreview;
    if (loadMore && (current == null || !_bilibiliPreviewHasMore)) return;
    setState(() => _isLoading = true);
    try {
      final preview = await providerGateway.listMediaLibrary(
        widget.roomId,
        sourceProvider: 'bilibili',
        typedPreviewSourceConfig: BilibiliSourceConfig.playlistWithShared(
          sourceConfig,
          _bilibiliShared,
        ),
        providerInstanceName: _bilibiliInstanceName,
        pageSize: 24,
        page: loadMore && current?.usesCursor == false ? current!.page + 1 : 1,
        cursor: loadMore && current?.usesCursor == true
            ? current!.nextCursor
            : null,
      );
      if (mounted) {
        setState(() {
          _biliPreview = loadMore && current != null
              ? RoomMediaLibraryPage(
                  playlists: preview.playlists,
                  media: preview.media,
                  dynamicItems: [
                    ...current.dynamicItems,
                    ...preview.dynamicItems,
                  ],
                  currentPath: preview.currentPath,
                  total: preview.total,
                  folderCount: preview.folderCount,
                  fileCount: preview.fileCount,
                  version: preview.version,
                  usesCursor: preview.usesCursor,
                  nextCursor: preview.nextCursor,
                  page: preview.page,
                )
              : preview;
        });
      }
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.parseFailed('$error'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addBilibiliCandidate() async {
    if (_biliInfo == null) return;
    setState(() => _isLoading = true);

    try {
      final candidate = _selectedBilibiliCandidate;
      if (candidate == null) {
        throw Exception(context.l10n.bilibiliVideoInfoUnavailable);
      }
      final title = candidate.title.isEmpty ? 'Bilibili' : candidate.title;
      if (candidate.mediaSourceConfig case final sourceConfig?) {
        await providerGateway.addMediaFromSourceConfig(
          widget.roomId,
          playlistId: widget.parentId ?? '',
          providerInstanceName: _bilibiliInstanceName,
          sourceConfig: BilibiliSourceConfig.mediaWithShared(
            sourceConfig,
            _bilibiliShared,
          ),
          name: title,
        );
      } else if (candidate.playlistSourceConfig case final sourceConfig?) {
        if (_biliPreview == null) {
          throw StateError('Preview the dynamic playlist before creating it');
        }
        await providerGateway.createPlaylistFromSourceConfig(
          widget.roomId,
          parentId: widget.parentId ?? '',
          providerInstanceName: _bilibiliInstanceName,
          sourceConfig: BilibiliSourceConfig.playlistWithShared(
            sourceConfig,
            _bilibiliShared,
          ),
          name: title,
          description: candidate.description,
        );
      } else {
        throw StateError('Bilibili parse candidate has no source config');
      }
      if (mounted) {
        Navigator.pop(context);
        AppNotifications.showSuccess(context, context.l10n.addedSuccessfully);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.addFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addSelectedBilibiliPreviewItems(
    List<RoomDynamicMediaEntry> items,
  ) async {
    if (items.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      for (final item in items) {
        final sourceConfig = item.mediaSourceConfig;
        if (sourceConfig == null) continue;
        await providerGateway.addMediaFromSourceConfig(
          widget.roomId,
          playlistId: widget.parentId ?? '',
          providerInstanceName: _bilibiliInstanceName,
          sourceConfig: BilibiliSourceConfig.mediaWithShared(
            sourceConfig,
            _bilibiliShared,
          ),
          name: item.name,
        );
      }
      if (mounted) {
        Navigator.pop(context);
        AppNotifications.showSuccess(context, context.l10n.addedSuccessfully);
      }
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.addFailed('$error'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadAlist(String path, {bool loadMore = false}) async {
    if (_alistBinds.isEmpty || _alistServerId.isEmpty) return;
    if (loadMore && _alistLoading) return;

    int targetPage = loadMore ? _alistPage + 1 : 1;
    final keyword = _alistKeyword;
    final password = _alistPasswordController.text;
    if (password != _alistPassword) {
      _alistPassword = password;
    }

    setState(() {
      _alistLoading = true;
      if (!loadMore) {
        _alistPath = path;
        _alistFiles = [];
      }
    });

    try {
      final pageInfo = await providerGateway.listAlistPage(
        path,
        keyword: keyword,
        page: targetPage,
        max: _pageSize,
        password: password,
        serverId: _alistServerId,
        instanceName: _alistInstanceName,
      );
      final newItems = pageInfo.items;
      final total = pageInfo.total;

      if (mounted) {
        setState(() {
          _alistServerId = pageInfo.serverId;
          _alistInstanceName = pageInfo.providerInstanceName;
          if (loadMore) {
            _alistFiles.addAll(newItems);
            _alistPage = targetPage;
          } else {
            _alistFiles = newItems;
            _alistPage = 1;
          }

          _alistHasMore = _alistFiles.length < total;
        });
      }
    } catch (e) {
      debugPrint('AList load error: $e');
      if (mounted) {
        AppNotifications.showError(context, context.l10n.loadFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _alistLoading = false);
    }
  }

  Future<void> _loadCloudreve(String path, {bool loadMore = false}) async {
    if (_cloudreveBinds.isEmpty || _cloudreveServerId.isEmpty) return;
    if (loadMore && _cloudreveLoading) return;
    final targetPage = loadMore ? _cloudrevePage + 1 : 1;
    setState(() {
      _cloudreveLoading = true;
      if (!loadMore) {
        _cloudrevePath = path;
        _cloudreveFiles = [];
      }
    });
    try {
      final page = await providerGateway.listCloudrevePage(
        path,
        keyword: _cloudreveKeyword,
        page: targetPage,
        max: _pageSize,
        offset: _cloudreveKeyword.isNotEmpty && loadMore
            ? _cloudreveFiles.length
            : 0,
        cursor: _cloudreveKeyword.isEmpty && loadMore && _cloudreveUsesCursor
            ? _cloudreveNextCursor
            : null,
        serverId: _cloudreveServerId,
        instanceName: _cloudreveInstanceName,
      );
      if (!mounted) return;
      setState(() {
        if (loadMore) {
          _cloudreveFiles.addAll(page.items);
          _cloudrevePage = targetPage;
        } else {
          _cloudreveFiles = page.items;
          _cloudrevePage = 1;
        }
        _cloudreveUsesCursor = page.usesCursor;
        _cloudreveNextCursor = page.nextCursor;
        _cloudreveHasMore = page.usesCursor
            ? page.nextCursor.isNotEmpty
            : _cloudreveFiles.length < page.total;
      });
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.loadFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _cloudreveLoading = false);
    }
  }

  void _searchCloudreve() {
    final keyword = _cloudreveSearchController.text.trim();
    if (keyword == _cloudreveKeyword) return;
    setState(() {
      _cloudreveKeyword = keyword;
      _cloudrevePage = 1;
      _cloudreveHasMore = true;
      _cloudreveUsesCursor = false;
      _cloudreveNextCursor = '';
    });
    _loadCloudreve(_cloudrevePath);
  }

  void _clearCloudreveSearch() {
    if (_cloudreveKeyword.isEmpty && _cloudreveSearchController.text.isEmpty) {
      return;
    }
    _cloudreveSearchController.clear();
    setState(() {
      _cloudreveKeyword = '';
      _cloudrevePage = 1;
      _cloudreveHasMore = true;
      _cloudreveUsesCursor = false;
      _cloudreveNextCursor = '';
    });
    _loadCloudreve(_cloudrevePath);
  }

  void _openCloudreveDirectory(String path) {
    if (_cloudreveKeyword.isNotEmpty) {
      _cloudreveSearchController.clear();
      setState(() => _cloudreveKeyword = '');
    }
    _loadCloudreve(path);
  }

  void _goUpCloudreve() {
    if (_cloudreveKeyword.isNotEmpty) {
      _clearCloudreveSearch();
      return;
    }
    final uri = Uri.tryParse(_cloudrevePath);
    if (uri == null || uri.pathSegments.isEmpty) return;
    final segments =
        uri.pathSegments.where((segment) => segment.isNotEmpty).toList()
          ..removeLast();
    _loadCloudreve(
      Uri(scheme: 'cloudreve', host: 'my', pathSegments: segments).toString(),
    );
  }

  Future<void> _addCloudreveFile(CloudreveItemInfo file) async {
    if (_cloudreveServerId.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await providerGateway.addCloudreveMedia(
        widget.roomId,
        playlistId: widget.parentId ?? '',
        serverId: _cloudreveServerId,
        path: file.path,
        name: file.name,
        providerInstanceName: _cloudreveInstanceName,
      );
      if (!mounted) return;
      Navigator.pop(context);
      AppNotifications.showSuccess(context, context.l10n.addedSuccessfully);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.addFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addCloudreveDirectoryPlaylist(CloudreveItemInfo file) async {
    if (_cloudreveServerId.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      await providerGateway.createPlaylist(
        widget.roomId,
        parentId: widget.parentId ?? '',
        sourceProvider: 'cloudreve',
        providerInstanceName: _cloudreveInstanceName,
        sourceConfig: {'serverId': _cloudreveServerId, 'path': file.path},
        name: file.name,
      );
      if (!mounted) return;
      Navigator.pop(context);
      AppNotifications.showSuccess(context, context.l10n.dynamicPlaylistAdded);
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.addFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _searchAlist() {
    final keyword = _alistSearchController.text.trim();
    if (keyword == _alistKeyword) return;
    setState(() {
      _alistKeyword = keyword;
      _alistPage = 1;
      _alistHasMore = true;
      _selectedAlistItems.clear();
    });
    _loadAlist(_alistPath);
  }

  void _clearAlistSearch() {
    if (_alistKeyword.isEmpty && _alistSearchController.text.isEmpty) return;
    _alistSearchController.clear();
    setState(() {
      _alistKeyword = '';
      _alistPage = 1;
      _alistHasMore = true;
      _selectedAlistItems.clear();
    });
    _loadAlist(_alistPath);
  }

  void _applyAlistPassword() {
    final password = _alistPasswordController.text;
    if (password == _alistPassword) return;
    setState(() {
      _alistPassword = password;
      _alistPage = 1;
      _alistHasMore = true;
      _selectedAlistItems.clear();
    });
    _loadAlist(_alistPath);
  }

  void _clearAlistPassword() {
    if (_alistPassword.isEmpty && _alistPasswordController.text.isEmpty) {
      return;
    }
    _alistPasswordController.clear();
    setState(() {
      _alistPassword = '';
      _alistPage = 1;
      _alistHasMore = true;
      _selectedAlistItems.clear();
    });
    _loadAlist(_alistPath);
  }

  void _openAlistDirectory(String path) {
    if (_alistKeyword.isNotEmpty) {
      _alistSearchController.clear();
      setState(() {
        _alistKeyword = '';
        _selectedAlistItems.clear();
      });
    }
    _loadAlist(path);
  }

  void _goUpAlist() {
    if (_alistPath == '/') return;
    if (_alistKeyword.isNotEmpty) {
      _clearAlistSearch();
      return;
    }
    final parts = _alistPath.split('/');
    parts.removeLast();
    _loadAlist(parts.length == 1 && parts[0] == '' ? '/' : parts.join('/'));
  }

  Future<void> _addAlistFile(AlistItemInfo file) async {
    if (_alistServerId.isEmpty) {
      AppNotifications.showWarning(
        context,
        context.l10n.chooseBoundAlistAccount,
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final password = _alistPasswordController.text;
      await providerGateway.addAlistMedia(
        widget.roomId,
        playlistId: widget.parentId ?? '',
        serverId: _alistServerId,
        path: file.path,
        password: password,
        name: file.name,
        providerInstanceName: _alistInstanceName,
      );
      if (mounted) {
        Navigator.pop(context);
        AppNotifications.showSuccess(context, context.l10n.addedSuccessfully);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.addFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addAlistDirectoryPlaylist(AlistItemInfo file) async {
    if (_alistServerId.isEmpty) {
      AppNotifications.showWarning(
        context,
        context.l10n.chooseBoundAlistAccount,
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final password = _alistPasswordController.text;
      final sourceConfig = <String, dynamic>{
        'serverId': _alistServerId,
        'path': file.path,
      };
      if (password.isNotEmpty) sourceConfig['password'] = password;
      await providerGateway.createPlaylist(
        widget.roomId,
        parentId: widget.parentId ?? '',
        sourceProvider: 'alist',
        providerInstanceName: _alistInstanceName,
        sourceConfig: sourceConfig,
        name: file.name,
      );
      if (mounted) {
        Navigator.pop(context);
        AppNotifications.showSuccess(
          context,
          context.l10n.dynamicPlaylistAdded,
        );
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.addFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addSelectedAlistItems() async {
    if (_selectedAlistItems.isEmpty) return;
    if (_alistServerId.isEmpty) {
      AppNotifications.showWarning(
        context,
        context.l10n.chooseBoundAlistAccount,
      );
      return;
    }
    setState(() => _isLoading = true);

    try {
      final List<Map<String, dynamic>> items = [];
      final List<AlistItemInfo> directories = [];
      final password = _alistPasswordController.text;
      for (final file in _selectedAlistItems.values) {
        final sourceConfig = <String, dynamic>{
          'serverId': _alistServerId,
          'path': file.path,
        };
        if (password.isNotEmpty) sourceConfig['password'] = password;
        if (file.isDir) {
          directories.add(file);
          continue;
        }
        items.add({
          'playlistId': widget.parentId ?? '',
          'sourceProvider':
              source_enum.SourceProvider.SOURCE_PROVIDER_ALIST.value,
          'providerInstanceName': _alistInstanceName,
          'sourceConfig': sourceConfig,
          'name': file.name,
        });
      }

      if (items.isNotEmpty) {
        await providerGateway.addMediaBatch(widget.roomId, items);
      }
      for (final directory in directories) {
        final sourceConfig = <String, dynamic>{
          'serverId': _alistServerId,
          'path': directory.path,
        };
        if (password.isNotEmpty) sourceConfig['password'] = password;
        await providerGateway.createPlaylist(
          widget.roomId,
          parentId: widget.parentId ?? '',
          sourceProvider: 'alist',
          providerInstanceName: _alistInstanceName,
          sourceConfig: sourceConfig,
          name: directory.name,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        AppNotifications.showSuccess(
          context,
          context.l10n.itemsAdded(_selectedAlistItems.length),
        );
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.batchAddFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadEmby(String path, {bool loadMore = false}) async {
    if (_embyBinds.isEmpty || _embyServerId.isEmpty) return;
    if (loadMore && _embyLoading) return;
    final targetPage = loadMore ? _embyPage + 1 : 1;
    final keyword = _embyKeyword;

    setState(() {
      _embyLoading = true;
      if (!loadMore) {
        _embyPath = path;
        _embyFiles = [];
      }
    });
    try {
      final pageInfo = await providerGateway.listEmbyPage(
        path,
        keyword: keyword,
        page: targetPage,
        max: _pageSize,
        serverId: _embyServerId,
        instanceName: _embyInstanceName,
      );
      final newItems = pageInfo.items;
      final total = pageInfo.total;
      if (mounted) {
        setState(() {
          _embyServerId = pageInfo.serverId;
          _embyInstanceName = pageInfo.providerInstanceName;
          if (loadMore) {
            _embyFiles.addAll(newItems);
            _embyPage = targetPage;
          } else {
            _embyFiles = newItems;
            _embyPage = 1;
          }
          _embyHasMore = _embyFiles.length < total;
        });
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.loadFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _embyLoading = false);
    }
  }

  void _searchEmby() {
    final keyword = _embySearchController.text.trim();
    if (keyword == _embyKeyword) return;
    setState(() {
      _embyKeyword = keyword;
      _embyPage = 1;
      _embyHasMore = true;
    });
    _loadEmby(_embyPath);
  }

  void _clearEmbySearch() {
    if (_embyKeyword.isEmpty && _embySearchController.text.isEmpty) return;
    _embySearchController.clear();
    setState(() {
      _embyKeyword = '';
      _embyPage = 1;
      _embyHasMore = true;
    });
    _loadEmby(_embyPath);
  }

  void _enterEmbyDir(String name, String pathOrId) {
    if (_embyKeyword.isNotEmpty) {
      _embySearchController.clear();
      setState(() => _embyKeyword = '');
    }
    _loadEmby(
      (pathOrId.contains('/') || pathOrId.length > 20)
          ? pathOrId
          : (_embyPath.endsWith('/') ? '$_embyPath$name' : '$_embyPath/$name'),
    );
  }

  void _goUpEmby() {
    if (_embyPath.isEmpty || _embyPath == '/') return;
    if (_embyKeyword.isNotEmpty) {
      _clearEmbySearch();
      return;
    }
    final parts = _embyPath.split('/');
    parts.removeLast();
    _loadEmby(parts.length == 1 && parts[0] == '' ? '' : parts.join('/'));
  }

  Future<void> _addEmbyFile(EmbyItemInfo file) async {
    if (_embyServerId.isEmpty) {
      AppNotifications.showWarning(
        context,
        context.l10n.chooseBoundEmbyAccount,
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final itemId = file.id;
      if (itemId.isEmpty) {
        throw Exception(context.l10n.embyMediaIdUnavailable);
      }
      await providerGateway.addEmbyMedia(
        widget.roomId,
        playlistId: widget.parentId ?? '',
        serverId: _embyServerId,
        itemId: itemId,
        name: file.name.isEmpty ? 'Emby Video' : file.name,
        providerInstanceName: _embyInstanceName,
      );
      if (mounted) {
        Navigator.pop(context);
        AppNotifications.showSuccess(context, context.l10n.addedSuccessfully);
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.addFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addEmbyDirectoryPlaylist(EmbyItemInfo file) async {
    if (_embyServerId.isEmpty) {
      AppNotifications.showWarning(
        context,
        context.l10n.chooseBoundEmbyAccount,
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final itemId = file.id;
      if (itemId.isEmpty) {
        throw Exception(context.l10n.embyDirectoryIdUnavailable);
      }
      await providerGateway.createPlaylist(
        widget.roomId,
        parentId: widget.parentId ?? '',
        sourceProvider: 'emby',
        providerInstanceName: _embyInstanceName,
        sourceConfig: {
          'serverId': _embyServerId,
          'source': {'type': 'folder', 'itemId': itemId},
        },
        name: file.name.isEmpty ? 'Emby Playlist' : file.name,
      );
      if (mounted) {
        Navigator.pop(context);
        AppNotifications.showSuccess(
          context,
          context.l10n.dynamicPlaylistAdded,
        );
      }
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.addFailed('$e'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
