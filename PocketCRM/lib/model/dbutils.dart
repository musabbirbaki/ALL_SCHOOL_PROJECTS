import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBUtils {
  static Future<Database> init([bool importData]) async {
    //   bool flag;
    //   importData == null ? flag = false : flag = true;
    //   print('init called: $importData');
    //   var databasesPath = await getDatabasesPath();
    //   var path = join(databasesPath, "entity_list.db");

    //   if (flag) {
    //     // Check if the database exists
    //     var exists = await databaseExists(path);

    //     // await deleteDatabase(path);
    //     if (!exists) {
    //       // Should happen only the first time you launch your application
    //       print("Creating new copy from asset");

    //       // Make sure the parent directory exists
    //       try {
    //         await Directory(dirname(path)).create(recursive: true);
    //       } catch (_) {}

    //       // Copy from asset
    //       ByteData data = await rootBundle.load(join("assets", "test.db"));
    //       print("data: $data");
    //       List<int> bytes =
    //           data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    //       print(bytes);

    //       // Write and flush the bytes written
    //       await File(path).writeAsBytes(bytes, flush: true);
    //     } else {
    //       print("Opening existing database");
    //     }
    //   }

    //   return openDatabase(
    //     path,
    //     version: 1,
    //   );
    // }

    return openDatabase(path.join(await getDatabasesPath(), 'entity_list.db'),
        version: 1);
  }
}
