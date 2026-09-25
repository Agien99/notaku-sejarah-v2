import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/core/theme/app_theme.dart';
import 'package:notaku_sejarah_v2/features/quiz/data/quiz_repository.dart';
import 'package:notaku_sejarah_v2/features/quiz/domain/models/quiz_question.dart';
import 'package:notaku_sejarah_v2/features/quiz/presentation/quiz_attempt_screen.dart';
import 'package:notaku_sejarah_v2/features/quiz/presentation/quiz_screen.dart';

void main() {
  Future<void> openAttempt(
    WidgetTester tester, {
    QuizRepository? repository,
  }) async {
    final loadedRepository =
        repository ??
        _LoadedRepository(
          (await tester.runAsync(
            () => QuizRepository().getQuestions(form: 1, chapter: 1),
          ))!,
        );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => QuizAttemptScreen(
                    form: 1,
                    chapter: 1,
                    title: 'Mengenali Sejarah',
                    repository: loadedRepository,
                  ),
                ),
              ),
              child: const Text('Mula'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Mula'));
    await tester.pumpAndSettle();
  }

  Future<void> tapVisible(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets(
    'selects form and exposes all published chapters',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: SingleChildScrollView(child: QuizScreen()),
          ),
        ),
      );
      await tester.tap(find.text('Tingkatan 1'));
      await tester.pumpAndSettle();
      expect(find.text('Pilih bab'), findsOneWidget);
      expect(find.text('Mulakan kuiz'), findsWidgets);
      expect(find.text('Belum tersedia'), findsNothing);
      final available = tester.widget<ListTile>(
        find.ancestor(
          of: find.text('Mulakan kuiz').first,
          matching: find.byType(ListTile),
        ),
      );
      expect(available.onTap, isNotNull);
    },
  );

  testWidgets(
    'completes 15 questions, reviews answers and starts a fresh retry',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 844);
      addTearDown(tester.view.reset);
      await openAttempt(tester);
      expect(find.text('0/15 dijawab'), findsOneWidget);
      expect(
        tester
            .widget<FilledButton>(
              find.widgetWithText(FilledButton, 'Hantar jawapan'),
            )
            .onPressed,
        isNull,
      );
      for (var i = 0; i < 15; i++) {
        await tapVisible(tester, find.byKey(const ValueKey('answer-0')));
        if (i < 14) await tapVisible(tester, find.text('Seterusnya'));
      }
      await tapVisible(tester, find.text('Sebelumnya'));
      expect(
        tester
            .widget<Semantics>(
              find
                  .ancestor(
                    of: find.byKey(const ValueKey('answer-0')),
                    matching: find.byType(Semantics),
                  )
                  .first,
            )
            .properties
            .selected,
        isTrue,
      );
      await tapVisible(tester, find.text('Hantar jawapan'));
      await tester.tap(find.text('Semak dahulu'));
      await tester.pumpAndSettle();
      expect(find.text('Keputusan Kuiz'), findsNothing);
      await tapVisible(tester, find.text('Hantar jawapan'));
      await tester.tap(find.text('Hantar'));
      await tester.pumpAndSettle();
      expect(find.text('Keputusan Kuiz'), findsOneWidget);
      await tapVisible(tester, find.text('Semak jawapan'));
      expect(find.textContaining('Jawapan betul:'), findsNWidgets(15));
      expect(find.textContaining('Jawapan anda:'), findsNWidgets(15));
      await tapVisible(tester, find.text('Cuba semula'));
      expect(find.text('0/15 dijawab'), findsOneWidget);
      expect(find.text('Soalan 1 daripada 15'), findsOneWidget);
      expect(find.text('Keputusan Kuiz'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('system back asks before discarding an active attempt', (
    tester,
  ) async {
    await openAttempt(tester);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Keluar daripada kuiz?'), findsOneWidget);
    await tester.tap(find.text('Teruskan kuiz'));
    await tester.pumpAndSettle();
    expect(find.text('Soalan 1 daripada 15'), findsOneWidget);
    await tester.tap(find.byTooltip('Kembali'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keluar'));
    await tester.pumpAndSettle();
    expect(find.text('Mula'), findsOneWidget);
  });

  testWidgets('shows a retryable load error and rejects undersized banks', (
    tester,
  ) async {
    final repository = _UnavailableRepository();
    await openAttempt(tester, repository: repository);
    expect(
      find.text('Soalan tidak dapat dimuatkan. Sila cuba lagi.'),
      findsOneWidget,
    );
    repository.fail = false;
    await tester.tap(find.text('Cuba lagi'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Bank soalan belum mencukupi'), findsOneWidget);
    expect(find.text('Soalan 1 daripada 15'), findsNothing);
  });

  for (final size in [
    const Size(320, 568),
    const Size(844, 390),
    const Size(1024, 768),
  ]) {
    testWidgets('quiz scrolls without overflow at $size with larger text', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await openAttempt(tester);
      await tapVisible(tester, find.byKey(const ValueKey('answer-3')));
      await tapVisible(tester, find.text('Seterusnya'));
      expect(find.text('Soalan 2 daripada 15'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}

class _UnavailableRepository extends QuizRepository {
  bool fail = true;

  @override
  Future<List<QuizQuestion>> getQuestions({
    required int form,
    required int chapter,
  }) async {
    if (fail) throw StateError('Failed test asset');
    return [];
  }
}

class _LoadedRepository extends QuizRepository {
  _LoadedRepository(this.questions);
  final List<QuizQuestion> questions;

  @override
  Future<List<QuizQuestion>> getQuestions({
    required int form,
    required int chapter,
  }) async => questions;
}
