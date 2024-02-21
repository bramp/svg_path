import 'dart:io';
import 'dart:math';

import 'package:svg_path_transform/svg_path_transform.dart';
import 'package:test/test.dart';

void main() {
  group('Path.fromString() handles subpaths', () {
    final tests = [
      ('M10 10', 1),
      ('M10 10 Z', 1),
      ('M10 10 Z L 1 1', 2),
      ('M10 10 Z L 1 1 Z', 2)
    ];

    for (final t in tests) {
      test(t.$1, () {
        expect(Path.fromString(t.$1).subPaths.length, t.$2);
      });
    }
  });

  group('Path.fromString', () {
    // Taken from https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial/Paths
    final tests = [
      (
        'M10 10',
        'M 10 10',
      ),
      (
        'M 10 10 H 90 V 90 H 10 L 10 10',
        'M 10 10 L 90 10 L 90 90 L 10 90 L 10 10',
      ),
      (
        'M 10 10 H 90 V 90 H 10 Z',
        'M 10 10 L 90 10 L 90 90 L 10 90 Z',
      ),
      (
        'M 10 10 h 80 v 80 h -80 Z',
        'M 10 10 L 90 10 L 90 90 L 10 90 Z',
      ),
      (
        'M 10 10 C 20 20, 40 20, 50 10',
        'M 10 10 C 20 20, 40 20, 50 10',
      ),
      (
        'M 70 10 C 70 20, 110 20, 110 10',
        'M 70 10 C 70 20, 110 20, 110 10',
      ),
      (
        'M 130 10 C 120 20, 180 20, 170 10',
        'M 130 10 C 120 20, 180 20, 170 10'
      ),
      (
        'M 10 60 C 20 80, 40 80, 50 60',
        'M 10 60 C 20 80, 40 80, 50 60',
      ),
      (
        'M 70 60 C 70 80, 110 80, 110 60',
        'M 70 60 C 70 80, 110 80, 110 60',
      ),
      (
        'M 130 60 C 120 80, 180 80, 170 60',
        'M 130 60 C 120 80, 180 80, 170 60'
      ),
      (
        'M 10 110 C 20 140, 40 140, 50 110',
        'M 10 110 C 20 140, 40 140, 50 110'
      ),
      (
        'M 70 110 C 70 140, 110 140, 110 110',
        'M 70 110 C 70 140, 110 140, 110 110'
      ),
      (
        'M 130 110 C 120 140, 180 140, 170 110',
        'M 130 110 C 120 140, 180 140, 170 110'
      ),
      (
        'M 10 80 C 40 10, 65 10, 95 80 S 150 150, 180 80',
        'M 10 80 C 40 10, 65 10, 95 80 C 125 150, 150 150, 180 80'
      ),
      (
        'M 10 80 Q 95 10 180 80',
        'M 10 80 C 66.67 33.33, 123.33 33.33, 180 80',
      ),
      (
        'M 10 80 Q 52.5 10, 95 80 T 180 80',
        'M 10 80 C 38.33 33.33, 66.67 33.33, 95 80 C 123.33 126.67, 151.67 126.67, 180 80'
      ),
      (
        'M 10 315 L 110 215 A 30 50 0 0 1 162.55 162.45 L 172.55 152.45 A 30 50 -45 0 1 215.1 109.9 L 315 10',
        'M 10 315 L 110 215 C 101.29 190.81, 106 159.44, 120.51 144.93 C 135.02 130.42, 153.84 138.26, 162.55 162.45 L 172.55 152.45 C 152.97 132.87, 146.62 107.47, 158.37 95.72 C 170.12 83.97, 195.52 90.32, 215.10 109.90 L 315 10'
      ),
      (
        'M 10 315 L 110 215 A 36 60 0 0 1 150.71 170.29 L 172.55 152.45 A 30 50 -45 0 1 215.1 109.9 L 315 10',
        'M 10 315 L 110 215 C 114.53 184.72, 132.23 165.28, 150.71 170.29 L 172.55 152.45 C 152.97 132.87, 146.62 107.47, 158.37 95.72 C 170.12 83.97, 195.52 90.32, 215.10 109.90 L 315 10'
      ),
      (
        'M 80 80 A 45 45, 0, 0, 0, 125 125 L 125 80 Z',
        'M 80 80 C 80 104.85, 100.15 125, 125 125 L 125 80 Z'
      ),
      (
        'M 230 80 A 45 45, 0, 1, 0, 275 125 L 275 80 Z',
        'M 230 80 C 205.15 80, 185 100.15, 185 125 C 185 149.85, 205.15 170, 230 170 C 254.85 170, 275 149.85, 275 125 L 275 80 Z'
      ),
      (
        'M 80 230 A 45 45, 0, 0, 1, 125 275 L 125 230 Z',
        'M 80 230 C 104.85 230, 125 250.15, 125 275 L 125 230 Z'
      ),
      (
        'M 230 230 A 45 45, 0, 1, 1, 275 275 L 275 230 Z',
        'M 230 230 C 230 205.15, 250.15 185, 275 185 C 299.85 185, 320 205.15, 320 230 C 320 254.85, 299.85 275, 275 275 L 275 230 Z'
      ),
    ];
    //writeTestsToHTML(tests);

    for (final t in tests) {
      test(t.$1, () {
        final result = Path.fromString(t.$1);
        expect(result.toString(), t.$2);
      });
    }
  });

  group('Path.translate(50, 50)', () {
    // Taken from https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial/Paths
    final tests = [
      (
        'M10 10',
        'M 60 60',
      ),
      (
        'M 10 10 H 90 V 90 H 10 L 10 10',
        'M 60 60 L 140 60 L 140 140 L 60 140 L 60 60',
      ),
      (
        'M 10 10 H 90 V 90 H 10 Z',
        'M 60 60 L 140 60 L 140 140 L 60 140 Z',
      ),
      (
        'M 10 10 h 80 v 80 h -80 Z',
        'M 60 60 L 140 60 L 140 140 L 60 140 Z',
      ),
      (
        'M 10 10 C 20 20, 40 20, 50 10',
        'M 60 60 C 70 70, 90 70, 100 60',
      ),
      (
        'M 70 10 C 70 20, 110 20, 110 10',
        'M 120 60 C 120 70, 160 70, 160 60',
      ),
      (
        'M 130 10 C 120 20, 180 20, 170 10',
        'M 180 60 C 170 70, 230 70, 220 60'
      ),
      (
        'M 10 60 C 20 80, 40 80, 50 60',
        'M 60 110 C 70 130, 90 130, 100 110',
      ),
      (
        'M 70 60 C 70 80, 110 80, 110 60',
        'M 120 110 C 120 130, 160 130, 160 110',
      ),
      (
        'M 130 60 C 120 80, 180 80, 170 60',
        'M 180 110 C 170 130, 230 130, 220 110'
      ),
      (
        'M 10 110 C 20 140, 40 140, 50 110',
        'M 60 160 C 70 190, 90 190, 100 160'
      ),
      (
        'M 70 110 C 70 140, 110 140, 110 110',
        'M 120 160 C 120 190, 160 190, 160 160'
      ),
      (
        'M 130 110 C 120 140, 180 140, 170 110',
        'M 180 160 C 170 190, 230 190, 220 160'
      ),
      (
        'M 10 80 C 40 10, 65 10, 95 80 S 150 150, 180 80',
        'M 60 130 C 90 60, 115 60, 145 130 C 175 200, 200 200, 230 130',
      ),
      (
        'M 10 80 Q 95 10 180 80',
        'M 60 130 C 116.67 83.33, 173.33 83.33, 230 130',
      ),
      (
        'M 10 80 Q 52.5 10, 95 80 T 180 80',
        'M 60 130 C 88.33 83.33, 116.67 83.33, 145 130 C 173.33 176.67, 201.67 176.67, 230 130'
      ),
      (
        'M 10 315 L 110 215 A 30 50 0 0 1 162.55 162.45 L 172.55 152.45 A 30 50 -45 0 1 215.1 109.9 L 315 10',
        'M 60 365 L 160 265 C 151.29 240.81, 156 209.44, 170.51 194.93 C 185.02 180.42, 203.84 188.26, 212.55 212.45 L 222.55 202.45 C 202.97 182.87, 196.62 157.47, 208.37 145.72 C 220.12 133.97, 245.52 140.32, 265.10 159.90 L 365 60'
      ),
      (
        'M 10 315 L 110 215 A 36 60 0 0 1 150.71 170.29 L 172.55 152.45 A 30 50 -45 0 1 215.1 109.9 L 315 10',
        'M 60 365 L 160 265 C 164.53 234.72, 182.23 215.28, 200.71 220.29 L 222.55 202.45 C 202.97 182.87, 196.62 157.47, 208.37 145.72 C 220.12 133.97, 245.52 140.32, 265.10 159.90 L 365 60'
      ),
      (
        'M 80 80 A 45 45, 0, 0, 0, 125 125 L 125 80 Z',
        'M 130 130 C 130 154.85, 150.15 175, 175 175 L 175 130 Z'
      ),
      (
        'M 230 80 A 45 45, 0, 1, 0, 275 125 L 275 80 Z',
        'M 280 130 C 255.15 130, 235 150.15, 235 175 C 235 199.85, 255.15 220, 280 220 C 304.85 220, 325 199.85, 325 175 L 325 130 Z'
      ),
      (
        'M 80 230 A 45 45, 0, 0, 1, 125 275 L 125 230 Z',
        'M 130 280 C 154.85 280, 175 300.15, 175 325 L 175 280 Z'
      ),
      (
        'M 230 230 A 45 45, 0, 1, 1, 275 275 L 275 230 Z',
        'M 280 280 C 280 255.15, 300.15 235, 325 235 C 349.85 235, 370 255.15, 370 280 C 370 304.85, 349.85 325, 325 325 L 325 280 Z'
      ),
    ];

    //writeTestsToHTML(tests, 'translate(50 50)');
    for (final t in tests) {
      test(t.$1, () {
        final result = Path.fromString(t.$1).translate(50, 50);
        expect(result.toString(), t.$2);
      });
    }
  });

  group('Path.reverse()', () {
    final tests = [
      // Examples from experiments with http://paperjs.org/reference/path/
      (
        'M0,0 L100,100 L150,150 L175,175',
        'M 175 175 L 150 150 L 100 100 L 0 0',
      ),
      (
        'M 30 75  L 30 25  L 80 25  L 80 75 Z',
        'M 80 75 L 80 25 L 30 25 L 30 75 Z',
      ),

      // Taken from https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial/Paths
      (
        'M10 10',
        'M 10 10',
      ),
      (
        'M 10 10 L 90 10 L 90 90 L 10 90 L 10 10',
        'M 10 10 L 10 90 L 90 90 L 90 10 L 10 10',
      ),
      (
        'M 10 10 L 90 10 L 90 90 L 10 90 Z',
        'M 10 90 L 90 90 L 90 10 L 10 10 Z',
      ),
      (
        'M 10 10 L 90 10 L 90 90 L 10 90 Z',
        'M 10 90 L 90 90 L 90 10 L 10 10 Z',
      ),
      (
        'M 10 10 C 20 20, 40 20, 50 10',
        'M 50 10 C 40 20, 20 20, 10 10',
      ),
      (
        'M 70 10 C 70 20, 110 20, 110 10',
        'M 110 10 C 110 20, 70 20, 70 10',
      ),
      (
        'M 130 10 C 120 20, 180 20, 170 10',
        'M 170 10 C 180 20, 120 20, 130 10'
      ),
      (
        'M 10 60 C 20 80, 40 80, 50 60',
        'M 50 60 C 40 80, 20 80, 10 60',
      ),
      (
        'M 70 60 C 70 80, 110 80, 110 60',
        'M 110 60 C 110 80, 70 80, 70 60',
      ),
      (
        'M 130 60 C 120 80, 180 80, 170 60',
        'M 170 60 C 180 80, 120 80, 130 60'
      ),
      (
        'M 10 110 C 20 140, 40 140, 50 110',
        'M 50 110 C 40 140, 20 140, 10 110'
      ),
      (
        'M 70 110 C 70 140, 110 140, 110 110',
        'M 110 110 C 110 140, 70 140, 70 110'
      ),
      (
        'M 130 110 C 120 140, 180 140, 170 110',
        'M 170 110 C 180 140, 120 140, 130 110'
      ),
      (
        'M 10 80 C 40 10, 65 10, 95 80 C 125 150, 150 150, 180 80',
        'M 180 80 C 150 150, 125 150, 95 80 C 65 10, 40 10, 10 80',
      ),
      (
        // 'M 10 80 Q 95 10 180 80',
        'M 10 80 C 66.67 33.33, 123.33 33.33, 180 80',
        'M 180 80 C 123.33 33.33, 66.67 33.33, 10 80',
      ),
      (
        // 'M 10 80 Q 52.5 10, 95 80 T 180 80',
        'M 10 80 C 38.33 33.33, 66.67 33.33, 95 80 C 123.33 126.67, 151.67 126.67, 180 80',
        'M 180 80 C 151.67 126.67, 123.33 126.67, 95 80 C 66.67 33.33, 38.33 33.33, 10 80'
      ),
      (
        // 'M 10 315 L 110 215 A 30 50 0 0 1 162.55 162.45 L 172.55 152.45 A 30 50 -45 0 1 215.1 109.9 L 315 10',
        'M 10 315 L 110 215 C 101.29 190.81, 106 159.44, 120.51 144.93 C 135.02 130.42, 153.84 138.26, 162.55 162.45 L 172.55 152.45 C 152.97 132.87, 146.62 107.47, 158.37 95.72 C 170.12 83.97, 195.52 90.32, 215.10 109.90 L 315 10',
        'M 315 10 L 215.10 109.90 C 195.52 90.32, 170.12 83.97, 158.37 95.72 C 146.62 107.47, 152.97 132.87, 172.55 152.45 L 162.55 162.45 C 153.84 138.26, 135.02 130.42, 120.51 144.93 C 106 159.44, 101.29 190.81, 110 215 L 10 315'
      ),
      (
        // 'M 10 315 L 110 215 A 36 60 0 0 1 150.71 170.29 L 172.55 152.45 A 30 50 -45 0 1 215.1 109.9 L 315 10',
        'M 10 315 L 110 215 C 114.53 184.72, 132.23 165.28, 150.71 170.29 L 172.55 152.45 C 152.97 132.87, 146.62 107.47, 158.37 95.72 C 170.12 83.97, 195.52 90.32, 215.10 109.90 L 315 10',
        'M 315 10 L 215.10 109.90 C 195.52 90.32, 170.12 83.97, 158.37 95.72 C 146.62 107.47, 152.97 132.87, 172.55 152.45 L 150.71 170.29 C 132.23 165.28, 114.53 184.72, 110 215 L 10 315'
      ),
      (
        // 'M 80 80 A 45 45, 0, 0, 0, 125 125 L 125 80 Z',
        'M 80 80 C 80 104.85, 100.15 125, 125 125 L 125 80 Z',
        'M 125 80 L 125 125 C 100.15 125, 80 104.85, 80 80 Z',
      ),
      (
        // 'M 230 80 A 45 45, 0, 1, 0, 275 125 L 275 80 Z',
        'M 230 80 C 205.15 80, 185 100.15, 185 125 C 185 149.85, 205.15 170, 230 170 C 254.85 170, 275 149.85, 275 125 L 275 80 Z',
        'M 275 80 L 275 125 C 275 149.85, 254.85 170, 230 170 C 205.15 170, 185 149.85, 185 125 C 185 100.15, 205.15 80, 230 80 Z'
      ),
      (
        // 'M 80 230 A 45 45, 0, 0, 1, 125 275 L 125 230 Z',
        'M 80 230 C 104.85 230, 125 250.15, 125 275 L 125 230 Z',
        'M 125 230 L 125 275 C 125 250.15, 104.85 230, 80 230 Z',
      ),
      (
        // 'M 230 230 A 45 45, 0, 1, 1, 275 275 L 275 230 Z',
        'M 230 230 C 230 205.15, 250.15 185, 275 185 C 299.85 185, 320 205.15, 320 230 C 320 254.85, 299.85 275, 275 275 L 275 230 Z',
        'M 275 230 L 275 275 C 299.85 275, 320 254.85, 320 230 C 320 205.15, 299.85 185, 275 185 C 250.15 185, 230 205.15, 230 230 Z',
      ),
    ];

    //writeTestsToHTML(tests);
    for (final t in tests) {
      test(t.$1, () {
        final result = Path.fromString(t.$1).reverse();
        expect(result.toString(), t.$2);
      });
    }
  });

  group('Path.rotate(pi/2, 100, 100)', () {
    final tests = [
      // Taken from https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial/Paths
      (
        'M10 10',
        'M 190 10',
      ),
      (
        'M 10 10 L 90 10 L 90 90 L 10 90 L 10 10',
        'M 190 10 L 190 90 L 110 90 L 110 10 L 190 10',
      ),
      (
        'M 10 10 L 90 10 L 90 90 L 10 90 Z',
        'M 190 10 L 190 90 L 110 90 L 110 10 Z',
      ),
      (
        'M 10 10 L 90 10 L 90 90 L 10 90 Z',
        'M 190 10 L 190 90 L 110 90 L 110 10 Z',
      ),
      (
        'M 10 10 C 20 20, 40 20, 50 10',
        'M 190 10 C 180 20, 180 40, 190 50',
      ),
      (
        'M 70 10 C 70 20, 110 20, 110 10',
        'M 190 70 C 180 70, 180 110, 190 110',
      ),
      (
        'M 130 10 C 120 20, 180 20, 170 10',
        'M 190 130 C 180 120, 180 180, 190 170'
      ),
      (
        'M 10 60 C 20 80, 40 80, 50 60',
        'M 140 10 C 120 20, 120 40, 140 50',
      ),
      (
        'M 70 60 C 70 80, 110 80, 110 60',
        'M 140 70 C 120 70, 120 110, 140 110',
      ),
      (
        'M 130 60 C 120 80, 180 80, 170 60',
        'M 140 130 C 120 120, 120 180, 140 170'
      ),
      (
        'M 10 110 C 20 140, 40 140, 50 110',
        'M 90 10 C 60 20, 60 40, 90 50',
      ),
      (
        'M 70 110 C 70 140, 110 140, 110 110',
        'M 90 70 C 60 70, 60 110, 90 110'
      ),
      (
        'M 130 110 C 120 140, 180 140, 170 110',
        'M 90 130 C 60 120, 60 180, 90 170'
      ),
      (
        'M 10 80 C 40 10, 65 10, 95 80 C 125 150, 150 150, 180 80',
        'M 120 10 C 190 40, 190 65, 120 95 C 50 125, 50 150, 120 180',
      ),
      (
        // 'M 10 80 Q 95 10 180 80',
        'M 10 80 C 66.67 33.33, 123.33 33.33, 180 80',
        'M 120 10 C 166.67 66.67, 166.67 123.33, 120 180',
      ),
      (
        // 'M 10 80 Q 52.5 10, 95 80 T 180 80',
        'M 10 80 C 38.33 33.33, 66.67 33.33, 95 80 C 123.33 126.67, 151.67 126.67, 180 80',
        'M 120 10 C 166.67 38.33, 166.67 66.67, 120 95 C 73.33 123.33, 73.33 151.67, 120 180'
      ),
      (
        // 'M 10 315 L 110 215 A 30 50 0 0 1 162.55 162.45 L 172.55 152.45 A 30 50 -45 0 1 215.1 109.9 L 315 10',
        'M 10 315 L 110 215 C 101.29 190.81, 106 159.44, 120.51 144.93 C 135.02 130.42, 153.84 138.26, 162.55 162.45 L 172.55 152.45 C 152.97 132.87, 146.62 107.47, 158.37 95.72 C 170.12 83.97, 195.52 90.32, 215.10 109.90 L 315 10',
        'M -115 10 L -15 110 C 9.19 101.29, 40.56 106, 55.07 120.51 C 69.58 135.02, 61.74 153.84, 37.55 162.55 L 47.55 172.55 C 67.13 152.97, 92.53 146.62, 104.28 158.37 C 116.03 170.12, 109.68 195.52, 90.10 215.10 L 190 315'
      ),
      (
        // 'M 10 315 L 110 215 A 36 60 0 0 1 150.71 170.29 L 172.55 152.45 A 30 50 -45 0 1 215.1 109.9 L 315 10',
        'M 10 315 L 110 215 C 114.53 184.72, 132.23 165.28, 150.71 170.29 L 172.55 152.45 C 152.97 132.87, 146.62 107.47, 158.37 95.72 C 170.12 83.97, 195.52 90.32, 215.10 109.90 L 315 10',
        'M -115 10 L -15 110 C 15.28 114.53, 34.72 132.23, 29.71 150.71 L 47.55 172.55 C 67.13 152.97, 92.53 146.62, 104.28 158.37 C 116.03 170.12, 109.68 195.52, 90.10 215.10 L 190 315'
      ),
      (
        // 'M 80 80 A 45 45, 0, 0, 0, 125 125 L 125 80 Z',
        'M 80 80 C 80 104.85, 100.15 125, 125 125 L 125 80 Z',
        'M 120 80 C 95.15 80, 75 100.15, 75 125 L 120 125 Z',
      ),
      (
        // 'M 230 80 A 45 45, 0, 1, 0, 275 125 L 275 80 Z',
        'M 230 80 C 205.15 80, 185 100.15, 185 125 C 185 149.85, 205.15 170, 230 170 C 254.85 170, 275 149.85, 275 125 L 275 80 Z',
        'M 120 230 C 120 205.15, 99.85 185, 75 185 C 50.15 185, 30 205.15, 30 230 C 30 254.85, 50.15 275, 75 275 L 120 275 Z'
      ),
      (
        // 'M 80 230 A 45 45, 0, 0, 1, 125 275 L 125 230 Z',
        'M 80 230 C 104.85 230, 125 250.15, 125 275 L 125 230 Z',
        'M -30 80 C -30 104.85, -50.15 125, -75 125 L -30 125 Z',
      ),
      (
        // 'M 230 230 A 45 45, 0, 1, 1, 275 275 L 275 230 Z',
        'M 230 230 C 230 205.15, 250.15 185, 275 185 C 299.85 185, 320 205.15, 320 230 C 320 254.85, 299.85 275, 275 275 L 275 230 Z',
        'M -30 230 C -5.15 230, 15 250.15, 15 275 C 15 299.85, -5.15 320, -30 320 C -54.85 320, -75 299.85, -75 275 L -30 275 Z',
      ),
    ];

    /*
    writeTestsToHTML(
        tests
            .map((t) => (
                  t.$1,
                  Path.fromString(t.$1).rotate(pi / 2.0, 100, 100).toString()
                ))
            .toList(),
        'rotate(90 100 100)');
    */

    for (final t in tests) {
      test(t.$1, () {
        final result = Path.fromString(t.$1).rotate(pi / 2, 100, 100);
        expect(result.toString(), t.$2);
      });
    }
  });

  // TODO Write tests for mirror
}

void writeTestsToHTML(List<(String, String)> tests, [String? transform]) {
  final f = File('tests.html').openWrite();

  f.write('''
    <!DOCTYPE html>
    <html>
    <head>
      <title>SVG Path Tests</title>
      <style>
        svg {
          border: 1px solid black;
          margin: 10px;
        }
      </style>
    </head>
    <body>
  ''');
  for (final t in tests) {
    f.write('''
      <table>
        <tr><td>${t.$1}</td><td>${t.$2}</td></tr>
        <tr>
          <td>
            <svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">
              <path d="${t.$1}" ${transform != null ? 'transform = "$transform"' : ''}/>
            </svg>
          </td>
          <td>
            <svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">
              <path d="${t.$2}"/>
            </svg>
          </td>
        </td>
      </table>
      <br />
      ''');
  }
  f.write('''
    </body>
    </html>
  ''');

  f.close();
}
