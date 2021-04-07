import 'users_screen.dart';
import 'leaveRoom.dart';
import 'package:flutter/material.dart';

class WaitingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LeaveRoom(),
          WelcomScreen(),
        ],
      ),
    );
  }
}
