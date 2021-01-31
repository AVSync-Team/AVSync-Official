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

String url;

RoomLogicController roomLogicController = Get.put(RoomLogicController());
YTStateController ytStateController = Get.put(YTStateController());
StreamController<int> _ytController;
RishabhController rishabhController = Get.put(RishabhController());
int position = 0;
Timer timer;

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
    _ytController = new StreamController();

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _ytController.close();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Stack(
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
                          roomLogicController.changeTimeStamp(
                              timestamp: controller.value.position.inSeconds);
                          if (controller.value.isPlaying) {
                            roomLogicController.sendPlayerStatus(status: false);
                          } else {
                            roomLogicController.sendPlayerStatus(status: true);
                          }
                          if (controller.value.isDragging) {
                            roomLogicController.sendIsDraggingStatus(
                                status: true);
                            roomLogicController.sendPlayerStatus(status: true);
                          } else {
                            roomLogicController.sendIsDraggingStatus(
                                status: false);
                            roomLogicController.sendPlayerStatus(status: false);
                          }
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
                // AspectRatio(
                //   aspectRatio: 16 / 9,
                //   child: Container(
                //     // width: double.infinity,
                //     // height: 100,
                //     decoration:
                //         BoxDecoration(border: Border.all(color: Colors.cyan)),
                //     child: GestureDetector(
                //       onDoubleTap: () {
                //         print('tapped');
                //         if (controller.value.isPlaying) {
                //           controller.pause();
                //           print('player paused');
                //         } else if (!controller.value.isPlaying) {
                //           controller.play();
                //           print('player unpaused');
                //         }
                //       },
                //     ),
                //   ),
                // ),
                Positioned(
                  bottom: 5,
                  child: Container(
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
                ),

                Positioned(
                  bottom: 20,
                  child: RaisedButton(
                    onPressed: () {
                      controller.value.isPlaying
                          ? controller.pause()
                          : controller.play();
                    },
                    child: Text(controller.value.isPlaying ? 'Pause' : 'Play'),
                  ),
                ),
                RaisedButton(onPressed: () {
                  ytStateController.getInfo();
                })
              ],
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
