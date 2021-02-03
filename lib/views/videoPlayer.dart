import 'dart:io';

import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/controllers/ytPlayercontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class NiceVideoPlayer extends StatefulWidget {
  @override
  _NiceVideoPlayerState createState() => _NiceVideoPlayerState();
}

class _NiceVideoPlayerState extends State<NiceVideoPlayer> {
  VideoPlayerController _controller;
  Duration videoLength;
  RoomLogicController roomLogicController = Get.put(RoomLogicController());
  YTStateController ytStateController = Get.put(YTStateController());
  RishabhController rishabhController = Get.put(RishabhController());

  @override
  void initState() {
    // TODO: implement initState

    _controller = VideoPlayerController.file(File(roomLogicController.localUrl))
      ..initialize().then((_) {
        setState(() {
          videoLength = _controller.value.duration;
        });
      });

    _controller.addListener(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: _controller.value.initialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(
            () {
              print('videoLength : ${videoLength.inSeconds}');

              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            },
          );
        },
        child:
            Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
