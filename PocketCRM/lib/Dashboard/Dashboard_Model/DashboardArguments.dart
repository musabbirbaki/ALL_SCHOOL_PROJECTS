import 'package:firebase_auth/firebase_auth.dart';
import 'package:pocket_crm/Dashboard/Dashboard_Model/dashboard.dart';

class DashboardArguments{
  DashboardArguments({this.listOfDashboards, this.user});

  List<Dashboard> listOfDashboards;
  AuthResult user;
}