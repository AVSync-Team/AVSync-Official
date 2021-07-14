import 'package:VideoSync/views/YTPlayer.dart';
import 'package:VideoSync/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoStartedWidgetDisplay extends StatefulWidget {
  @override
  _VideoStartedWidgetDisplayState createState() =>
      _VideoStartedWidgetDisplayState();
}

class _VideoStartedWidgetDisplayState extends State<VideoStartedWidgetDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
        //TODO: UI Implementation for this widget look into that
        child: Column(
      children: [
        Text("The Video has started join the room ",
            style: TextStyle(color: Colors.white)),
        CustomButton(
          content: "Join",
          cornerRadius: 10,
          width: 80,
          height: 30,
          buttonColor: Colors.redAccent,
          function: () {
            Get.to(YTPlayer());
          },
        )
      ],
    ));
  }
}
