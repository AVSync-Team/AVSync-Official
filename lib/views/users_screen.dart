import 'dart:async';
import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/chat.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/controllers/ytPlayercontroller.dart';
import 'package:VideoSync/video_manager/photoLibMain.dart';
import 'package:VideoSync/views/video%20players/YTPlayer.dart';
import 'package:VideoSync/views/createRoom.dart';
import 'package:VideoSync/views/video%20players/anyPlayer.dart';
import 'package:VideoSync/views/webShow.dart';
import 'package:VideoSync/widgets/chat_list_view.dart';
import 'package:VideoSync/widgets/chat_send_.dart';
import 'package:VideoSync/widgets/custom_button.dart';
import 'package:VideoSync/widgets/custom_namebar.dart';
import 'package:VideoSync/widgets/video_started_widget.dart';
import 'package:clipboard/clipboard.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class WelcomScreen extends StatefulWidget {
  @override
  _WelcomScreenState createState() => _WelcomScreenState();
}

class _WelcomScreenState extends State<WelcomScreen> {
  RoomLogicController roomLogicController = Get.put(RoomLogicController());
  RishabhController rishabhController = Get.put(RishabhController());
  ChatController chatController = Get.put(ChatController());
  YTStateController ytStateController = Get.put(YTStateController());
  TextEditingController chatTextController = TextEditingController();
  final double heightRatio = Get.height / 823;
  final double widthRatio = Get.width / 411;
  bool picking;
  double xOffset = 0;
  double yOffset = 0;
  double zOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;
  bool leaveRoom = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    roomLogicController.adminIdd(firebaseId: roomLogicController.roomFireBaseId).listen((event) {
      print("adminId");
      roomLogicController.adminId.value = event.snapshot.value;
      setState(() {});
    });
    //checks the room status if status = 0 , then room is kicked
    // status = 1,then room is fine

    roomLogicController.ytlink(firebaseId: roomLogicController.roomFireBaseId).listen((event) {
      roomLogicController.ytURL.value = event.snapshot.value;
      yturl.text = roomLogicController.ytURL.value;
    });
    roomLogicController.roomStatus(firebaseId: roomLogicController.roomFireBaseId).listen((event) {
      int x = event.snapshot.value;
      if (x == 0 && !(roomLogicController.adminId.value == roomLogicController.userId.obs.value)) {
        if (Get.context.orientation == Orientation.landscape)
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        Get.offAll(CreateRoomScreen());
        buildShowDialog(context, title: "Room Deleted", content: "The admin has deleted the room :(");
      }
    });

    //checks the status status if status = 0 , then user is kicked
    // status = 1,then user is fine
    if (!(roomLogicController.adminId.value == roomLogicController.userId.obs.value))
      roomLogicController
          .userStatus(
        firebaseId: roomLogicController.roomFireBaseId,
        // idOfUser: roomLogicController.userId
      )
          .listen((event) {
        int x = event.snapshot.value;

        if (x == 0 && !(roomLogicController.adminId.value == roomLogicController.userId.obs.value)) {
          if (Get.context.orientation == Orientation.landscape)
            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          Get.offAll(CreateRoomScreen());
          buildShowDialog(context, title: "Kicked from room", content: "The admin has kicked you from the room :(");
        }
      });
    listenToTextInputStateChanges();
  }

  void listenToTextInputStateChanges() {
    chatTextController.addListener(() {
      print("TextState: ${chatTextController.text}");
      if (chatTextController.text == "") {
        chatController.isTextEmpty.value = true;
      } else {
        chatController.isTextEmpty.value = false;
      }
      print('TextState: ${chatController.isTextEmpty}');
    });
  }

  void youTubeBottomSheet() {
    Get.bottomSheet(
      Container(
        width: double.infinity,
        height: heightRatio * 250,
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text('Video Link', style: TextStyle(fontSize: 20)),
              Container(
                margin: EdgeInsets.only(top: heightRatio * 20),
                height: heightRatio * 80,
                width: widthRatio * 300,
                child: TextField(
                  controller: yturl,
                  onChanged: (String value) {
                    ytStateController.checkLinkValidty(value);
                  },
                  cursorColor: Colors.red,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
              ),
              Obx(
                () => Container(
                  margin: EdgeInsets.only(top: heightRatio * 10),
                  child: Row(
                    children: [
                      Spacer(),
                      //mp4 player
                      if (ytStateController.linkType.value == LinkType.BrowserLink &&
                          ytStateController.linkValidity.value == LinkValidity.Valid)
                        CustomButton(
                          function: () async {
                            //load the YT URL
                            await sendToBrowserPlayerPage();
                          },
                          buttonColor: Colors.blue,
                          content: 'MP4 Video',
                          contentSize: 10,
                          cornerRadius: 10,
                          height: 40,
                          textColor: Colors.white,
                          width: 100,
                        ),
                      SizedBox(width: 8),
                      //yt video button
                      if (ytStateController.linkType.value == LinkType.YTLink &&
                          ytStateController.linkValidity.value == LinkValidity.Valid)
                        CustomButton(
                          function: () async {
                            //load the YT URL
                            await sendToYTPage();
                          },
                          buttonColor: Colors.redAccent,
                          content: 'YouTube Video',
                          contentSize: 20,
                          cornerRadius: 10,
                          height: 40,
                          textColor: Colors.white,
                          // width: ,
                        ),
                      Spacer()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        //),
      ),
    );
  }

  Future<void> sendToBrowserPlayerPage() async {
    roomLogicController.ytURL.value = yturl.text;
    roomLogicController.sendYtLink(ytlink: roomLogicController.ytURL.value);
    roomLogicController.sendYtStatus(status: 'loaded');
    Navigator.pop(context);
    await Future.delayed(Duration(seconds: 1));
    Get.to(AnyPlayer());
  }

  Future<void> sendToYTPage() async {
    roomLogicController.ytURL.value = yturl.text;
    roomLogicController.sendYtLink(ytlink: roomLogicController.ytURL.value);
    roomLogicController.sendYtStatus(status: 'loaded');
    Navigator.pop(context);
    await Future.delayed(Duration(seconds: 1));
    Get.to(YTPlayer());
  }

  //opens the local player
  void localMediaPlayerFileSelectionBottomSheet() {
    Get.defaultDialog(title: 'Local Media', middleText: "Search for a video in your local storage", actions: [
      TextButton(
        onPressed: () async {
          Navigator.of(context).pop();

          Get.to(PhotoLibMain());
        },
        child: Text('Search'),
      ),
    ]);
  }

  void snackbar(String name, String message) {
    Get.snackbar(name, message);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    FocusNode currenFocus = FocusScope.of(context);
    return WillPopScope(
      onWillPop: () async {
        await buildShowDialog(context, content: "Do you wish to go back ", title: "Leaving room", customFunction: () {
          setState(() {
            leaveRoom = true;
          });
          roomLogicController.userLeaveRoom(
              firebaseId: roomLogicController.roomFireBaseId,
              adminId: roomLogicController.adminId.value,
              userId: roomLogicController.userId);
          Get.offAll(CreateRoomScreen());
        });
        return leaveRoom;
      },
      child: AnimatedContainer(
        transform: Matrix4.translationValues(xOffset, yOffset, zOffset)..scale(scaleFactor),
        duration: Duration(milliseconds: 350),
        decoration: BoxDecoration(
          color: themeController.primaryColor.value,
          borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: isDrawerOpen ? Colors.transparent : Color.fromRGBO(41, 39, 39, 1),
            elevation: 0,
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
                    icon: !(roomLogicController.adminId.value == roomLogicController.userId.obs.value)
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
                    },
                  ),
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.chat_bubble),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              )
            ],
            centerTitle: true,
            // title:
          ),
          endDrawer: Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: Drawer(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 33,
                    ),
                    width: 200,
                    color: Color.fromRGBO(35, 35, 35, 1),
                    padding: EdgeInsets.all(
                      7,
                    ),
                    child: Center(
                      child: Text(
                        'you can chat here',
                        style: TextStyle(
                          color: Colors.white38,
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: ChatListViewWidget()),
                  ChatSend(chatHeight: 50, chatTextController: chatTextController, currenFocus: currenFocus)
                ],
              ),
            ),
          ),
          body: Center(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: Get.height,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SizedBox(
                  //   height: 10 * heightRatio,
                  StreamBuilder(
                    stream: roomLogicController.ytVideoLoadedStatus(firebaseId: roomLogicController.roomFireBaseId),
                    builder: (BuildContext ctx, AsyncSnapshot<Event> snapshot) {
                      if (snapshot.hasData) {
                        //now if video not loaded then don't show anything
                        if (snapshot.data.snapshot.value == "loaded") {
                          //look into it
                          return VideoStartedWidgetDisplay();
                        } else {
                          //if video not loaded then don't show anything
                          // return VideoStartedWidgetDisplay();
                          return SizedBox(
                            height: 10 * heightRatio,
                          );
                        }
                      }
                      return Container();
                    },
                  ),
                  Text('Room Code', style: TextStyle(fontSize: 15, color: Colors.white)),
                  SizedBox(height: 10),
                  GetX<RoomLogicController>(builder: (controller) {
                    return Container(
                      width: widthRatio * 165,
                      height: heightRatio * 50,
                      // padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.amber,
                            width: 2,
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 5),
                          Text(' ${controller.roomId.obs.value} ', style: TextStyle(fontSize: 20, color: Colors.white)),
                          IconButton(
                            // iconSize: 10,
                            onPressed: () {
                              //copy the room code
                              FlutterClipboard.copy(
                                      "Hey !\nI have downloaded this awesome app where you can watch videos with friends and chat with them online !! \nJoin my room here : ${controller.roomId.obs.value}")
                                  .then(
                                (value) => Get.snackbar("Room Id Copied", "Share your room id with friend !!",
                                    backgroundColor: Colors.black38,
                                    snackPosition: SnackPosition.TOP,
                                    colorText: Colors.white,
                                    snackStyle: SnackStyle.FLOATING),
                              );
                            },
                            icon: Icon(
                              Icons.copy,
                              color: Colors.white,
                              // size: 10,
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                  // StreamBuilder(
                  //   stream: roomLogicController.ytVideoLoadedStatus(
                  //       firebaseId: roomLogicController.roomFireBaseId),
                  //   builder: (BuildContext ctx, AsyncSnapshot<Event> snapshot) {
                  //     if (snapshot.hasData) {
                  //       //now if video not loaded then don't show anything
                  //       if (snapshot.data.snapshot.value == "loaded") {
                  //         //look into it
                  //         return VideoStartedWidgetDisplay();
                  //       } else {
                  //         //if video not loaded then don't show anything
                  //         // return VideoStartedWidgetDisplay();
                  //         return SizedBox(
                  //           height: 10 * heightRatio,
                  //         );
                  //       }
                  //     }
                  //     return Container();
                  //   },
                  // ),
                  Hero(
                    tag: 'Rishabh',
                    child: Container(
                      // color: Colors.yellow.withOpacity(0.1),
                      height: 250 * heightRatio,
                      width: 270 * widthRatio,
                      child: Card(
                        color: Color.fromARGB(200, 60, 60, 60),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25 * widthRatio),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // color: Colors.red.withOpacity(0.1),
                              padding: const EdgeInsets.only(top: 25),
                              child: CustomButton(
                                buttonColor: Colors.redAccent,
                                content: 'Browse Online',
                                contentSize: 20,
                                cornerRadius: 10,
                                height: heightRatio * 40,
                                textColor: Colors.white,
                                function: () {
                                  //////////////////////////////asking for opening webview or link bottom sheet directly///////////////////////
                                  Get.defaultDialog(
                                      title: 'Browse Video',
                                      middleText:
                                          "Search the video you are looking for or if you have the link then enter it :)",
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            youTubeBottomSheet();
                                          },
                                          child: Text('Enter link'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            youTubeBottomSheet();
                                            await Get.to(WebShow());
                                            FlutterClipboard.paste().then((value) => yturl.text = value);
                                          },
                                          child: Text('Browse for link'),
                                        ),
                                      ]);
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              child: CustomButton(
                                buttonColor: Colors.blueAccent,
                                content: 'Local Media',
                                contentSize: 20,
                                cornerRadius: 10,
                                height: heightRatio * 40,
                                textColor: Colors.white,
                                function: () {
                                  localMediaPlayerFileSelectionBottomSheet();
                                },
                              ),
                            ),
                            SizedBox(height: 20 * heightRatio),
                            Container(
                              child: Row(
                                // mainAxisAlignment:
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.ideographic,
                                children: [
                                  Spacer(),
                                  StreamBuilder(
                                      stream: roomLogicController.adminBsdkKaNaam(
                                          firebaseId: roomLogicController.roomFireBaseId),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Container(
                                            child: Text(
                                              '${snapshot.data.snapshot.value}',
                                              style: TextStyle(color: Colors.white, fontSize: 25),
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text('Error');
                                        }
                                        return Text('');
                                      }),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10, bottom: 0),
                                    child: SvgPicture.asset(
                                      'lib/assets/svgs/crown.svg',
                                      height: 27 * heightRatio,
                                      width: 27 * widthRatio,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40 * heightRatio),
                  Expanded(
                    child: Container(
                      width: 300 * widthRatio,
                      // color: Colors.red,
                      child: StreamBuilder(
                        stream: rishabhController.tester(firebaseId: roomLogicController.roomFireBaseId),
                        builder: (ctx, event) {
                          if (event.hasData) {
                            return NotificationListener<OverscrollIndicatorNotification>(
                              onNotification: (overscroll) {
                                overscroll.disallowGlow();
                                return null;
                              },
                              child: ListView.separated(
                                scrollDirection: Axis.vertical,
                                separatorBuilder: (ctx, i) {
                                  return SizedBox(
                                    width: 5,
                                  );
                                },
                                itemBuilder: (ctx, i) {
                                  print('chut: ${event.data.snapshot.value}');
                                  return CustomNameBar(
                                    userName: event.data.snapshot.value.values.toList()[i]['name'],
                                    roomController: roomLogicController,
                                    userID: event.data.snapshot.value.values.toList()[i]['id'],
                                    event: event,
                                    index: i,
                                    widthRatio: widthRatio,
                                    heightRatio: heightRatio,
                                    // controller: funLogic,
                                    imageSize: 50,
                                    textSize: 25,
                                  );
                                },
                                itemCount: event.data.snapshot.value.values.toList().length,
                              ),
                            );
                          } else if (event.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(themeController.drawerHead.value),
                              ),
                            );
                          } else {
                            return Center(
                                child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(themeController.drawerHead.value),
                            ));
                          }
                        },
                      ),
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

  Future buildShowDialog(BuildContext context,
      {String userName, String title, String content, Function customFunction}) {
    return showDialog(
      context: context,
      builder: (context) => Container(
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('$title', style: TextStyle(color: Colors.blueAccent)),
          content: Text("$content"),
          actions: <Widget>[
            CustomButton(
              height: 30,
              buttonColor: Colors.blueAccent,
              content: "Cancel",
              cornerRadius: 5,
              contentSize: 14,
              function: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            //checks if the customfunction is not null
            customFunction != null
                ? CustomButton(
                    height: 30,
                    buttonColor: Colors.blueAccent,
                    content: "Leave",
                    cornerRadius: 5,
                    contentSize: 14,
                    function: customFunction)
                : Container(),
          ],
        ),
      ),
    );
  }
}
