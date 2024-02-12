import 'package:meta/meta.dart';
import 'package:path_parsing/path_parsing.dart';

import 'math.dart';
import 'operation.dart';
import 'path_builder.dart';
import 'svg_command.dart';

/// A sequence of SVG commands making up a path.
// TODO Rename to SubPath (as that's strictly what it is).
@immutable
class Path implements Operations<Path> {
  final List<SvgCommand> segments;

  Path(List<SvgCommand> segments) : segments = List.unmodifiable(segments) {
    if (segments.first is! SvgMoveTo) {
      throw UnimplementedError(
          'Sorry we only support paths that start with a move to command.');
    }

    if (segments.contains(SvgClose())) {
      if (segments.last is! SvgClose) {
        throw StateError('If there is a close path it must be last');
      }

      if (segments.whereType<SvgClose>().length > 1) {
        throw UnimplementedError(
            'Sorry we only support a single sub path. (That is a path with a single close path command.)');
      }
    }
  }

  factory Path.fromString(String path) {
    final SvgPathStringSource parser = SvgPathStringSource(path);
    final SvgPathNormalizer normalizer = SvgPathNormalizer();

    final builder = PathBuilder();

    for (PathSegmentData seg in parser.parseSegments()) {
      normalizer.emitSegment(seg, builder);
    }

    return builder.finished();
  }

  bool get isClosed => segments.contains(SvgClose());

  /// Returns a new Path translated by x and y.
  @override
  Path translate(num x, num y) {
    return Path(segments.map((p) => p.translate(x, y)).toList());
  }

  /// Rotate this [angle] radians around [centerX],[centerY].
  @override
  Path rotate(angle, [double centerX = 0.0, double centerY = 0.0]) {
    return Path(
        segments.map((p) => p.rotate(angle, centerX, centerY)).toList());
  }

  /// Mirrors the [T] over vertical or horizontal line that goes though [centerX],[centerY].
  // TODO Support mirroring over a arbitrary line.
  @override
  Path mirror(Axis axis, [double centerX = 0.0, double centerY = 0.0]) {
    return Path(segments.map((p) => p.mirror(axis, centerX, centerY)).toList());
  }

  /// Returns a new Path with the segments in reverse order.
  Path reverse() {
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

    return Path(reversed);
  }

  /// Returns the Path as a valid SVG path string.
  @override
  String toString() {
    return segments.map((s) => s.toString()).join(' ');
  }
}
