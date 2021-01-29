import 'dart:async';
import 'dart:convert';

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

  String roomFireBaseId;
  var roomId = '0'.obs;

  int randomGenerator() {
    Random random = new Random();
    randomNumber.value = random.nextInt(100000);
    return randomNumber.value;
  }

  Future<void> makeRoom({String adminName}) async {
    this.roomId.value = randomGenerator().toString();
    final response = await http.post(roomUrl,
        body: json.encode({
          "admin": adminName,
          "isPlayerPaused": false,
          "roomId": this.roomId,
          "timeStamp": 0,
          "users": [
            {"name": adminName},
          ]
        }));

    roomFireBaseId = json.decode(response.body)["name"];
    print(roomFireBaseId);
  }

  Future<bool> joinRoom({String roomId, String name}) async {
    this.roomId.value = roomId;
    String roomIds =
        'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms.json';
    final response = await http.get(roomIds);
    bool flag = false;
    String roomUrl;
    rooms = json.decode(response.body);
    rooms.forEach((key, value) async {
      if (value['roomId'].toString() == roomId) {
        flag = true;
        roomFireBaseId = key.toString();
        roomUrl =
            'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms/$roomFireBaseId/users.json';
        final reponse2 = await http.get(roomUrl);
        users = json.decode(reponse2.body);
        users.add({"name": name});
        await http.patch(
            'https://avsync-9ce10-default-rtdb.firebaseio.com/Rooms/$roomFireBaseId.json',
            body: json.encode({"users": users}));
        return true;
      }
    });
    return true;
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

  // Stream<List<dynamic>> getusersInRoom() async* {
  //   print("heellool");
  //   Future.delayed(Duration(seconds: 1));
  //    Timer.periodic(Duration(seconds: 1), (_) => loadDetails());

  //   print('fid: $roomFireBaseId');
  // }
}
