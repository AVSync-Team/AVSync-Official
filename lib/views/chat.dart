import 'package:VideoSync/controllers/chat.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChattingPlace extends StatefulWidget {
  @override
  _ChattingPlaceState createState() => _ChattingPlaceState();
}

class M {
  DateTime id;
  String meesage;
  M({this.id, this.meesage});
}

class _ChattingPlaceState extends State<ChattingPlace> {
  RoomLogicController roomLogicController = Get.put(RoomLogicController());
  ChatController chatController = Get.put(ChatController());
  TextEditingController message = TextEditingController();
  // List messages
  List messages = [];
  List text = [];

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
                List<M> check = [];
                List temp = [];
                snapshot.data.snapshot.value.forEach((key, value) {
                  text = [];
                  messages.add(
                      {"userId": value["userId"], "message": value["message"]});
                  check.add(M(
                      id: DateTime.parse(value["messageId"]),
                      meesage: value["message"]));
                });
                temp = check;

                check.sort((a, b) => (a.id).compareTo(b.id));

                print(check[0].id);

                // if (text == []) {
                //   text = check;
                // } else {
                //   check.removeWhere((element) {
                //     for (int i = 0; i < text.length; i++) {
                //       if (element["messageId"] == text[i]["messageId"]) {
                //         return true;
                //       }
                //     }
                //     return false;
                //   });
                //   text = temp;
                // }
                print(check);

                return Container(
                  height: 200,
                  child: ListView.builder(
                      itemBuilder: (ctx, i) {
                        return Text(check[i].meesage);
                      },
                      itemCount: check.length),
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
