import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodspace/pages/home_page.dart';
import 'package:foodspace/pages/liked_restaurants_page.dart';
import 'package:foodspace/pages/profile_page.dart';
import 'package:foodspace/shared/loading.dart';

class TabMonitorPage extends StatefulWidget {

  final dynamic cityId, cityName;
  TabMonitorPage({
    this.cityId,
    this.cityName
  });

  @override
  _TabMonitorPageState createState() => _TabMonitorPageState();
}

class _TabMonitorPageState extends State<TabMonitorPage> {

  int _currentTab = 0;
  dynamic _tabs = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _tabs = [
        HomePage(cityId: widget.cityId, cityName: widget.cityName),
        LikedRestaurantsPage(),
        ProfilePage(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs.length == 0 ? Loading() : _tabs[_currentTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (int value) {
          setState(() {
            _currentTab = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30.0),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidHeart),
            activeIcon: Icon(FontAwesomeIcons.solidHeart, color: Colors.red, size: 25.0),
            title: SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, size: 30.0),
            title: SizedBox.shrink(),
          ),
        ]
      ),
    );
  }
}