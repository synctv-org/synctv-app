import 'package:flutter/material.dart';
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
      color: Color(0xFF5D5FEF),
    ),
    'rtmp' => const MediaProviderBrand(
      type: 'rtmp',
      label: 'RTMP',
      icon: Icons.upload_rounded,
      color: Color(0xFFE65100),
    ),
    'liveproxy' => const MediaProviderBrand(
      type: 'liveProxy',
      label: 'Live Proxy',
      icon: Icons.sensors_rounded,
      color: Color(0xFF00897B),
    ),
    'bilibili' => MediaProviderBrand(
      type: 'bilibili',
      label: 'Bilibili',
      icon: FontAwesomeIcons.bilibili.data,
      color: Color(0xFFFB7299),
    ),
    'alist' => const MediaProviderBrand(
      type: 'alist',
      label: 'AList',
      icon: Icons.cloud_circle_rounded,
      color: Color(0xFFF59E0B),
    ),
    'emby' => const MediaProviderBrand(
      type: 'emby',
      label: 'Emby',
      icon: Icons.video_library_rounded,
      color: Color(0xFF52B54B),
    ),
    'cloudreve' => const MediaProviderBrand(
      type: 'cloudreve',
      label: 'Cloudreve',
      icon: Icons.cloud_rounded,
      color: Color(0xFF5C6BC0),
    ),
    'twitch' => MediaProviderBrand(
      type: 'twitch',
      label: 'Twitch',
      icon: FontAwesomeIcons.twitch.data,
      color: Color(0xFF9146FF),
    ),
    'huya' => const MediaProviderBrand(
      type: 'huya',
      label: 'Huya',
      icon: Icons.sports_esports_rounded,
      color: Color(0xFFFF7A00),
    ),
    'douyu' => const MediaProviderBrand(
      type: 'douyu',
      label: 'Douyu',
      icon: Icons.live_tv_rounded,
      color: Color(0xFFFF5D23),
    ),
    'acfun' => const MediaProviderBrand(
      type: 'acfun',
      label: 'AcFun',
      icon: Icons.ondemand_video_rounded,
      color: Color(0xFFFD4C5B),
    ),
    'cctv' => const MediaProviderBrand(
      type: 'cctv',
      label: 'CCTV',
      icon: Icons.tv_rounded,
      color: Color(0xFFC62828),
    ),
    'fnos' => const MediaProviderBrand(
      type: 'fnos',
      label: 'FNOS',
      icon: Icons.storage_rounded,
      color: Color(0xFF087F5B),
    ),
    'qnap' => const MediaProviderBrand(
      type: 'qnap',
      label: 'QNAP',
      icon: Icons.storage_rounded,
      color: Color(0xFF0076A8),
    ),
    'synology' || 'synologydsm' => const MediaProviderBrand(
      type: 'synology',
      label: 'Synology DSM',
      icon: Icons.video_library_rounded,
      color: Color(0xFF1578D3),
    ),
    'nextcloud' => const MediaProviderBrand(
      type: 'nextcloud',
      label: 'Nextcloud',
      icon: Icons.cloud_outlined,
      color: Color(0xFF0082C9),
    ),
    'seafile' => const MediaProviderBrand(
      type: 'seafile',
      label: 'Seafile',
      icon: Icons.cloud_queue_rounded,
      color: Color(0xFFED7109),
    ),
    'truenas' => const MediaProviderBrand(
      type: 'truenas',
      label: 'TrueNAS',
      icon: Icons.dns_rounded,
      color: Color(0xFF0095D5),
    ),
    'youtube' => MediaProviderBrand(
      type: 'youtube',
      label: 'YouTube',
      icon: FontAwesomeIcons.youtube.data,
      color: Color(0xFFFF0033),
    ),
    'douyin' => MediaProviderBrand(
      type: 'douyin',
      label: 'Douyin',
      icon: FontAwesomeIcons.tiktok.data,
      color: Color(0xFF00AFA7),
    ),
    'tiktok' => MediaProviderBrand(
      type: 'tiktok',
      label: 'TikTok',
      icon: FontAwesomeIcons.tiktok.data,
      color: Color(0xFFFE2C55),
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
