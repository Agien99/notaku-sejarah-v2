import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/app/app.dart';
import 'package:notaku_sejarah_v2/core/theme/app_colors.dart';

void main() {
  testWidgets('renders Utama with bottom navigation on compact screens', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    expect(find.byKey(const ValueKey('screen-utama')), findsOneWidget);
    expect(find.text('Selamat datang ke Notaku Sejarah'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme?.scaffoldBackgroundColor, AppColors.cream);
    expect(materialApp.theme?.colorScheme.primary, AppColors.navy);
  });

  testWidgets('switches between feature screens on compact navigation', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    await tester.tap(find.text('Nota'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('screen-nota')), findsOneWidget);
    expect(find.text('Nota Sejarah'), findsOneWidget);

    await tester.tap(find.text('Kuiz'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('screen-kuiz')), findsOneWidget);
    expect(find.text('Uji kefahaman anda'), findsOneWidget);

    await tester.tap(find.text('Rekod'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('screen-rekod')), findsOneWidget);
    expect(find.text('Rekod pembelajaran'), findsOneWidget);
  });

  testWidgets('keeps the selected destination when the layout changes', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    await tester.tap(find.text('Kuiz'));
    await tester.pumpAndSettle();

    tester.view.physicalSize = const Size(700, 1024);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('screen-kuiz')), findsOneWidget);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.selectedIndex, 2);
    expect(rail.extended, isFalse);
  });

  testWidgets('uses navigation rail on medium screens', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(700, 1024);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));

    expect(find.byType(NavigationBar), findsNothing);
    expect(rail.selectedIndex, 0);
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

    expect(rail.selectedIndex, 0);
    expect(rail.extended, isTrue);
  });
}
