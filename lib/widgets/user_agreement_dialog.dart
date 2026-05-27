import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '用户使用协议',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: isDark ? Colors.grey[800]! : Colors.grey[300]!),
                ),
                padding: const EdgeInsets.all(12),
                child: Markdown(
                  controller: _scrollController,
                  data: widget.agreementContent,
                  styleSheet: MarkdownStyleSheet(
                    h1: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87),
                    h2: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87),
                    p: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: isDark ? Colors.grey[300] : Colors.black87),
                    listBullet: TextStyle(
                        color: isDark ? Colors.grey[300] : Colors.black87),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (!_canAgree)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  '请阅读到底部以继续',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      SystemNavigator.pop(); // Exit app
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                    ),
                    child: const Text('不同意并退出'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canAgree
                        ? () {
                            Navigator.of(context).pop(true);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCF0A2C),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          isDark ? Colors.grey[800] : Colors.grey[300],
                      disabledForegroundColor:
                          isDark ? Colors.grey[500] : Colors.grey[500],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('同意'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
