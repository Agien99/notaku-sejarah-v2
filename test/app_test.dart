import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/app/app.dart';
import 'package:notaku_sejarah_v2/core/theme/app_colors.dart';

void main() {
  Finder navigationLabel(String label) {
    return find.descendant(
      of: find.byType(NavigationBar),
      matching: find.text(label),
    );
  }

  testWidgets('renders complete Utama empty state on compact screens', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    expect(find.byKey(const ValueKey('screen-utama')), findsOneWidget);
    expect(find.text('NOTAKU SEJARAH'), findsOneWidget);
    expect(find.text('MODERN HERITAGE'), findsOneWidget);
    expect(find.text('Selamat datang 👋'), findsOneWidget);
    expect(find.text('Jom belajar Sejarah hari ini.'), findsOneWidget);
    expect(find.text('Sambung Belajar'), findsOneWidget);
    expect(find.text('Pintasan'), findsOneWidget);
    expect(find.text('Prestasi Terkini'), findsOneWidget);
    expect(find.text('Aktiviti Terkini'), findsOneWidget);
    expect(
      find.text('Belum ada pembelajaran untuk disambung'),
      findsOneWidget,
    );
    expect(find.text('Belum ada keputusan kuiz'), findsOneWidget);
    expect(find.text('Belum ada aktiviti terkini'), findsOneWidget);
    expect(find.text('Boleh digunakan luar talian'), findsNothing);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme?.scaffoldBackgroundColor, AppColors.cream);
    expect(materialApp.theme?.colorScheme.primary, AppColors.navy);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens the Utama information dialog', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    await tester.tap(find.byTooltip('Tentang Notaku Sejarah'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Tentang Notaku Sejarah'), findsWidgets);
    expect(find.text('Tutup'), findsOneWidget);

    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('switches between feature screens on compact navigation', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    await tester.tap(navigationLabel('Nota'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('screen-nota')), findsOneWidget);
    expect(find.text('Nota Sejarah'), findsOneWidget);

    await tester.tap(navigationLabel('Kuiz'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('screen-kuiz')), findsOneWidget);
    expect(find.text('Uji kefahaman anda'), findsOneWidget);

    await tester.tap(navigationLabel('Rekod'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('screen-rekod')), findsOneWidget);
    expect(find.text('Rekod pembelajaran'), findsOneWidget);
  });

  testWidgets('Utama quick actions open their destinations', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    await tester.ensureVisible(
      find.byKey(const ValueKey('quick-action-nota')),
    );
    await tester.tap(find.byKey(const ValueKey('quick-action-nota')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('screen-nota')), findsOneWidget);

    await tester.tap(navigationLabel('Utama'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey('quick-action-kuiz')),
    );
    await tester.tap(find.byKey(const ValueKey('quick-action-kuiz')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('screen-kuiz')), findsOneWidget);

    await tester.tap(navigationLabel('Utama'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey('quick-action-rekod')),
    );
    await tester.tap(find.byKey(const ValueKey('quick-action-rekod')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('screen-rekod')), findsOneWidget);
  });

  testWidgets('empty state actions open Nota and Kuiz', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    await tester.ensureVisible(find.text('Mula dengan Nota'));
    await tester.tap(find.text('Mula dengan Nota'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('screen-nota')), findsOneWidget);

    await tester.tap(navigationLabel('Utama'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Mulakan Kuiz'));
    await tester.tap(find.text('Mulakan Kuiz'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('screen-kuiz')), findsOneWidget);
  });

  testWidgets('keeps the selected destination when the layout changes', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    await tester.tap(navigationLabel('Kuiz'));
    await tester.pumpAndSettle();

    tester.view.physicalSize = const Size(700, 1024);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('screen-kuiz')), findsOneWidget);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);

    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.selectedIndex, 2);
    expect(rail.extended, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports phone landscape without layout exceptions', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(844, 390);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byKey(const ValueKey('section-pintasan')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports tablet portrait and wider Utama content', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(700, 1024);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));

    expect(find.byType(NavigationBar), findsNothing);
    expect(find.bySemanticsLabel('Motif warisan dan sejarah'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('latest-performance-empty')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('recent-activity-empty')),
      findsOneWidget,
    );
    expect(rail.selectedIndex, 0);
    expect(rail.extended, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supports tablet landscape with extended navigation', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1024, 700);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());
    await tester.pumpAndSettle();

    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));

    expect(rail.extended, isTrue);
    expect(
      find.byKey(const ValueKey('section-sambung-belajar')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('section-aktiviti-terkini')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses compact navigation immediately below 600px', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(599, 900);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('uses medium rail at exactly 600px', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(600, 900);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.extended, isFalse);
  });

  testWidgets('uses medium rail immediately below 900px', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(899, 900);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.extended, isFalse);
  });

  testWidgets('uses extended rail at exactly 900px', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(900, 900);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));

    expect(find.bySemanticsLabel('Motif warisan dan sejarah'), findsOneWidget);
    expect(rail.selectedIndex, 0);
    expect(rail.extended, isTrue);
    expect(tester.takeException(), isNull);
  });
}
