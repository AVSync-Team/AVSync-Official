// import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/views/createRoom.dart';
// import 'package:VideoSync/views/homePage.dart';
// import 'package:VideoSync/views/videoPlayer.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:VideoSync/views/videoPlayer.dart';
// import 'package:VideoSync/views/welcome_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final themeController = Get.put(CustomThemeData());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: CreateRoomScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
