import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:notaku_sejarah_v2/features/records/data/records_repository.dart';
import 'package:sembast/sembast_memory.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  var sequence = 0;
  setUp(() {
    final name = 'test-records-${sequence++}';
    RecordsRepository.instance = RecordsRepository(
      openDatabase: () => databaseFactoryMemory.openDatabase(name),
    );
  });
  tearDown(() async {
    await RecordsRepository.instance.close();
    RecordsRepository.instance.dispose();
  });
  await testMain();
}
