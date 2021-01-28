import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YTPlayer extends StatefulWidget {
  final String urled;

  YTPlayer({this.urled});

  @override
  _YTPlayerState createState() => _YTPlayerState();
}

String url;

class _YTPlayerState extends State<YTPlayer> {
  @override
  void didChangeDependencies() {
    url = widget.urled;
    print('sex: ${YoutubePlayer.convertUrlToId(widget.urled)}');
  }

  YoutubePlayerController controller = YoutubePlayerController(
    initialVideoId: 'gXPUXOl0qQ0',
    flags: YoutubePlayerFlags(
      autoPlay: true,
      // hideControls: true,
      mute: false,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(
                showVideoProgressIndicator: true,
                progressColors: ProgressBarColors(
                    playedColor: Colors.amber, handleColor: Colors.amberAccent),
                onReady: () {
                  controller.addListener(() {
                    print('posRED: ${controller.value.position}');
                    print('isDragging: ${controller.value.isDragging}');
                  });
                },
                controller: controller,
                // bottomActions: [
                //   CurrentPosition(),
                //   ProgressBar(isExpanded: true),
                // ],
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              // _controller.setVolume(100);
              controller.load('gwWKnnCMQ5c');
              print('position: ${controller.value.position}');
            },
            child: Text('Load another Video'),
          ),
        ],
      ),
    );
  }
}
