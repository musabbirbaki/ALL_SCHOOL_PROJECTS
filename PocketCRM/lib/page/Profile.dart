import 'package:flutter/material.dart';

import 'AppLocalizations.dart';
import 'Drawer.dart';
import 'dart:io';
import 'package:image_picker_modern/image_picker_modern.dart';
import 'dart:async';
import 'package:path/path.dart' as Path;
import 'package:pocket_crm/AppUser/registerAppUser.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final databaseReference = Firestore.instance;

String _account = "";
String _name = "";
File imageFile;
String _uploadedFileURL;

// void readUser(_account, _name, _imageURL){
//   databaseReference
//       .collection("users")
//       .getDocuments()
//       .then((QuerySnapshot snapshot) {
//     snapshot.documents.forEach((f) => print('${f.data}}'));
//   });
// }

class ProfileWidget extends StatefulWidget {
  ProfileWidget(this.user);

  AuthResult user;

  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  DataUpdate dataUpdate;
  // GetCloud getCloud;

  void initState() {
    super.initState();
    dataUpdate = DataUpdate(
        context: context,
        email: widget.user.user.email,
        imageURL: _uploadedFileURL);
    // getCloud = GetCloud(context:context);
  }

  _openGallery(BuildContext context) async {
    // var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      // imageFile = picture;
      uploadFile();
    });
    Navigator.of(context).pop();
    dataUpdate.updateData();
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profilePictures/${Path.basename(imageFile.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(imageFile);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

  getName(email) async {
    final docRef = Firestore.instance.document('users/$email');
    DocumentSnapshot documentSnapshot = await docRef.get();
    _name = '${documentSnapshot.data["name"]}';
  }

  @override
  Widget build(BuildContext context) {
    double widthmax = MediaQuery.of(context).size.width;
    getName(widget.user.user.email);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
          child: Column(
        children: [
          Material(
            elevation: 4.0,
            clipBehavior: Clip.antiAlias,
            child: Container(
              color: Colors.redAccent,
              height: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 80),
                    child: Material(
                        elevation: 4.0,
                        shape: CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: ProfilePicWidget()),
                  ),
                ],
              ),
            ),
          ),
          Row(children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Text(
                // '$_account',
                widget.user.user.email,
                textAlign: TextAlign.center,
              ),
            ),
          ]),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  '$_name',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: widthmax,
                child: FlatButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text(AppLocalizations.of(context)
                              .translate('gallery_message')),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text(AppLocalizations.of(context)
                                  .translate('gallery_button')),
                              onPressed: () {
                                Navigator.of(context).pop();
                                _openGallery(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('change_pic'),
                  ),
                ),
              )
            ],
          ),
        ],
      )),
      drawer: drawer(context, widget.user),
    );
  }
}

class ProfilePicWidget extends StatefulWidget {
  @override
  ProfilePicWidgetState createState() => ProfilePicWidgetState();
}

class ProfilePicWidgetState extends State<ProfilePicWidget> {
  @override
  Widget build(BuildContext context) {
    if (_uploadedFileURL == null) {
      print("uploadedFileURL");
      return Container(
          width: 190.0,
          child: Center(
              child:
                  Text(AppLocalizations.of(context).translate('pic_message'))));
    } else {
      return Container(
        width: 190.0,
        child: Center(
          child: Container(
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(_uploadedFileURL),
              ),
            ),
          ),
        ),
      );
    }
  }
}
