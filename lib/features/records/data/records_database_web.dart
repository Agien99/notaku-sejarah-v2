import 'package:sembast_web/sembast_web.dart';

Future<Database> openRecordsDatabase() =>
    databaseFactoryWeb.openDatabase('notaku_records', version: 1);
