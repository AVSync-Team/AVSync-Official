import 'dart:async';

import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/chat.dart';
import 'package:VideoSync/controllers/funLogic.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/views/YTPlayer.dart';
import 'package:VideoSync/views/chat.dart';
import 'package:VideoSync/views/createRoom.dart';
import 'package:VideoSync/views/leaveRoom.dart';
import 'package:VideoSync/views/videoPlayer.dart';
import 'package:better_player/better_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:VideoSync/views/videoPlayer.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
// import 'package:VideoSync/views/createRoom.dart';

class WelcomScreen extends StatefulWidget {
  @override
  _WelcomScreenState createState() => _WelcomScreenState();
}

class _WelcomScreenState extends State<WelcomScreen> {
  // bool ytPlayerclicked = false;
  // bool localPlayerClicked = false;
  TextEditingController yturl = TextEditingController();
  RoomLogicController roomLogicController = Get.put(RoomLogicController());

  RishabhController rishabhController = Get.put(RishabhController());
  ChatController chatController = Get.put(ChatController());
  FunLogic funLogic = Get.put(FunLogic());
  CustomThemeData themeController = Get.put(CustomThemeData());

  final double heightRatio = Get.height / 823;
  final double widthRatio = Get.width / 411;

  bool picking;

  double xOffset = 0;
  double yOffset = 0;
  double zOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;
  // StreamController<List<dynamic>> _userController;
  // Timer timer;

  @override
  void initState() {
    super.initState();

    roomLogicController
        .adminIdd(firebaseId: roomLogicController.roomFireBaseId)
        .listen((event) {
      print("adminId");
      roomLogicController.adminId.value = event.snapshot.value;
      setState(() {});
    });

    // chatController
    //     .message(firebaseId: roomLogicController.roomFireBaseId)
    //     .listen((event) {
    //   List<M> check = [];

    //   event.snapshot.value.forEach((key, value) {
    //     check.add(M(
    //         id: DateTime.parse(value["messageId"]),
    //         mesage: value["message"],
    //         userId: value["userId"],
    //         username: value["username"]));
    //   });

    //   check.sort((a, b) => (a.id).compareTo(b.id));
    //   if (check[check.length - 1].userId != roomLogicController.userId)
    //     Get.snackbar(
    //         check[check.length - 1].username, check[check.length - 1].mesage);
    // });

    roomLogicController
        .roomStatus(firebaseId: roomLogicController.roomFireBaseId)
        .listen((event) {
      int x = event.snapshot.value;
      if (x == 0 &&
          !(roomLogicController.adminId.value ==
              roomLogicController.userId.obs.value)) {
        Get.offAll(CreateRoomScreen());
      }
    });

    if (!(roomLogicController.adminId.value ==
        roomLogicController.userId.obs.value))
      roomLogicController
          .userStatus(
        firebaseId: roomLogicController.roomFireBaseId,
        // idOfUser: roomLogicController.userId
      )
          .listen((event) {
        int x = event.snapshot.value;

        if (x == 0 &&
            !(roomLogicController.adminId.value ==
                roomLogicController.userId.obs.value)) {
          Get.offAll(CreateRoomScreen());
        }
      });
  }

  // @override
  // void dispose() {
  //   // chatController.dispose();
  //   // roomLogicController.dispose();
  //   // rishabhController.dispose();
  //   print(
  //       "Leaving loda mera bsdk gandu harsh  player nikla lodu gamndu bcbcbcb");
  //   super.dispose();
  // }

  bool isLoading = false;

  void bottomSheet() {
    Get.bottomSheet(Container(
      color: Colors.white,
      height: 200,
      width: 200,
      child: !isLoading
          ? RaisedButton(
              onPressed: () async {
                await filePick();
                Get.to(NiceVideoPlayer());
              },
              child: Text("Pick Video"),
            )
          : Center(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    ));
  }

  Future<void> filePick() async {
    setState(() {
      isLoading = true;
    });

    FilePickerResult result = await FilePicker.platform.pickFiles(
        // type: FileType.media,
        // allowMultiple: false,
        // allowedExtensions: ['.mp4'],
        withData: false,
        // allowCompression: true,
        withReadStream: true,
        onFileLoading: (status) {
          if (status.toString() == "FilePickerStatus.picking") {
            setState(() {
              picking = true;
            });
          } else {
            setState(() {
              picking = false;
            });
          }
        });

    // roomLogicController.bytes.obs.value = result.files[0];
    roomLogicController.localUrl.value = result.files[0].path;

    // print('testUrl: $testUrl');
    setState(() {
      isLoading = false;
    });

    // Get.to(NiceVideoPlayer());
  }

  void snackbar(String name, String message) {
    Get.snackbar(name, message);
  }

  // Widget open(snackbar) {
  //   return Theme(
  //     data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
  //     //width: 380 * widthRatio,
  //     child: Drawer(
  //       child: ChattingPlace(snackbar: snackbar),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return rishabhController.userLeaveRoom(
            firebaseId: roomLogicController.roomFireBaseId,
            adminId: roomLogicController.adminId.value,
            userId: roomLogicController.userId);
      },
      child: AnimatedContainer(
        transform: Matrix4.translationValues(xOffset, yOffset, zOffset)
          ..scale(scaleFactor),
        duration: Duration(milliseconds: 350),
        decoration: BoxDecoration(
          color: themeController.primaryColor.value,
          borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0),
        ),
        child: Scaffold(
          //backgroundColor: Color.fromRGBO(0, 250, 0, 0.1),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            //backgroundColor: Color.fromRGBO(41, 39, 39, 1),
            backgroundColor: isDrawerOpen
                ? Colors.transparent
                : Color.fromRGBO(41, 39, 39, 1),
            elevation: 10,
            leading: isDrawerOpen
                ? IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        xOffset = 0;
                        yOffset = 0;
                        zOffset = 0;
                        scaleFactor = 1;
                        isDrawerOpen = false;
                      });
                    })
                : IconButton(
                    icon: !(roomLogicController.adminId.value ==
                            roomLogicController.userId.obs.value)
                        ? Icon(Icons.exit_to_app_rounded)
                        : Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        xOffset = 170;
                        yOffset = 100;
                        zOffset = 20;
                        scaleFactor = 0.75;
                        isDrawerOpen = true;
                      });
                      //   Get.defaultDialog(
                      //       // buttonColor: Colors.green.withOpacity(0.1),
                      //       title: !(roomLogicController.adminKaNaam.obs.value ==
                      //               roomLogicController.userName.obs.value)
                      //           ? 'Leave Room'
                      //           : 'Delete Room',
                      //       confirm: RaisedButton(
                      //           color: Colors.green,
                      //           child: Text('Yes'),
                      //           onPressed: () {
                      //             if (!(roomLogicController.adminKaNaam.obs.value ==
                      //                 roomLogicController.userName.obs.value)) {
                      //               rishabhController.userLeaveRoom(
                      //                 firebaseId:
                      //                     roomLogicController.roomFireBaseId,
                      //                 userId: roomLogicController.userId,
                      //               );
                      //             } else {
                      //               roomLogicController.adminDeleteRoom(
                      //                   firebaseId:
                      //                       roomLogicController.roomFireBaseId);
                      //             }
                      //             Get.offAll(CreateRoomScreen());
                      //             // Get.off(CreateRoomScreen());
                      //           }),
                      //       cancel: ElevatedButton(
                      //           style: ButtonStyle(
                      //               foregroundColor:
                      //                   MaterialStateProperty.all<Color>(
                      //                       Colors.green)),
                      //           // color: Colors.red,
                      //           child: Text('No'),
                      //           onPressed: () {
                      //             Get.back();
                      //           }),
                      //       content: !(roomLogicController.adminKaNaam.obs.value ==
                      //               roomLogicController.userName.obs.value)
                      //           ? Text('Do you want to leave the room ? ')
                      //           : Text('Do you want to delete the room ? '));
                    },
                  ),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.chat_bubble),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              )
            ],
          ),
          // appBar: AppBar(),

          endDrawer: Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            //width: 380 * widthRatio,
            child: Drawer(
              child: ChattingPlace(snackbar: snackbar),
            ),
          ),

          body: Center(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: Get.height,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10 * heightRatio,
                  ),
                  Hero(
                    tag: 'Rishabh',
                    child: Container(
                      // color: Colors.green.withOpacity(0.1),
                      height: 350 * heightRatio,
                      width: 330 * widthRatio,
                      // decoration:
                      //     BoxDecoration(border: Border.all(color: Colors.black)),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              // color: Colors.yellow.withOpacity(0.1),
                              height: 260 * heightRatio,
                              width: 300 * widthRatio,
                              child: Card(
                                color: Color.fromARGB(200, 60, 60, 60),
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(25 * widthRatio),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // color: Colors.red.withOpacity(0.1),
                                      padding: const EdgeInsets.only(
                                          top: 20, left: 24),
                                      child: InkWell(
                                        onTap: () {
                                          // Get.defaultDialog(title: 'Rishabn',content: Text('Enter '));
                                          Get.bottomSheet(
                                            Container(
                                              // color:
                                              //     Colors.white.withOpacity(0.1),
                                              width: double.infinity,
                                              height: heightRatio * 250,
                                              child: Container(
                                                color: Colors.white,
                                                // decoration: BoxDecoration(
                                                //   color: Colors.purple
                                                //       .withOpacity(0.1),
                                                //   borderRadius: BorderRadius.only(
                                                //     topLeft:
                                                //         Radius.circular(30.0),
                                                //     topRight:
                                                //         Radius.circular(30.0),
                                                //   ),
                                                // ),

                                                //child: Card(
                                                // shape: RoundedRectangleBorder(
                                                //     borderRadius:
                                                //         BorderRadius.only(
                                                //             topLeft:
                                                //                 Radius.circular(
                                                //                     30.0),
                                                //             topRight:
                                                //                 Radius.circular(
                                                //                     30.0))),
                                                // elevation: 10,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(height: 20),
                                                    Text(
                                                        'Enter the Youtube Link',
                                                        style: TextStyle(
                                                            fontSize: 20)),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top:
                                                              heightRatio * 20),
                                                      height: heightRatio * 80,
                                                      width: widthRatio * 300,
                                                      child: TextField(
                                                        controller: yturl,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top:
                                                              heightRatio * 10),
                                                      child: RaisedButton(
                                                        shape: StadiumBorder(),
                                                        onPressed: () {
                                                          roomLogicController
                                                                  .ytURL.value =
                                                              yturl.text;

                                                          Navigator.pop(
                                                              context);

                                                          Get.to(YTPlayer());
                                                          // Navigator.pop(
                                                          //     context);
                                                        },
                                                        child: Text('Play'),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              //),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'lib/assets/svgs/youtubeplayer.svg',
                                              width: 70 * heightRatio,
                                              height: 70 * widthRatio,
                                            ),
                                            SizedBox(width: 10 * widthRatio),
                                            Text(
                                              'Youtube',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.red),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      // color: Colors.orange.withOpacity(0.1),
                                      padding: const EdgeInsets.only(left: 36),
                                      child: InkWell(
                                        onTap: () {
                                          print("adminId");
                                          print(roomLogicController
                                              .adminId.value);
                                          // filePick();
                                          bottomSheet();
                                        },
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'lib/assets/svgs/localplayer.svg',
                                              width: 40 * widthRatio,
                                              height: 40 * heightRatio,
                                              //color: Colors.white,
                                            ),
                                            SizedBox(width: 10 * widthRatio),
                                            Text(
                                              'Local Media',
                                              style: TextStyle(
                                                fontSize: 20,
                                                //color: Colors.white
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20 * heightRatio),
                                    Container(
                                      // color: Colors.white.withOpacity(0.1),
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Row(
                                        // mainAxisAlignment:
                                        //     MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          FutureBuilder(
                                              future: Future.delayed(
                                                  Duration(seconds: 2)),
                                              builder: (cts, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.done) {
                                                  return StreamBuilder(
                                                      stream: roomLogicController
                                                          .adminBsdkKaNaam(
                                                              firebaseId:
                                                                  roomLogicController
                                                                      .roomFireBaseId),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          return Text(
                                                            '${snapshot.data.snapshot.value}',
                                                            style: TextStyle(
                                                                fontSize: 30),
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return Text('Error');
                                                        }
                                                        return Text('');
                                                      });
                                                }
                                                return Container();
                                              }),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, bottom: 0),
                                            child: SvgPicture.asset(
                                              'lib/assets/svgs/crown.svg',
                                              height: 27 * heightRatio,
                                              width: 27 * widthRatio,
                                              color: Colors.orange,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10 * heightRatio),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: GetX<RoomLogicController>(
                                          builder: (controller) {
                                        return Text(
                                            'Room no: ${controller.roomId.obs.value} ',
                                            style: TextStyle(fontSize: 15));
                                      }),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: SvgPicture.asset('lib/assets/svgs/movie.svg',
                                width: 120 * widthRatio,
                                height: 120 * heightRatio),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40 * heightRatio),
                  Expanded(
                    // margin: EdgeInsets.only(left: 20),
                    // color: Colors.blue.withOpacity(0.1),
                    // height: heightRatio * 300,
                    // width: widthRatio * 200,
                    // height: 500,
                    child: Container(
                      width: 300 * widthRatio,
                      // color: Colors.red,
                      child: FutureBuilder(
                          future: Future.delayed(Duration(seconds: 2)),
                          builder: (ctx, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return StreamBuilder(
                                stream: rishabhController.tester(
                                    firebaseId:
                                        roomLogicController.roomFireBaseId),
                                builder: (ctx, event) {
                                  if (event.hasData) {
                                    return NotificationListener<
                                        OverscrollIndicatorNotification>(
                                      onNotification: (overscroll) {
                                        overscroll.disallowGlow();
                                      },
                                      child: ListView.separated(
                                        scrollDirection: Axis.vertical,
                                        separatorBuilder: (ctx, i) {
                                          return SizedBox(
                                            width: 5,
                                          );
                                        },
                                        itemBuilder: (ctx, i) {
                                          print(
                                              'chut: ${event.data.snapshot.value}');
                                          return CustomNameBar(
                                            roomController: roomLogicController,
                                            userID: event
                                                .data.snapshot.value.values
                                                .toList()[i]['id'],
                                            event: event,
                                            index: i,
                                            widthRatio: widthRatio,
                                            heightRatio: heightRatio,
                                            controller: funLogic,
                                          );
                                        },
                                        itemCount: event
                                            .data.snapshot.value.values
                                            .toList()
                                            .length,
                                      ),
                                    );
                                  } else if (event.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                  return Container(height: 0.0, width: 0.0);
                                },
                              );
                            }
                            return Container();
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomNameBar extends StatefulWidget {
  final AsyncSnapshot event;
  final int index;
  final double heightRatio;
  final double widthRatio;
  final String userID;
  final FunLogic controller;
  final RoomLogicController roomController;
  CustomNameBar({
    this.event,
    this.index,
    this.heightRatio,
    this.widthRatio,
    this.controller,
    Key key,
    this.userID,
    this.roomController,
  }) : super(key: key);

  @override
  _CustomNameBarState createState() => _CustomNameBarState();
}

class _CustomNameBarState extends State<CustomNameBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 224 * widget.widthRatio,
      height: 90 * widget.heightRatio,
      child: Card(
        color: Color.fromARGB(200, 60, 60, 60),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        // width: 20,
        // height: 70,
        // color: Colors.white,
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(25), color: Colors.white),

        child: Row(
          children: [
            SizedBox(width: widget.widthRatio * 12),
            ClipOval(
              child: Container(
                decoration: BoxDecoration(),
                width: 50,
                height: 50,
                child: Image.network(
                    'https://i.picsum.photos/id/56/200/200.jpg?hmac=rRTTTvbR4tHiWX7-kXoRxkV7ix62g9Re_xUvh4o47jA'),
              ),
            ),
            SizedBox(width: 20 * widget.heightRatio),
            Text(
              '${widget.event.data.snapshot.value.values.toList()[widget.index]['name']}',
              style: TextStyle(
                  fontSize: 25, color: widget.controller.randomColorPick),
            ),
            Spacer(),
            Column(
              children: [
                (widget.roomController.userId != widget.userID &&
                        widget.roomController.userId ==
                            widget.roomController.adminId.value)
                    ? ClipOval(
                        child: GestureDetector(
                          onTap: () {
                            print(
                                "roomControllerUserId: ${widget.roomController.userId}");

                            print("UserId: ${widget.userID}");
                            widget.roomController.kickUser(
                                firebaseId:
                                    widget.roomController.roomFireBaseId,
                                idofUser: widget.userID);
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            color: Colors.red,
                            child: Center(child: Text('X')),
                          ),
                        ),
                      )
                    : Container(),
                Spacer()
              ],
            )
          ],
        ),
      ),
    );
  }
}
