import 'dart:math';

import 'package:svg_path/svg_path.dart';

void main() {
  // Read a path from a SVG path string.
  final path = Path.fromString('M 10 10 H 90 V 90 H 10 L 10 10 Z');

  // Translate the path 10 units in the x and y direction.
  final p0 = path.translate(10, 10);

  // Rotate the path 45 degrees around the point (50, 50).
  final p1 = path.rotate(pi / 4, 50, 50);

  // Reverse the path (drawing from the end to the start)
  final p2 = path.reverse();

  // Mirror the path across the X axis.
  final p3 = path.mirror(Axis.x);

  // Print out the paths as SVG path strings.
  print(p0.toString());
  print(p1.toString());
  print(p2.toString());
  print(p3.toString());
}
