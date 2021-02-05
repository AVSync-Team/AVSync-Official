// import 'dart:async';

import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/controllers/ytPlayercontroller.dart';
// import 'package:VideoSync/views/welcome_Screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'chat.dart';

class YTPlayer extends StatefulWidget {
  @override
  _YTPlayerState createState() => _YTPlayerState();
}

// String url;

RoomLogicController roomLogicController = Get.put(RoomLogicController());
YTStateController ytStateController = Get.put(YTStateController());
RishabhController rishabhController = Get.put(RishabhController());
AnimationController animationController;
final double heightRatio = Get.height / 823;
final double widthRatio = Get.width / 411;

// int position = 0;

class _YTPlayerState extends State<YTPlayer> {
  YoutubePlayerController controller = YoutubePlayerController(
    initialVideoId:
        YoutubePlayer.convertUrlToId(roomLogicController.ytURL.value),
    flags: YoutubePlayerFlags(
        autoPlay: false,
        // hideControls: !(roomLogicController.adminKaNaam.obs.value ==
        //         roomLogicController.userName.obs.value)
        //     ? true
        //     : false,
        hideControls: true,
        mute: false,
        disableDragSeek: false,

        // hideControls: true,
        hideThumbnail: true),
  );
  int timestamp = 0;
  // bool dontHideControlsBool = true;
  bool hideUI = false;
  double animatedHeight = 30;

  // void hideControls() async {
  //   if (controller.value.isPlaying) {
  //     await Future.delayed(Duration(seconds: 2));
  //     setState(() {
  //       dontHideControlsBool = true;
  //     });
  //   } else {
  //     await Future.delayed(Duration(seconds: 2));
  //     // hideControlsBool = false;
  //     setState(() {
  //       dontHideControlsBool = false;
  //     });
  //   }
  //   print('Khushi Love');
  // }

  @override
  void initState() {
    var firebaseDatabase = FirebaseDatabase.instance.reference();
    firebaseDatabase
        .child('Rooms')
        .child(roomLogicController.roomFireBaseId.obs.value)
        .child('timeStamp')
        .onValue
        .listen((event) {
      if (!(roomLogicController.adminKaNaam.obs.value ==
          roomLogicController.userName.obs.value)) {
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
      if (!(roomLogicController.adminKaNaam.obs.value ==
          roomLogicController.userName.obs.value)) {
        if (event.snapshot.value) {
          controller.pause();
          // print(event.snapshot.value);
        } else {
          controller.play();
        }
      }
    });

    // hideControls();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
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
      endDrawer: Container(
        width: 380 * widthRatio,
        child: Drawer(
          child: ChattingPlace(controller: controller),
        ),
      ),
      backgroundColor: Color(0xff292727),
      body: Center(
        child: Container(
          child: Stack(
            children: [
              //The youtube player
              Align(
                alignment: Alignment.center,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  // width: double.infinity,
                  child: YoutubePlayer(
                    // onEnded: (_) {
                    //   Get.off(WelcomScreen());
                    // },
                    aspectRatio: 16 / 9,
                    controller: controller,
                    showVideoProgressIndicator: true,
                    progressColors: ProgressBarColors(
                        playedColor: Colors.amber,
                        handleColor: Colors.amberAccent),
                    onReady: () {
                      controller.addListener(
                        () {
                          roomLogicController.videoPosition.value =
                              controller.value.position;
                          roomLogicController.playingStatus.value =
                              controller.value.isPlaying;
                          ytStateController.videoPosition.value =
                              controller.value.position.inSeconds.toDouble();
                          //admin
                          //will send timestamp and control video playback
                          if (roomLogicController.adminKaNaam.obs.value ==
                              roomLogicController.userName.obs.value) {
                            rishabhController.sendTimeStamp(
                                firebaseId: roomLogicController.roomFireBaseId,
                                timeStamp: controller.value.position.inSeconds);
                            if (controller.value.isPlaying) {
                              rishabhController.sendPlayerStatus(
                                  status: false,
                                  firebaseId:
                                      roomLogicController.roomFireBaseId);
                            } else if (!controller.value.isPlaying) {
                              rishabhController.sendPlayerStatus(
                                  status: true,
                                  firebaseId:
                                      roomLogicController.roomFireBaseId);
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
              ),

              //Control UIs
              //seek back 10
              Align(
                alignment: Alignment.center,
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
                          //     border: Border.all(color: Colors.red)),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                hideUI = !hideUI;
                                // animatedHeight = 0;
                              });
                            },
                          ),
                        ),
                      ),
                      // Spacer(

                      Obx(
                        () => Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  // margin: EdgeInsets.only(left: 5),
                                  child: Text(
                                      '${roomLogicController.videoPosition.value.toString().substring(0, 7)}',
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                ),
                                Container(
                                  // margin: EdgeInsets.only(right: 5),
                                  child: Text(
                                      '${controller.metadata.duration.toString().substring(0, 7)}',
                                      style: TextStyle(color: Colors.white)),
                                )
                              ],
                            )),
                      ),

                      //For all the controls
                      AnimatedContainer(
                        color: Color.fromRGBO(25, 25, 25, 0.66),
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
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.seekTo(Duration(
                                        seconds: controller
                                                .value.position.inSeconds -
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
                                      controller.pause();
                                    } else {
                                      controller.play();
                                    }
                                  },
                                  child: Obx(
                                    () =>
                                        roomLogicController.playingStatus.value
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
                                        seconds: controller
                                                .value.position.inSeconds +
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
                                  controller.toggleFullScreenMode();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      // : Container(
                      //     height: 0,
                      //     margin: EdgeInsets.only(bottom: 10),
                      //   )
                      // SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
