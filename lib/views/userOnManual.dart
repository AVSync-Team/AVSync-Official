import 'package:flutter/material.dart';
import 'package:VideoSync/controllers/themeData.dart';
import 'package:get/get.dart';

class UserOnManual extends StatefulWidget {
  @override
  _UserOnManualState createState() => _UserOnManualState();
}

class _UserOnManualState extends State<UserOnManual> {
  CustomThemeData themeController = Get.put(CustomThemeData());

  double xOffset = 0;
  double yOffset = 0;
  double zOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, zOffset)
        ..scale(scaleFactor),
      duration: Duration(milliseconds: 350),
      decoration: BoxDecoration(
        color: themeController.switchContainerColor.value,
        borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0),
      ),
      child: Scaffold(
        /////////////////////////////////////////////////////////////
        // appBar: AppBar(
        //   title: Text('Music'),
        //   backgroundColor: themeController.switchContainerColor.value,
        // ),
        // drawer: MainDrawer(),
        /////////////////////////////////////////////////////////////////
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.only(
                  left: 25,
                ),
                alignment: Alignment.centerLeft,
                child: isDrawerOpen
                    ? IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            xOffset = 0;
                            yOffset = 0;
                            zOffset = 0;
                            scaleFactor = 1;
                            isDrawerOpen = false;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            xOffset = 250;
                            yOffset = 155;
                            zOffset = 20;
                            scaleFactor = 0.6;
                            isDrawerOpen = true;
                          });
                        },
                      ),
              ),
              SizedBox(height: 50),
              Expanded(
                child: Center(
                  child: Container(
                    child: Text('Nothing to see here'),
                  ),
                ),
              ),
              SizedBox(
                height: 80,
              ),
            ],
          )),
        ),
      ),
    );
  }
}
