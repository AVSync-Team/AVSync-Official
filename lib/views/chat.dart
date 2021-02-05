// import 'dart:ffi';

import 'package:VideoSync/controllers/chat.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
// import 'package:VideoSync/controllers/ytPlayercontroller.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:neumorphic/neumorphic.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ChattingPlace extends StatefulWidget {
  final YoutubePlayerController controller;
  final Function snackbar;
  ChattingPlace({this.controller, this.snackbar});
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
      backgroundColor: Colors.black.withOpacity(0.5),
      //drawerEdgeDragWidth: 380.0,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(0, 200, 100, 50),
          // height: 500,
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

                    if (count != 0) {
                      chatScroll.animateTo(
                        chatScroll.position.maxScrollExtent,
                        duration: Duration(milliseconds: 200),
                        curve: Curves.bounceIn,
                      );
                      check[check.length - 1].userId !=
                              roomLogicController.userId
                          ? Future.delayed(
                              Duration(seconds: 1),
                              () => {
                                    widget.snackbar(
                                        check[check.length - 1].username,
                                        check[check.length - 1].mesage)
                                  })
                          : {};
                    }

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
                      height: Get.height * 0.910,
                      child: ListView.builder(
                          controller: chatScroll,
                          itemBuilder: (ctx, i) {
                            return roomLogicController.userId == check[i].userId
                                //Self user
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                      right: 5,
                                      //left: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Spacer(),
                                        Container(
                                          //decoration: BoxBorder(BorderRadius: BorderRadius.circular(10,),),
                                          constraints: BoxConstraints(
                                            minWidth: 150,
                                            maxWidth: 225,
                                          ),
                                          //minwidth: 150,
                                          padding: EdgeInsets.all(8),
                                          child: Card(
                                            color:
                                                Colors.white.withOpacity(0.4),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(13),
                                                bottomLeft: Radius.circular(13),
                                                topLeft: Radius.circular(13),
                                              ),
                                            ),
                                            elevation: 5,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 12,
                                                left: 8,
                                                top: 6,
                                              ),
                                              child: GestureDetector(
                                                onLongPress: () {
                                                  FlutterClipboard.copy(
                                                          check[i].mesage)
                                                      .then((value) =>
                                                          Get.snackbar("Done!",
                                                              "Message Copied!"));
                                                },

                                                // child: Container(
                                                //   check[i].username == roomLogicController.adminKaNaam.obs.value

                                                // ),

                                                // margin: EdgeInsets.all(0),
                                                // padding: EdgeInsets.all(0),
                                                // child: check[i].username ==
                                                //         roomLogicController
                                                //             .adminKaNaam
                                                //           .obs
                                                //             .value
                                                //     ? Column(
                                                //         crossAxisAlignment:
                                                //             CrossAxisAlignment
                                                //                 .start,
                                                //         children: [
                                                //           SizedBox(height: 5),
                                                //           Text(check[i]
                                                //               .mesage),
                                                //           SizedBox(height: 5),
                                                //         ],
                                                //       )
                                                //     : Column(
                                                //         crossAxisAlignment:
                                                //             CrossAxisAlignment
                                                //                 .end,
                                                //         children: [
                                                //           check[i].username ==
                                                //                   roomLogicController
                                                //                       .adminKaNaam
                                                //                       .obs
                                                //                       .value
                                                //               ? Text(
                                                //                   "Admin",
                                                //                   style:
                                                //                       TextStyle(
                                                //                     fontSize:
                                                //                         20,
                                                //                     color: Colors
                                                //                         .cyan,
                                                //                   ),
                                                //                 )
                                                //               : Text(
                                                //                   check[i]
                                                //                       .username,
                                                //                   style:
                                                //                       TextStyle(
                                                //                     fontSize:
                                                //                         20,
                                                //                     color: Colors
                                                //                         .pink,
                                                //                   ),
                                                //                 ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 5),
                                                    Text(check[i].mesage),
                                                    SizedBox(height: 5),
                                                  ],
                                                ),
                                              ),
                                              //                child: Column(
                                              //                  crossAxisAlignment:
                                              //                      CrossAxisAlignment.start,
                                              //                  children: [
                                              //                    check[i].username ==
                                              //                            roomLogicController
                                              //                                .adminKaNaam
                                              //                                .obs
                                              //                                .value
                                              //                        ? Text("Admin",
                                              //                            style: TextStyle(
                                              //                                fontSize: 20,
                                              //                                color: Colors
                                              //                                    .cyan))
                                              //                        : Text(
                                              //                            check[i].username),
                                              //                    SizedBox(height: 5),
                                              //                    Text(check[i].mesage),
                                              //                    SizedBox(height: 5)
                                              //                  ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                //Sending user
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          // decoration:
                                          //     BoxDecoration(color: Colors.cyan),
                                          //width: 150,
                                          constraints: BoxConstraints(
                                            minWidth: 150,
                                            maxWidth: 225,
                                          ),
                                          padding: EdgeInsets.only(right: 20),
                                          child: Card(
                                            color:
                                                Colors.white.withOpacity(0.4),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(13),
                                                bottomRight:
                                                    Radius.circular(13),
                                                topLeft: Radius.circular(13),
                                              ),
                                            ),
                                            elevation: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 12,
                                                left: 8,
                                                top: 6,
                                                bottom: 6,
                                              ),
                                              child: GestureDetector(
                                                onLongPress: () {
                                                  FlutterClipboard.copy(
                                                          check[i].mesage)
                                                      .then((value) =>
                                                          Get.snackbar("Done!",
                                                              "Message Copied!"));
                                                },
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    check[i].username ==
                                                            roomLogicController
                                                                .adminKaNaam
                                                                .obs
                                                                .value
                                                        ? Text(
                                                            "Admin",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.red
                                                                  .withOpacity(
                                                                      0.7),
                                                            ),
                                                          )
                                                        : Text(
                                                            check[i].username,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.blue
                                                                  .withOpacity(
                                                                      0.7),
                                                            ),
                                                          ),
                                                    Text(
                                                      check[i].mesage,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer()
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
              //Container(
              //width: 300,
              //height: 50,
              //child:
              Container(
                color: Colors.grey.withOpacity(0.2),
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.start,

                  children: [
                    Expanded(
                      child: Container(
                        //color: Colors.white.withOpacity(0.8),
                        constraints: BoxConstraints(
                          minHeight: Get.height * 0.065,
                          //maxWidth: 100,
                        ),
                        //height: Get.height * 0.065,
                        margin: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(0, 255, 255, 255),
                        ),
                        child: TextField(
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.start,
                          textAlignVertical: TextAlignVertical.bottom,
                          onTap: () {
                            if (widget.controller != null) {
                              widget.controller.play();
                            }
                          },
                          controller: message,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey,
                              focusColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(5),
                                  ))),
                        ),
                      ),
                    ),
                    //SizedBox(width: 5),
                    Container(
                      height: Get.height * 0.077,
                      child: RaisedButton(
                        color: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                          topRight: Radius.circular(5),
                        )),
                        onPressed: () {
                          if (message.text != "") {
                            chatController.sendMessage(
                                firebaseId: roomLogicController.roomFireBaseId,
                                message: message.text,
                                userId: roomLogicController.userId,
                                username:
                                    roomLogicController.userName.obs.value);
                            message.clear();
                            messages = [];
                          }
                        },
                        child: Text("Send",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15)),
                      ),
                    ),
                    SizedBox(width: 10)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
