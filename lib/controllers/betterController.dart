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

  void userLeaveRoom({String firebaseId, String userId}) async {
    final firebaseDatabase = FirebaseDatabase.instance.reference();
    final userRef =
        firebaseDatabase.child('Rooms').child('$firebaseId').child('users');

    // var usersList = [];
    // var index = 0;

    userRef.once().then((value) {
      value.value.forEach((key, value) {
        // print(index);
        print(key);
        print(value['id']);
        if (userId == value['id']) {
          print(userId);
          userRef.child(key).remove();
        }
        // index++;
      });
    });
    // print('sext: $userId');
    // print('room: $firebaseId');
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
