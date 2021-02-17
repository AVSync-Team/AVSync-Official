import 'dart:async';

import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/chat.dart';
import 'package:VideoSync/controllers/funLogic.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/views/YTPlayer.dart';
import 'package:VideoSync/views/chat.dart';
import 'package:VideoSync/views/createRoom.dart';
import 'package:VideoSync/views/videoPlayer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:VideoSync/views/videoPlayer.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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

  // StreamController<List<dynamic>> _userController;
  // Timer timer;

  @override
  void initState() {
    super.initState();
    chatController
        .message(firebaseId: roomLogicController.roomFireBaseId)
        .listen((event) {
      List<M> check = [];

      event.snapshot.value.forEach((key, value) {
        check.add(M(
            id: DateTime.parse(value["messageId"]),
            mesage: value["message"],
            userId: value["userId"],
            username: value["username"]));
      });

      check.sort((a, b) => (a.id).compareTo(b.id));
      if (check[check.length - 1].userId != roomLogicController.userId)
        Get.snackbar(
            check[check.length - 1].username, check[check.length - 1].mesage);
    });
    // _userController = new StreamController();

    // timer = Timer.periodic(Duration(seconds: 3), (_) async {
    //   var data = await roomLogicController.loadDetails();
    //   _userController.add(data);
    // });
  }

  // @override
  // void dispose() {
  //   _userController.close();
  //   // _userController.done;
  //   timer.cancel();
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

  Widget open(snackbar) {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      //width: 380 * widthRatio,
      child: Drawer(
        child: ChattingPlace(snackbar: snackbar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: !(roomLogicController.adminKaNaam.obs.value ==
                  roomLogicController.userName.obs.value)
              ? Icon(Icons.exit_to_app_rounded)
              : Icon(Icons.delete),
          onPressed: () {
            Get.defaultDialog(
                buttonColor: Colors.green.withOpacity(0.1),
                title: !(roomLogicController.adminKaNaam.obs.value ==
                        roomLogicController.userName.obs.value)
                    ? 'Leave Room'
                    : 'Delete Room',
                confirm: RaisedButton(
                    color: Colors.green,
                    child: Text('Yes'),
                    onPressed: () {
                      if (!(roomLogicController.adminKaNaam.obs.value ==
                          roomLogicController.userName.obs.value)) {
                        rishabhController.userLeaveRoom(
                          firebaseId: roomLogicController.roomFireBaseId,
                          userId: roomLogicController.userId,
                        );
                      } else {
                        roomLogicController.adminDeleteRoom(
                            firebaseId: roomLogicController.roomFireBaseId);
                      }
                      Get.offAll(CreateRoomScreen());
                      // Get.off(CreateRoomScreen());
                    }),
                cancel: RaisedButton(
                    color: Colors.red,
                    child: Text('No'),
                    onPressed: () {
                      Get.back();
                    }),
                content: !(roomLogicController.adminKaNaam.obs.value ==
                        roomLogicController.userName.obs.value)
                    ? Text('Do you want to leave the room ? ')
                    : Text('Do you want to delete the room ? '));
          },
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.chat_bubble_rounded),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          )
        ],
        backgroundColor: themeController.switchContainerColor.value,
      ),
      // appBar: AppBar(),

      // endDrawer: Theme(
      //   data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      //   //width: 380 * widthRatio,
      //   child: Drawer(
      //     child: ChattingPlace(snackbar: snackbar),
      //   ),
      // ),
      backgroundColor: themeController.primaryColor.value,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: Get.height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Text('Users: '),
                // SizedBox(height: 40),

                Text(
                  'Room',
                  style: TextStyle(color: Colors.white, fontSize: 50),
                ),
                // StreamBuilder(
                //   stream: rishabhController.tester(
                //       firebaseId: roomLogicController.roomFireBaseId),
                //   builder: (context, snapshot) {
                //     return Container(
                //       height: 100,
                //       child: ListView.builder(
                //         itemBuilder: (ctx, i) {
                //           return Text('Rishabh');
                //         },
                //         itemCount:
                //             snapshot.data.snapshot.value.values.toList().length,
                //       ),
                //     );

                //     // return RaisedButton(onPressed: () {
                //     //   print(snapshot.data.snapshot.value.values.toList());

                //     //   rishabhController.userLeaveRoom(
                //     //       firebaseId: '-MScDAopj96DypuMqyNh', userId: '2312312');
                //   },
                // ),
                SizedBox(
                  height: 37 * heightRatio,
                ),
                Hero(
                  tag: 'Rishabh',
                  child: Container(
                    color: Colors.green.withOpacity(0.1),
                    height: 350 * heightRatio,
                    width: 330 * widthRatio,
                    // decoration:
                    //     BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            color: Colors.yellow.withOpacity(0.1),
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
                                    color: Colors.red.withOpacity(0.1),
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 24),
                                    child: InkWell(
                                      onTap: () {
                                        // Get.defaultDialog(title: 'Rishabn',content: Text('Enter '));
                                        Get.bottomSheet(
                                          Container(
                                            color:
                                                Colors.white.withOpacity(0.1),
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
                                                  Text('Enter the Youtube Link',
                                                      style: TextStyle(
                                                          fontSize: 20)),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: heightRatio * 20),
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
                                                                  .circular(20),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: heightRatio * 10),
                                                    child: RaisedButton(
                                                      shape: StadiumBorder(),
                                                      onPressed: () {
                                                        roomLogicController
                                                            .ytURL
                                                            .value = yturl.text;
                                                        Get.to(YTPlayer());
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
                                    color: Colors.orange.withOpacity(0.1),
                                    padding: const EdgeInsets.only(left: 36),
                                    child: InkWell(
                                      onTap: () {
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
                                    color: Colors.white.withOpacity(0.1),
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

                // FutureBuilder(
                //     future: Future.delayed(Duration(seconds: 2)),
                //     builder: (ctx, snapshot) {
                //       if (snapshot.connectionState == ConnectionState.done) {
                //         return StreamBuilder(
                //           builder: (ctx, event) {
                //             if (event.hasData) {
                //               print('snapshot: ${event.data.snapshot.value}');
                //             }

                //             return Container(height: 0, width: 0);
                //           },
                //           stream: rishabhController.tester(
                //               firebaseId: roomLogicController.roomFireBaseId),
                //         );
                //       }
                //       return Container();
                //     }),

                Expanded(
                  child: FutureBuilder(
                      future: Future.delayed(Duration(seconds: 2)),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return StreamBuilder(
                            stream: rishabhController.tester(
                                firebaseId: roomLogicController.roomFireBaseId),
                            builder: (ctx, event) {
                              if (event.hasData) {
                                // Future.delayed(
                                //     Duration(seconds: 2),
                                //     () => {
                                //           Get.snackbar(
                                //               "",
                                //               event.data.snapshot.value[event
                                //                           .data
                                //                           .snapshot
                                //                           .value
                                //                           .length -
                                //                       1]['name'] +
                                //                   "joined!")
                                //         });

                                return Container(
                                  // height: 100,
                                  width: 300 * widthRatio,
                                  child: NotificationListener<
                                      OverscrollIndicatorNotification>(
                                    onNotification: (overscroll) {
                                      overscroll.disallowGlow();
                                    },
                                    child: ListView.separated(
                                      separatorBuilder: (ctx, i) {
                                        return SizedBox(
                                          height: 20 * heightRatio,
                                        );
                                      },
                                      itemBuilder: (ctx, i) {
                                        print(
                                            'chut: ${event.data.snapshot.value}');
                                        return CustomNameBar(
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
              ],
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
  final FunLogic controller;
  CustomNameBar({
    this.event,
    this.index,
    this.heightRatio,
    this.widthRatio,
    this.controller,
    Key key,
  }) : super(key: key);

  @override
  _CustomNameBarState createState() => _CustomNameBarState();
}

class _CustomNameBarState extends State<CustomNameBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Card(
        color: Color.fromARGB(200, 60, 60, 60),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        // width: 20,
        // height: 70,
        // color: Colors.white,
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(25), color: Colors.white),

        child: Center(
          child: Text(
            '${widget.event.data.snapshot.value.values.toList()[widget.index]['name']}',
            style: TextStyle(
                fontSize: 30, color: widget.controller.randomColorPick),
          ),

          // InkWell(
          //   onTap: () {
          //     Get.showSnackbar(GetBar(
          //       title: 'Rishabh',
          //       message: 'Hi I am Rishabh',
          //       duration: Duration(seconds: 2),
          //     ));
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.only(right: 30),
          //     child: SvgPicture.asset(
          //       'lib/assets/svgs/emoji.svg',
          //       width: 30 * widthRatio,
          //       height: 30 * heightRatio,
          //       color: Color(0xffF15757),
          //     ),
          //   ),
          //)
        ),
      ),
    );
  }
}
