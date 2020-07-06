import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pocket_crm/components/EntityForm.dart';
import 'package:pocket_crm/components/InitialAttributesForm.dart';
import 'package:pocket_crm/page/EntityPage.dart';
import 'package:pocket_crm/page/Drawer.dart';

import '../model/EntityModel.dart';
import '../model/Entity.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ListEntities extends StatefulWidget {
  final String tbName;
  ListEntities([this.tbName, this.user]);
  AuthResult user;
  @override
  _ListEntitiesState createState() => _ListEntitiesState(this.tbName);
}

class _ListEntitiesState extends State<ListEntities> {
  final text = TextEditingController();
  final String tbName;

  _ListEntitiesState(this.tbName);

  EntityModel _model;

  List<Entity> entitys = [];
  int _lastIndex = 0;
  Map colNames = {};

  final _sKey = GlobalKey<ScaffoldState>();

  bool dialVisible = true;
  void getEntitys() async {
    entitys = await _model.getAllEntitys();
    print(entitys);
  }

  void createNewEntity() async {
    // Todo: Create new Entity
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EntityForm(entityName: tbName)));
    print('_lastIndex: $_lastIndex');
    print(result);
    Entity newEntity = Entity(++_lastIndex, result);

    _lastIndex = await _model.insertEntity(newEntity);
    setState(() {});
  }

  test() async {
    colNames = await _model.getColumnNames();
    print(colNames);
  }

  @override
  void initState() {
    _model = EntityModel(tbName);
    test();
    super.initState();
  }

  void addAttributes(List attrs) {
    print('add attributes called');
    for (var attr in attrs) {
      _model.addNewAttribute(attr['name']);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Loading test Entity page');
    print('table name $tbName');
    return Scaffold(
        key: _sKey,
        backgroundColor: Colors.grey,
        drawer: drawer(context, widget.user),
        appBar: AppBar(
          title: Text('$tbName'),
        ),
        body: FutureBuilder(
          future: _model.getAllEntitys(),
          builder: (context, snapshot) {
            entitys = snapshot.data;
            if (snapshot.hasData) {
              if (entitys.length == 0) {
                return Center(
                  child: Text('Please Create a new Entity'),
                );
              } else {
                return ListView.builder(
                  itemCount: entitys.length,
                  itemBuilder: (context, index) {
                    int id = entitys[index].id;
                    _lastIndex = id;

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: ListTile(
                          title: Text('$id'),
                          onTap: () {
                            print('testEntity: index $_lastIndex');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EntityPage(
                                        entitys[index], _lastIndex, tbName)));
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        floatingActionButton: FloatingActionButton(onPressed: null)
        // SpeedDial(
        //   // both default to 16
        //   marginRight: 18,
        //   marginBottom: 20,
        //   animatedIcon: AnimatedIcons.menu_arrow,
        //   animatedIconTheme: IconThemeData(size: 22.0),
        //   visible: dialVisible,
        //   closeManually: false,
        //   curve: Curves.bounceIn,
        //   overlayColor: Colors.black,
        //   overlayOpacity: 0.5,
        //   onOpen: () => print('OPENING DIAL'),
        //   onClose: () => print('DIAL CLOSED'),
        //   tooltip: 'Speed Dial',
        //   heroTag: 'speed-dial-hero-tag',
        //   elevation: 8.0,
        //   shape: CircleBorder(),
        //   children: [
        //     SpeedDialChild(
        //       child: Icon(Icons.add),
        //       label: 'Add entity',
        //       labelStyle: TextStyle(fontSize: 18.0),
        //       onTap: () async {
        //         print('Creating new Entity');
        //         createNewEntity();
        //       },
        //     ),
        //     SpeedDialChild(
        //       child: Icon(Icons.add_box),
        //       label: 'Add Attributes',
        //       labelStyle: TextStyle(fontSize: 18.0),
        //       onTap: () async {
        //         var results = await Navigator.push(context,
        //             MaterialPageRoute(builder: (context) => InitialAttributes()));
        //         if (results != null) {
        //           print('results: $results');
        //           addAttributes(results);
        //         }
        //       },
        //     ),
        //   ],
        // ),
        );
  }
}
