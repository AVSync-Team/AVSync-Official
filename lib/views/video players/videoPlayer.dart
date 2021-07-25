import 'dart:io';
import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/chat.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/controllers/ytPlayercontroller.dart';
import 'package:VideoSync/video_manager/photo_lib.dart';
import 'package:VideoSync/widgets/chat_list_view.dart';
import 'package:VideoSync/widgets/chat_send_.dart';
import 'package:VideoSync/widgets/custom_button.dart';
import 'package:VideoSync/widgets/custom_namebar.dart';
// import 'package:VideoSync/views/chat.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'YTPlayer.dart';

class NiceVideoPlayer extends StatefulWidget {
  @override
  _NiceVideoPlayerState createState() => _NiceVideoPlayerState();
}

RoomLogicController roomLogicController = Get.put(RoomLogicController());
ChatController chatController = Get.put(ChatController());
YTStateController ytStateController = Get.put(YTStateController());
RishabhController rishabhController = Get.put(RishabhController());
CustomThemeData themeData = Get.put(CustomThemeData());
AnimationController animationController;
final double heightRatio = Get.height / 823;
final double widthRatio = Get.width / 411;

class _NiceVideoPlayerState extends State<NiceVideoPlayer>
    with SingleTickerProviderStateMixin {
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
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));

    ///`Video Player Controller`

    controller =
        VideoPlayerController.file(File(roomLogicController.localUrl.value),
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
      if (!(roomLogicController.adminId.obs.value ==
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
      if (!(roomLogicController.adminId.obs.value ==
          roomLogicController.userId.obs.value)) {
        // controller.setPlaybackRate(event.snapshot.value);
        controller.setPlaybackSpeed(event.snapshot.value);
      }
    });
    //video controller listeners
    addListener();
    listenToTextInputStateChanges();
  }

  void addListener() {
    return controller.addListener(() {
      roomLogicController.videoPosition.value = controller.value.position;
      roomLogicController.playingStatus.value = controller.value.isPlaying;
      ytStateController.videoPosition.value =
          controller.value.position.inSeconds.toDouble();

      //admin
      //will send timestamp and control video playback
      if (roomLogicController.adminId.obs.value ==
          roomLogicController.userId.obs.value) {
        rishabhController.sendTimeStamp(
            firebaseId: roomLogicController.roomFireBaseId,
            timeStamp: controller.value.position.inSeconds);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    chatController.dispose();
    roomLogicController.dispose();
    // rishabhController.dispose();
    controller.dispose();
  }

  Future<ClosedCaptionFile> _loadCaptions() async {
    print('closedcaptions fires');
    final String fileContents =
        await DefaultAssetBundle.of(context).loadString('lib/assets/lund.srt');
    print('contents: $fileContents');
    return SubRipCaptionFile(fileContents);
  }

  // Future<ClosedCaptionFile> _loadCaptions() async {
  //   print("fired");
  //   final String fileContents =
  //       await DefaultAssetBundle.of(context).loadString(path);
  //   print('fileContents : $fileContents');
  //   return SubRipCaptionFile(fileContents);
  // }

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

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    // final size = MediaQuery.of(context).size;
    FocusNode currenFocus = FocusScope.of(context);

    //GetX Orientation doesn't work nicely so use this everywhere possible
    final Orientation phoneOrientation = MediaQuery.of(context).orientation;
    final Size size = MediaQuery.of(context).size;

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
                        child: Icon(Icons.folder),
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
                                // getDialogBox();
                                // Navigator.of(context).replace(
                                //     MaterialPageRoute(
                                //         builder: (ctx) => PhotoMypher()));
                                controller.dispose();
                                Get.off(PhotoMypher());
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        child: buttonPressed == 0
                            ? Icon(Icons.message)
                            : Icon(Icons.fullscreen),
                        onTap: () {
                          if (buttonPressed == 1)
                            setState(() {
                              //Need comments here Manav
                              //what happens when it's zero and what happens when it's 1
                              buttonPressed = 0;
                            });
                          else
                            setState(() {
                              buttonPressed = 1;
                            });
                        },
                      ),
                    ],
                  ),
                )
              ],
            )
          : null,
      // endDrawer: Container(
      //   width: 380 * widthRatio,
      //   child: Drawer(
      //     child: ChattingPlace(controller: controller),
      //   ),
      // ),
      backgroundColor: themeData.primaryColor.value,
      body: Container(
        // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
        child: Column(
          children: [
            Container(
              // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
              child: Container(
                height: phoneOrientation == Orientation.portrait
                    ? size.height * 0.3
                    : size.height * .98,
                width: phoneOrientation == Orientation.portrait
                    ? size.width
                    : size.width,
                // aspectRatio: controller.value.aspectRatio,
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
                      // decoration:
                      //     BoxDecoration(border: Border.all(color: Colors.cyan)),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          // width: size.width,
                          // height: MediaQuery.of(context).orientation ==
                          //         Orientation.landscape
                          //     ? size.height * 0.8
                          //     : size.height * 0.3,
                          // decoration:
                          //     BoxDecoration(border: Border.all(color: Colors.yellow)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //For hiding or displaying UI
                              Expanded(
                                child: Container(
                                  // decoration: BoxDecoration(
                                  //   border: Border.all(color: Colors.yellow),
                                  // ),
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
                                                thumbShape:
                                                    RoundSliderThumbShape(
                                                        enabledThumbRadius:
                                                            8.0),
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
                                                // activeColor:
                                                //     Color.fromRGBO(50, 60, 120, 0.5),
                                                value: roomLogicController
                                                    .videoPosition
                                                    .value
                                                    .inSeconds
                                                    .toDouble(),
                                                onChanged: (value) {
                                                  roomLogicController
                                                          .videoPosition.value =
                                                      Duration(
                                                          seconds:
                                                              value.toInt());
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
                                            // margin: EdgeInsets.only(right: 5),
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
                                  // border: Border.all(color: Colors.cyan)
                                ),
                                // color: Color.fromRGBO(25, 25, 25, 0.66),
                                // decoration: BoxDecoration(
                                //     color: Colors.grey,
                                //     border: Border.all(color: Colors.cyan)),
                                // padding: EdgeInsets.only(bottom: 20),
                                duration: Duration(milliseconds: 500),
                                height: hideUI ? 40 : 0,
                                // width: hideUI ? 0 : size.width,
                                // height: 0,
                                child: AnimatedOpacity(
                                  duration: Duration(milliseconds: 200),
                                  opacity: hideUI ? 1 : 0,
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      //seek backward 10
                                      SizedBox(width: 10),
                                      if (roomLogicController
                                              .adminId.obs.value ==
                                          roomLogicController.userId.obs.value)
                                        IconButton(
                                          icon: Icon(Icons.speed),
                                          color: Colors.white,
                                          onPressed: () {
                                            // setState(() {
                                            //   shoSpeedWidget = !shoSpeedWidget;
                                            // });

                                            //Show speed UI
                                            // Get.dialog(Container(
                                            //     height: 200,
                                            //     width: 400,
                                            //     child: Card()));
                                            showSpeedAlertDialog();
                                          },
                                        ),

                                      if (roomLogicController
                                              .adminId.obs.value ==
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
                                              rishabhController
                                                  .sendPlayerStatus(
                                                      status: true,
                                                      firebaseId:
                                                          roomLogicController
                                                              .roomFireBaseId);
                                              controller.pause();
                                            } else {
                                              rishabhController
                                                  .sendPlayerStatus(
                                                      status: false,
                                                      firebaseId:
                                                          roomLogicController
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
                                      if (roomLogicController
                                              .adminId.obs.value ==
                                          roomLogicController.userId.obs.value)
                                        Expanded(
                                          // width: Get.width * 0.3,
                                          // color: Colors.yellow.shade100,
                                          child: GestureDetector(
                                            child: SvgPicture.asset(
                                                'lib/assets/svgs/go10.svg',
                                                width: 30 * widthRatio,
                                                height: 30 * heightRatio),
                                            onTap: () {
                                              controller.seekTo(Duration(
                                                  seconds: controller.value
                                                          .position.inSeconds +
                                                      10));
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
                                            SystemChrome
                                                .setPreferredOrientations([
                                              DeviceOrientation.portraitUp
                                            ]);
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
                    // if (subsController != null)
                    // Positioned(
                    //   bottom: 100,
                    //   child: Container(
                    //     height: 100,
                    //     width: size.width,
                    //     child: ClosedCaption(
                    //         text: controller.value.caption.text,
                    //         textStyle: TextStyle(
                    //             fontSize: 14,
                    //             backgroundColor: Colors.white,
                    //             color: Colors.pink)),
                    //   ),
                    // ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // controller.dispose();
                    //     initializeSubs();
                    //   },
                    //   child: Text('Test'),
                    // )
                  ],
                ),
              ),
            ),
            if (phoneOrientation == Orientation.portrait) SizedBox(height: 10),

            //this is the chat display part of code
            //so if the buttonPressed == 1 then thos these UIs ok got it Manav

            if (phoneOrientation == Orientation.portrait && buttonPressed == 1)
              Expanded(
                child: ChatListViewWidget(
                    // chatWidth: 200,
                    ),
              ),
            if (phoneOrientation == Orientation.portrait && buttonPressed == 1)
              ChatSend(
                  chatHeight: 50,
                  chatTextController: chatTextController,
                  currenFocus: currenFocus)
          ],
        ),
      ),
    );
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
                }),
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
}
