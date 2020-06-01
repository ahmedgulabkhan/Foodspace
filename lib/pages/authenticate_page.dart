import 'package:foodspace/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:foodspace/pages/signin_page.dart';

class AuthenticatePage extends StatefulWidget {
  @override
  _AuthenticatePageState createState() => _AuthenticatePageState();
}

class _AuthenticatePageState extends State<AuthenticatePage> {

  bool showSignIn = true;
  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn) {
      return SignInPage(toggleView: toggleView);
    }
    else {
      return RegisterPage(toggleView: toggleView);
    }
  }
}