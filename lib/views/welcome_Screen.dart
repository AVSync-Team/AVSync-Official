import 'package:VideoSync/views/YTPlayer.dart';
import 'package:VideoSync/views/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomScreen extends StatelessWidget {
  bool ytPlayerclicked = false;
  bool localPlayerClicked = false;
  TextEditingController yturl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: yturl,
              decoration: InputDecoration(hintText: 'Enter URL'),
            ),
            RaisedButton(
              onPressed: () {
                ytPlayerclicked = true;

                Get.to(YTPlayer(
                  urled: yturl.text,
                ));
              },
              child: Text('Yotube Video'),
            ),
            RaisedButton(     
              onPressed:  () {
                Get.to(NiceVideoPlayer());
              },
              child: Text('Local Video'),
            )
          ],
        ),
      ),
    );
  }
}
