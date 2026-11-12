import 'package:flutter/material.dart';
import 'package:synctv_app/theme/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

@immutable
class MediaProviderBrand {
  const MediaProviderBrand({
    required this.type,
    required this.label,
    required this.icon,
    required this.color,
    this.known = true,
  });

  final String type;
  final String label;
  final IconData icon;
  final Color color;
  final bool known;
}

MediaProviderBrand mediaProviderBrand(String providerType) {
  final type = providerType.trim();
  final key = type.toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');
  return switch (key) {
    'direct' || 'directurl' => const MediaProviderBrand(
      type: 'directUrl',
      label: 'Direct URL',
      icon: Icons.link_rounded,
      color: AppColors.providerIndigo,
    ),
    'rtmp' => const MediaProviderBrand(
      type: 'rtmp',
      label: 'RTMP',
      icon: Icons.upload_rounded,
      color: AppColors.providerRtmp,
    ),
    'liveproxy' => const MediaProviderBrand(
      type: 'liveProxy',
      label: 'Live Proxy',
      icon: Icons.sensors_rounded,
      color: AppColors.providerLiveProxy,
    ),
    'bilibili' => MediaProviderBrand(
      type: 'bilibili',
      label: 'Bilibili',
      icon: FontAwesomeIcons.bilibili.data,
      color: AppColors.providerBilibili,
    ),
    'alist' => const MediaProviderBrand(
      type: 'alist',
      label: 'AList',
      icon: Icons.cloud_circle_rounded,
      color: AppColors.warning,
    ),
    'emby' => const MediaProviderBrand(
      type: 'emby',
      label: 'Emby',
      icon: Icons.video_library_rounded,
      color: AppColors.providerEmby,
    ),
    'cloudreve' => const MediaProviderBrand(
      type: 'cloudreve',
      label: 'Cloudreve',
      icon: Icons.cloud_rounded,
      color: AppColors.providerCloudreve,
    ),
    'twitch' => MediaProviderBrand(
      type: 'twitch',
      label: 'Twitch',
      icon: FontAwesomeIcons.twitch.data,
      color: AppColors.providerTwitch,
    ),
    'huya' => const MediaProviderBrand(
      type: 'huya',
      label: 'Huya',
      icon: Icons.sports_esports_rounded,
      color: AppColors.providerHuya,
    ),
    'douyu' => const MediaProviderBrand(
      type: 'douyu',
      label: 'Douyu',
      icon: Icons.live_tv_rounded,
      color: AppColors.providerDouyu,
    ),
    'acfun' => const MediaProviderBrand(
      type: 'acfun',
      label: 'AcFun',
      icon: Icons.ondemand_video_rounded,
      color: AppColors.providerAcfun,
    ),
    'cctv' => const MediaProviderBrand(
      type: 'cctv',
      label: 'CCTV',
      icon: Icons.tv_rounded,
      color: AppColors.providerCctv,
    ),
    'fnos' => const MediaProviderBrand(
      type: 'fnos',
      label: 'FNOS',
      icon: Icons.storage_rounded,
      color: AppColors.providerFnos,
    ),
    'qnap' => const MediaProviderBrand(
      type: 'qnap',
      label: 'QNAP',
      icon: Icons.storage_rounded,
      color: AppColors.providerQnap,
    ),
    'synology' || 'synologydsm' => const MediaProviderBrand(
      type: 'synology',
      label: 'Synology DSM',
      icon: Icons.video_library_rounded,
      color: AppColors.providerSynology,
    ),
    'nextcloud' => const MediaProviderBrand(
      type: 'nextcloud',
      label: 'Nextcloud',
      icon: Icons.cloud_outlined,
      color: AppColors.providerNextcloud,
    ),
    'seafile' => const MediaProviderBrand(
      type: 'seafile',
      label: 'Seafile',
      icon: Icons.cloud_queue_rounded,
      color: AppColors.providerSeafile,
    ),
    'truenas' => const MediaProviderBrand(
      type: 'truenas',
      label: 'TrueNAS',
      icon: Icons.dns_rounded,
      color: AppColors.providerTruenas,
    ),
    'youtube' => MediaProviderBrand(
      type: 'youtube',
      label: 'YouTube',
      icon: FontAwesomeIcons.youtube.data,
      color: AppColors.providerYoutube,
    ),
    'douyin' => MediaProviderBrand(
      type: 'douyin',
      label: 'Douyin',
      icon: FontAwesomeIcons.tiktok.data,
      color: AppColors.providerDouyin,
    ),
    'tiktok' => MediaProviderBrand(
      type: 'tiktok',
      label: 'TikTok',
      icon: FontAwesomeIcons.tiktok.data,
      color: AppColors.providerTiktok,
    ),
    _ => MediaProviderBrand(
      type: type,
      label: type.isEmpty ? 'Provider' : type,
      icon: Icons.extension_outlined,
      color: const Color(0xFF607D8B),
      known: false,
    ),
  };
}
