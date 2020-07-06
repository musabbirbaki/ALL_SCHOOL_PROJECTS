import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocket_crm/model/Entity.dart';
import 'package:pocket_crm/model/EntityModel.dart';

class FireBaseUtils {
  Map<String, Map<String, dynamic>> firebaseData = {};

  loadData(AuthResult currUser) {
    loadDataFire(currUser).then((data) {
      print('asdfasdfasdfsd--------$data');
    });
  }

  Future<Map<String, Map<String, dynamic>>> loadDataFire(AuthResult currUser,
      [bool testDataFlag]) async {
    var _model = EntityModel();
    String email = currUser.user.email;
    List<String> dbTables = await _model.getTables();
    print('---------------------Current tables -----------------------------');
    print(await _model.getTables());
    // if (testDataFlag) {
    dbTables.forEach((table) async {
      await _model.dropTable(table);
    });
    // }
    print(
        '---------------------After droped tables -----------------------------');
    print(await _model.getTables());

    // DocumentReference
    final docRef = Firestore.instance.document('users/$email');
    // final data = Firestore.instance.collection('TestData/Tables/Customers');
    //get TableNames
    DocumentSnapshot documentSnapshot = await docRef.get();
    Map _maps = documentSnapshot.data;
    print('maps: $_maps');

    _maps.forEach((_key, _value) async {
      try {
        int.parse(_key);
        print('need to create table: $_value');
        await _model.createNewTable(_value);
        firebaseData[_value] = {};

        docRef.collection(_value).getDocuments().then((result) {
          print(_value);
          result.documents.forEach((fStoreData) {
            firebaseData[_value] = fStoreData.data;
            print("firebaseData: $firebaseData");
            // fStoreData.data.keys.forEach((attr) {
            //   print('attr: $attr');
            //   _model.addNewAttribute(attr, _value);
            // });
          });
        });
      } catch (e) {
        print('can\'t parse object to int');
      }
    });
    print(
        '---------------------After New Tables created -----------------------------');
    dbTables = await _model.getTables();
    print(dbTables);

    print("firebaseData2: $firebaseData");
    return firebaseData;
    // dbTables.forEach((table) async {
    //   print('---------current table: $table----------');

    // QuerySnapshot tableData =
    //     await
    // _model = EntityModel(table);
    // docRef.collection(table).getDocuments().then((result) async {
    //   print(_model.tbName);
    //   result.documents.forEach((fStoreData) async {
    //     fStoreData.data.keys.forEach((attr) async {
    //       print('attr: $attr');
    //       await _model.addNewAttribute(attr);
    //     });
    // _model.getColumnNames().then((columns) {
    //   print('columns: $columns');
    //   // if (columns.isEmpty) {
    //   // }
    // });

    //       //     Map<String, dynamic> fireStoreMap = {};
    //       // fireStoreMap = data.data;
    //       // fireStoreMap['id'] = data.documentID;

    //       //Create Enitity and add entity to local db
    //       // await _model
    //       //     .insertEntity(Entity(int.parse(fireStoreMap['id']), fireStoreMap));
    //       // });

    //       print('new entity added');
    //   });
    // });
    // });
  }

  //Adds all the data stored on the local db to firebase
  pushData(AuthResult currUser) async {
    //FOR DEBUGGING: check to see the current user
    print(currUser);
    String email = currUser.user.email;

    //Document reference to current users firestore document
    final docRef = Firestore.instance.document('users/$email');
    var _model = EntityModel();

    List<String> tables = await _model.getTables();
    int i = 0;
    DocumentSnapshot snapshot = await docRef.get();

    //used to be able to access the tables names when loading in the data
    while (snapshot.data.containsKey('$i')) {
      i += 1;
    }

    //loops througth each table in the db and adds its data to the firestore
    tables.forEach((table) async {
      //flag to see it the table was just created
      bool doesExits = false;
      print('-----------working on table: $table ----------');
      print('data: ${snapshot.data}');
      //checks to see if table needs to be created
      if (!snapshot.data.containsValue(table)) {
        await snapshot.reference.updateData({'$i': table});
        i += 1;
      } else {
        print('$table already exists');
        doesExits = true;
      }
      _model = EntityModel(table);
      List<Entity> entities = await _model.getAllEntitys();

      //collection reference of the current table
      var colRef = snapshot.reference.collection(table);
      var query = await colRef.getDocuments();
      List<DocumentSnapshot> currQuery = query.documents;
      List<Map<String, dynamic>> documentsMap = [];
      currQuery.forEach((f) {
        documentsMap.add(f.data);
      });
      entities.forEach((e) {
        //finds index of old existance of entity object and deletes it form the database
        if (doesExits) {
          var index = documentsMap.indexWhere((test) => test['id'] == e.id);
          currQuery[index].reference.delete();
        }

        //adds the most current enity to the database
        colRef.add(e.toMap());
      });
    });
  }
}
