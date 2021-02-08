import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/views/appDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutPage extends StatelessWidget {
  

  final String aboutUs =
      '''Us being movieholics, we used to watch movies while sharing our screens , one guy would share their screen and others would watch the movie.\nThe problem we had was the quality and the sync issue , that\'s a funny one as to watch in sync we would start the movie by saying 1, 2, 3 and go.\nThat\'s when we came up with this idea of developing an app that would play your favourite movie and series with sync and plus you could also chat with your friends at the same time.\nHave fun Syncing!! '
      ''';

  final String binaryCoders =
      'We call ourselves the Binary Coders.\n\nWe are made up of:\n\n\nSidharth Bansal\n\nManav Parikh\n\nRishabh Mishra';

  final themeController = Get.put(CustomThemeData());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: themeController.primaryColorSwatch.value),
      drawer: MainDrawer(),
      backgroundColor: themeController.primaryColorSwatch.value,
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.only(left: 20.0, top: 30, right: 20.0),
            child: Text(
              aboutUs,
              style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w100),
              //   // maxLines: 2,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20.0, top: 30),
            child: Text(
              binaryCoders,
              style: TextStyle(color: Colors.white, letterSpacing: 1.5),
              // maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
