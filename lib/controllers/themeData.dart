import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomThemeData extends GetxController {
  Rx<Color> primaryColor = Color.fromRGBO(41, 39, 39, 1).obs;
  Rx<Color> drawerColor = Colors.black.obs;
  Rx<Color> primaryColorSwatch = Color.fromRGBO(41, 39, 39, 1).obs;
  Rx<Color> darkGrey = Color.fromRGBO(30, 30, 30, 1).obs;
  Rx<Color> primaryTextColor = Colors.white.obs;
  Rx<Color> drawerHead = Colors.white.obs;
  Rx<Color> blackText = Colors.grey.obs;
  Rx<Alignment> swithcAlignment = Alignment.centerLeft.obs;
  Rx<Color> themeSwitchColor = Color.fromRGBO(92, 92, 92, 1).obs;
  Rx<Color> switchContainerColor = Color.fromRGBO(196, 196, 196, 1).obs;
  Rx<Color> justColor = Color.fromRGBO(196, 196, 196, 1).obs;

  // Rx<Color> appBarColor = Color.fromRGBO().obs;

  void changeDarkTheme() {
    swithcAlignment.value = Alignment.centerLeft;
    drawerColor.value = Colors.black;
    blackText.value = Colors.grey;
    primaryColorSwatch.value = Color.fromRGBO(41, 39, 39, 1);
    primaryTextColor.value = Colors.white;
    drawerHead.value = Colors.white;
    primaryColor.value = Color.fromRGBO(41, 39, 39, 1);
    switchContainerColor.value = Color.fromRGBO(41, 39, 39, 1);
    print('called');
  }

  void changeLightTheme() {
    swithcAlignment.value = Alignment.centerRight;
    drawerColor = Color.fromRGBO(10, 10, 10, 0.4).obs;
    primaryColorSwatch.value = Colors.white;
    blackText.value = Colors.black38;
    primaryColor.value = Color.fromRGBO(201, 199, 199, 1);
    drawerHead.value = Colors.black;
    primaryTextColor.value = Color.fromRGBO(10, 10, 10, 1);
    switchContainerColor.value = Color.fromRGBO(196, 196, 196, 1);
    justColor.value = Color.fromRGBO(196, 196, 196, 1);
  }
}
