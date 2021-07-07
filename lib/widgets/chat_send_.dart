import 'dart:async';

import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/views/YTPlayer.dart';
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
              // height: 100,
              //color: Colors.white.withOpacity(0.8),
              constraints: BoxConstraints(
                minHeight: Get.height * 0.065,
                //maxWidth: 100,
              ),
              //height: Get.height * 0.065,
              // padding: EdgeInsets.only(bottom: 5),
              margin: EdgeInsets.only(left: 10),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(10),
              //   color: Color.fromARGB(0, 255, 255, 255),
              // ),
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(0),
                //color: CustomThemeData().darkGrey.value,
                color: Color.fromRGBO(10, 10, 10, 1),
              ),
              child: Card(
                elevation: 0,
                color: Colors.transparent,
                child: TextField(
                  maxLines: null,
                  // maxLength: 35,
                  expands: true,
                  autofocus: false,
                  controller: chatTextController,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w100,
                    // backgroundColor: Colors.red
                  ),
                  textAlign: TextAlign.start,
                  cursorHeight: 20,
                  cursorColor: Colors.grey,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black12,
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Color.fromRGBO(10, 10, 10, 0),
                        width: 1,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                      ),
                    ),
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
          ),
          Container(
            // decoration:
            //     BoxDecoration(border: Border.all(color: Colors.red)),
            // height: 20,
            // width: 80,
            child: Obx(
              () => IconButton(
                icon: Icon(Icons.send,
                    color: chatController.isTextEmpty.value
                        ? Colors.grey
                        : Colors.blueAccent,
                    size: 30),
                splashColor: CustomThemeData().primaryColor.value,
                // style: ElevatedButton.styleFrom(
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.only(
                //       topLeft: Radius.circular(30),
                //       bottomLeft: Radius.circular(10),
                //       bottomRight: Radius.circular(30),
                //       topRight: Radius.circular(5),
                //     ),
                //   ),
                // ),
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
                          () => chatScrollController.jumpTo(
                              chatScrollController.position.maxScrollExtent),
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
