import 'dart:io';
import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/chat.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/controllers/ytPlayercontroller.dart';
import 'package:VideoSync/views/video%20players/YTPlayer.dart';
import 'package:VideoSync/views/webShow.dart';
import 'package:VideoSync/widgets/chat_list_view.dart';
import 'package:VideoSync/widgets/chat_send_.dart';
import 'package:VideoSync/widgets/custom_button.dart';
import 'package:VideoSync/widgets/custom_namebar.dart';
import 'package:VideoSync/widgets/custom_text.dart';
import 'package:clipboard/clipboard.dart';
// import 'package:VideoSync/views/chat.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class AnyPlayer extends StatefulWidget {
  @override
  _AnyPlayerState createState() => _AnyPlayerState();
}

RoomLogicController roomLogicController = Get.put(RoomLogicController());
ChatController chatController = Get.put(ChatController());
YTStateController ytStateController = Get.put(YTStateController());
RishabhController rishabhController = Get.put(RishabhController());
CustomThemeData themeData = Get.put(CustomThemeData());
AnimationController animationController;
final double heightRatio = Get.height / 823;
final double widthRatio = Get.width / 411;

class _AnyPlayerState extends State<AnyPlayer> {
  ///            `controllers`
  AnimationController _animationController;
  VideoPlayerController controller;
  VideoPlayerController subsController;

  ///             `properties`
  Duration videoLength;
  final double heightRatio = Get.height / 823;
  final double widthRatio = Get.width / 411;
  int timestamp = 0;
  // bool dontHideControlsBool = true;
  bool hideUI = false;
  double animatedHeight = 30;
  bool shoSpeedWidget = false;
  bool playerIsUser = true;
  int selectedRadio;
  bool isLoading = false;
  bool picking = false;
  String path = "";
  TextEditingController chatTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    //animation controller

    ///`Video Player Controller`

    controller = VideoPlayerController.network(roomLogicController.ytURL.value,
        // closedCaptionFile: _loadCaptions(),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
      ..initialize().then((_) {
        setState(() {
          videoLength = controller.value.duration;
        });
      });

    //closed captions
    // initializeSubs();

    //firebase
    var firebaseDatabase = FirebaseDatabase.instance.reference();
    firebaseDatabase
        .child('Rooms')
        .child(roomLogicController.roomFireBaseId.obs.value)
        .child('timeStamp')
        .onValue
        .listen((event) {
      if (!(roomLogicController.adminId.value ==
          roomLogicController.userId.obs.value)) {
        if ((controller.value.position.inSeconds - event.snapshot.value)
                .abs() >=
            5) {
          controller.seekTo(Duration(seconds: event.snapshot.value));
        }
      }
    });

    firebaseDatabase
        .child('Rooms')
        .child(roomLogicController.roomFireBaseId.obs.value)
        .child('isPlayerPaused')
        .onValue
        .listen((event) {
      if (event.snapshot.value) {
        controller.pause();
        // print(event.snapshot.value);
      } else {
        controller.play();
      }
    });

    firebaseDatabase
        .child('Rooms')
        .child(roomLogicController.roomFireBaseId.obs.value)
        .child('playBackSpeed')
        .onValue
        .listen((event) {
      if (!(roomLogicController.adminId.value ==
          roomLogicController.userId.obs.value)) {
        // controller.setPlaybackRate(event.snapshot.value);
        controller.setPlaybackSpeed(event.snapshot.value);
      }
    });

    // hideControls();

    selectedRadio = 1;

    //video controller listeners
    addListener();
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

  void addListener() {
    return controller.addListener(() {
      roomLogicController.videoPosition.value = controller.value.position;
      roomLogicController.playingStatus.value = controller.value.isPlaying;
      //check if controller is loaded

      ytStateController.videoPosition.value =
          controller.value.position.inSeconds.toDouble();

      //admin
      //will send timestamp and control video playback
      if (roomLogicController.adminId.value ==
          roomLogicController.userId.obs.value) {
        rishabhController.sendTimeStamp(
            firebaseId: roomLogicController.roomFireBaseId,
            timeStamp: controller.value.position.inSeconds);
      }
      setState(() {});
    });
  }

  youWebShe() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: WebShow(),
        );
      },
    );
  }

  youBotShe() {
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
              Text('Enter the Link', style: TextStyle(fontSize: 20)),
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
                        borderSide: new BorderSide(
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
                      if (ytStateController.linkType.value ==
                              LinkType.BrowserLink &&
                          ytStateController.linkValidity.value ==
                              LinkValidity.Valid)
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
                          ytStateController.linkValidity.value ==
                              LinkValidity.Valid)
                        CustomButton(
                          function: () async {
                            //load the YT URL
                            await sendToYTPage();
                          },
                          buttonColor: Colors.redAccent,
                          content: 'YouTube Video',
                          contentSize: 10,
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

  getDialogBox() {
    Get.defaultDialog(
      title: 'Link Input',
      middleText: 'Select where do you want to input the link',
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            youBotShe();
          },
          child: Text('Link'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            youBotShe();
            //await Get.to(WebShow());
            youWebShe();
            yturl.text = roomLogicController.ytURL.value;
            FlutterClipboard.paste().then((value) {
              print(value);
              yturl.text = value;
            });
          },
          child: Text('Browse Web'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    chatController.dispose();
    roomLogicController.dispose();
    rishabhController.dispose();
    controller.dispose();
  }

  Future<dynamic> showSpeedAlertDialog() {
    return Get.defaultDialog(
      titleStyle: TextStyle(color: Colors.white, fontSize: 12),
      backgroundColor: Color(0xff292727),
      title: 'Speed',
      content: Obx(
        () => Container(
          width: 200,
          // height: 170,
          child: SliderTheme(
            data: SliderThemeData(
                activeTrackColor: Colors.greenAccent,
                activeTickMarkColor: Colors.green,
                showValueIndicator: ShowValueIndicator.always),
            child: Slider(
              min: 1.0,
              max: 2.0,
              divisions: 10,
              label: '${rishabhController.playBackSpeedValue.value}',
              value: rishabhController.playBackSpeedValue.value,
              onChanged: (value) {
                rishabhController.playBackSpeedValue.value = value;
                controller.setPlaybackSpeed(value);
                rishabhController.changePlayBackSpeed(
                    roomLogicController.roomFireBaseId,
                    rishabhController.playBackSpeedValue.value);
              },
            ),
          ),
        ),
      ),
      cancel: CustomButton(
        function: () {
          Get.back();
        },
        buttonColor: Colors.blueAccent,
        content: 'Back',
        contentSize: 10,
        cornerRadius: 10,
        height: 30,
        textColor: Colors.white,
        width: 100,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final Orientation phoneOrientation = MediaQuery.of(context).orientation;
    FocusNode currenFocus = FocusScope.of(context);

    return Scaffold(
      appBar: phoneOrientation == Orientation.portrait
          ? AppBar(
              backgroundColor: Color(0xff292727),
              elevation: 0,
              leading: GestureDetector(
                onTap: () {
                  Get.bottomSheet(
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      color: Color.fromRGBO(10, 10, 10, 0.9),
                      width: double.infinity,
                      height: 300,
                      // color: Colors.red,
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              width: double.infinity,
                              child: Text(
                                'All Users',
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 255, 255, 0.8),
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 250,
                            child: FutureBuilder(
                              future: Future.delayed(Duration(seconds: 1)),
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
                                              print(
                                                  'chut: ${event.data.snapshot.value}');
                                              return Container(
                                                width: 80,
                                                height: 60,
                                                child: CustomNameBar(
                                                  userName: event.data.snapshot
                                                      .value.values
                                                      .toList()[i]['name'],
                                                  roomController:
                                                      roomLogicController,
                                                  userID: event.data.snapshot
                                                      .value.values
                                                      .toList()[i]['id'],
                                                  event: event,
                                                  index: i,
                                                  widthRatio: widthRatio,
                                                  heightRatio: heightRatio,
                                                  imageSize: 35,
                                                  textSize: 17,
                                                ),
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
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                new AlwaysStoppedAnimation<
                                                        Color>(
                                                    themeController
                                                        .drawerHead.value),
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                new AlwaysStoppedAnimation<
                                                        Color>(
                                                    themeController
                                                        .drawerHead.value),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    //),
                  );
                },
                child: Icon(Icons.people),
              ),
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: GetX<RoomLogicController>(builder: (controller) {
                  return Text(
                    '${controller.roomId.obs.value} ',
                    style: TextStyle(
                      fontFamily: 'Consolas',
                      fontSize: 20,
                      // fontWeight: FontWeight.w100,
                    ),
                  );
                }),
              ),
              actions: [
                Container(
                  padding: EdgeInsets.only(right: 13),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Icon(Icons.link),
                        onTap: () {
                          Get.snackbar(
                            '',
                            '',
                            snackPosition: SnackPosition.BOTTOM,
                            snackStyle: SnackStyle.GROUNDED,
                            duration: Duration(seconds: 4),
                            messageText: Text(
                              'Do you want to watch another video?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            titleText: Container(),
                            margin: const EdgeInsets.only(
                                bottom: kBottomNavigationBarHeight,
                                left: 8,
                                right: 8),
                            padding: const EdgeInsets.only(
                                top: 8, bottom: 10, left: 16, right: 16),
                            borderRadius: 20,
                            backgroundColor: Color.fromRGBO(20, 20, 20, 1),
                            colorText: Colors.white10,
                            mainButton: FlatButton(
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
                              ),
                              onPressed: () {
                                getDialogBox();
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        child: buttonEnumState == ButtonEnumState.Message
                            ? Icon(Icons.message)
                            : Icon(Icons.fullscreen),
                        onTap: () {
                          if (buttonEnumState == ButtonEnumState.Full_Screen)
                            setState(() {
                              //Need comments here Manav
                              //what happens when it's zero and what happens when it's 1

                              buttonEnumState = ButtonEnumState.Message;
                            });
                          else
                            setState(() {
                              buttonEnumState = ButtonEnumState.Full_Screen;
                            });
                        },
                      ),
                    ],
                  ),
                )
              ],
            )
          : null,
      backgroundColor: themeData.primaryColor.value,
      body: Container(
        child: Column(
          children: [
            SizedBox(
                height: phoneOrientation == Orientation.portrait &&
                        buttonEnumState == ButtonEnumState.Message
                    ? 200
                    : 0),
            Container(
              height: phoneOrientation == Orientation.portrait
                  ? size.height * 0.3
                  : size.height * .98,
              width: phoneOrientation == Orientation.portrait
                  ? size.width
                  : size.width,
              child: Stack(
                children: [
                  //The youtube player
                  Align(
                    alignment: Alignment.center,
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      // width: double.infinity,
                      child: VideoPlayer(controller),
                      // ClosedCaption(),
                    ),
                  ),

                  //Control UIs
                  //seek back 10
                  Container(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //For hiding or displaying UI
                            Expanded(
                              child: Container(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      hideUI = !hideUI;
                                      shoSpeedWidget = false;
                                      // animatedHeight = 0;
                                    });
                                  },
                                ),
                              ),
                            ),
                            // Spacer(
                            if (controller != null)
                              Obx(
                                () => Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          // margin: EdgeInsets.only(left: 5),
                                          child: Text(
                                              '${roomLogicController.videoPosition.value.toString().substring(0, 7)}',
                                              style: TextStyle(
                                                color: Colors.white,
                                              )),
                                        ),
                                        Expanded(
                                          child: SliderTheme(
                                            data: SliderThemeData(
                                              activeTrackColor: Colors.indigo,
                                              inactiveTrackColor:
                                                  Colors.indigo.shade200,
                                              trackShape:
                                                  RoundedRectSliderTrackShape(),
                                              trackHeight: 2.0,
                                              thumbShape: RoundSliderThumbShape(
                                                  enabledThumbRadius: 8.0),
                                              thumbColor: Colors.indigoAccent,
                                              overlayColor: Colors.indigo,
                                              overlayShape:
                                                  RoundSliderOverlayShape(
                                                      overlayRadius: 10.0),
                                              tickMarkShape:
                                                  RoundSliderTickMarkShape(),
                                              activeTickMarkColor:
                                                  Colors.indigo,
                                              inactiveTickMarkColor:
                                                  Colors.indigo,
                                              valueIndicatorShape:
                                                  PaddleSliderValueIndicatorShape(),
                                              valueIndicatorColor:
                                                  Colors.indigo,
                                            ),
                                            child: Slider(
                                              value: roomLogicController
                                                  .videoPosition.value.inSeconds
                                                  .toDouble(),
                                              onChanged: (value) {
                                                roomLogicController
                                                        .videoPosition.value =
                                                    Duration(
                                                        seconds: value.toInt());
                                                controller.seekTo(Duration(
                                                    seconds: value.toInt()));
                                              },
                                              min: 0.0,
                                              max: controller
                                                  .value.duration.inSeconds
                                                  .toDouble(),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                              '${controller.value.duration.toString().substring(0, 7)}',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        )
                                      ],
                                    )),
                              ),

                            //For all the controls
                            AnimatedContainer(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(25, 25, 25, 0.66),
                              ),
                              duration: Duration(milliseconds: 500),
                              height: hideUI ? 40 : 0,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 200),
                                opacity: hideUI ? 1 : 0,
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //seek backward 10
                                    SizedBox(width: 10),
                                    if (roomLogicController.adminId.value ==
                                        roomLogicController.userId.obs.value)
                                      IconButton(
                                        icon: Icon(Icons.speed),
                                        color: Colors.white,
                                        onPressed: () {
                                          showSpeedAlertDialog();
                                        },
                                      ),

                                    if (roomLogicController.adminId.value ==
                                        roomLogicController.userId.obs.value)
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.seekTo(Duration(
                                                seconds: controller.value
                                                        .position.inSeconds -
                                                    10));
                                          },
                                          child: SvgPicture.asset(
                                              'lib/assets/svgs/back10.svg',
                                              width: 30 * widthRatio,
                                              height: 30 * heightRatio),
                                        ),
                                      ),

                                    //play pause icon
                                    Expanded(
                                      // width: Get.width * 0.4,
                                      // color: Colors.blue.shade100,
                                      child: GestureDetector(
                                        onTap: () {
                                          // hideControls();
                                          if (controller.value.isPlaying) {
                                            rishabhController.sendPlayerStatus(
                                                status: true,
                                                firebaseId: roomLogicController
                                                    .roomFireBaseId);
                                            controller.pause();
                                          } else {
                                            rishabhController.sendPlayerStatus(
                                                status: false,
                                                firebaseId: roomLogicController
                                                    .roomFireBaseId);
                                            controller.pause();
                                            controller.play();
                                          }
                                        },
                                        child: Obx(
                                          () => roomLogicController
                                                  .playingStatus.value
                                              ? Icon(
                                                  Icons.pause,
                                                  size: 40,
                                                  color: Colors.white,
                                                )
                                              : Icon(
                                                  Icons.play_arrow,
                                                  size: 40,
                                                  color: Colors.white,
                                                ),
                                        ),
                                      ),
                                    ),

                                    //seek forward 10
                                    if (roomLogicController.adminId.value ==
                                        roomLogicController.userId.obs.value)
                                      Expanded(
                                        child: GestureDetector(
                                          child: SvgPicture.asset(
                                              'lib/assets/svgs/go10.svg',
                                              width: 30 * widthRatio,
                                              height: 30 * heightRatio),
                                          onTap: () {
                                            controller.seekTo(
                                              Duration(
                                                  seconds: controller.value
                                                          .position.inSeconds +
                                                      10),
                                            );
                                          },
                                        ),
                                      ),

                                    //Toggle fullscreen
                                    IconButton(
                                      icon: Icon(
                                        Icons.fullscreen,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        if (Get.context.isPortrait) {
                                          SystemChrome
                                              .setPreferredOrientations([
                                            DeviceOrientation.landscapeRight
                                          ]);
                                        } else if (Get.context.isLandscape) {
                                          SystemChrome.setPreferredOrientations(
                                              [DeviceOrientation.portraitUp]);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (phoneOrientation == Orientation.portrait) SizedBox(height: 10),

            //this is the chat display part of code
            //so if the buttonPressed == 1 then thos these UIs ok got it Manav

            if (phoneOrientation == Orientation.portrait && buttonEnumState == ButtonEnumState.Full_Screen)
              Expanded(
                child: ChatListViewWidget(
                    // chatWidth: 200,
                    ),
              ),
            if (phoneOrientation == Orientation.portrait && buttonEnumState == ButtonEnumState.Full_Screen)
              ChatSend(
                  chatHeight: 50,
                  chatTextController: chatTextController,
                  currenFocus: currenFocus)
          ],
        ),
      ),
    );
  }
}
