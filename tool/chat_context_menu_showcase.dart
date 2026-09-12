import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';
import 'package:synctv_app/features/room/presentation/widgets/chat_context_menu_popup.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() =>
    runApp(MaterialApp(theme: AppTheme.light, home: const _Preview()));

class _Preview extends StatefulWidget {
  const _Preview();
  @override
  State<_Preview> createState() => _PreviewState();
}

class _PreviewState extends State<_Preview> {
  String status = 'No action';
  bool keyboard = false;

  void open(Offset anchor) => showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close message actions',
    barrierColor: Colors.transparent,
    pageBuilder: (context, _, _) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(viewInsets: EdgeInsets.only(bottom: keyboard ? 500 : 0)),
      child: ChatContextMenuPopup(
        anchor: anchor,
        reactionCount: 6,
        actionCount: 6,
        child: AppPanelSurface(
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final group in [
                [
                  Icons.thumb_up,
                  Icons.favorite,
                  Icons.celebration,
                  Icons.star,
                  Icons.check,
                  Icons.add_reaction,
                ],
                [
                  Icons.reply,
                  Icons.copy,
                  Icons.edit,
                  Icons.push_pin,
                  Icons.delete,
                  Icons.flag,
                ],
              ]) ...[
                Wrap(
                  spacing: 3,
                  runSpacing: 3,
                  children: [
                    for (var i = 0; i < group.length; i++)
                      AppIconButton(
                        constraints: const BoxConstraints.tightFor(
                          width: 28,
                          height: 28,
                        ),
                        padding: EdgeInsets.zero,
                        iconSize: 15,
                        icon: group[i],
                        tooltip: group.first == Icons.reply
                            ? [
                                'Reply',
                                'Copy',
                                'Edit',
                                'Pin',
                                'Delete',
                                'Report',
                              ][i]
                            : 'Reaction ${i + 1}',
                        onPressed: () {
                          Navigator.pop(context);
                          setState(
                            () => status = group.first == Icons.reply
                                ? [
                                    'Reply',
                                    'Copy',
                                    'Edit',
                                    'Pin',
                                    'Delete',
                                    'Report',
                                  ][i]
                                : 'Reaction ${i + 1}',
                          );
                        },
                      ),
                  ],
                ),
                if (group.first != Icons.reply)
                  const Padding(
                    padding: EdgeInsets.only(top: 7, bottom: 5),
                    child: AppDivider(height: 1),
                  ),
              ],
            ],
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Message actions')),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text('Keyboard inset'),
          value: keyboard,
          onChanged: (value) => setState(() => keyboard = value),
        ),
        Text(status),
        const SizedBox(height: 24),
        GestureDetector(
          onSecondaryTapDown: (event) => open(event.globalPosition),
          child: FilledButton.icon(
            onPressed: () => open(
              Offset(
                MediaQuery.sizeOf(context).width - 16,
                MediaQuery.sizeOf(context).height - 16,
              ),
            ),
            icon: const Icon(Icons.more_horiz),
            label: const Text('Message actions'),
          ),
        ),
      ],
    ),
  );
}
