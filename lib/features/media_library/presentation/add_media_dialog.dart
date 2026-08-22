import 'dart:async';

import 'package:flutter/services.dart';
import 'package:synctv_app/contracts/discovered_source.dart';
import 'package:synctv_app/contracts/synctv_api_types.dart';
import 'package:synctv_app/core/config/distribution_profile.dart';
import 'package:flutter/material.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/features/providers/presentation/provider_gateway_scope.dart';
import 'package:synctv_app/src/generated/proto/source_config.pbenum.dart'
    as source_enum;
import 'package:synctv_app/src/generated/proto/client.pbenum.dart'
    as client_enum;
import 'package:synctv_app/theme/app_responsive.dart';
import 'package:synctv_app/core/presentation/notifications/app_notifications.dart';
import 'package:synctv_app/core/presentation/dialogs/app_dialogs.dart';
import 'package:synctv_app/core/presentation/media_provider_brand.dart';
import 'package:synctv_app/core/presentation/media_variant_label.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/acfun_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/bilibili_playlist_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/cctv_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/douyin_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/douyu_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/discovery_browser.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/emby_playlist_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/fnos_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/huya_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/nextcloud_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/playback_proxy_mode_control.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_add_target.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_workspace.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_account_action.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/qnap_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/seafile_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/tiktok_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/twitch_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/truenas_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/youtube_add_media_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/synology_add_media_form.dart';
import 'package:synctv_app/features/providers/presentation/binding/platform_binding_dialog.dart';
import 'package:synctv_app/src/generated/proto/providers/common.pb.dart'
    as provider_common;

class AddMediaDialog extends StatefulWidget {
  final String roomId;
  final String? parentId;
  final ProviderDistributionPolicy distributionPolicy;
  final VoidCallback? onCompactClose;
  final DateTime Function() now;

  const AddMediaDialog({
    super.key,
    required this.roomId,
    this.parentId,
    this.distributionPolicy = ProviderDistributionPolicy.current,
    this.onCompactClose,
    this.now = DateTime.now,
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
        final compact = MediaQuery.sizeOf(context).width < 720;
        return AppDialogFrame(
          maxWidth: 1280,
          allowWide: true,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: compact
              ? AddMediaDialog(
                  key: dialogKey,
                  roomId: roomId,
                  parentId: parentId,
                  onCompactClose: () => dialogKey.currentState?._requestClose(),
                )
              : SizedBox(
                  width: double.infinity,
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

enum _LivePullProtocol { rtmp, rtsp, httpFlv }

enum _RtspTrackMode { firstCompatible, explicitIndex, disabled }

class _AddMediaDialogState extends State<AddMediaDialog> {
  int _selectedIndex = 0;

  final _urlController = TextEditingController();
  final _urlFocusNode = FocusNode();
  final _nameController = TextEditingController();
  final _liveProxyUrlController = TextEditingController();
  final _liveProxyNameController = TextEditingController();
  final _liveProxyVideoTrackIndexController = TextEditingController(text: '0');
  final _liveProxyAudioTrackIndexController = TextEditingController(text: '0');
  final _biliUrlController = TextEditingController();
  final _alistSearchController = TextEditingController();
  final _alistPasswordController = TextEditingController();
  final _embySearchController = TextEditingController();
  final _cloudreveSearchController = TextEditingController();
  final _sourceSearchController = TextEditingController();
  final _directSelection = DiscoverySelectionController();
  final _bilibiliSelection = DiscoverySelectionController();
  final _alistSelection = DiscoverySelectionController();
  final _embySelection = DiscoverySelectionController();
  final _cloudreveSelection = DiscoverySelectionController();

  source_enum.PlaybackProxyMode _directProxyMode =
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;
  source_enum.PlaybackProxyMode _bilibiliProxyMode =
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;
  source_enum.PlaybackProxyMode _alistProxyMode =
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;
  source_enum.PlaybackProxyMode _embyProxyMode =
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;
  source_enum.PlaybackProxyMode _cloudreveProxyMode =
      source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO;
  source_enum.PlaybackKind _directPlaybackKind =
      source_enum.PlaybackKind.PLAYBACK_KIND_REGULAR;
  bool _isLoading = false;
  String _directHeaderError = '';
  List<provider_common.PreparedMediaSource> _directPreview = const [];
  source_enum.RtmpStreamMode _rtmpPublishMode =
      source_enum.RtmpStreamMode.RTMP_STREAM_MODE_DEFAULT;
  provider_common.PreparedMediaSource? _rtmpPreview;
  client_enum.PublishKeyType _rtmpPublishKeyType =
      client_enum.PublishKeyType.PUBLISH_KEY_TYPE_SINGLE_USE;
  late DateTime _rtmpPublishExpiresAt;
  _LivePullProtocol _liveProxyProtocol = _LivePullProtocol.rtmp;
  source_enum.RtmpStreamMode _liveProxyRtmpMode =
      source_enum.RtmpStreamMode.RTMP_STREAM_MODE_DEFAULT;
  source_enum.RtspTransport _liveProxyRtspTransport =
      source_enum.RtspTransport.RTSP_TRANSPORT_TCP;
  _RtspTrackMode _liveProxyVideoTrackMode = _RtspTrackMode.firstCompatible;
  _RtspTrackMode _liveProxyAudioTrackMode = _RtspTrackMode.firstCompatible;
  provider_common.PreparedMediaSource? _liveProxyPreview;

  BilibiliParseInfo? _biliInfo;
  int _biliSelectedIndex = 0;
  bool _bilibiliShared = false;
  BilibiliPlaylistListPage? _biliPreview;

  String _alistPath = '/';
  List<AlistItemInfo> _alistFiles = [];
  bool _alistLoading = false;
  int _alistPage = 1;
  int _alistTotal = 0;
  bool _alistHasMore = true;
  String _alistServerId = '';
  String _alistInstanceName = '';
  String _alistKeyword = '';
  String _alistPassword = '';
  List<AlistBindInfo> _alistBinds = [];
  static const int _pageSize = 20;
  provider_common.DiscoveredSource? _alistListSource;
  final List<_DirectHeaderDraft> _directHeaders = [];

  String _embyPath = '';
  final List<(String, String)> _embyBreadcrumbs = [];
  List<EmbyItemInfo> _embyFiles = [];
  bool _embyLoading = false;
  int _embyPage = 1;
  int _embyTotal = 0;
  bool _embyHasMore = true;
  String _embyServerId = '';
  String _embyInstanceName = '';
  String _embyKeyword = '';
  List<EmbyBindInfo> _embyBinds = [];
  provider_common.DiscoveredSource? _embyListSource;
  bool _embyPlaylistMode = false;
  bool _embyPlaylistHasDraft = false;

  String _cloudrevePath = 'cloudreve://my/';
  List<CloudreveItemInfo> _cloudreveFiles = [];
  bool _cloudreveLoading = false;
  int _cloudrevePage = 1;
  int _cloudreveTotal = 0;
  bool _cloudreveUsesCursor = false;
  String _cloudreveNextCursor = '';
  bool _cloudreveHasMore = true;
  String _cloudreveServerId = '';
  String _cloudreveInstanceName = '';
  String _cloudreveKeyword = '';
  List<CloudreveBindInfo> _cloudreveBinds = [];
  provider_common.DiscoveredSource? _cloudreveListSource;

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
  ProviderAddTarget _bilibiliTarget = ProviderAddTarget.parse;
  bool _bilibiliPlaylistHasDraft = false;

  final Set<String> _loadingVendors = {};
  final Map<String, int> _vendorLoadRevisions = {};
  int _vendorErrorGeneration = 0;
  int _notifiedVendorErrorGeneration = 0;
  PublicSettingsInfo? _publicSettings;
  bool _dependenciesInitialized = false;

  bool get _checkingVendors => _loadingVendors.isNotEmpty;

  List<String> get _boundVendors => [
    if (_alistBinds.isNotEmpty) 'alist',
    if (_embyBinds.isNotEmpty) 'emby',
    if (_bilibiliBinds.isNotEmpty) 'bilibili',
    if (_cloudreveBinds.isNotEmpty) 'cloudreve',
    if (_twitchBinds.isNotEmpty) 'twitch',
    if (_fnosBinds.isNotEmpty) 'fnos',
    if (_qnapBinds.isNotEmpty) 'qnap',
    if (_synologyBinds.isNotEmpty) 'synology',
    if (_nextcloudBinds.isNotEmpty) 'nextcloud',
    if (_seafileBinds.isNotEmpty) 'seafile',
    if (_trueNasBinds.isNotEmpty) 'truenas',
    if (_youtubeBinds.isNotEmpty) 'youtube',
    if (_douyinBinds.isNotEmpty) 'douyin',
    if (_tiktokBinds.isNotEmpty) 'tiktok',
  ];

  @override
  void initState() {
    super.initState();
    _rtmpPublishExpiresAt = widget.now().add(const Duration(hours: 1));
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
    final errorGeneration = ++_vendorErrorGeneration;
    final providerTypes = widget.distributionPolicy.includesThirdPartyProviders
        ? const [
            'alist',
            'emby',
            'bilibili',
            'cloudreve',
            'twitch',
            'fnos',
            'qnap',
            'huya',
            'douyu',
            'acfun',
            'cctv',
            'publicSettings',
            'synology',
            'nextcloud',
            'seafile',
            'truenas',
            'youtube',
            'douyin',
            'tiktok',
          ]
        : const [
            'alist',
            'emby',
            'cloudreve',
            'fnos',
            'qnap',
            'publicSettings',
            'synology',
            'nextcloud',
            'seafile',
            'truenas',
          ];
    try {
      await Future.wait(
        providerTypes.map(
          (providerType) =>
              _refreshVendor(providerType, errorGeneration: errorGeneration),
        ),
      );
    } catch (error) {
      if (!mounted || _notifiedVendorErrorGeneration == errorGeneration) {
        return;
      }
      _notifiedVendorErrorGeneration = errorGeneration;
      AppNotifications.showError(
        context,
        context.l10n.loadMediaBindingsFailed('$error'),
      );
    }
  }

  Future<void> _openProviderBinding(String providerType) async {
    await PlatformBindingDialog.show(
      context,
      initialProviderType: providerType,
    );
    await _refreshVendor(providerType);
    if (!mounted) return;
    switch (providerType) {
      case 'alist' when _alistBinds.isNotEmpty:
        _loadAlist(_alistPath);
      case 'emby' when _embyBinds.isNotEmpty:
        _loadEmby(_embyPath);
      case 'cloudreve' when _cloudreveBinds.isNotEmpty:
        _loadCloudreve(_cloudrevePath);
    }
  }

  Future<void> _refreshVendor(String providerType, {int? errorGeneration}) {
    final generation = errorGeneration ?? ++_vendorErrorGeneration;
    return switch (providerType) {
      'alist' => _loadVendor(
        providerType,
        providerGateway.getAllAlistBindInfos,
        (value) => _alistBinds = value,
        generation,
      ),
      'emby' => _loadVendor(
        providerType,
        providerGateway.getAllEmbyBindInfos,
        (value) => _embyBinds = value,
        generation,
      ),
      'bilibili' => _loadVendor(
        providerType,
        providerGateway.getAllBilibiliBindInfos,
        (value) => _bilibiliBinds = value,
        generation,
      ),
      'cloudreve' => _loadVendor(
        providerType,
        providerGateway.getAllCloudreveBindInfos,
        (value) => _cloudreveBinds = value,
        generation,
      ),
      'twitch' => _loadVendor(
        providerType,
        providerGateway.getAllTwitchBindInfos,
        (value) => _twitchBinds = value,
        generation,
      ),
      'fnos' => _loadVendor(
        providerType,
        providerGateway.getAllFnosBindInfos,
        (value) => _fnosBinds = value,
        generation,
      ),
      'qnap' => _loadVendor(
        providerType,
        providerGateway.getAllQnapBindInfos,
        (value) => _qnapBinds = value,
        generation,
      ),
      'synology' => _loadVendor(
        providerType,
        providerGateway.getAllSynologyBindInfos,
        (value) => _synologyBinds = value,
        generation,
      ),
      'nextcloud' => _loadVendor(
        providerType,
        providerGateway.getAllNextcloudBindInfos,
        (value) => _nextcloudBinds = value,
        generation,
      ),
      'seafile' => _loadVendor(
        providerType,
        providerGateway.getAllSeafileBindInfos,
        (value) => _seafileBinds = value,
        generation,
      ),
      'truenas' => _loadVendor(
        providerType,
        providerGateway.getAllTrueNasBindInfos,
        (value) => _trueNasBinds = value,
        generation,
      ),
      'youtube' => _loadVendor(
        providerType,
        providerGateway.getAllYoutubeBindInfos,
        (value) => _youtubeBinds = value,
        generation,
      ),
      'douyin' => _loadVendor(
        providerType,
        providerGateway.getAllDouyinBindInfos,
        (value) => _douyinBinds = value,
        generation,
      ),
      'tiktok' => _loadVendor(
        providerType,
        providerGateway.getAllTikTokBindInfos,
        (value) => _tiktokBinds = value,
        generation,
      ),
      'huya' || 'douyu' || 'acfun' || 'cctv' => _loadVendor(
        providerType,
        () => providerGateway.listAvailableProviderInstances(
          providerType: providerType,
        ),
        (value) => _setProviderInstances(providerType, value),
        generation,
      ),
      'publicSettings' => _loadVendor(
        providerType,
        providerGateway.getPublicSettings,
        (value) => _publicSettings = value,
        generation,
      ),
      _ => Future<void>.value(),
    };
  }

  Future<void> _loadVendor<T>(
    String providerType,
    Future<T> Function() load,
    void Function(T value) apply,
    int errorGeneration,
  ) async {
    final revision = (_vendorLoadRevisions[providerType] ?? 0) + 1;
    _vendorLoadRevisions[providerType] = revision;
    if (mounted) setState(() => _loadingVendors.add(providerType));
    try {
      final value = await load();
      if (!mounted || _vendorLoadRevisions[providerType] != revision) return;
      setState(() {
        apply(value);
        _applyDefaultProviderBindings();
        _loadingVendors.remove(providerType);
      });
    } catch (error) {
      if (!mounted || _vendorLoadRevisions[providerType] != revision) return;
      setState(() => _loadingVendors.remove(providerType));
      if (_notifiedVendorErrorGeneration == errorGeneration) return;
      _notifiedVendorErrorGeneration = errorGeneration;
      AppNotifications.showError(
        context,
        context.l10n.loadMediaBindingsFailed('$error'),
      );
    }
  }

  void _setProviderInstances(String providerType, List<String> instances) {
    final available = {'', ...instances}.toList();
    switch (providerType) {
      case 'huya':
        _huyaInstances = available;
      case 'douyu':
        _douyuInstances = available;
      case 'acfun':
        _acfunInstances = available;
      case 'cctv':
        _cctvInstances = available;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _urlFocusNode.dispose();
    _nameController.dispose();
    _liveProxyUrlController.dispose();
    _liveProxyNameController.dispose();
    _liveProxyVideoTrackIndexController.dispose();
    _liveProxyAudioTrackIndexController.dispose();
    for (final header in _directHeaders) {
      header.dispose();
    }
    _biliUrlController.dispose();
    _alistSearchController.dispose();
    _alistPasswordController.dispose();
    _embySearchController.dispose();
    _cloudreveSearchController.dispose();
    _sourceSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final availableHeight = AppMetrics.dialogMaxHeight(context, null);
    final contentHeight = availableHeight.clamp(420.0, 820.0);

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final narrow = constraints.maxWidth < 720;
            if (narrow) {
              return Column(
                children: [
                  _buildCompactSourceRail(theme),
                  Expanded(child: _buildSourcePanel(theme, compact: true)),
                ],
              );
            }
            // This threshold only depends on the dialog width. The source rail
            // therefore keeps a stable width while its content changes.
            final sourceDetails = constraints.maxWidth >= 1220;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: sourceDetails ? 236 : 68,
                  child: _buildSourceRail(theme, iconOnly: !sourceDetails),
                ),
                AppVerticalDivider(
                  width: 1,
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.7,
                  ),
                ),
                Expanded(child: _buildSourcePanel(theme)),
              ],
            );
          },
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
          .map((spec) {
            final providerType = _providerTypeForSourceIndex(spec.index);
            if (providerType == null) return spec;
            final brand = mediaProviderBrand(providerType);
            return _MediaSourceSpec(
              index: spec.index,
              title: spec.title,
              subtitle: spec.subtitle,
              icon: brand.icon,
              color: brand.color,
            );
          })
          .where((spec) {
            final providerType = _providerTypeForSourceIndex(spec.index);
            return providerType == null ||
                widget.distributionPolicy.allowsProvider(providerType);
          })
          .toList(growable: false);

  List<_MediaSourceSpec> get _filteredSourceSpecs {
    final keyword = _sourceSearchController.text.trim().toLowerCase();
    if (keyword.isEmpty) return _sourceSpecs;
    return _sourceSpecs
        .where(
          (spec) =>
              spec.title.toLowerCase().contains(keyword) ||
              spec.subtitle.toLowerCase().contains(keyword),
        )
        .toList(growable: false);
  }

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

  Widget _buildSourceRail(ThemeData theme, {required bool iconOnly}) {
    return AppPanelSurface(
      color: theme.colorScheme.surfaceContainerLow,
      padding: EdgeInsets.all(iconOnly ? 8 : 12),
      borderRadius: BorderRadius.zero,
      clipBehavior: Clip.none,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!iconOnly) ...[
            Text(
              context.l10n.source,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            AppSearchField(
              controller: _sourceSearchController,
              hintText: context.l10n.search,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) {},
            ),
            const SizedBox(height: 8),
          ],
          Expanded(
            child: AppListView.separated(
              padding: EdgeInsets.zero,
              itemCount:
                  (iconOnly ? _sourceSpecs : _filteredSourceSpecs).length,
              separatorBuilder: (_, _) => SizedBox(height: iconOnly ? 8 : 6),
              itemBuilder: (context, index) => _buildSourceTile(
                theme,
                (iconOnly ? _sourceSpecs : _filteredSourceSpecs)[index],
                iconOnly: iconOnly,
              ),
            ),
          ),
          if (!iconOnly) ...[
            const SizedBox(height: 8),
            Text(
              context.l10n.connectedMediaSources(_boundVendors.length),
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (_checkingVendors) ...[
              const SizedBox(height: 6),
              const AppLinearProgress(minHeight: 2),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildCompactSourceRail(ThemeData theme) {
    final selectedSpec = _sourceSpecs.firstWhere(
      (spec) => spec.index == _selectedIndex,
    );
    return AppPanelSurface(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      color: theme.colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.zero,
      border: Border(
        bottom: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      clipBehavior: Clip.none,
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<int>(
              key: ValueKey('add-media-source-selector-$_selectedIndex'),
              initialValue: _selectedIndex,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: context.l10n.source,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                prefixIcon: Icon(selectedSpec.icon, color: selectedSpec.color),
              ),
              menuMaxHeight: 420,
              selectedItemBuilder: (context) => [
                for (final spec in _sourceSpecs)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      spec.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              items: [
                for (final spec in _sourceSpecs)
                  DropdownMenuItem<int>(
                    value: spec.index,
                    child: Row(
                      children: [
                        Icon(
                          spec.icon,
                          key: ValueKey(
                            'add-media-provider-icon-${spec.index}',
                          ),
                          size: 18,
                          color: spec.color,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            spec.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
              onChanged: (index) {
                if (index != null) _selectSource(index);
              },
            ),
          ),
          if (widget.onCompactClose case final onClose?) ...[
            const SizedBox(width: 8),
            AppIconButton(
              onPressed: onClose,
              icon: Icons.close_rounded,
              tooltip: context.l10n.close,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSourceTile(
    ThemeData theme,
    _MediaSourceSpec spec, {
    bool iconOnly = false,
  }) {
    final selected = _selectedIndex == spec.index;
    final surface = AppInkSurface(
      key: ValueKey('add-media-source-tile-${spec.index}'),
      color: selected
          ? spec.color.withValues(alpha: 0.13)
          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.38),
      borderRadius: BorderRadius.circular(8),
      onTap: () => _selectSource(spec.index),
      child: AppPanelSurface(
        padding: EdgeInsets.symmetric(
          horizontal: iconOnly ? 8 : 11,
          vertical: iconOnly ? 8 : 10,
        ),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: selected
              ? spec.color.withValues(alpha: 0.55)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        clipBehavior: Clip.none,
        child: iconOnly
            ? Semantics(
                label: '${spec.title}: ${spec.subtitle}',
                child: Center(
                  child: AppIconBadge(
                    icon: spec.icon,
                    color: spec.color,
                    size: 32,
                    iconSize: 20,
                    backgroundAlpha: selected ? 0.18 : 0.12,
                  ),
                ),
              )
            : Row(
                children: [
                  AppIconBadge(
                    icon: spec.icon,
                    color: spec.color,
                    size: 32,
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
    return iconOnly
        ? Tooltip(message: '${spec.title}\n${spec.subtitle}', child: surface)
        : surface;
  }

  Widget _buildSourcePanel(ThemeData theme, {bool compact = false}) {
    final selectedSpec = _sourceSpecs.firstWhere(
      (spec) => spec.index == _selectedIndex,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppPanelSurface(
          height: compact ? 48 : 52,
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
              AppIconBadge(
                key: ValueKey('selected-provider-icon-$_selectedIndex'),
                icon: selectedSpec.icon,
                color: selectedSpec.color,
                size: 30,
                iconSize: 18,
                backgroundAlpha: 0.12,
              ),
              const SizedBox(width: 10),
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
              if (_selectedSourceSelectionCount > 0) ...[
                const SizedBox(width: 8),
                AppChip(
                  avatar: const Icon(Icons.check_circle_outline_rounded),
                  label: Text(
                    compact
                        ? '$_selectedSourceSelectionCount'
                        : context.l10n.selectedCount(
                            _selectedSourceSelectionCount,
                          ),
                  ),
                  style: AppChipStyle.outlined,
                ),
              ],
              if (_providerBindingType(_selectedIndex) != null)
                compact
                    ? AppIconButton(
                        onPressed: () => _openProviderBinding(
                          _providerBindingType(_selectedIndex)!,
                        ),
                        icon: Icons.link_rounded,
                        tooltip: context.l10n.manageConnections,
                      )
                    : AppActionButton(
                        onPressed: () => _openProviderBinding(
                          _providerBindingType(_selectedIndex)!,
                        ),
                        icon: Icons.link_rounded,
                        label: context.l10n.manageConnections,
                        style: AppActionButtonStyle.text,
                      ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: compact
                ? const EdgeInsets.all(8)
                : const EdgeInsets.fromLTRB(18, 10, 18, 10),
            child: _buildContent(theme),
          ),
        ),
      ],
    );
  }

  int get _selectedSourceSelectionCount => switch (_selectedIndex) {
    3 => _bilibiliSelection.length,
    4 => _alistSelection.length,
    5 => _embySelection.length,
    6 => _cloudreveSelection.length,
    _ => 0,
  };

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
        if (_fnosBinds.isEmpty && _loadingVendors.contains('fnos')) {
          return const AppLoadingIndicator();
        }
        return FnosAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          binds: _fnosBinds,
          onDraftChanged: (value) => _fnosHasDraft = value,
          onOpenBinding: () => _openProviderBinding('fnos'),
        );
      case 13:
        if (_qnapBinds.isEmpty && _loadingVendors.contains('qnap')) {
          return const AppLoadingIndicator();
        }
        return QnapAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          binds: _qnapBinds,
          onDraftChanged: (value) => _qnapHasDraft = value,
          onOpenBinding: () => _openProviderBinding('qnap'),
        );
      case 14:
        if (_synologyBinds.isEmpty && _loadingVendors.contains('synology')) {
          return const AppLoadingIndicator();
        }
        return SynologyAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          binds: _synologyBinds,
          onDraftChanged: (value) => _synologyHasDraft = value,
          onOpenBinding: () => _openProviderBinding('synology'),
        );
      case 15:
        if (_nextcloudBinds.isEmpty && _loadingVendors.contains('nextcloud')) {
          return const AppLoadingIndicator();
        }
        return NextcloudAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          binds: _nextcloudBinds,
          onDraftChanged: (value) => _nextcloudHasDraft = value,
          onOpenBinding: () => _openProviderBinding('nextcloud'),
        );
      case 16:
        if (_seafileBinds.isEmpty && _loadingVendors.contains('seafile')) {
          return const AppLoadingIndicator();
        }
        return SeafileAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          binds: _seafileBinds,
          onDraftChanged: (value) => _seafileHasDraft = value,
          onOpenBinding: () => _openProviderBinding('seafile'),
        );
      case 17:
        if (_trueNasBinds.isEmpty && _loadingVendors.contains('truenas')) {
          return const AppLoadingIndicator();
        }
        return TrueNasAddMediaForm(
          roomId: widget.roomId,
          playlistId: widget.parentId ?? '',
          binds: _trueNasBinds,
          onDraftChanged: (value) => _trueNasHasDraft = value,
          onOpenBinding: () => _openProviderBinding('truenas'),
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
    return _buildActionForm(
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
          onChanged: (_) => setState(() {
            _directPreview = const [];
            _directSelection.clear();
          }),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final nameField = _buildDirectTextField(
              controller: _nameController,
              label: constraints.maxWidth < 520
                  ? context.l10n.name
                  : context.l10n.optionalVideoName,
              hintText: context.l10n.defaultsToFileName,
              prefixIcon: Icons.title_rounded,
              textInputAction: TextInputAction.next,
              enabled: !_isLoading,
              onChanged: (_) => setState(() {}),
            );
            final playbackKindControl = _buildDirectPlaybackKindControl();
            if (constraints.maxWidth >= 560) {
              return Row(
                children: [
                  Expanded(child: nameField),
                  const SizedBox(width: 12),
                  SizedBox(width: 220, child: playbackKindControl),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                playbackKindControl,
                const SizedBox(height: 10),
                nameField,
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        _buildDirectHeadersEditor(theme),
        const SizedBox(height: 12),
        PlaybackProxyModeControl(
          value: _directProxyMode,
          enabled: !_isLoading,
          source: _directPlaybackPolicySource,
          onChanged: (value) => setState(() => _directProxyMode = value),
        ),
        if (_directPreview.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(height: 280, child: _buildDirectPreview()),
        ],
      ],
      actions: [
        OutlinedButton.icon(
          key: const Key('direct-url-preview'),
          onPressed: _isLoading || _urlController.text.trim().isEmpty
              ? null
              : _prepareDirectLinks,
          icon: const Icon(Icons.preview_outlined),
          label: Text(context.l10n.preview),
        ),
      ],
    );
  }

  Widget _buildActionForm({
    required List<Widget> children,
    required List<Widget> actions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: AppSingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
        const SizedBox(height: 10),
        const AppDivider(height: 1),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.end,
          spacing: 10,
          runSpacing: 10,
          children: actions,
        ),
      ],
    );
  }

  Widget _buildDirectPlaybackKindControl() {
    return Semantics(
      label: context.l10n.playbackKind,
      child: SegmentedButton<source_enum.PlaybackKind>(
        style: const ButtonStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 6)),
          minimumSize: WidgetStatePropertyAll(Size(0, 40)),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
          textStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 13, letterSpacing: 0),
          ),
        ),
        segments: [
          ButtonSegment(
            value: source_enum.PlaybackKind.PLAYBACK_KIND_REGULAR,
            label: Text(context.l10n.onDemand),
          ),
          ButtonSegment(
            value: source_enum.PlaybackKind.PLAYBACK_KIND_LIVE,
            label: Text(context.l10n.live),
          ),
        ],
        selected: {_directPlaybackKind},
        onSelectionChanged: _isLoading
            ? null
            : (selection) {
                setState(() {
                  _directPlaybackKind = selection.single;
                  _directPreview = const [];
                  _directSelection.clear();
                });
              },
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
    int? maxLines = 1,
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
    return _buildActionForm(
      children: [
        _buildTextField(
          theme,
          _nameController,
          context.l10n.liveName,
          context.l10n.liveNameHint,
          Icons.live_tv_rounded,
        ),
        const SizedBox(height: 12),
        AppSelect<source_enum.RtmpStreamMode>(
          value: _rtmpPublishMode,
          label: context.l10n.streamMode,
          prefixIcon: Icons.tune_rounded,
          options: {
            context.l10n.audioAndVideo:
                source_enum.RtmpStreamMode.RTMP_STREAM_MODE_DEFAULT,
            context.l10n.videoOnly:
                source_enum.RtmpStreamMode.RTMP_STREAM_MODE_VIDEO_ONLY,
            context.l10n.audioOnly:
                source_enum.RtmpStreamMode.RTMP_STREAM_MODE_AUDIO_ONLY,
          },
          enabled: !_isLoading,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _rtmpPublishMode = value;
                _rtmpPreview = null;
              });
            }
          },
        ),
        const SizedBox(height: 18),
        AppSelect<client_enum.PublishKeyType>(
          key: const Key('rtmp-publish-key-type'),
          value: _rtmpPublishKeyType,
          label: context.l10n.publishKeyType,
          prefixIcon: Icons.key_rounded,
          options: {
            context.l10n.singleUsePublishKey:
                client_enum.PublishKeyType.PUBLISH_KEY_TYPE_SINGLE_USE,
            context.l10n.expiringPublishKey:
                client_enum.PublishKeyType.PUBLISH_KEY_TYPE_EXPIRING,
            context.l10n.permanentPublishKey:
                client_enum.PublishKeyType.PUBLISH_KEY_TYPE_PERMANENT,
          },
          enabled: !_isLoading,
          onChanged: (value) {
            if (value != null) setState(() => _rtmpPublishKeyType = value);
          },
        ),
        const SizedBox(height: 12),
        if (_rtmpPublishKeyType ==
            client_enum.PublishKeyType.PUBLISH_KEY_TYPE_PERMANENT)
          _buildInlineNotice(
            theme,
            icon: Icons.warning_amber_rounded,
            title: context.l10n.permanentPublishKey,
            subtitle: context.l10n.permanentPublishKeyDescription,
            color: Colors.orange.shade700,
          )
        else
          OutlinedButton.icon(
            key: const Key('rtmp-publish-key-expiration'),
            onPressed: _isLoading ? null : _selectRtmpPublishExpiration,
            icon: const Icon(Icons.schedule_rounded),
            label: Text(
              '${context.l10n.expirationTime}: '
              '${_formatDateTime(_rtmpPublishExpiresAt)}',
            ),
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
        if (_rtmpPreview case final preview?) ...[
          const SizedBox(height: 16),
          _buildPreparedSourceCard(preview, icon: Icons.live_tv_rounded),
        ],
      ],
      actions: [
        OutlinedButton.icon(
          key: const Key('rtmp-preview'),
          onPressed: _isLoading ? null : _prepareRtmpPublish,
          icon: const Icon(Icons.preview_outlined),
          label: Text(context.l10n.preview),
        ),
        FilledButton.icon(
          key: const Key('rtmp-submit'),
          onPressed: _isLoading || _rtmpPreview == null
              ? null
              : _addRtmpPublish,
          icon: const Icon(Icons.live_tv_rounded),
          label: Text(context.l10n.createPublishingEntry),
        ),
      ],
    );
  }

  Widget _buildLiveProxyContent(ThemeData theme) {
    return _buildActionForm(
      children: [
        SegmentedButton<_LivePullProtocol>(
          segments: [
            const ButtonSegment(
              value: _LivePullProtocol.rtmp,
              label: Text('RTMP'),
              icon: Icon(Icons.podcasts_rounded),
            ),
            const ButtonSegment(
              value: _LivePullProtocol.rtsp,
              label: Text('RTSP'),
              icon: Icon(Icons.videocam_outlined),
            ),
            const ButtonSegment(
              value: _LivePullProtocol.httpFlv,
              label: Text('HTTP-FLV'),
              icon: Icon(Icons.http_rounded),
            ),
          ],
          selected: {_liveProxyProtocol},
          onSelectionChanged: _isLoading
              ? null
              : (selection) {
                  setState(() {
                    _liveProxyProtocol = selection.single;
                    _liveProxyPreview = null;
                  });
                },
        ),
        const SizedBox(height: 12),
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
          onChanged: (_) => setState(() => _liveProxyPreview = null),
        ),
        if (_liveProxyProtocol == _LivePullProtocol.rtmp) ...[
          const SizedBox(height: 12),
          AppSelect<source_enum.RtmpStreamMode>(
            value: _liveProxyRtmpMode,
            label: context.l10n.streamMode,
            prefixIcon: Icons.tune_rounded,
            options: {
              context.l10n.audioAndVideo:
                  source_enum.RtmpStreamMode.RTMP_STREAM_MODE_DEFAULT,
              context.l10n.videoOnly:
                  source_enum.RtmpStreamMode.RTMP_STREAM_MODE_VIDEO_ONLY,
              context.l10n.audioOnly:
                  source_enum.RtmpStreamMode.RTMP_STREAM_MODE_AUDIO_ONLY,
            },
            enabled: !_isLoading,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _liveProxyRtmpMode = value;
                  _liveProxyPreview = null;
                });
              }
            },
          ),
        ],
        if (_liveProxyProtocol == _LivePullProtocol.rtsp) ...[
          const SizedBox(height: 12),
          AppSelect<source_enum.RtspTransport>(
            value: _liveProxyRtspTransport,
            label: context.l10n.rtspTransport,
            prefixIcon: Icons.swap_horiz_rounded,
            options: {
              'TCP': source_enum.RtspTransport.RTSP_TRANSPORT_TCP,
              'UDP': source_enum.RtspTransport.RTSP_TRANSPORT_UDP,
            },
            enabled: !_isLoading,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _liveProxyRtspTransport = value;
                  _liveProxyPreview = null;
                });
              }
            },
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final video = _buildRtspTrackControl(
                label: context.l10n.videoTrack,
                icon: Icons.videocam_outlined,
                mode: _liveProxyVideoTrackMode,
                indexController: _liveProxyVideoTrackIndexController,
                onChanged: (value) {
                  setState(() {
                    _liveProxyVideoTrackMode = value;
                    _liveProxyPreview = null;
                  });
                },
              );
              final audio = _buildRtspTrackControl(
                label: context.l10n.audioTrack,
                icon: Icons.audiotrack_rounded,
                mode: _liveProxyAudioTrackMode,
                indexController: _liveProxyAudioTrackIndexController,
                onChanged: (value) {
                  setState(() {
                    _liveProxyAudioTrackMode = value;
                    _liveProxyPreview = null;
                  });
                },
              );
              if (constraints.maxWidth < 560) {
                return Column(
                  children: [video, const SizedBox(height: 12), audio],
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: video),
                  const SizedBox(width: 12),
                  Expanded(child: audio),
                ],
              );
            },
          ),
        ],
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
        if (_liveProxyPreview case final preview?) ...[
          const SizedBox(height: 16),
          _buildPreparedSourceCard(preview, icon: Icons.sensors_rounded),
        ],
      ],
      actions: [
        OutlinedButton.icon(
          key: const Key('live-proxy-preview'),
          onPressed: _isLoading || _liveProxyUrlController.text.trim().isEmpty
              ? null
              : _prepareLiveProxy,
          icon: const Icon(Icons.preview_outlined),
          label: Text(context.l10n.preview),
        ),
        FilledButton.icon(
          key: const Key('live-proxy-submit'),
          onPressed: _isLoading || _liveProxyPreview == null
              ? null
              : _addLiveProxyMedia,
          icon: const Icon(Icons.playlist_add_rounded),
          label: Text(context.l10n.addLivePull),
        ),
      ],
    );
  }

  Widget _buildRtspTrackControl({
    required String label,
    required IconData icon,
    required _RtspTrackMode mode,
    required TextEditingController indexController,
    required ValueChanged<_RtspTrackMode> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSelect<_RtspTrackMode>(
          value: mode,
          label: label,
          prefixIcon: icon,
          options: {
            context.l10n.firstCompatibleTrack: _RtspTrackMode.firstCompatible,
            context.l10n.trackIndex: _RtspTrackMode.explicitIndex,
            context.l10n.disabled: _RtspTrackMode.disabled,
          },
          enabled: !_isLoading,
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        ),
        if (mode == _RtspTrackMode.explicitIndex) ...[
          const SizedBox(height: 10),
          AppTextField(
            controller: indexController,
            label: context.l10n.trackIndex,
            prefixIcon: Icons.numbers_rounded,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            enabled: !_isLoading,
            onChanged: (_) => setState(() => _liveProxyPreview = null),
          ),
        ],
      ],
    );
  }

  Widget _buildBilibiliContent(ThemeData theme) {
    final targetControl = _buildBilibiliTargetControl();
    return switch (_bilibiliTarget) {
      ProviderAddTarget.parse => _buildBilibiliMediaContent(
        theme,
        leadingControls: targetControl,
      ),
      ProviderAddTarget.media ||
      ProviderAddTarget.playlist => BilibiliPlaylistForm(
        key: ValueKey(_bilibiliTarget),
        roomId: widget.roomId,
        parentId: widget.parentId ?? '',
        binds: _bilibiliBinds,
        target: _bilibiliTarget,
        proxyMode: _bilibiliProxyMode,
        onProxyModeChanged: (value) =>
            setState(() => _bilibiliProxyMode = value),
        onDraftChanged: (value) => _bilibiliPlaylistHasDraft = value,
        leadingControls: targetControl,
      ),
    };
  }

  Widget _buildBilibiliTargetControl() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ProviderAddTargetSelector(
        value: _bilibiliTarget,
        targets: const [
          ProviderAddTarget.parse,
          ProviderAddTarget.media,
          ProviderAddTarget.playlist,
        ],
        enabled: !_isLoading,
        onChanged: (value) => setState(() => _bilibiliTarget = value),
      ),
      const SizedBox(height: 10),
    ],
  );

  Widget _buildBilibiliResolvedPreview({
    required ThemeData theme,
    required List<BilibiliParseCandidateInfo> candidates,
    required BilibiliParseCandidateInfo? selected,
    required String coverImage,
    required String title,
    required List<String> details,
    required List<BilibiliPlaylistListItemInfo> previewItems,
    required int selectedIndex,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 260;
        final headerHeight = (constraints.maxHeight - 70)
            .clamp(0.0, 250.0)
            .toDouble();
        if (compact) {
          return AppSingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildBilibiliResolvedHeader(
                  theme: theme,
                  candidates: candidates,
                  selected: selected,
                  coverImage: coverImage,
                  title: title,
                  details: details,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 380,
                  child: _buildBilibiliParseBrowser(
                    selected: selected,
                    previewItems: previewItems,
                    selectedIndex: selectedIndex,
                    title: title,
                  ),
                ),
              ],
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: headerHeight,
              child: AppSingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 4),
                child: _buildBilibiliResolvedHeader(
                  theme: theme,
                  candidates: candidates,
                  selected: selected,
                  coverImage: coverImage,
                  title: title,
                  details: details,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _buildBilibiliParseBrowser(
                selected: selected,
                previewItems: previewItems,
                selectedIndex: selectedIndex,
                title: title,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBilibiliResolvedHeader({
    required ThemeData theme,
    required List<BilibiliParseCandidateInfo> candidates,
    required BilibiliParseCandidateInfo? selected,
    required String coverImage,
    required String title,
    required List<String> details,
  }) {
    return Column(
      children: [
        if (coverImage.isNotEmpty)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: AppImageThumbnail(
              url: coverImage,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        if (details.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            details.join(' · '),
            style: TextStyle(fontSize: 13, color: theme.hintColor),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
        if (candidates.length > 1) ...[
          const SizedBox(height: 12),
          _buildBilibiliCandidateSelector(theme, candidates),
        ],
        if (selected?.isMedia == true) ...[
          const SizedBox(height: 12),
          _buildActionButton(
            context.l10n.addToPlaylist,
            _addBilibiliCandidate,
            color: const Color(0xFFFB7299),
            icon: Icons.playlist_add_rounded,
          ),
        ],
      ],
    );
  }

  Widget _buildBilibiliParseBrowser({
    required BilibiliParseCandidateInfo? selected,
    required List<BilibiliPlaylistListItemInfo> previewItems,
    required int selectedIndex,
    required String title,
  }) {
    return DiscoveryBrowser(
      key: ValueKey('bilibili-parse-preview:${selected?.title ?? ''}'),
      items: [
        for (final item in previewItems)
          DiscoveryBrowserEntry(
            key: item.id,
            title: item.title,
            subtitle: item.description,
            source: item.source,
            isContainer: item.isContainer,
            selectable: item.source.hasMedia() || item.source.hasPlaylist(),
            leading: item.cover.isEmpty
                ? Icon(
                    item.isContainer
                        ? Icons.video_library_outlined
                        : Icons.play_circle_outline,
                  )
                : AppImageThumbnail(
                    url: item.cover,
                    width: 48,
                    height: 48,
                    borderRadius: BorderRadius.circular(4),
                  ),
          ),
      ],
      selectionController: _bilibiliSelection,
      selectionScope: '$_bilibiliInstanceName:$selectedIndex:$title',
      onSelectionChanged: () => setState(() {}),
      loading: _isLoading,
      paginationMode: _bilibiliPreviewUsesCursor
          ? DiscoveryPaginationMode.cursor
          : DiscoveryPaginationMode.page,
      page: _biliPreview?.page ?? 1,
      pageSize: 24,
      hasMore: _bilibiliPreviewHasMore,
      onLoadMore: _bilibiliPreviewUsesCursor
          ? () => _previewBilibiliCandidate(loadMore: true)
          : null,
      onPreviousPage:
          _isLoading ||
              _bilibiliPreviewUsesCursor ||
              (_biliPreview?.page ?? 1) <= 1
          ? null
          : () => _previewBilibiliCandidate(page: _biliPreview!.page - 1),
      onNextPage:
          _isLoading || _bilibiliPreviewUsesCursor || !_bilibiliPreviewHasMore
          ? null
          : () => _previewBilibiliCandidate(page: _biliPreview!.page + 1),
      onAddSelected: _addSelectedBilibiliPreviewItems,
      onAddCurrentList: _addBilibiliCandidate,
      currentListLabel: context.l10n.addCurrentList,
      emptyIcon: Icons.video_collection_outlined,
      emptyTitle: context.l10n.noItems,
    );
  }

  Widget _buildBilibiliMediaContent(
    ThemeData theme, {
    required Widget leadingControls,
  }) {
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
        _biliPreview?.items ?? const <BilibiliPlaylistListItemInfo>[];

    final controls = Column(
      children: [
        leadingControls,
        _buildProviderBindSelector<BilibiliBindInfo>(
          theme: theme,
          items: _bilibiliBinds,
          selectedKey:
              _bilibiliBinds
                  .where(
                    (bind) =>
                        bind.providerInstanceName == _bilibiliInstanceName,
                  )
                  .map(
                    (bind) => _providerBindKey(
                      bind.serverId,
                      bind.providerInstanceName,
                    ),
                  )
                  .firstOrNull ??
              '',
          keyOf: (bind) =>
              _providerBindKey(bind.serverId, bind.providerInstanceName),
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
              _bilibiliSelection.clear();
            });
          },
        ),
        AppSwitchTile(
          contentPadding: EdgeInsets.zero,
          title: Text(context.l10n.shareMyCredentials),
          prefix: const Icon(Icons.key_rounded),
          semanticsLabel: context.l10n.shareMyCredentials,
          value: _bilibiliShared,
          onChanged: _isLoading
              ? null
              : (value) {
                  setState(() {
                    _bilibiliShared = value;
                    _biliInfo = null;
                    _biliPreview = null;
                    _bilibiliSelection.clear();
                  });
                },
        ),
        if (_bilibiliPlaybackPolicySource case final source?)
          PlaybackProxyModeControl(
            key: const Key('bilibili-playback-proxy-mode'),
            value: _bilibiliProxyMode,
            enabled: !_isLoading,
            source: source,
            onChanged: (value) => setState(() => _bilibiliProxyMode = value),
          ),
        const SizedBox(height: 12),
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
                  onChanged: (_) => setState(() {
                    _biliInfo = null;
                    _biliPreview = null;
                    _bilibiliSelection.clear();
                  }),
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
      ],
    );
    final results = _biliInfo == null
        ? LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 180;
              return Center(
                child: AppEmptyState(
                  icon: Icons.tv_rounded,
                  iconColor: const Color(0xFFFB7299),
                  iconSize: compact ? 32 : 58,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: compact ? 6 : 16,
                  ),
                  title: context.l10n.pasteBilibiliLink,
                  subtitle: compact
                      ? null
                      : context.l10n.bilibiliSupportedLinks,
                  maxWidth: 360,
                ),
              );
            },
          )
        : _biliPreview != null
        ? _buildBilibiliResolvedPreview(
            theme: theme,
            candidates: candidates,
            selected: selected,
            coverImage: coverImage,
            title: title,
            details: details,
            previewItems: previewItems,
            selectedIndex: selectedIndex,
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
                    style: TextStyle(fontSize: 13, color: theme.hintColor),
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
                        onPressed: _isLoading || selected?.browse == null
                            ? null
                            : _previewBilibiliCandidate,
                        icon: const Icon(Icons.preview_outlined),
                        label: Text(context.l10n.preview),
                      ),
                    ),
              ],
            ),
          );
    return ProviderWorkspace(controls: controls, results: results);
  }

  Widget _buildAlistContent(ThemeData theme) {
    if (_alistBinds.isEmpty && _loadingVendors.contains('alist')) {
      return const AppLoadingIndicator();
    }
    if (!_boundVendors.contains('alist')) {
      return _buildBindGuide('AList', theme);
    }

    final controls = Column(
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
              _alistListSource = null;
            });
            _loadAlist('/');
          },
        ),
        PlaybackProxyModeControl(
          value: _alistProxyMode,
          enabled: !_alistLoading && !_isLoading,
          source: _alistPlaybackPolicySource,
          onChanged: (value) => setState(() => _alistProxyMode = value),
        ),
        const SizedBox(height: 12),
        _buildAlistSearchBar(theme),
        _buildAlistPasswordField(theme),
        _buildPathBar(theme, _alistPath, _goUpAlist),
      ],
    );
    final results = _alistLoading && _alistFiles.isEmpty
        ? const AppLoadingIndicator()
        : DiscoveryBrowser(
            key: ValueKey(
              'alist:$_alistServerId:$_alistInstanceName:'
              '$_alistPath:$_alistKeyword:$_alistPassword',
            ),
            items: [
              for (final file in _alistFiles)
                DiscoveryBrowserEntry(
                  key: file.path,
                  title: file.name,
                  subtitle: file.isDir ? '' : _formatSize(file.size),
                  source: file.source,
                  isContainer: file.isDir,
                ),
            ],
            selectionController: _alistSelection,
            selectionScope: _providerBindKey(
              _alistServerId,
              _alistInstanceName,
            ),
            onSelectionChanged: () => setState(() {}),
            loading: _alistLoading || _isLoading,
            paginationMode: DiscoveryPaginationMode.page,
            page: _alistPage,
            pageSize: _pageSize,
            total: _alistTotal,
            hasMore: _alistHasMore,
            onPreviousPage: _alistLoading || _alistPage <= 1
                ? null
                : () => _loadAlist(
                    _alistPath,
                    page: _alistPage - 1,
                    preserveResults: true,
                  ),
            onNextPage: _alistLoading || !_alistHasMore
                ? null
                : () => _loadAlist(
                    _alistPath,
                    page: _alistPage + 1,
                    preserveResults: true,
                  ),
            onOpen: (entry) => _openAlistDirectory(entry.key),
            onAddSelected: _addDiscoveredEntries,
            onAddCurrentList: _alistListSource == null
                ? null
                : () => _addDiscoveredSource(
                    _alistListSource!,
                    _alistPath.split('/').last,
                  ),
            emptyIcon: Icons.cloud_queue_rounded,
            emptyTitle: context.l10n.noFiles,
          );
    return ProviderWorkspace(controls: controls, results: results);
  }

  Widget _buildEmbyContent(ThemeData theme) {
    if (_embyBinds.isEmpty && _loadingVendors.contains('emby')) {
      return const AppLoadingIndicator();
    }
    if (_embyBinds.isEmpty) return _buildBindGuide('Emby', theme);
    if (!_embyPlaylistMode) return _buildEmbyLibraryContent(theme);
    return EmbyPlaylistForm(
      roomId: widget.roomId,
      parentId: widget.parentId ?? '',
      binds: _embyBinds,
      leadingControls: _buildEmbyModeControls(includeProxyMode: false),
      proxyMode: _embyProxyMode,
      onProxyModeChanged: (value) => setState(() => _embyProxyMode = value),
      onDraftChanged: (value) => _embyPlaylistHasDraft = value,
      onOpenBinding: () => _openProviderBinding('emby'),
    );
  }

  Widget _buildEmbyModeControls({bool includeProxyMode = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<bool>(
          segments: [
            ButtonSegment(
              value: false,
              icon: const Icon(Icons.folder_open_outlined),
              label: Text(context.l10n.library),
            ),
            ButtonSegment(
              value: true,
              icon: const Icon(Icons.favorite_outline),
              label: Text(context.l10n.embyDiscoveryAndLists),
            ),
          ],
          selected: {_embyPlaylistMode},
          onSelectionChanged: _isLoading
              ? null
              : (values) => setState(() => _embyPlaylistMode = values.first),
        ),
        const SizedBox(height: 12),
        if (includeProxyMode) ...[
          PlaybackProxyModeControl(
            value: _embyProxyMode,
            enabled: !_isLoading,
            source: _embyPlaybackPolicySource,
            onChanged: (value) => setState(() => _embyProxyMode = value),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildEmbyLibraryContent(ThemeData theme) {
    if (_embyBinds.isEmpty && _loadingVendors.contains('emby')) {
      return const AppLoadingIndicator();
    }
    if (!_boundVendors.contains('emby')) return _buildBindGuide('Emby', theme);

    final controls = Column(
      children: [
        _buildEmbyModeControls(),
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
              _embyBreadcrumbs.clear();
              _embyFiles = [];
              _embyPage = 1;
              _embyHasMore = true;
              _embyKeyword = '';
              _embySearchController.clear();
              _embyListSource = null;
            });
            _loadEmby('');
          },
        ),
        _buildEmbySearchBar(theme),
        _buildPathBar(
          theme,
          _embyBreadcrumbs.isEmpty
              ? '/'
              : '/${_embyBreadcrumbs.map((entry) => entry.$2).join('/')}',
          _goUpEmby,
        ),
      ],
    );
    return ProviderWorkspace(
      controls: controls,
      results: _buildEmbyLibraryBrowser(),
    );
  }

  Widget _buildEmbyLibraryBrowser() {
    if (_embyLoading && _embyFiles.isEmpty) {
      return const AppLoadingIndicator();
    }
    return DiscoveryBrowser(
      key: ValueKey(
        'emby:$_embyServerId:$_embyInstanceName:'
        '$_embyPath:$_embyKeyword',
      ),
      items: [
        for (final file in _embyFiles)
          DiscoveryBrowserEntry(
            key: file.id,
            title: file.name.isEmpty ? context.l10n.unknown : file.name,
            subtitle: file.description.isNotEmpty
                ? file.description
                : localizedMediaVariant(context, file.type),
            source: file.source,
            isContainer: file.isDir,
            leading: file.thumbnail.isEmpty
                ? Icon(
                    file.isDir ? Icons.folder_rounded : Icons.movie_outlined,
                    color: Colors.green,
                  )
                : AppImageThumbnail(
                    url: file.thumbnail,
                    headers: resourceUrlResolver.authenticatedHeaders,
                    width: 48,
                    height: 48,
                    borderRadius: BorderRadius.circular(4),
                    errorIcon: Icons.movie_outlined,
                  ),
          ),
      ],
      selectionController: _embySelection,
      selectionScope: _providerBindKey(_embyServerId, _embyInstanceName),
      onSelectionChanged: () => setState(() {}),
      loading: _embyLoading || _isLoading,
      paginationMode: DiscoveryPaginationMode.page,
      page: _embyPage,
      pageSize: _pageSize,
      total: _embyTotal,
      hasMore: _embyHasMore,
      onPreviousPage: _embyLoading || _embyPage <= 1
          ? null
          : () => _loadEmby(
              _embyPath,
              page: _embyPage - 1,
              preserveResults: true,
            ),
      onNextPage: _embyLoading || !_embyHasMore
          ? null
          : () => _loadEmby(
              _embyPath,
              page: _embyPage + 1,
              preserveResults: true,
            ),
      onOpen: (entry) => _enterEmbyDir(entry.key, entry.title),
      onAddSelected: _addDiscoveredEntries,
      onAddCurrentList: _embyListSource == null
          ? null
          : () => _addDiscoveredSource(
              _embyListSource!,
              _embyPath.isEmpty ? 'Emby Library' : '',
            ),
      emptyIcon: Icons.video_library_rounded,
      emptyTitle: context.l10n.noMedia,
    );
  }

  Widget _buildCloudreveContent(ThemeData theme) {
    if (_cloudreveBinds.isEmpty && _loadingVendors.contains('cloudreve')) {
      return const AppLoadingIndicator();
    }
    if (!_boundVendors.contains('cloudreve')) {
      return _buildBindGuide('Cloudreve', theme);
    }

    final controls = Column(
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
              _cloudreveListSource = null;
            });
            _loadCloudreve(_cloudrevePath);
          },
        ),
        PlaybackProxyModeControl(
          value: _cloudreveProxyMode,
          enabled: !_cloudreveLoading && !_isLoading,
          source: _cloudrevePlaybackPolicySource,
          onChanged: (value) => setState(() => _cloudreveProxyMode = value),
        ),
        const SizedBox(height: 12),
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
      ],
    );
    return ProviderWorkspace(
      controls: controls,
      results: _buildCloudreveBrowser(),
    );
  }

  Widget _buildCloudreveBrowser() {
    if (_cloudreveLoading && _cloudreveFiles.isEmpty) {
      return const AppLoadingIndicator();
    }
    return DiscoveryBrowser(
      key: ValueKey(
        'cloudreve:$_cloudreveServerId:$_cloudreveInstanceName:'
        '$_cloudrevePath:$_cloudreveKeyword',
      ),
      items: [
        for (final file in _cloudreveFiles)
          DiscoveryBrowserEntry(
            key: file.path,
            title: file.name,
            subtitle: file.isDir ? '' : _formatSize(file.size),
            source: file.source,
            isContainer: file.isDir,
            leading: file.thumbnail.isEmpty
                ? Icon(
                    file.isDir ? Icons.folder_rounded : Icons.movie_outlined,
                    color: Colors.teal,
                  )
                : AppImageThumbnail(
                    url: file.thumbnail,
                    headers: resourceUrlResolver.authenticatedHeaders,
                    width: 48,
                    height: 48,
                    borderRadius: BorderRadius.circular(4),
                    errorIcon: Icons.movie_outlined,
                  ),
          ),
      ],
      selectionController: _cloudreveSelection,
      selectionScope: _providerBindKey(
        _cloudreveServerId,
        _cloudreveInstanceName,
      ),
      onSelectionChanged: () => setState(() {}),
      loading: _cloudreveLoading || _isLoading,
      paginationMode: _cloudreveUsesCursor
          ? DiscoveryPaginationMode.cursor
          : DiscoveryPaginationMode.page,
      page: _cloudrevePage,
      pageSize: _pageSize,
      total: _cloudreveTotal,
      hasMore: _cloudreveHasMore,
      onLoadMore: _cloudreveUsesCursor
          ? () => _loadCloudreve(_cloudrevePath, loadMore: true)
          : null,
      onPreviousPage:
          _cloudreveLoading || _cloudreveUsesCursor || _cloudrevePage <= 1
          ? null
          : () => _loadCloudreve(
              _cloudrevePath,
              requestedPage: _cloudrevePage - 1,
              preserveResults: true,
            ),
      onNextPage:
          _cloudreveLoading || _cloudreveUsesCursor || !_cloudreveHasMore
          ? null
          : () => _loadCloudreve(
              _cloudrevePath,
              requestedPage: _cloudrevePage + 1,
              preserveResults: true,
            ),
      onOpen: (entry) => _openCloudreveDirectory(entry.key),
      onAddSelected: _addDiscoveredEntries,
      onAddCurrentList: _cloudreveListSource == null
          ? null
          : () => _addDiscoveredSource(
              _cloudreveListSource!,
              Uri.tryParse(_cloudrevePath)?.pathSegments.lastOrNull ??
                  'Cloudreve',
            ),
      emptyIcon: Icons.cloud_off_rounded,
      emptyTitle: context.l10n.noFiles,
    );
  }

  Widget _buildTextField(
    ThemeData theme,
    TextEditingController controller,
    String label,
    String hint,
    IconData icon, {
    bool urlInput = false,
    ValueChanged<String>? onChanged,
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
      onChanged: onChanged,
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
    if (items.isEmpty) return const SizedBox.shrink();
    final value = items.any((item) => keyOf(item) == selectedKey)
        ? selectedKey
        : keyOf(items.first);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: context.l10n.mediaSourceAccount,
          prefixIcon: const Icon(Icons.account_circle_outlined),
        ),
        items: [
          for (final item in items)
            DropdownMenuItem(
              value: keyOf(item),
              child: Text(labelOf(item), overflow: TextOverflow.ellipsis),
            ),
        ],
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
            candidate.isPlaylist
                ? context.l10n.dynamicPlaylist
                : context.l10n.media,
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
              _bilibiliSelection.clear();
            }),
          );
        },
      ),
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
          ProviderAccountAction(
            providerType: name,
            onPressed: () =>
                _openProviderBinding(mediaProviderBrand(name).type),
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
      _directPreview = const [];
      _directSelection.clear();
    });
  }

  void _removeDirectHeaderRow(int index) {
    if (index < 0 || index >= _directHeaders.length) return;
    final header = _directHeaders.removeAt(index);
    header.dispose();
    _directPreview = const [];
    _directSelection.clear();
    _updateDirectHeaderValidation();
  }

  void _updateDirectHeaderValidation() {
    final message = _currentDirectHeaderValidationMessage();
    if (!mounted || _directHeaderError == message) return;
    setState(() {
      _directHeaderError = message;
      _directPreview = const [];
      _directSelection.clear();
    });
  }

  String _currentDirectHeaderValidationMessage() {
    try {
      _collectDirectHeaders(validateCompleteRows: false);
      return '';
    } on FormatException catch (error) {
      return error.message;
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
        throw FormatException(context.l10n.completeRequestHeaderNameAndValue);
      }
      if (name.isNotEmpty) {
        final normalized = name.toLowerCase();
        if (!normalizedNames.add(normalized)) {
          throw FormatException(context.l10n.duplicateRequestHeader(name));
        }
      }
      if (validateCompleteRows) {
        headers[name] = value;
      } else if (name.isNotEmpty && value.isNotEmpty) {
        headers[name] = value;
      }
    }
    return headers;
  }

  bool get _hasUnsavedDraft {
    if (_directPlaybackKind != source_enum.PlaybackKind.PLAYBACK_KIND_REGULAR ||
        _directProxyMode !=
            source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO ||
        _bilibiliProxyMode !=
            source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO ||
        _alistProxyMode !=
            source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO ||
        _embyProxyMode !=
            source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO ||
        _cloudreveProxyMode !=
            source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO ||
        _urlController.text.trim().isNotEmpty ||
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

  Future<void> _prepareDirectLinks() async {
    final urls = _urlController.text
        .split('\n')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList(growable: false);
    if (urls.isEmpty) {
      AppNotifications.showWarning(context, context.l10n.enterHttpLinks);
      return;
    }
    late final Map<String, String> headers;
    try {
      headers = _collectDirectHeaders();
    } on FormatException catch (error) {
      final message = error.message;
      setState(() => _directHeaderError = message);
      AppNotifications.showWarning(context, message);
      return;
    }

    setState(() {
      _isLoading = true;
      _directSelection.clear();
    });
    try {
      final preview = await Future.wait([
        for (final url in urls)
          providerGateway.prepareDirectUrl(
            provider_common.PrepareDirectUrlRequest(
              url: url,
              headers: headers.entries,
              playbackKind: _directPlaybackKind,
              proxyMode: _directProxyMode,
            ),
          ),
      ]);
      if (mounted) setState(() => _directPreview = preview);
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.parseFailed('$error'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildDirectPreview() {
    return DiscoveryBrowser(
      key: ValueKey('direct-preview:${_directPreview.length}'),
      items: [
        for (final (index, prepared) in _directPreview.indexed)
          DiscoveryBrowserEntry(
            key: 'direct-$index',
            title: prepared.suggestedName,
            subtitle: _playbackKindLabel(prepared.playbackKind),
            source: prepared.source.withPlaybackProxyMode(_directProxyMode),
            isContainer: false,
            selectable: prepared.hasSource(),
            leading: const Icon(Icons.link_rounded),
          ),
      ],
      selectionController: _directSelection,
      selectionScope: _urlController.text,
      onSelectionChanged: () => setState(() {}),
      loading: _isLoading,
      initiallySelectAll: true,
      onAddSelected: _addPreparedDirectLinks,
      emptyIcon: Icons.link_off_rounded,
      emptyTitle: context.l10n.noPreparedLinks,
    );
  }

  Future<void> _addPreparedDirectLinks(
    List<DiscoveryBrowserEntry> entries,
  ) async {
    if (entries.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      final customName = _nameController.text.trim();
      for (final entry in entries) {
        await providerGateway.addDiscoveredSource(
          widget.roomId,
          playlistId: widget.parentId ?? '',
          source: entry.source,
          name: entries.length == 1 && customName.isNotEmpty
              ? customName
              : entry.title,
        );
      }
      if (!mounted) return;
      Navigator.pop(context);
      AppNotifications.showSuccess(
        context,
        context.l10n.itemsAdded(entries.length),
      );
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.addFailed('$error'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _playbackKindLabel(source_enum.PlaybackKind kind) => switch (kind) {
    source_enum.PlaybackKind.PLAYBACK_KIND_LIVE => context.l10n.live,
    source_enum.PlaybackKind.PLAYBACK_KIND_REGULAR => context.l10n.onDemand,
    _ => context.l10n.source,
  };

  Widget _buildPreparedSourceCard(
    provider_common.PreparedMediaSource prepared, {
    required IconData icon,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          prepared.suggestedName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(_playbackKindLabel(prepared.playbackKind)),
      ),
    );
  }

  Future<void> _prepareRtmpPublish() async {
    setState(() => _isLoading = true);
    try {
      final preview = await providerGateway.prepareRtmp(_rtmpPublishMode);
      if (mounted) setState(() => _rtmpPreview = preview);
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.parseFailed('$error'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addRtmpPublish() async {
    final preview = _rtmpPreview;
    if (preview == null || !preview.hasSource()) return;
    if (_rtmpPublishKeyType !=
            client_enum.PublishKeyType.PUBLISH_KEY_TYPE_PERMANENT &&
        !_rtmpPublishExpiresAt.isAfter(widget.now())) {
      AppNotifications.showWarning(
        context,
        context.l10n.publishKeyExpirationMustBeFuture,
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final name = _nameController.text.trim();
      final mediaId = await providerGateway.addDiscoveredSource(
        widget.roomId,
        playlistId: widget.parentId ?? '',
        source: preview.source,
        name: name.isEmpty ? preview.suggestedName : name,
      );
      final publish = await providerGateway.createRtmpPublishKeyInfo(
        widget.roomId,
        mediaId,
        keyType: _rtmpPublishKeyType,
        expiresAt:
            _rtmpPublishKeyType ==
                client_enum.PublishKeyType.PUBLISH_KEY_TYPE_PERMANENT
            ? null
            : _rtmpPublishExpiresAt.millisecondsSinceEpoch ~/ 1000,
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

  Future<void> _prepareLiveProxy() async {
    final url = _liveProxyUrlController.text.trim();
    late final provider_common.PrepareLiveProxyRequest intent;
    try {
      intent = _liveProxyIntent(url);
    } on FormatException catch (error) {
      AppNotifications.showWarning(context, error.message);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final preview = await providerGateway.prepareLiveProxy(intent);
      if (mounted) setState(() => _liveProxyPreview = preview);
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.parseFailed('$error'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addLiveProxyMedia() async {
    final preview = _liveProxyPreview;
    if (preview == null || !preview.hasSource()) return;
    setState(() => _isLoading = true);
    try {
      final name = _liveProxyNameController.text.trim();
      await providerGateway.addDiscoveredSource(
        widget.roomId,
        playlistId: widget.parentId ?? '',
        source: preview.source,
        name: name.isEmpty ? preview.suggestedName : name,
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

  provider_common.PrepareLiveProxyRequest _liveProxyIntent(String url) {
    return switch (_liveProxyProtocol) {
      _LivePullProtocol.rtmp => provider_common.PrepareLiveProxyRequest(
        rtmp: provider_common.PrepareRtmpPullIntent(
          url: url,
          mode: _liveProxyRtmpMode,
        ),
      ),
      _LivePullProtocol.rtsp => _rtspLiveProxyIntent(url),
      _LivePullProtocol.httpFlv => provider_common.PrepareLiveProxyRequest(
        httpFlv: provider_common.PrepareHttpFlvPullIntent(url: url),
      ),
    };
  }

  provider_common.PrepareLiveProxyRequest _rtspLiveProxyIntent(String url) {
    if (_liveProxyVideoTrackMode == _RtspTrackMode.disabled &&
        _liveProxyAudioTrackMode == _RtspTrackMode.disabled) {
      throw FormatException(context.l10n.selectRtspTrack);
    }
    return provider_common.PrepareLiveProxyRequest(
      rtsp: provider_common.PrepareRtspPullIntent(
        url: url,
        transport: _liveProxyRtspTransport,
        videoTrack: _rtspTrackIntent(
          _liveProxyVideoTrackMode,
          _liveProxyVideoTrackIndexController,
        ),
        audioTrack: _rtspTrackIntent(
          _liveProxyAudioTrackMode,
          _liveProxyAudioTrackIndexController,
        ),
      ),
    );
  }

  provider_common.PrepareRtspTrackIntent _rtspTrackIntent(
    _RtspTrackMode mode,
    TextEditingController indexController,
  ) {
    return switch (mode) {
      _RtspTrackMode.firstCompatible => provider_common.PrepareRtspTrackIntent(
        firstCompatible: true,
      ),
      _RtspTrackMode.disabled => provider_common.PrepareRtspTrackIntent(
        disabled: true,
      ),
      _RtspTrackMode.explicitIndex => provider_common.PrepareRtspTrackIntent(
        index: _validatedTrackIndex(indexController.text),
      ),
    };
  }

  int _validatedTrackIndex(String value) {
    final index = int.tryParse(value);
    if (index == null || index < 0) {
      throw FormatException(context.l10n.enterValidTrackIndex);
    }
    return index;
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
              context.l10n.publishKeyType,
              _publishKeyTypeLabel(publish.keyType),
            ),
            if (publish.expiresAt case final expiresAt?)
              _buildRtmpInfoRow(
                context.l10n.expirationTime,
                _formatTimestamp(expiresAt),
              )
            else
              _buildRtmpInfoRow(
                context.l10n.expirationTime,
                context.l10n.noExpiration,
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

  String _formatDateTime(DateTime value) =>
      _formatTimestamp(value.millisecondsSinceEpoch ~/ 1000);

  String _publishKeyTypeLabel(client_enum.PublishKeyType value) {
    switch (value) {
      case client_enum.PublishKeyType.PUBLISH_KEY_TYPE_SINGLE_USE:
        return context.l10n.singleUsePublishKey;
      case client_enum.PublishKeyType.PUBLISH_KEY_TYPE_EXPIRING:
        return context.l10n.expiringPublishKey;
      case client_enum.PublishKeyType.PUBLISH_KEY_TYPE_PERMANENT:
        return context.l10n.permanentPublishKey;
      case client_enum.PublishKeyType.PUBLISH_KEY_TYPE_UNSPECIFIED:
        return context.l10n.publishKeyType;
    }
    return context.l10n.publishKeyType;
  }

  Future<void> _selectRtmpPublishExpiration() async {
    final now = widget.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _rtmpPublishExpiresAt.isBefore(now)
          ? now.add(const Duration(hours: 1))
          : _rtmpPublishExpiresAt,
      firstDate: now,
      lastDate: now.add(const Duration(days: 3650)),
    );
    if (!mounted || selectedDate == null) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_rtmpPublishExpiresAt),
    );
    if (!mounted || selectedTime == null) return;

    final expiresAt = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    if (!expiresAt.isAfter(widget.now())) {
      if (mounted) {
        AppNotifications.showWarning(
          context,
          context.l10n.publishKeyExpirationMustBeFuture,
        );
      }
      return;
    }

    setState(() => _rtmpPublishExpiresAt = expiresAt);
  }

  Future<void> _parseBilibili() async {
    final url = _biliUrlController.text.trim();
    if (url.isEmpty) return;
    setState(() {
      _isLoading = true;
      _biliInfo = null;
      _biliPreview = null;
      _bilibiliSelection.clear();
    });
    try {
      final info = await providerGateway.parseBilibiliInfo(
        url,
        instanceName: _bilibiliInstanceName,
        shared: _bilibiliShared,
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

  provider_common.DiscoveredSource? get _bilibiliPlaybackPolicySource =>
      _bilibiliSelection.entries.firstOrNull?.source ??
      _selectedBilibiliCandidate?.source;

  provider_common.DiscoveredSource? get _directPlaybackPolicySource =>
      _directSelection.entries.firstOrNull?.source ??
      _directPreview.firstOrNull?.source;

  provider_common.DiscoveredSource? get _alistPlaybackPolicySource =>
      _alistSelection.entries.firstOrNull?.source ?? _alistListSource;

  provider_common.DiscoveredSource? get _embyPlaybackPolicySource =>
      _embySelection.entries.firstOrNull?.source ?? _embyListSource;

  provider_common.DiscoveredSource? get _cloudrevePlaybackPolicySource =>
      _cloudreveSelection.entries.firstOrNull?.source ?? _cloudreveListSource;

  bool get _bilibiliPreviewHasMore {
    return _biliPreview?.hasMore ?? false;
  }

  bool get _bilibiliPreviewUsesCursor =>
      _selectedBilibiliCandidate?.browse?.mode ==
      BilibiliPlaylistListMode.history;

  Future<void> _previewBilibiliCandidate({
    bool loadMore = false,
    int? page,
  }) async {
    final candidate = _selectedBilibiliCandidate;
    if (candidate == null || !candidate.isPlaylist) return;
    final intent = candidate.browse;
    if (intent == null) return;
    final current = _biliPreview;
    if (loadMore && (current == null || !_bilibiliPreviewHasMore)) return;
    setState(() => _isLoading = true);
    try {
      final preview = await providerGateway.listBilibiliPlaylist(
        intent,
        page: page ?? (loadMore ? (current?.page ?? 1) + 1 : 1),
        pageSize: 24,
        cursor: _bilibiliPreviewUsesCursor && loadMore ? current?.cursor : null,
        instanceName: candidate.source.providerInstanceName,
        shared: _bilibiliShared,
      );
      if (mounted) {
        setState(() {
          _biliPreview =
              _bilibiliPreviewUsesCursor && loadMore && current != null
              ? BilibiliPlaylistListPage(
                  items: [...current.items, ...preview.items],
                  hasMore: preview.hasMore,
                  page: preview.page,
                  cursor: preview.cursor,
                  source: preview.source,
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
      if (candidate.isPlaylist && _biliPreview == null) {
        throw StateError('Preview the dynamic playlist before creating it');
      }
      await providerGateway.addDiscoveredSource(
        widget.roomId,
        playlistId: widget.parentId ?? '',
        source: candidate.source.withPlaybackProxyMode(_bilibiliProxyMode),
        name: title,
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

  Future<void> _addSelectedBilibiliPreviewItems(
    List<DiscoveryBrowserEntry> items,
  ) async {
    if (items.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      for (final item in items) {
        await providerGateway.addDiscoveredSource(
          widget.roomId,
          playlistId: widget.parentId ?? '',
          source: item.source.withPlaybackProxyMode(_bilibiliProxyMode),
          name: item.title,
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

  Future<void> _loadAlist(
    String path, {
    int page = 1,
    bool preserveResults = false,
  }) async {
    if (_alistBinds.isEmpty || _alistServerId.isEmpty) return;
    if (_alistLoading) return;
    final keyword = _alistKeyword;
    final password = _alistPasswordController.text;
    if (password != _alistPassword) {
      _alistPassword = password;
    }

    setState(() {
      _alistLoading = true;
      _alistPath = path;
      _alistListSource = null;
      if (!preserveResults) {
        _alistSelection.clear();
        _alistFiles = [];
        _alistTotal = 0;
      }
    });

    try {
      final pageInfo = await providerGateway.listAlistPage(
        path,
        keyword: keyword,
        page: page,
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
          _alistFiles = newItems;
          _alistPage = page;
          _alistTotal = total;
          _alistHasMore = page * _pageSize < total;
          _alistListSource = pageInfo.source;
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

  Future<void> _loadCloudreve(
    String path, {
    bool loadMore = false,
    int requestedPage = 1,
    bool preserveResults = false,
  }) async {
    if (_cloudreveBinds.isEmpty || _cloudreveServerId.isEmpty) return;
    if (loadMore && _cloudreveLoading) return;
    final targetPage = loadMore ? _cloudrevePage + 1 : requestedPage;
    setState(() {
      _cloudreveLoading = true;
      if (!loadMore && !preserveResults) {
        _cloudreveSelection.clear();
        _cloudrevePath = path;
        _cloudreveFiles = [];
        _cloudreveTotal = 0;
        _cloudreveListSource = null;
      }
    });
    try {
      final result = await providerGateway.listCloudrevePage(
        path,
        keyword: _cloudreveKeyword,
        page: targetPage,
        max: _pageSize,
        offset: _cloudreveKeyword.isNotEmpty ? (targetPage - 1) * _pageSize : 0,
        cursor: _cloudreveKeyword.isEmpty && loadMore && _cloudreveUsesCursor
            ? _cloudreveNextCursor
            : null,
        serverId: _cloudreveServerId,
        instanceName: _cloudreveInstanceName,
      );
      if (!mounted) return;
      setState(() {
        if (result.usesCursor && loadMore) {
          _cloudreveFiles.addAll(result.items);
          _cloudrevePage = targetPage;
        } else {
          _cloudreveFiles = result.items;
          _cloudrevePage = targetPage;
        }
        _cloudreveTotal = result.total;
        _cloudreveUsesCursor = result.usesCursor;
        _cloudreveNextCursor = result.nextCursor;
        _cloudreveHasMore = result.usesCursor
            ? result.nextCursor.isNotEmpty
            : targetPage * _pageSize < result.total;
        _cloudreveListSource = result.source;
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
      _cloudreveListSource = null;
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
      _cloudreveListSource = null;
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

  void _searchAlist() {
    final keyword = _alistSearchController.text.trim();
    if (keyword == _alistKeyword) return;
    setState(() {
      _alistKeyword = keyword;
      _alistPage = 1;
      _alistHasMore = true;
      _alistListSource = null;
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
      _alistListSource = null;
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
      _alistListSource = null;
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
      _alistListSource = null;
    });
    _loadAlist(_alistPath);
  }

  void _openAlistDirectory(String path) {
    if (_alistKeyword.isNotEmpty) {
      _alistSearchController.clear();
      setState(() {
        _alistKeyword = '';
        _alistListSource = null;
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

  Future<void> _loadEmby(
    String path, {
    int page = 1,
    bool preserveResults = false,
  }) async {
    if (_embyBinds.isEmpty || _embyServerId.isEmpty) return;
    if (_embyLoading) return;
    final targetPage = page;
    final keyword = _embyKeyword;

    setState(() {
      _embyLoading = true;
      _embyPath = path;
      _embyListSource = null;
      if (!preserveResults) {
        _embySelection.clear();
        _embyFiles = [];
        _embyTotal = 0;
      }
    });
    try {
      final pageInfo = await providerGateway.listEmbyPage(
        EmbyListMode.folder,
        targetId: path,
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
          _embyFiles = newItems;
          _embyPage = targetPage;
          _embyTotal = total;
          _embyHasMore = targetPage * _pageSize < total;
          _embyListSource = pageInfo.source;
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
      _embyListSource = null;
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
      _embyListSource = null;
    });
    _loadEmby(_embyPath);
  }

  void _enterEmbyDir(String itemId, String name) {
    if (_embyKeyword.isNotEmpty) {
      _embySearchController.clear();
      setState(() => _embyKeyword = '');
    }
    setState(() => _embyBreadcrumbs.add((itemId, name)));
    _loadEmby(itemId);
  }

  void _goUpEmby() {
    if (_embyKeyword.isNotEmpty) {
      _clearEmbySearch();
      return;
    }
    if (_embyBreadcrumbs.isEmpty) return;
    setState(() => _embyBreadcrumbs.removeLast());
    _loadEmby(_embyBreadcrumbs.lastOrNull?.$1 ?? '');
  }

  Future<void> _addDiscoveredEntries(
    List<DiscoveryBrowserEntry> entries,
  ) async {
    if (entries.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      for (final entry in entries) {
        await providerGateway.addDiscoveredSource(
          widget.roomId,
          playlistId: widget.parentId ?? '',
          source: entry.source.withPlaybackProxyMode(_activeProxyMode),
          name: entry.title,
        );
      }
      if (!mounted) return;
      Navigator.pop(context);
      AppNotifications.showSuccess(
        context,
        context.l10n.itemsAdded(entries.length),
      );
    } catch (error) {
      if (mounted) {
        AppNotifications.showError(context, context.l10n.addFailed('$error'));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addDiscoveredSource(
    provider_common.DiscoveredSource source,
    String name,
  ) => _addDiscoveredEntries([
    DiscoveryBrowserEntry(
      key: 'current-list',
      title: name.isEmpty ? context.l10n.dynamicPlaylist : name,
      source: source,
      isContainer: true,
    ),
  ]);

  source_enum.PlaybackProxyMode get _activeProxyMode =>
      switch (_selectedIndex) {
        3 => _bilibiliProxyMode,
        4 => _alistProxyMode,
        5 => _embyProxyMode,
        6 => _cloudreveProxyMode,
        _ => source_enum.PlaybackProxyMode.PLAYBACK_PROXY_MODE_AUTO,
      };
}
