import 'package:meta/meta.dart';
import 'package:svg_path_transform/src/operation.dart';

import 'math.dart';

String _formatNumber(double n) {
  // Two decimal places, and no trailing zeros.
  final s = n.toStringAsFixed(2);
  if (s.endsWith('.00')) {
    return s.substring(0, s.length - 3);
  }
  return s;
}

/// Normalised SVG Commands
/// That is limited to what dart:ui supports, and all coordinates are absolute.
@immutable
sealed class SvgCommand implements Operations<SvgCommand> {
  const SvgCommand();

  /// Returns the coordinates of the end of this command.
  /// e.g LineTo(10, 20).end = (10, 20)
  // TODO Maybe remove this, as some commands don't have an end point (e.g Close).
  (double x, double y) get end;
}

class SvgClose extends SvgCommand {
  const SvgClose();

  @override
  SvgClose translate(num x, num y) => this;

  @override
  SvgClose rotate(double angle, [double centerX = 0.0, double centerY = 0.0]) =>
      this;

  @override
  SvgClose mirror(Axis axis, [double centerX = 0.0, double centerY = 0.0]) =>
      this;

  @override
  SvgClose scale(num scaleX, [num? scaleY]) => this;

  @override
  String toString() => 'Z';

  @override
  (double, double) get end =>
      throw StateError('SvgClose end point, is the subpath\'s initial point.');

  @override
  bool operator ==(Object other) => other is SvgClose;

  @override
  int get hashCode => runtimeType.hashCode;
}

class SvgMoveTo extends SvgCommand {
  const SvgMoveTo(this.x, this.y);

  final double x;
  final double y;

  @override
  SvgMoveTo translate(num x, num y) => SvgMoveTo(this.x + x, this.y + y);

  @override
  SvgMoveTo rotate(double angle, [double centerX = 0.0, double centerY = 0.0]) {
    final (x, y) = rotatePoint(this.x, this.y, angle, centerX, centerY);
    return SvgMoveTo(x, y);
  }

  @override
  SvgMoveTo mirror(Axis axis, [double centerX = 0.0, double centerY = 0.0]) {
    final (x, y) = mirrorPoint(this.x, this.y, axis, centerX, centerY);
    return SvgMoveTo(x, y);
  }

  @override
  SvgMoveTo scale(num scaleX, [num? scaleY]) => SvgMoveTo(
        x * scaleX,
        y * (scaleY ?? scaleX),
      );

  @override
  String toString() => 'M ${_formatNumber(x)} ${_formatNumber(y)}';

  @override
  (double, double) get end => (x, y);

  @override
  bool operator ==(Object other) =>
      other is SvgMoveTo && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}

class SvgLineTo extends SvgCommand {
  const SvgLineTo(this.x, this.y);

  final double x;
  final double y;

  @override
  SvgLineTo translate(num x, num y) => SvgLineTo(this.x + x, this.y + y);

  @override
  SvgLineTo rotate(double angle, [double centerX = 0.0, double centerY = 0.0]) {
    final (x, y) = rotatePoint(this.x, this.y, angle, centerX, centerY);
    return SvgLineTo(x, y);
  }

  @override
  SvgLineTo mirror(Axis axis, [double centerX = 0.0, double centerY = 0.0]) {
    final (x, y) = mirrorPoint(this.x, this.y, axis, centerX, centerY);
    return SvgLineTo(x, y);
  }

  @override
  SvgLineTo scale(num scaleX, [num? scaleY]) => SvgLineTo(
        x * scaleX,
        y * (scaleY ?? scaleX),
      );

  @override
  String toString() => 'L ${_formatNumber(x)} ${_formatNumber(y)}';

  @override
  (double, double) get end => (x, y);

  @override
  bool operator ==(Object other) =>
      other is SvgLineTo && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);
}

// Cubic bezier segment that curves from the current point to the given
// point (x3,y3), using the control points (x1,y1) and (x2,y2).
class SvgCubicTo extends SvgCommand {
  const SvgCubicTo(this.x1, this.y1, this.x2, this.y2, this.x3, this.y3);

  final double x1;
  final double y1;

  final double x2;
  final double y2;

  final double x3;
  final double y3;

  @override
  SvgCubicTo translate(num x, num y) => SvgCubicTo(
        x1 + x, y1 + y, // control point 1
        x2 + x, y2 + y, // control point 2
        x3 + x, y3 + y, // end point
      );

  @override
  SvgCubicTo rotate(double angle,
      [double centerX = 0.0, double centerY = 0.0]) {
    final (x1, y1) = rotatePoint(this.x1, this.y1, angle, centerX, centerY);
    final (x2, y2) = rotatePoint(this.x2, this.y2, angle, centerX, centerY);
    final (x3, y3) = rotatePoint(this.x3, this.y3, angle, centerX, centerY);

    return SvgCubicTo(x1, y1, x2, y2, x3, y3);
  }

  @override
  SvgCubicTo mirror(Axis axis, [double centerX = 0.0, double centerY = 0.0]) {
    final (x1, y1) = mirrorPoint(this.x1, this.y1, axis, centerX, centerY);
    final (x2, y2) = mirrorPoint(this.x2, this.y2, axis, centerX, centerY);
    final (x3, y3) = mirrorPoint(this.x3, this.y3, axis, centerX, centerY);

    return SvgCubicTo(x1, y1, x2, y2, x3, y3);
  }

  @override
  SvgCubicTo scale(num scaleX, [num? scaleY]) => SvgCubicTo(
        x1 * scaleX,
        y1 * (scaleY ?? scaleX),
        x2 * scaleX,
        y2 * (scaleY ?? scaleX),
        x3 * scaleX,
        y3 * (scaleY ?? scaleX),
      );

  @override
  String toString() => 'C ' //
      '${_formatNumber(x1)} ${_formatNumber(y1)}, ' //
      '${_formatNumber(x2)} ${_formatNumber(y2)}, ' //
      '${_formatNumber(x3)} ${_formatNumber(y3)}';

  @override
  (double, double) get end => (x3, y3);

  @override
  bool operator ==(Object other) =>
      other is SvgCubicTo &&
      other.x1 == x1 &&
      other.y1 == y1 &&
      other.x2 == x2 &&
      other.y2 == y2 &&
      other.x3 == x3 &&
      other.y3 == y3;

  @override
  int get hashCode => Object.hash(x1, y1, x2, y2, x3, y3);
}
