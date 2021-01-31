import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/views/welcome_Screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateRoomScreen extends StatefulWidget {
  @override
  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  RoomLogicController roomLogicController = Get.put(RoomLogicController());
  TextEditingController nameController = TextEditingController();
  TextEditingController roomId = TextEditingController();
  RishabhController rishabhController = Get.put(RishabhController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                child: TextField(
              controller: roomId,
              decoration: InputDecoration(
                hintText: "Room Id",
              ),
            )),
            Container(
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                ),
              ),
            ),
            RaisedButton(
              onPressed: () async {
                bool canJoin = await roomLogicController.joinRoom(
                  roomId: roomId.text,
                  name: nameController.text,
                );
                if (canJoin)
                  Get.to(WelcomScreen());
                else
                  print("No Such Room exsist");
              },
              child: Text('Join Room'),
            ),
            RaisedButton(
              onPressed: () async {
                await roomLogicController.makeRoom(
                    adminName: nameController.text);
                Get.to(WelcomScreen());
              },
              child: Text('Create Room'),
            ),
            RaisedButton(
              onPressed: () async {
                // Get.to(WelcomScreen());
              },
              child: Text('Users'),
            ),
            RaisedButton(
              onPressed: () async {
                // Get.to(WelcomScreen());
                rishabhController.rishabhTry();
              },
              child: Text('Rishabh'),
            ),
          ],
        ),
      ),
    );
  }
}
