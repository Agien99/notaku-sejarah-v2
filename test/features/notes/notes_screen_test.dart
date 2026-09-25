import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/features/notes/data/note_content_repository.dart';
import 'package:notaku_sejarah_v2/features/notes/data/note_seed_data.dart';
import 'package:notaku_sejarah_v2/features/notes/domain/models/note_chapter.dart';
import 'package:notaku_sejarah_v2/features/notes/domain/models/note_chapter_content.dart';
import 'package:notaku_sejarah_v2/features/notes/domain/models/note_form.dart';
import 'package:notaku_sejarah_v2/features/notes/presentation/chapter_list_screen.dart';
import 'package:notaku_sejarah_v2/features/notes/presentation/note_reader_screen.dart';
import 'package:notaku_sejarah_v2/features/notes/presentation/notes_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  test('contains all 46 KSSM 2026 chapters', () {
    expect(noteForms.length, 5);
    expect(
      noteForms.fold<int>(0, (total, form) => total + form.chapters.length),
      46,
    );

    for (final form in noteForms) {
      expect(form.isAvailable, isTrue);
      expect(form.curriculum.code, 'KSSM');
      expect(form.curriculum.effectiveYear, 2026);
      expect(form.curriculum.contentVersion, '2026.1');
    }
  });

  test('all 46 native note assets parse and match their metadata', () async {
    const repository = AssetNoteContentRepository();

    for (final form in noteForms) {
      for (final chapter in form.chapters) {
        final content = await repository.load(chapter);

        expect(content.form, form.level);
        expect(content.chapter, chapter.number);
        expect(content.title, chapter.title);
        expect(content.curriculum, form.curriculum.code);
        expect(content.contentVersion, form.curriculum.contentVersion);
        expect(content.overview, isNotEmpty);
        expect(content.sections, isNotEmpty);
        expect(content.keyFacts, isNotEmpty);
        expect(content.summary, isNotEmpty);
      }
    }
  });

  testWidgets('shows Tingkatan 1 to 5 as available', (tester) async {
    await pumpNotes(tester);

    expect(find.text('Nota Sejarah'), findsOneWidget);
    expect(
      find.text('KSSM · Kandungan disemak 25 September 2026'),
      findsOneWidget,
    );
    expect(find.text('Tingkatan 1'), findsOneWidget);
    expect(find.text('Tingkatan 2'), findsOneWidget);
    expect(find.text('Tingkatan 3'), findsOneWidget);
    expect(find.text('Tingkatan 4'), findsOneWidget);
    expect(find.text('Tingkatan 5'), findsOneWidget);
    expect(find.text('Tersedia'), findsNWidgets(5));
    expect(find.text('Akan Datang'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens Tingkatan 4 chapter list on compact layout', (
    tester,
  ) async {
    await pumpNotes(tester);

    await tester.ensureVisible(find.byKey(const ValueKey('note-form-4')));
    await tester.tap(find.byKey(const ValueKey('note-form-4')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('chapter-list-4')), findsOneWidget);
    expect(find.text('Warisan Negara Bangsa'), findsOneWidget);
    expect(find.text('Pemasyhuran Kemerdekaan'), findsOneWidget);
    expect(find.text('Pilih salah satu daripada 10 bab.'), findsOneWidget);
    expect(find.text('KSSM · Sesi 2026'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens Tingkatan 5 chapter list on compact layout', (
    tester,
  ) async {
    await pumpNotes(tester);

    await tester.ensureVisible(find.byKey(const ValueKey('note-form-5')));
    await tester.tap(find.byKey(const ValueKey('note-form-5')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('chapter-list-5')), findsOneWidget);
    expect(find.text('Kedaulatan Negara'), findsOneWidget);
    expect(
      find.text('Kecemerlangan Malaysia di Persada Dunia'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('expanded layout switches from Tingkatan 1 to Tingkatan 5', (
    tester,
  ) async {
    await pumpNotes(tester, size: const Size(1100, 900));

    expect(find.byKey(const ValueKey('chapter-list-1')), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('note-form-5')));
    await tester.tap(find.byKey(const ValueKey('note-form-5')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('chapter-list-1')), findsNothing);
    expect(find.byKey(const ValueKey('chapter-list-5')), findsOneWidget);
    expect(find.text('Kedaulatan Negara'), findsOneWidget);
    expect(
      find.text('Kecemerlangan Malaysia di Persada Dunia'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('chapter selection returns the native content asset', (
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

    expect(selectedChapter?.contentAsset, 'assets/notes/kssm_2026/t1_b08.json');
    expect(tester.takeException(), isNull);
  });

  testWidgets('native reader renders structured revision content', (
    tester,
  ) async {
    await setSurface(tester);
    final form = noteForms[4];
    final chapter = form.chapters[0];
    final repository = _StaticRepository(_sampleContent(form, chapter));

    await tester.pumpWidget(
      MaterialApp(
        home: NoteReaderScreen(
          form: form,
          chapter: chapter,
          repository: repository,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('native-note-reader')), findsOneWidget);
    expect(find.text('Gambaran Keseluruhan'), findsOneWidget);
    expect(find.text('Kata Kunci'), findsOneWidget);
    expect(find.byKey(const ValueKey('note-section-1.1')), findsOneWidget);
    expect(find.byKey(const ValueKey('note-key-facts')), findsOneWidget);
    expect(find.byKey(const ValueKey('note-summary')), findsOneWidget);
    expect(
      find.text('Kandungan KSSM · Versi 2026.1 · Semakan 2026-09-25'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('native reader exposes loading state', (tester) async {
    await setSurface(tester);
    final form = noteForms.first;
    final chapter = form.chapters.first;
    final completer = Completer<NoteChapterContent>();

    await tester.pumpWidget(
      MaterialApp(
        home: NoteReaderScreen(
          form: form,
          chapter: chapter,
          repository: _PendingRepository(completer.future),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('note-reader-loading')), findsOneWidget);

    completer.complete(_sampleContent(form, chapter));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('native-note-reader')), findsOneWidget);
  });

  testWidgets('native reader retries after a load error', (tester) async {
    await setSurface(tester);
    final form = noteForms.first;
    final chapter = form.chapters.first;
    final repository = _RetryRepository(_sampleContent(form, chapter));

    await tester.pumpWidget(
      MaterialApp(
        home: NoteReaderScreen(
          form: form,
          chapter: chapter,
          repository: repository,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('note-reader-error')), findsOneWidget);
    expect(repository.calls, 1);

    await tester.tap(find.text('Cuba semula'));
    await tester.pumpAndSettle();

    expect(repository.calls, 2);
    expect(find.byKey(const ValueKey('native-note-reader')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'native reader uses expanded table of contents on tablet landscape',
    (tester) async {
      await setSurface(tester, size: const Size(1180, 820));
      final form = noteForms[3];
      final chapter = form.chapters[8];

      await tester.pumpWidget(
        MaterialApp(
          home: NoteReaderScreen(
            form: form,
            chapter: chapter,
            repository: _StaticRepository(_sampleContent(form, chapter)),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('native-note-reader-expanded')),
        findsOneWidget,
      );
      expect(find.text('Kandungan Bab'), findsOneWidget);
      expect(find.byKey(const ValueKey('native-note-reader')), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

NoteChapterContent _sampleContent(NoteForm form, NoteChapter chapter) {
  return NoteChapterContent(
    curriculum: form.curriculum.code,
    contentVersion: form.curriculum.contentVersion,
    reviewedOn: '2026-09-25',
    form: form.level,
    chapter: chapter.number,
    title: chapter.title,
    overview: 'Gambaran ringkas untuk ujian reader.',
    keywords: const ['kata kunci'],
    sections: const [
      NoteSection(
        id: '1.1',
        title: 'Subtopik Ujian',
        intro: 'Pengenalan subtopik.',
        points: ['Fakta pertama.', 'Fakta kedua.'],
      ),
    ],
    keyFacts: const ['Fakta penting untuk diingati.'],
    summary: const ['Ringkasan bab untuk ulang kaji.'],
  );
}

class _StaticRepository implements NoteContentRepository {
  const _StaticRepository(this.content);

  final NoteChapterContent content;

  @override
  Future<NoteChapterContent> load(NoteChapter chapter) async => content;
}

class _PendingRepository implements NoteContentRepository {
  const _PendingRepository(this.future);

  final Future<NoteChapterContent> future;

  @override
  Future<NoteChapterContent> load(NoteChapter chapter) => future;
}

class _RetryRepository implements NoteContentRepository {
  _RetryRepository(this.content);

  final NoteChapterContent content;
  int calls = 0;

  @override
  Future<NoteChapterContent> load(NoteChapter chapter) async {
    calls++;

    if (calls == 1) {
      throw StateError('Simulated first-load failure');
    }

    return content;
  }
}
