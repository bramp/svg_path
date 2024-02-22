import 'dart:math';

import 'package:svg_path_transform/svg_path_transform.dart';
import 'package:test/test.dart';

void main() {
  test('equals is approximent', () {
    // These two should be the same, but double precision says they are not.
    expect(
        Path.fromString('M 100 100 L200 100 L100 200 Z')
            .rotate(270 / 180 * pi, 500, 500),
        equals(Path.fromString('M 100 900 L 100 800 L 200 900 Z')));
  });

  test('equals works', () {
    expect(
        Path.fromString('M 0 50 L 100 200 C 100 200 300 400 500 600 Z'),
        equals(
            Path.fromString('M 0 50 L 100 200 C 100 200 300 400 500 600 Z')));

    // and not equals
    expect(Path.fromString('M 0 50'), isNot(equals(Path.fromString('M 50 0'))));
    expect(Path.fromString('M 0 50 L 100 200'),
        isNot(equals(Path.fromString('M 0 0 L 200 100'))));
    expect(Path.fromString('M 0 0 L 100 200'),
        isNot(equals(Path.fromString('M 0 0 M 100 200'))));
    expect(Path.fromString('M 0 0 C 100 200 300 400 500 600'),
        isNot(equals(Path.fromString('M 0 0 C 1 2 3 4 5 6'))));
    expect(Path.fromString('M 0 0 Z'), isNot(equals(Path.fromString('M 0 0'))));
  });
}
