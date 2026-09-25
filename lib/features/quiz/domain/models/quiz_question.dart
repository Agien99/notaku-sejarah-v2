import 'quiz_option.dart';

class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.form,
    required this.chapter,
    required this.prompt,
    required this.options,
    required this.correctOptionId,
    required this.explanation,
    this.tags = const <String>[],
  });

  final String id;
  final int form;
  final int chapter;
  final String prompt;
  final List<QuizOption> options;
  final String correctOptionId;
  final String explanation;
  final List<String> tags;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      form: json['form'] as int,
      chapter: json['chapter'] as int,
      prompt: json['prompt'] as String,
      options: (json['options'] as List<dynamic>)
          .map((item) => QuizOption.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      correctOptionId: json['correctOptionId'] as String,
      explanation: json['explanation'] as String,
      tags: (json['tags'] as List<dynamic>? ?? const <dynamic>[]).cast<String>(),
    );
  }

  QuizOption get correctOption => options.singleWhere(
    (option) => option.id == correctOptionId,
  );
}
