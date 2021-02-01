import 'package:VideoSync/controllers/chat.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChattingPlace extends StatefulWidget {
  @override
  _ChattingPlaceState createState() => _ChattingPlaceState();
}

class _ChattingPlaceState extends State<ChattingPlace> {
  RoomLogicController roomLogicController = Get.put(RoomLogicController());
  ChatController chatController = Get.put(ChatController());
  TextEditingController message = TextEditingController();
  // List messages
  List messages = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          StreamBuilder(
            stream: chatController.message(
                firebaseId: roomLogicController.roomFireBaseId),
            builder: (BuildContext ctx, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                snapshot.data.snapshot.value.forEach((key, value) {
                  messages.add(
                      {"userId": value["userId"], "message": value["message"]});
                });

                return Container(
                  height: 200,
                  child: ListView.builder(
                    itemBuilder: (ctx, i) {
                      return Text(messages[0]["message"]);
                    },
                    itemCount: messages.length,
                  ),
                );
              } else {
                return Text("Getting your Chat");
              }
            },
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: message,
                ),
              ),
              RaisedButton(
                onPressed: () {
                  chatController.sendMessage(
                      firebaseId: roomLogicController.roomFireBaseId,
                      message: message.text,
                      userId: roomLogicController.userId);
                  messages = [];
                },
                child: Text("Send"),
              )
            ],
          )
        ],
      ),
    );
  }
}
