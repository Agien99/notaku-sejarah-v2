import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/app/app.dart';
import 'package:notaku_sejarah_v2/core/theme/app_colors.dart';

void main() {
  testWidgets('renders the responsive foundation on compact screens', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    expect(find.text('NOTAKU SEJARAH'), findsOneWidget);
    expect(find.text('Responsive Architecture'), findsOneWidget);
    expect(find.text('COMPACT · < 600'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme?.scaffoldBackgroundColor, AppColors.cream);
    expect(materialApp.theme?.colorScheme.primary, AppColors.navy);
  });

  testWidgets('uses navigation rail on medium screens', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(700, 1024);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    expect(find.text('MEDIUM · 600–899'), findsOneWidget);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('uses expanded layout on large tablets', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1100, 900);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());

    expect(find.text('EXPANDED · ≥ 900'), findsOneWidget);

    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.extended, isTrue);
  });
}
