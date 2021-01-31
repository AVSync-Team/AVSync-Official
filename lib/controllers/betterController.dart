import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class RishabhController extends GetxController {
  var timeStamp = 0.obs;
  var isDragging = false.obs;

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

  void sendTimeStamp({int timeStamp,String firebaseId}) {
    var firebaseDatabase = FirebaseDatabase.instance.reference();
    firebaseDatabase
        .child('Rooms')
        .child('$firebaseId')
        .child('timeStamp')
        .set(timeStamp);

  }
}
