import 'package:flutter/widgets.dart';

/// Whether this subtree belongs to the selected tab at every nesting level.
class AppTabActivity extends InheritedWidget {
  const AppTabActivity({super.key, required this.active, required super.child});

  final bool active;

  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppTabActivity>()?.active ??
      true;

  @override
  bool updateShouldNotify(AppTabActivity oldWidget) =>
      active != oldWidget.active;
}
