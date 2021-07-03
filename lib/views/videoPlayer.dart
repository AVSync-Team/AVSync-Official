import 'dart:io';
import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/chat.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/controllers/ytPlayercontroller.dart';
import 'package:VideoSync/views/chat.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class NiceVideoPlayer extends StatefulWidget {
  @override
  _NiceVideoPlayerState createState() => _NiceVideoPlayerState();
}

RoomLogicController roomLogicController = Get.put(RoomLogicController());
ChatController chatController = Get.put(ChatController());
YTStateController ytStateController = Get.put(YTStateController());
RishabhController rishabhController = Get.put(RishabhController());
CustomThemeData themeData = Get.put(CustomThemeData());
AnimationController animationController;
final double heightRatio = Get.height / 823;
final double widthRatio = Get.width / 411;

class _NiceVideoPlayerState extends State<NiceVideoPlayer>
    with SingleTickerProviderStateMixin {
  ///            `controllers`
  AnimationController _animationController;
  VideoPlayerController controller;
  VideoPlayerController subsController;

  ///             `properties`
  Duration videoLength;
  final double heightRatio = Get.height / 823;
  final double widthRatio = Get.width / 411;
  int timestamp = 0;
  // bool dontHideControlsBool = true;
  bool hideUI = false;
  double animatedHeight = 30;
  bool shoSpeedWidget = false;
  bool playerIsUser = true;
  int selectedRadio;
  bool isLoading = false;
  bool picking = false;
  String path = "";

  @override
  void initState() {
    super.initState();

    //animation controller
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));

    ///`Video Player Controller`

    controller =
        VideoPlayerController.file(File(roomLogicController.localUrl.value),
            // closedCaptionFile: _loadCaptions(),
            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
          ..initialize().then((_) {
            setState(() {
              videoLength = controller.value.duration;
            });
          });

    //closed captions
    // initializeSubs();

    //firebase
    var firebaseDatabase = FirebaseDatabase.instance.reference();
    firebaseDatabase
        .child('Rooms')
        .child(roomLogicController.roomFireBaseId.obs.value)
        .child('timeStamp')
        .onValue
        .listen((event) {
      if (!(roomLogicController.adminKaNaam.obs.value ==
          roomLogicController.userName.obs.value)) {
        if ((controller.value.position.inSeconds - event.snapshot.value)
                .abs() >=
            5) {
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
      if (!(roomLogicController.adminKaNaam.obs.value ==
          roomLogicController.userName.obs.value)) {
        // controller.setPlaybackRate(event.snapshot.value);
        controller.setPlaybackSpeed(event.snapshot.value);
      }
    });

    // hideControls();

    selectedRadio = 1;

    //video controller listeners
    addListener();

    
  }

  void addListener() {
    
    return controller.addListener(() {
      roomLogicController.videoPosition.value = controller.value.position;
      roomLogicController.playingStatus.value = controller.value.isPlaying;
      ytStateController.videoPosition.value =
          controller.value.position.inSeconds.toDouble();

      //admin
      //will send timestamp and control video playback
      if (roomLogicController.adminKaNaam.obs.value ==
          roomLogicController.userName.obs.value) {
        rishabhController.sendTimeStamp(
            firebaseId: roomLogicController.roomFireBaseId,
            timeStamp: controller.value.position.inSeconds);
      }
      setState(() {});
    });
  }

  changeRadioValue(int value) {
    setState(() {
      selectedRadio = value;
    });
  }

  @override
  void dispose() {
    chatController.dispose();
    roomLogicController.dispose();
    rishabhController.dispose();
    controller.dispose();

    super.dispose();
  }

  Future<void> filePick() async {
    // setState(() {
    //   isLoading = true;
    // });

    print("File picker fired");
    FilePickerResult result = await FilePicker.platform.pickFiles(
        // type: FileType.media,
        // allowMultiple: false,
        // allowedExtensions: ['.srt'],
        withData: false,
        // allowCompression: true,
        withReadStream: true,
        onFileLoading: (status) {
          if (status.toString() == "FilePickerStatus.picking") {
            // setState(() {
            //   picking = true;
            // });
          } else {
            // setState(() {
            //   picking = false;
            // });
          }
        });

    // roomLogicController.bytes.obs.value = result.files[0];
    path = result.files[0].path;
    print("vide path $path");

    // print('testUrl: $testUrl');
    // setState(() {
    //   isLoading = false;
    // });

    // Get.to(NiceVideoPlayer());
  }

  Future<ClosedCaptionFile> _loadCaptions() async {
    print('closedcaptions fires');
    final String fileContents =
        await DefaultAssetBundle.of(context).loadString('lib/assets/lund.srt');
    print('contents: $fileContents');
    return SubRipCaptionFile(fileContents);
  }

  // Future<ClosedCaptionFile> _loadCaptions() async {
  //   print("fired");
  //   final String fileContents =
  //       await DefaultAssetBundle.of(context).loadString(path);
  //   print('fileContents : $fileContents');
  //   return SubRipCaptionFile(fileContents);
  // }

  Future<void> initializeSubs() async {
    //first close the videoPlayer
    // controller.dispose();
    // await filePick();

    controller = VideoPlayerController.file(
        File(
          roomLogicController.localUrl.value,
        ),
        closedCaptionFile: _loadCaptions())
      ..initialize().then((_) {
        // setState(() {
        //   print(videoLength.toString() + "LODE  BSDK ");
        //   videoLength = controller.value.duration;
        // });
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: Get.context.orientation == Orientation.portrait
          ? AppBar(
              backgroundColor: Color(0xff292727),
              elevation: 0,
            )
          : null,
      // endDrawer: Container(
      //   width: 380 * widthRatio,
      //   child: Drawer(
      //     child: ChattingPlace(controller: controller),
      //   ),
      // ),
      backgroundColor: themeData.primaryColor.value,
      body: Center(
        child: Container(
          // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: Stack(
              children: [
                //The youtube player
                Align(
                  alignment: Alignment.center,
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    // width: double.infinity,
                    child: VideoPlayer(controller),
                    // ClosedCaption(),
                  ),
                ),

                //Control UIs
                //seek back 10
                Container(
                  // decoration:
                  //     BoxDecoration(border: Border.all(color: Colors.cyan)),
                  child: Align(
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
                              // decoration: BoxDecoration(
                              //   border: Border.all(color: Colors.yellow),
                              // ),
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
                          if (controller != null)
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
                                                .value.duration.inSeconds
                                                .toDouble(),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // margin: EdgeInsets.only(right: 5),
                                        child: Text(
                                            '${controller.value.duration.toString().substring(0, 7)}',
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
                                  if (roomLogicController
                                          .adminKaNaam.obs.value ==
                                      roomLogicController.userName.obs.value)
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
                                        Get.defaultDialog(
                                          titleStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                          backgroundColor: Color(0xff292727),
                                          title: 'Speed',
                                          content:
                                              GetBuilder<RishabhController>(
                                                  builder: (controllerGetx) {
                                            return Container(
                                              width: 200,
                                              height: 170,
                                              child: ListView(
                                                // height: 50,
                                                children: [
                                                  Container(
                                                    height: 50,
                                                    child: RadioListTile(
                                                        // key: globalKey,
                                                        toggleable: true,
                                                        title: CustomText('1'),
                                                        value: 1.0,
                                                        groupValue:
                                                            controllerGetx
                                                                .radioValue,
                                                        onChanged: (value) {
                                                          roomLogicController
                                                              .sendPlayBackSpeed(
                                                                  speed: 1.0);
                                                          controller
                                                              .setPlaybackSpeed(
                                                                  1.0);
                                                          controllerGetx
                                                              .radioValue
                                                              .value = value;

                                                          Get.back();
                                                        }),
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    child: RadioListTile(
                                                        // key: globalKey,
                                                        title:
                                                            CustomText('1.25'),
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
                                                                  speed: 1.25);
                                                          controller
                                                              .setPlaybackSpeed(
                                                                  1.25);
                                                          controllerGetx
                                                              .radioValue
                                                              .value = value;

                                                          Get.back();
                                                        }),
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    child: RadioListTile(
                                                        // key: globalKey,
                                                        title:
                                                            CustomText('1.5'),
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
                                                                  speed: 1.5);
                                                          controller
                                                              .setPlaybackSpeed(
                                                                  1.5);
                                                          controllerGetx
                                                              .radioValue
                                                              .value = value;

                                                          Get.back();
                                                        }),
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    child: RadioListTile(
                                                        // key: globalKey,
                                                        title:
                                                            CustomText('1.75'),
                                                        value: 1.75,
                                                        groupValue:
                                                            controllerGetx
                                                                .radioValue
                                                                .value,
                                                        onChanged: (value) {
                                                          roomLogicController
                                                              .sendPlayBackSpeed(
                                                                  speed: 1.75);
                                                          controller
                                                              .setPlaybackSpeed(
                                                                  1.75);
                                                          controllerGetx
                                                              .radioValue
                                                              .value = value;

                                                          Get.back();
                                                        }),
                                                  ),
                                                  Container(
                                                      child: ElevatedButton(
                                                    child: Container(),
                                                    onPressed: () async {
                                                      await initializeSubs();
                                                    },
                                                  )),
                                                  Container(
                                                    // height: 40,
                                                    margin: EdgeInsets.only(
                                                        bottom: 10),
                                                    child: RadioListTile(
                                                      // key: globalKey,
                                                      title: CustomText('2'),
                                                      value: 2.0,
                                                      groupValue: controllerGetx
                                                          .radioValue.value,
                                                      onChanged: (value) {
                                                        // print('value: $value');
                                                        roomLogicController
                                                            .sendPlayBackSpeed(
                                                                speed: 2.0);
                                                        controller
                                                            .setPlaybackSpeed(
                                                                2.0);
                                                        controllerGetx
                                                            .radioValue
                                                            .value = value;

                                                        Get.back();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                          cancel: RaisedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text('Cancel'),
                                          ),
                                        );
                                      },
                                    ),

                                  if (roomLogicController
                                          .adminKaNaam.obs.value ==
                                      roomLogicController.userName.obs.value)
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.seekTo(Duration(
                                              seconds: controller.value.position
                                                      .inSeconds -
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
                                      child: IconButton(
                                          icon: AnimatedIcon(
                                            color: Colors.white,
                                            size: 28,
                                            progress: _animationController,
                                            icon: AnimatedIcons.play_pause,
                                          ),
                                          onPressed: () {
                                            if (roomLogicController
                                                .playingStatus.value) {
                                              controller.pause();
                                              _animationController.reverse();
                                            } else if (!roomLogicController
                                                .playingStatus.value) {
                                              controller.play();
                                              _animationController.forward();
                                            }
                                          }),
                                    ),
                                  ),

                                  //seek forward 10
                                  if (roomLogicController
                                          .adminKaNaam.obs.value ==
                                      roomLogicController.userName.obs.value)
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
                                              seconds: controller.value.position
                                                      .inSeconds +
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
                                      if (Get.context.isPortrait) {
                                        SystemChrome.setPreferredOrientations(
                                            [DeviceOrientation.landscapeRight]);
                                      } else if (Get.context.isLandscape) {
                                        SystemChrome.setPreferredOrientations(
                                            [DeviceOrientation.portraitUp]);
                                      }
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
                ),
                // if (subsController != null)
                Positioned(
                  bottom: 100,
                  child: Container(
                    height: 100,
                    width: size.width,
                    child: ClosedCaption(
                        text: controller.value.caption.text,
                        textStyle: TextStyle(
                            fontSize: 14,
                            backgroundColor: Colors.white,
                            color: Colors.pink)),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      // controller.dispose();
                      initializeSubs();
                    },
                    child: Text('Test'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String text;
  CustomText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(color: Colors.white));
  }
}
