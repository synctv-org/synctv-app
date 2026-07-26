import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:synctv_app/l10n/l10n.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class UserAgreementDialog extends StatefulWidget {
  final String agreementContent;

  const UserAgreementDialog({super.key, required this.agreementContent});

  @override
  State<UserAgreementDialog> createState() => _UserAgreementDialogState();
}

class _UserAgreementDialogState extends State<UserAgreementDialog> {
  final ScrollController _scrollController = ScrollController();
  bool _canAgree = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _checkScroll() {
    if (!_canAgree &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 20) {
      setState(() {
        _canAgree = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppDialogFrame(
      maxWidth: 400,
      maxHeight: 600,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.userAgreement,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: AppPanelSurface(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[100],
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Markdown(
                    controller: _scrollController,
                    data: widget.agreementContent,
                    styleSheet: MarkdownStyleSheet(
                      h1: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      h2: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      p: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: isDark ? Colors.grey[300] : Colors.black87,
                      ),
                      listBullet: TextStyle(
                        color: isDark ? Colors.grey[300] : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (!_canAgree)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    context.l10n.readAgreementToEnd,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: AppActionButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        SystemNavigator.pop(); // Exit app
                      },
                      label: context.l10n.declineAndExit,
                      style: AppActionButtonStyle.text,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppActionButton(
                      onPressed: _canAgree
                          ? () {
                              Navigator.of(context).pop(true);
                            }
                          : null,
                      label: context.l10n.agree,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
