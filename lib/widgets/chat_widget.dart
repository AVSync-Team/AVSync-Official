import 'package:VideoSync/controllers/themeData.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';

class ChatWidget extends StatelessWidget {
  final String messageText;
  final String userName;
  final String timeStamp;
  final String userIdofOtherUsers;
  final String usersOwnUserId;
  final double chatWidth;
  final String status;
  final String messageTag;
  const ChatWidget(
      {this.messageText,
      this.messageTag,
      this.status,
      this.chatWidth,
      this.userName,
      this.timeStamp,
      this.userIdofOtherUsers,
      this.usersOwnUserId});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('${timeStamp}'),
      margin: EdgeInsets.symmetric(horizontal: 8),
      // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          //target this spacer for the self user only
          if (userIdofOtherUsers == usersOwnUserId && messageTag == "message")
            Spacer(),

          //show the pics of other users only
          if (userIdofOtherUsers != usersOwnUserId && messageTag == "message")
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
          if (messageTag == "alert") Spacer(),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 5,
            color: CustomThemeData().darkGrey.value,
            child: Container(
              width: chatWidth,
              constraints: BoxConstraints(minWidth: 40, maxWidth: 203),
              //this is for the padding and stuff
              // margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              padding: EdgeInsets.only(right: 10, bottom: 8, left: 10, top: 8),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(width: 5),
                  if (userIdofOtherUsers != usersOwnUserId &&
                      messageTag == "message")
                    Text(
                      '${userName}',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 14,
                      ),
                      softWrap: true,
                    ),
                  if (userIdofOtherUsers != usersOwnUserId) SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      FlutterClipboard.copy(messageText).then(
                          (value) => Get.snackbar("Done!", "Message Copied"));
                    },
                    child: Text(
                      "${messageText}",
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          color: messageTag == "message"
                              ? Colors.white
                              : userName == "User Joined"
                                  ? Colors.blueAccent
                                  : Colors.redAccent,
                          fontSize: 12,
                          fontFamily: "Consolas"),
                    ),
                  )
                ],
              ),
            ),
          ),
          //helps the UI
          if (messageTag == "alert") Spacer(),
          if (userIdofOtherUsers != usersOwnUserId && messageTag == "message")
            Spacer()
        ],
      ),
    );
  }
}
