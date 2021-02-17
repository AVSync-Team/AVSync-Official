import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/views/appDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatelessWidget {
  final themeController = Get.put(CustomThemeData());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final heightRatio = size.height / 823;
    final widthRatio = size.width / 411;
    return Obx(
      () => Scaffold(
          backgroundColor: themeController.primaryColor.value,
          appBar: AppBar(
            title: Text('Settings',
                style:
                    TextStyle(color: themeController.primaryTextColor.value)),
            backgroundColor: themeController.switchContainerColor.value,
          ),
          drawer: MainDrawer(),
          body: Container(
            height: size.height,
            width: size.width,
            // decoration: BoxDecoration(border: Border.all(color: Colors.cyan)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(top: 20 * heightRatio),
                    child: CustomText('Theme', themeController)),
                Padding(
                  padding: EdgeInsets.only(top: 18 * heightRatio),
                  child: Container(
                    decoration: BoxDecoration(
                        color: themeController.switchContainerColor.value,
                        borderRadius: BorderRadius.circular(30 * widthRatio)),
                    width: widthRatio * 220,
                    padding: EdgeInsets.symmetric(horizontal: 8 * widthRatio),
                    height: 50 * heightRatio,
                    child: Stack(
                      children: [
                        Align(
                          alignment: themeController.swithcAlignment.value,
                          child: Container(
                            width: widthRatio * 110,
                            height: heightRatio * 40,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(30 * widthRatio),
                              color: themeController.themeSwitchColor.value,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //Dark theme
                              Expanded(
                                child: Container(
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(color: Colors.red)),
                                  child: GestureDetector(
                                    onTap: () {
                                      themeController.changeDarkTheme();
                                      print('Rishabh');
                                    },
                                    child: Icon(Icons.brightness_2_outlined,
                                        color: themeController
                                            .primaryTextColor.value,
                                        size: 35),
                                  ),
                                ),
                              ),

                              //Ligth theme
                              Expanded(
                                child: Container(
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(color: Colors.red)),
                                  child: GestureDetector(
                                    onTap: () {
                                      themeController.changeLightTheme();
                                    },
                                    child: Icon(Icons.brightness_7,
                                        color: themeController
                                            .primaryTextColor.value,
                                        size: 35),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class CustomText extends StatelessWidget {
  final String text;
  final CustomThemeData themeController;
  CustomText(this.text, this.themeController);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            color: themeController.primaryTextColor.value, fontSize: 20));
  }
}
