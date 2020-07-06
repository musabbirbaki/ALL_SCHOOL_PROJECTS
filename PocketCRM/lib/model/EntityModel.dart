import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'dbutils.dart';
import 'Entity.dart';
import 'package:path/path.dart' as path;

class EntityModel {
  String tbName;

  EntityModel([this.tbName]);
  //getAllEntitys(): returns a list of all Entitys in the db
  Future<List<Entity>> getAllEntitys() async {
    print('getAllEntitys: $tbName');
    final db = await DBUtils.init();
    List<Map<String, dynamic>> maps = await db.query(tbName);
    List<Entity> entitys = [];
    for (int i = 0; i < maps.length; i++) {
      entitys.add(Entity.fromMap(maps[i]));
    }

    return entitys;
  }

  Future<Entity> getEntityById(int id) async {
    final db = await DBUtils.init();
    List<Map<String, dynamic>> maps = await db.query(
      '$tbName',
      where: 'id = ?',
      whereArgs: [id],
    );
    Entity entity = Entity.fromMap(maps[0]);

    return entity;
  }

  void dropAllTables() async {
    List<String> tables = await getTables();
    tables.forEach((table) async => await dropTable(table));
    print('after drop all tables: ${await getTables()}');
  }

  Future<void> createNewTable(String name) async {
    final db = await DBUtils.init();

    await db.execute('CREATE TABLE $name(id INTEGER PRIMARY KEY)');
    print(await getTables());
  }

  Future<void> dropTable(String name) async {
    final db = await DBUtils.init();
    print('table to be dropped: $name');
    if (name == 'android_metadata') {
    } else {
      await db.execute('DROP TABLE $name;');
    }
    print(await getTables());
  }

  Future<List<String>> getTables() async {
    final db = await DBUtils.init();
    String sql = "SELECT name FROM sqlite_master WHERE type ='table' ";
//AND name NOT LIKE 'sqlite_%';
    var f = await db.rawQuery(sql);
    List<String> tableNames = [];
    for (var item in f) {
      if (item['name'] != 'android_metadata') {
        tableNames.add(item['name']);
      }
    }
    return tableNames;
  }

  //insertEntity(Entity Entity): add new Entity, return id
  Future<int> insertEntity(Entity entity, [String table]) async {
    //initialize db
    final db = await DBUtils.init();
    if (table != null) {
      tbName = table;
    }

    return await db.insert(
      '$tbName',
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //updateEntity(Entity Entity): update using id
  Future<int> updateEntity(Entity entity) async {
    final db = await DBUtils.init();

    return await db.update(
      '$tbName',
      entity.toMap(), //data to replace with (value)
      where: 'id = ?',
      whereArgs: [entity.id],
    );
  }

  void query(sql) async {
    final db = await DBUtils.init();

    // sql = 'PRAGMA table_info(tbName)';

    var t = await db.rawQuery(sql);
    print(t);
  }

  /*
    Intended for Dashboard query use, this is mostly used by Dashboard after all
    custom queries are run.
  */
  Future<List<Map<String, dynamic>>> runCustomEntityQuery(sql) async {
    final db = await DBUtils.init();
    List<Map<String, dynamic>> t = await db.rawQuery(sql);
    return t;
  }

  Future<Map<String, dynamic>> getColumnNames([String table]) async {
    final db = await DBUtils.init();
    if (table != null) {
      tbName = table;
    }
    var sql = 'PRAGMA table_info($tbName)';

    var lMap = await db.rawQuery(sql);
    // print(lMap);
    Map<String, dynamic> colNames = {};
    lMap.forEach((item) {
      if (item['name'] == 'id') {
      } else {
        // colNames = MapEntry(key, value)
        colNames[item['name'].toString()] = item['dflt_value'];
      }
    });
    return colNames;
  }

  Future<void> getAddress() async {
    final db = await DBUtils.init();
    var sql = 'Select Address From $tbName';
    var colNames = await db.rawQuery(sql);
    print('address: $colNames');
  }

  //deleteEntityById(int id): delete Entity using id
  Future<int> deleteEntityById(int id) async {
    final db = await DBUtils.init();
    return await db.delete(
      '$tbName',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> addNewAttribute(String attrName, [String table]) async {
    print('add new attribute called: $attrName');
    final db = await DBUtils.init();
    String attrType = 'TEXT';
    if (table != null) {
      tbName = table;
    }
    // List<String> colNames =
    getColumnNames(tbName).then((colNames) async {
      print('col: ${colNames.keys}');
      if (!colNames.keys.contains(attrName)) {
        print('does this even work');
        await db.execute('''ALTER TABLE $tbName
ADD $attrName TEXT''');
      }
    });

    print(await getColumnNames());
  }

  void deleteDB() async {
    deleteDatabase(path.current);
  }
}

//// TODO: test sql
//SELECT Orders.name as OrdersID, Customers.name, Orders.OrderDate FROM Orders INNER JOIN Customers ON Orders.CustomerID=Customers.id;
