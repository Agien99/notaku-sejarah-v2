import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/features/quiz/data/quiz_repository.dart';
import 'package:notaku_sejarah_v2/features/quiz/domain/models/quiz_option.dart';
import 'package:notaku_sejarah_v2/features/quiz/domain/models/quiz_question.dart';
import 'package:notaku_sejarah_v2/features/quiz/domain/quiz_data_exception.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuizRepository', () {
    test('loads and validates a chapter question bank', () async {
      final repository = QuizRepository(
        assetBundle: _MemoryAssetBundle({
          'assets/quiz/kssm_2026/t1_b01.json': _validJson,
        }),
      );

      final questions = await repository.getQuestions(form: 1, chapter: 1);

      expect(questions, hasLength(1));
      expect(questions.single.id, 't1-b01-q001');
      expect(questions.single.correctOption.text, 'Jawapan A');
    });

    test('returns empty list for an unregistered chapter', () async {
      final repository = QuizRepository(
        assetBundle: _MemoryAssetBundle(const <String, String>{}),
      );

      expect(await repository.getQuestions(form: 6, chapter: 1), isEmpty);
    });

    test('rejects duplicate question IDs', () {
      const question = QuizQuestion(
        id: 'duplicate',
        form: 1,
        chapter: 1,
        prompt: 'Soalan',
        options: [
          QuizOption(id: 'A', text: 'A'),
          QuizOption(id: 'B', text: 'B'),
        ],
        correctOptionId: 'A',
        explanation: 'Penerangan',
      );

      expect(
        () => QuizRepository.validateQuestions([question, question]),
        throwsA(isA<QuizDataException>()),
      );
    });

    test('rejects an answer key absent from options', () {
      const question = QuizQuestion(
        id: 'q1',
        form: 1,
        chapter: 1,
        prompt: 'Soalan',
        options: [
          QuizOption(id: 'A', text: 'A'),
          QuizOption(id: 'B', text: 'B'),
        ],
        correctOptionId: 'C',
        explanation: 'Penerangan',
      );

      expect(
        () => QuizRepository.validateQuestions([question]),
        throwsA(isA<QuizDataException>()),
      );
    });
  });
}

class _MemoryAssetBundle extends CachingAssetBundle {
  _MemoryAssetBundle(this.assets);

  final Map<String, String> assets;

  @override
  Future<ByteData> load(String key) async {
    final value = assets[key];
    if (value == null) throw StateError('Missing test asset: $key');
    return ByteData.sublistView(Uint8List.fromList(value.codeUnits));
  }
}

const _validJson = '''
{
  "questions": [
    {
      "id": "t1-b01-q001",
      "form": 1,
      "chapter": 1,
      "prompt": "Soalan ujian",
      "options": [
        {"id": "A", "text": "Jawapan A"},
        {"id": "B", "text": "Jawapan B"}
      ],
      "correctOptionId": "A",
      "explanation": "Penerangan",
      "tags": ["ujian"]
    }
  ]
}
''';
