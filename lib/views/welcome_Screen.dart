import 'dart:async';

import 'package:VideoSync/controllers/betterController.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/views/YTPlayer.dart';
import 'package:VideoSync/views/chat.dart';
import 'package:VideoSync/views/videoPlayer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:VideoSync/views/createRoom.dart';

class WelcomScreen extends StatefulWidget {
  @override
  _WelcomScreenState createState() => _WelcomScreenState();
}

class _WelcomScreenState extends State<WelcomScreen> {
  bool ytPlayerclicked = false;
  bool localPlayerClicked = false;
  TextEditingController yturl = TextEditingController();
  RoomLogicController roomLogicController = Get.put(RoomLogicController());
  RishabhController rishabhController = Get.put(RishabhController());

  // StreamController<List<dynamic>> _userController;
  // Timer timer;

  // @override
  // void initState() {
  //   super.initState();
  //   //   _userController = new StreamController();

  //   //   timer = Timer.periodic(Duration(seconds: 3), (_) async {
  //   //     var data = await roomLogicController.loadDetails();
  //   //     _userController.add(data);
  //   //   });
  //   //
  // }

  // @override
  // void dispose() {
  //   _userController.close();
  //   // _userController.done;
  //   timer.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ChattingPlace(),
      ),
      backgroundColor: Color(0xff247D7D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Text('Users: '),
            SizedBox(height: 40),
            Text(
              'Room',
              style: TextStyle(color: Colors.white, fontSize: 50),
            ),
            SizedBox(
              height: 90,
            ),
            Container(
              height: 320,
              width: 250,
              // decoration:
              //     BoxDecoration(border: Border.all(color: Colors.black)),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 250,
                      width: 250,
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 70, left: 85),
                              child: SvgPicture.asset(
                                  'lib/assets/svgs/neomo.svg',
                                  width: 70,
                                  height: 70,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                children: [
                                  Text(
                                    'Rishabh',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 0),
                                    child: SvgPicture.asset(
                                        'lib/assets/svgs/crown.svg',
                                        height: 25,
                                        width: 25),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: GetX<RoomLogicController>(
                                  builder: (controller) {
                                return Text(
                                    'Room no: ${controller.roomId.obs.value} ',
                                    style: TextStyle(fontSize: 20));
                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset('lib/assets/svgs/movie.svg',
                        width: 120, height: 120),
                  )
                ],
              ),
            ),
            // SizedBox(height: 80),
            Expanded(
              child: StreamBuilder(
                  stream: rishabhController.getUsersList(
                      firebaseId: roomLogicController.roomFireBaseId),
                  builder: (ctx, event) {
                    if (event.hasData) {
                      return Container(
                        // height: 100,
                        width: 300,
                        child: NotificationListener<
                                OverscrollIndicatorNotification>(
                            onNotification: (overscroll) {
                              overscroll.disallowGlow();
                            },
                            child: ListView.separated(
                                separatorBuilder: (ctx, i) {
                                  return SizedBox(
                                    height: 20,
                                  );
                                },
                                itemBuilder: (ctx, i) {
                                  print('chut: ${event.data.snapshot.value}');

                                  return CustomNameBar(event: event, index: i);
                                },
                                itemCount: event.data.snapshot.value.length)),
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
            ),
            GetX<RoomLogicController>(
              builder: (controller) {
                return Text('Your room id is: ${controller.roomId.obs.value}');
              },
            ),
            // ChattingPlace(),
          ],
        ),
      ),
    );
  }
}

class CustomNameBar extends StatelessWidget {
  final AsyncSnapshot event;
  final int index;
  CustomNameBar({
    this.event,
    this.index,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        // width: 20,
        // height: 70,
        // color: Colors.white,
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(25), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Row(
            children: [
              Text(
                '${event.data.snapshot.value[index]['name']}',
                style: TextStyle(fontSize: 30),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: SvgPicture.asset(
                  'lib/assets/svgs/emoji.svg',
                  width: 30,
                  height: 30,
                  color: Color(0xffF15757),
                ),
              )
            ],
          ),
        ),
      ),
    );

    // ListTile(
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    //   tileColor: Colors.white,
    //   title: Text('${event.data.snapshot.value[index]['name']}'),
    // );
  }
}
