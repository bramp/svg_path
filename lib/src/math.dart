import 'dart:math';

enum Axis { x, y }

(double, double) rotatePoint(double x, double y, double radians,
    [double centerX = 0.0, double centerY = 0.0]) {
  final cosA = cos(radians);
  final sinA = sin(radians);

  // Translate to origin
  x -= centerX;
  y -= centerY;

  // Rotate
  final newX = (x * cosA - y * sinA);
  final newY = (x * sinA + y * cosA);

  // Translate back
  return (
    newX + centerX,
    newY + centerY,
  );
}

// TODO Change to support arbitrary line as the axis.
(double, double) mirrorPoint(double x, double y, Axis axis,
    [double centerX = 0.0, double centerY = 0.0]) {
  // Translate to origin
  x -= centerX;
  y -= centerY;

  // Flip over the appropriate axis
  if (axis == Axis.x) {
    x = -x;
  } else if (axis == Axis.y) {
    y = -y;
  }

  // Translate back
  return (
    x + centerX,
    y + centerY,
  );
}
