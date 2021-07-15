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
        //color: Color.fromRGBO(0, 0, 0, 0.5),
        color: Colors.blueAccent,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 5, bottom: 5),
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              child: Column(
                children: [
                  Text(
                    "A user has started a video",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                        fontSize: 0.045 * MediaQuery.of(context).size.width),
                  ),
                  Text(
                    "Do you wish to join?",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                        fontSize: 0.035 * MediaQuery.of(context).size.width),
                  ),
                ],
              ),
            ),
            CustomButton(
              content: "Join",
              cornerRadius: 15,
              width: 80,
              height: 35,
              buttonColor: Colors.redAccent,
              function: () {
                Get.to(YTPlayer());
              },
            )
          ],
        ));
  }
}
