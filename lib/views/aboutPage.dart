import 'package:VideoSync/views/aboutOnPage.dart';
import 'package:VideoSync/views/drawerPage.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          DrawerPage(),
          AboutOnPage(),
        ],
      ),
    );
  }
}
