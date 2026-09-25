import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/models/quiz_question.dart';
import '../domain/quiz_data_exception.dart';
import 'quiz_manifest.dart';

class QuizRepository {
  QuizRepository({AssetBundle? assetBundle})
    : _assetBundle = assetBundle ?? rootBundle;

  final AssetBundle _assetBundle;

  Future<List<QuizQuestion>> getQuestions({
    required int form,
    required int chapter,
  }) async {
    final assetPath = quizAssetManifest[quizChapterKey(form, chapter)];
    if (assetPath == null) return const <QuizQuestion>[];

    final decoded = jsonDecode(await _assetBundle.loadString(assetPath));
    if (decoded is! Map<String, dynamic>) {
      throw const QuizDataException('Quiz asset root must be a JSON object.');
    }

    final rawQuestions = decoded['questions'];
    if (rawQuestions is! List<dynamic>) {
      throw QuizDataException('$assetPath must contain a questions array.');
    }

    final questions = rawQuestions
        .map((item) => QuizQuestion.fromJson(item as Map<String, dynamic>))
        .toList(growable: false);

    validateQuestions(questions, expectedForm: form, expectedChapter: chapter);
    return questions;
  }

  static void validateQuestions(
    List<QuizQuestion> questions, {
    int? expectedForm,
    int? expectedChapter,
  }) {
    final ids = <String>{};

    for (final question in questions) {
      if (question.id.trim().isEmpty || !ids.add(question.id)) {
        throw QuizDataException(
          'Question IDs must be non-empty and unique: ${question.id}',
        );
      }
      if (expectedForm != null && question.form != expectedForm) {
        throw QuizDataException(
          '${question.id} belongs to form ${question.form}, expected $expectedForm.',
        );
      }
      if (expectedChapter != null && question.chapter != expectedChapter) {
        throw QuizDataException(
          '${question.id} belongs to chapter ${question.chapter}, expected $expectedChapter.',
        );
      }
      if (question.prompt.trim().isEmpty ||
          question.explanation.trim().isEmpty) {
        throw QuizDataException(
          '${question.id} requires a prompt and explanation.',
        );
      }
      if (question.options.length < 2) {
        throw QuizDataException(
          '${question.id} requires at least two options.',
        );
      }

      final optionIds = <String>{};
      for (final option in question.options) {
        if (option.id.trim().isEmpty ||
            option.text.trim().isEmpty ||
            !optionIds.add(option.id)) {
          throw QuizDataException(
            '${question.id} has invalid or duplicate options.',
          );
        }
      }

      if (!optionIds.contains(question.correctOptionId)) {
        throw QuizDataException(
          '${question.id} has an invalid correctOptionId.',
        );
      }
    }
  }
}
