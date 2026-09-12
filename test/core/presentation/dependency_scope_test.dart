import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/core/presentation/dependency_scope.dart';

void main() {
  testWidgets('maybeOf tolerates an absent scope', (tester) async {
    _Dependency? resolved = const _Dependency('sentinel');
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          resolved = DependencyScope.maybeOf<_Dependency>(context);
          return const SizedBox();
        },
      ),
    );
    expect(resolved, isNull);
  });

  for (final registry in [false, true]) {
    testWidgets('maybeOf subscribes to replacement registry=$registry', (
      tester,
    ) async {
      var dependency = const _Dependency('first');
      _Dependency? resolved;
      var builds = 0;
      late StateSetter update;
      final consumer = Builder(
        builder: (context) {
          builds++;
          resolved = DependencyScope.maybeOf<_Dependency>(context);
          return const SizedBox();
        },
      );
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return registry
                ? DependencyRegistryScope(
                    values: {_Dependency: dependency},
                    child: consumer,
                  )
                : DependencyScope<_Dependency>(
                    value: dependency,
                    child: consumer,
                  );
          },
        ),
      );
      expect(resolved, same(dependency));
      expect(builds, 1);
      update(() => dependency = const _Dependency('second'));
      await tester.pump();
      expect(resolved, same(dependency));
      expect(builds, 2);
    });
  }

  testWidgets('maybeOf follows registry insertion and removal', (tester) async {
    var values = <Type, Object>{};
    _Dependency? resolved;
    late StateSetter update;
    final consumer = Builder(
      builder: (context) {
        resolved = DependencyScope.maybeOf<_Dependency>(context);
        return const SizedBox();
      },
    );
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return DependencyRegistryScope(values: values, child: consumer);
        },
      ),
    );
    expect(resolved, isNull);
    const dependency = _Dependency('inserted');
    update(() => values = {_Dependency: dependency});
    await tester.pump();
    expect(resolved, same(dependency));
    update(() => values = {});
    await tester.pump();
    expect(resolved, isNull);
  });

  testWidgets(
    'maybeOf prefers a typed override without watching its registry',
    (tester) async {
      var root = const _Dependency('root');
      const local = _Dependency('local');
      var builds = 0;
      _Dependency? resolved;
      late StateSetter update;
      final consumer = DependencyScope<_Dependency>(
        value: local,
        child: Builder(
          builder: (context) {
            builds++;
            resolved = DependencyScope.maybeOf<_Dependency>(context);
            return const SizedBox();
          },
        ),
      );
      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return DependencyRegistryScope(
              values: {_Dependency: root},
              child: consumer,
            );
          },
        ),
      );
      update(() => root = const _Dependency('changed'));
      await tester.pump();
      expect(resolved, same(local));
      expect(builds, 1);
    },
  );

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
