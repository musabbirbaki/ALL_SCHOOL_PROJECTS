/*
Not being used
*/

// import 'dart:async';

// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart' as path;

// class DashboardDBUtils {
//   static Future<Database> init() async {
//     return openDatabase(
//       path.join(await getDatabasesPath(), 'dashboard_list.db'),
//       onCreate: (db, version) {
//         if (version > 1) {
//           // downgrade path
//         }
//         db.execute('CREATE TABLE dashboards_table(id INTEGER PRIMARY KEY, graphTitle TEXT, graphType TEXT, dataInString TEXT)');
//       },
//       version: 1,
//     );
//   }
// }