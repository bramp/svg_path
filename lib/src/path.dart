import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:path_parsing/path_parsing.dart';
import 'package:svg_path/src/math.dart';
import 'package:svg_path/src/operation.dart';
import 'package:svg_path/src/path_builder.dart';
import 'package:svg_path/src/sub_path.dart';

@immutable
class Path implements Operations<Path> {
  final List<SubPath> subPaths;

  Path(List<SubPath> subPaths) : subPaths = List.unmodifiable(subPaths);

  const Path.empty() : subPaths = const [];

  factory Path.fromString(String path) {
    final SvgPathStringSource parser = SvgPathStringSource(path);
    final SvgPathNormalizer normalizer = SvgPathNormalizer();

    final builder = PathBuilder();

    for (PathSegmentData seg in parser.parseSegments()) {
      normalizer.emitSegment(seg, builder);
    }

    return builder.finished();
  }

  /// Creates a path that represents a circle at ([cx], [cy]) with radius [r].
  /// That is a path made up for two 180 degree arcs.
  factory Path.fromCircle(double cx, double cy, double r) {
    // https://stackoverflow.com/questions/5737975/circle-drawing-with-svgs-arc-path
    return Path.fromString(
      'M${cx - r},$cy '
      'a$r,$r 0 1,0 ${r * 2},0 '
      'a$r,$r 0 1,0 -${r * 2},0 '
      'Z',
    );
  }

  /// Creates a path that represents a ellipse at ([cx], [cy]) with radius [rx]
  /// and [ry].
  /// That is a path made up for two 180 degree arcs.
  factory Path.fromEllipse(double cx, double cy, double rx, double ry) {
    return Path.fromString(
      'M${cx - rx},$cy '
      'a$rx,$ry 0 1,0 ${rx * 2},0 '
      'a$rx,$ry 0 1,0 -${rx * 2},0 '
      'Z',
    );
  }

  int get length => subPaths.map((p) => p.length).sum;

  @override
  Path mirror(Axis axis, [double centerX = 0.0, double centerY = 0.0]) {
    return Path(subPaths.map((p) => p.mirror(axis, centerX, centerY)).toList());
  }

  @override
  Path rotate(angle, [double centerX = 0.0, double centerY = 0.0]) {
    return Path(
        subPaths.map((p) => p.rotate(angle, centerX, centerY)).toList());
  }

  @override
  Path translate(num x, num y) {
    return Path(subPaths.map((p) => p.translate(x, y)).toList());
  }

  Path reverse() {
    return Path(subPaths.reversed.map((p) => p.reverse()).toList());
  }

  /// Joins two paths together. e.g
  /// ```
  /// final a = Path.fromString('M0,0 L1,1 Z')
  /// final b = Path.fromString('M2,2 L3,3 Z');
  /// final c = a.join(b);
  /// // c == Path.fromString('M0,0 L1,1 Z   M2,2 L3,3 Z');
  /// ```
  Path concat(Path other) {
    return Path([...subPaths, ...other.subPaths]);
  }

  /// Returns the Path as a valid SVG path string.
  @override
  String toString() {
    return subPaths.map((s) => s.toString()).join(' ');
  }

  @override
  bool operator ==(Object other) =>
      other is Path && ListEquality().equals(subPaths, other.subPaths);

  @override
  int get hashCode => ListEquality().hash(subPaths);
}
