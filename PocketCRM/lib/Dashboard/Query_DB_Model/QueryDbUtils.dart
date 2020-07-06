import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class QueryObjectDBUtils {
  static Future<Database> init() async {
    return openDatabase(
      path.join(await getDatabasesPath(), 'customer_list.db'),
      onCreate: (db, version) {
        if (version > 1) {
          // downgrade path
        }
        db.execute('CREATE TABLE query_table(id INTEGER PRIMARY KEY, query TEXT, title TEXT, chartType TEXT)');
      },
      version: 1,
    );
  }
}