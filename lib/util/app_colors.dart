import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static Color editorBackground = Colors.grey.shade200;
  static Color primary = Colors.blue[200]!;
  static Color borderColor = Colors.grey;
}

Color darken(Color color, double amount) {
  int r = color.red;
  int g = color.green;
  int b = color.blue;

  int darkenedR = (r * (1 - amount)).toInt();
  int darkenedG = (g * (1 - amount)).toInt();
  int darkenedB = (b * (1 - amount)).toInt();

  return Color.fromARGB(color.alpha, darkenedR, darkenedG, darkenedB);
}