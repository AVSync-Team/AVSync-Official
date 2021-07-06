import 'package:VideoSync/controllers/themeData.dart';
import 'package:flutter/material.dart';

class ChatWidget extends StatefulWidget {
  final String messageText;
  final String userName;
  final String timeStamp;
  final String userIdofOtherUsers;
  final String usersOwnUserId;
  const ChatWidget(
      {this.messageText,
      this.userName,
      this.timeStamp,
      this.userIdofOtherUsers,
      this.usersOwnUserId});

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('${widget.timeStamp}'),
      margin: EdgeInsets.symmetric(horizontal: 8),
      // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          //target this spacer for the self user only
          if (widget.userIdofOtherUsers == widget.usersOwnUserId) Spacer(),

          //show the pics of other users only
          if (widget.userIdofOtherUsers != widget.usersOwnUserId)
            ClipOval(
              child: Container(
                // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                // padding: EdgeInsets.only(bottom: 10),
                width: 35,
                height: 35,
                child: Image.network(
                    'https://i.picsum.photos/id/56/200/200.jpg?hmac=rRTTTvbR4tHiWX7-kXoRxkV7ix62g9Re_xUvh4o47jA'),
              ),
            ),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            color: CustomThemeData().darkGrey.value,
            child: Container(
              //this is for the padding and stuff
              // margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              padding: EdgeInsets.only(right: 10, bottom: 8, left: 10, top: 8),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 5),
                  if (widget.userIdofOtherUsers != widget.usersOwnUserId)
                    Text(
                      '${widget.userName}',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 14,
                      ),
                    ),
                  if (widget.userIdofOtherUsers != widget.usersOwnUserId)
                    SizedBox(height: 5),
                  Text(
                    "${widget.messageText}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: "Consolas"),
                  )
                ],
              ),
            ),
          ),
          //helps the UI

          if (widget.userIdofOtherUsers != widget.usersOwnUserId) Spacer()
        ],
      ),
    );
  }
}
