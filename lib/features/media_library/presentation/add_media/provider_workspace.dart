import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

/// Keeps provider configuration and browsable output side by side on desktop.
class ProviderWorkspace extends StatelessWidget {
  const ProviderWorkspace({
    super.key,
    required this.controls,
    required this.results,
    this.wideControlsWidth = 420,
    this.breakpoint = 860,
  });

  final Widget controls;
  final Widget? results;
  final double wideControlsWidth;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final output = results;
        if (output == null) {
          final compact = constraints.maxWidth < breakpoint;
          return Align(
            alignment: AlignmentDirectional.topStart,
            child: SizedBox(
              width: compact ? double.infinity : wideControlsWidth,
              child: AppSingleChildScrollView(
                padding: compact
                    ? EdgeInsets.zero
                    : const EdgeInsets.only(right: 12),
                child: controls,
              ),
            ),
          );
        }
        if (constraints.maxWidth < breakpoint) {
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(child: controls),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
              const SliverToBoxAdapter(child: AppDivider(height: 1)),
              const SliverToBoxAdapter(child: SizedBox(height: 12)),
            ],
            body: output,
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: wideControlsWidth,
              child: AppSingleChildScrollView(
                padding: const EdgeInsets.only(right: 12),
                child: controls,
              ),
            ),
            AppVerticalDivider(
              width: 1,
              color: Theme.of(context).colorScheme.outlineVariant
                  .withValues(alpha: 0.7),
            ),
            const SizedBox(width: 12),
            Expanded(child: output),
          ],
        );
      },
    );
  }
}
