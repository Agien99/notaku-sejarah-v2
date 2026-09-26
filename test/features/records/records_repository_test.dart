import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/features/records/data/records_repository.dart';
import 'package:notaku_sejarah_v2/features/records/domain/quiz_record.dart';
import 'package:sembast/sembast_io.dart';

QuizRecord sampleRecord(
  String id, {
  int form = 1,
  int chapter = 1,
  int score = 1,
  int total = 2,
  int day = 1,
}) => QuizRecord(
  id: id,
  form: form,
  chapter: chapter,
  title: 'Mengenali Sejarah',
  startedAt: DateTime.utc(2026, 9, day, 10),
  completedAt: DateTime.utc(2026, 9, day, 10, 2),
  answers: List.generate(
    total,
    (index) => RecordedAnswer(
      questionId: 'q$index',
      prompt: 'Soalan $index',
      selectedAnswer: index < score ? 'Betul' : 'Salah',
      correctAnswer: 'Betul',
      isCorrect: index < score,
      explanation: 'Penerangan $index',
    ),
  ),
);

void main() {
  test(
    'disk reopen preserves answer snapshots; repeated save is idempotent',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'notaku-records-',
      );
      final path = '${directory.path}/records.db';
      RecordsRepository create() => RecordsRepository(
        openDatabase: () => databaseFactoryIo.openDatabase(path, version: 1),
      );
      final first = create();
      final record = sampleRecord('same-attempt');
      await first.save(record);
      await first.save(record);
      await first.close();
      first.dispose();
      final reopened = create();
      try {
        await reopened.load();
        expect(reopened.error, isNull);
        expect(reopened.records, hasLength(1));
        final stored = reopened.records.single;
        expect(stored.toJson(), record.toJson());
        expect(stored.duration, const Duration(minutes: 2));
        await reopened.save(sampleRecord('next', day: 2));
        expect(reopened.records.first.id, 'next');
      } finally {
        await reopened.close();
        reopened.dispose();
        await directory.delete(recursive: true);
      }
    },
  );

  test('statistics average unrounded percentages and distinguish same-number chapters', () {
    final stats = RecordStatistics([
      sampleRecord('a', score: 1, total: 3),
      sampleRecord('b', form: 2, score: 3, total: 3),
      sampleRecord('c', score: 0, total: 2),
    ]);
    expect(stats.count, 3);
    expect(stats.best, 100);
    expect(stats.average, closeTo(44.444444, 0.00001));
    expect(stats.chapters, 2);
    expect(RecordStatistics([]).average, 0);
    expect(RecordStatistics([]).best, 0);
  });

  test('database open failure is visible and retry can recover', () async {
    var fail = true;
    final directory = await Directory.systemTemp.createTemp('notaku-retry-');
    final repository = RecordsRepository(
      openDatabase: () async {
        if (fail) throw StateError('Storage unavailable');
        return databaseFactoryIo.openDatabase('${directory.path}/records.db');
      },
    );
    try {
      await repository.load();
      expect(repository.error, isNotNull);
      expect(repository.loaded, isFalse);
      await expectLater(
        repository.save(sampleRecord('retry')),
        throwsStateError,
      );
      fail = false;
      await repository.save(sampleRecord('retry'));
      expect(repository.error, isNull);
      expect(repository.records, hasLength(1));
    } finally {
      await repository.close();
      repository.dispose();
      await directory.delete(recursive: true);
    }
  });
}
