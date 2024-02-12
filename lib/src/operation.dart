import 'math.dart';

abstract class Operations<T> {
  /// Returns a new [T] translated by x and y.
  T translate(num x, num y);

  /// Returns a new [T] rotated [angle] radians around [centerX],[centerY].
  T rotate(angle, [double centerX = 0.0, double centerY = 0.0]);

  /// Mirrors the [T] over vertical or horizontal line that goes though [centerX],[centerY].
  // TODO Support mirroring over a arbitrary line.
  T mirror(Axis axis, [double centerX = 0.0, double centerY = 0.0]);
}
