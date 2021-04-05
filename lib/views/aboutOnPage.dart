import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/views/appDrawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutOnPage extends StatefulWidget {
  @override
  _AboutOnPageState createState() => _AboutOnPageState();
}

class _AboutOnPageState extends State<AboutOnPage> {
  final String aboutUs =
      '''Us being movieholics, we used to watch movies while sharing our screens , one guy would share their screen and others would watch the movie.\nThe problem we had was the quality and the sync issue , that\'s a funny one as to watch in sync we would start the movie by saying 1, 2, 3 and go.\nThat\'s when we came up with this idea of developing an app that would play your favourite movie and series with sync and plus you could also chat with your friends at the same time.\nHave fun Syncing!! '
      ''';

  final String binaryCoders =
      'We call ourselves the Binary Coders.\n\nWe are made up of:\n\n\nSidharth Bansal\n\nManav Parikh\n\nRishabh Mishra';

  final themeController = Get.put(CustomThemeData());

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
        ////////////////////////////////////////////////////////////////////
        // appBar: AppBar(backgroundColor: themeController.primaryColorSwatch.value),
        // drawer: MainDrawer(),
        ///////////////////////////////////////////////////////////////
        //backgroundColor: themeController.primaryColorSwatch.value,
        backgroundColor: Colors.transparent,
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
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
            Container(
              padding: const EdgeInsets.only(left: 20.0, top: 30, right: 20.0),
              child: Text(
                aboutUs,
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontSize: 15,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w300),
                //   // maxLines: 2,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20.0, top: 30),
              child: Text(
                binaryCoders,
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: 15,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.w200,
                ),
                // maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
