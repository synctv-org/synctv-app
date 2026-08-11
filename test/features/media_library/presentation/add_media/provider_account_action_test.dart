import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/emby_playlist_form.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/provider_account_action.dart';
import 'package:synctv_app/l10n/app_localizations.dart';

import '../../../../test_app.dart';

void main() {
  testWidgets('empty provider form exposes a direct account action', (
    tester,
  ) async {
    var opened = false;
    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: EmbyPlaylistForm(
            roomId: 'room',
            parentId: 'playlist',
            binds: const <EmbyBindInfo>[],
            onDraftChanged: (_) {},
            onOpenBinding: () async => opened = true,
          ),
        ),
      ),
    );

    expect(find.textContaining('Bind Emby'), findsOneWidget);
    await tester.tap(find.textContaining('Bind Emby'));
    await tester.pumpAndSettle();
    expect(opened, isTrue);
  });

  testWidgets('account selector keeps distinct bindings selectable', (
    tester,
  ) async {
    const binds = [
      YoutubeBindInfo(
        id: 'bind-a',
        serverId: 'server-a',
        label: 'Personal',
        hasVisitorData: false,
        hasPoToken: false,
        hasCookie: true,
        createdAt: 1,
        providerInstanceName: 'youtube-main',
      ),
      YoutubeBindInfo(
        id: 'bind-b',
        serverId: 'server-b',
        label: 'Family',
        hasVisitorData: false,
        hasPoToken: false,
        hasCookie: true,
        createdAt: 2,
        providerInstanceName: 'youtube-main',
      ),
    ];
    YoutubeBindInfo? selected;
    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ProviderAccountSelector<YoutubeBindInfo>(
            accounts: binds,
            selectedId: binds.first.id,
            idOf: (bind) => bind.id,
            labelOf: (bind) => bind.label,
            onChanged: (bind) => selected = bind,
          ),
        ),
      ),
    );

    expect(find.text('Personal'), findsOneWidget);
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Family').last);
    await tester.pumpAndSettle();
    expect(selected?.id, 'bind-b');
  });
}
