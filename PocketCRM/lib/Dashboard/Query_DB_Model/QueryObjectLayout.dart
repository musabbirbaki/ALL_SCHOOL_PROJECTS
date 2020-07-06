/*
  This class contains the form of Creating a new Dashboard. Navigation to this page
  can be accessessed using the add(+) button from the Dashboard. Or "all_dashboard_layout.dart"
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket_crm/Dashboard/Dashboard_Model/dashboard.dart';
import 'package:pocket_crm/Dashboard/Query_DB_Model/QueryObject.dart';
import 'package:pocket_crm/Dashboard/Query_DB_Model/QueryObjectModel.dart';
import 'package:pocket_crm/Dashboard/ConstructDashboard.dart';
import 'package:pocket_crm/model/EntityModel.dart';

class CreateQueryObjectUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateQueryObjectUIState();
}

class CreateQueryObjectUIState extends State<CreateQueryObjectUI> {
  int id;
  String query, title, dashboardType;

  QueryObjectModel _model;

  int _lastIndex = 0;

  @override
  void initState() {
    print("(Query Form:) Entered QueryObject Create Form.");
    super.initState();
    _model = QueryObjectModel();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

    return Scaffold(
      // drawer: drawer(context),
      appBar: AppBar(
        title: Text('Create Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Center(
                child: Column(children: [
              // Container(
              //   padding: EdgeInsets.all(40),
              //   child: Text("Please fill in valid information to register.",
              //   style: TextStyle(fontSize: 25)),
              // ),

              //Title field
              Container(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                color: Colors.white,
                child: TextFormField(
                  validator: (String input) {
                    if (input.length < 0) {
                      return 'Please provide a title.';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (input) {
                    this.title = input;
                  },
                  // obscureText: true,
                  onEditingComplete: () {
                    FocusScope.of(context)
                        .requestFocus(FocusNode()); //Keyboard is put away
                  },
                  style: style,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0))),
                ),
              ),

              //Query Field
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
                color: Colors.white,
                child: TextFormField(
                  validator: (input) {
                    print("(Query Form:) Running Query validator");
                    if (input.isEmpty) {
                      return 'Please provide an query.';
                    } else if (input.toLowerCase().contains("select")) {
                      return null;
                    } else {
                      print("(Query Form:) Invalid Query: $input");
                      return 'Invalid Query';
                    }
                  },
                  onSaved: (input) {
                    query = input;
                  },
                  style: style,
                  maxLines: 10,
                  decoration: InputDecoration(
                      labelText: "SQL Query",
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "SELECT.....",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0))),
                ),
              ),

              // Container(
              //   padding: EdgeInsets.fromLTRB(45, 0, 45, 20),
              //   color: Colors.white,
              //   child: Text("Re-Type Password:"),
              // ),

              //Retye Password field
              // Container(
              //   padding: EdgeInsets.fromLTRB(45, 0, 45, 20),
              //   color: Colors.white,
              //   child: TextFormField(
              //     validator: (String input){
              //       if(input.length < 0){
              //         return 'Please provide a valid password.';
              //       }
              //       else{
              //         return null;
              //       }
              //     },
              //     onSaved: (input){
              //       _chartType = input;
              //     },
              //     obscureText: true,
              //     onEditingComplete: () {
              //       FocusScope.of(context).requestFocus(FocusNode());//Keyboard is put away
              //     },
              //     style: style,
              //     decoration: InputDecoration(
              //         contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              //         hintText: "Re-type Password",
              //         border: OutlineInputBorder(
              //             borderRadius: BorderRadius.circular(32.0))),
              //   ),
              // ),

              ///////////DROP DOWN LIST
              Container(
                padding: EdgeInsets.only(bottom: 20),
                width: MediaQuery.of(context).size.width * 0.80,
                child: DropdownButton<String>(
                  items: <String>['None', 'Pie', 'Bar', 'Scatter', 'Line']
                      .map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: Text(
                          value,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    );
                  }).toList(),
                  value: dashboardType,
                  onChanged: (String newValue) {
                    setState(() {
                      dashboardType = newValue;
                      print('(Query Form:) Graph Type $dashboardType');
                    });
                  },
                ),
              ),

              RaisedButton(
                color: Colors.white,
                textColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                onPressed: () {
                  print("Create Query.");
                  createQueryObject();
                },
                child: Text(
                  "Create Query",
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ]))),
      ),
    );
  }

  void createQueryObject() {
    //Save Textfield data
    final formState = _formKey.currentState;
    EntityModel _entityModelcreator = EntityModel();

    //Validate the inputs
    if (formState.validate()) {
      formState.save();

      //Create QueryObeject
      ////////////////////////////////////////////////////////////////////////////////////////////////////////////
      createNewQueryObject().then((query) {
        print(("Query Form: $query"));

        // createDashboard
        _entityModelcreator.runCustomEntityQuery(query.query).then((map) {
          Dashboard dash = ConstructDashBoard.createDashboard(
              query, ConstructDashBoard.queryResultSetToMap(map));
          print(
              "(Query Form:) Adding New Dashboard element to Dashboard: $dash");
          Navigator.of(context).pop(dash);
        });
      });
      //////////////////////////////////////////////////////////////////////////////////////////////////////////////

      //Return to dashboard
      // Dashboard newDashboard;
      // Navigator.of(context).pop(newDashboard);
    } else {
      print("INVALID QURWERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");
    }
  }

  QueryObject checkQuery(String query) {
    EntityModel _entityModel = EntityModel();

    var aa = query.toLowerCase();
    var a = query.split(" ");
    var b = a.indexOf("from");
    var tn = query.split(" ")[b + 1].trim();

    bool found = false;
    String tname = "";
    _entityModel.getTables().then((table) {
      if (table.contains(tn)) {
        found = true;
      }
      print(table);
    });
    print("(Query Form:) Table $found with name $tn");
  }

  Future<QueryObject> createNewQueryObject() async {
    int lastIndex = await _model.getNumberOfRows();
    lastIndex += 1;
    print("(Query Form:) Last Index: $lastIndex");

    //If graph hasn't chosen
    if (this.dashboardType == null) {
      this.dashboardType = "None";
    }

    // checkQuery(this.query);

    print(
        "\n(Query Form:) Saving Query with Title: ${this.title}, Query: ${this.query}, Tyep: ${this.dashboardType}\n");

    try {
      QueryObject qb = QueryObject(
          id: lastIndex,
          query: this.query,
          title: this.title,
          chartType: this.dashboardType);

      EntityModel _entityModelTester = EntityModel();
      _entityModelTester.runCustomEntityQuery(qb.query).then((map) {
        print("(Query Form:) Query Result: $map");
      });

      //Uncomment after testing
      _lastIndex = await _model.insertQueryObject(qb);
      return qb;
    } catch (e) {
      print("(Query Form:) Invalid Query: $e");
    }

    // printAllQueryObjects();
  }

  /*
    Prints all query, for debuggin.
  */
  void printAllQueryObjects() async {
    List<QueryObject> qbs = await _model.getAllQueryObjects();
    print("(Query Form:) Printing all Queries:");
    print(qbs);
  }
}
