import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pocket_crm/FirebaseUtils/firebaseUtils.dart';
import 'package:pocket_crm/model/EntityModel.dart';
import 'package:pocket_crm/page/ListEntities.dart';

import 'Drawer.dart';

class TablePage extends StatefulWidget {
  final AuthResult user;
  TablePage(this.user);
  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  var _model = EntityModel();
  var textFieldController = TextEditingController();
  String tableName;
  bool _validate = false;
  bool dialVisible = true;

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  getTablesLength() async {
    var tables = await _model.getTables();
    return tables.length;
  }

  var exp = RegExp('^[A-Z]');
  @override
  Widget build(BuildContext context) {
    print('Table page');
    print('currUser: ${widget.user}');

    return Scaffold(
      drawer: drawer(context, widget.user),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text('Table page'),
      ),
      body: FutureBuilder(
        future: _model.getTables(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print('snapshot: ${snapshot.data}');
          if (snapshot.hasData) {
            return Container(
              child: _buildListView(context, snapshot.data),
              decoration: BoxDecoration(color: Theme.of(context).dividerColor),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      // floatingActionButton: getTablesLength() == 0
      //     ? SpeedDial(
      //         // both default to 16
      //         marginRight: 18,
      //         marginBottom: 20,
      //         animatedIcon: AnimatedIcons.menu_arrow,
      //         animatedIconTheme: IconThemeData(size: 22.0),
      //         visible: dialVisible,
      //         closeManually: false,
      //         curve: Curves.bounceIn,
      //         overlayColor: Colors.black,
      //         overlayOpacity: 0.5,
      //         onOpen: () => print('OPENING DIAL'),
      //         onClose: () => print('DIAL CLOSED'),
      //         tooltip: 'Speed Dial',
      //         heroTag: 'speed-dial-hero-tag',
      //         elevation: 8.0,
      //         shape: CircleBorder(),
      //         children: [
      //           SpeedDialChild(
      //             child: Icon(Icons.create),
      //             label: 'Create Table',
      //             labelStyle: TextStyle(fontSize: 18.0),
      //             onTap: () async {
      //               showDialog(
      //                   context: context,
      //                   builder: (BuildContext context) {
      //                     return AlertDialog(
      //                       title: Text('Please enter a table name'),
      //                       content: TextField(
      //                         // style: TextStyle(color: _validate ? null : Colors.red),
      //                         controller: textFieldController,
      //                         onChanged: (val) {
      //                           setState(() {
      //                             _validate =
      //                                 exp.hasMatch(textFieldController.text);
      //                           });
      //                         },
      //                         decoration: InputDecoration(
      //                           errorText: _validate
      //                               ? 'Table Name must start with a Capital letter'
      //                               : null,
      //                         ),
      //                         inputFormatters: [
      //                           WhitelistingTextInputFormatter(
      //                               RegExp("[a-zA-Z]"))
      //                         ],
      //                       ),
      //                       actions: <Widget>[
      //                         FlatButton(
      //                           child: Text('submit'),
      //                           onPressed: () {
      //                             tableName = textFieldController.text;

      //                             createTable(tableName, _model);
      //                             Navigator.of(context).pop();
      //                           },
      //                         )
      //                       ],
      //                     );
      //                   });
      //             },
      //           ),
      //           // SpeedDialChild(
      //           //   child: Icon(Icons.cloud_download),
      //           //   label: 'Load data',
      //           //   labelStyle: TextStyle(fontSize: 18.0),
      //           //   onTap: () async {
      //           //     showDialog(
      //           //         context: context,
      //           //         builder: (BuildContext context) {
      //           //           return AlertDialog(
      //           //             title: Text('Use Test Data',
      //           //                 style: TextStyle(color: Colors.red)),
      //           //             content: Text(
      //           //               'Are you sure? This will delete all the current tables you have stored and replace them with test data!!!',
      //           //               style: TextStyle(
      //           //                   color: Colors.red,
      //           //                   fontWeight: FontWeight.bold),
      //           //             ),
      //           //             actions: <Widget>[
      //           //               FlatButton(
      //           //                 child: Text('no'),
      //           //                 onPressed: () async {
      //           //                   Navigator.of(context).pop();
      //           //                 },
      //           //               ),
      //           //               FlatButton(
      //           //                 child: Text('yes'),
      //           //                 onPressed: () async {
      //           //                   var _fireUtils = FireBaseUtils();
      //           //                   print('currUser: ${widget.user}');
      //           //                   await _fireUtils.loadData(widget.user);
      //           //                   print('loading data completed');
      //           //                   setState(() {});

      //           //                   Navigator.of(context).pop();
      //           //                 },
      //           //               ),
      //           //             ],
      //           //           );
      //           //         });
      //           //   },
      //           // ),
      //         ],
      //       )
      //     : SpeedDial(
      //         // both default to 16
      //         marginRight: 18,
      //         marginBottom: 20,
      //         animatedIcon: AnimatedIcons.menu_close,
      //         animatedIconTheme: IconThemeData(size: 22.0),
      //         visible: dialVisible,
      //         closeManually: false,
      //         curve: Curves.bounceIn,
      //         overlayColor: Colors.black,
      //         overlayOpacity: 0.5,
      //         onOpen: () => print('OPENING DIAL'),
      //         onClose: () => print('DIAL CLOSED'),
      //         tooltip: 'Speed Dial',
      //         heroTag: 'speed-dial-hero-tag',
      //         elevation: 8.0,
      //         shape: CircleBorder(),
      //         children: [
      //           SpeedDialChild(
      //             child: Icon(Icons.create),
      //             label: 'Create Table',
      //             labelStyle: TextStyle(fontSize: 18.0),
      //             onTap: () async {
      //               showDialog(
      //                   context: context,
      //                   builder: (BuildContext context) {
      //                     return AlertDialog(
      //                       title: Text('Please enter a table name'),
      //                       content: TextField(
      //                         // style: TextStyle(color: _validate ? null : Colors.red),
      //                         controller: textFieldController,
      //                         onChanged: (val) {
      //                           setState(() {
      //                             _validate =
      //                                 exp.hasMatch(textFieldController.text);
      //                           });
      //                         },
      //                         decoration: InputDecoration(
      //                           errorText: _validate
      //                               ? 'Table Name must start with a Capital letter'
      //                               : null,
      //                         ),
      //                         inputFormatters: [
      //                           WhitelistingTextInputFormatter(
      //                               RegExp("[a-zA-Z]"))
      //                         ],
      //                       ),
      //                       actions: <Widget>[
      //                         FlatButton(
      //                           child: Text('submit'),
      //                           onPressed: () {
      //                             tableName = textFieldController.text;

      //                             createTable(tableName, _model);
      //                             Navigator.of(context).pop();
      //                           },
      //                         )
      //                       ],
      //                     );
      //                   });
      //             },
      //           ),
      //           SpeedDialChild(
      //             child: Icon(Icons.cloud_download),
      //             label: 'Load data',
      //             labelStyle: TextStyle(fontSize: 18.0),
      //             onTap: () async {
      //               showDialog(
      //                   context: context,
      //                   builder: (BuildContext context) {
      //                     return AlertDialog(
      //                       title: Text('Use Test Data'),
      //                       content: Text(
      //                         'Are you sure? This will delete all the current tables you have stored and replace them with test data!!!',
      //                         style: TextStyle(color: Colors.red),
      //                       ),
      //                       actions: <Widget>[
      //                         FlatButton(
      //                           child: Text('yes'),
      //                           onPressed: () async {
      //                             var _fireUtils = FireBaseUtils();
      //                             print('currUser: ${widget.user}');
      //                             await _fireUtils.loadData(widget.user);
      //                             print('loading data completed');
      //                             setState(() {});

      //                             Navigator.of(context).pop();
      //                           },
      //                         )
      //                       ],
      //                     );
      //                   });
      //             },
      //           ),
      //           SpeedDialChild(
      //             child: Icon(Icons.cloud_upload),
      //             label: 'Push Data',
      //             labelStyle: TextStyle(fontSize: 18.0),
      //             onTap: () async {
      //               var _fireUtils = FireBaseUtils();
      //               print('currUser: ${widget.user}');
      //               await _fireUtils.pushData(widget.user);
      //             },
      //           ),
      //         ],
      //       ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.create),
          onPressed: () async {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Please enter a table name'),
                    content: TextField(
                      // style: TextStyle(color: _validate ? null : Colors.red),
                      controller: textFieldController,
                      onChanged: (val) {
                        setState(() {
                          _validate = exp.hasMatch(textFieldController.text);
                        });
                      },
                      decoration: InputDecoration(
                        errorText: _validate
                            ? 'Table Name must start with a Capital letter'
                            : null,
                      ),
                      inputFormatters: [
                        WhitelistingTextInputFormatter(RegExp("[a-zA-Z]"))
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('submit'),
                        onPressed: () {
                          tableName = textFieldController.text;

                          createTable(tableName, _model);
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
          }),
    );
  }

  Widget _buildListView(BuildContext context, data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                spreadRadius: 0.05,
                blurRadius: 20.0,
                offset: Offset(3, 1.5),
              ),
            ],
          ),
          child: Material(
            type: MaterialType.card,
            shadowColor: Colors.red,
            child: ListTile(
              title: Text(
                data[index],
                style: Theme.of(context).textTheme.headline6,
              ),
              onTap: () {
                tableName = data[index];
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ListEntities(tableName)));

                print('current table: $tableName');
              },
            ),
          ),
        );
      },
    );
  }
}

void createTable(String name, EntityModel _model) {
  _model.createNewTable(name);
}
