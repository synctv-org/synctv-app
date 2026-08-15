import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';

void main() {
  testWidgets('reads a dependency from the root registry', (tester) async {
    const dependency = _Dependency('root');
    late _Dependency resolved;

    await tester.pumpWidget(
      DependencyRegistryScope(
        values: const <Type, Object>{_Dependency: dependency},
        child: Builder(
          builder: (context) {
            resolved = DependencyScope.read<_Dependency>(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(resolved, same(dependency));
  });

  testWidgets('a local typed scope overrides the root registry', (
    tester,
  ) async {
    const root = _Dependency('root');
    const local = _Dependency('local');
    late _Dependency resolved;

    await tester.pumpWidget(
      DependencyRegistryScope(
        values: const <Type, Object>{_Dependency: root},
        child: DependencyScope<_Dependency>(
          value: local,
          child: Builder(
            builder: (context) {
              resolved = DependencyScope.read<_Dependency>(context);
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect(resolved, same(local));
  });

  testWidgets('maybeRead returns null when a dependency is absent', (
    tester,
  ) async {
    _Dependency? resolved;

    await tester.pumpWidget(
      Builder(
        builder: (context) {
          resolved = DependencyScope.maybeRead<_Dependency>(context);
          return const SizedBox();
        },
      ),
    );

    expect(resolved, isNull);
  });
}

final class _Dependency {
  const _Dependency(this.value);

  final String value;
}
