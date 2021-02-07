import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/views/aboutPage.dart';
import 'package:VideoSync/views/createRoom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(String title, IconData icon2, Function tapHandler) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: ListTile(
        // leading: Icon(
        //   icon2,
        //   size: 26,
        // ),
        title: Text(
          title,
          style: TextStyle(
              color: Colors.white,
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
      color: CustomThemeData.customBlack,
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.cyan)),
            alignment: Alignment.topLeft,
            height: 200,
            width: double.infinity,
            padding: EdgeInsets.all(20),
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
          SizedBox(
            height: 20,
          ),
          buildListTile('Rooms', Icons.restaurant, () {
            Get.off(CreateRoomScreen());
            // by this we replace the existing page
          }),
          SizedBox(
            height: 8,
          ),
          buildListTile('Discover', Icons.restaurant, () {
            Get.off(CreateRoomScreen());
            // by this we replace the existing page
          }),
          SizedBox(
            height: 8,
          ),
          buildListTile('Music', Icons.restaurant, () {
            Get.off(AboutPage());
            // by this we replace the existing page
          }),
          buildListTile('About Us', Icons.restaurant, () {
            Get.off(AboutPage());
            // by this we replace the existing page
          }),
        ],
      ),
    );
  }
}
