import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:foodspace/helper/helper_functions.dart';
import 'package:foodspace/pages/selectcity_page.dart';
import 'package:foodspace/services/auth_service.dart';
import 'package:foodspace/services/database_service.dart';
import 'package:foodspace/shared/constants.dart';
import 'package:foodspace/shared/loading.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {

  final Function toggleView;
  SignInPage({
    this.toggleView
  });

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      resizeToAvoidBottomPadding: false,
      body: CustomPaint(
      painter: MyPainter(),
      child: Form(
      key: _formKey,
      child: Container(
        //color: Colors.red,
        //margin: EdgeInsets.only(top: 70.0),
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Welcome to Foodspace", style: TextStyle(color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold)),

            SizedBox(height: 30.0),

            Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 25.0)),

            SizedBox(height: 20.0),

            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: textInputDecoration.copyWith(labelText: 'Email'),
              validator: (val) {
                return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Please enter a valid email";
              },
              onChanged: (val) {
                setState(() {
                  email = val;
                });
              },
            ),

            SizedBox(height: 15.0),

            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: textInputDecoration.copyWith(labelText: 'Password'),
              validator: (val) => val.length < 6 ? 'Password not strong enough' : null,
              obscureText: true,
              onChanged: (val) {
                setState(() {
                  password = val;
                });
              },
            ),

            SizedBox(height: 20.0),

            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: RaisedButton(
                elevation: 0.0,
                color: Colors.green[400],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                child: Text('Sign In', style: TextStyle(color: Colors.white, fontSize: 16.0)),
                // onPressed: () {},
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    setState(() {
                      loading = true;
                    });

                    await _auth.signInWithEmailAndPassword(email, password).then((result) async {
                      if(result != null) {
                        QuerySnapshot userInfoSnapshot = await DatabaseService().getUserData(email);

                        HelperFunctions.saveUserLoggedInSharedPreference(true);
                        HelperFunctions.saveUserEmailSharedPreference(email);
                        HelperFunctions.saveUserNameSharedPreference(
                          userInfoSnapshot.documents[0].data['fullName']
                        );

                        print("Signed In");
                        await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
                          print("Logged in: $value");
                        });
                        await HelperFunctions.getUserEmailSharedPreference().then((value) {
                          print("Email: $value");
                        });
                        await HelperFunctions.getUserNameSharedPreference().then((value) {
                          print("Full Name: $value");
                        });

                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => SelectCityPage()), (Route<dynamic> route) => false);
                      }
                      else {
                        setState(() {
                          error = 'Error signing in!';
                          loading = false;
                        });
                      }
                    });
                  }
                }
              ),
            ),

            SizedBox(height: 10.0),

            Text.rich(
              TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(color: Colors.white, fontSize: 14.0),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Register here',
                    style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      widget.toggleView();
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.0),

            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
            ),
          ],
          ),
          )
        )
      ),
    );
  }
}