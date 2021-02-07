import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/chat.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/views/appDrawer.dart';
import 'package:VideoSync/views/users_screen.dart';
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
  // final double heightRatio = Get.height / 823;

  // bool joinLoading = false;
  // String roomIdText = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double heightRatio = size.height / 823;
    final double widthRatio = size.width / 411;
    return Scaffold(
      appBar: AppBar(
        // actions: [],
        // actions: [Text('Rishabh'), Text('Mishra')],
        backgroundColor: Color(0xff292727),
        elevation: 10,
      ),
      drawer: MainDrawer(),
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
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  controller: nameController,
                  decoration: InputDecoration(
                    //filled: true,
                    //fillColor: Colors.blueGrey,
                    focusColor: Colors.yellow,
                    // fillColor: Colors.red,
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                      borderRadius: new BorderRadius.circular(25),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.black, width: 6),
                      borderRadius: new BorderRadius.circular(25),
                    ),

                    //  border: OutlineInputBorder(
                    //
                    //    borderSide: BorderSide(
                    //      color: Colors.blueGrey,
                    //      style: BorderStyle.solid,
                    //      width: 6.0,
                    //    ),
                    //    borderRadius: BorderRadius.circular(25),
                    //  ),
                    hintText: "Enter your name",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 60),
              Container(
                width: 300 * widthRatio,
                height: 80 * heightRatio,
                child: RaisedButton(
                  elevation: 20,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Text(
                    'Join Room',
                    style: TextStyle(
                        fontSize: 30,
                        //fontSize: 40 * widthRatio,
                        fontWeight: FontWeight.normal),
                  ),
                  onPressed: () async {
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) {
                        return Container(
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
                                  margin:
                                      EdgeInsets.only(top: 40 * heightRatio),
                                  width: 270 * widthRatio,
                                  height: 70 * heightRatio,
                                  child: TextField(
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                    controller: roomId,
                                    onChanged: (value) {
                                      roomLogicController.roomText(value);
                                    },
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
                                GetBuilder<RoomLogicController>(
                                  builder: (controller) {
                                    return Container(
                                      height: 50 * heightRatio,
                                      width: 150 * widthRatio,
                                      child: RaisedButton(
                                        color: controller.joinLoading.value
                                            ? Colors.blue
                                            : Colors.green,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        onPressed: () {
                                          roomLogicController.joinRoom(
                                              roomId: roomId.text,
                                              name: nameController.text);

                                          if (true) {
                                            Get.to(WelcomScreen());
                                          } else {
                                            Get.snackbar('Wrong Room Id',
                                                'The room id you entered is wrong');
                                          }
                                        },
                                        child: Text(
                                          'Join',
                                          style: TextStyle(fontSize: 25),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );

                    bool canJoin = await roomLogicController.joinRoom(
                      roomId: roomId.text,
                      name: nameController.text,
                    );
                    if (canJoin) {
                      Get.to(WelcomScreen());
                    } else if (!canJoin) {
                      // print("No Such Room exsist");
                      return Get.snackbar(
                        'Room not found',
                        'The Room ID you entered was not found :(',
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 30 * heightRatio),
              Container(
                width: 300 * widthRatio,
                height: 80 * heightRatio,
                child: Hero(
                  tag: 'Rishabh',
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
                              fontSize: 30,
                              //fontSize: 35 * widthRatio,
                              fontWeight: FontWeight.normal))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.7,
      // height: 400,
      // color: Colors.white,
      color: Color(0xff292727),
      // appBar: AppBar(),
      child: Column(
        children: [ListTile(title: Text('Rishabh'))],
      ),
    );
  }
}
