import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:pocket_crm/Dashboard/Dashboard_Model/dashboard.dart';
import 'package:pocket_crm/Dashboard/DataTable/data_table_layout.dart';
import 'package:pocket_crm/Dashboard/SingleDashboardLayout.dart';
import 'package:pocket_crm/page/EntityPage.dart';
import 'package:pocket_crm/model/EntityModel.dart';

import 'Drawer.dart';

class DetailedDashBoardPage extends StatelessWidget {
  DetailedDashBoardPage({
    Key key,
    this.dashboard,
  }) : super(key: key);

  final Dashboard dashboard;

  @override
  Widget build(BuildContext context) {
    //If no graph is needed, return a scafold with just the table
    if (!dashboard.isGraph) {
      return Scaffold(
        appBar: AppBar(
          title: Text(dashboard.graphTitle),
          backgroundColor: Colors.orange,

          // actions: <Widget>[
          //   Container(
          //     padding: EdgeInsets.only(right: 20),
          //     child: GestureDetector(
          //       onTap: edit(),
          //       child: Icon(Icons.edit)
          //       ),
          //   )
          // ],
        ),

        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // DashboardLayout(dashboard: this.dashboard,),
              DataTableLayout(
                makeItemsSelectable: true,
                tableData: dashboard.tableData,
              ),

              ///Replace the data with dashboard data
            ],
          ),
        ),

        //Add Drawer code
        // drawer: drawer(context),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(dashboard.graphTitle),
        backgroundColor: Colors.orange,
      ),

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            DashboardLayout(
              dashboard: this.dashboard,
            ),
            DataTableLayout(
              makeItemsSelectable: true,
              tableData: dashboard.tableData,
            ),
            // DataTableLayout(makeItemsSelectable: true, tableData: graphDataToTableData(dashboard.data),), ///Replace the data with dashboard data
          ],
        ),
      ),

      //Add Drawer code
      // drawer: drawer(context),
    );
  }

  /*
  This function changes a map into a list of maps
  This is since the Table widget requires a list of maps
  and a graph only requires a map

  Example:
    {
      "A": "100",
      "E": "10",
      "F": "70",
    }
    turns into

    [
      {"Name": "A", "Value": "100"},
      {"Name": "E", "Value": "10"},
      {"Name": "F", "Value": "70"},
    ]
  */
  List<Map<String, String>> graphDataToTableData(Map<String, String> map) {
    List<Map<String, String>> tableData = [];

    map.keys.forEach((key) {
      tableData.add({"Name": key, "Value": map[key]});
    });
    return tableData;
  }

  //TEMPORARY DATA FOR TABLE
  // List<Map<String, String>> tableData = [
  //     {
  //       "Id": "1",
  //     "Name" : "Jason",
  //     "Age" : "20",
  //     "Title" : "Student",
  //     },

  //     {
  //       "Id": "2",
  //     "Name" : "Tomy",
  //     "Age" : "30",
  //     "Title" : "Teacher",
  //     },

  //     {
  //       "Id": "3",
  //     "Name" : "Adrian",
  //     "Age" : "29",
  //     "Title" : "Principle",
  //     },

  //     {
  //       "Id": "4",
  //     "Name" : "Andoid",
  //     "Age" : "21",
  //     "Title" : "Mechanic",
  //     },

  //     {
  //       "Id": "5",
  //     "Name" : "Sammy",
  //     "Age" : "19",
  //     "Title" : "Singer",
  //     },

  //     {
  //       "Id": "6",
  //     "Name" : "Boston",
  //     "Age" : "31",
  //     "Title" : "Student",
  //     },
  //   ];
  // edit(){
  //   Navigator.push(context, MaterialPageRoute(
  //     builder: (context) => EntityPage()
  //   ))
  // }

}
