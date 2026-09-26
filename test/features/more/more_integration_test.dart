import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/app/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _pumpUi(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 350));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('opens Lagi and shows settings about and credits', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());
    await _pumpUi(tester);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Lagi'),
      ),
    );
    await _pumpUi(tester);

    expect(find.byKey(const ValueKey('screen-lagi')), findsOneWidget);
    expect(find.text('Tetapan'), findsOneWidget);
    expect(find.text('Tentang'), findsOneWidget);
    expect(find.text('Kredit'), findsOneWidget);
    expect(find.text('Eurgien Anak Anthony'), findsOneWidget);
    expect(find.text('Flutter & Dart'), findsOneWidget);
    expect(find.text('0.1.0 (Build 1)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('changing text size updates the app text scaler', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const NotakuSejarahApp());
    await _pumpUi(tester);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Lagi'),
      ),
    );
    await _pumpUi(tester);

    await tester.ensureVisible(find.text('Besar'));
    await tester.tap(find.text('Besar'));
    await _pumpUi(tester);

    final mediaQuery = tester.widget<MediaQuery>(find.byType(MediaQuery).last);
    expect(mediaQuery.data.textScaler.scale(16), closeTo(18.4, 0.001));
  });
}
