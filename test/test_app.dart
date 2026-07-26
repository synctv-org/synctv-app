import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';
import 'package:synctv_app/core/presentation/widgets/app_form_controls.dart';

Finder byAppTooltip(Pattern message) {
  bool matches(String value) => switch (message) {
    RegExp() => message.hasMatch(value),
    _ => value == message,
  };

  return find.byWidgetPredicate(
    (widget) => switch (widget) {
      AppTooltip(message: final value) => matches(value),
      Tooltip(message: final value?) => matches(value),
      _ => false,
    },
    description: 'app tooltip matching "$message"',
  );
}

Widget buildThemedTestApp(BuildContext context, Widget? child) {
  final theme = Theme.of(context);
  final foruiTheme = theme.brightness == Brightness.dark
      ? FTheme.neutral.dark.desktop
      : FTheme.neutral.light.desktop;
  return FTheme(data: foruiTheme, child: child!);
}
