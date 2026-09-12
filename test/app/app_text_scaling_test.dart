import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:synctv_app/app/app_viewport.dart';

class _NonlinearScaler extends TextScaler {
  const _NonlinearScaler();

  @override
  double scale(double fontSize) => fontSize + 12;

  @override
  double get textScaleFactor => 2;
}

void main() {
  for (final scaler in [
    TextScaler.linear(0.7),
    TextScaler.linear(2),
    TextScaler.linear(3),
    const _NonlinearScaler(),
  ]) {
    testWidgets('app composition preserves system text scaler $scaler', (
      tester,
    ) async {
      TextScaler? actual;
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(textScaler: scaler),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: AppViewport(
              child: Builder(
                builder: (context) {
                  actual = MediaQuery.textScalerOf(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      expect(actual, same(scaler));
      for (final fontSize in [12.0, 16.0, 32.0]) {
        expect(actual!.scale(fontSize), scaler.scale(fontSize));
      }
      expect(tester.takeException(), isNull);
    });
  }
}
