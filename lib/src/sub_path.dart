import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import 'math.dart';
import 'operation.dart';
import 'svg_command.dart';

/// A sequence of SVG commands making up a path.
@immutable
class SubPath implements Operations<SubPath> {
  final List<SvgCommand> segments;

  SubPath(List<SvgCommand> segments) : segments = List.unmodifiable(segments) {
    if (segments.isEmpty) {
      throw ArgumentError('A SubPath must have at least one segment');
    }

    if (segments.contains(SvgClose())) {
      if (segments.last is! SvgClose) {
        throw StateError('If there is a ClosePath it must be last');
      }

      if (segments.whereType<SvgClose>().length > 1) {
        throw UnimplementedError(
            'Only a single ClosePath is allowed per SubPath');
      }
    }
  }

  bool get isClosed => segments.last is SvgClose;
  int get length => segments.length;

  /// Returns a new Path translated by x and y.
  @override
  SubPath translate(num x, num y) {
    return SubPath(segments.map((p) => p.translate(x, y)).toList());
  }

  /// Rotate this [angle] radians around [centerX],[centerY].
  @override
  SubPath rotate(angle, [double centerX = 0.0, double centerY = 0.0]) {
    return SubPath(
        segments.map((p) => p.rotate(angle, centerX, centerY)).toList());
  }

  /// Mirrors the [T] over vertical or horizontal line that goes though [centerX],[centerY].
  // TODO Support mirroring over a arbitrary line.
  @override
  SubPath mirror(Axis axis, [double centerX = 0.0, double centerY = 0.0]) {
    return SubPath(
        segments.map((p) => p.mirror(axis, centerX, centerY)).toList());
  }

  /// Returns a new Path with the segments in reverse order.
  @useResult
  SubPath reverse() {
    if (segments.length <= 1) {
      return this;
    }

    List<SvgCommand> reversed = [];

    // In reverse order, find where each previous point ends
    // and create the same command but going to that last point.
    for (int i = segments.length - 1; i > 0; i--) {
      final SvgCommand segment = segments[i];

      if (segment is SvgClose) {
        // Skip this.
        continue;
      }

      if (reversed.isEmpty) {
        final end = segment.end;
        reversed.add(SvgMoveTo(end.$1, end.$2));
      }

      final prevEnd = segments[i - 1].end;
      switch (segment) {
        case SvgMoveTo():
          reversed.add(SvgMoveTo(prevEnd.$1, prevEnd.$2));
          break;
        case SvgLineTo():
          reversed.add(SvgLineTo(prevEnd.$1, prevEnd.$2));
          break;
        case SvgCubicTo():
          // TODO Do I need to change control points?
          reversed.add(SvgCubicTo(
            segment.x2, segment.y2, //
            segment.x1, segment.y1, //
            prevEnd.$1, prevEnd.$2, //
          ));
          break;
        case SvgClose():
          throw UnimplementedError(
              'Should not be possible to have a close command in the middle of a path.');
      }
    }

    if (isClosed) {
      reversed.add(SvgClose());
    }

    assert(segments.length == reversed.length,
        'Expected reverse path to have the same number of segments.');

    return SubPath(reversed);
  }

  @override
  bool operator ==(Object other) =>
      other is SubPath && ListEquality().equals(segments, other.segments);

  @override
  int get hashCode => ListEquality().hash(segments);

  /// Returns the SubPath as a valid SVG path string.
  @override
  String toString() {
    return segments.map((s) => s.toString()).join(' ');
  }
}
