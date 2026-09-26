import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/features/records/data/records_repository.dart';
import 'package:notaku_sejarah_v2/features/records/domain/quiz_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  setUp(() {
    RecordsRepository.instance = _WidgetRecordsRepository();
    SharedPreferences.setMockInitialValues({});
  });
  tearDown(() async {
    await RecordsRepository.instance.close();
    RecordsRepository.instance.dispose();
  });
  await testMain();
}

/// Widget tests use deterministic local stores without platform I/O timers.
/// Real Sembast transactions and disk reopen are tested in repository tests.
class _WidgetRecordsRepository extends RecordsRepository {
  _WidgetRecordsRepository() {
    loaded = true;
  }

  final Map<String, QuizRecord> _saved = {};

  @override
  List<QuizRecord> get records => List.unmodifiable(
    _saved.values.toList()
      ..sort((a, b) => b.completedAt.compareTo(a.completedAt)),
  );

  @override
  Future<void> load() async {}

  @override
  Future<void> save(QuizRecord record) async {
    _saved.putIfAbsent(record.id, () => record);
    notifyListeners();
  }

  @override
  Future<void> close() async {}
}
