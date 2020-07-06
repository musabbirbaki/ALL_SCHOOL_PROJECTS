import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email;
  String imageURL;
  String name;
  DocumentReference reference;

  User(this.email, this.imageURL, this.name);

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['imageURL'] !=null),
        assert(map['email'] != null),
        assert(reference.documentID != null),
        this.email = map['email'],
        this.imageURL = map['imageURL'],
        this.name = map['name'];


  Map<String, dynamic> toMap() {
    return {
      'email': this.email,
      'name': this.name,
      'imageURL': this.imageURL,
    };
  }

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() {
    return 'Name{email: $email, name: $name, imageURL: $imageURL}';
  }
}
