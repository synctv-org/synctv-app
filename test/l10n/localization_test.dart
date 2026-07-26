import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/l10n.dart';

Widget _localizedApp(Locale locale) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Builder(
      builder: (context) {
        final l10n = context.l10n;
        return Text(
          '${l10n.languageSettingsTitle}|${l10n.server}|'
          '${l10n.featuredRooms}|${l10n.continueWatchingRooms}|'
          '${l10n.popularRooms}|'
          '${l10n.roomsPageSummary(2, 1, 3)}|'
          '${l10n.cloudreveAccountDescription}|'
          '${l10n.twitchAccountDescription}|'
          '${l10n.youtubeAccountDescription}',
        );
      },
    ),
  );
}

void main() {
  testWidgets('loads English resources', (tester) async {
    await tester.pumpWidget(_localizedApp(const Locale('en')));

    expect(
      find.text(
        'Display language|Server|Featured rooms|Continue watching|'
        'Popular rooms|'
        '2 rooms · Page 1 of 3|'
        'Cloud storage media and directory resources|'
        'Twitch live streams, VODs, and clips|'
        'YouTube videos, live streams, and dynamic playlists with Cookie, '
        'Visitor Data, or PO Token',
      ),
      findsOneWidget,
    );
  });

  testWidgets('loads Simplified Chinese resources', (tester) async {
    await tester.pumpWidget(_localizedApp(const Locale('zh')));

    expect(
      find.text(
        '显示语言|服务器|精选房间|继续观看|热门房间|'
        '共 2 个房间 · 第 1 / 3 页|'
        '连接 Cloudreve 账号并浏览云盘媒体|'
        '连接 Twitch 账号并播放直播、VOD 与 Clip|'
        '连接 Cookie、Visitor Data 或 PO Token 并播放视频、直播与动态列表',
      ),
      findsOneWidget,
    );
  });
}
