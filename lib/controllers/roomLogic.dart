import 'dart:async';
// import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:VideoSync/controllers/chat.dart';
import 'package:VideoSync/views/videoPlayer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class RoomLogicController extends GetxController {
  String roomUrl =
      'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms.json';

  Map<dynamic, dynamic> rooms;
  List<dynamic> roomNumbers = [];
  var randomNumber = 0.obs;
  List<dynamic> users = [];
  String adminKaNaam;

  var joinButtonLoadingState = false.obs;
  var ytURL = ''.obs;
  var localUrl = ''.obs;
  String userId;
  String userKaId;
  String userFireBase;
  var adminId = ''.obs;
  Uint8List bytes;
  var adminKaNameFromDb = ''.obs;
  var roomIdText = "".obs.value;
  var joinLoading = false.obs;
  var playingStatus = false.obs;
  var dontHideControls = false.obs;
  var videoPosition = Duration(seconds: 0).obs;
  var isLoading = false.obs;
  var userName = ''.obs;

  void roomText(text) {
    roomIdText = text;
  }

  void joinstatus(status) {
    joinLoading = status;
  }

  String roomFireBaseId;
  var roomId = '0'.obs;

  int randomGenerator() {
    Random random = new Random();
    randomNumber.value = random.nextInt(100000);
    return randomNumber.value;
  }

  Future<void> makeRoom({String adminName}) async {
    this.roomId.value = randomGenerator().toString();

    print("RoomLogicController: ${userName.value}");
    this.userId = randomGenerator().toString();
    final response = await http.post(roomUrl,
        body: json.encode({
          "status": 1,
          "admin": userName,
          "isPlayerPaused": true,
          "roomId": this.roomId,
          "timeStamp": 0,
          "adminName": adminName,
          "adminId": this.userId,
          'ytLink': "",
          "ytstatus": "not_loaded",
          "playBackSpeed": 1.0,
          "isDragging": false,
          "users": {
            "admin": {"name": adminName, "id": this.userId},
          },
        }));
    adminId.value = userId;

    roomFireBaseId = json.decode(response.body)["name"];
    print(roomFireBaseId);
  }

  String get getUserId {
    return userKaId;
  }

  Future<bool> joinRoom({String roomId, String name}) async {
    isLoading.value = true;
    final firebaseDatabase = FirebaseDatabase.instance.reference();
    adminKaNaam = "1234434";
    this.roomId.value = roomId;
    String roomIds =
        'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms.json';
    final response = await http.get(roomIds);
    bool flag = false;
    String roomUrl;

    this.userId = randomGenerator().toString();
    userKaId = this.userId;

    rooms = json.decode(response.body);
    rooms.forEach(
      (key, value) async {
        if (value['roomId'].toString() == roomId) {
          flag = true;
          this.roomFireBaseId = key.toString();
          print('joinRoom: $roomFireBaseId');

          //add user in the room
          String key1 = firebaseDatabase
              .child('Rooms')
              .child('$roomFireBaseId')
              .child('users')
              .push()
              .key;

          firebaseDatabase
              .child('Rooms')
              .child('$roomFireBaseId')
              .child('users')
              .child(key1)
              .set({"id": this.userId, "name": name, "status": 1});

          userFireBase = key1;
          firebaseDatabase
              .child('Rooms')
              .child('$roomFireBaseId')
              .child('adminId')
              .once()
              .then((value) {
            adminId.value = value.value;
          });
          flag = true;
          //send alert dialog message to Chat for new user joined
          chatController.sendMessageCloudFireStore(
            message: "$userName has joined the room !!",
            roomId: roomFireBaseId,
            sentBy: "User Joined",
            tag: "alert",
            userId: "696969",
            status: "joined",
          );
        }
      },
    );
    isLoading.value = false;
    //flag tells if the room exists or not
    return flag;
  }

  Stream<Event> adminBsdkKaNaam({String firebaseId}) {
    final firebase = FirebaseDatabase.instance.reference();
    return firebase
        .child('Rooms')
        .child('$firebaseId')
        .child('adminName')
        .onValue;
  }

  Stream<Event> adminIdd({String firebaseId}) {
    final firebase = FirebaseDatabase.instance.reference();
    return firebase
        .child('Rooms')
        .child('$firebaseId')
        .child('adminId')
        .onValue;
  }

  Stream<Event> ytVideoLoadedStatus({String firebaseId}) {
    final firebase = FirebaseDatabase.instance.reference();
    return firebase
        .child('Rooms')
        .child('$firebaseId')
        .child('ytstatus')
        .onValue;
  }

  Stream<Event> ytlink({String firebaseId}) {
    final firebase = FirebaseDatabase.instance.reference();

    return firebase.child('Rooms').child('$firebaseId').child('ytLink').onValue;
  }

  List<dynamic> getUsersList() {
    return users;
  }

  Future<bool> userLeaveRoom(
      {String firebaseId, String userId, String adminId}) async {
    final firebaseDatabase = FirebaseDatabase.instance.reference();
    final userRef =
        firebaseDatabase.child('Rooms').child('$firebaseId').child('users');

    int flag = 0;
    await userRef.once().then((value) {
      print("Firebase ${adminId}");

      value.value.forEach((key, value) {
        if (userId == value['id']) {
          userRef.child(key).remove();
          chatController.sendMessageCloudFireStore(
            message: "$userName has left the room :(",
            roomId: roomFireBaseId,
            sentBy: "User Left",
            tag: "alert",
            userId: "696969",
            status: "left",
          );
        } else if (flag == 0) {
          print(value['name']);

          if (adminId == roomLogicController.userId.obs.value) {
            flag = 1;
            print("firebase id" + firebaseId);
            firebaseDatabase
                .child('Rooms')
                .child('$firebaseId')
                .child('adminId')
                .set(value['id']);
            firebaseDatabase
                .child('Rooms')
                .child('$firebaseId')
                .child('adminName')
                .set(value['name']);
          }
        }
      });
    });

    return true;
  }

  void sendPlayBackSpeed({double speed}) {
    var firebase = FirebaseDatabase.instance.reference();
    firebase
        .child('Rooms')
        .child(roomFireBaseId)
        .child('playBackSpeed')
        .set(speed);
  }

  void sendYtLink({String ytlink}) {
    var firebase = FirebaseDatabase.instance.reference();
    firebase.child('Rooms').child(roomFireBaseId).child('ytLink').set(ytlink);
  }

  void sendYtStatus({String status}) {
    var firebase = FirebaseDatabase.instance.reference();
    firebase.child('Rooms').child(roomFireBaseId).child('ytstatus').set(status);
  }

  Future<void> kickUser({String firebaseId, String idofUser}) async {
    final firebaseDB = FirebaseDatabase.instance.reference();
    Event bhosda = await firebaseDB
        .child('Rooms')
        .child(firebaseId)
        .child('users')
        .onValue
        .first;
    Map userMap = bhosda.snapshot.value;

    userMap.forEach((key, value) async {
      if (value['id'] == idofUser && key != 'admin') {
        //set the status zero - then the user will be kicked
        firebaseDB
            .child('Rooms')
            .child(firebaseId)
            .child('users')
            .child(key)
            .child('status')
            .set(0);

        chatController.sendMessageCloudFireStore(
          message: "${value['name']} has been kicked from the room ",
          roomId: roomFireBaseId,
          sentBy: "User Kicked",
          tag: "alert",
          userId: "696969",
          status: "joined",
        );

        firebaseDB
            .child('Rooms')
            .child(firebaseId)
            .child('users')
            .child(key)
            .remove();
      }
    });
  }

  Stream<Event> userStatus({String firebaseId}) {
    print(" firebaseid: $firebaseId");
    print('userFireBase :  $userFireBase');

    final firebaseDB = FirebaseDatabase.instance.reference();
    return firebaseDB
        .child('Rooms')
        .child(firebaseId)
        .child('users')
        .child(userFireBase)
        .child('status')
        .onValue;
  }

  Future<void> adminDeleteRoom({String firebaseId}) async {
    final firebaseDB = FirebaseDatabase.instance.reference();

    firebaseDB.child('Rooms').child('$firebaseId').child('status').set(0);
    await Future.delayed(Duration(seconds: 20));
    firebaseDB.child('Rooms').child('$firebaseId').remove();
  }

  Stream<Event> roomStatus({String firebaseId}) {
    final firebaseDB = FirebaseDatabase.instance.reference();
    return firebaseDB
        .child('Rooms')
        .child('$firebaseId')
        .child('status')
        .onValue;
  }
}
