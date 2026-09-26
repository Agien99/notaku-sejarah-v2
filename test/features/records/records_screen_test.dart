import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/app/app.dart';
import 'package:notaku_sejarah_v2/features/records/data/records_repository.dart';
import 'package:notaku_sejarah_v2/features/records/presentation/records_screen.dart';

import 'records_repository_test.dart' show sampleRecord;

void main() {
  for (final size in [
    const Size(320, 568),
    const Size(844, 390),
    const Size(1024, 768),
  ]) {
    testWidgets('records filter and detail work at $size with large text', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final repository = RecordsRepository.instance;
      await repository.save(sampleRecord('first'));
      await repository.save(sampleRecord('second', form: 2, day: 2));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: RecordsScreen(repository: repository),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ChoiceChip, 'Tingkatan 1'));
      await tester.pumpAndSettle();
      expect(find.textContaining('T2 • Bab'), findsNothing);
      final tile = find.text('T1 • Bab 1: Mengenali Sejarah');
      await tester.ensureVisible(tile);
      await tester.tap(tile);
      await tester.pumpAndSettle();
      expect(find.text('Butiran Percubaan'), findsOneWidget);
      expect(find.text('50% • 1/2 betul'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Jawapan anda: Salah'), 200);
      expect(find.text('Jawapan anda: Salah'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('empty records show guidance without invented statistics', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SingleChildScrollView(child: RecordsScreen())),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Belum ada rekod kuiz'), findsOneWidget);
    expect(find.text('0.0%'), findsNothing);
  });

  testWidgets('home updates when a completed record is saved', (tester) async {
    await tester.pumpWidget(const NotakuSejarahApp());
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('latest-performance-empty')),
      findsOneWidget,
    );
    await RecordsRepository.instance.save(sampleRecord('new-result'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('latest-performance-empty')),
      findsNothing,
    );
    expect(find.byKey(const ValueKey('recent-activity-empty')), findsNothing);
  });
}
