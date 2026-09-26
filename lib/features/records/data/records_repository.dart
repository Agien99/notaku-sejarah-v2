import 'package:flutter/foundation.dart';
import 'package:sembast/sembast.dart';

import '../domain/quiz_record.dart';
import 'records_database.dart';

class RecordsRepository extends ChangeNotifier {
  RecordsRepository({Future<Database> Function()? openDatabase})
    : _openDatabase = openDatabase ?? openRecordsDatabase;

  static RecordsRepository instance = RecordsRepository();
  final Future<Database> Function() _openDatabase;
  final _store = stringMapStoreFactory.store('quiz_attempts');
  Future<Database>? _database;
  Future<void>? _loading;
  List<QuizRecord> _records = const [];
  List<QuizRecord> get records => _records;
  bool loaded = false;
  Object? error;

  Future<Database> _open() async {
    try {
      return await (_database ??= _openDatabase());
    } catch (_) {
      _database = null;
      rethrow;
    }
  }

  Future<void> load() =>
      _loading ??= _load().whenComplete(() => _loading = null);

  Future<void> _load() async {
    try {
      final database = await _open();
      final snapshots = await _store.find(database);
      final records =
          snapshots
              .map((snapshot) => QuizRecord.fromJson(snapshot.value))
              .toList()
            ..sort((a, b) => b.completedAt.compareTo(a.completedAt));
      _records = List.unmodifiable(records);
      loaded = true;
      error = null;
    } catch (exception) {
      error = exception;
    }
    notifyListeners();
  }

  /// Stable ID + transaction makes retries idempotent, including after restart.
  Future<void> save(QuizRecord record) async {
    final database = await _open();
    await database.transaction((transaction) async {
      final reference = _store.record(record.id);
      if (!await reference.exists(transaction)) {
        await reference.put(transaction, record.toJson());
      }
    });
    await _loading;
    await load();
  }

  Future<void> close() async {
    await _loading;
    final pending = _database;
    if (pending != null) await (await pending).close();
    _database = null;
  }
}
