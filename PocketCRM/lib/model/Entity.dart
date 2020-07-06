import 'package:cloud_firestore/cloud_firestore.dart';

class Entity {
  int id;
  DocumentReference reference;
  Map<String, dynamic> attributes = {};
  String s = '{}';

  // Entity c2 = Entity(2, {'Name': 'Musabbir', 'Age': 24});
  Entity(this.id, this.attributes);

  Entity.fromMap(Map<String, dynamic> map, [this.reference]) {
    this.id = map['id'];
    this.attributes = map;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> att = this.attributes;
    id = this.id;
    return att;
  }

  Entity.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, snapshot.reference);

  @override
  String toString() {
    String s = "";
    s += 'Entity: ';
    attributes.forEach((k, v) {
      s += '$k: $v';
    });
    return s;
  }
}
