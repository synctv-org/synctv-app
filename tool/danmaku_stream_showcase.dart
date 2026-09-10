import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:synctv_app/features/room/data/http_danmaku_source.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() =>
    runApp(MaterialApp(theme: AppTheme.light, home: const _Preview()));

class _Preview extends StatefulWidget {
  const _Preview();
  @override
  State<_Preview> createState() => _PreviewState();
}

class _PreviewState extends State<_Preview> {
  final messages = <String>[];
  String status = 'Connecting';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final events = await const HttpDanmakuSource()
          .openEventStream(Uri.base.resolve('events.txt'))
          .toList();
      if (!mounted) return;
      for (final event in events) {
        try {
          messages.add((jsonDecode(event) as Map)['message'].toString());
        } on FormatException {
          messages.add('Invalid event fragment');
        }
      }
      setState(() => status = 'Received ${messages.length} events');
    } catch (error) {
      if (mounted) setState(() => status = 'Stream failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Live danmaku events')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(status, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        for (final message in messages)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(message),
            ),
          ),
      ],
    ),
  );
}
