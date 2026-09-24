import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/core/responsive/app_breakpoints.dart';

void main() {
  group('AppBreakpoints', () {
    test('classifies compact widths below 600', () {
      expect(AppBreakpoints.fromWidth(0), AppWindowClass.compact);
      expect(AppBreakpoints.fromWidth(599.9), AppWindowClass.compact);
    });

    test('classifies medium widths from 600 to below 900', () {
      expect(AppBreakpoints.fromWidth(600), AppWindowClass.medium);
      expect(AppBreakpoints.fromWidth(899.9), AppWindowClass.medium);
    });

    test('classifies expanded widths from 900', () {
      expect(AppBreakpoints.fromWidth(900), AppWindowClass.expanded);
      expect(AppBreakpoints.fromWidth(1440), AppWindowClass.expanded);
    });
  });
}
