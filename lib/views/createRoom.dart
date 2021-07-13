import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/chat.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/views/waitingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateRoomScreen extends StatefulWidget {
  @override
  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  RoomLogicController roomLogicController = Get.put(RoomLogicController());
  // TextEditingController nameController = TextEditingController();
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
  final _formKey = GlobalKey<FormState>();
  Future<SharedPreferences> displayPreference;
  SharedPreferences setPreference;
  String nameController;

  commonRoom(String room) {
    if (room == '') {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    sharedPrefsInit();
    // setTheUserName();
  }

  void sharedPrefsInit() async {
    displayPreference = SharedPreferences.getInstance();
    setPreference = await displayPreference;
  }

  //set the name persisteent
  // void listenToNameChanges() {
  //   nameController.addListener(() {
  //     //set it persistent
  //   });
  // }

  // void setTheUserName() {
  //   nameController = setPreference.getString('userName') == null
  //       ? null
  //       : setPreference.getString('userName');
  // }

  void _createCustomBottomSheet(
      {double heightRatio, double widthRatio, Size size}) async {
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.only(
    //     topLeft: Radius.circular(23.0),
    //     topRight: Radius.circular(23.0),
    //   ),
    // ),

    _controller = await Get.bottomSheet(GestureDetector(
      onTap: () {},
      child: Container(
        width: size.width,
        color: Colors.white,
        height: 330 * heightRatio,
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                //height: 30,
                child: Text(
                  'Enter Room Id',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                //color: Colors.grey.withOpacity(0.6),
                margin: EdgeInsets.only(top: 16 * heightRatio),
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
                  maxLength: 5,
                  textAlign: TextAlign.center,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    // enabledBorder: OutlineInputBorder(
                    //   borderSide: const BorderSide(
                    //       color: Colors.white, width: 2.0),
                    //   borderRadius: BorderRadius.circular(25.0),
                    // ),
                    filled: true,
                    counterStyle: TextStyle(fontSize: 7),
                    focusedBorder: OutlineInputBorder(
                      borderSide: new BorderSide(
                        color: Color.fromRGBO(41, 39, 39, 1),
                        width: 1,
                      ),
                      borderRadius: new BorderRadius.circular(25),
                    ),
                    //focusedBorder: Color.fromRGBO(41, 39, 39, 1),
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
                child:
                    //roomId.text.isNotEmpty
                    //?
                    !isLoading
                        ? RaisedButton(
                            // color: roomId.text.isEmpty
                            //     ? Colors.grey
                            //     : Colors.green,
                            // color: commonRoom(roomId.text)
                            //     ? Colors.grey
                            //     : Colors.green,
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            onPressed: () async {
                              if (roomId.text.isEmpty) {
                                return Get.showSnackbar(GetBar(
                                  //title: 'Room ID Error',
                                  message: 'Enter room name',
                                  duration: Duration(seconds: 2),
                                  borderRadius: 20,
                                ));
                              }
                              // _controller.setState(() {
                              //   isLoading = true;
                              // });
                              setState(() {
                                isLoading = true;
                              });
                              bool value = await roomLogicController.joinRoom(
                                  roomId: roomId.text, name: nameController);
                              await Future.delayed(Duration(seconds: 1));
                              if (value) {
                                Get.to(WaitingPage());
                              } else {
                                // Get.snackbar('Wrong Room Id',
                                //     'The room id you entered is wrong');
                                return Get.showSnackbar(
                                  GetBar(
                                    title: 'Room ID Error',
                                    message: 'The Room does not exits',
                                    duration: Duration(seconds: 2),
                                    borderRadius: 20,
                                  ),
                                );
                              }
                              // _controller.setState(() {
                              //   isLoading = false;
                              // });
                              _controller.setState(() {
                                isLoading = false;
                              });
                            },
                            child: Text(
                              'Join',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          )
                        : Center(
                            child: SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Color.fromRGBO(41, 39, 39, 1)),
                                ))),
                // : RaisedButton(
                //     color: Colors.grey,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(25)),
                //     onPressed: () async {
                //       Get.showSnackbar(GetBar(
                //         //title: 'Room ID Error',

                //         message: 'Enter a room Id',
                //         duration: Duration(seconds: 2),
                //         borderRadius: 20,
                //       ));
                //     }
                //     // _controller.setState(() {
                //     //   isLoading = false;
                //     // });
                //     ,
                //     child: Text(
                //       'Join',
                //       style: TextStyle(
                //           fontSize: 20, color: Colors.white),
                //     ),
              ),
            ],
          ),
        ),
      ),
      behavior: HitTestBehavior.opaque,
    ));
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
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: (MediaQuery.of(context).size.height -
                //AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top),
            //height: Get.height,
            // decoration:
            //     BoxDecoration(border: Border.all(color: Colors.green)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  // Container(
                  //   padding: EdgeInsets.only(
                  //     left: 25,
                  //   ),
                  //   alignment: Alignment.centerLeft,
                  //   child: isDrawerOpen
                  //       ? IconButton(
                  //           icon: Icon(
                  //             Icons.arrow_back_ios,
                  //             color: themeController.drawerHead.value,
                  //           ),
                  //           onPressed: () {
                  //             setState(() {
                  //               xOffset = 0;
                  //               yOffset = 0;
                  //               zOffset = 0;
                  //               scaleFactor = 1;
                  //               isDrawerOpen = false;
                  //             });
                  //           },
                  //         )
                  //       : IconButton(
                  //           icon: Icon(
                  //             Icons.menu,
                  //             color: themeController.drawerHead.value,
                  //           ),
                  //           onPressed: () {
                  //             setState(() {
                  //               xOffset = 250;
                  //               yOffset = 155;
                  //               zOffset = 20;
                  //               scaleFactor = 0.6;
                  //               isDrawerOpen = true;
                  //             });
                  //           },
                  //         ),
                  // ),
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
                    child: FutureBuilder<SharedPreferences>(
                      future: displayPreference,
                      builder: (BuildContext context,
                          AsyncSnapshot<SharedPreferences> snapshot) {
                        if (snapshot.hasData) {
                          //get from local storage
                          nameController = snapshot.data.getString('userName');
                          //set the username from local storage
                          roomLogicController.userName.value = nameController;
                          print(
                              "RoomLogicPeCheck ${roomLogicController.userName.value}");

                          return TextFormField(
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "Name can't be empty";
                              }
                              return null;
                            },
                            onChanged: (String value) {
                              roomLogicController.userName.value =
                                  value; //set the name
                              setPreference.setString('userName', value);
                            },
                            maxLength: 8,
                            textAlign: TextAlign.center,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-zA-Z]")),
                            ],
                            style: TextStyle(
                              fontSize: 18,
                              color: themeController.primaryTextColor.value,
                              fontWeight: FontWeight.bold,
                            ),
                            // controller: nameController,
                            initialValue:
                                setPreference.getString('userName') == null
                                    ? ''
                                    : setPreference.getString('userName'),
                            decoration: InputDecoration(
                              //filled: true,
                              //fillColor: Colors.blueGrey,
                              focusColor: Colors.yellow,
                              // fillColor: Colors.red,
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(
                                  color: themeController.drawerHead.value,
                                  width: 1,
                                ),
                                borderRadius: new BorderRadius.circular(25),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: new BorderSide(
                                    color: Colors.black, width: 6),
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
                              hintText:
                                  snapshot.data.getString('userName') != null
                                      ? null
                                      : 'Enter your name ',
                              hintStyle: TextStyle(
                                //color:
                                //themeController.switchContainerColor.value
                                color: themeController.blackText.value,
                              ),
                            ),
                          );
                        }
                        nameController = 'King';
                        return Container();
                      },
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

                        primary: themeController.butColor.value,
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

                        //checks if the name is empty don't proceed further
                        print("validate: ${_formKey.currentState.validate()}");
                        if (!_formKey.currentState.validate()) return;

                        //creates the bottom sheet where the user inputs the room id
                        _createCustomBottomSheet(
                            heightRatio: heightRatio,
                            widthRatio: widthRatio,
                            size: size);
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
                        () => !roomLogicController.isLoading.value
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  primary: themeController.butColor.value,
                                  elevation: 8,
                                  onPrimary: Colors.white,
                                ),
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(25),
                                // ),
                                // color: Colors.white,
                                onPressed: () async {
                                  //check if name is null
                                  if (!_formKey.currentState.validate()) return;
                                  print(
                                      'MakeRoomButton ${roomLogicController.userName.value}');
                                  roomLogicController.isLoading.value = true;
                                  await roomLogicController.makeRoom(
                                      adminName:
                                          roomLogicController.userName.value);
                                  Get.to(WaitingPage());
                                  roomLogicController.isLoading.value = false;
                                },
                                child: Text(
                                  'Create Room',
                                  style: TextStyle(
                                      fontSize: 30,
                                      //fontSize: 35 * widthRatio,
                                      fontWeight: FontWeight.normal),
                                )
                                // : CircularProgressIndicator(
                                //     //value: controller.value,
                                //     valueColor:
                                //         new AlwaysStoppedAnimation<Color>(
                                //             Colors.white),
                                //     // semanticsLabel:
                                //     //     'Linear progress indicator',
                                //   ),
                                )
                            : Center(
                                child: CircularProgressIndicator(
                                  //value: controller.value,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  // semanticsLabel:
                                  //     'Linear progress indicator',
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        //This is the code for the landscape view , right now it's not needed
        // MediaQuery.of(context).orientation == Orientation.landscape

        // //landscape
        // ? Container(
        //     width: size.width,
        //     height: (MediaQuery.of(context).size.height -
        //         AppBar().preferredSize.height -
        //         MediaQuery.of(context).padding.top),
        //     decoration:
        //         BoxDecoration(border: Border.all(color: Colors.green)),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: <Widget>[
        //         SingleChildScrollView(
        //           child: Container(
        //             width: Get.width * 0.4,
        //             //color: Colors.yellow.withOpacity(0.5),
        //             child: Center(
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.center,
        //                 mainAxisAlignment: MainAxisAlignment.start,
        //                 children: [
        //                   SizedBox(
        //                       height: (MediaQuery.of(context).size.height -
        //                               AppBar().preferredSize.height -
        //                               MediaQuery.of(context).padding.top) *
        //                           0.26),
        //                   Container(
        //                     decoration: BoxDecoration(
        //                         border: Border.all(color: Colors.red)),
        //                     child: SvgPicture.asset(
        //                       'lib/assets/svgs/movie.svg',
        //                       width: 294 * widthRatio,
        //                       height: 294 * heightRatio,
        //                     ),
        //                     // child :
        //                     // Container()
        //                   ),
        //                   // Container(
        //                   //   width: Get.width * .8,
        //                   //   child: TextField(
        //                   //     style: TextStyle(
        //                   //         color: Colors.white, fontWeight: FontWeight.normal),
        //                   //     controller: roomId,
        //                   //     decoration: InputDecoration(
        //                   //       border: OutlineInputBorder(
        //                   //           borderRadius: BorderRadius.circular(25)),
        //                   //       hintText: "Enter Room ID",
        //                   //       hintStyle: TextStyle(color: Colors.grey),
        //                   //     ),
        //                   //   ),
        //                   // ),
        //                   SizedBox(
        //                       height:
        //                           MediaQuery.of(context).size.height * 0.2),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ),
        //         SingleChildScrollView(
        //           child: Center(
        //             child: Container(
        //               width: Get.width * 0.35,
        //               child: Form(
        //                 key: _formKey,
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.center,
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: <Widget>[
        //                     Container(
        //                       width: Get.width * 0.5,
        //                       child: TextFormField(
        //                         validator: (String value) {
        //                           if (value.isEmpty) {
        //                             return "Name can't be empty";
        //                           }
        //                           return null;
        //                         },
        //                         maxLength: 8,
        //                         textAlign: TextAlign.center,
        //                         style: TextStyle(
        //                           fontSize: 16,
        //                           color: Colors.white,
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                         controller: nameController,
        //                         decoration: InputDecoration(
        //                           //filled: true,
        //                           //fillColor: Colors.blueGrey,
        //                           focusColor: Colors.yellow,
        //                           // fillColor: Colors.red,
        //                           focusedBorder: OutlineInputBorder(
        //                             borderSide: new BorderSide(
        //                               color: Colors.red,
        //                               width: 1,
        //                             ),
        //                             borderRadius:
        //                                 new BorderRadius.circular(25),
        //                           ),
        //                           enabledBorder: UnderlineInputBorder(
        //                             borderSide: new BorderSide(
        //                                 color: Colors.black, width: 6),
        //                             borderRadius:
        //                                 new BorderRadius.circular(25),
        //                           ),

        //                           //  border: OutlineInputBorder(
        //                           //
        //                           //    borderSide: BorderSide(
        //                           //      color: Colors.blueGrey,
        //                           //      style: BorderStyle.solid,
        //                           //      width: 6.0,
        //                           //    ),
        //                           //    borderRadius: BorderRadius.circular(25),
        //                           //  ),
        //                           hintText: "Enter your name",
        //                           hintStyle: TextStyle(
        //                               color:
        //                                   themeController.blackText.value),
        //                         ),
        //                       ),
        //                     ),
        //                     SizedBox(height: Get.height * 0.1),
        //                     Container(
        //                       width: Get.width * 0.4,
        //                       height: 35,
        //                       child: ElevatedButton(
        //                         // elevation: 8,
        //                         // color: Colors.white,
        //                         // splashColor: Color.fromRGBO(196, 196, 196, 1),
        //                         // shape: RoundedRectangleBorder(
        //                         // borderRadius: BorderRadius.circular(25)),
        //                         style: ElevatedButton.styleFrom(
        //                           shape: RoundedRectangleBorder(
        //                             borderRadius: BorderRadius.circular(20),
        //                           ),
        //                           onSurface: Colors.white,
        //                           primary: Colors.red,
        //                           shadowColor: Colors.green,
        //                           elevation: 8,
        //                           onPrimary: Colors.white,
        //                         ),
        //                         child: Text(
        //                           'Join Room',
        //                           style: TextStyle(
        //                               fontSize: 25,
        //                               //fontSize: 40 * widthRatio,
        //                               fontWeight: FontWeight.normal),
        //                         ),
        //                         onPressed: () async {
        //                           //don't process further if the name is empty
        //                           if (!_formKey.currentState.validate())
        //                             return;
        //                           Scaffold.of(context).showBottomSheet(
        //                             // context: context,
        //                             // shape: RoundedRectangleBorder(
        //                             //   borderRadius: BorderRadius.only(
        //                             //     topLeft: Radius.circular(23.0),
        //                             //     topRight: Radius.circular(23.0),
        //                             //   ),
        //                             // ),
        //                             (ctx) {
        //                               return Container(
        //                                 width: Get.width,
        //                                 //decoration: BoxDecoration(
        //                                 //color: Colors.red.withOpacity(0.4),
        //                                 //borderRadius: BorderRadius.circular(20)),
        //                                 // decoration: new BoxDecoration(
        //                                 //   color: Colors.white,
        //                                 //   borderRadius: new BorderRadius.only(
        //                                 //     topLeft: const Radius.circular(20.0),
        //                                 //     topRight: const Radius.circular(20.0),
        //                                 //   ),
        //                                 // ),
        //                                 //color: Colors.black.withOpacity(0.5),
        //                                 height: 270 * heightRatio,
        //                                 child: Center(
        //                                   child: Row(
        //                                     mainAxisAlignment:
        //                                         MainAxisAlignment.center,
        //                                     children: [
        //                                       Container(
        //                                         //color: Colors.grey.withOpacity(0.6),
        //                                         // margin: EdgeInsets.only(
        //                                         //     top: 40 * heightRatio),
        //                                         // width: 270 * widthRatio,
        //                                         // height: 70 * heightRatio,
        //                                         // padding:
        //                                         //     EdgeInsets.only(left: 30),
        //                                         width: 300,
        //                                         child: TextField(
        //                                           style: TextStyle(
        //                                               color: Colors.black,
        //                                               fontWeight: FontWeight
        //                                                   .normal),
        //                                           controller: roomId,
        //                                           onChanged: (value) {
        //                                             roomLogicController
        //                                                 .roomText(value);
        //                                           },
        //                                           keyboardType:
        //                                               TextInputType.number,
        //                                           textAlign:
        //                                               TextAlign.center,
        //                                           decoration:
        //                                               InputDecoration(
        //                                             // enabledBorder: OutlineInputBorder(
        //                                             //   borderSide: const BorderSide(
        //                                             //       color: Colors.white, width: 2.0),
        //                                             //   borderRadius: BorderRadius.circular(25.0),
        //                                             // ),
        //                                             filled: true,
        //                                             fillColor: Colors.grey
        //                                                 .withOpacity(0.4),
        //                                             border: OutlineInputBorder(
        //                                                 borderRadius:
        //                                                     BorderRadius
        //                                                         .circular(
        //                                                             25)),
        //                                             hintText: "Room ID",
        //                                             hintStyle: TextStyle(
        //                                                 color: Color(
        //                                                     0xff7B7171)),
        //                                           ),
        //                                         ),
        //                                       ),
        //                                       SizedBox(
        //                                         height: 30 * heightRatio,
        //                                         width: 30,
        //                                       ),
        //                                       GetBuilder<
        //                                           RoomLogicController>(
        //                                         builder: (controller) {
        //                                           return Container(
        //                                             //height: 50 * heightRatio,
        //                                             //width: 150 * widthRatio,
        //                                             width: 100,
        //                                             child: RaisedButton(
        //                                               color: controller
        //                                                       .joinLoading
        //                                                       .value
        //                                                   ? Colors.blue
        //                                                   : Colors.green,
        //                                               shape: RoundedRectangleBorder(
        //                                                   borderRadius:
        //                                                       BorderRadius
        //                                                           .circular(
        //                                                               25)),
        //                                               onPressed: () {
        //                                                 roomLogicController
        //                                                     .joinRoom(
        //                                                         roomId: roomId
        //                                                             .text,
        //                                                         name: nameController
        //                                                             .text);

        //                                                 if (true) {
        //                                                   Get.to(
        //                                                       WaitingPage());
        //                                                 } else {
        //                                                   Get.snackbar(
        //                                                       'Wrong Room Id',
        //                                                       'The room id you entered is wrong');
        //                                                 }
        //                                               },
        //                                               child: Text(
        //                                                 'Join',
        //                                                 style: TextStyle(
        //                                                     fontSize: 20),
        //                                               ),
        //                                             ),
        //                                           );
        //                                         },
        //                                       )
        //                                     ],
        //                                   ),
        //                                 ),
        //                               );
        //                             },
        //                           );

        //                           // bool canJoin =
        //                           //     await roomLogicController.joinRoom(
        //                           //   roomId: roomId.text,
        //                           //   name: nameController.text,
        //                           // );
        //                           // if (canJoin) {
        //                           //   Get.to(WelcomScreen());
        //                           // } else if (!canJoin) {
        //                           //   // print("No Such Room exsist");
        //                           //   return Get.snackbar(
        //                           //     'Room not found',
        //                           //     'The Room ID you entered was not found :(',
        //                           //   );
        //                           // }
        //                         },
        //                       ),
        //                     ),
        //                     SizedBox(height: 30 * heightRatio),
        //                     Container(
        //                       width: 300 * widthRatio,
        //                       height: 80 * heightRatio,
        //                       child: Hero(
        //                         tag: 'Rishabh',
        //                         child: Obx(
        //                           () => ElevatedButton(
        //                             // shape: RoundedRectangleBorder(
        //                             //   borderRadius: BorderRadius.circular(25),
        //                             // ),
        //                             // color: Colors.white,
        //                             onPressed: () async {
        //                               //check if name is null
        //                               if (!_formKey.currentState.validate())
        //                                 return;
        //                               roomLogicController.isLoading.value =
        //                                   true;
        //                               await roomLogicController.makeRoom(
        //                                   adminName: nameController.text);
        //                               Get.to(WaitingPage());
        //                               roomLogicController.isLoading.value =
        //                                   false;
        //                             },
        //                             child:
        //                                 !roomLogicController.isLoading.value
        //                                     ? Text(
        //                                         'Create Room',
        //                                         style: TextStyle(
        //                                             fontSize: 30,
        //                                             //fontSize: 35 * widthRatio,
        //                                             fontWeight:
        //                                                 FontWeight.normal),
        //                                       )
        //                                     : CircularProgressIndicator(),
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //         Container(
        //           width: 30,
        //         )
        //       ],
        //     ),
        //   )
      ),
    );
  }
}
