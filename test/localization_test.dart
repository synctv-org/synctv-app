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
          '${l10n.roomFeedPublic}|${l10n.roomFeedMine}|'
          '${l10n.roomFeedPopular}|${l10n.roomFeedFavorites}|'
          '${l10n.roomsPageSummary(2, 1, 3)}',
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
        'Display language|Server|Public|Mine|Popular|Favorites|'
        '2 rooms · Page 1 of 3',
      ),
      findsOneWidget,
    );
  });

  testWidgets('loads Simplified Chinese resources', (tester) async {
    await tester.pumpWidget(_localizedApp(const Locale('zh')));

    expect(
      find.text('显示语言|服务器|公开|我的|热门|收藏|共 2 个房间 · 第 1 / 3 页'),
      findsOneWidget,
    );
  });
}
