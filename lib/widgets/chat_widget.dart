import 'package:flutter/material.dart';

class ChatWidget extends StatefulWidget {
  final String messageText;
  final String userName;
  final String timeStamp;
  const ChatWidget({this.messageText, this.userName, this.timeStamp});

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 30,
      decoration: BoxDecoration(),
      margin: EdgeInsets.all(10),
      child: Card(
        
        color: Colors.transparent,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.userName}',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Text(
              "${widget.messageText}",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
