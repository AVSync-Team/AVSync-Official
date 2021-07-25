import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/chat.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/controllers/themeData.dart';
import 'package:VideoSync/views/waitingPage.dart';
import 'package:VideoSync/widgets/custom_button.dart';
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
  TextEditingController roomId = TextEditingController();
  RishabhController rishabhController = Get.put(RishabhController());
  CustomThemeData themeController = Get.put(CustomThemeData());

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

  void _createCustomBottomSheet(
      {double heightRatio, double widthRatio, Size size}) async {
    Get.defaultDialog(
      title: '',
      content: Container(
        // height: heightRatio * 200,
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
                  filled: true,
                  counterStyle: TextStyle(fontSize: 10),
                  focusedBorder: OutlineInputBorder(
                    borderSide: new BorderSide(
                      color: Color.fromRGBO(41, 39, 39, 1),
                      width: 1,
                    ),
                    borderRadius: new BorderRadius.circular(25),
                  ),
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
                child: Obx(() =>
                    roomLogicController.joinButtonLoadingState.value != true
                        ? RaisedButton(
                            color: !isLoading ? Colors.green : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            onPressed: () async {
                              if (roomId.text.isEmpty) {
                                return Get.showSnackbar(GetBar(
                                  //title: 'Room ID Error',
                                  message: 'Enter room name',
                                  duration: Duration(seconds: 2),
                                  borderRadius: 20,
                                ));
                              }
                              roomLogicController.joinButtonLoadingState.value =
                                  true; //set to login
                              bool value = await roomLogicController.joinRoom(
                                  roomId: roomId.text, name: nameController);
                              // await Future.delayed(Duration(seconds: 1));
                              roomLogicController.joinButtonLoadingState.value =
                                  false;
                              if (value) {
                                Get.to(WaitingPage());
                              } else {
                                return Get.showSnackbar(
                                  GetBar(
                                    //title: 'Room ID Error',
                                    message: 'The Room does not exists',
                                    duration: Duration(seconds: 2),
                                    borderRadius: 20,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Join',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ))
                        : Center(child: CircularProgressIndicator()))),
          ],
        ),
      ),
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
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: (MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.height * 0.1,
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
                            initialValue:
                                setPreference.getString('userName') == null
                                    ? ''
                                    : setPreference.getString('userName'),
                            decoration: InputDecoration(
                              focusColor: Colors.yellow,
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
                              hintText:
                                  snapshot.data.getString('userName') != null
                                      ? null
                                      : 'Enter your name ',
                              hintStyle: TextStyle(
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
                                ))
                            : Center(
                                child: CircularProgressIndicator(
                                  //value: controller.value,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.white),
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
      ),
    );
  }
}
