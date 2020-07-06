import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket_crm/page/Drawer.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pocket_crm/components/LocalNotification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


final databaseReference = Firestore.instance;

class RegisterAppUserUI extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => RegisterAppUserUIState();


}

class RegisterAppUserUIState extends State<RegisterAppUserUI>{
  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
LocalNotification localNotification;

  String _email, _password, _name;
  String _imageURL = 'null';
  bool emailInUse, emailInvalid = false;

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    localNotification = LocalNotification(context: context, title: "Enjoying PocketCRM?", subtitle:"Please give us an A! Thank you -PocketCRM team");
  }
  
  @override
  Widget build(BuildContext context) {
      
    // SystemChrome.setEnabledSystemUIOverlays([]);
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
    return Scaffold(
        // drawer: drawer(context),
        appBar: AppBar(
          title: Text('Welcome'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
              child: Center(
                child: Column(children: [

                  Container(
                    padding: EdgeInsets.all(40),
                    child: Text("Please fill in valid information to register.",
                    style: TextStyle(fontSize: 25)),
                  ),

                  //Username Field
                  Container(
                    padding: EdgeInsets.fromLTRB(45, 20, 45, 20),
                    color: Colors.white,
                    child: TextFormField(
                      validator: (input){
                        print("Runs validator");
                        if(input.isEmpty){
                          return 'Please provide an email.';
                        }else if(!input.contains("@")){
                          return 'Invalid Email';
                        }
                        else{
                          return null;
                        }
                      },
                      onSaved: (input){
                        _email = input;
                      },
                      
                      style: style,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Username",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)
                          )
                      ),
                    ),
                  ),
                  
                  //Password field
                  Container(
                    padding: EdgeInsets.fromLTRB(45, 0, 45, 20),
                    color: Colors.white,
                    child: TextFormField(
                      validator: (String input){
                        if(input.length < 6){
                          return 'The password must be at least 6 characters long';
                        }else{
                          return null;
                        }
                      },
                      onSaved: (input){
                        _password = input;
                      },
                      // obscureText: true,
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(FocusNode());//Keyboard is put away
                      },
                      style: style,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(45, 0, 45, 20),
                    color: Colors.white,
                    child: TextFormField(
                      validator: (String input){
                        if(input.length <= 0){
                          return 'Please enter your name';
                        }else{
                          return null;
                        }
                      },
                      onSaved: (input){
                        _name = input;
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(FocusNode());//Keyboard is put away
                      },
                      style: style,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                    ),
                  ),

                  // Container(
                  //   padding: EdgeInsets.fromLTRB(45, 0, 45, 20),
                  //   color: Colors.white,
                  //   child: Text("Re-Type Password:"),
                  // ),

                  //Retye Password field
                  // Container(
                  //   padding: EdgeInsets.fromLTRB(45, 0, 45, 20),
                  //   color: Colors.white,
                  //   child: TextFormField(
                  //     validator: (String input){
                  //       if(input != _password){
                  //         return 'Passwords do not match';
                  //       }                                
                  //       else{
                  //         return null;
                  //       }
                  //     },
                  //     onSaved: (input){
                  //       _retypePassword = input;
                  //     },
                  //     obscureText: true,
                  //     onEditingComplete: () {
                  //       FocusScope.of(context).requestFocus(FocusNode());//Keyboard is put away
                  //     },
                  //     style: style,
                  //     decoration: InputDecoration(
                  //         contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  //         hintText: "Re-type Password",
                  //         border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(32.0))),
                  //   ),
                  // ),

                  RaisedButton(
                    color: Colors.white,
                    textColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      print("Navigating to Registration Button.");
                      appUserRegistration(context);
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),

            ]
          ))
          ),
        ),
      );
  }

  void appUserRegistration(context) async{
    if (saveVal()){
      try {
        AuthResult user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
        createUser(_name, _email, _imageURL);
        Navigator.pop(context);
        localNotification.showNotification();
        }catch (e) {
        print('Error: $e');
          print(e.code); // can access the code here
          if(e.code.toString() == 'ERROR_EMAIL_ALREADY_IN_USE') {
            emailInUse = true;
          } else if(e.code.toString() == 'ERROR_INVALID_EMAIL') {
            emailInvalid= true;
          }
        }
        if(emailInUse){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Email already in use"),
                content: new Text("The email you entered is already registered with an account. Please use a different"),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        //refresh
                      });
                    },
                  ),
                ],
              );
            },
          );
        } else if(emailInvalid){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text("Email entered is invalid"),
                content: new Text("The email you entered is not of a valid domain, please enter a valid email address"),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        //refresh
                      });
                    },
                  ),
                ],
              );
            },
          );
        }
        
      }
      // }catch(e){
      //   if(e.code.toString() == 'ERROR_EMAIL_ALREADY_IN_USE') {
      //     print("the email is already in use");
      //   }else {
      //     print("an unknown error has occurred while registering username and password");
      //   }
      // }
    
      
    // print("${this._email}, ${this._password}, ${this._retypePassword}");
  }

  bool saveVal(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }
}

void createUser(_name, _email, _imageURL) async {
  await databaseReference.collection("users")
      .document('$_email') //set the document reference id to the email
      .setData({
        'email': '$_email',
        'name': '$_name',
        'imageURL': '$_imageURL'
      });
      //The below code generates a random document reference ID
  // DocumentReference ref = await databaseReference.collection("users")
  //     .add({
  //       'email': '$_email',
  //       'name': '$_name',
  //       'imageURL': '$_imageURL'
  //     });
  // print(ref.documentID);
}

class DataUpdate {
  DataUpdate({this.context, this.imageURL, this.email});
  BuildContext context;
  String imageURL;
  String email;
  //doesnt seem to be working correctly, or im calling it wrong
  updateData() async {
    await databaseReference
        .collection('users')
        .document(email)
        .updateData({'imageURL': imageURL});
        print("$email, $imageURL");
  }
}

// class GetCloud {
//   GetCloud({this.context});
//   BuildContext context;

//     Future<String> getImageURL() async {
//     DocumentSnapshot snapshot = await Firestore.instance.collection('users').document('imageURL').get();
//     var imageLink = snapshot['imageLink'];
//     if (imageLink is String) {
//       return imageLink;
//     }
//   }
// }