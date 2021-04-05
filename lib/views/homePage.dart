import 'createRoom.dart';
import 'drawerPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          DrawerPage(),
          CreateRoomScreen(),
        ],
      ),
    );
  }
}
