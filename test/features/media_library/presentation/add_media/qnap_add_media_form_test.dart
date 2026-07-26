import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/l10n/app_localizations.dart';
import 'package:synctv_app/contracts/provider_models.dart';
import 'package:synctv_app/features/media_library/presentation/add_media/qnap_add_media_form.dart';

import '../../../../test_app.dart';

void main() {
  const bind = QnapBindInfo(
    id: '1',
    serverId: 'qnap-home',
    endpoint: 'https://nas.example',
    username: 'alice',
    serverName: 'Home NAS',
    version: '5.2.4',
    supportRtt: true,
    createdAt: 1,
    providerInstanceName: '',
  );

  testWidgets('browses QNAP files and exposes transcode state', (tester) async {
    var requestedPath = '';
    var requestedSearch = '';
    await tester.binding.setSurfaceSize(const Size(900, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        builder: buildThemedTestApp,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: QnapAddMediaForm(
            roomId: 'room',
            playlistId: '',
            binds: const [bind],
            resourceHeaders: () => const {},
            fileLoader: (_, path, page, _, search) async {
              requestedPath = path;
              requestedSearch = search;
              return QnapFileListPage(
                items: path.isEmpty
                    ? const [
                        QnapFileItemInfo(
                          name: 'Multimedia',
                          path: '/Multimedia',
                          isDir: true,
                          size: 0,
                          modifiedAt: 0,
                          fileType: 0,
                          preTranscodedHeights: [],
                          thumbnailUrl: '',
                        ),
                      ]
                    : const [
                        QnapFileItemInfo(
                          name: 'Movie.mkv',
                          path: '/Multimedia/Movie.mkv',
                          isDir: false,
                          size: 1073741824,
                          modifiedAt: 1700000000,
                          fileType: 1,
                          preTranscodedHeights: [720, 1080],
                          thumbnailUrl: '',
                        ),
                      ],
                total: 1,
                page: page,
                hasMore: false,
                realtimeTranscode: true,
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Multimedia'), findsOneWidget);
    await tester.tap(find.text('Multimedia'));
    await tester.pumpAndSettle();

    expect(requestedPath, '/Multimedia');
    expect(find.text('Movie.mkv'), findsOneWidget);
    expect(find.textContaining('Ready 720p / 1080p'), findsOneWidget);
    expect(find.textContaining('RTT'), findsNothing);

    await tester.enterText(find.byType(TextField), 'movie');
    await tester.tap(byAppTooltip('Search'));
    await tester.pumpAndSettle();
    expect(requestedSearch, 'movie');
  });
}
