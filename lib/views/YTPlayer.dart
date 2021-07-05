// import 'dart:async';

import 'dart:async';
import 'dart:ui';

import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/chat.dart';
import 'package:VideoSync/controllers/funLogic.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/controllers/ytPlayercontroller.dart';
import 'package:VideoSync/widgets/chat_widget.dart';
import 'package:VideoSync/widgets/custom_button.dart';
//import 'package:VideoSync/widgets/custom_namebar.dart';
import 'package:VideoSync/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:VideoSync/views/welcome_Screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:VideoSync/widgets/show_alerts.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'chat.dart';

class YTPlayer extends StatefulWidget {
  @override
  _YTPlayerState createState() => _YTPlayerState();
}

// String url;

RoomLogicController roomLogicController = Get.put(RoomLogicController());
ChatController chatController = Get.put(ChatController());
YTStateController ytStateController = Get.put(YTStateController());
RishabhController rishabhController = Get.put(RishabhController());
FunLogic funLogic = Get.put(FunLogic());
CustomThemeData themeController = Get.put(CustomThemeData());
ScrollController chatScrollController = ScrollController();
AnimationController animationController;
final double heightRatio = Get.height / 823;
final double widthRatio = Get.width / 411;
int buttonPressed = 1;

// int position = 0;

class _YTPlayerState extends State<YTPlayer> {
  YoutubePlayerController controller = YoutubePlayerController(
    initialVideoId:
        YoutubePlayer.convertUrlToId(roomLogicController.ytURL.value),
    flags: YoutubePlayerFlags(
        autoPlay: false,
        // hideControls: !(roomLogicController.adminKaNaam.obs.value ==
        //         roomLogicController.userName.obs.value)
        //     ? true
        //     : false,
        hideControls: true,
        mute: false,
        disableDragSeek: false,

        // hideControls: true,
        hideThumbnail: true),
  );
  int timestamp = 0;
  // bool dontHideControlsBool = true;
  bool hideUI = false;
  double animatedHeight = 30;
  bool shoSpeedWidget = false;
  bool playerIsUser = true;
  int selectedRadio;
  Duration videoLength;

  TextEditingController chatTextController = TextEditingController();
  // final GlobalKey globalKey = GlobalKey();

  // void hideControls() async {
  //   if (controller.value.isPlaying) {
  //     await Future.delayed(Duration(seconds: 2));
  //     setState(() {
  //       dontHideControlsBool = true;
  //     });
  //   } else {
  //     await Future.delayed(Duration(seconds: 2));
  //     // hideControlsBool = false;
  //     setState(() {
  //       dontHideControlsBool = false;
  //     });
  //   }
  //   print('Khushi Love');
  // }

  @override
  void initState() {
    roomLogicController
        .adminIdd(firebaseId: roomLogicController.roomFireBaseId)
        .listen((event) {
      print("adminId");
      roomLogicController.adminId.value = event.snapshot.value;
      // if (Get.context.orientation == Orientation.portrait)
      //   controller.toggleFullScreenMode();

      // setState(() {});
    });

    print(roomLogicController.adminId.value);

    var firebaseDatabase = FirebaseDatabase.instance.reference();
    firebaseDatabase
        .child('Rooms')
        .child(roomLogicController.roomFireBaseId.obs.value)
        .child('timeStamp')
        .onValue
        .listen((event) {
      if (!(roomLogicController.adminId.value ==
          roomLogicController.userId.obs.value)) {
        if ((controller.value.position.inSeconds - event.snapshot.value)
                .abs() >=
            3) {
          controller.seekTo(Duration(seconds: event.snapshot.value));
        }
      }
    });

    firebaseDatabase
        .child('Rooms')
        .child(roomLogicController.roomFireBaseId.obs.value)
        .child('isPlayerPaused')
        .onValue
        .listen((event) {
      if (event.snapshot.value) {
        controller.pause();
        print(roomLogicController.adminId.value);
        // print(event.snapshot.value);
      } else {
        controller.play();
      }
    });

    // chatController
    //     .message(firebaseId: roomLogicController.roomFireBaseId)
    //     .listen((event) {
    //   List<M> check = [];

    //   event.snapshot.value.forEach((key, value) {
    //     check.add(M(
    //         id: DateTime.parse(value["messageId"]),
    //         mesage: value["message"],
    //         userId: value["userId"],
    //         username: value["username"]));
    //   });

    //   check.sort((a, b) => (a.id).compareTo(b.id));
    //   if (check[check.length - 1].userId != roomLogicController.userId)
    //     Get.snackbar(
    //         check[check.length - 1].username, check[check.length - 1].mesage);
    // });

    firebaseDatabase
        .child('Rooms')
        .child(roomLogicController.roomFireBaseId.obs.value)
        .child('playBackSpeed')
        .onValue
        .listen((event) {
      if (!(roomLogicController.adminId.value ==
          roomLogicController.userId.obs.value)) {
        controller.setPlaybackRate(event.snapshot.value);
      }
    });

    // roomLogicController
    //     .roomStatus(firebaseId: roomLogicController.roomFireBaseId)
    //     .listen((event) {
    //   int x = event.snapshot.value;
    //   if (x == 0) {
    //     Get.back();
    //   }
    // });

    // hideControls();

    super.initState();

    selectedRadio = 1;
    listenToTextInputStateChanges();
  }

  void listenToTextInputStateChanges() {
    chatTextController.addListener(() {
      print("TextState: ${chatTextController.text}");
      if (chatTextController.text == "") {
        chatController.isTextEmpty.value = true;
      } else {
        chatController.isTextEmpty.value = false;
      }
      print('TextState: ${chatController.isTextEmpty}');
    });
  }

  @override
  void dispose() {
    controller.dispose();
    chatTextController.dispose();
    roomLogicController.dispose();
    rishabhController.dispose();
    ytStateController.dispose();
    super.dispose();
  }

  changeRadioValue(int value) {
    setState(() {
      selectedRadio = value;
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        controller.pause();
        Navigator.pop(context);
        // controller.seekTo(Duration(seconds: 0));
        Navigator.pop(context);
        return true;
      },
    );

    Widget cancel = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
        // controller.seekTo(Duration(seconds: timestamp));
        return false;
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alert"),
      content: Text("Do you want to leave the screen"),
      actions: [okButton, cancel],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    FocusNode currenFocus = FocusScope.of(context);

    return WillPopScope(
      onWillPop: () async {
        // controller.pause();
        if (Get.context.orientation == Orientation.landscape)
          controller.toggleFullScreenMode();

        // rishabhController.sendPlayerStatus(
        //     status: false, firebaseId: roomLogicController.roomFireBaseId);
        return showAlertDialog(context);
      },
      child: Scaffold(
        appBar: Get.context.orientation == Orientation.portrait
            ? AppBar(
                backgroundColor: Color(0xff292727),
                elevation: 0,
                leading: GestureDetector(
                  onTap: () {
                    Get.bottomSheet(
                      //Expanded(
                      // margin: EdgeInsets.only(left: 20),
                      // color: Colors.blue.withOpacity(0.1),
                      // height: heightRatio * 300,
                      // width: widthRatio * 200,
                      // height: 500,
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        color: Color.fromRGBO(10, 10, 10, 0.9),
                        width: double.infinity,
                        height: 300,
                        // color: Colors.red,
                        child: Column(
                          children: <Widget>[
                            Center(
                              child: Container(
                                alignment: Alignment.center,
                                height: 40,
                                width: double.infinity,
                                child: Text(
                                  'All Users',
                                  style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 0.8),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 250,
                              child: FutureBuilder(
                                  future: Future.delayed(Duration(seconds: 1)),
                                  builder: (ctx, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return StreamBuilder(
                                        stream: rishabhController.tester(
                                            firebaseId: roomLogicController
                                                .roomFireBaseId),
                                        builder: (ctx, event) {
                                          if (event.hasData) {
                                            return NotificationListener<
                                                OverscrollIndicatorNotification>(
                                              onNotification: (overscroll) {
                                                overscroll.disallowGlow();
                                              },
                                              child: ListView.separated(
                                                scrollDirection: Axis.vertical,
                                                separatorBuilder: (ctx, i) {
                                                  return SizedBox(
                                                    width: 5,
                                                  );
                                                },
                                                itemBuilder: (ctx, i) {
                                                  print(
                                                      'chut: ${event.data.snapshot.value}');
                                                  return Container(
                                                    width: 100,
                                                    height: 60,
                                                    child: CustomNameBar(
                                                      userName: event.data
                                                          .snapshot.value.values
                                                          .toList()[i]['name'],
                                                      roomController:
                                                          roomLogicController,
                                                      userID: event.data
                                                          .snapshot.value.values
                                                          .toList()[i]['id'],
                                                      event: event,
                                                      index: i,
                                                      widthRatio: widthRatio,
                                                      heightRatio: heightRatio,
                                                      controller: funLogic,
                                                    ),
                                                  );
                                                },
                                                itemCount: event
                                                    .data.snapshot.value.values
                                                    .toList()
                                                    .length,
                                              ),
                                            );
                                          } else if (event.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                            Color>(
                                                        themeController
                                                            .drawerHead.value),
                                              ),
                                            );
                                          } else {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator(
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                          Color>(
                                                      themeController
                                                          .drawerHead.value),
                                            ));
                                          }
                                          return Container(
                                              height: 0.0, width: 0.0);
                                        },
                                      );
                                    }
                                    return Container();
                                  }),
                            ),
                          ],
                        ),
                      ),
                      //),
                    );
                  },
                  child: Icon(Icons.people),
                ),
                centerTitle: true,
                title: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: GetX<RoomLogicController>(builder: (controller) {
                    return Text('${controller.roomId.obs.value} ',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.w100));
                  }),
                ),
                actions: [
                  Container(
                    padding: EdgeInsets.only(right: 13),
                    child: GestureDetector(
                      child: buttonPressed == 0
                          ? Icon(Icons.message)
                          : Icon(Icons.fullscreen),
                      onTap: () {
                        if (buttonPressed == 1)
                          setState(() {
                            buttonPressed = 0;
                          });
                        else
                          setState(() {
                            buttonPressed = 1;
                          });
                      },
                    ),
                  )
                ],
              )
            : null,
        // endDrawer: Container(
        //   width: 380 * widthRatio,
        //   child: Drawer(
        //     child: ChattingPlace(controller: controller),
        //   ),
        // ),
        backgroundColor: Color(0xff292727),
        body: Column(
          children: [
            SizedBox(
              height: buttonPressed == 0 ? 225 : 0,
            ),
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.red)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: [
                    //The youtube player
                    Align(
                      alignment: Alignment.center,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        // width: double.infinity,
                        child: YoutubePlayer(
                          // onEnded: (_) {
                          //   Get.off(WelcomScreen());
                          // },
                          aspectRatio: 16 / 9,
                          controller: controller,
                          showVideoProgressIndicator: true,
                          progressColors: ProgressBarColors(
                              playedColor: Colors.amber,
                              handleColor: Colors.amberAccent),
                          onReady: () {
                            controller.addListener(
                              () {
                                roomLogicController.videoPosition.value =
                                    controller.value.position;
                                roomLogicController.playingStatus.value =
                                    controller.value.isPlaying;
                                ytStateController.videoPosition.value =
                                    controller.value.position.inSeconds
                                        .toDouble();
                                // print("adminId");
                                // print(roomLogicController.adminId.;value);
                                //admin
                                //will send timestamp and control video playback
                                if (roomLogicController.adminId.value ==
                                    roomLogicController.userId.obs.value) {
                                  rishabhController.sendTimeStamp(
                                      firebaseId:
                                          roomLogicController.roomFireBaseId,
                                      timeStamp:
                                          controller.value.position.inSeconds);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ),

                    //Control UIs
                    //seek back 10
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        // width: size.width,
                        // height: MediaQuery.of(context).orientation ==
                        //         Orientation.landscape
                        //     ? size.height * 0.8
                        //     : size.height * 0.3,
                        // decoration:
                        //     BoxDecoration(border: Border.all(color: Colors.yellow)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //For hiding or displaying UI
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                    // border: Border.all(color: Colors.yellow),

                                    ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      hideUI = !hideUI;
                                      shoSpeedWidget = false;
                                      // animatedHeight = 0;
                                    });
                                  },
                                ),
                              ),
                            ),
                            // Spacer(

                            Obx(
                              () => Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        // margin: EdgeInsets.only(left: 5),
                                        child: Text(
                                            '${roomLogicController.videoPosition.value.toString().substring(0, 7)}',
                                            style: TextStyle(
                                              color: Colors.white,
                                            )),
                                      ),
                                      Expanded(
                                        child: SliderTheme(
                                          data: SliderThemeData(
                                            activeTrackColor: Colors.indigo,
                                            inactiveTrackColor:
                                                Colors.indigo.shade200,
                                            trackShape:
                                                RoundedRectSliderTrackShape(),
                                            trackHeight: 2.0,
                                            thumbShape: RoundSliderThumbShape(
                                                enabledThumbRadius: 8.0),
                                            thumbColor: Colors.indigoAccent,
                                            overlayColor: Colors.indigo,
                                            overlayShape:
                                                RoundSliderOverlayShape(
                                                    overlayRadius: 10.0),
                                            tickMarkShape:
                                                RoundSliderTickMarkShape(),
                                            activeTickMarkColor: Colors.indigo,
                                            inactiveTickMarkColor:
                                                Colors.indigo,
                                            valueIndicatorShape:
                                                PaddleSliderValueIndicatorShape(),
                                            valueIndicatorColor: Colors.indigo,
                                          ),
                                          child: Slider(
                                            // activeColor:
                                            //     Color.fromRGBO(50, 60, 120, 0.5),

                                            value: roomLogicController
                                                .videoPosition.value.inSeconds
                                                .toDouble(),
                                            onChanged: (value) {
                                              roomLogicController
                                                      .videoPosition.value =
                                                  Duration(
                                                      seconds: value.toInt());
                                              controller.seekTo(Duration(
                                                  seconds: value.toInt()));
                                            },
                                            min: 0.0,
                                            max: controller
                                                    .metadata.duration.inSeconds
                                                    .toDouble() +
                                                5.0,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // margin: EdgeInsets.only(right: 5),
                                        child: Text(
                                            '${controller.metadata.duration.toString().substring(0, 7)}',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      )
                                    ],
                                  )),
                            ),

                            //For all the controls
                            AnimatedContainer(
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(25, 25, 25, 0.66),
                                // border: Border.all(color: Colors.cyan)
                              ),
                              // color: Color.fromRGBO(25, 25, 25, 0.66),
                              // decoration: BoxDecoration(
                              //     color: Colors.grey,
                              //     border: Border.all(color: Colors.cyan)),
                              // padding: EdgeInsets.only(bottom: 20),
                              duration: Duration(milliseconds: 500),
                              height: hideUI ? 40 : 0,
                              // width: hideUI ? 0 : size.width,
                              // height: 0,
                              child: AnimatedOpacity(
                                duration: Duration(milliseconds: 200),
                                opacity: hideUI ? 1 : 0,
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    //seek backward 10
                                    SizedBox(width: 10),
                                    if (roomLogicController.adminId.value ==
                                        roomLogicController.userId)
                                      IconButton(
                                        icon: Icon(Icons.speed),
                                        color: Colors.white,
                                        onPressed: () {
                                          // setState(() {
                                          //   shoSpeedWidget = !shoSpeedWidget;
                                          // });

                                          //Show speed UI
                                          // Get.dialog(Container(
                                          //     height: 200,
                                          //     width: 400,
                                          //     child: Card()));
                                          if (Get.context.orientation ==
                                              Orientation.portrait) {
                                            return Get.bottomSheet(
                                              Container(
                                                height: 350,
                                                color: Color.fromRGBO(
                                                    50, 50, 50, 1),
                                                child: GetBuilder<
                                                        RishabhController>(
                                                    builder: (controllerGetx) {
                                                  return Container(
                                                    width: double.infinity,
                                                    height: 100,
                                                    child: ListView(
                                                      // height: 50,
                                                      children: [
                                                        Container(
                                                          color: Color.fromRGBO(
                                                              50, 50, 50, 1),
                                                          child: RaisedButton(
                                                            color:
                                                                Color.fromRGBO(
                                                                    50,
                                                                    50,
                                                                    50,
                                                                    1),
                                                            elevation: 0,
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  Icons
                                                                      .arrow_back_ios,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                Text(
                                                                  'Playback speed',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.white,
                                                        ),
                                                        RadioListTile(
                                                            // key: globalKey,
                                                            //tileColor: Colors.white,
                                                            activeColor:
                                                                Colors.white,
                                                            toggleable: true,
                                                            title:
                                                                CustomText('1'),
                                                            value: 1.0,
                                                            groupValue:
                                                                controllerGetx
                                                                    .radioValue,
                                                            onChanged: (value) {
                                                              roomLogicController
                                                                  .sendPlayBackSpeed(
                                                                      speed:
                                                                          1.0);
                                                              controller
                                                                  .setPlaybackRate(
                                                                      1.0);
                                                              controllerGetx
                                                                  .radioValue
                                                                  .value = value;

                                                              Get.back();
                                                            }),
                                                        RadioListTile(
                                                            // key: globalKey,
                                                            title: CustomText(
                                                                '1.25'),
                                                            value: 1.25,
                                                            groupValue:
                                                                controllerGetx
                                                                    .radioValue
                                                                    .value,
                                                            onChanged: (value) {
                                                              // print('value: $value');
                                                              // changeRadioValue(value);
                                                              roomLogicController
                                                                  .sendPlayBackSpeed(
                                                                      speed:
                                                                          1.25);
                                                              controller
                                                                  .setPlaybackRate(
                                                                      1.25);
                                                              controllerGetx
                                                                  .radioValue
                                                                  .value = value;

                                                              Get.back();
                                                            }),
                                                        RadioListTile(
                                                            // key: globalKey,
                                                            title: CustomText(
                                                                '1.5'),
                                                            value: 1.5,
                                                            groupValue:
                                                                controllerGetx
                                                                    .radioValue
                                                                    .value,
                                                            onChanged: (value) {
                                                              // print('value: $value');
                                                              // changeRadioValue(value);
                                                              roomLogicController
                                                                  .sendPlayBackSpeed(
                                                                      speed:
                                                                          1.5);
                                                              controller
                                                                  .setPlaybackRate(
                                                                      1.5);
                                                              controllerGetx
                                                                  .radioValue
                                                                  .value = value;

                                                              Get.back();
                                                            }),
                                                        RadioListTile(
                                                            // key: globalKey,
                                                            title: CustomText(
                                                                '1.75'),
                                                            value: 1.75,
                                                            groupValue:
                                                                controllerGetx
                                                                    .radioValue
                                                                    .value,
                                                            onChanged: (value) {
                                                              roomLogicController
                                                                  .sendPlayBackSpeed(
                                                                      speed:
                                                                          1.75);
                                                              controller
                                                                  .setPlaybackRate(
                                                                      1.75);
                                                              controllerGetx
                                                                  .radioValue
                                                                  .value = value;

                                                              Get.back();
                                                            }),
                                                        RadioListTile(
                                                          // key: globalKey,
                                                          title:
                                                              CustomText('2'),
                                                          value: 2.0,
                                                          groupValue:
                                                              controllerGetx
                                                                  .radioValue
                                                                  .value,
                                                          onChanged: (value) {
                                                            // print('value: $value');
                                                            roomLogicController
                                                                .sendPlayBackSpeed(
                                                                    speed: 2.0);
                                                            controller
                                                                .setPlaybackRate(
                                                                    2.0);
                                                            controllerGetx
                                                                .radioValue
                                                                .value = value;

                                                            Get.back();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              ),
                                            );
                                          }
                                          Get.defaultDialog(
                                            backgroundColor:
                                                Color.fromRGBO(30, 30, 30, 0),
                                            title: '',
                                            content:
                                                GetBuilder<RishabhController>(
                                                    builder: (controllerGetx) {
                                              return SingleChildScrollView(
                                                child: Container(
                                                  color: Color.fromRGBO(
                                                      30, 30, 30, 0.9),
                                                  width: 900,
                                                  height: 200,
                                                  child: ListView(
                                                    // height: 50,
                                                    children: [
                                                      Container(
                                                        color: Color.fromRGBO(
                                                            50, 50, 50, 0),
                                                        child: RaisedButton(
                                                          color: Color.fromRGBO(
                                                              50, 50, 50, 0),
                                                          elevation: 0,
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child: Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons
                                                                    .arrow_back_ios,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              Text(
                                                                'Playback speed',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Divider(
                                                        color: Colors.white,
                                                      ),
                                                      RadioListTile(
                                                          // key: globalKey,
                                                          toggleable: true,
                                                          title:
                                                              CustomText('1'),
                                                          selectedTileColor:
                                                              Color.fromRGBO(
                                                                  200,
                                                                  200,
                                                                  200,
                                                                  0.8),
                                                          value: 1.0,
                                                          groupValue:
                                                              controllerGetx
                                                                  .radioValue,
                                                          onChanged: (value) {
                                                            roomLogicController
                                                                .sendPlayBackSpeed(
                                                                    speed: 1.0);
                                                            controller
                                                                .setPlaybackRate(
                                                                    1.0);
                                                            controllerGetx
                                                                .radioValue
                                                                .value = value;

                                                            Get.back();
                                                          }),
                                                      RadioListTile(
                                                          // key: globalKey,
                                                          title: CustomText(
                                                              '1.25'),
                                                          value: 1.25,
                                                          groupValue:
                                                              controllerGetx
                                                                  .radioValue
                                                                  .value,
                                                          selectedTileColor:
                                                              Color.fromRGBO(
                                                                  200,
                                                                  200,
                                                                  200,
                                                                  0.8),
                                                          onChanged: (value) {
                                                            // print('value: $value');
                                                            // changeRadioValue(value);
                                                            roomLogicController
                                                                .sendPlayBackSpeed(
                                                                    speed:
                                                                        1.25);
                                                            controller
                                                                .setPlaybackRate(
                                                                    1.25);
                                                            controllerGetx
                                                                .radioValue
                                                                .value = value;

                                                            Get.back();
                                                          }),
                                                      RadioListTile(
                                                          // key: globalKey,
                                                          title:
                                                              CustomText('1.5'),
                                                          value: 1.5,
                                                          groupValue:
                                                              controllerGetx
                                                                  .radioValue
                                                                  .value,
                                                          selectedTileColor:
                                                              Color.fromRGBO(
                                                                  200,
                                                                  200,
                                                                  200,
                                                                  0.8),
                                                          onChanged: (value) {
                                                            // print('value: $value');
                                                            // changeRadioValue(value);
                                                            roomLogicController
                                                                .sendPlayBackSpeed(
                                                                    speed: 1.5);
                                                            controller
                                                                .setPlaybackRate(
                                                                    1.5);
                                                            controllerGetx
                                                                .radioValue
                                                                .value = value;

                                                            Get.back();
                                                          }),
                                                      RadioListTile(
                                                          // key: globalKey,
                                                          title: CustomText(
                                                              '1.75'),
                                                          value: 1.75,
                                                          groupValue:
                                                              controllerGetx
                                                                  .radioValue
                                                                  .value,
                                                          selectedTileColor:
                                                              Color.fromRGBO(
                                                                  200,
                                                                  200,
                                                                  200,
                                                                  0.8),
                                                          onChanged: (value) {
                                                            roomLogicController
                                                                .sendPlayBackSpeed(
                                                                    speed:
                                                                        1.75);
                                                            controller
                                                                .setPlaybackRate(
                                                                    1.75);
                                                            controllerGetx
                                                                .radioValue
                                                                .value = value;

                                                            Get.back();
                                                          }),
                                                      RadioListTile(
                                                        // key: globalKey,
                                                        title: CustomText('2'),
                                                        value: 2.0,
                                                        groupValue:
                                                            controllerGetx
                                                                .radioValue
                                                                .value,
                                                        selectedTileColor:
                                                            Color.fromRGBO(200,
                                                                200, 200, 0.8),
                                                        onChanged: (value) {
                                                          // print('value: $value');
                                                          roomLogicController
                                                              .sendPlayBackSpeed(
                                                                  speed: 2.0);
                                                          controller
                                                              .setPlaybackRate(
                                                                  2.0);
                                                          controllerGetx
                                                              .radioValue
                                                              .value = value;

                                                          Get.back();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                            // cancel: RaisedButton(
                                            //   onPressed: () {
                                            //     Get.back();
                                            //   },
                                            //   child: Text('Cancel'),
                                            // ),
                                          );
                                        },
                                      ),

                                    if (roomLogicController.adminId.value ==
                                        roomLogicController.userId.obs.value)
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            controller.seekTo(Duration(
                                                seconds: controller.value
                                                        .position.inSeconds -
                                                    10));
                                          },
                                          child: SvgPicture.asset(
                                              'lib/assets/svgs/back10.svg',
                                              width: 30 * widthRatio,
                                              height: 30 * heightRatio),
                                        ),
                                      ),

                                    //play pause icon
                                    Expanded(
                                      // width: Get.width * 0.4,
                                      // color: Colors.blue.shade100,
                                      child: GestureDetector(
                                        onTap: () {
                                          // hideControls();
                                          if (controller.value.isPlaying) {
                                            rishabhController.sendPlayerStatus(
                                                status: true,
                                                firebaseId: roomLogicController
                                                    .roomFireBaseId);
                                            controller.pause();
                                          } else {
                                            rishabhController.sendPlayerStatus(
                                                status: false,
                                                firebaseId: roomLogicController
                                                    .roomFireBaseId);
                                            controller.pause();
                                            controller.play();
                                          }
                                        },
                                        child: Obx(
                                          () => roomLogicController
                                                  .playingStatus.value
                                              ? Icon(
                                                  Icons.pause,
                                                  size: 40,
                                                  color: Colors.white,
                                                )
                                              : Icon(
                                                  Icons.play_arrow,
                                                  size: 40,
                                                  color: Colors.white,
                                                ),
                                        ),
                                      ),
                                    ),

                                    //seek forward 10
                                    if (roomLogicController.adminId.value ==
                                        roomLogicController.userId.obs.value)
                                      Expanded(
                                        // width: Get.width * 0.3,
                                        // color: Colors.yellow.shade100,
                                        child: GestureDetector(
                                          child: SvgPicture.asset(
                                              'lib/assets/svgs/go10.svg',
                                              width: 30 * widthRatio,
                                              height: 30 * heightRatio),
                                          onTap: () {
                                            controller.seekTo(Duration(
                                                seconds: controller.value
                                                        .position.inSeconds +
                                                    10));
                                          },
                                        ),
                                      ),

                                    //Toggle fullscreen
                                    IconButton(
                                      icon: Icon(
                                        Icons.fullscreen,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        controller.toggleFullScreenMode();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // if (roomLogicController.adminKaNaam.obs.value ==
                    //   roomLogicController.userName.obs.value)
                    // AnimatedContainer(
                    //   duration: Duration(seconds: 1),
                    //   // height: hideUI ? 0 : double.maxFinite,
                    //   margin: EdgeInsets.only(bottom: 40),
                    //   decoration:
                    //       BoxDecoration(border: Border.all(color: Colors.red)),
                    //   // height: 100,
                    //   width: shoSpeedWidget ? 40 : 0,
                    //   child: Align(
                    //     alignment: Alignment.center,
                    //     child: AnimatedOpacity(
                    //       duration: Duration(milliseconds: 200),
                    //       opacity: !shoSpeedWidget ? 0 : 1,
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //         children: [
                    //           SizedBox(height: 20),
                    //           GestureDetector(
                    //             child: CustomText('1.0'),
                    //             onTap: () {
                    //               roomLogicController.sendPlay(speed: 1.0);
                    //               controller.setPlaybackRate(1.0);
                    //             },
                    //           ),
                    //           GestureDetector(
                    //             child: CustomText('1.25'),
                    //             onTap: () {
                    //               roomLogicController.sendPlay(speed: 1.25);
                    //               controller.setPlaybackRate(1.25);
                    //             },
                    //           ),
                    //           // Spacer(),
                    //           GestureDetector(
                    //             child: CustomText('1.5'),
                    //             onTap: () {
                    //               roomLogicController.sendPlay(speed: 1.5);
                    //               controller.setPlaybackRate(1.5);
                    //             },
                    //           ),
                    //           GestureDetector(
                    //             child: CustomText('1.75'),
                    //             onTap: () {
                    //               roomLogicController.sendPlay(speed: 1.75);
                    //               controller.setPlaybackRate(1.75);
                    //             },
                    //           ),
                    //           GestureDetector(
                    //             child: CustomText('2.0'),
                    //             onTap: () {
                    //               roomLogicController.sendPlay(speed: 2.0);
                    //               controller.setPlaybackRate(2.0);
                    //             },
                    //           ),
                    //           // SizedBox(height: 30)
                    //           // Spacer()
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // )
                    // RaisedButton(onPressed: () {
                    //   print('marty: ${rishabhController.radioValue.value}');
                    // })
                  ],
                ),
              ),
            ),
            if (Get.context.orientation == Orientation.portrait)
              SizedBox(height: 10),
            //this is the chat display part of code
            if (Get.context.orientation == Orientation.portrait &&
                buttonPressed == 1)
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  // stream: chatController.message(
                  //     firebaseId: roomLogicController.roomFireBaseId),
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc('${roomLogicController.roomFireBaseId}')
                      .collection('messages')
                      .orderBy('timeStamp', descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text("Some error occured"));
                    } else if (snapshot.hasData) {
                      return NotificationListener<
                          OverscrollIndicatorNotification>(
                        onNotification: (overscroll) {
                          overscroll.disallowGlow();
                          return null;
                        },
                        child: ListView.separated(
                          controller: chatScrollController,
                          itemBuilder: (BuildContext context, int index) {
                            return ChatWidget(
                              userName:
                                  "${snapshot.data.docs[index]['sentBy']}",
                              messageText:
                                  "${snapshot.data.docs[index]['message']}",
                              timeStamp:
                                  "${snapshot.data.docs[index]['timeStamp']}",
                              userIdofOtherUsers:
                                  "${snapshot.data.docs[index]['userId']}",
                              usersOwnUserId:
                                  roomLogicController.userId.toString(),
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
                ),
              ),

            //this is the sending part
            //send button
            //and textinput widget
            if (Get.context.orientation == Orientation.portrait &&
                buttonPressed == 1)
              Container(
                width: double.infinity,
                height: 50,
                color: Color.fromRGBO(10, 10, 10, 1),
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
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
                                      roomId:
                                          roomLogicController.roomFireBaseId,
                                      message: chatTextController.text,
                                      userId: roomLogicController.userId,
                                      sentBy:
                                          roomLogicController.userName.value);

                                  //scroll the listview down
                                  Timer(
                                      Duration(milliseconds: 300),
                                      () => chatScrollController.jumpTo(
                                          chatScrollController
                                              .position.maxScrollExtent));
                                  //clear the text from textfield
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
              )
          ],
        ),
      ),
    );
  }
}

class CustomNameBar extends StatefulWidget {
  final String userName;
  final AsyncSnapshot event;
  final int index;
  final double heightRatio;
  final double widthRatio;
  final String userID;
  final FunLogic controller;
  final RoomLogicController roomController;
  CustomAlertes customAlertes;
  CustomNameBar({
    this.userName,
    this.event,
    this.index,
    this.heightRatio,
    this.widthRatio,
    this.controller,
    Key key,
    this.userID,
    this.roomController,
  }) : super(key: key);

  @override
  _CustomNameBarState createState() => _CustomNameBarState();
}

class _CustomNameBarState extends State<CustomNameBar> {
  Future buildShowDialog(BuildContext context, {String userName}) {
    return showDialog(
      context: context,
      builder: (context) => Container(
        child: new AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title:
              new Text('Kick User', style: TextStyle(color: Colors.blueAccent)),
          content: Text("Do you want to kick $userName ?"),
          actions: <Widget>[
            CustomButton(
              height: 30,
              buttonColor: Colors.blueAccent,
              content: "Cancel",
              cornerRadius: 5,
              contentSize: 14,
              function: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            CustomButton(
              height: 30,
              // buttonColor: Colors.redAccent,
              content: "Kick",
              cornerRadius: 5,
              contentSize: 14,
              function: () {
                widget.roomController.kickUser(
                    firebaseId: widget.roomController.roomFireBaseId,
                    idofUser: widget.userID);
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 224 * widget.widthRatio,
      height: 90 * widget.heightRatio,
      child: Card(
        color: Color.fromARGB(200, 60, 60, 60),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        // width: 20,
        // height: 70,
        // color: Colors.white,
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(25), color: Colors.white),

        child: Row(
          children: [
            SizedBox(width: widget.widthRatio * 12),
            ClipOval(
              child: Container(
                decoration: BoxDecoration(),
                width: 35,
                height: 35,
                child: Image.network(
                    'https://i.picsum.photos/id/56/200/200.jpg?hmac=rRTTTvbR4tHiWX7-kXoRxkV7ix62g9Re_xUvh4o47jA'),
              ),
            ),
            SizedBox(width: 20 * widget.heightRatio),
            Text(
              '${widget.event.data.snapshot.value.values.toList()[widget.index]['name']}',
              style: TextStyle(
                  fontSize: 17, color: widget.controller.randomColorPick),
            ),
            Spacer(),
            Column(
              children: [
                (widget.roomController.userId != widget.userID &&
                        widget.roomController.userId ==
                            widget.roomController.adminId.value)
                    ? ClipOval(
                        child: GestureDetector(
                          onTap: () {
                            print(
                                "roomControllerUserId: ${widget.roomController.userId}");

                            print("UserId: ${widget.userID}");

                            buildShowDialog(context, userName: widget.userName);
                          },
                          child: Container(
                            width: 25,
                            height: 25,
                            color: Colors.red,
                            child: Center(child: Text('X')),
                          ),
                        ),
                      )
                    : Container(),
                Spacer()
              ],
            )
          ],
        ),
      ),
    );
  }
}
