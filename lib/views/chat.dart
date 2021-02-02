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
  String mesage;
  String userId;
  String username;

  M({this.id, this.mesage, this.userId, this.username});
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

                snapshot.data.snapshot.value.forEach((key, value) {
                  text = [];
                  messages.add(
                      {"userId": value["userId"], "message": value["message"]});
                  check.add(M(
                      id: DateTime.parse(value["messageId"]),
                      mesage: value["message"],
                      userId: value["userId"],
                      username: value["username"]));
                });

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
                        return roomLogicController.userId == check[i].userId
                            ? Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    check[i].username ==
                                            roomLogicController
                                                .adminKaNaam.obs.value
                                        ? Text("Admin")
                                        : Text(check[i].username),
                                    Text(check[i].mesage)
                                  ],
                                ),
                              )
                            : Container(
                                child: Column(
                                  children: [
                                    check[i].username ==
                                            roomLogicController
                                                .adminKaNaam.obs.value
                                        ? Text("Admin")
                                        : Text(check[i].username),
                                    Text(check[i].mesage)
                                  ],
                                ),
                              );
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
                      userId: roomLogicController.userId,
                      username: roomLogicController.userName.obs.value);
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
