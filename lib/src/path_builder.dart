import 'package:meta/meta.dart';
import 'package:path_parsing/path_parsing.dart';
import 'package:svg_path_transform/src/path.dart';

import 'sub_path.dart';
import 'svg_command.dart';

class PathBuilder implements PathProxy {
  final List<SvgCommand> segments = [];

  @override
  void close() {
    segments.add(const SvgClose());
  }

  // Adds a cubic bezier segment that curves from the current point to the given
  // point (x3,y3), using the control points (x1,y1) and (x2,y2).
  @override
  void cubicTo(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    segments.add(SvgCubicTo(x1, y1, x2, y2, x3, y3));
  }

  @override
  void lineTo(double x, double y) {
    segments.add(SvgLineTo(x, y));
  }

  @override
  void moveTo(double x, double y) {
    segments.add(SvgMoveTo(x, y));
  }

  @useResult
  Path finished() {
    final paths = <SubPath>[];
    int last = 0;

    for (int i = 0; i < segments.length; i++) {
      if (segments[i] is SvgClose) {
        paths.add(SubPath(segments.sublist(last, i + 1)));
        last = i + 1;
      }
    }

    if (last < segments.length) {
      paths.add(SubPath(segments.sublist(last)));
    }

    return Path(paths);
  }
}
