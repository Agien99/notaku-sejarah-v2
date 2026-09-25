import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/features/notes/presentation/notes_screen.dart';

void main() {
  Future<void> pumpNotes(
    WidgetTester tester, {
    Size size = const Size(390, 844),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SafeArea(child: SingleChildScrollView(child: NotesScreen())),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows available and upcoming Tingkatan', (tester) async {
    await pumpNotes(tester);

    expect(find.text('Nota Sejarah'), findsOneWidget);
    expect(find.text('Tingkatan 1'), findsOneWidget);
    expect(find.text('Tingkatan 2'), findsOneWidget);
    expect(find.text('Tingkatan 3'), findsOneWidget);
    expect(find.text('Tingkatan 4'), findsOneWidget);
    expect(find.text('Tingkatan 5'), findsOneWidget);
    expect(find.text('Tersedia'), findsNWidgets(3));
    expect(find.text('Akan Datang'), findsNWidgets(2));
  });

  testWidgets('opens chapter list for an available form on compact layout', (
    tester,
  ) async {
    await pumpNotes(tester);

    await tester.ensureVisible(find.byKey(const ValueKey('note-form-1')));
    await tester.tap(find.byKey(const ValueKey('note-form-1')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('chapter-list-1')), findsOneWidget);
    expect(find.text('Mengenali Sejarah'), findsOneWidget);
    expect(find.text('Tamadun Islam dan Sumbangannya'), findsOneWidget);
    expect(find.text('8 bab'), findsNothing);
    expect(find.text('Pilih salah satu daripada 8 bab.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('does not open unavailable Tingkatan', (tester) async {
    await pumpNotes(tester);

    await tester.ensureVisible(find.byKey(const ValueKey('note-form-4')));
    await tester.tap(find.byKey(const ValueKey('note-form-4')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('notes-content')), findsOneWidget);
    expect(find.byKey(const ValueKey('chapter-list-4')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('uses master detail and switches chapters on expanded layout', (
    tester,
  ) async {
    await pumpNotes(tester, size: const Size(1100, 900));

    expect(find.byKey(const ValueKey('chapter-list-1')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('note-form-2')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('chapter-list-1')), findsNothing);
    expect(find.byKey(const ValueKey('chapter-list-2')), findsOneWidget);
    expect(find.text('Kerajaan Alam Melayu'), findsOneWidget);
    expect(find.text('Sarawak dan Sabah'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
