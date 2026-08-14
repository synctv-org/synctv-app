import 'package:flutter/material.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

class PlaylistSearchField extends StatelessWidget {
  const PlaylistSearchField({
    super.key,
    required this.controller,
    required this.label,
    required this.onSearch,
  });

  final TextEditingController controller;
  final String label;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      prefixIcon: Icons.search_rounded,
      showClearButton: true,
      onChanged: (value) {
        if (value.isEmpty) onSearch();
      },
      onSubmitted: (_) => onSearch(),
    );
  }
}
