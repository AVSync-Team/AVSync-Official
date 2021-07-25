import 'dart:async';

import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/views/video%20players/YTPlayer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatSend extends StatelessWidget {
  const ChatSend(
      {Key key,
      @required this.chatTextController,
      @required this.currenFocus,
      @required this.chatHeight})
      : super(key: key);

  final TextEditingController chatTextController;
  final FocusNode currenFocus;
  final double chatHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: chatHeight,
      color: Color.fromRGBO(10, 10, 10, 1),
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                minHeight: Get.height * 0.065,
              ),
              margin: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: Color.fromRGBO(10, 10, 10, 1),
              ),
              child: TextField(
                autofocus: false,
                controller: chatTextController,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w100,
                ),
                textAlign: TextAlign.start,
                cursorHeight: 20,
                cursorColor: Colors.grey,
                textAlignVertical: TextAlignVertical.bottom,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  focusColor: Colors.white,
                  border: InputBorder.none,
                  hintText: 'Message',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w100,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Obx(
              () => IconButton(
                icon: Icon(Icons.send,
                    color: chatController.isTextEmpty.value
                        ? Colors.grey
                        : Colors.blueAccent,
                    size: 30),
                splashColor: CustomThemeData().primaryColor.value,
                onPressed: chatController.isTextEmpty.value
                    ? null
                    : () {
                        chatController.sendMessageCloudFireStore(
                            roomId: roomLogicController.roomFireBaseId,
                            message: chatTextController.text,
                            userId: roomLogicController.userId,
                            sentBy: roomLogicController.userName.value);

                        //scroll the listview down
                        Timer(
                          Duration(milliseconds: 300),
                          () => chatScrollController.animateTo(
                              chatScrollController.position.maxScrollExtent,
                              duration: Duration(seconds: 2),
                              curve: Curves.decelerate),
                        );
                        //clear the text from textfield
                        print(
                            "Message Length: ${chatTextController.text.length}");
                        chatTextController.clear();
                        //remove focus of widget
                        if (!currenFocus.hasPrimaryFocus) {
                          currenFocus.unfocus();
                        }
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
