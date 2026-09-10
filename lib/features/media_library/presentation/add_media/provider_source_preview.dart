import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class ProviderSourcePreview extends StatelessWidget {
  const ProviderSourcePreview({
    super.key,
    required this.title,
    required this.details,
    this.thumbnailUrl = '',
  });

  final String title;
  final List<String> details;
  final String thumbnailUrl;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final stacked =
          constraints.maxWidth < 480 ||
          MediaQuery.textScalerOf(context).scale(14) > 21;
      final content = Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title),
            if (details.isNotEmpty) Text(details.join(' · ')),
          ],
        ),
      );
      final thumbnail = thumbnailUrl.trim().isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(10),
              child: AppImageThumbnail(
                url: thumbnailUrl,
                width: stacked ? 160 : 112,
                height: stacked ? 100 : 72,
                fit: BoxFit.contain,
                semanticLabel: title,
              ),
            );
      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: stacked
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (thumbnail != null)
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: thumbnail,
                    ),
                  content,
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ?thumbnail,
                  Expanded(child: content),
                ],
              ),
      );
    },
  );
}
