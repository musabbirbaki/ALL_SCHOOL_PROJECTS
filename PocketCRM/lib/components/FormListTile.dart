import 'package:flutter/material.dart';

class FormListTile extends StatefulWidget {
  final String _key;
  final Map _attrMap;
  FormListTile(this._key, this._attrMap);
  @override
  _FormListTileState createState() =>
      _FormListTileState(this._key, this._attrMap);
}

class _FormListTileState extends State<FormListTile> {
  Map _attrMap;
  String _key;
  _FormListTileState(this._key, this._attrMap);

  var input;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: '${_attrMap[_key]}',
      onChanged: (v) => _attrMap[_key] = v,
      onEditingComplete: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        print('$_attrMap');
      },
    );
  }
}
