import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/features/more/application/app_settings_controller.dart';
import 'package:notaku_sejarah_v2/features/more/presentation/more_screen.dart';
import 'package:notaku_sejarah_v2/features/records/data/records_repository.dart';
import 'package:notaku_sejarah_v2/features/records/domain/quiz_record.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:shared_preferences/shared_preferences.dart';

QuizRecord _sampleRecord() => QuizRecord(
  id: 'more-screen-reset',
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
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('requires confirmation before clearing quiz records', (
    tester,
  ) async {
    final database = await databaseFactoryMemory.openDatabase(
      'more-screen-reset-test',
    );
    final recordsRepository = RecordsRepository(
      openDatabase: () async => database,
    );
    final settingsController = AppSettingsController();

    await recordsRepository.save(_sampleRecord());

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: MoreScreen(
              settingsController: settingsController,
              recordsRepository: recordsRepository,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final clearButton = find.byKey(const ValueKey('clear-records-button'));
    await tester.ensureVisible(clearButton);
    await tester.tap(clearButton);
    await tester.pumpAndSettle();

    expect(find.text('Padam semua rekod kuiz?'), findsOneWidget);
    expect(recordsRepository.records, hasLength(1));

    await tester.tap(find.text('Padam rekod'));
    await tester.pumpAndSettle();

    expect(recordsRepository.records, isEmpty);
    expect(find.text('Semua rekod kuiz telah dipadam.'), findsOneWidget);

    settingsController.dispose();
    await recordsRepository.close();
    recordsRepository.dispose();
  });
}
