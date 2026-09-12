import 'package:flutter/widgets.dart';
import 'package:synctv_app/app/app_startup.dart';
import 'package:synctv_app/features/home/showcase/home_showcase.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  var attempts = 0;
  runApp(
    AppStartup(
      initialize: () async {
        await Future<void>.delayed(const Duration(milliseconds: 350));
        if (attempts++ == 0) {
          throw StateError('Simulated startup storage failure');
        }
      },
      child: const HomeShowcaseApp(),
    ),
  );
}
