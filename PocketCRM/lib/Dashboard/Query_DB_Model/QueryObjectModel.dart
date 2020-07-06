import 'package:pocket_crm/Dashboard/Query_DB_Model/QueryDbUtils.dart';
import 'package:pocket_crm/Dashboard/Query_DB_Model/QueryObject.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart' as path;

class QueryObjectModel {
  //Insert Query by Query Object
  Future<int> insertQueryObject(QueryObject queryObject) async {
    final db = await QueryObjectDBUtils.init();
    return await db.insert(
      "query_table",
      queryObject.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Delete Query by ID
  Future<int> deleteQueryObjectById(int id) async {
    final db = await QueryObjectDBUtils.init();
    return await db.delete(
      'query_table',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //Delete Db
  void deleteDB() async {
    deleteDatabase(path.current);
  }

  //Get all query
  Future<List<QueryObject>> getAllQueryObjects() async {
    final db = await QueryObjectDBUtils.init();
    List<Map<String, dynamic>> maps = await db.query('query_table');
    List<QueryObject> queries = [];
    for (int i = 0; i < maps.length; i++) {
      queries.add(QueryObject.fromMap(maps[i]));
    }
    return queries;
  }

  /*
    Queries the last ID the queryObject table has
  */
  Future<int> getNumberOfRows() async {
    final db = await QueryObjectDBUtils.init();
    // String sql = "SELECT COUNT(*) FROM query_table;";
    String sql = "SELECT id FROM query_table ORDER BY id DESC LIMIT 1;";

    List<Map<String, dynamic>> f = await db.rawQuery(sql);

    if (f.length == 0) {
      return 0;
    }
    // print("f: $f");

    int lastID = f[0]['id'];
    return lastID;
  }

  Future<void> deleteAllQueries() async {
    final db = await QueryObjectDBUtils.init();
    String sql = "DELETE FROM query_table";
    db.rawQuery(sql);
  }

  /*
    Prints custom query for debuggin.
  */
  void query(sql) async {
    final db = await QueryObjectDBUtils.init();
    var t = await db.rawQuery(sql);
    print(t);
  }
}
