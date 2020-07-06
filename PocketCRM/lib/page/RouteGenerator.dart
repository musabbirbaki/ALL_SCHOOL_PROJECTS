import 'package:flutter/material.dart';
import 'package:pocket_crm/Dashboard/Dashboard_Model/DashboardArguments.dart';
import 'package:pocket_crm/page/InitializeDashboard.dart';
import 'package:pocket_crm/page/Login.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => LoginWidget());
      case '/Dashboard':
        DashboardArguments args = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => InitializeDashboard(
                listOfDashboards: args.listOfDashboards, user: args.user));
    }
  }
}
