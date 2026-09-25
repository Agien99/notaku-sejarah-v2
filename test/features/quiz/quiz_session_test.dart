import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/features/quiz/data/quiz_repository.dart';
import 'package:notaku_sejarah_v2/features/quiz/domain/quiz_session.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('real bank supports 15 unique questions without mutating source data', () async {
    final bank = await QuizRepository().getQuestions(form: 1, chapter: 1);
    final originalIds = bank.map((q) => q.id).toList();
    final originalOptions = bank.map((q) => q.options.map((o) => o.id).toList()).toList();
    final session = QuizSession(bank, random: Random(1));
    expect(session.questions, hasLength(15));
    expect(session.questions.map((q) => q.id).toSet(), hasLength(15));
    expect(bank.map((q) => q.id), originalIds);
    expect(bank.map((q) => q.options.map((o) => o.id).toList()), originalOptions);
    expect(session.questions.map((q) => q.id), isNot(originalIds.take(15).toList()));
    expect(session.questions.any((q) => q.options.map((o) => o.id).join() != 'ABCD'), isTrue);
    for (final question in session.questions) {
      expect(question.correctOption.text, bank.singleWhere((q) => q.id == question.id).correctOption.text);
    }
    final next = QuizSession(bank, random: Random(2));
    expect(next.questions.map((q) => q.id), isNot(session.questions.map((q) => q.id).toList()));
  });

  test('scores stable IDs, allows edits, locks submitted answers and resets retries', () async {
    final bank = await QuizRepository().getQuestions(form: 1, chapter: 1);
    final session = QuizSession(bank, random: Random(3));
    expect(session.submit, throwsStateError);
    expect(() => session.score, throwsStateError);
    expect(() => session.answer(0, 'invalid'), throwsArgumentError);
    for (var i = 0; i < session.questions.length; i++) {
      session.answer(i, session.questions[i].correctOptionId);
    }
    final first = session.questions.first;
    session.answer(0, first.options.firstWhere((o) => o.id != first.correctOptionId).id);
    expect(session.answeredCount, 15);
    session.submit();
    expect(session.score, 14);
    expect(session.percentage, 93);
    expect(() => session.answer(0, first.correctOptionId), throwsStateError);
    session.submit();
    expect(session.score, 14);
    final retry = QuizSession(bank);
    expect(retry.answeredCount, 0);
    expect(retry.isSubmitted, isFalse);
  });

  test('rejects insufficient and duplicate banks', () async {
    final bank = await QuizRepository().getQuestions(form: 1, chapter: 1);
    expect(() => QuizSession(bank.take(4).toList()), throwsArgumentError);
    expect(() => QuizSession(List.filled(15, bank.first)), throwsArgumentError);
  });
}
