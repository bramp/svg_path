import 'package:path_parsing/path_parsing.dart';

import 'path.dart';
import 'svg_command.dart';

class PathBuilder implements PathProxy {
  final List<SvgCommand> segments = [];

  @override
  void close() {
    segments.add(SvgClose());
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

  Path finished() {
    return Path(segments);
  }
}
