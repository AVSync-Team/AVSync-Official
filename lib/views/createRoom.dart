import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/chat.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/views/welcome_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CreateRoomScreen extends StatefulWidget {
  @override
  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  RoomLogicController roomLogicController = Get.put(RoomLogicController());
  TextEditingController nameController = TextEditingController();
  TextEditingController roomId = TextEditingController();
  RishabhController rishabhController = Get.put(RishabhController());
  ChatController chatController = Get.put(ChatController());
  var messages;
  final double heightRatio = Get.height / 823;
  final double widthRatio = Get.width / 411;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292727),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('lib/assets/svgs/movie.svg',
                  width: 170 * widthRatio, height: 170 * heightRatio),
              // Container(
              //   width: Get.width * .8,
              //   child: TextField(
              //     style: TextStyle(
              //         color: Colors.white, fontWeight: FontWeight.normal),
              //     controller: roomId,
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(25)),
              //       hintText: "Enter Room ID",
              //       hintStyle: TextStyle(color: Colors.grey),
              //     ),
              //   ),
              // ),
              SizedBox(height: 30),
              Container(
                width: Get.width * 0.8,
                child: TextField(
                  maxLength: 12,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.normal),
                  controller: nameController,
                  //    decoration: InputDecoration(
                  //      focusColor: Colors.yellow,
                  //      // fillColor: Colors.red,
                  //      border: OutlineInputBorder(
                  //        borderRadius: BorderRadius.circular(25),
                  //      ),
                  //      hintText: "Enter your name",
                  //      hintStyle: TextStyle(color: Colors.grey),
                  //    ),
                ),
              ),
              SizedBox(height: 60),
              Container(
                width: 300 * widthRatio,
                height: 80 * heightRatio,
                child: RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  onPressed: () async {
                    Get.bottomSheet(
                      Container(
                        width: Get.width,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(20.0),
                            topRight: const Radius.circular(20.0),
                          ),
                        ),
                        height: 270 * heightRatio,
                        child: Center(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 40 * heightRatio),
                                width: 270 * widthRatio,
                                height: 70 * heightRatio,
                                child: TextField(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  controller: roomId,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    // enabledBorder: OutlineInputBorder(
                                    //   borderSide: const BorderSide(
                                    //       color: Colors.white, width: 2.0),
                                    //   borderRadius: BorderRadius.circular(25.0),
                                    // ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    hintText: "Room ID",
                                    hintStyle:
                                        TextStyle(color: Color(0xff7B7171)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30 * heightRatio,
                              ),
                              Container(
                                height: 50 * heightRatio,
                                width: 150 * widthRatio,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  onPressed: () async {
                                    roomLogicController.joinRoom(
                                        roomId: roomId.text,
                                        name: nameController.text);
                                    // bool canJoin =
                                    //     await roomLogicController.joinRoom(
                                    //   roomId: roomId.text,
                                    //   name: nameController.text,
                                    // );
                                    // if (canJoin) {
                                    //   Get.to(WelcomScreen());
                                    // } else if (!canJoin) {
                                    //   // print("No Such Room exsist");
                                    //   return Get.snackbar(
                                    //     'Room not found',
                                    //     'The Room ID you entered was not found :(',
                                    //   );
                                    // }
                                  },
                                  child: Text(
                                    'Join',
                                    style: TextStyle(fontSize: 25),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );

                    // bool canJoin = await roomLogicController.joinRoom(
                    //   roomId: roomId.text,
                    //   name: nameController.text,
                    // );
                    // if (canJoin) {
                    //   Get.to(WelcomScreen());
                    // } else if (!canJoin) {
                    //   // print("No Such Room exsist");
                    //   return Get.snackbar(
                    //     'Room not found',
                    //     'The Room ID you entered was not found :(',
                    //   );
                    // }
                  },
                  child: Text('Join Room',
                      style: TextStyle(
                          fontSize: 40 * widthRatio,
                          fontWeight: FontWeight.normal)),
                ),
              ),
              SizedBox(height: 30 * heightRatio),
              Container(
                width: 300 * widthRatio,
                height: 80 * heightRatio,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    color: Colors.white,
                    onPressed: () async {
                      await roomLogicController.makeRoom(
                          adminName: nameController.text);
                      Get.to(WelcomScreen());
                    },
                    child: Text('Create Room',
                        style: TextStyle(
                            fontSize: 35 * widthRatio,
                            fontWeight: FontWeight.normal))),
              ),
              // RaisedButton(
              //   onPressed: () async {
              //     // Get.to(WelcomScreen());
              //   },
              //   child: Text('Users'),
              // ),
              // RaisedButton(
              //   onPressed: () async {
              //     // Get.to(WelcomScreen());
              //     // rishabhController.timestampFromDB();
              //     // rishabhController.isDraggingStatus();
              //     chatController.message();
              //     rishabhController.sendPlayerStatus(
              //         status: true, firebaseId: '-MSPN-uaUOs908rvqaYY');
              //   },
              //   child: Text('Rishabh'),
              // ),
              // StreamBuilder(
              //   stream:
              //       chatController.message(firebaseId: '-MSTkHEhCDHKWKCfslOa'),
              //   builder: (ctx, event) {
              //     // if (event.hasData) {
              //     //   return Container(
              //     //     height: 200,
              //     //     child: ListView.builder(
              //     //       itemBuilder: (ctx, i) {
              //     //         return Text('Rishabh');
              //     //       },
              //     //       itemCount: 3,
              //     //     ),
              //     //   );
              //     // }
              //     // if (event.hasData) {
              //     //   // print('sexy_choot: ${event.data.snapshot.value}');
              //     //   // event.data.snapshot.value.forEach((key, value) {
              //     //   //   // print(value);
              //     //   // });
              //     //   // print(event.data.snapshot.value['1']);
              //     //   event.data.snapshot.value.forEach((key, value) {
              //     //     // print(value['message']);
              //     //     messages.add({value});
              //     //   });
              //     // }

              //     return Text('dekh mera lund');
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}
