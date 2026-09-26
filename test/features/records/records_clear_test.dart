import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/features/records/data/records_repository.dart';
import 'package:notaku_sejarah_v2/features/records/domain/quiz_record.dart';
import 'package:sembast/sembast_io.dart';

QuizRecord _sampleRecord() => QuizRecord(
  id: 'clear-test',
  form: 1,
  chapter: 1,
  title: 'Mengenali Sejarah',
  startedAt: DateTime.utc(2026, 9, 26, 10),
  completedAt: DateTime.utc(2026, 9, 26, 10, 2),
  answers: const [
    RecordedAnswer(
      questionId: 'q1',
      prompt: 'Soalan 1',
      selectedAnswer: 'Betul',
      correctAnswer: 'Betul',
      isCorrect: true,
      explanation: 'Penerangan',
    ),
  ],
);

void main() {
  test('clear removes all stored quiz records', () async {
    final directory = await Directory.systemTemp.createTemp(
      'notaku-records-clear-',
    );
    final path = '${directory.path}/records.db';
    final repository = RecordsRepository(
      openDatabase: () => databaseFactoryIo.openDatabase(path),
    );

    try {
      await repository.save(_sampleRecord());
      expect(repository.records, hasLength(1));

      await repository.clear();
      expect(repository.records, isEmpty);

      await repository.load();
      expect(repository.records, isEmpty);
      expect(repository.error, isNull);
    } finally {
      await repository.close();
      repository.dispose();
      await directory.delete(recursive: true);
    }
  });
}
