import 'package:flutter/material.dart';
import 'package:pocket_crm/model/EntityModel.dart';

class Testfrom extends StatefulWidget {
  @override
  _TestfromState createState() => _TestfromState();
}

class _TestfromState extends State<Testfrom> {
  var _mode = EntityModel();
  TextEditingController txt = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
          child: Column(
        children: <Widget>[
          TextFormField(
            controller: txt,
          ),
          FlatButton(
            onPressed: () async => _mode.query(txt.text),
            child: Text('run query'),
          )
        ],
      )),
    );
  }
}
