import 'package:VideoSync/views/YTPlayer.dart';
import 'package:VideoSync/views/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {
                Get.to(YTPlayer());
              },
              child: Text('Yotube Video'),
            ),
            RaisedButton(
              onPressed: () {
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
