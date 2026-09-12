import 'package:flutter/material.dart';
import 'package:synctv_app/features/room/presentation/widgets/playback_empty_state.dart';
import 'package:synctv_app/features/room/presentation/widgets/playlist_empty_state.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() => runApp(
  MaterialApp(
    theme: AppTheme.light,
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: const _Preview(),
  ),
);

class _Preview extends StatefulWidget {
  const _Preview();
  @override
  State<_Preview> createState() => _PreviewState();
}

class _PreviewState extends State<_Preview> {
  bool playlist = false;
  bool large = false;
  bool added = false;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Room empty states')),
    body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton(
                onPressed: () => setState(() => playlist = !playlist),
                child: Text(playlist ? 'Show playback' : 'Show playlist'),
              ),
              FilledButton(
                onPressed: () => setState(() => large = !large),
                child: Text(large ? 'Text 1x' : 'Text 3x'),
              ),
            ],
          ),
        ),
        Center(
          child: SizedBox(
            width: 320,
            height: 180,
            child: ColoredBox(
              color: playlist
                  ? Theme.of(context).colorScheme.surfaceContainer
                  : const Color(0xFF151820),
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: TextScaler.linear(large ? 3 : 1)),
                child: playlist
                    ? PlaylistEmptyState(
                        onAdd: () => setState(() => added = true),
                      )
                    : const PlaybackEmptyState(
                        error: 'The media could not be loaded. Check the source address and try again. The server returned an unavailable source. Reference: source-unavailable.',
                        loading: false,
                        hasPlayback: false,
                      ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(added ? 'Add media action reached' : 'Panel: 320 × 180'),
        ),
      ],
    ),
  );
}
