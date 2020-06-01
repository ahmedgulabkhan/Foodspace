import 'package:flutter/material.dart';
import 'package:foodspace/helper/helper_functions.dart';
import 'package:foodspace/pages/authenticate_page.dart';
import 'package:foodspace/services/auth_service.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  AuthService _auth = AuthService();

  String _username = '', _email = '';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future _getUserInfo() async {
    String name = await HelperFunctions.getUserNameSharedPreference();
    String email = await HelperFunctions.getUserEmailSharedPreference();
    setState(() {
      _username = name;
      _email = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Profile'),
        titleSpacing: -1.0,
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.account_circle, size: 150.0),

            SizedBox(height: 20.0),

            Text('User Info', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold)),

            Divider(),

            ListTile(
              leading: Text('Name', style: TextStyle(fontSize: 15.0)),
              trailing: Text(_username, style: TextStyle(fontSize: 15.0)),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            ),

            Divider(),

            ListTile(
              leading: Text('Email', style: TextStyle(fontSize: 15.0)),
              trailing: Text(_email, style: TextStyle(fontSize: 15.0)),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            ),

            Divider(),
          ],
        ),
      ),
      bottomSheet: GestureDetector(
        onTap: () async {
          await _auth.signOut();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AuthenticatePage()), (Route<dynamic> route) => false);
        },
        child: Container(
          alignment: Alignment.center,
          height: 50.0,
          width: double.infinity,
          color: Colors.red,
          child: Text('Log out', style: TextStyle(color: Colors.white, fontSize: 20.0)),
        ),
      ),
    );
  }
}