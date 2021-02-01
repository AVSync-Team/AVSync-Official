import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  void sendMessage({String firebaseId, String message, String userId}) {
    var firebaseDatabase = FirebaseDatabase.instance.reference();
    firebaseDatabase
        .child('Rooms')
        .child('$firebaseId')
        .child('chat')
        .child('1')
        .set({"message": message, "userId": userId});
  }

  Stream message({String firebaseId}) {
    final firebasedatbase = FirebaseDatabase.instance.reference();
    return firebasedatbase
        .child('Rooms')
        .child('$firebaseId')
        .child('chat')
        .onValue;
  }
}
