import 'dart:async';

import 'package:flutter/material.dart';
import 'package:synctv_app/contracts/room_media_models.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room/presentation/widgets/chat_reaction_users_dialog.dart';
import 'package:synctv_app/features/room/presentation/widgets/chat_read_receipts_dialog.dart';
import 'package:synctv_app/features/room/presentation/models/chat_detail_dialog_controller.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/src/generated/proto/common.pbenum.dart' as enums;
import 'package:synctv_app/theme/app_theme.dart';

void main() => runApp(
  MaterialApp(
    theme: AppTheme.light,
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const _Preview(),
  ),
);

class _Preview extends StatelessWidget {
  const _Preview();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Conversation details')),
    body: Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          AppActionButton(
            label: 'Expiring details',
            icon: Icons.timer_outlined,
            onPressed: () {
              final dialogs = ChatDetailDialogController();
              final timer = Timer(
                const Duration(seconds: 3),
                dialogs.dismissAll,
              );
              unawaited(
                dialogs
                    .show(
                      context: context,
                      messageId: 'message',
                      userId: 'author',
                      builder: (_) => const ChatReadReceiptsDialog(
                        receipts: ChatMessageReadReceiptsInfo(
                          readers: [],
                          unreadMembers: [],
                          readerTotal: 0,
                          unreadTotal: 0,
                        ),
                      ),
                    )
                    .whenComplete(() {
                      timer.cancel();
                      dialogs.dispose();
                    }),
              );
            },
          ),
          AppActionButton(
            label: 'Read details',
            icon: Icons.done_all,
            onPressed: () => showAppDialog<void>(
              context: context,
              builder: (_) => ChatReadReceiptsDialog(
                receipts: ChatMessageReadReceiptsInfo(
                  readers: [
                    for (var i = 0; i < 12; i++)
                      ChatReadReceiptUserInfo(
                        user: _user(i),
                        readAt: i == 0 ? 9007199254740991 : 1700000000,
                      ),
                  ],
                  unreadMembers: [for (var i = 12; i < 24; i++) _user(i)],
                  readerTotal: 12,
                  unreadTotal: 12,
                ),
              ),
            ),
          ),
          AppActionButton(
            label: 'Reactions',
            icon: Icons.thumb_up_outlined,
            onPressed: () {
              var attempts = 0;
              showAppDialog<void>(
                context: context,
                builder: (_) => ChatReactionUsersDialog(
                  roomId: 'room',
                  messageId: 'message',
                  reactionKey: 'Like',
                  loadUsers: ({String cursor = ''}) async {
                    if (++attempts == 1) {
                      throw StateError('Connection unavailable');
                    }
                    return ChatReactionUsersPage(
                      users: [
                        ChatReactionUserInfo(
                          userId: 'alex',
                          username: cursor.isEmpty ? 'Alex' : 'Alex updated',
                          reactedAt: 9007199254740991,
                        ),
                        if (cursor.isNotEmpty)
                          const ChatReactionUserInfo(
                            userId: 'sam',
                            username: 'Sam',
                            reactedAt: 1700000000,
                          ),
                      ],
                      nextCursor: 'next',
                      total: 2,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    ),
  );

  SyncTvUser _user(int index) => SyncTvUser(
    id: 'member-$index',
    username: 'Member ${index + 1}',
    role: const AccountUserRole(enums.UserRole.USER_ROLE_USER),
  );
}
