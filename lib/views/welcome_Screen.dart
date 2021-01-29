import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/views/YTPlayer.dart';
import 'package:VideoSync/views/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomScreen extends StatelessWidget {
  bool ytPlayerclicked = false;
  bool localPlayerClicked = false;
  TextEditingController yturl = TextEditingController();
  RoomLogicController roomLogicController = Get.put(RoomLogicController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Users: '),
            FutureBuilder<dynamic>(
                future: roomLogicController.getusersInRoom(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    return Text('It has');
                  }
                 return Container();
                }),
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
              onPressed: () {
                Get.to(NiceVideoPlayer());
              },
              child: Text('Local Video'),
            ),
            GetX<RoomLogicController>(
              builder: (controller) {
                return Text('Your room id is: ${controller.randomNumber}');
              },
            )
          ],
        ),
      ),
    );
  }
}
