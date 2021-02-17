import 'package:VideoSync/main.dart';
import 'package:VideoSync/views/appDrawer.dart';
import 'package:flutter/material.dart';
import 'package:VideoSync/controllers/themeData.dart';
import 'package:get/get.dart';

class UserManual extends StatefulWidget {
  @override
  _UserManualState createState() => _UserManualState();
}

class _UserManualState extends State<UserManual> {
  CustomThemeData themeController = Get.put(CustomThemeData());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Manual'),
        backgroundColor: themeController.switchContainerColor.value,
      ),
      drawer: MainDrawer(),
    );
  }
}
