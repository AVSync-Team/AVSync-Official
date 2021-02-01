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
                return ListView.builder(
                  itemBuilder: (ctx, i) {
                    return snapshot.data.snapshot.value[i]["userId"] ==
                            roomLogicController.userId
                        ? Text(snapshot.data.snapshot.value[i]["message"])
                        : Text(snapshot.data.snapshot.value[i]["message"]);
                  },
                  itemCount: snapshot.data.snapshot.value.length,
                );
              } else {
               return  Text("Getting your Chat");
              }
            },
          ),
          Row(
            children: [
              TextField(
                controller: message,
              ),
              RaisedButton(
                onPressed: () {
                  chatController.sendMessage(
                      firebaseId: roomLogicController.roomFireBaseId,
                      message: message.text,
                      userId: roomLogicController.userId);
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
