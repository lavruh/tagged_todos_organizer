import 'package:flutter/material.dart';

const _maxBlue = 255 - 10 * 7;
const _maxGreen = 255 - 10 * 5;

Color getColorForPriority(int priority) {
  if (priority == 0) return Colors.white;
  if(priority == 1) return Colors.red.shade300;
  if(priority == 2) return Colors.red.shade200;
  if(priority == 3) return Colors.orange.shade200;
  if(priority == 4) return Colors.orange.shade100;
  if(priority == 5) return Colors.yellow.shade100;
  if(priority == 6) return Colors.yellow.shade50;
  final blue = _maxBlue + priority * 7;
  final green = _maxGreen + priority * 5;
  return Colors.white
      .withBlue(blue > 255 ? 255 : blue)
      .withGreen(green > 255 ? 255 : green);
}
