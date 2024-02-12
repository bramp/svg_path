<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

## Features

Pure data library for parsing and manipulating SVG paths.

* Parse
* Translate
* Rotate
* Mirror
* Reverse (e.g clockwise to counter-clockwise)

Does not depend on Flutter/dart:ui, but these Path objects can easily be converted to dart:ui [Path objects](https://api.flutter.dev/flutter/dart-ui/Path-class.html).

## Usage

```dart

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

  // Print out the paths as SVG path strings.
  print(p0.toString());
  print(p1.toString());
  print(p2.toString());
  print(p3.toString());
}
```

## Limitations

* All SVG commands are normalised to the absolute versions of moveTo, lineTo or
  curveTo. The resulting image is identical, but the path string may be longer.

* Does not support sub-path strings (e.g 'M 10 10 L 20 20 Z   M 30 30 L 40 40 Z')