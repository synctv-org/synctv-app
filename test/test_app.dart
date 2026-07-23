import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

Widget buildThemedTestApp(BuildContext context, Widget? child) {
  final theme = Theme.of(context);
  final foruiTheme = theme.brightness == Brightness.dark
      ? FTheme.neutral.dark.desktop
      : FTheme.neutral.light.desktop;
  return FTheme(data: foruiTheme, child: child!);
}
