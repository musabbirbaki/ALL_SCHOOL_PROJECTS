import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class User{
  String _name;
  String _email;

    setName(email) async {
    final docRef = Firestore.instance.document('users/$_email');
    DocumentSnapshot documentSnapshot = await docRef.get();
    this._name = '${documentSnapshot.data["name"]}';
  }

  User(this._email);

  getName(){
    return this._name;
  }

  getEmail(){
    return this._email;
  }
}