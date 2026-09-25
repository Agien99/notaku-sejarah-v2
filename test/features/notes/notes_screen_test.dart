import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/features/notes/data/note_seed_data.dart';
import 'package:notaku_sejarah_v2/features/notes/domain/models/note_chapter.dart';
import 'package:notaku_sejarah_v2/features/notes/domain/models/note_form.dart';
import 'package:notaku_sejarah_v2/features/notes/presentation/chapter_list_screen.dart';
import 'package:notaku_sejarah_v2/features/notes/presentation/note_reader_screen.dart';
import 'package:notaku_sejarah_v2/features/notes/presentation/notes_screen.dart';

void main() {
  Future<void> setSurface(
    WidgetTester tester, {
    Size size = const Size(390, 844),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.reset);
  }

  Future<void> pumpNotes(
    WidgetTester tester, {
    Size size = const Size(390, 844),
  }) async {
    await setSurface(tester, size: size);

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
    expect(find.text('Muka surat 2'), findsOneWidget);
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

  testWidgets('chapter selection exposes mapped printed and PDF page', (
    tester,
  ) async {
    await setSurface(tester);

    NoteChapter? selectedChapter;

    await tester.pumpWidget(
      MaterialApp(
        home: ChapterListScreen(
          form: noteForms.first,
          onChapterSelected: (chapter) {
            selectedChapter = chapter;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const ValueKey('note-chapter-8')));
    await tester.tap(find.byKey(const ValueKey('note-chapter-8')));
    await tester.pump();

    expect(selectedChapter?.printedPage, 158);
    expect(selectedChapter?.initialPageNumber, 169);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reader opens requested chapter page with injected viewer', (
    tester,
  ) async {
    await setSurface(tester);
    final form = noteForms[1];
    final chapter = form.chapters[4];

    String? capturedAsset;
    int? capturedPage;

    await tester.pumpWidget(
      MaterialApp(
        home: NoteReaderScreen(
          form: form,
          chapter: chapter,
          viewerBuilder:
              (context, assetName, initialPageNumber, revision, onRetry) {
                capturedAsset = assetName;
                capturedPage = initialPageNumber;
                return const ColoredBox(
                  key: ValueKey('fake-note-viewer'),
                  color: Colors.white,
                );
              },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(capturedAsset, 'assets/notes/tingkatan_2.pdf');
    expect(capturedPage, 78);
    expect(find.byKey(const ValueKey('fake-note-viewer')), findsOneWidget);
    expect(find.text('Muka surat 70'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reader has explicit unavailable state', (tester) async {
    await setSurface(tester);

    const chapter = NoteChapter(
      number: 1,
      title: 'Kandungan Akan Datang',
      printedPage: 1,
      initialPageNumber: 1,
    );
    const form = NoteForm(
      level: 4,
      theme: 'Pembinaan Negara',
      isAvailable: false,
      chapters: [chapter],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: NoteReaderScreen(form: form, chapter: chapter),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('note-reader-unavailable')),
      findsOneWidget,
    );
    expect(find.text('Nota belum tersedia'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('reader stays stable on tablet landscape', (tester) async {
    await setSurface(tester, size: const Size(1180, 820));
    final form = noteForms[2];
    final chapter = form.chapters[7];

    await tester.pumpWidget(
      MaterialApp(
        home: NoteReaderScreen(
          form: form,
          chapter: chapter,
          viewerBuilder:
              (context, assetName, initialPageNumber, revision, onRetry) {
                return const ColoredBox(
                  key: ValueKey('fake-landscape-viewer'),
                  color: Colors.white,
                );
              },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('fake-landscape-viewer')), findsOneWidget);
    expect(find.text('Muka surat 198'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
