import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NiceVideoPlayer extends StatefulWidget {
  @override
  _NiceVideoPlayerState createState() => _NiceVideoPlayerState();
}

class _NiceVideoPlayerState extends State<NiceVideoPlayer> {
  VideoPlayerController _controller;
  Duration videoLength;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.network(
        'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4')
      ..initialize().then((_) {
        setState(() {
          videoLength = _controller.value.duration;
        });
      });
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
