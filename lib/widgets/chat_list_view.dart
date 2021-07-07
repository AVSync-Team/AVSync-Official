import 'package:VideoSync/views/YTPlayer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_widget.dart';

class ChatListViewWidget extends StatelessWidget {
  final double chatWidth;
  ChatListViewWidget({this.chatWidth});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // stream: chatController.message(
      //     firebaseId: roomLogicController.roomFireBaseId),
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc('${roomLogicController.roomFireBaseId}')
          .collection('messages')
          .orderBy('timeStamp', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Some error occured"));
        } else if (snapshot.hasData) {
          return NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return null;
            },
            child: ListView.separated(
              controller: chatScrollController,
              itemBuilder: (BuildContext context, int index) {
                return ChatWidget(
                  chatWidth: chatWidth,
                  userName: "${snapshot.data.docs[index]['sentBy']}",
                  messageText: "${snapshot.data.docs[index]['message']}",
                  timeStamp: "${snapshot.data.docs[index]['timeStamp']}",
                  userIdofOtherUsers: "${snapshot.data.docs[index]['userId']}",
                  usersOwnUserId: roomLogicController.userId.toString(),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 5);
              },
              itemCount: snapshot.data.size,
            ),
          );
        }
        return Container();
      },
    );
  }
}
