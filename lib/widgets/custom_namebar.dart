// import 'package:VideoSync/controllers/funLogic.dart';
import 'package:VideoSync/controllers/roomLogic.dart';
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
  // final FunLogic controller;
  final RoomLogicController roomController;
  final double textSize;
  final double imageSize;

  CustomNameBar(
      {this.userName,
      this.event,
      this.index,
      this.heightRatio,
      this.widthRatio,
      // this.controller,
      Key key,
      this.userID,
      this.roomController,
      this.textSize,
      this.imageSize})
      : super(key: key);

  @override
  _CustomNameBarState createState() => _CustomNameBarState();
}

class _CustomNameBarState extends State<CustomNameBar> {
  //builds the alert dialog
  Future buildShowDialog(BuildContext context, {String userName}) {
    return showDialog(
      context: context,
      builder: (context) => Container(
        height: 60,
        child: new AlertDialog(
          // backgroundColor: CustomThemeData().darkGrey.value,
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
                //kick the user logic is here
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
    //builds the custom card container
    return Container(
      // width: 224 * widget.widthRatio,
      height: 90 * widget.heightRatio,
      child: Card(
        color: const Color.fromARGB(200, 60, 60, 60),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: widget.widthRatio * 12),
            ClipOval(
              child: Container(
                decoration: BoxDecoration(),
                width: widget.imageSize,
                height: widget.imageSize,
                child: Image.network(
                    'https://i.picsum.photos/id/56/200/200.jpg?hmac=rRTTTvbR4tHiWX7-kXoRxkV7ix62g9Re_xUvh4o47jA'),
              ),
            ),
            SizedBox(width: 10 * widget.heightRatio),
            Container(
              // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
              child: Text(
                '${widget.event.data.snapshot.value.values.toList()[widget.index]['name']}',
                style: TextStyle(
                  fontSize: widget.textSize,
                  color: Colors.blueAccent,
                  // color: Colors.greenAccent,
                ),
              ),
            ),
            Spacer(),
            //kick UI
            (widget.roomController.userId != widget.userID &&
                    widget.roomController.userId ==
                        widget.roomController.adminId.value)
                ? Container(
                    // height: 50,
                    width: 55,
                    decoration: BoxDecoration(
                        // color: Colors.redAccent,
                        ),
                    child: GestureDetector(
                      child: Card(
                        elevation: 7,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(0),
                            bottomRight: Radius.circular(25),
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(0),
                          ),
                        ),
                        color: Colors.redAccent,
                        child: Center(
                          child: Text(
                            'Kick',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      //kick logic
                      onTap: () {
                        buildShowDialog(context, userName: widget.userName);
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
