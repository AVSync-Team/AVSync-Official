import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/views/aboutPage.dart';
import 'package:VideoSync/views/createRoom.dart';
//<<<<<<< Updated upstream
import 'package:VideoSync/views/musicPage.dart';
//=======
//<<<<<<< HEAD
import 'package:VideoSync/views/settingsPage.dart';
import 'package:VideoSync/views/userManual.dart';
//=======
// import 'package:VideoSync/views/musicPage.dart';
//>>>>>>> aa24f830821f4ce032249f8ea189e3ebfb7e0f6e
//>>>>>>> Stashed changes
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainDrawer extends StatelessWidget {
  final themeController = Get.put(CustomThemeData());

  Widget buildListTile(String title, IconData icon2, Function tapHandler) {
    return Container(
      //padding: const EdgeInsets.only(left: 30.0),
      child: ListTile(
        //leading: Icon(
        //   icon2,
        //   size: 26,
        // ),
        leading: Icon(
          icon2,
          color: themeController.primaryTextColor.value,
        ),
        title: Text(
          title,
          style: TextStyle(
              color: themeController.primaryTextColor.value,
              fontSize: 24,
              // color: THEMEDATA.emeraldCityGreen,
              fontWeight: FontWeight.bold),
        ),
        onTap: tapHandler,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: themeController.primaryColorSwatch.value,
      width: 300,
      height: Get.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: themeController.darkGrey.value,
                  border: Border.all(color: Colors.cyan)),
              alignment: Alignment.topLeft,
              height: 150,
              //color: Color.fromRGBO(10, 10, 10, 0),
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 30,
                left: 20,
              ),
              child: Text(
                'AV Sync',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            //Container(
            //child: SingleChildScrollView(
            //child: Column(
            //children: <Widget>[
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              //child: Container(
              //height: 500,
              child: Column(
                children: <Widget>[
                  buildListTile('Rooms', Icons.restaurant, () {
                    Get.off(CreateRoomScreen());
                    // by this we replace the existing page
                  }),
                  Divider(
                    color: themeController.darkGrey.value,
                  ),
                  // SizedBox(
                  //   height: 8,
                  // ),
                  buildListTile('Discover', Icons.restaurant, () {
                    Get.off(CreateRoomScreen());
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
