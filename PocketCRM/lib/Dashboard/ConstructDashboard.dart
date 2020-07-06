import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pocket_crm/Dashboard/Dashboard_Model/DashboardArguments.dart';
import 'package:pocket_crm/Dashboard/Dashboard_Model/dashboard.dart';
import 'package:pocket_crm/Dashboard/Query_DB_Model/QueryObject.dart';
import 'package:pocket_crm/Dashboard/Query_DB_Model/QueryObjectModel.dart';
import 'package:pocket_crm/model/EntityModel.dart';
import 'package:pocket_crm/page/InitializeDashboard.dart';

class ConstructDashBoard {
  static void createGetDashboardAndNavigateToDashboard(
      BuildContext context, AuthResult user) {
    QueryObjectModel _modelQueryObject = QueryObjectModel();
    EntityModel _modelEntity = EntityModel();
    List<QueryObject> queryObjects = [];
    // List<Map<String, String>> queryData = [];
    List<Dashboard> listOfDashboards = [];

    _modelQueryObject.getAllQueryObjects().then((qos) {
      qos.forEach((queryObject) {
        print("inside null${queryObject == null}");
        //Saving all query Objects
        // print("Dashboard Query ${queryObject.id}: ${queryObject.query}");
        queryObjects.add(queryObject);
      });
    }).whenComplete(() {
      //Gettin all entity Information using query objects
      // List<Dashboard> listOfDashboards = [];

      //Check if there is any query to show in dashboard
      if (queryObjects.length > 0) {
        Future(() {
          queryObjects.forEach((query) {
            _modelEntity.runCustomEntityQuery(query.query).then((data) {
              //QueryResultSet ---> List<Map<String, String>>
              List<Map<String, String>> dd = queryResultSetToMap(data);
              // print("Entity Query: $dd");
              // print(dd.runtimeType);

              Dashboard dash;
              if (query.chartType == "None") {
                //Create a table
                dash = Dashboard(
                  id: query.id,
                  graphTitle: query.title,
                  isGraph: false,
                  tableData: dd,
                );

                // print(dash);
                listOfDashboards.add(dash);
                // print("${listOfDashboards.length} --- ${queryObjects.length}");

                if (listOfDashboards.length == queryObjects.length) {
                  listOfDashboards.forEach(print);
                  print("Navigating from Login to Dashboard Screen.");
                  // Navigator.of(context).pushNamed(
                  //   '/Dashboard',
                  //   arguments: DashboardArguments(listOfDashboards: listOfDashboards, user: user)
                  // );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: RouteSettings(name: "/Dashboard"),
                        builder: (context) => InitializeDashboard(
                            listOfDashboards: listOfDashboards, user: user)),
                  );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => InitializeDashboard(listOfDashboards: listOfDashboards, user: user)),
                  // );
                }
              } else {
                //create a chart
                dash = Dashboard.createDashboardUsingData(
                  query.id,
                  query.title,
                  query.chartType,
                  listOfMapToMap(dd),
                  query.chartType != "None",
                  dd,
                );

                // print(dash);
                listOfDashboards.add(dash);
                // print("${listOfDashboards.length} --- ${queryObjects.length}");

                if (listOfDashboards.length == queryObjects.length) {
                  listOfDashboards.forEach(print);
                  print("Navigating to Dashboard Screen.");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        settings: RouteSettings(name: "/Dashboard"),
                        builder: (context) => InitializeDashboard(
                            listOfDashboards: listOfDashboards, user: user)),
                  );

                  // Navigator.of(context).pushNamed(
                  //   '/Dashboard',
                  //   arguments: DashboardArguments(listOfDashboards: listOfDashboards, user: user)
                  // );
                }
              }
            });
          });

          return listOfDashboards;
        });
      } else {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => InitializeDashboard(listOfDashboards: listOfDashboards, user: user)),
        // );

        // Navigator.of(context).pushNamed(
        //   '/Dashboard',
        //   arguments: DashboardArguments(listOfDashboards: listOfDashboards, user: user)
        // );

        Navigator.push(
          context,
          MaterialPageRoute(
              settings: RouteSettings(name: "/Dashboard"),
              builder: (context) => InitializeDashboard(
                  listOfDashboards: listOfDashboards, user: user)),
        );
      }
    });
  }

  /*
    This function converts QueryResultSet into a List<Map<String, String>>
  */
  static List<Map<String, String>> queryResultSetToMap(qrs) {
    List<Map<String, String>> returnVal = [];
    qrs.forEach((Map<String, dynamic> qr) {
      Map<String, String> mp = {};

      qr.keys.forEach((key) {
        mp[key.toString()] = qr[key].toString();
      });

      returnVal.add(mp);
    });

    return returnVal;
  }

  /*
  List<Map<String, String>> ===> Map<String, String>
  */
  static Map<String, String> listOfMapToMap(List<Map<String, String>> listMap) {
    Map<String, String> map = {};
    listMap.forEach((Map<String, String> m) {
      // map.addAll(m);
      map[m[m.keys.first.toString()]] = m[m.keys.last];
    });
    // print(map);

    return map;
  }

  /*
    This function creates a dashboard using a QueryObject
  */
  static Dashboard createDashboard(
      QueryObject query, List<Map<String, String>> dd) {
    print("Entered Create Dashboard function in Construct Dashboard Class.");

    Dashboard dash;
    if (query.chartType == "None") {
      //Create a table
      dash = Dashboard(
        id: query.id,
        graphTitle: query.title,
        isGraph: false,
        tableData: dd,
      );
      return dash;
    } else {
      //create a chart
      dash = Dashboard.createDashboardUsingData(
        query.id,
        query.title,
        query.chartType,
        listOfMapToMap(dd),
        query.chartType != "None",
        dd,
      );
      return dash;
    }
  }
}
