import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/views/aboutPage.dart';
import 'package:VideoSync/views/createRoom.dart';
import 'package:VideoSync/views/homePage.dart';
import 'package:VideoSync/views/musicPage.dart';
import 'package:VideoSync/views/settingsOnPage.dart';
import 'package:VideoSync/views/settingsPage.dart';
import 'package:VideoSync/views/userManual.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final themeController = Get.put(CustomThemeData());

  bool isDark = true;

  Widget buildListTile(String title, IconData icon2, Function tapHandler) {
    return Container(
      //padding: const EdgeInsets.only(left: 30.0),
      child: ListTile(
        //leading: Icon(
        //   icon2,
        //   size: 26,
        // ),
        /////////////////////////////////////////////////////////////////
        // leading: Icon(
        //   icon2,
        //   color: themeController.primaryTextColor.value,
        //   size: 15,
        // ),
        /////////////////////////////////////////////////////////////////
        title: Text(
          title,
          style: TextStyle(
            color: themeController.primaryTextColor.value,
            //fontSize: 15,
            // color: THEMEDATA.emeraldCityGreen,
            //fontWeight: FontWeight.w100
            fontSize: 17,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w100,
          ),
        ),
        onTap: tapHandler,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: themeController.primaryColorSwatch.value,
      //color: Colors.grey[900],
      color: themeController.drawerColor.value,
      width: double.infinity,
      height: Get.height,
      child: Obx(
        () => Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  //decoration: BoxDecoration(
                  //color: themeController.darkGrey.value,
                  //border: Border.all(color: Colors.cyan)),
                  alignment: Alignment.topLeft,
                  height: 170,
                  //color: Color.fromRGBO(10, 10, 10, 0),
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 80, left: 20),
                  child: Row(
                    children: [
                      Text(
                        'AV Sync',
                        style: TextStyle(
                          color: themeController.drawerHead.value,
                          fontSize: 30,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        child: IconButton(
                            icon: isDark
                                ? Icon(
                                    Icons.wb_sunny,
                                    color: Colors.yellow,
                                  )
                                : Icon(
                                    Icons.brightness_3,
                                    color: Colors.white,
                                  ),
                            onPressed: () {
                              if (isDark == true) {
                                setState(() {
                                  themeController.changeLightTheme();
                                });
                                isDark = false;
                              } else {
                                setState(() {
                                  themeController.changeDarkTheme();
                                });
                                isDark = true;
                              }
                            }),
                      )
                    ],
                  ),
                ),
                //Container(
                //child: SingleChildScrollView(
                //child: Column(
                //children: <Widget>[
                // SizedBox(
                //   height: 20,
                // ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  //child: Container(
                  //height: 500,
                  child: Column(
                    children: <Widget>[
                      Divider(
                        color: themeController.darkGrey.value,
                      ),
                      buildListTile('Rooms', Icons.restaurant, () {
                        //Get.off(CreateRoomScreen());
                        Get.off(HomePage());
                        // by this we replace the existing page
                      }),
                      Divider(
                        color: themeController.darkGrey.value,
                      ),
                      // SizedBox(
                      //   height: 8,
                      // ),
                      buildListTile('Discover', Icons.restaurant, () {
                        Get.off(HomePage());
                        // by this we replace the existing page
                      }),
                      Divider(
                        color: themeController.darkGrey.value,
                      ),
                      // SizedBox(
                      //   height: 8,
                      // ),
                      buildListTile('Music', Icons.restaurant, () {
                        Get.off(MusicPage());
                        // by this we replace the existing page
                      }),
                      Divider(color: themeController.darkGrey.value),
                      buildListTile('User Manual', Icons.table_chart, () {
                        Get.off(UserManual());
                      }),
                      Divider(
                        color: themeController.darkGrey.value,
                      ),
                      buildListTile('Settings', Icons.settings, () {
                        Get.off(SettingsPage());
                      }),
                      Divider(
                        color: themeController.darkGrey.value,
                      ),
                      buildListTile('About Us', Icons.restaurant, () {
                        Get.off(AboutPage());
                        // by this we replace the existing page
                      }),
                      Divider(
                        color: themeController.darkGrey.value,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
