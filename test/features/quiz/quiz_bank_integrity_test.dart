import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/features/notes/data/note_repository.dart';
import 'package:notaku_sejarah_v2/features/quiz/data/quiz_manifest.dart';
import 'package:notaku_sejarah_v2/features/quiz/data/quiz_repository.dart';
import 'package:notaku_sejarah_v2/features/quiz/domain/quiz_session.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('all 46 chapters contain 40 valid unique questions', () async {
    final forms = const LocalNoteRepository().getForms();
    final repository = QuizRepository();
    final globalIds = <String>{};
    final keys = <String>{};
    for (final form in forms) {
      for (final chapter in form.chapters) {
        final key = quizChapterKey(form.level, chapter.number);
        keys.add(key);
        expect(quizAssetManifest.containsKey(key), isTrue, reason: key);
        final questions = await repository.getQuestions(
          form: form.level,
          chapter: chapter.number,
        );
        expect(questions, hasLength(40), reason: key);
        expect(questions.map((q) => q.prompt).toSet(), hasLength(40));
        final answers = <String, int>{};
        for (final question in questions) {
          expect(globalIds.add(question.id), isTrue, reason: question.id);
          expect(question.options, hasLength(4));
          expect(question.options.map((o) => o.text).toSet(), hasLength(4));
          expect(question.explanation.trim(), isNotEmpty);
          expect(question.correctOption.text.trim(), isNotEmpty);
          answers.update(
            question.correctOptionId,
            (count) => count + 1,
            ifAbsent: () => 1,
          );
        }
        expect(answers, {'A': 10, 'B': 10, 'C': 10, 'D': 10});
        final session = QuizSession(questions);
        expect(session.questions.map((q) => q.id).toSet(), hasLength(15));
        for (var i = 0; i < session.questions.length; i++) {
          session.answer(i, session.questions[i].correctOptionId);
        }
        session.submit();
        expect(session.score, 15);
      }
    }
    expect(keys, hasLength(46));
    expect(quizAssetManifest.keys.toSet(), keys);
    expect(globalIds, hasLength(1840));
  });
}
