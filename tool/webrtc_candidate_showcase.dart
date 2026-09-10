import 'package:flutter/material.dart';
import 'package:synctv_app/core/webrtc/webrtc_negotiation_state.dart';
import 'package:synctv_app/theme/app_theme.dart';

import '../test/support/p2p_replacement_candidates.dart';

void main() =>
    runApp(MaterialApp(theme: AppTheme.light, home: const _Preview()));

class _Preview extends StatefulWidget {
  const _Preview();
  @override
  State<_Preview> createState() => _PreviewState();
}

class _PreviewState extends State<_Preview> {
  String status = 'Ready';
  List<String> retained = [];
  bool running = false;

  Future<void> runChannels() async {
    setState(() {
      running = true;
      status = 'Replacing data channels';
      retained = [];
    });
    try {
      for (final duringClose in [false, true]) {
        final events = await p2pReplacedChannelEvents(duringClose: duringClose);
        retained.add(
          '${duringClose ? "During close" : "After close"}: ${events.join(", ")}',
        );
        if (events.length != 2 ||
            events[0] != 'state' ||
            events[1] != 'current cache read') {
          throw StateError('Obsolete channel handled events');
        }
      }
      status = '2/2 channel ownership checks passed';
    } catch (error) {
      status = 'FAIL: $error';
    } finally {
      if (mounted) setState(() => running = false);
    }
  }

  Future<void> runP2p() async {
    setState(() {
      running = true;
      status = 'Replacing P2P peer';
      retained = [];
    });
    try {
      final candidates = await p2pReplacementCandidates();
      if (!mounted) return;
      retained = candidates.whereType<String>().toList();
      status =
          retained.length == 2 &&
              retained[0] == 'During old peer close' &&
              retained[1] == 'After replacement'
          ? '2/2 P2P candidates preserved in order'
          : 'FAIL: P2P replacement lost a candidate';
    } catch (error) {
      if (!mounted) return;
      status = 'FAIL: $error';
    } finally {
      if (mounted) setState(() => running = false);
    }
  }

  void run() {
    final negotiation = WebRtcNegotiationState<String, String>();
    negotiation.queueCandidate('peer', 'Before replacement');
    final saved = negotiation.takeCandidates('peer');
    negotiation.clearPeer('peer');
    negotiation.queueCandidate('peer', 'During replacement');
    negotiation.restoreCandidates('peer', saved);
    try {
      negotiation.queueCandidate('peer', 'After replacement');
      status = 'Candidates restored';
    } catch (error) {
      status = 'FAIL: $error';
    }
    retained = negotiation.takeCandidates('peer');
    if (retained.length == 3 &&
        retained[0] == 'Before replacement' &&
        retained[1] == 'During replacement' &&
        retained[2] == 'After replacement') {
      status = '3/3 candidates preserved in order';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('WebRTC candidates')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: running ? null : run,
            icon: const Icon(Icons.refresh),
            label: const Text('Replace peer'),
          ),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: running ? null : runP2p,
            icon: const Icon(Icons.sync),
            label: const Text('Replace P2P peer'),
          ),
        ),
        const SizedBox(height: 16),
        Semantics(liveRegion: true, child: Text(status)),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton(
            onPressed: running ? null : runChannels,
            child: const Text('Replace data channels'),
          ),
        ),
        for (final candidate in retained)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(candidate),
          ),
      ],
    ),
  );
}
