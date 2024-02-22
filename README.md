Pure dart library for parsing and manipulating SVG paths.

[![Pub package](https://img.shields.io/pub/v/svg_path_transform.svg)](https://pub.dev/packages/svg_path_transform)
[![Pub publisher](https://img.shields.io/pub/publisher/svg_path_transform.svg)](https://pub.dev/publishers/bramp.net/packages)
[![Dart Analysis](https://github.com/bramp/svg_path/actions/workflows/dart.yml/badge.svg)](https://github.com/bramp/svg_path/actions/workflows/dart.yml)

## Features

* Parse a SVG path
* Translate the path
* Rotate the path around a point
* Mirror the path across an axis
* Scale the path
* Reverse (e.g clockwise to counter-clockwise)

Does not depend on [Flutter](https://api.flutter.dev/index.html) or [dart:ui](https://api.flutter.dev/flutter/dart-ui/dart-ui-library.html), but these Path objects can easily be converted to dart:ui [Path objects](https://api.flutter.dev/flutter/dart-ui/Path-class.html).

## Usage

```shell
dart pub add svg_path_transform
```

```dart
import 'package:svg_path_transform/svg_path_transform.dart';

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

  // Scale the path by 2 in the x direction, and 0.5 in the y direction.
  final p4 = path.scale(2, 0.5);

  // Print out the paths as SVG path strings.
  print(p0.toString());
  print(p1.toString());
  print(p2.toString());
  print(p3.toString());
  print(p4.toString());
}
```

## Limitations

* All SVG commands are normalised to the absolute versions of moveTo, lineTo or
  curveTo. The resulting image is identical, but the path string may be longer.
