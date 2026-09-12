import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:synctv_app/contracts/room_management_models.dart';
import 'package:synctv_app/features/voice/infrastructure/voice_chat_manager.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() =>
    runApp(MaterialApp(theme: AppTheme.light, home: const _VoiceCheck()));

class _VoiceCheck extends StatefulWidget {
  const _VoiceCheck();
  @override
  State<_VoiceCheck> createState() => _VoiceCheckState();
}

class _VoiceCheckState extends State<_VoiceCheck> {
  late final VoiceChatManager _manager;
  final _signals = <String>[];
  final _streams = <_Stream>[];
  Completer<MediaStream>? _pending;
  bool _joining = false;
  int _requests = 0;
  String? _error;
  Completer<void>? _routingPending;
  bool _speakerEnabled = false;
  final _routingEvents = <String>[];

  @override
  void initState() {
    super.initState();
    _manager = VoiceChatManager(
      configureSpeakerphone: Uri.base.queryParameters['routing'] == 'delayed'
          ? _configureSpeakerphone
          : null,
      onSignalingMessage: (type, _) {
        _signals.add(type);
        if (type == 'leave' && Uri.base.queryParameters['leave'] == 'fail') {
          throw StateError('Preview leave signaling failed');
        }
      },
      loadIceServers: () async => const [
        IceServerInfo(
          urls: ['stun:example.test'],
          username: '',
          credential: '',
        ),
      ],
      onStateChange: _refresh,
      acquireMicrophone: () {
        _requests++;
        _pending = Completer<MediaStream>();
        _refresh();
        return _pending!.future;
      },
    );
  }

  Future<void> _configureSpeakerphone(bool enabled) async {
    _routingEvents.add('start $enabled');
    if (enabled) {
      _routingPending = Completer<void>();
      _refresh();
      await _routingPending!.future;
    }
    _speakerEnabled = enabled;
    _routingEvents.add('complete $enabled');
    _refresh();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Future<void> _join() async {
    setState(() {
      _joining = true;
      _error = null;
    });
    try {
      await _manager.join(clientOperationId: 'preview-join');
    } catch (error) {
      _error = error.toString();
    } finally {
      _joining = false;
      _refresh();
    }
  }

  void _resolve() {
    final pending = _pending;
    if (pending == null || pending.isCompleted) return;
    final stream = _Stream(_refresh);
    _streams.add(stream);
    pending.complete(stream);
    _refresh();
  }

  @override
  void dispose() {
    unawaited(_manager.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Voice lifecycle')),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Image.network(
            Uri.base.resolve('icons/Icon-192.png').toString(),
            width: 64,
            height: 64,
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: _joining || _manager.isConnected ? null : _join,
              icon: const Icon(Icons.mic),
              label: const Text('Join'),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                try {
                  await _manager.leave();
                } catch (error) {
                  _error = error.toString();
                }
                _refresh();
              },
              icon: const Icon(Icons.call_end),
              label: const Text('Leave'),
            ),
            OutlinedButton.icon(
              onPressed: _pending != null && !_pending!.isCompleted
                  ? _resolve
                  : null,
              icon: const Icon(Icons.check),
              label: const Text('Resolve microphone'),
            ),
            if (Uri.base.queryParameters['routing'] == 'delayed')
              OutlinedButton(
                onPressed:
                    _routingPending != null && !_routingPending!.isCompleted
                    ? () => _routingPending!.complete()
                    : null,
                child: const Text('Resolve audio routing'),
              ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Connected: ${_manager.isConnected}'),
        Text('Pending join: $_joining'),
        Text('Microphone requests: $_requests'),
        Text(
          'Stopped tracks: ${_streams.fold(0, (sum, stream) => sum + stream.track.stops)}',
        ),
        Text(
          'Disposed streams: ${_streams.fold(0, (sum, stream) => sum + stream.disposals)}',
        ),
        Text('Signals: ${_signals.isEmpty ? 'none' : _signals.join(', ')}'),
        if (Uri.base.queryParameters['routing'] == 'delayed') ...[
          Text('Speaker enabled: $_speakerEnabled'),
          Text('Audio routing: ${_routingEvents.join(', ')}'),
        ],
        if (_error != null) Text(_error!),
      ],
    ),
  );
}

class _Stream extends MediaStream {
  _Stream(this.onChanged)
    : track = _Track(onChanged),
      super('preview-stream', 'preview');
  final VoidCallback onChanged;
  final _Track track;
  int disposals = 0;
  @override
  List<MediaStreamTrack> getTracks() => [track];
  @override
  Future<void> dispose() async {
    disposals++;
    onChanged();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Track implements MediaStreamTrack {
  _Track(this.onChanged);
  final VoidCallback onChanged;
  int stops = 0;
  @override
  Future<void> stop() async {
    stops++;
    onChanged();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
