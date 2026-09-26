import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/features/more/application/app_settings_controller.dart';
import 'package:notaku_sejarah_v2/features/more/presentation/more_screen.dart';
import 'package:notaku_sejarah_v2/features/records/data/records_repository.dart';
import 'package:notaku_sejarah_v2/features/records/domain/quiz_record.dart';
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

class _FakeRecordsRepository extends RecordsRepository {
  _FakeRecordsRepository() : _records = [_sampleRecord()] {
    loaded = true;
  }

  List<QuizRecord> _records;

  @override
  List<QuizRecord> get records => List.unmodifiable(_records);

  @override
  Future<void> load() async {}

  @override
  Future<void> clear() async {
    _records = const [];
    notifyListeners();
  }

  @override
  Future<void> close() async {}
}

Future<void> _pumpUi(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 350));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('requires confirmation before clearing quiz records', (
    tester,
  ) async {
    final recordsRepository = _FakeRecordsRepository();
    final settingsController = AppSettingsController();

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
    await _pumpUi(tester);

    final clearButton = find.byKey(const ValueKey('clear-records-button'));
    await tester.ensureVisible(clearButton);
    await tester.tap(clearButton);
    await _pumpUi(tester);

    expect(find.text('Padam semua rekod kuiz?'), findsOneWidget);
    expect(recordsRepository.records, hasLength(1));

    await tester.tap(find.text('Padam rekod'));
    await _pumpUi(tester);

    expect(recordsRepository.records, isEmpty);
    expect(find.text('Semua rekod kuiz telah dipadam.'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    settingsController.dispose();
    recordsRepository.dispose();
  });
}
