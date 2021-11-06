import 'package:VideoSync/views/createRoom.dart';
import 'package:VideoSync/views/video%20players/videoPlayer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {


  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      print("appp is inactive aur in background aur dead");
      if (roomLogicController.roomFireBaseId != null) {
        roomLogicController.userLeaveRoom(
            firebaseId: roomLogicController.roomFireBaseId,
            userId: roomLogicController.userId,
            adminId: roomLogicController.adminId.value);
        Get.offAll(CreateRoomScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: CreateRoomScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
