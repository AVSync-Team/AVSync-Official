import 'dart:io';
import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/chat.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/controllers/ytPlayercontroller.dart';
import 'package:VideoSync/widgets/custom_button.dart';
import 'package:VideoSync/widgets/custom_text.dart';
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

class _AnyPlayerState extends State<AnyPlayer>
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

  @override
  void initState() {
    super.initState();

    //animation controller
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));

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
  }

  void addListener() {
    return controller.addListener(() {
      roomLogicController.videoPosition.value = controller.value.position;
      roomLogicController.playingStatus.value = controller.value.isPlaying;
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

  changeRadioValue(int value) {
    setState(() {
      selectedRadio = value;
    });
  }

  @override
  void dispose() {
    chatController.dispose();
    roomLogicController.dispose();
    rishabhController.dispose();
    controller.dispose();

    super.dispose();
  }

  Future<ClosedCaptionFile> _loadCaptions() async {
    print('closedcaptions fires');
    final String fileContents =
        await DefaultAssetBundle.of(context).loadString('lib/assets/lund.srt');
    print('contents: $fileContents');
    return SubRipCaptionFile(fileContents);
  }

  Future<void> initializeSubs() async {
    controller = VideoPlayerController.file(
        File(
          roomLogicController.localUrl.value,
        ),
        closedCaptionFile: _loadCaptions())
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: Get.context.orientation == Orientation.portrait
          ? AppBar(
              backgroundColor: Color(0xff292727),
              elevation: 0,
            )
          : null,
      backgroundColor: themeData.primaryColor.value,
      body: Center(
        child: Container(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
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
                                  margin: EdgeInsets.symmetric(horizontal: 10),
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
                                            activeTickMarkColor: Colors.indigo,
                                            inactiveTickMarkColor:
                                                Colors.indigo,
                                            valueIndicatorShape:
                                                PaddleSliderValueIndicatorShape(),
                                            valueIndicatorColor: Colors.indigo,
                                          ),
                                          child: Slider(
                                            // activeColor:
                                            //     Color.fromRGBO(50, 60, 120, 0.5),
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
                                        // margin: EdgeInsets.only(right: 5),
                                        child: Text(
                                            '${controller.value.duration.toString().substring(0, 7)}',
                                            style:
                                                TextStyle(color: Colors.white)),
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
                                              seconds: controller.value.position
                                                      .inSeconds -
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
                                      child: IconButton(
                                          icon: AnimatedIcon(
                                            color: Colors.white,
                                            size: 28,
                                            progress: _animationController,
                                            icon: AnimatedIcons.play_pause,
                                          ),
                                          onPressed: () {
                                            if (roomLogicController
                                                .playingStatus.value) {
                                              controller.pause();
                                              _animationController.reverse();
                                            } else if (!roomLogicController
                                                .playingStatus.value) {
                                              controller.play();
                                              _animationController.forward();
                                            }
                                          }),
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
                                          controller.seekTo(Duration(
                                              seconds: controller.value.position
                                                      .inSeconds +
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
                                        SystemChrome.setPreferredOrientations(
                                            [DeviceOrientation.landscapeRight]);
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
