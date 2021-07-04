import 'package:VideoSync/controllers/local_storage_controller.dart';
import 'package:VideoSync/views/homePage.dart';
// import 'package:VideoSync/views/videoPlayer.dart';
// import 'package:VideoSync/views/welcome_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences _prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // final themeController = Get.put(CustomThemeData());

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // setSharedPrefs();
  }

  // LocalStorageController localStorageController =
  //     Get.put(LocalStorageController());
  // void setSharedPrefs() async {
  //   print("sharedprefs set called");
  //   localStorageController.prefs.value = await SharedPreferences.getInstance();
  // }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
