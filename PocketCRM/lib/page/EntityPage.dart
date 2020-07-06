import 'package:flutter/material.dart';
import 'package:pocket_crm/components/AttributeForm.dart';
import 'package:pocket_crm/components/EntityForm.dart';
import 'package:pocket_crm/components/FormListTile.dart';
import 'package:pocket_crm/components/ProfilePic.dart';
import 'package:pocket_crm/model/Entity.dart';
import 'package:pocket_crm/model/EntityModel.dart';
import '../CardMap.dart';
import '../components/FormListTile.dart';

class EntityPage extends StatefulWidget {
  final Entity c;
  final int _latestIndex;
  final String tbName;
  EntityPage(this.c, this._latestIndex, this.tbName);
  @override
  _EntityPageState createState() =>
      _EntityPageState(this.c, this._latestIndex, this.tbName);
}

class _EntityPageState extends State<EntityPage> {
  Entity c;
  int _latestIndex;
  String tbName;
  _EntityPageState(this.c, this._latestIndex, this.tbName);
  int _id;
  Map<String, dynamic> attributesMap = {};
  bool isEdit = false;
  EntityModel _model;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> buttonsUtil;

  @override
  void initState() {
    _model = EntityModel(tbName);
    super.initState();
    if (c != null) {
      attributesMap.addAll(c.attributes);
      _id = c.id;
      attributesMap.remove('id');
      print('attributes');
      print('id: $_id');
    }
    // print(attributesMap.remove('id'));
  }

  // final form
  final textController = TextEditingController();

  void saveAtrributes(context) async {
    print('save clicked');
    await _model.updateEntity(Entity(_id, attributesMap));

    setState(() {
      isEdit = !isEdit;
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Saving changes to Entity $_id'),
      ));
    });
  }

  void addNewEntity() async {
    // Todo: Create new Entity
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EntityForm(entityName: tbName)));
    print('_lastIndex: $_latestIndex');
    print(result);
    Entity newEntity = Entity(++_latestIndex, result);

    _latestIndex = await _model.insertEntity(newEntity);

    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EntityPage(newEntity, _latestIndex, tbName)));
  }

  void deleteCusotmer(context, id) async {
    Navigator.pop(context);
    // _model.deleteEntityById(id);
  }

  void editEntity() {}
  void cancelPressed() {}

  @override
  Widget build(BuildContext context) {
    print('Entity page called');
    print('Attributes map: $attributesMap');
    print(_latestIndex);
    _latestIndex = _id;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: Container(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Align(
              child: Text('Entity id: $_id'),
              alignment: Alignment.topLeft,
            ),
            // testContainer(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                porfilePicture(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        // splashColor: Colors.red,
                        onPressed: () {
                          if (isEdit) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Save Changes?'),
                                    content: Text(
                                        'Any changes made the this page will be saved. Continue?'),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('No'),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          saveAtrributes(context);
                                        },
                                        child: Text('Yes'),
                                      )
                                    ],
                                  );
                                });
                          } else {
                            addNewEntity();
                          }
                        },
                        child: isEdit ? Text('Save') : Text('Add New'),
                      ),
                      FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: !isEdit
                            ? () => setState(() => isEdit = !isEdit)
                            : null,
                        child: Text('Edit'),
                      ),
                      FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () {
                          var cancelDialog = AlertDialog(
                            title: Text('Cancel Changes?'),
                            content: Text(
                                'Any changes made to this page will be lost. Are you sure you like to continue?'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('No'),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    isEdit = !isEdit;
                                  });
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          );

                          var deleteDialog = AlertDialog(
                            title: Text('Delete User?'),
                            content: Text(
                                'Would you like to delete this user from the database?'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('No'),
                              ),
                              FlatButton(
                                onPressed: () async {
                                  await _model.deleteEntityById(_id);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();

                                  // _scaffoldKey.currentState
                                  //     .showSnackBar(SnackBar(
                                  //   content: Text(
                                  //       'Entity $_id has been deleted from the database.'),
                                  // ));
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          );

                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return isEdit ? cancelDialog : deleteDialog;
                              });
                        },
                        child: !isEdit ? Text('Delete') : Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.black,
              thickness: 2,
            ),
            // ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(25.0),
                itemCount: isEdit
                    ? attributesMap.keys.length + 1
                    : attributesMap.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index == attributesMap.keys.length) {
                    return FractionallySizedBox(
                      widthFactor: 0.65,
                      child: FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () async {
                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AttributeForm()));
                          if (result != null) {
                            print('result: ${result['key']}');
                            attributesMap[result['key']] = result['value'];
                            _model.addNewAttribute(result['key']);
                          }
                          // print(result['type']);
                        },
                        child: Text('Add New Attribute'),
                      ),
                    );
                  }
                  var currKey = attributesMap.keys.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      if (currKey == 'Address') {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(attributesMap[currKey]),
                                content:
                                    CardMap(context, attributesMap[currKey]),
                              );
                            });
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.5),
                          color: Colors.blue,
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: Colors.black),
                                ),
                              ),
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '$currKey',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: isEdit
                                    ? FormListTile(currKey, attributesMap)
                                    : Text(
                                        '${attributesMap[currKey]}',
                                        style: TextStyle(fontSize: 20),
                                      ),
                              ),
                            ),
                          ],
                        )),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
