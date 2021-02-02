import 'package:VideoSync/controllers/chat.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neumorphic/neumorphic.dart';

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
  ScrollController chatScroll = ScrollController();
  // List messages
  List messages = [];
  List text = [];
  int a;
  int count = 0;
  @override
  void dispose() {
    super.dispose();
    count = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Color(0x11ffffff),
        height: 500,
        width: double.infinity,
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
                    messages.add({
                      "userId": value["userId"],
                      "message": value["message"]
                    });
                    check.add(M(
                        id: DateTime.parse(value["messageId"]),
                        mesage: value["message"],
                        userId: value["userId"],
                        username: value["username"]));
                  });

                  check.sort((a, b) => (a.id).compareTo(b.id));

                  if (count != 0)
                    chatScroll.animateTo(
                      chatScroll.position.maxScrollExtent,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.bounceIn,
                    );

                  count++;
////s
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

                  return Container(
                    height: 400,
                    child: ListView.builder(
                        controller: chatScroll,
                        itemBuilder: (ctx, i) {
                          return roomLogicController.userId == check[i].userId
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Spacer(),
                                    Container(
                                      width: 150,
                                      padding: EdgeInsets.all(8),
                                      child: Card(
                                        elevation: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              check[i].username ==
                                                      roomLogicController
                                                          .adminKaNaam.obs.value
                                                  ? Text("Admin",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.cyan))
                                                  : Text(check[i].username),
                                              SizedBox(height: 5),
                                              Text(check[i].mesage),
                                              SizedBox(height: 5)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Container(
                                      // decoration:
                                      //     BoxDecoration(color: Colors.cyan),
                                      width: 150,
                                      padding: EdgeInsets.only(right: 20),
                                      child: Card(
                                        elevation: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              check[i].username ==
                                                      roomLogicController
                                                          .adminKaNaam.obs.value
                                                  ? Text("Admin")
                                                  : Text(check[i].username,
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.red)),
                                              Text(
                                                check[i].mesage,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer()
                                  ],
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
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ),
                SizedBox(width: 5),
                RaisedButton(
                  onPressed: () {
                    chatController.sendMessage(
                        firebaseId: roomLogicController.roomFireBaseId,
                        message: message.text,
                        userId: roomLogicController.userId,
                        username: roomLogicController.userName.obs.value);
                    message.clear();
                    messages = [];
                  },
                  child: Text("Send"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
