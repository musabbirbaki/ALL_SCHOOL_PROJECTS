import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JoinedPage extends StatelessWidget {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.tealAccent[700],
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Joined Events"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("lib/resources/place1.jpeg"),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Location: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Ottawa University\n 75 Laurier Ave E. Ottawa ON K1N 6N5",
                    ),
                  ],
                ),
                Divider(
                  //thickness: 1,
                  color: Colors.black,
                  indent: 20,
                  endIndent: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Requested: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Jon Perry",
                    ),
                  ],
                ),
                Divider(
                  //thickness: 1,
                  color: Colors.black,
                  indent: 20,
                  endIndent: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "When: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "1:30 PM \nNovember 2 2019",
                    ),
                  ],
                ),
                Divider(
                  //thickness: 1,
                  color: Colors.black,
                  indent: 20,
                  endIndent: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Disclaimer: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Children Under 12 must be supervised at all \ntimes by a responsible adult." +
                          " Responsible adult\nmust at least 18 years of age",
                    ),
                  ],
                ),
                Divider(
                  //thickness: 1,
                  color: Colors.black,
                  indent: 20,
                  endIndent: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "What to bring: ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("-Gloves\n-Garbage\n"),
                ),
                Image.asset(
                  "lib/resources/going.png",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 180,
                      child: RaisedButton(
                        child: Text("CONTACT ORGANIZER"),
                        color: Colors.cyan,
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      width: 180,
                      child: RaisedButton(
                        child: Text("SHARE"),
                        color: Colors.cyan,
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        child: Text("UNJOIN"),
                        color: Colors.tealAccent[700],
                        textColor: Colors.white,
                        onPressed: () {
                          final snackBar = SnackBar(
                            elevation: 6.0,
                            backgroundColor: Colors.tealAccent[700],
                            //behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 1),
                            content: Text(
                              "UNJOINED",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18),
                            ),
                          );
                          debugPrint("Unjoin clicked");
                          _scaffoldKey.currentState.showSnackBar(snackBar);
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
