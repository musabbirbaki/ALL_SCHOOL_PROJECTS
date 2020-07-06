import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pocket_crm/FirebaseUtils/firebaseUtils.dart';
import 'package:pocket_crm/page/TablePage.dart';
import 'package:pocket_crm/page/Profile.dart';
import 'Login.dart';
import 'AppLocalizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pocket_crm/model/User.dart';

Widget drawer(BuildContext context, AuthResult user) {
  //Drawer
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          currentAccountPicture: FlutterLogo(),
          accountName: Text('John Doe'),
          accountEmail: Text('test@example.com'),
        ),
        ListTile(
          title:
              Text(AppLocalizations.of(context).translate('drawer_dashboard')),
          onTap: () {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.popUntil(context, ModalRoute.withName('/Dashboard'));
              // Navigator.of(context).popUntil((route) => route.settings.name == "Dashboard");
            });

            // Navigator.pop(context);
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => InitializeDashboard(user:user)
            //     ));
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).translate('drawer_tables')),
          onTap: () {
            //navigate to Entity
            //tryo to pop unitl dashboard and then push tablepage
            Navigator.popUntil(context, ModalRoute.withName('/Dashboard'));
            // Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TablePage(user)));
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).translate('drawer_profile')),
          onTap: () {
            //navigate to Profile

            Navigator.popUntil(context, ModalRoute.withName('/Dashboard'));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileWidget(user)),
            );
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).translate('drawer_logout')),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: new Text("Are you sure you want to Logout?"),
                  content: new Text("Your session will exit."),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new FlatButton(
                      child: new Text("Logout"),
                      onPressed: () async {
                        var _fireUtils = FireBaseUtils();
                        _fireUtils.pushData(user);
                        signOut(context);
                        Navigator.of(context).pop();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => LoginWidget()),
                        // );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    ),
  );
}
