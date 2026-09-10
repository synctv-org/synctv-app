import 'dart:io';

import 'package:synctv_app/features/providers/presentation/binding/bilibili_geetest_html.dart';

void main(List<String> arguments) {
  if (arguments.length != 1) {
    throw ArgumentError('Provide one output HTML path.');
  }
  File(arguments.single).writeAsStringSync(
    buildBilibiliGeetestHtml(gt: 'preview', challenge: 'preview'),
  );
}
