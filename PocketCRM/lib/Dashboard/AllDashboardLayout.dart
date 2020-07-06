import 'package:flutter/material.dart';
import 'package:pocket_crm/Dashboard/Query_DB_Model/QueryObjectLayout.dart';
import 'package:pocket_crm/Dashboard/Query_DB_Model/QueryObjectModel.dart';
import 'package:pocket_crm/page/DetailedDashboardPage.dart';
import 'package:pocket_crm/page/Drawer.dart';
import 'Dashboard_Model/dashboard.dart';
import 'SingleDashboardLayout.dart';

import 'package:firebase_auth/firebase_auth.dart';

/*
  This is the dashboard screen.
  This widget is the list of dashboards
*/

class AllDashboardLayout extends StatefulWidget {
  AllDashboardLayout({Key key, this.listOfDashboards, this.user})
      : super(key: key);

  final List<Dashboard> listOfDashboards;
  AuthResult user;

  @override
  _AllDashboardLayoutState createState() => _AllDashboardLayoutState();
}

class _AllDashboardLayoutState extends State<AllDashboardLayout> {
  String dashboardType;
  Dashboard tempNewDashboard;

  Dashboard selectedDashboard;

  @override
  void initState() {
    print("(All Queries Layout:) Entered All Dashboard widget build.");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print('cannot go back.');
      },
      child: Scaffold(
        appBar: AppBar(
          // title: Text(widget.title),
          backgroundColor: Colors.orange,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                print("(All Queries Layout:) Add to Queries");
                tempNewDashboard = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateQueryObjectUI(),
                      fullscreenDialog: true),
                );

                if (tempNewDashboard != null) {
                  // print("(All Queries Layout:) List of Old Dashboards: ${widget.listOfDashboards}");
                  print("(All Queries Layout:) Adding: ${tempNewDashboard}");
                  widget.listOfDashboards.add(tempNewDashboard);
                  // print("(All Queries Layout:) List of New Dashboards: ${widget.listOfDashboards}");
                  setState(() {});
                } else {
                  print("(All Queries Layout:) ${tempNewDashboard}");
                }
              },
            ),

            IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () async {
                // print("(All Queries Layout:) Delete All Queries.");
                // deleteAllQueries();
                deleteSelectedQuery();
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => CreateQueryObjectUI(), fullscreenDialog: true),
                // );
              },
            ),

            // Card(
            //   // elevation: 100,
            //   borderOnForeground: true,
            //   child: InkWell(
            //     onTap: (){
            //       print("Customize My Dashboard!!");
            //     },

            //     child: Container(
            //       color: Colors.orange[100],
            //       padding: EdgeInsets.only(top: 4, left: 10, right: 10),
            //       child: Text(
            //         "Customize Dashboard",
            //         style: TextStyle(height: 1.65, fontSize: 20),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),

        //List Each Dasboard
        body: Container(
            color: Colors.orange[50],
            child: ListView.separated(
              padding: const EdgeInsets.all(8.0),
              itemCount: widget.listOfDashboards.length < 1
                  ? 0
                  : widget.listOfDashboards.length,
              itemBuilder: (BuildContext context, int index) {
                if (widget.listOfDashboards.length < 1) {
                  return Container(
                    child: Text("Nothing to Show :o"),
                  );
                }

                //if this dashboard isn't a graph, show simple List Tile
                if (!widget.listOfDashboards[index].isGraph) {
                  return Container(
                    width: 600,
                    // color: Colors.orange[100],
                    child: Card(
                        child: InkWell(
                      onLongPress: () {
                        selectedDashboard = widget.listOfDashboards[index];
                      },
                      onDoubleTap: () {
                        // print(index);
                        // print("Dashboard ID: ${widget.listOfDashboards[index].id}");
                        // print("Dashboard Title: ${widget.listOfDashboards[index].graphTitle}");

                        showDashboardDetails(widget.listOfDashboards[index]);
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Center(
                            child: Text(
                          widget.listOfDashboards[index].graphTitle,
                          style: TextStyle(fontSize: 25),
                        )),
                      ),
                    )),
                    // child: ListTile(
                    //   title: Text(widget.listOfDashboards[index].graphTitle, style: TextStyle(fontSize: 25),),
                    // ),
                  );
                }

                return Container(
                  width: 600,
                  // height: 430,
                  child: Center(
                      child: Card(
                          child: InkWell(
                    onLongPress: () {
                      selectedDashboard = widget.listOfDashboards[index];
                    },
                    onDoubleTap: () {
                      // print(index);
                      // print("Dashboard ID: ${widget.listOfDashboards[index].id}");
                      // print("Dashboard Title: ${widget.listOfDashboards[index].graphTitle}");

                      showDashboardDetails(widget.listOfDashboards[index]);
                    },
                    child: DashboardLayout(
                      dashboard: widget.listOfDashboards[index],
                    ),
                  ))),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                      // color: Colors.grey,
                      // thickness: 4.0,
                      ),
            )),

        //Add Drawer code
        drawer: drawer(context, widget.user),
      ),
    );
  }

  /*
  This function is called when double clicked on a dashboard.
  */
  void showDashboardDetails(Dashboard dashboard) {
    print("(All Queries Layout:) Dashboard ID: ${dashboard.id}");
    print("(All Queries Layout:) Dashboard Title: ${dashboard.graphTitle}");

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailedDashBoardPage(
            dashboard: dashboard,
          ),
        ));
  }

  /*
    This function deletes all queries.
  */
  // void deleteAllQueries(){
  //   QueryObjectModel qbm = QueryObjectModel();
  //   Future<void> f = qbm.deleteAllQueries();
  //   setState(() {
  //     print("All Queries Layout: Set state after delete.");
  //   });
  // }

  //Dashboard deletes selected Query in dashboard
  void deleteSelectedQuery() {
    QueryObjectModel qbm = QueryObjectModel();
    qbm.deleteQueryObjectById(selectedDashboard.id);
    widget.listOfDashboards.remove(selectedDashboard);
    print("(All Queries Layout:) Deleted ${selectedDashboard.graphTitle}");
    setState(() {});
  }
}
