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
    ),
  );

  @override
  void initState() {
    _ytController = new StreamController();
    Timer.periodic(Duration(seconds: 1), (_) async {
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
      }

      // if (!(roomLogicController.adminKaNaam.obs.value ==
      //     roomLogicController.userName.obs.value))
      //   controller.seekTo(Duration(seconds: data),allowSeekAhead: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AspectRatio(
                aspectRatio: 16 / 9,
                child: StreamBuilder(
                  stream: _ytController.stream,
                  builder: (ctx, snapshot) {
                    if (snapshot.hasData) {
                      return YoutubePlayer(
                        showVideoProgressIndicator: true,
                        progressColors: ProgressBarColors(
                            playedColor: Colors.amber,
                            handleColor: Colors.amberAccent),
                        onReady: () {
                          controller.addListener(() {
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
                )),
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
