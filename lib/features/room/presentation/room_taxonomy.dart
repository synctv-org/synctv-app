import 'package:flutter/material.dart';

Color parseRoomLabelColor(String value, Color fallback) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return fallback;
  var hex = trimmed.startsWith('#') ? trimmed.substring(1) : trimmed;
  hex = hex.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');
  if (hex.length == 3) {
    hex = hex.split('').map((part) => '$part$part').join();
  } else if (hex.length == 6) {
    hex = 'FF$hex';
  } else if (hex.length != 8) {
    return fallback;
  }
  final valueInt = int.tryParse(hex, radix: 16);
  if (valueInt == null) return fallback;
  return Color(valueInt);
}
