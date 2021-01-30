import 'dart:async';

import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/views/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:VideoSync/views/createRoom.dart';

class WelcomScreen extends StatefulWidget {
  @override
  _WelcomScreenState createState() => _WelcomScreenState();
}

class _WelcomScreenState extends State<WelcomScreen> {
  bool ytPlayerclicked = false;

  bool localPlayerClicked = false;

  TextEditingController yturl = TextEditingController();

  RoomLogicController roomLogicController = Get.put(RoomLogicController());

  StreamController<List<dynamic>> _userController;
  Timer timer;

  @override
  void initState() {
    super.initState();
    _userController = new StreamController();
    timer = Timer.periodic(Duration(seconds: 1), (_) async {
      var data = await roomLogicController.loadDetails();
      _userController.add(data);
    });
  }

  @override
  void dispose() {
    _userController.close();
    // _userController.done;
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Users: '),
            StreamBuilder<List<dynamic>>(
                stream: _userController.stream,
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 200,
                      width: 200,
                      child: ListView.builder(
                        itemBuilder: (ctx, i) {
                          print(snapshot.data);
                          return Text('${snapshot.data[i]['name']}');
                        },
                        itemCount: snapshot.data.length,
                      ),
                    );
                  } else {
                    return Text("wait");
                  }
                }),
            TextField(
              controller: yturl,
              decoration: InputDecoration(hintText: 'Enter URL'),
            ),
            RaisedButton(
              onPressed: () {
                ytPlayerclicked = true;
                roomLogicController.ytURL.value = yturl.text;
                Get.off(YTPlayer());
              },
              child: Text('Yotube Video'),
            ),
            RaisedButton(
              onPressed: () {
                Get.to(NiceVideoPlayer());
              },
              child: Text('Local Video'),
            ),
            RaisedButton(
              onPressed: () {
                Get.off(CreateRoomScreen());
              },
              child: Text('Delete Room'),
            ),
            GetX<RoomLogicController>(
              builder: (controller) {
                return Text('Your room id is: ${controller.roomId.obs.value}');
              },
            )
          ],
        ),
      ),
    );
  }
}
