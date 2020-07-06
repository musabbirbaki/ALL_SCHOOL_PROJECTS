/*
  Currently replaced by Query Object DB
*/


// import 'dart:async';

// import 'package:sqflite/sqflite.dart';
// import 'dashboard_db_utils.dart';
// import 'dashboard.dart';

// class DashboardModel{
//   //Insert Dashboard
//   Future<int> insertDashboard(Dashboard dashboard) async {
//     final db = await DashboardDBUtils.init();
//     return await db.insert(
//       "dashboards_table", 
//       dashboard.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   //Delete Dashboard using Dashboard Title
//   Future<int> deleteDashboardUsingTitle(String graphTitle) async {
//     final db = await DashboardDBUtils.init();
//     return await db.delete(
//       "dashboards_table", 
//       where: 'graphTitle = ?',
//       whereArgs: [graphTitle],
//     );
//   }

//   //Delete Dashboard using Dashboard id
//   Future<int> deleteDashboardUsingId(int id) async {
//     final db = await DashboardDBUtils.init();
//     return await db.delete(
//       "dashboards_table", 
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }

//   //Get All Dashboards
//   Future<List<Dashboard>> getAllDashboard() async {
//     final db = await DashboardDBUtils.init();
//     List<Map<String,dynamic>> maps = await db.query('dashboards_table');
//     List<Dashboard> dashboards = [];
//     for (int i = 0; i < maps.length; i++) {
//       dashboards.add(Dashboard.fromMap(maps[i]));
//     }
//     return dashboards;
//   }

// }