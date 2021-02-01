import 'dart:async';

import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/views/YTPlayer.dart';
import 'package:VideoSync/views/chat.dart';
import 'package:VideoSync/views/videoPlayer.dart';
import 'package:firebase_database/firebase_database.dart';
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
  RishabhController rishabhController = Get.put(RishabhController());

  // StreamController<List<dynamic>> _userController;
  // Timer timer;

  // @override
  // void initState() {
  //   super.initState();
  //   //   _userController = new StreamController();

  //   //   timer = Timer.periodic(Duration(seconds: 3), (_) async {
  //   //     var data = await roomLogicController.loadDetails();
  //   //     _userController.add(data);
  //   //   });
  //   //
  // }

  // @override
  // void dispose() {
  //   _userController.close();
  //   // _userController.done;
  //   timer.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Users: '),
            StreamBuilder(
                stream: rishabhController.getUsersList(
                    firebaseId: roomLogicController.roomFireBaseId),
                builder: (ctx, event) {
                  if (event.hasData) {
                    return Container(
                      height: 200,
                      width: 200,
                      child: ListView.builder(
                          itemBuilder: (ctx, i) {
                            print('chut: ${event.data.snapshot.value}');

                            return CustomNameBar(event: event, index: i);
                          },
                          itemCount: event.data.snapshot.value.length),
                    );
                  } else {
                    return CircularProgressIndicator();
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
            ),
            ChattingPlace()
          ],
        ),
      ),
    );
  }
}

class CustomNameBar extends StatelessWidget {
  final AsyncSnapshot event;
  final int index;
  CustomNameBar({
    this.event,
    this.index,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '${event.data.snapshot.value[index]['name']}',
      style: TextStyle(fontSize: 20),
    );
  }
}
