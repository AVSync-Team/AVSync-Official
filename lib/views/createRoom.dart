import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/chat.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/controllers/soundController.dart';
import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/views/appDrawer.dart';
import 'package:VideoSync/views/users_screen.dart';
import 'package:VideoSync/views/waitingPage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:flutter_sound/public/flutter_sound_player.dart';
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
  CustomThemeData themeController = Get.put(CustomThemeData());

  // SoundController soundController = Get.put(SoundController());
  PersistentBottomSheetController _controller; // <------ Instance variable
  final _scaffoldKey =
      GlobalKey<ScaffoldState>(); // <---- Another instance variable

  var messages;
  bool isLoading = false;

  double xOffset = 0;
  double yOffset = 0;
  double zOffset = 0;
  double scaleFactor = 1;
  bool isDrawerOpen = false;
  // FlutterSoundPlayer _mplayer = FlutterSoundPlayer();
  // var _mPlayerIsInited = false.obs;
  // final double heightRatio = Get.height / 823;

  // bool joinLoading = false;
  // String roomIdText = "";

  // void play() async {
  //   if (_mPlayerIsInited.value) {
  //     await _mplayer.startPlayer(
  //       fromURI:
  //           'https://file-examples.com/wp-content/uploads/2017/11/file_example_MP3_700KB.mp3',
  //       // codec: Codec.mp3,
  //       // whenFinished: () {
  //       //   stopPlayer();
  //       // },

  //     );
  //   }
  //   // print(_mPlayerIsInited.value);
  // }

  // void stopPlayer() async {
  //   if (_mplayer != null) {
  //     await _mplayer.stopPlayer();
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _mplayer.openAudioSession().then((value) {});
  //   _mPlayerIsInited.value = true;
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _mplayer.closeAudioSession();
  //   _mplayer = null;
  // }

  void _createCustomBottomSheet(
      {double heightRatio, double widthRatio, Size size}) async {
    _controller = await _scaffoldKey.currentState.showBottomSheet(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.only(
      //     topLeft: Radius.circular(23.0),
      //     topRight: Radius.circular(23.0),
      //   ),
      // ),
      (BuildContext buildContext) {
        return Container(
          width: size.width,
          height: 270 * heightRatio,
          child: Center(
            child: Column(
              children: [
                Container(
                  //color: Colors.grey.withOpacity(0.6),
                  margin: EdgeInsets.only(top: 40 * heightRatio),
                  width: 270 * widthRatio,
                  height: 70 * heightRatio,
                  child: TextField(
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                    controller: roomId,
                    onChanged: (value) {
                      roomLogicController.roomText(value);
                    },
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      // enabledBorder: OutlineInputBorder(
                      //   borderSide: const BorderSide(
                      //       color: Colors.white, width: 2.0),
                      //   borderRadius: BorderRadius.circular(25.0),
                      // ),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.4),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25)),
                      hintText: "Room ID",
                      hintStyle: TextStyle(color: Color(0xff7B7171)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30 * heightRatio,
                ),
                Container(
                  height: 50 * heightRatio,
                  width: 150 * widthRatio,
                  child: !isLoading
                      ? RaisedButton(
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          onPressed: () async {
                            _controller.setState(() {
                              isLoading = true;
                            });
                            bool value = await roomLogicController.joinRoom(
                                roomId: roomId.text, name: nameController.text);
                            await Future.delayed(Duration(seconds: 3));
                            if (value) {
                              Get.to(WaitingPage());
                            } else {
                              // Get.snackbar('Wrong Room Id',
                              //     'The room id you entered is wrong');
                              Get.showSnackbar(GetBar(
                                title: 'Room ID Error',
                                message: 'The Room ID is not valid',
                                duration: Duration(seconds: 2),
                                borderRadius: 20,
                              ));
                            }
                            _controller.setState(() {
                              isLoading = false;
                            });
                          },
                          child: Text(
                            'Join',
                            style: TextStyle(fontSize: 20),
                          ),
                        )
                      : Center(
                          child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator())),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final size = MediaQuery.of(context).size;
    final double heightRatio = size.height / 823;
    final double widthRatio = size.width / 411;
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, zOffset)
        ..scale(scaleFactor),
      duration: Duration(milliseconds: 350),
      decoration: BoxDecoration(
        color: themeController.primaryColor.value,
        borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0),
      ),
      //key: _scaffoldKey,
      //////////////////////////appbar////////////////////////////////////
      // appBar: AppBar(
      //   //backgroundColor: themeController.switchContainerColor.value,
      //   backgroundColor: Color.fromRGBO(41, 39, 39, 1),
      //   elevation: 10,
      // ),
      //drawer: MainDrawer(),
      /////////////////////////////////////////////////////////////////////
      //backgroundColor: themeController.primaryColor.value,
      child: Scaffold(
        key: _scaffoldKey,
        //backgroundColor: themeController.primaryColor.value,
        backgroundColor: Colors.transparent,
        body: MediaQuery.of(context).orientation == Orientation.landscape

            //landscape
            ? Container(
                width: size.width,
                height: (MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.green)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SingleChildScrollView(
                      child: Container(
                        width: Get.width * 0.4,
                        //color: Colors.yellow.withOpacity(0.5),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: (MediaQuery.of(context).size.height -
                                          AppBar().preferredSize.height -
                                          MediaQuery.of(context).padding.top) *
                                      0.26),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red)),
                                child: SvgPicture.asset(
                                  'lib/assets/svgs/movie.svg',
                                  width: 294 * widthRatio,
                                  height: 294 * heightRatio,
                                ),
                                // child :
                                // Container()
                              ),
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
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Center(
                        child: Container(
                          width: Get.width * 0.35,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: Get.width * 0.5,
                                child: TextField(
                                  maxLength: 12,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
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
                                        color: Colors.red,
                                        width: 1,
                                      ),
                                      borderRadius:
                                          new BorderRadius.circular(25),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Colors.black, width: 6),
                                      borderRadius:
                                          new BorderRadius.circular(25),
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
                              SizedBox(height: Get.height * 0.1),
                              Container(
                                width: Get.width * 0.4,
                                height: 35,
                                child: ElevatedButton(
                                  // elevation: 8,
                                  // color: Colors.white,
                                  // splashColor: Color.fromRGBO(196, 196, 196, 1),
                                  // shape: RoundedRectangleBorder(
                                  // borderRadius: BorderRadius.circular(25)),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    onSurface: Colors.white,
                                    primary: Colors.red,
                                    shadowColor: Colors.green,
                                    elevation: 8,
                                    onPrimary: Colors.white,
                                  ),
                                  child: Text(
                                    'Join Room',
                                    style: TextStyle(
                                        fontSize: 25,
                                        //fontSize: 40 * widthRatio,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  onPressed: () async {
                                    Scaffold.of(context).showBottomSheet(
                                      // context: context,
                                      // shape: RoundedRectangleBorder(
                                      //   borderRadius: BorderRadius.only(
                                      //     topLeft: Radius.circular(23.0),
                                      //     topRight: Radius.circular(23.0),
                                      //   ),
                                      // ),
                                      (ctx) {
                                        return Container(
                                          width: Get.width,
                                          //decoration: BoxDecoration(
                                          //color: Colors.red.withOpacity(0.4),
                                          //borderRadius: BorderRadius.circular(20)),
                                          // decoration: new BoxDecoration(
                                          //   color: Colors.white,
                                          //   borderRadius: new BorderRadius.only(
                                          //     topLeft: const Radius.circular(20.0),
                                          //     topRight: const Radius.circular(20.0),
                                          //   ),
                                          // ),
                                          //color: Colors.black.withOpacity(0.5),
                                          height: 270 * heightRatio,
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  //color: Colors.grey.withOpacity(0.6),
                                                  // margin: EdgeInsets.only(
                                                  //     top: 40 * heightRatio),
                                                  // width: 270 * widthRatio,
                                                  // height: 70 * heightRatio,
                                                  // padding:
                                                  //     EdgeInsets.only(left: 30),
                                                  width: 300,
                                                  child: TextField(
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                    controller: roomId,
                                                    onChanged: (value) {
                                                      roomLogicController
                                                          .roomText(value);
                                                    },
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    decoration: InputDecoration(
                                                      // enabledBorder: OutlineInputBorder(
                                                      //   borderSide: const BorderSide(
                                                      //       color: Colors.white, width: 2.0),
                                                      //   borderRadius: BorderRadius.circular(25.0),
                                                      // ),
                                                      filled: true,
                                                      fillColor: Colors.grey
                                                          .withOpacity(0.4),
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25)),
                                                      hintText: "Room ID",
                                                      hintStyle: TextStyle(
                                                          color: Color(
                                                              0xff7B7171)),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 30 * heightRatio,
                                                  width: 30,
                                                ),
                                                GetBuilder<RoomLogicController>(
                                                  builder: (controller) {
                                                    return Container(
                                                      //height: 50 * heightRatio,
                                                      //width: 150 * widthRatio,
                                                      width: 100,
                                                      child: RaisedButton(
                                                        color: controller
                                                                .joinLoading
                                                                .value
                                                            ? Colors.blue
                                                            : Colors.green,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25)),
                                                        onPressed: () {
                                                          roomLogicController
                                                              .joinRoom(
                                                                  roomId: roomId
                                                                      .text,
                                                                  name:
                                                                      nameController
                                                                          .text);

                                                          if (true) {
                                                            Get.to(
                                                                WaitingPage());
                                                          } else {
                                                            Get.snackbar(
                                                                'Wrong Room Id',
                                                                'The room id you entered is wrong');
                                                          }
                                                        },
                                                        child: Text(
                                                          'Join',
                                                          style: TextStyle(
                                                              fontSize: 20),
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
                                ),
                              ),
                              SizedBox(height: 30 * heightRatio),
                              Container(
                                width: 300 * widthRatio,
                                height: 80 * heightRatio,
                                child: Hero(
                                  tag: 'Rishabh',
                                  child: Obx(
                                    () => ElevatedButton(
                                      // shape: RoundedRectangleBorder(
                                      //   borderRadius: BorderRadius.circular(25),
                                      // ),
                                      // color: Colors.white,
                                      onPressed: () async {
                                        roomLogicController.isLoading.value =
                                            true;
                                        await roomLogicController.makeRoom(
                                            adminName: nameController.text);
                                        Get.to(WaitingPage());
                                        roomLogicController.isLoading.value =
                                            false;
                                      },
                                      child:
                                          !roomLogicController.isLoading.value
                                              ? Text(
                                                  'Create Room',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      //fontSize: 35 * widthRatio,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                )
                                              : CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 30,
                    )
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Container(
                  width: size.width,
                  height: (MediaQuery.of(context).size.height -
                      //AppBar().preferredSize.height -
                      MediaQuery.of(context).padding.top),
                  //height: Get.height,
                  // decoration:
                  //     BoxDecoration(border: Border.all(color: Colors.green)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 25,
                        ),
                        alignment: Alignment.centerLeft,
                        child: isDrawerOpen
                            ? IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    xOffset = 0;
                                    yOffset = 0;
                                    zOffset = 0;
                                    scaleFactor = 1;
                                    isDrawerOpen = false;
                                  });
                                },
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    xOffset = 250;
                                    yOffset = 155;
                                    zOffset = 20;
                                    scaleFactor = 0.6;
                                    isDrawerOpen = true;
                                  });
                                },
                              ),
                      ),
                      SizedBox(height: 50),
                      Container(
                        child: SvgPicture.asset(
                          'lib/assets/svgs/movie.svg',
                          width: 170 * widthRatio,
                          height: 170 * heightRatio,
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: Get.width * 0.8,
                        child: TextField(
                          maxLength: 12,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: themeController.primaryTextColor.value,
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
                              borderSide:
                                  new BorderSide(color: Colors.black, width: 6),
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
                            hintStyle: TextStyle(
                              //color:
                              //themeController.switchContainerColor.value
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 60),
                      Container(
                        width: 300 * widthRatio,
                        height: 80 * heightRatio,
                        child: ElevatedButton(
                          clipBehavior: Clip.none,
                          style: ElevatedButton.styleFrom(
                            animationDuration: Duration(milliseconds: 400),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            primary: Colors.redAccent,
                            // shadowColor: Colors.blueAccent,
                            elevation: 6,
                          ),
                          child: Text(
                            'Join Room',
                            style: TextStyle(
                                fontSize: 30,
                                //fontSize: 40 * widthRatio,
                                fontWeight: FontWeight.normal),
                          ),
                          onPressed: () async {
                            // Portrait build

                            _createCustomBottomSheet(
                                heightRatio: heightRatio,
                                widthRatio: widthRatio,
                                size: size);

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
                        ),
                      ),
                      SizedBox(height: 30 * heightRatio),
                      Container(
                        width: 300 * widthRatio,
                        height: 80 * heightRatio,
                        child: Hero(
                          tag: 'Rishabh',
                          child: Obx(
                            () => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                primary: Colors.redAccent,
                                elevation: 8,
                                onPrimary: Colors.white,
                              ),
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(25),
                              // ),
                              // color: Colors.white,
                              onPressed: () async {
                                roomLogicController.isLoading.value = true;
                                await roomLogicController.makeRoom(
                                    adminName: nameController.text);
                                Get.to(WaitingPage());
                                roomLogicController.isLoading.value = false;
                              },
                              child: !roomLogicController.isLoading.value
                                  ? Text(
                                      'Create Room',
                                      style: TextStyle(
                                          fontSize: 30,
                                          //fontSize: 35 * widthRatio,
                                          fontWeight: FontWeight.normal),
                                    )
                                  : CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
