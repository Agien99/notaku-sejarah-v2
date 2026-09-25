import 'dart:math';

import 'models/quiz_option.dart';
import 'models/quiz_question.dart';

/// Owns one attempt. Repository data is never shuffled or edited in place.
class QuizSession {
  QuizSession(List<QuizQuestion> bank, {Random? random}) {
    if (bank.length < questionCount) {
      throw ArgumentError('At least $questionCount questions are required.');
    }
    if (bank.map((question) => question.id).toSet().length != bank.length) {
      throw ArgumentError('Question IDs must be unique.');
    }
    final generator = random ?? Random();
    final shuffled = List<QuizQuestion>.of(bank)..shuffle(generator);
    questions = List<QuizQuestion>.unmodifiable(
      shuffled.take(questionCount).map((question) {
        final options = List<QuizOption>.of(question.options)..shuffle(generator);
        return QuizQuestion(
          id: question.id,
          form: question.form,
          chapter: question.chapter,
          prompt: question.prompt,
          options: List<QuizOption>.unmodifiable(options),
          correctOptionId: question.correctOptionId,
          explanation: question.explanation,
          tags: List<String>.unmodifiable(question.tags),
        );
      }),
    );
  }

  static const questionCount = 15;
  late final List<QuizQuestion> questions;
  final Map<String, String> _answers = {};
  bool _submitted = false;

  bool get isSubmitted => _submitted;
  int get answeredCount => _answers.length;
  bool get isComplete => answeredCount == questions.length;
  String? answerFor(QuizQuestion question) => _answers[question.id];

  void answer(int index, String optionId) {
    if (_submitted) throw StateError('This attempt has been submitted.');
    final question = questions[index];
    if (!question.options.any((option) => option.id == optionId)) {
      throw ArgumentError.value(optionId, 'optionId');
    }
    _answers[question.id] = optionId;
  }

  void submit() {
    if (!isComplete) throw StateError('Answer every question before submitting.');
    _submitted = true;
  }

  int get score {
    if (!_submitted) throw StateError('Submit before reading the score.');
    return questions.where((q) => answerFor(q) == q.correctOptionId).length;
  }

  int get percentage => (score / questions.length * 100).round();
}
