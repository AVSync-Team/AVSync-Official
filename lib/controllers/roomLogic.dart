import 'dart:async';
// import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

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
  String userName;
  var ytURL = ''.obs;
  var localUrl = ''.obs;
  String userId;
  String userKaId;
  Uint8List bytes;
  var adminKaNameFromDb = ''.obs;
  var roomIdText = "".obs.value;
  var joinLoading = false.obs;
  var playingStatus = false.obs;
  var dontHideControls = false.obs;
  var videoPosition = Duration(seconds: 0).obs;

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
    adminKaNaam = randomGenerator().toString();
    userName = adminKaNaam;
    this.userId = randomGenerator().toString();
    final response = await http.post(roomUrl,
        body: json.encode({
          "admin": adminKaNaam,
          "isPlayerPaused": true,
          "roomId": this.roomId,
          "timeStamp": 0,
          "adminName": adminName,
          "playBackSpeed": 1.0,
          "isDragging": false,
          "users": {
            "admin": {"name": adminName, "id": this.userId},
          },
          "chat": {
            "341241": {
              "message": "Welcome",
              "userId": "231312",
              "messageId": DateTime.now().toIso8601String(),
              "username": "Bot"
            }
          }
        }));

    // userName = randomGenerator().toString();

    roomFireBaseId = json.decode(response.body)["name"];
    print(roomFireBaseId);
  }

  String get getUserId {
    return userKaId;
  }

  Future<bool> joinRoom({String roomId, String name}) async {
    final firebaseDatabase = FirebaseDatabase.instance.reference();

    userName = name;
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
    rooms.forEach((key, value) async {
      if (value['roomId'].toString() == roomId) {
        flag = true;
        this.roomFireBaseId = key.toString();
        print('joinRoom: $roomFireBaseId');

        firebaseDatabase
            .child('Rooms')
            .child('$roomFireBaseId')
            .child('users')
            .push()
            .set({"id": this.userId, "name": name});

        // roomUrl =
        //     'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms/$roomFireBaseId/users.json';
        // final reponse2 = await http.get(roomUrl);
        // users = json.decode(reponse2.body);
        // users.add({"name": name, "id": this.userId});
        // await http.patch(
        //     'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms/$roomFireBaseId.json',
        flag = true;
      }
    });
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

  List<dynamic> getUsersList() {
    return users;
  }

  Future<List<dynamic>> loadDetails() async {
    final response = await http.get(
        'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms/$roomFireBaseId/users.json');
    print('loda: ${response.body}');
    final decoded = json.decode(response.body);
    print(decoded);
    return decoded;
  }

  Future<void> changeTimeStamp({int timestamp}) async {
    final response = await http.patch(
        'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms/$roomFireBaseId.json',
        body: json.encode({"timeStamp": timestamp}));
  }

  Future<int> getTimeStamp() async {
    final response = await http.get(
        'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms/$roomFireBaseId/timeStamp.json');
    return json.decode(response.body);
  }

  Future<bool> isDraggingStatus() async {
    final response = await http.get(
        'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms/$roomFireBaseId/isDragging.json');
    return json.decode(response.body);
  }

  Future<bool> isPlayerPaused() async {
    final response = await http.get(
        'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms/$roomFireBaseId/isPlayerPaused.json');

    print('player_status: ${response.body}');
    return json.decode(response.body);
  }

  Future<void> sendPlayerStatus({bool status}) async {
    final response = await http.patch(
        'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms/$roomFireBaseId.json',
        body: json.encode({"isPlayerPaused": status}));
    print('status sent: ${response.statusCode}');
  }

  Future<bool> sendIsDraggingStatus({bool status}) async {
    final response = await http.patch(
        'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms/$roomFireBaseId.json',
        body: json.encode({"isDragging": status}));
    return json.decode(response.body);
  }

  Future<void> sendPlay({double speed}) async {
    final response = await http.patch(
        'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms/$roomFireBaseId.json',
        body: json.encode({"playBackSpeed": speed}));
  }

  void sendPlayBackSpeed({double speed}) {
    final firebase = FirebaseDatabase.instance.reference();
    firebase
        .child('Rooms')
        .child(roomFireBaseId)
        .child('playBackSpeed')
        .set(speed);
  }

  // Stream<List<dynamic>> getusersInRoom() async* {
  //   print("heellool");
  //   Future.delayed(Duration(seconds: 1));
  //    Timer.periodic(Duration(seconds: 1), (_) => loadDetails());

  //   print('fid: $roomFireBaseId');
  // }

  void adminDeleteRoom({String firebaseId}) {
    final firebaseDB = FirebaseDatabase.instance.reference();
    firebaseDB.child('Rooms').child('$firebaseId').remove();
  }
}
