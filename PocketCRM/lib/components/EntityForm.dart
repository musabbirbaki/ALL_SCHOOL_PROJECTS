import 'package:flutter/material.dart';
import 'package:pocket_crm/model/EntityModel.dart';

class EntityForm extends StatefulWidget {
  final String entityName;
  EntityForm({this.entityName});
  @override
  _EntityFormState createState() => _EntityFormState(this.entityName);
}

class _EntityFormState extends State<EntityForm> {
  // static String tableName = '';
  final _formKey = GlobalKey<FormState>();

  _EntityFormState(this.tbName);
  String tbName;
  // Entity _Entity = Entity(id, attributes);
  Map<String, dynamic> attributes = {};
  EntityModel _model;

  void getAttributesName() async {
    attributes = await _model.getColumnNames();
    print(attributes);
  }

  @override
  void initState() {
    _model = EntityModel(tbName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getAttributesName();
    print(attributes);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entityName),
      ),
      body: FutureBuilder(
        future: _model.getColumnNames(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            attributes = snapshot.data;
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView.builder(
                  itemCount: attributes.length,
                  itemBuilder: (context, index) {
                    String attrKey = attributes.keys.elementAt(index);
                    return TextFormField(
                      decoration: InputDecoration(labelText: attrKey),
                      // initialValue: Entity.keys[index],
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'The name of the attribute must be specified';
                        }
                        return null;
                      },
                      onSaved: (val) => attributes[attrKey] = val,
                    );
                  },
                ),
              ),
            );
          } else {
            return LinearProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            Navigator.pop(context, attributes);
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
