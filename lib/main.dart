import 'package:VideoSync/views/createRoom.dart';
// import 'package:VideoSync/views/videoPlayer.dart';
// import 'package:VideoSync/views/welcome_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: CreateRoomScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
