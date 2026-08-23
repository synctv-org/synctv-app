import 'dart:async';

Future<void> main() async {
  print('before');
  await Future<void>.delayed(const Duration(milliseconds: 10));
  print('after');
}
