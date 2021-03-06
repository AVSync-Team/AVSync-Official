import 'dart:async';

import 'package:VideoSync/views/video%20players/YTPlayer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_widget.dart';

class ChatListViewWidget extends StatefulWidget {
  final double chatWidth;
  ChatListViewWidget({this.chatWidth});

  @override
  _ChatListViewWidgetState createState() => _ChatListViewWidgetState();
}

class _ChatListViewWidgetState extends State<ChatListViewWidget> {
  @override
  void initState() {
    super.initState();
    chatStream.listen((event) {
      //if an event happens then go down
      Timer(Duration(milliseconds: 300), () {
       

        chatScrollController.animateTo(
            chatScrollController.position.maxScrollExtent,
            duration: Duration(milliseconds:500),
            curve: Curves.decelerate);
      });
    });
  }

  Stream<QuerySnapshot> chatStream = FirebaseFirestore.instance
      .collection('chats')
      .doc('${roomLogicController.roomFireBaseId}')
      .collection('messages')
      .orderBy('timeStamp', descending: false)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
     
      stream: chatStream,
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
                  chatWidth: widget.chatWidth,
                  userName: "${snapshot.data.docs[index]['sentBy']}",
                  messageText: "${snapshot.data.docs[index]['message']}",
                  timeStamp: "${snapshot.data.docs[index]['timeStamp']}",
                  userIdofOtherUsers: "${snapshot.data.docs[index]['userId']}",
                  usersOwnUserId: roomLogicController.userId.toString(),
                  messageTag: "${snapshot.data.docs[index]['tag']}",
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
