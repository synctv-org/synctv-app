import 'package:flutter/widgets.dart';

final class DependencyScope<T extends Object> extends InheritedWidget {
  const DependencyScope({super.key, required this.value, required super.child});

  final T value;

  static T of<T extends Object>(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<DependencyScope<T>>();
    return scope?.value ?? DependencyRegistryScope.of<T>(context);
  }

  static T read<T extends Object>(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<DependencyScope<T>>();
    return scope?.value ?? DependencyRegistryScope.read<T>(context);
  }

  static T? maybeRead<T extends Object>(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<DependencyScope<T>>();
    return scope?.value ?? DependencyRegistryScope.maybeRead<T>(context);
  }

  @override
  bool updateShouldNotify(DependencyScope<T> oldWidget) =>
      !identical(value, oldWidget.value);
}

final class DependencyRegistryScope extends InheritedWidget {
  const DependencyRegistryScope({
    super.key,
    required this.values,
    required super.child,
  });

  final Map<Type, Object> values;

  static T of<T extends Object>(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<DependencyRegistryScope>();
    return scope?._lookup<T>() ?? _missing<T>();
  }

  static T read<T extends Object>(BuildContext context) {
    final scope = context
        .getInheritedWidgetOfExactType<DependencyRegistryScope>();
    return scope?._lookup<T>() ?? _missing<T>();
  }

  static T? maybeRead<T extends Object>(BuildContext context) {
    final scope = context
        .getInheritedWidgetOfExactType<DependencyRegistryScope>();
    return scope?._lookup<T>();
  }

  T? _lookup<T extends Object>() => values[T] as T?;

  static Never _missing<T extends Object>() =>
      throw StateError('No dependency of type $T found in the widget tree.');

  @override
  bool updateShouldNotify(DependencyRegistryScope oldWidget) {
    if (identical(values, oldWidget.values)) return false;
    if (values.length != oldWidget.values.length) return true;
    return values.entries.any(
      (entry) => !identical(oldWidget.values[entry.key], entry.value),
    );
  }
}
