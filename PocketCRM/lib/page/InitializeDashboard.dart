import 'package:flutter/material.dart';
import 'package:pocket_crm/Dashboard/Dashboard_Model/dashboard.dart';
import 'package:pocket_crm/Dashboard/AllDashboardLayout.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InitializeDashboard extends StatefulWidget {
  InitializeDashboard({Key key, this.user, this.listOfDashboards})
      : super(key: key);

  final AuthResult user;
  final List<Dashboard> listOfDashboards;

  @override
  InitializeDashboardState createState() => InitializeDashboardState();
}

class InitializeDashboardState extends State<InitializeDashboard> {
  @override
  void initState() {
    print("Calling AllDashboardLayout (InitializeDashboardState).");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AllDashboardLayout(
      listOfDashboards: widget.listOfDashboards,
      user: widget.user,
    );
  }
}
