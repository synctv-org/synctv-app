import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_responsive_layout.dart';
import 'package:synctv_app/theme/app_theme.dart';

void main() =>
    runApp(MaterialApp(theme: AppTheme.light, home: const _Preview()));

class _Preview extends StatelessWidget {
  const _Preview();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Adaptive room layout')),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1014),
        child: AppAdaptiveSplitView(
          minPrimaryWidth: 680,
          minSecondaryWidth: 320,
          maxSecondaryWidth: 420,
          spacing: 14,
          collapsedSecondaryMinHeight: 520,
          primary: ColoredBox(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: LayoutBuilder(
              builder: (context, constraints) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Player width: ${constraints.maxWidth.toStringAsFixed(1)}\n'
                    'Split minimum: 680',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          secondary: ColoredBox(
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: LayoutBuilder(
              builder: (context, constraints) => Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Sidebar width: ${constraints.maxWidth.toStringAsFixed(1)}',
                    ),
                    const Text('Playlist and chat'),
                    const Spacer(),
                    FilledButton(
                      onPressed: () => ScaffoldMessenger.of(context)
                          .showSnackBar(
                            const SnackBar(
                              content: Text('Sidebar action reached'),
                            ),
                          ),
                      child: const Text('Bottom sidebar action'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
