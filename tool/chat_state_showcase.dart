import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room/domain/room_chat_message_state.dart';
import 'package:synctv_app/features/room/domain/room_realtime.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() =>
    runApp(MaterialApp(theme: AppTheme.light, home: const _Preview()));

class _Preview extends StatefulWidget {
  const _Preview();
  @override
  State<_Preview> createState() => _PreviewState();
}

class _PreviewState extends State<_Preview> {
  final _state = RoomChatMessageState();
  static const _original = RoomRealtimeChatEntry(
    id: 'message',
    userId: 'user',
    username: 'Alex',
    content: 'Original message',
    timestampMillis: 1,
    version: 1,
    pin: ChatPinInfo(
      pinnedByUserId: 'user',
      pinnedByUsername: 'Alex',
      note: '',
      pinnedAt: 1,
    ),
  );

  @override
  void initState() {
    super.initState();
    _state.merge(_original, addToTimeline: true);
  }

  @override
  Widget build(BuildContext context) {
    final reply = _state.cache['message'];
    return Scaffold(
      appBar: AppBar(title: const Text('Room conversation')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              AppActionButton(
                label: 'Block author',
                icon: Icons.person_off_outlined,
                onPressed: () => setState(() => _state.removeUser('user')),
              ),
              AppActionButton(
                label: 'Revoke access',
                icon: Icons.lock_outline,
                onPressed: () => setState(_state.clear),
              ),
              AppActionButton(
                label: 'React and unpin',
                icon: Icons.thumb_up_outlined,
                onPressed: reply == null
                    ? null
                    : () => setState(() {
                        final current = _state.cache['message']!;
                        final revision = _state.revision;
                        _state.merge(current.copyWith(reactionCount: 2));
                        _state.merge(
                          current.copyWith(clearPin: true),
                          updatePin: true,
                          snapshotRevision: revision,
                        );
                      }),
              ),
              AppActionButton(
                label: 'Edit',
                icon: Icons.edit_outlined,
                onPressed: () => setState(
                  () => _state.merge(
                    _original.copyWith(version: 2, content: 'Updated message'),
                    addToTimeline: true,
                  ),
                ),
              ),
              AppActionButton(
                label: 'Delete',
                icon: Icons.delete_outline,
                onPressed: () => setState(
                  () => _state.merge(
                    _original.copyWith(version: 3, isDeleted: true),
                    addToTimeline: true,
                  ),
                ),
              ),
              AppActionButton(
                label: 'Late response',
                icon: Icons.history,
                onPressed: () => setState(
                  () => _state.prependHistory([_original], snapshotRevision: 0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Messages: ${_state.messages.length}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          for (final message in _state.messages)
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline),
              title: Text(message.content),
              subtitle: Text('Reactions: ${message.reactionCount}'),
            ),
          const Divider(),
          Text(
            'Pinned: ${_state.pinnedMessages.length}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          for (final message in _state.pinnedMessages)
            ListTile(
              leading: const Icon(Icons.push_pin_outlined),
              title: Text(message.content),
            ),
          const Divider(),
          Text(
            'Reply: ${reply?.isDeleted == true ? 'Message deleted' : reply?.content ?? ''}',
          ),
        ],
      ),
    );
  }
}
