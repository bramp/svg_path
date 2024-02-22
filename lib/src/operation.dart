import 'package:meta/meta.dart';

enum Axis { x, y }

abstract class Operations<T> {
  /// Returns a new [T] translated by x and y.
  @useResult
  T translate(num x, num y);

  /// Returns a new [T] rotated [angle] radians around [centerX],[centerY].
  @useResult
  T rotate(double angle, [double centerX = 0.0, double centerY = 0.0]);

  /// Mirrors the [T] over vertical or horizontal line that goes though [centerX],[centerY].
  // TODO Support mirroring over a arbitrary line.
  @useResult
  T mirror(Axis axis, [double centerX = 0.0, double centerY = 0.0]);
}
