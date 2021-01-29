import 'dart:async';

import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YTPlayer extends StatefulWidget {
  final String urled;

  YTPlayer({this.urled});

  @override
  _YTPlayerState createState() => _YTPlayerState();
}

String url;
YoutubePlayerController controller;
RoomLogicController roomLogicController = Get.put(RoomLogicController());
StreamController<int> _ytController;

class _YTPlayerState extends State<YTPlayer> {
  @override
  void didChangeDependencies() {
    controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.urled),
      flags: YoutubePlayerFlags(
        autoPlay: true,
        // hideControls: true,
        mute: false,
      ),
    );
  }

  @override
  void initState() {
    _ytController = new StreamController();
    Timer.periodic(Duration(milliseconds: 1), (_) async {
      var data = await roomLogicController.getTimeStamp();
      _ytController.add(data);
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
                            print('posRED: ${controller.value.position}');
                            print('isDragging: ${controller.value.isDragging}');
                            if (controller.value.isDragging) {
                              roomLogicController.changeTimeStamp(
                                  timestamp:
                                      controller.value.position.inSeconds);
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
