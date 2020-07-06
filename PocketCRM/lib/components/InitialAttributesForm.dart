import 'package:flutter/material.dart';

class InitialAttributes extends StatefulWidget {
  @override
  _InitialAttributesState createState() => _InitialAttributesState();
}

class _InitialAttributesState extends State<InitialAttributes> {
  int attrCount = 1;
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> attrList = [];
  Map attrMap = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Attributes'),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView.builder(
            itemCount: attrCount + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == attrCount) {
                return FractionallySizedBox(
                  widthFactor: 0.65,
                  child: FlatButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () async {
                      setState(() {
                        attrCount += 1;
                      });
                    },
                    child: Text('Add New Attribute'),
                  ),
                );
              }
              return ListTile(
                title: TextFormField(
                  decoration: InputDecoration(labelText: 'Attribute name'),
                  onSaved: (val) {
                    attrList.add({'name': val});
                  },
                ),
                trailing: index == 0
                    ? IconButton(
                        icon: Icon(Icons.ac_unit),
                        onPressed: () {},
                        color: Colors.transparent,
                      )
                    : IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            attrCount -= 1;
                          });
                        },
                      ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            // print(attrList);

            Navigator.pop(context, attrList);
          }
        },
      ),
    );
  }
}
