import 'package:VideoSync/controllers/funLogic.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
import 'package:VideoSync/widgets/show_alerts.dart';
import 'package:flutter/material.dart';

import 'custom_button.dart';

// ignore: must_be_immutable
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
              buttonColor: Colors.redAccent,
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
                width: 50,
                height: 50,
                child: Image.network(
                    'https://i.picsum.photos/id/56/200/200.jpg?hmac=rRTTTvbR4tHiWX7-kXoRxkV7ix62g9Re_xUvh4o47jA'),
              ),
            ),
            SizedBox(width: 20 * widget.heightRatio),
            Text(
              '${widget.event.data.snapshot.value.values.toList()[widget.index]['name']}',
              style: TextStyle(
                  fontSize: 25, color: widget.controller.randomColorPick),
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
