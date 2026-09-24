import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/app/app.dart';
import 'package:notaku_sejarah_v2/core/theme/app_colors.dart';

void main() {
  testWidgets('renders app shell with bottom navigation on compact screens', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    expect(find.byKey(const ValueKey('shell-page-utama')), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme?.scaffoldBackgroundColor, AppColors.cream);
    expect(materialApp.theme?.colorScheme.primary, AppColors.navy);
  });

  testWidgets('switches destinations from the compact navigation bar', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    await tester.tap(find.text('Nota'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('shell-page-nota')), findsOneWidget);
    expect(find.byKey(const ValueKey('shell-page-utama')), findsNothing);
  });

  testWidgets('uses navigation rail on medium screens', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(700, 1024);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.extended, isFalse);
  });

  testWidgets('uses extended navigation rail on expanded screens', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1100, 900);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.extended, isTrue);
  });
}
