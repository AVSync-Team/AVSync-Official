import 'dart:async';

import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/controllers/ytPlayercontroller.dart';
import 'package:VideoSync/views/welcome_Screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        hideControls: false,
        mute: false,
        disableDragSeek: false,

        // hideControls: true,
        hideThumbnail: true),
  );
  int timestamp = 0;
  @override
  void initState() {
    var firebaseDatabase = FirebaseDatabase.instance.reference();
    var data = firebaseDatabase
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Get.context.orientation == Orientation.portrait
          ? AppBar(
              backgroundColor: Color(0xff292727),
            )
          : null,
      drawer: Container(
        width: 380 * widthRatio,
        child: Drawer(
          child: ChattingPlace(),
        ),
      ),
      backgroundColor: Color(0xff292727),
      body: Center(
        child: Container(
          // decoration: BoxDecoration(border: Border.all(color: Colors.cyan)),
          // height: Get.context.isPortrait ? Get.height : Get.height,
          // width: Get.context.isPortrait ? Get.width : Get.width,
          child: Stack(
            children: [
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
              Align(
                alignment: Alignment.center,
                child: Container(
                  // aspectRatio: 16 / 9,
                  width: Get.width,
                  height: Get.height,
                  // decoration: BoxDecoration(color: Colors.blue),

                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          // decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.red)),
                          child: GestureDetector(
                            onTap: () {
                              controller.seekTo(Duration(
                                  seconds: controller.value.position.inSeconds -
                                      10));
                            },
                            child: SvgPicture.asset(
                                'lib/assets/svgs/back10.svg',
                                width: 40 * widthRatio,
                                height: 40 * heightRatio),
                          ),
                        ),
                      ),
                      Expanded(
                        // width: Get.width * 0.4,
                        // color: Colors.blue.shade100,
                        child: Container(
                          // decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.cyan)),
                          child: GestureDetector(
                            onTap: () {
                              if (controller.value.isPlaying) {
                                controller.pause();
                              } else {
                                controller.play();
                              }
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        // width: Get.width * 0.3,
                        // color: Colors.yellow.shade100,
                        child: Container(
                          // decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.yellow)),
                          child: GestureDetector(
                            child: SvgPicture.asset('lib/assets/svgs/go10.svg',
                                width: 40 * widthRatio,
                                height: 40 * heightRatio),
                            onTap: () {
                              controller.seekTo(Duration(
                                  seconds: controller.value.position.inSeconds +
                                      10));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: Get.context.isPortrait
                    ? 270 * heightRatio
                    : 20 * heightRatio,
                right:
                    Get.context.isPortrait ? 10 * widthRatio : 30 * widthRatio,
                child: Container(
                  // margin: EdgeInsets.only(left: 40),
                  child: IconButton(
                      icon: Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                        size: 35,
                      ),
                      onPressed: () {
                        controller.toggleFullScreenMode();
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
