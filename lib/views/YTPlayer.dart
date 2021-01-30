import 'dart:async';

import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YTPlayer extends StatefulWidget {
  @override
  _YTPlayerState createState() => _YTPlayerState();
}

String url;

RoomLogicController roomLogicController = Get.put(RoomLogicController());
StreamController<int> _ytController;
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

  @override
  void initState() {
    _ytController = new StreamController();
    timer = Timer.periodic(Duration(seconds: 1), (_) async {
      var data = await roomLogicController.getTimeStamp();
      _ytController.add(data);
      // print(roomLogicController.adminKaNaam.obs.value);
      // print(roomLogicController.userName.obs.value);

      //non admin
      if (!(roomLogicController.adminKaNaam.obs.value ==
          roomLogicController.userName.obs.value)) {
        if (await roomLogicController.isPlayerPaused()) {
          controller.pause();
        } else {
          controller.play();
        }

        bool isDragging = await roomLogicController.isDraggingStatus();

        if (isDragging) {
          controller.seekTo(Duration(seconds: data));
        }
      }
      // if (!(roomLogicController.adminKaNaam.obs.value ==
      //     roomLogicController.userName.obs.value))
      //   controller.seekTo(Duration(seconds: data),allowSeekAhead: false);
    });
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
                  child: StreamBuilder(
                    stream: _ytController.stream,
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        return YoutubePlayer(
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
                              position = controller.value.position.inSeconds;

                              //admin
                              //will send timestamp and control video playback
                              if (roomLogicController.adminKaNaam.obs.value ==
                                  roomLogicController.userName.obs.value) {
                                roomLogicController.changeTimeStamp(
                                    timestamp:
                                        controller.value.position.inSeconds);
                                if (controller.value.isPlaying) {
                                  roomLogicController.sendPlayerStatus(
                                      status: false);
                                } else {
                                  roomLogicController.sendPlayerStatus(
                                      status: true);
                                }
                                if (controller.value.isDragging) {
                                  roomLogicController.sendIsDraggingStatus(
                                      status: true);
                                  roomLogicController.sendPlayerStatus(
                                      status: true);
                                } else {
                                  roomLogicController.sendIsDraggingStatus(
                                      status: false);
                                  roomLogicController.sendPlayerStatus(
                                      status: false);
                                }
                              }
                            });
                          },

                          controller: controller,
                          // bottomActions: [
                          //   CurrentPosition(),
                          //   ProgressBar(isExpanded: true),
                          // ],
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
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
                Container(
                  height: 5,
                  width: double.infinity,
                  child: Slider(
                    value: position.toDouble(),
                    max: controller.metadata.duration.inSeconds.toDouble(),
                    min: 0.0,
                    onChanged: (value) {
                      setState(() {
                        print('position: $position');
                        position = value.toInt();
                      });
                    },
                  ),
                )
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
