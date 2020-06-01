import 'package:flutter/material.dart';
import 'package:foodspace/helper/helper_functions.dart';
import 'package:foodspace/pages/selectcity_page.dart';

import 'pages/onboarding_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _getLoggedInState();
  }

  _getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        isLoggedIn  = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodspace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF307EFF),
      ),
      home: isLoggedIn != null ? isLoggedIn ? SelectCityPage() : OnboardingPage() : OnboardingPage(),
    );
  }
}
