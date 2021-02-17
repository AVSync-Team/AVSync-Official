import 'package:VideoSync/views/appDrawer.dart';
import 'package:flutter/material.dart';
import 'package:VideoSync/controllers/themeData.dart';
import 'package:get/get.dart';

class MusicPage extends StatefulWidget {
  MusicPage({Key key}) : super(key: key);

  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  CustomThemeData themeController = Get.put(CustomThemeData());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Music'),
        backgroundColor: themeController.switchContainerColor.value,
      ),
      drawer: MainDrawer(),
      body: Center(
        child: Container(
          child: Text('Go to spotify you idiot'),
        ),
      ),
    );
    //     Container(
    //     decoration: BoxDecoration(border: Border.all(color: Colors.red)),
    //     width: size.width,
    //     height: size.height,
    //     child: Text('Rishabh'));
  }
}
