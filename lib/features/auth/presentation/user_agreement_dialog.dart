import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class UserAgreementDialog extends StatefulWidget {
  const UserAgreementDialog({super.key, required this.agreementContent});

  final String agreementContent;

  @override
  State<UserAgreementDialog> createState() => _UserAgreementDialogState();
}

class _UserAgreementDialogState extends State<UserAgreementDialog> {
  final ScrollController _scrollController = ScrollController();
  bool _canAgree = false;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkScroll);
  }

  @override
  void didUpdateWidget(covariant UserAgreementDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.agreementContent == widget.agreementContent) return;
    _canAgree = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.jumpTo(0);
      _checkScroll();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _checkScroll() {
    if (mounted &&
        !_canAgree &&
        _scrollController.hasClients &&
        _scrollController.position.hasContentDimensions &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 20) {
      setState(() => _canAgree = true);
    }
  }

  void _finish(bool accepted) {
    if (!mounted || _finished || ModalRoute.of(context)?.isCurrent != true) {
      return;
    }
    if (accepted && !_canAgree) return;
    _finished = true;
    Navigator.of(context).pop(accepted);
    if (!accepted) SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppDialogFrame(
      maxWidth: 480,
      maxHeight: 600,
      child: NotificationListener<ScrollMetricsNotification>(
        onNotification: (_) {
          _checkScroll();
          return false;
        },
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: AppSingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    context.l10n.userAgreement,
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 16),
                MarkdownBody(
                  data: widget.agreementContent,
                  styleSheet: MarkdownStyleSheet.fromTheme(theme),
                ),
                const SizedBox(height: 16),
                if (!_canAgree) ...[
                  Text(
                    context.l10n.readAgreementToEnd,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    AppActionButton(
                      onPressed: () => _finish(false),
                      label: context.l10n.declineAndExit,
                      wrapLabel: true,
                      style: AppActionButtonStyle.text,
                    ),
                    AppActionButton(
                      onPressed: _canAgree ? () => _finish(true) : null,
                      label: context.l10n.agree,
                      wrapLabel: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
