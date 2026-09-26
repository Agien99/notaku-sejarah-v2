import '../../quiz/domain/quiz_session.dart';

/// A self-contained snapshot: later question-bank edits cannot alter history.
class RecordedAnswer {
  const RecordedAnswer({
    required this.questionId,
    required this.prompt,
    required this.selectedAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    required this.explanation,
  });

  final String questionId;
  final String prompt;
  final String selectedAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final String explanation;

  Map<String, Object?> toJson() => {
    'questionId': questionId,
    'prompt': prompt,
    'selectedAnswer': selectedAnswer,
    'correctAnswer': correctAnswer,
    'isCorrect': isCorrect,
    'explanation': explanation,
  };

  factory RecordedAnswer.fromJson(Map<String, dynamic> json) => RecordedAnswer(
    questionId: json['questionId'] as String,
    prompt: json['prompt'] as String,
    selectedAnswer: json['selectedAnswer'] as String,
    correctAnswer: json['correctAnswer'] as String,
    isCorrect: json['isCorrect'] as bool,
    explanation: json['explanation'] as String,
  );
}

class QuizRecord {
  QuizRecord({
    required this.id,
    required this.form,
    required this.chapter,
    required this.title,
    required this.startedAt,
    required this.completedAt,
    required List<RecordedAnswer> answers,
  }) : answers = List.unmodifiable(answers) {
    if (id.isEmpty || answers.isEmpty || completedAt.isBefore(startedAt)) {
      throw ArgumentError('Invalid completed quiz record.');
    }
  }

  final String id;
  final int form;
  final int chapter;
  final String title;
  final DateTime startedAt;
  final DateTime completedAt;
  final List<RecordedAnswer> answers;
  int get score => answers.where((answer) => answer.isCorrect).length;
  int get total => answers.length;
  double get percentage => score * 100 / total;
  Duration get duration => completedAt.difference(startedAt);

  factory QuizRecord.fromSession({
    required String id,
    required int form,
    required int chapter,
    required String title,
    required DateTime startedAt,
    required DateTime completedAt,
    required QuizSession session,
  }) {
    if (!session.isSubmitted) throw StateError('Submit before saving.');
    return QuizRecord(
      id: id,
      form: form,
      chapter: chapter,
      title: title,
      startedAt: startedAt,
      completedAt: completedAt,
      answers: session.questions.map((question) => RecordedAnswer(
        questionId: question.id,
        prompt: question.prompt,
        selectedAnswer: question.options.singleWhere(
          (option) => option.id == session.answerFor(question),
        ).text,
        correctAnswer: question.correctOption.text,
        isCorrect: session.answerFor(question) == question.correctOptionId,
        explanation: question.explanation,
      )).toList(),
    );
  }

  Map<String, Object?> toJson() => {
    'schemaVersion': 1,
    'id': id,
    'form': form,
    'chapter': chapter,
    'title': title,
    'startedAt': startedAt.toUtc().toIso8601String(),
    'completedAt': completedAt.toUtc().toIso8601String(),
    'answers': answers.map((answer) => answer.toJson()).toList(),
  };

  factory QuizRecord.fromJson(Map<String, dynamic> json) {
    if (json['schemaVersion'] != 1) {
      throw const FormatException('Unsupported record version.');
    }
    return QuizRecord(
      id: json['id'] as String,
      form: json['form'] as int,
      chapter: json['chapter'] as int,
      title: json['title'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: DateTime.parse(json['completedAt'] as String),
      answers: (json['answers'] as List<dynamic>).map((answer) =>
        RecordedAnswer.fromJson(Map<String, dynamic>.from(answer as Map)),
      ).toList(),
    );
  }
}

class RecordStatistics {
  RecordStatistics(Iterable<QuizRecord> records) : records = List.of(records);
  final List<QuizRecord> records;
  int get count => records.length;
  double get average => count == 0 ? 0 :
      records.fold<double>(0, (sum, record) => sum + record.percentage) / count;
  double get best => records.fold<double>(0, (best, record) =>
      record.percentage > best ? record.percentage : best);
  int get chapters => records.map((r) => '${r.form}:${r.chapter}').toSet().length;
}
