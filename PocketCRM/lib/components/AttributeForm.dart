import 'package:flutter/material.dart';

class AttributeForm extends StatefulWidget {
  @override
  _AttributeFormState createState() => _AttributeFormState();
}

class _AttributeFormState extends State<AttributeForm> {
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> attribute = {};
  String dropdownValue = 'One';
  String _i = 'Text';

  @override
  Widget build(BuildContext context) {
    print('is this even getting reloaded');
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Attribute Name'),
                validator: (val) {
                  if (val.isEmpty) {
                    return 'The name of the attribute must be specified';
                  }
                  return null;
                },
                onSaved: (val) => attribute['key'] = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Attribute Value'),
                onSaved: (val) => attribute['value'] = val,
              ),
              DropdownButtonFormField(
                items: ['Text', 'Integer', 'Real'].map((i) {
                  return DropdownMenuItem(
                    value: i,
                    child: Text(i),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _i = newValue;
                    attribute['type'] = _i;
                  });
                },
                value: _i,
                hint: Text('Specify the data type of value'),
              ),
              FlatButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    Navigator.pop(context, attribute);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
