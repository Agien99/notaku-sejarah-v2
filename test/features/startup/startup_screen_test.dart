import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/core/theme/app_theme.dart';
import 'package:notaku_sejarah_v2/features/startup/presentation/startup_screen.dart';

void main() {
  testWidgets('shows the branded startup identity and finishes once', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    addTearDown(semantics.dispose);
    var finished = 0;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: StartupScreen(onFinished: () => finished++),
      ),
    );

    expect(find.byKey(const ValueKey('startup-screen')), findsOneWidget);
    expect(find.text('NOTAKU SEJARAH'), findsOneWidget);
    expect(find.text('MODERN HERITAGE'), findsOneWidget);
    expect(find.bySemanticsLabel('Logo Notaku Sejarah'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(finished, 1);
    expect(tester.takeException(), isNull);
  });
}
