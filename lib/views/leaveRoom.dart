import 'dart:async';

import 'package:VideoSync/controllers/betterController.dart';
// import 'package:VideoSync/controllers/chat.dart';
// import 'package:VideoSync/controllers/funLogic.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/views/createRoom.dart';
// import 'package:VideoSync/views/homePage.dart';
import 'package:VideoSync/views/waitingPage.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/platform_interface.dart';

class LeaveRoom extends StatefulWidget {
  @override
  _LeaveRoomState createState() => _LeaveRoomState();
}

class _LeaveRoomState extends State<LeaveRoom> {
  // RoomLogicController roomLogicController = Get.put(RoomLogicController());
  // TextEditingController yturl = TextEditingController();
  RishabhController rishabhController = Get.put(RishabhController());
  // ChatController chatController = Get.put(ChatController());
  // FunLogic funLogic = Get.put(FunLogic());
  // CustomThemeData themeController = Get.put(CustomThemeData());
  RoomLogicController roomLogicController = Get.put(RoomLogicController());

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // SizedBox(
              //   height: 50,
              // ),
              !(roomLogicController.adminId.obs.value ==
                      roomLogicController.userId.obs.value)
                  ? Container(
                      padding: EdgeInsets.only(
                        left: 12,
                      ),
                      child: Text(
                        'LEAVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 31,
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.only(
                        left: 18,
                      ),
                      child: Text(
                        'DELETE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 31,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
              Container(
                padding: EdgeInsets.only(
                  left: 32,
                ),
                child: Text(
                  'ROOM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.only(left: 30),
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.only(
                            left: 15, top: 10, right: 20, bottom: 10),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(41, 39, 39, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              (10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    icon: Icon(
                      Icons.done,
                      color: Colors.green,
                      size: 25,
                    ),
                    label: Text(
                      'Yes',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Raleway',
                      ),
                    ),
                    onPressed: () {
                      if (!(roomLogicController.adminId.obs.value ==
                          roomLogicController.userId.obs.value)) {
                        roomLogicController.userLeaveRoom(
                          firebaseId: roomLogicController.roomFireBaseId,
                          userId: roomLogicController.userId,
                        );
                      } else {
                        roomLogicController.adminDeleteRoom(
                            firebaseId: roomLogicController.roomFireBaseId);
                      }
                      Get.offAll(CreateRoomScreen());
                    }),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(left: 28),
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.only(
                            left: 15, top: 10, right: 20, bottom: 10),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(41, 39, 39, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              (10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 25,
                    ),
                    label: Text(
                      'No',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Raleway',
                      ),
                    ),
                    onPressed: () {
                      // ignore: unrelated_type_equality_checks
                      Get.off(WaitingPage());
                      // Get.off(CreateRoomScreen());
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Get.defaultDialog(
//                           // buttonColor: Colors.green.withOpacity(0.1),
//                           title: !(roomLogicController.adminKaNaam.obs.value ==
//                                   roomLogicController.userName.obs.value)
//                               ? 'Leave Room'
//                               : 'Delete Room',
//                           confirm: RaisedButton(
//                               color: Colors.green,
//                               child: Text('Yes'),
//                               onPressed: () {
//                                 if (!(roomLogicController.adminKaNaam.obs.value ==
//                                     roomLogicController.userName.obs.value)) {
//                                   rishabhController.userLeaveRoom(
//                                     firebaseId:
//                                         roomLogicController.roomFireBaseId,
//                                     userId: roomLogicController.userId,
//                                   );
//                                 } else {
//                                   roomLogicController.adminDeleteRoom(
//                                       firebaseId:
//                                           roomLogicController.roomFireBaseId);
//                                 }
//                                 Get.offAll(CreateRoomScreen());
//                                 // Get.off(CreateRoomScreen());
//                               }),
//                           cancel: ElevatedButton(
//                               style: ButtonStyle(
//                                   foregroundColor:
//                                       MaterialStateProperty.all<Color>(
//                                           Colors.green)),
//                               // color: Colors.red,
//                               child: Text('No'),
//                               onPressed: () {
//                                 Get.back();
//                               }),
//                           content: !(roomLogicController.adminKaNaam.obs.value ==
//                                   roomLogicController.userName.obs.value)
//                               ? Text('Do you want to leave the room ? ')
//                               : Text('Do you want to delete the room ? '));),),
