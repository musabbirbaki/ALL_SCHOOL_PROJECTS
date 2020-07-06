import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket_crm/AppUser/registerAppUser.dart';
import 'package:pocket_crm/Dashboard/ConstructDashboard.dart';
import 'package:pocket_crm/main.dart';

import 'package:pocket_crm/model/User.dart';

//Firebase Auth import
import 'package:firebase_auth/firebase_auth.dart';

import 'AppLocalizations.dart';

class LoginWidget extends StatefulWidget {
  // LoginWidget({
  //   Key key,
  //   this.username,
  //   this.password,
  // }) : super(key: key);

  LoginWidget({
    Key key,
    // this.username,
    // this.password,
  }) : super(key: key);

  // String username, password;

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool showLogo = true;
  String _username, _password;
  static User s;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool validEmail = true, validPassword = true;

  AuthResult user;

  @override
  Widget build(BuildContext context) {
    final myControllerUser = TextEditingController();
    final myControllerPassword = TextEditingController();
    // void dispose() {
    //   // Clean up the controller when the widget is disposed.
    //   myControllerUser.dispose();
    //   myControllerPassword.dispose();
    //   super.dispose();
    // }
    SystemChrome.setEnabledSystemUIOverlays([]);
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

    return Scaffold(
      drawerEdgeDragWidth: 0.0,
      backgroundColor: Colors.orange,
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Center(
                child: Column(children: [
              //Logo
              GestureDetector(
                //FOR DEBUGING REMOVE-------------------------------------------------------------------------
                onTap: () => offlineLogin(user),

                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 85, 0, 15.0),
                  child: showLogo
                      ? ImageWidget(
                          size: 300,
                        )
                      : ImageWidget(size: 40),
                ),
              ),

              //Username Field
              Container(
                padding: EdgeInsets.fromLTRB(45, 20, 45, 20),
                color: Colors.white,
                child: TextFormField(
                  validator: (input) {
                    print("Runs validator");
                    if (input.isEmpty) {
                      return 'Please provide an email.';
                    }
                    // else if(!validUser){
                    //   return "Invalid User.";
                    // }else if(!validEmail){
                    //   return "Invalid Email.";
                    // }
                    else {
                      return null;
                    }
                  },
                  onSaved: (input) {
                    _username = input;
                  },
                  controller: myControllerUser,
                  onTap: () {
                    //makes image smaller on tap
                    if (showLogo == true) {
                      setState(() {
                        showLogo = false;
                      });
                    }
                  },
                  style: style,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Username",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0))),
                ),
              ),

              //Password field
              Container(
                padding: EdgeInsets.fromLTRB(45, 0, 45, 20),
                color: Colors.white,
                child: TextFormField(
                  validator: (String input) {
                    if (input.length < 0) {
                      return 'Please provide a valid password.';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (input) {
                    _password = input;
                  },
                  obscureText: true,
                  controller: myControllerPassword,
                  onEditingComplete: () {
                    FocusScope.of(context)
                        .requestFocus(FocusNode()); //Keyboard is put away
                  },
                  style: style,
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0))),
                ),
              ),

              //Signin and Register buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //SignIn button
                  RaisedButton(
                    color: Colors.white,
                    textColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      _username = myControllerUser.text;
                      _password = myControllerPassword.text;
                      print(_username);
                      print(_password);
                      signIn(context);
                    },
                    child: Text(
                      AppLocalizations.of(context).translate('login_string'),
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),

                  //Register button
                  RaisedButton(
                    color: Colors.white,
                    textColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueAccent,
                    onPressed: () {
                      print("Navigating to Registration Button.");
                      appUserRegistration();
                    },
                    child: Text(
                      AppLocalizations.of(context).translate('register_string'),
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                ],
              ),
            ]))),
      ),
    );
  }

  void offlineLogin(AuthResult user) {
    // final formState = _formKey.currentState;
    // print("Sign In method runing.");
    // if(formState.validate()){
    //   print("State Valid.");

    //   //Login to firebase
    //   formState.save();
    //   Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => InitializeDashboard(user: user)),
    //       );
    // }
    ConstructDashBoard.createGetDashboardAndNavigateToDashboard(context, user);
  }

  /*
  This function handles the Sign-out to fireBase authentication. This runs when the sign out button is clicked.
  */

  /*
    This function handles the Sign-in to firebase authentication. This runs when sign in button is pressed.
  */
  Future<void> signIn(context) async {
    final formState = _formKey.currentState;
    print("Sign In method runing.");
    s = User(user.user.email);
    if (formState.validate()) {
      print("State Valid.");

      //Login to firebase
      formState.save();

      try {
        print("Trying Firebase with Email and Pass.");
        user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _username, password: _password);
        //enter dashboard if validated
        print("Logged into: ${user.user.email}");
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => InitializeDashboard(user:user)),
        //   /*
        //   final FirebaseUser appUser = user.user;
        //   appUser.email
        //   */
        // );
        ConstructDashBoard.createGetDashboardAndNavigateToDashboard(
            context, user);
      } catch (e) {
        if (e.toString().contains("ERROR_INVALID_EMAIL")) {
          //Wrong Password
          setState(() {
            validEmail = false;
            validPassword = true;
          });
        } else if (e.toString().contains("ERROR_WRONG_PASSWORD")) {
          //User not found please register
          setState(() {
            validPassword = false;
            validEmail = true;
          });
        }
      }
      if (!validEmail) {
        print('User does not exist');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("The email you entered is invalid"),
              content: new Text("Please try again or Register for an account."),
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
      } else if (!validPassword) {
        print('Password is invalid');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("The password you entered is invalid"),
              content: new Text("Please try again."),
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
  }

  /*
    This method is run when the registration button is pressed.
  */
  void appUserRegistration() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RegisterAppUserUI(), fullscreenDialog: true),
    );
  }
}

class ImageWidget extends StatefulWidget {
  ImageWidget({this.size});

  final double size;

  @override
  ImageWidgetState createState() => ImageWidgetState();
}

class ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/logo.png",
      height: widget.size,
      fit: BoxFit.fill,
    );
  }
}

Future<void> signOut(context) async {
  print('Sign Out method running.');
  FirebaseAuth.instance.signOut();
  //print('$user');
  // // MaterialPageRoute(builder: (context) => LoginWidget());
  Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MyApp()),
  );
  // main();
  // Navigator.of(context).popUntil((route) => route.settings.name == "LoginWidget");
}
