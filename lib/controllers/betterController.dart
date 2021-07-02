import 'package:VideoSync/views/videoPlayer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class RishabhController extends GetxController {
  var timeStamp = 0.obs;
  var isDragging = false.obs;
  var radioValue = 1.0.obs;

  void timestampFromDB({String roomFireBaseID}) {
    print('called');
    var firebaseDatabase = FirebaseDatabase.instance.reference();
    var data = firebaseDatabase
        .child('Rooms')
        .child('-MSIdyAkrq0f_r7ymlCD')
        .child('timeStamp')
        .onValue
        .listen((event) {
      // print('anthonio: ${event.snapshot.value}');
      this.timeStamp.value = event.snapshot.value;
      print('timeStamp: $timeStamp');
    });
  }

  void isDraggingStatus() {
    var firebaseDatabase = FirebaseDatabase.instance.reference();
    var data = firebaseDatabase
        .child('Rooms')
        .child('-MSIdyAkrq0f_r7ymlCD')
        .child('isDragging')
        .onValue
        .listen((event) {
      this.isDragging.value = event.snapshot.value;
      print('isDragging: $isDragging');
    });
  }

  void sendPlayerStatus({bool status, String firebaseId}) {
    var firebaseDatabase = FirebaseDatabase.instance.reference();
    firebaseDatabase
        .child('Rooms')
        .child('$firebaseId')
        .child('isPlayerPaused')
        .set(status);
  }

  void sendTimeStamp({int timeStamp, String firebaseId}) {
    var firebaseDatabase = FirebaseDatabase.instance.reference();
    firebaseDatabase
        .child('Rooms')
        .child('$firebaseId')
        .child('timeStamp')
        .set(timeStamp);
  }

  void sendIsDraggingStatus({bool draggingStatus, String firebaseId}) {
    var firebaseDatabase = FirebaseDatabase.instance.reference();
    firebaseDatabase
        .child('Rooms')
        .child('$firebaseId')
        .child('isDragging')
        .set(draggingStatus);
  }

  Stream<Event> getUsersList({String firebaseId}) {
    final firebasedatbase = FirebaseDatabase.instance.reference();
    return firebasedatbase
        .child('Rooms')
        .child('$firebaseId')
        .child('users')
        .onValue;
  }

  Future<bool> userLeaveRoom(
      {String firebaseId, String userId, String adminId}) async {
    final firebaseDatabase = FirebaseDatabase.instance.reference();
    final userRef =
        firebaseDatabase.child('Rooms').child('$firebaseId').child('users');

    // var usersList = [];
    // var index = 0;

    String id = "";
    String name = "";
    DataSnapshot v;
    int flag = 0;
    await userRef.once().then((value) {
      v = value;
      print("loda mera sala");
      print("Firebase ${adminId}");

      value.value.forEach((key, value) {
        if (userId == value['id']) {
          userRef.child(key).remove();
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

        // index++;
      });
    });

    // index++;

    return true;
  }

  Stream tester({String firebaseId}) {
    print('lodu: $firebaseId');
    final firebasedatbase = FirebaseDatabase.instance.reference();
    return firebasedatbase
        .child('Rooms')
        .child('$firebaseId')
        .child('users')
        .onValue;
  }

  Future firstDataFromUsers({String firebaseId}) {
    final firebasedatbase = FirebaseDatabase.instance.reference();
    return firebasedatbase
        .child('Rooms')
        .child('$firebaseId')
        .child('users')
        .onValue
        .first;
  }
}
