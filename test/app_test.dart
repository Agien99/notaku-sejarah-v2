import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/app/app.dart';
import 'package:notaku_sejarah_v2/core/theme/app_colors.dart';

void main() {
  testWidgets('renders the Phase 1.2 design-system foundation', (tester) async {
    await tester.pumpWidget(const NotakuSejarahApp());

    expect(find.text('NOTAKU SEJARAH'), findsOneWidget);
    expect(find.text('Design System Foundation'), findsOneWidget);
    expect(find.text('Navy'), findsOneWidget);
    expect(find.text('Gold'), findsOneWidget);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme?.scaffoldBackgroundColor, AppColors.cream);
    expect(materialApp.theme?.colorScheme.primary, AppColors.navy);
  });
}
