import 'package:flutter/widgets.dart';
import 'package:synctv_app/contracts/synctv_models.dart';
import 'package:synctv_app/features/home/showcase/home_showcase.dart';

void main() {
  final longCategory = Uri.base.queryParameters['categories'] == 'long';
  runApp(
    HomeShowcaseApp(
      textScaler: TextScaler.linear(longCategory ? 3 : 2),
      state: longCategory
          ? homeShowcaseState(
              categories: const [
                RoomCategoryInfo(
                  id: 'long',
                  key: 'long',
                  name: 'International cinema and documentary discussion screenings',
                  description: '',
                  sortOrder: 0,
                  isEnabled: true,
                ),
              ],
            )
          : null,
    ),
  );
}
