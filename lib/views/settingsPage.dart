import 'package:VideoSync/views/settingsOnPage.dart';

import 'drawerPage.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          DrawerPage(),
          SettingsOnPage(),
        ],
      ),
    );
  }
}
