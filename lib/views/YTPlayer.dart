import 'dart:async';

import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/controllers/ytPlayercontroller.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YTPlayer extends StatefulWidget {
  @override
  _YTPlayerState createState() => _YTPlayerState();
}

// String url;

RoomLogicController roomLogicController = Get.put(RoomLogicController());
YTStateController ytStateController = Get.put(YTStateController());
RishabhController rishabhController = Get.put(RishabhController());
// int position = 0;

class _YTPlayerState extends State<YTPlayer> {
  YoutubePlayerController controller = YoutubePlayerController(
    initialVideoId:
        YoutubePlayer.convertUrlToId(roomLogicController.ytURL.value),
    flags: YoutubePlayerFlags(
        autoPlay: false,
        hideControls: !(roomLogicController.adminKaNaam.obs.value ==
                roomLogicController.userName.obs.value)
            ? true
            : false,
        mute: false,
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
      timestamp = event.snapshot.value;
    });

    firebaseDatabase
        .child('Rooms')
        .child(roomLogicController.roomFireBaseId.obs.value)
        .child('isDragging')
        .onValue
        .listen((event) {
      if (event.snapshot.value) {
        if (!(roomLogicController.adminKaNaam.obs.value ==
            roomLogicController.userName.obs.value)) {
          controller.seekTo(Duration(seconds: timestamp));
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

    // timer = Timer.periodic(Duration(seconds: 1), (_) async {
    //   var data = await roomLogicController.getTimeStamp();
    //   _ytController.add(data);
    //   // print(roomLogicController.adminKaNaam.obs.value);
    //   // print(roomLogicController.userName.obs.value);

    //   //non admin
    //   if (!(roomLogicController.adminKaNaam.obs.value ==
    //       roomLogicController.userName.obs.value)) {
    //     if (await roomLogicController.isPlayerPaused()) {
    //       controller.pause();
    //     } else {
    //       controller.play();
    //     }

    //     bool isDragging = await roomLogicController.isDraggingStatus();

    //     if (isDragging) {
    //       controller.seekTo(Duration(seconds: data));
    //     }
    //   }
    //   // if (!(roomLogicController.adminKaNaam.obs.value ==
    //   //     roomLogicController.userName.obs.value))
    //   //   controller.seekTo(Duration(seconds: data),allowSeekAhead: false);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 600,
              width: Get.width,
              child: Column(
                children: [
                  Container(
                    height: 300,
                    // width: double.infinity,
                    child: YoutubePlayer(
                      // topActions: [],
                      // bottomActions: [
                      //   Container(
                      //     width: 50,
                      //     height: 50,
                      //     color: Colors.red,
                      //   )
                      // ],
                      aspectRatio: 16 / 9,
                      showVideoProgressIndicator: true,
                      progressColors: ProgressBarColors(
                          playedColor: Colors.amber,
                          handleColor: Colors.amberAccent),
                      onReady: () {
                        controller.addListener(() {
                          ytStateController.videoPosition.value =
                              controller.value.position.inSeconds.toDouble();
                          //admin
                          //will send timestamp and control video playback
                          if (roomLogicController.adminKaNaam.obs.value ==
                              roomLogicController.userName.obs.value) {
                            // roomLogicController.changeTimeStamp(
                            //     timestamp: controller.value.position.inSeconds);

                            rishabhController.sendTimeStamp(
                                firebaseId: roomLogicController.roomFireBaseId,
                                timeStamp: controller.value.position.inSeconds);
                            if (controller.value.isPlaying) {
                              // roomLogicController.sendPlayerStatus(status: false);

                              rishabhController.sendPlayerStatus(
                                  status: false,
                                  firebaseId:
                                      roomLogicController.roomFireBaseId);
                            } else if (!controller.value.isPlaying) {
                              // roomLogicController.sendPlayerStatus(status: true);

                              rishabhController.sendPlayerStatus(
                                  status: true,
                                  firebaseId:
                                      roomLogicController.roomFireBaseId);
                            }
                            // if (controller.value.isDragging) {
                            //   roomLogicController.sendIsDraggingStatus(
                            //       status: true);
                            //   roomLogicController.sendPlayerStatus(status: true);
                            // } else {
                            //   roomLogicController.sendIsDraggingStatus(
                            //       status: false);
                            //   roomLogicController.sendPlayerStatus(status: false);
                            // }
                          }
                        });
                      },

                      controller: controller,
                      // bottomActions: [
                      //   CurrentPosition(),
                      //   ProgressBar(isExpanded: true),
                      // ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 5,
                    width: double.infinity,
                    child: Obx(() {
                      return Slider(
                        value: ytStateController.videoPosition.value,
                        max: controller.metadata.duration.inSeconds.toDouble(),
                        min: 0.0,
                        onChanged: (value) {
                          ytStateController.videoPosition.value = value;
                          controller.seekTo(Duration(seconds: value.toInt()));
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    onPressed: () {
                      controller.value.isPlaying
                          ? controller.pause()
                          : controller.play();
                    },
                    child: Text(controller.value.isPlaying ? 'Pause' : 'Play'),
                  ),
                ],
              ),
            ),
          ),
          // RaisedButton(
          //   onPressed: () {
          //     // _controller.setVolume(100);
          //     controller.load('gwWKnnCMQ5c');
          //     print('position: ${controller.value.position}');
          //   },
          //   child: Text('Load another Video'),
          // ),
        ],
      ),
    );
  }
}
